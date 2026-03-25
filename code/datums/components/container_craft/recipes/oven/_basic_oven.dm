/datum/container_craft/oven
	abstract_type = /datum/container_craft/oven
	required_container = /obj/machinery/light/fueled/oven
	crafting_time = 25 SECONDS
	category = "Oven"
	used_skill = /datum/attribute/skill/craft/cooking/baking

	var/datum/pollutant/cooked_smell

/datum/container_craft/oven/get_real_time(atom/host, mob/user, estimated_multiplier)
	var/real_cooking_time = crafting_time * estimated_multiplier
	if(user.mind)
		real_cooking_time /= 1 + (GET_MOB_SKILL_VALUE_OLD(user, /datum/attribute/skill/craft/cooking) * 0.2)
		real_cooking_time = round(real_cooking_time)
	return real_cooking_time

/datum/container_craft/oven/after_craft(atom/created_output, obj/item/crafter, mob/initiator, list/found_optional_requirements, list/found_optional_wildcards, list/found_optional_reagents, list/removing_items)
	for(var/obj/item/reagent_containers/food/snacks/item in removing_items)
		item.initialize_cooked_food(list(created_output), 1)

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
	category = "Vanderlin Cuisine"
	name = "Apple Fritter"
	requirements = list(/obj/item/reagent_containers/food/snacks/foodbase/fritter_raw = 1)
	output = /obj/item/reagent_containers/food/snacks/fritter
	cooked_smell = /datum/pollutant/food/fritter
	used_skill = /datum/attribute/skill/craft/cooking/baking

/datum/container_craft/oven/apple_frittergood
	hides_from_books = TRUE
	name = "Apple Fritter"
	requirements = list(/obj/item/reagent_containers/food/snacks/foodbase/fritter_raw/good = 1)
	output = /obj/item/reagent_containers/food/snacks/fritter/good
	cooked_smell = /datum/pollutant/food/fritter
	used_skill = /datum/attribute/skill/craft/cooking/baking

/datum/container_craft/oven/handpie
	name = "Baked Handpie"
	wildcard_requirements = list(/obj/item/reagent_containers/food/snacks/foodbase/handpieraw = 1)
	output = /obj/item/reagent_containers/food/snacks/handpie
	cooked_smell = /datum/pollutant/food/pie_base
	used_skill = /datum/attribute/skill/craft/cooking/baking

/datum/container_craft/oven/handpie/create_item(obj/item/crafter, mob/initiator, list/found_optional_requirements, list/found_optional_wildcards, list/found_optional_reagents, list/removing_items)
	var/create_type = output
	if(GET_MOB_SKILL_VALUE_OLD(initiator, /datum/attribute/skill/craft/cooking) >= 2)
		create_type = /obj/item/reagent_containers/food/snacks/handpie/good

	for(var/j = 1 to output_amount)
		var/atom/created_output = new create_type(get_turf(crafter))
		SEND_SIGNAL(crafter, COMSIG_TRY_STORAGE_INSERT, created_output, null, null, TRUE, TRUE)
		after_craft(created_output, crafter, initiator, found_optional_requirements, found_optional_wildcards, found_optional_reagents, removing_items)
		SEND_SIGNAL(crafter, COMSIG_CONTAINER_CRAFT_COMPLETE, created_output)

/datum/container_craft/oven/huskbun
	category = "Tiefling Cuisine"
	name = "Baked Huskbun"
	wildcard_requirements = list(/obj/item/reagent_containers/food/snacks/foodbase/huskbunraw = 1)
	output = /obj/item/reagent_containers/food/snacks/huskbun
	cooked_smell = /datum/pollutant/food/sunreed_dough

/datum/container_craft/oven/huskbun/create_item(obj/item/crafter, mob/initiator, list/found_optional_requirements, list/found_optional_wildcards, list/found_optional_reagents, list/removing_items)
	var/create_type = output
	for(var/j = 1 to output_amount)
		var/atom/created_output = new create_type(get_turf(crafter))
		SEND_SIGNAL(crafter, COMSIG_TRY_STORAGE_INSERT, created_output, null, null, TRUE, TRUE)
		after_craft(created_output, crafter, initiator, found_optional_requirements, found_optional_wildcards, found_optional_reagents, removing_items)
		SEND_SIGNAL(crafter, COMSIG_CONTAINER_CRAFT_COMPLETE, created_output)

