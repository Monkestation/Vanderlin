/datum/keybinding/human
	category = CATEGORY_HUMAN
	weight = WEIGHT_MOB

/datum/keybinding/human/can_use(client/user)
	return ishuman(user.mob)

// Left commented because quick equip can put items into slots that are not in the UI, blame Roguetown.
/* /datum/keybinding/human/quick_equip
	hotkey_keys = list() // Keeping it empty lets the user set their own keybind since E is used
	name = "quick_equip"
	full_name = "Quick Equip"
	description = "Quickly puts an item in the best slot available"

/datum/keybinding/human/quick_equip/down(client/user, turf/target, mousepos_x, mousepos_y)
	var/mob/living/carbon/human/H = user.mob
	H.quick_equip()
	return TRUE */

/datum/keybinding/human/quick_equipbelt
	hotkey_keys = list("ShiftB")
	name = "quick_equipbelt"
	full_name = "Quick equip belt"
	description = "Put held thing in belt or take out most recent thing from belt"

/datum/keybinding/human/quick_equipbelt/down(client/user, turf/target, mousepos_x, mousepos_y)
	. = ..()
	var/mob/living/carbon/human/H = user.mob
	if(do_after(H, CLICK_CD_MELEE, H))
		H.smart_equipbelt()
	return TRUE

/datum/keybinding/human/bag_equip_backl
	hotkey_keys = list("ShiftQ")
	name = "bag_equip_backl"
	full_name = "Bag Equip Left"
	description = "Put held item in the left backpack slot or take out the most recent item from the left backpack slot"

/datum/keybinding/human/bag_equip_backl/down(client/user, turf/target, mousepos_x, mousepos_y)
	. = ..()
	var/mob/living/carbon/human/H = user.mob
	if(do_after(H, CLICK_CD_MELEE, H))
		H.smart_equipbag(ITEM_SLOT_BACK_R) // These fucking shits are reversed in the UI, so keep it like this for symmetry
	return TRUE

/datum/keybinding/human/bag_equip_backr
	hotkey_keys = list("ShiftE")
	name = "bag_equip_backr"
	full_name = "Bag Equip Right"
	description = "Put held item in the right backpack slot or take out the most recent item from the right backpack slot"

/datum/keybinding/human/bag_equip_backr/down(client/user, turf/target, mousepos_x, mousepos_y)
	. = ..()
	var/mob/living/carbon/human/H = user.mob
	if(do_after(H, CLICK_CD_MELEE, H))
		H.smart_equipbag(ITEM_SLOT_BACK_L) // These fucking shits are reversed in the UI, so keep it like this for symmetry
	return TRUE

/datum/keybinding/human/fixeye
	hotkey_keys = list("F")
	name = "fix_eye"
	full_name = "Fixed Eye"
	description = "Focus in a direction."

/datum/keybinding/human/fixeye/down(client/user, turf/target, mousepos_x, mousepos_y)
	. = ..()
	var/mob/living/carbon/human/H = user.mob
	H.toggle_eye_intent(H)
	return TRUE
