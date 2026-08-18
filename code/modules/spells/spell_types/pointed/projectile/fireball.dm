/datum/action/cooldown/spell/projectile/fireball
	name = "Fireball"
	desc = "Shoot out a ball of fire that emits a light explosion on impact, setting the target alight."
	button_icon_state = "fireball"
	charge_sound = 'sound/magic/charging_fire.ogg'
	sound = 'sound/magic/fireball.ogg'

	cast_range = 8

	invocation = "ONI SOMA!!!"
	invocation_type = INVOCATION_SHOUT

	charge_time = 2.5 SECONDS
	charge_drain = 1
	charge_slowdown = 0.7
	cooldown_time = 25 SECONDS
	spell_cost = 30
	spell_flags = SPELL_RITUOS
	projectile_type = /obj/projectile/magic/aoe/fireball/rogue

	required_form = FORM_FIRE
	required_technique = TECHNIQUE_DESTRUCTION
	shared_cooldown = FIREBALL_SHARED_COOLDOWN



/datum/action/cooldown/spell/projectile/fireball/ready_projectile(obj/projectile/magic/aoe/fireball/to_fire, atom/target, mob/user, iteration)
	. = ..()
	to_fire.damage *= spell_magnitude_modifier
	to_fire.exp_light *= spell_magnitude_modifier
	to_fire.exp_fire *= spell_magnitude_modifier

/datum/action/cooldown/spell/projectile/fireball/baali
	name = "Infernal Fireball"

	associated_skill = /datum/attribute/skill/magic/blood

	invocation = "CAEDIS DISPLOSIO!!!"

	spell_type = SPELL_BLOOD
	required_form = FORM_BLOOD
	heretical_spell = TRUE

	charge_time = 4 SECONDS
	spell_cost = 150
	cooldown_time = 60 SECONDS

/datum/action/cooldown/spell/projectile/fireball/greater
	name = "Fireball (Greater)"
	desc = "Shoot out an immense ball of fire that explodes on impact."
	button_icon_state = "fireball_greater"

	required_level = 3

	charge_time = 4 SECONDS
	charge_drain = 2
	charge_slowdown = 1.3
	cooldown_time = 35 SECONDS
	spell_cost = 50
	spell_flags = NONE

	projectile_type = /obj/projectile/magic/aoe/fireball/rogue/great

/obj/projectile/magic/aoe/fireball/rogue
	name = "fireball"
	exp_heavy = 0
	exp_light = 3
	exp_flash = 0
	exp_fire = 3
	damage = 10
	damage_type = BURN
	nodamage = FALSE
	flag = "magic"
	hitsound = 'sound/fireball.ogg'
	aoe_range = 0
	speed = 3

/obj/projectile/magic/aoe/fireball/rogue/great
	name = "greater fireball"
	exp_devi = 0
	exp_heavy = 1
	exp_light = 5
	exp_flash = 0
	exp_fire = 4
	exp_hotspot = 0
	speed = 6
