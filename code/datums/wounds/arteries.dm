/datum/wound/artery
	name = "severed artery"
	check_name = "<span class='artery'><B>ARTERY</B></span>"
	severity = WOUND_SEVERITY_CRITICAL
	crit_message = "Blood sprays from %VICTIM's %BODYPART!"
	sound_effect = 'sound/combat/crit.ogg'
	whp = 50
	sewn_whp = 20
	bleed_rate = ARTERY_LIMB_BLEEDRATE
	sewn_bleed_rate = 0.2
	clotting_threshold = null
	sewn_clotting_threshold = null
	woundpain = 35
	sewn_woundpain = 20
	mob_overlay = "s1"
	sewn_overlay = "cut"
	can_sew = TRUE
	can_cauterize = TRUE
	critical = TRUE
	sleep_healing = 0
	embed_chance = 0

	werewolf_infection_probability = 50

/datum/wound/artery/can_apply_to_bodypart(obj/item/bodypart/affected)
	. = ..()
	if(affected.status == BODYPART_ROBOTIC)
		return FALSE

/datum/wound/artery/can_stack_with(datum/wound/other)
	if(istype(other, /datum/wound/artery) && (type == other.type))
		return FALSE
	return TRUE

/datum/wound/artery/on_mob_gain(mob/living/affected)
	. = ..()
	affected.emote("paincrit", TRUE)
	affected.Slowdown(20)
	shake_camera(affected, 2, 2)

/datum/wound/artery/on_bodypart_gain(obj/item/bodypart/affected)
	. = ..()
	affected.temporary_crit_paralysis(10 SECONDS)

/datum/wound/artery/neck
	name = "torn carotid"
	check_name = "<span class='artery'><B>CAROTID</B></span>"
	crit_message = "Blood sprays from %VICTIM's throat!"
	severity = WOUND_SEVERITY_FATAL
	whp = 100
	sewn_whp = 25
	bleed_rate = 60
	sewn_bleed_rate = 0.5
	woundpain = 45
	sewn_woundpain = 20
	mob_overlay = "s1_throat"
	mortal = TRUE

/datum/wound/artery/neck/on_mob_gain(mob/living/affected)
	. = ..()
	ADD_TRAIT(affected, TRAIT_GARGLE_SPEECH, "[type]")
	if(HAS_TRAIT(affected, TRAIT_CRITICAL_WEAKNESS))
		affected.death()

/datum/wound/artery/neck/on_mob_loss(mob/living/affected)
	. = ..()
	REMOVE_TRAIT(affected, TRAIT_GARGLE_SPEECH, "[type]")

/datum/wound/artery/chest
	name = "aortic dissection"
	check_name = "<span class='artery'><B>AORTA</B></span>"
	crit_message = "A tide of blood gushes from %VICTIM's chest!"
	severity = WOUND_SEVERITY_FATAL
	whp = 100
	sewn_whp = 35
	bleed_rate = 60
	sewn_bleed_rate = 0.8
	woundpain = 80
	sewn_woundpain = 50
	mortal = TRUE

/datum/wound/artery/chest/on_mob_gain(mob/living/affected)
	. = ..()
	if(iscarbon(affected))
		var/mob/living/carbon/carbon_affected = affected
		carbon_affected.vomit(blood = TRUE)
	var/static/list/heartaches = list(
		"OOHHHH MY HEART!",
		"MY HEART! IT HURTS!",
		"I AM DYING!",
		"MY HEART IS TORN!",
		"MY HEART IS BLEEDING!",
	)
	to_chat(affected, "<span class='userdanger'>[pick(heartaches)]</span>")

/datum/wound/artery/chest/on_life()
	. = ..()
	if(!iscarbon(owner))
		return
	var/mob/living/carbon/carbon_owner = owner
	if(!carbon_owner.stat && prob(10))
		carbon_owner.vomit(1, blood = TRUE, stun = TRUE)

/datum/wound/artery/reattachment
	name = "replantation"
	check_name = "<span class='artery'><B>UNSEWN</B></span>"
	severity = WOUND_SEVERITY_FATAL
	whp = 100
	sewn_whp = 25
	bleed_rate = 50
	sewn_bleed_rate = 0.5
	woundpain = 60
	sewn_woundpain = 30
	disabling = TRUE
