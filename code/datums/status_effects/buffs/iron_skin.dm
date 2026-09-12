#define IRON_SKIN_FILTER "iron_skin_glow"

/atom/movable/screen/alert/status_effect/buff/iron_skin
	name = "Iron Skin"
	desc = "Bits of arcyne iron and steel surround my armor, any attacks against me are blunted."
	icon_state = "buff"

/datum/status_effect/buff/iron_skin
	var/outline_colour = "#708090"
	id = "iron_skin"
	alert_type = /atom/movable/screen/alert/status_effect/buff/iron_skin
	duration = 1 MINUTES

/datum/status_effect/buff/iron_skin/on_apply()
	. = ..()
	var/filter = owner.get_filter(IRON_SKIN_FILTER)
	if(!filter)
		owner.add_filter(IRON_SKIN_FILTER, 2, list("type" = "outline", "color" = outline_colour, "alpha" = 40, "size" = 1))
	to_chat(owner, span_notice("Bits of arcyne iron and steel surround my armor, any blows and attacks against me are blunted."))

/datum/status_effect/buff/iron_skin/on_remove()
	. = ..()
	to_chat(owner, span_warning("The iron shell flakes away."))
	owner.remove_filter(IRON_SKIN_FILTER)

#undef IRON_SKIN_FILTER
