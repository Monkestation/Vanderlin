/datum/config_entry/number/special_rerolls
	default = 0

/datum/preferences/proc/open_loadout_shop(mob/mob)
	var/datum/tgui_triumph_shop/ui = new /datum/tgui_triumph_shop(mob.client)
	ui.ui_interact(mob)

/datum/preferences/proc/open_gossip(mob/mob)
	var/datum/gossip_prefs/gossip = new /datum/gossip_prefs(mob)
	gossip.ui_interact(mob)

/datum/preferences/proc/load_triumph_shop_character_data(savefile/S)
	if(!S)
		return
	S["equipped_loadout"] >> equipped_loadout
	if(!islist(equipped_loadout))
		equipped_loadout = list()
	S["single_round_loadout"] >> single_round_loadout
	if(!islist(single_round_loadout))
		single_round_loadout = list()

	validate_loadouts()
	load_loadout_colors(S)

/datum/preferences/proc/load_loadout_colors(savefile/S)
	if(!S)
		return
	S["equipped_loadout_colors"] >> equipped_loadout_colors
	S["single_round_loadout_colors"] >> single_round_loadout_colors
	if(!islist(equipped_loadout_colors))
		equipped_loadout_colors = list()
	if(!islist(single_round_loadout_colors))
		single_round_loadout_colors = list()

	// Scrub stale color entries whose path no longer exists in equipped lists
	var/list/clean_ec = list()
	for(var/path_str in equipped_loadout_colors)
		if(path_str in equipped_loadout)
			clean_ec[path_str] = equipped_loadout_colors[path_str]
	equipped_loadout_colors = clean_ec

	var/list/clean_sc = list()
	for(var/path_str in single_round_loadout_colors)
		if(path_str in single_round_loadout)
			clean_sc[path_str] = single_round_loadout_colors[path_str]
	single_round_loadout_colors = clean_sc

/datum/preferences/proc/validate_loadouts()
	var/list/clean_owned = list()
	for(var/path_str in owned_loadout_items)
		var/datum/loadout_item/item = GLOB.loadout_items[text2path(path_str)]
		if(!item)
			continue
		// Achievement check: item must still be unlocked.
		if(!item.is_unlocked_for(parent))
			continue
		// Patreon check: lapsed subs lose patreon-locked items.
		if((item.loadout_flags & LOADOUT_FLAG_PATREON_LOCKED) && !parent?.patreon?.is_donator())
			continue
		clean_owned += path_str
	owned_loadout_items = clean_owned

	var/list/clean_equipped = list()
	for(var/path_str in equipped_loadout)
		if(!(path_str in owned_loadout_items))
			continue
		var/datum/loadout_item/item = GLOB.loadout_items[text2path(path_str)]
		// NO_EQUIP items must not occupy a loadout slot under any circumstances.
		if(item && (item.loadout_flags & LOADOUT_FLAG_NO_EQUIP))
			continue
		clean_equipped += path_str
	if(length(clean_equipped) > 3)
		clean_equipped = clean_equipped.Copy(1, 4)
	equipped_loadout = clean_equipped
	return TRUE


/proc/apply_loadouts(mob/living/carbon/human/character, client/player)
	if(!player)
		player = character.client //???
	if(!player?.prefs)
		stack_trace("No Client passed into apply_loadouts, [character]. This means something is funky")
		return

	var/slot = 1
	for(var/path_str in player.prefs.equipped_loadout)
		if(slot > 3)
			break
		var/datum/loadout_item/item = GLOB.loadout_items[text2path(path_str)]
		if(!item)
			continue

		var/atom/item_path = item.item_path
		character.mind.special_items[initial(item_path.name)] = item.item_path

		var/list/colors = player.prefs.equipped_loadout_colors[path_str]
		if(colors)
			if(!character.mind.loadout_item_colors)
				character.mind.loadout_item_colors = list()
			character.mind.loadout_item_colors[initial(item_path.name)] = colors

		slot++

	for(var/path_str in player.prefs.single_round_loadout)
		if(slot > 3)
			break
		if(path_str in player.prefs.equipped_loadout)
			continue
		var/datum/loadout_item/item = GLOB.loadout_items[text2path(path_str)]
		if(!item)
			continue

		var/atom/item_path = item.item_path
		character.mind.special_items[initial(item_path.name)] = item.item_path

		var/list/colors = player.prefs.single_round_loadout_colors[path_str]
		if(colors)
			if(!character.mind.loadout_item_colors)
				character.mind.loadout_item_colors = list()
			character.mind.loadout_item_colors[initial(item_path.name)] = colors

		slot++

	if(!player.is_donator())
		player.prefs.single_round_loadout = list()
		player.prefs.single_round_loadout_colors = list()
	player.prefs.save_preferences()
	player.prefs.save_character()

