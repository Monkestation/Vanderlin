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
	abstract_type = /datum/essence_combo
	var/name = "Unknown Combo"
	/// Essence type paths required to activate this combo.
	/// All must be present unless required_count overrides this.
	var/list/required_essences = list()
	/// How many of the required essences must be present.
	/// Defaults to all of them if left null.
	var/required_count = null
	/// If set, only users of this species ID can activate this combo.
	var/required_species = null

/datum/essence_combo/New()
	ASSERT(length(required_essences) > 0)
	validate()

/// Override to perform subtype-specific validation at init time.
/datum/essence_combo/proc/validate()
	return

/// Returns TRUE if all activation conditions are met.
/datum/essence_combo/proc/can_activate(list/available_essences, mob/user)
	var/needed = required_count != null ? required_count : length(required_essences)
	var/matched = 0
	for(var/essence_type in required_essences)
		if(essence_type in available_essences)
			matched++
	if(matched < needed)
		return FALSE

	if(required_species && !user_is_species(user, required_species))
		return FALSE

	return TRUE

/datum/essence_combo/proc/user_is_species(mob/user, species_id)
	if(!ishuman(user))
		return FALSE
	var/mob/living/carbon/human/H = user
	return H.dna?.species?.id == species_id

/// Called when the gauntlet is equipped or vials are updated and this combo is active.
/datum/essence_combo/proc/apply(obj/item/clothing/gloves/essence_gauntlet/gauntlet, mob/living/user)
	return

/// Called when the gauntlet is unequipped or vials are updated.
/// Spell combos do not need to override this, the gauntlet handles bulk spell removal.
/datum/essence_combo/proc/remove(obj/item/clothing/gloves/essence_gauntlet/gauntlet, mob/living/user)
	return
