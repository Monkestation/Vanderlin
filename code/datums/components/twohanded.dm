/**
 * Two Handed Component
 *
 * When applied to an item it will make it two handed
 *
 */
/datum/component/two_handed
	/// Only one of the component can exist on an item
	dupe_mode = COMPONENT_DUPE_UNIQUE_PASSARGS
	/// Are we holding the two handed item properly
	var/wielded = FALSE
	/// The multiplier applied to force when wielded, does not work with force_wielded, and force_unwielded
	var/force_multiplier = 0
	/// The force of the item when wielded
	var/force_wielded = 0
	/// The force of the item when unwielded
	var/force_unwielded = 0
	/// Play sound when wielded
	var/wieldsound = list('sound/combat/weaponr1.ogg','sound/combat/weaponr2.ogg')
	/// Play sound when unwielded
	var/unwieldsound = FALSE
	/// Play sound on attack when wielded
	var/attacksound = FALSE
	/// Does it have to be held in both hands
	var/require_twohands = FALSE
	/// The icon that will be used when wielded
	var/icon_wielded = FALSE
	/// Do we create an offhand item when wielding? Does not affect the rest of twohanded functionality.
	var/wield_block_offhand = TRUE
	/// Reference to the offhand created for the item
	var/obj/item/offhand/offhand_item = null
	/// A callback on the parent to be called when the item is wielded
	var/datum/callback/wield_callback
	/// A callback on the parent to be called when the item is unwielded
	var/datum/callback/unwield_callback

/**

 * Two Handed component
 *
 * vars:
 * * require_twohands (optional) Does the item need both hands to be carried
 * * wieldsound (optional) The sound to play when wielded
 * * unwieldsound (optional) The sound to play when unwielded
 * * attacksound (optional) The sound to play when wielded and attacking
 * * force_multiplier (optional) The force multiplier when wielded, do not use with force_wielded, and force_unwielded
 * * force_wielded (optional) The force setting when the item is wielded, do not use with force_multiplier
 * * force_unwielded (optional) The force setting when the item is unwielded, do not use with force_multiplier
 * * icon_wielded (optional) The icon to be used when wielded
 * * wield_blocking (optional) Is the offhand blocked?
 */
/datum/component/two_handed/Initialize(require_twohands=FALSE, wieldsound=FALSE, unwieldsound=FALSE, attacksound=FALSE, \
										force_multiplier=0, force_wielded=0, force_unwielded=0, icon_wielded=FALSE, \
										datum/callback/wield_callback, datum/callback/unwield_callback, wield_block_offhand = TRUE)
	if(!isitem(parent))
		return COMPONENT_INCOMPATIBLE

	src.require_twohands = require_twohands
	src.wieldsound = wieldsound
	src.unwieldsound = unwieldsound
	src.attacksound = attacksound
	src.force_multiplier = force_multiplier
	src.force_wielded = force_wielded
	src.force_unwielded = force_unwielded
	src.icon_wielded = icon_wielded
	src.wield_callback = wield_callback
	src.unwield_callback = unwield_callback
	src.wield_block_offhand = wield_block_offhand

	if(require_twohands)
		ADD_TRAIT(parent, TRAIT_NEEDS_TWO_HANDS, ABSTRACT_ITEM_TRAIT)

/datum/component/two_handed/Destroy(force)
	offhand_item = null
	wield_callback = null
	unwield_callback = null
	return ..()

// Inherit the new values passed to the component
/datum/component/two_handed/InheritComponent(datum/component/two_handed/new_comp, original, require_twohands, wieldsound, unwieldsound, \
											force_multiplier, force_wielded, force_unwielded, icon_wielded, \
											datum/callback/wield_callback, datum/callback/unwield_callback)
	if(!original)
		return
	if(require_twohands)
		src.require_twohands = require_twohands
	if(wieldsound)
		src.wieldsound = wieldsound
	if(unwieldsound)
		src.unwieldsound = unwieldsound
	if(attacksound)
		src.attacksound = attacksound
	if(force_multiplier)
		src.force_multiplier = force_multiplier
	if(force_wielded)
		src.force_wielded = force_wielded
	if(force_unwielded)
		src.force_unwielded = force_unwielded
	if(icon_wielded)
		src.icon_wielded = icon_wielded
	if(wield_callback)
		src.wield_callback = wield_callback
	if(unwield_callback)
		src.unwield_callback = unwield_callback

// register signals withthe parent item
/datum/component/two_handed/RegisterWithParent()
	RegisterSignal(parent, COMSIG_ITEM_EQUIPPED, PROC_REF(on_equip))
	RegisterSignal(parent, COMSIG_ITEM_DROPPED, PROC_REF(on_drop))
	RegisterSignal(parent, COMSIG_ITEM_ATTACK_SELF, PROC_REF(on_attack_self))
	RegisterSignal(parent, COMSIG_ITEM_ATTACK, PROC_REF(on_attack))
	RegisterSignal(parent, COMSIG_ATOM_UPDATE_ICON, PROC_REF(on_update_icon))
	RegisterSignal(parent, COMSIG_MOVABLE_MOVED, PROC_REF(on_moved))
	RegisterSignal(parent, COMSIG_TOPIC_INSPECT, PROC_REF(on_inspect))

	var/obj/item/item = parent
	if(require_twohands)
		item.has_inspect_verb = TRUE

