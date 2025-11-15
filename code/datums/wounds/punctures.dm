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

// Puncture (Stab -- not Pick) Omniwounds
// Vaguely: Not nearly as painful, higher bleed cap, easier to sew / heal.
/datum/wound/dynamic/puncture
	name = "puncture"
	whp = 1
	sewn_whp = 0
	bleed_rate = 1
	sewn_bleed_rate = 0.04
	clotting_rate = 0.01
	sewn_clotting_rate = 0.01
	clotting_threshold = 0.2
	sewn_clotting_threshold = 0.1
	sew_threshold = 20
	mob_overlay = "cut"
	can_sew = TRUE
	can_cauterize = TRUE
	associated_bclasses = list(BCLASS_STAB)

	severity_names = list(
		"shallow" = 3,
		"deep" = 6,
		"gnarly" = 9,
		"vicious" = 12,
		"lethal" = 20,
	)
	upgrade_bleed_rate = 0.5
	upgrade_bleed_clamp = 1.3
	upgrade_bleed_clamp_armor = 0.75
	upgrade_whp = 0.5
	upgrade_sew_threshold = 0.65
	upgrade_pain = 0.05
	protected_bleed_clamp = 6

// Gouge (Pick) dynamic wounds
// Vaguely: Not very painful, not very bleedy, but you can't cauterize them. You're still better off using stab every time.
// Addendum: This was made with the assumption that pick intent penetrates most armors (and being able to crit through them).
/datum/wound/dynamic/gouge
	name = "gouge"
	whp = 1
	sewn_whp = 0
	bleed_rate = 1
	sewn_bleed_rate = 0.04
	clotting_rate = 0.01
	sewn_clotting_rate = 0.01
	clotting_threshold = 0.2
	sewn_clotting_threshold = 0.1
	sew_threshold = 20
	mob_overlay = "cut"
	can_sew = TRUE
	can_cauterize = FALSE
	associated_bclasses = list(
		BCLASS_PICK,
		BCLASS_PIERCE,
		BCLASS_SHOT,
	)

	severity_names = list(
		"shallow" = 2,
		"deep" = 4,
		"gnarly" = 8,
		"vicious" = 12,
		"lethal" = 20,
	)
	upgrade_bleed_rate = 0.01
	upgrade_bleed_clamp = 0.5
	upgrade_whp = 1
	upgrade_sew_threshold = 0.3
	upgrade_pain = 0.01
	protected_bleed_clamp = 4
