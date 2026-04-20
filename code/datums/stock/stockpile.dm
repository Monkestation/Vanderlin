// Guidelines for Stockpiles. Items should always cost ~50% more to withdraw than was received for depositing.
// Export Prices should fall between the payout and the withdraw, unless the item is incredibly cheap.

/datum/stock/stockpile
	var/oversupply_amount = 999
	var/oversupply_payout = 0

/datum/stock/stockpile/get_payout_price(obj/item/I)
	return (held_items >= oversupply_amount) ? oversupply_payout : payout_price

/datum/stock/stockpile/wood
	name = "Small Log"
	desc = "Wooden logs cut short for transport."
	item_type = /obj/item/grown/log/tree/small
	held_items = 5
	payout_price = 1
	withdraw_price = 6
	export_price = 5
	importexport_amt = 10
	oversupply_amount = 25

/datum/stock/stockpile/stone
	name = "Stone"
	desc = "Chunks of stone good for masonry and construction."
	item_type = /obj/item/natural/stone
	held_items = 5
	payout_price = 1
	withdraw_price = 4
	export_price = 3
	importexport_amt = 10
	oversupply_amount = 25

/datum/stock/stockpile/cloth
	name = "Cloth"
	desc = "Cloth sewn for further sewing and tailoring."
	item_type = /obj/item/natural/cloth
	held_items = 4
	payout_price = 1
	withdraw_price = 3
	export_price = 2
	importexport_amt = 10
	oversupply_amount = 20

/datum/stock/stockpile/hide
	name = "Hide"
	desc = "Hide stripped off of prey."
	item_type = /obj/item/natural/hide
	held_items = 0
	importexport_amt = 10
	payout_price = 4
	withdraw_price = 7
	export_price = 6
	importexport_amt = 10

/datum/stock/stockpile/cured
	name = "Cured Leather"
	desc = "Cured Leather ready to be worked."
	item_type = /obj/item/natural/hide/cured
	held_items = 4
	payout_price = 3
	withdraw_price = 15
	export_price = 12

/datum/stock/stockpile/silk
	name = "Silk"
	desc = "Strands of fine silk used for exotic weaving"
	item_type = /obj/item/natural/silk
	held_items = 4
	payout_price = 5
	withdraw_price = 8
	export_price = 7
	importexport_amt = 10

/datum/stock/stockpile/salt
	name = "Salt"
	desc = "Rock salt useful for curing and cooking."
	item_type = /obj/item/reagent_containers/powder/salt
	held_items = 5
	payout_price = 4
	withdraw_price = 6
	export_price = 5
	importexport_amt = 20
	stockpile_id = STOCK_FOOD

/datum/stock/stockpile/grain
	name = "Grain"
	desc = "Wheat grains primed for milling."
	item_type = /obj/item/reagent_containers/food/snacks/produce/grain/wheat
	held_items = 5
	payout_price = 2
	withdraw_price = 6
	export_price = 5
	importexport_amt = 20
	stockpile_id = STOCK_FOOD

/datum/stock/stockpile/oat
	name = "Oat"
	desc = "Oat grains primed for milling."
	item_type = /obj/item/reagent_containers/food/snacks/produce/grain/oat
	held_items = 5
	payout_price = 2
	withdraw_price = 6
	export_price = 5
	importexport_amt = 20
	stockpile_id = STOCK_FOOD

/datum/stock/stockpile/sunreed
	name = "Sunreed"
	desc = "An extremely hard grain primed for milling."
	item_type = /obj/item/reagent_containers/food/snacks/produce/grain/sunreed
	held_items = 5
	payout_price = 2
	withdraw_price = 6
	export_price = 5
	importexport_amt = 20
	stockpile_id = STOCK_FOOD

/datum/stock/stockpile/apple
	name = "Apples"
	desc = "A sweet and nutritious fruit."
	item_type = /obj/item/reagent_containers/food/snacks/produce/fruit/apple
	held_items = 2
	payout_price = 2
	withdraw_price = 5
	export_price = 4
	importexport_amt = 20
	stockpile_id = STOCK_FOOD

