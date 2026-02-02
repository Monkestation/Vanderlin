/** # Snacks

Items in the "Snacks" subcategory are food items that people actually eat. The key points are that they are created
already filled with reagents and are destroyed when empty. Additionally, they make a "munching" noise when eaten.

Notes by Darem: Food in the "snacks" subtype can hold a maximum of 50 units. Generally speaking, you don't want to go over 40
total for the item because you want to leave space for extra condiments. If you want effect besides healing, add a reagent for
it. Try to stick to existing reagents when possible (so if you want a stronger healing effect, just use omnizine). On use
effect (such as the old officer eating a donut code) requires a unique reagent (unless you can figure out a better way).

The nutriment reagent and bitesize variable replace the old heal_amt and amount variables. Each unit of nutriment is equal to
2 of the old heal_amt variable. Bitesize is the rate at which the reagents are consumed. So if you have 6 nutriment and a
bitesize of 2, then it'll take 3 bites to eat. Unlike the old system, the contained reagents are evenly spread among all
the bites. No more contained reagents = no more bites.

Here is an example of the new formatting for anyone who wants to add more food items.
```
/obj/item/reagent_containers/food/snacks/xenoburger			//Identification path for the object.
	name = "Xenoburger"													//Name that displays in the UI.
	desc = ""						//Duh
	icon_state = "xburger"												//Refers to an icon in food.dmi
/obj/item/reagent_containers/food/snacks/xenoburger/Initialize()		//Don't mess with this. | nO I WILL MESS WITH THIS
	. = ..()														//Same here.
	reagents.add_reagent(/datum/reagent/xenomicrobes, 10)						//This is what is in the food item. you may copy/paste
	reagents.add_reagent(/datum/reagent/consumable/nutriment, 2)							//this line of code for all the contents.
	bitesize = 3													//This is the amount each bite consumes.
```

All foods are distributed among various categories. Use common sense.
*/
/obj/item/reagent_containers/food/snacks
	name = "snack"
	desc = ""
	icon = 'icons/roguetown/items/food.dmi'
	icon_state = null
	lefthand_file = 'icons/roguetown/onmob/lefthand.dmi'
	righthand_file = 'icons/roguetown/onmob/righthand.dmi'

	obj_flags = UNIQUE_RENAME
	grind_results = list() //To let them be ground up to transfer their reagents
	possible_item_intents = list(/datum/intent/food)
	foodtype = GRAIN
	list_reagents = list(/datum/reagent/consumable/nutriment = 1)
	w_class = WEIGHT_CLASS_SMALL
	var/transfers_tastes = FALSE
	var/bitesize = 3 // how many times you need to bite to consume it fully
	var/bitecount = 0
	var/trash = null
	var/slice_path    // for sliceable food. path of the item resulting from the slicing
	var/slice_bclass = BCLASS_CUT
	var/slices_num
	var/slice_batch = TRUE
	var/eatverb
	var/dried_type = null
	var/dry = 0
	var/dunkable = FALSE // for dunkable food, make true
	var/dunk_amount = 10 // how much reagent is transferred per dunk
	var/filling_color = "#FFFFFF" //color to use when added to custom food.
	var/custom_food_type = null  //for food customizing. path of the custom food to create
	var/junkiness = 0  //for junk food. used to lower human satiety.
	var/list/bonus_reagents //the amount of reagents (usually nutriment and vitamin) added to crafted/cooked snacks, on top of the ingredients reagents.
	var/customfoodfilling = 1 // whether it can be used as filling in custom food
	var/list/tastes  // for example list("crisps" = 2, "salt" = 1)
	var/naturalist = FALSE

	var/cooking = 0
	var/cooktime = 25 SECONDS
	var/burning = 0
	var/burntime = 5 MINUTES
	var/warming		//if greater than 0, have a brief period where the food buff applies while its still hot. On 2025-02-05 testing didn´t show it did anything. ROGTODO.

	var/cooked_color = "#91665c"
	var/burned_color = "#302d2d"

	var/ingredient_size = 1
	var/eat_effect
	var/rotprocess = FALSE
	var/become_rot_type = null

	var/mill_result = null

	var/fertamount = 50

	drop_sound = 'sound/foley/dropsound/food_drop.ogg'
	smeltresult = /obj/item/fertilizer/ash
	//Placeholder for effect that trigger on eating that aren't tied to reagents.

	var/chopping_sound = FALSE // does it play a choppy sound when batch sliced?
	var/slice_sound = FALSE // does it play the slice sound when sliced?

	var/cooked_smell

	var/list/sizemod = null
	var/list/raritymod = null

	var/modified = FALSE // for tracking if food has been changed

	var/biting // if TRUE changes the icon state to the bitecount, for stuff like handpies. Will break unless you also set a base_icon_state
	var/rot_away_timer

