/datum/anvil_recipe/slag
	appro_skill = /datum/attribute/skill/craft/blacksmithing
	abstract_type = /datum/anvil_recipe/slag
	category = "Slag"

/datum/anvil_recipe/slag/handle_output(obj/item/output_item, datum/quality_calculator/blacksmithing/quality_calculator)
	var/average_performance = accumulated_quality / numberofhits
	if(average_performance >= MINIMUM_ANVIL_MINIGAME_SCORE) // Did you even try?
		output_item.set_quality(material_quality / num_of_materials)

/datum/anvil_recipe/slag/steel
	name = "Steel Ingot"
	required_material = /obj/item/ingot/steel_slag
	created_item = /obj/item/ingot/steel
	craftdiff = 2
