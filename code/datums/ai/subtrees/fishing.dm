#define FISHING_COOLDOWN 45 SECONDS

///subtree for fishing and eating food!
/datum/ai_planning_subtree/fish
	///behavior we use to find fishable objects
	var/datum/ai_behavior/find_fishable_behavior = /datum/ai_behavior/find_and_set/in_list
	///behavior we use to fish!
	var/datum/ai_behavior/fishing_behavior = /datum/ai_behavior/fishing
	///blackboard key storing things we can fish from
	var/fishable_list_key = BB_FISHABLE_LIST
	///key where we store found fishable items
	var/fishing_target_key = BB_FISHING_TARGET
	///key where we store our fishing cooldown
	var/fishing_cooldown_key = BB_FISHING_COOLDOWN
	///our fishing range
	var/fishing_range = 5

/datum/ai_planning_subtree/fish/SelectBehaviors(datum/ai_controller/controller, seconds_per_tick)
	if(controller.blackboard[BB_ONLY_FISH_WHILE_HUNGRY] && controller.blackboard[BB_NEXT_HUNGRY] > world.time)
		return
	if(controller.blackboard[BB_FISHING_TIMER] > world.time)
		return
	if(!controller.blackboard_key_exists(fishing_target_key))
		controller.queue_behavior(find_fishable_behavior, fishing_target_key, controller.blackboard[fishable_list_key], fishing_range)
		return
	controller.queue_behavior(/datum/ai_behavior/fishing, fishing_target_key, fishing_cooldown_key)
	return SUBTREE_RETURN_FINISH_PLANNING

///less expensive fishing behavior!
/datum/ai_planning_subtree/fish/fish_from_turfs
	find_fishable_behavior = /datum/ai_behavior/find_and_set/in_list/closest_turf

/datum/ai_behavior/fishing
	behavior_flags = AI_BEHAVIOR_REQUIRE_MOVEMENT | AI_BEHAVIOR_REQUIRE_REACH
	var/clear_target = FALSE
	var/fish_delay = 10 SECONDS

/datum/ai_behavior/fishing/wolf
	fish_delay = 30 SECONDS

/datum/ai_behavior/fishing/setup(datum/ai_controller/controller, target_key)
	. = ..()
	var/turf/open/target = controller.blackboard[target_key]
	if(QDELETED(target))
		return FALSE
	if(!isopenspace(target) && !istype(target, /turf/open/water))
		return FALSE
	if(isopenspace(target))
		var/turf/bottom_turf = GET_TURF_BELOW(target)
		while(istransparentturf(bottom_turf))
			bottom_turf = GET_TURF_BELOW(bottom_turf)
		if(!istype(bottom_turf, /turf/open/water))
			return FALSE

	set_movement_target(controller, target)

/datum/ai_behavior/fishing/perform(seconds_per_tick, datum/ai_controller/controller, target_key)
	var/atom/target = controller.blackboard[target_key]
	if(QDELETED(target))
		finish_action(controller, FALSE)
		return FALSE
	controller.PauseAi(fish_delay)
	if(!do_after(controller.pawn, fish_delay, target))
		controller.PauseAi(0)
		finish_action(controller, FALSE)
		return
	create_fish(controller, target)
	finish_action(controller, TRUE)
	return TRUE

/datum/ai_behavior/fishing/finish_action(datum/ai_controller/controller, succeeded, fishing_target_key, fishing_cooldown_key)
	. = ..()
	if(clear_target || !succeeded)
		controller.clear_blackboard_key(BB_FISHING_TARGET)
	if(!succeeded)
		return
	var/cooldown = controller.blackboard[fishing_cooldown_key] || FISHING_COOLDOWN
	controller.set_blackboard_key(BB_FISHING_TIMER, world.time + cooldown)

