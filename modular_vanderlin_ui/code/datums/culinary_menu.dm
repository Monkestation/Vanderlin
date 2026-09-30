/datum/culinary_menu
	var/datum/preferences/prefs
	var/mob/owner

/datum/culinary_menu/New(datum/preferences/prefs, mob/owner)
	src.prefs = prefs
	src.owner = owner

/datum/culinary_menu/Destroy()
	prefs = null
	owner = null
	return ..()

/datum/culinary_menu/ui_state(mob/user)
	return GLOB.always_state

/datum/culinary_menu/ui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "CulinaryPreferences", "Culinary Preferences")
		ui.open()

/datum/culinary_menu/ui_data(mob/user)
	var/list/data = list()
	prefs.validate_culinary_preferences()
	var/list/culinary = prefs.read_preference(/datum/preference/list_type/culinary_preferences)
	data["random_preferences"] = culinary[CULINARY_RANDOM_PREFERENCES] ? TRUE : FALSE
	var/obj/item/reagent_containers/food/snacks/fav_food_ref = culinary[CULINARY_FAVOURITE_FOOD]
	data["favourite_food"] = fav_food_ref ? fav_food_ref::name : "None"
	var/datum/reagent/fav_drink_ref = culinary[CULINARY_FAVOURITE_DRINK]
	data["favourite_drink"] = fav_drink_ref ? fav_drink_ref::name : "None"
	var/obj/item/reagent_containers/food/snacks/hated_food_ref = culinary[CULINARY_HATED_FOOD]
	data["hated_food"] = hated_food_ref ? hated_food_ref::name : "None"
	var/datum/reagent/hated_drink_ref = culinary[CULINARY_HATED_DRINK]
	data["hated_drink"] = hated_drink_ref ? hated_drink_ref::name : "None"
	return data

/datum/culinary_menu/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	. = ..()
	if(.)
		return
	var/list/culinary = prefs.read_preference(/datum/preference/list_type/culinary_preferences)
	if(!culinary)
		culinary = list()
	switch(action)
		if("toggle_random")
			culinary[CULINARY_RANDOM_PREFERENCES] = !culinary[CULINARY_RANDOM_PREFERENCES]
			prefs.write_preference(/datum/preference/list_type/culinary_preferences, culinary)
			prefs.validate_culinary_preferences()
			return TRUE
		if("pick_favourite_food")
			if(!length(GLOB.selectable_foods))
				GLOB.selectable_foods = get_global_selectable_foods()
			var/list/choices = list()
			for(var/food_type in GLOB.selectable_foods)
				choices[initial(food_type:name)] = food_type
			var/chosen = input(owner, "Choose your favourite food:", "Culinary Preference") as null|anything in choices
			if(!chosen)
				return
			culinary[CULINARY_FAVOURITE_FOOD] = choices[chosen]
			prefs.write_preference(/datum/preference/list_type/culinary_preferences, culinary)
			return TRUE
		if("pick_favourite_drink")
			if(!length(GLOB.selectable_drinks))
				GLOB.selectable_drinks = get_global_selectable_drinks()
			var/list/choices = list()
			for(var/drink_type in GLOB.selectable_drinks)
				choices[initial(drink_type:name)] = drink_type
			var/chosen = input(owner, "Choose your favourite drink:", "Culinary Preference") as null|anything in choices
			if(!chosen)
				return
			culinary[CULINARY_FAVOURITE_DRINK] = choices[chosen]
			prefs.write_preference(/datum/preference/list_type/culinary_preferences, culinary)
			return TRUE
		if("pick_hated_food")
			if(!length(GLOB.selectable_foods))
				GLOB.selectable_foods = get_global_selectable_foods()
			var/list/choices = list()
			for(var/food_type in GLOB.selectable_foods)
				choices[initial(food_type:name)] = food_type
			var/chosen = input(owner, "Choose your hated food:", "Culinary Preference") as null|anything in choices
			if(!chosen)
				return
			culinary[CULINARY_HATED_FOOD] = choices[chosen]
			prefs.write_preference(/datum/preference/list_type/culinary_preferences, culinary)
			return TRUE
		if("pick_hated_drink")
			if(!length(GLOB.selectable_drinks))
				GLOB.selectable_drinks = get_global_selectable_drinks()
			var/list/choices = list()
			for(var/drink_type in GLOB.selectable_drinks)
				choices[initial(drink_type:name)] = drink_type
			var/chosen = input(owner, "Choose your hated drink:", "Culinary Preference") as null|anything in choices
			if(!chosen)
				return
			culinary[CULINARY_HATED_DRINK] = choices[chosen]
			prefs.write_preference(/datum/preference/list_type/culinary_preferences, culinary)
			return TRUE