
/datum/loot_table/coin
	name = "generic coins"
	loot_table = list(
		/obj/item/coin/gold/pile = 5,
		/obj/item/coin/gold = 10,
		/obj/item/coin/silver/pile = 20,
		/obj/item/coin/silver = 25,
		/obj/item/coin/copper/pile = 30,
		/obj/item/coin/copper = 35
	)
	base_max = 3

/datum/loot_table/coin/low
	name = "generic coins low"
	loot_table = list(
		/obj/item/coin/copper/pile = 75,
		/obj/item/coin/copper = 25
	)

/datum/loot_table/coin/med
	name = "generic coins medium"
	loot_table = list(
		/obj/item/coin/silver/pile = 75,
		/obj/item/coin/silver = 25
	)

/datum/loot_table/coin/high
	name = "generic coins high"
	loot_table = list(
		/obj/item/coin/gold/pile = 75,
		/obj/item/coin/gold = 25
	)

/datum/loot_table/coin/absurd
	name = "generic coins absurd"
	loot_table = list(
		/obj/item/coin/gold/pile = 50,
		/obj/item/gem = 50
	)
