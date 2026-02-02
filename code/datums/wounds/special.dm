/datum/wound/facial
	name = "facial trauma"
	sound_effect = 'sound/combat/crit.ogg'
	severity = WOUND_SEVERITY_SEVERE
	whp = null
	woundpain = 10
	can_sew = TRUE
	sewn_bleed_rate = 0
	can_cauterize = FALSE
	critical = FALSE

/datum/wound/facial/can_stack_with(datum/wound/other)
	if(istype(other, /datum/wound/facial) && (type == other.type))
		return FALSE
	return TRUE

/datum/wound/facial/ears
	name = "tympanosectomy"
	check_name = "<span class='danger'>EARS</span>"
	crit_message = list(
		"The eardrums are gored!",
		"The eardrums are ruptured!",
	)
	woundpain = 50
	bleed_rate = 8
	can_cauterize = TRUE
	critical = TRUE

/datum/wound/facial/ears/can_apply_to_mob(mob/living/affected)
	. = ..()
	if(!.)
		return
	return affected.getorganslot(ORGAN_SLOT_EARS)

/datum/wound/facial/ears/on_mob_gain(mob/living/affected)
	. = ..()
	affected.Stun(10)
	var/obj/item/organ/ears/ears = affected.getorganslot(ORGAN_SLOT_EARS)
	if(ears)
		ears.Remove(affected)
		ears.forceMove(affected.drop_location())

/datum/wound/facial/eyes
	name = "eye evisceration"
	check_name = "<span class='warning'>EYE</span>"
	crit_message = list(
		"The eye is poked!",
		"The eye is gouged!",
		"The eye is destroyed!",
	)
	woundpain = 30
	bleed_rate = 8
	can_cauterize = FALSE
	critical = TRUE

/datum/wound/facial/eyes/can_apply_to_mob(mob/living/affected)
	. = ..()
	if(!.)
		return
	return affected.getorganslot(ORGAN_SLOT_EYES)

/datum/wound/facial/eyes/on_mob_gain(mob/living/affected)
	. = ..()
	affected.Stun(10)
	affected.adjust_temp_blindness(10 SECONDS)

/datum/wound/facial/eyes/right
	name = "right eye evisceration"
	check_name = "<span class='danger'>RIGHT EYE</span>"
	crit_message = list(
		"The right eye is poked!",
		"The right eye is gouged!",
		"The right eye is destroyed!",
	)

/datum/wound/facial/eyes/right/can_stack_with(datum/wound/other)
	if(istype(other, /datum/wound/facial/eyes/right))
		return FALSE
	return TRUE

/datum/wound/facial/eyes/right/on_mob_gain(mob/living/affected)
	. = ..()
	ADD_TRAIT(affected, TRAIT_CYCLOPS_RIGHT, "[type]")
	affected.update_fov_angles()
	if(affected.has_wound(/datum/wound/facial/eyes/left) && affected.has_wound(/datum/wound/facial/eyes/right))
		var/obj/item/organ/my_eyes = affected.getorganslot(ORGAN_SLOT_EYES)
		if(my_eyes)
			my_eyes.Remove(affected)
			my_eyes.forceMove(affected.drop_location())

/datum/wound/facial/eyes/right/on_mob_loss(mob/living/affected)
	. = ..()
	REMOVE_TRAIT(affected, TRAIT_CYCLOPS_RIGHT, "[type]")
	affected.update_fov_angles()

/datum/wound/facial/eyes/right/permanent
	show_in_book = FALSE
	whp = null
	woundpain = 0
	bleed_rate = 0
	can_sew = FALSE

/datum/wound/facial/eyes/left
	name = "left eye evisceration"
	check_name = "<span class='danger'>LEFT EYE</span>"
	crit_message = list(
		"The left eye is poked!",
		"The left eye is gouged!",
		"The left eye is destroyed!",
	)

/datum/wound/facial/eyes/left/can_stack_with(datum/wound/other)
	if(istype(other, /datum/wound/facial/eyes/left))
		return FALSE
	return TRUE

/datum/wound/facial/eyes/left/on_mob_gain(mob/living/affected)
	. = ..()
	ADD_TRAIT(affected, TRAIT_CYCLOPS_LEFT, "[type]")
	affected.update_fov_angles()
	if(affected.has_wound(/datum/wound/facial/eyes/left) && affected.has_wound(/datum/wound/facial/eyes/right))
		var/obj/item/organ/my_eyes = affected.getorganslot(ORGAN_SLOT_EYES)
		if(my_eyes)
			my_eyes.Remove(affected)
			my_eyes.forceMove(affected.drop_location())

/datum/wound/facial/eyes/left/on_mob_loss(mob/living/affected)
	. = ..()
	REMOVE_TRAIT(affected, TRAIT_CYCLOPS_LEFT, "[type]")
	affected.update_fov_angles()

/datum/wound/facial/eyes/left/permanent
	show_in_book = FALSE
	whp = null
	woundpain = 0
	bleed_rate = 0
	can_sew = FALSE

/datum/wound/facial/tongue
	name = "glossectomy"
	check_name = "<span class='danger'>TONGUE</span>"
	crit_message = list(
		"The tongue is cut!",
		"The tongue is severed!",
		"The tongue flies off in an arc!"
	)
	woundpain = 8
	bleed_rate = 10
	can_cauterize = FALSE
	critical = TRUE
	var/permanent = FALSE

