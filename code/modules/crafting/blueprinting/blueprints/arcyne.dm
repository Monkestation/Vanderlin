/datum/blueprint_recipe/arcyne
	abstract_type = /datum/blueprint_recipe/arcyne
	skillcraft = /datum/attribute/skill/magic/arcane
	category = "Arcane"
	construct_tool = /obj/item/weapon/hammer
	craftsound = 'sound/foley/Building-01.ogg'
	verbage = "weave"
	verbage_tp = "weaves"

/datum/blueprint_recipe/arcyne/mana_pylon
	name = "mana pylon"
	desc = "A crystalline pylon that channels and focuses mana."
	result_type = /obj/structure/mana_pylon
	required_materials = list(
		/obj/item/natural/stone = 2,
		/obj/item/gem/amethyst = 1
	)
	craftdiff = 2
