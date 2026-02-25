
#define DUALWIELD_PENALTY_EXTRA_MULTIPLIER 1.4

/obj/item/gun
	abstract_type = /obj/item/gun
	name = "gun"
	desc = "It's a gun. It's pretty terrible, though."
	icon = 'icons/obj/guns/projectile.dmi'
	icon_state = "detective"
	item_state = "gun"
	flags_1 =  CONDUCT_1
	appearance_flags = TILE_BOUND|PIXEL_SCALE|LONG_GLIDE|KEEP_TOGETHER
	slot_flags = ITEM_SLOT_HIP
	w_class = WEIGHT_CLASS_NORMAL
	possible_item_intents = list(INTENT_GENERIC, RANGED_FIRE)
	throwforce = 5
	throw_speed = 3
	throw_range = 5
	force = 5
	item_flags = NEEDS_PERMIT
	attack_verb = list("struck", "hit", "bashed")

	/// Trigger guard on the weapon, hulks can't fire them with their big meaty fingers
	trigger_guard = TRIGGER_GUARD_NORMAL

	// Muzzle Flash
	light_on = FALSE
	light_system = MOVABLE_LIGHT
	light_outer_range = 3
	light_color = LIGHT_COLOR_ORANGE
	light_power = 0.5
	// If we can do the muzzle flash
	var/can_muzzle_flash = TRUE
	/// Muzzle Flash Duration
	var/light_time = 0.1 SECONDS

	/// Currently chambered bullet
	var/obj/item/ammo_casing/chambered = null

	/// Shooting shound
	var/fire_sound = 'sound/blank.ogg'
	/// If playsound has vary
	var/vary_fire_sound = TRUE
	/// Base volume of shooting
	var/fire_sound_volume = 50
	/// Sound when fired without a bullet
	var/dry_fire_sound = 'sound/blank.ogg'
	/// Volume of shooting without a bullet
	var/dry_fire_sound_volume = 30

	/// How large a burst is
	var/burst_size = 1
	/// Delay between shots in a burst.
	var/burst_delay = 2
	/// Delay between bursts (if burst-firing) or individual shots (if weapon is single-fire).
	var/fire_delay = 0 SECONDS
	var/firing_burst = 0 //Prevent the weapon from firing again while already firing
	/// Firing cooldown, true if this gun shouldn't be allowed to manually fire
	var/fire_cd = 0

	/// Just 'slightly' snowflakey way to modify projectile damage for projectiles fired from this gun.
	var/projectile_damage_multiplier = 1
	/// Even snowflakier way to modify projectile wounding bonus/potential for projectiles fired from this gun.
	var/projectile_wound_bonus = 0
	/// The most reasonable way to modify projectile speed values for projectile fired from this gun. Honest.
	/// Lower values are worse, higher values are better.
	var/projectile_speed_multiplier = 1

	/// Inherent spread from the gun itself
	var/spread = 0
	/// Extra random spread, for single fire weapons
	var/randomspread = 1

	/// Screen shake when the weapon is fired
	var/recoil = 0
	/// A multiplier of the duration the recoil takes to go back to normal view, this is (recoil*recoil_backtime_multiplier)+1
	var/recoil_backtime_multiplier = 1.5
	/// This is how much deviation the gun recoil can have, recoil pushes the screen towards the reverse angle you shot + some deviation which this is the max.
	var/recoil_deviation = 20
	/// Used as the min value when calculating recoil
	/// Affected by a player's min_recoil_multiplier preference, so keep in mind it can ultimately be 0 regardless
	/// Often utilized as a "purely visual" form of recoil (as it can be disabled)
	var/min_recoil = 0

	/// X offset of ammo counter
	var/ammo_x_offset = 0
	/// Y offset of ammo counter
	var/ammo_y_offset = 0

	var/automatic = 0 //can gun use it, 0 is no, anything above 0 is the delay between clicks in ds

/obj/item/gun/Destroy()
	if(chambered) //Not all guns are chambered (EMP'ed energy guns etc)
		QDEL_NULL(chambered)
	return ..()

/obj/item/gun/Exited(atom/movable/gone, atom/new_loc)
	. = ..()
	if(gone == chambered)
		chambered = null
		update_appearance()

//called after the gun has successfully fired its chambered ammo.
/obj/item/gun/proc/process_chamber()
	return FALSE

//check if there's enough ammo/energy/whatever to shoot one time
//i.e if clicking would make it shoot
/obj/item/gun/proc/can_shoot()
	return TRUE

/obj/item/gun/proc/shoot_with_empty_chamber(mob/living/user as mob|obj)
	to_chat(user, "<span class='danger'>*click*</span>")
	playsound(src, dry_fire_sound, 30, TRUE)

