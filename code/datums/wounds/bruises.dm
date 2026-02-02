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

// Bruise dynamic wounds
// Vaguely: Hella painful. No bleeding until severe. No armor interactions. Every hit also increases its self heal by a little bit.
/datum/wound/dynamic/bruise
	name = "hematoma"
	whp = 5
	bleed_rate = 0
	clotting_rate = null
	clotting_threshold = null
	sewn_clotting_threshold = null
	woundpain = 5
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

	severity_names = list(
		"small" = 10,
		"large" = 35,
		"unbearable" = 55,
		"agonising" = 80,
		"deadly" = 120,
	)
	upgrade_whp = 1
	upgrade_pain = 1

	var/upgrade_heal = 0.4

// :(
/datum/wound/dynamic/bruise/update_name()
	var/prefix
	for(var/sevname in severity_names)
		if(severity_names[sevname] <= woundpain)
			prefix = sevname
	name = "[prefix ? "[prefix] " : ""][initial(name)]"

// Woundpain limit makes it actually a threat
// Wish we had internal bleeding proper
/datum/wound/dynamic/maxed_check()
	if(woundpain < 120)
		return FALSE
	sleep_healing = passive_healing
	passive_healing = 0
	bleed_rate += 1.2
	update_name()
	return TRUE

/datum/wound/dynamic/bruise/upgrade(bclass, damage)
	. = ..()
	if(!.)
		return

	passive_healing = max(passive_healing + upgrade_heal, 8)

	// Enable bleeds
	if(!upgrade_bleed_rate && woundpain >= 55)
		upgrade_bleed_rate = 0.03
		bleed_rate += damage * upgrade_bleed_rate
		clotting_rate = 0.02
		clotting_threshold = 0.3

	return TRUE

/datum/wound/dynamic/bruise/downgrade(multiplier)
	return // Already self heal and aren't as dangerous
