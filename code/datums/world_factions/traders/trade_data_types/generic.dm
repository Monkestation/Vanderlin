/datum/trader_data/food_merchant
	name = "Food"
	base_type = list(/datum/supply_pack/food)
	initial_products = list()
	initial_wanteds = list(
		/obj/item/reagent_containers/glass = list(4, INFINITY, ""),
		/obj/item/storage/bag = list(5, INFINITY, ""),
	)
	say_phrases = list(
		ITEM_REJECTED_PHRASE = list(
			"Sorry, I'm not a fan of anything you're showing me. Give me something better and we'll talk.",
		),
		ITEM_SELLING_CANCELED_PHRASE = list(
			"What a shame, tell me if you changed your mind.",
		),
		ITEM_SELLING_ACCEPTED_PHRASE = list(
			"Pleasure doing business with you.",
		),
		INTERESTED_PHRASE = list(
			"Hey, you've got an item that interests me, I'd like to buy it, I'll give you some cash for it, deal?",
		),
		BUY_PHRASE = list(
			"Pleasure doing business with you.",
		),
		NO_CASH_PHRASE = list(
			"Sorry adventurer, I can't give credit! Come back when you're a little mmmmm... richer!",
		),
		NO_STOCK_PHRASE = list(
			"Sorry adventurer, but that item is not in stock at the moment.",
		),
		NOT_WILLING_TO_BUY_PHRASE = list(
			"I don't want to buy that item for the time being, check back another time.",
		),
		ITEM_IS_WORTHLESS_PHRASE = list(
			"This item seems to be worthless on a closer look, I won't buy this.",
		),
		TRADER_HAS_ENOUGH_ITEM_PHRASE = list(
			"I already bought enough of this for the time being.",
		),
		TRADER_NOT_BUYING_ANYTHING = list(
			"I'm currently buying nothing at the moment.",
		),
		TRADER_NOT_SELLING_ANYTHING = list(
			"I'm currently selling nothing at the moment.",
		),
		TRADER_BATTLE_START_PHRASE = list(
			"Thief!",
		),
		TRADER_BATTLE_END_PHRASE = list(
			"That is a discount I call death.",
		),
		TRADER_LORE_PHRASE = list(
			"Fresh goods from distant lands!",
			"Taste the flavors of the world!",
			"My cargo hold is full of delicacies!",
		),
		TRADER_SHOP_OPENING_PHRASE = list(
			"Come try exotic cuisines!",
		),
	)

/datum/trader_data/clothing_merchant
	name = "Clothier"
	base_type = list(/datum/supply_pack/apparel)
	initial_products = list()
	initial_wanteds = list(
		/obj/item/natural/cloth = list(3, INFINITY, ""),
		/obj/item/dye_pack/cheap = list(15, INFINITY, ""),
	)
	say_phrases = list(
		ITEM_REJECTED_PHRASE = list(
			"Sorry, I'm not a fan of anything you're showing me. Give me something better and we'll talk.",
		),
		ITEM_SELLING_CANCELED_PHRASE = list(
			"What a shame, tell me if you changed your mind.",
		),
		ITEM_SELLING_ACCEPTED_PHRASE = list(
			"Pleasure doing business with you.",
		),
		INTERESTED_PHRASE = list(
			"Hey, you've got an item that interests me, I'd like to buy it, I'll give you some cash for it, deal?",
		),
		BUY_PHRASE = list(
			"Pleasure doing business with you.",
		),
		NO_CASH_PHRASE = list(
			"Sorry adventurer, I can't give credit! Come back when you're a little mmmmm... richer!",
		),
		NO_STOCK_PHRASE = list(
			"Sorry adventurer, but that item is not in stock at the moment.",
		),
		NOT_WILLING_TO_BUY_PHRASE = list(
			"I don't want to buy that item for the time being, check back another time.",
		),
		ITEM_IS_WORTHLESS_PHRASE = list(
			"This item seems to be worthless on a closer look, I won't buy this.",
		),
		TRADER_HAS_ENOUGH_ITEM_PHRASE = list(
			"I already bought enough of this for the time being.",
		),
		TRADER_NOT_BUYING_ANYTHING = list(
			"I'm currently buying nothing at the moment.",
		),
		TRADER_NOT_SELLING_ANYTHING = list(
			"I'm currently selling nothing at the moment.",
		),
		TRADER_BATTLE_START_PHRASE = list(
			"Thief!",
		),
		TRADER_BATTLE_END_PHRASE = list(
			"That is a discount I call death.",
		),
		TRADER_LORE_PHRASE = list(
			"Finest fabrics from across the seas!",
			"Fashion that would make nobles jealous!",
			"Cloth woven by master artisans!",
		),
		TRADER_SHOP_OPENING_PHRASE = list(
			"Clothe yourself in foreign finery!",
		),
	)

