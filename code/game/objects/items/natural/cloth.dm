/obj/item/natural/cloth
	name = "cloth"
	desc = "A square of cloth mended from fibers."
	icon_state = "cloth"
	possible_item_intents = list(/datum/intent/use, INTENT_SOAK, INTENT_WRING)
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
	flags_ai_inventory = AI_ITEM_BANDAGE
	item_weight = 12 GRAMS

	var/datum/component/cleaner/cleaner_component = null
	var/clean_speed = 0.4 SECONDS
	var/volume = 9

	// Effectiveness when used as a bandage, how much it'll lower the bloodloss, bloodloss will get multiplied by this.
	var/bandage_effectiveness = 0 // EXPERIMENTAL CHANGE: BANDAGES STOP ALL BLEEDING
	///how long it will take to bandage something with this
	var/bandage_speed = 7 SECONDS
	///How much you can bleed into the bandage until it needs to be changed
	var/bandage_health = 250
	obj_flags = CAN_BE_HIT //enables splashing on by containers

/obj/item/natural/cloth/examine(mob/user)
	. = ..()
	. += span_notice("[src] is [PERCENT((initial(bandage_health) - bandage_health)/initial(bandage_health))]% soaked in blood.")

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
	if(istype(atom_to_clean, /turf/open/water) || istype(atom_to_clean, /turf/open/openspace) || istype(atom_to_clean, /obj/item/plate) || istype(atom_to_clean, /obj/item/reagent_containers/glass/bowl) || istype(atom_to_clean, /obj/item/clothing/shoes))
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
	if(!clean_succeeded)
		return
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

/obj/item/natural/cloth/interact_with_atom(atom/interacting_with, mob/living/user, list/modifiers)
	if(ishuman(interacting_with))
		if(bandage(interacting_with, user))
			return ITEM_INTERACT_SUCCESS
		return ITEM_INTERACT_BLOCKING

	var/datum/intent/used = user.used_intent
	if(istype(used, INTENT_SOAK) && soak_cloth(interacting_with, user))
		return ITEM_INTERACT_SUCCESS

	if(istype(used, INTENT_WRING) && wring_cloth(interacting_with, user))
		return ITEM_INTERACT_SUCCESS

	return NONE

/obj/item/natural/cloth/attack_self(mob/user, list/modifiers)
	wring_cloth(user.loc, user)

/obj/item/natural/cloth/attack_hand_secondary(mob/user, list/modifiers)
	. = ..()
	if(. == SECONDARY_ATTACK_CANCEL_ATTACK_CHAIN)
		return

	wring_cloth(user.loc, user)

	return SECONDARY_ATTACK_CANCEL_ATTACK_CHAIN

/obj/item/natural/cloth/proc/soak_cloth(atom/target, mob/living/user)
	if(reagents.total_volume == reagents.maximum_volume)
		to_chat(user, span_warning("\The [src] is already soaked."))
		return FALSE
	if(isobj(target))
		var/obj/O = target
		if(!O.reagents || !O.is_open_container())
			return FALSE
		if(O.reagents.total_volume == 0)
			to_chat(user, span_warning("It's empty."))
			return FALSE
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
				bandage_health = initial(bandage_health)
				bandage_effectiveness = initial(bandage_effectiveness)
		else
			var/datum/liquid_group/lg = T.liquids?.liquid_group
			if(!lg)
				to_chat(user, span_warning("Nothing there to soak."))
				return FALSE
			if(do_after(user, clean_speed * 2, T))
				lg.transfer_to_atom(null, reagents.maximum_volume, src)
				user.visible_message(span_small("[user] soaks \the [src]."), span_small("I soak \the [src]."), vision_distance = 2)
				playsound(T, pick('sound/foley/waterwash (1).ogg','sound/foley/waterwash (2).ogg'), 25, FALSE)

	update_appearance(UPDATE_OVERLAYS)
	return TRUE

/obj/item/natural/cloth/proc/wring_cloth(atom/target, mob/living/user)
	if(reagents.total_volume == 0)
		to_chat(user, span_warning("Nothing to wring out."))
		return FALSE
	if(isobj(target))
		var/obj/O = target
		if(!O.reagents || !O.is_open_container())
			return FALSE
		if(O.reagents.total_volume == O.reagents.maximum_volume)
			to_chat(user, span_warning("It's full."))
			return FALSE
		if(do_after(user, clean_speed * 2.5, O))
			reagents.trans_to(O, reagents.total_volume, 1, transfered_by = user)
			user.visible_message(span_small("[user] wrings out \the [src] in \the [O]."), span_small("I wring out \the [src] in \the [O]."), vision_distance = 2)
			playsound(O, pick('sound/foley/waterwash (1).ogg','sound/foley/waterwash (2).ogg'), 25, FALSE)
			bandage_health = initial(bandage_health)
			bandage_effectiveness = initial(bandage_effectiveness)
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
				bandage_health = initial(bandage_health)
				bandage_effectiveness = initial(bandage_effectiveness)

	update_appearance(UPDATE_OVERLAYS)

	return TRUE

/obj/item/natural/cloth/proc/bandage(mob/living/M, mob/user)
	if(!M.can_inject(user, TRUE))
		return FALSE

	if(!ishuman(M))
		return FALSE

	var/mob/living/carbon/human/H = M
	var/obj/item/bodypart/affecting = H.get_bodypart(check_zone(user.zone_selected))
	if(!affecting)
		return FALSE

	if(affecting.bandage)
		to_chat(user, "<span class='warning'>There is already a bandage.</span>")
		return FALSE

	var/used_time = bandage_speed * (1 - (GET_MOB_SKILL_VALUE_OLD(H, /datum/attribute/skill/misc/medicine) * 0.15))
	playsound(src, 'sound/foley/bandage.ogg', 100, FALSE)
	if(!do_after(user, used_time, M))
		return FALSE

	playsound(src, 'sound/foley/bandage.ogg', 100, FALSE)

	user.dropItemToGround(src)
	affecting.try_bandage(src)
	H.update_damage_overlays()

	if(M == user)
		user.visible_message(span_notice("[user] bandages [user.p_their()] [affecting.name]."), span_notice("I bandage my [affecting.name]."))
	else
		user.visible_message(span_notice("[user] bandages [M]'s [affecting.name]."), span_notice("I bandage [M]'s [affecting.name]."))

	return TRUE

/obj/item/natural/cloth/update_overlays()
	. = ..()

	if(reagents?.total_volume <= 0)
		return
	var/soaked_color = mix_color_from_reagents(reagents.reagent_list)
	var/mutable_appearance/soaked_overlay = mutable_appearance(icon, "[icon_state]_soaked")
	soaked_overlay.color = soaked_color
	. += soaked_overlay

	var/is_glowing = FALSE
	for(var/datum/reagent/R in reagents.reagent_list)
		if(R.glows)
			is_glowing = TRUE
			break

	if(!is_glowing)
		return

	var/mutable_appearance/emissive_overlay = emissive_appearance(icon, "[icon_state]_soaked", src)
	. += emissive_overlay
