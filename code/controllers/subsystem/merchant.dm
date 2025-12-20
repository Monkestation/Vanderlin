SUBSYSTEM_DEF(merchant)
	name = "Merchant Packs"
	wait = 60 SECONDS
	init_order = INIT_ORDER_DEFAULT
	runlevels = RUNLEVEL_SETUP | RUNLEVEL_GAME

	var/list/supply_packs = list()
	var/list/supply_cats = list()
	var/list/shoppinglist = list()
	var/list/requestlist = list()
	var/list/fencerequestlist = list()
	var/list/orderhistory = list()
	var/list/trade_requests = list()
	var/list/sending_stuff = list()

	var/datum/lift_master/tram/cargo_boat
	var/cargo_docked = TRUE
	var/datum/lift_master/tram/fence_boat
	var/fence_docked = TRUE

	var/list/world_factions = list()
	var/list/staticly_setup_types = list()

	// New faction management
	var/datum/world_faction/active_faction // Currently selected faction for trading
	var/list/faction_rotation_schedule = list() // When each faction becomes active
	var/list/active_faction_traders = list()

/datum/controller/subsystem/merchant/Initialize(timeofday)
	// Initialize supply packs
	for(var/pack in subtypesof(/datum/supply_pack))
		var/datum/supply_pack/P = new pack()
		if(!P.contains)
			continue
		supply_packs[P.type] = P
		if(!(P.group in supply_cats))
			supply_cats += P.group

	// Initialize factions
	initialize_factions()
	return ..()

/datum/controller/subsystem/merchant/proc/initialize_factions()

	for(var/datum/world_faction/faction as anything in subtypesof(/datum/world_faction))
		var/datum/world_faction/new_faction = new faction
		if((SSmapping.config.map_name in new_faction.allowed_maps) || !length(new_faction.allowed_maps))
			world_factions |= new_faction

	// Set initial active faction
	active_faction = world_factions[rand(1, length(world_factions))]

	// Schedule faction rotations (every 45 minutes)
	var/rotation_time = 45 MINUTES
	for(var/i = 1 to length(world_factions))
		var/datum/world_faction/faction = world_factions[i]
		faction_rotation_schedule[faction] = world.time + (rotation_time * (i - 1))

/datum/controller/subsystem/merchant/proc/rotate_active_faction()
	var/datum/world_faction/next_faction
	var/earliest_time = INFINITY

	// Find the faction scheduled to be next
	for(var/datum/world_faction/faction in faction_rotation_schedule)
		var/scheduled_time = faction_rotation_schedule[faction]
		if(scheduled_time <= world.time && scheduled_time < earliest_time)
			earliest_time = scheduled_time
			next_faction = faction

	if(next_faction && next_faction != active_faction)
		active_faction = next_faction
		faction_rotation_schedule[next_faction] = world.time + (45 MINUTES * length(world_factions))

/datum/controller/subsystem/merchant/fire(resumed)
	// Update all factions
	for(var/datum/world_faction/faction in world_factions)
		faction.handle_world_change()

	// Check for faction rotation
	rotate_active_faction()

/datum/controller/subsystem/merchant/proc/prepare_cargo_shipment()
	if(!cargo_boat || !cargo_docked)
		return
	draw_selling_changes()
	cargo_boat.show_tram()
	var/list/boat_spaces = list()
	for(var/obj/structure/industrial_lift/lift in cargo_boat.lift_platforms)
		boat_spaces |= cargo_boat.get_valid_turfs(lift)
	for(var/datum/supply_pack/requested as anything in requestlist)
		if(!requestlist[requested])
			continue
		var/turf/boat_turf = pick_n_take(boat_spaces)
		var/obj/structure/closet/crate/crate_to_use
		for(var/i in 1 to requestlist[requested])
			if(i == 1)
				crate_to_use = requested.generate(boat_turf)
			else
				requested.fill(crate_to_use)
		for(var/obj/structure/industrial_lift/lift in cargo_boat.lift_platforms)
			lift.held_cargo |= crate_to_use
	for(var/atom/movable/item as anything in sending_stuff)
		var/turf/boat_turf = pick(boat_spaces)
		if(ispath(item))
			new item(boat_turf)
		else
			item.forceMove(boat_turf)
	requestlist = list()
	spawn_faction_traders()
	cargo_docked = FALSE
	SEND_GLOBAL_SIGNAL(COMSIG_DISPATCH_CARGO, cargo_boat)

