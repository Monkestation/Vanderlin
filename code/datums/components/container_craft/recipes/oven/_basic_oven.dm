/datum/container_craft/oven
	abstract_type = /datum/container_craft/oven
	required_container = /obj/machinery/light/fueled/oven
	crafting_time = 25 SECONDS
	category = "Oven"

	var/datum/pollutant/cooked_smell

/datum/container_craft/oven/get_real_time(atom/host, mob/user, estimated_multiplier)
	var/real_cooking_time = crafting_time * estimated_multiplier
	if(user.mind)
		real_cooking_time /= 1 + (user.get_skill_level(/datum/skill/craft/cooking, TRUE) * 0.2)
		real_cooking_time = round(real_cooking_time)
	return real_cooking_time

/datum/container_craft/oven/after_craft(atom/created_output, obj/item/crafter, mob/initiator, list/found_optional_requirements, list/found_optional_wildcards, list/found_optional_reagents, list/removing_items)
	for(var/obj/item/reagent_containers/food/snacks/item in removing_items)
		item.initialize_cooked_food(created_output, 1)

/datum/container_craft/oven/try_craft(obj/item/crafter, list/pathed_items, mob/initiator, datum/callback/on_craft_start, datum/callback/on_craft_failed)
	if(!istype(crafter.loc, /obj/machinery/light/fueled/oven) && !istype(crafter, /obj/machinery/light/fueled/oven))
		return FALSE
	var/obj/machinery/light/fueled/oven/fueled = crafter.loc
	if(!istype(fueled))
		fueled = crafter
	if(!fueled.fueluse)
		return FALSE
	. = ..()

/datum/container_craft/oven/check_failure(obj/item/crafter, mob/user)
	if(!istype(crafter.loc, /obj/machinery/light/fueled/oven) && !istype(crafter, /obj/machinery/light/fueled/oven))
		return TRUE
	var/obj/machinery/light/fueled/oven/fueled = crafter.loc
	if(!istype(fueled))
		fueled = crafter
	if(!fueled.fueluse)
		return TRUE
	return FALSE

/datum/container_craft/oven/apple_fritter
	name = "Apple Fritter"
	requirements = list(/obj/item/reagent_containers/food/snacks/foodbase/fritter_raw = 1)
	output = /obj/item/reagent_containers/food/snacks/fritter
	cooked_smell = /datum/pollutant/food/fritter

/datum/container_craft/oven/apple_frittergood
	hides_from_books = TRUE
	name = "Apple Fritter"
	requirements = list(/obj/item/reagent_containers/food/snacks/foodbase/fritter_raw/good = 1)
	output = /obj/item/reagent_containers/food/snacks/fritter/good
	cooked_smell = /datum/pollutant/food/fritter


/datum/container_craft/oven/handpie
	name = "Baked Handpie"
	wildcard_requirements = list(/obj/item/reagent_containers/food/snacks/foodbase/handpieraw = 1)
	output = /obj/item/reagent_containers/food/snacks/handpie
	cooked_smell = /datum/pollutant/food/pie_base

/datum/container_craft/oven/handpie/create_item(obj/item/crafter, mob/initiator, list/found_optional_requirements, list/found_optional_wildcards, list/found_optional_reagents, list/removing_items)
	var/create_type = output
	if(initiator.get_skill_level(/datum/skill/craft/cooking) >= 2)
		create_type = /obj/item/reagent_containers/food/snacks/handpie/good

	for(var/j = 1 to output_amount)
		var/atom/created_output = new create_type(get_turf(crafter))
		SEND_SIGNAL(crafter, COMSIG_TRY_STORAGE_INSERT, created_output, null, null, TRUE, TRUE)
		after_craft(created_output, crafter, initiator, found_optional_requirements, found_optional_wildcards, found_optional_reagents, removing_items)
		SEND_SIGNAL(crafter, COMSIG_CONTAINER_CRAFT_COMPLETE, created_output)

/datum/container_craft/oven/roastbird
	name = "Roast Bird"
	requirements = list(/obj/item/reagent_containers/food/snacks/meat/poultry = 1)
	output = /obj/item/reagent_containers/food/snacks/cooked/roastchicken
	cooked_smell = /datum/pollutant/food/fried_chicken

/datum/container_craft/oven/pastry
	name = "Pastry"
	requirements = list(/obj/item/reagent_containers/food/snacks/butterdough_slice = 1)
	output = /obj/item/reagent_containers/food/snacks/pastry
	cooked_smell = /datum/pollutant/food/pastry

/datum/container_craft/oven/pie
	abstract_type = /datum/container_craft/oven/pie
	category = "Pies"
	var/atom/good_path