/obj/item/gun/proc/muzzle_flash_on()
	if (can_muzzle_flash)
		set_light_on(TRUE)
		addtimer(CALLBACK(src, PROC_REF(muzzle_flash_off)), light_time, TIMER_UNIQUE | TIMER_OVERRIDE)
	else
		muzzle_flash_off()

/obj/item/gun/proc/muzzle_flash_off()
	set_light_on(FALSE)

/obj/item/gun/proc/shoot_live_shot(mob/living/user, pointblank = FALSE, mob/pbtarget = null, message = TRUE)
	if(recoil)
		shake_camera(user, recoil + 1, recoil)

	playsound(user, fire_sound, fire_sound_volume, vary_fire_sound)

	if(!message)
		return FALSE

	if(pointblank)
		if(user == pbtarget)
			user.visible_message(
				span_danger("[user] fires [src] point blank at [user.p_them()]self!"),
				span_userdanger("You fire [src] point blank at yourself!"),
				span_hear("You hear a gunshot!"),
				vision_distance = COMBAT_MESSAGE_RANGE,
			)
		else
			user.visible_message(
				span_danger("[user] fires [src] point blank at [pbtarget]!"),
				span_danger("You fire [src] point blank at [pbtarget]!"),
				span_hear("You hear a gunshot!"),
				vision_distance = COMBAT_MESSAGE_RANGE,
				ignored_mobs = pbtarget,
			)
			to_chat(pbtarget, span_userdanger("[user] fires [src] point blank at you!"))
	else
		user.visible_message(
			span_danger("[user] fires [src]!"),
			span_danger("You fire [src]!"),
			span_hear("You hear a gunshot!"),
			vision_distance = COMBAT_MESSAGE_RANGE,
		)

	return TRUE

/obj/item/gun/afterattack(atom/target, mob/living/user, proximity_flag, list/modifiers)
	. = ..()
	if(!target)
		return

	if(!user?.used_intent.tranged) //melee attack
		return

	if(firing_burst)
		return NONE

	if(SEND_SIGNAL(user, COMSIG_MOB_TRYING_TO_FIRE_GUN, src, target, proximity_flag, modifiers) & COMPONENT_CANCEL_GUN_FIRE)
		return NONE

	if(SEND_SIGNAL(src, COMSIG_GUN_TRY_FIRE, user, target, proximity_flag, modifiers) & COMPONENT_CANCEL_GUN_FIRE)
		return NONE

	if(proximity_flag) //It's adjacent, is the user, or is on the user's person
		if(target in user.contents) //can't shoot stuff inside us.
			return
		if(!ismob(target)) //melee attack
			return
		if(target == user && user.zone_selected != BODY_ZONE_PRECISE_MOUTH) //so we can't shoot ourselves (unless mouth selected)
			return

	if(istype(user))//Check if the user can use the gun, if the user isn't alive(turrets) assume it can.
		var/mob/living/L = user
		if(!can_trigger_gun(L))
			return

	if(!can_shoot()) //Just because you can pull the trigger doesn't mean it can shoot.
		shoot_with_empty_chamber(user)
		return

	return process_fire(target, user, TRUE, modifiers, null, 0)

/obj/item/gun/proc/recharge_newshot()
	return


/obj/item/gun/proc/process_burst(mob/living/user, atom/target, message = TRUE, list/modifiers, zone_override, random_spread = 0, burst_spread_mult = 0, iteration = 0)
	if(!user || !firing_burst)
		firing_burst = FALSE
		return FALSE

	if(iteration > 1 && !(user.is_holding(src))) //for burst firing
		firing_burst = FALSE
		return FALSE

	if(chambered?.loaded_projectile)
		if(HAS_TRAIT(user, TRAIT_PACIFISM)) // If the user has the pacifist trait, then they won't be able to fire [src] if the round chambered inside of [src] is lethal.
			if(chambered.harmful) // Is the bullet chambered harmful?
				to_chat(user, span_warning("[src] is lethally chambered! You don't want to risk harming anyone..."))
				firing_burst = FALSE
				return FALSE
		var/sprd
		if(randomspread)
			sprd = round((rand(0, 1) - 0.5) * DUALWIELD_PENALTY_EXTRA_MULTIPLIER * (random_spread))
		else //Smart spread
			sprd = round((((burst_spread_mult/burst_size) * iteration) - (0.5 + (burst_spread_mult * 0.25))) * (random_spread))

		before_firing(target,user)

		if(!chambered.fire_casing(target, user, modifiers, 0, FALSE, zone_override, sprd, src))
			shoot_with_empty_chamber(user)
			firing_burst = FALSE
			return FALSE
		else
			if(get_dist(user, target) <= 1) //Making sure whether the target is in vicinity for the pointblank shot
				shoot_live_shot(user, TRUE, target, message)
			else
				shoot_live_shot(user, FALSE, target, message)
			if(iteration >= burst_size)
				firing_burst = FALSE
	else
		shoot_with_empty_chamber(user)
		firing_burst = FALSE
		return FALSE

	process_chamber()
	update_appearance()
	return TRUE