/proc/apply_item_colors(obj/item/spawned_item, datum/mind/mind)
	if(!spawned_item || !mind?.loadout_item_colors)
		return
	if(!(spawned_item.name in mind.loadout_item_colors))
		return
	var/list/colors = mind.loadout_item_colors[spawned_item.name]
	if(!colors)
		return
	if(spawned_item.dyeable)
		var/base_hex = colors["base"]
		if(base_hex)
			spawned_item.add_atom_colour(base_hex, FIXED_COLOUR_PRIORITY)
		var/detail_hex = colors["detail"]
		if(detail_hex && !isnull(spawned_item.get_detail_tag()))
			spawned_item.detail_color = detail_hex
			spawned_item.update_appearance(UPDATE_OVERLAYS)

/datum/tgui_triumph_shop
	var/client/owner
	var/lookup_result_ckey = null
	var/list/lookup_result_tickets = null

/datum/tgui_triumph_shop/New(client/C)
	owner = C

/datum/tgui_triumph_shop/ui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if (!ui)
		ui = new(user, src, "TriumphShop")
		ui.open()

/datum/tgui_triumph_shop/ui_state(mob/user, datum/tgui/ui)
	return GLOB.always_state

/datum/tgui_triumph_shop/ui_data(mob/user)
	var/list/data = list()
	var/total_weight = 0
	for(var/tt in GLOB.special_traits)
		var/datum/special_trait/trait = SPECIAL_TRAIT(tt)
		total_weight += trait.weight

	data["triumph_balance"] = get_triumph_amount(owner.ckey)
	data["cost_random_special"] = owner.is_donator() ? 0 : TRIUMPH_COST_RANDOM_SPECIAL
	data["donator"] = owner.is_donator()
	data["online_ckeys"] = GLOB.key_list

	// Pending special for next spawn
	var/pending = owner.prefs.next_special_trait
	data["pending_special"] = pending ? "[pending]" : null

	var/list/tb_cats = list()
	for(var/cat_key in SStriumphs.central_state_data)
		if(cat_key == TRIUMPH_CAT_ACTIVE_DATUMS) continue // handled separately
		var/list/cat_items = list()
		for(var/page_key in SStriumphs.central_state_data[cat_key])
			for(var/datum/triumph_buy/tb in SStriumphs.central_state_data[cat_key][page_key])
				// resolve conflicts server-side so client never has to iterate
				var/conflicted = FALSE
				for(var/datum/triumph_buy/active in SStriumphs.active_triumph_buy_queue)
					if(tb.type in active.conflicts_with) conflicted = TRUE
				if(SSticker.HasRoundStarted() && tb.pre_round_only) conflicted = TRUE
				var/already_owned = !tb.allow_multiple_buys && owner?.has_triumph_buy(tb.triumph_buy_id)
				cat_items += list(list(
					"ref" = REF(tb),
					"triumph_buy_id" = tb.triumph_buy_id,
					"name" = tb.name,
					"desc" = tb.desc,
					"cost" = tb.triumph_cost,
					"category" = cat_key,
					"is_communal" = istype(tb, /datum/triumph_buy/communal),
					"communal_current" = istype(tb,/datum/triumph_buy/communal) ? SStriumphs.communal_pools[tb.type] : 0,
					"communal_max" = istype(tb,/datum/triumph_buy/communal) ? tb:maximum_pool : 0,
					"communal_activated" = istype(tb,/datum/triumph_buy/communal) ? tb.activated : FALSE,
					"pre_round_only" = tb.pre_round_only,
					"limited" = tb.limited,
					"stock" = tb.limited ? SStriumphs.triumph_buy_stocks[tb.type] : -1,
					"conflicted" = conflicted,
					"disabled" = tb.disabled,
					"allow_multiple" = tb.allow_multiple_buys,
					"already_owned" = already_owned,
					"can_be_refunded" = tb.can_be_refunded,
					"activated" = tb.activated,
					"is_seasonal" = istype(tb, /datum/triumph_buy/seasonal),
					"visible_active" = tb.visible_on_active_menu,
					))
		tb_cats[cat_key] = cat_items

	var/list/active_items = list()
	for(var/datum/triumph_buy/tb in SStriumphs.active_triumph_buy_queue)
		if(!tb.visible_on_active_menu || owner.ckey != tb.ckey_of_buyer) continue
		active_items += list(list(
			"ref" = REF(tb),
			"triumph_buy_id" = tb.triumph_buy_id,
			"name" = tb.name,
			"desc" = tb.desc,
			"cost" = tb.triumph_cost,
			"pre_round_only" = tb.pre_round_only,
			"can_be_refunded" = tb.can_be_refunded,
			"activated" = tb.activated,
			"is_seasonal" = istype(tb, /datum/triumph_buy/seasonal),
		))
	data["triumph_buy_categories"] = tb_cats
	data["active_triumph_buys"] = active_items

	// Loadout categories
	var/list/categories = list()
	for(var/path in GLOB.loadout_items)
		var/datum/loadout_item/item = GLOB.loadout_items[path]
		var/cat = item.ui_category
		if(!(cat in categories))
			categories[cat] = list()
		var/path_str = "[path]"
		categories[cat] += list(list(
			"path" = path_str,
			"name" = item.name,
			"description" = item.description,
			"cost_single" = CEILING(item.triumph_cost_permanent * 0.05, 1),
			"cost_permanent" = item.triumph_cost_permanent,
			"free" = (!item.triumph_cost_permanent),
			"owned" = (path_str in owner.prefs.owned_loadout_items),
			"equipped" = (path_str in owner.prefs.equipped_loadout),
			"rented" = (path_str in owner.prefs.single_round_loadout),
			"can_afford_single" = item.can_afford_single(owner),
			"can_afford_perm" = item.can_afford_permanent(owner),
			"award_locked" = !!(item.required_award && !item.is_unlocked_for(owner)),
			"ui_icon" = item.ui_icon,
			"ui_icon_state" = item.ui_icon_state,
			"no_rent" = !!(item.loadout_flags & LOADOUT_FLAG_NO_RENT),
			"no_equip" = !!(item.loadout_flags & LOADOUT_FLAG_NO_EQUIP),
			"patreon_locked" = !!(item.loadout_flags & LOADOUT_FLAG_PATREON_LOCKED),
			"giveaway_only" = !!(item.loadout_flags & LOADOUT_FLAG_GIVEAWAY_ONLY),
			"donator_free" = !(item.loadout_flags & LOADOUT_FLAG_NO_DONATOR_FREE),
			"category" = cat
		))
	data["categories"] = categories

	var/list/colors_list = list()
	for(var/path in GLOB.loadout_items)
		var/datum/loadout_item/item = GLOB.loadout_items[path]
		if(!istype(item, /datum/loadout_item/dye_color))
			continue
		var/datum/loadout_item/dye_color/color_item = item
		var/path_str = "[path]"
		colors_list += list(list(
			"name" = color_item.name,
			"hex" = color_item.color_hex,
			"owned" = color_item.is_owned_and_accessible(owner),
			"purchase_path" = path_str,
			"cost" = color_item.triumph_cost_permanent,
			"palette" = color_item.palette,
		))
	data["available_colors"] = colors_list

	// Equipped slots (ordered, always 3 entries)
	var/list/slots = list()
	for(var/i in 1 to 3)
		var/path_str = (length(owner.prefs.equipped_loadout) >= i) \
			? owner.prefs.equipped_loadout[i] : null
		if(path_str)
			var/datum/loadout_item/item = GLOB.loadout_items[text2path(path_str)]
			var/list/slot_entry = list(
				"path" = path_str,
				"name" = item ? item.name : "Unknown",
				"permanent" = TRUE
			)
			enrich_slot_with_dye_info(slot_entry, path_str, owner.prefs.equipped_loadout_colors)
			slots += list(slot_entry)
		else
			var/rent_idx = i - length(owner.prefs.equipped_loadout)
			if(rent_idx >= 1 && rent_idx <= length(owner.prefs.single_round_loadout))
				var/rpath = owner.prefs.single_round_loadout[rent_idx]
				var/datum/loadout_item/ritem = GLOB.loadout_items[text2path(rpath)]
				var/list/slot_entry = list(
					"path" = rpath,
					"name" = ritem ? "[ritem.name] (this round)" : "Rental",
					"permanent" = FALSE
				)
				enrich_slot_with_dye_info(slot_entry, rpath, owner.prefs.single_round_loadout_colors)
				slots += list(slot_entry)
			else
				// four dye keys stubbed out since empty
				slots += list(list(
					"path" = null,
					"name" = "Empty",
					"permanent" = FALSE,
					"dyeable" = FALSE,
					"has_detail" = FALSE,
					"base_color" = null,
					"detail_color" = null
				))
	data["equipped_slots"] = slots
	var/mob/living/carbon/human/preview = owner.mob
	var/list/specials_list = list()
	for(var/trait_type in GLOB.special_traits)
		var/datum/special_trait/trait = SPECIAL_TRAIT(trait_type)
		var/expected_rolls = (trait.weight > 0) ? (total_weight / trait.weight) : 999
		var/patreon_modifier = user.client.is_donator() ? 0.5 : 1
		var/computed_cost = FLOOR(expected_rolls * TRIUMPH_COST_RANDOM_SPECIAL * trait.cost_modifier * patreon_modifier, 1)
		var/eligible = TRUE
		if(istype(preview, /mob/living/carbon/human))
			eligible = !!charactet_eligible_for_trait(preview, owner, trait_type)
		specials_list += list(list(
			"path" = "[trait_type]",
			"name" = trait.name,
			"greet_text" = trait.greet_text,
			"req_text" = trait.req_text,
			"weight" = trait.weight,
			"total_weight" = total_weight,
			"eligible" = eligible,
			"cost_random" = owner.is_donator() ? 0 : TRIUMPH_COST_RANDOM_SPECIAL,
			"cost_specific" = computed_cost,
			"is_pending" = (pending == trait_type)
		))
	data["specials"] = specials_list

	var/list/tickets_list = list()
	for(var/datum/ticket/t in owner.prefs.owned_tickets)
		var/list/tdata = t.to_list()
		t.enrich_ui_entry(tdata)
		tickets_list += list(tdata)
	data["owned_tickets"] = tickets_list
	data["ticket_history"] = owner.prefs.ticket_history

	var/list/locked_offering_ids = list()
	var/list/incoming_trades = list()
	var/list/outgoing_trades = list()

	for(var/datum/ticket_trade/trade in GLOB.ticket_trade_manager.pending)
		if(trade.from_ckey == owner.ckey)
			for(var/id in trade.offered_ticket_ids)
				locked_offering_ids += id
			outgoing_trades += list(list(
				"trade_id" = trade.trade_id,
				"to_ckey" = trade.to_ckey,
				"offered_ticket_ids" = trade.offered_ticket_ids,
				"offered_ticket_names" = trade.offered_ticket_names,
				"requested_ticket_ids" = trade.requested_ticket_ids,
				"requested_ticket_names" = trade.requested_ticket_names,
				"cancelling" = !!(trade.cancel_requested_at),
			))
		else if(trade.to_ckey == owner.ckey)
			var/client/from_client = GLOB.directory[trade.from_ckey]
			var/list/sender_raw = GLOB.ticket_trade_manager.get_raw_ticket_list(trade.from_ckey, from_client)

			var/list/offered_enriched = list()
			for(var/id in trade.offered_ticket_ids)
				if(islist(sender_raw))
					for(var/list/entry in sender_raw)
						if(entry["ticket_id"] == id)
							var/list/enriched = entry.Copy()
							// Use a temporary datum purely for enrich_ui_entry
							var/datum/ticket/temp = ticket_from_list(entry)
							if(temp)
								temp.enrich_ui_entry(enriched)
							offered_enriched += list(enriched)
							break

			var/list/requested_enriched = list()
			for(var/id in trade.requested_ticket_ids)
				var/datum/ticket/t = find_ticket_in_prefs(owner.prefs, id)
				if(t)
					var/list/tdata = t.to_list()
					t.enrich_ui_entry(tdata)
					requested_enriched += list(tdata)
				else
					requested_enriched += list(list(
						"ticket_id" = id,
						"name" = "(no longer owned)",
						"ticket_type" = "unknown",
					))

			incoming_trades += list(list(
				"trade_id" = trade.trade_id,
				"from_ckey" = trade.from_ckey,
				"offered_tickets" = offered_enriched,
				"offered_ticket_names" = trade.offered_ticket_names,
				"requested_tickets" = requested_enriched,
				"requested_ticket_names" = trade.requested_ticket_names,
				"cancelling" = !!(trade.cancel_requested_at),
			))

	data["locked_offering_ids"] = locked_offering_ids
	data["incoming_trades"] = incoming_trades
	data["outgoing_trades"] = outgoing_trades

	data["lookup_result_ckey"] = src.lookup_result_ckey
	data["lookup_result_tickets"] = src.lookup_result_tickets

	return data


