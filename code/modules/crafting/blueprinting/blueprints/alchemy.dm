/datum/blueprint_recipe/alchemy
	abstract_type = /datum/blueprint_recipe/alchemy
	skillcraft = /datum/attribute/skill/craft/alchemy
	category = "Alchemy"
	construct_tool = /obj/item/weapon/hammer
	craftsound = 'sound/foley/Building-01.ogg'
	verbage = "infuse"
	verbage_tp = "infuses"

/datum/blueprint_recipe/alchemy/essence_reservoir
	name = "Essence Reservoir"
	desc = "A container for storing alchemical essences."
	result_type = /obj/machinery/essence/reservoir
	required_materials = list(
		/obj/item/ingot/thaumic = 1,
		/obj/item/natural/glass = 3
	)
	supports_directions = TRUE
	craftdiff = 2

/datum/blueprint_recipe/alchemy/essence_combiner
	name = "Essence Combiner"
	desc = "A device for combining different alchemical essences."
	result_type = /obj/machinery/essence/combiner
	required_materials = list(
		/obj/item/ingot/thaumic = 2,
		/obj/item/natural/glass = 2
	)
	supports_directions = TRUE
	craftdiff = 3

/datum/blueprint_recipe/alchemy/research_matrix
	name = "Research Matrix"
	desc = "A matrix for researching new alchemical formulas."
	result_type = /obj/machinery/essence/research_matrix
	required_materials = list(
		/obj/item/ingot/thaumic = 2,
		/obj/item/mana_battery/mana_crystal = 1
	)

/datum/blueprint_recipe/alchemy/essence_infuser
	name = "Essence Infuser"
	desc = "A device for infusing items with alchemical essence."
	result_type = /obj/machinery/essence/infuser
	required_materials = list(
		/obj/item/natural/stone = 2,
		/obj/item/ingot/iron = 1
	)
	supports_directions = TRUE
	craftdiff = 2

/datum/blueprint_recipe/alchemy/essence_splitter
	name = "Essence Splitter"
	desc = "A device for splitting alchemical essences."
	result_type = /obj/machinery/essence/splitter
	required_materials = list(
		/obj/item/ingot/thaumic = 2,
		/obj/item/mana_battery/mana_crystal = 1
	)
	supports_directions = TRUE
	craftdiff = 3

/datum/blueprint_recipe/alchemy/enchantment_altar
	name = "Enchantment Altar"
	desc = "An altar for enchanting items with alchemical properties."
	result_type = /obj/machinery/essence/enchantment_altar
	required_materials = list(
		/obj/item/natural/stone = 2,
		/obj/item/ingot/thaumic = 2,
		/obj/item/mana_battery/mana_crystal = 1
	)
	supports_directions = TRUE
	craftdiff = 4

/datum/blueprint_recipe/alchemy/essence_harvester
	name = "Essence Harvester"
	desc = "A device for harvesting alchemical essence from various sources."
	result_type = /obj/machinery/essence/harvester
	required_materials = list(
		/obj/item/ingot/thaumic = 2,
		/obj/item/mana_battery/mana_crystal = 1,
		/obj/item/natural/glass = 1
	)
	supports_directions = TRUE
	craftdiff = 3
