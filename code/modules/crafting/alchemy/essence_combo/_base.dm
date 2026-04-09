GLOBAL_LIST_INIT(essence_combos, init_essence_combos())

/proc/init_essence_combos()
	var/list/combos = list()
	for(var/datum/essence_combo/combo_type as anything in subtypesof(/datum/essence_combo))
		if(IS_ABSTRACT(combo_type))
			continue
		combos += new combo_type()
	return combos

/proc/get_available_essence_combos(list/available_essences, mob/user)
	var/list/available_combos = list()
	for(var/datum/essence_combo/combo in GLOB.essence_combos)
		if(combo.can_activate(available_essences, user))
			available_combos += combo
	return available_combos

/datum/essence_combo
	var/name = "Base Combo"
	var/list/required_essences = list() // List of essence type paths
	var/required_race = null // Optional race requirement
	var/required_minimum_essences = 0 // How many of the required essences must be present (default: all)

/datum/essence_combo/New()
	if(!length(required_essences))
		stack_trace("Essence combo [type] has no required essences!")
	validate_combo()

/datum/essence_combo/proc/validate_combo()
	// Override in subtypes to validate their specific requirements
	return

/datum/essence_combo/proc/can_activate(list/available_essences, mob/user)
	// Check essence requirements
	var/matching_essences = 0
	for(var/essence_type in required_essences)
		if(essence_type in available_essences)
			matching_essences++

	if(required_minimum_essences)
		if(matching_essences < required_minimum_essences)
			return FALSE
	else
		if(length(required_essences) != matching_essences)
			return FALSE

	// Check race requirement if any
	if(required_race)
		var/user_race = get_user_race(user)
		if(user_race != required_race)
			return FALSE

	return TRUE

/datum/essence_combo/proc/get_user_race(mob/user)
	if(!ishuman(user))
		return null
	var/mob/living/carbon/human/human_user = user
	return human_user.dna?.species?.id

// Base proc for applying combo effects - override in subtypes
/datum/essence_combo/proc/apply_effects(obj/item/clothing/gloves/essence_gauntlet/gauntlet, mob/user)
	return

// Base proc for removing combo effects - override in subtypes
/datum/essence_combo/proc/remove_effects(obj/item/clothing/gloves/essence_gauntlet/gauntlet, mob/user)
	return
