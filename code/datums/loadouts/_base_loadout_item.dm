GLOBAL_LIST_INIT(loadout_items, init_loadout_items())

/proc/init_loadout_items()
	. = list()
	for(var/datum/loadout_item/item as anything in subtypesof(/datum/loadout_item))
		if(IS_ABSTRACT(item))
			continue
		.[item] = new item()
	return .

/datum/loadout_item
	abstract_type = /datum/loadout_item
	/// Visible name for selection
	var/name = "Parent loadout datum"
	/// Visible description for item
	var/description
	/// Path to the item to spawn
	var/item_path
	/// Typepath of a /datum/award that must be unlocked to use this loadout item. Null = no requirement.
	var/required_award = null
	/// Triumphs spent to permanently own this item. Saved to owned_loadout_items.
	var/triumph_cost_permanent = 0
	/// DMI file for the shop sprite, auto-derived from item_path in New()
	var/ui_icon = null
	/// Icon state within the DMI, auto-derived from item_path in New()
	var/ui_icon_state = null
	/// Category tab shown in the shop
	var/ui_category = "Miscellaneous"
	/// Bitfield of LOADOUT_FLAG_* defines controlling rental, equip, and access restrictions.
	var/loadout_flags = LOADOUT_FLAG_NONE

/datum/loadout_item/New()
	. = ..()
	if(item_path && isnull(ui_icon))
		ui_icon = initial(item_path:icon)
		ui_icon_state = initial(item_path:icon_state)

/datum/loadout_item/proc/is_permanently_owned_by(client/C)
	return ("[type]" in C.prefs.owned_loadout_items)

/datum/loadout_item/proc/can_afford_single(client/C)
	if(loadout_flags & LOADOUT_FLAG_GIVEAWAY_ONLY)
		return FALSE
	if(triumph_cost_permanent)
		return TRUE
	return get_triumph_amount(C.ckey) >= CEILING(triumph_cost_permanent * 0.05, 1)

/datum/loadout_item/proc/can_afford_permanent(client/C)
	if(loadout_flags & LOADOUT_FLAG_GIVEAWAY_ONLY)
		return FALSE
	if(!triumph_cost_permanent)
		return TRUE
	return get_triumph_amount(C.ckey) >= triumph_cost_permanent

/// Returns TRUE if the given client has satisfied this loadout item's award requirement.
/datum/loadout_item/proc/is_unlocked_for(client/C)
	if(required_award)
		if(!length(SSachievements.awards))
			SSachievements.setup()
		var/datum/award/A = SSachievements.awards[required_award]
		if(!A)
			return FALSE
		if(istype(A, /datum/award/achievement/progress))
			var/datum/award/achievement/progress/PA = A
			if(C.player_details.achievements.get_achievement_status(required_award) < PA.required_progress)
				return FALSE
		else if(istype(A, /datum/award/achievement))
			if(C.player_details.achievements.get_achievement_status(required_award) != TRUE)
				return FALSE
		else if(istype(A, /datum/award/score))
			if(C.player_details.achievements.get_achievement_status(required_award) <= 0)
				return FALSE
	if(loadout_flags & LOADOUT_FLAG_PATREON_LOCKED)
		if(!C?.patreon?.is_donator())
			return FALSE
	return TRUE

/// Returns TRUE if this item is currently owned by the client and all runtime access checks pass.
/// Use this as the authoritative check in other systems (species checks, perk grants, etc).
/datum/loadout_item/proc/is_owned_and_accessible(client/C)
    if(!C?.prefs)
        return FALSE
    if(!("[type]" in C.prefs.owned_loadout_items))
        return FALSE
    // Patreon can lapse after purchase; re-validate at runtime.
    if(loadout_flags & LOADOUT_FLAG_PATREON_LOCKED)
        if(!C?.patreon?.is_donator())
            return FALSE
    return TRUE

/proc/owns_loadout_item(client/client, datum/loadout_item/loadout_item)
	var/datum/loadout_item/singleton = GLOB.loadout_items[loadout_item]
	return singleton.is_owned_and_accessible(client)
