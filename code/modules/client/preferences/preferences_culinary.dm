GLOBAL_LIST_EMPTY(selectable_foods)
GLOBAL_LIST_EMPTY(selectable_drinks)
GLOBAL_LIST_EMPTY(cached_food_flat_icons)
GLOBAL_LIST_EMPTY(cached_drink_flat_icons)

/proc/get_cached_food_flat_icon(obj/item/reagent_containers/food/snacks/food_type)
	var/cache_key = "[food_type]"
	if(!GLOB.cached_food_flat_icons[cache_key])
		var/image/dummy = image(initial(food_type.icon), null, initial(food_type.icon_state), initial(food_type.layer))
		GLOB.cached_food_flat_icons[cache_key] = "<img src='data:image/png;base64, [icon2base64(getFlatIcon(dummy))]'>"
	return GLOB.cached_food_flat_icons[cache_key]

/proc/get_cached_drink_flat_icon(drink_quality)
	var/obj/item/reagent_containers/glass/icon_type
	if(drink_quality <= 0)
		icon_type = /obj/item/reagent_containers/glass/cup/wooden
	else if(drink_quality <= 1)
		icon_type = /obj/item/reagent_containers/glass/cup
	else if(drink_quality <= 2)
		icon_type = /obj/item/reagent_containers/glass/bottle
	else if(drink_quality <= 3)
		icon_type = /obj/item/reagent_containers/glass/cup/silver
	else
		icon_type = /obj/item/reagent_containers/glass/cup/golden

	var/cache_key = "[icon_type]"
	if(!GLOB.cached_drink_flat_icons[cache_key])
		var/image/dummy = image(initial(icon_type.icon), null, initial(icon_type.icon_state), initial(icon_type.layer))
		GLOB.cached_drink_flat_icons[cache_key] = "<img src='data:image/png;base64, [icon2base64(getFlatIcon(dummy))]'>"
	return GLOB.cached_drink_flat_icons[cache_key]

/datum/preferences/proc/validate_culinary_preferences()
	if(!culinary_preferences)
		culinary_preferences = list()

	if(!length(GLOB.selectable_foods))
		GLOB.selectable_foods = get_global_selectable_foods()

	if(!length(GLOB.selectable_drinks))
		GLOB.selectable_drinks = get_global_selectable_drinks()

	if(!culinary_preferences[CULINARY_RANDOM_PREFERENCES])
		culinary_preferences[CULINARY_RANDOM_PREFERENCES] = FALSE

	if(!culinary_preferences[CULINARY_RANDOM_PREFERENCES])
		if(!culinary_preferences[CULINARY_FAVOURITE_FOOD] || !(culinary_preferences[CULINARY_FAVOURITE_FOOD] in GLOB.selectable_foods))
			culinary_preferences[CULINARY_FAVOURITE_FOOD] = get_random_food()

		if(!culinary_preferences[CULINARY_FAVOURITE_DRINK] || !(culinary_preferences[CULINARY_FAVOURITE_DRINK] in GLOB.selectable_drinks))
			culinary_preferences[CULINARY_FAVOURITE_DRINK] = get_random_drink()

		if(!culinary_preferences[CULINARY_HATED_FOOD] || !(culinary_preferences[CULINARY_HATED_FOOD] in GLOB.selectable_foods))
			culinary_preferences[CULINARY_HATED_FOOD] = get_random_hated_food()

		if(!culinary_preferences[CULINARY_HATED_DRINK] || !(culinary_preferences[CULINARY_HATED_DRINK] in GLOB.selectable_drinks))
			culinary_preferences[CULINARY_HATED_DRINK] = get_random_hated_drink()
	else
		if(!culinary_preferences[CULINARY_FAVOURITE_FOOD])
			culinary_preferences[CULINARY_FAVOURITE_FOOD] = get_random_food()
		if(!culinary_preferences[CULINARY_FAVOURITE_DRINK])
			culinary_preferences[CULINARY_FAVOURITE_DRINK] = get_random_drink()
		if(!culinary_preferences[CULINARY_HATED_FOOD])
			culinary_preferences[CULINARY_HATED_FOOD] = get_random_hated_food()
		if(!culinary_preferences[CULINARY_HATED_DRINK])
			culinary_preferences[CULINARY_HATED_DRINK] = get_random_hated_drink()

	if(culinary_preferences[CULINARY_FAVOURITE_FOOD] == culinary_preferences[CULINARY_HATED_FOOD])
		culinary_preferences[CULINARY_HATED_FOOD] = get_default_hated_food()
	if(culinary_preferences[CULINARY_FAVOURITE_DRINK] == culinary_preferences[CULINARY_HATED_DRINK])
		culinary_preferences[CULINARY_HATED_DRINK] = get_default_hated_drink()