/datum/trader_data/luxury_merchant
	name = "Luxury"
	base_type = list(/datum/supply_pack/luxury)
	initial_products = list()
	initial_wanteds = list(
		/obj/item/ingot/gold = list(30, INFINITY, ""),
		/obj/item/gem = list(20, INFINITY, ""),
	)
	custom_items = list(
		/obj/item/reagent_containers/glass/cup/teacup/fancy = list(5, 10, 6),
		/obj/item/reagent_containers/glass/carafe/teapot = list(5, 40, 1),
	)
	say_phrases = list(
		ITEM_REJECTED_PHRASE = list(
			"Sorry, I'm not a fan of anything you're showing me. Give me something better and we'll talk.",
		),
		ITEM_SELLING_CANCELED_PHRASE = list(
			"What a shame, tell me if you changed your mind.",
		),
		ITEM_SELLING_ACCEPTED_PHRASE = list(
			"Pleasure doing business with you.",
		),
		INTERESTED_PHRASE = list(
			"Hey, you've got an item that interests me, I'd like to buy it, I'll give you some cash for it, deal?",
		),
		BUY_PHRASE = list(
			"Pleasure doing business with you.",
		),
		NO_CASH_PHRASE = list(
			"Sorry adventurer, I can't give credit! Come back when you're a little mmmmm... richer!",
		),
		NO_STOCK_PHRASE = list(
			"Sorry adventurer, but that item is not in stock at the moment.",
		),
		NOT_WILLING_TO_BUY_PHRASE = list(
			"I don't want to buy that item for the time being, check back another time.",
		),
		ITEM_IS_WORTHLESS_PHRASE = list(
			"This item seems to be worthless on a closer look, I won't buy this.",
		),
		TRADER_HAS_ENOUGH_ITEM_PHRASE = list(
			"I already bought enough of this for the time being.",
		),
		TRADER_NOT_BUYING_ANYTHING = list(
			"I'm currently buying nothing at the moment.",
		),
		TRADER_NOT_SELLING_ANYTHING = list(
			"I'm currently selling nothing at the moment.",
		),
		TRADER_BATTLE_START_PHRASE = list(
			"Thief!",
		),
		TRADER_BATTLE_END_PHRASE = list(
			"That is a discount I call death.",
		),
		TRADER_LORE_PHRASE = list(
			"Treasures fit for royalty!",
			"Luxury beyond your wildest dreams!",
			"Each piece tells a story of distant courts!",
		),
		TRADER_SHOP_OPENING_PHRASE = list(
			"Behold, wonders from afar!",
		),
	)

