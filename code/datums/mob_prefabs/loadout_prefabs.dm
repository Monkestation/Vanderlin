/// Gives a loadout and complimentary traits
/datum/mob_prefab/loadout
	abstract_type = /datum/mob_prefab/loadout

	/// a path to an outfit
	var/outfit
	/// any traits we want to give
	var/list/traits
	/// blackboard info
	var/ai_armorclass = 0

/datum/mob_prefab/loadout/assign_prefab(mob/living/carbon/human/target)
	. = ..()
	if(!. || !ishuman(target))
		return
	if(ispath(outfit, /datum/outfit))
		target.equipOutfit(new outfit())
	for(var/T in traits)
		ADD_TRAIT(target, T, "[type]")
	// these are useful for mappers so they go on everyone
	ADD_TRAIT(target, TRAIT_HEAVYARMOR, TRAIT_GENERIC)
	ADD_TRAIT(target, TRAIT_MEDIUMARMOR, TRAIT_GENERIC)
	ADD_TRAIT(target, TRAIT_LIGHT_STEP, TRAIT_GENERIC)
	target.ai_controller?.set_blackboard_key(BB_ARMOR_CLASS, ai_armorclass)


/datum/mob_prefab/loadout/light
	outfit = /datum/outfit/npc/light_gear
	traits = list(TRAIT_DODGEEXPERT)
	ai_armorclass = 1

/datum/mob_prefab/loadout/light/dualwield
	traits = list(TRAIT_DODGEEXPERT, TRAIT_DUALWIELDER)


/datum/mob_prefab/loadout/medium
	outfit = /datum/outfit/npc/medium_gear
	ai_armorclass = 2


/datum/mob_prefab/loadout/heavy
	outfit = /datum/outfit/npc/heavy_gear
	ai_armorclass = 3
