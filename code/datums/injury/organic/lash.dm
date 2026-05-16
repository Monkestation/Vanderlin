/datum/injury/lash
	damage_type = WOUND_LASH
	autoheal_cutoff = 10
	infection_rate = 1.15
	bleed_threshold = 20

/datum/injury/lash/welt
	stages = list(
		"ripped welt" = 10,
		"welt" = 5,
		"healing welt" = 2,
		"fading welt" = 0
	)

/datum/injury/lash/lash
	stages = list(
		"ripped lash" = 20,
		"lash" = 15,
		"healing lash" = 5,
		"lash scar" = 0
	)
	fade_away_time = INFINITY
	max_bleeding_stage = 2

/datum/injury/lash/severe
	stages = list(
		"ripped severe lash" = 35,
		"severe lash" = 30,
		"healing severe lash" = 10,
		"deep lash scar" = 0
	)
	fade_away_time = INFINITY
	max_bleeding_stage = 3

/datum/injury/lash/deep
	stages = list(
		"ripped deep lash" = 45,
		"deep lash" = 40,
		"healing deep lash" = 15,
		"flensed scar" = 0
	)
	fade_away_time = INFINITY
	max_bleeding_stage = 3

/datum/injury/lash/flayed
	stages = list(
		"flayed area" = 50,
		"healing flayed area" = 20,
		"massive lash scar" = 0
	)
	fade_away_time = INFINITY
	max_bleeding_stage = 4