/datum/ai_behavior/fishing/proc/create_fish(datum/ai_controller/controller, turf/targeted)
	var/mob/living/fisher = controller.pawn
	var/deepmod = 0
	var/list/fishpicker = list()
	if(!targeted.can_see_sky())
		deepmod += 1

	var/list/deepfishlist = list(/obj/item/reagent_containers/food/snacks/fish/angler = 1)
	if(istype(targeted, /turf/open/water/swamp))
		fishpicker = list(/obj/item/reagent_containers/food/snacks/fish/eel = 6,
							/obj/item/reagent_containers/food/snacks/fish/carp = 2,
							/obj/item/reagent_containers/food/snacks/fish/shrimp = 1)
	else if(istype(targeted, /turf/open/water/swamp/deep))
		fishpicker = list(/obj/item/reagent_containers/food/snacks/fish/eel = 5,
							/obj/item/reagent_containers/food/snacks/fish/carp = 3,
							/obj/item/reagent_containers/food/snacks/fish/shrimp = 1)
		deepmod += 1
	else if(istype(targeted, /turf/open/water/cleanshallow))
		fishpicker = list(/obj/item/reagent_containers/food/snacks/fish/eel = 3,
							/obj/item/reagent_containers/food/snacks/fish/carp = 5)
	else if(istype(targeted, /turf/open/water/river))
		fishpicker = list(/obj/item/reagent_containers/food/snacks/fish/eel = 2,
							/obj/item/reagent_containers/food/snacks/fish/carp = 6)
		deepmod += 1

	while(deepmod > 0)
		fishpicker = pickweightmerge(fishpicker, deepfishlist)
		deepmod--

	var/list/raritypicker = list("com" = 95, "rare" = 5)
	var/list/sizepicker = list("tiny" = 4, "small" = 4, "normal" = 4, "large" = 2)

	if(fisher.STALUC > 10)
		var/luckboost = fisher.STALUC - 10
		var/luckrarity = list("com" = -1, "rare" = 1)
		while(luckboost > 0)
			raritypicker = pickweightmerge(raritypicker, luckrarity)
			luckboost--

	var/trashfishing = FALSE
	var/fishrarity
	var/fishtype
	var/fishsize

	if(prob(16 - fisher.STALUC)) //you will always have a chance at this, legendary fishers got a 10% chance - their luck stat
		fishtype = pickweight(list(/obj/item/natural/fibers = 1, /obj/item/storage/belt/pouch/coins/poor = 1, /obj/item/clothing/shoes/boots/leather = 1, /obj/structure/fermentation_keg = 1, /obj/item/clothing/head/fisherhat = 1))
		trashfishing = TRUE

	if(!trashfishing)
		raritypicker = removenegativeweights(raritypicker)
		sizepicker = removenegativeweights(sizepicker)

		fishsize = pickweightAllowZero(sizepicker)
		fishrarity = pickweightAllowZero(raritypicker)
		fishtype = pickweightAllowZero(fishpicker)

	var/fishchance = 25 + (fisher.STALUC * 3)
	if(prob(fishchance))
		playsound(fisher.loc, 'sound/items/Fish_out.ogg', 100, TRUE)
		var/obj/item/reagent_containers/food/snacks/fish/caughtfish = new fishtype(get_turf(fisher))
		var/raritydesc
		var/sizedesc

		var/costmod = 1
		switch(fishsize)
			if("tiny")
				costmod *= 0.5
			if("small")
				costmod *= 0.75
		switch(fishrarity)
			if("rare")
				costmod *= 2


		switch(fishrarity)
			if("rare")
				raritydesc = "rare"
				caughtfish.rarity_rank = 1
				caughtfish.raritymod = list("com"= -30)//some incentive to use rarer tiny fish as bait
			if("ultra")
				raritydesc = "ultra-rare"
				caughtfish.rarity_rank = 2
				caughtfish.raritymod = list("com"= -50)
			if("gold")
				raritydesc = "legendary"
				caughtfish.rarity_rank = 3
				caughtfish.raritymod = list("com"= -70, "rare" = -20)
			else
				raritydesc = "common"
				caughtfish.rarity_rank = 0
		caughtfish.icon_state = "[caughtfish.icon_state][fishrarity]"
		if(fishrarity != "com")
			caughtfish:rare = TRUE

		switch(fishsize)
			if("tiny")
				caughtfish.sizemod = list("tiny" = -999)//fish can't swallow a fish of the same size
			if("small")
				caughtfish.sizemod = list("tiny" = -999, "small" = -999)
			if("large")
				caughtfish.slices_num = 2
				caughtfish.fishloot = null//can't use fish larger than normal size as bait
			if("prize")
				caughtfish.slices_num = 3
				caughtfish.fishloot = null
			else
				caughtfish.fishloot = null
		sizedesc = fishsize
		caughtfish.name = "[sizedesc] [raritydesc] [caughtfish.name]"
		caughtfish.sellprice *= costmod

#undef FISHING_COOLDOWN
