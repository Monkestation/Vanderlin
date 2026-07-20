/datum/injury/internal_bruise
	damage_type = WOUND_INTERNAL_BRUISE
	autoheal_cutoff = 0
	bleed_threshold = INFINITY
	fade_away_time = INFINITY

/datum/injury/internal_bruise/infection_check(delta_time, times_fired)
	return FALSE

/datum/injury/internal_bruise/get_desc(count)
	return null

/datum/injury/internal_bruise/minor
	stages = list(
		"internal bruise" = 10,
		"fading internal bruise" = 0
	)

/datum/injury/internal_bruise/moderate
	stages = list(
		"internal bruise" = 20,
		"fading internal bruise" = 0
	)

/datum/injury/internal_bruise/severe
	stages = list(
		"internal bruise" = 35,
		"fading internal bruise" = 0
	)

/datum/injury/internal_bruise/critical
	stages = list(
		"internal bruise" = 45,
		"fading internal bruise" = 0
	)

/datum/injury/internal_bruise/catastrophic
	stages = list(
		"internal bruise" = 50,
		"fading internal bruise" = 0
	)
