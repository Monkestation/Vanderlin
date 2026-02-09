/datum/container_craft/pan
	abstract_type = /datum/container_craft/pan
	required_container = /obj/item/cooking/pan
	crafting_time = 25 SECONDS
	category = "Pan"

	var/datum/pollutant/cooked_smell
	cooking_sound = /datum/looping_sound/frying

/datum/container_craft/pan/get_real_time(atom/host, mob/user, estimated_multiplier)
	var/real_cooking_time = crafting_time * estimated_multiplier
	if(user.mind)
		real_cooking_time /= 1 + (user.get_skill_level(/datum/skill/craft/cooking, TRUE) * 0.2)
		real_cooking_time = round(real_cooking_time)
	return real_cooking_time

/datum/container_craft/pan/after_craft(atom/created_output, obj/item/crafter, mob/initiator, list/found_optional_requirements, list/found_optional_wildcards, list/found_optional_reagents, list/removing_items)
	. = ..()
	if(cooked_smell)
		created_output.AddComponent(/datum/component/temporary_pollution_emission, cooked_smell, 20, 5 MINUTES)

	for(var/obj/item/reagent_containers/food/snacks/item in removing_items)
		item.initialize_cooked_food(created_output, 1)

/datum/container_craft/pan/try_craft(obj/item/crafter, list/pathed_items, mob/initiator, datum/callback/on_craft_start, datum/callback/on_craft_failed)
	if(!istype(crafter.loc, /obj/machinery/light/fueled))
		return FALSE
	var/obj/machinery/light/fueled/fueled = crafter.loc
	if(!fueled.fueluse)
		return FALSE
	. = ..()

/datum/container_craft/pan/check_failure(obj/item/crafter, mob/user)
	if(!istype(crafter.loc, /obj/machinery/light/fueled))
		return TRUE
	var/obj/machinery/light/fueled/fueled = crafter.loc
	if(!fueled.fueluse)
		return TRUE
	return FALSE


/datum/container_craft/pan/fried_crow
	name = "Fried Crow"
	wildcard_requirements = list(/obj/item/reagent_containers/food/snacks/crow = 1)
	output = /obj/item/reagent_containers/food/snacks/friedcrow
	cooked_smell = /datum/pollutant/food/fried_crow

/datum/container_craft/pan/fried_rat
	name = "Fried Rat"
	wildcard_requirements = list(/obj/item/reagent_containers/food/snacks/smallrat = 1)
	output = /obj/item/reagent_containers/food/snacks/friedrat
	cooked_smell = /datum/pollutant/food/fried_rat

/datum/container_craft/pan/truffle
	name = "Fried Truffles"
	requirements = list(/obj/item/reagent_containers/food/snacks/truffles = 1)
	output = /obj/item/reagent_containers/food/snacks/cooked/truffle
	cooked_smell = /datum/pollutant/food/truffles

/datum/container_craft/pan/truffle/toxic
	hides_from_books = TRUE
	requirements = list(/obj/item/reagent_containers/food/snacks/toxicshrooms = 1)
	output = /obj/item/reagent_containers/food/snacks/cooked/truffle_toxic
	cooked_smell = /datum/pollutant/food/truffles

/datum/container_craft/pan/fish
	abstract_type = /datum/container_craft/pan/fish
	var/rare_output

/datum/container_craft/pan/fish/create_item(obj/item/crafter, mob/initiator, list/found_optional_requirements, list/found_optional_wildcards, list/found_optional_reagents, list/removing_items)
	var/create_path = output
	for(var/obj/item/reagent_containers/food/snacks/fish/fish in removing_items)
		if(fish.rare && rare_output)
			create_path = rare_output
			break

	for(var/j = 1 to output_amount)
		var/atom/created_output = new create_path(get_turf(crafter))
		SEND_SIGNAL(crafter, COMSIG_TRY_STORAGE_INSERT, created_output, null, null, TRUE, TRUE)
		after_craft(created_output, crafter, initiator, found_optional_requirements, found_optional_wildcards, found_optional_reagents, removing_items)
		SEND_SIGNAL(crafter, COMSIG_CONTAINER_CRAFT_COMPLETE, created_output)

/datum/container_craft/pan/fish/swordfish
	name = "Fried Swordfish"
	requirements = list(/obj/item/reagent_containers/food/snacks/fish/swordfish = 1)
	output = /obj/item/reagent_containers/food/snacks/fryfish/swordfish
	cooked_smell = /datum/pollutant/food/baked_swordfish

/datum/container_craft/pan/fish/shrimp
	name = "Fried Shrimp"
	requirements = list(/obj/item/reagent_containers/food/snacks/fish/shrimp = 1)
	output = /obj/item/reagent_containers/food/snacks/fryfish/shrimp
	cooked_smell = /datum/pollutant/food/baked_shrimp