/datum/container_craft/oven/roastbird
	name = "Roast Bird"
	wildcard_requirements = list(/obj/item/reagent_containers/food/snacks/meat/poultry = 1)
	output = /obj/item/reagent_containers/food/snacks/cooked/roastchicken
	cooked_smell = /datum/pollutant/food/fried_chicken
	used_skill = /datum/attribute/skill/craft/cooking/grilling

/datum/container_craft/oven/ribrack
	name = "Roast Ribrack"
	wildcard_requirements = list(/obj/item/reagent_containers/food/snacks/meat/ribs = 1)
	output = /obj/item/reagent_containers/food/snacks/bread/ribrack
	cooked_smell = /datum/pollutant/food/baked_meat

/datum/container_craft/oven/pastry
	name = "Pastry"
	requirements = list(/obj/item/reagent_containers/food/snacks/butterdough_slice = 1)
	output = /obj/item/reagent_containers/food/snacks/pastry
	cooked_smell = /datum/pollutant/food/pastry
	used_skill = /datum/attribute/skill/craft/cooking/baking

/datum/container_craft/oven/pie
	abstract_type = /datum/container_craft/oven/pie
	category = "Pies"
	used_skill = /datum/attribute/skill/craft/cooking/baking
	var/atom/good_path

/datum/container_craft/oven/pie/create_item(obj/item/crafter, mob/initiator, list/found_optional_requirements, list/found_optional_wildcards, list/found_optional_reagents, list/removing_items)
	var/create_path = output
	if((GET_MOB_SKILL_VALUE_OLD(initiator, /datum/attribute/skill/craft/cooking) >= 2 )&& good_path)
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

/datum/container_craft/oven/pie/blackberry
	name = "Blackberry Pie"
	requirements = list(/obj/item/reagent_containers/food/snacks/raw_pie/blackberry = 1)
	output = /obj/item/reagent_containers/food/snacks/pie/cooked/blackberry
	good_path = /obj/item/reagent_containers/food/snacks/pie/cooked/blackberry
	cooked_smell = /datum/pollutant/food/blackberry_pie

/datum/container_craft/oven/pie/raspberry
	name = "Raspberry Pie"
	requirements = list(/obj/item/reagent_containers/food/snacks/raw_pie/raspberry = 1)
	output = /obj/item/reagent_containers/food/snacks/pie/cooked/raspberry
	good_path = /obj/item/reagent_containers/food/snacks/pie/cooked/raspberry
	cooked_smell = /datum/pollutant/food/raspberry_pie

/datum/container_craft/oven/pie/pompkaun
	name = "Pompkaun Pie"
	requirements = list(/obj/item/reagent_containers/food/snacks/raw_pie/pompkaun = 1)
	output = /obj/item/reagent_containers/food/snacks/pie/cooked/pompkaun
	good_path = /obj/item/reagent_containers/food/snacks/pie/cooked/pompkaun
	cooked_smell = /datum/pollutant/food/pompkaun_pie

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

/datum/container_craft/oven/bookbread
	category = "Holiday Food"
	name = "Bookbread"
	requirements = list(/obj/item/reagent_containers/food/snacks/butterdough = 1)
	output = /obj/item/reagent_containers/food/snacks/bread/bookbread
	cooked_smell = /datum/pollutant/food/pastry

/datum/container_craft/oven/raspberrybookbread
	category = "Holiday Food"
	name = "Raspberry Bookbread"
	requirements = list(/obj/item/reagent_containers/food/snacks/raspberrybutterdough = 1)
	output = /obj/item/reagent_containers/food/snacks/bread/bookbread/raspberry
	cooked_smell = /datum/pollutant/food/pastry

