/datum/action/cooldown/spell/projectile/fire_flare
	name = "Fire Flare"
	desc = "Shoot out a low-powered ball of fire that shines brightly on impact, potentially blinding a target."
	button_icon_state = "fireball_multi"
	sound = 'sound/magic/whiteflame.ogg'
	charge_sound = 'sound/magic/charging_fire.ogg'

	point_cost = 3
	attunements = list(
		/datum/attunement/fire = 0.3,
	)

	charge_time = 2 SECONDS
	charge_drain = 1
	charge_slowdown = 0.7
	cooldown_time = 15 SECONDS
	spell_cost = 40
	spell_flags = SPELL_RITUOS
	projectile_type = /obj/projectile/magic/aoe/fireball/flare

/datum/action/cooldown/spell/projectile/fire_flare/ready_projectile(obj/projectile/magic/aoe/fireball/to_fire, atom/target, mob/user, iteration)
	. = ..()
	to_fire.damage *= attuned_strength
	to_fire.exp_flash *= attuned_strength

/obj/projectile/magic/aoe/fireball/flare
	name = "spitfire"
	exp_heavy = 0
	exp_light = 0
	exp_flash = 1
	exp_fire = 0
	speed = 2.5