/proc/enrich_slot_with_dye_info(list/slot_entry, path_str, list/color_store)
	var/datum/loadout_item/item = GLOB.loadout_items[text2path(path_str)]
	if(!item || !item.item_path)
		slot_entry["dyeable"] = FALSE
		slot_entry["has_detail"] = FALSE
		slot_entry["base_color"] = null
		slot_entry["detail_color"] = null
		return

	var/atom/movable/item_type = item.item_path
	var/is_dyeable = initial(item_type:dyeable)
	var/has_detail = FALSE
	if(is_dyeable)
		var/obj/item/probe = new item_type(null)
		if(istype(probe))
			has_detail = !isnull(probe.get_detail_tag())
		qdel(probe)

	slot_entry["dyeable"] = is_dyeable
	slot_entry["has_detail"] = has_detail

	var/list/colors = color_store[path_str]
	slot_entry["base_color"] = colors ? colors["base"] : null
	slot_entry["detail_color"] = colors ? colors["detail"] : null

/datum/tgui_triumph_shop/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	. = ..()
	switch(action)
		if("buy_permanent")
			return handle_buy_permanent(params["path"])
		if("buy_single")
			return handle_buy_single(params["path"])
		if("equip_item")
			return handle_equip(params["path"])
		if("unequip_item")
			return handle_unequip(params["path"])
		if("buy_random_special")
			return handle_random_special()
		if("buy_specific_special")
			return handle_specific_special(params["path"])
		if("clear_pending_special")
			return handle_clear_pending_special()
		if("set_loadout_color")
			return handle_set_loadout_color(params["path"], params["layer"], params["hex"])
		if("clear_loadout_color")
			return handle_clear_loadout_color(params["path"], params["layer"])
		if("triumph_buy")
			var/datum/triumph_buy/tb = locate(params["ref"])
			if(!tb) return FALSE
			return SStriumphs.attempt_to_buy_triumph_condition(owner, tb)
		if("triumph_refund")
			var/datum/triumph_buy/tb = locate(params["ref"])
			if(!tb) return FALSE
			return SStriumphs.attempt_to_unbuy_triumph_condition(owner, tb)
		if("triumph_contribute")
			var/datum/triumph_buy/communal/tb = locate(params["ref"])
			if(!tb || !istype(tb)) return FALSE
			var/amount = text2num(params["amount"])
			var/available = SStriumphs.get_triumphs(owner.ckey)
			if(!amount || amount <= 0) return FALSE
			if(!owner?.ckey)
				return
			if(!amount || amount <= 0)
				return

			var/max_possible = tb.maximum_pool ? tb.maximum_pool - SStriumphs.communal_pools[tb.type] : INFINITY

			if(SSticker.current_state == GAME_STATE_FINISHED)
				to_chat(owner, span_warning("You cannot contribute after the round has ended!"))
				return
			if(tb.activated)
				to_chat(owner, span_warning("The item is already active!"))
				return
			if(istype(tb, /datum/triumph_buy/communal/preround) && SSticker.HasRoundStarted())
				to_chat(owner, span_warning("This can only be contributed to before the round starts!"))
				return

			amount = round(amount)
			if(amount <= 0)
				to_chat(owner, span_warning("You must contribute at least one whole triumph!"))
				return
			if(amount > available)
				to_chat(owner, span_warning("You don't have [amount] triumph\s! You only have [available] triumph\s."))
				return

			amount = min(amount, available, max_possible)
			if(amount > 0)
				owner.adjust_triumphs(-amount, counted = FALSE, silent = TRUE)
				SStriumphs.communal_pools[tb.type] += amount
				LAZYADD(SStriumphs.communal_contributions[tb.type][owner.ckey], amount)
				to_chat(owner, span_notice("You have contributed [amount] triumph\s to the [tb.name]."))

				if(amount >= 5 && SSticker.current_state < GAME_STATE_SETTING_UP)
					to_chat(world, span_notice("[amount] triumph\s were contributed to the [tb.name] communal buy!"))

				if(tb.maximum_pool && SStriumphs.communal_pools[tb.type] >= tb.maximum_pool)
					tb.on_activate()
			return TRUE
		if("use_ticket")
			var/datum/ticket/t = find_ticket_in_prefs(owner.prefs, params["ticket_id"])
			if(!t) return FALSE
			return use_ticket(owner, t)

		if("offer_trade")
			var/list/offered_ids = params["offered_ids"]
			var/list/requested_ids = params["requested_ids"]
			if(!islist(offered_ids)) offered_ids = list()
			if(!islist(requested_ids)) requested_ids = list()
			return GLOB.ticket_trade_manager.offer_trade(owner, params["to_ckey"], offered_ids, requested_ids)

		if("accept_trade")
			return GLOB.ticket_trade_manager.accept_trade(owner, params["trade_id"])

		if("cancel_trade")
			return GLOB.ticket_trade_manager.cancel_trade(owner, params["trade_id"])

		if("lookup_ckey_tickets")
			var/target_ckey = params["target_ckey"]
			if(!target_ckey) return FALSE
			if(target_ckey == owner.ckey) return FALSE
			var/list/raw = GLOB.ticket_trade_manager.lookup_inventory(target_ckey)
			var/list/enriched = list()
			if(islist(raw))
				for(var/list/entry in raw)
					var/list/e = entry.Copy()
					var/datum/ticket/temp = ticket_from_list(entry)
					if(temp)
						temp.enrich_ui_entry(e)
					enriched += list(e)
			src.lookup_result_ckey = target_ckey
			src.lookup_result_tickets = enriched
			SStgui.update_uis(src)
			return TRUE
		if("convert_triumphs_to_ticket")
			var/amount = text2num(params["amount"])
			return handle_convert_triumphs_to_ticket(amount)

	return FALSE

