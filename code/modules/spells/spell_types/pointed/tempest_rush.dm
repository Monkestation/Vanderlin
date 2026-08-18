/datum/action/cooldown/spell/tempest_rush
	button_icon = 'icons/mob/actions/spells/spellfist.dmi'
	button_icon_state = "storm_of_psydon"
	name = "Tempest Rush"
	desc = "Channel mana into your legs to leap toward a target from a distance, closing the gap rapidly. \
		Then, channel the mana into your fists to unleash a storm of blows. \
		Requires 7 Momentum: 3 punches + 1 kick (20 damage each). \
		Overcharged at 10 Momentum: 9 punches + 1 kick (20 damage each). \
		Cannot be parried or dodged. \
		Consumes all momentum only on a successful hit."
	sound = list('sound/combat/wooshes/punch/punchwoosh (1).ogg','sound/combat/wooshes/punch/punchwoosh (2).ogg','sound/combat/wooshes/punch/punchwoosh (3).ogg')

	cast_range = 7

	spell_cost = 120

	required_form = FORM_LIGHTNING
	required_technique = TECHNIQUE_IMBUE

	invocation = null
	invocation_type = INVOCATION_NONE

	charge_required = TRUE
	charge_time = 1 SECONDS
	charge_slowdown = CHARGING_SLOWDOWN_NONE
	charge_sound = 'sound/magic/charging.ogg'
	cooldown_time = 60 SECONDS

	spell_impact_intensity = SPELL_IMPACT_MEDIUM

	spell_requirements = SPELL_REQUIRES_NO_ANTIMAGIC | SPELL_REQUIRES_HUMAN | SPELL_REQUIRES_SAME_Z

	var/start_invocation = "'Asifa!"
	var/dash_range = 7
	var/step_delay = 1
	var/punch_damage = 20
	var/kick_damage = 20
	var/punch_sets_full = 3
	var/punches_per_set = 3
	var/punch_count_lame = 3
	var/min_momentum = 7
	var/empowered_momentum = 10

/datum/action/cooldown/spell/tempest_rush/can_cast_spell(feedback = TRUE)
	. = ..()
	if(!.)
		return FALSE
	if(!ishuman(owner))
		return FALSE
	var/mob/living/carbon/human/H = owner
	var/datum/status_effect/buff/arcyne_momentum/M = H.has_status_effect(/datum/status_effect/buff/arcyne_momentum)
	if(!M || M.stacks < min_momentum)
		if(feedback)
			to_chat(H, span_warning("Not enough momentum! I need at least [min_momentum] stacks!"))
		return FALSE
	return TRUE

/datum/action/cooldown/spell/tempest_rush/before_cast(atom/cast_on)
	. = ..()
	. |= SPELL_NO_IMMEDIATE_COOLDOWN

/datum/action/cooldown/spell/tempest_rush/cast(atom/cast_on)
	. = ..()
	var/mob/living/carbon/human/H = owner
	if(!istype(H))
		return FALSE

	var/datum/status_effect/buff/arcyne_momentum/M = H.has_status_effect(/datum/status_effect/buff/arcyne_momentum)
	if(!M || M.stacks < min_momentum)
		return FALSE

	var/stacks = M.stacks
	var/is_full = stacks >= empowered_momentum

	var/mob/living/preferred_target
	if(isliving(cast_on))
		preferred_target = cast_on
	else
		var/turf/clicked_turf = get_turf(cast_on)
		if(clicked_turf)
			for(var/mob/living/L in clicked_turf)
				if(L != H && L.stat != DEAD)
					preferred_target = L
					break

	if(!preferred_target)
		to_chat(H, span_warning("I need a target to focus my storm on!"))
		return FALSE

	H.say(start_invocation, forced = "spell", language = /datum/language/common)

	var/turf/start = get_turf(H)
	var/facing = get_dir(start, get_turf(preferred_target)) || H.dir
	H.dir = facing

	if(get_dist(H, preferred_target) <= 1)
		if(preferred_target.can_block_magic())
			preferred_target.visible_message(span_warning("The storm dissipates on contact with [preferred_target]!"))
			StartCooldown()
			return TRUE
		H.visible_message(span_danger("<b>[H] latches onto [preferred_target], unleashing a flurry of blows!</b>"))
		release_momentum(H, M, stacks)
		if(is_full)
			oraora(H, preferred_target)
		else
			oraora_lame(H, preferred_target)
		StartCooldown()
		return TRUE

	H.visible_message(span_danger("<b>[H] launches toward [preferred_target] with storming intent!</b>"))

	var/old_pass = H.pass_flags
	var/old_throwing = H.throwing
	H.pass_flags |= PASSMOB
	H.throwing = TRUE
	var/prev_pixel_z = H.pixel_z
	var/prev_transform = H.transform

	animate(H, pixel_z = prev_pixel_z + 18, time = 1, easing = EASE_OUT)

	var/mob/living/hit_target
	for(var/i in 1 to dash_range)
		if(H.stat != CONSCIOUS || H.IsParalyzed() || H.IsStun() || QDELETED(H))
			break

		if(get_dist(H, preferred_target) <= 1)
			hit_target = preferred_target
			break

		facing = get_dir(get_turf(H), get_turf(preferred_target))
		if(!facing)
			break
		H.dir = facing

		var/turf/next = get_step(get_turf(H), facing)
		if(!next || next.density)
			break

		var/blocked = FALSE
		for(var/obj/structure/S in next.contents)
			if(S.density && !S.climbable)
				blocked = TRUE
				break
		if(blocked)
			break

		step(H, facing)

		if(i < dash_range)
			sleep(step_delay)

	var/land_angle = pick(-20, -15, 15, 20)
	animate(H, pixel_z = prev_pixel_z, transform = turn(prev_transform, land_angle), time = 1, easing = EASE_IN)
	animate(transform = prev_transform, time = 2)

	H.pass_flags = old_pass
	H.throwing = old_throwing

	if(!hit_target && get_dist(H, preferred_target) <= 1)
		hit_target = preferred_target

	if(!hit_target)
		to_chat(H, span_warning("My storm finds no purchase!"))
		StartCooldown()
		return TRUE

	if(hit_target.can_block_magic())
		hit_target.visible_message(span_warning("The storm dissipates on contact with [hit_target]!"))
		StartCooldown()
		return TRUE

	release_momentum(H, M, stacks)
	if(is_full)
		oraora(H, hit_target)
	else
		oraora_lame(H, hit_target)
	StartCooldown()
	return TRUE

