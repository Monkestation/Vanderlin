/datum/action/cooldown/spell/projectile/blood_shard
	name = "Blood Shard"
	desc = "Shoot out rapid shards of crystalline blood."
	button_icon_state =  "unholy_grab"
	sound = 'sound/magic/icicle.ogg'
	charge_sound = 'sound/magic/chargingold.ogg'

	cast_range = 12

	associated_skill = /datum/attribute/skill/magic/blood
	spell_type = SPELL_BLOOD
	required_form = FORM_BLOOD
	heretical_spell = TRUE
	antimagic_flags = MAGIC_RESISTANCE_BLOOD

	invocation = "CAEDIS FRAGMENTUM!!!"
	invocation_type = INVOCATION_SHOUT

	charge_time = 1 SECONDS
	charge_drain = 1
	charge_slowdown = 1.3
	cooldown_time = 5 SECONDS
	spell_cost = 75
	spell_flags = SPELL_UNETCHABLE
	projectile_type = /obj/projectile/magic/energy/bloodshard

/datum/action/cooldown/spell/projectile/blood_shard/ready_projectile(obj/projectile/to_fire, atom/target, mob/user, iteration)
	. = ..()
	to_fire.damage *= spell_magnitude_modifier
	to_fire.armor_penetration *= spell_magnitude_modifier

/obj/projectile/magic/energy/bloodshard
	name = "blood shard"
	icon_state = "blood_bolt"
	damage = 30
	damage_type = BRUTE
	woundclass = BCLASS_CUT
	armor_penetration = 15
	nodamage = FALSE
	flag = "piercing"
	speed = 2
	spread = 4
