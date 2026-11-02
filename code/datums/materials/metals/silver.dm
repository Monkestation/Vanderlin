/datum/material/silver
	name = "Silver"
	show_as_filling = TRUE
	color = "#d1e6e3"
	hardness = MAT_VALUE_FLEXIBLE + 10
	integrity_modifier = 0.65
	solid_form = /obj/item/ingot/silver

	traits = list(
		/datum/material_trait/silver_bane
	)

	value_modiifer = 1.5

/datum/material/truesilver
	name = "Truesilver"
	show_as_filling = TRUE
	color = "#d1e6e3"
	hardness = MAT_VALUE_FLEXIBLE + 10
	integrity_modifier = 0.85
	solid_form = /obj/item/ingot/silver/truesilver

	traits = list(
		/datum/material_trait/silver_bane
	)

	value_modiifer = 1.8
	material_examine_hint = /datum/examine_highlight/divine/truesilver