/obj/item/reagent_containers/food/snacks/Initialize(mapload)
	. = ..()
	if(rotprocess)
		SSticker.OnRoundstart(CALLBACK(src, PROC_REF(begin_rotting)))

/obj/item/reagent_containers/food/snacks/Destroy()
	if(reagents)
		QDEL_NULL(reagents)
	deltimer(rot_away_timer)
	return ..()

/datum/intent/food
	name = "feed"
	noaa = TRUE
	icon_state = "infeed"
	rmb_ranged = TRUE
	no_attack = TRUE

/datum/intent/food/rmb_ranged(atom/target, mob/user)
	if(ismob(target))
		var/mob/M = target
		var/list/targetl = list(target)
		var/obj/item/master = get_master_item()
		if(!master)
			return
		user.visible_message("<span class='green'>[user] beckons [M] with [master].</span>", "<span class='green'>I beckon [M] with [master].</span>", ignored_mobs = targetl)
		if(M.client)
			if(M.can_see_cone(user))
				to_chat(M, "<span class='green'>[user] beckons me with [master].</span>")
		M.food_tempted(master, user)

/obj/item/reagent_containers/food/snacks/fire_act(added, maxstacks)
	burning(1 MINUTES)

/obj/item/reagent_containers/food/snacks/proc/begin_rotting()
	START_PROCESSING(SSobj, src)

/obj/item/reagent_containers/food/snacks/process()
	..()
	if(QDELETED(src))
		return PROCESS_KILL
	if(rotprocess)
		var/turf/open/T = get_turf(src)
		var/temp_modifier = 1.0
		var/turf_temp =  T?.return_temperature()

		var/obj/structure/closet/dirthole/dirtgrave = recursive_loc_check(src, /obj/structure/closet/dirthole)
		var/obj/structure/closet/crate/chest/chest = recursive_loc_check(src, /obj/structure/closet/crate/chest)
		if(dirtgrave && chest && !dirtgrave.opened && !chest.opened)
			var/temp_mod = T.temperature_modification
			var/amb_temp = turf_temp - temp_mod
			amb_temp = 11 + CEILING(amb_temp * 0.1, 1) // chests in graves act as cellars
			turf_temp = amb_temp + temp_mod

		if(turf_temp)
			if(turf_temp > 20)
				// Each 10 degrees above room temp increases rot rate by 20%
				temp_modifier = 1.0 + ((turf_temp - 20) / 10) * 0.2
				temp_modifier = min(temp_modifier, 3.0) // Cap at 3x speed
			else
				// Each 3 degrees below room temp decreases rot rate by 20%
				temp_modifier = max(0.2, 1.0 - ((20 -turf_temp) / 3) * 0.2)
				// Minimum 0.2x speed (cold slows but doesn't completely stop rot)

		var/obj/structure/fake_machine/vendor = locate(/obj/structure/fake_machine/vendor) in get_turf(src)
		if(!istype(loc, /obj/item/storage/backpack/backpack/artibackpack) || !istype(loc, /obj/structure/closet/crate/chest/magical))
			var/obj/structure/table/located = locate(/obj/structure/table) in loc
			if(located || vendor || chest)
				warming -= 4 * temp_modifier
			else
				warming -= 20 * temp_modifier //ssobj processing has a wait of 20
			if(warming < (-1*rotprocess))
				if(become_rotten())
					STOP_PROCESSING(SSobj, src)
					return PROCESS_KILL

