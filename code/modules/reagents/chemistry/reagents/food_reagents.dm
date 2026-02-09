///////////////////////////////////////////////////////////////////
					//Food Reagents
//////////////////////////////////////////////////////////////////


// Part of the food code. Also is where all the food
// 	condiments, additives, and such go.


/datum/reagent/consumable
	name = "Consumable"
	taste_description = "generic food"
	taste_mult = 4
	metabolization_rate = REAGENTS_METABOLISM
	var/nutriment_factor = 1
	var/hydration_factor = 0
	var/quality = 0	//affects mood, typically higher for mixed drinks with more complex recipes

/datum/reagent/consumable/on_mob_life(mob/living/carbon/M)
	if(ishuman(M))
		var/mob/living/carbon/human/H = M
		if(!HAS_TRAIT(H, TRAIT_NOHUNGER))
			var/actual_metabolized = min(volume, metabolization_rate)
			H.adjust_nutrition(nutriment_factor * actual_metabolized)
			H.adjust_hydration(hydration_factor * actual_metabolized)
	return ..()

/datum/reagent/consumable/reaction_mob(mob/living/M, method=TOUCH, reac_volume)
	if ((method & INGEST) && ishuman(M))
		var/mob/living/carbon/human/HM = M

		if(HM.culinary_preferences)
			var/favorite_drink_type = HM.culinary_preferences[CULINARY_FAVOURITE_DRINK]
			if(favorite_drink_type == type)
				if(HM.add_stress(/datum/stress_event/favourite_drink))
					to_chat(HM, span_green("Yum! My favorite drink!"))
			else if(ispath(type, favorite_drink_type))
				var/datum/reagent/consumable/favorite_drink_instance = favorite_drink_type
				var/favorite_drink_name = initial(favorite_drink_instance.name)
				if(favorite_drink_name == name)
					if(HM.add_stress(/datum/stress_event/favourite_drink))
						to_chat(HM, span_green("Yum! My favorite drink!"))

			var/hated_drink_type = HM.culinary_preferences[CULINARY_HATED_DRINK]
			if(hated_drink_type == type)
				if(HM.add_stress(/datum/stress_event/hated_drink))
					to_chat(HM, span_red("Yuck! My hated drink!"))
			else if(ispath(type, hated_drink_type))
				var/datum/reagent/consumable/hated_drink_instance = hated_drink_type
				var/hated_drink_name = initial(hated_drink_instance.name)
				if(hated_drink_name == name)
					if(HM.add_stress(/datum/stress_event/hated_drink))
						to_chat(HM, span_red("Yuck! My hated drink!"))

		if (quality)
			switch (quality)
				if (DRINK_NICE)
					M.add_stress(/datum/stress_event/wine_okay)
					if (prob(25))
						to_chat(M, span_green("Not bad."))
					if (HM.is_noble() || HM.is_courtier() || HM.is_yeoman())
						M.remove_stress(/datum/stress_event/noble_bland_food)
				if (DRINK_GOOD)
					M.add_stress(/datum/stress_event/wine_good)
					if (prob(25))
						to_chat(M, span_green("A fine beverage."))
					if (HM.is_noble() || HM.is_courtier() || HM.is_yeoman())
						M.remove_stress(list(/datum/stress_event/noble_impoverished_food, /datum/stress_event/noble_bland_food))
				if (DRINK_VERYGOOD to DRINK_FANTASTIC)
					if (HM.is_noble() || HM.is_courtier() || HM.is_yeoman())
						M.add_stress(/datum/stress_event/wine_great)
						M.remove_stress(list(/datum/stress_event/noble_desperate, /datum/stress_event/noble_impoverished_food, /datum/stress_event/noble_bland_food, /datum/stress_event/noble_bad_manners, /datum/stress_event/noble_ate_without_table))
						if (prob(25))
							to_chat(M, span_blue("Absolutely exquisite!"))
					else
						M.add_stress(/datum/stress_event/wine_good)
						if (prob(25))
							to_chat(M, span_green("Complex, but good."))
	return ..()

/datum/reagent/consumable/nutriment
	name = "Nutriment"
	description = "All the vitamins, minerals, and carbohydrates the body needs in pure form."
	reagent_state = SOLID
	nutriment_factor = 35 //EVERY 1 NUTRIMENT RESTORES 35 NUTRITION
	color = "#664330" // rgb: 102, 67, 48

	var/brute_heal = 0
	var/burn_heal = 0

/datum/reagent/consumable/nutriment/on_mob_life(mob/living/carbon/M)
	if(prob(50))
		M.heal_bodypart_damage(brute_heal,burn_heal, 0)
		. = 1
	..()

/datum/reagent/consumable/nutriment/on_new(list/supplied_data)
	. = ..()
	if(!data)
		return
	// taste data can sometimes be ("salt" = 3, "chips" = 1)
	// and we want it to be in the form ("salt" = 0.75, "chips" = 0.25)
	// which is called "normalizing"
	if(!supplied_data)
		supplied_data = data

	// if data isn't an associative list, this has some WEIRD side effects
	// TODO probably check for assoc list?

	data = counterlist_normalise(supplied_data)