/datum/action/cooldown/spell/tempest_rush/proc/release_momentum(mob/living/carbon/human/H, datum/status_effect/buff/arcyne_momentum/M, stacks)
	if(M)
		M.consume_all_stacks()
	to_chat(H, span_notice("All [stacks] momentum released into the storm!"))

/datum/action/cooldown/spell/tempest_rush/proc/combo_valid(mob/living/carbon/human/user, mob/living/target)
	if(QDELETED(user) || QDELETED(target))
		return FALSE
	if(user.stat != CONSCIOUS)
		return FALSE
	if(get_dist(user, target) > 1)
		return FALSE
	return TRUE

/datum/action/cooldown/spell/tempest_rush/proc/cling(mob/living/carbon/human/user, mob/living/target)
	if(get_dist(user, target) <= 1)
		return TRUE
	var/turf/user_turf = get_turf(user)
	var/turf/target_turf = get_turf(target)
	if(!user_turf || !target_turf || user_turf.z != target_turf.z)
		return FALSE
	var/dir_to = get_dir(user, target)
	if(!dir_to)
		return FALSE
	user.dir = dir_to
	step(user, dir_to)
	return get_dist(user, target) <= 1

/datum/action/cooldown/spell/tempest_rush/proc/combo_cleanup(obj/effect/after_image/shadow_left, obj/effect/after_image/shadow_right)
	QDEL_NULL(shadow_left)
	QDEL_NULL(shadow_right)

/datum/action/cooldown/spell/tempest_rush/proc/create_shadows(mob/living/carbon/human/user, mob/living/target)
	var/turf/user_turf = get_turf(user)

	var/obj/effect/after_image/shadow_left = new(user_turf, 0, 0, 0, 0, 0, 0, 0)
	shadow_left.appearance = user.appearance
	shadow_left.pixel_x = -10
	shadow_left.pixel_y = 4
	shadow_left.alpha = 120
	shadow_left.color = "#2a0a3a"
	shadow_left.dir = user.dir
	shadow_left.mouse_opacity = MOUSE_OPACITY_TRANSPARENT
	shadow_left.name = ""

	var/obj/effect/after_image/shadow_right = new(user_turf, 0, 0, 0, 0, 0, 0, 0)
	shadow_right.appearance = user.appearance
	shadow_right.pixel_x = 10
	shadow_right.pixel_y = 4
	shadow_right.alpha = 120
	shadow_right.color = "#2a0a3a"
	shadow_right.dir = user.dir
	shadow_right.mouse_opacity = MOUSE_OPACITY_TRANSPARENT
	shadow_right.name = ""

	return list(shadow_left, shadow_right)