/obj/item/reagent_containers/food/snacks/proc/become_rotten()
	if(QDELETED(src))
		return
	if(!become_rot_type)
		color = "#6c6897"
		var/mutable_appearance/rotflies = mutable_appearance('icons/roguetown/mob/rotten.dmi', "rotten")
		add_overlay(rotflies)
		name = "rotten [initial(name)]"
		eat_effect = /datum/status_effect/debuff/rotfood
		slices_num = 0
		slice_path = null
		cooktime = 0
		modified = TRUE
		rot_away_timer = QDEL_IN_STOPPABLE(src, 15 MINUTES)
		record_round_statistic(STATS_FOOD_ROTTED)
		return TRUE
	if(!ismob(loc) && loc)
		var/obj/item/reagent_containers/NU = new become_rot_type(loc)
		reagents.trans_to(NU.reagents, reagents.maximum_volume)
		qdel(src)
		record_round_statistic(STATS_FOOD_ROTTED)
		return TRUE
	return FALSE

/obj/item/proc/cooking(input as num)
	return

/obj/item/reagent_containers/food/snacks/cooking(input as num, atom/A)
	if(!input)
		return
	if(cooktime)
		if(cooking < cooktime)
			cooking = cooking + input
			if(cooking >= cooktime)
				return heating_act(A)
			warming = 5 MINUTES
			return
	burning(input)

/obj/item/reagent_containers/food/snacks/heating_act(atom/A)
	var/obj/item/result = new /obj/item/reagent_containers/food/snacks/badrecipe(A)
	initialize_cooked_food(result, 1)
	return result

/obj/item/proc/burning(input as num)
	return

/obj/item/reagent_containers/food/snacks/burning(input as num) //used for pans without oil, skips the cooking stage
	if(!input)
		return
	warming = 5 MINUTES
	if(burntime)
		burning = burning + input
		if(eat_effect != /datum/status_effect/debuff/burnedfood)
			if(burning >= burntime)
				color = burned_color
				name = "burned [name]"
				slice_path = null
				eat_effect = /datum/status_effect/debuff/burnedfood
		if(burning > (burntime * 2))
			burn()

/obj/item/reagent_containers/food/snacks/add_initial_reagents()
	if(!LAZYLEN(tastes))
		return ..()
	if(list_reagents)
		for(var/rid in list_reagents)
			var/amount = list_reagents[rid]
			if(rid == /datum/reagent/consumable/nutriment || rid == /datum/reagent/consumable/nutriment/vitamin)
				reagents.add_reagent(rid, amount, tastes.Copy())
			else
				reagents.add_reagent(rid, amount)

