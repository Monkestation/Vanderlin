/obj/machinery/light/fueled/smelter
	icon = 'icons/roguetown/misc/forge.dmi'
	name = "stone furnace"
	desc = "A stone furnace, weathered by time and heat."
	icon_state = "cavesmelter0"
	base_state = "cavesmelter"
	anchored = TRUE
	density = TRUE
	climbable = TRUE
	climb_time = 0
	climb_offset = 10
	on = TRUE
	temperature_change = 80
	fueluse = 30 MINUTES
	crossfire = FALSE

	var/list/contained_items = list()
	/// How many items can we contain?
	var/max_contained_items = 1
	/// How many crucibles can we contain?
	var/max_crucible_amount = 1
	/// How long has the furnace been smelting for? Resets when adding an item.
	var/smelting_progress = 0
	/// How high smelting_progress needs to reach before smelting an ore
	var/smelting_threshold = 20
	var/max_crucible_temperature = 1500

/obj/machinery/light/fueled/smelter/examine(mob/user, params)
	. = ..()
	. += span_info("It can hold up to <b>[max_contained_items] items</b>.")
	if(length(contents) && Adjacent(user))
		. += span_notice("Peeking inside, you can see:")
		for(var/obj/item/item as anything in contents)
			. += span_info("- [item]")

/obj/machinery/light/fueled/smelter/attackby(obj/item/attacking_item, mob/living/user, list/modifiers)
	if(istype(attacking_item, /obj/item/weapon/tongs))
		var/obj/item/weapon/tongs/tongs = attacking_item
		if(tongs.held_item)
			try_add_item(tongs.held_item, user, tongs)
		else
			try_retrieve_item(user, tongs)
		return TRUE

	if(attacking_item.firefuel)
		if(alert(usr, "Fuel \the [src] with [attacking_item]?", "VANDERLIN", "Fuel", "Smelt") == "Fuel")
			return ..()

	if(try_add_item(attacking_item, user))
		return TRUE

	return ..()

/obj/machinery/light/fueled/smelter/proc/try_retrieve_item(mob/living/user, obj/item/weapon/tongs/tongs_used)
	. = FALSE
	var/obj/item/retrieved_item
	if(!. && tongs_used && !tongs_used.held_item)
		for(var/obj/item/storage/crucible/crucible in contents)
			user.visible_message("[user] starts removing a crucible from [src].", "You start removing a crucible from [src].")
			if(!do_after(user, 1.5 SECONDS, src))
				return
			tongs_used.set_held_item(crucible)
			retrieved_item = crucible
			. = TRUE

	if(!. && length(contained_items))
		retrieved_item = contained_items[contained_items.len]
		if(tongs_used)
			tongs_used.set_held_item(retrieved_item)
			if(on)
				tongs_used.heat_held_item(source = "smelter", duration = 20 SECONDS, incoming = 150, max_heat = max_crucible_temperature)
				if(istype(tongs_used, /obj/item/weapon/tongs/stone))
					tongs_used.take_damage(1, BRUTE, BLUNT)
		else
			if(on)
				to_chat(user, span_warning("It's too hot to retrieve items with your hands."))
				return
			user.put_in_hands(retrieved_item)
		user.visible_message(span_info("[user] retrieves [retrieved_item] from [src]."))
		contained_items -= retrieved_item
		. = TRUE

	if(.)
		if(HAS_TRAIT(retrieved_item, TRAIT_NEWLY_SMELTED))
			var/mob/living/living_user = user
			var/amt2raise = max(GET_MOB_ATTRIBUTE_VALUE(user, STAT_INTELLIGENCE), 1)
			amt2raise *= living_user.get_learning_boon(/datum/attribute/skill/craft/smelting)
			living_user.mind.add_sleep_experience(/datum/attribute/skill/craft/smelting, amt2raise, FALSE)
			SEND_SIGNAL(living_user, COMSIG_ITEM_SMELTED)
			REMOVE_TRAIT(retrieved_item, TRAIT_NEWLY_SMELTED, TRAIT_GENERIC)

	user.adjust_stamina(user.maximum_stamina / 20)