/datum/container_craft/oven/pie/create_item(obj/item/crafter, mob/initiator, list/found_optional_requirements, list/found_optional_wildcards, list/found_optional_reagents, list/removing_items)
	var/create_path = output
	if((initiator.get_skill_level(/datum/skill/craft/cooking) >= 2 )&& good_path)
		create_path = good_path

	for(var/j = 1 to output_amount)
		var/atom/created_output = new create_path(get_turf(crafter))
		SEND_SIGNAL(crafter, COMSIG_TRY_STORAGE_INSERT, created_output, null, null, TRUE, TRUE)
		after_craft(created_output, crafter, initiator, found_optional_requirements, found_optional_wildcards, found_optional_reagents, removing_items)
		SEND_SIGNAL(crafter, COMSIG_CONTAINER_CRAFT_COMPLETE, created_output)

/datum/container_craft/oven/pie/fish
	name = "Fish Pie"
	requirements = list(/obj/item/reagent_containers/food/snacks/raw_pie/fish = 1)
	output = /obj/item/reagent_containers/food/snacks/pie/cooked/meat/fish
	good_path = /obj/item/reagent_containers/food/snacks/pie/cooked/meat/fish/good
	cooked_smell = /datum/pollutant/food/fish_pie

/datum/container_craft/oven/pie/meat
	name = "Meat Pie"
	requirements = list(/obj/item/reagent_containers/food/snacks/raw_pie/meat = 1)
	output = /obj/item/reagent_containers/food/snacks/pie/cooked/meat/meat
	good_path = /obj/item/reagent_containers/food/snacks/pie/cooked/meat/meat/good
	cooked_smell = /datum/pollutant/food/meat_pie

/datum/container_craft/oven/pie/pot
	name = "Pot Pie"
	requirements = list(/obj/item/reagent_containers/food/snacks/raw_pie/pot_pie = 1)
	output = /obj/item/reagent_containers/food/snacks/pie/cooked/pot
	good_path = /obj/item/reagent_containers/food/snacks/pie/cooked/pot/good
	cooked_smell = /datum/pollutant/food/pot_pie

/datum/container_craft/oven/pie/apple
	name = "Apple Pie"
	requirements = list(/obj/item/reagent_containers/food/snacks/raw_pie/apple = 1)
	output = /obj/item/reagent_containers/food/snacks/pie/cooked/apple
	good_path = /obj/item/reagent_containers/food/snacks/pie/cooked/apple/good
	cooked_smell = /datum/pollutant/food/apple_pie

/datum/container_craft/oven/pie/pear
	name = "Pear Pie"
	requirements = list(/obj/item/reagent_containers/food/snacks/raw_pie/pear = 1)
	output = /obj/item/reagent_containers/food/snacks/pie/cooked/pear
	good_path = /obj/item/reagent_containers/food/snacks/pie/cooked/pear/good
	cooked_smell = /datum/pollutant/food/pear_pie

/datum/container_craft/oven/pie/berry
	name = "Berry Pie"
	requirements = list(/obj/item/reagent_containers/food/snacks/raw_pie/berry = 1)
	output = /obj/item/reagent_containers/food/snacks/pie/cooked/berry
	good_path = /obj/item/reagent_containers/food/snacks/pie/cooked/berry/good
	cooked_smell = /datum/pollutant/food/berry_pie

/datum/container_craft/oven/pie/poisonberry
	hides_from_books = TRUE
	name = "Poison Berry Pie"
	requirements = list(/obj/item/reagent_containers/food/snacks/raw_pie/berry/poison = 1)
	output = /obj/item/reagent_containers/food/snacks/pie/cooked/poison
	cooked_smell = /datum/pollutant/food/berry_pie

/datum/container_craft/oven/pie/borowiki
	name = "Borowiki Pie"
	requirements = list(/obj/item/reagent_containers/food/snacks/raw_pie/borowiki = 1)
	output = /obj/item/reagent_containers/food/snacks/pie/cooked/borowiki
	good_path = /obj/item/reagent_containers/food/snacks/pie/cooked/borowiki/good
	cooked_smell = /datum/pollutant/food/borowiki_pie

/datum/container_craft/oven/bread
	name = "Bread"
	requirements = list(/obj/item/reagent_containers/food/snacks/dough = 1)
	output = /obj/item/reagent_containers/food/snacks/bread
	cooked_smell = /datum/pollutant/food/bread

/datum/container_craft/oven/bun
	name = "Bun"
	requirements = list(/obj/item/reagent_containers/food/snacks/dough_slice = 1)
	output = /obj/item/reagent_containers/food/snacks/bun
	cooked_smell = /datum/pollutant/food/bun