/datum/controller/subsystem/merchant/proc/send_cargo_ship_back()
	var/obj/effect/landmark/tram/queued_path/cargo_stop/cargo_stop = cargo_boat.idle_platform
	cargo_stop.UnregisterSignal(cargo_boat, COMSIG_TRAM_EMPTY)
	if(!SSticker.HasRoundStarted())
		return
	if(!cargo_stop.next_path_id)
		return
	var/obj/effect/landmark/tram/destination_platform
	for (var/obj/effect/landmark/tram/destination as anything in GLOB.tram_landmarks[cargo_stop.specific_lift_id])
		if(destination.platform_code == cargo_stop.next_path_id)
			destination_platform = destination
			break

	if (!destination_platform)
		return FALSE

	cargo_boat.tram_travel(destination_platform, rapid = FALSE)
	cargo_boat.callback_platform = destination_platform



/datum/controller/subsystem/merchant/proc/prepare_fence_shipment()
	if(!fence_boat || !fence_docked)
		return

	fence_boat.show_tram()
	var/list/boat_spaces = list()
	for(var/obj/structure/industrial_lift/lift in fence_boat.lift_platforms)
		boat_spaces |= fence_boat.get_valid_turfs(lift)

	for(var/atom/movable/request as anything in fencerequestlist)
		for(var/i = 1 to fencerequestlist[request])
			var/turf/boat_turf = pick_n_take(boat_spaces)
			var/atom/movable/new_item = new request
			new_item.forceMove(boat_turf)
			for(var/obj/structure/industrial_lift/lift in fence_boat.lift_platforms)
				lift.held_cargo |= new_item

	fencerequestlist = list()
	fence_docked = FALSE
	SEND_GLOBAL_SIGNAL(COMSIG_DISPATCH_CARGO, fence_boat)

/datum/controller/subsystem/merchant/proc/send_fence_ship_back()
	var/obj/effect/landmark/tram/queued_path/fence_stop/cargo_stop = fence_boat.idle_platform
	cargo_stop.UnregisterSignal(fence_boat, COMSIG_TRAM_EMPTY)
	if(!SSticker.HasRoundStarted())
		return
	if(!cargo_stop.next_path_id)
		return
	var/obj/effect/landmark/tram/destination_platform
	for (var/obj/effect/landmark/tram/destination as anything in GLOB.tram_landmarks[cargo_stop.specific_lift_id])
		if(destination.platform_code == cargo_stop.next_path_id)
			destination_platform = destination
			break

	if (!destination_platform)
		return FALSE

	fence_boat.tram_travel(destination_platform, rapid = FALSE)
	fence_boat.callback_platform = destination_platform

/datum/controller/subsystem/merchant/proc/adjust_sell_multiplier(obj/change_type, change = 0)
	active_faction.adjust_sell_multiplier(change_type, change)


/datum/controller/subsystem/merchant/proc/handle_selling(obj/selling_type)
	active_faction.handle_selling(selling_type)

/datum/controller/subsystem/merchant/proc/changed_sell_prices(atom/atom_type, old_price, new_price)
	active_faction.changed_sell_prices(atom_type, old_price, new_price)

/datum/controller/subsystem/merchant/proc/draw_selling_changes()
	for(var/datum/world_faction/active_faction in world_factions)
		active_faction.draw_selling_changes()

/datum/controller/subsystem/merchant/proc/return_sell_modifier(atom/sell_type)
	return active_faction.return_sell_modifier(sell_type)

/datum/controller/subsystem/merchant/proc/set_faction_sell_values(atom/sell_type)
	staticly_setup_types |= sell_type
	for(var/datum/world_faction/active_faction in world_factions)
		active_faction.setup_sell_data(sell_type)

/datum/controller/subsystem/merchant/proc/spawn_faction_traders()
	if(!cargo_docked || !length(world_factions))
		return

	var/datum/world_faction/selected_faction
	for(var/datum/world_faction/faction in world_factions)
		if(faction.trader_schedule_generated && faction.next_boat_trader_count > 0)
			selected_faction = faction
			break

	if(!selected_faction)
		return

	// Find spawn location on or near the boat
	var/list/possible_turfs = list()
	for(var/obj/structure/industrial_lift/lift in cargo_boat.lift_platforms)
		possible_turfs |= cargo_boat.get_valid_turfs(lift)
	var/atom/spawn_turf = get_turf(pick(possible_turfs))

	if(!spawn_turf)
		return

	// Create all scheduled traders
	var/list/new_traders = selected_faction.create_scheduled_traders(spawn_turf)

	for(var/mob/living/simple_animal/hostile/retaliate/trader/faction_trader/trader in new_traders)
		active_faction_traders += trader
		trader.ai_controller?.set_blackboard_key(BB_CURRENT_MIN_MOVE_DISTANCE, 0)
		trader.ai_controller.PauseAi(1 MINUTES) // Wait a minute then they get off the boat

	// Reset for next boat
	selected_faction.reset_trader_schedule()

/obj/Initialize()
	. = ..()
	if(sellprice)
		if(!(type in SSmerchant.staticly_setup_types))
			if(!istype(src, /obj/item/coin))
				SSmerchant.set_faction_sell_values(type)
