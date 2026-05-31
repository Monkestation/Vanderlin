/datum/injury/bite/small/mechanical
	stages = list(
		"ugly crushed dent" = 20,
		"crushed dent" = 10,
		"dent" = 5,
		"healing dent" = 2,
		"small dent" = 0
		)
	required_status = BODYPART_ROBOTIC

/datum/injury/bite/deep/mechanical
	stages = list(
		"ugly deep puncture dent" = 25,
		"deep puncture dent" = 20,
		"deep dent" = 15,
		"dent" = 8,
		"small dent" = 2,
		"hairline crack" = 0
		)
	required_status = BODYPART_ROBOTIC

/datum/injury/bite/flesh/mechanical
	stages = list(
		"ugly crushed puncture wound" = 35,
		"crushed puncture wound" = 30,
		"puncture wound" = 25,
		"shallow puncture" = 15,
		"large dent" = 5,
		"small dent" = 0
		)
	required_status = BODYPART_ROBOTIC

/datum/injury/bite/gaping/mechanical
	stages = list(
		"gaping crush wound" = 50,
		"large crush wound" = 25,
		"shallow crush wound" = 15,
		"small jagged crack" = 5,
		"small crack" = 0
		)
	required_status = BODYPART_ROBOTIC

/datum/injury/bite/gaping_big/mechanical
	stages = list(
		"big gaping crush wound" = 60,
		"melding gaping crush wound" = 40,
		"large puncture wound" = 25,
		"large jagged crack" = 10,
		"large crack" = 0
		)
	required_status = BODYPART_ROBOTIC

/datum/injury/bite/massive/mechanical
	stages = list(
		"massive crush wound" = 70,
		"massive melding crush wound" = 50,
		"massive soldering crush wound" = 25,
		"massive jagged crack" = 10,
		"massive splintered crack" = 0
		)
	required_status = BODYPART_ROBOTIC