/datum/container_craft/oven/jacksberrybookbread
	category = "Holiday Food"
	name = "Raisin Bookbread"
	requirements = list(/obj/item/reagent_containers/food/snacks/jacksberrybutterdough = 1)
	output = /obj/item/reagent_containers/food/snacks/bread/bookbread/jacksberry
	cooked_smell = /datum/pollutant/food/pastry

/datum/container_craft/oven/poisonjacksberrybookbread
	hides_from_books = TRUE
	name = "Raisin Bookbread (Poison)"
	requirements = list(/obj/item/reagent_containers/food/snacks/jacksberrybutterdough/poison = 1)
	output = /obj/item/reagent_containers/food/snacks/bread/bookbread/jacksberry/poison
	cooked_smell = /datum/pollutant/food/pastry

/datum/container_craft/oven/blackberrybookbread
	category = "Holiday Food"
	name = "Blackberry Bookbread"
	requirements = list(/obj/item/reagent_containers/food/snacks/blackberrybutterdough = 1)
	output = /obj/item/reagent_containers/food/snacks/bread/bookbread/blackberry
	cooked_smell = /datum/pollutant/food/pastry

/datum/container_craft/oven/pearbookbread
	category = "Holiday Food"
	name = "Pear Bookbread"
	requirements = list(/obj/item/reagent_containers/food/snacks/pearbutterdough = 1)
	output = /obj/item/reagent_containers/food/snacks/bread/bookbread/pear
	cooked_smell = /datum/pollutant/food/pastry

/datum/container_craft/oven/tangerinebookbread
	category = "Holiday Food"
	name = "Tangerine Bookbread"
	requirements = list(/obj/item/reagent_containers/food/snacks/tangerinebutterdough = 1)
	output = /obj/item/reagent_containers/food/snacks/bread/bookbread/tangerine
	cooked_smell = /datum/pollutant/food/pastry

/datum/container_craft/oven/plumbookbread
	category = "Holiday Food"
	name = "Plum Bookbread"
	requirements = list(/obj/item/reagent_containers/food/snacks/plumbutterdough = 1)
	output = /obj/item/reagent_containers/food/snacks/bread/bookbread/plum
	cooked_smell = /datum/pollutant/food/pastry

/datum/container_craft/oven/lemonbookbread
	category = "Holiday Food"
	name = "Lemon Bookbread"
	requirements = list(/obj/item/reagent_containers/food/snacks/lemonbutterdough = 1)
	output = /obj/item/reagent_containers/food/snacks/bread/bookbread/lemon
	cooked_smell = /datum/pollutant/food/pastry

/datum/container_craft/oven/chocolatebookbread
	category = "Holiday Food"
	name = "Chocolate Bookbread"
	requirements = list(/obj/item/reagent_containers/food/snacks/chocolatebutterdough = 1)
	output = /obj/item/reagent_containers/food/snacks/bread/bookbread/chocolate
	cooked_smell = /datum/pollutant/food/pastry

/datum/container_craft/oven/bun
	name = "Bun"
	requirements = list(/obj/item/reagent_containers/food/snacks/dough_slice = 1)
	output = /obj/item/reagent_containers/food/snacks/bun
	cooked_smell = /datum/pollutant/food/bun
	used_skill = /datum/attribute/skill/craft/cooking/baking

/datum/container_craft/oven/choco_pastry
	name = "Chocolate Pastry"
	requirements = list(/obj/item/reagent_containers/food/snacks/choco_butterdough_slice = 1)
	output = /obj/item/reagent_containers/food/snacks/choco_pastry
	cooked_smell = /datum/pollutant/food/pastry

/datum/container_craft/oven/choco_bun
	name = "Chocolate Bun"
	requirements = list(/obj/item/reagent_containers/food/snacks/choco_bun_raw = 1)
	output = /obj/item/reagent_containers/food/snacks/choco_bun
	cooked_smell = /datum/pollutant/food/bun