/datum/preferences/proc/reset_culinary_preferences()
	culinary_preferences = list()
	culinary_preferences[CULINARY_RANDOM_PREFERENCES] = FALSE
	culinary_preferences[CULINARY_FAVOURITE_FOOD] = get_random_food()
	culinary_preferences[CULINARY_FAVOURITE_DRINK] = get_random_drink()
	culinary_preferences[CULINARY_HATED_FOOD] = get_random_hated_food()
	culinary_preferences[CULINARY_HATED_DRINK] = get_random_hated_drink()

/datum/preferences/proc/get_default_food()
	return /obj/item/reagent_containers/food/snacks/bread

/datum/preferences/proc/get_default_hated_food()
	return /obj/item/reagent_containers/food/snacks/badrecipe

/datum/preferences/proc/get_default_drink()
	return /datum/reagent/consumable/ethanol/beer

/datum/preferences/proc/get_default_hated_drink()
	return /datum/reagent/consumable/tea/badidea

/datum/preferences/proc/get_random_food()
	if(!length(GLOB.selectable_foods))
		GLOB.selectable_foods = get_global_selectable_foods()
	var/list/choices = GLOB.selectable_foods - culinary_preferences[CULINARY_HATED_FOOD]
	return pick(choices)

/datum/preferences/proc/get_random_drink()
	if(!length(GLOB.selectable_drinks))
		GLOB.selectable_drinks = get_global_selectable_drinks()
	var/list/choices = GLOB.selectable_drinks - culinary_preferences[CULINARY_HATED_DRINK]
	return pick(choices)

/datum/preferences/proc/get_random_hated_food()
	if(!length(GLOB.selectable_foods))
		GLOB.selectable_foods = get_global_selectable_foods()
	var/list/choices = GLOB.selectable_foods - culinary_preferences[CULINARY_FAVOURITE_FOOD]
	return pick(choices)

/datum/preferences/proc/get_random_hated_drink()
	if(!length(GLOB.selectable_drinks))
		GLOB.selectable_drinks = get_global_selectable_drinks()
	var/list/choices = GLOB.selectable_drinks - culinary_preferences[CULINARY_FAVOURITE_DRINK]
	return pick(choices)

/datum/preferences/proc/handle_culinary_topic(mob/user, href_list)
	switch(href_list["preference"])
		if("toggle_random_culinary")
			var/current_random = culinary_preferences[CULINARY_RANDOM_PREFERENCES]
			culinary_preferences[CULINARY_RANDOM_PREFERENCES] = !current_random
			if(culinary_preferences[CULINARY_RANDOM_PREFERENCES])
				to_chat(user, span_notice("Random culinary preferences enabled. Your food and drink preferences will be randomized."))
			else
				to_chat(user, span_notice("Random culinary preferences disabled. You can now manually choose your preferences."))
			show_culinary_ui(user)
		if("choose_food")
			show_food_selection_ui(user, CULINARY_FAVOURITE_FOOD)
		if("choose_drink")
			show_drink_selection_ui(user, CULINARY_FAVOURITE_DRINK)
		if("choose_hated_food")
			show_food_selection_ui(user, CULINARY_HATED_FOOD)
		if("choose_hated_drink")
			show_drink_selection_ui(user, CULINARY_HATED_DRINK)
		if("confirm_food")
			var/food_type = text2path(href_list["food_type"])
			var/preference_type = href_list["preference_type"]
			if(ispath(food_type, /obj/item/reagent_containers/food/snacks) && (food_type in GLOB.selectable_foods))
				var/opposite_preference = (preference_type == CULINARY_FAVOURITE_FOOD) ? CULINARY_HATED_FOOD : CULINARY_FAVOURITE_FOOD
				if(culinary_preferences[opposite_preference] == food_type)
					to_chat(user, span_warning("You can't set the same item as both favorite and hated!"))
				else
					culinary_preferences[preference_type] = food_type
					user << browse(null, "window=food_selection")
					show_culinary_ui(user)
		if("confirm_drink")
			var/drink_type = text2path(href_list["drink_type"])
			var/preference_type = href_list["preference_type"]
			if(ispath(drink_type, /datum/reagent/consumable) && (drink_type in GLOB.selectable_drinks))
				var/opposite_preference = (preference_type == CULINARY_FAVOURITE_DRINK) ? CULINARY_HATED_DRINK : CULINARY_FAVOURITE_DRINK
				if(culinary_preferences[opposite_preference] == drink_type)
					to_chat(user, span_warning("You can't set the same drink as both favorite and hated!"))
				else
					culinary_preferences[preference_type] = drink_type
					user << browse(null, "window=drink_selection")
					show_culinary_ui(user)

