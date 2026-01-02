/obj/item/natural/fibers
	name = "fiber"
	desc = "Plant fiber. The peasants make their living sewing these into fabrics and clothing."
	icon_state = "fibers"
	possible_item_intents = list(/datum/intent/use)
	force = 0
	throwforce = 0
	color = "#454032"
	firefuel = 1 MINUTES
	resistance_flags = FLAMMABLE
	slot_flags = ITEM_SLOT_MOUTH
	max_integrity = 20
	muteinmouth = TRUE
	w_class = WEIGHT_CLASS_TINY
	spitoutmouth = FALSE
	bundletype = /obj/item/natural/bundle/fibers

/obj/item/natural/silk
	name = "silk"
	icon_state = "fibers"
	possible_item_intents = list(/datum/intent/use)
	desc = "Silken strands. Their usage in clothing is exotic in all places save the Underdark."
	force = 0
	throwforce = 0
	color = "#e6e3db"
	firefuel = 1 MINUTES
	resistance_flags = FLAMMABLE
	slot_flags = ITEM_SLOT_MOUTH
	max_integrity = 20
	muteinmouth = TRUE
	w_class = WEIGHT_CLASS_TINY
	spitoutmouth = FALSE
	bundletype = /obj/item/natural/bundle/silk

#ifdef TESTSERVER

/client/verb/bloodnda()
	set category = "DEBUGTEST"
	set name = "bloodnda"
	set desc = ""

	var/obj/item/I
	I = mob.get_active_held_item()
	if(I)
		if(GET_ATOM_BLOOD_DNA(I))
			testing("yep")
		else
			testing("nope")

#endif

/obj/item/natural/cloth
	name = "cloth"
	desc = "A square of cloth mended from fibers."
	icon_state = "cloth"
	possible_item_intents = list(/datum/intent/use, /datum/intent/soak, /datum/intent/wring)
	force = 0
	throwforce = 0
	firefuel = 3 MINUTES
	resistance_flags = FLAMMABLE
	slot_flags = ITEM_SLOT_MOUTH|ITEM_SLOT_HIP|ITEM_SLOT_MASK|ITEM_SLOT_BELT
	body_parts_covered = null
	experimental_onhip = TRUE
	max_integrity = 20
	muteinmouth = TRUE
	w_class = WEIGHT_CLASS_TINY
	spitoutmouth = FALSE
	bundletype = /obj/item/natural/bundle/cloth

	var/datum/component/cleaner/cleaner_component = null
	var/clean_speed = 0.4 SECONDS
	var/volume = 9

	/// Effectiveness when used as a bandage, how much bloodloss we can tampon
	var/bandage_effectiveness = 0.9
	obj_flags = CAN_BE_HIT //enables splashing on by containers

/obj/item/natural/cloth/Initialize(mapload, vol)
	. = ..()
	if(isnum(vol) && vol > 0)
		volume = vol
	create_reagents(volume, TRANSPARENT)
	cleaner_component = AddComponent(
		/datum/component/cleaner, \
		clean_speed, \
		CLEAN_SCRUB, \
		100, \
		TRUE, \
		CALLBACK(src, PROC_REF(on_pre_clean)), \
		CALLBACK(src, PROC_REF(on_clean_success)), \
	)

/obj/item/natural/cloth/Destroy()
	cleaner_component = null
	return ..()

/obj/item/natural/cloth/proc/on_pre_clean(datum/cleaning_source, atom/atom_to_clean, mob/living/cleaner)
	if(cleaner?.used_intent?.type != INTENT_USE || ismob(atom_to_clean) || !check_allowed_items(atom_to_clean))
		return DO_NOT_CLEAN
	if(istype(atom_to_clean, /turf/open/water) || istype(atom_to_clean, /turf/open/transparent) || istype(atom_to_clean, /obj/item/plate) || istype(atom_to_clean, /obj/item/reagent_containers/glass/bowl) || istype(atom_to_clean, /obj/item/clothing/shoes))
		return DO_NOT_CLEAN
	if(cleaner.client && ((atom_to_clean in cleaner.client.screen) && !cleaner.is_holding(atom_to_clean)))
		to_chat(cleaner, span_warning("I need to take \the [atom_to_clean] off before cleaning it!"))
		return DO_NOT_CLEAN
	if(reagents.total_volume < 0.1)
		to_chat(cleaner, span_warning("[src] is too dry to clean with!"))
		return DO_NOT_CLEAN

	// overly complicated effectiveness calculations
	// explanation/graph https://www.desmos.com/calculator/sjzjfkeupd
	var/pWater = reagents.get_reagent_amount(/datum/reagent/water) / reagents.total_volume
	var/pDirtyWater = reagents.get_reagent_amount(/datum/reagent/water/gross) / reagents.total_volume
	var/pSoap = reagents.get_reagent_amount(/datum/reagent/soap) / reagents.total_volume
	var/effectiveness = 0.1 + pWater * CLEAN_EFFECTIVENESS_WATER + pDirtyWater * CLEAN_EFFECTIVENESS_DIRTY_WATER
	effectiveness *= LERP(1, CLEAN_EFFECTIVENESS_SOAP, pSoap)

	cleaner_component.cleaning_effectiveness = (effectiveness * 100) % 100
	cleaner_component.cleaning_strength = CLEAN_WASH
	playsound(cleaner, pick('sound/foley/cloth_wipe (1).ogg','sound/foley/cloth_wipe (2).ogg', 'sound/foley/cloth_wipe (3).ogg'), 25, FALSE)
	cleaner.nobles_seen_servant_work()
	return TRUE