/datum/trader_data/tool_merchant
	name = "Tool"
	base_type = list(/datum/supply_pack/tools)
	initial_products = list()
	initial_wanteds = list(
		/obj/item/ingot/iron = list(5, INFINITY, ""),
		/obj/item/natural/wood = list(8, INFINITY, ""),
	)
	say_phrases = list(
		ITEM_REJECTED_PHRASE = list(
			"Sorry, I'm not a fan of anything you're showing me. Give me something better and we'll talk.",
		),
		ITEM_SELLING_CANCELED_PHRASE = list(
			"What a shame, tell me if you changed your mind.",
		),
		ITEM_SELLING_ACCEPTED_PHRASE = list(
			"Pleasure doing business with you.",
		),
		INTERESTED_PHRASE = list(
			"Hey, you've got an item that interests me, I'd like to buy it, I'll give you some cash for it, deal?",
		),
		BUY_PHRASE = list(
			"Pleasure doing business with you.",
		),
		NO_CASH_PHRASE = list(
			"Sorry adventurer, I can't give credit! Come back when you're a little mmmmm... richer!",
		),
		NO_STOCK_PHRASE = list(
			"Sorry adventurer, but that item is not in stock at the moment.",
		),
		NOT_WILLING_TO_BUY_PHRASE = list(
			"I don't want to buy that item for the time being, check back another time.",
		),
		ITEM_IS_WORTHLESS_PHRASE = list(
			"This item seems to be worthless on a closer look, I won't buy this.",
		),
		TRADER_HAS_ENOUGH_ITEM_PHRASE = list(
			"I already bought enough of this for the time being.",
		),
		TRADER_NOT_BUYING_ANYTHING = list(
			"I'm currently buying nothing at the moment.",
		),
		TRADER_NOT_SELLING_ANYTHING = list(
			"I'm currently selling nothing at the moment.",
		),
		TRADER_BATTLE_START_PHRASE = list(
			"Thief!",
		),
		TRADER_BATTLE_END_PHRASE = list(
			"That is a discount I call death.",
		),
		TRADER_LORE_PHRASE = list(
			"Tools forged by master craftsmen!",
			"Implements to make work easier!",
			"Quality instruments from skilled smiths!",
		),
		TRADER_SHOP_OPENING_PHRASE = list(
			"Equip yourself with proper tools!",
		),
	)

/datum/trader_data/alchemist
	name = "Alchemical"
	base_type = list(/datum/supply_pack/narcotics)
	initial_products = list()
	initial_wanteds = list(
		/obj/item/natural/bundle/fibers = list(6, INFINITY, ""),
		/obj/item/fertilizer/ash = list(10, INFINITY, ""),
	)
	say_phrases = list(
		ITEM_REJECTED_PHRASE = list(
			"Sorry, I'm not a fan of anything you're showing me. Give me something better and we'll talk.",
		),
		ITEM_SELLING_CANCELED_PHRASE = list(
			"What a shame, tell me if you changed your mind.",
		),
		ITEM_SELLING_ACCEPTED_PHRASE = list(
			"Pleasure doing business with you.",
		),
		INTERESTED_PHRASE = list(
			"Hey, you've got an item that interests me, I'd like to buy it, I'll give you some cash for it, deal?",
		),
		BUY_PHRASE = list(
			"Pleasure doing business with you.",
		),
		NO_CASH_PHRASE = list(
			"Sorry adventurer, I can't give credit! Come back when you're a little mmmmm... richer!",
		),
		NO_STOCK_PHRASE = list(
			"Sorry adventurer, but that item is not in stock at the moment.",
		),
		NOT_WILLING_TO_BUY_PHRASE = list(
			"I don't want to buy that item for the time being, check back another time.",
		),
		ITEM_IS_WORTHLESS_PHRASE = list(
			"This item seems to be worthless on a closer look, I won't buy this.",
		),
		TRADER_HAS_ENOUGH_ITEM_PHRASE = list(
			"I already bought enough of this for the time being.",
		),
		TRADER_NOT_BUYING_ANYTHING = list(
			"I'm currently buying nothing at the moment.",
		),
		TRADER_NOT_SELLING_ANYTHING = list(
			"I'm currently selling nothing at the moment.",
		),
		TRADER_BATTLE_START_PHRASE = list(
			"Thief!",
		),
		TRADER_BATTLE_END_PHRASE = list(
			"That is a discount I call death.",
		),
		TRADER_LORE_PHRASE = list(
			"Ancient remedies and exotic compounds!",
			"Elixirs brewed in distant laboratories!",
			"Potions that blur the line between medicine and magic!",
		),
		TRADER_SHOP_OPENING_PHRASE = list(
			"Sample my mystical concoctions!",
		),
	)

