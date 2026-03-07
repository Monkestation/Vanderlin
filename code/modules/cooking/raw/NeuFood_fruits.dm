/* * * * * * * * * * * **
 *						*
 *		 NeuFood		*
 *		(FRUITS)		*
 *						*
 * * * * * * * * * * * **/

/obj/item/reagent_containers/food/snacks/fruit
	faretype = FARE_NEUTRAL
	bitesize = 2
	nutrition = FRUIT_NUTRITION
	foodtype = FRUIT

/*	..................   mango   ................... */
/obj/item/reagent_containers/food/snacks/fruit/mango_half
	name = "mangga"
	icon_state = "mango_half"
	dropshrink = 0.8
	nutrition = FRUIT_NUTRITION/2

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
	nutrition = FRUIT_NUTRITION/2

/*	..................   dragonfruit   ................... */
/obj/item/reagent_containers/food/snacks/fruit/dragonfruit_half
	name = "piyata"
	icon_state = "dragonfruit_half"
	dropshrink = 0.7
	nutrition = FRUIT_NUTRITION/2

/*	..................   pineapple   ................... */
/obj/item/reagent_containers/food/snacks/fruit/pineapple_slice
	name = "ananas slice"
	icon_state = "pineapple_slice"
	bitesize = 1
	dropshrink = 0.7
	nutrition = FRUIT_NUTRITION/2
	foodtype = FRUIT | PINEAPPLE