/obj/item/natural/cloth/proc/on_clean_success(datum/source, atom/target, mob/living/user, clean_succeeded)
	if(clean_succeeded)
		if(prob(50) && isturf(target)) // to prevent infinitely renewable water
			var/turf/T = target
			T.add_liquid_from_reagents(reagents, amount = 1)
		reagents.remove_all(1)

/obj/item/natural/cloth/mob_can_equip(mob/living/M, mob/living/equipper, slot, disable_warning, bypass_equip_delay_self)
	. = ..()
	if(.)
		if((slot & ITEM_SLOT_BELT) && !equipper)
			if(!do_after(M, 1.5 SECONDS, src))
				return FALSE

/obj/item/natural/cloth/equipped(mob/living/carbon/human/user, slot)
	. = ..()
	if(slot & ITEM_SLOT_MASK)
		user.become_blind("blindfold_[REF(src)]")
	else if(slot & ITEM_SLOT_BELT)
		user.temporarilyRemoveItemFromInventory(src)
		user.equip_to_slot_if_possible(new /obj/item/storage/belt/leather/cloth(get_turf(user)), ITEM_SLOT_BELT)
		qdel(src)

/obj/item/natural/cloth/dropped(mob/living/carbon/human/user)
	..()
	user.cure_blind("blindfold_[REF(src)]")


// CLEANING

/obj/item/natural/cloth/attack_atom(obj/O, mob/living/user)
	switch(user.used_intent.type)
		if(INTENT_SOAK)
			soak_cloth(O, user)
			return TRUE
		if(INTENT_WRING)
			wring_cloth(O, user)
			return TRUE
	return ..()

/obj/item/natural/cloth/attack_self(mob/user, params)
	wring_cloth(user.loc, user)

/obj/item/natural/cloth/attack_hand_secondary(mob/user, params)
	. = ..()
	if(. == SECONDARY_ATTACK_CANCEL_ATTACK_CHAIN)
		return

	wring_cloth(user.loc, user)

	return SECONDARY_ATTACK_CANCEL_ATTACK_CHAIN

/obj/item/natural/cloth/proc/soak_cloth(atom/target, mob/living/user)
	if(reagents.total_volume == reagents.maximum_volume)
		to_chat(user, span_warning("\The [src] is already soaked."))
		return
	if(isobj(target))
		var/obj/O = target
		if(!O.reagents || !O.is_open_container())
			return
		if(O.reagents.total_volume == 0)
			to_chat(user, span_warning("It's empty."))
			return
		if(do_after(user, clean_speed, O))
			O.reagents.trans_to(src, reagents.maximum_volume, 1, transfered_by = user)
			user.visible_message(span_small("[user] soaks \the [src] in \the [O]."), span_small("I soak \the [src] in \the [O]."), vision_distance = 2)
			playsound(O, pick('sound/foley/waterwash (1).ogg','sound/foley/waterwash (2).ogg'), 25, FALSE)
	else if(isturf(target))
		var/turf/T = target
		if(istype(T, /turf/open/water))
			var/turf/open/water/W = T
			if(do_after(user, clean_speed, T))
				reagents.add_reagent(W.water_reagent, reagents.maximum_volume)
				user.visible_message(span_small("[user] soaks \the [src] in \the [T]."), span_small("I soak \the [src] in \the [T]."), vision_distance = 2)
				playsound(T, pick('sound/foley/waterwash (1).ogg','sound/foley/waterwash (2).ogg'), 25, FALSE)
		else
			var/datum/liquid_group/lg = T.liquids?.liquid_group
			if(!lg)
				to_chat(user, span_warning("Nothing there to soak."))
				return
			if(do_after(user, clean_speed * 2, T))
				lg.transfer_to_atom(null, reagents.maximum_volume, src)
				user.visible_message(span_small("[user] soaks \the [src]."), span_small("I soak \the [src]."), vision_distance = 2)
				playsound(T, pick('sound/foley/waterwash (1).ogg','sound/foley/waterwash (2).ogg'), 25, FALSE)