/obj/item/reagent_containers/food/snacks/on_consume(mob/living/eater)
	if(!eater)
		return

	var/apply_effect = TRUE
	if(ishuman(eater))
		var/mob/living/carbon/human/human_eater = eater

		if(human_eater.culinary_preferences)
			var/favorite_food_type = human_eater.culinary_preferences[CULINARY_FAVOURITE_FOOD]
			if(favorite_food_type == type)
				if(human_eater.add_stress(/datum/stress_event/favourite_food))
					to_chat(human_eater, span_green("Yum! My favorite food!"))
			else if(ispath(type, favorite_food_type))
				var/obj/item/reagent_containers/food/snacks/favorite_food_instance = favorite_food_type
				var/favorite_food_name = initial(favorite_food_instance.name)
				if(favorite_food_name == name)
					if(human_eater.add_stress(/datum/stress_event/favourite_food))
						to_chat(human_eater, span_green("Yum! My favorite food!"))
			else
				var/obj/item/reagent_containers/food/snacks/favorite_food_instance = favorite_food_type
				var/slice_path = initial(favorite_food_instance.slice_path)
				if(slice_path && type == slice_path)
					if(human_eater.add_stress(/datum/stress_event/favourite_food))
						to_chat(human_eater, span_green("Yum! My favorite food!"))

			var/hated_food_type = human_eater.culinary_preferences[CULINARY_HATED_FOOD]
			if(hated_food_type == type)
				if(human_eater.add_stress(/datum/stress_event/hated_food))
					to_chat(human_eater, span_red("Yuck! My hated food!"))
			else if(ispath(type, hated_food_type))
				var/obj/item/reagent_containers/food/snacks/hated_food_instance = hated_food_type
				var/hated_food_name = initial(hated_food_instance.name)
				if(hated_food_name == name)
					if(human_eater.add_stress(/datum/stress_event/hated_food))
						to_chat(human_eater, span_red("Yuck! My hated food!"))
			else
				var/obj/item/reagent_containers/food/snacks/hated_food_instance = hated_food_type
				var/slice_path = initial(hated_food_instance.slice_path)
				if(slice_path && type == slice_path)
					if(human_eater.add_stress(/datum/stress_event/hated_food))
						to_chat(human_eater, span_red("Yuck! My hated food!"))

		if (!HAS_TRAIT(human_eater, TRAIT_NASTY_EATER))
			if (human_eater.is_noble())
				if (!portable)
					if(!(locate(/obj/structure/table) in range(1, eater)))
						eater.add_stress(/datum/stress_event/noble_ate_without_table) // look i just had to okay?
						if (prob(25))
							to_chat(eater, span_red("I should really eat this at a table..."))
					if(!(locate(/obj/item/plate) in range(1, eater)))
						eater.add_stress(/datum/stress_event/noble_ate_without_plate)
				switch (faretype)
					if (FARE_IMPOVERISHED)
						eater.add_stress(/datum/stress_event/noble_impoverished_food)
						to_chat(eater, span_red("This is disgusting... how can anyone eat this?"))
						if (eater.nutrition >= NUTRITION_LEVEL_STARVING)
							eater.taste(reagents)
							return
						else
							if (eater.has_stress_type(/datum/stress_event/noble_impoverished_food))
								eater.add_stress(/datum/stress_event/noble_desperate)
							apply_effect = FALSE
					if (FARE_POOR to FARE_NEUTRAL)
						eater.add_stress(/datum/stress_event/noble_bland_food)
						if (prob(25))
							to_chat(eater, span_red("This is rather bland. I deserve better food than this..."))
						apply_effect = FALSE
					if (FARE_FINE)
						eater.remove_stress(/datum/stress_event/noble_bland_food)
					if (FARE_LAVISH)
						eater.remove_stress(/datum/stress_event/noble_bland_food)
						eater.add_stress(/datum/stress_event/noble_lavish_food)
						if (prob(25))
							to_chat(eater, span_green("Ah, food fit for my title."))

			// yeomen and courtiers are also used to a better quality of life but are way less picky
			if (human_eater.is_yeoman() || human_eater.is_courtier())
				switch (faretype)
					if (FARE_IMPOVERISHED)
						eater.add_stress(/datum/stress_event/noble_bland_food)
						apply_effect = FALSE
						if (prob(25))
							to_chat(eater, span_red("This is rather bland. I deserve better food than this..."))
					if (FARE_POOR to FARE_LAVISH)
						eater.remove_stress(/datum/stress_event/noble_bland_food)

	if(eat_effect && apply_effect)
		if(islist(eat_effect))
			for(var/effect in eat_effect)
				eater.apply_status_effect(effect)
		else
			eater.apply_status_effect(eat_effect)
	eater.taste(reagents)

	if(!reagents.total_volume)
		record_featured_stat(FEATURED_STATS_EATERS, eater)
		record_featured_object_stat(FEATURED_STATS_FOOD, name)
		if(faretype == FARE_LAVISH || faretype == FARE_FINE)
			record_round_statistic(STATS_LUXURIOUS_FOOD_EATEN)
		if(eat_effect == /datum/status_effect/debuff/rotfood)
			SEND_SIGNAL(eater, COMSIG_ROTTEN_FOOD_EATEN, src)
		var/old_loc = loc
		var/obj/item/trash = generate_trash(drop_location())
		qdel(src)
		if(trash && isliving(old_loc))
			var/mob/living/L = old_loc
			L.put_in_hands(trash)

	update_appearance(UPDATE_ICON_STATE)

