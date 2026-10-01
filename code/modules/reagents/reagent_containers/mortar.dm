/datum/component/storage/concrete/grid/mortar
	screen_max_rows = 3
	screen_max_columns = 4
	max_w_class = WEIGHT_CLASS_NORMAL

/datum/component/storage/concrete/grid/mortar/can_be_inserted(obj/item/storing, stop_messages, mob/user, worn_check, list/modifiers, storage_click)
	if(istype(storing, /obj/item/pestle))
		if(!stop_messages && user)
			to_chat(user, span_warning("[storing] is a tool, not something to grind!"))
		return FALSE

	var/can_grind = FALSE
	for(var/datum/alch_grind_recipe/grindRec in GLOB.alch_grind_recipes)
		if(grindRec.picky)
			if(storing.type == grindRec.valid_input)
				can_grind = TRUE
				break
		else if(istype(storing, grindRec.valid_input))
			can_grind = TRUE
			break

	if(!can_grind && (length(storing.juice_results) || length(storing.grind_results) || storing.reagents?.total_volume))
		can_grind = TRUE

	if(!can_grind)
		if(!stop_messages && user)
			to_chat(user, span_warning("[storing] can't be ground or processed!"))
		return FALSE

	return ..()

/obj/item/pestle
	name = "pestle"
	desc = ""
	icon = 'icons/roguetown/misc/alchemy.dmi'
	icon_state = "pestle"
	force = 7
	dropshrink = 0.9
	grid_height = 64
	grid_width = 32

/obj/item/reagent_containers/glass/mortar
	name = "mortar"
	desc = "A versatile mortar for both alchemy and reagent processing."
	icon = 'icons/roguetown/misc/alchemy.dmi'
	icon_state = "mortar"
	amount_per_transfer_from_this = 10
	possible_transfer_amounts = list(5, 10, 15, 20, 25, 30, 50, 100)
	volume = 100
	reagent_flags = TRANSFERABLE | AMOUNT_VISIBLE
	spillable = TRUE
	grid_height = 32
	grid_width = 64
	dropshrink = 0.9
	soaker = FALSE
	// total w_class units allowed, mirrors the old max_grind_capacity
	var/max_grind_capacity = 13

/obj/item/reagent_containers/glass/mortar/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/storage/concrete/grid/mortar)

/obj/item/reagent_containers/glass/mortar/examine(mob/user)
	. = ..()
	if(!length(contents))
		return

	. += span_info("It contains:")
	for(var/obj/item/thing in contents)
		. += span_info("[thing.name]")

/obj/item/reagent_containers/glass/mortar/get_mechanics_examine(mob/user)
	. = ..()
	. += span_notice("Right clicking with an empty hand will remove all items inside the mortar.")

/obj/item/reagent_containers/glass/mortar/attack_hand_secondary(mob/user, list/modifiers)
	if(!length(contents))
		return ..()

	balloon_alert(user, "removing items...")
	if(!do_after(user, (grind_load() / 2) SECONDS, src))
		return SECONDARY_ATTACK_CANCEL_ATTACK_CHAIN

	for(var/obj/item/I as anything in contents)
		I.forceMove(get_turf(user))

	balloon_alert(user, "items removed.")

	return SECONDARY_ATTACK_CANCEL_ATTACK_CHAIN

