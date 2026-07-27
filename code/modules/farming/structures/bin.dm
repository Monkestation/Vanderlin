//Not adding this yet

/obj/item/bin
	name = "wood bin"
	desc = "A washbin, a trashbin, a bloodbin... Your choices are limitless."
	icon = 'icons/roguetown/misc/structure.dmi'
	icon_state = "washbin"
	var/base_state
	attacked_sound = list('sound/combat/hits/onwood/woodimpact (1).ogg','sound/combat/hits/onwood/woodimpact (2).ogg')
	density = TRUE
	opacity = FALSE
	anchored = FALSE
	max_integrity = 80
	w_class = WEIGHT_CLASS_GIGANTIC
	var/kover = FALSE
	drag_slowdown = 2
	throw_speed = 1
	throw_range = 1
	blade_dulling = DULLING_BASHCHOP
	obj_flags = CAN_BE_HIT

/obj/item/bin/Initialize()
	. = ..()
	if(!base_state)
		create_reagents(600, TRANSFERABLE | AMOUNT_VISIBLE)
		base_state = icon_state
	AddComponent(/datum/component/storage/concrete/grid/bin)
	update_appearance(UPDATE_ICON)
	ADD_TRAIT(src, TRAIT_DO_NOT_SPLASH, INNATE_TRAIT)

/obj/item/bin/Destroy()
	var/datum/component/storage/STR = GetComponent(/datum/component/storage)
	if(STR)
		var/list/things = STR.contents()
		for(var/obj/item/I in things)
			STR.remove_from_storage(I, get_turf(src))
	return ..()


/obj/item/bin/update_icon_state()
	. = ..()
	icon_state = "[base_state][kover ? "over" : ""]"

/obj/item/bin/update_overlays()
	. = ..()
	if(!reagents?.total_volume)
		return
	var/mutable_appearance/filling = mutable_appearance('icons/roguetown/misc/structure.dmi', "liquid2")
	filling.color = mix_color_from_reagents(reagents.reagent_list)
	filling.alpha = mix_alpha_from_reagents(reagents.reagent_list)
	. += filling

/obj/item/bin/onkick(mob/user)
	if(isliving(user))
		var/mob/living/L = user
		if(kover)
			playsound(src, 'sound/combat/hits/onwood/woodimpact (1).ogg', 100)
			user.visible_message("<span class='warning'>[user] kicks [src]!</span>", \
				"<span class='warning'>I kick [src]!</span>")
			return
		if(prob(GET_MOB_ATTRIBUTE_VALUE(L, STAT_STRENGTH) * 8))
			playsound(src, 'sound/combat/hits/onwood/woodimpact (1).ogg', 100)
			user.visible_message("<span class='warning'>[user] kicks over [src]!</span>", \
				"<span class='warning'>I kick over [src]!</span>")
			kover = TRUE
			playsound(src, pick('sound/foley/water_land1.ogg','sound/foley/water_land2.ogg', 'sound/foley/water_land3.ogg'), 100, FALSE)
			chem_splash(loc, 2, list(reagents), adminlog = TRUE)
			var/datum/component/storage/STR = GetComponent(/datum/component/storage)
			if(STR)
				var/list/things = STR.contents()
				for(var/obj/item/I in things)
					STR.remove_from_storage(I, get_turf(src))
			update_appearance(UPDATE_ICON_STATE)
		else
			playsound(src, 'sound/combat/hits/onwood/woodimpact (1).ogg', 100)
			user.visible_message("<span class='warning'>[user] kicks [src]!</span>", \
				"<span class='warning'>I kick [src]!</span>")

/obj/item/bin/attack_hand_secondary(mob/user, list/modifiers)
	. = SECONDARY_ATTACK_CANCEL_ATTACK_CHAIN
	if(kover)
		user.visible_message("<span class='notice'>[user] starts to pick up [src]...</span>", \
			"<span class='notice'>I start to pick up [src]...</span>")
		if(do_after(user, 3 SECONDS, src))
			kover = FALSE
			update_appearance(UPDATE_ICON_STATE)
		return

	if(user.cmode)
		return

	try_wash(user, user)

/obj/item/bin/proc/try_wash(atom/to_wash, mob/user)
	if(!reagents?.maximum_volume || kover)
		return FALSE

	var/removereg = /datum/reagent/water
	if(!reagents.has_reagent(/datum/reagent/water, 5))
		removereg = /datum/reagent/water/gross
		if(!reagents.has_reagent(/datum/reagent/water/gross, 5))
			to_chat(user, "<span class='warning'>No water to wash these stains.</span>")
			return FALSE

	var/list/wash = list('sound/foley/waterwash (1).ogg','sound/foley/waterwash (2).ogg')
	if(to_wash == user)
		user.visible_message("<span class='info'>[user] starts to wash in [src].</span>")
	else
		user.visible_message("<span class='info'>[user] starts to wash [to_wash] in [src].</span>")
		if(istype(to_wash, /obj/item/clothing))
			var/obj/item/clothing/clothing_item = to_wash
			if(clothing_item.wetable)
				if(!reagents.has_reagent(/datum/reagent/water/gross))
					clothing_item.wet.add_water(20, dirty = FALSE, washed_properly = TRUE)
				else
					clothing_item.wet.add_water(20, dirty = TRUE, washed_properly = TRUE)
		user.nobles_seen_servant_work()
	reagents.remove_reagent(removereg, 5)

	playsound(user, pick_n_take(wash), 100, FALSE)
	if(do_after(user, 3 SECONDS, src))
		to_wash.wash(CLEAN_WASH)
		playsound(user, pick(wash), 100, FALSE)

	var/datum/reagent/water_to_dirty = reagents.has_reagent(/datum/reagent/water, 5)
	if(water_to_dirty)
		var/amount_to_dirty = water_to_dirty.volume
		if(amount_to_dirty)
			reagents.remove_reagent(/datum/reagent/water, amount_to_dirty)
			reagents.add_reagent(/datum/reagent/water/gross, amount_to_dirty)

	return TRUE

