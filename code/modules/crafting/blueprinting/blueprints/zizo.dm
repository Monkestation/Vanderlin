/datum/blueprint_recipe/zizo
	craftdiff = 0
	category = "Structure"
	requires_learning = TRUE
	construct_tool = /obj/item/weapon/hammer

/datum/blueprint_recipe/zizo/shrine
	name = "inverted cross"
	required_materials = list(
		/obj/item/grown/log/tree/small = 1,
		/obj/item/natural/stone = 2,
		/obj/item/grown/log/tree/stake = 3
	)
	result_type = /obj/structure/fluff/psycross/zizocross
	craftdiff = 1
	verbage = "construct"
	verbage_tp = "constructs"
	craftsound = 'sound/foley/Building-01.ogg'
