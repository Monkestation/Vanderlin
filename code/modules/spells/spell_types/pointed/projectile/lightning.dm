/datum/action/cooldown/spell/projectile/lightning
	name = "Bolt of Lightning"
	desc = "Emit a bolt of lightning that burns and stuns a target."
	button_icon_state = "lightning"
	sound = 'sound/magic/lightning.ogg'
	charge_sound = 'sound/magic/charging_lightning.ogg'
	sparks_amt = 5

	invocation = "THUNDER STRIKE!!!"
	invocation_type = INVOCATION_SHOUT

	cast_range = 8
	point_cost = 3
	attunements = list(
		/datum/attunement/electric = 0.7,
	)

	charge_time = 3 SECONDS
	charge_drain = 1
	charge_slowdown = 0.7
	cooldown_time = 30 SECONDS
	spell_cost = 40
	spell_flags = SPELL_RITUOS
	projectile_type = /obj/projectile/magic/lightning

/obj/projectile/magic/lightning
	name = "bolt of lightning"
	tracer_type = /obj/effect/projectile/tracer/stun
	hitscan = TRUE
	movement_type = FLYING
	projectile_piercing = PROJECTILE_PIERCE_HIT
	damage = 15
	damage_type = BURN
	nodamage = FALSE
	speed = 0.3
	light_color = "#dbe72c"
	light_outer_range =  7

/obj/projectile/magic/lightning/on_hit(atom/target, blocked, pierce_hit)
	. = ..()
	if(isliving(target))
		var/mob/living/L = target
		L.electrocute_act(1, src)
		L.apply_status_effect(/datum/status_effect/debuff/electrified)