/datum/container_craft/oven/choccy_cookie
	name = "Chocolate Chip Cookie"
	requirements = list(/obj/item/reagent_containers/food/snacks/choccy_cookie_raw = 1)
	output = /obj/item/reagent_containers/food/snacks/choccy_cookie
	cooked_smell = /datum/pollutant/food/pastry

/datum/container_craft/oven/xylixbun
	name = "Xylix Bun"
	hides_from_books = TRUE //Secret bun ooooooo
	requirements = list(/obj/item/reagent_containers/food/snacks/foodbase/xylixbun_raw = 1)
	output = /obj/item/reagent_containers/food/snacks/xylixbun
	cooked_smell = /datum/pollutant/food/bun

/datum/container_craft/oven/hardtack
	name = "Hardtack"
	requirements = list(/obj/item/reagent_containers/food/snacks/foodbase/hardtack_raw = 1)
	output = /obj/item/reagent_containers/food/snacks/hardtack
	used_skill = /datum/attribute/skill/craft/cooking/baking

/datum/container_craft/oven/pie_base
	name = "Baked Pie Base"
	requirements = list(/obj/item/reagent_containers/food/snacks/piedough = 1)
	output = /obj/item/reagent_containers/food/snacks/foodbase/piebottom
	cooked_smell = /datum/pollutant/food/pie_base
	used_skill = /datum/attribute/skill/craft/cooking/baking

/datum/container_craft/oven/baked_potato
	name = "Baked Potato"
	requirements = list(/obj/item/reagent_containers/food/snacks/produce/vegetable/potato = 1)
	output = /obj/item/reagent_containers/food/snacks/produce/vegetable/potato/baked
	cooked_smell = /datum/pollutant/food/baked_potato

/datum/container_craft/oven/baked_pompkaun
	name = "Baked Pompkaun"
	requirements = list(/obj/item/reagent_containers/food/snacks/fruit/pompkaun_goo = 1)
	output = /obj/item/reagent_containers/food/snacks/fruit/pompkaun_goo/cooked
	cooked_smell = /datum/pollutant/food/baked_pompkaun

/datum/container_craft/oven/plum_scone
	name = "Baked Plum Scone"
	requirements = list(/obj/item/reagent_containers/food/snacks/foodbase/scone_raw_plum = 1)
	output = /obj/item/reagent_containers/food/snacks/scone_plum
	cooked_smell = /datum/pollutant/food/scone
	used_skill = /datum/attribute/skill/craft/cooking/baking

/datum/container_craft/oven/tangerine_scone
	name = "Baked Tangerine Scone"
	requirements = list(/obj/item/reagent_containers/food/snacks/foodbase/scone_raw_tangerine = 1)
	output = /obj/item/reagent_containers/food/snacks/scone_tangerine
	cooked_smell = /datum/pollutant/food/scone
	used_skill = /datum/attribute/skill/craft/cooking/baking

/datum/container_craft/oven/choco_scone
	name = "Chocolate Scone"
	requirements = list(/obj/item/reagent_containers/food/snacks/foodbase/scone_raw_choco = 1)
	output = /obj/item/reagent_containers/food/snacks/scone_choco
	cooked_smell = /datum/pollutant/food/scone

/datum/container_craft/oven/scone
	name = "Baked Scone"
	requirements = list(/obj/item/reagent_containers/food/snacks/foodbase/scone_raw= 1)
	output = /obj/item/reagent_containers/food/snacks/scone
	cooked_smell = /datum/pollutant/food/scone
	used_skill = /datum/attribute/skill/craft/cooking/baking

/datum/container_craft/oven/tangerinecake
	category = "Cakes"
	name = "Baked Scarletharp Cake"
	requirements = list(/obj/item/reagent_containers/food/snacks/tangerinecake_ready= 1)
	output = /obj/item/reagent_containers/food/snacks/tangerinecake_cooked
	cooked_smell = /datum/pollutant/food/strawberry_cake
	used_skill = /datum/attribute/skill/craft/cooking/baking