// Remove all siginals registered to the parent item
/datum/component/two_handed/UnregisterFromParent()
	UnregisterSignal(parent, list(COMSIG_ITEM_EQUIPPED,
								COMSIG_ITEM_DROPPED,
								COMSIG_ITEM_ATTACK_SELF,
								COMSIG_ITEM_ATTACK,
								COMSIG_ATOM_UPDATE_ICON,
								COMSIG_MOVABLE_MOVED,
								COMSIG_TOPIC_INSPECT))

	var/obj/item/item = parent
	item.has_inspect_verb = initial(item.has_inspect_verb)

/// Triggered on equip of the item containing the component
/datum/component/two_handed/proc/on_equip(datum/source, mob/user, slot)
	SIGNAL_HANDLER

	if(require_twohands && (slot & ITEM_SLOT_HANDS)) // force equip the item
		wield(user)
	if(!user.is_holding(parent) && wielded && !require_twohands)
		unwield(user, FALSE)

/// Triggered on drop of item containing the component
/datum/component/two_handed/proc/on_drop(datum/source, mob/user)
	SIGNAL_HANDLER

	if(require_twohands) //Don't let the item fall to the ground and cause bugs if it's actually being equipped on another slot.
		unwield(user, FALSE, FALSE)
	if(wielded)
		unwield(user, FALSE)
	if(source == offhand_item && !QDELETED(source))
		offhand_item = null
		qdel(source)

/// Triggered on destroy of the component's offhand
/datum/component/two_handed/proc/on_destroy(datum/source)
	SIGNAL_HANDLER

	offhand_item = null

/// Triggered on attack self of the item containing the component
/datum/component/two_handed/proc/on_attack_self(datum/source, mob/user)
	SIGNAL_HANDLER

	if(!require_twohands)
		if(wielded)
			unwield(user)
		else if(user.is_holding(parent))
			wield(user)

/**
 * Wield the two handed item in both hands
 *
 * vars:
 * * user The mob/living/carbon that is wielding the item
 */
/datum/component/two_handed/proc/wield(mob/living/carbon/user)
	if(wielded)
		return
	if(user.get_inactive_held_item())
		if(require_twohands)
			to_chat(user, span_notice("[parent] is too cumbersome to carry in one hand!"))
			user.dropItemToGround(parent, force=TRUE)
		else
			to_chat(user, span_warning("I need my other hand to be empty!"))
		return
	if(user.usable_hands < 2)
		if(require_twohands)
			user.dropItemToGround(parent, force=TRUE)
		to_chat(user, span_warning("[parent] is too bulky to carry for me!"))
		return

	// wield update status
	if(SEND_SIGNAL(parent, COMSIG_TWOHANDED_WIELD, user) & COMPONENT_TWOHANDED_BLOCK_WIELD)
		return // blocked wield from item
	wielded = TRUE
	ADD_TRAIT(parent, TRAIT_WIELDED, REF(src))
	RegisterSignal(user, COMSIG_MOB_SWAPPING_HANDS, PROC_REF(on_swapping_hands))
	wield_callback?.Invoke(parent, user)

	// update item stats and name
	var/obj/item/parent_item = parent
	if(force_multiplier)
		parent_item.force *= force_multiplier
	else if(force_wielded)
		parent_item.force = force_wielded
	// if(sharpened_increase)
	// 	parent_item.force += sharpened_increase
	parent_item.name += " (wielded)"
	parent_item.update_appearance(UPDATE_ICON_STATE)

	if(user.get_item_by_slot(ITEM_SLOT_BACK) == parent)
		user.update_inv_back()
	else
		user.update_inv_hands()

	// Play sound if one is set
	var/sound_to_play = wieldsound
	if(islist(sound_to_play))
		sound_to_play = pick(sound_to_play)

	if(isfile(sound_to_play))
		playsound(parent_item, sound_to_play, 50, TRUE)

	// Let's reserve the other hand
	if(wield_block_offhand)
		offhand_item = new(user)
		offhand_item.name = "[parent_item.name] - offhand"
		offhand_item.desc = "Your second grip on [parent_item]."
		RegisterSignal(offhand_item, COMSIG_ITEM_DROPPED, PROC_REF(on_drop))
		RegisterSignal(offhand_item, COMSIG_PARENT_QDELETING, PROC_REF(on_destroy))
		user.put_in_inactive_hand(offhand_item)

	to_chat(user, span_notice("I wield [parent] with both hands."))

/**
 * Unwield the two handed item
 *
 * vars:
 * * user The mob/living/carbon that is unwielding the item
 * * show_message (option) show a message to chat on unwield
 * * can_drop (option) whether 'dropItemToGround' can be called or not.
 */
