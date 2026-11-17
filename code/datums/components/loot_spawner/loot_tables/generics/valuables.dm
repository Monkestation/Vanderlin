/datum/loot_table/treasure_tiered
	name = "tiered treasure"
	cascading = TRUE
	luck_chance_bonus = 1
	loot_table = list(
		/datum/loot_table/treasure/hoard = 4,
		/datum/loot_table/treasure/valuables = 20,
		/datum/loot_table/treasure/trinkets = 100
	)

/datum/loot_table/treasure
	name = "treasure"
	loot_table = list(
		/datum/loot_table/treasure/trinkets = 60,
		/datum/loot_table/treasure/valuables = 30,
		/datum/loot_table/treasure/hoard = 10
	)

/datum/loot_table/treasure/trinkets
	name = "trinkets"
	loot_table = list(
		/obj/item/carvedgem/shell/rawshell = 10,
		/obj/item/carvedgem/shell/cutgem = 8,
		/obj/item/carvedgem/shell/fork = 6,
		/obj/item/carvedgem/shell/spoon = 6,
		/obj/item/carvedgem/shell/comb = 6,
		/obj/item/carvedgem/shell/figurine = 6,
		/obj/item/carvedgem/shell/duck = 5,
		/obj/item/carvedgem/rose/rawrose = 8,
		/obj/item/carvedgem/rose/cutgem = 6,
		/obj/item/carvedgem/rose/cameo = 5,
		/obj/item/carvedgem/rose/fish = 4,
		/obj/item/statue/bronze/figurine = 6,
		/obj/item/statue/bronze/comb = 6,
		/obj/item/statue/bronze/cameo = 6,
		/obj/item/statue/bronze/vase = 4,
		/obj/item/statue/silver/figurine = 3,
		/obj/item/statue/silver/fish = 3
	)

/datum/loot_table/treasure/valuables
	name = "valuables"
	loot_table = list(
		/obj/item/carvedgem/onyxa/cutgem = 8,
		/obj/item/carvedgem/onyxa/figurine = 6,
		/obj/item/carvedgem/onyxa/bust = 4,
		/obj/item/carvedgem/jade/cutgem = 8,
		/obj/item/carvedgem/jade/figurine = 6,
		/obj/item/carvedgem/jade/vase = 4,
		/obj/item/carvedgem/amber/cutgem = 8,
		/obj/item/carvedgem/amber/figurine = 6,
		/obj/item/carvedgem/coral/cutgem = 8,
		/obj/item/carvedgem/coral/figurine = 6,
		/obj/item/statue/silver/bust = 5,
		/obj/item/statue/silver/vase = 5,
		/obj/item/statue/silver/urn = 4,
		/obj/item/statue/silver/obelisk = 4,
		/obj/item/statue/silver/totem = 4,
		/obj/item/statue/gold/figurine = 4,
		/obj/item/statue/gold/loot = 4,
		/obj/item/statue/steel = 3,
		/obj/item/statue/bronze/urn = 4,
		/obj/item/statue/bronze/volf = 4
	)

/datum/loot_table/treasure/hoard
	name = "hoard"
	loot_table = list(
		/obj/item/carvedgem/turq/cutgem = 8,
		/obj/item/carvedgem/turq/bust = 4,
		/obj/item/carvedgem/turq/ka = 2,
		/obj/item/carvedgem/turq/scarab = 2,
		/obj/item/carvedgem/opal/cutgem = 8,
		/obj/item/carvedgem/opal/bust = 4,
		/obj/item/carvedgem/opal/crab = 2,
		/obj/item/carvedgem/jade/wyrm = 2,
		/obj/item/carvedgem/amber/beaver = 2,
		/obj/item/carvedgem/amber/sun = 2,
		/obj/item/carvedgem/coral/shark = 2,
		/obj/item/carvedgem/onyxa/spider = 2,
		/obj/item/carvedgem/onyxa/snake = 2,
		/obj/item/statue/gold/bust = 5,
		/obj/item/statue/gold/urn = 5,
		/obj/item/statue/gold/vasefancy = 4,
		/obj/item/statue/gold/volf = 4,
		/obj/item/statue/gold/totem = 3,
		/obj/item/statue/gold = 2,
		/obj/item/ingot/gold = 5,
		/obj/item/ingot/silver = 5,
		/obj/item/reagent_containers/glass/carafe/teapot/gold = 2
	)
