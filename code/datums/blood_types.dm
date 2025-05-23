GLOBAL_LIST_INIT_TYPED(blood_types, /datum/blood_type, init_subtypes_w_path_keys(/datum/blood_type))


/**
 * Blood Types
 *
 * Singleton datums which represent, well, blood inside someone
 */
/datum/blood_type
	/// The short-hand name of the blood type
	var/name = "?"
	///this is the color of our blood
	var/color = LIGHT_COLOR_LIGHT_CYAN
	/// What blood types can this type receive from
	/// Itself is always included in this list
	var/list/compatible_types = list()
	/// What reagent is represented by this blood type?
	var/datum/reagent/reagent_type = /datum/reagent/blood
	/// What chem is used to restore this blood type (outside of itself, of course)?
	var/datum/reagent/restoration_chem
	///do we contain Lux?
	var/contains_lux = FALSE

/datum/blood_type/New()
	. = ..()
	compatible_types |= type


/// Gets data to pass to a reagent
/datum/blood_type/proc/get_blood_data(mob/living/sampled_from)
	return null

/**
 * Used to handle any unique facets of blood spawned of this blood type
 *
 * Arguments
 * * blood - the blood being set up
 * * new_splat - whether this is a newly instantiated blood decal, or an existing one this blood is being added to
 */
/datum/blood_type/proc/set_up_blood(obj/effect/decal/cleanable/blood/blood, new_splat = FALSE)
	return

/// A base type for all blood used by humans (NOT humanoids), for organization's sake
/datum/blood_type/human
	contains_lux = TRUE

/datum/blood_type/human/get_blood_data(mob/living/carbon/sampled_from)
	if(!istype(sampled_from) || isnull(sampled_from.dna))
		return ..()

	var/list/blood_data = list()

	blood_data["blood_DNA"] = sampled_from.dna.unique_enzymes

	var/list/temp_chem = list()
	for(var/datum/reagent/trace_chem as anything in sampled_from.reagents.reagent_list)
		temp_chem[trace_chem.type] = trace_chem.volume
	blood_data["trace_chem"] = list2params(temp_chem)

	blood_data["mind"] = sampled_from.mind || sampled_from.last_mind
	blood_data["ckey"] = sampled_from.ckey || ckey(sampled_from.last_mind?.key)
	blood_data["cloneable"] = !sampled_from.suiciding
	blood_data["blood_type"] = sampled_from.dna.human_blood_type
	blood_data["gender"] = sampled_from.gender
	blood_data["real_name"] = sampled_from.real_name
	blood_data["features"] = sampled_from.dna.features
	blood_data["factions"] = sampled_from.faction
	return blood_data


/datum/blood_type/human/a_minus
	name = "A-"
	compatible_types = list(
		/datum/blood_type/human/o_minus,
	)

/datum/blood_type/human/tiefling
	name = "Tiefling"
	compatible_types = list(
		/datum/blood_type/human/o_minus,
	)
	reagent_type = /datum/reagent/blood/tiefling
	contains_lux = TRUE

/datum/blood_type/human/kobold
	name = "Kobold"
	compatible_types = list(
		/datum/blood_type/human/o_minus,
	)
	reagent_type = /datum/reagent/blood
	contains_lux = FALSE

/datum/blood_type/human/rakshari
	name = "Rakshari"
	compatible_types = list(
		/datum/blood_type/human/o_minus,
	)
	reagent_type = /datum/reagent/blood
	contains_lux = FALSE

/datum/blood_type/human/demihuman
	name = "Hollow-Kin"
	compatible_types = list(
		/datum/blood_type/human/o_minus,
	)
	reagent_type = /datum/reagent/blood
	contains_lux = FALSE

/datum/blood_type/human/horc
	name = "Half-Orc"
	compatible_types = list(
		/datum/blood_type/human/o_minus,
	)
	reagent_type = /datum/reagent/blood
	contains_lux = TRUE

/datum/blood_type/human/delf
	name = "Dark Elf"
	compatible_types = list(
		/datum/blood_type/human/o_minus,
	)
	reagent_type = /datum/reagent/blood
	contains_lux = TRUE

/datum/blood_type/human/cursed_elf
	name = "Cursed Elf Blood"
	compatible_types = list(
		/datum/blood_type/human/o_minus,
	)
	reagent_type = /datum/reagent/blood
	contains_lux = TRUE

/datum/blood_type/human/a_plus
	name = "A+"
	compatible_types = list(
		/datum/blood_type/human/a_minus,
		/datum/blood_type/human/a_plus,
		/datum/blood_type/human/o_minus,
		/datum/blood_type/human/o_plus,
	)

/datum/blood_type/human/b_minus
	name = "B-"
	compatible_types = list(
		/datum/blood_type/human/b_minus,
		/datum/blood_type/human/o_minus,
	)

/datum/blood_type/human/b_plus
	name = "B+"
	compatible_types = list(
		/datum/blood_type/human/b_minus,
		/datum/blood_type/human/b_plus,
		/datum/blood_type/human/o_minus,
		/datum/blood_type/human/o_plus,
	)

/datum/blood_type/human/ab_minus
	name = "AB-"
	compatible_types = list(
		/datum/blood_type/human/b_minus,
		/datum/blood_type/human/ab_minus,
		/datum/blood_type/human/a_minus,
		/datum/blood_type/human/o_minus,
	)

/datum/blood_type/human/ab_plus
	name = "AB+"
	// Universal Recipient

/datum/blood_type/human/ab_plus/New()
	. = ..()
	compatible_types |= subtypesof(/datum/blood_type/human)

/datum/blood_type/human/o_minus
	name = "O-"
	// Universal Donor

/datum/blood_type/human/o_plus
	name = "O+"
	compatible_types = list(
		/datum/blood_type/human/o_minus,
		/datum/blood_type/human/o_plus,
	)

/datum/blood_type/animal
	name = "Y-"
