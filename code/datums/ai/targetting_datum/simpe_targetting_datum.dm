///Datum for basic mobs to define what they can attack.
/datum/targetting_datum

///Returns true or false depending on if the target can be attacked by the mob
/datum/targetting_datum/proc/can_attack(mob/living/living_mob, atom/target)
	return

///Returns something the target might be hiding inside of
/datum/targetting_datum/proc/find_hidden_mobs(mob/living/living_mob, atom/target)
	var/atom/target_hiding_location
	if(istype(target.loc, /obj/structure/closet))
		target_hiding_location = target.loc
	return target_hiding_location

/datum/targetting_datum/basic

/datum/targetting_datum/basic/can_attack(mob/living/living_mob, atom/the_target)
	if(isturf(the_target) || !the_target ) // bail out on invalids
		return FALSE
	var/mob/living/simple_animal/attacker = living_mob
	if(istype(attacker))
		if(attacker.binded == TRUE)
			return FALSE

	if(ismob(the_target)) //Target is in godmode, ignore it.
		var/mob/M = the_target
		if(M.status_flags & GODMODE)
			return FALSE

	if(living_mob.see_invisible < the_target.invisibility)//Target's invisible to us, forget it
		return FALSE

	if(HAS_TRAIT(the_target, TRAIT_IMPERCEPTIBLE))
		return FALSE

	if(!isturf(the_target.loc))
		return FALSE

	if(isliving(the_target)) //Targetting vs living mobs
		var/mob/living/L = the_target
		if(faction_check(living_mob, L) || L.stat >= DEAD) //basic targetting doesn't target dead people
			return FALSE
		return TRUE

	return FALSE

/datum/targetting_datum/basic/proc/faction_check(mob/living/living_mob, mob/living/the_target)
	if((living_mob in SSmatthios_mobs.matthios_mobs) && (the_target in SSmatthios_mobs.matthios_mobs))
		return TRUE
	return living_mob.faction_check_mob(the_target, exact_match = FALSE)

/// Subtype which doesn't care about faction
/// Mobs which retaliate but don't otherwise target seek should just attack anything which annoys them
/datum/targetting_datum/basic/ignore_faction

/datum/targetting_datum/basic/ignore_faction/faction_check(mob/living/living_mob, mob/living/the_target)
	return FALSE

/datum/targetting_datum/basic/zizoid/can_attack(mob/living/living_mob, atom/the_target)
	if(isliving(the_target))
		var/mob/living/target = the_target
		if(target.mind?.has_antag_datum(/datum/antagonist/zizocultist))
			return FALSE
	. = ..()
