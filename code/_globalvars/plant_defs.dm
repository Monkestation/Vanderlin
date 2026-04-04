#define BERRYCOLORS	list("#6a6699", "#9b6464", "#58a75c", "#5658a9", "#669799")
GLOBAL_LIST_EMPTY(berrycolors)


/// Plant def is a list of every single Plant/Herb we have
GLOBAL_LIST_INIT(plant_defs, build_plant_defs())

/proc/build_plant_defs()
	. = list()
	for(var/path in subtypesof(/datum/plant_def))
		.[path] = new path()

/// list of seeds that can spawn randomly on the grass
GLOBAL_LIST_INIT(seeds_common, build_plant_local())

/proc/build_plant_local()
	. = list()
	for(var/path in subtypesof(/datum/plant_def))
		var/datum/plant_def/plant = new path()
		if(plant.rarity > PLANT_RARITY_COMMON || plant.plant_family == FAMILY_DIKARYA) //no spores
			continue
		.[path] = plant

/// list of seeds that are rare/expensive
GLOBAL_LIST_INIT(seeds_rare, build_plant_rare())

/proc/build_plant_rare()
	. = list()
	for(var/path in subtypesof(/datum/plant_def))
		var/datum/plant_def/plant = new path()
		if(plant.rarity == PLANT_RARITY_RARE || plant.plant_family == FAMILY_DIKARYA) //no spores
			continue
		.[path] = plant

/// list of seeds that are imported
GLOBAL_LIST_INIT(seeds_exotic, build_plant_exotic())

/proc/build_plant_exotic()
	. = list()
	for(var/path in subtypesof(/datum/plant_def))
		var/datum/plant_def/plant = new path()
		if(plant.rarity == PLANT_RARITY_EXOTIC || plant.plant_family == FAMILY_DIKARYA) //no spores
			continue
		.[path] = plant

GLOBAL_LIST_INIT(seeds_spores, build_plant_spores())

/proc/build_plant_spores()
	. = list()
	for(var/path in subtypesof(/datum/plant_def))
		var/datum/plant_def/plant = new path()
		if(plant.plant_family != FAMILY_DIKARYA) //only spores
			continue
		.[path] = plant
