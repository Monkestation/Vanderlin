/datum/component/stockpile_loot_spawner
	// Inherits from base loot_spawner
	var/max_spawns = 3
	var/spawns_per_person = 1
	var/list/takers = list()
	var/obj/item/resetting_item
	var/needs_reset = FALSE
	var/datum/loot_table/loot
	var/spawn_loot_on_break = TRUE
	var/action_time = 2 SECONDS
	var/action_text = "starts sifting through"

	// Stockpile-specific vars
	var/datum/stockpile/stockpile_ref
	var/list/resource_costs
	var/require_exact_resources = TRUE

	// Cooldown system vars
	var/cooldown_time = 5 MINUTES  // Time between allowed loots per person
	var/list/player_cooldowns = list()  // Associative list of ckey -> world.time of last loot
	var/enable_cooldown = FALSE  // Whether to use cooldown system instead of per-person limits

/datum/component/stockpile_loot_spawner/Initialize(datum/loot_table/table, max_spawns = 3, spawns_per_person = 1, spawn_loot_on_break = TRUE, action_time = 2 SECONDS, action_text = "starts sifting through", datum/stockpile/stockpile, list/costs, require_exact = TRUE, obj/item/resetting_item, cooldown_time = 5 MINUTES, enable_cooldown = FALSE)
	. = ..()
	if(!table || !stockpile)
		return COMPONENT_INCOMPATIBLE

	loot = new table
	src.max_spawns = max_spawns
	src.spawns_per_person = spawns_per_person
	src.spawn_loot_on_break = spawn_loot_on_break
	src.action_time = action_time
	src.action_text = action_text
	src.resetting_item = resetting_item
	src.stockpile_ref = stockpile
	src.resource_costs = costs || list()
	src.require_exact_resources = require_exact
	src.cooldown_time = cooldown_time
	src.enable_cooldown = enable_cooldown

/datum/component/stockpile_loot_spawner/RegisterWithParent()
	. = ..()
	RegisterSignal(parent, COMSIG_ATOM_ATTACK_HAND, PROC_REF(handle_loot_attempt))
	if(resetting_item)
		RegisterSignal(parent, COMSIG_ATOM_ATTACKBY, PROC_REF(handle_reset_attempt))

/datum/component/stockpile_loot_spawner/UnregisterFromParent()
	. = ..()
	UnregisterSignal(parent, COMSIG_ATOM_ATTACK_HAND)
	if(resetting_item)
		UnregisterSignal(parent, COMSIG_ATOM_ATTACKBY)

/datum/component/stockpile_loot_spawner/proc/handle_loot_attempt(atom/source, mob/user)
	if(!source.CanLoot(user))
		return NONE
	if(needs_reset)
		to_chat(user, span_warning("[parent] needs to be restocked before you can loot it again."))
		return NONE

	// Check cooldown or spawns per person limits
	if(enable_cooldown)
		if(!check_player_cooldown(user))
			return NONE
	else
		if(user in takers)
			if(takers[user] >= spawns_per_person)
				to_chat(user, span_warning("You've already taken your share from [parent]."))
				return NONE

	if(length(takers) >= max_spawns)
		to_chat(user, span_warning("[parent] has been completely emptied."))
		SEND_SIGNAL(parent, COMSIG_LOOT_SPAWNER_EMPTY)
		return NONE

	// Check stockpile resources
	if(!check_stockpile_resources(user))
		return NONE

	INVOKE_ASYNC(src, PROC_REF(start_loot), source, user)
	return COMPONENT_CANCEL_ATTACK_CHAIN

/datum/component/stockpile_loot_spawner/proc/check_stockpile_resources(mob/user)
	if(!stockpile_ref || !length(resource_costs))
		return TRUE

	if(require_exact_resources)
		if(!stockpile_ref.has_resources(resource_costs))
			to_chat(user, span_warning("This has been pillaged for now!"))
			return FALSE
	else
		if(!stockpile_ref.has_any_resources(resource_costs))
			to_chat(user, span_warning("The stockpile is completely empty of useful resources."))
			return FALSE

	return TRUE

