

/*
 * Book
 */
/obj/item/book
	name = "book"
	icon = 'icons/roguetown/items/books.dmi'
	icon_state = "basic_book_0"
	desc = ""
	dropshrink = 0.6
	drop_sound = 'sound/foley/dropsound/book_drop.ogg'
	force = 5
	throw_speed = 1
	throw_range = 5
	slot_flags = ITEM_SLOT_HIP
	w_class = WEIGHT_CLASS_NORMAL		 //upped to three because books are, y'know, pretty big. (and you could hide them inside eachother recursively forever)
	attack_verb = list("bashed", "whacked", "educated")
	resistance_flags = FLAMMABLE
	drop_sound = 'sound/blank.ogg'
	pickup_sound =  'sound/blank.ogg'
	firefuel = 2 MINUTES

	grid_width = 32
	grid_height = 64

	var/random_cover
	var/category = null

	base_icon_state = "basic_book"
	var/open = FALSE
	var/dat				//Actual page content
	var/due_date = 0	//Game time in 1/10th seconds
	var/author			//Who wrote the thing, can be changed by pen or PC. It is not automatically assigned
	var/unique = TRUE		//0 - Normal book, 1 - Should not be treated as normal book, unable to be copied, unable to be modified
	var/title			//The real name of the book.
	var/window_size = null // Specific window size for the book, i.e: "1920x1080", Size x Width

	var/list/pages = list()
	var/bookfile
	var/curpage = 1
	var/textper = 100
	var/our_font = "Rosemary Roman"
	var/override_find_book = FALSE
	var/special_book = FALSE

/obj/item/book/examine(mob/user)
	. = ..()
	. += "<a href='byond://?src=[REF(src)];read=1'>Read</a>"

/obj/item/book/getonmobprop(tag)
	. = ..()
	if(tag)
		if(open)
			switch(tag)
				if("gen")
					return list("shrink" = 0.4,
	"sx" = -2,
	"sy" = -3,
	"nx" = 10,
	"ny" = -2,
	"wx" = 1,
	"wy" = -3,
	"ex" = 5,
	"ey" = -3,
	"northabove" = 0,
	"southabove" = 1,
	"eastabove" = 1,
	"westabove" = 0,
	"nturn" = 0,
	"sturn" = 0,
	"wturn" = 0,
	"eturn" = 0,
	"nflip" = 0,
	"sflip" = 0,
	"wflip" = 0,
	"eflip" = 0)
				if("onbelt")
					return list("shrink" = 0.3,"sx" = -2,"sy" = -5,"nx" = 4,"ny" = -5,"wx" = 0,"wy" = -5,"ex" = 2,"ey" = -5,"nturn" = 0,"sturn" = 0,"wturn" = 0,"eturn" = 0,"nflip" = 0,"sflip" = 0,"wflip" = 0,"eflip" = 0,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0)
		else
			switch(tag)
				if("gen")
					return list("shrink" = 0.4,
	"sx" = -2,
	"sy" = -3,
	"nx" = 10,
	"ny" = -2,
	"wx" = 1,
	"wy" = -3,
	"ex" = 5,
	"ey" = -3,
	"northabove" = 0,
	"southabove" = 1,
	"eastabove" = 1,
	"westabove" = 0,
	"nturn" = 0,
	"sturn" = 0,
	"wturn" = 0,
	"eturn" = 0,
	"nflip" = 0,
	"sflip" = 0,
	"wflip" = 0,
	"eflip" = 0)
				if("onbelt")
					return list("shrink" = 0.3,"sx" = -2,"sy" = -5,"nx" = 4,"ny" = -5,"wx" = 0,"wy" = -5,"ex" = 2,"ey" = -5,"nturn" = 0,"sturn" = 0,"wturn" = 0,"eturn" = 0,"nflip" = 0,"sflip" = 0,"wflip" = 0,"eflip" = 0,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0)

// ...... Book Cover Randomizer Code  (gives the book a radom cover when random_cover = TRUE)
/obj/item/book/Initialize()
	. = ..()
	if(random_cover)
		base_icon_state = "book[rand(1,8)]"
		icon_state = "[base_icon_state]_0"

/obj/item/book/attack_self(mob/user, list/modifiers)
	if(!open)
		attack_hand_secondary(user, modifiers)
		return
	if(!user.can_read(src))
		return
	if(!user.client || !user.hud_used)
		return
	if(!user.hud_used.reads)
		return
	read(user)
	user.update_inv_hands()

/obj/item/book/attack_self_secondary(mob/user, list/modifiers)
	. = ..()
	if(. == SECONDARY_ATTACK_CANCEL_ATTACK_CHAIN)
		return
	attack_hand_secondary(user, modifiers)
	return SECONDARY_ATTACK_CANCEL_ATTACK_CHAIN

/obj/item/book/proc/read(mob/user)
	if(special_book)
		return
	if(!open)
		to_chat(user, "<span class='info'>Open me first.</span>")
		return FALSE
	user << browse_rsc('html/book.png')
	if(!user.client || !user.hud_used)
		return
	if(!user.hud_used.reads)
		return
	if(!user.can_read(src))
		user.adjust_experience(/datum/skill/misc/reading, 4, FALSE)
		return
	if(in_range(user, src) || isobserver(user))
		if(!pages.len)
			if(!override_find_book)
				pages = SSlibrarian.get_book(bookfile)
		if(!pages.len)
			to_chat(user, "<span class='warning'>This book is completely blank.</span>")
		if(curpage > pages.len)
			curpage = 1
