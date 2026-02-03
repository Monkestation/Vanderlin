/datum/hair_gradient
	abstract_type = /datum/hair_gradient
	var/name
	var/icon = 'icons/mob/sprite_accessory/hair/hair_gradients.dmi'
	var/icon_state

/datum/hair_gradient/none
	name = "None"
	icon = null
	icon_state = null

/datum/hair_gradient/fadeup
	name = "Fade Up"
	icon_state = "fadeup"

/datum/hair_gradient/fadedown
	name = "Fade Down"
	icon_state = "fadedown"

/datum/hair_gradient/vertical_split
	name = "Vertical Split"
	icon_state = "vsplit"

/datum/hair_gradient/_split
	name = "Horizontal Split"
	icon_state = "bottomflat"

/datum/hair_gradient/reflected
	name = "Reflected"
	icon_state = "reflected_high"

/datum/hair_gradient/reflected_inverse
	name = "Reflected Inverse"
	icon_state = "reflected_inverse_high"

/datum/hair_gradient/wavy
	name = "Wavy"
	icon_state = "wavy"

/datum/hair_gradient/long_fade_up
	name = "Long Fade Up"
	icon_state = "long_fade_up"

/datum/hair_gradient/long_fade_down
	name = "Long Fade Down"
	icon_state = "long_fade_down"

/datum/hair_gradient/short_fade_up
	name = "Short Fade Up"
	icon_state = "short_fade_up"

/datum/hair_gradient/short_fade_down
	name = "Short Fade Down"
	icon_state = "short_fade_down"

/datum/hair_gradient/wavy_spike
	name = "Spiked Wavy"
	icon_state = "wavy_spiked"

/datum/hair_gradient/streaks
	name = "Streaked"
	icon_state = "streaks"
