/obj/structure/mana_pylon
	name = "mana pylon"
	desc = ""
	icon_state = "pylon"
	icon = 'icons/roguetown/misc/mana_pylon.dmi'
	has_initial_mana_pool = TRUE
	plane = GAME_PLANE_FOV_HIDDEN
	layer = ABOVE_MOB_LAYER
	light_outer_range = MINIMUM_USEFUL_LIGHT_RANGE
	light_color = COLOR_CYAN
	density = TRUE

	var/obj/structure/mana_pylon/linked_pylon
	var/datum/beam/created_beam
	var/list/transferring_mobs = list()
	var/different_z = FALSE

/obj/structure/mana_pylon/examine(mob/user)
	. = ..()
	if(different_z)
		. += span_notice("It appears to be transporting mana vertically!")
	if(mana_pool.network_attunement)
		var/datum/attunement/attunement = mana_pool.network_attunement
		. += span_blue("It is attuned to [initial(attunement.name)]")

/obj/structure/mana_pylon/Initialize(mapload, ...)
	. = ..()
	update_appearance(UPDATE_OVERLAYS)
	set_light(1.4, 1.4, 0.75, l_color = COLOR_CYAN)

/obj/structure/mana_pylon/AltClick(mob/living/user)
	. = ..()
	if(!user.client)
		return
	var/datum/mana_pool/mana_pylon/pool = mana_pool
	var/new_threshold = input(user, "Set the minimum mana reserve for this pylon (current: [pool.transfer_threshold]):", "Pylon Threshold", pool.transfer_threshold) as num|null
	if(isnull(new_threshold))
		return
	pool.transfer_threshold = max(0, new_threshold)
	user.balloon_alert(user, "threshold set: [pool.transfer_threshold]")

/obj/structure/mana_pylon/Destroy()
	if(linked_pylon)
		unlink_pylon(linked_pylon)
	return ..()

/obj/structure/mana_pylon/update_overlays()
	. = ..()
	var/mutable_appearance/MA = mutable_appearance(icon, "pylon-glow", plane = ABOVE_LIGHTING_PLANE)
	if(different_z)
		MA.color = COLOR_RED
	. += MA

/obj/structure/mana_pylon/get_initial_mana_pool_type()
	return /datum/mana_pool/mana_pylon

/obj/structure/mana_pylon/attackby(obj/item/I, mob/living/user, list/modifiers)
	. = ..()
	if(!istype(I, /obj/item/gem))
		return
	var/obj/item/gem/gem = I
	if(!gem.attuned)
		return
	user.visible_message(span_notice("[user] starts to attune [src]."), span_notice("You start to attune [src]."))
	if(!do_after(user, 3 SECONDS, src))
		return
	mana_pool.network_attunement = gem.attuned

/obj/structure/mana_pylon/attack_hand_secondary(mob/user, list/modifiers)
	. = ..()
	if(. == SECONDARY_ATTACK_CANCEL_ATTACK_CHAIN)
		return
	if(user.client)
		drain_mana(user)
		return SECONDARY_ATTACK_CANCEL_ATTACK_CHAIN

/obj/structure/mana_pylon/proc/link_pylon(obj/structure/mana_pylon/pylon_to_link)
	if(pylon_to_link.linked_pylon == src)
		return
	if(linked_pylon)
		unlink_pylon(linked_pylon)

	linked_pylon = pylon_to_link
	different_z = (pylon_to_link.z != z)

	if(!different_z)
		created_beam = Beam(
			pylon_to_link,
			icon_state = "medbeam",
			time = INFINITY,
			max_distance = world.maxx,
			beam_layer = LOWER_LEYLINE_LAYER,
			beam_plane = LEYLINE_PLANE,
			invisibility = INVISIBILITY_LEYLINES,
			override_origin_pixel_y = 32,
			override_target_pixel_y = 32,
		)

	mana_pool.start_transfer(pylon_to_link.mana_pool, TRUE)
	update_appearance(UPDATE_OVERLAYS)
	return TRUE

/obj/structure/mana_pylon/proc/unlink_pylon(obj/structure/mana_pylon/pylon_to_unlink)
	QDEL_NULL(created_beam)
	linked_pylon = null
	different_z = FALSE
	mana_pool.stop_transfer(pylon_to_unlink.mana_pool)
	update_appearance(UPDATE_OVERLAYS)

/obj/structure/mana_pylon/proc/drain_mana(mob/living/user)
	if(mana_pool.network_attunement)
		var/list/mana_pools = list()
		for(var/atom/movable/thing as anything in user.get_all_contents())
			if(!isnull(thing.mana_pool) && thing.mana_pool.network_attunement == mana_pool.network_attunement)
				mana_pools += thing.mana_pool
		if(!length(mana_pools))
			return

	var/datum/beam/transfer_beam = user.Beam(src, icon_state = "drain_life", time = INFINITY, override_target_pixel_y = 32)

	while(TRUE)
		if(!do_after(user, 3 SECONDS, target = src) || !user.client)
			break
		var/transfer_amount = min(mana_pool.amount, 20)
		if(!transfer_amount)
			break
		var/obj/item/mana_battery/mana_crystal/small/focus/foci = user.get_active_held_item()
		if(istype(foci))
			mana_pool.transfer_specific_mana(foci.mana_pool, transfer_amount, decrement_budget = TRUE)
		else
			mana_pool.transfer_specific_mana(user.mana_pool, transfer_amount, decrement_budget = TRUE)

	qdel(transfer_beam)

/obj/structure/mana_pylon/MouseDrop_T(mob/living/user, mob/living/over_object)
	. = ..()
	if(!isliving(user) || user != over_object)
		return
	if(!HAS_TRAIT(user, TRAIT_PYLON_RIDER))
		return
	if(get_dist(user, src) > 1)
		to_chat(user, span_warning("You're too far from the pylon."))
		return
	if(mana_pool.amount < 10)
		to_chat(user, span_warning("The pylon doesn't have enough mana to carry you."))
		return

	mana_pool.amount -= 10
	user.visible_message(
		span_notice("[user] dissolves into the leyline!"),
		span_notice("You dissolve into the leyline, riding the flow of mana.")
	)
	user.forceMove(get_turf(src))
	new /obj/effect/bloodcult_jaunt/visible/ley(get_turf(user), user, get_turf(linked_pylon), null)