/datum/wound/facial/tongue/can_apply_to_mob(mob/living/affected)
	. = ..()
	if(!.)
		return
	return affected.getorganslot(ORGAN_SLOT_TONGUE)

/datum/wound/facial/tongue/on_mob_gain(mob/living/affected)
	. = ..()
	affected.Stun(10)
	var/obj/item/organ/tongue/tongue_loss = affected.getorganslot(ORGAN_SLOT_TONGUE)
	if(tongue_loss)
		tongue_loss.Remove(affected)
		if(permanent)
			qdel(tongue_loss)
		else
			tongue_loss.forceMove(affected.drop_location())

/datum/wound/facial/tongue/permanent
	show_in_book = FALSE
	whp = null
	woundpain = 0
	bleed_rate = 0
	can_sew = FALSE
	permanent = TRUE

/datum/wound/facial/disfigurement
	name = "disfigurement"
	check_name = "<span class='warning'>FACE</span>"
	severity = 0
	crit_message = "The face is mangled beyond recognition!"
	whp = null
	woundpain = 20
	mob_overlay = "cut"
	can_sew = FALSE
	can_cauterize = FALSE
	critical = TRUE

/datum/wound/facial/disfigurement/on_mob_gain(mob/living/affected)
	. = ..()
	ADD_TRAIT(affected, TRAIT_DISFIGURED, "[type]")

/datum/wound/facial/disfigurement/on_mob_loss(mob/living/affected)
	. = ..()
	REMOVE_TRAIT(affected, TRAIT_DISFIGURED, "[type]")

/datum/wound/facial/disfigurement/nose
	name = "rhinotomy"
	check_name = "<span class='warning'>NOSE</span>"
	crit_message = list(
		"The nose is mangled beyond recognition!",
		"The nose is destroyed!",
	)
	mortal = TRUE

/datum/wound/facial/disfigurement/nose/on_mob_gain(mob/living/affected)
	. = ..()
	ADD_TRAIT(affected, TRAIT_MISSING_NOSE, "[type]")

/datum/wound/facial/disfigurement/nose/on_mob_loss(mob/living/affected)
	. = ..()
	REMOVE_TRAIT(affected, TRAIT_MISSING_NOSE, "[type]")

/datum/wound/cbt
	name = "testicular torsion"
	check_name = "<span class='userdanger'><B>NUTCRACK</B></span>"
	crit_message = list(
		"The testicles are twisted!",
		"The testicles are torsioned!",
	)
	whp = 50
	woundpain = 100
	mob_overlay = ""
	can_sew = FALSE
	can_cauterize = FALSE
	disabling = TRUE
	critical = TRUE
	mortal = TRUE

/datum/wound/cbt/can_stack_with(datum/wound/other)
	if(istype(other, /datum/wound/cbt))
		return FALSE
	return TRUE

/datum/wound/cbt/on_mob_gain(mob/living/affected)
	. = ..()
	affected.emote("groin", forced = TRUE)
	affected.Stun(20)
	to_chat(affected, "<span class='userdanger'>Something twists inside my groin!</span>")
	if(affected.gender != MALE)
		name = "ovarian torsion"
		check_name = "<span class='userdanger'><B>EGGCRACK</B></span>"
		crit_message = list(
			"The ovaries are twisted!",
			"The ovaries are torsioned!",
		)
	else
		name = "testicular torsion"
		check_name = "<span class='userdanger'><B>NUTCRACK</B></span>"
		crit_message = list(
			"The testicles are twisted!",
			"The testicles are torsioned!",
		)

/datum/wound/cbt/on_life()
	. = ..()
	if(!iscarbon(owner))
		return
	var/mob/living/carbon/carbon_owner = owner
	if(!carbon_owner.stat && prob(7))
		carbon_owner.vomit(1, stun = TRUE)

/datum/wound/cbt/permanent
	name = "testicular evisceration"
	crit_message = list(
		"The testicles are destroyed!",
		"The testicles are eviscerated!",
	)
	whp = null

/datum/wound/cbt/permanent/on_mob_gain(mob/living/affected)
	. = ..()
	if(affected.gender != MALE)
		name = "ovarian evisceration"
		check_name = "<span class='userdanger'><B>EGGCRACK</B></span>"
		crit_message = list(
			"The ovaries are destroyed!",
			"The ovaries are eviscerated!",
		)
	else
		name = "testicular evisceration"
		check_name = "<span class='userdanger'><B>NUTCRACK</B></span>"
		crit_message = list(
			"The testicles are destroyed!",
			"The testicles are eviscerated!",
		)

/datum/wound/scarring
	name = "permanent scarring"
	check_name = "<span class='userdanger'><B>SCARRED</B></span>"
	severity = WOUND_SEVERITY_SEVERE
	crit_message = list(
		"The whiplash cuts deep!",
		"The tissue is irreversibly rended!",
		"The %BODYPART is thoroughly disfigured!",
	)
	sound_effect = 'sound/combat/crit.ogg'
	whp = 80
	woundpain = 30
	can_sew = FALSE
	can_cauterize = FALSE
	disabling = TRUE
	critical = TRUE
	sleep_healing = 0
	var/gain_emote = "paincrit"

/datum/wound/scarring/on_mob_gain(mob/living/affected)
	. = ..()
	affected.emote("scream", TRUE)
	affected.Slowdown(20)
	shake_camera(affected, 2, 2)

/datum/wound/scarring/can_stack_with(datum/wound/other)
	if(istype(other, /datum/wound/scarring))
		return FALSE
	return TRUE