/datum/tgui_triumph_shop/proc/handle_convert_triumphs_to_ticket(amount)
	amount = round(text2num("[amount]")) // paranoia, never trust client
	if(!amount || amount <= 0)
		return FALSE
	if(amount < TRIUMPH_TICKET_MIN_CONVERT)
		to_chat(owner.mob, span_warning("You must convert at least [TRIUMPH_TICKET_MIN_CONVERT] triumphs at a time."))
		return FALSE
	var/balance = get_triumph_amount(owner.ckey)
	if(balance < amount)
		to_chat(owner.mob, span_warning("You only have [balance] triumphs, not [amount]."))
		return FALSE

	adjust_triumphs(owner, -amount, TRUE, "Triumph Shop: converted [amount] triumphs to ticket", FALSE, TRUE)

	var/datum/ticket/triumph/t = new
	t.ticket_id = generate_ticket_id()
	t.name = "[amount] Triumph Ticket"
	t.description = "Redeemable for [amount] triumphs."
	t.triumph_amount = amount
	t.granted_by = "Triumph Shop"
	t.granted_at = "[time2text(world.realtime, "YYYY-MM-DD hh:mm:ss")]"
	t.grant_reason = "Self-converted"
	owner.prefs.owned_tickets += t
	owner.prefs.ticket_history += list(list(
		"event" = "converted",
		"description" = "granted [t.name] ([t.ticket_type][t.details()]) by Triumph Shop (self-converted).",
		"timestamp" = time2text(world.realtime, "YYYY-MM-DD hh:mm:ss"),
		"ticket_id" = t.ticket_id,
		"name" = t.name,
		"type" = t.ticket_type,
	))
	owner.prefs.save_preferences()
	owner.prefs.save_character()

	log_game("TRIUMPH SHOP: [owner.ckey] converted [amount] triumphs into a triumph ticket.")
	to_chat(owner.mob, span_notice("Converted <b>[amount] triumphs</b> into a tradeable ticket!"))
	return TRUE