//We need to use this or the object will be put in storage instead of attacking it
/obj/item/bin/StorageBlock(obj/item/I, mob/user)
	if(user?.used_intent)
		if(user.used_intent.type in list(/datum/intent/fill,/datum/intent/pour, /datum/intent/splash))
			return TRUE
	if(istype(I, /obj/item/weapon/tongs))
		var/obj/item/weapon/tongs/T = I
		if(T.held_item && istype(T.held_item, /obj/item/ingot))
			return TRUE
	if(istype(I, /obj/item/dye_pack))
		return TRUE
	return FALSE

/obj/item/bin/item_interaction(mob/living/user, obj/item/tool, list/modifiers)
	if(!reagents?.total_volume)
		return NONE

	if(user.cmode)
		return NONE

	if(istype(tool, /obj/item/dye_pack))
		var/obj/item/dye_pack/pack = tool
		user.visible_message(span_info("[user] begins to add [pack] to [src]..."))
		if(!do_after(user, 3 SECONDS, src))
			return ITEM_INTERACT_BLOCKING
		playsound(src, "bubbles", 50, 1)
		new /obj/structure/dye_bin(get_turf(src), pack)
		qdel(src)
		return ITEM_INTERACT_SUCCESS

	if(is_type_in_list(user.used_intent, list(INTENT_SOAK, INTENT_WRING)))
		return NONE // special snowflake

	if(isreagentcontainer(tool))
		return NONE // special snowflake

	var/obj/item/item = tool
	if(istype(tool, /obj/item/weapon/tongs))
		var/obj/item/weapon/tongs/tongs = tool
		if(tongs.held_item)
			item = tongs.held_item

	if(HAS_TRAIT(item, TRAIT_NEEDS_QUENCH))
		if(!quench(item, user))
			return ITEM_INTERACT_BLOCKING
		return ITEM_INTERACT_SUCCESS

	if(!try_wash(item, user))
		return ITEM_INTERACT_BLOCKING
	return ITEM_INTERACT_SUCCESS

/obj/item/bin/proc/quench(obj/item/tool, mob/living/user)
	var/removereg = /datum/reagent/water
	if(!reagents.has_reagent(/datum/reagent/water, 5))
		removereg = /datum/reagent/water/gross
		if(!reagents.has_reagent(/datum/reagent/water/gross, 5))
			to_chat(user, "<span class='warning'>Need more water to quench in.</span>")
			return FALSE

	reagents.remove_reagent(removereg, 5)
	playsound(src,pick('sound/items/quench_barrel1.ogg','sound/items/quench_barrel2.ogg'), 100, FALSE)
	user.visible_message("<span class='info'>[user] tempers \the [tool] in \the [src], hot metal sizzling.</span>")
	tool.remove_quench()
	update_appearance(UPDATE_ICON)

	return TRUE

/obj/item/bin/trash
	name = "trash bin"
	desc = "An eyesore that is meant to make things look cleaner."
	icon_state = "trashbin"
	base_state = "trashbin"

/obj/item/bin/trash/StorageBlock(obj/item/I, mob/user)
	return FALSE

/obj/item/bin/trash/attackby(obj/item/I, mob/user, list/modifiers)
	if(istype(I, /obj/item/dye_pack)) //it works... but we can do better, surely?
		return
	. = ..()

/obj/item/proc/remove_quench(source)
	// Source is null when removing all TRAIT_NEEDS_QUENCH
	// If this is the only trait source we have, remove the filter.
	if(isnull(source) || !HAS_TRAIT_NOT_FROM(src, TRAIT_NEEDS_QUENCH, source))
		remove_filter("heated")
	REMOVE_TRAIT(src, TRAIT_NEEDS_QUENCH, source)

/obj/item/proc/add_quench_requirement(source, duration)
	if(!HAS_TRAIT(src, TRAIT_NEEDS_QUENCH))
		add_filter("heated", 1, color_matrix_filter(list(3,0,0,1, 0,2.7,0,0.4, 0,0,1,0, 0,0,0,1)))
	ADD_TRAIT(src, TRAIT_NEEDS_QUENCH, source)
	if(duration)
		addtimer(CALLBACK(src, PROC_REF(remove_quench), source), duration, TIMER_UNIQUE|TIMER_OVERRIDE|TIMER_DELETE_ME)
