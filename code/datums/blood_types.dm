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
	var/color = COLOR_BLOOD
	/// What blood types can this type receive from
	/// Itself is always included in this list
	var/list/compatible_types = list()
	/// What reagent is represented by this blood type?
	var/datum/reagent/reagent_type = /datum/reagent/blood
	/// What chem is used to restore this blood type (outside of itself, of course)?
	var/datum/reagent/restoration_chem
	///do we contain Lux?
	var/contains_lux = FALSE
	///is our lux tainted?
	var/tainted_lux = FALSE
	///the chimeric table we pull from when creating chimeric nodes based on this blood
	var/datum/chimeric_table/used_table

/datum/blood_type/New()
	. = ..()
	compatible_types |= type


/// Gets data to pass to a reagent
/datum/blood_type/proc/get_blood_data(mob/living/sampled_from)
	if(!istype(sampled_from))
		return null

	var/list/blood_data = list()

	blood_data["mind"] = sampled_from.mind
	blood_data["ckey"] = sampled_from.ckey
	blood_data["blood_type"] = sampled_from.get_blood_type().type
	blood_data["gender"] = sampled_from.gender
	blood_data["real_name"] = sampled_from.real_name
	blood_data["factions"] = sampled_from.faction
	return blood_data

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
	name = "Human"
	contains_lux = TRUE
	used_table = /datum/chimeric_table/human

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


/datum/blood_type/human/tiefling
	name = "Tiefling"
	reagent_type = /datum/reagent/blood/tiefling
	contains_lux = TRUE
	used_table = /datum/chimeric_table/tiefling

/datum/blood_type/human/kobold
	name = "Kobold"
	reagent_type = /datum/reagent/blood
	contains_lux = FALSE
	used_table = /datum/chimeric_table/kobold

/datum/blood_type/human/rakshari
	name = "Rakshari"
	reagent_type = /datum/reagent/blood
	contains_lux = FALSE
	used_table = /datum/chimeric_table/rakshari

/datum/blood_type/human/demihuman
	name = "Hollow-Kin"
	reagent_type = /datum/reagent/blood
	contains_lux = FALSE
	used_table = /datum/chimeric_table/demihuman

/datum/blood_type/human/horc
	name = "Half-Orc"
	reagent_type = /datum/reagent/blood
	contains_lux = TRUE
	used_table = /datum/chimeric_table/horc

/datum/blood_type/human/delf
	name = "Dark Elf"
	reagent_type = /datum/reagent/blood
	contains_lux = TRUE
	used_table = /datum/chimeric_table/delf

/datum/blood_type/human/cursed_elf
	name = "Cursed Elf Blood"
	reagent_type = /datum/reagent/blood
	contains_lux = TRUE
	used_table = /datum/chimeric_table/cursed_elf

/datum/blood_type/human/triton
	name = "Triton"
	reagent_type = /datum/reagent/blood
	contains_lux = TRUE
	used_table = /datum/chimeric_table/triton

/datum/blood_type/human/medicator
	name = "Medicator"
	used_table = /datum/chimeric_table/medicator

/datum/blood_type/human/dwarf
	name = "Dwarf"
	used_table = /datum/chimeric_table/dwarf

/datum/blood_type/human/elf
	name = "Elf"
	used_table = /datum/chimeric_table/elf

/datum/blood_type/animal
	name = "Animal"
	used_table = /datum/chimeric_table/animal

/datum/blood_type/troll
	name = "Troll"
	used_table = /datum/chimeric_table/troll

/datum/blood_type/fey
	name = "fey"
	used_table = /datum/chimeric_table/fey

/datum/blood_type/lycan
	name = "Lycan"
	used_table = /datum/chimeric_table/lycan

/datum/blood_type/human/corrupted
	contains_lux = TRUE
	tainted_lux = TRUE
	reagent_type = /datum/reagent/blood

/datum/blood_type/human/corrupted/goblin
	name = "Goblin"
	used_table = /datum/chimeric_table/goblin

/datum/blood_type/human/corrupted/orc
	name = "Orc"
	used_table = /datum/chimeric_table/orc

/datum/blood_type/human/corrupted/rousman
	name = "Rousman"
	used_table = /datum/chimeric_table/rousman

/datum/blood_type/human/corrupted/zizombie
	name = "Zizombie"

/datum/blood_type/putrid
	name = "Putrid"
	used_table = /datum/chimeric_table/putrid
