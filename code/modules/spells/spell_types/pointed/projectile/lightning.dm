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

	required_form = FORM_LIGHTNING
	required_technique = TECHNIQUE_DESTRUCTION

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

/obj/projectile/magic/lightning/on_hit(target)
	. = ..()
	if(ismob(target))
		var/mob/M = target
		if(M.can_block_magic())
			visible_message(span_warning("[src] fizzles on contact with [target]!"))
			playsound(get_turf(target), 'sound/magic/magic_nulled.ogg', 100)
			qdel(src)
			return BULLET_ACT_BLOCK
		if(isliving(target))
			var/mob/living/L = target
			if(out_of_effective_range())
				return
			L.lightning_shock(src)
	else if(isatom(target))
		var/atom/A = target
		A.fire_act()
	qdel(src)
