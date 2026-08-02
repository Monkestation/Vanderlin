/**
 * Configurable ranged attack for basic mobs.
 */
/datum/component/ranged_attacks
	/// What kind of casing do we use to fire?
	var/casing_type
	/// What kind of projectile to we fire? Use only one of this or casing_type
	var/projectile_type
	/// Sound to play when we fire our projectile
	var/projectile_sound
	/// how many shots we will fire
	var/burst_shots
	/// intervals between shots
	var/burst_intervals
	/// Time to wait between shots
	var/cooldown_time
	/// Tracks time between shots
	COOLDOWN_DECLARE(fire_cooldown)
	/// Visible message when firing
	var/ranged_message

/datum/component/ranged_attacks/Initialize(
	casing_type,
	projectile_type,
	projectile_sound = 'sound/blank.ogg',
	burst_shots,
	burst_intervals = 0.2 SECONDS,
	cooldown_time = 3 SECONDS,
	ranged_message,
)
	. = ..()
	if(!istype(parent, /mob/living/simple_animal))
		return COMPONENT_INCOMPATIBLE

	src.casing_type = casing_type
	src.projectile_sound = projectile_sound
	src.projectile_type = projectile_type
	src.cooldown_time = cooldown_time
	src.ranged_message = ranged_message

	if (casing_type && projectile_type)
		CRASH("Set both casing type and projectile type in [parent]'s ranged attacks component! uhoh! stinky!")
	if (!casing_type && !projectile_type)
		CRASH("Set neither casing type nor projectile type in [parent]'s ranged attacks component! What are they supposed to be attacking with, air?")
	if(burst_shots <= 1)
		return
	src.burst_shots = burst_shots
	src.burst_intervals = burst_intervals

/datum/component/ranged_attacks/RegisterWithParent()
	. = ..()
	RegisterSignal(parent, COMSIG_MOB_ATTACK_RANGED, PROC_REF(fire_ranged_attack))

/datum/component/ranged_attacks/UnregisterFromParent()
	. = ..()
	UnregisterSignal(parent, COMSIG_MOB_ATTACK_RANGED)

/datum/component/ranged_attacks/proc/fire_ranged_attack(mob/living/simple_animal/firer, atom/target, list/modifiers)
	SIGNAL_HANDLER
	if(!COOLDOWN_FINISHED(src, fire_cooldown))
		return
	COOLDOWN_START(src, fire_cooldown, cooldown_time)
	firer.visible_message(span_danger("<b>[firer]</b> [ranged_message] at [target]!</span>"))
	INVOKE_ASYNC(src, PROC_REF(async_fire_ranged_attack), firer, target, modifiers)
	if(isnull(burst_shots))
		return
	for(var/i in 1 to (burst_shots - 1))
		addtimer(CALLBACK(src, PROC_REF(async_fire_ranged_attack), firer, target, modifiers), i * burst_intervals)

/// Actually fire the damn thing
/datum/component/ranged_attacks/proc/async_fire_ranged_attack(mob/living/simple_animal/firer, atom/target, list/modifiers)
	firer.face_atom(target)
	if(projectile_type)
		firer.fire_projectile(projectile_type, target, projectile_sound)
		SEND_SIGNAL(parent, COMSIG_MOB_POSTATTACK_RANGED, target, modifiers)
		return
	playsound(firer, projectile_sound, 100, TRUE)
	var/turf/startloc = get_turf(firer)
	var/obj/item/ammo_casing/casing = new casing_type(startloc)
	var/target_zone
	if(ismob(target))
		var/mob/target_mob = target
		target_zone = target_mob.get_random_valid_zone()
	else
		target_zone = ran_zone()
	casing.fire_casing(target, firer, null, null, null, target_zone, 0,  firer)
	SEND_SIGNAL(parent, COMSIG_MOB_POSTATTACK_RANGED, target, modifiers)
	return

/mob/proc/get_random_valid_zone(base_zone, base_probability = 80, list/blacklisted_parts, even_weights, bypass_warning)
	return BODY_ZONE_CHEST //even though they don't really have a chest, let's just pass the default of check_zone to be safe.


/mob/living/carbon/get_random_valid_zone(base_zone, base_probability = 80, list/blacklisted_parts, even_weights, bypass_warning)
	var/list/limbs = list()
	for(var/obj/item/bodypart/part as anything in bodyparts)
		var/limb_zone = part.body_zone //cache the zone since we're gonna check it a ton.
		if(limb_zone in blacklisted_parts)
			continue
		if(even_weights)
			limbs[limb_zone] = 1
			continue
		if(limb_zone == BODY_ZONE_CHEST || limb_zone == BODY_ZONE_HEAD)
			limbs[limb_zone] = 1
		else
			limbs[limb_zone] = 4

	if(base_zone && !(check_zone(base_zone) in limbs))
		base_zone = null //check if the passed zone is infact valid

	var/chest_blacklisted
	if((BODY_ZONE_CHEST in blacklisted_parts))
		chest_blacklisted = TRUE
		if(bypass_warning && !limbs.len)
			CRASH("limbs is empty and the chest is blacklisted. this may not be intended!")
	return (((chest_blacklisted && !base_zone) || even_weights) ? pickweight(limbs) : ran_zone(base_zone, base_probability, limbs))