/datum/container_craft/oven/crimsoncake
	category = "Cakes"
	name = "Baked Crimson Pine Cake"
	requirements = list(/obj/item/reagent_containers/food/snacks/crimsoncake_ready= 1)
	output = /obj/item/reagent_containers/food/snacks/crimsoncake_cooked
	cooked_smell = /datum/pollutant/food/crimson_cake
	used_skill = /datum/attribute/skill/craft/cooking/baking

/datum/container_craft/oven/strawberrycake
	category = "Cakes"
	name = "Baked Strawberry Cake"
	requirements = list(/obj/item/reagent_containers/food/snacks/strawbycake_ready= 1)
	output = /obj/item/reagent_containers/food/snacks/strawbycake_cooked
	cooked_smell = /datum/pollutant/food/strawberry_cake
	used_skill = /datum/attribute/skill/craft/cooking/baking

/datum/container_craft/oven/cheesecake
	category = "Cakes"
	name = "Baked Cheesecake"
	requirements = list(/obj/item/reagent_containers/food/snacks/chescake_ready= 1)
	output = /obj/item/reagent_containers/food/snacks/cheesecake_cooked
	cooked_smell = /datum/pollutant/food/cheese_cake
	used_skill = /datum/attribute/skill/craft/cooking/baking

/datum/container_craft/oven/honey_cake
	category = "Cakes"
	name = "Baked Zaladin Cake"
	requirements = list(/obj/item/reagent_containers/food/snacks/zybcake_ready= 1)
	output = /obj/item/reagent_containers/food/snacks/zybcake_cooked
	cooked_smell = /datum/pollutant/food/honey_cake
	used_skill = /datum/attribute/skill/craft/cooking/baking

/datum/container_craft/oven/tamto_cake
	category = "Cakes"
	name = "Baked Tamto Silk Cake"
	requirements = list(/obj/item/reagent_containers/food/snacks/tamtocake_ready= 1)
	output = /obj/item/reagent_containers/food/snacks/tamtocake_cooked
	cooked_smell = /datum/pollutant/food/tamto_cake

/datum/container_craft/oven/eighthscake
	category = "Tiefling Cuisine"
	name = "Baked Eighthscake"
	requirements = list(/obj/item/reagent_containers/food/snacks/eighthscake_unbaked = 1)
	output = /obj/item/reagent_containers/food/snacks/eighthscake
	cooked_smell = /datum/pollutant/food/sunreed_dough

/datum/container_craft/oven/eighthscake_lemon
	category = "Tiefling Cuisine"
	name = "Baked Lemon Eighthscake"
	requirements = list(/obj/item/reagent_containers/food/snacks/eighthscake_unbaked/lemon = 1)
	output = /obj/item/reagent_containers/food/snacks/eighthscake/lemon
	cooked_smell = /datum/pollutant/food/sunreed_dough

/datum/container_craft/oven/eighthscake_lime
	category = "Tiefling Cuisine"
	name = "Baked Lime Eighthscake"
	requirements = list(/obj/item/reagent_containers/food/snacks/eighthscake_unbaked/lime = 1)
	output = /obj/item/reagent_containers/food/snacks/eighthscake/lime
	cooked_smell = /datum/pollutant/food/sunreed_dough

/datum/container_craft/oven/prezzel
	name = "Baked Prezzel"
	requirements = list(/obj/item/reagent_containers/food/snacks/foodbase/prezzel_raw= 1)
	output = /obj/item/reagent_containers/food/snacks/prezzel
	cooked_smell = /datum/pollutant/food/prezzel
	used_skill = /datum/attribute/skill/craft/cooking/baking

/datum/container_craft/oven/prezzelgood
	hides_from_books = TRUE
	name = "Baked Prezzel"
	requirements = list(/obj/item/reagent_containers/food/snacks/foodbase/prezzel_raw/good= 1)
	output = /obj/item/reagent_containers/food/snacks/prezzel/good
	cooked_smell = /datum/pollutant/food/prezzel
	used_skill = /datum/attribute/skill/craft/cooking/baking

