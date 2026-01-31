/datum/trade_agreement
	var/name = "Generic Contract"
	var/desc = "Generic lore about why we need this"

	///if we are activated
	var/active = FALSE

	///this is our base contract weight
	var/weight = 100
	///this is the minimum weight we allow
	var/minimum_weight = 10

	///if this is set its a timed agreement think famine they NEED food
	var/time = 0
	var/fail_time

	///min max for the amount of items we need
	var/min_requested = 3
	var/max_requested = 5
	var/amount_requested = 0

	///the mammons for completing this
	var/mammon_reward = 10
	///items if any we give for completing this
	var/list/reward_items
	///list of all the items we can choose from when setting this agreement up (we can add to this in new if you want to do typesof or something)
	var/list/possible_items
	///how many of the possible items we want to pick
	var/picked_item_count = 0
	///the items we actually want for the agreement (this uses a typecheck so children are accepted)
	var/list/required_items
	///the nation we need to send this to
	var/datum/nation/location

/datum/trade_agreement/New(datum/nation/created_nation)
	. = ..()
	amount_requested = rand(min_requested, max_requested)
	location = created_nation
	expand_possible_items()
	select_items()

/datum/trade_agreement/Destroy(force, ...)
	. = ..()
	location.active_agreements -= src
	location.finished_agreements++
	location = null

/datum/trade_agreement/proc/expand_possible_items()
	return

/datum/trade_agreement/proc/select_items()
	if(!length(possible_items))
		return
	var/list/takers = possible_items.Copy()
	for(var/i = 1 to picked_item_count)
		if(!length(takers))
			return
		LAZYADD(required_items, pick_n_take(takers))

/datum/trade_agreement/proc/activate_agreement()
	active = TRUE
	if(time)
		fail_time = world.time + time

///we do a full process here since we don't get paid for agreement items
/datum/trade_agreement/proc/process_shipment(list/items, obj/structure/industrial_lift/tram/platform)
	for(var/atom/item in items)
		if(!(is_type_in_list(item, required_items)))
			continue
		amount_requested--
		items -= item
		qdel(item)
		platform.lift_load -= item
		if(amount_requested <= 0)
			handle_rewards()
			break
	return items

///here we create the items we want and throw them into the nations cached items so when the ship next leaves it spawns those
/datum/trade_agreement/proc/handle_rewards()
	spawn_coins() //these are created in nullspace because its frankly easier
	if(!length(reward_items))
		return
	location.cached_rewards |= reward_items

/datum/trade_agreement/proc/spawn_coins()
	if(mammon_reward <= 0)
		return

	var/gold_coins = floor(mammon_reward/10)
	if(gold_coins >= 1)
		var/stacks = floor(gold_coins/20) // keep this in sync with MAX_COIN_STACK_SIZE in coins.dm
		if(stacks >= 1)
			for(var/i in 1 to stacks)
				location.cached_rewards += new /obj/item/coin/gold(null, 20)
		var/remainder = gold_coins % 20
		if(remainder >= 1)
			location.cached_rewards += new /obj/item/coin/gold(null, remainder)
	mammon_reward -= gold_coins*10
	if(!mammon_reward)
		return

	var/silver_coins = floor(mammon_reward/5)
	if(silver_coins >= 1)
		var/stacks = floor(silver_coins/20)
		if(stacks >= 1)
			for(var/i in 1 to stacks)
				location.cached_rewards += new /obj/item/coin/silver(null, 20)
		var/remainder = silver_coins % 20
		if(remainder >= 1)
			location.cached_rewards += new /obj/item/coin/silver(null, remainder)
	mammon_reward -= silver_coins*5
	if(!mammon_reward)
		return

	var/copper = floor(mammon_reward)
	location.cached_rewards += new /obj/item/coin/copper(null, copper)

