/datum/wound/fracture
	name = "fracture"
	check_name = "<span class='bone'><B>FRACTURE</B></span>"
	severity = WOUND_SEVERITY_SEVERE
	crit_message = list(
		"The bone shatters!",
		"The bone is broken!",
		"The %BODYPART is mauled!",
		"The bone snaps through the skin!",
	)
	sound_effect = "wetbreak"
	whp = 40
	woundpain = 60
	mob_overlay = "frac"
	can_sew = FALSE
	can_cauterize = FALSE
	disabling = TRUE
	critical = TRUE
	sleep_healing = 0 // no sleep healing that is dumb

	// Limbs hemorrhage but clot quickly
	// Lose 164.3 blood over 19 ticks then clot
	bleed_rate = 16.3
	clotting_threshold = 0.6
	clotting_rate = 0.85

	var/set_bleed_rate = 0.5

	ignore_bloody = TRUE

	werewolf_infection_probability = 0
	/// Whether or not we can be surgically set
	var/can_set = TRUE
	/// Emote we use when applied
	var/gain_emote = "paincrit"

/datum/wound/fracture/get_visible_name(mob/user)
	. = ..()
	if(passive_healing)
		. += " <span class='green'>(set)</span>"

/datum/wound/fracture/can_stack_with(datum/wound/other)
	if(istype(other, /datum/wound/fracture) && (type == other.type))
		return FALSE
	return TRUE

/datum/wound/fracture/on_mob_gain(mob/living/affected)
	. = ..()
	if(gain_emote)
		affected.emote(gain_emote, TRUE)
	affected.Slowdown(20)
	shake_camera(affected, 2, 2)

/datum/wound/fracture/proc/set_bone()
	if(!can_set)
		return FALSE
	bleed_rate = set_bleed_rate
	sleep_healing = max(sleep_healing, 1)
	passive_healing = max(passive_healing, 1)
	heal_wound(initial(whp)/1.6) //heal a little more than of maximum fracture
	can_set = FALSE
	return TRUE

/datum/wound/fracture/head
	name = "compound cranial fracture"
	check_name = "<span class='bone'><B>SKULLCRACK</B></span>"
	crit_message = list(
		"The skull shatters in a gruesome way!",
		"The head is smashed!",
		"The skull is broken!",
		"The skull caves in!",
	)
	sound_effect = "headcrush"
	whp = 80
	bleed_rate = 3.2
	clotting_threshold = null

	mortal = TRUE
	/// Brain case fractures (Depressed Cranium, Temporal) cause paralysis
	var/paralysis = FALSE
	var/knockout = 15 SECONDS

/datum/wound/fracture/head/on_mob_gain(mob/living/affected)
	. = ..()
	if(knockout)
		affected.Unconscious(knockout)
	ADD_TRAIT(affected, TRAIT_DISFIGURED, "[type]")
	if(paralysis)
		ADD_TRAIT(affected, TRAIT_NO_BITE, "[type]")
		ADD_TRAIT(affected, TRAIT_PARALYSIS, "[type]")
		ADD_TRAIT(affected, TRAIT_GARGLE_SPEECH, "[type]")
		ADD_TRAIT(affected, TRAIT_DEAF, "[type]")
		ADD_TRAIT(affected, TRAIT_NOPAIN, "[type]")
		affected.become_nearsighted("[type]")

/datum/wound/fracture/head/on_mob_loss(mob/living/affected)
	. = ..()
	REMOVE_TRAIT(affected, TRAIT_DISFIGURED, "[type]")
	if(paralysis)
		REMOVE_TRAIT(affected, TRAIT_NO_BITE, "[type]")
		REMOVE_TRAIT(affected, TRAIT_PARALYSIS, "[type]")
		REMOVE_TRAIT(affected, TRAIT_GARGLE_SPEECH, "[type]")
		REMOVE_TRAIT(affected, TRAIT_DEAF, "[type]")
		REMOVE_TRAIT(affected, TRAIT_NOPAIN, "[type]")
		affected.cure_nearsighted("[type]")

/datum/wound/fracture/head/on_life()
	. = ..()
	if(owner)
		owner.stuttering = max(owner.stuttering, 5)

/datum/wound/fracture/head/brain
	name = "depressed cranial fracture"
	severity = WOUND_SEVERITY_FATAL
	crit_message = list(
		"The cranium is fractured!",
		"The cranium is cracked!",
		"The cranium is shattered!",
	)
	whp = 150
	bleed_rate = 4.6
	paralysis = TRUE
	knockout = 25 SECONDS

/datum/wound/fracture/head/brain/on_life()
	. = ..()
	owner.adjustOxyLoss(2.5)
	if(HAS_TRAIT(owner, TRAIT_ROTMAN)) // brain crit kills deadites
		owner.death()

/datum/wound/fracture/head/eyes
	name = "orbital fracture"
	crit_message = list(
		"The orbital bone is fractured!",
		"The orbital bone is cracked!",
	)

/datum/wound/fracture/head/eyes/on_mob_gain(mob/living/affected)
	. = ..()
	affected.adjust_temp_blindness(15 SECONDS)
	affected.become_nearsighted("[type]")

