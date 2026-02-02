#define MAXIMUM_TOTAL_COMPOST 2000
#define COMPOST_PER_PRODUCED_ITEM 100
#define COMPOST_PROCESS_RATE 300 / (1 MINUTES)

/obj/structure/composter
	name = "composter"
	desc = "A wooden fencing with space for discarded produce to turn into compost."
	icon = 'icons/roguetown/misc/composter.dmi'
	icon_state = "composter"
	density = TRUE
	max_integrity = 200
	anchored = TRUE
	climbable = TRUE
	climb_offset = 4
	var/unflipped_compost = 0
	var/flipped_compost = 0
	var/ready_compost = 0

/obj/structure/composter/halffull
	ready_compost = MAXIMUM_TOTAL_COMPOST * 0.5

/obj/structure/composter/full
	ready_compost = MAXIMUM_TOTAL_COMPOST

/obj/structure/composter/examine(mob/user)
	. = ..()
	var/show_dry = (unflipped_compost > flipped_compost)
	if(ready_compost > COMPOST_PER_PRODUCED_ITEM)
		. += span_info("There is some ready compost.")
	if(show_dry && unflipped_compost >= COMPOST_PER_PRODUCED_ITEM)
		. += span_warning("The compost requires flipping!")

/obj/structure/composter/Initialize()
	START_PROCESSING(SSprocessing, src)
	update_appearance(UPDATE_OVERLAYS)
	. = ..()

/obj/structure/composter/Destroy()
	STOP_PROCESSING(SSprocessing, src)
	. = ..()

/obj/structure/composter/process()
	var/dt = 10
	var/compost_to_process = min(dt * COMPOST_PROCESS_RATE, flipped_compost)
	// Change flipped compost into most processed compost, and some back unflipped
	flipped_compost -= compost_to_process
	unflipped_compost += compost_to_process * 0.25
	ready_compost += compost_to_process * 0.75

/obj/structure/composter/proc/get_total_compost()
	return unflipped_compost + flipped_compost + ready_compost

/obj/structure/composter/proc/try_handle_flipping_compost(obj/item/attacking_item, mob/user)
	var/using_tool = FALSE
	if(attacking_item)
		if(istype(attacking_item, /obj/item/weapon/pitchfork) || istype(attacking_item, /obj/item/weapon/shovel))
			using_tool = TRUE
			to_chat(user, span_notice("I start flipping the compost..."))
	else
		to_chat(user, span_notice("I start flipping the compost by hand..."))
		playsound(user, "rustle", 50, TRUE)
	var/do_time = using_tool ? 2 SECONDS : 9 SECONDS
	var/fatigue = using_tool ? 10 : 30
	if(do_after(user, get_farming_do_time(user, do_time), src))
		apply_farming_fatigue(user, fatigue)
		if(using_tool)
			playsound(src,'sound/items/dig_shovel.ogg', 100, TRUE)
		addtimer(CALLBACK(src, PROC_REF(flip_compost)), 1 SECONDS)

	return TRUE

/obj/structure/composter/proc/flip_compost()
	var/flip_amount = unflipped_compost
	unflipped_compost -= flip_amount
	flipped_compost += flip_amount
	update_appearance(UPDATE_OVERLAYS)

/obj/structure/composter/proc/try_handle_adding_compost(obj/item/attacking_item, mob/user, batch_process)
	var/compost_value = 0
	if(istype(attacking_item, /obj/item/reagent_containers/food/snacks))
		compost_value = 150
	if(istype(attacking_item, /obj/item/alch/herb))
		compost_value = 150
	if(istype(attacking_item, /obj/item/natural/chaff))
		compost_value = 150
	if(istype(attacking_item, /obj/item/alch/bone))
		compost_value = 100
	if(istype(attacking_item, /obj/item/alch/sinew))
		compost_value = 100
	if(istype(attacking_item, /obj/item/alch/viscera))
		compost_value = 50
	if(istype(attacking_item, /obj/item/trash))
		compost_value = 50
	if(istype(attacking_item, /obj/item/reagent_containers/food/snacks/rotten))
		compost_value = 50
	if(compost_value > 0)
		if(get_total_compost() >= MAXIMUM_TOTAL_COMPOST)
			if(!batch_process)
				to_chat(user, span_warning("There's too much compost!"))
			return FALSE
		unflipped_compost += min(compost_value, MAXIMUM_TOTAL_COMPOST - get_total_compost())
		if(!batch_process)
			to_chat(user, span_notice("I add \the [attacking_item] to \the [src]"))
		qdel(attacking_item)
		update_appearance(UPDATE_OVERLAYS)
		return TRUE
	return FALSE

/obj/structure/composter/proc/try_handle_removing_compost(obj/item/attacking_item, mob/living/user)
	if(ready_compost < COMPOST_PER_PRODUCED_ITEM)
		to_chat(user, span_warning("There's not enough processed compost!"))
		return TRUE
	apply_farming_fatigue(user, 5)
	to_chat(user, span_notice("I take out some ready compost."))
	var/obj/item/fertilizer/compost/compost = take_out_compost()
	if(compost)
		user.put_in_active_hand(compost)
	return TRUE