/datum/stock/stockpile/pear
	name = "Pears"
	desc = "Very sweet, oblong fruits."
	item_type = /obj/item/reagent_containers/food/snacks/produce/fruit/pear
	held_items = 2
	payout_price = 2
	withdraw_price = 5
	export_price = 4
	importexport_amt = 20
	stockpile_id = STOCK_FOOD

/datum/stock/stockpile/lemon
	name = "Lemons"
	desc = "Sour fruit that is often added to other dishes."
	item_type = /obj/item/reagent_containers/food/snacks/produce/fruit/lemon
	held_items = 2
	payout_price = 2
	withdraw_price = 5
	export_price = 4
	importexport_amt = 20
	stockpile_id = STOCK_FOOD

/datum/stock/stockpile/lime
	name = "Limes"
	desc = "Sour fruit favored by sailors to ward off scurvy."
	item_type = /obj/item/reagent_containers/food/snacks/produce/fruit/lime
	held_items = 2
	payout_price = 2
	withdraw_price = 5
	export_price = 4
	importexport_amt = 20
	stockpile_id = STOCK_FOOD

/datum/stock/stockpile/tangerine
	name = "Tangerines"
	desc = "A citrus fruit more mild in its sourness."
	item_type = /obj/item/reagent_containers/food/snacks/produce/fruit/tangerine
	held_items = 2
	payout_price = 2
	withdraw_price = 5
	export_price = 4
	importexport_amt = 20
	stockpile_id = STOCK_FOOD

/datum/stock/stockpile/plum
	name = "Plums"
	desc = "A sweet fruit with a large seed in the middle."
	item_type = /obj/item/reagent_containers/food/snacks/produce/fruit/plum
	held_items = 2
	payout_price = 2
	withdraw_price = 5
	export_price = 4
	importexport_amt = 20
	stockpile_id = STOCK_FOOD

/datum/stock/stockpile/mango
	name = "Manggas"
	desc = "A golden tropical fruit bursting with sweet, juicy flesh."
	item_type = /obj/item/reagent_containers/food/snacks/produce/fruit/mango
	held_items = 2
	payout_price = 9
	withdraw_price = 23
	export_price = 18
	importexport_amt = 20
	stockpile_id = STOCK_FOOD

/datum/stock/stockpile/mangosteen
	name = "Mangosteens"
	desc = "A tropical fruit with a thick purple rind and white segments within."
	item_type = /obj/item/reagent_containers/food/snacks/produce/fruit/mangosteen
	held_items = 2
	payout_price = 9
	withdraw_price = 23
	export_price = 18
	importexport_amt = 20
	stockpile_id = STOCK_FOOD

/datum/stock/stockpile/avocado
	name = "Avocados"
	desc = "A verdant tropical fruit known for its smooth and creamy flesh."
	item_type = /obj/item/reagent_containers/food/snacks/produce/fruit/avocado
	held_items = 2
	payout_price = 6
	withdraw_price = 15
	export_price = 12
	importexport_amt = 20
	stockpile_id = STOCK_FOOD

/datum/stock/stockpile/dragonfruit
	name = "Piyatas"
	desc = "A spiky fruit with a pink skin and white flesh."
	item_type = /obj/item/reagent_containers/food/snacks/produce/fruit/dragonfruit
	held_items = 2
	payout_price = 9
	withdraw_price = 23
	export_price = 18
	importexport_amt = 20
	stockpile_id = STOCK_FOOD

/datum/stock/stockpile/pineapple
	name = "Ananas"
	desc = "A spiky, tangy fruit with golden skin."
	item_type = /obj/item/reagent_containers/food/snacks/produce/fruit/pineapple
	held_items = 2
	payout_price = 9
	withdraw_price = 23
	export_price = 18
	importexport_amt = 20
	stockpile_id = STOCK_FOOD

/datum/stock/stockpile/tamto
	name = "Tamtos"
	desc = "A deliciously sweet berry that grows abundantly in the bogs of Daftmarsh."
	item_type = /obj/item/reagent_containers/food/snacks/produce/fruit/tamto
	held_items = 2
	payout_price = 2
	withdraw_price = 5
	export_price = 4
	importexport_amt = 20
	stockpile_id = STOCK_FOOD

