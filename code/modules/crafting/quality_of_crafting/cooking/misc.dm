/proc/calculate_food_quality(cooking_skill, ingredient_quality, freshness, quality_modifier = 1.0)
	var/skill_factor = cooking_skill / 6
	var/freshness_factor = min(1, freshness / (5 MINUTES))

	var/skill_component = skill_factor * 1.5
	var/ingredient_component = ingredient_quality * 0.5
	var/freshness_component = freshness_factor * 0.5
	var/modifier_component = quality_modifier * 0.5
	var/final_quality = 1 + skill_component + ingredient_component + freshness_component + modifier_component
	// Ensures no skill = max quality 1, 1 skill = max quality 2, etc.
	var/skill_cap = 1 + cooking_skill

	// Apply both the skill cap and the absolute maximum of 4
	return min(4, min(skill_cap, final_quality))

// Shared method to apply quality descriptions to food
/proc/apply_food_quality(obj/item/reagent_containers/food/snacks/food_item, quality, rot_threshold = -0.5)
	food_item.eat_effect = null  // Clear previous effect

	// We only apply description changes if quality is good (2+) or really poor (rotting)
	if(quality <= rot_threshold)  // Bad quality - close to rotting
		food_item.name = pick("unappealing", "sloppy", "failed", "woeful", "soggy", "bland") + " [initial(food_item.name)]"
		food_item.desc = pick("It is made without love or care.",
							"It barely looks like food.",
							"It is a disgrace to cooking.",
							"Cooking that might cause a divorce.",
							"If there be gods of cooking they must be dead.",
							"Is this food?")
		food_item.tastes |= list("blandness" = 1)
		return

	// Normal quality (1-2) - keep default name/description
	if(quality < 2)
		return

	// Good quality (2+)
	if(quality >= 2 && quality < 3)
		food_item.eat_effect = /datum/status_effect/buff/foodbuff
		food_item.name = pick("tasty", "well-made", "appealing") + " [initial(food_item.name)]"
		food_item.desc = "[initial(food_item.desc)] It looks good."
		return

	// Great quality (3+)
	if(quality >= 3 && quality < 4)
		food_item.eat_effect = /datum/status_effect/buff/foodbuff
		food_item.name = pick("fine", "tasty", "well-made", "appealing", "appetising", "savory", "flavorful") + " [initial(food_item.name)]"
		food_item.desc = "[initial(food_item.desc)] [pick("It looks tasty.",
													"It smells good.",
													"This is fine cooking.",
													"It seem to call out to you.",
													"Your mouth waters at the sight.",
													"It will make a fine meal.",
													"It looks like good eating.")]"
		return

	// Masterful quality (4)
	if(quality >= 4)
		food_item.eat_effect = /datum/status_effect/buff/foodbuff
		food_item.name = pick("masterful", "exquisite", "perfected", "gourmet", "delicious") + " [initial(food_item.name)]"
		food_item.desc = "[initial(food_item.desc)] [pick("It looks perfect.",
													"It smells like heaven.",
													"It is a triumph of cooking.",
													"It is fit for royalty.",
													"It is a masterwork.")]"

/datum/repeatable_crafting_recipe/cooking
	abstract_type = /datum/repeatable_crafting_recipe/cooking
	skillcraft = /datum/skill/craft/cooking
	var/quality_modifier = 1.0  // Base modifier for recipe quality