/datum/wound/fracture/head/eyes/on_mob_loss(mob/living/affected)
	. = ..()
	affected.cure_nearsighted("[type]")

/datum/wound/fracture/head/ears
	name = "depressed temporal fracture"
	severity = WOUND_SEVERITY_FATAL
	crit_message = list(
		"The temporal bone is fractured!",
		"The temporal bone is cracked!",
	)
	paralysis = TRUE
	knockout = 25 SECONDS

/datum/wound/fracture/head/nose
	name = "nasal fracture"
	crit_message = list(
		"The nasal bone is fractured!",
		"The nasal bone is shattered!",
	)
	mortal = FALSE
	knockout = 10 SECONDS

/datum/wound/fracture/head/nose/on_mob_gain(mob/living/affected)
	. = ..()
	ADD_TRAIT(affected, TRAIT_MISSING_NOSE, "[type]")

/datum/wound/fracture/head/nose/on_mob_loss(mob/living/affected)
	. = ..()
	REMOVE_TRAIT(affected, TRAIT_MISSING_NOSE, "[type]")

/datum/wound/fracture/mouth
	name = "mandibular fracture"
	check_name = "<span class='bone'>JAW FRACTURE</span>"
	crit_message = list(
		"The mandible comes apart beautifully!",
		"The jaw is smashed!",
		"The jaw is shattered!",
		"The jaw caves in!",
	)
	whp = 50

	bleed_rate = 1.6
	clotting_threshold = 0.4
	clotting_rate = 0.04

/datum/wound/fracture/mouth/on_mob_gain(mob/living/affected)
	. = ..()
	ADD_TRAIT(affected, TRAIT_NO_BITE, "[type]")
	ADD_TRAIT(affected, TRAIT_GARGLE_SPEECH, "[type]")

/datum/wound/fracture/mouth/on_mob_loss(mob/living/affected)
	. = ..()
	REMOVE_TRAIT(affected, TRAIT_NO_BITE, "[type]")
	REMOVE_TRAIT(affected, TRAIT_GARGLE_SPEECH, "[type]")

/datum/wound/fracture/neck
	name = "cervical fracture"
	check_name = "<span class='bone'><B>NECK</B></span>"
	crit_message = list(
		"The spine shatters in a spectacular way!",
		"The spine snaps!",
		"The spine cracks!",
		"The spine is broken!",
	)
	whp = 150
	mortal = TRUE

/datum/wound/fracture/neck/can_apply_to_mob(mob/living/affected)
	if(QDELETED(affected) || istype(affected, /mob/living/carbon/human/species/skeleton/death_arena))
		return FALSE
	. = ..()

/datum/wound/fracture/neck/on_mob_gain(mob/living/affected)
	. = ..()
	ADD_TRAIT(affected, TRAIT_PARALYSIS, "[type]")
	ADD_TRAIT(affected, TRAIT_NOPAIN, "[type]")

/datum/wound/fracture/neck/on_mob_loss(mob/living/affected)
	. = ..()
	REMOVE_TRAIT(affected, TRAIT_PARALYSIS, "[type]")
	REMOVE_TRAIT(affected, TRAIT_NOPAIN, "[type]")

/datum/wound/fracture/neck/on_life()
	. = ..()
	owner.adjustOxyLoss(2.5)

/datum/wound/fracture/chest
	name = "rib fracture"
	check_name = "<span class='bone'><B>RIBS</B></span>"
	crit_message = list(
		"The ribs shatter in a splendid way!",
		"The ribs are smashed!",
		"The ribs are mauled!",
		"The ribcage caves in!",
	)
	whp = 50
	// Lose 224.6 blood over 18 ticks then clot
	bleed_rate = 23.1
	clotting_threshold = 0.8
	clotting_rate = 1.25

/datum/wound/fracture/chest/on_mob_gain(mob/living/affected)
	. = ..()
	affected.Immobilize(15)

/datum/wound/fracture/groin
	name = "pelvic fracture"
	check_name = "<span class='bone'><B>PELVIS</B></span>"
	crit_message = list(
		"The pelvis shatters in a magnificent way!",
		"The pelvis is smashed!",
		"The pelvis is mauled!",
		"The pelvic floor caves in!",
	)
	whp = 50
	gain_emote = "groin"
	bleed_rate = 3.1
	clotting_threshold = 1.2
	clotting_rate = 0.04

/datum/wound/fracture/groin/on_mob_gain(mob/living/affected)
	. = ..()
	affected.Immobilize(15)
	ADD_TRAIT(affected, TRAIT_PARALYSIS_R_LEG, "[type]")
	ADD_TRAIT(affected, TRAIT_PARALYSIS_L_LEG, "[type]")

/datum/wound/fracture/groin/on_mob_loss(mob/living/affected)
	. = ..()
	REMOVE_TRAIT(affected, TRAIT_PARALYSIS_R_LEG, "[type]")
	REMOVE_TRAIT(affected, TRAIT_PARALYSIS_L_LEG, "[type]")
