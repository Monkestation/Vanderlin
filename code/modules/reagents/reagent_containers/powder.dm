/obj/item/reagent_containers/powder
	name = "powder parent item. You should not be seeing this."
	desc = ""
	icon = 'icons/roguetown/items/produce.dmi'
	icon_state = "spice"
	item_state = "spice"
	possible_transfer_amounts = null
	volume = 15
	list_reagents = null
	sellprice = 10
	grid_height = 32
	grid_width = 32

/obj/item/reagent_containers/powder/canconsume(mob/eater, mob/user, silent)
	. = ..()
	if(!.)
		return
	if(user.zone_selected != BODY_ZONE_PRECISE_NOSE)
		to_chat(user, span_notice("\The [src] must be snorted."))
		return FALSE
	// Checked in parent for carbon
	var/mob/living/L = eater
	if(!L.can_smell())
		if(L == user)
			to_chat(user, span_warning("I can't use my nose!"))
		else
			to_chat(user, span_warning("[L.p_they(TRUE)] can't use [L.p_their()] nose!"))
		return FALSE
	return TRUE

/obj/item/reagent_containers/powder/throw_impact(atom/hit_atom, datum/thrownthing/thrownthing)
	. = ..()
	if(thrownthing?.target_zone != BODY_ZONE_PRECISE_NOSE)
		return
	if(iscarbon(hit_atom))
		var/mob/living/carbon/C = hit_atom
		if(canconsume(C, silent = TRUE))
			if(reagents.total_volume)
				playsound(C, 'sound/items/sniff.ogg', 100, FALSE)
				reagents.trans_to(C, 1, transfered_by = thrownthing.thrower, method = "swallow")
				qdel(src)

/obj/item/reagent_containers/powder/attack(mob/M, mob/user, list/modifiers)
	if(!canconsume(M, user))
		return FALSE
	if(M == user)
		M.visible_message(span_notice("[user] sniffs [src]."))
	else
		if(iscarbon(M))
			var/mob/living/carbon/C = M
			var/obj/item/bodypart/CH = C.get_bodypart(BODY_ZONE_HEAD)
			if(!CH)
				to_chat(user, span_warning("[C.p_theyre(TRUE)] missing their head."))
				return FALSE
			C.visible_message(span_danger("[user] attempts to force [C] to inhale [src]."), \
							span_danger("[user] attempts to force me to inhale [src]!"))
			if(C.cmode)
				if(!CH.grabbedby)
					to_chat(user, span_info("[C.p_they(TRUE)] steals [C.p_their()] face from it."))
					return FALSE
			if(!do_after(user, 1 SECONDS, M))
				return FALSE

	playsound(M, 'sound/items/sniff.ogg', 100, FALSE)

	if(reagents.total_volume)
		reagents.trans_to(M, reagents.total_volume, transfered_by = user, method = SNORT)
		SEND_SIGNAL(M, COMSIG_DRUG_SNIFFED, user)
		record_featured_stat(FEATURED_STATS_CRIMINALS, user)
		record_round_statistic(STATS_DRUGS_SNORTED)
	qdel(src)
	return TRUE

/obj/item/reagent_containers/powder/spice
	name = "spice"
	desc = "A potent powder that opens the mind to previously unseen possibilities..."
	icon = 'icons/roguetown/items/produce.dmi'
	icon_state = "spice"
	item_state = "spice"
	list_reagents = list(/datum/reagent/druqks = 15)
	sellprice = 16

/datum/reagent/druqks
	name = "Drukqs"
	description = ""
	taste_description = "something spicy"
	color = "#60A584" // rgb: 96, 165, 132
	overdose_threshold = 16
	metabolization_rate = 0.2

/atom/movable/screen/fullscreen/druqks
	icon_state = "spa"
	plane = FLOOR_PLANE
	layer = ABOVE_OPEN_TURF_LAYER
	blend_mode = 0
	show_when_dead = FALSE

/datum/reagent/druqks/on_mob_life(mob/living/carbon/M)
	SEND_SIGNAL(src, COMSIG_DRUG_INDULGE)
	M.set_drugginess(30 SECONDS)
	M.apply_status_effect(/datum/status_effect/buff/druqks)
	if(prob(5))
		if(M.gender == FEMALE)
			M.emote(pick("twitch_s","giggle"))
		else
			M.emote(pick("twitch_s","chuckle"))
	if(M.has_quirk(/datum/quirk/vice/junkie))
		M.sate_addiction(/datum/quirk/vice/junkie)
	..()

