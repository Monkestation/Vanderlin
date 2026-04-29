/** BITES **/
/datum/injury/bite
	bleed_threshold = 5
	damage_type = WOUND_BITE

/datum/injury/bite/small
	max_bleeding_stage = 3
	stages = list(
		"ugly bite mark" = 20,
		"bite mark" = 10,
		"small bite" = 5,
		"bruised bite" = 2,
		"small bruise" = 0
		)

/datum/injury/bite/deep
	max_bleeding_stage = 3
	stages = list(
		"ugly deep bite" = 25,
		"deep bite" = 20,
		"deep tooth mark" = 15,
		"clotted bite" = 8,
		"bruised scab" = 2,
		"ragged scar" = 0
		)
	fade_away_time = INFINITY

/datum/injury/bite/flesh
	max_bleeding_stage = 4
	stages = list(
		"ugly torn bite wound" = 35,
		"torn bite wound" = 30,
		"bite wound" = 25,
		"blood soaked bite clot" = 15,
		"large bruised scab" = 5,
		"ragged scar" = 0
		)
	fade_away_time = INFINITY

/datum/injury/bite/gaping
	max_bleeding_stage = 3
	stages = list(
		"gaping bite wound" = 50,
		"large blood soaked bite clot" = 25,
		"blood soaked bite clot" = 15,
		"small ragged scar" = 5,
		"small puckered scar" = 0
		)
	fade_away_time = INFINITY

/datum/injury/bite/gaping_big
	max_bleeding_stage = 3
	stages = list(
		"big gaping bite wound" = 60,
		"healing gaping bite wound" = 40,
		"large blood soaked bite clot" = 25,
		"large ragged scar" = 10,
		"large puckered scar" = 0
		)
	fade_away_time = INFINITY

/datum/injury/bite/massive
	max_bleeding_stage = 3
	stages = list(
		"massive bite wound" = 70,
		"massive healing bite wound" = 50,
		"massive blood soaked bite clot" = 25,
		"massive ragged scar" = 10,
		"massive jagged bite scar" = 0
		)
	fade_away_time = INFINITY