/obj/item/reagent_containers/food/snacks/attack_self(mob/user, list/modifiers)
	return

/obj/item/reagent_containers/food/snacks/attack(mob/living/M, mob/living/user, list/modifiers)
	if(user.used_intent.type != /datum/intent/food && (!(M == user) && isanimal(M)))
		return ..()
	if(!eatverb)
		eatverb = pick("bite","chew","nibble","gnaw","gobble","chomp")

	if(iscarbon(M))
		if(!canconsume(M, user))
			return FALSE

		var/obj/item/kitchen/fork/fork_check = user.get_active_held_item()
		var/obj/item/plate/plate_check

		if(istype(loc,/obj/item/plate))
			plate_check = loc

		if(fork_check)
			if(!plate_check)
				if(HAS_TRAIT(M,TRAIT_NOBLE))
					M.add_stress(/datum/stress_event/noble_ate_with_just_a_fork)
			else
				if(plate_check.dirty)
					M.add_stress(/datum/stress_event/dirty_platter)
				else if(faretype != FARE_LAVISH && !plate_check.dirty)
					faretype += 1
				plate_check.fork_usages +=1
				if(plate_check.fork_usages >= plate_check.max_fork_usages && !plate_check.dirty)
					plate_check.dirty = TRUE
					var/datum/component/particle_spewer = plate_check.GetComponent(/datum/component/particle_spewer/sparkle)
					if(particle_spewer)
						qdel(particle_spewer)
					plate_check.update_appearance(UPDATE_OVERLAYS)

		if(M == user)								//If you're eating it myself.
			switch(M.nutrition)
				if(NUTRITION_LEVEL_FAT to INFINITY)
					user.visible_message("<span class='notice'>[user] forces [M.p_them()]self to eat \the [src].</span>", "<span class='notice'>I force myself to eat \the [src].</span>")
				if(NUTRITION_LEVEL_STARVING to NUTRITION_LEVEL_FAT)
					user.visible_message("<span class='notice'>[user] [eatverb]s \the [src].</span>", "<span class='notice'>I [eatverb] \the [src].</span>")
				if(0 to NUTRITION_LEVEL_STARVING)
					user.visible_message("<span class='notice'>[user] hungrily [eatverb]s \the [src], gobbling it down!</span>", "<span class='notice'>I hungrily [eatverb] \the [src], gobbling it down!</span>")
					M.changeNext_move(CLICK_CD_MELEE * 0.5)
		else
			if(!isbrain(M))		//If you're feeding it to someone else.
				if(M.nutrition in NUTRITION_LEVEL_FAT to INFINITY)
					M.visible_message("<span class='warning'>[user] cannot force any more of [src] down [M]'s throat!</span>", \
										"<span class='warning'>[user] cannot force any more of [src] down your throat!</span>")
					return FALSE
				else
					M.visible_message("<span class='danger'>[user] tries to feed [M] [src].</span>", \
										"<span class='danger'>[user] tries to feed me [src].</span>")
				if(iscarbon(M))
					var/mob/living/carbon/C = M
					var/obj/item/bodypart/CH = C.get_bodypart(BODY_ZONE_HEAD)
					if(C.cmode)
						if(!CH.grabbedby)
							to_chat(user, "<span class='info'>[C.p_they(TRUE)] steals [C.p_their()] face from it.</span>")
							return FALSE
				if(!do_after(user, 3 SECONDS, M))
					return
				log_combat(user, M, "fed", reagents.log_list())
			else
				to_chat(user, "<span class='warning'>[M] doesn't seem to have a mouth!</span>")
				return

		if(reagents)								//Handle ingestion of the reagent.
			if(M.satiety > -200)
				M.satiety -= junkiness
			playsound(M,'sound/misc/eat.ogg', rand(30,60), TRUE)
			if(reagents.total_volume)
				SEND_SIGNAL(src, COMSIG_FOOD_EATEN, M, user)
				SEND_SIGNAL(M, COMSIG_MOB_FOOD_EAT, src)
				var/fraction = min(bitesize / reagents.total_volume, 1)
				var/amt2take = reagents.total_volume / (bitesize - bitecount)
				if((bitecount >= bitesize) || (bitesize == 1))
					amt2take = reagents.total_volume

				reagents.trans_to(M, amt2take, transfered_by = user, method = INGEST)

				if(M.has_quirk(/datum/quirk/boon/naturalist) && naturalist)
					for(var/datum/reagent/R in reagents.reagent_list)
						var/bonus_amount = (R.volume / reagents.total_volume) * amt2take * 0.5
						M.reagents.add_reagent(R.type, bonus_amount)

				bitecount++
				on_consume(M)
				checkLiked(fraction, M)
				if(bitecount >= bitesize && !QDELETED(src))
					qdel(src)
				return TRUE
		playsound(M,'sound/misc/eat.ogg', rand(30,60), TRUE)
		qdel(src)
		return FALSE
	else if(isanimal(M))
		var/mob/living/simple_animal/animal = M
		if(animal.eat_food(src))
			animal.eat_food_after(src)
			return TRUE

	return ..()

