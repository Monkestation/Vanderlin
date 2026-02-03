GLOBAL_VAR_INIT(lair_portal, null)

/obj/structure/overlord_portal
	name = "shadow portal"
	desc = "A swirling vortex of dark energy. You can sense it connects to the outside world."
	icon = 'icons/roguetown/topadd/death/vamp-lord.dmi'
	icon_state = "obelisk"
	pixel_x = -16
	density = FALSE
	anchored = TRUE
	var/list/overlords = list()
	light_system = MOVABLE_LIGHT
	light_outer_range = 3
	light_color = "#003300"

/obj/structure/overlord_portal/Initialize(mapload)
	. = ..()
	GLOB.lair_portal = src

/obj/structure/overlord_portal/Destroy(force)
	if(GLOB.lair_portal == src)
		GLOB.lair_portal = null
	return ..()

/obj/structure/overlord_portal/attack_hand(mob/user)
	if(!length(overlords))
		to_chat(user, span_warning("The portal flickers weakly - no destinations are available."))
		return

	var/obj/structure/door/exit_door

	var/list/minds = list()
	var/list/doors = list()
	for(var/datum/antagonist/overlord/lord in overlords)
		minds |= lord.owner
		minds[lord.owner] = lord

		doors |= lord.enchanted_doors

	if(user.mind in minds)
		var/list/door_options = list()
		var/datum/antagonist/overlord/linked_overlord = minds[user.mind]
		for(var/obj/structure/door/door in linked_overlord.enchanted_doors)
			if(!QDELETED(door))
				var/area_name = get_area_name(door)
				door_options["[door.name] in [area_name]"] = door

		if(!length(door_options))
			to_chat(user, span_warning("The portal flickers weakly - no destinations are available."))
			return

		var/choice = input(user, "Choose your destination:", "Shadow Portal") as null|anything in door_options
		if(!choice || !door_options[choice])
			return

		exit_door = door_options[choice]
	else
		var/list/valid_doors = list()
		for(var/obj/structure/door/door in doors)
			if(!QDELETED(door))
				valid_doors += door

		if(!length(valid_doors))
			to_chat(user, span_warning("The portal flickers weakly - no destinations are available."))
			return

		exit_door = pick(valid_doors)

	to_chat(user, span_notice("You step through the portal and emerge from [exit_door]."))
	user.forceMove(get_turf(exit_door))

	if(user.mind in minds)
		user.visible_message(span_danger("[user] emerges from the shadows."))
	else
		user.visible_message(span_warning("[user] steps out from [exit_door]."))

/obj/structure/overlord_portal/examine(mob/user)
	. = ..()

	var/list/minds = list()
	var/list/doors = list()
	for(var/datum/antagonist/overlord/lord in overlords)
		minds |= lord.owner
		minds[lord.owner] = lord

		doors |= lord.enchanted_doors

	if(user.mind in minds)
		var/datum/antagonist/overlord/linked_overlord = minds[user.mind]
		. += span_notice("You have [length(linked_overlord.enchanted_doors)] enchanted doors available as exits.")
	else
		. += span_notice("You could step through this to leave, though you're not sure where you'd end up.")
