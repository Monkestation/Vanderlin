/datum/mob_affix/armored
	name = "Armored"
	description = "Thick hide reduces incoming damage"
	color = "#888888"

/datum/mob_affix/armored/apply_affix(mob/living/simple_animal/hostile/retaliate/target)
	description = "Reduces incoming damage by [round(25 * intensity)]%"
	RegisterSignal(target, COMSIG_MOB_APPLY_DAMAGE, PROC_REF(armored_damaged))

/datum/mob_affix/armored/proc/armored_damaged(mob/living/simple_animal/hostile/retaliate/source, damage, damagetype, def_zone)
	SIGNAL_HANDLER
	if(damagetype == BRUTE || damagetype == BURN)
		var/reduction = 1 - (0.25 * intensity)
		return max(1, damage * reduction) // Always take at least 1 damage
