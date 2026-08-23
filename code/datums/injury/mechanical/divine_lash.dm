
/datum/injury/divine/smite/mechanical
	stages = list(
		"raw smite wound" = 10,
		"smite wound" = 5,
		"healing smite wound" = 2,
		"fading smite mark" = 0
	)
	required_status = BODYPART_ROBOTIC

/datum/injury/divine/brand/mechanical
	stages = list(
		"raw divine brand" = 20,
		"divine brand" = 15,
		"healing divine brand" = 5,
		"brand scar" = 0
	)
	required_status = BODYPART_ROBOTIC

/datum/injury/divine/severe/mechanical
	stages = list(
		"raw severe brand" = 35,
		"severe divine brand" = 30,
		"healing divine brand" = 10,
		"deep brand scar" = 0
	)
	required_status = BODYPART_ROBOTIC

/datum/injury/divine/wrath/mechanical
	stages = list(
		"raw wrath wound" = 45,
		"wrath wound" = 40,
		"healing wrath wound" = 15,
		"wrath scar" = 0
	)
	required_status = BODYPART_ROBOTIC

/datum/injury/divine/condemned/mechanical
	stages = list(
		"condemned flesh" = 50,
		"healing condemned flesh" = 20,
		"condemnation scar" = 0
	)
	required_status = BODYPART_ROBOTIC
