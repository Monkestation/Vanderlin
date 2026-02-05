
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
	var/obj/item/to_grind

/obj/item/reagent_containers/glass/mortar/Destroy()
	if(!QDELETED(to_grind))
		to_grind.forceMove(get_turf(src))
	to_grind = null
	return ..()

/obj/item/reagent_containers/glass/mortar/attack_hand_secondary(mob/user, list/modifiers)
	if(!to_grind)
		return ..()

	var/obj/item/thing = to_grind

	thing.forceMove(get_turf(user))
	user.put_in_hands(thing)

	to_grind = null

	balloon_alert(user, "I remove \an [to_grind].")

	return SECONDARY_ATTACK_CANCEL_ATTACK_CHAIN

/obj/item/reagent_containers/glass/mortar/item_interaction(mob/living/user, obj/item/tool, list/modifiers)
	if(!istype(tool, /obj/item/pestle)) // Make this storage based
		if(user.cmode)
			return NONE
		if(!user.transferItemToLoc(tool, src))
			balloon_alert(user, "stuck!")
			return ITEM_INTERACT_BLOCKING
		balloon_alert(user, "added [tool].")
		to_grind = tool
		return ITEM_INTERACT_SUCCESS

	if(!to_grind)
		if(user.try_recipes(src, tool))
			user.changeNext_move(CLICK_CD_FAST)
			return ITEM_INTERACT_SUCCESS
		balloon_alert(user, "nothing to grind!")
		return ITEM_INTERACT_BLOCKING

	// Check for alchemical recipe first
	var/datum/alch_grind_recipe/foundrecipe = find_recipe()
	if(!foundrecipe)
		balloon_alert(user, "can't grind [to_grind]!")
		return ITEM_INTERACT_BLOCKING

	// Process alchemical recipe
	balloon_alert(user, "i start grinding.")
	playsound(src, 'sound/foley/mortarpestle.ogg', 100, FALSE)

	if(!do_after(user, 1 SECONDS, src))
		return ITEM_INTERACT_BLOCKING

	for(var/output in foundrecipe.valid_outputs)
		for(var/i in 1 to foundrecipe.valid_outputs[output])
			new output(get_turf(src))
	var/bonus_modifier = 1
	switch(user.get_learning_boon(/datum/skill/craft/alchemy))
		if(SKILL_LEVEL_JOURNEYMAN)
			bonus_modifier = 1.4
		if(SKILL_LEVEL_EXPERT)
			bonus_modifier = 1.6
		if(SKILL_LEVEL_MASTER)
			bonus_modifier = 1.8
		if(SKILL_LEVEL_LEGENDARY)
			bonus_modifier = 2
	if(foundrecipe.bonus_chance_outputs.len > 0)
		for(var/i in 1 to foundrecipe.bonus_chance_outputs.len)
			if((foundrecipe.bonus_chance_outputs[foundrecipe.bonus_chance_outputs[i]] * bonus_modifier) >= roll(1,100))
				var/obj/item/bonusduck = foundrecipe.bonus_chance_outputs[i]
				new bonusduck(get_turf(src))
	if(istype(to_grind,/obj/item/ore) || istype(to_grind,/obj/item/ingot))
		user.flash_fullscreen("whiteflash")
		var/datum/effect_system/spark_spread/S = new()
		var/turf/front = get_turf(src)
		S.set_up(1, 1, front)
		S.start()

	QDEL_NULL(to_grind)

	user.adjust_experience(/datum/skill/craft/alchemy, user.STAINT * user.get_learning_boon(/datum/skill/craft/alchemy), FALSE)

	return ITEM_INTERACT_SUCCESS

/obj/item/reagent_containers/glass/mortar/item_interaction_secondary(mob/living/user, obj/item/tool, list/modifiers)
	if(!istype(tool, /obj/item/pestle))
		return ..()

	if(!to_grind)
		balloon_alert(user, "nothing to grid!")
		return ITEM_INTERACT_BLOCKING

	if(!length(to_grind.grind_results) && !length(to_grind.juice_results))
		balloon_alert(user, "can't grind [to_grind]!")
		return ITEM_INTERACT_BLOCKING

	balloon_alert(user, "i start grinding.")

	if(!do_after(user, 2.5 SECONDS, src))
		return ITEM_INTERACT_BLOCKING

	if(to_grind.juice_results) //prioritize juicing
		to_grind.on_juice()
		reagents.add_reagent_list(to_grind.juice_results)
	else
		to_grind.on_grind()
		reagents.add_reagent_list(to_grind.grind_results)

	balloon_alert(user, "i grind [to_grind].")

	if(to_grind.reagents) //food and pills
		to_grind.reagents.trans_to(src, to_grind.reagents.total_volume, transfered_by = user)

	QDEL_NULL(to_grind)

	return ITEM_INTERACT_SUCCESS

// Looks through all the alch grind recipes to find what it should create, returns the correct one.
/obj/item/reagent_containers/glass/mortar/proc/find_recipe()
	for(var/datum/alch_grind_recipe/grindRec in GLOB.alch_grind_recipes)
		if(grindRec.picky)
			if(to_grind.type == grindRec.valid_input)
				return grindRec
		else
			if(istype(to_grind,grindRec.valid_input))
				return grindRec
	return null