/datum/preferences/proc/print_culinary_page(mob/user)
	var/list/dat = list()

	var/current_food = culinary_preferences[CULINARY_FAVOURITE_FOOD]
	var/current_drink = culinary_preferences[CULINARY_FAVOURITE_DRINK]
	var/current_hated_food = culinary_preferences[CULINARY_HATED_FOOD]
	var/current_hated_drink = culinary_preferences[CULINARY_HATED_DRINK]
	var/random_preferences = culinary_preferences[CULINARY_RANDOM_PREFERENCES]

	var/food_name = "None"
	var/food_icon = ""
	if(current_food && !random_preferences)
		var/obj/item/food_instance = current_food
		food_name = capitalize(initial(food_instance.name))
		food_icon = get_cached_food_flat_icon(current_food)
	else if(random_preferences)
		food_name = "Random"

	var/drink_name = "None"
	var/drink_icon = ""
	if(current_drink && !random_preferences)
		var/datum/reagent/consumable/drink_instance = current_drink
		drink_name = capitalize(initial(drink_instance.name))
		var/drink_quality = initial(drink_instance.quality)
		drink_icon = get_cached_drink_flat_icon(drink_quality)
	else if(random_preferences)
		drink_name = "Random"

	var/hated_food_name = "None"
	var/hated_food_icon = ""
	if(current_hated_food && !random_preferences)
		var/obj/item/hated_food_instance = current_hated_food
		hated_food_name = capitalize(initial(hated_food_instance.name))
		hated_food_icon = get_cached_food_flat_icon(current_hated_food)
	else if(random_preferences)
		hated_food_name = "Random"

	var/hated_drink_name = "None"
	var/hated_drink_icon = ""
	if(current_hated_drink && !random_preferences)
		var/datum/reagent/consumable/hated_drink_instance = current_hated_drink
		hated_drink_name = capitalize(initial(hated_drink_instance.name))
		var/hated_drink_quality = initial(hated_drink_instance.quality)
		hated_drink_icon = get_cached_drink_flat_icon(hated_drink_quality)
	else if(random_preferences)
		hated_drink_name = "Random"

	dat += "<style>"
	dat += ".culinary-item { display: flex; align-items: center; margin-bottom: 5px; }"
	dat += ".culinary-icon { vertical-align: middle; }"
	dat += ".culinary-text { vertical-align: middle; line-height: 32px; }"
	dat += ".random-toggle { margin-bottom: 10px; padding: 5px; background: #2a2a2a; border-radius: 3px; }"
	dat += "</style>"

	dat += "<div class='random-toggle'>"
	dat += "<b>Random Preferences:</b> <a href='byond://?_src_=prefs;preference=toggle_random_culinary;task=change_culinary_preferences'>[random_preferences ? "Enabled" : "Disabled"]</a>"
	dat += "<br>When enabled, random foods and drinks will be selected for you automatically each round. Eating or drinking your favourites when this setting is enabled will give you a triumph, but only once per category. You can view your character's preferences in their memories."
	dat += "</div>"

	dat += "<div [random_preferences ? "" : "class='culinary-item'"]><b>Favourite Food: </b> <span class='culinary-icon'>[food_icon]</span> <span class='culinary-text'>"
	if(random_preferences)
		dat += "<font color='orange'>[encode_special_chars(food_name)]</font>"
	else
		dat += "<a href='byond://?_src_=prefs;preference=choose_food;preference_type=[CULINARY_FAVOURITE_FOOD];task=change_culinary_preferences'>[encode_special_chars(food_name)]</a>"
	dat += "</span></div>"

	dat += "<div [random_preferences ? "" : "class='culinary-item'"]><b>Favourite Drink: </b> <span class='culinary-icon'>[drink_icon]</span> <span class='culinary-text'>"
	if(random_preferences)
		dat += "<font color='orange'>[encode_special_chars(drink_name)]</font>"
	else
		dat += "<a href='byond://?_src_=prefs;preference=choose_drink;preference_type=[CULINARY_FAVOURITE_DRINK];task=change_culinary_preferences'>[encode_special_chars(drink_name)]</a>"
	dat += "</span></div>"

	dat += "<div [random_preferences ? "" : "class='culinary-item'"]><b>Hated Food: </b> <span class='culinary-icon'>[hated_food_icon]</span> <span class='culinary-text'>"
	if(random_preferences)
		dat += "<font color='orange'>[encode_special_chars(hated_food_name)]</font>"
	else
		dat += "<a href='byond://?_src_=prefs;preference=choose_hated_food;preference_type=[CULINARY_HATED_FOOD];task=change_culinary_preferences'>[encode_special_chars(hated_food_name)]</a>"
	dat += "</span></div>"

	dat += "<div [random_preferences ? "" : "class='culinary-item'"]><b>Hated Drink: </b> <span class='culinary-icon'>[hated_drink_icon]</span> <span class='culinary-text'>"
	if(random_preferences)
		dat += "<font color='orange'>[encode_special_chars(hated_drink_name)]</font>"
	else
		dat += "<a href='byond://?_src_=prefs;preference=choose_hated_drink;preference_type=[CULINARY_HATED_DRINK];task=change_culinary_preferences'>[encode_special_chars(hated_drink_name)]</a>"
	dat += "</span></div>"

	return dat

