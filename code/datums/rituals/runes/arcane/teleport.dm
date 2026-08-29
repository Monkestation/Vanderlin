/// Flat mana cost per traveler moved through the sigil
#define ARCYNE_TELEPORT_MANA_PER_TRAVELER 40
/// Flat mana cost per item
#define ARCYNE_TELEPORT_MANA_PER_ITEM 4

/// Delay between each follower's warp after the caster commits to a destination
#define ARCYNE_TELEPORT_FOLLOWER_STAGGER (0.4 SECONDS)

/obj/effect/decal/cleanable/ritual_rune/arcyne/mana_siphon/teleport
	name = "arcyne conduit sigil"
	desc = "A large spiraling sigil that thrums with power, hungry for the mana it needs to tear open a path between two points."
	icon = 'icons/effects/160x160.dmi'
	icon_state = "portal"
	tier = 2
	runesize = 2
	invocation = "Xel'tharr un'korel!"
	color = "#8E44AD"
	can_be_scribed = TRUE
	mana_cost = ARCYNE_TELEPORT_MANA_PER_TRAVELER
	SET_BASE_PIXEL(-64, -64)
	/// Registry key other conduit sigils are picked by, e.g. "east wing" or just the area name
	var/listkey
	/// Origin turf captured at the moment we open the conduit, so late arrivals don't get swept up as followers
	var/turf/warp_origin
	/// The active browsing session, if someone is currently inside this sigil's conduit
	var/datum/sigil_travel_ui/active_ui

/obj/effect/decal/cleanable/ritual_rune/arcyne/mana_siphon/teleport/Initialize(mapload, set_keyword)
	. = ..()
	var/area/A = get_area(src)
	var/locname = initial(A.name)
	listkey = set_keyword ? "[set_keyword] [locname]" : "[locname]"
	LAZYADD(GLOB.teleport_runes, src)

/obj/effect/decal/cleanable/ritual_rune/arcyne/mana_siphon/teleport/Destroy()
	GLOB.teleport_runes -= src
	if(active_ui)
		active_ui.cleanup()
	return ..()

/// Fully replaces the base mana_siphon click handler - this rune doesn't loop-process, it opens the warp sigil view once per activation.
/obj/effect/decal/cleanable/ritual_rune/arcyne/mana_siphon/teleport/attack_hand(mob/living/user)
	if(GET_MOB_SKILL_VALUE(user, /datum/attribute/skill/magic/arcane) <= SKILL_LEVEL_NONE)
		to_chat(user, span_warning("You aren't able to invoke these symbols."))
		return

	if(siphon_active)
		to_chat(user, span_warning("The sigil is already channeling - wait for it to still."))
		return

	var/list/valid_destinations = list()
	for(var/obj/effect/decal/cleanable/ritual_rune/arcyne/mana_siphon/teleport/T as anything in GLOB.teleport_runes)
		if(T == src || QDELETED(T))
			continue
		var/turf/dest_turf = get_turf(T)
		if(dest_turf.is_blocked_turf(TRUE))
			continue
		valid_destinations += T

	if(!length(valid_destinations))
		to_chat(user, span_warning("There are no valid sigils to link to!"))
		return

	var/list/mob/living/followers = list()
	for(var/mob/living/sub in range(runesize, src))
		if(QDELETED(sub) || sub == user)
			continue
		followers += sub

	var/list/obj/item/item_list = list()
	for(var/obj/item/item in range(runesize, src))
		if(item.mana_pool)
			continue
		if(item.anchored)
			continue
		if(item.item_flags & NO_ITEM_TELEPORT)
			continue
		item_list += item

	for(var/obj/structure/closet/chest in range(runesize, src))
		if(chest.anchored)
			continue
		item_list += chest

	var/travelers = 1 + length(followers)
	var/items = length(item_list)
	if(!drain_mana(travelers, items, user))
		to_chat(user, span_hierophant_warning("The sigil gropes for power and finds none. It falls dark."))
		return

	siphon_active = TRUE
	activating_mob = user
	warp_origin = get_turf(src)
	set_active_visuals(TRUE)
	user.say(invocation, language = /datum/language/common, ignore_spam = TRUE, forced = "cult invocation")

	followers += item_list
	active_ui = new(user, src, valid_destinations, followers)
	active_ui.show()
	return ..()

