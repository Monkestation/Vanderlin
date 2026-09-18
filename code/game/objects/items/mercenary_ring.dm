/obj/item/mercenary_ring
	name = "mercenary ring"
	desc = "A beautiful golden ring, which resonates in a mercenary's mind when twisted. Usually given to their employers as a way of communication. Only a mercenary may bind themselves to such ring."
	icon = 'icons/roguetown/clothing/rings.dmi'
	icon_state = "g_newring_topaz"
	slot_flags = ITEM_SLOT_RING
	sellprice = 1
	dyeable = FALSE
	detail_tag = null
	detail_color = null
	dropshrink = 0.7
	grid_height = 32
	grid_width = 32
	item_weight = 60 GRAMS

	var/datum/weakref/mob_ref

	COOLDOWN_DECLARE(ring_bell)
	var/cooldown = 3 MINUTES
	var/hear_distance = 100

/obj/item/mercenary_ring/Initialize(mapload)
	. = ..()
	RegisterSignal(SSdcs, COMSIG_GLOB_HUMAN_ENTER_CRYO, PROC_REF(remove_mercenary))

/obj/item/mercenary_ring/Destroy()
	mob_ref = null
	. = ..()

/obj/item/mercenary_ring/examine(mob/user)
	. = ..()
	if(!mob_ref)
		to_chat(user, span_warning("There is no mercenary bound to the ring."))
		return

	var/mob/living/carbon/human/bound_merc = mob_ref.resolve()
	. += span_notice("The ring is bound to [bound_merc.real_name].")

/obj/item/mercenary_ring/interact_with_atom(atom/interacting_with, mob/living/user, list/modifiers)

	if(!ishuman(interacting_with))
		return NONE

	var/mob/living/carbon/human/H = interacting_with

	if(!H.mind)
		return ITEM_INTERACT_BLOCKING

	if(mob_ref)
		to_chat(user, span_warning("It can hold no more minds."))
		return ITEM_INTERACT_BLOCKING

	if(!(user == H))
		to_chat(user, span_warning("I can only bind myself to the ring."))
		return
	if(!is_mercenary_job(user.mind.assigned_role))
		to_chat(user, span_warning("I am not a mercenary, the ring does not answer to me."))
		return

	if(IS_DEADITE(H))
		to_chat(user, span_warning("The deadite curse resists the bell's charm."))
	else
		add_mercenary(H)
		to_chat(user, span_smallnotice("I bind myself to the ring."))

	playsound(src, 'sound/items/servant_bell.ogg', 80, TRUE)
	return ITEM_INTERACT_SUCCESS
	
/obj/item/mercenary_ring/attack_self(mob/living/user, list/modifiers)
	. = ..()
	if(COOLDOWN_FINISHED(src, ring_bell))
		ring_bell(user)
		COOLDOWN_START(src, ring_bell, cooldown)
	else
		playsound(src, 'sound/items/servant_bell.ogg', 80, TRUE)

/obj/item/mercenary_ring/proc/ring_bell(mob/living/user)
	if(!mob_ref)
		return
	var/mob/living/carbon/human/player = mob_ref.resolve()
	if(!player)
		return
	if(!player.client)
		return
	if(player.stat >= DEAD)
		return
	if(HAS_TRAIT(player, TRAIT_DEAF))
		return
	if(player.can_block_magic(MAGIC_RESISTANCE_MIND, 0))
		return
	var/turf/origin_turf = get_turf(src)
	if(!is_in_zweb(player.z, origin_turf.z))
		return
	var/distance = get_dist(player, origin_turf)
	if(distance > hear_distance)
		return

	user.visible_message("[user] twists the mercenary ring.")
	playsound(src, 'sound/items/servant_bell.ogg', 100, TRUE)

	player.apply_status_effect(/datum/status_effect/signal_horn/mercenary_ring, null, origin_turf)
	var/dirText = ""
	var/z_dist = origin_turf.z - player.z
	if(z_dist != 0)
		var/abs_z = abs(z_dist)
		switch(abs_z)
			if(1)
				dirText += " one story"
			if(2)
				dirText += " two stories"
			else
				dirText += " far"
		dirText += z_dist > 0 ? " above me" : " below me"
	to_chat(player, span_warning("The mercenary ring resonates[dirText]."))
	if(distance <= 7)
		return
	//sound played for other players, by fem_tanyl !!!1!!
	player.playsound_local(get_turf(player), 'sound/items/servant_bell.ogg', 35, FALSE, pressure_affected = FALSE)

/obj/item/mercenary_ring/proc/add_mercenary(mob/living/carbon/human/H)
	if(mob_ref)
		return
	mob_ref = WEAKREF(H)

/obj/item/mercenary_ring/proc/remove_mercenary(datum/source, mob/living/carbon/human/H)
	if(!mob_ref || !ishuman(H))
		return
	var/mob/living/carbon/human/bound_mob = mob_ref.resolve()
	if(!bound_mob || bound_mob == H)
		mob_ref = null

/datum/status_effect/signal_horn/mercenary_ring
	id = "mercenary ring indicator"
	duration = 25 SECONDS
	alert_type = /atom/movable/screen/alert/status_effect/mercenary_ring

/atom/movable/screen/alert/status_effect/mercenary_ring
	name = "Mercenary Ring"
	desc = "I've been summoned by the ring."
	icon_state = "mercenary_ring"