/datum/tgui_triumph_shop/proc/handle_buy_permanent(path_str)
	var/datum/loadout_item/item = GLOB.loadout_items[text2path(path_str)]
	if(!item)
		return FALSE
	if(path_str in owner.prefs.owned_loadout_items)
		return FALSE
	if(item.loadout_flags & LOADOUT_FLAG_GIVEAWAY_ONLY)
		to_chat(owner.mob, span_warning("[item.name] cannot be purchased. It can only be obtained through a giveaway."))
		return FALSE
	if(!item.is_unlocked_for(owner))
		if(item.required_award)
			to_chat(owner.mob, span_warning("You haven't unlocked the achievement required for [item.name]."))
		else if(item.loadout_flags & LOADOUT_FLAG_PATREON_LOCKED)
			to_chat(owner.mob, span_warning("[item.name] requires an active Patreon subscription."))
		return FALSE
	if(item.triumph_cost_permanent > 0)
		var/balance = get_triumph_amount(owner.ckey)
		if(balance < item.triumph_cost_permanent)
			to_chat(owner.mob, span_warning("You need [item.triumph_cost_permanent] triumphs to permanently unlock [item.name]. You have [balance]."))
			return FALSE
		adjust_triumphs(owner, -item.triumph_cost_permanent, TRUE, "Triumph Shop: permanent unlock [item.name]", FALSE, TRUE)
	owner.prefs.owned_loadout_items += path_str
	owner.prefs.save_preferences()
	owner.prefs.save_character()
	log_game("TRIUMPH SHOP: [owner.ckey] permanently unlocked [path_str] for [item.triumph_cost_permanent] triumphs.")
	to_chat(owner.mob, span_notice("Permanently unlocked [item.name]!"))
	if(item.triumph_cost_permanent)
		add_abstract_elastic_data(ELASCAT_SHOP, "[item.name]", 1)
	return TRUE