/datum/preferences/proc/show_culinary_ui(mob/user)
	var/list/dat = list()
	dat += "<meta http-equiv=\"Content-Type\" content=\"text/html; charset=utf-8\">"
	dat += print_culinary_page(user)
	var/datum/browser/popup = new(user, "culinary_customization", "<div align='center'>Culinary Preferences</div>", 360, 365)
	popup.set_content(dat.Join())
	popup.open(FALSE)

/datum/preferences/proc/apply_culinary_preferences(mob/living/carbon/human/character)
	if(!culinary_preferences)
		return

	character.culinary_preferences = culinary_preferences.Copy()
	if(has_world_trait(/datum/world_trait/exotic_tastes))
		character.culinary_preferences[CULINARY_RANDOM_PREFERENCES] = TRUE

	if(character.culinary_preferences[CULINARY_RANDOM_PREFERENCES])
		character.culinary_preferences[CULINARY_FAVOURITE_FOOD] = get_random_food()
		character.culinary_preferences[CULINARY_FAVOURITE_DRINK] = get_random_drink()
		character.culinary_preferences[CULINARY_HATED_FOOD] = get_random_hated_food()
		character.culinary_preferences[CULINARY_HATED_DRINK] = get_random_hated_drink()

/datum/preferences/proc/show_food_selection_ui(mob/user, preference_type)
	if(culinary_preferences[CULINARY_RANDOM_PREFERENCES])
		to_chat(user, span_warning("You cannot choose food preferences while random preferences are enabled. Disable random preferences first."))
		return

	var/list/dat = list()
	dat += "<meta http-equiv=\"Content-Type\" content=\"text/html; charset=utf-8\">"
	dat += "<style>"
	dat += ".food-item { display: flex; align-items: center; margin-bottom: 5px; }"
	dat += ".food-icon { vertical-align: middle; }"
	dat += ".food-text { vertical-align: middle; line-height: 32px; }"
	dat += "</style>"

	var/list/food_with_faretypes = list()
	for(var/obj/item/reagent_containers/food/snacks/food_instance as anything in GLOB.selectable_foods)
		var/food_faretype = initial(food_instance.faretype)
		var/food_name = initial(food_instance.name)
		food_with_faretypes += list(list("type" = food_instance, "faretype" = food_faretype, "name" = food_name))

	food_with_faretypes = sortTim(food_with_faretypes, GLOBAL_PROC_REF(cmp_food_by_faretype_and_name))

	for(var/list/food_data in food_with_faretypes)
		var/food_type = food_data["type"]
		var/food_name = food_data["name"]
		var/food_faretype = food_data["faretype"]

		var/display_name = capitalize(food_name)
		var/food_icon = get_cached_food_flat_icon(food_type)
		dat += "<div class='food-item'><span class='food-icon'>[food_icon]</span> <span class='food-text'><a href='byond://?_src_=prefs;preference=confirm_food;food_type=[food_type];preference_type=[preference_type];task=change_culinary_preferences'>[encode_special_chars(display_name)]</a> (Quality: [food_faretype])</span></div>"

	var/title = (preference_type == CULINARY_FAVOURITE_FOOD) ? "Select Favourite Food" : "Select Hated Food"
	var/datum/browser/popup = new(user, "food_selection", "<div align='center'>[title]</div>", 400, 600)
	popup.set_content(dat.Join())
	popup.open(FALSE)