/datum/container_craft/oven/hardtack
	name = "Hardtack"
	requirements = list(/obj/item/reagent_containers/food/snacks/foodbase/hardtack_raw = 1)
	output = /obj/item/reagent_containers/food/snacks/hardtack

/datum/container_craft/oven/pie_base
	name = "Baked Pie Base"
	requirements = list(/obj/item/reagent_containers/food/snacks/piedough = 1)
	output = /obj/item/reagent_containers/food/snacks/foodbase/piebottom
	cooked_smell = /datum/pollutant/food/pie_base

/datum/container_craft/oven/baked_potato
	name = "Baked Potato"
	requirements = list(/obj/item/reagent_containers/food/snacks/produce/vegetable/potato = 1)
	output = /obj/item/reagent_containers/food/snacks/produce/vegetable/potato/baked
	cooked_smell = /datum/pollutant/food/baked_potato

/datum/container_craft/oven/plum_scone
	name = "Baked Plum Scone"
	requirements = list(/obj/item/reagent_containers/food/snacks/foodbase/scone_raw_plum = 1)
	output = /obj/item/reagent_containers/food/snacks/scone_plum
	cooked_smell = /datum/pollutant/food/scone

/datum/container_craft/oven/tangerine_scone
	name = "Baked Tangerine Scone"
	requirements = list(/obj/item/reagent_containers/food/snacks/foodbase/scone_raw_tangerine = 1)
	output = /obj/item/reagent_containers/food/snacks/scone_tangerine
	cooked_smell = /datum/pollutant/food/scone

/datum/container_craft/oven/scone
	name = "Baked Scone"
	requirements = list(/obj/item/reagent_containers/food/snacks/foodbase/scone_raw= 1)
	output = /obj/item/reagent_containers/food/snacks/scone
	cooked_smell = /datum/pollutant/food/scone

/datum/container_craft/oven/tangerinecake
	category = "Cakes"
	name = "Baked Scarletharp Cake"
	requirements = list(/obj/item/reagent_containers/food/snacks/tangerinecake_ready= 1)
	output = /obj/item/reagent_containers/food/snacks/tangerinecake_cooked
	cooked_smell = /datum/pollutant/food/strawberry_cake

/datum/container_craft/oven/crimsoncake
	category = "Cakes"
	name = "Baked Crimson Pine Cake"
	requirements = list(/obj/item/reagent_containers/food/snacks/crimsoncake_ready= 1)
	output = /obj/item/reagent_containers/food/snacks/crimsoncake_cooked
	cooked_smell = /datum/pollutant/food/crimson_cake

/datum/container_craft/oven/strawberrycake
	category = "Cakes"
	name = "Baked Strawberry Cake"
	requirements = list(/obj/item/reagent_containers/food/snacks/strawbycake_ready= 1)
	output = /obj/item/reagent_containers/food/snacks/strawbycake_cooked
	cooked_smell = /datum/pollutant/food/strawberry_cake

/datum/container_craft/oven/poisoncheesecake
	hides_from_books = TRUE
	category = "Cakes"
	name = "Baked Poison Cheesecake"
	requirements = list(/obj/item/reagent_containers/food/snacks/chescake_poison_ready= 1)
	output = /obj/item/reagent_containers/food/snacks/cheesecake_poison_cooked
	cooked_smell = /datum/pollutant/food/cheese_cake

/datum/container_craft/oven/cheesecake
	category = "Cakes"
	name = "Baked Cheesecake"
	requirements = list(/obj/item/reagent_containers/food/snacks/chescake_ready= 1)
	output = /obj/item/reagent_containers/food/snacks/cheesecake_cooked
	cooked_smell = /datum/pollutant/food/cheese_cake

/datum/container_craft/oven/honey_cake
	category = "Cakes"
	name = "Baked Zaladin Cake"
	requirements = list(/obj/item/reagent_containers/food/snacks/zybcake_ready= 1)
	output = /obj/item/reagent_containers/food/snacks/zybcake_cooked
	cooked_smell = /datum/pollutant/food/honey_cake

/datum/container_craft/oven/prezzel
	name = "Baked Prezzel"
	requirements = list(/obj/item/reagent_containers/food/snacks/foodbase/prezzel_raw= 1)
	output = /obj/item/reagent_containers/food/snacks/prezzel
	cooked_smell = /datum/pollutant/food/prezzel

/datum/container_craft/oven/prezzelgood
	hides_from_books = TRUE
	name = "Baked Prezzel"
	requirements = list(/obj/item/reagent_containers/food/snacks/foodbase/prezzel_raw/good= 1)
	output = /obj/item/reagent_containers/food/snacks/prezzel/good
	cooked_smell = /datum/pollutant/food/prezzel

