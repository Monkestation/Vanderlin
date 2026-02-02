/obj/structure/closet/crate
	name = "crate"
	desc = ""
	icon = 'icons/obj/crates.dmi'
	icon_state = "crate"
	w_class = WEIGHT_CLASS_BULKY
	can_weld_shut = FALSE
	horizontal = TRUE
	allow_dense = FALSE
	dense_when_open = TRUE
	climbable = TRUE
	climb_time = 10 //real fast, because let's be honest stepping into or onto a crate is easy
	climb_stun = 0 //climbing onto crates isn't hard, guys
	open_sound = 'sound/blank.ogg'
	close_sound = 'sound/blank.ogg'
	open_sound_volume = 35
	close_sound_volume = 50
	drag_slowdown = 0

/obj/structure/closet/crate/CanAllowThrough(atom/movable/mover, turf/target)
	. = ..()
	if(!istype(mover, /obj/structure/closet))
		var/obj/structure/closet/crate/locatedcrate = locate(/obj/structure/closet/crate) in get_turf(mover)
		if(locatedcrate) //you can walk on it like tables, if you're not in an open crate trying to move to a closed crate
			if(opened) //if we're open, allow entering regardless of located crate openness
				return TRUE
			if(!locatedcrate.opened) //otherwise, if the located crate is closed, allow entering
				return TRUE

/obj/structure/closet/crate/attack_hand(mob/user)
	. = ..()
	if(.)
		return

/obj/structure/closet/crate/open(mob/living/user)
	. = ..()

/obj/structure/closet/crate/coffin
	name = "casket"
	desc = "Death basket."
	icon_state = "casket"
	resistance_flags = FLAMMABLE
	max_integrity = 70
	icon = 'icons/roguetown/misc/structure.dmi'
	material_drop_amount = 5
	open_sound = 'sound/blank.ogg'
	close_sound = 'sound/blank.ogg'
	open_sound_volume = 25
	close_sound_volume = 50
	var/sealed = FALSE // is the casket sealed? If not, we can still open and close it freely.
	var/consecrated = FALSE // Is the casket consecrated (AKA was there someone inside when we sealed it)?

/obj/structure/closet/crate/coffin/attack_hand(mob/living/user)
	if (!sealed) // if it's not sealed, process as usual.
		. = ..()
	else // if it's sealed, you must unseal it with a sharp object first.
		to_chat(user, span_warning("[src] is sealed with red tallow, you must slice it open with a dagger or knife first."))

/obj/structure/closet/crate/coffin/examine(mob/user)
	. = ..()
	if(HAS_TRAIT(user, TRAIT_GRAVEROBBER)) // only people who are greenlit to dig out graves can tell if a coffin is consecrated.
		if(consecrated)
			. += span_rose("This consecrated coffin hosts a body.")
		else if (sealed)
			. += span_warning("It is sealed, but has no body.")

/obj/structure/closet/crate/coffin/attacked_by(obj/item/I, mob/living/user)
	if(istype(I, /obj/item/inqarticles/tallowpot)) // consecrating and sealing a coffin with tallow.
		var/obj/item/inqarticles/tallowpot/pot = I
		if(istype(src, /obj/structure/closet/crate/coffin/vampire)) // you cannot seal a vampire lord's casket.
			to_chat(user, span_warning("The coffin's material prevents the tallow from sticking, it's seeping right off!"))
			return

		if(!pot.tallow)
			to_chat(user, span_warning("I lack tallow in the pot."))
			return

		if(!pot.heatedup)
			to_chat(user, span_warning("The tallow is not warm enough."))
			return

		to_chat(user, span_info("I start sealing the coffin with tallow.."))
		if(!do_after(user, 5 SECONDS, src))
			return
		if(pacify_coffin(src, user))
			add_overlay("graveconsecrated")
			user.visible_message(span_rose("[user] seals and consecrates [src]."), span_rose("I seal the coffin, consecrating it. I may bury it to protect it's inhabitant further."))
			SEND_SIGNAL(user, COMSIG_GRAVE_CONSECRATED, src)
			record_round_statistic(STATS_GRAVES_CONSECRATED)
			consecrated = TRUE
		else
			to_chat(user, span_warning("The consecration failed, but you did seal the coffin."))
		sealed = TRUE
		icon_state = "casketconsecrated"
		pot.remaining = max(pot.remaining - 150, 0) // take only 150 since each process tick removes 20 from the tallow pot, and sometimes people wait.
		return
	if(user.used_intent.type == /datum/intent/dagger/cut && istype(I, /obj/item/weapon/knife)) // unsealing a coffin
		if(!user.cmode)
			if(!sealed)
				to_chat(user, span_info("The coffin has no seal to remove."))
			else
				to_chat(user, span_info("I start unsealing the coffin.."))
				if(!do_after(user, 5 SECONDS, src))
					return
				if(user.patron?.type != /datum/patron/divine/necra) // necrans don't add to the grave robber counts, though they can still get cursed.
					record_featured_stat(FEATURED_STATS_CRIMINALS, user)
					record_round_statistic(STATS_GRAVES_ROBBED)
				if(isliving(user) && src.consecrated)
					var/mob/living/L = user
					if(HAS_TRAIT(L, TRAIT_GRAVEROBBER))
						to_chat(user, "<span class='warning'>Necra turns a blind eye to my deeds.</span>")
					else
						to_chat(user, "<span class='warning'>Necra shuns my blasphemous deeds, I am cursed!</span>")
						L.apply_status_effect(/datum/status_effect/debuff/cursed)
				SEND_SIGNAL(user, COMSIG_GRAVE_ROBBED, user)
				sealed = FALSE
				consecrated = FALSE
				icon_state = "casket"
				return
		. = ..()

/obj/structure/closet/crate/coffin/vampire
	name = "sleep casket"
	desc = "A fancy coffin."
	icon_state = "vcasket"
	resistance_flags = FLAMMABLE
	max_integrity = 70
	icon = 'icons/roguetown/misc/structure.dmi'
	material_drop_amount = 5
	open_sound = 'sound/blank.ogg'
	close_sound = 'sound/blank.ogg'
	open_sound_volume = 25
	close_sound_volume = 50