/datum/stock/stockpile/pompkaun
	name = "Pompkauns"
	desc = "A large, thick fruit favored by Dendorites and Pestrans."
	item_type = /obj/item/reagent_containers/food/snacks/produce/fruit/pompkaun
	held_items = 2
	payout_price = 2
	withdraw_price = 5
	export_price = 4
	importexport_amt = 20
	stockpile_id = STOCK_FOOD

/datum/stock/stockpile/strawberry
	name = "Strawberries"
	desc = "A variety of sweet berry native to Wintermare."
	item_type = /obj/item/reagent_containers/food/snacks/produce/fruit/strawberry
	held_items = 2
	payout_price = 4
	withdraw_price = 10
	export_price = 8
	importexport_amt = 20
	stockpile_id = STOCK_FOOD

/datum/stock/stockpile/raspberry
	name = "Raspberries"
	desc = "A variety of tart berry formerly common in Vanderlin."
	item_type = /obj/item/reagent_containers/food/snacks/produce/fruit/raspberry
	held_items = 2
	payout_price = 2
	withdraw_price = 5
	export_price = 4
	importexport_amt = 20
	stockpile_id = STOCK_FOOD

/datum/stock/stockpile/blackberry
	name = "Blackberries"
	desc = "A variety of earthy berry formerly common in Vanderlin."
	item_type = /obj/item/reagent_containers/food/snacks/produce/fruit/blackberry
	held_items = 2
	payout_price = 2
	withdraw_price = 5
	export_price = 4
	importexport_amt = 20
	stockpile_id = STOCK_FOOD

/datum/stock/stockpile/jacksberry
	name = "Jacksberries"
	desc = "Common berries found throughout most of Faience."
	item_type = /obj/item/reagent_containers/food/snacks/produce/fruit/jacksberry
	held_items = 2
	payout_price = 1
	withdraw_price = 4
	export_price = 2
	importexport_amt = 12
	stockpile_id = STOCK_FOOD

/datum/stock/stockpile/swampweed
	name = "Swampweed"
	desc = "A weed that can be dried and smoked to induce a relaxed state."
	item_type = /obj/item/reagent_containers/food/snacks/produce/swampweed
	held_items = 2
	payout_price = 2
	withdraw_price = 5
	export_price = 4
	importexport_amt = 20
	stockpile_id = STOCK_FOOD

/datum/stock/stockpile/westleach
	name = "Westleach Leaves"
	desc = "A common, strong-smelling leaf that is often dried and smoked."
	item_type = /obj/item/reagent_containers/food/snacks/produce/westleach
	held_items = 2
	payout_price = 2
	withdraw_price = 5
	export_price = 4
	importexport_amt = 20
	stockpile_id = STOCK_FOOD

/datum/stock/stockpile/sunflower
	name = "Sunflowers"
	desc = "Astratas favoured flower, said to carry some of her warmth and radiance."
	item_type = /obj/item/reagent_containers/food/snacks/produce/sunflower
	held_items = 2
	payout_price = 2
	withdraw_price = 5
	export_price = 4
	importexport_amt = 20
	stockpile_id = STOCK_FOOD

/datum/stock/stockpile/turnip
	name = "Turnips"
	desc = "A hearty root vegetable fit for soup."
	item_type = /obj/item/reagent_containers/food/snacks/produce/vegetable/turnip
	held_items = 2
	payout_price = 2
	withdraw_price = 5
	export_price = 4
	importexport_amt = 20
	stockpile_id = STOCK_FOOD

/datum/stock/stockpile/potato
	name = "Potatoes"
	desc = "A reliable if tough vegetable of Dwarven popularity."
	item_type = /obj/item/reagent_containers/food/snacks/produce/vegetable/potato
	held_items = 2
	payout_price = 2
	withdraw_price = 6
	export_price = 5
	importexport_amt = 20
	stockpile_id = STOCK_FOOD

/datum/stock/stockpile/cabbage
	name = "Cabbages"
	desc = "A vegetable with thick leaves, seen as a symbol of prosperity by some elves."
	item_type = /obj/item/reagent_containers/food/snacks/produce/vegetable/cabbage
	held_items = 2
	payout_price = 2
	withdraw_price = 5
	export_price = 4
	importexport_amt = 20
	stockpile_id = STOCK_FOOD

