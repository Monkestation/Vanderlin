/obj/item/automaton_frame
	name = "automaton frame"
	desc = "An unfinished brass skeleton, waiting to be given purpose. The joints are hollow, the chest cavity empty."
	icon = 'icons/roguetown/mob/bodies/m/automaton.dmi'
	icon_state = "chest_s"
	w_class = WEIGHT_CLASS_HUGE

/datum/repeatable_crafting_recipe/engineering/automaton_frame
	name = "automaton frame"
	category = "Automatons"
	requirements = list(
		/obj/item/ingot/bronze = 8,
		/obj/item/ingot/iron   = 4,
	)
	tool_usage = list(
		/obj/item/weapon/hammer = list(
			span_notice("starts hammering a brass frame together"),
			span_notice("start hammering a brass frame together"),
			'sound/items/bsmith2.ogg'
		),
	)
	attacked_atom = /obj/item/ingot/bronze
	starting_atom = /obj/item/weapon/hammer
	output = /obj/item/automaton_frame
	craft_time = 20 SECONDS

/datum/repeatable_crafting_recipe/engineering/automaton_heart
	name = "automaton steam engine"
	category = "Automatons"
	requirements = list(
		/obj/item/ingot/copper = 3,
		/obj/item/ingot/iron   = 1,
		/obj/item/rotation_contraption/boiler = 1,
	)
	tool_usage = list(
		/obj/item/weapon/hammer = list(
			span_notice("starts assembling a miniature steam engine"),
			span_notice("start assembling a miniature steam engine"),
			'sound/items/bsmith2.ogg'
		),
	)
	attacked_atom = /obj/item/rotation_contraption/boiler
	starting_atom = /obj/item/weapon/hammer
	output = /obj/item/organ/heart/automaton
	craft_time = 12 SECONDS

/datum/repeatable_crafting_recipe/engineering/automaton_eyes
	name = "automaton optical sensors"
	category = "Automatons"
	requirements = list(
		/obj/item/ingot/bronze = 1,
		/obj/item/ingot/copper = 1,
	)
	tool_usage = list(
		/obj/item/weapon/knife = list(
			span_notice("starts grinding lenses for optical sensors"),
			span_notice("start grinding lenses for optical sensors"),
			'sound/items/wood_sharpen.ogg'
		),
	)
	attacked_atom = /obj/item/ingot/bronze
	starting_atom = /obj/item/weapon/knife
	output = /obj/item/organ/eyes/automaton
	craft_time = 10 SECONDS

/datum/orderless_slapcraft/automaton
	name = "Automaton Assembly"
	category = "Automatons"
	related_skill = /datum/skill/craft/engineering
	skill_xp_gained = 50
	action_time = 2 SECONDS
	process_sound = 'sound/items/bsmith2.ogg'

	starting_item = /obj/item/automaton_frame

	requirements = list(
		/obj/item/ingot/bronze = 5,
		/obj/item/ingot/copper = 3,
		/obj/item/ingot/iron = 2,
		/obj/item/organ/eyes/automaton  = 1,
		/obj/item/gear/metal/bronze = 4,
	)
	finishing_item = /obj/item/organ/heart/automaton
	output_item = null  // We spawn a mob instead, handled in try_finish

	var/list/installed_parts = list()
	var/total_requirements = 0

/datum/orderless_slapcraft/automaton/New(loc, _source)
	. = ..()
	for(var/type in requirements)
		total_requirements += requirements[type]

/datum/orderless_slapcraft/automaton/step_process(mob/user, obj/item/attacking_item)
	if(istype(attacking_item, /obj/item/ingot/bronze))
		user.visible_message(span_notice("[user] hammers brass plating onto the frame."), span_notice("You hammer the brass plating into place."))
	else if(istype(attacking_item, /obj/item/ingot/copper))
		user.visible_message(span_notice("[user] threads copper piping through the frame's chest."), span_notice("You thread copper piping through the chest cavity."))
	else if(istype(attacking_item, /obj/item/ingot/iron))
		user.visible_message(span_notice("[user] bolts iron joints into the frame."), span_notice("You bolt the iron joints firmly in place."))
	else if(istype(attacking_item, /obj/item/organ/heart/automaton))
		user.visible_message(span_notice("[user] carefully seats the steam engine into the frame's chest."), span_notice("You lower the steam engine into the chest cavity. It fits with a heavy clunk."))
	else if(istype(attacking_item, /obj/item/organ/eyes/automaton))
		user.visible_message(span_notice("[user] screws the optical sensors into the frame's skull."), span_notice("You screw the optical sensors into place. The lenses catch the light."))
	else if(istype(attacking_item, /obj/item/gear/metal/bronze))
		user.visible_message(span_notice("[user] clicks cogwheels into the frame's joints."), span_notice("You slot the cogwheels into the joint assemblies."))
	update_frame_overlays()

/datum/orderless_slapcraft/automaton/proc/update_frame_overlays()
	var/remaining = 0
	for(var/type in requirements)
		remaining += requirements[type]

	var/progress = (total_requirements - remaining) / total_requirements  // 0.0 to 1.0 could do 0 to 100 but eh same thing really

	var/list/stage_overlays = list(
		"r_leg_s"  = 0.15,
		"l_leg_s"  = 0.30,
		"r_arm_s"  = 0.50,
		"l_arm_s"  = 0.65,
		"torso_s"  = 0.80,
		"head_s"   = 0.95,
	)

	for(var/overlay in stage_overlays)
		if(progress >= stage_overlays[overlay] && !(overlay in installed_parts))
			installed_parts += overlay
			hosted_source.add_overlay(mutable_appearance(hosted_source.icon, overlay))

/datum/orderless_slapcraft/automaton/process_finishing_item(obj/item/attacking_item, mob/user)
	user.visible_message(
		span_notice("[user] presses the soul core into the automaton's chest. The runes flare — then go still."),
		span_notice("You press the soul core into the chest cavity. The binding runes flare with cold light, then dim. Something stirs within the brass.")
	)
	return FALSE

/datum/orderless_slapcraft/automaton/try_finish(mob/user)
	var/turf/T = get_turf(hosted_source)
	qdel(hosted_source)
	new /mob/living/carbon/human/species/automaton/vessel(T)
	user.adjust_experience(related_skill, skill_xp_gained)
	to_chat(user, span_notice("The automaton stands complete. It awaits a soul."))

/datum/orderless_slapcraft/automaton/handle_output_item(mob/user, obj/item/new_item)
	return
