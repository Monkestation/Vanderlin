/datum/injury/divine
	damage_type = WOUND_DIVINE
	autoheal_cutoff = 0
	infection_rate = 0
	bleed_threshold = INFINITY
	fade_away_time = INFINITY

/datum/injury/divine/can_autoheal()
	return FALSE // nuh uh

/datum/injury/divine/smite
	stages = list(
		"raw smite wound" = 10,
		"smite wound" = 5,
		"healing smite wound" = 2,
		"fading smite mark" = 0
	)

/datum/injury/divine/brand
	stages = list(
		"raw divine brand" = 20,
		"divine brand" = 15,
		"healing divine brand" = 5,
		"brand scar" = 0
	)
	fade_away_time = INFINITY
	max_bleeding_stage = 2

/datum/injury/divine/severe
	stages = list(
		"raw severe brand" = 35,
		"severe divine brand" = 30,
		"healing divine brand" = 10,
		"deep brand scar" = 0
	)
	fade_away_time = INFINITY
	max_bleeding_stage = 3

/datum/injury/divine/wrath
	stages = list(
		"raw wrath wound" = 45,
		"wrath wound" = 40,
		"healing wrath wound" = 15,
		"wrath scar" = 0
	)
	fade_away_time = INFINITY
	max_bleeding_stage = 3

/datum/injury/divine/condemned
	stages = list(
		"condemned flesh" = 50,
		"healing condemned flesh" = 20,
		"condemnation scar" = 0
	)
	fade_away_time = INFINITY
	max_bleeding_stage = 4