/datum/stock/stockpile/onion
	name = "Onions"
	desc = "A wonderful vegetable with many layers and a broad flavor profile."
	item_type = /obj/item/reagent_containers/food/snacks/produce/vegetable/onion
	held_items = 2
	payout_price = 2
	withdraw_price = 5
	export_price = 4
	importexport_amt = 20
	stockpile_id = STOCK_FOOD

/datum/stock/stockpile/cocaudo
	name = "Cocaudos"
	desc = "A strange and foreign vegetable that's near impossible to break into."
	item_type = /obj/item/natural/cocaudo
	held_items = 2
	payout_price = 8
	withdraw_price = 20
	export_price = 16
	importexport_amt = 20
	stockpile_id = STOCK_FOOD

/datum/stock/stockpile/borowiki
	name = "Borowiki"
	desc = "A hearty mushroom fit for stews and pies."
	item_type = /obj/item/reagent_containers/food/snacks/produce/mushroom/borowiki
	held_items = 2
	payout_price = 2
	withdraw_price = 7
	export_price = 4
	importexport_amt = 20
	stockpile_id = STOCK_FOOD

/datum/stock/stockpile/waddle
	name = "Waddle"
	desc = "A bright mushroom with a meaty flavor."
	item_type = /obj/item/reagent_containers/food/snacks/produce/mushroom/waddle
	held_items = 2
	payout_price = 2
	withdraw_price = 6
	export_price = 4
	importexport_amt = 20
	stockpile_id = STOCK_FOOD

/datum/stock/stockpile/caveweep
	name = "Caveweep"
	desc = "A mushroom that grows close to the coastline, known for a briny flavor."
	item_type = /obj/item/reagent_containers/food/snacks/produce/mushroom/caveweep
	held_items = 2
	payout_price = 6
	withdraw_price = 18
	export_price = 12
	importexport_amt = 20
	stockpile_id = STOCK_FOOD

/datum/stock/stockpile/drowsbane
	name = "Drowsbane"
	desc = "A type of lichen known for it's fiery effects on the palate."
	item_type = /obj/item/reagent_containers/food/snacks/produce/mushroom/drowsbane
	held_items = 2
	payout_price = 6
	withdraw_price = 18
	export_price = 12
	importexport_amt = 20
	stockpile_id = STOCK_FOOD

/datum/stock/stockpile/coal
	name = "Coal"
	desc = "Chunks of coal used for fuel and alloying."
	item_type = /obj/item/ore/coal
	held_items = 5
	payout_price = 3
	withdraw_price = 6
	export_price = 5
	importexport_amt = 20
	stockpile_id = STOCK_METAL

/datum/stock/stockpile/copper
	name = "Copper Ore"
	desc = "Raw unrefined copper."
	item_type = /obj/item/ore/copper
	held_items = 4
	payout_price = 2
	withdraw_price = 6
	export_price = 5
	importexport_amt = 10
	stockpile_id = STOCK_METAL

/datum/stock/stockpile/tin
	name = "Tin Ore"
	desc = "Raw tin fit for alloying."
	item_type = /obj/item/ore/tin
	held_items = 4
	payout_price = 2
	withdraw_price = 7
	export_price = 6
	importexport_amt = 10
	stockpile_id = STOCK_METAL

/datum/stock/stockpile/iron
	name = "Iron Ore"
	desc = "Raw unrefined iron."
	item_type = /obj/item/ore/iron
	held_items = 2
	payout_price = 4
	withdraw_price = 12
	export_price = 10
	importexport_amt = 10
	stockpile_id = STOCK_METAL

/datum/stock/stockpile/silver
	name = "Silver Ore"
	desc = "Raw unrefined silver."
	item_type = /obj/item/ore/silver
	held_items = 4
	payout_price = 6
	withdraw_price = 15
	export_price = 26
	importexport_amt = 5
	stockpile_id = STOCK_METAL

/datum/stock/stockpile/gold
	name = "Gold Ore"
	desc = "Raw unrefined gold."
	item_type = /obj/item/ore/gold
	held_items = 4
	payout_price = 7
	withdraw_price = 17
	export_price = 30
	importexport_amt = 5
	stockpile_id = STOCK_METAL