/obj/item/natural/cloth/proc/wring_cloth(atom/target, mob/living/user)
	if(reagents.total_volume == 0)
		to_chat(user, span_warning("Nothing to wring out."))
		return
	if(isobj(target))
		var/obj/O = target
		if(!O.reagents || !O.is_open_container())
			return
		if(O.reagents.total_volume == O.reagents.maximum_volume)
			to_chat(user, span_warning("It's full."))
			return
		if(do_after(user, clean_speed * 2.5, O))
			reagents.trans_to(O, reagents.total_volume, 1, transfered_by = user)
			user.visible_message(span_small("[user] wrings out \the [src] in \the [O]."), span_small("I wring out \the [src] in \the [O]."), vision_distance = 2)
			playsound(O, pick('sound/foley/waterwash (1).ogg','sound/foley/waterwash (2).ogg'), 25, FALSE)
	else if(isturf(target))
		var/turf/T = target
		if(istype(T, /turf/open/water))
			if(do_after(user, clean_speed * 2.5, T))
				reagents.clear_reagents()
				user.visible_message(span_small("[user] wrings out \the [src] in \the [T]."), span_small("I wring out \the [src] in \the [T]."), vision_distance = 2)
				playsound(T, pick('sound/foley/waterwash (1).ogg','sound/foley/waterwash (2).ogg'), 25, FALSE)
		else
			if(do_after(user, clean_speed * 2.5, T))
				T.add_liquid_from_reagents(reagents, amount = reagents.maximum_volume)
				reagents.clear_reagents()
				user.visible_message(span_small("[user] wrings out \the [src]."), span_small("I wring out \the [src]."), vision_distance = 2)
				playsound(T, pick('sound/foley/waterwash (1).ogg','sound/foley/waterwash (2).ogg'), 25, FALSE)

// BANDAGING
/obj/item/natural/cloth/attack(mob/living/M, mob/user)
	bandage(M, user)

/obj/item/natural/cloth/proc/bandage(mob/living/M, mob/user)
	if(!M.can_inject(user, TRUE))
		return
	if(!ishuman(M))
		return
	var/mob/living/carbon/human/H = M
	var/obj/item/bodypart/affecting = H.get_bodypart(check_zone(user.zone_selected))
	if(!affecting)
		return
	if(affecting.bandage)
		to_chat(user, "<span class='warning'>There is already a bandage.</span>")
		return
	var/used_time = 70
	if(H.mind)
		used_time -= (H.get_skill_level(/datum/skill/misc/medicine) * 10)
	playsound(loc, 'sound/foley/bandage.ogg', 100, FALSE)
	if(!do_after(user, used_time, M))
		return
	playsound(loc, 'sound/foley/bandage.ogg', 100, FALSE)

	user.dropItemToGround(src)
	affecting.try_bandage(src)
	H.update_damage_overlays()

	if(M == user)
		user.visible_message("<span class='notice'>[user] bandages [user.p_their()] [affecting].</span>", "<span class='notice'>I bandage my [affecting].</span>")
	else
		user.visible_message("<span class='notice'>[user] bandages [M]'s [affecting].</span>", "<span class='notice'>I bandage [M]'s [affecting].</span>")

/obj/item/natural/thorn
	name = "thorn"
	desc = "This bog-grown thorn is sharp and resistant like a needle."
	icon_state = "thorn"
	force = 10
	throwforce = 0
	possible_item_intents = list(/datum/intent/stab)
	firefuel = 1 MINUTES
	embedding = list("embedded_unsafe_removal_time" = 20, "embedded_pain_chance" = 10, "embedded_pain_multiplier" = 1, "embed_chance" = 35, "embedded_fall_chance" = 0)
	resistance_flags = FLAMMABLE
	max_integrity = 20
/obj/item/natural/thorn/attack_self(mob/living/user, params)
	user.visible_message("<span class='warning'>[user] snaps [src].</span>")
	playsound(user,'sound/items/seedextract.ogg', 100, FALSE)
	qdel(src)

/obj/item/natural/thorn/Crossed(mob/living/L)
	. = ..()
	if(istype(L))
		var/prob2break = 33
		if(L.m_intent == MOVE_INTENT_SNEAK)
			prob2break = 0
		if(L.m_intent == MOVE_INTENT_RUN)
			prob2break = 100
		if(prob(prob2break))
			playsound(src,'sound/items/seedextract.ogg', 100, FALSE)
			qdel(src)
			if (L.alpha == 0 && L.rogue_sneaking) // not anymore you're not
				L.update_sneak_invis(TRUE)
			L.consider_ambush()

