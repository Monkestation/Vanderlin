/obj/item/book/secret/ledger
	name = "catatoma"
	icon_state = "ledger_0"
	base_icon_state = "ledger"
	title = "Catatoma"
	special_book = TRUE
	var/list/cart = list() // Key: pack datum -> Value: Quantity

/obj/item/book/secret/ledger/fence
	name = "Smuggler's Manifest"
	title = " Smuggler's Manifest"

/obj/item/book/secret/ledger/attack_self(mob/user)
	ui_interact(user)

/obj/item/book/secret/ledger/ui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "CatatomaLedger", title)
		ui.open()

/obj/item/book/secret/ledger/ui_data(mob/user)
	var/list/data = list()
	var/datum/world_faction/faction = SSmerchant.active_faction

	// Faction Information
	data["faction_name"] = faction ? faction.faction_name : "None"
	data["categories"] = list("All") + SSmerchant.supply_cats
	data["bounty_reroll_ready"] = faction ? faction.can_reroll_bounty() : FALSE
	data["bounty_reroll_seconds_left"] = faction ? faction.get_bounty_reroll_seconds_left() : 0

	data["faction_reputation"] = faction ? faction.faction_reputation : 0
	data["faction_reputation_tier"] = faction ? faction.get_reputation_tier() : 0
	data["faction_reputation_thresholds"] = faction ? faction.reputation_thresholds : list()
	data["faction_color"] = faction ? faction.faction_color : "#FFFFFF"

	data["rotation_seconds_left"] = SSmerchant.get_active_faction_rotation_seconds_left()
	data["manual_rotate_ready"] = SSmerchant.can_manual_rotate()
	data["manual_rotate_seconds_left"] = SSmerchant.get_manual_rotation_seconds_left()

	var/list/available_factions = list()
	for(var/datum/world_faction/other_faction in SSmerchant.world_factions)
		available_factions += list(list(
			"name" = other_faction.faction_name,
			"ref" = "\ref[other_faction]",
			"color" = other_faction.faction_color,
			"active" = (other_faction == faction)
		))
	data["available_factions"] = available_factions

	var/list/all_packs = list()
	if(faction && islist(faction.faction_supply_packs))
		for(var/pack_id in faction.faction_supply_packs)
			var/datum/supply_pack/pack = faction.faction_supply_packs[pack_id]
			if(!pack)
				continue

			var/list/sanitized_history = list()
			if(islist(pack.cost_history) && length(pack.cost_history))
				for(var/price in pack.cost_history)
					if(isnum(price))
						sanitized_history += price

			if(length(sanitized_history) < 2)
				sanitized_history = list(pack.cost, pack.cost)

			all_packs += list(list(
				"name" = pack.name,
				"desc" = pack.desc,
				"group" = pack.group || "Unassigned",
				"id" = "\ref[pack]",
				"cost" = pack.cost,
				"in_stock" = faction.has_supply_pack(pack.type),
				"history" = sanitized_history
			))
	data["supply_packs"] = all_packs

	var/list/serialized_bounties = list()
	if(faction && islist(faction.active_bounties))
		for(var/datum/bounty/bounty in faction.active_bounties)
			if(!bounty)
				continue

			var/required_count = 0
			var/current_count = 0
			var/target_name = "Unknown Asset"
			if(bounty.required_path)
				var/atom/bounty_target = bounty.required_path
				target_name = initial(bounty_target.name)
				required_count = bounty.required_count
				current_count = bounty.current_count
			else if(bounty.required_reagent_type)
				var/datum/reagent/bounty_target = bounty.required_reagent_type
				target_name = initial(bounty_target.name)
				required_count = bounty.required_reagent_amount
				current_count = bounty.current_reagent_amount

			var/list/serialized_discounts = list()
			if(islist(bounty.supply_pack_modifiers) && length(bounty.supply_pack_modifiers))
				for(var/datum/supply_pack/pack_path as anything in bounty.supply_pack_modifiers)
					var/discount_value = 1 - bounty.supply_pack_modifiers[pack_path]

					serialized_discounts += list(list(
						"pack_name" = initial(pack_path.name),
						"modifier"  = discount_value * 100
					))

			serialized_bounties += list(list(
				"id" = "\ref[bounty]",
				"name" = bounty.name,
				"desc" = bounty.desc,
				"target_item" = target_name,
				"required_count" = required_count,
				"current_count" = current_count,
				"reward_reputation" = bounty.reward_reputation,
				"reward_currency" = bounty.reward_currency,
				"discounts" = serialized_discounts
			))
	data["active_bounties"] = serialized_bounties

	var/list/cart_items = list()
	var/total_mammon = 0

	for(var/datum/supply_pack/pack in cart)
		var/quantity = cart[pack]
		var/pack_ref = "\ref[pack]"
		var/item_mammon = pack.cost * quantity

		total_mammon += item_mammon

		cart_items += list(list(
			"name" = pack.name,
			"id" = pack_ref,
			"quantity" = quantity,
			"mammon_cost" = item_mammon
		))

	data["cart"] = cart_items
	data["total_mammon_cost"] = total_mammon

	return data

/obj/item/book/secret/ledger/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	if(..())
		return TRUE

	switch(action)
		if("add_to_cart")
			var/datum/supply_pack/pack = locate(params["id"])
			if(!pack)
				return TRUE

			var/quantity = round(text2num(params["quantity"]))
			if(!quantity || quantity < 1)
				quantity = 1
			quantity = min(quantity, 100) // sanity cap

			cart[pack] += quantity
			return TRUE

		if("remove_from_cart")
			var/datum/supply_pack/pack = locate(params["id"])
			if(!pack)
				return TRUE

			var/quantity = round(text2num(params["quantity"]))
			if(!quantity || quantity < 1)
				quantity = 1

			cart[pack] -= quantity
			if(cart[pack] <= 0)
				cart -= pack
			return TRUE

		if("clear_cart")
			cart.Cut()
			return TRUE

		if("submit_order")
			create_order_scroll(usr)
			return TRUE

		if("reroll_bounty")
			var/datum/bounty/target = locate(params["id"])
			var/datum/world_faction/faction = SSmerchant.active_faction
			if(!target || !faction)
				return TRUE
			faction.reroll_bounty(target, usr)
			return TRUE

		if("manual_rotate_faction")
			var/datum/world_faction/chosen = locate(params["ref"])
			if(!chosen)
				return TRUE
			SSmerchant.manual_rotate_faction(chosen, usr)
			return TRUE

	return FALSE

/obj/item/book/secret/ledger/proc/create_order_scroll(mob/current_reader)
	if(!length(cart))
		to_chat(usr, "<span class='warning'>Your cart is empty!</span>")
		return

	var/datum/world_faction/faction = SSmerchant.active_faction
	if(!faction)
		to_chat(usr, "<span class='warning'>No active faction found!</span>")
		return

	var/obj/item/paper/scroll/cargo/order = new(get_turf(usr))
	order.orders = cart.Copy()

	// Track the active faction on the scroll instance
	order.buying_from = faction
	order.name = "[faction.faction_name] order scroll ([length(cart)] items)"

	// Calculate total costs
	var/total_mammon_cost = 0
	for(var/datum/supply_pack/pack in cart)
		var/quantity = cart[pack]
		total_mammon_cost += pack.cost * quantity

	to_chat(usr, "<span class='notice'>Order scroll created! Cost: [total_mammon_cost] mammons from [faction.faction_name]</span>")
	order.rebuild_info()

	// Clear the cart
	cart.Cut()
	current_reader.put_in_hands(order)
	to_chat(current_reader, "<span class='notice'>Your order has been written on a scroll.</span>")
