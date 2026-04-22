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
	item_weight = 90 GRAMS

/*	..................   mangosteen   ................... */
/obj/item/reagent_containers/food/snacks/fruit/mangosteen_opened
	name = "mangosteen"
	icon_state = "mangosteen_open"
	trash = /obj/item/trash/mangosteenshell
	bitesize = 5
	dropshrink = 0.8
	item_weight = 75 GRAMS

/*	..................   avocado   ................... */
/obj/item/reagent_containers/food/snacks/fruit/avocado_half
	name = "avocado"
	icon_state = "avocado_half"
	dropshrink = 0.9
	nutrition = FRUIT_NUTRITION/2
	item_weight = 60 GRAMS

/*	..................   dragonfruit   ................... */
/obj/item/reagent_containers/food/snacks/fruit/dragonfruit_half
	name = "piyata"
	icon_state = "dragonfruit_half"
	dropshrink = 0.7
	nutrition = FRUIT_NUTRITION/2
	item_weight = 175 GRAMS

/*	..................   pineapple   ................... */
/obj/item/reagent_containers/food/snacks/fruit/pineapple_slice
	name = "ananas slice"
	icon_state = "pineapple_slice"
	bitesize = 1
	dropshrink = 0.7
	nutrition = FRUIT_NUTRITION/2
	foodtype = FRUIT | PINEAPPLE
	item_weight = 200 GRAMS

/*	..................   Tamto   ................... */
/obj/item/reagent_containers/food/snacks/fruit/tamto_slice
	name = "sliced tamto"
	icon_state = "mato_split"
	bitesize = 1
	dropshrink = 0.7
	nutrition = FRUIT_NUTRITION
	foodtype = FRUIT
	item_weight = 40 GRAMS

/*	..................   Pompkaun   ................... */
/obj/item/reagent_containers/food/snacks/fruit/pompkaun_goo
	name = "pompkaun goo"
	icon_state = "pompkaun_goo"
	bitesize = 1
	dropshrink = 0.7
	nutrition = FRUIT_NUTRITION
	foodtype = FRUIT
	item_weight = 1.2 KILOGRAMS
