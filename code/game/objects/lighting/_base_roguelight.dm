/obj/machinery/light/fueled
	icon = 'icons/roguetown/misc/lighting.dmi'
	brightness = 8
	nightshift_allowed = FALSE
	fueluse = 60 MINUTES
	bulb_colour = "#f9ad80"
	bulb_power = 1
	var/datum/looping_sound/soundloop = null // = /datum/looping_sound/fireloop
	pass_flags_self = LETPASSTHROW
	flags_1 = NODECONSTRUCT_1
	var/cookonme = FALSE
	var/crossfire = TRUE
	var/can_damage = FALSE

	var/temperature_change = 20
	var/temperature_weight = 1
	var/temperature_falloff = 0.9

/obj/machinery/light/fueled/Initialize()
	if(soundloop)
		soundloop = new soundloop(src, FALSE)
		soundloop.start()
	GLOB.fires_list += src
	if(fueluse > 0)
		fueluse = fueluse - (rand(fueluse*0.1,fueluse*0.3))
	update_appearance(UPDATE_ICON_STATE)
	seton(TRUE)

	. = ..()

/obj/machinery/light/fueled/Destroy()
	if(soundloop)
		QDEL_NULL(soundloop)
	remove_temp_effect()
	return ..()

/obj/machinery/light/fueled/seton(s)
	. = ..()
	if(temperature_change)
		propagate_temp_change(temperature_change, temperature_weight, temperature_falloff)

/obj/machinery/light/fueled/OnCrafted(dirin, mob/user)
	. = ..()
	can_damage = TRUE
	burn_out()

/obj/machinery/light/fueled/examine(mob/user)
	. = ..()
	if(Adjacent(user))
		if(fueluse > 0)
			var/minsleft = fueluse / 600
			minsleft = round(minsleft)
			if(minsleft <= 1)
				minsleft = "less than a minute"
			else
				minsleft = "[round(minsleft)] minutes"
			. += "<span class='info'>The fire will last for [minsleft].</span>"
		else
			if(initial(fueluse) > 0)
				. += "<span class='warning'>The fire is burned out and hungry...</span>"


/obj/machinery/light/fueled/extinguish()
	if(on)
		burn_out()
		new /obj/effect/temp_visual/small_smoke(src.loc)
	..()

/obj/machinery/light/fueled/burn_out()
	if(soundloop)
		soundloop.stop()
	if(on)
		playsound(src, 'sound/items/firesnuff.ogg', 100)
	..()
	remove_temp_effect()
	update_appearance(UPDATE_ICON_STATE)

/obj/machinery/light/fueled/update_icon_state()
	. = ..()
	icon_state = "[base_state][on]"

/obj/machinery/light/fueled/update()
	. = ..()
	if(on)
		GLOB.fires_list |= src
	else
		GLOB.fires_list -= src

/obj/machinery/light/fueled/Destroy()
	QDEL_NULL(soundloop)
	GLOB.fires_list -= src
	. = ..()

/obj/machinery/light/fueled/fire_act(added, maxstacks)
	if(!on && ((fueluse > 0) || (initial(fueluse) == 0)))
		playsound(src, 'sound/items/firelight.ogg', 100)
		on = TRUE
		update()
		update_appearance(UPDATE_ICON_STATE)
		if(soundloop)
			soundloop.start()
		return TRUE

/obj/machinery/light/fueled/Crossed(atom/movable/AM, oldLoc)
	..()
	if(crossfire)
		if(on)
			AM.fire_act(1,5)

/obj/machinery/light/fueled/spark_act()
	fire_act()

