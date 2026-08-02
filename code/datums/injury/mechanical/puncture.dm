/** MECHANICAL PUNCTURES **/
/datum/injury/puncture/small/mechanical
	stages = list(
		"perforation" = 5,
		"small perforation" = 2,
		"small nick" = 0
		)
	required_status = BODYPART_ROBOTIC

/datum/injury/puncture/flesh/mechanical
	stages = list(
		"large rupture" = 15,
		"perforation" = 5,
		"large nick" = 2,
		"small round nick" = 0
		)
	required_status = BODYPART_ROBOTIC

/datum/injury/puncture/gaping/mechanical
	stages = list(
		"gaping rupture" = 30,
		"large rupture" = 15,
		"large perforation" = 10,
		"small deep nick" = 5,
		"small nick" = 0
		)
	required_status = BODYPART_ROBOTIC

/datum/injury/puncture/gaping_big/mechanical
	stages = list(
		"big gaping rupture" = 50,
		"gaping rupture" = 20,
		"large rupture" = 15,
		"large perforation" = 10,
		"large nick" = 0
		)
	required_status = BODYPART_ROBOTIC

/datum/injury/puncture/massive/mechanical
	stages = list(
		"massive gaping rupture" = 60,
		"massive rupture" = 30,
		"massive pierce" = 25,
		"massive perforation" = 10,
		"massive jagged nick" = 0
		)
	required_status = BODYPART_ROBOTIC
