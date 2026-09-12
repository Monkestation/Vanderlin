/datum/blueprint_recipe/matthios
	craftdiff = 0
	category = "Structure"
	requires_learning = TRUE
	construct_tool = /obj/item/weapon/hammer

/datum/blueprint_recipe/matthios/idol
	name = "Matthios Idol"
	required_materials = list(
		/obj/item/natural/stone = 8,
		/obj/item/grown/log/tree/small = 3
	)
	result_type = /obj/structure/fluff/statue/evil
	craftdiff = 1
	verbage = "construct"
	verbage_tp = "constructs"
	craftsound = 'sound/foley/Building-01.ogg'