/datum/component/stockpile_loot_spawner/proc/check_player_cooldown(mob/user)
	if(!user.ckey)
		return TRUE  // Allow non-player mobs to always loot

	var/user_key = user.ckey
	var/last_loot_time = player_cooldowns[user_key]

	if(!last_loot_time)
		return TRUE  // First time looting

	var/time_since_last = world.time - last_loot_time
	if(time_since_last < cooldown_time)
		var/remaining_time = cooldown_time - time_since_last
		var/remaining_minutes = round(remaining_time / (1 MINUTES), 0.1)
		to_chat(user, span_warning("You must wait [remaining_minutes] more minute\s before you can loot [parent] again."))
		return FALSE

	return TRUE

/datum/component/stockpile_loot_spawner/proc/update_player_cooldown(mob/user)
	if(!user.ckey)
		return

	player_cooldowns[user.ckey] = world.time

/datum/component/stockpile_loot_spawner/proc/get_player_cooldown_remaining(mob/user)
	if(!enable_cooldown || !user.ckey)
		return 0

	var/last_loot_time = player_cooldowns[user.ckey]
	if(!last_loot_time)
		return 0

	var/time_since_last = world.time - last_loot_time
	return max(0, cooldown_time - time_since_last)

/datum/component/stockpile_loot_spawner/proc/clear_player_cooldown(mob/user)
	if(!user.ckey)
		return FALSE

	if(user.ckey in player_cooldowns)
		player_cooldowns -= user.ckey
		return TRUE
	return FALSE

/datum/component/stockpile_loot_spawner/proc/clear_all_cooldowns()
	player_cooldowns.Cut()
	. = list()
	for(var/resource in resource_costs)
		. += "[resource_costs[resource]] [resource]"

/datum/component/stockpile_loot_spawner/proc/handle_reset_attempt(atom/source, obj/item/L, mob/living/user)
	if(!needs_reset)
		return NONE
	if(!istype(L, resetting_item))
		return NONE
	INVOKE_ASYNC(src, PROC_REF(start_reset), source, L, user)
	return COMPONENT_NO_AFTERATTACK

/datum/component/stockpile_loot_spawner/proc/start_loot(atom/source, mob/living/user)
	user.visible_message("[user] [action_text] [parent].")
	if(!do_after(user, action_time, source))
		return

	if(stockpile_ref && length(resource_costs))
		if(require_exact_resources)
			if(!stockpile_ref.has_resources(resource_costs))
				to_chat(user, span_warning("Not enough resources remaining in stockpile!"))
				return
			stockpile_ref.remove_resources(resource_costs)
		else
			var/list/available_costs = list()
			for(var/resource in resource_costs)
				if((resource in stockpile_ref.stored_materials) && stockpile_ref.stored_materials[resource] > 0)
					available_costs[resource] = min(resource_costs[resource], stockpile_ref.stored_materials[resource])
			stockpile_ref.remove_resources(available_costs)

	// Spawn the loot
	loot.spawn_loot(user, SSmapping.get_delve(user), user.return_item_rarity())

	if(resetting_item)
		needs_reset = TRUE

	// Update tracking based on system type
	if(enable_cooldown)
		update_player_cooldown(user)
	else
		takers |= user
		takers[user]++

	if(length(takers) >= max_spawns)
		SEND_SIGNAL(parent, COMSIG_LOOT_SPAWNER_EMPTY)

	SEND_SIGNAL(parent, COMSIG_PARENT_TRAP_TRIGGERED, user)

/datum/component/stockpile_loot_spawner/proc/start_reset(atom/source, obj/item/L, mob/living/user)
	if(!do_after(user, action_time, source))
		return
	needs_reset = FALSE
	to_chat(user, span_notice("You restock [parent]."))

