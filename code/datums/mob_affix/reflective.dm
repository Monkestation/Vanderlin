/datum/mob_affix/reflective
	name = "Reflective"
	description = "Reflects damage back to attackers"
	color = "#CCCCFF"
	var/last_damage

/datum/mob_affix/reflective/apply_affix(mob/living/simple_animal/hostile/retaliate/target)
	description = "Reflects [round(30 * intensity)]% damage back to attackers"
	RegisterSignal(target, COMSIG_MOB_APPLY_DAMGE, PROC_REF(reflective_damaged))

/datum/mob_affix/reflective/proc/reflective_damaged(mob/living/simple_animal/hostile/retaliate/source, damage, damagetype, def_zone)
	SIGNAL_HANDLER
	if(world.time < last_damage)
		return
	if(damagetype == BRUTE)
		var/reflect_damage = round(damage * (0.3 * intensity))
		last_damage = world.time + 10 SECONDS
		for(var/mob/living/M in range(1, source))
			if(M != source && !faction_check(source.faction, M.faction) && !(M in SSmatthios_mobs.matthios_mobs))
				M.apply_damage(reflect_damage, BRUTE)
				M.visible_message(span_warning("[M] is hurt by [source]'s reflective hide!"))
				break // Only reflect to one nearby enemy

/obj/effect/temp_visual/retaliate
	icon = 'icons/effects/96x96.dmi'
	icon_state = "retaliate"
	duration = 0.7 SECONDS
