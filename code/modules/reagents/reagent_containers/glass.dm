
/obj/item/reagent_containers/glass
	name = "glass"
	amount_per_transfer_from_this = 10
	possible_transfer_amounts = list(5, 10, 15, 20, 25, 30, 50)
	volume = 50
	reagent_flags = OPENCONTAINER
	spillable = TRUE
	possible_item_intents = list(INTENT_POUR, /datum/intent/fill, INTENT_SPLASH, INTENT_GENERIC)
	resistance_flags = ACID_PROOF

/obj/item/reagent_containers/glass/Initialize(mapload, vol)
	. = ..()
	AddComponent(/datum/component/liquids_interaction, TYPE_PROC_REF(/obj/item/reagent_containers/glass, attack_on_liquids_turf))

/obj/item/reagent_containers/glass/proc/attack_on_liquids_turf(obj/item/reagent_containers/my_beaker, turf/T, mob/living/user, obj/effect/abstract/liquid_turf/liquids)
	if(user.used_intent != /datum/intent/fill)
		return FALSE

	if(!my_beaker.spillable)
		return FALSE

	if(user.cmode)
		return FALSE

	if(liquids.fire_state) //Use an extinguisher first
		to_chat(user, span_danger("You can't scoop up anything while it's on fire!"))
		return FALSE

	if(liquids.liquid_group.expected_turf_height == 1)
		to_chat(user, span_danger("The puddle is too shallow to scoop anything up!"))
		return FALSE

	var/free_space = my_beaker.reagents.maximum_volume - my_beaker.reagents.total_volume
	if(free_space <= 0)
		to_chat(user, span_danger("You can't fit any more liquids inside [my_beaker]!"))
		return FALSE

	var/desired_transfer = my_beaker.amount_per_transfer_from_this
	if(desired_transfer > free_space)
		desired_transfer = free_space

	if(desired_transfer > liquids.liquid_group.reagents_per_turf)
		desired_transfer = liquids.liquid_group.reagents_per_turf

	liquids.liquid_group.trans_to_seperate_group(my_beaker.reagents, desired_transfer, liquids)
	to_chat(user, span_notice("You scoop up around [UNIT_FORM_STRING(round(desired_transfer))] of liquids with [my_beaker]."))
	user.changeNext_move(CLICK_CD_MELEE)

	return TRUE

/datum/intent/fill
	name = "fill"
	icon_state = "infill"
	chargetime = 0
	noaa = TRUE
	candodge = FALSE
	misscost = 0

/datum/intent/pour
	name = "feed"
	icon_state = "infeed"
	chargetime = 0
	noaa = TRUE
	candodge = FALSE
	misscost = 0

/datum/intent/splash
	name = "splash"
	icon_state = "insplash"
	chargetime = 0
	noaa = TRUE
	candodge = TRUE
	misscost = 0
	reach = 2

/datum/intent/soak
	name = "soak"
	icon_state = "insoak"
	chargetime = 0
	noaa = TRUE
	candodge = FALSE
	misscost = 0

/datum/intent/wring
	name = "wring"
	icon_state = "inwring"
	chargetime = 0
	noaa = TRUE
	candodge = FALSE
	misscost = 0