/datum/trader_data/material_merchant
	name = "Material"
	base_type = list(/datum/supply_pack/rawmats)
	initial_products = list()
	initial_wanteds = list(
		/obj/item/natural/wood/plank = list(5, INFINITY, ""),
		/obj/item/natural/stone = list(7, INFINITY, ""),
	)
	say_phrases = list(
		ITEM_REJECTED_PHRASE = list(
			"Sorry, I'm not a fan of anything you're showing me. Give me something better and we'll talk.",
		),
		ITEM_SELLING_CANCELED_PHRASE = list(
			"What a shame, tell me if you changed your mind.",
		),
		ITEM_SELLING_ACCEPTED_PHRASE = list(
			"Pleasure doing business with you.",
		),
		INTERESTED_PHRASE = list(
			"Hey, you've got an item that interests me, I'd like to buy it, I'll give you some cash for it, deal?",
		),
		BUY_PHRASE = list(
			"Pleasure doing business with you.",
		),
		NO_CASH_PHRASE = list(
			"Sorry adventurer, I can't give credit! Come back when you're a little mmmmm... richer!",
		),
		NO_STOCK_PHRASE = list(
			"Sorry adventurer, but that item is not in stock at the moment.",
		),
		NOT_WILLING_TO_BUY_PHRASE = list(
			"I don't want to buy that item for the time being, check back another time.",
		),
		ITEM_IS_WORTHLESS_PHRASE = list(
			"This item seems to be worthless on a closer look, I won't buy this.",
		),
		TRADER_HAS_ENOUGH_ITEM_PHRASE = list(
			"I already bought enough of this for the time being.",
		),
		TRADER_NOT_BUYING_ANYTHING = list(
			"I'm currently buying nothing at the moment.",
		),
		TRADER_NOT_SELLING_ANYTHING = list(
			"I'm currently selling nothing at the moment.",
		),
		TRADER_BATTLE_START_PHRASE = list(
			"Thief!",
		),
		TRADER_BATTLE_END_PHRASE = list(
			"That is a discount I call death.",
		),
		TRADER_LORE_PHRASE = list(
			"Raw materials from the far corners of the world!",
			"Building blocks for your grandest projects!",
			"Resources gathered from untamed lands!",
		),
		TRADER_SHOP_OPENING_PHRASE = list(
			"Stock up on quality materials!",
		),
	)

/datum/trader_data/weapon_merchant
	name = "Arms Dealer"
	base_type = list(/datum/supply_pack/weapons)
	initial_products = list()
	initial_wanteds = list(
		/obj/item/ingot/steel = list(8, INFINITY, ""),
		/obj/item/natural/hide = list(12, INFINITY, ""),
		/obj/item/natural/wood = list(6, INFINITY, ""),
	)
	say_phrases = list(
		ITEM_REJECTED_PHRASE = list(
			"Sorry, I'm not a fan of anything you're showing me. Give me something better and we'll talk.",
		),
		ITEM_SELLING_CANCELED_PHRASE = list(
			"What a shame, tell me if you changed your mind.",
		),
		ITEM_SELLING_ACCEPTED_PHRASE = list(
			"Pleasure doing business with you.",
		),
		INTERESTED_PHRASE = list(
			"Hey, you've got an item that interests me, I'd like to buy it, I'll give you some cash for it, deal?",
		),
		BUY_PHRASE = list(
			"Pleasure doing business with you.",
		),
		NO_CASH_PHRASE = list(
			"Sorry adventurer, I can't give credit! Come back when you're a little mmmmm... richer!",
		),
		NO_STOCK_PHRASE = list(
			"Sorry adventurer, but that item is not in stock at the moment.",
		),
		NOT_WILLING_TO_BUY_PHRASE = list(
			"I don't want to buy that item for the time being, check back another time.",
		),
		ITEM_IS_WORTHLESS_PHRASE = list(
			"This item seems to be worthless on a closer look, I won't buy this.",
		),
		TRADER_HAS_ENOUGH_ITEM_PHRASE = list(
			"I already bought enough of this for the time being.",
		),
		TRADER_NOT_BUYING_ANYTHING = list(
			"I'm currently buying nothing at the moment.",
		),
		TRADER_NOT_SELLING_ANYTHING = list(
			"I'm currently selling nothing at the moment.",
		),
		TRADER_BATTLE_START_PHRASE = list(
			"Thief!",
		),
		TRADER_BATTLE_END_PHRASE = list(
			"That is a discount I call death.",
		),
		TRADER_LORE_PHRASE = list(
			"Blades forged in distant foundries!",
			"Weapons that have tasted victory!",
			"Arms to protect and conquer!",
			"Steel tested in a hundred battles!",
		),
		TRADER_SHOP_OPENING_PHRASE = list(
			"Arm yourself for whatever comes!",
			"Quality steel for discerning warriors!",
		),
	)