/datum/preferences/proc/show_drink_selection_ui(mob/user, preference_type)
	if(culinary_preferences[CULINARY_RANDOM_PREFERENCES])
		to_chat(user, span_warning("You cannot choose drink preferences while random preferences are enabled. Disable random preferences first."))
		return

	var/list/dat = list()
	dat += "<meta http-equiv=\"Content-Type\" content=\"text/html; charset=utf-8\">"
	dat += "<style>"
	dat += ".drink-item { display: flex; align-items: center; margin-bottom: 5px; }"
	dat += ".drink-icon { vertical-align: middle; }"
	dat += ".drink-text { vertical-align: middle; line-height: 32px; }"
	dat += "</style>"

	var/list/drink_with_qualities = list()
	for(var/datum/reagent/consumable/drink_instance as anything in GLOB.selectable_drinks)
		var/drink_quality = initial(drink_instance.quality)
		var/drink_name = initial(drink_instance.name)
		drink_with_qualities += list(list("type" = drink_instance, "quality" = drink_quality, "name" = drink_name))

	drink_with_qualities = sortTim(drink_with_qualities, /proc/cmp_drink_by_quality_and_name)

	for(var/list/drink_data in drink_with_qualities)
		var/drink_type = drink_data["type"]
		var/drink_name = drink_data["name"]
		var/drink_quality = drink_data["quality"]

		var/display_name = capitalize(drink_name)
		var/drink_icon = get_cached_drink_flat_icon(drink_quality)
		dat += "<div class='drink-item'><span class='drink-icon'>[drink_icon]</span> <span class='drink-text'><a href='byond://?_src_=prefs;preference=confirm_drink;drink_type=[drink_type];preference_type=[preference_type];task=change_culinary_preferences'>[encode_special_chars(display_name)]</a> (Quality: [drink_quality])</span></div>"

	var/title = (preference_type == CULINARY_FAVOURITE_DRINK) ? "Select Favourite Drink" : "Select Hated Drink"
	var/datum/browser/popup = new(user, "drink_selection", "<div align='center'>[title]</div>", 400, 600)
	popup.set_content(dat.Join())
	popup.open(FALSE)

/proc/cmp_food_by_faretype_and_name(list/a, list/b)
	var/faretype_a = a["faretype"]
	var/faretype_b = b["faretype"]

	if(faretype_a != faretype_b)
		return faretype_a - faretype_b

	var/name_a = a["name"]
	var/name_b = b["name"]
	return sorttext(name_a, name_b)

/proc/cmp_drink_by_quality_and_name(list/a, list/b)
	var/quality_a = a["quality"]
	var/quality_b = b["quality"]

	if(quality_a != quality_b)
		return quality_a - quality_b

	var/name_a = a["name"]
	var/name_b = b["name"]
	return sorttext(name_a, name_b)

