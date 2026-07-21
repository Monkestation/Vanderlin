/datum/action/cooldown/spell/undirected/conjure_item/fire_vial
	name = "Fire Vial"
	desc = "Pull a small vial of caustic compounds from a pocket."
	button_icon_state = "acidsplash"


	cooldown_time = 4 MINUTES
	invocation_type = INVOCATION_NONE
	associated_skill = /datum/attribute/skill/craft/alchemy
	item_type = /obj/item/reagent_containers/glass/bottle/vial/firevial
	item_duration = 20 SECONDS
	item_outline ="#fa1a1a"
	delete_old = TRUE
	spell_type = SPELL_STAMINA
	spell_cost = 50


/datum/reagent/poison/evilburnjuice
	name = "Firewater"
	description = "A highly concentrated wine addative - a rare, expensive delicacy in some select parts of the realm, made from fyritius, wormwood, and other botanicals. It is always watered down."
	reagent_state = LIQUID
	color = "#ff2d2d"
	taste_description = "liquid pain"
	scent_description = "the burning fire of hells"
	harmful = TRUE

/datum/reagent/poison/evilburnjuice/expose_mob(mob/living/exposed_mob, methods, reac_volume, show_message, touch_protection)
	. = ..()
	if(methods & (TOUCH|VAPOR))
		exposed_mob.adjustFireLoss(reac_volume * 1.5, 0)
		exposed_mob.IgniteMob()
		exposed_mob.adjust_fire_stacks(2)
		exposed_mob.emote("agony", forced = TRUE)
		exposed_mob.set_eye_blur_if_lower(5 SECONDS)
		if(show_message)
			exposed_mob.visible_message(span_danger("[exposed_mob]'s skin bursts into flames! OH GODS!"), span_userdanger("!!!OH MY GODS IT BURNS!!!"))

// Poisoning is incredibly funny and, as much as i want this to be super mega deadly, you can very well spam this over the course of an hour.

/datum/reagent/poison/evilburnjuice/on_mob_life(mob/living/carbon/M, efficiency)
	M.adjustFireLoss(2 * REM * efficiency, 0)
	M.adjust_fire_stacks(2)
	M.IgniteMob()
	. = ..()


/obj/item/reagent_containers/glass/bottle/vial/firevial
	list_reagents = list(/datum/reagent/poison/evilburnjuice = 10)
