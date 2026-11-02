
/obj/item/reagent_containers/glass
	name = "glass"
	amount_per_transfer_from_this = 10
	possible_transfer_amounts = list(5, 10, 15, 20, 25, 30, 50)
	volume = 50
	sellprice = 1
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

/obj/item/reagent_containers/glass/on_offer(mob/living/offerer, mob/living/offered_to)
	if(!reagents || reagents.maximum_volume <= 0)
		return FALSE

	var/obj/item/reagent_containers/glass/offered_item_other = offered_to.offered_item_ref?.resolve()
	if(isnull(offered_item_other) || !istype(offered_item_other) || !offered_item_other.reagents || offered_item_other.reagents.maximum_volume <= 0)
		return FALSE

	playsound(offerer, reagents.maximum_volume > 50 ? 'sound/misc/clink_drink_big.ogg' : 'sound/misc/clink_drink.ogg', 100, TRUE)
	addtimer(CALLBACK(offerer, TYPE_PROC_REF(/mob/living, stop_offering_item)), 0.6 SECONDS)
	addtimer(CALLBACK(offered_to, TYPE_PROC_REF(/mob/living, stop_offering_item)), 0.6 SECONDS)

	offerer.visible_message(
		span_notice("[offerer] clinks [src] with [offered_to]!"), \
		span_notice("I clink [src] with [offered_to]!"), \
		vision_distance = COMBAT_MESSAGE_RANGE, \
		ignored_mobs = list(offered_to)
	)
	to_chat(offered_to, span_notice("[offerer] clinks [src] with me!"))
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