/datum/tgui_triumph_shop/proc/handle_buy_single(path_str)
	var/datum/loadout_item/item = GLOB.loadout_items[text2path(path_str)]
	if(!item)
		return FALSE
	if(item.loadout_flags & LOADOUT_FLAG_NO_RENT)
		to_chat(owner.mob, span_warning("[item.name] cannot be rented, it must be permanently unlocked."))
		return FALSE
	if(item.loadout_flags & LOADOUT_FLAG_NO_EQUIP)
		to_chat(owner.mob, span_warning("[item.name] cannot be equipped as a loadout item."))
		return FALSE
	if(item.loadout_flags & LOADOUT_FLAG_GIVEAWAY_ONLY)
		to_chat(owner.mob, span_warning("[item.name] cannot be purchased. It can only be obtained through a giveaway."))
		return FALSE
	if(path_str in owner.prefs.owned_loadout_items)
		return FALSE
	if(path_str in owner.prefs.single_round_loadout)
		return FALSE
	if(!item.is_unlocked_for(owner))
		to_chat(owner.mob, span_warning("You don't meet the requirements for [item.name]."))
		return FALSE
	var/used = length(owner.prefs.equipped_loadout) + length(owner.prefs.single_round_loadout)
	if(used >= 3)
		to_chat(owner.mob, span_warning("All 3 loadout slots are in use."))
		return FALSE
	if(CEILING(item.triumph_cost_permanent * 0.05, 1) > 0 && !(owner.is_donator() && !(item.loadout_flags & LOADOUT_FLAG_NO_DONATOR_FREE)))
		var/balance = get_triumph_amount(owner.ckey)
		if(balance < CEILING(item.triumph_cost_permanent * 0.05, 1))
			to_chat(owner.mob, span_warning("You need [CEILING(item.triumph_cost_permanent * 0.05, 1)] triumphs to rent [item.name]. You have [balance]."))
			return FALSE
		adjust_triumphs(owner, -CEILING(item.triumph_cost_permanent * 0.05, 1), TRUE, "Triumph Shop: single-round rent [item.name]", FALSE, TRUE)
		add_abstract_elastic_data(ELASCAT_SHOP, "[item.name] - Rented", 1)

	var/donator_free_use = owner.is_donator() && !(item.loadout_flags & LOADOUT_FLAG_NO_DONATOR_FREE)
	owner.prefs.single_round_loadout += path_str
	owner.prefs.save_preferences()
	owner.prefs.save_character()
	log_game("TRIUMPH SHOP: [owner.ckey] [donator_free_use ? "trialing" : "rented"] [path_str] [donator_free_use ? "(free, donator)" : "for one round ([CEILING(item.triumph_cost_permanent * 0.05, 1)] triumphs)"].")
	to_chat(owner.mob, span_notice("[donator_free_use ? "Trying out [item.name] for this round (Patreon perk, no cost)." : "Rented [item.name] for this round."]"))
	return TRUE