/obj/structure/composter/proc/take_out_compost()
	if(ready_compost < COMPOST_PER_PRODUCED_ITEM)
		return
	ready_compost -= COMPOST_PER_PRODUCED_ITEM
	. = new /obj/item/fertilizer/compost(get_turf(src))
	update_appearance(UPDATE_OVERLAYS)

/obj/structure/composter/attackby(obj/item/attacking_item, mob/user, list/modifiers)
	user.changeNext_move(CLICK_CD_FAST)
	if(istype(attacking_item,/obj/item/storage/sack) && length(attacking_item.contents))
		if(get_total_compost() >= MAXIMUM_TOTAL_COMPOST)
			to_chat(user, span_warning("There's too much compost!"))
			return
		var/success
		for(var/obj/item/bagged_item in attacking_item.contents)
			if(try_handle_adding_compost(bagged_item, user, batch_process = TRUE))
				success = TRUE
				if(get_total_compost() >= MAXIMUM_TOTAL_COMPOST)
					break
		if(success)
			to_chat(user, span_info("I dump all the compostables inside [attacking_item] into [src]."))
			attacking_item.update_appearance(UPDATE_ICON_STATE)
		else
			to_chat(user, span_warning("There's nothing in [attacking_item] that can be composted."))
		return TRUE
	if(try_handle_adding_compost(attacking_item, user))
		return TRUE
	if(istype(attacking_item, /obj/item/weapon/shovel))
		if(try_handle_bulk_compost_removal(attacking_item, user))
			return TRUE
	. = ..()

/obj/structure/composter/proc/try_handle_bulk_compost_removal(obj/item/attacking_item, mob/living/user)
	if(ready_compost < COMPOST_PER_PRODUCED_ITEM)
		to_chat(user, span_warning("There's not enough processed compost!"))
		return FALSE
	var/amount = FLOOR(ready_compost / COMPOST_PER_PRODUCED_ITEM, 1)
	if(!amount)
		return FALSE
	if(!do_after(user, 3 SECONDS, src))
		return FALSE
	to_chat(user, span_notice("I take out some ready compost."))
	for(var/i = 1 to amount)
		apply_farming_fatigue(user, 5)
		take_out_compost()
	return TRUE

/obj/structure/composter/attack_hand(mob/user)
	user.changeNext_move(CLICK_CD_FAST)
	if(try_handle_removing_compost(null, user, null))
		return
	. = ..()

/obj/structure/composter/attack_hand_secondary(mob/user, list/modifiers)
	. = ..()
	if(. == SECONDARY_ATTACK_CANCEL_ATTACK_CHAIN)
		return
	user.changeNext_move(CLICK_CD_FAST)
	if(try_handle_flipping_compost(null, user))
		return SECONDARY_ATTACK_CANCEL_ATTACK_CHAIN

/obj/structure/composter/attackby_secondary(obj/item/weapon, mob/user, list/modifiers)
	. = ..()
	if(. == SECONDARY_ATTACK_CANCEL_ATTACK_CHAIN)
		return
	user.changeNext_move(CLICK_CD_FAST)
	if(try_handle_flipping_compost(weapon, user))
		return SECONDARY_ATTACK_CANCEL_ATTACK_CHAIN

/obj/structure/composter/update_overlays()
	. = ..()
	var/total_unprocessed = unflipped_compost + flipped_compost
	var/total_processed = ready_compost
	var/show_dry = (unflipped_compost > flipped_compost)
	var/unprocesed_dry_overlay_name
	if(total_unprocessed >= MAXIMUM_TOTAL_COMPOST * 0.60)
		unprocesed_dry_overlay_name = "pre_compost_heavy_dry"
		. += "pre_compost_heavy"
	else if(total_unprocessed >= MAXIMUM_TOTAL_COMPOST * 0.30)
		unprocesed_dry_overlay_name = "pre_compost_mid_dry"
		. += "pre_compost_mid"
	else if (total_unprocessed >= COMPOST_PER_PRODUCED_ITEM)
		unprocesed_dry_overlay_name = "pre_compost_low_dry"
		. += "pre_compost_low"

	if(show_dry && unprocesed_dry_overlay_name)
		var/mutable_appearance/dry_ma = mutable_appearance(\
			icon,\
			unprocesed_dry_overlay_name,\
			color = "#ffbb6d",\
			alpha = 40,\
		)
		. += dry_ma

	if(total_processed >= MAXIMUM_TOTAL_COMPOST * 0.60)
		. += "post_compost_heavy"
	else if(total_processed >= MAXIMUM_TOTAL_COMPOST * 0.30)
		. += "post_compost_mid"
	else if (total_processed >= COMPOST_PER_PRODUCED_ITEM)
		. += "post_compost_low"

#undef MAXIMUM_TOTAL_COMPOST
#undef COMPOST_PER_PRODUCED_ITEM
#undef COMPOST_PROCESS_RATE