/datum/trader_data/livestock_merchant
	name = "Beast Trader"
	base_type = list(/datum/supply_pack/livestock)
	initial_products = list()
	initial_wanteds = list(
		/obj/item/reagent_containers/food/snacks/grown = list(5, INFINITY, ""),
		/obj/item/reagent_containers/food/snacks/produce/grain = list(8, INFINITY, ""),
		/obj/item/rope = list(10, INFINITY, ""),
	)
	say_phrases = list(
		ITEM_REJECTED_PHRASE = list(
			"Sorry, I'm not a fan of anything you're showing me. Give me something better and we'll talk.",
		),
		ITEM_SELLING_CANCELED_PHRASE = list(
			"What a shame, tell me if you changed your mind.",
		),
		ITEM_SELLING_ACCEPTED_PHRASE = list(
			"Pleasure doing business with you.",
		),
		INTERESTED_PHRASE = list(
			"Hey, you've got an item that interests me, I'd like to buy it, I'll give you some cash for it, deal?",
		),
		BUY_PHRASE = list(
			"Pleasure doing business with you.",
		),
		NO_CASH_PHRASE = list(
			"Sorry adventurer, I can't give credit! Come back when you're a little mmmmm... richer!",
		),
		NO_STOCK_PHRASE = list(
			"Sorry adventurer, but that item is not in stock at the moment.",
		),
		NOT_WILLING_TO_BUY_PHRASE = list(
			"I don't want to buy that item for the time being, check back another time.",
		),
		ITEM_IS_WORTHLESS_PHRASE = list(
			"This item seems to be worthless on a closer look, I won't buy this.",
		),
		TRADER_HAS_ENOUGH_ITEM_PHRASE = list(
			"I already bought enough of this for the time being.",
		),
		TRADER_NOT_BUYING_ANYTHING = list(
			"I'm currently buying nothing at the moment.",
		),
		TRADER_NOT_SELLING_ANYTHING = list(
			"I'm currently selling nothing at the moment.",
		),
		TRADER_BATTLE_START_PHRASE = list(
			"Thief!",
		),
		TRADER_BATTLE_END_PHRASE = list(
			"That is a discount I call death.",
		),
		TRADER_LORE_PHRASE = list(
			"Creatures from lands unknown!",
			"Beasts to serve and companion you!",
			"Animals bred by expert handlers!",
			"Livestock to enrich your holdings!",
		),
		TRADER_SHOP_OPENING_PHRASE = list(
			"Behold my menagerie of wonders!",
			"Creatures great and small!",
		),
	)

