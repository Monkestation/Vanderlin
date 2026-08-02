
/datum/injury/lash/welt/mechanical
	stages = list(
		"ripped gouge" = 10,
		"gouge mark" = 5,
		"healing gouge" = 2,
		"fading gouge" = 0
	)
	required_status = BODYPART_ROBOTIC

/datum/injury/lash/lash/mechanical
	stages = list(
		"ripped deep gouge" = 20,
		"deep gouge" = 15,
		"healing deep gouge" = 5,
		"scoring mark" = 0
	)
	required_status = BODYPART_ROBOTIC
	fade_away_time = INFINITY

/datum/injury/lash/severe/mechanical
	stages = list(
		"ripped severe gouge" = 35,
		"severe gouge" = 30,
		"healing severe gouge" = 10,
		"deep scoring" = 0
	)
	required_status = BODYPART_ROBOTIC
	fade_away_time = INFINITY

/datum/injury/lash/deep/mechanical
	stages = list(
		"ripped chassis gash" = 45,
		"chassis gash" = 40,
		"healing chassis gash" = 15,
		"chassis scarring" = 0
	)
	required_status = BODYPART_ROBOTIC
	fade_away_time = INFINITY

/datum/injury/lash/flayed/mechanical
	stages = list(
		"stripped plating" = 50,
		"healing stripped plating" = 20,
		"plating scar" = 0
	)
	required_status = BODYPART_ROBOTIC
	fade_away_time = INFINITY
