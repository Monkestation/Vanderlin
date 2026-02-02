/*
	TO NOTE THERE WILL BE A LOT OF SNOWFLAKE BEHAVIOR
*/

/datum/triumph_buy
	/// Display name shown as a title above the description
	var/name = "UNNAMED TRIUMPH BUY"
	/// Desc shown for it on the menu
	var/desc = "NO DESCRIPTION"
	/// Unique ID of the triumph buy
	var/triumph_buy_id
	/// Ckey of the person who bought it
	var/ckey_of_buyer
	/// Cost in triumphs for something
	var/triumph_cost = 500
	/// Category we sort something into
	var/category = TRIUMPH_CAT_ACTIVE_DATUMS
	/// Whether we are visible on active menu
	var/visible_on_active_menu = FALSE
	/// Whether its pre-round only
	var/pre_round_only = FALSE
	/// Whether the triumph buy effect must be manually activated somewhere else than on its buy
	var/manual_activation = FALSE
	/// Whether the triumph buy effect was activated and therefore cannot be refunded
	var/activated = FALSE
	/// Whether the user is allowed to buy the triumph buy they already have
	var/allow_multiple_buys = TRUE
	/// Whether the triumph buy has limited stock to buy
	var/limited = FALSE
	/// Number times the triumph buy can be bought if its limited
	var/stock = 0
	/// List of things it can conflict with
	var/list/conflicts_with = list()
	/// Disables this triumph from being buyable, admin only.
	var/disabled = FALSE

/// We call this when someone buys it in the triumph shop
/datum/triumph_buy/proc/on_buy()
	if(!manual_activation)
		on_activate()

/// We call this when someone is trying to remove it aka on refund or otherwise
/datum/triumph_buy/proc/on_removal()
	return

/// We call this on when the triumph buy effect is active
/datum/triumph_buy/proc/on_activate(mob/living/carbon/human/H)
	activated = TRUE

/// Called on job after spawn
/datum/triumph_buy/proc/on_after_spawn(mob/living/carbon/human/H)
	return
