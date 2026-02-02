///for balance sake herbs consume a bit of everything.
/datum/plant_def/alchemical
	abstract_type = /datum/plant_def/alchemical

	name = ""
	icon = 'icons/roguetown/misc/herbfoliage.dmi'
	icon_state = "herb"
	uproot_loot = list(/obj/item/grown/log/tree/stick)
	perennial = TRUE
	produce_amount_min = 1
	produce_amount_max = 2
	maturation_time = FAST_GROWING
	produce_time = SLOW_PRODUCE_TIME
	water_drain_rate = 1 / (2 MINUTES)
	can_grow_underground = TRUE
	plant_family = FAMILY_HERB
	// Herbs are generally efficient with nutrients
	nitrogen_requirement = 20
	phosphorus_requirement = 25
	potassium_requirement = 20
	nitrogen_production = 5  // Herbs add some nutrients back
	phosphorus_production = 8
	potassium_production = 12

/datum/plant_def/alchemical/set_genetic_tendencies(datum/plant_genetics/base_genetics)
	base_genetics.quality_trait = TRAIT_GRADE_GOOD  // Herbs are prized for quality
	base_genetics.disease_resistance = TRAIT_GRADE_GOOD  // Natural compounds deter pests

/datum/plant_def/alchemical/atropa
	name = "atropa"
	icon_state = "atropa"
	produce_type = /obj/item/alch/herb/atropa
	nitrogen_requirement = 25  // Deadly nightshade needs more N
	phosphorus_requirement = 35  // Alkaloid production
	potassium_requirement = 18
	seed_identity = "atropa seeds"
	honey_type = /obj/item/reagent_containers/food/snacks/spiderhoney/honey/toxic

/datum/plant_def/alchemical/atropa/set_genetic_tendencies(datum/plant_genetics/base_genetics)
	..()
	base_genetics.disease_resistance = TRAIT_GRADE_GOOD  // Highly toxic = very pest resistant

/datum/plant_def/alchemical/matricaria
	name = "matricaria"
	icon_state = "matricaria"
	produce_type = /obj/item/alch/herb/matricaria
	seed_identity = "matricaria seeds"

/datum/plant_def/alchemical/symphitum
	name = "symphitum"
	icon_state = "symphitum"
	produce_type = /obj/item/alch/herb/symphitum
	nitrogen_requirement = 30  // Comfrey is a heavy feeder
	phosphorus_requirement = 20
	potassium_requirement = 25
	seed_identity = "symphitum seeds"

/datum/plant_def/alchemical/symphitum/set_genetic_tendencies(datum/plant_genetics/base_genetics)
	..()
	base_genetics.yield_trait = TRAIT_GRADE_GOOD  // Comfrey grows vigorously

/datum/plant_def/alchemical/taraxacum
	name = "taraxacum"
	icon_state = "taraxacum"
	produce_type = /obj/item/alch/herb/taraxacum
	nitrogen_requirement = 15  // Dandelions are very efficient
	phosphorus_requirement = 20
	potassium_requirement = 15
	seed_identity = "taraxacum seeds"

/datum/plant_def/alchemical/taraxacum/set_genetic_tendencies(datum/plant_genetics/base_genetics)
	..()
	base_genetics.water_efficiency = TRAIT_GRADE_GOOD  // Dandelions are tough
	base_genetics.cold_resistance = TRAIT_GRADE_GOOD

/datum/plant_def/alchemical/euphrasia
	name = "euphrasia"
	icon_state = "euphrasia"
	produce_type = /obj/item/alch/herb/euphrasia
	seed_identity = "euphrasia seeds"

/datum/plant_def/alchemical/urtica
	name = "urtica"
	icon_state = "urtica"
	produce_type = /obj/item/alch/herb/urtica
	nitrogen_requirement = 35  // Nettles love nitrogen
	phosphorus_requirement = 15
	potassium_requirement = 20
	seed_identity = "urtica seeds"

