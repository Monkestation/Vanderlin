/datum/wound/puncture
	name = "puncture"
	whp = 40
	sewn_whp = 20
	bleed_rate = 0.8
	sewn_bleed_rate = 0.04
	clotting_rate = 0.01
	sewn_clotting_rate = 0.01
	clotting_threshold = 0.2
	sewn_clotting_threshold = 0.1
	woundpain = 6
	sewn_woundpain = 3
	sew_threshold = 75
	mob_overlay = "cut"
	can_sew = TRUE
	can_cauterize = TRUE
	associated_bclasses = list(BCLASS_STAB)
	can_roll = FALSE

/datum/wound/puncture/can_apply_to_bodypart(obj/item/bodypart/affected)
	. = ..()
	if(affected.status == BODYPART_ROBOTIC)
		return FALSE

/datum/wound/puncture/small
	name = "small puncture"
	whp = 20
	sewn_whp = 10
	bleed_rate = 0.4
	sewn_bleed_rate = 0.02
	clotting_rate = 0.01
	sewn_clotting_rate = 0.01
	clotting_threshold = 0.1
	sewn_clotting_threshold = 0.1
	woundpain = 3
	sewn_woundpain = 1
	sew_threshold = 35

/datum/wound/puncture/large
	name = "gaping puncture"
	whp = 40
	sewn_whp = 20
	bleed_rate = 2
	sewn_bleed_rate = 0.1
	clotting_rate = 0.01
	sewn_clotting_rate = 0.01
	clotting_threshold = 0.5
	sewn_clotting_threshold = 0.25
	woundpain = 15
	sewn_woundpain = 8
	sew_threshold = 100

/datum/wound/puncture/drilling
	name = "drilling"
	check_name = "<span class='bloody'><B>DRILLING</B></span>"
	severity = WOUND_SEVERITY_SUPERFICIAL
	whp = 40
	sewn_whp = 20
	bleed_rate = 2
	sewn_bleed_rate = 0.1
	clotting_rate = null
	clotting_threshold = null
	woundpain = 15
	sewn_woundpain = 8
	sew_threshold = 100
	passive_healing = 0
	sleep_healing = 0

/datum/wound/puncture/drilling/sew_wound()
	qdel(src)
	return TRUE

/datum/wound/puncture/drilling/cauterize_wound()
	qdel(src)
	return TRUE
