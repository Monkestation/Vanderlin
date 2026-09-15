/datum/action/cooldown/spell/projectile/arcyne_bolt
	name = "Arcyne Bolt"
	desc = "Shoot out rapid bolts of arcyne power."
	button_icon_state =  "arcane_bolt"
	sound = 'sound/magic/vlightning.ogg'

	cast_range = 12

	required_form = FORM_ARCANE

	invocation = "MAGIC MISSILE!!!"
	invocation_type = INVOCATION_SHOUT

	charge_time = 1 SECONDS
	charge_drain = 1
	charge_slowdown = 1.3
	cooldown_time = 5 SECONDS
	spell_cost = 20
	spell_flags = SPELL_RITUOS
	projectile_type = /obj/projectile/magic/energy/rogue3

/datum/action/cooldown/spell/projectile/arcyne_bolt/ready_projectile(obj/projectile/to_fire, atom/target, mob/user, iteration)
	. = ..()
	to_fire.damage *= spell_magnitude_modifier
	to_fire.armor_penetration *= spell_magnitude_modifier

/obj/projectile/magic/energy/rogue3
	name = "arcyne bolt"
	icon_state = "arcane_barrage"
	damage = 30
	damage_type = BRUTE
	woundclass = BCLASS_BLUNT
	armor_penetration = 10
	nodamage = FALSE
	flag = "piercing"
	speed = 2
	spread = 4
