/** MECHANICAL SLASHES **/
/datum/injury/slash/small/mechanical
	stages = list(
		"ugly ripped laceration" = 20,
		"ripped laceration" = 10,
		"laceration" = 5,
		"healing cut" = 2,
		"small tear" = 0
		)
	required_status = BODYPART_ROBOTIC

/datum/injury/slash/deep/mechanical
	stages = list(
		"ugly deep ripped laceration" = 25,
		"deep ripped laceration" = 20,
		"deep laceration" = 15,
		"laceration" = 8,
		"tear" = 2,
		"small tear" = 0
		)
	required_status = BODYPART_ROBOTIC

/datum/injury/slash/flesh/mechanical
	stages = list(
		"ugly ripped gash" = 35,
		"ugly gash" = 30,
		"gash" = 25,
		"shallow gash" = 15,
		"large tear" = 5,
		"small tear" = 0
		)
	required_status = BODYPART_ROBOTIC

/datum/injury/slash/gaping/mechanical
	stages = list(
		"gaping gash" = 50,
		"large gash" = 25,
		"shallow gash" = 15,
		"small angry tear" = 5,
		"small straight tear" = 0
		)
	required_status = BODYPART_ROBOTIC

/datum/injury/slash/gaping_big/mechanical
	stages = list(
		"big gaping gash" = 60,
		"melding gaping gash" = 40,
		"large laceration" = 25,
		"large angry tear" = 10,
		"large straight tear" = 0
		)
	required_status = BODYPART_ROBOTIC

/datum/injury/slash/massive/mechanical
	stages = list(
		"massive gash" = 70,
		"massive melding gash" = 50,
		"massive soldering gash" = 25,
		"massive angry tear" = 10,
		"massive jagged tear" = 0
		)
	required_status = BODYPART_ROBOTIC
