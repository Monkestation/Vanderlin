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

/datum/plant_def/proc/show_menu(mob/user)
	user << browse(generate_html(user),"window=recipe;size=500x810")

/datum/plant_def/proc/generate_html(mob/user)
	var/client/client = user
	if(!istype(client))
		client = user.client
	SSassets.transport.send_assets(client, list("try4_border.png", "try4.png", "slop_menustyle2.css"))
	user << browse_rsc('html/book.png')

	var/produce_icon_html = ""
	if(produce_type)
		var/obj/item/produce_item = new produce_type
		produce_icon_html = "<div class='recipe-card-icon'><img src='\ref[initial(produce_item.icon)]?state=[initial(produce_item.icon_state)]&dir=[initial(produce_item.dir)]'/></div>"
		qdel(produce_item)

	var/html = {"
		<!DOCTYPE html>
		<html lang="en">
		<meta charset='UTF-8'>
		<meta http-equiv='X-UA-Compatible' content='IE=edge,chrome=1'/>
		<meta http-equiv='Content-Type' content='text/html; charset=UTF-8'/>
		<style>
			@import url('https://fonts.googleapis.com/css2?family=Charm:wght@700&display=swap');
			body {
				font-family: "Charm", cursive;
				font-size: 1.2em;
				text-align: center;
				margin: 20px;
				background-color: #f4efe6;
				color: #3e2723;
				background-color: rgb(31, 20, 24);
				background:
					url('[SSassets.transport.get_asset_url("try4_border.png")]'),
					url('book.png');
				background-repeat: no-repeat;
				background-attachment: fixed;
				background-size: 100% 100%;
			}
			h1 {
				text-align: center;
				font-size: 2em;
				border-bottom: 2px solid #3e2723;
				padding-bottom: 10px;
				margin-bottom: 10px;
			}
			.recipe-card-icon {
				text-align: center;
				margin: 20px 0;
			}
			.recipe-card-icon img {
				width: 64px;
				height: 64px;
				image-rendering: pixelated;
			}
			.requirements {
				margin-bottom: 20px;
			}
			.growth-info {
				margin-top: 15px;
			}
		</style>
		<body>
			<div>
				<h1>[name]</h1>
				[produce_icon_html]
				<div class="requirements">
					<h2>Growth Requirements</h2>
					<strong>Maturation Time:</strong> [maturation_time / (1 MINUTES)] minutes<br>
					<strong>Produce Time:</strong> [produce_time / (1 MINUTES)] minutes<br>
					<strong>Expected Yield:</strong> [produce_amount_min]-[produce_amount_max]<br>
					<strong>Plant Type:</strong> [perennial ? "Perennial" : "Annual"]<br>
	"}

	// Add nutrient requirements
	if(nitrogen_requirement > 0 || phosphorus_requirement > 0 || potassium_requirement > 0)
		html += "<h2>Nutrient Requirements</h2>"
		if(nitrogen_requirement > 0)
			html += "<strong>Nitrogen:</strong> [nitrogen_requirement] units<br>"
		if(phosphorus_requirement > 0)
			html += "<strong>Phosphorus:</strong> [phosphorus_requirement] units<br>"
		if(potassium_requirement > 0)
			html += "<strong>Potassium:</strong> [potassium_requirement] units<br>"

	// Add nutrient production
	if(nitrogen_production > 0 || phosphorus_production > 0 || potassium_production > 0)
		html += "<h2>Soil Enrichment</h2>"
		if(nitrogen_production > 0)
			html += "<strong>Nitrogen Production:</strong> +[nitrogen_production] units<br>"
		if(phosphorus_production > 0)
			html += "<strong>Phosphorus Production:</strong> +[phosphorus_production] units<br>"
		if(potassium_production > 0)
			html += "<strong>Potassium Production:</strong> +[potassium_production] units<br>"

	// Add plant family and special properties
	var/family_name = get_family_name()
	html += {"
				</div>
				<div class='growth-info'>
					<h2>Plant Information</h2>
					<strong>Family:</strong> [family_name]<br>
					<strong>Water Usage:</strong> [water_drain_rate * (1 MINUTES)] units/minute<br>
					<strong>Weed Resistance:</strong> [weed_immune ? "Yes" : "No"]<br>
					<strong>Underground Growth:</strong> [can_grow_underground ? "Yes" : "No"]<br>
				</div>
			</div>
		</body>
		</html>
	"}
	return html

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