/datum/reagent/druqks/on_mob_metabolize(mob/living/M)
	M.overlay_fullscreen("druqk", /atom/movable/screen/fullscreen/druqks)
	M.set_drugginess(30 SECONDS)
	if(M.client)
		ADD_TRAIT(M, TRAIT_DRUQK, "based")
		M.refresh_looping_ambience()

/datum/reagent/druqks/on_mob_end_metabolize(mob/living/M)
	M.clear_fullscreen("druqk")
	M.set_drugginess(0)
	M.remove_status_effect(/datum/status_effect/buff/druqks)
	if(M.client)
		REMOVE_TRAIT(M, TRAIT_DRUQK, "based")
		M.refresh_looping_ambience()

/datum/reagent/druqks/overdose_process(mob/living/M)
	M.adjustOrganLoss(ORGAN_SLOT_BRAIN, 0.25*REM)
	M.adjustToxLoss(0.25*REM, 0)
	. = ..()

/datum/reagent/druqks/overdose_start(mob/living/M)
	M.visible_message(span_warning("Blood runs from [M]'s nose."))

/obj/item/reagent_containers/powder/ozium
	name = "ozium"
	desc = "A potent drug that causes a state of euphoria, but can also arrest breathing."
	icon = 'icons/roguetown/items/produce.dmi'
	icon_state = "ozium"
	list_reagents = list(/datum/reagent/ozium = 15)
	sellprice = 8

/datum/reagent/ozium
	name = "Ozium"
	description = ""
	taste_description = "a flash of white"
	color = "#60A584" // rgb: 96, 165, 132
	overdose_threshold = 16
	metabolization_rate = 0.2

/datum/reagent/ozium/on_mob_life(mob/living/carbon/M)
	SEND_SIGNAL(src, COMSIG_DRUG_INDULGE)
	if(M.has_quirk(/datum/quirk/vice/junkie))
		M.sate_addiction(/datum/quirk/vice/junkie)
	if(prob(5))
		M.flash_fullscreen("whiteflash")
	M.apply_status_effect(/datum/status_effect/buff/ozium)
	..()

/datum/reagent/ozium/overdose_process(mob/living/M)
	M.adjustToxLoss(0.25*REM, 0)
	. = ..()

/datum/reagent/ozium/overdose_start(mob/living/M)
	M.playsound_local(get_turf(M), 'sound/misc/heroin_rush.ogg', 100, FALSE)
	M.visible_message(span_warning("Blood runs from [M]'s nose."))

/obj/item/reagent_containers/powder/moondust
	name = "moondust"
	desc = "Derived from the skins of certain pallid goblins. Makes folk quick to act and anger."
	icon = 'icons/roguetown/items/produce.dmi'
	icon_state = "moondust"
	list_reagents = list(/datum/reagent/moondust = 15)
	sellprice = 16

/datum/reagent/moondust
	name = "Moondust"
	description = ""
	taste_description = "gunpowder"
	color = "#bfc3b5"
	overdose_threshold = 50
	metabolization_rate = 0.2

/datum/reagent/moondust/on_mob_metabolize(mob/living/M)
	animate(M.client, pixel_y = 1, time = 1, loop = -1, flags = ANIMATION_RELATIVE)
	animate(pixel_y = -1, time = 1, flags = ANIMATION_RELATIVE)

/datum/reagent/moondust/on_mob_end_metabolize(mob/living/M)
	M.remove_status_effect(/datum/status_effect/buff/moondust)
	animate(M.client)

/datum/reagent/moondust/on_mob_life(mob/living/carbon/M)
	SEND_SIGNAL(src, COMSIG_DRUG_INDULGE)
	if(M.has_reagent(/datum/reagent/moondust_purest))
		M.Sleeping(40, 0)
	if(M.has_quirk(/datum/quirk/vice/junkie))
		M.sate_addiction(/datum/quirk/vice/junkie)
	M.apply_status_effect(/datum/status_effect/buff/moondust)
	if(prob(2))
		M.flash_fullscreen("whiteflash")
	..()

/datum/reagent/moondust/overdose_process(mob/living/M)
	M.adjustToxLoss(0.25*REM, 0)
	. = ..()

/datum/reagent/moondust/overdose_start(mob/living/M)
	M.playsound_local(get_turf(M), 'sound/misc/heroin_rush.ogg', 100, FALSE)
	M.visible_message(span_warning("Blood runs from [M]'s nose."))

/obj/item/reagent_containers/powder/moondust_purest
	name = "pure moondust"
	desc = "This moondust glitters even in the dark. It seems to have certain pure properties."
	icon = 'icons/roguetown/items/produce.dmi'
	icon_state = "moondust_purest"
	list_reagents = list(/datum/reagent/moondust_purest = 15)
	sellprice = 20

