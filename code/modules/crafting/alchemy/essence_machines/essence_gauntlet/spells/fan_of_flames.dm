/datum/action/cooldown/spell/essence/fan_of_flames
	name = "Fan of Flames"
	desc = "Unleash a spreading fan of slow-moving flame projectiles."
	school = "evocation"
	button_icon_state = "sacredflame"
	spell_cost = 4
	cooldown_time = 45 SECONDS
	point_cost = 4
	attunements = list(/datum/attunement/fire, /datum/attunement/aeromancy)
	essences = list(/datum/thaumaturgical_essence/fire, /datum/thaumaturgical_essence/air)
	click_to_activate = TRUE
	/// Projectile type to fire
	var/obj/projectile/magic/projectile_type = /obj/projectile/magic/fan_of_flames
	/// Number of projectiles in the fan
	var/projectiles_per_fire = 10
	/// Angle between each projectile in the fan
	var/fan_spread_angle = 5

/datum/action/cooldown/spell/essence/fan_of_flames/cast(atom/cast_on)
	. = ..()
	if(!isturf(owner.loc))
		return FALSE
	fire_projectile(cast_on)
	return TRUE

/datum/action/cooldown/spell/essence/fan_of_flames/proc/fire_projectile(atom/target)
	for(var/i in 1 to projectiles_per_fire)
		var/obj/projectile/to_fire = new projectile_type()
		ready_projectile(to_fire, target, owner, i)
		to_fire.fire()
	return TRUE

/datum/action/cooldown/spell/essence/fan_of_flames/proc/ready_projectile(obj/projectile/to_fire, atom/target, mob/user, iteration)
	var/center_offset = (projectiles_per_fire - 1) / 2
	var/spread = (iteration - 1 - center_offset) * fan_spread_angle
	to_fire.firer = owner
	to_fire.fired_from = get_turf(owner)
	to_fire.preparePixelProjectile(target, owner, spread = spread)
	if(istype(to_fire, /obj/projectile/magic))
		var/obj/projectile/magic/magic_to_fire = to_fire
		magic_to_fire.antimagic_flags = antimagic_flags

/obj/projectile/magic/fan_of_flames
	name = "flame bolt"
	icon = 'icons/obj/projectiles.dmi'
	icon_state = "blastwave"
	damage = 5
	damage_type = BURN
	speed = 1 SECONDS
	homing = FALSE
	range = 3