/obj/item/natural/bundle/fibers
	name = "fiber bundle"
	desc = "Fibers, bundled together."
	icon_state = "fibersroll1"
	possible_item_intents = list(/datum/intent/use)
	force = 0
	throwforce = 0
	maxamount = 12
	color = "#454032"
	firemod =  1 MINUTES
	resistance_flags = FLAMMABLE
	slot_flags = ITEM_SLOT_MOUTH
	max_integrity = 20
	muteinmouth = TRUE
	w_class = WEIGHT_CLASS_TINY
	spitoutmouth = FALSE
	stacktype = /obj/item/natural/fibers
	icon1step = 3
	icon2step = 6

/obj/item/natural/bundle/fibers/full/Initialize()
	. = ..()
	amount = maxamount
	update_bundle()

/obj/item/natural/bundle/silk
	name = "silken weave"
	icon_state = "fibersroll1"
	possible_item_intents = list(/datum/intent/use)
	desc = "Silk neatly woven together."
	force = 0
	throwforce = 0
	maxamount = 6
	color = "#e6e3db"
	firemod = 1 MINUTES
	resistance_flags = FLAMMABLE
	slot_flags = ITEM_SLOT_MOUTH
	max_integrity = 20
	muteinmouth = TRUE
	w_class = WEIGHT_CLASS_TINY
	spitoutmouth = FALSE
	stacktype = /obj/item/natural/silk
	icon1step = 3
	icon2step = 6

/obj/item/natural/bundle/cloth
	name = "bundle of cloth"
	icon_state = "clothroll1"
	possible_item_intents = list(/datum/intent/use)
	desc = "A cloth roll of several pieces of fabric."
	force = 0
	throwforce = 0
	maxamount = 10
	firemod = 3 MINUTES
	resistance_flags = FLAMMABLE
	w_class = WEIGHT_CLASS_TINY
	spitoutmouth = FALSE
	stacktype = /obj/item/natural/cloth
	stackname = "cloth"
	icon1 = "clothroll1"
	icon1step = 5
	icon2 = "clothroll2"
	icon2step = 10

/obj/item/natural/bundle/cloth/full/Initialize()
	. = ..()
	amount = maxamount
	update_bundle()

/obj/item/natural/bundle/stick
	name = "bundle of sticks"
	desc = "A bundle of wooden sticks, looks like they all need to stick together!"
	icon_state = "stickbundle1"
	possible_item_intents = list(/datum/intent/use)
	maxamount = 10
	force = 0
	throwforce = 0
	firemod = 5 MINUTES
	resistance_flags = FLAMMABLE
	w_class = WEIGHT_CLASS_TINY
	spitoutmouth = FALSE
	stacktype = /obj/item/grown/log/tree/stick
	stackname = "sticks"
	icon1 = "stickbundle1"
	icon1step = 4
	icon2 = "stickbundle2"
	icon2step = 7
	icon3 = "stickbundle3"

/obj/item/natural/bowstring
	name = "fibre bowstring"
	desc = "A simple cord of bowstring."
	icon_state = "fibers"
	possible_item_intents = list(/datum/intent/use)
	force = 0
	throwforce = 0
	color = COLOR_BEIGE
	firefuel = 5 MINUTES
	resistance_flags = FLAMMABLE
	slot_flags = ITEM_SLOT_MOUTH
	max_integrity = 20
	muteinmouth = TRUE
	w_class = WEIGHT_CLASS_TINY
	spitoutmouth = FALSE

/obj/item/natural/bundle/worms
	name = "worms"
	desc = "Multiple wriggly worms."
	icon_state = "worm2"
	color = "#964B00"
	maxamount = 6
	icon1 = "worm2"
	icon1step = 3
	icon2 = "worm3"
	icon2step = 5
	icon3 = "worm4"
	stacktype = /obj/item/natural/worms
	stackname = "worms"

/obj/item/natural/bundle/bone
	name = "stack of bones"
	icon_state = "bonestack1"
	possible_item_intents = list(/datum/intent/use)
	desc = "Bones stacked upon one another."
	force = 0
	throwforce = 0
	maxamount = 6
	color = null
	firefuel = null
	firemod = 0
	resistance_flags = FLAMMABLE
	slot_flags = ITEM_SLOT_MOUTH
	max_integrity = 20
	muteinmouth = TRUE
	w_class = WEIGHT_CLASS_TINY
	spitoutmouth = FALSE
	stacktype = /obj/item/alch/bone
	stackname = "bones"
	icon1 = "bonestack1"
	icon1step = 2
	icon2 = "bonestack2"
	icon2step = 4

/obj/item/natural/bundle/bone/full/Initialize()
	. = ..()
	amount = maxamount
	update_bundle()
