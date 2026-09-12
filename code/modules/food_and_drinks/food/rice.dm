/* .............   RICE   ................ */
/obj/item/reagent_containers/food/snacks/ricewet
	name = "washed rice"
	desc = ""
	gender = PLURAL
	icon = 'icons/roguetown/items/produce.dmi'
	icon_state = "rice"
	list_reagents = list(/datum/reagent/flour = 1)
	volume = 1
	sellprice = 0

/obj/item/reagent_containers/food/snacks/rice_cooked
	name = "cooked rice"
	desc = "Plain cooked rice, a staple food in many cultures."
	icon = 'icons/obj/food/cooked/cooked_rice.dmi'
	icon_state = "rice"
	faretype = FARE_POOR
	bitesize = 3
	bonus_reagents = list(/datum/reagent/consumable/nutriment = SNACK_DECENT)
	rotprocess = SHELFLIFE_LONG

/*	.................   Rice & pork  ................... */
/obj/item/reagent_containers/food/snacks/ricepork
	name = "rice and pork"
	tastes = list("rice" = 1, "pork" = 1)
	list_reagents = list(/datum/reagent/consumable/nutriment = MEAL_MEAGRE)
	desc = "Rice mixed with fatty pork."
	icon = 'icons/obj/food/cooked/cooked_rice.dmi'
	icon_state = "ricepork"
	faretype = FARE_FINE
	rotprocess = SHELFLIFE_LONG
	eat_effect = /datum/status_effect/buff/foodbuff

/*	.................   Rice & pork & cucumbers ................... */
/obj/item/reagent_containers/food/snacks/riceporkcuc
	name = "rice and pork meal"
	tastes = list("rice" = 1, "pork" = 1, "fresh avocado" = 1)
	list_reagents = list(/datum/reagent/consumable/nutriment = MEAL_AVERAGE)
	desc = "Rice mixed with fatty pork and fresh avocado."
	icon = 'icons/obj/food/cooked/cooked_rice.dmi'
	icon_state = "riceporkmeal"
	faretype = FARE_LAVISH
	rotprocess = SHELFLIFE_LONG
	eat_effect = /datum/status_effect/buff/foodbuff/tier2

/*	.................   Rice & beef ................... */
/obj/item/reagent_containers/food/snacks/ricebeef
	name = "rice and beef"
	tastes = list("rice" = 1, "steak" = 1)
	list_reagents = list(/datum/reagent/consumable/nutriment = MEAL_MEAGRE)
	desc = "Rice mixed with beef steak."
	icon = 'icons/obj/food/cooked/cooked_rice.dmi'
	icon_state = "ricebeef"
	faretype = FARE_FINE
	rotprocess = SHELFLIFE_LONG
	eat_effect = /datum/status_effect/buff/foodbuff

/*	.................   Rice & beef & carrots ................... */
/obj/item/reagent_containers/food/snacks/ricebeefcar
	name = "rice and beef meal"
	tastes = list("rice" = 1, "steak" = 1, "fried cabbage" = 1)
	list_reagents = list(/datum/reagent/consumable/nutriment = MEAL_AVERAGE)
	desc = "Rice mixed with beef steak and fried cabbage."
	icon = 'icons/obj/food/cooked/cooked_rice.dmi'
	icon_state = "ricebeefmeal"
	faretype = FARE_LAVISH
	rotprocess = SHELFLIFE_LONG
	eat_effect = /datum/status_effect/buff/foodbuff/tier2

/*	.................   Rice & shrimp ................... */
/obj/item/reagent_containers/food/snacks/riceshrimp
	name = "rice and shrimp"
	tastes = list("rice" = 1, "shrimp" = 1)
	list_reagents = list(/datum/reagent/consumable/nutriment = MEAL_MEAGRE)
	desc = "Rice mixed with shrimp."
	icon = 'icons/obj/food/cooked/cooked_rice.dmi'
	icon_state = "riceshrimp"
	faretype = FARE_FINE
	rotprocess = SHELFLIFE_LONG
	eat_effect = /datum/status_effect/buff/foodbuff

