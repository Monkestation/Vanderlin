/datum/triumph_buy/psydon_favourite
	name = "Psydon's Favourite"
	desc = "Have a guaranteed place as a notable person of the Realm if you make it through the week!"
	triumph_buy_id = TRIUMPH_BUY_PSYDON_FAVOURITE
	triumph_cost = 2
	category = TRIUMPH_CAT_MISC
	visible_on_active_menu = TRUE
	allow_multiple_buys = FALSE
	limited = TRUE
	stock = 1

/datum/triumph_buy/psydon_favourite/on_activate()
	. = ..()
	SSgamemode.refresh_alive_stats()
