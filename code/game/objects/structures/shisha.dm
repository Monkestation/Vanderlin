/obj/structure/fluff/statue/shisha
	name = "shisha pipe"
	desc = "A traditional shisha pipe. It looks like it could be packed and smoked."
	icon = 'icons/roguetown/misc/64x64.dmi'
	icon_state = "zbuski"
	density = FALSE
	anchored = TRUE
	layer = ABOVE_MOB_LAYER
	plane = GAME_PLANE_UPPER
	blade_dulling = DULLING_BASH
	max_integrity = 300
	SET_BASE_PIXEL(-10, 0)

	var/datum/reagents/liquid_contents
	var/liquid_max_volume = 100

	var/obj/item/bowl_contents = null
	var/bowl_reagent_amount = 20

	var/smoke_interval = 8
	var/smoke_timer = 0

	var/mob/living/current_smoker = null

	var/puffs_remaining = 0
	var/puffs_per_pack_base = 24
	var/puffs_per_coal = 8

	var/list/loaded_coals = list()
	var/list/coal_puff_counts = list()
	var/max_coals = 3


/obj/structure/fluff/statue/shisha/Initialize(mapload)
	. = ..()
	liquid_contents = new /datum/reagents(liquid_max_volume)
	liquid_contents.my_atom = src


/obj/structure/fluff/statue/shisha/Destroy()
	QDEL_NULL(liquid_contents)
	if(bowl_contents)
		qdel(bowl_contents)
		bowl_contents = null
	for(var/obj/item/ore/coal/C in loaded_coals)
		qdel(C)
	loaded_coals.Cut()
	coal_puff_counts.Cut()
	stop_smoking()
	return ..()


/obj/structure/fluff/statue/shisha/examine(mob/user)
	. = ..()
	if(length(loaded_coals))
		. += span_notice("It has [length(loaded_coals)] coal\s loaded on top.")
	else
		. += span_warning("No coals are loaded. Add some ore coal to heat the bowl.")
	if(bowl_contents)
		. += span_notice("The bowl is packed with [bowl_contents.name]. ([puffs_remaining] puffs remaining.)")
	else
		. += span_warning("The bowl is empty.")
	if(liquid_contents.total_volume > 0)
		. += span_notice("The base contains [liquid_contents.total_volume]u of liquid.")
	else
		. += span_warning("The base is dry.")
	if(current_smoker)
		. += span_notice("[current_smoker.name] is smoking from it.")
	else
		. += span_notice("Click it to smoke.")


/obj/structure/fluff/statue/shisha/attack_hand(mob/living/user, list/modifiers)
	if(!user.Adjacent(src))
		return

	if(current_smoker == user)
		stop_smoking()
		to_chat(user, span_notice("You pull away from the [name]."))
		return

	if(current_smoker)
		to_chat(user, span_warning("[current_smoker.name] is already using the [name]."))
		return

	if(!length(loaded_coals))
		to_chat(user, span_warning("There are no coals loaded. Place some coal on top first."))
		return

	if(!bowl_contents || puffs_remaining <= 0)
		to_chat(user, span_warning("The bowl is empty. Pack it with something first."))
		return

	if(liquid_contents.total_volume <= 0)
		to_chat(user, span_warning("The base is dry. Add some liquid first."))
		return

	start_smoking(user)


/obj/structure/fluff/statue/shisha/attackby(obj/item/I, mob/living/user, params)
	if(istype(I, /obj/item/ore/coal))
		if(length(loaded_coals) >= max_coals)
			to_chat(user, span_warning("The hookah already has [max_coals] coals loaded. That's the max."))
			return
		user.transferItemToLoc(I, src)
		loaded_coals += I
		coal_puff_counts[I] = 0
		puffs_remaining = bowl_contents ? calc_puffs() : 0
		to_chat(user, span_notice("You place the coal on top of the hookah. ([length(loaded_coals)]/[max_coals] coals)"))
		return

	if(istype(I, /obj/item/reagent_containers/glass))
		var/obj/item/reagent_containers/glass/container = I
		if(!container.is_open_container())
			return
		if(liquid_contents.total_volume >= liquid_max_volume)
			to_chat(user, span_warning("The base is already full."))
			return
		I.reagents.trans_to(liquid_contents, min(I.reagents.total_volume, liquid_max_volume - liquid_contents.total_volume))
		to_chat(user, span_notice("You pour liquid into the base of the [name]."))
		return

	if(istype(I, /obj/item/reagent_containers/powder))
		if(bowl_contents)
			to_chat(user, span_warning("The bowl is already packed. Empty it first."))
			return
		user.transferItemToLoc(I, src)
		bowl_contents = I
		puffs_remaining = calc_puffs()
		to_chat(user, span_notice("You pack the bowl with [I.name]."))
		return

	if(istype(I, /obj/item/reagent_containers/food/snacks))
		if(bowl_contents)
			to_chat(user, span_warning("The bowl is already packed. Empty it first."))
			return
		user.transferItemToLoc(I, src)
		bowl_contents = I
		puffs_remaining = calc_puffs()
		to_chat(user, span_notice("You crumble [I.name] into the bowl of the [name]."))
		return

	return ..()


/obj/structure/fluff/statue/shisha/proc/calc_puffs()
	var/n = length(loaded_coals)
	return max(puffs_per_pack_base - ((n - 1) * 2), 2)


