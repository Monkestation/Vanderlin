/datum/ai_behavior/find_and_set/armor
	action_cooldown = 30 SECONDS

/datum/ai_behavior/find_and_set/armor/search_tactic(datum/ai_controller/controller, locate_path, search_range)
	var/mob/living/carbon/living_pawn = controller.pawn


	var/list/armor = list()
	for(var/obj/item/clothing/local_candidate in oview(search_range, controller.pawn))
		if(!istype(local_candidate, /obj/item/clothing))
			continue
		var/obj/item/clothing/clothing = local_candidate
		if(clothing.armor_class != controller.blackboard[BB_ARMOR_CLASS])
			continue
		if(!(living_pawn?.dna?.species?.id in local_candidate.allowed_race))
			continue
		armor += local_candidate
	if(armor.len)
		return pick(armor)

/datum/ai_behavior/find_and_set/armor/atom_allowed(atom/movable/checking, locate_path, atom/pawn)
	if(checking == pawn)
		return FALSE
	if(!istype(checking, /obj/item/clothing))
		return FALSE
	var/obj/item/clothing/clothing = checking
	var/mob/living/carbon/living_pawn = pawn
	var/datum/ai_controller/controller = living_pawn.ai_controller
	if(clothing.armor_class != controller.blackboard[BB_ARMOR_CLASS])
		return FALSE
	if(!(living_pawn?.dna?.species?.id in clothing.allowed_race))
		return FALSE
	return TRUE