/**
 * Calculates the final recoil value applied when firing a gun.
 *
 * Arguments:
 * * user - The living mob attempting to fire the gun. Used for preference lookups.
 * * recoil_amount - The raw recoil value to be processed before clamping.
 *
 * Returns:
 * The clamped recoil value after applying all modifiers.
 */
/obj/item/gun/proc/calculate_recoil(mob/living/user, recoil_amount = 0)
	return clamp(recoil_amount, min_recoil, INFINITY)

/**
 * Simulates firearm recoil and applies camera feedback when firing.
 *
 * Arguments:
 * * user - The mob firing the gun. Used for recoil calculation and camera shake.
 * * recoil_amount - The base recoil value before modifiers.
 * * firing_angle - The firing direction used to determine camera kick direction.
 */
/obj/item/gun/proc/simulate_recoil(mob/living/user, recoil_amount = 0, firing_angle)
	var/total_recoil = calculate_recoil(user, recoil_amount)

	var/actual_angle = firing_angle + rand(-recoil_deviation, recoil_deviation) + 180
	if(actual_angle > 360)
		actual_angle -= 360

	if(total_recoil > 0)
		user.recoil_camera(total_recoil + 1, (total_recoil * recoil_backtime_multiplier) + 1, total_recoil, actual_angle)

/obj/item/gun/proc/process_fire(atom/target, mob/living/user, message = TRUE, list/modifiers, zone_override, bonus_spread = 0)
	if(fire_cd)
		return FALSE

	if(user)
		SEND_SIGNAL(user, COMSIG_MOB_FIRED_GUN, src, target, modifiers, zone_override)

	SEND_SIGNAL(src, COMSIG_GUN_FIRED, user, target, modifiers, zone_override)

	add_fingerprint(user)

	var/randomized_bonus_spread = rand(0, bonus_spread)
	var/randomized_gun_spread = spread ? rand(0, spread) : 0
	var/total_random_spread = max(0, randomized_bonus_spread + randomized_gun_spread)
	var/burst_spread_mult = rand()

	if(burst_size > 1)
		firing_burst = TRUE
		fire_cd = TRUE
		for(var/i = 1 to burst_size)
			addtimer(CALLBACK(src, PROC_REF(process_burst), user, target, message, modifiers, zone_override, total_random_spread, burst_spread_mult, i), burst_delay * (i - 1))
			addtimer(CALLBACK(src, PROC_REF(reset_fire_cd)), fire_delay) // for the case of fire delay longer than burst
	else
		if(!chambered)
			shoot_with_empty_chamber(user)
			return FALSE

		if(HAS_TRAIT(user, TRAIT_PACIFISM)) // If the user has the pacifist trait, then they won't be able to fire [src] if the round chambered inside of [src] is lethal.
			if(chambered.harmful) // Is the bullet chambered harmful?
				to_chat(user, span_warning("[src] is lethally chambered! You don't want to risk harming anyone..."))
				return FALSE

		var/sprd = round((rand(0, 1) - 0.5) * DUALWIELD_PENALTY_EXTRA_MULTIPLIER * total_random_spread)
		before_firing(target, user)

		if(!chambered.fire_casing(target, user, modifiers, 0, FALSE, zone_override, sprd, src))
			shoot_with_empty_chamber(user)
			return FALSE
		else if(get_dist(user, target) <= 1) //Making sure whether the target is in vicinity for the pointblank shot
			shoot_live_shot(user, TRUE, target, message)
		else
			shoot_live_shot(user, FALSE, target, message)

		process_chamber()
		update_appearance()

		fire_cd = TRUE
		addtimer(CALLBACK(src, PROC_REF(reset_fire_cd)), fire_delay)

	if(user)
		user.update_inv_hands()

	SSblackbox.record_feedback("tally", "gun_fired", 1, type)

	return TRUE

/obj/item/gun/proc/reset_fire_cd()
	fire_cd = FALSE

//Happens before the actual projectile creation
/obj/item/gun/proc/before_firing(atom/target,mob/user)
	return

/obj/item/gun/get_examine_string(mob/user, thats = FALSE)
	return "[thats? "That's ":""]<b>[get_examine_name(user)]</b>"

#undef DUALWIELD_PENALTY_EXTRA_MULTIPLIER
