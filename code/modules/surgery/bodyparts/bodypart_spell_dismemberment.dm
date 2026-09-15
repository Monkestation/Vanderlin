/obj/item/bodypart/proc/get_spell_dismemberment_chance(force, bclass, zone_precise = src.body_zone)
	if(!can_dismember())
		return 0
	if(bclass != BCLASS_CUT && bclass != BCLASS_CHOP)
		return 0
	if(bclass == BCLASS_CHOP)
		force *= 1.1
	return dismemberment_chance_from_force(force, zone_precise)

/obj/item/bodypart/proc/dismemberment_chance_from_force(nuforce, zone_precise = src.body_zone)
	if(nuforce < 10)
		return 0
	var/total_dam = get_damage()
	var/probability = nuforce * (total_dam / max_damage)
	var/hard_dismember = HAS_TRAIT(src, TRAIT_HARDDISMEMBER)
	var/easy_dismember = HAS_TRAIT(src, TRAIT_ROTTEN) || skeletonized || HAS_TRAIT(src, TRAIT_EASYDISMEMBER)
	var/easy_decapitation = HAS_TRAIT(src, TRAIT_EASYDISMEMBER)
	if(owner)
		if(!hard_dismember)
			hard_dismember = HAS_TRAIT(owner, TRAIT_HARDDISMEMBER)
		if(!easy_dismember)
			easy_dismember = HAS_TRAIT(owner, TRAIT_EASYDISMEMBER)
		if(!easy_decapitation)
			easy_decapitation = HAS_TRAIT(owner, TRAIT_EASYDISMEMBER)
	if((total_dam <= (max_damage * 0.7)) && !easy_dismember)
		return 0
	if(easy_decapitation && zone_precise == BODY_ZONE_PRECISE_NECK)
		return probability * 1.5
	if(hard_dismember)
		return min(probability, 5)
	else if(easy_dismember)
		return probability * 1.5
	return probability