/obj/effect/decal/cleanable/ritual_rune/arcyne/mana_siphon/teleport/drain_mana(travelers, items, mob/living/user)
	var/cost = mana_cost * max(1, travelers)
	cost += items * ARCYNE_TELEPORT_MANA_PER_ITEM
	var/turf/here = get_turf(src)

	for(var/atom/movable/thing as anything in here)
		if(thing == src || isnull(thing.mana_pool))
			continue
		var/datum/mana_pool/pool = thing.mana_pool
		if(pool.amount >= cost)
			pool.adjust_mana(-cost)
			return TRUE

	for(var/obj/structure/mana_pylon/pylon in range(runesize, src))
		if(isnull(pylon.mana_pool) || pylon.mana_pool.amount < cost)
			continue
		pylon.mana_pool.adjust_mana(-cost)
		here.Beam(pylon, icon_state = "drain_life", time = 1 SECONDS, override_target_pixel_y = 32)
		return TRUE

	if(!QDELETED(user) && user.stat == CONSCIOUS)
		if(!isnull(user.mana_pool) && user.has_mana_available(cost))
			user.mana_pool.adjust_mana(-cost)
			if(COOLDOWN_FINISHED(src, drain_message))
				to_chat(user, span_italics("The sigil draws from your own reserves..."))
				COOLDOWN_START(src, drain_message, 45 SECONDS)
			return TRUE

	return FALSE

/// Called by sigil_travel_ui once the caster commits (walks off the browsed destination under their own power)
/obj/effect/decal/cleanable/ritual_rune/arcyne/mana_siphon/teleport/proc/finish_warp(mob/living/user, turf/final_turf, list/mob/living/followers)
	SpinAnimation(
		speed = 0.4 SECONDS,
		loops = length(followers),
		clockwise = TRUE,
		segments = 6,
		parallel = TRUE
	)
	warp_followers(followers, final_turf, user)
	active_ui = null
	deactivate_siphon()

/obj/effect/decal/cleanable/ritual_rune/arcyne/mana_siphon/teleport/proc/warp_followers(list/mob/living/followers, turf/target_turf, mob/living/user)
	for(var/i in 1 to length(followers))
		var/mob/living/follower = followers[i]
		addtimer(CALLBACK(src, PROC_REF(warp_single_follower), follower, target_turf, user), ARCYNE_TELEPORT_FOLLOWER_STAGGER * i)

/obj/effect/decal/cleanable/ritual_rune/arcyne/mana_siphon/teleport/proc/warp_single_follower(mob/living/follower, turf/target_turf, mob/living/user)
	if(QDELETED(follower) || QDELETED(target_turf) || QDELETED(src))
		return

	if(get_dist(get_turf(follower), warp_origin) > runesize) // they wandered off before their turn came up
		return
	var/obj/effect/temp_visual/wave_up/wave = new /obj/effect/temp_visual/wave_up(get_turf(follower))
	wave.color = GLOB.form_colors[FORM_ARCANE]

	playsound(follower, 'sound/magic/cosmic_expansion.ogg', 50, TRUE)
	to_chat(follower, span_cult("The sigil's pull catches you, and you tumble through after [user]!"))
	follower.forceMove(target_turf)
	target_turf.visible_message(span_warning("[follower] tumbles out of the sigil after [user]!"))

/datum/sigil_travel_ui
	var/mob/living/traveler
	var/obj/effect/decal/cleanable/ritual_rune/arcyne/mana_siphon/teleport/origin
	var/list/obj/effect/decal/cleanable/ritual_rune/arcyne/mana_siphon/teleport/destinations = list()
	var/list/mob/living/followers = list()
	var/current_index = 1
	var/obj/screen/sigil_navigate/left_button
	var/obj/screen/sigil_navigate/right_button

/datum/sigil_travel_ui/New(mob/living/user, obj/effect/decal/cleanable/ritual_rune/arcyne/mana_siphon/teleport/sigil, list/destination_list, list/follower_list)
	traveler = user
	origin = sigil
	destinations = destination_list.Copy()
	followers = follower_list.Copy()
	current_index = 1

	RegisterSignal(traveler, COMSIG_MOVABLE_MOVED, PROC_REF(on_traveler_moved))