/datum/tgui_triumph_shop/proc/handle_equip(path_str)
	if(!(path_str in owner.prefs.owned_loadout_items))
		return FALSE
	if(path_str in owner.prefs.equipped_loadout)
		return FALSE
	var/datum/loadout_item/item = GLOB.loadout_items[text2path(path_str)]
	if(item && (item.loadout_flags & LOADOUT_FLAG_NO_EQUIP))
		to_chat(owner.mob, span_warning("[item.name] cannot be equipped as a loadout slot item."))
		return FALSE
	var/used = length(owner.prefs.equipped_loadout) + length(owner.prefs.single_round_loadout)
	if(used >= 3)
		to_chat(owner.mob, span_warning("All 3 loadout slots are in use."))
		return FALSE
	owner.prefs.equipped_loadout += path_str
	owner.prefs.save_preferences()
	owner.prefs.save_character()
	return TRUE

/datum/tgui_triumph_shop/proc/handle_unequip(path_str)
	if(path_str in owner.prefs.equipped_loadout)
		owner.prefs.equipped_loadout -= path_str
		owner.prefs.save_preferences()
		owner.prefs.save_character()
		return TRUE
	if(path_str in owner.prefs.single_round_loadout)
		owner.prefs.single_round_loadout -= path_str
		owner.prefs.save_preferences()
		owner.prefs.save_character()
		var/datum/loadout_item/item = GLOB.loadout_items[text2path(path_str)]
		var/donator_free_use = owner.is_donator() && !(item?.loadout_flags & LOADOUT_FLAG_NO_DONATOR_FREE)
		if(!donator_free_use && CEILING(item?.triumph_cost_permanent * 0.05, 1) > 0)
			adjust_triumphs(owner, CEILING(item.triumph_cost_permanent * 0.05, 1), TRUE, "Triumph Shop: refund rent [item.name]", FALSE, TRUE)
		return TRUE
	return FALSE

/datum/tgui_triumph_shop/proc/handle_random_special()
	if(owner.prefs.next_special_trait)
		to_chat(owner.mob, span_warning("You already have a special trait queued. Clear it first."))
		return FALSE
	var/balance = get_triumph_amount(owner.ckey)
	var/cost = owner.is_donator() ? 0 : TRIUMPH_COST_RANDOM_SPECIAL
	if(balance < cost)
		to_chat(owner.mob, span_warning("You need [cost] triumphs to roll a random special. You have [balance]."))
		return FALSE
	// roll_random_special uses weight-based pickweight across ALL specials
	// (not filtered by character eligibility, this is intentional for random rolls)
	var/rolled = roll_random_special(owner)
	if(!rolled)
		to_chat(owner.mob, span_warning("No specials available to roll."))
		return FALSE
	if(cost)
		adjust_triumphs(owner, -cost, TRUE, "Triumph Shop: random special roll", FALSE, TRUE)
	owner.prefs.next_special_trait = rolled
	owner.prefs.save_preferences()
	owner.prefs.save_character()
	print_special_text(owner, owner.prefs.next_special_trait)
	owner.mob.playsound_local(owner.mob, 'sound/misc/alert.ogg', 100)
	var/datum/special_trait/trait = SPECIAL_TRAIT(rolled)
	log_game("TRIUMPH SHOP: [owner.ckey] rolled random special [rolled] ([trait?.name]) for [TRIUMPH_COST_RANDOM_SPECIAL] triumphs.")
	to_chat(owner.mob, span_notice("You rolled: <b>[trait?.name]</b>! Applies on your next spawn."))
	return TRUE