/datum/trader_data/seed_merchant
	name = "Seedsman"
	base_type = list(/datum/supply_pack/seeds)
	initial_products = list()
	initial_wanteds = list(
		/obj/item/fertilizer/ash = list(5, INFINITY, ""),
		/obj/item/natural/bundle/fibers = list(8, INFINITY, ""),
		/obj/item/reagent_containers/glass = list(3, INFINITY, ""),
	)
	custom_items = list(
		/obj/item/neuFarm/seed/wheat/ancient = list(4, 15, 1),
		/obj/item/neuFarm/seed/tea = list(4, 19, 3),
		/obj/item/neuFarm/seed/coffee = list(4, 22, 5),
		/obj/item/queen_bee = list(11, 50, 2),
	)
	say_phrases = list(
		ITEM_REJECTED_PHRASE = list(
			"Sorry, I'm not a fan of anything you're showing me. Give me something better and we'll talk.",
		),
		ITEM_SELLING_CANCELED_PHRASE = list(
			"What a shame, tell me if you changed your mind.",
		),
		ITEM_SELLING_ACCEPTED_PHRASE = list(
			"Pleasure doing business with you.",
		),
		INTERESTED_PHRASE = list(
			"Hey, you've got an item that interests me, I'd like to buy it, I'll give you some cash for it, deal?",
		),
		BUY_PHRASE = list(
			"Pleasure doing business with you.",
		),
		NO_CASH_PHRASE = list(
			"Sorry adventurer, I can't give credit! Come back when you're a little mmmmm... richer!",
		),
		NO_STOCK_PHRASE = list(
			"Sorry adventurer, but that item is not in stock at the moment.",
		),
		NOT_WILLING_TO_BUY_PHRASE = list(
			"I don't want to buy that item for the time being, check back another time.",
		),
		ITEM_IS_WORTHLESS_PHRASE = list(
			"This item seems to be worthless on a closer look, I won't buy this.",
		),
		TRADER_HAS_ENOUGH_ITEM_PHRASE = list(
			"I already bought enough of this for the time being.",
		),
		TRADER_NOT_BUYING_ANYTHING = list(
			"I'm currently buying nothing at the moment.",
		),
		TRADER_NOT_SELLING_ANYTHING = list(
			"I'm currently selling nothing at the moment.",
		),
		TRADER_BATTLE_START_PHRASE = list(
			"Thief!",
		),
		TRADER_BATTLE_END_PHRASE = list(
			"That is a discount I call death.",
		),
		TRADER_LORE_PHRASE = list(
			"Seeds from gardens across the world!",
			"Plants that will transform your land!",
			"Crops unknown to these shores!",
			"The future of your harvest in my hands!",
		),
		TRADER_SHOP_OPENING_PHRASE = list(
			"Sow the seeds of prosperity!",
			"Exotic flora awaits your soil!",
		),
	)

/datum/trader_data/instrument_merchant
	name = "Minstrel"
	base_type = list(/datum/supply_pack/instruments)
	initial_products = list()
	initial_wanteds = list(
		/obj/item/natural/wood = list(4, INFINITY, ""),
		/obj/item/natural/bundle/fibers = list(6, INFINITY, ""),
	)
	say_phrases = list(
		ITEM_REJECTED_PHRASE = list(
			"Sorry, I'm not a fan of anything you're showing me. Give me something better and we'll talk.",
		),
		ITEM_SELLING_CANCELED_PHRASE = list(
			"What a shame, tell me if you changed your mind.",
		),
		ITEM_SELLING_ACCEPTED_PHRASE = list(
			"Pleasure doing business with you.",
		),
		INTERESTED_PHRASE = list(
			"Hey, you've got an item that interests me, I'd like to buy it, I'll give you some cash for it, deal?",
		),
		BUY_PHRASE = list(
			"Pleasure doing business with you.",
		),
		NO_CASH_PHRASE = list(
			"Sorry adventurer, I can't give credit! Come back when you're a little mmmmm... richer!",
		),
		NO_STOCK_PHRASE = list(
			"Sorry adventurer, but that item is not in stock at the moment.",
		),
		NOT_WILLING_TO_BUY_PHRASE = list(
			"I don't want to buy that item for the time being, check back another time.",
		),
		ITEM_IS_WORTHLESS_PHRASE = list(
			"This item seems to be worthless on a closer look, I won't buy this.",
		),
		TRADER_HAS_ENOUGH_ITEM_PHRASE = list(
			"I already bought enough of this for the time being.",
		),
		TRADER_NOT_BUYING_ANYTHING = list(
			"I'm currently buying nothing at the moment.",
		),
		TRADER_NOT_SELLING_ANYTHING = list(
			"I'm currently selling nothing at the moment.",
		),
		TRADER_BATTLE_START_PHRASE = list(
			"Thief!",
		),
		TRADER_BATTLE_END_PHRASE = list(
			"That is a discount I call death.",
		),
		TRADER_LORE_PHRASE = list(
			"Music from every corner of the realm!",
			"Instruments crafted by master artisans!",
			"Melodies waiting to be born!",
			"The sound of distant cultures!",
		),
		TRADER_SHOP_OPENING_PHRASE = list(
			"Let music fill your halls!",
			"Bring harmony to harsh lands!",
		),
	)

