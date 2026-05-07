/datum/wound/bruise
	name = "hematoma"
	whp = 30
	bleed_rate = 0
	clotting_threshold = null
	sewn_clotting_threshold = null
	woundpain = 13
	sew_threshold = 50
	can_sew = FALSE
	can_cauterize = FALSE
	passive_healing = 0.5

	associated_bclasses = list(
		BCLASS_BLUNT,
		BCLASS_SMASH,
		BCLASS_PUNCH,
		BCLASS_TWIST,
	)
	can_roll = FALSE

/datum/wound/bruise/can_apply_to_bodypart(obj/item/bodypart/affected)
	. = ..()
	if(affected.status == BODYPART_ROBOTIC)
		return FALSE

/datum/wound/bruise/small
	name = "bruise"
	whp = 15
	woundpain = 8
	sew_threshold = 25

/datum/wound/bruise/large
	name = "massive hematoma"
	whp = 40
	bleed_rate = 0.9
	clotting_rate = 0.02
	clotting_threshold = 0.3
	sew_threshold = 75
	woundpain = 25
