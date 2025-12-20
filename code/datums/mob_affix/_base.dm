/datum/mob_affix
	var/name = "Unknown Affix"
	var/description = "A mysterious enhancement"
	var/color = "#FFFFFF"
	var/intensity = 1.0
	var/delve_level = 1

/datum/mob_affix/proc/apply_affix(mob/living/simple_animal/hostile/retaliate/target)
	return

/datum/mob_affix/proc/on_attack(mob/living/simple_animal/hostile/retaliate/attacker, atom/target)
	return

/datum/mob_affix/proc/on_death(mob/living/simple_animal/hostile/retaliate/target)
	return

/datum/mob_affix/proc/cleanup_affix(mob/living/simple_animal/hostile/retaliate/target)
	return
