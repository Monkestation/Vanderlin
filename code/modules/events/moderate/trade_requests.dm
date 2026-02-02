/datum/trade_request
	var/input_name
	var/atom/input_atom
	var/input_amount = 1

	var/output_name
	var/atom/output_atom
	var/output_amount = 1

	var/total_trade = 1
	var/start_total_trade = 1

/datum/trade_request/New()
	. = ..()
	generate_trade_request()

/datum/trade_request/proc/generate_trade_request()
	var/datum/supply_pack/pack = pick(SSmerchant.supply_packs)


	var/list/packs = SSmerchant.supply_packs.Copy()

	for(var/datum/supply_pack/listed in packs)
		if(listed.cost > pack.cost * 1.5)
			packs -= listed

	if(islist(pack.contains))
		input_atom = pick(pack.contains)
	else
		input_atom = pack.contains

	input_name = pack.name
	input_amount = rand(1, 4)

	var/datum/supply_pack/output = pick(packs)

	if(islist(output.contains))
		output_atom = pick(output.contains)
	else
		output_atom = output.contains

	output_name = output.name
	output_amount = rand(1, 4)

	total_trade = rand(5, 10)
	start_total_trade = total_trade


/obj/item/paper/scroll/trade_requests
	name = "trade requests"
	icon_state = "contractsigned"
	var/list/requests
	var/writers_name

/obj/item/paper/scroll/trade_requests/Initialize()
	. = ..()
	writers_name = pick(world.file2list("strings/rt/names/human/humnorm.txt"))
	rebuild_info()

/obj/item/paper/scroll/trade_requests/update_icon_state()
	. = ..()
	if(open)
		icon_state = "contractsigned"
	else
		icon_state = "scroll_closed"

/obj/item/paper/scroll/trade_requests/update_name()
	. = ..()
	if(open)
		name = initial(name)
	else
		name = "scroll"

/obj/item/paper/scroll/trade_requests/proc/rebuild_info()
	info = null
	info += "<div style='vertical-align:top'>"
	info += "<h2 style='color:#06080F;font-family:\"Segoe Script\"'>Trade Request</h2>"
	info += "<hr/>"

	if(!requests)
		return
	if(length(requests))
		info += "<ul>"
		for(var/datum/trade_request/request in requests)
			info += "<li style='color:#06080F;font-size:11px;font-family:\"Segoe Script\"'>[request.input_name]x[request.input_amount] for [request.output_name]x[request.output_amount]</li><br/>"
			info += "<li style='color:#06080F;font-size:11px;font-family:\"Segoe Script\"'>Limit of [request.start_total_trade] Trades.</li><br/>"
			info += "<br>"
		info += "</ul>"

	info += "<br/></font>"

	info += "<font size=\"2\" face=\"[FOUNTAIN_PEN_FONT]\" color=#27293f>[writers_name] Shipwright of [pick("Heartfelt", "Zalad", "Grenzelhoft", "Kingsfield")]</font>"

	info += "</div>"

/datum/round_event_control/trade_request
	name = "Trade Request"
	track = EVENT_TRACK_MODERATE
	typepath = /datum/round_event/trade_request
	weight = 7
	max_occurrences = 12
	min_players = 0
	earliest_start = 5 MINUTES

	tags = list(
		TAG_TRADE,
		TAG_BOON,
		TAG_WATER,
	)

/datum/round_event/trade_request/start()
	. = ..()
	var/list/requests = list()
	for(var/i = 1 to rand(1, 3))
		var/datum/trade_request/new_request = new
		requests |= new_request

	var/obj/item/paper/scroll/trade_requests/request = new
	request.requests = requests
	SSmerchant.sending_stuff |= request