/datum/container_craft/pan/fish/eel
	name = "Fried Eel"
	requirements = list(/obj/item/reagent_containers/food/snacks/fish/eel = 1)
	output = /obj/item/reagent_containers/food/snacks/fryfish/eel
	rare_output = /obj/item/reagent_containers/food/snacks/fryfish/eel/rare
	cooked_smell = /datum/pollutant/food/baked_eel

/datum/container_craft/pan/fish/angler
	name = "Fried Angler"
	requirements = list(/obj/item/reagent_containers/food/snacks/fish/angler = 1)
	output = /obj/item/reagent_containers/food/snacks/fryfish/angler
	rare_output = /obj/item/reagent_containers/food/snacks/fryfish/angler/rare
	cooked_smell = /datum/pollutant/food/baked_angler

/datum/container_craft/pan/fish/clownfish
	name = "Fried Clownfish"
	requirements = list(/obj/item/reagent_containers/food/snacks/fish/clownfish = 1)
	output = /obj/item/reagent_containers/food/snacks/fryfish/clownfish
	rare_output = /obj/item/reagent_containers/food/snacks/fryfish/clownfish/rare
	cooked_smell = /datum/pollutant/food/baked_clownfish

/datum/container_craft/pan/fish/carp
	name = "Fried Carp"
	requirements = list(/obj/item/reagent_containers/food/snacks/fish/carp = 1)
	output = /obj/item/reagent_containers/food/snacks/fryfish/carp
	rare_output = /obj/item/reagent_containers/food/snacks/fryfish/carp/rare
	cooked_smell = /datum/pollutant/food/baked_carp

/datum/container_craft/pan/roastseeds
	name = "Roasted Seeds"
	crafting_time = 15 SECONDS
	wildcard_requirements = list(/obj/item/neuFarm/seed = 1)
	output = /obj/item/reagent_containers/food/snacks/roastseeds
	cooked_smell = /datum/pollutant/food/roasted_seeds

/datum/container_craft/pan/egg
	name = "Fried Egg"
	crafting_time = 20 SECONDS
	requirements = list(/obj/item/reagent_containers/food/snacks/egg = 1)
	output = /obj/item/reagent_containers/food/snacks/cooked/egg
	cooked_smell = /datum/pollutant/food/fried_eggs

/datum/container_craft/pan/egg/create_start_callback(crafter, initiator, highest_multiplier)
	return CALLBACK(src, PROC_REF(on_start_recipe), crafter, initiator, highest_multiplier)

/datum/container_craft/pan/egg/proc/on_start_recipe(atom/crafter, initiator, highest_multiplier)
	var/list/stored_items = crafter.contents
	playsound(crafter, 'sound/foley/eggbreak.ogg', 100, TRUE, -1)
	crafter.visible_message("The [lowertext(name)] starts to cook.")
	var/count = 0
	for(var/obj/item/reagent_containers/food/snacks/egg/egg in stored_items)
		if(count >= highest_multiplier)
			break
		egg.icon_state = "rawegg"
	crafter.update_appearance(UPDATE_OVERLAYS)

/datum/container_craft/pan/fried_potato
	name = "Fried Potato"
	requirements = list(/obj/item/reagent_containers/food/snacks/veg/potato_sliced = 1)
	output = /obj/item/reagent_containers/food/snacks/produce/vegetable/potato/fried
	cooked_smell = /datum/pollutant/food/baked_potato

/datum/container_craft/pan/fried_cabbage
	name = "Fried Cabbage"
	requirements = list(/obj/item/reagent_containers/food/snacks/veg/cabbage_sliced = 1)
	output = /obj/item/reagent_containers/food/snacks/cabbage_fried
	cooked_smell = /datum/pollutant/food/fried_cabbage

/datum/container_craft/pan/fried_onion
	name = "Fried Onion"
	requirements = list(/obj/item/reagent_containers/food/snacks/veg/onion_sliced = 1)
	output = /obj/item/reagent_containers/food/snacks/onion_fried
	cooked_smell = /datum/pollutant/food/fried_onion

/datum/container_craft/pan/wiener
	name = "Fried Wiener"
	requirements = list(/obj/item/reagent_containers/food/snacks/meat/wiener = 1)
	output = /obj/item/reagent_containers/food/snacks/cooked/sausage/wiener
	cooked_smell = /datum/pollutant/food/sausage

/datum/container_craft/pan/sausage
	name = "Fried Sausage"
	requirements = list(/obj/item/reagent_containers/food/snacks/meat/sausage = 1)
	output = /obj/item/reagent_containers/food/snacks/cooked/sausage
	cooked_smell = /datum/pollutant/food/sausage

/datum/container_craft/pan/minced_poultry
	name = "Fried Minced Poultry"
	requirements = list(/obj/item/reagent_containers/food/snacks/meat/mince/poultry = 1)
	output = /obj/item/reagent_containers/food/snacks/meat/mince/poultry/cooked
	cooked_smell = /datum/pollutant/food/fried_chicken