/proc/get_global_selectable_foods()
	var/list/blacklisted_food = list(
		/obj/item/reagent_containers/food/snacks/produce,
		/obj/item/reagent_containers/food/snacks/produce/vegetable,
		/obj/item/reagent_containers/food/snacks/produce/fruit,
		/obj/item/reagent_containers/food/snacks/produce/grain,
		/obj/item/reagent_containers/food/snacks/pie,
		/obj/item/reagent_containers/food/snacks/pie/cooked,
		/obj/item/reagent_containers/food/snacks/rotten,
		/obj/item/reagent_containers/food/snacks/meat/mince,
		/obj/item/reagent_containers/food/snacks/dough_base,
		/obj/item/reagent_containers/food/snacks/meat,
		/obj/item/reagent_containers/food/snacks/veg,
		/obj/item/reagent_containers/food/snacks/store,
		/obj/item/reagent_containers/food/snacks/grown,
		/obj/item/reagent_containers/food/snacks/zybcake,
		/obj/item/reagent_containers/food/snacks/zybcake_ready,
		/obj/item/reagent_containers/food/snacks/strawbycake,
		/obj/item/reagent_containers/food/snacks/strawbycake_ready,
		/obj/item/reagent_containers/food/snacks/tangerinecake,
		/obj/item/reagent_containers/food/snacks/tangerinecake_ready,
		/obj/item/reagent_containers/food/snacks/crimsoncake,
		/obj/item/reagent_containers/food/snacks/crimsoncake_ready,
		/obj/item/reagent_containers/food/snacks/chescake,
		/obj/item/reagent_containers/food/snacks/chescake_ready,
		/obj/item/reagent_containers/food/snacks/chescake_poison,
		/obj/item/reagent_containers/food/snacks/chescake_poison_ready,
		/obj/item/reagent_containers/food/snacks/cheesecake_poison_cooked,
		/obj/item/reagent_containers/food/snacks/cake,
		/obj/item/reagent_containers/food/snacks/piedough,
		/obj/item/reagent_containers/food/snacks/raisindough,
		/obj/item/reagent_containers/food/snacks/dough,
		/obj/item/reagent_containers/food/snacks/dough_slice,
		/obj/item/reagent_containers/food/snacks/butterdough,
		/obj/item/reagent_containers/food/snacks/butterdough_slice,
		/obj/item/reagent_containers/food/snacks/meat/wiener,
		/obj/item/reagent_containers/food/snacks/meat/sausage,
		/obj/item/reagent_containers/food/snacks/meat/fatty,
		/obj/item/reagent_containers/food/snacks/rotten/sausage,
		/obj/item/reagent_containers/food/snacks/rotten/poultry,
		/obj/item/reagent_containers/food/snacks/rotten/bacon,
		/obj/item/reagent_containers/food/snacks/rotten/mince,
		/obj/item/reagent_containers/food/snacks/rotten/meat,
		/obj/item/reagent_containers/food/snacks/rotten/egg,
		/obj/item/reagent_containers/food/snacks/rotten/chickenleg,
		/obj/item/reagent_containers/food/snacks/rotten/breadslice,
		/obj/item/reagent_containers/food/snacks/meat/mince/beef,
		/obj/item/reagent_containers/food/snacks/meat/mince/fish,
		/obj/item/reagent_containers/food/snacks/meat/mince/poultry,
		/obj/item/reagent_containers/food/snacks/meat/poultry,
		/obj/item/reagent_containers/food/snacks/meat/poultry/cutlet,
		/obj/item/reagent_containers/food/snacks/tart,
		/obj/item/reagent_containers/food/snacks/tart/cooked,
		/obj/item/reagent_containers/food/snacks/tartslice,
		/obj/item/reagent_containers/food/snacks/fruit,
		/obj/item/reagent_containers/food/snacks/produce/sugarcane,
		/obj/item/reagent_containers/food/snacks/fat,
		/obj/item/reagent_containers/food/snacks/produce/swampweed,
		/obj/item/reagent_containers/food/snacks/produce/swampweed_dried,
		/obj/item/reagent_containers/food/snacks/produce/sunflower,
		/obj/item/reagent_containers/food/snacks/produce/fyritius,
		/obj/item/reagent_containers/food/snacks/produce/fyritius/bloodied,
		/obj/item/reagent_containers/food/snacks/produce/westleach,
		/obj/item/reagent_containers/food/snacks/produce/dry_westleach,
		/obj/item/reagent_containers/food/snacks/produce/manabloom,
		/obj/item/reagent_containers/food/snacks/produce/poppy,
		/obj/item/reagent_containers/food/snacks/meat/human,
		/obj/item/reagent_containers/food/snacks/crow,
		/obj/item/reagent_containers/food/snacks/crow/dead,
		/obj/item/reagent_containers/food/snacks/smallrat,
		/obj/item/reagent_containers/food/snacks/smallrat/dead,
		/obj/item/reagent_containers/food/snacks/messenger_bird,
		/obj/item/reagent_containers/food/snacks/messenger_bird/dead,
	)

	var/list/slice_paths = list()
	for(var/obj/item/reagent_containers/food/snacks/F as anything in subtypesof(/obj/item/reagent_containers/food/snacks))
		var/slice_path = initial(F.slice_path)
		if(slice_path)
			slice_paths |= slice_path

	var/list/food_types = subtypesof(/obj/item/reagent_containers/food/snacks) - typesof(/obj/item/reagent_containers/food/snacks/foodbase) - typesof(/obj/item/reagent_containers/food/snacks/raw_pie) - typesof(/obj/item/reagent_containers/food/snacks/raw_tart) - typesof(/obj/item/reagent_containers/food/snacks/fish) - subtypesof(/obj/item/reagent_containers/food/snacks/spiderhoney/honey) - blacklisted_food - slice_paths

	var/list/filtered_food_types = list()
	var/list/name_to_type = list()

	for(var/obj/item/reagent_containers/food/snacks/food_instance as anything in food_types)
		var/food_name = initial(food_instance.name)

		if(!name_to_type[food_name])
			name_to_type[food_name] = food_instance
			filtered_food_types += food_instance
		else
			var/existing_type = name_to_type[food_name]
			if(ispath(existing_type, food_instance))
				name_to_type[food_name] = food_instance
				filtered_food_types -= existing_type
				filtered_food_types += food_instance

	return filtered_food_types

