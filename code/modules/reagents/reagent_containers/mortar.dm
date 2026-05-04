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
	var/list/to_grind = list()
	// total w_class units allowed
	var/max_grind_capacity = 13

/obj/item/reagent_containers/glass/mortar/Destroy()
	for(var/obj/item/I in to_grind)
		if(!QDELETED(I))
			I.forceMove(get_turf(src))
	to_grind = null
	return ..()

/obj/item/reagent_containers/glass/mortar/attack_hand_secondary(mob/user, list/modifiers)
	if(!to_grind.len)
		return ..()

	user.changeNext_move(CLICK_CD_MELEE)

	for(var/obj/item/I in to_grind)
		I.forceMove(get_turf(user))
	to_grind.Cut()
	balloon_alert(user, "I remove all items from [src].")
	return SECONDARY_ATTACK_CANCEL_ATTACK_CHAIN

/obj/item/reagent_containers/glass/mortar/attackby_secondary(obj/item/weapon, mob/user, list/modifiers)
	. = ..()
	if(. == SECONDARY_ATTACK_CANCEL_ATTACK_CHAIN)
		return
	if(!istype(weapon, /obj/item/pestle))
		return
	if(!to_grind.len)
		to_chat(user, span_warning("There's nothing to grind."))
		return SECONDARY_ATTACK_CANCEL_ATTACK_CHAIN

	// Check all items can actually be juiced/ground
	for(var/obj/item/I in to_grind)
		if(!I.grind_results && !I.juice_results || !I.reagents.total_volume)
			to_chat(user, span_warning("I cannot process [I] this way."))
			return SECONDARY_ATTACK_CANCEL_ATTACK_CHAIN

	var/grind_time = (2.5 SECONDS) + (grind_load() * 3.5)
	grind_time *= min(2, GENERAL_SKILL_TIME_MULITPLIER(user, /datum/attribute/skill/craft/alchemy))
	to_chat(user, span_notice("I start grinding..."))
	if(!do_after(user, grind_time, src))
		return SECONDARY_ATTACK_CANCEL_ATTACK_CHAIN

	for(var/obj/item/I in to_grind)
		if(QDELETED(I))
			continue
		if(length(I.juice_results))
			I.on_juice()
			reagents.add_reagent_list(I.juice_results)
			to_chat(user, span_notice("I juice [I] into a fine liquid."))
			if(I.reagents)
				I.reagents.trans_to(src, I.reagents.total_volume, transfered_by = user)
		else if(length(I.grind_results))
			I.on_grind()
			reagents.add_reagent_list(I.grind_results)
			to_chat(user, span_notice("I break [I] into powder."))
		else
			to_chat(user, span_notice("I grind [I] into a fine liquid."))
			if(I.reagents)
				I.reagents.trans_to(src, I.reagents.total_volume, transfered_by = user)
		qdel(I)
	to_grind.Cut()
	return SECONDARY_ATTACK_CANCEL_ATTACK_CHAIN

/obj/item/reagent_containers/glass/mortar/proc/grind_load()
	var/total = 0
	for(var/obj/item/I in to_grind)
		total += I.w_class
	return total

/obj/item/reagent_containers/glass/mortar/AltClick(mob/user, list/modifiers)
	for(var/obj/item/I in to_grind)
		I.forceMove(get_turf(user))
	to_grind.Cut()

/obj/item/reagent_containers/glass/mortar/attackby(obj/item/I, mob/living/carbon/human/user, list/modifiers)
	if(istype(I, /obj/item/pestle))
		if(!to_grind.len)
			if(user.try_recipes(src, I, user))
				user.changeNext_move(CLICK_CD_FAST)
				return TRUE
			to_chat(user, span_warning("There's nothing to grind."))
			return

		// Validate all items have a recipe before starting
		var/list/recipes = list()
		for(var/obj/item/G in to_grind)
			var/datum/alch_grind_recipe/found = find_recipe(G)
			if(!found)
				to_chat(user, span_warning("[G] doesn't seem to work in here!"))
				return
			recipes[G] = found

		user.visible_message(span_info("[user] begins grinding up the contents of [src]."))
		playsound(src, 'sound/foley/mortarpestle.ogg', 100, FALSE)

		var/grind_time = (2 SECONDS) + (grind_load() * 3)
		grind_time *= min(2, GENERAL_SKILL_TIME_MULITPLIER(user, /datum/attribute/skill/craft/alchemy))
		if(!do_after(user, grind_time, src))
			return

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
		for(var/obj/item/G in to_grind)
			if(QDELETED(G))
				continue
			var/datum/alch_grind_recipe/foundrecipe = recipes[G]
			for(var/output in foundrecipe.valid_outputs)
				for(var/i in 1 to foundrecipe.valid_outputs[output])
					new output(get_turf(src))
			if(foundrecipe.bonus_chance_outputs.len > 0)
				for(var/i in 1 to foundrecipe.bonus_chance_outputs.len)
					if((foundrecipe.bonus_chance_outputs[foundrecipe.bonus_chance_outputs[i]] * bonus_modifier) >= roll(1,100))
						var/obj/item/bonusduck = foundrecipe.bonus_chance_outputs[i]
						new bonusduck(get_turf(src))
			if(!did_flash && (istype(G, /obj/item/ore) || istype(G, /obj/item/ingot)))
				did_flash = TRUE
			QDEL_NULL(G)

		if(did_flash)
			user.flash_fullscreen("whiteflash")
			var/datum/effect_system/spark_spread/S = new()
			S.set_up(1, 1, get_turf(src))
			S.start()

		to_grind.Cut()

		if(user.mind)
			user.adjust_experience(/datum/attribute/skill/craft/alchemy, GET_MOB_ATTRIBUTE_VALUE(user, STAT_INTELLIGENCE) * user.get_learning_boon(/datum/attribute/skill/craft/alchemy), FALSE)
		return

	if((grind_load() + I.w_class) > max_grind_capacity)
		to_chat(user, span_warning("[src] is too full to fit [I]!"))
		return
	if(!user.transferItemToLoc(I, src))
		to_chat(user, span_warning("[I] is stuck to my hand!"))
		. = ..()
		return
	to_grind += I
	to_chat(user, span_notice("I add [I] to [src]."))
	return

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
