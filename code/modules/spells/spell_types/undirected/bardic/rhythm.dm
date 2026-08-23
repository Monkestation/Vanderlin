#define RHYTHM_FILTER "rhythm_glow"

/datum/rhythm_tracker
	var/greater_stacks = 0
	var/last_rhythm_type = RHYTHM_NONE
	var/last_proc_time = 0
	var/datum/action/cooldown/spell/crescendo/crescendo_action = null

/datum/rhythm_tracker/proc/on_rhythm_proc(rhythm_path)
	last_rhythm_type = rhythm_path
	last_proc_time = world.time
	greater_stacks = min(greater_stacks + 1, CRESCENDO_STACKS)
	update_crescendo_button()

/datum/rhythm_tracker/proc/check_decay()
	if(greater_stacks > 0 && (world.time - last_proc_time) >= CRESCENDO_DECAY)
		greater_stacks = 0
		last_rhythm_type = RHYTHM_NONE
		update_crescendo_button()

/datum/rhythm_tracker/proc/update_crescendo_button()
	if(crescendo_action)
		crescendo_action.build_all_button_icons(UPDATE_BUTTON_STATUS)

/datum/rhythm_tracker/Destroy()
	if(crescendo_action)
		QDEL_NULL(crescendo_action)
	return ..()

/datum/action/cooldown/spell/undirected/rhythm
	name = "Rhythm"
	desc = "Attune your blade to a rhythm. Your next melee hit within 8 seconds will trigger its effect."
	button_icon = 'icons/mob/actions/bardsongs.dmi'
	button_icon_state = "rhythm_resonating"

	click_to_activate = FALSE
	self_cast_possible = TRUE

	spell_type = SPELL_STAMINA
	spell_cost = RHYTHM_ACTIVATION_COST

	charge_required = FALSE
	cooldown_time = RHYTHM_COOLDOWN

	shared_cooldown = RHYTHM_SHARED_COOLDOWN

	invocation_type = INVOCATION_NONE
	spell_requirements = SPELL_REQUIRES_HUMAN

	associated_skill = /datum/attribute/skill/misc/music

	var/rhythm_type = RHYTHM_NONE
	var/primed = FALSE
	var/prime_timer_id = null
	var/datum/rhythm_tracker/tracker = null
	var/prime_alert = "Rhythm!"

/// Check if user is holding an instrument in either hand
/datum/action/cooldown/spell/undirected/rhythm/proc/has_instrument(mob/living/carbon/human/user)
	for(var/obj/item/held in user.held_items)
		if(istype(held, /obj/item/instrument))
			return TRUE
	return FALSE

/datum/action/cooldown/spell/undirected/rhythm/can_cast_spell(feedback = TRUE)
	. = ..()
	if(!.)
		return FALSE
	if(!ishuman(owner))
		return FALSE
	var/mob/living/carbon/human/H = owner
	if(!has_instrument(H))
		if(feedback)
			to_chat(H, span_warning("I need an instrument in hand to perform!"))
		return FALSE
	return TRUE

/datum/action/cooldown/spell/undirected/rhythm/cast(atom/cast_on)
	. = ..()
	var/mob/living/carbon/human/H = owner
	if(!ishuman(H))
		return FALSE

	// Prime the next hit
	primed = TRUE
	H.add_filter(RHYTHM_FILTER, 2, list("type" = "outline", "color" = GLOW_COLOR_BARDIC, "alpha" = 100, "size" = 1))
	to_chat(H, span_info("I attune my weapon to a [name] rhythm."))
	H.visible_message(span_warning("[H]'s weapon resonates with a [name] rhythm."))
	H.balloon_alert_to_viewers(prime_alert)
	playsound(H, 'sound/magic/buffrollaccent.ogg', 30, TRUE)

	// Register for the next melee hit (pre-defense, rhythm always lands)
	RegisterSignal(H, COMSIG_MOB_ITEM_ATTACK_POST_SWINGDELAY, PROC_REF(on_melee_hit))

	// Start the window timer
	prime_timer_id = addtimer(CALLBACK(src, PROC_REF(rhythm_fizzle)), RHYTHM_WINDOW, TIMER_STOPPABLE)
	return TRUE

//meleeing will always trigger this
/datum/action/cooldown/spell/undirected/rhythm/proc/on_melee_hit(mob/living/source, mob/living/target, mob/living/user, obj/item/weapon)
	SIGNAL_HANDLER
	if(!primed)
		return
	if(!isliving(target) || target == owner || target.stat == DEAD)
		return

	primed = FALSE
	UnregisterSignal(owner, COMSIG_MOB_ITEM_ATTACK_POST_SWINGDELAY)
	if(prime_timer_id)
		deltimer(prime_timer_id)
		prime_timer_id = null
	owner.remove_filter(RHYTHM_FILTER)

	apply_rhythm(target, owner)

	if(tracker)
		var/mob/living/carbon/human/H = owner
		if(ishuman(H) && H.inspiration && H.inspiration.level >= BARD_T2)
			tracker.on_rhythm_proc(rhythm_type)
			if(tracker.greater_stacks >= CRESCENDO_STACKS)
				H.balloon_alert_to_viewers("<font color = '#44bb44'>Crescendo ready!</font>")
			else
				H.balloon_alert_to_viewers("Crescendo [tracker.greater_stacks]/[CRESCENDO_STACKS]")