/datum/container_craft/oven/biscuit
	name = "Baked Biscuit"
	requirements = list(/obj/item/reagent_containers/food/snacks/foodbase/biscuit_raw= 1)
	output = /obj/item/reagent_containers/food/snacks/biscuit
	cooked_smell = /datum/pollutant/food/biscuit
	used_skill = /datum/attribute/skill/craft/cooking/baking

/datum/container_craft/oven/biscuitgood
	hides_from_books = TRUE
	name = "Baked Biscuit"
	requirements = list(/obj/item/reagent_containers/food/snacks/foodbase/biscuit_raw/good= 1)
	output = /obj/item/reagent_containers/food/snacks/biscuit/good
	cooked_smell = /datum/pollutant/food/biscuit
	used_skill = /datum/attribute/skill/craft/cooking/baking

/datum/container_craft/oven/cheesebun
	name = "Baked Cheese Bun"
	requirements = list(/obj/item/reagent_containers/food/snacks/foodbase/cheesebun_raw= 1)
	output = /obj/item/reagent_containers/food/snacks/cheesebun
	cooked_smell = /datum/pollutant/food/cheese_bun
	used_skill = /datum/attribute/skill/craft/cooking/baking

/datum/container_craft/oven/raisin_bread
	name = "Raisin Bread"
	requirements = list(/obj/item/reagent_containers/food/snacks/raisindough= 1)
	output = /obj/item/reagent_containers/food/snacks/bread/raisin
	cooked_smell = /datum/pollutant/food/raisin_bread
	used_skill = /datum/attribute/skill/craft/cooking/baking

/datum/container_craft/oven/toast
	name = "Toast"
	requirements = list(/obj/item/reagent_containers/food/snacks/breadslice= 1)
	output = /obj/item/reagent_containers/food/snacks/breadslice/toast
	cooked_smell = /datum/pollutant/food/toast
	used_skill = /datum/attribute/skill/craft/cooking/baking

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
	used_skill = /datum/attribute/skill/craft/cooking/fine_cuisine

/datum/container_craft/oven/tart_base
	name = "Baked Tart Crust"
	requirements = list(/obj/item/reagent_containers/food/snacks/foodbase/piebottom = 1)
	output = /obj/item/reagent_containers/food/snacks/foodbase/tartcrust
	cooked_smell = /datum/pollutant/food/pastry
	used_skill = /datum/attribute/skill/craft/cooking/baking

/datum/container_craft/oven/pie/avocado
	name = "Avocado Tart"
	requirements = list(/obj/item/reagent_containers/food/snacks/raw_tart/avocado = 1)
	output = /obj/item/reagent_containers/food/snacks/tart/cooked/avocado
	cooked_smell = /datum/pollutant/food/pastry
	used_skill = /datum/attribute/skill/craft/cooking/baking

/datum/container_craft/oven/pie/mango
	name = "Mangga Tart"
	requirements = list(/obj/item/reagent_containers/food/snacks/raw_tart/mango = 1)
	output = /obj/item/reagent_containers/food/snacks/tart/cooked/mango
	cooked_smell = /datum/pollutant/food/pastry
	used_skill = /datum/attribute/skill/craft/cooking/baking

/datum/container_craft/oven/pie/mangosteen
	name = "Mangosteen Tart"
	requirements = list(/obj/item/reagent_containers/food/snacks/raw_tart/mangosteen = 1)
	output = /obj/item/reagent_containers/food/snacks/tart/cooked/mangosteen
	cooked_smell = /datum/pollutant/food/pastry
	used_skill = /datum/attribute/skill/craft/cooking/baking

/datum/container_craft/oven/pie/pineapple
	name = "Ananas Tart"
	requirements = list(/obj/item/reagent_containers/food/snacks/raw_tart/pineapple = 1)
	output = /obj/item/reagent_containers/food/snacks/tart/cooked/pineapple
	cooked_smell = /datum/pollutant/food/pastry
	used_skill = /datum/attribute/skill/craft/cooking/baking

