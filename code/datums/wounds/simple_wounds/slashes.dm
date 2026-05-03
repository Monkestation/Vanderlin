/datum/wound/slash
	name = "slash"
	whp = 30
	sewn_whp = 10
	bleed_rate = 0.8
	sewn_bleed_rate = 0.02
	clotting_rate = 0.02
	sewn_clotting_rate = 0.02
	clotting_threshold = 0.2
	sewn_clotting_threshold = 0.1
	woundpain = 8
	sewn_woundpain = 2
	sew_threshold = 50
	mob_overlay = "cut"
	can_sew = TRUE
	can_cauterize = TRUE
	associated_bclasses = list(BCLASS_CUT, BCLASS_CHOP)

/datum/wound/slash/can_apply_to_bodypart(obj/item/bodypart/affected)
	. = ..()
	if(affected.status == BODYPART_ROBOTIC)
		return FALSE

/datum/wound/slash/small
	name = "small slash"
	whp = 15
	sewn_whp = 5
	bleed_rate = 0.4
	sewn_bleed_rate = 0.01
	clotting_rate = 0.02
	sewn_clotting_rate = 0.02
	clotting_threshold = 0.1
	sewn_clotting_threshold = 0.05
	woundpain = 4
	sewn_woundpain = 1
	sew_threshold = 25

/datum/wound/slash/large
	name = "gruesome slash"
	whp = 40
	sewn_whp = 12
	bleed_rate = 2
	sewn_bleed_rate = 0.05
	clotting_rate = 0.02
	sewn_clotting_rate = 0.02
	clotting_threshold = 0.4
	sewn_clotting_threshold = 0.1
	woundpain = 15
	sewn_woundpain = 5
	sew_threshold = 75

/datum/wound/lashing
	name = "lashing"
	whp = 30
	sewn_whp = 12
	bleed_rate = 0.6
	sewn_bleed_rate = 0.02
	clotting_rate = 0.02
	sewn_clotting_rate = 0.02
	clotting_threshold = 0.2
	sewn_clotting_threshold = 0.1
	woundpain = 10
	sewn_woundpain = 4
	sew_threshold = 65
	can_sew = TRUE
	can_cauterize = TRUE
	associated_bclasses = list(BCLASS_LASHING)
	can_roll = FALSE

/datum/wound/lashing/small
	name = "superficial lashing"
	whp = 15
	sewn_whp = 5
	bleed_rate = 0.2
	sewn_bleed_rate = 0.01
	clotting_rate = 0.02
	sewn_clotting_rate = 0.02
	clotting_threshold = 0.1
	sewn_clotting_threshold = 0.05
	woundpain = 8
	sewn_woundpain = 2
	sew_threshold = 30

/datum/wound/lashing/large
	name = "excruciating lashing"
	whp = 45
	sewn_whp = 15
	bleed_rate = 1.2 //Intended for combat, might kill if used for punishment. Force can be controlled by not charging the whip lash fully.
	sewn_bleed_rate = 0.05
	clotting_rate = 0.02
	sewn_clotting_rate = 0.02
	clotting_threshold = 0.4
	sewn_clotting_threshold = 0.1
	woundpain = 22
	sewn_woundpain = 14
	sew_threshold = 95