/datum/reagent/moondust_purest
	name = "Purest Moondust"
	description = ""
	taste_description = "gunpowder"
	color = "#bfc3b5"
	overdose_threshold = 50
	metabolization_rate = 0.2

/datum/reagent/moondust_purest/on_mob_metabolize(mob/living/M)
	M.playsound_local(M, 'sound/ravein/small/hello_my_friend.ogg', 100, FALSE)
	M.overlay_fullscreen("purest_kaif", /atom/movable/screen/fullscreen/purest)
	animate(M.client, pixel_y = 1, time = 1, loop = -1, flags = ANIMATION_RELATIVE)
	animate(pixel_y = -1, time = 1, flags = ANIMATION_RELATIVE)

/datum/reagent/moondust_purest/on_mob_end_metabolize(mob/living/M)
	animate(M.client)
	M.clear_fullscreen("purest_kaif")
	M.remove_status_effect(/datum/status_effect/buff/moondust_purest)

/datum/reagent/moondust_purest/on_mob_life(mob/living/carbon/M)
	SEND_SIGNAL(src, COMSIG_DRUG_INDULGE)
	if(M.has_reagent(/datum/reagent/moondust))
		M.Sleeping(40, 0)
	if(M.has_quirk(/datum/quirk/vice/junkie))
		M.sate_addiction(/datum/quirk/vice/junkie)
	M.apply_status_effect(/datum/status_effect/buff/moondust_purest)
	if(prob(20))
		M.flash_fullscreen("whiteflash")
	..()

/datum/reagent/moondust_purest/overdose_process(mob/living/M)
	M.adjustToxLoss(0.25*REM, 0)
	. = ..()

/datum/reagent/moondust_purest/overdose_start(mob/living/M)
	M.playsound_local(get_turf(M), 'sound/misc/heroin_rush.ogg', 100, FALSE)
	M.visible_message(span_warning("Blood runs from [M]'s nose."))

/obj/item/reagent_containers/powder/manabloom
	name = "manabloom dust"
	desc = "Crushed manabloom useful as a combat measure against mages."
	icon = 'icons/roguetown/items/produce.dmi'
	icon_state = "salt"
	list_reagents = list(/datum/reagent/toxin/manabloom_juice = 5)
	sellprice = 10
	color = COLOR_CYAN

//generic herbs and spices used in cooking
//not as strong as pepper is, meant to be used by peasants and poor people to add some extra flavour
//feel free to make this be used in anything cooking related
/obj/item/reagent_containers/powder/herbs
	name = "herbs and spices"
	desc = "A bunch of herbs and spices mixed together."
	icon = 'icons/roguetown/items/produce.dmi'
	icon_state = "flour"
	volume = 1
	list_reagents = list(/datum/reagent/ash = 1)//you shouldn't be eating this anyways
	sellprice = 10
	color = COLOR_PALE_GREEN_GRAY

/obj/item/reagent_containers/powder/blastpowder
	name = "blastpowder"
	desc = "Explosive powder known to be produced by the dwarves. It's used in many explosives."
	icon = 'icons/roguetown/items/produce.dmi'
	icon_state = "blastpowder"
	list_reagents = list(/datum/reagent/blastpowder = 15)
	sellprice = 15
	var/primed = FALSE

/obj/item/reagent_containers/powder/blastpowder/spark_act()
	fire_act()

/obj/item/reagent_containers/powder/blastpowder/fire_act(added, maxstacks)
	if(primed)
		return
	primed = TRUE
	playsound(src, 'sound/items/fuse.ogg', 100)
	addtimer(CALLBACK(src, PROC_REF(boom)), 5 SECONDS)
	..()

/obj/item/reagent_containers/powder/blastpowder/proc/boom()
	var/turf/target_turf = get_turf(src)
	var/exp_devi = 0
	var/exp_heavy = 1
	var/exp_light = 1
	var/exp_flash = 3
	var/explode_sound = 'sound/misc/explode/bomb.ogg'
	explosion(target_turf, exp_devi, exp_heavy, exp_light, exp_flash, soundin = explode_sound)

	if(!isturf(loc))
		return

	if(!istype(loc, /turf/open/floor/naturalstone) && !istype(loc, /turf/open/floor/blocks) && !istype(loc, /turf/open/floor/grass) && !istype(loc, /turf/open/floor/dirt))
		return

	var/turf/closed/below = GET_TURF_BELOW(target_turf)
	if(istype(below))
		below.ScrapeAway()

	target_turf.ScrapeAway()

	qdel(src)
