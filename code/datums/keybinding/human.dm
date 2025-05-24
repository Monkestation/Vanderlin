/datum/keybinding/human
	category = CATEGORY_HUMAN
	weight = WEIGHT_MOB

/datum/keybinding/human/can_use(client/user)
	return ishuman(user.mob)

/datum/keybinding/human/fixeye
	hotkey_keys = list("F")
	name = "fix_eye"
	full_name = "Fixed Eye"
	description = "Focus in a direction."

/datum/keybinding/human/fixeye/down(client/user)
	. = ..()
	var/mob/living/carbon/human/H = user.mob
	H.toggle_eye_intent(H)
	return TRUE