/datum/reagent/consumable/nutriment/on_merge(list/newdata, newvolume)
	. = ..()
	if(!islist(newdata) || !newdata.len)
		return

	// data for nutriment is one or more (flavour -> ratio)
	// where all the ratio values adds up to 1

	var/list/taste_amounts = list()
	if(data)
		taste_amounts = data.Copy()

	counterlist_scale(taste_amounts, volume)

	var/list/other_taste_amounts = newdata.Copy()
	counterlist_scale(other_taste_amounts, newvolume)

	counterlist_combine(taste_amounts, other_taste_amounts)

	counterlist_normalise(taste_amounts)

	data = taste_amounts

/datum/reagent/consumable/nutriment/vitamin
	name = "Vitamin"
	description = "All the best vitamins, minerals, and carbohydrates the body needs in pure form."

	brute_heal = 1
	burn_heal = 1

/datum/reagent/consumable/nutriment/vitamin/on_mob_life(mob/living/carbon/M)
	if(M.satiety < 600)
		M.satiety += 30
	. = ..()

/datum/reagent/consumable/sugar
	name = "Sugar"
	description = "The organic compound commonly known as table sugar and sometimes called saccharose. This white, odorless, crystalline powder has a pleasing, sweet taste."
	reagent_state = SOLID
	color = "#FFFFFF" // rgb: 255, 255, 255
	taste_mult = 1.5 // stop sugar drowning out other flavours
	nutriment_factor = 10 * REAGENTS_METABOLISM
	metabolization_rate = 2 * REAGENTS_METABOLISM
	overdose_threshold = 200 // Hyperglycaemic shock
	taste_description = "sweetness"

/datum/reagent/consumable/sugar/overdose_start(mob/living/M)
	to_chat(M, "<span class='danger'>I go into hyperglycaemic shock! Lay off the twinkies!</span>")
	M.AdjustSleeping(600)
	. = 1

/datum/reagent/consumable/sugar/overdose_process(mob/living/M)
	M.AdjustSleeping(40)
	..()
	. = 1

/datum/reagent/consumable/sugar/molasses
	name ="Molasses"
	color = "#835c5c"

/datum/reagent/consumable/sodiumchloride
	name = "Table Salt"
	description = "A salt made of sodium chloride. Commonly used to season food."
	reagent_state = SOLID
	color = "#FFFFFF" // rgb: 255,255,255
	taste_description = "salt"

/datum/reagent/consumable/sodiumchloride/reaction_turf(turf/T, reac_volume) //Creates an umbra-blocking salt pile
	if(!istype(T))
		return
	if(reac_volume < 1)
		return
	new/obj/effect/decal/cleanable/food/salt(T)

/datum/reagent/consumable/blackpepper
	name = "Black Pepper"
	description = "A powder ground from peppercorns. *AAAACHOOO*"
	reagent_state = SOLID
	// no color (ie, black)
	taste_description = "pepper"


/datum/reagent/drug/mushroomhallucinogen
	name = "Mushroom Hallucinogen"
	description = "A strong hallucinogenic drug derived from certain species of mushroom."
	color = "#E700E7" // rgb: 231, 0, 231
	metabolization_rate = 0.2 * REAGENTS_METABOLISM
	taste_description = "mushroom"

/datum/reagent/drug/mushroomhallucinogen/on_mob_life(mob/living/carbon/M)
	if(!M.slurring)
		M.slurring = 1
	switch(current_cycle)
		if(1 to 5)
			M.set_dizzy(10 SECONDS)
			M.set_drugginess(30 SECONDS)
			if(prob(10))
				M.emote(pick("twitch","giggle"))
		if(5 to 10)
			M.adjust_jitter(10 SECONDS)
			M.set_dizzy(20 SECONDS)
			M.set_drugginess(35 SECONDS)
			if(prob(20))
				M.emote(pick("twitch","giggle"))
		if (10 to INFINITY)
			M.adjust_jitter(20 SECONDS)
			M.set_dizzy(30 SECONDS)
			M.set_drugginess(40 SECONDS)
			if(prob(30))
				M.emote(pick("twitch","giggle"))
	..()

/datum/reagent/consumable/eggyolk
	name = "Egg Yolk"
	description = "It's full of protein."
	nutriment_factor = 3 * REAGENTS_METABOLISM
	color = "#FFB500"
	taste_description = "egg"

/datum/reagent/consumable/honey
	name = "Honey"
	description = "Sweet, sweet honey that decays into sugar. Has antibacterial and natural healing properties."
	color = "#d3a308"
	nutriment_factor = 15 * REAGENTS_METABOLISM
	metabolization_rate = 1 * REAGENTS_METABOLISM
	taste_description = "sweetness"

/datum/reagent/consumable/honey/on_mob_life(mob/living/carbon/M)
	M.reagents.add_reagent(/datum/reagent/consumable/sugar,3)
	if(prob(55))
		M.adjustBruteLoss(-1*REM, 0)
		M.adjustFireLoss(-1*REM, 0)
		M.adjustOxyLoss(-1*REM, 0)
		M.adjustToxLoss(-1*REM, 0)
	..()
