/datum/triumph_buy_menu
	/// These are the menu datum vars
	var/client/linked_client
	/// Current page of triumphs we are viewing and yes its a number in a string
	var/current_page = "1"
	/// Current category we are viewing
	var/current_category = TRIUMPH_CAT_CHARACTER
	/// Number of pages we have
	var/page_count = 0

/datum/triumph_buy_menu/New()
	..()

/datum/triumph_buy_menu/Destroy(force, ...)
	linked_client = null
	. = ..()

/datum/triumph_buy_menu/proc/triumph_menu_startup_slop()
	var/datum/asset/thicc_assets = get_asset_datum(/datum/asset/simple/stonekeep_triumph_buy_menu_slop_layout)
	thicc_assets.send(linked_client)

	show_menu()

/datum/triumph_buy_menu/proc/show_menu()
	if(!linked_client)
		return

	var/data = {"
	<html>
		<head>
			<meta http-equiv=\"X-UA-Compatible\" content=\"IE=edge,chrome=1\"/>
			<meta http-equiv=\"Content-Type\" content=\"text/html; charset=UTF-8\"/>
			<style>
				@import url('https://fonts.googleapis.com/css2?family=Aclonica&display=swap');
				@import url('https://fonts.googleapis.com/css2?family=VT323&display=swap');
				@import url('https://fonts.googleapis.com/css2?family=Pirata+One&display=swap');
				@import url('https://fonts.googleapis.com/css2?family=Jersey+25&display=swap');
				body {
					background-color: rgb(31, 20, 24);
					background:
						url('[SSassets.transport.get_asset_url("try5_border.png")]'),
						url('[SSassets.transport.get_asset_url("try5.png")]');
					background-repeat: no-repeat;
					background-attachment: fixed;
					background-size: 100% 100%;
				}
				.triumph_name {
					font-family: "Aclonica", sans-serif;
					font-weight: 400;
					font-style: normal;
					font-size: 20px;
					color: #91E0F3;
					padding-bottom: 2px;
				}
				.nothing_bought {
					font-family: "Aclonica", sans-serif;
					font-weight: 400;
					font-style: normal;
					font-size: 24px;
					color: #FDF7D2;
					text-align: center;
					width: 100%;
					padding-top: 200px;
				}
			</style>
			<link rel='stylesheet' type='text/css' href='[SSassets.transport.get_asset_url("slop_menustyle3.css")]'>
		</head>
		<body>
			<div id=\"top_container_div\">
				<div id=\"triumph_quantity_div\">
					I have [SStriumphs.get_triumphs(linked_client.ckey)] Triumphs
				</div>
			</div>
			<div style=\"width:100%;float:left\">
	"}

	data += "<hr class='fadeout_line'>"
	for(var/cat_key in SStriumphs.central_state_data)
		if(cat_key == current_category)
			data += "<a class=\"triumph_categories_selected\" href=\"byond://?src=\ref[src];select_a_category=[cat_key]\"><span class=\"bigunder_back\"><span class=\"bigunder\"></span>[cat_key]</span></a>"
		else
			data += "<a class=\"triumph_categories_normal\" href=\"byond://?src=\ref[src];select_a_category=[cat_key]\">[cat_key]</a>"

	data += {"
	<hr class=\"fadeout_line\">
		</div>
	"}

	if(current_category == TRIUMPH_CAT_ACTIVE_DATUMS)
		var/found_one = FALSE
		var/list/active_items = list()

		for(var/datum/triumph_buy/found_triumph_buy in SStriumphs.active_triumph_buy_queue)
			if(!found_triumph_buy.visible_on_active_menu || usr.ckey != found_triumph_buy.ckey_of_buyer)
				continue

			active_items += found_triumph_buy
			found_one = TRUE

		if(found_one)
			data += {"
				<table>
					<thead>
						<tr>
							<th class=\"triumph_text_head\">Description</th>
							<th class=\"triumph_text_head_redeem\">Redeem</th>
						</tr>
					</thead>
					<tbody>
			"}

			for(var/datum/triumph_buy/found_triumph_buy in active_items)
				data += {"
					<tr class='triumph_text_row'>
						<td class='triumph_text_desc'>
							<div class='triumph_name'>[found_triumph_buy.name]</div>
							[found_triumph_buy.desc]
						</td>
				"}

				if(SSticker.HasRoundStarted() && found_triumph_buy.pre_round_only)
					data += "<td class='triumph_buy_wrapper'><a class='triumph_text_buy' href='byond://?src=\ref[src];handle_buy_button=\ref[found_triumph_buy];'><span class='strikethru_back'>ROUND STARTED</span></a></td>"
				else
					data += "<td class='triumph_buy_wrapper'><a class='triumph_text_buy' href='byond://?src=\ref[src];handle_buy_button=\ref[found_triumph_buy];'>REFUND</a></td>"

				data += "</tr>"

			data += {"
					</tbody>
				</table>
			"}
		else
			data += {"
				<div class='nothing_bought'>YOU HAVE NOTHING</div>
			"}
	else if(current_category == TRIUMPH_CAT_COMMUNAL)
		data += "<div class='communal_container'>"

		for(var/datum/triumph_buy/communal/communal_buy in SStriumphs.central_state_data[current_category]["[current_page]"])
			var/total = SStriumphs.communal_pools[communal_buy.type]
			var/progress = communal_buy.maximum_pool ? (total / communal_buy.maximum_pool) * 100 : 0
			var/is_preround = istype(communal_buy, /datum/triumph_buy/communal/preround)

			data += "<div class='communal_item'>"
			data += "<div class='communal_name'>[communal_buy.name]</div>"
			data += "<div class='communal_desc'>[communal_buy.desc]</div>"

			data += "<div class='progress_container'>"
			data += "<div class='progress_bar' style='width:[progress]%'></div>"
			data += "<div class='progress_text'>[total]/[communal_buy.maximum_pool]</div>"
			data += "</div>"

			data += "<div style='text-align:center; margin-top:5px;'>"
			if(communal_buy.activated)
				data += "<div class='communal_contribute'>ACTIVE</div>"
			else if(is_preround && SSticker.HasRoundStarted())
				data += "<div class='communal_contribute'>PREROUND ONLY</div>"
			else
				data += "<a class='communal_contribute' href='byond://?src=\ref[src];contribute=\ref[communal_buy]'>CONTRIBUTE</a>"
			data += "</div>"
			data += "</div>"

		data += "</div>"

	else
		data += {"
			<table>
				<thead>
					<tr>
						<th class=\"triumph_text_head\">Description</th>
						<th class=\"triumph_text_head\">Cost</th>
						<th class=\"triumph_text_head\">Stock</th>
						<th class=\"triumph_text_head_redeem\">Redeem</th>
					</tr>
				</thead>
				<tbody>
		"}

		for(var/datum/triumph_buy/current_check in SStriumphs.central_state_data[current_category]["[current_page]"])
			data += {"
				<tr class='triumph_text_row'>
					<td class='triumph_text_desc'>
						<div class='triumph_name'>[current_check.name]</div>
						[current_check.desc]
					</td>
					<td class='triumph_cost_wrapper'>[current_check.triumph_cost]</td>
					<td class='triumph_stock_wrapper'>[current_check.limited ? SStriumphs.triumph_buy_stocks[current_check.type] : "∞"]</td>
			"}

			var/string = "<td class='triumph_buy_wrapper'><a class='triumph_text_buy' href='byond://?src=\ref[src];handle_buy_button=\ref[current_check];'>BUY</a></td>"
			if(current_check.limited && SStriumphs.triumph_buy_stocks[current_check.type] <= 0)
				string = "<td class='triumph_buy_wrapper'><a class='triumph_text_buy' href='byond://?src=\ref[src];handle_buy_button=\ref[current_check];'><span class='strikethru_back'>OUT OF STOCK</span></a></td>"
			else if(SSticker.HasRoundStarted() && current_check.pre_round_only)
				string = "<td class='triumph_buy_wrapper'><a class='triumph_text_buy' href='byond://?src=\ref[src];handle_buy_button=\ref[current_check];'><span class='strikethru_back'>CONFLICT</span></a></td>"
			else
				for(var/datum/triumph_buy/conflict_check in SStriumphs.active_triumph_buy_queue)
					if(current_check.type in conflict_check.conflicts_with)
						string = "<td class='triumph_filler_cells'><a class='triumph_text_buy' href='byond://?src=\ref[src];handle_buy_button=\ref[current_check];'><span class='strikethru_back'>CONFLICT</span></a></td>"

			data += string
			data += "</tr>"

		data += {"
				</tbody>
			</table>
		"}

	data += "<div class='triumph_footer'>"

	for(var/i in 1 to SStriumphs.central_state_data[current_category].len)
		if("[i]" == current_page)
			data += "<a class='triumph_numbers_selected' href='byond://?src=\ref[src];select_a_page=[i]'><span class='num_bigunder_back'><span class='num_bigunder'></span>[i]</span></a>"
		else
			data += "<a class='triumph_numbers_normal' href='byond://?src=\ref[src];select_a_page=[i]'>[i]</a>"

	data += "</div>"
	data += {"
		</body>
	</html>
	"}
	linked_client << browse(data, "window=triumph_buy_window;size=675x855;can_close=1;can_minimize=0;can_maximize=0;can_resize=1;titlebar=1")
	for(var/i in 1 to 10)
		if(!linked_client)
			break
		if(winexists(linked_client, "triumph_buy_window"))
			winset(linked_client, "triumph_buy_window", "on-close=\".windowclose [REF(src)]\"")
			break

/datum/triumph_buy_menu/Topic(href, list/href_list)
	. = ..()

	if(href_list["select_a_category"])
		var/sent_category = href_list["select_a_category"]
		if(SStriumphs.central_state_data[sent_category])
			if(sent_category != current_category)
				current_category = sent_category
				current_page = "1"
				show_menu()

	if(href_list["select_a_page"])
		var/sent_page = href_list["select_a_page"]
		if(SStriumphs.central_state_data[current_category]["[sent_page]"])
			if(sent_page != current_page)
				current_page = sent_page
				show_menu()

	if(href_list["contribute"])
		if(!linked_client?.ckey)
			return
		if(SSticker.current_state == GAME_STATE_FINISHED)
			to_chat(linked_client, span_warning("You cannot contribute after the round has ended!"))
			return

		var/datum/triumph_buy/communal/communal_buy = locate(href_list["contribute"])
		if(communal_buy && istype(communal_buy))
			if(communal_buy.disabled)
				to_chat(linked_client, span_warning("This Triumph Buy has been disabled by administrators!"))
				return
			if(communal_buy.activated)
				to_chat(linked_client, span_warning("The item is already active!"))
				return
			if(istype(communal_buy, /datum/triumph_buy/communal/preround) && SSticker.HasRoundStarted())
				to_chat(linked_client, span_warning("This can only be contributed to before the round starts!"))
				return

			var/available = SStriumphs.get_triumphs(linked_client.ckey)
			var/max_possible = communal_buy.maximum_pool ? communal_buy.maximum_pool - SStriumphs.communal_pools[communal_buy.type] : INFINITY
			var/amount = input(linked_client, "How much to contribute?", "Communal Contribution", 0) as num|null

			if(!linked_client?.ckey)
				return
			if(!amount || amount <= 0)
				return

			if(SSticker.current_state == GAME_STATE_FINISHED)
				to_chat(linked_client, span_warning("You cannot contribute after the round has ended!"))
				return
			if(communal_buy.activated)
				to_chat(linked_client, span_warning("The item is already active!"))
				return
			if(istype(communal_buy, /datum/triumph_buy/communal/preround) && SSticker.HasRoundStarted())
				to_chat(linked_client, span_warning("This can only be contributed to before the round starts!"))
				return

			amount = round(amount)
			if(amount <= 0)
				to_chat(linked_client, span_warning("You must contribute at least one whole triumph!"))
				return
			if(amount > available)
				to_chat(linked_client, span_warning("You don't have [amount] triumph\s! You only have [available] triumph\s."))
				return

			amount = min(amount, available, max_possible)
			if(amount > 0)
				linked_client.adjust_triumphs(-amount, counted = FALSE, silent = TRUE)
				SStriumphs.communal_pools[communal_buy.type] += amount
				LAZYADD(SStriumphs.communal_contributions[communal_buy.type][linked_client.ckey], amount)
				to_chat(linked_client, span_notice("You have contributed [amount] triumph\s to the [communal_buy.name]."))

				if(amount >= 5 && SSticker.current_state < GAME_STATE_SETTING_UP)
					to_chat(world, span_notice("[amount] triumph\s were contributed to the [communal_buy.name] communal buy!"))

				if(communal_buy.maximum_pool && SStriumphs.communal_pools[communal_buy.type] >= communal_buy.maximum_pool)
					communal_buy.on_activate()

				SStriumphs.refresh_communal_menus()
			else
				show_menu()

	if(href_list["handle_buy_button"])
		if(!linked_client?.ckey)
			return
		if(SSticker.current_state == GAME_STATE_FINISHED)
			to_chat(linked_client, span_warning("You cannot buy anything after the round has ended!"))
			return

		var/datum/triumph_buy/target_datum = locate(href_list["handle_buy_button"])
		if(target_datum)
			var/conflicting = FALSE

			for(var/datum/triumph_buy/current_actives in SStriumphs.active_triumph_buy_queue)
				if(target_datum.type in current_actives.conflicts_with)
					conflicting = TRUE

			if(SSticker.HasRoundStarted() && target_datum.pre_round_only)
				conflicting = TRUE

			if(!conflicting)
				// Well we already made sure it wasn't going to conflict before we sent the path in, im sleepy and I hope this isn't REALLY fuckedu p when i look at it later
				if(current_category == TRIUMPH_CAT_ACTIVE_DATUMS) // ACTIVE datums are ones already bought anyways
					SStriumphs.attempt_to_unbuy_triumph_condition(linked_client, target_datum) // By unbuy, i mean you unbuy someone elses buy and thus we need a ref to it anyways
				else
					SStriumphs.attempt_to_buy_triumph_condition(linked_client, target_datum) // regular buy, just send over the ref to the reference case
			show_menu()

	if(href_list["close"])
		SStriumphs.remove_triumph_buy_menu(linked_client)
