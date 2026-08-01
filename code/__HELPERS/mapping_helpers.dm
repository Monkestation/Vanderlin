// No non-player species in this for now
/// For a /obj/effect/mob_spawn/corpse/human or /obj/effect/mob_spawn/human (if it ever exists) create all species subtypes
#define CREATE_ALL_SPECIES_SPAWNERS(path) \
	##path/aasimar { \
		mob_species = /datum/species/aasimar; \
	} \
	##path/automaton { \
		mob_species = /datum/species/automaton; \
	} \
	##path/halfling { \
		mob_species = /datum/species/halfling; \
	} \
	##path/harpy { \
		mob_species = /datum/species/harpy; \
	} \
	##path/space_man { \
		mob_species = /datum/species/human/space; \
	} \
	##path/half_drow { \
		mob_species = /datum/species/human/halfdrow; \
	} \
	##path/half_elf { \
		mob_species = /datum/species/human/halfelf; \
	} \
	##path/half_snow { \
		mob_species = /datum/species/human/halfzizo; \
	} \
	##path/hollow_kin { \
		mob_species = /datum/species/demihuman; \
	} \
	##path/dwarf { \
		mob_species = /datum/species/dwarf/mountain; \
	} \
	##path/dwarf/subterra { \
		mob_species = /datum/species/dwarf/mountain/subterra; \
	} \
	##path/elf { \
		mob_species = /datum/species/elf/snow; \
	} \
	##path/elf/dark { \
		mob_species = /datum/species/elf/dark; \
	} \
	##path/elf/snow { \
		mob_species = /datum/species/elf/zizo; \
	} \
	##path/half_orc { \
		mob_species = /datum/species/halforc; \
	} \
	##path/kobold { \
		mob_species = /datum/species/kobold; \
	} \
	##path/kobold/formikrag { \
		mob_species = /datum/species/kobold/formikrag; \
	} \
	##path/medicator { \
		mob_species = /datum/species/medicator; \
	} \
	##path/rakshari { \
		mob_species = /datum/species/rakshari; \
	} \
	##path/tiefling { \
		mob_species = /datum/species/tieberian; \
	} \
	##path/triton { \
		mob_species = /datum/species/triton; \
	} \
