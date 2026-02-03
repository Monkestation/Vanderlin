/* * * * * * * * * * * **
 *						*
 *		 NeuFood		*
 *		(Veggies)		*
 *						*
 * * * * * * * * * * * **/

/obj/item/reagent_containers/food/snacks/veg
	faretype = FARE_POOR

/*	..................   Onion slice   ................... */
/obj/item/reagent_containers/food/snacks/veg/onion_sliced
	name = "sliced onion"
	icon_state = "onion_sliced"
	slices_num = 0

/*	..................   Cabbage   ................... */
/obj/item/reagent_containers/food/snacks/veg/cabbage_sliced
	name = "shredded cabbage"
	icon_state = "cabbage_sliced"

/*	..................   Potato   ................... */
/obj/item/reagent_containers/food/snacks/veg/potato_sliced
	name = "potato cuts"
	icon_state = "potato_sliced"

/*	..................   Turnip   ................... */
/obj/item/reagent_containers/food/snacks/veg/turnip_sliced
	name = "cleaned turnip"
	icon_state = "turnip_sliced"


/*	..................		Roasted seeds		................... */
/obj/item/reagent_containers/food/snacks/roastseeds
	list_reagents = list(/datum/reagent/consumable/nutriment = SNACK_POOR - 1)
	tastes = list("roasted seeds" = 1)
	name = "roasted seeds"
	desc = "Treats for both rats and humens."
	icon_state = "roastseeds"
	dropshrink = 0.8
	color = "#e5b175"
	foodtype = VEGETABLES
	rotprocess = null
	eat_effect = /datum/status_effect/buff/foodbuff
	faretype = FARE_POOR

/*	..................		Salted seeds		................... */
/obj/item/reagent_containers/food/snacks/saltseeds
	list_reagents = list(/datum/reagent/consumable/nutriment = SNACK_POOR)
	tastes = list("salted roasted seeds" = 1)
	name = "salted roasted seeds"
	desc = "Too salty for rats, delectable for humens."
	icon_state = "roastseeds"
	dropshrink = 0.8
	color = "#e5b175"
	foodtype = VEGETABLES
	rotprocess = null
	eat_effect = /datum/status_effect/buff/foodbuff
	faretype = FARE_NEUTRAL
