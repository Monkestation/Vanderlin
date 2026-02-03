#define SPECIAL_TRAIT(trait_type) GLOB.special_traits[trait_type]

GLOBAL_LIST_INIT(special_traits, build_special_traits())

/proc/build_special_traits()
	. = list()
	for(var/datum/special_trait/type as anything in typesof(/datum/special_trait))
		if(IS_ABSTRACT(type))
			continue
		.[type] = new type()
	return .

/proc/roll_random_special(client/player)
	var/list/eligible_weight = list()
	for(var/trait_type in GLOB.special_traits)
		var/datum/special_trait/special = SPECIAL_TRAIT(trait_type)
		eligible_weight[trait_type] = special.weight

	if(!length(eligible_weight))
		return null

	return pickweight(eligible_weight)

/proc/print_special_text(mob/user, trait_type)
	var/datum/special_trait/special = SPECIAL_TRAIT(trait_type)
	to_chat(user, span_notice("<b>[special.name]</b>"))
	to_chat(user, special.greet_text)
	if(special.req_text)
		to_chat(user, span_boldwarning("Requirements: [special.req_text]"))

/proc/try_apply_character_post_equipment(mob/living/carbon/human/character, client/player)
	var/datum/job/job
	if(character.job)
		job = SSjob.name_occupations[character.job]
	if(!job)
		// Apply the stuff if we dont have a job for some reason
		apply_character_post_equipment(character, player)
		return
	if(length(job.advclass_cat_rolls))
		// Dont apply the stuff, let adv class handler do it later
		return
	// Apply the stuff if we have a job that has no adv classes
	apply_character_post_equipment(character, player)
	apply_loadouts(arglist(args))

/proc/apply_character_post_equipment(mob/living/carbon/human/character, client/player)
	if(!player)
		player = character.client
	apply_prefs_special(character, player)

/proc/apply_prefs_special(mob/living/carbon/human/character, client/player)
	if(!player)
		player = character.client
	if(!player)
		return
	if(!player.prefs)
		return
	var/trait_type = player.prefs.next_special_trait
	if(!trait_type)
		return
	apply_special_trait_if_able(character, player, trait_type)
	player.prefs.next_special_trait = null

/proc/apply_loadouts(mob/living/carbon/human/character, client/player)
	if(!player)
		player = character.client
	if(!player?.prefs)
		return
	for(var/i in 1 to 3)
		if(isnull(player.prefs.vars["loadout[i]"]))
			continue
		character.mind.special_items["[player.prefs.vars["loadout[i]"]:item_path:name]"] = player.prefs.vars["loadout[i]"]:item_path

/proc/apply_special_trait_if_able(mob/living/carbon/human/character, client/player, trait_type)
	if(!charactet_eligible_for_trait(character, player, trait_type))
		log_game("SPECIALS: Failed to apply [trait_type] for [key_name(character)]")
		return FALSE
	log_game("SPECIALS: Applied [trait_type] for [key_name(character)] ([character.get_role_title()])")
	apply_special_trait(character, trait_type)
	return TRUE

/// Applies random special trait IF the client has specials enabled in prefs
/proc/apply_random_special_trait(mob/living/carbon/human/character, client/player)
	if(!player)
		player = character.client
	if(!player)
		return
	var/special_type = get_random_special_for_char(character, player)
	if(!special_type) // Ineligible for all of them, somehow
		return
	apply_special_trait(character, special_type)

/proc/charactet_eligible_for_trait(mob/living/carbon/human/character, client/player, trait_type)
	var/datum/special_trait/special = SPECIAL_TRAIT(trait_type)
	var/datum/job/job = character?.mind.assigned_role
	var/datum/job/parent_job = job?.parent_job
	if(!isnull(special.allowed_jobs))
		if(!job)
			return FALSE
		if(!(job.type in special.allowed_jobs) && !(parent_job?.type in special.allowed_jobs))
			return FALSE
	if(!isnull(special.restricted_jobs) && job && (job.type in special.restricted_jobs))
		return FALSE
	if(!isnull(special.restricted_jobs) && parent_job && (parent_job.type in special.restricted_jobs))
		return FALSE
	if(!isnull(special.allowed_races) && !(character.dna.species.id in special.allowed_races))
		return FALSE
	if(!isnull(special.restricted_races) && (character.dna.species.id in special.restricted_races))
		return FALSE
	if(!isnull(special.allowed_sexes) && !(character.gender in special.allowed_sexes))
		return FALSE
	if(!isnull(special.allowed_ages) && !(character.age in special.allowed_ages))
		return FALSE
	if(!isnull(special.allowed_patrons) && !(character.patron.type in special.allowed_patrons))
		return FALSE
	if(!isnull(special.allowed_flaw) && !character.has_quirk(special.allowed_flaw))
		return FALSE
	if(!isnull(special.restricted_traits))
		var/has_trait
		for(var/trait in special.restricted_traits)
			if(HAS_TRAIT(character, trait))
				has_trait = TRUE
				break
		if(has_trait)
			return FALSE
	if(!special.can_apply(character))
		return FALSE
	return TRUE

/proc/get_random_special_for_char(mob/living/carbon/human/character, client/player)
	var/list/eligible_weight = list()
	for(var/trait_type in GLOB.special_traits)
		var/datum/special_trait/special = SPECIAL_TRAIT(trait_type)
		if(!charactet_eligible_for_trait(character, player, trait_type))
			continue
		eligible_weight[trait_type] = special.weight

	if(!length(eligible_weight))
		return null

	return pickweight(eligible_weight)

/proc/apply_special_trait(mob/living/carbon/human/character, trait_type, silent)
	var/datum/special_trait/special = SPECIAL_TRAIT(trait_type)
	special.on_apply(character, silent)
	if(!silent && special.greet_text)
		to_chat(character, special.greet_text)