/obj/item/reagent_containers/food/snacks/examine(mob/user)
	. = ..()
	if(!in_container)
		switch (bitecount)
			if (0)
				return
			if(1)
				. += "[src] was bitten by someone!"
			if(2,3)
				. += "[src] was bitten [bitecount] times!"
			else
				. += "[src] was bitten multiple times!"


/obj/item/reagent_containers/food/snacks/attackby(obj/item/W, mob/user, list/modifiers)
	. = ..()
	if(istype(W, /obj/item/storage))
		..() // -> item/attackby()
		return 0

	if(W.get_sharpness() && W.wlength == WLENGTH_SHORT)
		if((slices_num <= 0 || !slices_num) || !slice_path) //is the food sliceable?
			return FALSE
		if(slice_bclass == BCLASS_CHOP)
			user.visible_message("<span class='notice'>[user] chops [src]!</span>")
			slice(W, user)
			user.nobles_seen_servant_work()
			return TRUE
		if(slice_bclass == BCLASS_CUT)
			user.visible_message("<span class='notice'>[user] slices [src]!</span>")
			slice(W, user)
			user.nobles_seen_servant_work()
			return TRUE
		else if(slice(W, user))
			user.nobles_seen_servant_work()
			return TRUE

/obj/item/reagent_containers/food/snacks/proc/slice(obj/item/W, mob/user)
	if((slices_num <= 0 || !slices_num) || !slice_path) //is the food sliceable?
		return FALSE

	if ( \
			!isturf(src.loc) || \
			(!(locate(/obj/structure/table) in src.loc) && \
			!(locate(/obj/structure/table/optable) in src.loc) && \
			!(locate(/obj/item/plate) in src.loc)) \
		)
		to_chat(user, "<span class='warning'>I need to use a table.</span>")
		return FALSE

	if(slice_sound)
		playsound(user, 'sound/foley/slicing.ogg', 60, TRUE, -1) // added some choppy sound
	if(chopping_sound)
		playsound(user, 'sound/foley/chopping_block.ogg', 60, TRUE, -1) // added some choppy sound
	if(slice_batch)
		if(!do_after(user, 3 SECONDS, src))
			return FALSE
		var/reagents_per_slice = reagents.total_volume/slices_num
		for(var/i in 1 to slices_num)
			var/obj/item/reagent_containers/food/snacks/slice = new slice_path(loc)
			slice.filling_color = filling_color
			initialize_slice(slice, reagents_per_slice)
		qdel(src)
	else
		var/reagents_per_slice = reagents.total_volume/slices_num
		var/obj/item/reagent_containers/food/snacks/slice = new slice_path(loc)
		slice.filling_color = filling_color
		initialize_slice(slice, reagents_per_slice)
		slices_num--
		if(slices_num == 1)
			slice = new slice_path(loc)
			slice.filling_color = filling_color
			initialize_slice(slice, reagents_per_slice)
			qdel(src)
			return TRUE
		if(slices_num <= 0)
			qdel(src)
			return TRUE
		update_appearance(UPDATE_ICON_STATE)
	return TRUE

