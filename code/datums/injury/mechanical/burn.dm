/** MECHANICAL BURNS **/
/datum/injury/burn/moderate/mechanical
	stages = list(
		"ripped scorch" = 10,
		"moderate scorch" = 5,
		"healing moderate scorch" = 2,
		"fresh singe" = 0
		)
	required_status = BODYPART_ROBOTIC

/datum/injury/burn/large/mechanical
	stages = list(
		"ripped large scorch" = 20,
		"large scorch" = 15,
		"healing large scorch" = 5,
		"fresh singe" = 0
		)
	required_status = BODYPART_ROBOTIC

/datum/injury/burn/severe/mechanical
	stages = list(
		"ripped severe scorch" = 35,
		"severe scorch" = 30,
		"healing severe scorch" = 10,
		"singing" = 0
		)
	required_status = BODYPART_ROBOTIC

/datum/injury/burn/deep/mechanical
	stages = list(
		"ripped deep scorch" = 45,
		"deep scorch" = 40,
		"healing deep scorch" = 15,
		"large singing" = 0
		)
	required_status = BODYPART_ROBOTIC

/datum/injury/burn/carbonised/mechanical
	stages = list(
		"warped area" = 50,
		"healing warped area" = 20,
		"massive singing" = 0
		)
	required_status = BODYPART_ROBOTIC
