/* * * * * * * * * * * **
 *						*
 *		 NeuFood		*
 *		(FRUITS)		*
 *						*
 * * * * * * * * * * * **/

/obj/item/reagent_containers/food/snacks/fruit
	faretype = FARE_NEUTRAL
	bitesize = 2
	list_reagents = list(/datum/reagent/consumable/nutriment = SNACK_DECENT)

/*	..................   mango   ................... */
/obj/item/reagent_containers/food/snacks/fruit/mango_half
	name = "mangga"
	icon_state = "mango_half"
	dropshrink = 0.8

/*	..................   mangosteen   ................... */
/obj/item/reagent_containers/food/snacks/fruit/mangosteen_opened
	name = "mangosteen"
	icon_state = "mangosteen_open"
	trash = /obj/item/trash/mangosteenshell
	bitesize = 5
	dropshrink = 0.8

/*	..................   avocado   ................... */
/obj/item/reagent_containers/food/snacks/fruit/avocado_half
	name = "avocado"
	icon_state = "avocado_half"
	dropshrink = 0.9

/*	..................   dragonfruit   ................... */
/obj/item/reagent_containers/food/snacks/fruit/dragonfruit_half
	name = "piyata"
	icon_state = "dragonfruit_half"
	dropshrink = 0.7

/*	..................   pineapple   ................... */
/obj/item/reagent_containers/food/snacks/fruit/pineapple_slice
	name = "ananas slice"
	icon_state = "pineapple_slice"
	bitesize = 1
	dropshrink = 0.7
