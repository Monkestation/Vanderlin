/datum/action/cooldown/meatvine/personal/crushing_sweep
	name = "Crushing Sweep"
	desc = "Sweep your appendages in a wide arc, crushing and throwing back nearby enemies."
	button_icon_state = "crush_tail"
	cooldown_time = 60 SECONDS
	personal_resource_cost = 25
	/// Radius of the sweep effect
	var/sweep_radius = 1
	/// How long mobs hit should be knocked down for
	var/knockdown_time = 4 SECONDS
	/// How much damage the sweep should do
	var/sweep_damage = 30
	/// Max throw distance
	var/max_throw = 3
	/// Sound to play on impact
	var/impact_sound = 'sound/blank.ogg'

/datum/action/cooldown/meatvine/personal/crushing_sweep/Activate(atom/target)
	. = ..()
	if(!.)
		return FALSE

	var/mob/living/simple_animal/hostile/retaliate/meatvine/consumed = owner
	playsound(consumed, 'sound/misc/tail_swing.ogg', 80, TRUE)
	consumed.spin(6, 1)

	for(var/mob/living/victim in range(sweep_radius, consumed))
		if(victim == consumed)
			continue
		if(istype(victim, /mob/living/simple_animal/hostile/retaliate/meatvine))
			continue

		sweep_victim(victim, consumed)

	return TRUE

/datum/action/cooldown/meatvine/personal/crushing_sweep/proc/sweep_victim(mob/living/victim, atom/caster)
	var/turf/throwtarget = get_edge_target_turf(caster, get_dir(caster, get_step_away(victim, caster)))
	var/dist_from_caster = get_dist(victim, caster)

	if(dist_from_caster <= 0)
		victim.Knockdown(knockdown_time)
	else
		victim.Knockdown(knockdown_time * 2)

	victim.apply_damage(sweep_damage, BRUTE, BODY_ZONE_CHEST)
	shake_camera(victim, 4, 3)
	playsound(victim, impact_sound, 100, TRUE, 8, 0.9)
	to_chat(victim, span_userdanger("[caster]'s appendages slam into you, throwing you back!"))
	victim.safe_throw_at(throwtarget, ((clamp((max_throw - (clamp(dist_from_caster - 2, 0, dist_from_caster))), 3, max_throw))), 1, caster, force = MOVE_FORCE_EXTREMELY_STRONG)

/datum/action/cooldown/meatvine/personal/crushing_sweep/evaluate_ai_score(datum/ai_controller/controller)
	var/mob/living/simple_animal/hostile/retaliate/meatvine/consumed = owner
	var/nearby_enemies = 0

	for(var/mob/living/potential_target in range(sweep_radius, consumed))
		if(potential_target == consumed)
			continue
		if(istype(potential_target, /mob/living/simple_animal/hostile/retaliate/meatvine))
			continue
		if(can_see(consumed, potential_target))
			nearby_enemies++

	// Higher score if multiple enemies nearby
	return nearby_enemies * 15

/datum/action/cooldown/meatvine/personal/crushing_sweep/ai_use_ability(datum/ai_controller/controller)
	return Activate(null)
