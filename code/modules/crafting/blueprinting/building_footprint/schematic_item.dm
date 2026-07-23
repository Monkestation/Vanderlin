/obj/item/building_schematic
	name = "building schematic"
	desc = "A rolled construction schematic."
	icon = 'icons/roguetown/items/misc.dmi'
	icon_state = "scroll"
	w_class = WEIGHT_CLASS_SMALL

	/// The map template type this schematic loads
	var/datum/map_template/building_template = /datum/map_template/vanderlin_house
	/// The spell granted while held
	var/datum/action/cooldown/spell/place_blueprint/held_spell
	///type of skill added
	var/skill = /datum/action/cooldown/spell/place_blueprint

/obj/item/building_schematic/Destroy()
	QDEL_NULL(held_spell)
	return ..()

/obj/item/building_schematic/equipped(mob/user, slot)
	. = ..()
	if(!(slot & ITEM_SLOT_HANDS))
		return
	if(held_spell)
		return
	if(!building_template)
		return
	held_spell = new skill(user)
	held_spell.schematic = src
	held_spell.Grant(user)

/obj/item/building_schematic/dropped(mob/user, silent)
	. = ..()
	/*
	if(!(slot & ITEM_SLOT_HANDS))
		return
	*/
	if(!held_spell)
		return
	held_spell.Remove(user)
	QDEL_NULL(held_spell)

/obj/item/building_schematic/proc/get_or_build_preview()
	if(!building_template)
		return null
	var/datum/map_template/T = SSmapping.map_templates[building_template]
	if(!T)
		T = new building_template
	if(!T)
		return null
	var/datum/building_preview/preview = new
	preview.load_from_template(T)
	if(!length(preview.blueprint_slots))
		qdel(preview)
		return null
	return preview

/obj/item/building_schematic/examine(mob/user)
	. = ..()
	var/datum/building_preview/preview = get_or_build_preview()
	if(!preview || !length(preview.blueprint_slots))
		. += span_warning("The schematic appears to be blank or unreadable.")
		return
	. += span_notice("This schematic marks [length(preview.blueprint_slots)] construction point[length(preview.blueprint_slots) != 1 ? "s" : ""]:")
	for(var/datum/blueprint_slot/slot in preview.blueprint_slots)
		var/datum/blueprint_recipe/R = slot.recipe
		. += span_notice(" - [R.name]")

/datum/action/cooldown/spell/place_blueprint
	name = "Place Schematic"
	desc = "Unroll the schematic and mark construction points."
	button_icon = 'icons/roguetown/items/misc.dmi'
	button_icon_state = "scroll"
	cooldown_time = 1 SECONDS
	spell_type = NONE
	spell_cost = 0
	charge_required = FALSE
	click_to_activate = TRUE
	self_cast_possible = FALSE
	cast_range = 7
	aim_assist = FALSE
	invocation_type = INVOCATION_NONE
	active_msg = "You unroll the schematic. Click a tile to mark construction points."
	deactive_msg = "You roll up the schematic."
	has_visual_effects = FALSE
	experience_modifier = 0

	/// The schematic item that granted this spell
	var/obj/item/building_schematic/schematic
	/// The ghost image atom sitting on the world
	var/obj/effect/building_outline/ghost_effect
	/// The turf the ghost is currently on
	var/turf/ghost_turf
	///do we care about the output of the list ued on children.
	var/cares_about_placement = FALSE

/datum/action/cooldown/spell/place_blueprint/Destroy()
	remove_ghost()
	schematic = null
	return ..()

/datum/action/cooldown/spell/place_blueprint/on_activation(mob/on_who)
	. = ..()
	setup_ghost()
	if(!ghost_effect)
		return
	RegisterSignal(on_who, COMSIG_MOB_MOUSE_ENTERED, PROC_REF(on_mouse_entered_turf))
	RegisterSignal(on_who, COMSIG_MOVABLE_MOVED, PROC_REF(on_owner_moved))
	RegisterSignal(on_who, COMSIG_ATOM_MOUSE_ENTERED, PROC_REF(on_mouse_entered_turf))
	move_ghost(get_turf(on_who))

/datum/action/cooldown/spell/place_blueprint/on_deactivation(mob/on_who, refund_cooldown = TRUE)
	. = ..()
	UnregisterSignal(on_who, list(
		COMSIG_MOB_MOUSE_ENTERED,
		COMSIG_MOVABLE_MOVED,
		COMSIG_ATOM_MOUSE_ENTERED,
	))
	remove_ghost()

/datum/action/cooldown/spell/place_blueprint/proc/setup_ghost()
	if(!schematic)
		return
	var/datum/building_preview/preview = schematic.get_or_build_preview()
	if(!preview?.preview_MA)
		return
	ghost_effect = new(get_turf(owner))
	ghost_effect.appearance = preview.preview_MA.appearance
	ghost_effect.alpha = 190
	ghost_effect.color = COLOR_CYAN
	ghost_effect.plane = ABOVE_LIGHTING_PLANE
	ghost_effect.mouse_opacity = MOUSE_OPACITY_TRANSPARENT

/datum/action/cooldown/spell/place_blueprint/proc/remove_ghost()
	QDEL_NULL(ghost_effect)
	ghost_turf = null

/datum/action/cooldown/spell/place_blueprint/proc/move_ghost(turf/T)
	if(!ghost_effect || !T || T == ghost_turf)
		return
	ghost_turf = T
	ghost_effect.forceMove(T)

/datum/action/cooldown/spell/place_blueprint/proc/on_mouse_entered_turf(mob/source, turf/new_turf)
	SIGNAL_HANDLER
	move_ghost(get_turf(new_turf))

/datum/action/cooldown/spell/place_blueprint/proc/on_owner_moved()
	SIGNAL_HANDLER
	move_ghost(get_turf(owner))

/datum/action/cooldown/spell/place_blueprint/is_valid_target(atom/cast_on)
	. = ..()
	if(!.)
		return FALSE
	var/turf/T = get_turf(cast_on)
	if(!T)
		owner.balloon_alert(owner, "Invalid placement!")
		return FALSE
	if(!schematic?.building_template)
		owner.balloon_alert(owner, "Schematic is blank!")
		return FALSE
	return TRUE

/datum/action/cooldown/spell/place_blueprint/cast(atom/cast_on)
	. = ..()
	var/turf/T = get_turf(cast_on)
	if(!T)
		return
	if(!cares_about_placement)
		var/datum/building_preview/preview = schematic?.get_or_build_preview()
		if(!preview)
			return

		// Deactivate first so the ghost vanishes cleanly before blueprints appear
		unset_click_ability(owner, refund_cooldown = FALSE)

		preview.place_blueprints(T, owner)