/datum/plant_def/alchemical/urtica/set_genetic_tendencies(datum/plant_genetics/base_genetics)
	..()
	base_genetics.disease_resistance = TRAIT_GRADE_GOOD  // Stinging = pest resistant

/datum/plant_def/alchemical/calendula
	name = "calendula"
	icon_state = "calendula"
	produce_type = /obj/item/alch/herb/calendula
	seed_identity = "calendula seeds"

/datum/plant_def/alchemical/mentha
	name = "mentha"
	icon_state = "mentha"
	produce_type = /obj/item/alch/herb/mentha
	nitrogen_requirement = 25
	phosphorus_requirement = 15
	potassium_requirement = 30  // Mint spreads with runners
	seed_identity = "mentha seeds"

/datum/plant_def/alchemical/mentha/set_genetic_tendencies(datum/plant_genetics/base_genetics)
	..()
	base_genetics.disease_resistance = TRAIT_GRADE_GOOD  // Aromatic oils repel pests

/datum/plant_def/alchemical/salvia
	name = "salvia"
	icon_state = "salvia"
	produce_type = /obj/item/alch/herb/salvia
	seed_identity = "salvia seeds"

/datum/plant_def/alchemical/hypericum
	name = "hypericum"
	icon_state = "hypericum"
	produce_type = /obj/item/alch/herb/hypericum
	seed_identity = "hypericum seeds"

/datum/plant_def/alchemical/benedictus
	name = "benedictus"
	icon_state = "benedictus"
	produce_type = /obj/item/alch/herb/benedictus
	seed_identity = "benedictus seeds"

/datum/plant_def/alchemical/valeriana
	name = "valeriana"
	icon_state = "valeriana"
	produce_type = /obj/item/alch/herb/valeriana
	seed_identity = "valeriana seeds"

/datum/plant_def/alchemical/paris
	name = "paris"
	icon_state = "paris"
	produce_type = /obj/item/alch/herb/paris
	nitrogen_requirement = 18
	phosphorus_requirement = 35  // Toxic compounds need P
	potassium_requirement = 15
	seed_identity = "paris seeds"
	honey_type = /obj/item/reagent_containers/food/snacks/spiderhoney/honey/toxic

/datum/plant_def/alchemical/paris/set_genetic_tendencies(datum/plant_genetics/base_genetics)
	..()
	base_genetics.disease_resistance = TRAIT_GRADE_GOOD  // Very toxic

/datum/plant_def/alchemical/artemisia
	name = "artemisia"
	icon_state = "artemisia"
	produce_type = /obj/item/alch/herb/artemisia
	seed_identity = "artemisia seeds"

/datum/plant_def/alchemical/artemisia/set_genetic_tendencies(datum/plant_genetics/base_genetics)
	..()
	base_genetics.water_efficiency = TRAIT_GRADE_GOOD  // Wormwood is drought tolerant

/datum/plant_def/alchemical/rosa
	name = "rosa"
	icon_state = "rosa"
	produce_type = /obj/item/alch/herb/rosa
	plant_family = FAMILY_ROSACEAE  // Roses are in rose family
	nitrogen_requirement = 30
	phosphorus_requirement = 25
	potassium_requirement = 35
	seed_identity = "rosa seeds"

/datum/plant_def/alchemical/euphorbia
	name = "euphorbia"
	icon_state = "euphorbia"
	produce_type = /obj/item/alch/herb/euphorbia
	nitrogen_requirement = 15  // Succulents are efficient
	phosphorus_requirement = 30  // Latex production
	potassium_requirement = 20
	seed_identity = "euphorbia seeds"

/datum/plant_def/alchemical/euphorbia/set_genetic_tendencies(datum/plant_genetics/base_genetics)
	..()
	base_genetics.water_efficiency = TRAIT_GRADE_GOOD  // Succulent
	base_genetics.disease_resistance = TRAIT_GRADE_GOOD  // Toxic latex