/datum/trader_data/book_merchant
	name = "Scholar"
	base_type = list(/datum/supply_pack/rawmats, /datum/supply_pack/narcotics)
	initial_products = list()
	initial_wanteds = list(
		/obj/item/natural/feather = list(8, INFINITY, ""),
		/obj/item/fertilizer/ash = list(5, INFINITY, ""),
		/obj/item/natural/hide = list(15, INFINITY, ""),
	)
	say_phrases = list(
		ITEM_REJECTED_PHRASE = list(
			"Sorry, I'm not a fan of anything you're showing me. Give me something better and we'll talk.",
		),
		ITEM_SELLING_CANCELED_PHRASE = list(
			"What a shame, tell me if you changed your mind.",
		),
		ITEM_SELLING_ACCEPTED_PHRASE = list(
			"Pleasure doing business with you.",
		),
		INTERESTED_PHRASE = list(
			"Hey, you've got an item that interests me, I'd like to buy it, I'll give you some cash for it, deal?",
		),
		BUY_PHRASE = list(
			"Pleasure doing business with you.",
		),
		NO_CASH_PHRASE = list(
			"Sorry adventurer, I can't give credit! Come back when you're a little mmmmm... richer!",
		),
		NO_STOCK_PHRASE = list(
			"Sorry adventurer, but that item is not in stock at the moment.",
		),
		NOT_WILLING_TO_BUY_PHRASE = list(
			"I don't want to buy that item for the time being, check back another time.",
		),
		ITEM_IS_WORTHLESS_PHRASE = list(
			"This item seems to be worthless on a closer look, I won't buy this.",
		),
		TRADER_HAS_ENOUGH_ITEM_PHRASE = list(
			"I already bought enough of this for the time being.",
		),
		TRADER_NOT_BUYING_ANYTHING = list(
			"I'm currently buying nothing at the moment.",
		),
		TRADER_NOT_SELLING_ANYTHING = list(
			"I'm currently selling nothing at the moment.",
		),
		TRADER_BATTLE_START_PHRASE = list(
			"Thief!",
		),
		TRADER_BATTLE_END_PHRASE = list(
			"That is a discount I call death.",
		),
		TRADER_LORE_PHRASE = list(
			"Knowledge from forgotten libraries!",
			"Wisdom of ages past and present!",
			"Scrolls penned by learned sages!",
			"The accumulated learning of civilizations!",
		),
		TRADER_SHOP_OPENING_PHRASE = list(
			"Enlighten yourself with ancient wisdom!",
			"Knowledge is the greatest treasure!",
		),
	)