/datum/tgui_triumph_shop/proc/handle_specific_special(path_str)
	if(owner.prefs.next_special_trait)
		to_chat(owner.mob, span_warning("You already have a special trait queued. Clear it first."))
		return FALSE
	var/trait_type = text2path(path_str)
	if(!trait_type || !(trait_type in GLOB.special_traits))
		return FALSE
	var/mob/living/carbon/human/preview = owner.mob
	if(istype(preview, /mob/living/carbon/human))
		if(!charactet_eligible_for_trait(preview, owner, trait_type))
			to_chat(owner.mob, span_warning("Your character does not meet the requirements for that trait."))
			return FALSE
	//never trust client-sent cost I don't want some fuck ass -1000000 cost
	var/total_weight = 0
	for(var/tw in GLOB.special_traits)
		var/datum/special_trait/special = SPECIAL_TRAIT(tw)
		total_weight += special.weight
	var/datum/special_trait/trait = SPECIAL_TRAIT(trait_type)
	var/expected_rolls = (trait.weight > 0) ? (total_weight / trait.weight) : 999
	var/patreon_modifier = owner.is_donator() ? 0.5 : 1
	var/cost = FLOOR(expected_rolls * TRIUMPH_COST_RANDOM_SPECIAL * trait.cost_modifier * patreon_modifier, 1)
	var/balance = get_triumph_amount(owner.ckey)
	if(balance < cost)
		to_chat(owner.mob, span_warning("You need [cost] triumphs to pick [trait.name]. You have [balance]."))
		return FALSE
	adjust_triumphs(owner, -cost, TRUE, "Triumph Shop: specific special [path_str]", FALSE, TRUE)
	owner.prefs.next_special_trait = trait_type
	owner.prefs.save_preferences()
	print_special_text(owner, owner.prefs.next_special_trait)
	owner.mob.playsound_local(owner.mob, 'sound/misc/alert.ogg', 100)
	log_game("TRIUMPH SHOP: [owner.ckey] purchased specific special [path_str] ([trait?.name]) for [cost] triumphs.")
	to_chat(owner.mob, span_notice("Selected: <b>[trait?.name]</b>! Applies on your next spawn."))
	add_abstract_elastic_data(ELASCAT_SHOP, "[trait.name]", 1)
	return TRUE

/datum/tgui_triumph_shop/proc/handle_clear_pending_special()
	if(!owner.prefs.next_special_trait)
		return FALSE
	if(owner.player_details.rerolls <= 0)
		return FALSE
	owner.player_details.rerolls--
	owner.prefs.next_special_trait = null
	owner.prefs.save_preferences()
	owner.prefs.save_character()
	to_chat(owner.mob, span_notice("Pending special trait cleared. No refund issued."))
	return TRUE


/datum/tgui_triumph_shop/proc/handle_set_loadout_color(path_str, layer, hex)
	//must be a 7-char string starting with # or the vanderlin will quite literally explode!!!
	if(!istext(hex) || length(hex) != 7 || copytext(hex, 1, 2) != "#")
		return FALSE
	if(layer != "base" && layer != "detail")
		return FALSE

	//no freebies fr fr
	var/found_color = FALSE
	for(var/cpath in GLOB.loadout_items)
		var/datum/loadout_item/item = GLOB.loadout_items[cpath]
		if(!istype(item, /datum/loadout_item/dye_color))
			continue
		var/datum/loadout_item/dye_color/color_item = item
		if(color_item.color_hex == hex && color_item.is_owned_and_accessible(owner))
			found_color = TRUE
			break
	if(!found_color)
		to_chat(owner.mob, span_warning("I do not own that color."))
		return FALSE

	// path_str must be in an equipped or rented slot
	var/in_equipped = (path_str in owner.prefs.equipped_loadout)
	var/in_rented = (path_str in owner.prefs.single_round_loadout)
	if(!in_equipped && !in_rented)
		return FALSE

	var/list/color_store = in_equipped \
		? owner.prefs.equipped_loadout_colors \
		: owner.prefs.single_round_loadout_colors

	if(!(path_str in color_store) || !islist(color_store[path_str]))
		color_store[path_str] = list("base" = null, "detail" = null)

	color_store[path_str][layer] = hex
	owner.prefs.save_preferences()
	owner.prefs.save_character()

	log_game("TRIUMPH SHOP: [owner.ckey] set [layer] color of [path_str] to [hex].")
	return TRUE

/datum/tgui_triumph_shop/proc/handle_clear_loadout_color(path_str, layer)
	if(layer != "base" && layer != "detail")
		return FALSE

	var/list/color_store = null
	if(path_str in owner.prefs.equipped_loadout)
		color_store = owner.prefs.equipped_loadout_colors
	else if(path_str in owner.prefs.single_round_loadout)
		color_store = owner.prefs.single_round_loadout_colors
	else
		return FALSE

	if(!(path_str in color_store))
		return TRUE // already clear

	color_store[path_str][layer] = null
	owner.prefs.save_preferences()
	owner.prefs.save_character()
	return TRUE
