/obj/item/organ/artery/r_arm
	name = "right brachial arteries"
	zone = BODY_ZONE_R_ARM
	blood_flow = ARTERIAL_BLOOD_FLOW * 0.75

/obj/item/organ/artery/r_leg
	name = "right femoral arteries"
	zone = BODY_ZONE_R_LEG

/obj/item/organ/artery/mouth
	name = "facial arteries"
	zone = BODY_ZONE_PRECISE_MOUTH

/obj/item/organ/artery/l_leg
	name = "left femoral arteries"
	zone = BODY_ZONE_L_LEG

/obj/item/organ/artery/l_arm
	name = "left brachial arteries"
	zone = BODY_ZONE_L_ARM
	blood_flow = ARTERIAL_BLOOD_FLOW * 0.75

/obj/item/organ/artery/head
	name = "temporal arteries"
	desc = "Well, this one was certainly temporal."
	zone = BODY_ZONE_HEAD

/obj/item/organ/artery/chest
	name = "intercostal arteries"
	desc = "These run along the spaces between ribs."
	zone = BODY_ZONE_CHEST
	blood_flow = ARTERIAL_BLOOD_FLOW * 0.4

/obj/item/organ/artery/heart
	name = "thoracic aorta"
	desc = "Shot through the heart, and you're to blame - Darlin', you give love a bad name."
	zone = BODY_ZONE_CHEST
	blood_flow = ARTERIAL_BLOOD_FLOW * 2.5
	crit_weakness_lethal = TRUE

/obj/item/organ/artery/heart/tear()
	. = ..()
	owner.vomit(blood = TRUE)
	var/static/list/heartaches = list(
		"OOHHHH MY HEART!",
		"MY HEART! IT HURTS!",
		"I AM DYING!",
		"MY HEART IS TORN!",
		"MY HEART IS BLEEDING!",
	)
	to_chat(owner, span_userdanger("[pick(heartaches)]"))

/obj/item/organ/artery/heart/dissect()
	. = ..()
	owner.vomit(blood = TRUE)
	var/static/list/heartaches = list(
		"OOHHHH MY HEART!",
		"MY HEART! IT HURTS!",
		"I AM DYING!",
		"MY HEART IS TORN!",
		"MY HEART IS BLEEDING!",
	)
	to_chat(owner, span_userdanger("[pick(heartaches)]"))

/obj/item/organ/artery/neck
	name = "carotid artery"
	zone = BODY_ZONE_PRECISE_NECK
	blood_flow = ARTERIAL_BLOOD_FLOW * 2
	crit_weakness_lethal = TRUE

/obj/item/organ/artery/neck/mend()
	. = ..()
	REMOVE_TRAIT(owner, TRAIT_GARGLE_SPEECH, "[type]")

/obj/item/organ/artery/neck/dissect()
	. = ..()
	ADD_TRAIT(owner, TRAIT_GARGLE_SPEECH, "[type]")

/obj/item/organ/artery/neck/tear()
	. = ..()
	ADD_TRAIT(owner, TRAIT_GARGLE_SPEECH, "[type]")