/obj/machinery/light/fueled/smelter/proc/try_add_item(obj/item/smelting_item, mob/living/user, obj/item/weapon/tongs/tongs_used)
	if(!istype(user))
		return FALSE

	if(istype(smelting_item, /obj/item/storage/crucible))
		var/crucible_count = 0
		for(var/obj/item/storage/crucible/crucible in contents)
			crucible_count++
		if(crucible_count >= max_crucible_amount)
			to_chat(user, span_warning("[src] cannot hold any more crucibles!"))
			return FALSE
		if(smelting_item.loc == user)
			user.transferItemToLoc(smelting_item, src)
		else
			smelting_item.forceMove(src)
		user.visible_message("[user] loads [smelting_item] into [src].", "You load [smelting_item] into [src].")
		return TRUE

	if(!tongs_used && !user.is_holding(smelting_item)) // necessary due to menu popup in attackby()
		return FALSE
	if(!smelting_item.smeltresult)
		to_chat(user, span_warning("[smelting_item] cannot be smelted directly."))
		return FALSE
	if(length(contained_items) >= max_contained_items)
		to_chat(user, span_warning("[src] is full!"))
		return FALSE

	smelting_item.forceMove(src)
	contained_items[smelting_item] = SMELTERY_QUALITY_SPOIL
	var/smelter_exp = GET_MOB_SKILL_VALUE_OLD(user, /datum/attribute/skill/craft/smelting) // 0 to 6
	contained_items[smelting_item] = clamp(floor(rand(smelter_exp*15 + 10, max(30, smelter_exp*25))/SMELTING_DENOMINATOR), SMELTERY_QUALITY_SPOIL, SMELTERY_QUALITY_EXCELLENT) // Math explained below
	/*
	RANDOMLY PICKED NUMBER ACCORDING TO SMELTER SKILL:
		NO SKILL: 		between 10 and 30
		NOVICE:	 		between 25 and 30
		APPRENTICE:	 	between 40 and 50
		JOURNEYMAN: 	between 55 and 75
		EXPERT: 		between 70 and 100
		MASTER: 		between 85 and 125
		LEGENDARY: 		between 100 and 150

	PICKED NUMBER GETS DIVIDED BY SMELTING_DENOMINATOR AND ROUNDED DOWN TO CLOSEST INTEGER.
	RESULT DETERMINES QUALITY OF BAR. SEE code/__DEFINES/qualities.dm
		1 = SPOILED
		2 = POOR
		3 = NORMAL
		4 = GOOD
		5 = GREAT
		6 = EXCELLENT
	*/
	user.visible_message(span_warning("[user] puts something in \the [src]."))
	smelting_progress = 0
	return TRUE

/obj/machinery/light/fueled/smelter/attack_hand(mob/user, list/modifiers)
	if(try_retrieve_item(user))
		return TRUE
	return ..()

/obj/machinery/light/fueled/smelter/process()
	..()
	if(!on || !length(contained_items))
		return
	if(smelting_progress < smelting_threshold)
		smelting_progress++
		playsound(src.loc,'sound/misc/smelter_sound.ogg', 50, FALSE)
		return

	if(smelting_progress == smelting_threshold)
		handle_smelting()

/obj/machinery/light/fueled/smelter/proc/handle_smelting()
	var/list/valid_xp_smelts = typecacheof(list(/obj/item/ore, /obj/item/ingot, /obj/item/natural/glass)) // prevent ash from giving smelting xp
	for(var/obj/item/item_to_smelt in contained_items)
		if(!item_to_smelt.smeltresult)
			continue
		var/obj/item/smelted = new item_to_smelt.smeltresult(src, contained_items[item_to_smelt])
		contained_items -= item_to_smelt
		qdel(item_to_smelt)
		contained_items += smelted
		if(is_type_in_typecache(smelted, valid_xp_smelts))
			ADD_TRAIT(smelted, TRAIT_NEWLY_SMELTED, TRAIT_GENERIC)
	playsound(src,'sound/misc/smelter_fin.ogg', 100, FALSE)
	visible_message(span_notice("[src] finishes smelting."))
	smelting_progress = smelting_threshold + 1