//		var/curdat = pages[curpage]
		var/dat = {"<!DOCTYPE HTML PUBLIC \"-//W3C//DTD HTML 4.01 Transitional//EN\" \"http://www.w3.org/TR/html4/loose.dtd\">
					<html><head><style type=\"text/css\">
					body { background-image:url('book.png');background-repeat: repeat; }</style></head><body scroll=yes>"}
		for(var/A in pages)
			dat += A
			dat += "<br>"
		dat += "<a href='byond://?src=[REF(src)];close=1' style='position:absolute;right:50px'>Close</a>"
		dat += "</body></html>"
		user << browse(dat, "window=reading;size=1000x700;can_close=1;can_minimize=0;can_maximize=0;can_resize=1;titlebar=0;border=0")
		onclose(user, "reading", src)
		SEND_SIGNAL(user, COMSIG_BOOK_READ)
	else
		return "<span class='warning'>You're too far away to read it.</span>"


/obj/item/book/Topic(href, href_list)
	..()

	if(!usr)
		return

	if(href_list["close"])
		var/mob/user = usr
		if(user?.client && user.hud_used)
			if(user.hud_used.reads)
				user.hud_used.reads.destroy_read()
			user << browse(null, "window=reading")

	if(!usr.can_perform_action(src, NEED_LITERACY|FORBID_TELEKINESIS_REACH))
		return

	if(href_list["read"])
		read(usr)

	if(href_list["turnpage"])
		if(pages.len >= curpage+2)
			curpage += 2
		else
			curpage = 1
		playsound(src, 'sound/items/book_page.ogg', 100, TRUE, -1)
		read(usr)

/obj/item/book/attack_hand_secondary(mob/user, list/modifiers)
	. = ..()
	if(. == SECONDARY_ATTACK_CANCEL_ATTACK_CHAIN)
		return
	if(!open)
		slot_flags &= ~ITEM_SLOT_HIP
		open = TRUE
		playsound(src, 'sound/items/book_open.ogg', 100, FALSE, -1)
	else
		slot_flags |= ITEM_SLOT_HIP
		open = FALSE
		playsound(src, 'sound/items/book_close.ogg', 100, FALSE, -1)
	curpage = 1
	update_appearance(UPDATE_ICON_STATE)
	user.update_inv_hands()
	return SECONDARY_ATTACK_CANCEL_ATTACK_CHAIN

/obj/item/book/update_icon_state()
	. = ..()
	icon_state = "[base_icon_state]_[open]"

/obj/item/book/secret/ledger
	name = "catatoma"
	icon_state = "ledger_0"
	base_icon_state = "ledger"
	title = "Catatoma"
	dat = "To create a shipping order, use a scroll on me."
	special_book = TRUE
	var/fence = FALSE
	var/mob/current_reader
	var/current_category = "All"
	var/search_query = ""
	var/show_in_stock = FALSE
	var/allow_reputation_purchase = FALSE
	var/list/categories = list("All")
	var/list/types = list()
	var/list/cart = list() // Track items in cart
	var/list/reputation_cart = list()

/obj/item/book/secret/ledger/Initialize()
	. = ..()
	// Populate categories and types from SSmerchant.supply_cats and SSmerchant.supply_packs
	categories += SSmerchant.supply_cats
	for(var/pack in SSmerchant.supply_packs)
		var/datum/supply_pack/PA = SSmerchant.supply_packs[pack]
		if(!PA.contraband) // You can add a var to control whether to show contraband
			types += PA

/obj/item/book/secret/ledger/attack_self(mob/user, list/modifiers)
	. = ..()
	current_reader = user
	current_reader << browse(generate_html(user),"window=ledger;size=800x810")

/obj/item/book/secret/ledger/proc/generate_html(mob/user)
	if(!length(types))
		for(var/pack in SSmerchant.supply_packs)
			var/datum/supply_pack/PA = SSmerchant.supply_packs[pack]
			if(!PA.contraband) // You can add a var to control whether to show contraband
				types += PA

	var/client/client = user
	if(!istype(client))
		client = user.client
	SSassets.transport.send_assets(client, list("try4_border.png", "try4.png", "slop_menustyle2.css"))
	user << browse_rsc('html/book.png')

	// Get faction info for display
	var/faction_html = generate_faction_info_html()

	var/html = {"
		<!DOCTYPE html>
		<html lang="en">
		<meta charset='UTF-8'>
		<meta http-equiv='X-UA-Compatible' content='IE=edge,chrome=1'/>
		<meta http-equiv='Content-Type' content='text/html; charset=UTF-8'/>

		<style>
			@import url('https://fonts.googleapis.com/css2?family=Charm:wght@700&display=swap');
			body {
				font-family: "Charm", cursive;
				font-size: 1.2em;
				text-align: center;
				margin: 20px;
				color: #3e2723;
				background-color: rgb(31, 20, 24);
				background:
					url('[SSassets.transport.get_asset_url("try4_border.png")]'),
					url('book.png');
				background-repeat: no-repeat;
				background-attachment: fixed;
				background-size: 100% 100%;
			}
			h1 {
				text-align: center;
				font-size: 2em;
				border-bottom: 2px solid #3e2723;
				padding-bottom: 10px;
				margin-bottom: 20px;
			}
			.faction-info {
				margin-bottom: 15px;
				padding: 10px;
				border: 2px solid var(--faction-color, #3e2723);
				border-radius: 10px;
				background-color: rgba(210, 180, 140, 0.1);
				text-align: left;
				position: relative;
			}
			.faction-header {
				color: var(--faction-color, #3e2723);
				margin: 0 0 5px 0;
				text-align: center;
				font-size: 1.3em;
			}
			.faction-toggle {
				position: absolute;
				top: 8px;
				right: 10px;
				background: none;
				border: none;
				color: var(--faction-color, #3e2723);
				cursor: pointer;
				font-size: 1.2em;
				font-weight: bold;
			}
			.faction-details {
				display: none;
				margin-top: 10px;
			}
			.faction-details.expanded {
				display: block;
			}
			.faction-summary {
				display: flex;
				justify-content: space-between;
				align-items: center;
				font-size: 0.9em;
				margin-top: 5px;
			}
			.bounty-grid {
				display: grid;
				grid-template-columns: 1fr 1fr;
				gap: 15px;
				margin-top: 10px;
			}
			.bounty-list {
				margin: 0;
				padding-left: 20px;
			}
			.bounty-item {
				padding: 2px 0;
				font-weight: bold;
				color: #8b4513;
				font-size: 0.9em;
			}
			.book-content {
				display: flex;
				height: 75%;
			}
			.sidebar {
				width: 30%;
				padding: 10px;
				border-right: 2px solid #3e2723;
				overflow-y: auto;
				max-height: 500px;
			}
			.main-content {
				width: 70%;
				padding: 10px;
				overflow-y: auto;
				max-height: 500px;
				text-align: left;
			}
			.filter-controls {
				margin-bottom: 15px;
				padding: 10px;
				border: 1px solid #3e2723;
				border-radius: 5px;
				background-color: rgba(210, 180, 140, 0.1);
			}

			.stock-filter {
				display: flex;
				align-items: center;
				margin-bottom: 10px;
				font-size: 0.9em;
			}

			.stock-filter-btn {
				padding: 5px 10px;
				background-color: #d2b48c;
				border: 1px solid #3e2723;
				border-radius: 5px;
				cursor: pointer;
				font-family: "Charm", cursive;
				font-size: 0.9em;
				margin-right: 10px;
			}

			.stock-filter-btn.active {
				background-color: #8b4513;
				color: white;
			}

			.reputation-controls {
				margin-bottom: 15px;
				padding: 10px;
				border: 1px solid #8b4513;
				border-radius: 5px;
				background-color: rgba(139, 69, 19, 0.1);
			}

			.reputation-toggle {
				display: flex;
				align-items: center;
				margin-bottom: 10px;
				font-size: 0.9em;
			}

			.reputation-toggle-btn {
				padding: 5px 10px;
				background-color: #8b4513;
				color: white;
				border: 1px solid #3e2723;
				border-radius: 5px;
				cursor: pointer;
				font-family: "Charm", cursive;
				font-size: 0.9em;
				margin-right: 10px;
			}

			.reputation-toggle-btn.inactive {
				background-color: #d2b48c;
				color: #3e2723;
			}

			.reputation-warning {
				font-size: 0.8em;
				color: #8b4513;
				font-style: italic;
				margin-top: 5px;
			}

			.categories {
				margin-bottom: 15px;
			}
			.category-btn {
				margin: 2px;
				padding: 5px;
				background-color: #d2b48c;
				border: 1px solid #3e2723;
				border-radius: 5px;
				cursor: pointer;
				font-family: "Charm", cursive;
				font-size: 0.9em;
			}
			.category-btn.active {
				background-color: #8b4513;
				color: white;
			}
			.search-box {
				width: 90%;
				padding: 5px;
				margin-bottom: 15px;
				border: 1px solid #3e2723;
				border-radius: 5px;
				font-family: "Charm", cursive;
			}
			.recipe-list {
				text-align: left;
			}
			.item-link {
				display: block;
				padding: 5px;
				color: #3e2723;
				text-decoration: none;
				border-bottom: 1px dotted #d2b48c;
				position: relative;
			}
			.item-link:hover {
				background-color: rgba(210, 180, 140, 0.3);
			}
			.item-link.unavailable {
				opacity: 0.7;
				color: #888;
			}
			.item-link.reputation-purchase {
				border-left: 3px solid #8b4513;
				background-color: rgba(139, 69, 19, 0.1);
			}
			.reputation-cost {
				font-size: 0.8em;
				color: #8b4513;
				font-weight: bold;
				margin-left: 5px;
			}
			.add-to-cart-btn {
				float: right;
				padding: 2px 5px;
				background-color: #8b4513;
				color: white;
				border: 1px solid #3e2723;
				border-radius: 3px;
				cursor: pointer;
				font-size: 0.8em;
				margin-left: 5px;
			}
			.add-to-cart-btn.reputation-btn {
				background-color: #d2691e;
			}
			.item-content {
				padding: 10px;
			}
			.back-btn {
				margin-top: 10px;
				padding: 5px 10px;
				background-color: #d2b48c;
				border: 1px solid #3e2723;
				border-radius: 5px;
				cursor: pointer;
				font-family: "Charm", cursive;
			}
			.icon {
				width: 96px;
				height: 96px;
				vertical-align: middle;
				margin-right: 10px;
			}
			.result-icon {
				text-align: center;
				margin: 15px 0;
			}
			.order-button {
				display: inline-block;
				margin: 10px 0;
				padding: 8px 15px;
				background-color: #8b4513;
				color: white;
				border: 1px solid #3e2723;
				border-radius: 5px;
				cursor: pointer;
				font-family: "Charm", cursive;
				text-decoration: none;
			}
			.quantity-input {
				width: 60px;
				padding: 5px;
				text-align: center;
				font-family: "Charm", cursive;
			}
			.no-matches {
				font-style: italic;
				color: #8b4513;
				padding: 10px;
				text-align: center;
				display: none;
			}
			.cart-content {
				margin-top: 20px;
				border-top: 2px solid #3e2723;
				padding-top: 15px;
			}
			.cart-item {
				justify-content: space-between;
				padding: 5px 0;
				border-bottom: 1px dotted #d2b48c;
			}
			.cart-item.reputation-item {
				background-color: rgba(139, 69, 19, 0.05);
				border-left: 3px solid #8b4513;
				padding-left: 8px;
			}
			.remove-item {
				color: #8b4513;
				cursor: pointer;
				font-weight: bold;
			}
			.checkout-button {
				display: block;
				width: 80%;
				margin: 20px auto;
				padding: 10px;
				background-color: #8b4513;
				color: white;
				border: 1px solid #3e2723;
				border-radius: 5px;
				cursor: pointer;
				font-family: "Charm", cursive;
				text-decoration: none;
				font-size: 1.2em;
			}
			table {
				margin: 10px auto;
				border-collapse: collapse;
				width: 100%;
			}
			table, th, td {
				border: 1px solid #3e2723;
			}
			th, td {
				padding: 8px;
				text-align: left;
			}
			th {
				background-color: rgba(210, 180, 140, 0.3);
			}
			.hidden {
				display: none;
			}
			.item-details {
				margin: 15px 0;
				padding: 15px;
				border: 1px solid #3e2723;
				border-radius: 5px;
				background-color: rgba(210, 180, 140, 0.1);
			}
			.item-description {
				margin: 15px 0;
				font-style: italic;
			}
			.add-to-cart {
				display: flex;
				align-items: center;
				justify-content: center;
				margin: 15px 0;
			}
			.add-btn {
				padding: 8px 15px;
				background-color: #8b4513;
				color: white;
				border: 1px solid #3e2723;
				border-radius: 5px;
				cursor: pointer;
				font-family: "Charm", cursive;
				margin-left: 10px;
			}
			.order-section {
				width: 100%;
			}
			.cart-table {
				width: 100%;
			}
			.cart-actions {
				display: flex;
				justify-content: space-between;
				align-items: center;
			}
			.cart-quantity {
				width: 60px;
				padding: 5px;
				text-align: center;
			}
			.reputation-costs {
				margin-top: 15px;
				padding: 10px;
				border: 1px solid #8b4513;
				border-radius: 5px;
				background-color: rgba(139, 69, 19, 0.05);
			}
		</style>

		<body>
			<h1>Catacoma</h1>

			<!-- Faction Information Section -->
			[faction_html]

			<div class="book-content">
				<div class="sidebar">
					<!-- Filter Controls -->
					<div class="filter-controls">
						<div class="stock-filter">
							<button class="stock-filter-btn [show_in_stock ? "active" : ""]"
									onclick="location.href='byond://?src=\ref[src];action=toggle_stock_filter&show_in_stock=[show_in_stock ? "false" : "true"]'">
								[show_in_stock ? "Showing: In Stock Only" : "Showing: All Items"]
							</button>
						</div>
						<div class="reputation-toggle">
							<button class="reputation-toggle-btn [allow_reputation_purchase ? "" : "inactive"]"
									onclick="location.href='byond://?src=\ref[src];action=toggle_reputation_purchase&allow=[allow_reputation_purchase ? "false" : "true"]'">
								[allow_reputation_purchase ? "Rep Purchase: ON" : "Rep Purchase: OFF"]
							</button>
						</div>
					</div>


					<!-- Search box -->
					<input type="text" class="search-box" id="searchInput"
						placeholder="Search items..." value="[html_encode(search_query)]">

					<!-- Categories -->
					<div class="categories">
	"}

	for(var/category in categories)
		var/active_class = category == current_category ? "active" : ""
		html += "<button class='category-btn [active_class]' onclick=\"location.href='byond://?src=\ref[src];action=set_category&category=[url_encode(category)]'\">[category]</button>"

	html += {"
					</div>

					<!-- Item List -->
					<div class="recipe-list" id="itemList">
	"}

	// Get faction info for calculating reputation costs
	var/datum/world_faction/current_faction = SSmerchant.active_faction

	for(var/datum/supply_pack/pack in types)
		var/should_show = TRUE
		var/is_available = current_faction.has_supply_pack(pack.type)

		if(pack.contraband && !fence)
			should_show = FALSE
		if(current_category != "All")
			if(pack.group != current_category)
				should_show = FALSE
		if(!is_available && show_in_stock && !allow_reputation_purchase)
			should_show = FALSE

		var/display_style = should_show ? "" : "display: none;"
		var/availability_class = is_available ? "" : "unavailable"
		var/stock_class = is_available ? "in-stock" : "out-of-stock"
		var/reputation_class = ""
		var/reputation_cost_text = ""

		// Calculate reputation cost for out-of-stock items
		if(!is_available && allow_reputation_purchase)
			var/reputation_cost = pack.calculate_reputation_cost()
			reputation_class = "reputation-purchase"
			reputation_cost_text = " <span class='reputation-cost'>([reputation_cost] rep)</span>"

		if(should_show)
			var/availability_text = is_available ? "" : " (Out of Stock)"
			var/action_url = is_available ? "add_to_cart" : (allow_reputation_purchase ? "add_to_cart_reputation" : "add_to_cart")

			html += "<a class='item-link [availability_class] [stock_class] [reputation_class]' data-in-stock='[is_available ? "true" : "false"]' href='byond://?src=\ref[src];action=[action_url]&item=\ref[pack]&quantity=1' style='[display_style]'>[pack.name] ([pack.cost] mammons)[availability_text][reputation_cost_text]</a>"

	html += {"
						<div id="noMatchesMsg" class="no-matches">No matching items found.</div>
					</div>
				</div>

				<div class="main-content" id="mainContent">
					<div class='item-content'>
						<div class="order-section">
	"}

	// Display cart items with reputation costs
	if(length(cart) > 0)
		html += "<table class='cart-table'><tr><th>Item</th><th>Quantity</th><th>Cost</th><th>Actions</th></tr>"
		var/total_cost = 0
		var/total_reputation_cost = 0

		for(var/datum/supply_pack/pack in cart)
			var/item_quantity = cart[pack]
			var/item_cost = pack.cost * item_quantity
			var/is_reputation_purchase = (pack in reputation_cart)
			var/reputation_cost = 0

			if(is_reputation_purchase)
				item_cost *= 2 // Double mammon cost for reputation purchases
				reputation_cost = pack.calculate_reputation_cost() * item_quantity
				total_reputation_cost += reputation_cost

			total_cost += item_cost

			var/reputation_class = is_reputation_purchase ? "reputation-item" : ""

			html += "<tr class='cart-item [reputation_class]'>"
			html += "<td>[pack.name][is_reputation_purchase ? " (Rep)" : ""]</td>"
			html += "<td>"
			html += "<form class='cart-actions' action='byond://?src=\ref[src];action=update_cart&item=\ref[pack]' method='get'>"
			html += "<input type='hidden' name='src' value='\ref[src]'>"
			html += "<input type='hidden' name='action' value='update_cart'>"
			html += "<input type='hidden' name='item' value='\ref[pack]'>"
			html += "<input type='number' name='quantity' value='[item_quantity]' min='1' max='100' class='cart-quantity'>"
			html += "<input type='submit' value='Update' class='add-btn' style='padding: 3px 8px; font-size: 0.8em;'>"
			html += "</form>"
			html += "</td>"
			html += "<td>[item_cost] mammons[is_reputation_purchase ? " + [reputation_cost] rep" : ""]</td>"
			html += "<td><span class='remove-item' onclick=\"location.href='byond://?src=\ref[src];action=remove_from_cart&item=\ref[pack]'\">✖</span></td>"
			html += "</tr>"

		html += "<tr><td colspan='2'><strong>Total:</strong></td><td colspan='2'><strong>[total_cost] mammons"
		if(total_reputation_cost > 0)
			html += " + [total_reputation_cost] reputation"
		html += "</strong></td></tr>"
		html += "</table>"

		if(total_reputation_cost > 0)
			html += "<div class='reputation-costs'>"
			html += "<strong>Reputation Cost Warning:</strong> This order will cost [total_reputation_cost] reputation points. "
			html += "Current reputation: [current_faction.faction_reputation]"
			html += "</div>"

		html += "<button class='checkout-button' onclick=\"location.href='byond://?src=\ref[src];action=checkout'\">Create Order Scroll</button>"

	else
		html += "<p>Your cart is empty. Click the 'Add' button next to items to add them to your order.</p>"

	html += {"
							</div>
						</div>
					</div>
				</div>
			</div>

			<script>
				// Faction info toggle
				function toggleFactionInfo() {
					const details = document.querySelector('.faction-details');
					const toggle = document.querySelector('.faction-toggle');

					if (details.classList.contains('expanded')) {
						details.classList.remove('expanded');
						toggle.textContent = '+';
					} else {
						details.classList.add('expanded');
						toggle.textContent = '−';
					}
				}

				// Stock filter functionality
				function filterItems(query) {
						const itemLinks = document.querySelectorAll('.item-link');
						const currentCategory = "[current_category]";
						const showInStockOnly = document.querySelector('.stock-filter-btn').classList.contains('active');
						const allowReputationPurchase = document.querySelector('.reputation-toggle-btn').classList.contains('active');
						let anyVisible = false;

						itemLinks.forEach(function(link) {
							const itemName = link.textContent.toLowerCase();
							const isInStock = link.getAttribute('data-in-stock') === 'true';
							const isReputationPurchase = link.classList.contains('reputation-purchase');

							// Check if it matches the search query
							const matchesQuery = query === '' || itemName.includes(query);

							// Check if it matches stock filter
							let matchesStock = true;
							if (showInStockOnly && !isInStock && !allowReputationPurchase) {
								matchesStock = false;
							}

							// Show if it matches both filters
							if (matchesQuery && matchesStock) {
								link.style.display = 'block';
								anyVisible = true;
							} else {
								link.style.display = 'none';
							}
						});

						// Show a message if no items match
						const noMatchesMsg = document.getElementById('noMatchesMsg');
						noMatchesMsg.style.display = anyVisible ? 'none' : 'block';

						// Remember the query
						window.location.replace(`byond://?src=\\ref[src];action=remember_query&query=${encodeURIComponent(query)}`);
					}

				// Live search functionality with debouncing
				let searchTimeout;
				document.getElementById('searchInput').addEventListener('keyup', function(e) {
					clearTimeout(searchTimeout);

					// Debounce the search to improve performance
					searchTimeout = setTimeout(function() {
						const query = document.getElementById('searchInput').value.toLowerCase();
						filterItems(query);
					}, 300);
				});

				// Initialize search based on any current query
				if ("[html_encode(search_query)]" !== "") {
					filterItems("[html_encode(search_query)]".toLowerCase());
				}
			</script>
		</body>
		</html>
	"}

	return html

/obj/item/book/secret/ledger/proc/generate_faction_info_html()
	var/datum/world_faction/faction = SSmerchant.active_faction
	if(!faction)
		return ""

	faction.schedule_next_boat_traders()

	// Find the earliest bounty expiration time
	var/earliest_bounty_expiration = 0
	if(length(faction.bounty_refresh_times))
		earliest_bounty_expiration = INFINITY
		for(var/bounty_type in faction.bounty_refresh_times)
			var/expiration_time = faction.bounty_refresh_times[bounty_type]
			expiration_time -= world.time
			if(expiration_time < earliest_bounty_expiration)
				earliest_bounty_expiration = expiration_time

	var/html = {"
		<div class="faction-info" style="--faction-color: [faction.faction_color];">
			<h2 class="faction-header">[faction.faction_name] - [faction.get_reputation_status()]</h2>
			<button class="faction-toggle" onclick="toggleFactionInfo()">+</button>
			<div class="faction-summary">
				<span><strong>[length(faction.faction_supply_packs)]</strong> items in stock</span>
				<span>Next rotation: <strong>[time_to_text(faction.next_supply_rotation - world.time)]</strong></span>
			</div>
			<div class="faction-details">
				<p style="font-style: italic; margin: 10px 0; text-align: center;">[faction.desc]</p>
				<div class="bounty-grid">
					<div>
						<h3 style="color: [faction.faction_color]; margin: 0 0 10px 0;">Active Bounties:</h3>
						<ul class="bounty-list">
	"}

	if(length(faction.bounty_items))
		for(var/bounty_type in faction.bounty_items)
			var/obj/temp = new bounty_type()
			var/bounty_name = temp.name
			var/multiplier = faction.bounty_items[bounty_type]
			var/base_value = SSmerchant.get_item_base_value(bounty_type)
			var/total_value = round(base_value * multiplier)
			var/expiration_time = faction.bounty_refresh_times[bounty_type]
			var/time_remaining = expiration_time - world.time
			qdel(temp)
			html += "<li class='bounty-item'>[bounty_name] ([multiplier]x - [total_value] mammon) - <small>[time_to_text(time_remaining)]</small></li>"
	else
		html += "<li>No active bounties</li>"
	html += {"
						</ul>
						<p style="font-size: 0.8em; color: [faction.faction_color]; margin-top: 10px;">
							<strong>Next bounty check:</strong><br>
							[time_to_text(earliest_bounty_expiration)]
						</p>
					</div>
					<div>
						<h3 style="color: [faction.faction_color]; margin: 0 0 10px 0;">Supply Status:</h3>
						<p><strong>[length(faction.faction_supply_packs)]</strong> items in stock</p>
						<p>Next rotation: <strong>[time_to_text(faction.next_supply_rotation - world.time)]</strong></p>
						<h3 style="color: [faction.faction_color]; margin: 15px 0 10px 0;">Next Boat Traders:</h3>
	"}
	// Display trader information
	if(faction.next_boat_trader_count > 0)
		html += "<p><strong>[faction.next_boat_trader_count]</strong> traders scheduled</p>"
		html += "<ul class='bounty-list' style='font-size: 0.9em;'>"
		for(var/datum/trader_data/trader in faction.next_boat_traders)
			var/trader_type_name = trader.name || "Unknown Trader"
			html += "<li class='bounty-item'>[trader_type_name]</li>"
		html += "</ul>"
	else
		html += "<p><em>No traders scheduled</em></p>"
	html += {"
					</div>
				</div>
			</div>
		</div>
	"}
	return html

// Helper proc for color conversion
/proc/hex_to_rgb(hex_color)
	// Convert hex color to RGB values for transparency
	var/r = hex2num(copytext(hex_color, 2, 4))
	var/g = hex2num(copytext(hex_color, 4, 6))
	var/b = hex2num(copytext(hex_color, 6, 8))
	return "[r], [g], [b]"

/proc/time_to_text(time_difference)
	if(time_difference <= 0)
		return "Now"

	var/minutes = round(time_difference / (1 MINUTES))
	if(minutes < 60)
		return "[minutes] min"

	var/hours = round(minutes / 60)
	return "[hours]h [minutes % 60]m"

/obj/item/book/secret/ledger/Topic(href, href_list)
	..()

	if(!current_reader)
		return

	if(!istype(current_reader) || current_reader.stat || !in_range(src, current_reader))
		return

	if(href_list["action"])
		switch(href_list["action"])
			if("toggle_reputation_purchase")
				allow_reputation_purchase = !allow_reputation_purchase

			if("add_to_cart_reputation")
				var/datum/supply_pack/pack = locate(href_list["item"])
				if(!pack)
					return

				var/datum/world_faction/faction = SSmerchant.active_faction
				if(!faction)
					to_chat(usr, "<span class='warning'>No active faction found!</span>")
					return

				var/reputation_cost = pack.calculate_reputation_cost()

				// Check if they have enough reputation
				if(faction.faction_reputation < reputation_cost)
					to_chat(usr, "<span class='warning'>You need [reputation_cost] reputation to purchase this item out of stock! Current: [faction.faction_reputation]</span>")
					return

				var/quantity = text2num(href_list["quantity"]) || 1

				// Add to both regular cart and reputation cart tracking
				cart[pack] = (cart[pack] || 0) + quantity
				reputation_cart[pack] = TRUE

			if("toggle_stock_filter")
				show_in_stock = !show_in_stock
			if("set_category")
				current_category = url_decode(href_list["category"])
				search_query = "" // Reset search when changing category

			if("remember_query")
				search_query = url_decode(href_list["query"])

			if("add_to_cart")
				var/datum/supply_pack/item = locate(href_list["item"])
				var/quantity = text2num(href_list["quantity"])
				if(!item)
					return

				// Check if item is available
				var/datum/world_faction/current_faction = SSmerchant.active_faction
				var/is_available = current_faction.has_supply_pack(item.type)

				if(!is_available)
					if(!allow_reputation_purchase)
						return

				if(item && quantity > 0)
					if(cart[item])
						cart[item] += quantity
					else
						cart[item] = quantity

			if("update_cart")
				var/datum/supply_pack/item = locate(href_list["item"])
				var/quantity = text2num(href_list["quantity"])

				if(item && quantity > 0)
					cart[item] = quantity
				else if(quantity <= 0)
					cart.Remove(item)

			if("remove_from_cart")
				var/datum/supply_pack/item = locate(href_list["item"])
				if(item && cart[item])
					cart.Remove(item)

			if("checkout")
				create_order_scroll()
				return

	current_reader << browse(generate_html(current_reader), "window=ledger;size=900x810")

/obj/item/book/secret/ledger/proc/create_order_scroll()
	if(!length(cart))
		to_chat(usr, "<span class='warning'>Your cart is empty!</span>")
		return

	var/datum/world_faction/faction = SSmerchant.active_faction
	if(!faction)
		to_chat(usr, "<span class='warning'>No active faction found!</span>")
		return

	// Calculate total reputation cost and check if player has enough
	var/total_reputation_cost = 0
	for(var/datum/supply_pack/pack in cart)
		if(pack in reputation_cart)
			var/reputation_cost = pack.calculate_reputation_cost()
			var/quantity = cart[pack]
			total_reputation_cost += reputation_cost * quantity

	if(total_reputation_cost > 0 && faction.faction_reputation < total_reputation_cost)
		to_chat(usr, "<span class='warning'>Insufficient reputation! Need [total_reputation_cost], have [faction.faction_reputation].</span>")
		return

	var/obj/item/paper/scroll/cargo/order = new(get_turf(usr))
	order.orders = cart.Copy()
	order.reputation_orders = reputation_cart.Copy()
	order.name = "order scroll ([length(cart)] items)"

	// Calculate and display costs
	var/total_mammon_cost = 0
	for(var/datum/supply_pack/pack in cart)
		var/quantity = cart[pack]
		var/cost_multiplier = (pack in reputation_cart) ? 2 : 1
		total_mammon_cost += pack.cost * quantity * cost_multiplier

	to_chat(usr, "<span class='notice'>Order scroll created! Cost: [total_mammon_cost] mammons[total_reputation_cost > 0 ? " + [total_reputation_cost] reputation" : ""]</span>")

	if(total_reputation_cost > 0)
		to_chat(usr, "<span class='boldwarning'>This order includes out-of-stock items that will cost [total_reputation_cost] reputation points when processed!</span>")

	order.rebuild_info()

	// Clear the carts
	cart.Cut()
	reputation_cart.Cut()

	current_reader.put_in_hands(order)

	to_chat(current_reader, "<span class='notice'>Your order has been written on a scroll.</span>")
	current_reader << browse(generate_html(current_reader), "window=ledger;size=800x810")

/obj/item/book/secret/ledger/fence
	name = "Smuggler's Manifest"
	title = " Smuggler's Manifest"
	fence = TRUE

/obj/item/book/bibble
	name = "The Book"
	icon_state = "bibble_0"
	base_icon_state = "bibble"
	title = "bible"
	dat = "gott.json"
	force = 2
	force_wielded = 4
	throwforce = 1
	possible_item_intents = list(/datum/intent/use, /datum/intent/mace/strike/wood)
	var/verses_file = "strings/bibble.txt"

/obj/item/book/bibble/read(mob/user)
	if(!open)
		to_chat(user, span_info("Open me first."))
		return FALSE
	if(!user.client || !user.hud_used)
		return
	if(!user.hud_used.reads)
		return
	if(!user.can_read(src))
		user.adjust_experience(/datum/skill/misc/reading, 4, FALSE)
		return
	if(in_range(user, src) || isobserver(user))
		user.changeNext_move(CLICK_CD_MELEE)
		var/m
		var/list/verses = world.file2list(verses_file)
		m = pick(verses)
		if(m)
			user.say(m)

/obj/item/book/bibble/attack(mob/living/M, mob/user, list/modifiers)
	if(is_priest_job(user.mind?.assigned_role))
		if(!user.can_read(src))
			return
		M.apply_status_effect(/datum/status_effect/buff/blessed)
		user.visible_message(span_notice("[user] blesses [M]."))
		playsound(user, 'sound/magic/bless.ogg', 100, FALSE)
		return

/datum/status_effect/buff/blessed
	id = "blessed"
	alert_type = /atom/movable/screen/alert/status_effect/buff/blessed
	effectedstats = list(STATKEY_LCK = 1)
	duration = 20 MINUTES

/atom/movable/screen/alert/status_effect/buff/blessed
	name = "Blessed"
	desc = ""
	icon_state = "buff"

/datum/status_effect/buff/blessed/on_apply()
	. = ..()
	if(iscarbon(owner))
		var/mob/living/carbon/C = owner
		C.add_stress(/datum/stress_event/blessed)

/datum/status_effect/buff/blessed/on_remove()
	. = ..()
	if(iscarbon(owner))
		var/mob/living/carbon/C = owner
		C.remove_stress(/datum/stress_event/blessed)

/obj/item/book/law
	name = "Tome of Justice"
	desc = ""
	icon_state ="lawtome_0"
	base_icon_state = "lawtome"
	bookfile = "law.json"

/obj/item/book/knowledge1
	name = "Book of Knowledge"
	desc = ""
	icon_state ="book5_0"
	base_icon_state = "book5"
	bookfile = "knowledge.json"

/obj/item/book/secret/xylix
	name = "Book of Gold"
	desc = "{<font color='red'><blink>An ominous book with untold powers.</blink></font>}"
	icon_state ="xylix_0"
	base_icon_state = "xylix"
	icon_state ="spellbookmimic_0"
	base_icon_state = "pellbookmimic"
	bookfile = "xylix.json"

/obj/item/book/xylix/attack_self(mob/user, list/modifiers)
	user.update_inv_hands()
	to_chat(user, "<span class='notice'>You feel laughter echo in your head.</span>")

//player made books
/obj/item/book/tales1
	name = "Assorted Tales From Yester Yils"
	desc = "By Alamere J Wevensworth"
	icon_state ="book_0"
	base_icon_state = "book"
	bookfile = "tales1.json"

/obj/item/book/festus
	name = "Book of Festus"
	desc = "Unknown Author"
	icon_state ="book2_0"
	base_icon_state = "book2"
	bookfile = "tales2.json"

/obj/item/book/tales3
	name = "Myths & Legends of Rockhill & Beyond Volume I"
	desc = "Arbalius The Younger"
	icon_state ="book3_0"
	base_icon_state = "book3"
	bookfile = "tales3.json"

/obj/item/book/bookofpriests
	name = "Holy Book of Saphria"
	desc = ""
	icon_state ="knowledge_0"
	base_icon_state = "knowledge"
	bookfile = "holyguide.json"

/obj/item/book/robber
	name = "Reading for Robbers"
	desc = "By Flavius of Dendor"
	icon_state ="basic_book_0"
	base_icon_state = "basic_book"
	bookfile = "tales4.json"

/obj/item/book/cardgame
	name = "Graystone's Torment Basic Rules"
	desc = "By Johnus of Doe"
	icon_state ="basic_book_0"
	base_icon_state = "basic_book"
	bookfile = "tales5.json"

/obj/item/book/blackmountain
	name = "Zabrekalrek, The Black Mountain Saga: Part One"
	desc = "Written by Gorrek Tale-Writer, translated by Hargrid Men-Speaker."
	icon_state ="book6_0"
	base_icon_state = "book6"
	bookfile = "tales6.json"

/obj/item/book/beardling
	name = "Rock and Stone - ABC & Tales for Beardlings"
	desc = "Distributed by the Dwarven Federation"
	icon_state ="book8_0"
	base_icon_state = "book8"
	bookfile = "tales7.json"

/obj/item/book/abyssor
	name = "A Tale of Those Who Live At Sea"
	desc = "By Bellum Aegir"
	icon_state ="book2_0"
	base_icon_state = "book2"
	bookfile = "tales8.json"

/obj/item/book/necra
	name = "Burial Rites for Necra"
	desc = "By Hunlaf, Gravedigger. Revised by Lenore, Priest of Necra."
	icon_state ="book6_0"
	base_icon_state = "book6"
	bookfile = "tales9.json"

/obj/item/book/noc
	name = "Dreamseeker"
	desc = "By Hunlaf, Gravedigger. Revised by Lenore, Priest of Necra."
	icon_state ="book6_0"
	base_icon_state = "book6"
	bookfile = "tales10.json"

/obj/item/book/fishing
	name = "Fontaine's Advanced Guide to Fishery"
	desc = "By Ford Fontaine"
	icon_state ="book2_0"
	base_icon_state = "book2"
	bookfile = "tales11.json"

/obj/item/book/sword
	name = "The Six Follies: How To Survive by the Sword"
	desc = "By Theodore Spillguts"
	icon_state ="book5_0"
	base_icon_state = "book5"
	bookfile = "tales12.json"

/obj/item/book/arcyne
	name = "Latent Magicks, where does Arcyne Power come from?"
	desc = "By Kildren Birchwood, scholar of Magicks"
	icon_state ="book4_0"
	base_icon_state = "book4"
	bookfile = "tales13.json"

/obj/item/book/nitebeast
	name = "Legend of the Nitebeast"
	desc = "By Paquetto the Scholar"
	icon_state ="book8_0"
	base_icon_state = "book8"
	bookfile = "tales14.json"

/obj/item/book/mysticalfog
	name = "Studie of the Etheral Foge phenomenon"
	desc = "By Roubert the Elder"
	icon_state ="book7_0"
	base_icon_state = "book8"
	bookfile = "tales15.json"

/obj/item/book/playerbook
	var/player_book_text = "moisture in the air or water leaks have rendered the carefully written caligraphy of this book unreadable"
	var/player_book_title = "unknown title"
	var/player_book_author = "unknown author"
	var/player_book_icon = "basic_book"
	var/player_book_author_ckey = "unknown"
	var/is_in_round_player_generated
	var/list/player_book_titles
	var/list/player_book_content
	var/list/book_icons = list(
	"Sickly green with embossed bronze" = "book8",
	"White with embossed obsidian" = "book7",
	"Black with embossed quartz" = "book6",
	"Blue with embossed ruby" = "book5",
	"Green with embossed amethyst" = "book4",
	"Purple with embossed emerald" = "book3",
	"Red with embossed sapphire" = "book2",
	"Brown with embossed gold" = "book1",
	"Brown without embossed material" = "basic_book")
	name = "unknown title"
	desc = "by an unknown author"
	icon_state = "basic_book_0"
	base_icon_state = "basic_book"
	override_find_book = TRUE

/obj/item/book/playerbook/proc/get_player_input(mob/living/in_round_player_mob, text)
	player_book_author_ckey = in_round_player_mob.ckey
	player_book_title = dd_limittext(capitalize(SANITIZE_HEAR_MESSAGE(input(in_round_player_mob, "What title do you want to give the book? (max 42 characters)", "Title", "Unknown"))), MAX_NAME_LEN)
	player_book_author = "[dd_limittext(SANITIZE_HEAR_MESSAGE(input(in_round_player_mob, "Do you want to preface your author name with an author title? (max 42 characters)", "Author Title", "")), MAX_NAME_LEN)] [in_round_player_mob.real_name]"
	player_book_icon = book_icons[input(in_round_player_mob, "Choose a book style", "Book Style") as anything in book_icons]
	player_book_text = text
	message_admins("[player_book_author_ckey]([in_round_player_mob.real_name]) has generated the player book: [player_book_title]")
	update_book_data()

/obj/item/book/playerbook/proc/update_book_data()
	name = "[player_book_title]"
	desc = "By [player_book_author]"
	icon_state = "[player_book_icon]_0"
	base_icon_state = "[player_book_icon]"
	pages = list("<b3><h3>Title: [player_book_title]<br>Author: [player_book_author]</b><h3>[player_book_text]")

/obj/item/book/playerbook/Initialize(mapload, in_round_player_generated, mob/living/in_round_player_mob, text, title)
	. = ..()
	is_in_round_player_generated = in_round_player_generated
	if(is_in_round_player_generated)
		INVOKE_ASYNC(src, PROC_REF(update_book_data), in_round_player_mob, text)
	else
		player_book_titles = SSlibrarian.pull_player_book_titles()
		if(title)
			player_book_content = SSlibrarian.file2playerbook(title)
		else
			player_book_content = SSlibrarian.file2playerbook(pick(player_book_titles))
		player_book_title = player_book_content["book_title"]
		player_book_author = player_book_content["author"]
		player_book_author_ckey = player_book_content["author_ckey"]
		player_book_icon = player_book_content["icon"]
		player_book_text = player_book_content["text"]
		update_book_data()

/obj/item/manuscript
	name = "manuscript"
	desc = "A written piece with aspirations of becoming a book."
	icon = 'icons/roguetown/items/misc.dmi'
	icon_state = "manuscript"
	dir = 2 //! dir is used to decide how many pages are displayed in the icon
	resistance_flags = FLAMMABLE
	var/number_of_pages = 2
	var/compiled_pages = null
	var/list/obj/item/paper/pages = new/list(2) //very intentional constructor

	var/author = "anonymous"
	var/content = ""
	var/category = "Unspecified"
	var/ckey = ""
	var/newicon = "basic_book_0"
	var/written = FALSE
	var/select_icon = "basic_book"
	var/list/book_icons = list(
		"Simple green" = "basic_book",
		"Simple black" = "book",
		"Simple red" = "book2",
		"Simple blue" = "book3",
		"Simple dark yellow" = "book4",
		"Brown with dark corners" = "book5",
		"Heavy purple with dark corners" = "book6",
		"Light purple with gold leaf" = "book7",
		"Light blue with gold leaf" = "book8",
		"Grey with gold leaf" = "knowledge")

/obj/item/manuscript/Initialize(mapload, list/obj/item/paper/preset_pages)
	. = ..()

	if(mapload || !preset_pages)
		for(var/i in 1 to length(pages))
			pages[i] = new /obj/item/paper(src)
	else
		for(var/i in 1 to length(preset_pages))
			pages[i] = preset_pages[i]
			preset_pages[i].forceMove(src) //lol

	update_pages()

/// Called when our pages have been updated.
/obj/item/manuscript/proc/update_pages()
	number_of_pages = length(pages)
	desc = "A [number_of_pages]-page written piece, with aspirations of becoming a book."
	update_appearance(UPDATE_ICON_STATE)

	compiled_pages = null
	for(var/obj/item/paper/page as anything in pages)
		compiled_pages += "<p>[page.info]</p>\n"

/obj/item/manuscript/attackby(obj/item/I, mob/living/user, list/modifiers)
	// why is a book crafting kit using the craft system, but crafting a book isn't?
	// Well, *for some reason*, the crafting system is made in such a way
	// as to make reworking it to allow you to put reqs vars in the crafted item near *impossible.*
	if(istype(I, /obj/item/book_crafting_kit))
		var/obj/item/book/playerbook/PB = new /obj/item/book/playerbook(get_turf(I.loc), TRUE, user, compiled_pages)
		qdel(I)
		if(user.Adjacent(PB))
			PB.add_fingerprint(user)
			user.put_in_hands(PB)
		return qdel(src)

	if((I.type == /obj/item/paper) || (I.type == /obj/item/paper/scroll))
		var/obj/item/paper/inserted_paper = I
		if(length(pages) == 8)
			to_chat(user, span_warning("I can not find a place to put [inserted_paper] into [src]..."))
			return

		inserted_paper.forceMove(src)
		pages += inserted_paper
		to_chat(user, span_notice("I put [inserted_paper] into [src]."))
		update_pages()
		updateUsrDialog()

	return ..()

/obj/item/manuscript/examine(mob/user)
	. = ..()
	. += span_info("<a href='byond://?src=[REF(src)];read=1'>Read</a>")

/obj/item/manuscript/Topic(href, href_list)
	..()

	if(!usr)
		return

	if(href_list["close"])
		var/mob/user = usr
		if(user?.client && user.hud_used)
			if(user.hud_used.reads)
				user.hud_used.reads.destroy_read()
			user << browse(null, "window=reading")

	if(!usr.can_perform_action(src, NEED_LITERACY|FORBID_TELEKINESIS_REACH))
		return

	if(href_list["read"])
		read(usr)

/obj/item/manuscript/attack_self(mob/user, list/modifiers)
	read(user)

/obj/item/manuscript/proc/read(mob/user)
	user << browse_rsc('html/book.png')
	if(!user.client || !user.hud_used)
		return
	if(!user.hud_used.reads)
		return
	if(!user.can_read(src))
		to_chat(user, span_warning("I study [src], but this verba still eludes me..."))
		user.adjust_experience(/datum/skill/misc/reading, 4, FALSE) //?
		return
	if(!in_range(user, src) && !isobserver(user))
		to_chat(user, span_warning("I am too far away to read [src]."))
		return

	var/dat = {"
	<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
	<html>
		<head>
			<style type="text/css">
				body {
					background-image:url('book.png');
					background-repeat: repeat;
				}
			</style>
		</head>
		<body scroll=yes>
			[compiled_pages]
		</body>
	</html>
	"}
	dat += "<a href='byond://?src=[REF(src)];close=1' style='position:absolute;right:50px'>Close</a>"
	user << browse(dat, "window=reading;size=1000x700;can_close=1;can_minimize=0;can_maximize=0;can_resize=0;")
	onclose(user, "reading", src)


/obj/item/manuscript/attackby_secondary(obj/item/I, mob/user, list/modifiers)
	. = ..()
	if(. == SECONDARY_ATTACK_CANCEL_ATTACK_CHAIN)
		return

	if(istype(I, /obj/item/natural/feather))
		if(written)
			to_chat(user, "<span class='notice'>The manuscript has already been authored and titled.</span>")
			return SECONDARY_ATTACK_CANCEL_ATTACK_CHAIN
		// Prompt user to populate manuscript fields
		var/newtitle = dd_limittext(SANITIZE_HEAR_MESSAGE(input(user, "Enter the title of the manuscript:") as text|null), MAX_CHARTER_LEN)
		var/newauthor = dd_limittext(SANITIZE_HEAR_MESSAGE(input(user, "Enter the author's name:") as text|null), MAX_CHARTER_LEN)
		var/newcategory = input(user, "Select the category of the manuscript:") in list("Apocrypha & Grimoires", "Myths & Tales", "Legends & Accounts", "Thesis", "Eoratica")
		var/newicon = book_icons[input(user, "Choose a book style", "Book Style") as anything in book_icons]

		if(newtitle && newauthor && newcategory)
			name = newtitle
			author = newauthor
			category = newcategory
			ckey = user.ckey
			select_icon = newicon
			icon_state = "paperwrite"
			to_chat(user, "<span class='notice'>You have successfully authored and titled the manuscript.</span>")
			var/complete = browser_alert(user, "Is the manuscript finished?", "WORDS OF NOC", DEFAULT_INPUT_CHOICES)
			SEND_SIGNAL(user, COMSIG_BOOK_WRITTEN)
			if(complete == CHOICE_YES && compiled_pages)
				written = TRUE
		else
			to_chat(user, "<span class='notice'>You must fill out all fields to complete the manuscript.</span>")

		return SECONDARY_ATTACK_CANCEL_ATTACK_CHAIN

/obj/item/manuscript/update_icon_state()
	. = ..()
	switch(length(pages))
		if(2)
			dir = SOUTH
		if(3)
			dir = NORTH
		if(4)
			dir = EAST
		if(5)
			dir = WEST
		if(6)
			dir = SOUTHEAST
		if(7)
			dir = SOUTHWEST
		else
			dir = NORTHWEST

/obj/item/manuscript/fire_act(added, maxstacks)
	..()
	if(!(resistance_flags & FIRE_PROOF))
		add_overlay("paper_onfire_overlay")

/obj/item/manuscript/attack_hand(mob/living/user)
	if(isliving(user) && user.is_holding(src))
		var/obj/item/paper/pulled_page = pop(pages)
		user.put_in_inactive_hand(src) //move this to the side
		user.put_in_active_hand(pulled_page)

		if(number_of_pages > 2)
			to_chat(user, span_notice("I pull out \a [pulled_page] from [src]."))
			update_pages()
		else
			to_chat(user, span_notice("I pull apart the final entries of [src]."))
			var/obj/item/paper/last_page = pop(pages)
			user.temporarilyRemoveItemFromInventory(src, TRUE)
			user.put_in_hands(last_page)
			qdel(src)
			return

		return

	. = ..()

/obj/item/book_crafting_kit
	name = "book crafting kit"
	desc = "Apply on a written manuscript to create a book"
	icon = 'icons/roguetown/items/misc.dmi'
	icon_state = "book_crafting_kit"




// ...... Books made by the Stonekeep community within #lore channel, approved & pushed by Guayo (current staff incharge of adding ingame books)

/* ______Example of layout of added in book

/obj/item/book/book_name_here
	name = "Title of your book here"
	desc = "Who wrote it or maybe some flavor here"
	bookfile = "filenamehere.json"
	random_cover = TRUE

____________End of Example*/

/obj/item/book/magicaltheory
	name = "Arcyne Foundations - A historie of the Arcyne"
	desc = "Written by the rector of the Valerian College of Magick"
	icon_state ="knowledge_0"
	base_icon_state = "knowledge"
	bookfile = "MagicalTheory.json"

/obj/item/book/vownecrapage
	name = "Necra's Vow of Silence"
	desc = "A faded page, with seemingly no author."
	icon_state = "book8_0"
	base_icon_state = "book8"
	bookfile = "VowOfNecraPage.json"

/obj/item/book/godofdreamsandnightmares
	name = "God of Dreams & Nightmares"
	desc = "An old decrepit book, with seemingly no author."
	bookfile = "GodDreams.json"
	random_cover = TRUE

/obj/item/book/psybibleplayerbook
	name = "Psybible"
	desc = "An old tome, authored by Father Ambrose of Grenzelhoft."
	bookfile = "PsyBible.json"
	random_cover = TRUE

/obj/item/book/manners
	name = "Manners of Gentlemen"
	desc = "A popular guide for young people of genteel birth."
	icon_state ="basic_book_0"
	base_icon_state = "basic_book"
	bookfile = "manners.json"

/obj/item/book/advice_soup
	name = "Soup de Rattus"
	desc = "Weathered book containing advice on surviving a famine."
	bookfile = "AdviceSoup.json"
	random_cover = TRUE

/obj/item/book/advice_farming
	name = "The Secrets of the Agronome"
	desc = "Soilson bible."
	bookfile = "AdviceFarming.json"
	random_cover = TRUE

/obj/item/book/advice_weaving
	name = "A hundred kinds of stitches"
	desc = "Howe to weave, tailor, and sundry tailoring. By Agnea Corazzani."
	icon_state ="book8_0"
	base_icon_state = "book8"
	bookfile = "AdviceWeaving.json"

/obj/item/book/yeoldecookingmanual // new book with some tips to learn
	name = "Ye olde ways of cookinge"
	desc = "Penned by Svend Fatbeard, butler in the fourth generation"
	icon_state ="book8_0"
	base_icon_state = "book8"
	bookfile = "Neu_cooking.json"

/obj/item/book/bibble/psy
	name = "The PSY Book"
	icon_state = "bibble_0" // change when sprites avaliable
	base_icon_state = "bibble"
	title = "psydon bible"
	dat = "gott.json"
	verses_file = "strings/psybibble.txt"

/obj/item/book/bibble/psy/attack(mob/living/M, mob/living/user, list/modifiers)
	if(istype(user) && istype(user.patron, /datum/patron/psydon))
		if(!user.can_read(src))
			return
		M.apply_status_effect(/datum/status_effect/buff/blessed)
		user.visible_message(span_notice("[user] blesses [M]."))
		playsound(user, 'sound/magic/bless.ogg', 100, FALSE)
		return

/datum/status_effect/buff/blessed
	id = "blessed"
	alert_type = /atom/movable/screen/alert/status_effect/buff/blessed
	effectedstats = list(STATKEY_LCK = 1)
	duration = 20 MINUTES

/atom/movable/screen/alert/status_effect/buff/blessed
	name = "Blessed"
	desc = "Divine power flows through me."
	icon_state = "buff"

/datum/status_effect/buff/blessed/on_apply()
	. = ..()
	if(iscarbon(owner))
		var/mob/living/carbon/C = owner
		C.add_stress(/datum/stress_event/blessed)

/datum/status_effect/buff/blessed/on_remove()
	. = ..()
	if(iscarbon(owner))
		var/mob/living/carbon/C = owner
		C.remove_stress(/datum/stress_event/blessed)

/obj/item/book/rogue/howtogaffer
	name = "Dont be a gaff, the guild masters manual"
	desc = "The author page has rotted off with time."
	bookfile = "Gaff.json"
	random_cover = TRUE
