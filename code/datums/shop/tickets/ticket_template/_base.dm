/datum/ticket_template
	abstract_type = /datum/ticket_template
	var/name = "Unnamed Template" // shown on the button
	var/fa_icon = "file-alt"
	var/color = "#607d8b"
	var/ticket_type // TICKET_TYPE_* - which tab this template belongs under
	/// Keys here match the form fields 1:1 - "name", "description", "grant_reason",
	/// plus any type-specific key (triumph_amount, job_boost_job, etc).
	/// Only include the keys you actually want this template to overwrite.
	var/list/fields = list()

/datum/ticket_template/proc/to_ui_list()
	return list(
		"label" = name,
		"fa_icon" = fa_icon,
		"color" = color,
		"ticket_type" = ticket_type,
		"fields" = fields,
	)

/datum/ticket_template/triumph_small
	name = "Small Triumph Grant"
	fa_icon = "coins"
	color = "#ffd700"
	ticket_type = TICKET_TYPE_TRIUMPH
	fields = list(
		"name" = "Triumph Bonus",
		"description" = "A small reward for good behavior.",
		"triumph_amount" = "5",
	)

/datum/ticket_template/peel_pin
	name = "Peel Pin"
	fa_icon = "coins"
	color = "#ffd700"
	ticket_type = TICKET_TYPE_LOADOUT
	fields = list(
		"name" = "Peel Pin Giveaway",
		"description" = "Unique Pin as a part of the Twitch Event.",
		"grant_reason" = "Rewarded for being apart of the Twitch Event.",
		"loadout_item_path" = "/datum/loadout_item/peel_pin",
	)