/datum/sigil_travel_ui/proc/on_traveler_moved(mob/source, atom/old_loc, movement_dir, forced, list/old_locs)
	// Only commit if they end up somewhere that ISN'T one of the destinations
	// (i.e. they walked off under their own steam instead of via navigate())
	///worst hack ever but hey
	var/turf/current_turf = get_turf(traveler)
	var/on_destination = FALSE

	for(var/obj/effect/decal/cleanable/ritual_rune/arcyne/mana_siphon/teleport/dest as anything in destinations)
		if(!QDELETED(dest) && get_turf(dest) == current_turf)
			on_destination = TRUE
			break

	if(!on_destination)
		commit_warp(movement_dir)

/datum/sigil_travel_ui/proc/show()
	if(!traveler?.client)
		cleanup()
		return

	var/client/C = traveler.client

	left_button = new()
	left_button.ui = src
	left_button.direction = -1
	left_button.screen_loc = "7,7"
	left_button.update_appearance()
	C.screen += left_button

	right_button = new()
	right_button.ui = src
	right_button.direction = 1
	right_button.screen_loc = "9,7"
	right_button.update_appearance()
	C.screen += right_button

	traveler.alpha = 0
	to_chat(traveler, span_notice("You sink into the sigil. You sense other conduits nearby..."))

	move_to_destination()
	update_display()

/datum/sigil_travel_ui/proc/update_display()
	if(!traveler || !length(destinations) || current_index > length(destinations))
		return

	var/obj/effect/decal/cleanable/ritual_rune/arcyne/mana_siphon/teleport/current_dest = destinations[current_index]
	var/area/dest_area = get_area(current_dest)

	to_chat(traveler, span_notice("Exit [current_index]/[length(destinations)]: [current_dest.listkey] in [dest_area.name]"))

/datum/sigil_travel_ui/proc/navigate(direction)
	if(!length(destinations))
		return

	var/attempts = length(destinations)
	while(attempts > 0)
		current_index += direction

		if(current_index < 1)
			current_index = length(destinations)
		else if(current_index > length(destinations))
			current_index = 1

		if(!QDELETED(destinations[current_index]))
			break

		attempts--

	move_to_destination()
	update_display()

/datum/sigil_travel_ui/proc/move_to_destination()
	if(!traveler || !length(destinations) || current_index > length(destinations))
		return

	var/obj/effect/decal/cleanable/ritual_rune/arcyne/mana_siphon/teleport/destination = destinations[current_index]
	if(QDELETED(destination))
		return

	traveler.forceMove(get_turf(destination))

/datum/sigil_travel_ui/proc/commit_warp(travel_dir)
	if(!traveler)
		return

	var/turf/final_turf = get_step(traveler, REVERSE_DIR(travel_dir))

	cleanup(FALSE)

	to_chat(traveler, span_cult("Your vision clears - you've stepped out of the sigil!"))
	traveler.visible_message(span_danger("[traveler] steps out of a shimmering sigil."))

	animate(traveler, alpha = 255, time = 0.5 SECONDS, flags = ANIMATION_RELATIVE|ANIMATION_PARALLEL)

	if(!QDELETED(origin))
		origin.finish_warp(traveler, final_turf, followers)

/datum/sigil_travel_ui/proc/cleanup(clean_alpha = TRUE)
	if(traveler)
		UnregisterSignal(traveler, COMSIG_MOVABLE_MOVED)

	if(traveler?.client)
		var/client/C = traveler.client
		if(left_button)
			C.screen -= left_button
			qdel(left_button)
		if(right_button)
			C.screen -= right_button
			qdel(right_button)

	if(clean_alpha && traveler?.alpha != 255)
		traveler.alpha = 255

	qdel(src)

/obj/screen/sigil_navigate
	name = "Navigate"
	icon = 'icons/obj/cellular/putrid_abilities.dmi'
	icon_state = "button_bg"
	plane = HUD_PLANE

	var/datum/sigil_travel_ui/ui
	var/direction = 0

/obj/screen/sigil_navigate/update_icon_state()
	. = ..()
	if(direction < 0)
		name = "Previous Exit"
	else
		name = "Next Exit"

/obj/screen/sigil_navigate/Click()
	if(!ui)
		return
	ui.navigate(direction)

/obj/screen/sigil_navigate/MouseEntered(location, control, params)
	. = ..()
	transform = matrix() * 1.2

/obj/screen/sigil_navigate/MouseExited()
	. = ..()
	transform = matrix()

#undef ARCYNE_TELEPORT_MANA_PER_TRAVELER
#undef ARCYNE_TELEPORT_FOLLOWER_STAGGER
#undef ARCYNE_TELEPORT_MANA_PER_ITEM