/datum/repeatable_crafting_recipe/cooking/create_outputs(list/to_delete, mob/user)
	var/list/outputs = list()
	var/total_freshness = 0
	var/ingredient_count = 0
	var/highest_quality = 0

	// Calculate average freshness and find highest quality ingredient
	for(var/obj/item/reagent_containers/food_item in to_delete)
		if(istype(food_item, /obj/item/reagent_containers/food/snacks) || istype(food_item, /obj/item/grown))
			ingredient_count++

			// Check warming value for freshness (higher means fresher)
			if(istype(food_item, /obj/item/reagent_containers/food/snacks))
				var/obj/item/reagent_containers/food/snacks/F = food_item
				total_freshness += max(0, (F.warming + F.rotprocess))
				highest_quality = max(highest_quality, F.quality)

			// Handle crops/grown items
			else if(istype(food_item, /obj/item/reagent_containers/food/snacks/produce))
				var/obj/item/reagent_containers/food/snacks/produce/G = food_item
				highest_quality = max(highest_quality, G.crop_quality - 1)

	// Calculate average freshness
	var/average_freshness = (ingredient_count > 0) ? (total_freshness / ingredient_count) : 0

	// Get the user's cooking skill
	var/cooking_skill = user.get_skill_level(/datum/skill/craft/cooking)

	// Create output items
	for(var/spawn_count = 1 to output_amount)
		var/obj/item/reagent_containers/food/snacks/new_item = new output(get_turf(user))
		new_item.sellprice = sellprice
		new_item.randomize_price()

		// Apply freshness to the new food item
		new_item.warming = min(5 MINUTES, average_freshness)

		// Calculate final quality based on ingredients, skill, and recipe
		var/final_quality = calculate_quality(cooking_skill, highest_quality, average_freshness)
		new_item.quality = round(final_quality)

		// Apply descriptive modifications based on quality
		apply_quality_description(new_item, final_quality)

		if(length(pass_types_in_end))
			var/list/parts = list()
			for(var/obj/item/listed as anything in to_delete)
				if(!is_type_in_list(listed, pass_types_in_end))
					continue
				parts += listed
			new_item.CheckParts(parts)

		new_item.OnCrafted(user.dir, user)

		outputs += new_item

	return outputs

/datum/repeatable_crafting_recipe/cooking/proc/calculate_quality(cooking_skill, ingredient_quality, freshness)
	return calculate_food_quality(cooking_skill, ingredient_quality, freshness, quality_modifier)

/datum/repeatable_crafting_recipe/cooking/proc/apply_quality_description(obj/item/reagent_containers/food/snacks/food_item, quality)
	apply_food_quality(food_item, quality)


/datum/repeatable_crafting_recipe/cooking/soap
	name = "soap"
	tool_usage = list(
		/obj/item/pestle = list("starts to grind materials in the mortar", "start to grind materials in the mortar", 'sound/foley/mortarpestle.ogg'),
	)

	reagent_requirements = list(
		/datum/reagent/water = 10,
	)
	requirements = list(
		/obj/item/ash = 1,
		/obj/item/reagent_containers/food/snacks/fat = 1,
	)
	output = /obj/item/soap
	starting_atom = /obj/item/pestle
	attacked_atom = /obj/item/reagent_containers/glass/mortar
	tool_use_time = 4 SECONDS
	craft_time = 6 SECONDS

/datum/repeatable_crafting_recipe/cooking/soap/bath
	name = "herbal soap "
	tool_usage = list(
		/obj/item/pestle = list("starts to grind materials in the mortar", "start to grind materials in the mortar", 'sound/foley/mortarpestle.ogg'),
	)

	requirements = list(
		/obj/item/ash = 1,
		/obj/item/reagent_containers/food/snacks/fat = 1,
		/obj/item/alch/mentha = 1,
	)
	output = /obj/item/soap/bath

/datum/repeatable_crafting_recipe/cooking/apple_fritter_raw
	name = "Raw Apple Fritter"

	requirements = list(
		/obj/item/reagent_containers/food/snacks/produce/fruit/apple = 1,
		/obj/item/reagent_containers/food/snacks/butterdough_slice = 1,
	)
	attacked_atom = /obj/item/reagent_containers/food/snacks/butterdough_slice
	starting_atom = /obj/item/reagent_containers/food/snacks/produce/fruit/apple
	output = /obj/item/reagent_containers/food/snacks/foodbase/fritter_raw
	uses_attacked_atom = TRUE
	required_table = TRUE
	craft_time = 6 SECONDS
	crafting_sound = 'sound/foley/dropsound/food_drop.ogg'
	crafting_message = "Adding apple bits to the dough..."
	extra_chance = 100