/datum/container_craft/oven/pie/dragonfruit
	name = "Piyata Tart"
	requirements = list(/obj/item/reagent_containers/food/snacks/raw_tart/dragonfruit = 1)
	output = /obj/item/reagent_containers/food/snacks/tart/cooked/dragonfruit
	cooked_smell = /datum/pollutant/food/pastry
	used_skill = /datum/attribute/skill/craft/cooking/baking

/datum/container_craft/oven/pie/chocolate
	name = "Chocolate Tart"
	requirements = list(/obj/item/reagent_containers/food/snacks/raw_tart/chocolate = 1)
	output = /obj/item/reagent_containers/food/snacks/tart/cooked/chocolate
	cooked_smell = /datum/pollutant/food/pastry

/datum/container_craft/oven/sunreed_bread
	category = "Tiefling Cuisine"
	name = "Sunbread"
	requirements = list(/obj/item/reagent_containers/food/snacks/masa = 1)
	output = /obj/item/reagent_containers/food/snacks/sunreed_bread
	cooked_smell = /datum/pollutant/food/sunreed_dough
	used_skill = /datum/attribute/skill/craft/cooking/baking

/datum/container_craft/oven/honey_sunreed_bread
	category = "Tiefling Cuisine"
	name = "Honeyed Sunbread"
	requirements = list(/obj/item/reagent_containers/food/snacks/masa_honey = 1)
	output = /obj/item/reagent_containers/food/snacks/sunreed_bread/honey
	cooked_smell = /datum/pollutant/food/sunreed_dough
	used_skill = /datum/attribute/skill/craft/cooking/baking

/datum/container_craft/oven/estrella
	category = "Tiefling Cuisine"
	name = "Estrella"
	requirements = list(/obj/item/reagent_containers/food/snacks/masa_slice = 1)
	output = /obj/item/reagent_containers/food/snacks/estrella
	cooked_smell = /datum/pollutant/food/sunreed_dough
	used_skill = /datum/attribute/skill/craft/cooking/baking

/datum/container_craft/oven/comelette
	category = "Tiefling Cuisine"
	name = "Caravaneer's Omelette"
	requirements = list(/obj/item/reagent_containers/food/snacks/comelette_uncooked = 1)
	output = /obj/item/reagent_containers/food/snacks/cooked/comelette
	cooked_smell = /datum/pollutant/food/fried_eggs

/datum/container_craft/oven/comelette_veggie
	category = "Tiefling Cuisine"
	name = "Veggie Caravaneer's Omelette"
	requirements = list(/obj/item/reagent_containers/food/snacks/comelette_uncooked/veggie = 1)
	output = /obj/item/reagent_containers/food/snacks/cooked/comelette/veggie
	cooked_smell = /datum/pollutant/food/fried_eggs

/datum/container_craft/oven/comelette_meat
	category = "Tiefling Cuisine"
	name = "Meat Caravaneer's Omelette"
	requirements = list(/obj/item/reagent_containers/food/snacks/comelette_uncooked/meat = 1)
	output = /obj/item/reagent_containers/food/snacks/cooked/comelette/meat
	cooked_smell = /datum/pollutant/food/fried_eggs

/datum/container_craft/oven/dottart_strawberry
	name = "Baked Strawberry Dot Tart"
	requirements = list(/obj/item/reagent_containers/food/snacks/foodbase/dottart_base/strawberry = 1)
	output = /obj/item/reagent_containers/food/snacks/dottart_strawberry
	cooked_smell = /datum/pollutant/food/pastry
	used_skill = /datum/attribute/skill/craft/cooking/baking

/datum/container_craft/oven/dottart_tangerine
	name = "Baked Tangerine Dot Tart"
	requirements = list(/obj/item/reagent_containers/food/snacks/foodbase/dottart_base/tangerine = 1)
	output = /obj/item/reagent_containers/food/snacks/dottart_tangerine
	cooked_smell = /datum/pollutant/food/pastry
	used_skill = /datum/attribute/skill/craft/cooking/baking

