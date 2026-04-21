/// Applied to items. Prevents mobs from equipping this item to any slot except hands
/// unless they are in the ambush or quest faction.
/datum/element/faction_restricted_equip
	element_flags = ELEMENT_BESPOKE

	/// List of factions that are allowed to equip this item freely. Defaults to ambush + quest.
	var/list/allowed_factions

/datum/element/faction_restricted_equip/Attach(datum/target, list/factions)
	. = ..()
	if(!isitem(target))
		return ELEMENT_INCOMPATIBLE

	allowed_factions = factions || list("ambush", "quest")
	RegisterSignal(target, COMSIG_ITEM_EQUIPPED, PROC_REF(on_equipped))
	RegisterSignal(target, COMSIG_ATOM_EXAMINE, PROC_REF(on_examine))

/datum/element/faction_restricted_equip/Detach(datum/target)
	. = ..()
	UnregisterSignal(target, COMSIG_ITEM_EQUIPPED)
	UnregisterSignal(target, COMSIG_ATOM_EXAMINE)

/datum/element/faction_restricted_equip/proc/on_examine(datum/source, mob/user, list/examine_text)
	examine_text += span_danger("This item has engraved runes preventing it from being worn.")

/// Checks if the mob equipping is in an allowed faction, blocks non-hand slots if not.
/datum/element/faction_restricted_equip/proc/on_equipped(obj/item/source, mob/living/user, slot)
	SIGNAL_HANDLER

	// Always allow hand slots
	if(slot == ITEM_SLOT_HANDS)
		return

	for(var/faction in allowed_factions)
		if(faction in user.faction)
			return

	user.temporarilyRemoveItemFromInventory(source)
	if(!user.put_in_hands(source))
		source.forceMove(get_turf(user))

	to_chat(user, span_warning("The enscribed runes in [source] prevent it from fitting on you."))