/obj/machinery/light/fueled/smelter/burn_out()
	smelting_progress = 0
	. = ..()

/obj/machinery/light/fueled/smelter/great
	icon = 'icons/roguetown/misc/forge.dmi'
	name = "great furnace"
	desc = "The pinnacle of dwarven engineering and the miracle of Malum's blessed fire crystal, allowing for greater alloys to be made."
	icon_state = "smelter0"
	base_state = "smelter"
	anchored = TRUE
	density = TRUE
	max_contained_items = 4
	fueluse = 5 MINUTES
	climbable = FALSE
	max_crucible_temperature = 2000

/obj/machinery/light/fueled/smelter/great/handle_smelting()
	// Alloy recipes should probably be datumized in the future
	var/alloy
	var/steelalloy
	var/bronzealloy
	var/blacksteelalloy

	for(var/obj/item/item_to_smelt in contained_items)
		var/smelt_result = item_to_smelt.smeltresult
		if(smelt_result == /obj/item/ore/coal)
			steelalloy = steelalloy + 1
		if(smelt_result == /obj/item/ore/coal/charcoal)
			steelalloy = steelalloy + 1
		if(smelt_result == /obj/item/ingot/iron)
			steelalloy = steelalloy + 2
		if(smelt_result == /obj/item/ingot/tin)
			bronzealloy = bronzealloy + 1
		if(smelt_result == /obj/item/ingot/copper)
			bronzealloy = bronzealloy + 2
		if(smelt_result == /obj/item/ingot/silver)
			blacksteelalloy = blacksteelalloy + 1
		if(smelt_result == /obj/item/ingot/steel)
			blacksteelalloy = blacksteelalloy + 2

	if(steelalloy == 7)
		max_contained_items = 3
		alloy = /obj/item/ingot/steel
	else if(bronzealloy == 7)
		alloy = /obj/item/ingot/bronze
	else if(blacksteelalloy == 7)
		alloy = /obj/item/ingot/blacksteel
		max_contained_items = 2

	if(alloy)
		var/floor_mean_quality = 0
		var/ore_deleted = 0
		for(var/obj/item/item in contained_items)
			floor_mean_quality += contained_items[item]
			ore_deleted++
			contained_items -= item
			qdel(item)
		floor_mean_quality = floor(floor_mean_quality/ore_deleted)
		for(var/i in 1 to max_contained_items)
			var/obj/item/result = new alloy(src, floor_mean_quality)
			if(alloy == /obj/item/ingot/blacksteel)
				record_round_statistic(STATS_BLACKSTEEL_SMELTED)
			contained_items += result
			ADD_TRAIT(result, TRAIT_NEWLY_SMELTED, TRAIT_GENERIC)
	else
		var/list/valid_xp_smelts = typecacheof(list(/obj/item/ore, /obj/item/ingot, /obj/item/natural/glass)) // prevent ash from giving smelting xp
		for(var/obj/item/item in contained_items)
			if(!item.smeltresult)
				continue
			var/obj/item/result = new item.smeltresult(src, contained_items[item])
			contained_items -= item
			qdel(item)
			contained_items += result
			if(is_type_in_typecache(result, valid_xp_smelts))
				ADD_TRAIT(result, TRAIT_NEWLY_SMELTED, TRAIT_GENERIC)

	max_contained_items = initial(max_contained_items)
	playsound(src,'sound/misc/smelter_fin.ogg', 100, FALSE)
	visible_message(span_notice("[src] finished smelting."))
	smelting_progress = smelting_threshold + 1
