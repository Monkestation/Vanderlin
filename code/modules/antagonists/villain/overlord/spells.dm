/datum/action/cooldown/spell/enchant_door
	name = "Enchant Door"
	desc = "Enchant a door to serve as a portal to your phylactery lair. Others who use it will be transported there."
	button_icon_state = "knock"
	cooldown_time = 30 SECONDS
	spell_requirements = NONE
	charge_time = 2 SECONDS

	attunements = list(
		/datum/attunement/death = 0.2,
	)

/datum/action/cooldown/spell/remove_enchantment/can_cast_spell(feedback)
	. = ..()
	if(!.)
		return
	return owner.mind?.has_antag_datum(/datum/antagonist/overlord)

/datum/action/cooldown/spell/remove_enchantment/is_valid_target(atom/cast_on)
	. = ..()
	if(!.)
		return
	return istype(cast_on, /obj/structure/door)

/datum/action/cooldown/spell/enchant_door/cast(obj/structure/door/target_door)
	. = ..()
	var/datum/antagonist/overlord/overlord_datum = owner.mind.has_antag_datum(/datum/antagonist/overlord)
	if(!overlord_datum)
		return

	// Check if this door is already enchanted
	if(target_door.GetComponent(/datum/component/overlord_door_enchantment))
		to_chat(owner, span_warning("This door is already enchanted."))
		return FALSE

	// Add enchantment component to existing door
	target_door.AddComponent(/datum/component/overlord_door_enchantment, overlord_datum)
	overlord_datum.enchanted_doors += target_door

	owner.visible_message(span_danger("Dark runes briefly flicker across \the [target_door]!"))
	to_chat(owner, span_notice("You have enchanted \the [target_door]. It now leads to your lair."))
	return TRUE

/datum/component/overlord_door_enchantment
	var/datum/antagonist/overlord/linked_overlord
	var/original_desc

/datum/component/overlord_door_enchantment/Initialize(datum/antagonist/overlord/overlord)
	if(!istype(parent, /obj/structure/door))
		return COMPONENT_INCOMPATIBLE

	linked_overlord = overlord
	var/obj/structure/door/door = parent
	original_desc = door.desc
	door.desc += " Dark energy seems to emanate from its frame."

	// Add subtle visual effect
	door.light_system = MOVABLE_LIGHT
	door.light_outer_range = 1
	door.light_color = "#a51bc0"

	RegisterSignal(parent, COMSIG_DOOR_OPENED, PROC_REF(on_door_opened))

/datum/component/overlord_door_enchantment/Destroy()
	var/obj/structure/door/door = parent
	if(door)
		door.desc = original_desc
		door.light_system = null
	. = ..()

/datum/component/overlord_door_enchantment/proc/on_door_opened(obj/structure/door/source, mob/user)
	SIGNAL_HANDLER
	if(!GLOB.lair_portal || !linked_overlord || !user)
		return

	// Everyone gets transported to the entry structure in the lair
	to_chat(user, span_danger("As you step through the doorway, reality shifts around you!"))
	user.forceMove(get_turf(GLOB.lair_portal))
	if(user.mind == linked_overlord.owner)
		user.visible_message(span_danger("[user] dissolves into shadow."))
	else
		user.visible_message(span_warning("[user] vanishes through the doorway!"))

/datum/action/cooldown/spell/undirected/enter_overseer_mode
	name = "Overseer Trance"
	desc = "Enter a meditative trance to oversee your phylactery operations from afar."
	button_icon_state = "blind"
	cooldown_time = 5 SECONDS
	charge_time = 2 SECONDS
	spell_requirements = NONE

	attunements = list(
		/datum/attunement/death = 0.2,
	)

/datum/action/cooldown/spell/undirected/enter_overseer_mode/can_cast_spell(feedback)
	. = ..()
	if(!.)
		return
	return owner.mind?.has_antag_datum(/datum/antagonist/overlord)

/datum/action/cooldown/spell/undirected/enter_overseer_mode/cast(mob/living/cast_on)
	. = ..()
	var/datum/antagonist/overlord/overlord_datum = cast_on.mind.has_antag_datum(/datum/antagonist/overlord)
	if(!overlord_datum)
		return

	if(!overlord_datum.overlord_controller)
		to_chat(cast_on, span_warning("You have not established a lair yet."))
		return

	if(overlord_datum.controlling_rts)
		exit_rts_mode(overlord_datum)
	else
		enter_rts_mode(overlord_datum)

