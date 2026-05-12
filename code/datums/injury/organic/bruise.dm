/** BRUISES **/
/datum/injury/bruise
	bleed_threshold = 20
	autoheal_cutoff = 30
	damage_type = WOUND_BLUNT

/datum/injury/bruise/small
	stages = list(
		"mild bruise" = 15,
		"small bruise" = 10,
		"tiny bruise" = 5,
		"tiny hematoma" = 0
		)

/datum/injury/bruise/moderate
	stages = list(
		"big bruise" = 25,
		"moderate bruise" = 20,
		"mild bruise" = 15,
		"small bruise" = 10,
		"small healing bruise" = 5,
		"small hematoma" = 0
		)
	max_bleeding_stage = 2

/datum/injury/bruise/large
	stages = list(
		"enormous bruise" = 50,
		"large bruise" = 30,
		"moderate bruise" = 20,
		"mild bruise" = 15,
		"small bruise" = 10,
		"small healing bruise" = 5,
		"small hematoma" = 0
		)
	max_bleeding_stage = 3
	fade_away_time = INFINITY

/datum/injury/bruise/huge
	stages = list(
		"gigantic bruise" = 80,
		"huge bruise" = 50,
		"large bruise" = 30,
		"moderate bruise" = 20,
		"mild angry bruise" = 15,
		"mild bruise" = 10,
		"mild healing bruise" = 5,
		"mild hematoma" = 0
		)
	max_bleeding_stage = 4
	fade_away_time = INFINITY

/datum/injury/bruise/monumental
	stages = list(
		"monumental bruise" = 80,
		"huge bruise" = 50,
		"large angry bruise" = 30,
		"large bruise" = 20,
		"moderate angry bruise" = 15,
		"moderate bruise" = 10,
		"moderate healing bruise" = 5,
		"moderate hematoma" = 0
		)
	max_bleeding_stage = 4
	fade_away_time = INFINITY
