
/datum/action/cooldown/meatvine/personal/ground_slam
	name = "Ground Slam"
	desc = "Slam the ground with tremendous force, creating a 5x5 shockwave that knocks down all hostiles. Crushes anyone beneath you for 65 damage to a random body part. Cost: 20 resources."
	button_icon_state = "ground_slam"
	cooldown_time = 20 SECONDS
	personal_resource_cost = 20
	var/slam_range = 2 // 2 range = 5x5 area (center + 2 tiles in each direction)
	var/crush_damage = 65
	var/knockdown_duration = 3 SECONDS
	var/slowdown_duration = 5 SECONDS

/datum/action/cooldown/meatvine/personal/ground_slam/Activate(atom/target)
	var/mob/living/simple_animal/hostile/retaliate/meatvine/user = owner
	if(!istype(user))
		return FALSE

	var/turf/user_turf = get_turf(user)
	if(!user_turf)
		to_chat(user, span_warning("You must be on solid ground to slam!"))
		return FALSE

	user.visible_message(
		span_danger("[user] rears up, preparing to slam the ground!"),
		span_boldnotice("You prepare to slam the ground!")
	)
	animate(user, pixel_y = user.base_pixel_y + 8, time = 0.3 SECONDS)
	sleep(0.3 SECONDS)

	if(QDELETED(user))
		return FALSE

	perform_slam(user, user_turf)

	animate(user, pixel_y = user.base_pixel_y, time = 0.2 SECONDS)

	. = ..()
	return TRUE

/datum/action/cooldown/meatvine/personal/ground_slam/proc/perform_slam(mob/living/simple_animal/hostile/retaliate/meatvine/user, turf/epicenter)
	user.visible_message(
		span_danger("[user] slams the ground with devastating force!"),
		span_boldnotice("You slam the ground!")
	)

	playsound(epicenter, 'sound/misc/meteorimpact.ogg', 80, TRUE)
	playsound(epicenter, 'sound/misc/bamf.ogg', 50, TRUE)
	shake_camera(user, 3, 3)

	for(var/mob/living/victim in epicenter)
		if(victim == user)
			continue

		if(user.faction_check_mob(victim))
			continue // Don't crush allies

		crush_victim(victim, user)

	for(var/turf/affected_turf in range(slam_range, epicenter))
		new /obj/effect/temp_visual/small_smoke/halfsecond(affected_turf)

		for(var/mob/living/target in affected_turf)
			if(target == user)
				continue

			if(user.faction_check_mob(target))
				continue // Don't affect allies

			apply_shockwave(target, user, affected_turf, epicenter)

/datum/action/cooldown/meatvine/personal/ground_slam/proc/crush_victim(mob/living/victim, mob/living/user)
	victim.visible_message(
		span_danger("[victim] is crushed under [user]'s massive weight!"),
		span_userdanger("You are crushed under [user]!")
	)

	var/target_zone = BODY_ZONE_CHEST
	if(ishuman(victim))
		var/static/list/possible_zones = list(
			BODY_ZONE_HEAD,
			BODY_ZONE_CHEST,
			BODY_ZONE_L_ARM,
			BODY_ZONE_R_ARM,
			BODY_ZONE_L_LEG,
			BODY_ZONE_R_LEG
		)
		target_zone = pick(possible_zones)

		var/mob/living/carbon/human/human_victim = victim
		var/obj/item/bodypart/crushed_part = human_victim.get_bodypart(target_zone)
		if(crushed_part)
			to_chat(victim, span_userdanger("Your [crushed_part.name] is crushed!"))

	victim.apply_damage(crush_damage, BRUTE, target_zone)
	victim.Paralyze(4 SECONDS)
	victim.add_splatter_floor()

	shake_camera(victim, 5, 4)

	//playsound(victim, 'sound/effects/splat.ogg', 50, TRUE)

/datum/action/cooldown/meatvine/personal/ground_slam/proc/apply_shockwave(mob/living/target, mob/living/user, turf/target_turf, turf/epicenter)
	var/distance = get_dist(target_turf, epicenter)

	target.Knockdown(knockdown_duration)

	target.apply_status_effect(/datum/status_effect/ground_slam_slow, slowdown_duration)

	var/shake_intensity = max(1, 4 - distance)
	shake_camera(target, shake_intensity, 2)

	to_chat(target, span_danger("The ground shakes violently beneath you!"))
	target.balloon_alert(target, "knocked down!")

	var/shockwave_damage = max(5, 15 - (distance * 3))
	target.apply_damage(shockwave_damage, BRUTE, spread_damage = TRUE)

/datum/action/cooldown/meatvine/personal/ground_slam/evaluate_ai_score(datum/ai_controller/controller)
	var/mob/living/simple_animal/hostile/retaliate/meatvine/user = owner
	if(!istype(user))
		return 0

	var/nearby_enemies = 0
	var/crushed_target = FALSE

	var/turf/user_turf = get_turf(user)

	// Check for crush target (same tile)
	for(var/mob/living/potential_crush in user_turf)
		if(potential_crush != user && !user.faction_check_mob(potential_crush))
			crushed_target = TRUE
			break

	// Count nearby enemies
	for(var/mob/living/enemy in range(slam_range, user))
		if(enemy != user && !user.faction_check_mob(enemy))
			nearby_enemies++

	// Very high priority if we can crush someone
	if(crushed_target)
		return 90

	// High priority if multiple enemies nearby
	if(nearby_enemies >= 3)
		return 75

	// Medium priority if at least 2 enemies
	if(nearby_enemies >= 2)
		return 50

	// Low priority for single enemy
	if(nearby_enemies >= 1)
		return 25

	return 0

/datum/action/cooldown/meatvine/personal/ground_slam/ai_use_ability(datum/ai_controller/controller)
	return Activate(null)

/datum/status_effect/ground_slam_slow
	id = "ground_slam_slow"
	alert_type = /atom/movable/screen/alert/status_effect/ground_slam_slow
	duration = 5 SECONDS
	status_type = STATUS_EFFECT_REFRESH

/datum/status_effect/ground_slam_slow/on_apply()
	. = ..()
	if(!isliving(owner))
		return FALSE

	var/mob/living/target = owner
	target.add_movespeed_modifier("ground_slam_slow", 1.5)
	return TRUE

/datum/status_effect/ground_slam_slow/on_remove()
	if(!isliving(owner))
		return

	var/mob/living/target = owner
	target.remove_movespeed_modifier("ground_slam_slow")
	return ..()

/atom/movable/screen/alert/status_effect/ground_slam_slow
	name = "Shockwave"
	desc = "The ground shook beneath you, slowing your movement!"
	icon_state = "slowed"