/obj/machinery/light/fueled/attackby(obj/item/W, mob/living/user, list/modifiers)
	if(cookonme)
		if(istype(W, /obj/item/reagent_containers/food/snacks))
			if(istype(W, /obj/item/reagent_containers/food/snacks/egg))
				return FALSE
			var/obj/item/A = user.get_inactive_held_item()
			if(A)
				var/foundstab = FALSE
				for(var/X in A.possible_item_intents)
					var/datum/intent/D = new X
					if(D.blade_class == BCLASS_STAB)
						foundstab = TRUE
						break
				if(foundstab)
					var/prob2spoil = 33
					if(user.get_skill_level(/datum/skill/craft/cooking))
						prob2spoil = 1

					// Check for container craft recipes first
					var/list/possible_recipes = list()
					for(var/recipe_type in subtypesof(/datum/container_craft/pan))
						var/datum/container_craft/recipe = new recipe_type
						if(recipe.used_skill != /datum/skill/craft/cooking)
							continue // Only want cooking recipes

						// Check if our food item matches any recipe requirement
						var/matches_recipe = FALSE
						if(length(recipe.requirements) == 1)
							for(var/required_type in recipe.requirements)
								if(istype(W, required_type))
									matches_recipe = TRUE
									break

						if(!matches_recipe && length(recipe.wildcard_requirements) == 1)
							for(var/wildcard_path in recipe.wildcard_requirements)
								if(istype(W, wildcard_path))
									matches_recipe = TRUE
									break

						if(matches_recipe)
							possible_recipes += recipe

					// If we found valid recipes, let the user choose
					if(length(possible_recipes))
						var/datum/container_craft/chosen_recipe
						if(length(possible_recipes) == 1)
							chosen_recipe = possible_recipes[1]
						else
							var/list/recipe_names = list()
							for(var/datum/container_craft/R in possible_recipes)
								recipe_names[R.name] = R

							var/choice
							if(length(recipe_names) > 1)
								choice = input(user, "Choose a recipe to make:", "Recipe Selection") as null|anything in recipe_names
							else
								choice = recipe_names[1]
							if(!choice)
								return FALSE
							chosen_recipe = recipe_names[choice]

						user.visible_message("<span class='notice'>[user] starts to cook [W] over [src].</span>")
						if(do_after(user, chosen_recipe.crafting_time || (4 SECONDS), src))
							var/obj/item/result
							if(prob(prob2spoil))
								var/obj/item/reagent_containers/food/snacks/S = W
								user.visible_message("<span class='warning'>[user] burns [S].</span>")
								if(user.client?.prefs.showrolls)
									to_chat(user, "<span class='warning'>Critfail... [prob2spoil]%.</span>")
								result = S.cooking(1000, null)
							else if(chosen_recipe.output)
								result = new chosen_recipe.output(get_turf(user))

								// if(istype(result, /obj/item/reagent_containers/food/snacks))
								// 	var/obj/item/reagent_containers/food/snacks/food_result = result
								// 	var/skill_modifier = 1.0
								// 	var/skill_level = user.get_skill_level(chosen_recipe.used_skill)

								// 	if(skill_level)
								// 		skill_modifier += (skill_level * 0.2) // Increase quality by 20% per skill level

								// 	// Apply the recipe's quality modifier alongside skill
								// 	food_result.quality = food_result.quality * skill_modifier * chosen_recipe.quality_modifier

								user.dropItemToGround(W, TRUE)
								qdel(W)

								user.put_in_hands(result)
								user.visible_message("<span class='notice'>[user] finishes cooking [result].</span>")
								to_chat(user, "<span class='notice'>[chosen_recipe.complete_message]</span>")
								user.nobles_seen_servant_work()
								return TRUE
						return FALSE

					// Fall back to normal cooking if no container recipe matches
					user.visible_message("<span class='notice'>[user] starts to cook [W] over [src].</span>")
					for(var/i in 1 to 6)
						if(do_after(user, 3 SECONDS, src))
							var/obj/item/reagent_containers/food/snacks/S = W
							var/obj/item/C
							if(prob(prob2spoil))
								user.visible_message("<span class='warning'>[user] burns [S].</span>")
								if(user.client?.prefs.showrolls)
									to_chat(user, "<span class='warning'>Critfail... [prob2spoil]%.</span>")
								C = S.cooking(1000, null)
							else
								C = S.cooking(S.cooktime/4, src)
							if(C)
								user.dropItemToGround(S, TRUE)
								qdel(S)
								C.forceMove(get_turf(user))
								user.put_in_hands(C)
								break
						else
							break
					return TRUE
	if(W.firefuel)
		if(initial(fueluse))
			if(fueluse > initial(fueluse) - 5 SECONDS)
				to_chat(user, "<span class='warning'>[src] is fully fueled.</span>")
				return
		else
			if(!on)
				return
		if (alert(usr, "Feed [W] to the fire?", "VANDERLIN", "Yes", "No") != "Yes")
			return
		if(!(W in user.held_items)|| !user.temporarilyRemoveItemFromInventory(W))
			return
		qdel(W)
		user.visible_message("<span class='warning'>[user] feeds [W] to [src].</span>")
		if(initial(fueluse))
			fueluse = fueluse + W.firefuel
			if(fueluse > initial(fueluse)) //keep it at the max
				fueluse = initial(fueluse)
		return
	else
		if(on)
			if(istype(W, /obj/item/natural/dirtclod))
				if(!user.temporarilyRemoveItemFromInventory(W))
					return
				on = FALSE
				update()
				update_appearance(UPDATE_ICON_STATE)
				qdel(W)
				src.visible_message("<span class='warning'>[user] snuffs the fire.</span>")
				return
			if(user.used_intent?.type != INTENT_SPLASH)
				W.spark_act()
	. = ..()

/obj/machinery/light/fueled/take_damage(damage_amount, damage_type = BRUTE, damage_flag = 0, sound_effect = 1)
	if(!can_damage)
		return
	. = ..()

/obj/machinery/light/fueled/process()
	. = ..()
	if(on && length(contents)) // burn kobolds in ovens and smelters
		for(var/obj/item/mob_holder/holder in GetAllContents(/obj/item/mob_holder))
			holder.held_mob?.adjust_fire_stacks(5)
			holder.held_mob?.IgniteMob()
			holder.update_appearance()
