/datum/keybinding/carbon
	category = CATEGORY_CARBON
	weight = WEIGHT_MOB

/datum/keybinding/carbon/can_use(client/user)
	return iscarbon(user.mob)

/datum/keybinding/carbon/toggle_throw_mode
	hotkey_keys = list("R")
	classic_keys = list("R") // END
	name = "toggle_throw_mode"
	full_name = "Toggle throw mode"
	description = "Toggle throwing the current item or not."
	category = CATEGORY_CARBON

/datum/keybinding/carbon/toggle_throw_mode/down(client/user, turf/target, mousepos_x, mousepos_y)
	. = ..()
	if (!iscarbon(user.mob))
		return FALSE
	var/mob/living/carbon/C = user.mob
	C.toggle_throw_mode()
	return TRUE

//****** Base Intents ******

/datum/keybinding/carbon/intent_one
	hotkey_keys = list("1")
	name = "intent_one"
	full_name = "Cycle Intent Slot 1"
	description = ""
	category = CATEGORY_CARBON

/datum/keybinding/carbon/intent_one/down(client/user, turf/target, mousepos_x, mousepos_y)
	. = ..()
	if (!iscarbon(user.mob))
		return FALSE
	var/mob/living/carbon/C = user.mob
	C.rog_intent_change(1)
/*	if(C.active_hand_index == 2)
		if(C.swap_hand(1))
			C.rog_intent_change(1)
	else
		if(C.l_index == 1)
			C.rog_intent_change(3)
		else
			C.rog_intent_change(1)*/

	return TRUE

/datum/keybinding/carbon/intent_two
	hotkey_keys = list("2")
	name = "intent_two"
	full_name = "Cycle Intent Slot 2"
	description = ""
	category = CATEGORY_CARBON

/datum/keybinding/carbon/intent_two/down(client/user, turf/target, mousepos_x, mousepos_y)
	. = ..()
	if (!iscarbon(user.mob))
		return FALSE
	var/mob/living/carbon/C = user.mob
	C.rog_intent_change(2)
	return TRUE

/datum/keybinding/carbon/intent_three
	hotkey_keys = list("3")
	name = "intent_three"
	full_name = "Cycle Intent Slot 3"
	description = ""
	category = CATEGORY_CARBON

/datum/keybinding/carbon/intent_three/down(client/user, turf/target, mousepos_x, mousepos_y)
	. = ..()
	if (!iscarbon(user.mob))
		return FALSE
	var/mob/living/carbon/C = user.mob
	C.rog_intent_change(3)
	return TRUE

/datum/keybinding/carbon/intent_four
	hotkey_keys = list("4")
	name = "intent_four"
	full_name = "Cycle Intent Slot 4"
	description = ""
	category = CATEGORY_CARBON

/datum/keybinding/carbon/intent_four/down(client/user, turf/target, mousepos_x, mousepos_y)
	. = ..()
	if (!iscarbon(user.mob))
		return FALSE
	var/mob/living/carbon/C = user.mob
	C.rog_intent_change(4)
	return TRUE

//****** Quad Intents ******

/datum/keybinding/carbon/give_intent
	hotkey_keys = list("G")
	name = "Give_Item"
	full_name = "Give item"
	description = "Give the item you're currently holding"
	category = CATEGORY_CARBON

/datum/keybinding/carbon/give_intent/down(client/user, turf/target, mousepos_x, mousepos_y)
	. = ..()
	if(.)
		return

	if(!target)
		return

	var/mob/living/living_user = user.mob
	if(!living_user.Adjacent(target))
		return

	var/mob/living/offered = locate() in target
	if(!offered)
		return

	living_user.give(offered)
	return TRUE

/datum/keybinding/carbon/bite_intent
	hotkey_keys = list("H")
	name = "intent_bite"
	full_name = "Select Bite Intent"
	description = ""
	category = CATEGORY_CARBON

/datum/keybinding/carbon/bite_intent/down(client/user, turf/target, mousepos_x, mousepos_y)
	. = ..()
	if (!iscarbon(user.mob))
		return FALSE
	var/mob/living/carbon/C = user.mob
	C.mmb_intent_change(QINTENT_BITE)
	return TRUE

/datum/keybinding/carbon/jump_intent
	hotkey_keys = list("J")
	name = "intent_jump"
	full_name = "Select Jump Intent"
	description = ""
	category = CATEGORY_CARBON

/datum/keybinding/carbon/jump_intent/down(client/user, turf/target, mousepos_x, mousepos_y)
	. = ..()
	if (!iscarbon(user.mob))
		return FALSE
	var/mob/living/carbon/C = user.mob
	C.mmb_intent_change(QINTENT_JUMP)
	return TRUE

/datum/keybinding/carbon/kick_intent
	hotkey_keys = list("K")
	name = "intent_kick"
	full_name = "Select Kick Intent"
	description = ""
	category = CATEGORY_CARBON

/datum/keybinding/carbon/kick_intent/down(client/user, turf/target, mousepos_x, mousepos_y)
	. = ..()
	if (!iscarbon(user.mob))
		return FALSE
	var/mob/living/carbon/C = user.mob
	C.mmb_intent_change(QINTENT_KICK)
	return TRUE

/datum/keybinding/carbon/steal_intent
	hotkey_keys = list("L")
	name = "intent_steal"
	full_name = "Select Steal Intent"
	description = ""
	category = CATEGORY_CARBON

/datum/keybinding/carbon/steal_intent/down(client/user, turf/target, mousepos_x, mousepos_y)
	. = ..()
	if (!iscarbon(user.mob))
		return FALSE
	var/mob/living/carbon/C = user.mob
	C.mmb_intent_change(QINTENT_STEAL)
	return TRUE

//****** RMB Intents ******