/datum/component/two_handed/proc/unwield(mob/living/carbon/user, show_message=TRUE, can_drop=TRUE)
	if(!wielded)
		return

	// wield update status
	wielded = FALSE
	UnregisterSignal(user, COMSIG_MOB_SWAPPING_HANDS)
	SEND_SIGNAL(parent, COMSIG_TWOHANDED_UNWIELD, user)
	REMOVE_TRAIT(parent, TRAIT_WIELDED, REF(src))
	unwield_callback?.Invoke(parent, user)

	// update item stats
	var/obj/item/parent_item = parent
	if(force_multiplier)
		parent_item.force /= force_multiplier
	else if(force_unwielded)
		parent_item.force = force_unwielded

	// update the items name to remove the wielded status
	var/sf = findtext(parent_item.name, " (Wielded)", -10) // 10 == length(" (Wielded)")
	if(sf)
		parent_item.name = copytext(parent_item.name, 1, sf)
	else
		parent_item.name = "[initial(parent_item.name)]"

	// Update icons
	parent_item.update_appearance(UPDATE_ICON_STATE)

	if(istype(user)) // tk showed that we might not have a mob here
		if(user.get_item_by_slot(ITEM_SLOT_BACK) == parent)
			user.update_inv_back()
		else
			user.update_inv_hands()

		// if the item requires two handed drop the item on unwield
		if(require_twohands && can_drop)
			user.dropItemToGround(parent, force=TRUE)

		// Show message if requested
		if(show_message)
			if(require_twohands)
				to_chat(user, span_notice("I drop [parent]."))
			else
				to_chat(user, span_notice("I carry [parent] with one hand."))

	// Play sound if set
	if(unwieldsound)
		playsound(parent_item, unwieldsound, 50, TRUE)

	// Remove the object in the offhand
	if(offhand_item)
		UnregisterSignal(offhand_item, list(COMSIG_ITEM_DROPPED, COMSIG_PARENT_QDELETING))
		qdel(offhand_item)
	// Clear any old refrence to an item that should be gone now
	offhand_item = null

/**
 * on_attack triggers on attack with the parent item
 */
/datum/component/two_handed/proc/on_attack(obj/item/source, mob/living/target, mob/living/user)
	SIGNAL_HANDLER
	if(wielded && attacksound)
		var/obj/item/parent_item = parent
		playsound(parent_item, attacksound, 50, TRUE)

/**
 * on_update_icon triggers on call to update parent items icon
 *
 * Updates the icon using icon_wielded if set
 */
/datum/component/two_handed/proc/on_update_icon(obj/item/source)
	SIGNAL_HANDLER
	if(!wielded)
		return NONE
	if(!icon_wielded)
		return NONE
	source.icon_state = icon_wielded
	return COMSIG_ATOM_NO_UPDATE_ICON_STATE

/**
 * on_moved Triggers on item moved
 */
/datum/component/two_handed/proc/on_moved(datum/source, atom/oldloc, dir)
	SIGNAL_HANDLER

	if(ismob(oldloc))
		unwield(oldloc, show_message = FALSE, can_drop=FALSE)

/**
 * on_inspect Triggers when the inspect href is called. inspect_list is the passed inspection list.
 */
/datum/component/two_handed/proc/on_inspect(obj/item/source, list/inspect_list)
	SIGNAL_HANDLER

	if(require_twohands)
		inspect_list += "\n<b>BULKY</b>"
	else
		inspect_list += "\n<b>TWO-HANDED</b>"

/**
 * on_swap_hands Triggers on swapping hands, blocks swap if the other hand is busy
 */
/datum/component/two_handed/proc/on_swapping_hands(mob/user, obj/item/held_item)
	SIGNAL_HANDLER

	if(!held_item)
		return
	if(held_item == parent)
		return COMPONENT_BLOCK_SWAP

/**
 * modify_base_force Modifies base unwielded and wielded force of parent. Additive modifier first, then multiplicative.
 */
/datum/component/two_handed/proc/modify_base_force(additive_modifier, multiplicative_modifier)
	var/obj/item/parent_item = parent
	if(additive_modifier)
		force_unwielded += additive_modifier
		force_wielded += additive_modifier
	if(multiplicative_modifier)
		force_unwielded *= multiplicative_modifier
		force_wielded *= multiplicative_modifier
	if(wielded && ismob(parent_item.loc))
		unwield(parent_item.loc)

/**
 * The offhand dummy item for two handed items
 *
 */
/obj/item/offhand
	name = "offhand"
	icon = 'icons/obj/hand.dmi'
	icon_state = "offhand"
	w_class = WEIGHT_CLASS_HUGE
	item_flags = ABSTRACT
	resistance_flags = EVERYTHING_PROOF
	layer = OBJ_LAYER - 1
	alpha = 120
	experimental_inhand = FALSE

/obj/item/offhand/Initialize(mapload)
	. = ..()
	ADD_TRAIT(src, TRAIT_NODROP, ABSTRACT_ITEM_TRAIT)

/obj/item/offhand/equipped(mob/user, slot)
	. = ..()
	if(!user.is_holding(src) && !QDELETED(src))
		qdel(src)

