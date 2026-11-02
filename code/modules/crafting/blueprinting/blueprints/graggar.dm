/datum/blueprint_recipe/graggar
	craftdiff = 0
	category = "Structure"
	requires_learning = TRUE
	construct_tool = /obj/item/weapon/hammer

/datum/blueprint_recipe/graggar/shrine
	name = "Graggar Idol"
	required_materials = list(
		/obj/item/grown/log/tree/small = 2,
		/obj/item/natural/stone = 3
	)
	result_type = /obj/structure/fluff/statue/graggar
	craftdiff = 1
	verbage = "construct"
	verbage_tp = "constructs"
	craftsound = 'sound/foley/Building-01.ogg'
