/datum/action/cooldown/spell/projectile/repel
	name = "Repel"
	desc = "Shoot out a magical bolt that pushes out the target struck away from the caster. If in throw mode, throw your held item with the same force."
	button_icon_state = "fetch"
	cast_range = 10
	sound = 'sound/magic/unmagnet.ogg'

	point_cost = 3
	attunements = list(
		/datum/attunement/aeromancy = 0.4,
	)

	invocation = "Repel!"
	invocation_type = INVOCATION_SHOUT

	charge_time = 3 SECONDS
	charge_drain = 2
	charge_slowdown = 0.3
	cooldown_time = 20 SECONDS
	spell_cost = 30
	spell_flags = SPELL_RITUOS
	projectile_type = /obj/projectile/magic/repel

/obj/projectile/magic/repel
	name = "bolt of repeling"
	icon = 'icons/effects/effects.dmi'
	icon_state = "curseblob"
	range = 15

/obj/projectile/magic/repel/on_hit(target)
	. = ..()
	var/atom/throw_target = get_edge_target_turf(firer, get_dir(firer, target))
	if(ismob(target))
		var/mob/M = target
		if(M.can_block_magic(MAGIC_RESISTANCE) || !firer)
			M.visible_message(span_warning("[src] vanishes on contact with [target]!"))
			return BULLET_ACT_BLOCK
		M.safe_throw_at(throw_target, 7, 4)
		return
	if(isitem(target))
		var/obj/item/I = target
		var/mob/living/carbon/human/carbon_firer
		if(ishuman(firer))
			carbon_firer = firer
			if(carbon_firer?.can_catch_item())
				throw_target = get_edge_target_turf(firer, get_dir(firer, target))
		I.safe_throw_at(throw_target, 7, 4)