/datum/container_craft/oven/dottart_plum
	name = "Baked Plum Dot Tart"
	requirements = list(/obj/item/reagent_containers/food/snacks/foodbase/dottart_base/plum = 1)
	output = /obj/item/reagent_containers/food/snacks/dottart_plum
	cooked_smell = /datum/pollutant/food/pastry
	used_skill = /datum/attribute/skill/craft/cooking/baking

/datum/container_craft/oven/dottart_blackberry
	name = "Baked Blackberry Dot Tart"
	requirements = list(/obj/item/reagent_containers/food/snacks/foodbase/dottart_base/blackberry = 1)
	output = /obj/item/reagent_containers/food/snacks/dottart_blackberry
	cooked_smell = /datum/pollutant/food/pastry
	used_skill = /datum/attribute/skill/craft/cooking/baking

/datum/container_craft/oven/dottart_raspberry
	name = "Baked Raspberry Dot Tart"
	requirements = list(/obj/item/reagent_containers/food/snacks/foodbase/dottart_base/raspberry = 1)
	output = /obj/item/reagent_containers/food/snacks/dottart_raspberry
	cooked_smell = /datum/pollutant/food/pastry
	used_skill = /datum/attribute/skill/craft/cooking/baking

/datum/container_craft/oven/dottart_lemon
	name = "Baked Lemon Dot Tart"
	requirements = list(/obj/item/reagent_containers/food/snacks/foodbase/dottart_base/lemon = 1)
	output = /obj/item/reagent_containers/food/snacks/dottart_lemon
	cooked_smell = /datum/pollutant/food/pastry
	used_skill = /datum/attribute/skill/craft/cooking/baking

/datum/container_craft/oven/dottart_lime
	name = "Baked Lime Dot Tart"
	requirements = list(/obj/item/reagent_containers/food/snacks/foodbase/dottart_base/lime = 1)
	output = /obj/item/reagent_containers/food/snacks/dottart_lime
	cooked_smell = /datum/pollutant/food/pastry
	used_skill = /datum/attribute/skill/craft/cooking/baking

/datum/container_craft/oven/dottart_pear
	name = "Baked Pear Dot Tart"
	requirements = list(/obj/item/reagent_containers/food/snacks/foodbase/dottart_base/pear = 1)
	output = /obj/item/reagent_containers/food/snacks/dottart_pear
	cooked_smell = /datum/pollutant/food/pastry
	used_skill = /datum/attribute/skill/craft/cooking/baking

/datum/container_craft/oven/tamtoplate_cheese
	category = "Vanderlin Cuisine"
	name = "Cheese Tamtoplate"
	requirements = list(/obj/item/reagent_containers/food/snacks/foodbase/tamtoplate_unfinished = 1)
	output = /obj/item/reagent_containers/food/snacks/tamtoplate
	cooked_smell = /datum/pollutant/food/tamtoplate

/datum/container_craft/oven/tamtoplate_meat
	category = "Vanderlin Cuisine"
	name = "Sausage Tamtoplate"
	requirements = list(/obj/item/reagent_containers/food/snacks/foodbase/tamtoplate_unfinished_meat = 1)
	output = /obj/item/reagent_containers/food/snacks/tamtoplate/meat
	cooked_smell = /datum/pollutant/food/tamtoplate

/datum/container_craft/oven/tamtoplate_fish
	category = "Vanderlin Cuisine"
	name = "Fish Tamtoplate"
	requirements = list(/obj/item/reagent_containers/food/snacks/foodbase/tamtoplate_unfinished_fish = 1)
	output = /obj/item/reagent_containers/food/snacks/tamtoplate/fish
	cooked_smell = /datum/pollutant/food/tamtoplate

/datum/container_craft/oven/tamtoplate_onion
	category = "Vanderlin Cuisine"
	name = "Onion Tamtoplate"
	requirements = list(/obj/item/reagent_containers/food/snacks/foodbase/tamtoplate_unfinished_onion = 1)
	output = /obj/item/reagent_containers/food/snacks/tamtoplate/onion
	cooked_smell = /datum/pollutant/food/tamtoplate
