/// Tiles (3D-distance) within which subscribers receive the buff refresh
#define MANA_SIPHON_BUFF_RANGE 7
/// Mana drained from anything per process tick
#define MANA_SIPHON_BASE_DRAIN 0.4
/// Process rate in deciseconds
#define MANA_SIPHON_PROCESS_RATE (2 SECONDS)
/// Duration granted/refreshed to the buff status effect (deciseconds)
#define MANA_SIPHON_BUFF_DURATION (3 SECONDS)

/obj/effect/decal/cleanable/ritual_rune/arcyne/mana_siphon
	name = "arcyne mana siphon"
	desc = "A hungry, pulsing sigil that draws power from the world and feeds it to those bound to it..."
	icon = 'icons/effects/160x160.dmi'
	icon_state = "imbuement"
	tier = 2
	runesize = 3
	SET_BASE_PIXEL(-64, -64)
	pixel_z = 0
	invocation = "Shar'kael un'veth draum!"
	can_be_scribed = TRUE
	color = "#2FBEBE"

	var/datum/status_effect/mana_siphon_buff/buff = /datum/status_effect/mana_siphon_buff
	/// Whether the siphon is currently draining and buffing
	var/siphon_active = FALSE
	/// The mob who activated the rune (fallback mana source, also sets the "anchor" for range checks)
	var/mob/living/activating_mob = null
	/// List of mobs who have paid the blood price to receive the buff
	var/list/mob/living/subscribers = list()
	/// Internal process timer handle
	var/process_timer = null
	///how fast we loop
	var/loop_speed = MANA_SIPHON_PROCESS_RATE
	///our mana cost per loop
	var/mana_cost = MANA_SIPHON_BASE_DRAIN
	///are we a subscribable rune? some aren't like crop_growth
	var/user_facing = TRUE
	///anti chat spam basically
	COOLDOWN_DECLARE(drain_message)

/obj/effect/decal/cleanable/ritual_rune/arcyne/mana_siphon/proc/set_active_visuals(active)
	if(active)
		// Pulse the rune brighter when siphoning
		animate(src, alpha = 255, time = 0.3 SECONDS, flags = ANIMATION_END_NOW)
		set_light(1.6, 1.6, 1.0, l_color = "#2FBEBE")
	else
		animate(src, alpha = 160, time = 0.5 SECONDS, flags = ANIMATION_END_NOW)
		set_light(0, 0, 0)

/obj/effect/decal/cleanable/ritual_rune/arcyne/mana_siphon/attack_hand(mob/living/user)
	if(GET_MOB_SKILL_VALUE(user, /datum/attribute/skill/magic/arcane) <= SKILL_LEVEL_NONE)
		to_chat(user, span_warning("You aren't able to invoke these symbols."))
		return

	if(siphon_active)
		deactivate_siphon()
		to_chat(user, span_cultsmall("The siphon stills."))
	else
		activate_siphon(user)
	return ..()

/obj/effect/decal/cleanable/ritual_rune/arcyne/mana_siphon/proc/activate_siphon(mob/living/user)
	siphon_active = TRUE
	activating_mob = user
	set_active_visuals(TRUE)
	user.say(invocation, language = /datum/language/common, ignore_spam = TRUE, forced = "cult invocation")
	playsound(src, 'sound/magic/cosmic_expansion.ogg', 50, TRUE)
	to_chat(user, span_hierophant_warning("The siphon awakens, it will drink from what it can find."))

	//this is mainly so we don't need 100 different processing subsystems
	process_timer = addtimer(CALLBACK(src, PROC_REF(siphon_process)), loop_speed, TIMER_LOOP | TIMER_STOPPABLE)
	rune_in_use = FALSE

/obj/effect/decal/cleanable/ritual_rune/arcyne/mana_siphon/proc/deactivate_siphon()
	siphon_active = FALSE
	activating_mob = null
	if(process_timer)
		deltimer(process_timer)
		set_active_visuals(FALSE)
		do_invoke_glow()
		rune_in_use = FALSE

/obj/effect/decal/cleanable/ritual_rune/arcyne/mana_siphon/attack_hand_secondary(mob/user, list/modifiers)
	. = ..()
	if(. == SECONDARY_ATTACK_CANCEL_ATTACK_CHAIN)
		return

	if(!user_facing)
		return SECONDARY_ATTACK_CANCEL_ATTACK_CHAIN

	if(!isliving(user))
		return SECONDARY_ATTACK_CANCEL_ATTACK_CHAIN

	var/mob/living/L = user
	if(GET_MOB_SKILL_VALUE(L, /datum/attribute/skill/magic/arcane) <= SKILL_LEVEL_NONE)
		to_chat(L, span_warning("You aren't able to commune with these symbols."))
		return SECONDARY_ATTACK_CANCEL_ATTACK_CHAIN

	if(!L.get_bleed_rate())
		to_chat(L, span_hierophant_warning("The rune demands a blood-price, you must be bleeding to bind yourself to it."))
		return SECONDARY_ATTACK_CANCEL_ATTACK_CHAIN

	if(L in subscribers)
		subscribers -= L
		to_chat(L, span_cultsmall("You withdraw your bond from the siphon."))
		L.remove_status_effect(buff)
	else
		subscribers += L
		playsound(src, 'sound/magic/glass.ogg', 50, TRUE)
		to_chat(L, span_hierophant_warning("Your blood seals the bond, the siphon will feed you while you remain close."))

	return SECONDARY_ATTACK_CANCEL_ATTACK_CHAIN