/datum/container_craft/pan/minced_fish
	name = "Fried Minced Fish"
	requirements = list(/obj/item/reagent_containers/food/snacks/meat/mince/fish = 1)
	output = /obj/item/reagent_containers/food/snacks/meat/mince/fish/cooked
	cooked_smell = /datum/pollutant/food/baked_carp

/datum/container_craft/pan/minced_beef
	name = "Fried Minced Beef"
	requirements = list(/obj/item/reagent_containers/food/snacks/meat/mince/beef = 1)
	output = /obj/item/reagent_containers/food/snacks/meat/mince/beef/cooked
	cooked_smell = /datum/pollutant/food/fried_meat

/datum/container_craft/pan/frybird
	name = "Fry Bird"
	requirements = list(/obj/item/reagent_containers/food/snacks/meat/poultry/cutlet = 1)
	output = /obj/item/reagent_containers/food/snacks/cooked/frybird
	cooked_smell = /datum/pollutant/food/fried_chicken

/datum/container_craft/pan/strange
	name = "Fried Strange Meat"
	requirements = list(/obj/item/reagent_containers/food/snacks/meat/strange = 1)
	output = /obj/item/reagent_containers/food/snacks/cooked/strange
	cooked_smell = /datum/pollutant/food/fried_meat

/datum/container_craft/pan/ham
	name = "Ham"
	requirements = list(/obj/item/reagent_containers/food/snacks/meat/fatty = 1)
	output = /obj/item/reagent_containers/food/snacks/cooked/ham
	cooked_smell = /datum/pollutant/food/bacon

/datum/container_craft/pan/frysteak
	name = "Fry Steak"
	requirements = list(/obj/item/reagent_containers/food/snacks/meat/steak = 1)
	output = /obj/item/reagent_containers/food/snacks/cooked/frysteak
	cooked_smell = /datum/pollutant/food/fried_meat

/datum/container_craft/pan/griddle_dog
	name = "Griddledog"
	requirements = list(/obj/item/reagent_containers/food/snacks/foodbase/griddledog_raw = 1)
	output = /obj/item/reagent_containers/food/snacks/cooked/griddledog
	cooked_smell = /datum/pollutant/food/sausage

/datum/container_craft/pan/frybread
	name = "Frybread"
	requirements = list(/obj/item/reagent_containers/food/snacks/butterdough_slice = 1)
	output = /obj/item/reagent_containers/food/snacks/frybread
	cooked_smell = /datum/pollutant/food/pastry

/datum/container_craft/pan/griddlecake
	name = "Griddlecake"
	requirements = list(/obj/item/reagent_containers/food/snacks/foodbase/griddlecake_raw = 1)
	output = /obj/item/reagent_containers/food/snacks/griddlecake
	cooked_smell = /datum/pollutant/food/griddlecake

/datum/container_craft/pan/griddlecakelemon
	name = "Lemon Griddlecake"
	requirements = list(/obj/item/reagent_containers/food/snacks/foodbase/lemongriddlecake_raw = 1)
	output = /obj/item/reagent_containers/food/snacks/griddlecake/lemon
	cooked_smell = /datum/pollutant/food/griddlecake

/datum/container_craft/pan/griddlecakeapple
	name = "Apple Griddlecake"
	requirements = list(/obj/item/reagent_containers/food/snacks/foodbase/applegriddlecake_raw = 1)
	output = /obj/item/reagent_containers/food/snacks/griddlecake/apple
	cooked_smell = /datum/pollutant/food/griddlecake

/datum/container_craft/pan/griddlecakeberry
	name = "Jacksberry Griddlecake"
	requirements = list(/obj/item/reagent_containers/food/snacks/foodbase/berrygriddlecake_raw = 1)
	output = /obj/item/reagent_containers/food/snacks/griddlecake/berry
	cooked_smell = /datum/pollutant/food/griddlecake

/datum/container_craft/pan/griddlecakepoisonberry
	name = "Jacksberry Griddlecake"
	requirements = list(/obj/item/reagent_containers/food/snacks/foodbase/poisonberrygriddlecake_raw = 1)
	output = /obj/item/reagent_containers/food/snacks/griddlecake/berry_poison
	cooked_smell = /datum/pollutant/food/griddlecake
	hides_from_books = TRUE

/datum/container_craft/pan/fried_messenger
	name = "Fried Messenger"
	wildcard_requirements = list(/obj/item/reagent_containers/food/snacks/messenger_bird = 1)
	output = /obj/item/reagent_containers/food/snacks/friedmessenger
	cooked_smell = /datum/pollutant/food/fried_messenger

/datum/container_craft/pan/fat_render
	name = "Render Fat"
	wildcard_requirements = list(/obj/item/reagent_containers/food/snacks/fat= 1)
	output = /obj/item/reagent_containers/food/snacks/tallow
	cooked_smell = /datum/pollutant/food/fried_messenger