/*	.................   Rice & shrimp & carrots ................... */
/obj/item/reagent_containers/food/snacks/riceshrimpcar
	name = "rice and shrimp meal"
	tastes = list("rice" = 1, "shrimp" = 1, "fried cabbage" = 1)
	list_reagents = list(/datum/reagent/consumable/nutriment = MEAL_MEAGRE)
	desc = "Rice mixed with shrimp and fried cabbage."
	icon = 'icons/obj/food/cooked/cooked_rice.dmi'
	icon_state = "riceshrimpmeal"
	faretype = FARE_LAVISH
	rotprocess = SHELFLIFE_LONG
	eat_effect = /datum/status_effect/buff/foodbuff/tier2

/*	.................   Rice & bird ................... */
/obj/item/reagent_containers/food/snacks/ricebird
	name = "rice and frybird"
	tastes = list("rice" = 1, "tasty birdmeat" = 1)
	list_reagents = list(/datum/reagent/consumable/nutriment = MEAL_MEAGRE)
	desc = "Rice mixed with frybird."
	icon = 'icons/obj/food/cooked/cooked_rice.dmi'
	icon_state = "ricebird"
	faretype = FARE_FINE
	rotprocess = SHELFLIFE_LONG
	eat_effect = /datum/status_effect/buff/foodbuff

/*	.................   Rice & bird & carrots ................... */
/obj/item/reagent_containers/food/snacks/ricebirdcar
	name = "rice and frybird meal"
	tastes = list("rice" = 1, "tasty birdmeat" = 1, "fried cabbage" = 1)
	list_reagents = list(/datum/reagent/consumable/nutriment = MEAL_AVERAGE)
	desc = "Rice mixed with frybird and fried cabbage."
	icon = 'icons/obj/food/cooked/cooked_rice.dmi'
	icon_state = "ricebirdmeal"
	faretype = FARE_LAVISH
	rotprocess = SHELFLIFE_LONG
	eat_effect = /datum/status_effect/buff/foodbuff/tier2

/*	.................   Rice & egg ................... */
/obj/item/reagent_containers/food/snacks/riceegg
	name = "rice and egg"
	tastes = list("rice" = 1, "egg" = 1)
	list_reagents = list(/datum/reagent/consumable/nutriment = MEAL_MEAGRE)
	desc = "Rice mixed with an egg."
	icon = 'icons/obj/food/cooked/cooked_rice.dmi'
	icon_state = "riceegg"
	faretype = FARE_FINE
	rotprocess = SHELFLIFE_LONG
	eat_effect = /datum/status_effect/buff/foodbuff

/*	.................   Rice & cheese ................... */
/obj/item/reagent_containers/food/snacks/ricecheese
	name = "rice and cheese"
	tastes = list("rice" = 1, "cheese" = 1)
	list_reagents = list(/datum/reagent/consumable/nutriment = MEAL_MEAGRE)
	desc = "Rice with a layer of melted cheese."
	icon = 'icons/obj/food/cooked/cooked_rice.dmi'
	icon_state = "ricecheese"
	faretype = FARE_FINE
	rotprocess = SHELFLIFE_LONG
	eat_effect = /datum/status_effect/buff/foodbuff

/*	.................   Rice & egg & cheese ................... */
/obj/item/reagent_containers/food/snacks/riceeggcheese
	name = "rice with egg and cheese"
	tastes = list("rice" = 1, "cheese" = 1, "egg" = 1)
	list_reagents = list(/datum/reagent/consumable/nutriment = MEAL_GOOD)
	desc = "Rice mixed with an egg and layered with melted cheese."
	icon = 'icons/obj/food/cooked/cooked_rice.dmi'
	icon_state = "riceeggcheese"
	faretype = FARE_LAVISH
	rotprocess = SHELFLIFE_LONG
	eat_effect = /datum/status_effect/buff/foodbuff/tier2
