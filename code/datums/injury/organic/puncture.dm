/datum/injury/puncture
	damage_type = WOUND_PUNCTURE

/datum/injury/puncture/can_worsen(damage_type, damage)
	return FALSE //cannot be enlargened

/datum/injury/puncture/small
	bleed_threshold = 2
	stages = list(
		"puncture" = 5,
		"healing puncture" = 2,
		"small round scab" = 0
		)

/datum/injury/puncture/flesh
	bleed_threshold = 5
	stages = list(
		"puncture wound" = 15,
		"round blood soaked clot" = 5,
		"large scab" = 2,
		"small round scar" = 0
		)
	fade_away_time = INFINITY

/datum/injury/puncture/gaping
	bleed_threshold = 10
	stages = list(
		"gaping hole" = 30,
		"large round blood soaked clot" = 15,
		"round blood soaked clot" = 10,
		"small round angry scar" = 5,
		"small round scar" = 0
		)
	fade_away_time = INFINITY

/datum/injury/puncture/gaping_big
	bleed_threshold = 15
	stages = list(
		"big gaping hole" = 50,
		"healing gaping hole" = 20,
		"large round blood soaked clot" = 15,
		"large round angry scar" = 10,
		"large round scar" = 0
		)
	fade_away_time = INFINITY

/datum/injury/puncture/massive
	bleed_threshold = 25
	stages = list(
		"massive hole" = 60,
		"massive healing hole" = 30,
		"massive round blood soaked clot" = 25,
		"massive round angry scar" = 10,
		"massive round jagged scar" = 0
		)
	fade_away_time = INFINITY
