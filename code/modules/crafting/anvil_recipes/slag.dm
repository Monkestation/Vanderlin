/datum/anvil_recipe/slag
	appro_skill = /datum/attribute/skill/craft/blacksmithing
	abstract_type = /datum/anvil_recipe/slag
	category = "Slag"

/datum/anvil_recipe/slag/handle_creation(obj/item/recipe_output, obj/item/initial_material)
	var/average_performance = accumulated_quality / numberofhits
	if(average_performance >= 40) // Did you even try?
		recipe_output.set_quality(initial_material.recipe_quality)

/datum/anvil_recipe/slag/steel
	name = "Steel Ingot"
	required_material = /obj/item/ingot/steel_slag
	created_item = /obj/item/ingot/steel
	craftdiff = 2