/datum/repeatable_crafting_recipe/cooking/apple_fritter_raw/create_outputs(list/to_delete, mob/user)
	var/output_path = output
	if(user.get_skill_level(/datum/skill/craft/cooking) >= 2)
		output_path =  /obj/item/reagent_containers/food/snacks/foodbase/fritter_raw/good
	var/list/outputs = list()

	for(var/spawn_count = 1 to output_amount)
		var/obj/item/new_item = new output_path(get_turf(user))

		new_item.sellprice = sellprice
		new_item.randomize_price()

		if(length(pass_types_in_end))
			var/list/parts = list()
			for(var/obj/item/listed as anything in to_delete)
				if(!is_type_in_list(listed, pass_types_in_end))
					continue
				parts += listed
			new_item.CheckParts(parts)

		new_item.OnCrafted(user.dir, user)

		outputs += new_item

	return outputs

/datum/repeatable_crafting_recipe/cooking/beef_mett
	name = "Grenzel Mett"

	requirements = list(
		/obj/item/reagent_containers/food/snacks/veg/onion_sliced = 1,
		/obj/item/reagent_containers/food/snacks/meat/mince/beef = 1,
	)
	required_table = TRUE
	attacked_atom = /obj/item/reagent_containers/food/snacks/meat/mince/beef
	starting_atom = /obj/item/reagent_containers/food/snacks/veg/onion_sliced
	output = /obj/item/reagent_containers/food/snacks/meat/mince/beef/mett
	uses_attacked_atom = TRUE
	craft_time = 5 SECONDS
	crafting_sound = 'sound/foley/kneading_alt.ogg'
	crafting_message = "Kneading onions into the mince..."
	extra_chance = 100

/datum/repeatable_crafting_recipe/cooking/raw_sausage
	name = "Fatty Raw Sausage"

	requirements = list(
		/obj/item/reagent_containers/food/snacks/fat = 1,
		/obj/item/reagent_containers/food/snacks/meat/mince = 1,
	)
	subtypes_allowed = TRUE
	required_table = TRUE
	attacked_atom = /obj/item/reagent_containers/food/snacks/meat/mince
	starting_atom = /obj/item/reagent_containers/food/snacks/fat
	output = /obj/item/reagent_containers/food/snacks/meat/sausage
	uses_attacked_atom = TRUE
	craft_time = 9 SECONDS
	crafting_sound = 'sound/foley/dropsound/food_drop.ogg'
	crafting_message = "Stuffing a wiener..."
	extra_chance = 100

/datum/repeatable_crafting_recipe/cooking/raw_sausage_inverse
	hides_from_books = TRUE
	name = "Fatty Raw Sausage"

	requirements = list(
		/obj/item/reagent_containers/food/snacks/fat = 1,
		/obj/item/reagent_containers/food/snacks/meat/mince = 1,
	)
	subtypes_allowed = TRUE
	required_table = TRUE
	attacked_atom = /obj/item/reagent_containers/food/snacks/fat
	starting_atom = /obj/item/reagent_containers/food/snacks/meat/mince
	output = /obj/item/reagent_containers/food/snacks/meat/sausage
	uses_attacked_atom = TRUE
	craft_time = 9 SECONDS
	crafting_sound = 'sound/foley/dropsound/food_drop.ogg'
	crafting_message = "Stuffing a wiener..."
	extra_chance = 100

/datum/repeatable_crafting_recipe/cooking/raw_sausage_alt
	name = "Lean Raw Sausage"

	requirements = list(
		/obj/item/reagent_containers/food/snacks/meat/mince = 2,
	)
	subtypes_allowed = TRUE
	required_table = TRUE
	attacked_atom = /obj/item/reagent_containers/food/snacks/meat/mince
	starting_atom = /obj/item/reagent_containers/food/snacks/meat/mince
	output = /obj/item/reagent_containers/food/snacks/meat/sausage
	uses_attacked_atom = TRUE
	craft_time = 9 SECONDS
	crafting_sound = 'sound/foley/dropsound/food_drop.ogg'
	crafting_message = "Stuffing a wiener..."
	extra_chance = 100