/datum/action/cooldown/spell/undirected/rhythm/proc/rhythm_fizzle()
	if(!primed)
		return
	primed = FALSE
	prime_timer_id = null
	UnregisterSignal(owner, COMSIG_MOB_ITEM_ATTACK_POST_SWINGDELAY)
	owner.remove_filter(RHYTHM_FILTER)
	to_chat(owner, span_warning("I failed to strike in time. My song unheard."))

/datum/action/cooldown/spell/undirected/rhythm/proc/apply_rhythm(mob/living/target, mob/living/user)
	new /obj/effect/temp_visual/song_telltale/buff(get_turf(user))

/datum/action/cooldown/spell/undirected/rhythm/Remove(mob/remove_from)
	if(primed)
		primed = FALSE
		UnregisterSignal(remove_from, COMSIG_MOB_ITEM_ATTACK_POST_SWINGDELAY)
		if(prime_timer_id)
			deltimer(prime_timer_id)
			prime_timer_id = null
		remove_from.remove_filter(RHYTHM_FILTER)
	. = ..()

/datum/action/cooldown/spell/undirected/rhythm/resonating
	name = "Resonating"
	desc = "Parry-bypassing brute damage that reverberates through the target. Armor still applies."
	button_icon_state = "rhythm_resonating"
	rhythm_type = RHYTHM_RESONATING
	prime_alert = "Rhythm: Resonate!"

/datum/action/cooldown/spell/undirected/rhythm/resonating/apply_rhythm(mob/living/target, mob/living/user)
	var/def_zone = user.zone_selected || BODY_ZONE_CHEST
	var/armor_block = target.run_armor_check(def_zone, "slash", armor_penetration = 0, damage = RHYTHM_RESONATING_DAMAGE)
	target.apply_damage(RHYTHM_RESONATING_DAMAGE, BRUTE, def_zone, armor_block, damage_type = BCLASS_CUT)
	new /obj/effect/temp_visual/kinetic_blast(get_turf(target))
	var/zone_name = parse_zone(def_zone)
	target.balloon_alert_to_viewers("resonant strike - [zone_name]!")
	target.visible_message(
		span_danger("Rhythmic force reverberates through [target]!"),
		span_userdanger("Rhythmic force reverberates through my body!"))
	playsound(target, 'sound/magic/blade_burst.ogg', 50, TRUE)
	..()

/datum/action/cooldown/spell/undirected/rhythm/concussive
	name = "Concussive"
	desc = "Repels the target backward on hit."
	button_icon_state = "rhythm_concussive"
	rhythm_type = RHYTHM_CONCUSSIVE
	prime_alert = "Rhythm: Concuss!"

/datum/action/cooldown/spell/undirected/rhythm/concussive/apply_rhythm(mob/living/target, mob/living/user)
	new /obj/effect/temp_visual/kinetic_blast(get_turf(target))
	if(!(target.move_resist >= MOVE_FORCE_STRONG || target.anchored))
		var/push_dir = get_dir(user, target)
		if(!push_dir)
			push_dir = user.dir
		target.safe_throw_at(get_ranged_target_turf(target, push_dir, 1), 1, 1, user, force = MOVE_FORCE_STRONG)
	target.visible_message(
		span_danger("[user]'s strike repels [target] backward!"),
		span_userdanger("[user]'s strike repels me backward!"))
	playsound(target, 'sound/magic/repulse.ogg', 50, TRUE)
	..()

/datum/action/cooldown/spell/undirected/rhythm/frigid
	name = "Frigid"
	desc = "Applies a frost stack to the target, slowing and eventually freezing them."
	button_icon_state = "rhythm_frigid"
	rhythm_type = RHYTHM_FRIGID
	prime_alert = "Rhythm: Chill!"

/datum/action/cooldown/spell/undirected/rhythm/frigid/apply_rhythm(mob/living/target, mob/living/user)
	apply_frost_stack(target)
	new /obj/effect/temp_visual/snap_freeze(get_turf(target))
	target.visible_message(
		span_danger("[user]'s strike chills [target]!"),
		span_userdanger("A deathly chill seeps into my body from [user]'s strike!"))
	//playsound(target, 'sound/spellbooks/crystal.ogg', 50, TRUE)
	..()

/datum/action/cooldown/spell/undirected/rhythm/regenerating
	name = "Regenerating"
	desc = "Grants a heal-over-time on yourself when you land a hit."
	button_icon_state = "rhythm_regenerating"
	rhythm_type = RHYTHM_REGENERATING
	prime_alert = "Rhythm: Mend!"

/datum/action/cooldown/spell/undirected/rhythm/regenerating/apply_rhythm(mob/living/target, mob/living/user)
	user.apply_status_effect(/datum/status_effect/buff/healing/rhythm_regen)
	new /obj/effect/temp_visual/heal_rogue(get_turf(user))
	to_chat(user, span_info("A soothing rhythm mends my wounds."))
	playsound(user, 'sound/magic/heal.ogg', 40, TRUE)
	..()

/datum/status_effect/buff/healing/rhythm_regen
	id = "rhythm_regen"
	alert_type = /atom/movable/screen/alert/status_effect/buff/healing
	duration = RHYTHM_REGEN_DURATION
	healing_on_tick = RHYTHM_REGEN_TICK
	outline_colour = GLOW_COLOR_BARDIC

#undef RHYTHM_FILTER