/datum/container_craft/oven/biscuit
	name = "Baked Biscuit"
	requirements = list(/obj/item/reagent_containers/food/snacks/foodbase/biscuit_raw= 1)
	output = /obj/item/reagent_containers/food/snacks/biscuit
	cooked_smell = /datum/pollutant/food/biscuit

/datum/container_craft/oven/biscuitgood
	hides_from_books = TRUE
	name = "Baked Biscuit"
	requirements = list(/obj/item/reagent_containers/food/snacks/foodbase/biscuit_raw/good= 1)
	output = /obj/item/reagent_containers/food/snacks/biscuit/good
	cooked_smell = /datum/pollutant/food/biscuit

/datum/container_craft/oven/biscuitpoison
	hides_from_books = TRUE
	name = "Baked Biscuit"
	requirements = list(/obj/item/reagent_containers/food/snacks/foodbase/biscuitpoison_raw= 1)
	output = /obj/item/reagent_containers/food/snacks/biscuit_poison
	cooked_smell = /datum/pollutant/food/biscuit

/datum/container_craft/oven/cheesebun
	name = "Baked Cheese Bun"
	requirements = list(/obj/item/reagent_containers/food/snacks/foodbase/cheesebun_raw= 1)
	output = /obj/item/reagent_containers/food/snacks/cheesebun
	cooked_smell = /datum/pollutant/food/cheese_bun

/datum/container_craft/oven/raisin_bread
	name = "Raisin Bread"
	requirements = list(/obj/item/reagent_containers/food/snacks/raisindough= 1)
	output = /obj/item/reagent_containers/food/snacks/bread/raisin
	cooked_smell = /datum/pollutant/food/raisin_bread

/datum/container_craft/oven/raisin_breadpoison
	hides_from_books = TRUE
	name = "Raisin Bread"
	requirements = list(/obj/item/reagent_containers/food/snacks/raisindough_poison= 1)
	output = /obj/item/reagent_containers/food/snacks/bread/raisin/poison
	cooked_smell = /datum/pollutant/food/raisin_bread

/datum/container_craft/oven/toast
	name = "Toast"
	requirements = list(/obj/item/reagent_containers/food/snacks/breadslice= 1)
	output = /obj/item/reagent_containers/food/snacks/breadslice/toast
	cooked_smell = /datum/pollutant/food/toast

/datum/container_craft/oven/clay_brick
	name = "Brick"
	requirements = list(/obj/item/natural/raw_brick= 1)
	output = /obj/item/natural/brick
	cooked_smell = null

/datum/container_craft/oven/coffeebean
	name = "Roasted Coffee-Beans"
	requirements = list(/obj/item/reagent_containers/food/snacks/produce/coffeebeans= 1)
	output = /obj/item/reagent_containers/food/snacks/produce/coffeebeansroasted
	cooked_smell = null

/datum/container_craft/oven/tart_base
	name = "Baked Tart Crust"
	requirements = list(/obj/item/reagent_containers/food/snacks/foodbase/piebottom = 1)
	output = /obj/item/reagent_containers/food/snacks/foodbase/tartcrust
	cooked_smell = /datum/pollutant/food/pastry

/datum/container_craft/oven/pie/avocado
	name = "Avocado Tart"
	requirements = list(/obj/item/reagent_containers/food/snacks/raw_tart/avocado = 1)
	output = /obj/item/reagent_containers/food/snacks/tart/cooked/avocado
	cooked_smell = /datum/pollutant/food/pastry

/datum/container_craft/oven/pie/mango
	name = "Mangga Tart"
	requirements = list(/obj/item/reagent_containers/food/snacks/raw_tart/mango = 1)
	output = /obj/item/reagent_containers/food/snacks/tart/cooked/mango
	cooked_smell = /datum/pollutant/food/pastry

/datum/container_craft/oven/pie/mangosteen
	name = "Mangosteen Tart"
	requirements = list(/obj/item/reagent_containers/food/snacks/raw_tart/mangosteen = 1)
	output = /obj/item/reagent_containers/food/snacks/tart/cooked/mangosteen
	cooked_smell = /datum/pollutant/food/pastry

/datum/container_craft/oven/pie/pineapple
	name = "Ananas Tart"
	requirements = list(/obj/item/reagent_containers/food/snacks/raw_tart/pineapple = 1)
	output = /obj/item/reagent_containers/food/snacks/tart/cooked/pineapple
	cooked_smell = /datum/pollutant/food/pastry

/datum/container_craft/oven/pie/dragonfruit
	name = "Piyata Tart"
	requirements = list(/obj/item/reagent_containers/food/snacks/raw_tart/dragonfruit = 1)
	output = /obj/item/reagent_containers/food/snacks/tart/cooked/dragonfruit
	cooked_smell = /datum/pollutant/food/pastry