/obj/effect/decal/cleanable/ritual_rune/arcyne/mana_siphon/proc/siphon_process()
	if(!siphon_active || QDELETED(src))
		deactivate_siphon()
		return

	var/mana_found = drain_mana()
	if(!mana_found)
		if(activating_mob && !QDELETED(activating_mob))
			to_chat(activating_mob, span_hierophant_warning("The siphon finds nothing to drink, it falls dark."))
		deactivate_siphon()
		return

	trigger_effects()
	// Small visual pulse to show the rune is working
	animate(src, alpha = 220, time = 0.2 SECONDS, flags = ANIMATION_END_NOW)
	sleep(0.2 SECONDS)
	animate(src, alpha = 255, time = 0.2 SECONDS, flags = ANIMATION_END_NOW)

/obj/effect/decal/cleanable/ritual_rune/arcyne/mana_siphon/proc/drain_mana()
	var/mana_found = FALSE
	var/turf/here = get_turf(src)
	for(var/atom/movable/thing as anything in here)
		if(thing == src)
			continue
		if(isnull(thing.mana_pool))
			continue
		var/datum/mana_pool/pool = thing.mana_pool
		if(pool.amount <= mana_cost * max(1, length(subscribers)))
			continue
		var/drain = min(pool.amount, mana_cost * max(1, length(subscribers)))
		pool.adjust_mana(-drain)
		mana_found = TRUE
		break

	if(!mana_found)
		for(var/obj/structure/mana_pylon/pylon in range(runesize, src))
			if(pylon.mana_pool.amount <= mana_cost * max(1, length(subscribers)))
				continue
			var/drain = min(pylon.mana_pool.amount, mana_cost * max(1, length(subscribers)))
			pylon.mana_pool.adjust_mana(-drain)
			var/turf/turf = get_turf(src)
			turf.Beam(pylon, icon_state = "drain_life", time = loop_speed, override_target_pixel_y = 32)
			mana_found = TRUE
			break

	if(!mana_found)
		if(activating_mob && !QDELETED(activating_mob) && activating_mob.stat == CONSCIOUS)
			if(!isnull(activating_mob.mana_pool) && activating_mob.mana_pool.amount > mana_cost * max(1, length(subscribers)))
				var/drain = min(activating_mob.mana_pool.amount, mana_cost * max(1, length(subscribers)))
				activating_mob.mana_pool.adjust_mana(-drain)
				if(COOLDOWN_FINISHED(src, drain_message))
					to_chat(activating_mob, span_italics("The siphon draws from your own reserves..."))
					COOLDOWN_START(src, drain_message, 45 SECONDS)
				mana_found = TRUE
	return mana_found


/obj/effect/decal/cleanable/ritual_rune/arcyne/mana_siphon/proc/trigger_effects()
	var/turf/source_turf = loc
	for(var/mob/living/sub as anything in subscribers)
		if(QDELETED(sub))
			subscribers -= sub
			continue
		if(sub.has_status_effect(buff))
			continue
		var/dist = source_turf.Distance3D(get_turf(sub))
		if(dist > MANA_SIPHON_BUFF_RANGE)
			continue
		sub.apply_status_effect(buff, null, src)

/obj/effect/decal/cleanable/ritual_rune/arcyne/mana_siphon/Destroy()
	deactivate_siphon()
	subscribers.Cut()
	return ..()

/datum/status_effect/mana_siphon_buff
	id = "mana_siphon_buff"
	alert_type = /atom/movable/screen/alert/status_effect/mana_siphon_buff
	duration = MANA_SIPHON_BUFF_DURATION
	/// The siphon rune that created this buff (weak ref so we don't hold the rune alive)
	var/obj/effect/decal/cleanable/ritual_rune/arcyne/mana_siphon/source_rune = null
	///the max distance we can be from our parent
	var/max_range = MANA_SIPHON_BUFF_RANGE

/datum/status_effect/mana_siphon_buff/on_creation(mob/living/afflicted, duration_override, obj/effect/decal/cleanable/ritual_rune/arcyne/mana_siphon/rune)
	. = ..()
	source_rune = rune
	to_chat(afflicted, span_hierophant_warning("The siphon's warmth flows through you."))

/datum/status_effect/mana_siphon_buff/on_remove()
	. = ..()
	to_chat(owner, span_cultsmall("The siphon's warmth fades from you."))

/datum/status_effect/mana_siphon_buff/tick()
	var/turf/source = source_rune.loc
	if(!source_rune.siphon_active)
		owner.remove_status_effect(src.type)
		return
	var/dist = source.Distance3D(get_turf(owner))
	if(dist > max_range)
		return
	duration = initial(duration)
	return

/atom/movable/screen/alert/status_effect/mana_siphon_buff
	name = "Mana Siphon"
	desc = "You are bound to a mana siphon rune. While near it, you are fed its stolen power."
	icon = 'icons/mob/screen_alert.dmi'
	icon_state = "censerbuff" // reuse an existing mana icon; swap as needed

#undef MANA_SIPHON_BUFF_RANGE
#undef MANA_SIPHON_BASE_DRAIN
#undef MANA_SIPHON_PROCESS_RATE
#undef MANA_SIPHON_BUFF_DURATION
