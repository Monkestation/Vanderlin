///Used to contain the traders initial wares, and speech
/datum/trader_data
	var/name = "Generic"
	///The item that marks the shopkeeper will sit on
	var/shop_spot_type =  /obj/structure/chair/stool
	///The sign that will greet the customers
	var/sign_type
	///Sound used when item sold/bought
	var/sell_sound = 'sound/blank.ogg'
	///The currency name
	var/currency_name = "zennies"
	///Which types of supply packs can we use here
	var/list/base_type = list()
	///Custom items that this trader type can sell with their weights and pricing
	///Format: item_type = list(weight, base_price, base_quantity)
	var/list/custom_items = list()
	///Maximum number of custom items to select for this trader
	var/max_custom_items = 3

	///The initial products that the trader offers
	var/list/initial_products = list(
		/obj/item/ore/cinnabar = list(20, INFINITY),
	)
	///The initial products that the trader buys
	var/list/initial_wanteds = list(
		/obj/item/ore/gold = list(30, INFINITY, ""),
	)
	///list of outfits we select if we don't want faction defaults
	var/list/outfit_override = list()

	///The speech data of the trader
	var/list/say_phrases = list(
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
		TRADER_LORE_PHRASE = list(
			"Hello! I am the test trader.",
			"Oooooooo~!",
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
		TRADER_SHOP_OPENING_PHRASE = list(
			"Welcome to my shop, friend!",
		),
	)

/**
 * Depending on the passed parameter/override, returns a randomly picked string out of a list
 *
 * Do note when overriding this argument, you will need to ensure pick(the list) doesn't get supplied with a list of zero length
 * Arguments:
 * * say_text - (String) a define that matches the key of a entry in say_phrases
 */
/datum/trader_data/proc/return_trader_phrase(say_text)
	if(!length(say_phrases[say_text]))
		return
	return pick(say_phrases[say_text])
