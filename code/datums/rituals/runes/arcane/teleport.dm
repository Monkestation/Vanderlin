/obj/effect/decal/cleanable/ritual_rune/arcyne/teleport
	name = "planar convergence matrix"
	desc = "A large spiraling sigil that seems to thrum with power."
	icon = 'icons/effects/160x160.dmi'
	icon_state = "portal"
	tier = 2
	req_invokers = 2
	invocation = "Xel'tharr un'korel!"
	req_keyword = TRUE
	runesize = 2
	SET_BASE_PIXEL(-64, -64)
	pixel_z = 0
	can_be_scribed = TRUE
	associated_ritual = /datum/runerituals/teleport
	var/listkey

/obj/effect/decal/cleanable/ritual_rune/arcyne/teleport/Initialize(mapload, set_keyword)
	. = ..()
	var/area/A = get_area(src)
	var/locname = initial(A.name)
	listkey = set_keyword ? "[set_keyword] [locname]" : "[locname]"
	LAZYADD(GLOB.teleport_runes, src)

/obj/effect/decal/cleanable/ritual_rune/arcyne/teleport/Destroy()
	LAZYREMOVE(GLOB.teleport_runes, src)
	return ..()

/obj/effect/decal/cleanable/ritual_rune/arcyne/teleport/invoke(list/invokers, datum/runerituals/runeritual)
	runeritual = associated_ritual
	if(!..())
		return

	var/mob/living/user = invokers[1]

	var/list/potential_runes = list()
	var/list/seen_keys = list()
	for(var/obj/effect/decal/cleanable/ritual_rune/arcyne/teleport/T as anything in GLOB.teleport_runes)
		if(T == src)
			continue
		potential_runes[avoid_assoc_duplicate_keys(T.listkey, seen_keys)] = T

	if(!length(potential_runes))
		to_chat(user, span_warning("There are no valid runes to teleport to!"))
		log_game("Teleport rune activated by [user] at [COORD(src)] failed - no other teleport runes.")
		fail_invoke()
		return

	var/chosen_key = input(user, "Rune to teleport to", "Teleportation Target") as null|anything in potential_runes
	if(isnull(chosen_key))
		return
	var/obj/effect/decal/cleanable/ritual_rune/arcyne/teleport/dest = potential_runes[chosen_key]
	if(!dest || !Adjacent(user) || QDELETED(src))
		fail_invoke()
		return

	var/turf/target = get_turf(dest)
	if(target.is_blocked_turf(TRUE))
		to_chat(user, span_warning("The target rune is blocked. Attempting to teleport to it would be massively unwise."))
		log_game("Teleport rune activated by [user] at [COORD(src)] failed - destination blocked.")
		fail_invoke()
		return

	if(ritual_result)
		pickritual.cleanup_atoms(selected_atoms)

	var/moved_anything = FALSE
	var/move_user_last = FALSE
	var/any_success = FALSE

	for(var/atom/movable/A in range(runesize, src))
		if(istype(A, /obj/effect/dummy/phased_mob))
			continue
		if(ismob(A) && !isliving(A))
			continue
		if(A == user)
			move_user_last = TRUE
			moved_anything = TRUE
			continue
		if(!A.anchored)
			moved_anything = TRUE
			if(do_teleport(A, target, channel = TELEPORT_CHANNEL_CULT))
				any_success = TRUE

	if(!moved_anything)
		fail_invoke()
		return

	playsound(src, 'sound/magic/cosmic_expansion.ogg', 50, TRUE)
	playsound(target, 'sound/magic/cosmic_expansion.ogg', 50, TRUE)

	if(move_user_last && do_teleport(user, target, channel = TELEPORT_CHANNEL_CULT))
		any_success = TRUE

	if(any_success)
		visible_message(span_warning("There is a sharp crack of inrushing air, and everything above the rune disappears!"), null, "<i>You hear a sharp crack.</i>")
		to_chat(user, span_cult("You[move_user_last ? "r vision blurs, and with a falling feeling you suddenly appear somewhere else" : " send everything above the rune away"]."))
		target.visible_message(span_warning("There is a boom of outrushing air as something appears above the rune!"), null, "<i>You hear a boom.</i>")
	else
		to_chat(user, span_cult("You[move_user_last ? "r vision blurs briefly, but nothing happens" : " try send everything above the rune away, but the teleportation fails"]."))

	finish_invoke(invokers)

/datum/runerituals/teleport
	name = "planar convergence"
	tier = 3
	blacklisted = FALSE
	required_atoms = list(
		/obj/item/natural/artifact = 1,
		/obj/item/natural/leyline = 1,
		/obj/item/natural/melded/t2 = 1
	)

/datum/runerituals/teleport/on_finished_recipe(mob/living/user, list/selected_atoms, turf/loc)
	return TRUE
