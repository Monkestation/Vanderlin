
/datum/container_craft/cooking/herbal_oil
	abstract_type = /datum/container_craft/cooking/herbal_oil
	category = "Herbal Oils"
	crafting_time = 25 SECONDS
	reagent_requirements = list(
		/datum/reagent/consumable/ethanol = 30
	)
	subtype_reagents_allowed = TRUE
	craft_verb = "infusing "
	required_chem_temp = 300 // Low heat for oil infusion
	pollute_amount = 100
	wording_choice = "essence of"
	complete_message = "The oil glistens with herbal essence!"
	used_skill = /datum/attribute/skill/craft/alchemy
	quality_modifier = 1.0

// Rosa Oil (perfume/cosmetic)
/datum/container_craft/cooking/herbal_oil/rosa_oil
	name = "Rosa Perfume Oil"
	created_reagent = /datum/reagent/consumable/herbal/rosa_oil
	water_conversion = 1
	requirements = list(
		/obj/item/alch/herb/rosa = 3
	)
	output_amount = 20
	finished_smell = /datum/pollutant/food/flower

// Mentha Cooling Oil (muscle relief)
/datum/container_craft/cooking/herbal_oil/mentha_oil
	name = "Mentha Cooling Oil"
	created_reagent = /datum/reagent/medicine/herbal/mentha_oil
	water_conversion = 1
	requirements = list(
		/obj/item/alch/herb/mentha = 2,
		/obj/item/alch/herb/euphrasia = 1
	)
	output_amount = 25
	finished_smell = /datum/pollutant/food/mint