/datum/repeatable_crafting_recipe/cooking/pestranstick
	name = "Pestran Stick"

	requirements = list(
		/obj/item/reagent_containers/food/snacks/butter = 1,
		/obj/item/grown/log/tree/stick = 1,
	)
	required_table = TRUE
	attacked_atom = /obj/item/reagent_containers/food/snacks/butter
	starting_atom = /obj/item/grown/log/tree/stick
	output = /obj/item/reagent_containers/food/snacks/pestranstick
	uses_attacked_atom = TRUE
	craft_time = 5 SECONDS
	crafting_sound = 'sound/foley/dropsound/food_drop.ogg'
	crafting_message = "Skewering the butter..."
	extra_chance = 100

/datum/repeatable_crafting_recipe/cooking/twoegg
	name = "Twin Eggs"

	requirements = list(
		/obj/item/reagent_containers/food/snacks/cooked/egg = 2,
	)
	required_table = TRUE
	attacked_atom = /obj/item/reagent_containers/food/snacks/cooked/egg
	starting_atom = /obj/item/reagent_containers/food/snacks/cooked/egg
	output = /obj/item/reagent_containers/food/snacks/cooked/twin_egg
	uses_attacked_atom = TRUE
	craft_time = 5 SECONDS
	crafting_sound = 'sound/foley/dropsound/food_drop.ogg'
	extra_chance = 100

/datum/repeatable_crafting_recipe/cooking/valorian_omlette
	name = "Valorian Omlette"

	requirements = list(
		/obj/item/reagent_containers/food/snacks/cooked/twin_egg = 1,
		/obj/item/reagent_containers/food/snacks/cheese_wedge = 1,
	)
	required_table = TRUE
	attacked_atom = /obj/item/reagent_containers/food/snacks/cooked/twin_egg
	starting_atom = /obj/item/reagent_containers/food/snacks/cheese_wedge
	output = /obj/item/reagent_containers/food/snacks/cooked/valorian_omlette
	uses_attacked_atom = TRUE
	craft_time = 5 SECONDS
	crafting_sound = 'sound/foley/dropsound/food_drop.ogg'
	extra_chance = 100

/datum/repeatable_crafting_recipe/cooking/royal_truffle
	name = "Royal Truffles"

	requirements = list(
		/obj/item/reagent_containers/food/snacks/cooked/ham = 1,
		/obj/item/reagent_containers/food/snacks/cooked/truffle = 1,
	)
	required_table = TRUE
	attacked_atom = /obj/item/reagent_containers/food/snacks/cooked/ham
	starting_atom = /obj/item/reagent_containers/food/snacks/cooked/truffle
	output = /obj/item/reagent_containers/food/snacks/cooked/royal_truffle
	uses_attacked_atom = TRUE
	craft_time = 2 SECONDS
	crafting_sound = 'sound/foley/dropsound/food_drop.ogg'
	extra_chance = 100

/datum/repeatable_crafting_recipe/cooking/royal_truffle_toxic
	hides_from_books = TRUE
	name = "Royal Truffles"

	requirements = list(
		/obj/item/reagent_containers/food/snacks/cooked/ham = 1,
		/obj/item/reagent_containers/food/snacks/cooked/truffle_toxic = 1,
	)
	required_table = TRUE
	attacked_atom = /obj/item/reagent_containers/food/snacks/cooked/ham
	starting_atom = /obj/item/reagent_containers/food/snacks/cooked/truffle_toxic
	output = /obj/item/reagent_containers/food/snacks/cooked/royal_truffle/toxin
	uses_attacked_atom = TRUE
	craft_time = 2 SECONDS
	crafting_sound = 'sound/foley/dropsound/food_drop.ogg'
	extra_chance = 100