/datum/trader_data/medicine_merchant
	name = "Healer"
	base_type = list(/datum/supply_pack/narcotics)
	initial_products = list()
	initial_wanteds = list(
		/obj/item/natural/bundle/fibers = list(4, INFINITY, ""),
		/obj/item/reagent_containers/glass = list(6, INFINITY, ""),
		/obj/item/natural/cloth = list(8, INFINITY, ""),
	)
	say_phrases = list(
		ITEM_REJECTED_PHRASE = list(
			"Sorry, I'm not a fan of anything you're showing me. Give me something better and we'll talk.",
		),
		ITEM_SELLING_CANCELED_PHRASE = list(
			"What a shame, tell me if you changed your mind.",
		),
		ITEM_SELLING_ACCEPTED_PHRASE = list(
			"Pleasure doing business with you.",
		),
		INTERESTED_PHRASE = list(
			"Hey, you've got an item that interests me, I'd like to buy it, I'll give you some cash for it, deal?",
		),
		BUY_PHRASE = list(
			"Pleasure doing business with you.",
		),
		NO_CASH_PHRASE = list(
			"Sorry adventurer, I can't give credit! Come back when you're a little mmmmm... richer!",
		),
		NO_STOCK_PHRASE = list(
			"Sorry adventurer, but that item is not in stock at the moment.",
		),
		NOT_WILLING_TO_BUY_PHRASE = list(
			"I don't want to buy that item for the time being, check back another time.",
		),
		ITEM_IS_WORTHLESS_PHRASE = list(
			"This item seems to be worthless on a closer look, I won't buy this.",
		),
		TRADER_HAS_ENOUGH_ITEM_PHRASE = list(
			"I already bought enough of this for the time being.",
		),
		TRADER_NOT_BUYING_ANYTHING = list(
			"I'm currently buying nothing at the moment.",
		),
		TRADER_NOT_SELLING_ANYTHING = list(
			"I'm currently selling nothing at the moment.",
		),
		TRADER_BATTLE_START_PHRASE = list(
			"Thief!",
		),
		TRADER_BATTLE_END_PHRASE = list(
			"That is a discount I call death.",
		),
		TRADER_LORE_PHRASE = list(
			"Remedies from distant healers!",
			"Medicines that mend what's broken!",
			"Salves and tonics for every ailment!",
			"The art of healing from many lands!",
		),
		TRADER_SHOP_OPENING_PHRASE = list(
			"Health is the greatest wealth!",
			"Restore what time has taken!",
		),
	)

/datum/trader_data/exotic_merchant
	name = "Curiosity Dealer"
	base_type = list(/datum/supply_pack/jewelry)
	initial_products = list()
	initial_wanteds = list(
		/obj/item/gem = list(25, INFINITY, ""),
		/obj/item/ingot/gold = list(40, INFINITY, ""),
	)
	say_phrases = list(
		ITEM_REJECTED_PHRASE = list(
			"Sorry, I'm not a fan of anything you're showing me. Give me something better and we'll talk.",
		),
		ITEM_SELLING_CANCELED_PHRASE = list(
			"What a shame, tell me if you changed your mind.",
		),
		ITEM_SELLING_ACCEPTED_PHRASE = list(
			"Pleasure doing business with you.",
		),
		INTERESTED_PHRASE = list(
			"Hey, you've got an item that interests me, I'd like to buy it, I'll give you some cash for it, deal?",
		),
		BUY_PHRASE = list(
			"Pleasure doing business with you.",
		),
		NO_CASH_PHRASE = list(
			"Sorry adventurer, I can't give credit! Come back when you're a little mmmmm... richer!",
		),
		NO_STOCK_PHRASE = list(
			"Sorry adventurer, but that item is not in stock at the moment.",
		),
		NOT_WILLING_TO_BUY_PHRASE = list(
			"I don't want to buy that item for the time being, check back another time.",
		),
		ITEM_IS_WORTHLESS_PHRASE = list(
			"This item seems to be worthless on a closer look, I won't buy this.",
		),
		TRADER_HAS_ENOUGH_ITEM_PHRASE = list(
			"I already bought enough of this for the time being.",
		),
		TRADER_NOT_BUYING_ANYTHING = list(
			"I'm currently buying nothing at the moment.",
		),
		TRADER_NOT_SELLING_ANYTHING = list(
			"I'm currently selling nothing at the moment.",
		),
		TRADER_BATTLE_START_PHRASE = list(
			"Thief!",
		),
		TRADER_BATTLE_END_PHRASE = list(
			"That is a discount I call death.",
		),
		TRADER_LORE_PHRASE = list(
			"Oddities from the furthest reaches!",
			"Curiosities that defy explanation!",
			"Rarities collected across lifetimes!",
			"Wonders that few eyes have seen!",
		),
		TRADER_SHOP_OPENING_PHRASE = list(
			"Marvel at the impossible!",
			"Treasures beyond imagination!",
		),
	)