/obj/item/reagent_containers/food/snacks/proc/initialize_slice(obj/item/reagent_containers/food/snacks/slice, reagents_per_slice)
	slice.create_reagents(slice.volume)
	reagents.trans_to(slice,reagents_per_slice)
	slice.filling_color = filling_color
	slice.update_snack_overlays(src)
	slice.set_quality(recipe_quality)

/obj/item/reagent_containers/food/snacks/proc/generate_trash(atom/location)
	if(trash)
		if(ispath(trash, /obj/item))
			. = new trash(location)
			trash = null
		else if(isitem(trash))
			var/obj/item/trash_item = trash
			trash_item.forceMove(location)
			. = trash
			trash = null

/obj/item/reagent_containers/food/snacks/proc/update_snack_overlays(obj/item/reagent_containers/food/snacks/S)
	cut_overlays()
	var/mutable_appearance/filling = mutable_appearance(icon, "[initial(icon_state)]_filling")
	filling.color = filling_color

	add_overlay(filling)

// initialize_cooked_food() is called when microwaving the food
/obj/item/reagent_containers/food/snacks/proc/initialize_cooked_food(obj/item/reagent_containers/food/snacks/S, cooking_efficiency = 1)
	if(reagents)
		reagents.trans_to(S, reagents.total_volume)
	if(S.bonus_reagents && S.bonus_reagents.len)
		for(var/r_id in S.bonus_reagents)
			var/amount = S.bonus_reagents[r_id] * cooking_efficiency
			if(r_id == /datum/reagent/consumable/nutriment || r_id == /datum/reagent/consumable/nutriment/vitamin)
				S.reagents.add_reagent(r_id, amount)
			else
				S.reagents.add_reagent(r_id, amount)

	if(transfers_tastes)
		S.foodtype |= foodtype
		S.tastes |= tastes

	S.filling_color = filling_color
	S.update_snack_overlays(src)

/obj/item/reagent_containers/food/snacks/proc/changefood(path, mob/living/eater)
	if(!path || !eater)
		return
	var/turf/T = get_turf(eater)
	if(eater.dropItemToGround(src))
		qdel(src)
	var/obj/item/I = new path(T)
	eater.put_in_active_hand(I, ignore_animation = TRUE)

/obj/item/reagent_containers/food/snacks/attack_animal(mob/M)
	if(isanimal(M))
		if(iscat(M))
			var/mob/living/simple_animal/pet/cat/L = M
			if(bitecount == 0 || prob(50))
				M.emote("me", 1, "nibbles away at \the [src]")
			bitecount++
			SEND_SIGNAL(L, COMSIG_MOB_FEED, src, 30)
			playsound(L, 'sound/misc/eat.ogg', 25, TRUE)
			L.taste(reagents) // why should carbons get all the fun?
			if(bitecount >= 5)
				var/sattisfaction_text = pick("burps from enjoyment", "meows for more", "looks at the area where \the [src] was")
				if(sattisfaction_text)
					M.emote("me", 1, "[sattisfaction_text]")
				qdel(src)

