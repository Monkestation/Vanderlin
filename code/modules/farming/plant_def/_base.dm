/datum/plant_def
	abstract_type = /datum/plant_def
	/// Name of the plant
	var/name = "Some plant"
	/// Description of the plant
	var/desc = "Sure is a plant."
	var/icon = 'icons/roguetown/misc/crops.dmi'
	var/icon_state
	/// Loot the plant will yield for uprooting it
	var/list/uproot_loot
	/// Time in ticks the plant will require to mature
	var/maturation_time = DEFAULT_GROW_TIME
	/// Time in ticks the plant will require to make produce
	var/produce_time = DEFAULT_PRODUCE_TIME
	/// Typepath of produce to make on harvest
	var/atom/produce_type
	/// Amount of minimum produce to make on harvest
	var/produce_amount_min = 2
	/// Amount of maximum produce to make on harvest
	var/produce_amount_max = 3
	/// How much nutrition will the plant require to make produce
	var/produce_nutrition = 20
	/// If not perennial, the plant will uproot itself upon harvesting first produce
	var/perennial = FALSE
	/// Whether the plant is immune to weeds and will naturally deal with them
	var/weed_immune = FALSE
	/// The rate at which the plant drains water
	var/water_drain_rate = 2 / (1 MINUTES)
	/// Color all seeds of this plant def will have
	var/seed_color
	/// Whether the plant can grow underground
	var/can_grow_underground = FALSE
	/// Whether the plant can grow in mushroom mound
	var/mound_growth = FALSE

	// NPK nutrient requirements (consumed during growth)
	var/nitrogen_requirement = 30      // For leafy growth
	var/phosphorus_requirement = 20    // For root/flower development
	var/potassium_requirement = 15     // For overall health

	// NPK nutrient production (added to soil after harvest/decay)
	var/nitrogen_production = 0        // Most crops consume N
	var/phosphorus_production = 5      // Most crops add some P
	var/potassium_production = 10      // Most crops add K

	// Plant family for breeding compatibility
	var/plant_family = FAMILY_HERB
	/// Identity of seeds with this type
	var/seed_identity = "some seeds"
	///this is if we become seethrough or not
	var/see_through = FALSE
	///the honey type we build towards
	var/obj/item/reagent_containers/food/snacks/spiderhoney/honey_type

/datum/plant_def/New()
	. = ..()
	var/static/list/random_colors = list("#fffbf7", "#f3c877", "#5e533e", "#db7f62", "#f39945")
	seed_color = pick(random_colors)

/datum/plant_def/proc/set_genetic_tendencies(datum/plant_genetics/base_genetics)
	// Override this in subtypes to set species-specific traits
	return

/datum/plant_def/proc/get_examine_details()
	var/list/details = list()

	if(nitrogen_requirement > 0)
		details += span_info("Nitrogen: [nitrogen_requirement] units [perennial ? "per stage" : ""]")
	if(phosphorus_requirement > 0)
		details += span_info("Phosphorus: [phosphorus_requirement] units [perennial ? "per stage" : ""]")
	if(potassium_requirement > 0)
		details += span_info("Potassium: [potassium_requirement] units [perennial ? "per stage" : ""]")

	if(nitrogen_requirement == 0 && phosphorus_requirement == 0 && potassium_requirement == 0)
		details += "No nutrient requirement"

	if(nitrogen_production > 0)
		details += span_info("Enriches [nitrogen_production] Nitrogen")
	if(phosphorus_production > 0)
		details += span_info("Enriches [phosphorus_production] Phosphorus")
	if(potassium_production > 0)
		details += span_info("Enriches [potassium_production] Potassium")

	// Growth time
	if(maturation_time)
		var/minutes = maturation_time / (1 MINUTES)
		details += span_info("<b>Growth Time:</b> [minutes] minute\s")

	return details

/datum/plant_def/proc/get_family_name()
	switch(plant_family)
		if(FAMILY_BRASSICA)
			return "Brassica"
		if(FAMILY_ALLIUM)
			return "Allium"
		if(FAMILY_GRAIN)
			return "Grain"
		if(FAMILY_SOLANACEAE)
			return "Solanaceae"
		if(FAMILY_ROSACEAE)
			return "Rosaceae"
		if(FAMILY_RUTACEAE)
			return "Rutaceae"
		if(FAMILY_ASTERACEAE)
			return "Asteraceae"
		if(FAMILY_HERB)
			return "Herb"
		if(FAMILY_ROOT)
			return "Root"
		if(FAMILY_RUBIACEAE)
			return "Madder"
		if(FAMILY_THEACEAE)
			return "Theaceae"
		if(FAMILY_FRUIT)
			return "Fruit"
		if(FAMILY_DIKARYA)
			return "Dikarya"
		else
			return "Unknown"