/datum/action/cooldown/spell/undirected/enter_overseer_mode/proc/enter_rts_mode(datum/antagonist/overlord/overlord_datum)
	var/mob/living/overlord_body = overlord_datum.owner.current

	// Make the overlord body immobile and hidden during RTS mode
	overlord_body.status_flags |= GODMODE
	overlord_body.alpha = 100
	overlord_body.visible_message(span_danger("[overlord_body] enters a deep meditative trance, their form becoming ethereal."))
	overlord_datum.owner.transfer_to(overlord_datum.overlord_controller)
	overlord_datum.controlling_rts = TRUE

	to_chat(overlord_datum.owner.current, span_notice("Your consciousness expands to oversee your phylactery operations."))

/datum/action/cooldown/spell/undirected/enter_overseer_mode/proc/exit_rts_mode(datum/antagonist/overlord/overlord_datum)
	var/mob/living/overlord_body = overlord_datum.overlord_body_ref.resolve()
	if(!overlord_body)
		return

	overlord_body.status_flags &= ~GODMODE
	overlord_body.alpha = 255
	overlord_body.visible_message(span_danger("[overlord_body] awakens from their trance, their form solidifying."))
	overlord_datum.owner.transfer_to(overlord_body)
	overlord_datum.controlling_rts = FALSE

	to_chat(overlord_datum.owner.current, span_notice("You return your focus to the physical realm."))

/datum/action/cooldown/spell/remove_enchantment
	name = "Remove Enchantment"
	desc = "Remove your enchantment from a door, severing the connection."
	button_icon_state = "disintegrate"
	cooldown_time = 30 SECONDS
	charge_time = 2 SECONDS
	spell_requirements = NONE

	attunements = list(
		/datum/attunement/death = 0.2,
	)

	cast_range = 1

/datum/action/cooldown/spell/remove_enchantment/can_cast_spell(feedback)
	. = ..()
	if(!.)
		return
	return owner.mind?.has_antag_datum(/datum/antagonist/overlord)

/datum/action/cooldown/spell/remove_enchantment/is_valid_target(atom/cast_on)
	. = ..()
	if(!.)
		return
	return istype(cast_on, /obj/structure/door)

/datum/action/cooldown/spell/remove_enchantment/cast(obj/structure/door/target_door)
	. = ..()
	var/datum/antagonist/overlord/overlord_datum = owner.mind?.has_antag_datum(/datum/antagonist/overlord)
	if(!overlord_datum)
		return

	if(!length(overlord_datum.enchanted_doors))
		to_chat(owner, span_warning("You don't have any enchanted doors."))
		return

	var/datum/component/overlord_door_enchantment/enchant = target_door.GetComponent(/datum/component/overlord_door_enchantment)
	if(!enchant || enchant.linked_overlord != overlord_datum)
		to_chat(owner, span_warning("This door is not enchanted by you."))
		return

	overlord_datum.enchanted_doors -= target_door
	qdel(enchant)

	target_door.visible_message(span_danger("The dark energy fades from [target_door]."))
	to_chat(owner, span_notice("You have removed the enchantment from [target_door]."))

/datum/action/cooldown/spell/undirected/summon_worker
	name = "Summon Worker"
	desc = "Uses an astronomical amount of mana to summon a worker if you are lacking."
	button_icon_state = "blind"
	cooldown_time = 10 MINUTES
	charge_time = 10 SECONDS
	spell_requirements = NONE
	spell_cost = 100

	attunements = list(
		/datum/attunement/death = 0.2,
	)

/datum/action/cooldown/spell/undirected/summon_worker/can_cast_spell(feedback)
	. = ..()
	if(!.)
		return
	return owner.mind?.has_antag_datum(/datum/antagonist/overlord)

/datum/action/cooldown/spell/undirected/summon_worker/cast(atom/cast_on)
	. = ..()
	var/datum/antagonist/overlord/overlord_datum = owner.mind?.has_antag_datum(/datum/antagonist/overlord)
	if(!overlord_datum)
		return

	if(!overlord_datum.overlord_controller)
		to_chat(owner, span_warning("You have not established a lair yet."))
		return

	if(length(overlord_datum.overlord_controller.worker_mobs))
		return

	overlord_datum.overlord_controller.create_new_worker_mob(get_turf(GLOB.lair_portal))
