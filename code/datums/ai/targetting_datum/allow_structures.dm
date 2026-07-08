/// Subtype which also allows attacking destructible structures (walls, barricades, etc)
/datum/targetting_datum/basic/allow_structures/can_attack(mob/living/living_mob, atom/the_target)
	if(isturf(the_target) || !the_target)
		return FALSE
	var/mob/living/simple_animal/attacker = living_mob
	if(istype(attacker))
		if(attacker.binded == TRUE)
			return FALSE
	if(ismob(the_target))
		var/mob/M = the_target
		if(M.status_flags & GODMODE)
			return FALSE
	if(living_mob.see_invisible < the_target.invisibility)
		return FALSE
	if(HAS_TRAIT(the_target, TRAIT_IMPERCEPTIBLE))
		return FALSE
	if(!isturf(the_target.loc))
		return FALSE
	if(isliving(the_target))
		var/mob/living/L = the_target
		if(faction_check(living_mob, L) || L.stat >= DEAD)
			return FALSE
		return TRUE
	if(isobj(the_target))
		var/obj/structure_target = the_target
		if(!structure_target.density)
			return FALSE
		if(structure_target.resistance_flags & INDESTRUCTIBLE)
			return FALSE
		return TRUE
	return FALSE