/obj/structure/fluff/statue/shisha/proc/empty_bowl(mob/living/user)
	if(!bowl_contents)
		to_chat(user, span_warning("The bowl is already empty."))
		return
	bowl_contents.forceMove(get_turf(src))
	bowl_contents = null
	puffs_remaining = 0
	to_chat(user, span_notice("You empty the bowl of the [name]."))


/obj/structure/fluff/statue/shisha/proc/start_smoking(mob/living/user)
	current_smoker = user
	var/n = length(loaded_coals)
	var/heat_desc = n >= 3 ? "fierce" : n == 2 ? "comfortable" : "gentle"
	to_chat(user, span_notice("You settle in and take a draw from the [name]. The [heat_desc] heat of the coals warms the bowl."))
	visible_message(span_notice("[user.name] begins smoking the [name]."))
	AddComponent(/datum/component/rope, user, \
		icon = 'icons/effects/beam.dmi', \
		icon_state = "shisha", \
		maximum_rope_distance = 3, \
		rope_broken_callback = CALLBACK(src, PROC_REF(on_rope_broken)), \
		override_origin_pixel_x = 10, \
		override_origin_pixel_y = 20)
	START_PROCESSING(SSobj, src)
	icon_state = "zbuski-smoker"


/obj/structure/fluff/statue/shisha/proc/stop_smoking()
	if(!current_smoker)
		return
	var/mob/living/was_smoker = current_smoker
	current_smoker = null
	STOP_PROCESSING(SSobj, src)
	qdel(GetComponent(/datum/component/rope))
	visible_message(span_notice("[was_smoker.name] pulls away from the [name]."))
	icon_state = "zbuski"


/obj/structure/fluff/statue/shisha/proc/on_rope_broken()
	if(current_smoker)
		to_chat(current_smoker, span_warning("You wander too far from the [name] and lose your draw."))
	stop_smoking()


/obj/structure/fluff/statue/shisha/process(delta_time)
	if(!current_smoker || !bowl_contents)
		stop_smoking()
		return PROCESS_KILL

	smoke_timer += delta_time
	if(smoke_timer < smoke_interval)
		return

	smoke_timer = 0
	deliver_puff()


/obj/structure/fluff/statue/shisha/proc/deliver_puff()
	if(!bowl_contents || puffs_remaining <= 0)
		to_chat(current_smoker, span_warning("The bowl has burned out."))
		stop_smoking()
		return

	var/n = length(loaded_coals)

	if(n >= 3 && prob(25))
		to_chat(current_smoker, span_warning("The coal runs too hot, a scorching hit sears your throat!"))
		current_smoker.adjustOrganLoss(ORGAN_SLOT_LUNGS, 5)
	else if(n == 2 && prob(8))
		to_chat(current_smoker, span_warning("A slightly harsh hit catches the back of your throat."))
		current_smoker.adjustOrganLoss(ORGAN_SLOT_LUNGS, 2)

	if(bowl_contents.reagents && bowl_contents.reagents.total_volume > 0)
		var/coal_bonus = (n - 1) * 5
		var/transfer_amount = min(bowl_reagent_amount + coal_bonus, bowl_contents.reagents.total_volume)
		bowl_contents.reagents.trans_to(current_smoker, transfer_amount, method = INGEST)

	if(liquid_contents && liquid_contents.total_volume > 0)
		var/liquid_transfer = min(5, liquid_contents.total_volume)
		liquid_contents.trans_to(current_smoker, liquid_transfer, method = INGEST)

	puffs_remaining--

	var/turf/T = get_turf(current_smoker)
	T.pollute_turf(/datum/pollutant/smoke, 120 + (n * 40))

	if(n >= 3)
		to_chat(current_smoker, span_notice("You take a deep, intense draw. Rich smoke floods your lungs."))
		visible_message(span_notice("[current_smoker.name] exhales a thick cloud of smoke."))
	else if(n == 2)
		to_chat(current_smoker, span_notice("You take a smooth, full draw from the [name]. Fragrant smoke fills your lungs."))
		visible_message(span_notice("[current_smoker.name] exhales a steady cloud of smoke."))
	else
		to_chat(current_smoker, span_notice("You take a soft, mild draw from the [name]. A wisp of lightly scented smoke drifts through."))
		visible_message(span_notice("[current_smoker.name] exhales a thin wisp of smoke."))

	// tick the oldest coal and delete it if spent
	if(length(loaded_coals))
		var/obj/item/ore/coal/C = loaded_coals[1]
		coal_puff_counts[C]++
		if(coal_puff_counts[C] >= puffs_per_coal)
			coal_puff_counts.Remove(C)
			loaded_coals.Remove(C)
			qdel(C)
			to_chat(current_smoker, span_warning("A coal burns out and crumbles away. ([length(loaded_coals)]/[max_coals] remaining)"))
			if(!length(loaded_coals))
				to_chat(current_smoker, span_warning("The last coal dies out. The bowl goes cold."))
				stop_smoking()
				return

	if(puffs_remaining <= 0)
		to_chat(current_smoker, span_warning("The bowl burns out. Time to repack."))
		if(bowl_contents)
			qdel(bowl_contents)
			bowl_contents = null
		stop_smoking()