/obj/item/reagent_containers/glass/mortar/item_interaction(mob/living/user, obj/item/tool, list/modifiers)
	if(user.cmode)
		return NONE

	if(!istype(tool, /obj/item/pestle))
		return NONE

	if(!length(contents))
		if(user.try_recipes(src, tool))
			user.changeNext_move(CLICK_CD_FAST)
			return ITEM_INTERACT_SUCCESS
		balloon_alert(user, "nothing to grind!")
		return ITEM_INTERACT_BLOCKING

	var/list/recipes = list()
	for(var/obj/item/grinding in contents)
		var/datum/alch_grind_recipe/found_recipe = find_recipe(grinding)
		if(!found_recipe)
			balloon_alert(user, "can't grind!")
			return ITEM_INTERACT_BLOCKING
		recipes[grinding] = found_recipe

	// Process alchemical recipe
	balloon_alert(user, "grinding...")
	playsound(src, 'sound/foley/mortarpestle.ogg', 100, FALSE)

	var/grind_time = (2 SECONDS) + (grind_load() * 3)
	grind_time *= min(2, GENERAL_SKILL_TIME_MULITPLIER(user, /datum/attribute/skill/craft/alchemy))
	if(!do_after(user, grind_time, src))
		return ITEM_INTERACT_BLOCKING

	var/bonus_modifier = 1
	switch(user.get_learning_boon(/datum/attribute/skill/craft/alchemy))
		if(SKILL_RANK_JOURNEYMAN)
			bonus_modifier = 1.4
		if(SKILL_RANK_EXPERT)
			bonus_modifier = 1.6
		if(SKILL_RANK_MASTER)
			bonus_modifier = 1.8
		if(SKILL_RANK_LEGENDARY)
			bonus_modifier = 2

	var/did_flash = FALSE
	for(var/obj/item/grinding as anything in contents)
		var/datum/alch_grind_recipe/foundrecipe = recipes[grinding]
		for(var/output in foundrecipe.valid_outputs)
			for(var/i in 1 to foundrecipe.valid_outputs[output])
				new output(get_turf(src))

		var/bonus = length(foundrecipe.bonus_chance_outputs)
		if(bonus)
			for(var/i in 1 to bonus)
				if((foundrecipe.bonus_chance_outputs[foundrecipe.bonus_chance_outputs[i]] * bonus_modifier) >= roll(1, 100))
					var/obj/item/bonusduck = foundrecipe.bonus_chance_outputs[i]
					new bonusduck(get_turf(src))

		if(!did_flash && (istype(grinding, /obj/item/ore) || istype(grinding, /obj/item/ingot)))
			did_flash = TRUE

		qdel(grinding)

	if(did_flash)
		user.flash_fullscreen("whiteflash")
		var/datum/effect_system/spark_spread/S = new()
		S.set_up(1, 1, get_turf(src))
		S.start()

	user.adjust_experience(/datum/attribute/skill/craft/alchemy, GET_MOB_ATTRIBUTE_VALUE(user, STAT_INTELLIGENCE) * user.get_learning_boon(/datum/attribute/skill/craft/alchemy), FALSE)

	return ITEM_INTERACT_SUCCESS

/obj/item/reagent_containers/glass/mortar/item_interaction_secondary(mob/living/user, obj/item/tool, list/modifiers)
	if(!istype(tool, /obj/item/pestle))
		return ..()

	if(!length(contents))
		balloon_alert(user, "nothing to grid!")
		return ITEM_INTERACT_BLOCKING

	balloon_alert(user, "grinding...")

	playsound(src, 'sound/foley/mortarpestle.ogg', 100, FALSE)

	var/grind_time = (2.5 SECONDS) + (grind_load() * 3.5)
	grind_time *= min(2, GENERAL_SKILL_TIME_MULITPLIER(user, /datum/attribute/skill/craft/alchemy))
	if(!do_after(user, grind_time, src))
		return ITEM_INTERACT_BLOCKING

	for(var/obj/item/grinding as anything in contents)
		if(length(grinding.juice_results))
			grinding.on_juice()
			reagents.add_reagent_list(grinding.juice_results)
		else if(length(grinding.grind_results))
			grinding.on_grind()
			reagents.add_reagent_list(grinding.grind_results)
		else if(!grinding.reagents?.total_volume)
			continue

		if(grinding.reagents) //food and pills
			grinding.reagents.trans_to(src, grinding.reagents.total_volume, transfered_by = user)

		qdel(grinding)

	return ITEM_INTERACT_SUCCESS

/obj/item/reagent_containers/glass/mortar/proc/grind_load()
	var/total = 0
	for(var/obj/item/I in contents)
		total += I.w_class
	return total

// Looks through all the alch grind recipes to find what it should create, returns the correct one.
/obj/item/reagent_containers/glass/mortar/proc/find_recipe(obj/item/target)
	for(var/datum/alch_grind_recipe/grindRec in GLOB.alch_grind_recipes)
		if(grindRec.picky)
			if(target.type == grindRec.valid_input)
				return grindRec
		else
			if(istype(target, grindRec.valid_input))
				return grindRec
	return null