/proc/get_global_selectable_drinks()
	var/list/blacklisted_drinks = list(
		/datum/reagent/consumable/ethanol,
		/datum/reagent/consumable/tea,
		/datum/reagent/consumable/nutriment,
		/datum/reagent/consumable/eggyolk,
		/datum/reagent/consumable/sodiumchloride,
		/datum/reagent/consumable/nutriment/vitamin,
		/datum/reagent/consumable/ice,
		/datum/reagent/consumable/honey,
		/datum/reagent/consumable/caffeine,
		/datum/reagent/consumable/coffee,
		/datum/reagent/consumable/sugar,
	)

	var/list/drink_types = subtypesof(/datum/reagent/consumable) - typesof(/datum/reagent/consumable/soup) - typesof(/datum/reagent/consumable/herbal) - blacklisted_drinks

	var/list/filtered_drink_types = list()
	var/list/name_to_type = list()

	for(var/datum/reagent/consumable/drink_instance as anything in drink_types)
		var/drink_name = initial(drink_instance.name)

		if(!name_to_type[drink_name])
			name_to_type[drink_name] = drink_instance
			filtered_drink_types += drink_instance
		else
			var/existing_type = name_to_type[drink_name]
			if(ispath(existing_type, drink_instance))
				name_to_type[drink_name] = drink_instance
				filtered_drink_types -= existing_type
				filtered_drink_types += drink_instance

	return filtered_drink_types

/proc/encode_special_chars(text)
	. = text
	. = replacetext(., "ü", "&uuml;")
	. = replacetext(., "Ü", "&Uuml;")
	. = replacetext(., "ö", "&ouml;")
	. = replacetext(., "Ö", "&Ouml;")
	. = replacetext(., "ä", "&auml;")
	. = replacetext(., "Ä", "&Auml;")
	. = replacetext(., "ß", "&szlig;")
	return .