/datum/action/cooldown/spell/tempest_rush/proc/oraora(mob/living/carbon/human/user, mob/living/target)
	user.changeNext_move(CLICK_CD_MELEE * 3)

	var/target_zone = user.zone_selected || BODY_ZONE_CHEST	// Every punch lands where the caster aimed.

	var/list/shadows = create_shadows(user, target)
	var/obj/effect/after_image/shadow_left = shadows[1]
	var/obj/effect/after_image/shadow_right = shadows[2]

	var/combo_broken = FALSE
	var/hit_num = 0
	for(var/set_i in 1 to punch_sets_full)
		if(combo_broken)
			break
		if(!cling(user, target))
			combo_broken = TRUE
			break
		user.emote("attack", forced = TRUE)
		var/turf/new_turf = get_turf(user)
		shadow_left.forceMove(new_turf)
		shadow_right.forceMove(new_turf)
		var/punch_dir = get_dir(user, target)
		var/lunge_px = 0
		var/lunge_py = 0
		if(punch_dir & NORTH)
			lunge_py = 6
		if(punch_dir & SOUTH)
			lunge_py = -6
		if(punch_dir & EAST)
			lunge_px = 6
		if(punch_dir & WEST)
			lunge_px = -6
		for(var/punch_i in 1 to punches_per_set)
			if(!combo_valid(user, target))
				combo_broken = TRUE
				break
			hit_num++
			arcyne_strike(user, target, null, punch_damage, target_zone, BCLASS_BLUNT, spell_name = "Tempest Rush (Punch [hit_num])", exact_zone = TRUE)
			playsound(get_turf(target), pick('sound/combat/hits/punch/punch_hard (1).ogg','sound/combat/hits/punch/punch_hard (2).ogg','sound/combat/hits/punch/punch_hard (3).ogg'), 80, TRUE)
			animate(shadow_left, pixel_x = -10 + lunge_px, pixel_y = 4 + lunge_py, time = 0.5, easing = EASE_OUT)
			animate(pixel_x = -10, pixel_y = 4, time = 0.5, easing = EASE_IN)
			animate(shadow_right, pixel_x = 10 + lunge_px, pixel_y = 4 + lunge_py, time = 0.5, easing = EASE_OUT)
			animate(pixel_x = 10, pixel_y = 4, time = 0.5, easing = EASE_IN)
		sleep(3)

	sleep(3)
	if(!combo_broken && cling(user, target) && combo_valid(user, target))
		user.emote("attack", forced = TRUE)
		arcyne_strike(user, target, null, kick_damage, target_zone, BCLASS_BLUNT, spell_name = "Tempest Rush (Kick)", exact_zone = TRUE)
		playsound(get_turf(target), pick('sound/combat/hits/blunt/genblunt (1).ogg','sound/combat/hits/blunt/genblunt (2).ogg','sound/combat/hits/blunt/genblunt (3).ogg'), 100, TRUE)
		var/atom/throw_target = get_edge_target_turf(user, get_dir(user, target))
		target.throw_at(throw_target, 3, 4)

	combo_cleanup(shadow_left, shadow_right)
	log_combat(user, target, "used Tempest Rush (full)")

/datum/action/cooldown/spell/tempest_rush/proc/oraora_lame(mob/living/carbon/human/user, mob/living/target)
	user.changeNext_move(CLICK_CD_MELEE * 2)

	var/target_zone = user.zone_selected || BODY_ZONE_CHEST

	var/combo_broken = FALSE
	user.emote("attack", forced = TRUE)

	for(var/i in 1 to punch_count_lame)
		if(!combo_valid(user, target))
			combo_broken = TRUE
			break
		arcyne_strike(user, target, null, punch_damage, target_zone, BCLASS_BLUNT, spell_name = "Tempest Rush (Punch [i])", exact_zone = TRUE)
		playsound(get_turf(target), pick('sound/combat/hits/punch/punch_hard (1).ogg','sound/combat/hits/punch/punch_hard (2).ogg','sound/combat/hits/punch/punch_hard (3).ogg'), 80, TRUE)

	sleep(1)
	if(!combo_broken && cling(user, target) && combo_valid(user, target))
		user.emote("attack", forced = TRUE)
		arcyne_strike(user, target, null, kick_damage, target_zone, BCLASS_BLUNT, spell_name = "Tempest Rush (Kick)", exact_zone = TRUE)
		playsound(get_turf(target), pick('sound/combat/hits/blunt/genblunt (1).ogg','sound/combat/hits/blunt/genblunt (2).ogg','sound/combat/hits/blunt/genblunt (3).ogg'), 100, TRUE)
		var/atom/throw_target = get_edge_target_turf(user, get_dir(user, target))
		target.throw_at(throw_target, 3, 4)

	log_combat(user, target, "used Tempest Rush (lame)")
