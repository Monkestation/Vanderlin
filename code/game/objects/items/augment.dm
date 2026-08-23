/obj/item/augment_kit
	name = "augmentation kit"
	desc = "A kit containing components for automaton augmentation. Examine to see details."
	icon = 'icons/roguetown/items/new_gears.dmi'
	icon_state = "steel_gear"
	w_class = WEIGHT_CLASS_SMALL
	grid_width = 32
	grid_height = 32
	item_weight = 372 GRAMS
	var/datum/augment/contained_augment
	color = COLOR_ASSEMBLY_PURPLE

/obj/item/augment_kit/Initialize(mapload)
	. = ..()
	if(contained_augment)
		contained_augment = new contained_augment()
		update_augment()

/obj/item/augment_kit/examine(mob/user)
	. = ..()
	if(contained_augment)
		. += span_info("This kit contains: [contained_augment.name]")
		. += span_info("Installation requires Engineering skill level [contained_augment.engineering_difficulty]")
		. += contained_augment.get_examine_info()
	else
		. += span_info("It's empty. Right click on someone to collect an augment from them.")

/obj/item/augment_kit/proc/update_augment()
	if(contained_augment)
		color = contained_augment.color
		name = "[contained_augment.name] kit"
		desc = "[contained_augment.desc]\n\nStability Cost: [contained_augment.stability_cost]\nRequired Skill: Engineering [contained_augment.engineering_difficulty]"
	else
		color = initial(color)
		name = initial(name)
		desc = initial(desc)
	update_appearance(UPDATE_ICON)

/obj/item/augment_kit/interact_with_atom(atom/interacting_with, mob/living/user, list/modifiers)
	if(!isliving(interacting_with))
		return NONE

	if(!contained_augment)
		to_chat(user, span_warning("[src] is empty!"))
		return ITEM_INTERACT_BLOCKING

	var/mob/living/augmented = interacting_with

	if(!SEND_SIGNAL(augmented, COMSIG_AUGMENT_GET_STABILITY))
		to_chat(user, span_warning("[augmented] cannot be augmented!"))
		return ITEM_INTERACT_BLOCKING

	if(!istype(augmented.buckled, /obj/machinery/artificer_table))
		to_chat(user, span_warning("[augmented] must be on an artificer's table!"))
		return ITEM_INTERACT_BLOCKING

	var/skill = GET_MOB_SKILL_VALUE_OLD(user, /datum/attribute/skill/craft/engineering)
	if(skill < contained_augment.engineering_difficulty)
		to_chat(user, span_warning("You lack the engineering skill to install this augment!"))
		return ITEM_INTERACT_BLOCKING

	to_chat(user, span_notice("You begin installing [contained_augment.name]..."))

	if(!do_after(user, contained_augment.installation_time, target = augmented))
		return

	var/result = SEND_SIGNAL(augmented, COMSIG_AUGMENT_INSTALL, contained_augment, user)
	if(result & COMPONENT_AUGMENT_SUCCESS)
		contained_augment = null
		update_augment()
		playsound(src, 'sound/effects/sparks1.ogg', 75, TRUE)

/obj/item/augment_kit/interact_with_atom_secondary(atom/interacting_with, mob/living/user, list/modifiers)
	if(!isliving(interacting_with))
		return NONE

	var/mob/living/augmented = interacting_with

	if(!SEND_SIGNAL(augmented, COMSIG_AUGMENT_GET_STABILITY))
		to_chat(user, span_warning("[augmented] cannot be augmented!"))
		return ITEM_INTERACT_BLOCKING

	if(!istype(augmented.buckled, /obj/machinery/artificer_table))
		to_chat(user, span_warning("[augmented] must be on an artificer's table!"))
		return ITEM_INTERACT_BLOCKING

	if(contained_augment)
		to_chat(user, span_warning("[src] has an augment in it!"))
		return ITEM_INTERACT_BLOCKING

	var/list/augments = list()
	SEND_SIGNAL(augmented, COMSIG_AUGMENT_GET_INSTALLED, augments)
	if(!length(augments))
		to_chat(user, span_warning("[augmented] has no augments."))
		return ITEM_INTERACT_BLOCKING

	var/list/names = list()
	var/i = 0
	for(var/datum/augment/A in augments)
		i++
		names["[i]. [A.name]"] = A

	var/chosen = tgui_input_list(user, "Collect which augment?", "Artificer", names, timeout = 20 SECONDS)
	var/datum/augment/to_remove = names[chosen]
	if(!chosen || QDELETED(to_remove) || QDELETED(augmented))
		return ITEM_INTERACT_BLOCKING

	var/skill = GET_MOB_SKILL_VALUE_OLD(user, /datum/attribute/skill/craft/engineering)
	if(skill < to_remove.engineering_difficulty)
		to_chat(user, span_warning("You lack the engineering skill to uninstall this augment!"))
		return ITEM_INTERACT_BLOCKING

	to_chat(user, span_notice("You begin uninstalling the [to_remove.name]..."))
	if(!do_after(user, to_remove.installation_time, target = augmented))
		return ITEM_INTERACT_BLOCKING

	var/result = SEND_SIGNAL(augmented, COMSIG_AUGMENT_REMOVE, to_remove, user)
	if(result & COMPONENT_AUGMENT_SUCCESS)
		contained_augment = to_remove
		update_augment()
		playsound(src, 'sound/effects/sparks1.ogg', 75, TRUE)

	return ITEM_INTERACT_SUCCESS