/obj/item/reagent_containers/food/snacks/afterattack(obj/item/reagent_containers/M, mob/user, proximity, list/modifiers)
	. = ..()
	if(!dunkable || !proximity)
		return
	if(istype(M, /obj/item/reagent_containers/glass))	//you can dunk dunkable snacks into beakers or drinks
		if(!M.is_drainable())
			to_chat(user, "<span class='warning'>[M] is unable to be dunked in!</span>")
			return
		if(M.reagents.trans_to(src, dunk_amount, transfered_by = user))	//if reagents were transfered, show the message
			to_chat(user, "<span class='notice'>I dunk \the [src] into \the [M].</span>")
			return
		if(!M.reagents.total_volume)
			to_chat(user, "<span class='warning'>[M] is empty!</span>")
		else
			to_chat(user, "<span class='warning'>[src] is full!</span>")

// //////////////////////////////////////////////Store////////////////////////////////////////
/// All the food items that can store an item inside itself, like bread or cake.
/obj/item/reagent_containers/food/snacks/store
	w_class = WEIGHT_CLASS_NORMAL
	var/stored_item = 0

/obj/item/reagent_containers/food/snacks/store/attackby(obj/item/W, mob/living/user, list/modifiers)
	..()
	if(W.w_class <= WEIGHT_CLASS_SMALL & !istype(W, /obj/item/reagent_containers/food/snacks)) //can't slip snacks inside, they're used for custom foods.
		if(W.get_sharpness())
			return 0
		if(stored_item)
			return 0
		if(!iscarbon(user))
			return 0
		if(contents.len >= 20)
			to_chat(user, "<span class='warning'>[src] is full.</span>")
			return 0
		to_chat(user, "<span class='notice'>I slip [W] inside [src].</span>")
		user.transferItemToLoc(W, src)
		add_fingerprint(user)
		contents += W
		stored_item = 1
		return 1 // no afterattack here

/obj/item/reagent_containers/food/snacks/MouseDrop(atom/over)
	var/turf/T = get_turf(src)
	var/obj/structure/table/TB = locate(/obj/structure/table) in T
	if(TB)
		TB.MouseDrop(over)
	else
		return ..()

/obj/item/reagent_containers/food/snacks/update_icon_state()
	. = ..()
	if(biting && bitecount)
		icon_state = "[base_icon_state][bitecount]"


/obj/item/reagent_containers/food/snacks/badrecipe
	name = "burned mess"
	desc = ""
	icon_state = "badrecipe"
	list_reagents = list(/datum/reagent/toxin/bad_food = 30)
	filling_color = "#8B4513"
	faretype = FARE_IMPOVERISHED
	foodtype = GROSS
	burntime = 0
	cooktime = 0


// Proc to handle visuals from plating
/obj/item/reagent_containers/food/snacks/proc/plated()
	icon = 'icons/roguetown/items/food.dmi'
	item_state = "plate_food"
	experimental_inhand = FALSE
	inhand_x_dimension = 32
	inhand_y_dimension = 32
	drop_sound = 'sound/foley/dropsound/wooden_drop.ogg'

// Proc for important vars when reaching meal level
/obj/item/reagent_containers/food/snacks/proc/meal_properties()
	modified = TRUE
	rotprocess = SHELFLIFE_DECENT
	bitesize = 5

// A way to insert quality naming when the procs dont fire
/obj/item/reagent_containers/food/snacks/proc/good_quality_descriptors()
	switch(rand(1,4))
		if(1)
			name = "good [name]"
		if(2)
			name = "fine [name]"
		if(3)
			name = "appealing [name]"
		if(4)
			name = "nice [name]"
	filling_color = filling_color
	update_snack_overlays(src)
