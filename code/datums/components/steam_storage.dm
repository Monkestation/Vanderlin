///think of this as like an extra tank of storage an atom has, so say you have a backtank, and your drill needs steam
///it can pull from the backtank

/datum/component/steam_storage
	var/current_steam = 0
	var/maximum_steam = 1000
	var/steam_decay = 0
	///if something has an id it basically prevents you from using it on things that don't have the same id, say you have a steam tank on your steam armor and its dedicated to that this prevents your drill from using it.
	var/tank_id

/datum/component/steam_storage/Initialize(steam_capacity, decay, id, charged = FALSE)
	if(!isatom(parent))
		return COMPONENT_INCOMPATIBLE
	if(!steam_capacity)
		return COMPONENT_INCOMPATIBLE

	maximum_steam = steam_capacity
	if(charged)
		current_steam = maximum_steam

	tank_id = id
	if(decay)
		steam_decay = decay
		START_PROCESSING(SSobj, src)

	RegisterSignal(parent, COMSIG_ATOM_STEAM_USE, PROC_REF(try_use_steam))
	RegisterSignal(parent, COMSIG_ITEM_EQUIPPED, PROC_REF(register_usage))
	RegisterSignal(parent, COMSIG_ATOM_STEAM_INCREASE, PROC_REF(try_increase_steam))
	RegisterSignal(parent, COMSIG_PARENT_EXAMINE, PROC_REF(on_examine))

/datum/component/steam_storage/proc/on_examine(datum/source, mob/user, list/examine_list)
	examine_list += "The steam gauge reads around [(current_steam / maximum_steam) * 100]% filled."

/datum/component/steam_storage/proc/try_use_steam(atom/source, amount_used, id)
	if((!id && tank_id) && source != parent)
		return FALSE

	if(amount_used > current_steam)
		return FALSE

	current_steam -= amount_used
	return TRUE

/datum/component/steam_storage/proc/try_proxy_use_steam(mob/proxy, atom/source, amount_used, id, emptying = FALSE, var/check_only = FALSE)
	if(tank_id && id != tank_id)
		return FALSE

	if((amount_used > current_steam) && !emptying)
		return FALSE

	if(check_only)
		return TRUE

	if(!emptying)
		current_steam -= amount_used
	else
		current_steam = 0
	return TRUE

/datum/component/steam_storage/proc/try_increase_steam(atom/source, amount_increased)
	if(current_steam >= maximum_steam)
		return FALSE

	current_steam = min(maximum_steam, current_steam + amount_increased)
	return TRUE

/datum/component/steam_storage/proc/register_usage(atom/source, mob/living/equipped)
	RegisterSignal(equipped, COMSIG_ATOM_PROXY_STEAM_USE, PROC_REF(try_proxy_use_steam), override = TRUE)
	RegisterSignal(parent, COMSIG_ITEM_DROPPED, PROC_REF(unregister_usage), override = TRUE)

/datum/component/steam_storage/proc/unregister_usage(atom/source, mob/living/dropper)
	UnregisterSignal(parent, COMSIG_ITEM_DROPPED)
	UnregisterSignal(dropper, COMSIG_ATOM_PROXY_STEAM_USE)