/datum/keybinding/carbon/rmb_intent_1
	hotkey_keys = list("Ctrl1")
	name = "rmb_intent_1"
	full_name = "Select Feint Intent"
	description = "Selects the Feint RMB intent."
	category = CATEGORY_CARBON

/datum/keybinding/carbon/rmb_intent_1/down(client/user, turf/target, mousepos_x, mousepos_y)
	. = ..()
	if(!iscarbon(user.mob))
		return FALSE
	var/mob/living/carbon/C = user.mob
	C.swap_rmb_intent(null, 1)
	return TRUE

/datum/keybinding/carbon/rmb_intent_2
	hotkey_keys = list("Ctrl2")
	name = "rmb_intent_2"
	full_name = "Select Aimed Intent"
	description = "Selects the Aimed RMB intent."
	category = CATEGORY_CARBON

/datum/keybinding/carbon/rmb_intent_2/down(client/user, turf/target, mousepos_x, mousepos_y)
	. = ..()
	if(!iscarbon(user.mob))
		return FALSE
	var/mob/living/carbon/C = user.mob
	C.swap_rmb_intent(null, 2)
	return TRUE

/datum/keybinding/carbon/rmb_intent_3
	hotkey_keys = list("Ctrl3")
	name = "rmb_intent_3"
	full_name = "Select Strong Intent"
	description = "Selects the Strong RMB intent."
	category = CATEGORY_CARBON

/datum/keybinding/carbon/rmb_intent_3/down(client/user, turf/target, mousepos_x, mousepos_y)
	. = ..()
	if(!iscarbon(user.mob))
		return FALSE
	var/mob/living/carbon/C = user.mob
	C.swap_rmb_intent(null, 3)
	return TRUE

/datum/keybinding/carbon/rmb_intent_4
	hotkey_keys = list("Ctrl4")
	name = "rmb_intent_4"
	full_name = "Select Swift Intent"
	description = "Selects the Swift RMB intent."
	category = CATEGORY_CARBON

/datum/keybinding/carbon/rmb_intent_4/down(client/user, turf/target, mousepos_x, mousepos_y)
	. = ..()
	if(!iscarbon(user.mob))
		return FALSE
	var/mob/living/carbon/C = user.mob
	C.swap_rmb_intent(null, 4)
	return TRUE

/datum/keybinding/carbon/rmb_intent_5
	hotkey_keys = list("Ctrl5")
	name = "rmb_intent_5"
	full_name = "Select Defend Intent"
	description = "Selects the Defend RMB intent."
	category = CATEGORY_CARBON

/datum/keybinding/carbon/rmb_intent_5/down(client/user, turf/target, mousepos_x, mousepos_y)
	. = ..()
	if(!iscarbon(user.mob))
		return FALSE
	var/mob/living/carbon/C = user.mob
	C.swap_rmb_intent(null, 5)
	return TRUE

/datum/keybinding/carbon/rmb_intent_6
	hotkey_keys = list("Ctrl6")
	name = "rmb_intent_6"
	full_name = "Select Weak Intent"
	description = "Selects the Weak RMB intent."
	category = CATEGORY_CARBON

/datum/keybinding/carbon/rmb_intent_6/down(client/user, turf/target, mousepos_x, mousepos_y)
	. = ..()
	if(!iscarbon(user.mob))
		return FALSE
	var/mob/living/carbon/C = user.mob
	C.swap_rmb_intent(null, 6)
	return TRUE

/datum/keybinding/carbon/cycle_rmb_intent
	hotkey_keys = list("N")
	name = "cycle_rmb_intent"
	full_name = "Cycle RMB Intent"
	description = "Cycle through available Right Mouse Button (RMB) intents."
	category = CATEGORY_CARBON

/datum/keybinding/carbon/cycle_rmb_intent/down(client/user, turf/target, mousepos_x, mousepos_y)
	. = ..()
	if(!iscarbon(user.mob))
		return FALSE
	var/mob/living/carbon/C = user.mob
	C.cycle_rmb_intent()
	return TRUE

/*

/datum/keybinding/carbon/select_help_intent
	hotkey_keys = null
	name = "select_help_intent"
	full_name = "Select help intent"
	description = ""
	category = CATEGORY_CARBON

/datum/keybinding/carbon/select_help_intent/down(client/user, turf/target, mousepos_x, mousepos_y)
	if(iscyborg(user.mob))
		return FALSE
	user.mob?.a_intent_change(INTENT_HELP)
	return TRUE


/datum/keybinding/carbon/select_disarm_intent
	hotkey_keys = null
	name = "select_disarm_intent"
	full_name = "Select disarm intent"
	description = ""
	category = CATEGORY_CARBON

/datum/keybinding/carbon/select_disarm_intent/down(client/user, turf/target, mousepos_x, mousepos_y)
	user.mob?.a_intent_change(INTENT_DISARM)
	return TRUE


/datum/keybinding/carbon/select_grab_intent
	hotkey_keys = null
	name = "select_grab_intent"
	full_name = "Select grab intent"
	description = ""
	category = CATEGORY_CARBON

/datum/keybinding/carbon/select_grab_intent/down(client/user, turf/target, mousepos_x, mousepos_y)
	user.mob?.a_intent_change(INTENT_GRAB)
	return TRUE


/datum/keybinding/carbon/select_harm_intent
	hotkey_keys = null
	name = "select_harm_intent"
	full_name = "Select harm intent"
	description = ""
	category = CATEGORY_CARBON

/datum/keybinding/carbon/select_harm_intent/down(client/user, turf/target, mousepos_x, mousepos_y)
	if(iscyborg(user.mob))
		return FALSE
	user.mob?.a_intent_change(INTENT_HARM)
	return TRUE
*/
