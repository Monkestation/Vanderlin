/** SLASHES **/
/datum/injury/slash
	damage_type = WOUND_SLASH

/datum/injury/slash/small
	// link wound descriptions to amounts of damage
	bleed_threshold = 5
	stages = list(
		"ugly ripped cut" = 20,
		"ripped cut" = 10,
		"cut" = 5,
		"healing cut" = 2,
		"small scab" = 0
		)

/datum/injury/slash/deep
	bleed_threshold = 15
	stages = list(
		"ugly deep ripped cut" = 25,
		"deep ripped cut" = 20,
		"deep cut" = 15,
		"clotted cut" = 8,
		"scab" = 2,
		"fresh scar" = 0
		)
	fade_away_time = INFINITY

/datum/injury/slash/flesh
	bleed_threshold = 15
	stages = list(
		"ugly ripped flesh wound" = 35,
		"ugly flesh wound" = 30,
		"flesh wound" = 25,
		"blood soaked clot" = 15,
		"large scab" = 5,
		"fresh scar" = 0
		)
	fade_away_time = INFINITY

/datum/injury/slash/gaping
	bleed_threshold = 15
	stages = list(
		"gaping wound" = 50,
		"large blood soaked clot" = 25,
		"blood soaked clot" = 15,
		"small angry scar" = 5,
		"small straight scar" = 0
		)
	fade_away_time = INFINITY

/datum/injury/slash/gaping_big
	bleed_threshold = 25
	stages = list(
		"big gaping wound" = 60,
		"healing gaping wound" = 40,
		"large blood soaked clot" = 25,
		"large angry scar" = 10,
		"large straight scar" = 0
		)
	fade_away_time = INFINITY

/datum/injury/slash/massive
	bleed_threshold = 25
	stages = list(
		"massive wound" = 70,
		"massive healing wound" = 50,
		"massive blood soaked clot" = 25,
		"massive angry scar" = 10,
		"massive jagged scar" = 0
		)
	fade_away_time = INFINITY
