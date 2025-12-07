/* * * * * * * * * * * **
 *						*
 *		 NeuFood		*
 *		 (Pies)		 	*
 *						*
 * * * * * * * * * * * **/



/*	........   Pie making   ................ */
/obj/item/reagent_containers/food/snacks/foodbase/piebottom
	name = "pie bottom"
	desc = "The foundation of the fantastical."
	icon_state = "piebottom"
	w_class = WEIGHT_CLASS_NORMAL
	eat_effect = /datum/status_effect/debuff/uncookedfood
	dropshrink = 0.9


/obj/item/reagent_containers/food/snacks/raw_pie
	name = "uncooked pie"
	desc = "The foundation of the fantastical."
	icon_state = "pieuncooked"

	var/overlay_state = ""
	var/pie_roof = FALSE

/obj/item/reagent_containers/food/snacks/raw_pie/Initialize()
	. = ..()
	update_appearance(UPDATE_OVERLAYS)

/obj/item/reagent_containers/food/snacks/raw_pie/update_overlays()
	. = ..()
	var/mutable_appearance/MA = mutable_appearance(icon, "[overlay_state]3")
	MA.color = filling_color
	. +=  MA

	. += mutable_appearance(icon, "pieuncooked")
	if(pie_roof)
		. += mutable_appearance(icon, pie_roof)

/obj/item/reagent_containers/food/snacks/raw_pie/fish
	name = "uncooked fish pie"
	icon_state = "fishpie_raw"
	filling_color = "#bb5a93"
	overlay_state = "fill_fish"

/obj/item/reagent_containers/food/snacks/raw_pie/pot_pie
	name = "uncooked pot pie"
	filling_color = "#9d8c3b"
	overlay_state = "fill_pot"

/obj/item/reagent_containers/food/snacks/raw_pie/apple
	name = "uncooked apple pie"
	filling_color = "#eca48c"
	overlay_state = "fill_apple"

/obj/item/reagent_containers/food/snacks/raw_pie/pear
	name = "uncooked pear pie"
	filling_color = "#edd28c"
	overlay_state = "fill_pear"

/obj/item/reagent_containers/food/snacks/raw_pie/berry
	name = "uncooked berry pie"
	filling_color = "#394da5"
	overlay_state = "fill_berry"
/obj/item/reagent_containers/food/snacks/raw_pie/berry/poison

/obj/item/reagent_containers/food/snacks/raw_pie/meat
	name = "uncooked meat pie"
	icon_state = "meatpie_raw"
	filling_color = "#b44f44"
	overlay_state = "fill_meat"

/obj/item/reagent_containers/food/snacks/raw_pie/borowiki
	name = "uncoooked borowiki pie"
	filling_color = "#7c6b75"
	overlay_state = "fill_pot"

/*--------------\
| Pie templates |
\--------------*/

/obj/item/reagent_containers/food/snacks/pie
	name = "pie"
	desc = ""
	color = "#e7e2df"
	dropshrink = 0.8
	var/stunning = FALSE

/obj/item/reagent_containers/food/snacks/pie/cooked
	icon_state = "pie"
	list_reagents = list(/datum/reagent/consumable/nutriment = MEAL_FILLING)
	slice_path = /obj/item/reagent_containers/food/snacks/pieslice
	faretype = FARE_LAVISH //an entire pie! all to yourself!
	portable = FALSE
	slices_num = 5
	slice_batch = TRUE
	eat_effect = null
	foodtype = GRAIN | DAIRY
	chopping_sound = TRUE
	dropshrink = 0.8

/obj/item/reagent_containers/food/snacks/pie/throw_impact(atom/hit_atom, datum/thrownthing/throwingdatum)
	. = ..()
	if(!.) //if we're not being caught
		splat(hit_atom)

/obj/item/reagent_containers/food/snacks/pie/proc/splat(atom/movable/hit_atom)
	if(isliving(loc)) //someone caught us!
		return
	var/turf/T = get_turf(hit_atom)
	new/obj/effect/decal/cleanable/food/pie_smudge(T)
	if(reagents && reagents.total_volume)
		reagents.reaction(hit_atom, TOUCH)
	if(isliving(hit_atom))
		var/mob/living/L = hit_atom
		if(stunning)
			L.Paralyze(20) //splat!
		L.adjust_blurriness(1)
		L.visible_message("<span class='warning'>[L] is hit by [src]!</span>", "<span class='danger'>I'm hit by [src]!</span>")
	qdel(src)

/obj/item/reagent_containers/food/snacks/pie/CheckParts(list/parts_list)
	..()
	for(var/obj/item/reagent_containers/food/snacks/M in parts_list)
		filling_color = M.filling_color
		update_snack_overlays(M)
		color = M.filling_color
		if(M.reagents)
			M.reagents.remove_reagent(/datum/reagent/consumable/nutriment, M.reagents.total_volume)
			M.reagents.trans_to(src, M.reagents.total_volume)
		qdel(M)

/obj/item/reagent_containers/food/snacks/pieslice
	list_reagents = list(/datum/reagent/consumable/nutriment = SNACK_DECENT)
	tastes = list("pie" = 1)
	name = "pie slice"
	desc = ""
	icon_state = "slice"
	dropshrink = 0.9
	filling_color = "#FFFFFF"
	foodtype = GRAIN | DAIRY
	color = "#e7e2df"
	rotprocess = SHELFLIFE_LONG
	faretype = FARE_FINE
	portable = FALSE

// ------ GOOD PIE SLICES -----
/obj/item/reagent_containers/food/snacks/pieslice/good
	eat_effect = /datum/status_effect/buff/foodbuff

/obj/item/reagent_containers/food/snacks/pieslice/good/pot
	filling_color = "#9d8c3b"

/obj/item/reagent_containers/food/snacks/pieslice/good/fish
	filling_color = "#bb5a93"

/obj/item/reagent_containers/food/snacks/pieslice/good/meat
	filling_color = "#b44f44"

/obj/item/reagent_containers/food/snacks/pieslice/good/berry
	filling_color = "#394da5"

/obj/item/reagent_containers/food/snacks/pieslice/good/apple
	filling_color = "#eca48c"

/obj/item/reagent_containers/food/snacks/pieslice/good/pear
	filling_color = "#edd28c"

/obj/item/reagent_containers/food/snacks/pieslice/good/borowiki
	filling_color = "#7c6b75"

// -------------- MEAT PIE -----------------
/obj/item/reagent_containers/food/snacks/pie/cooked/meat // bae item
	name = "meat pie"
	desc = "A pie that is fit for meat lovers. It contains meat, meat, and nothing but meat."
	foodtype = GRAIN | DAIRY | MEAT
	list_reagents = list(/datum/reagent/consumable/nutriment = MEATPIE_NUTRITION)

/obj/item/reagent_containers/food/snacks/pie/cooked/meat/meat
	icon_state = "meatpie"
	tastes = list("meat and butterdough" = 1)
	filling_color = "#b44f44"
/obj/item/reagent_containers/food/snacks/pie/cooked/meat/meat/good
	eat_effect = /datum/status_effect/buff/foodbuff
	slice_path = /obj/item/reagent_containers/food/snacks/pieslice/good/meat
	tastes = list("succulent meat and crispy butterdough" = 1)
/obj/item/reagent_containers/food/snacks/pie/cooked/meat/meat/good/New()
	. = ..()
	good_quality_descriptors()

// -------------- FISH PIE -----------------
/obj/item/reagent_containers/food/snacks/pie/cooked/meat/fish
	name = "fish pie"
	icon_state = "fishpie"
	tastes = list("baked fish and butterdough" = 1)
	filling_color = "#bb5a93"

/obj/item/reagent_containers/food/snacks/pie/cooked/meat/fish/good
	eat_effect = /datum/status_effect/buff/foodbuff
	slice_path = /obj/item/reagent_containers/food/snacks/pieslice/good/fish
	tastes = list("baked fish and crispy butterdough" = 1)
/obj/item/reagent_containers/food/snacks/pie/cooked/meat/fish/good/New()
	. = ..()
	good_quality_descriptors()

// -------------- POT PIE -----------------
/obj/item/reagent_containers/food/snacks/pie/cooked/pot
	name = "pot pie"
	desc = "A pie made with a host of different ingredients. May or may not contain meat."
	slices_num = 6
	list_reagents = list(/datum/reagent/consumable/nutriment = MEATPIE_NUTRITION)
	tastes = list("mysterious filling and butterdough" = 1)
	filling_color = "#9d8c3b"
	foodtype = GRAIN | DAIRY | MEAT

/obj/item/reagent_containers/food/snacks/pie/cooked/pot/good
	eat_effect = /datum/status_effect/buff/foodbuff
	slice_path = /obj/item/reagent_containers/food/snacks/pieslice/good/pot
	tastes = list("succulent filling and crispy butterdough" = 1)
/obj/item/reagent_containers/food/snacks/pie/cooked/meat/pot/good/New()
	. = ..()
	good_quality_descriptors()

// -------------- BERRY PIE -----------------
/obj/item/reagent_containers/food/snacks/pie/cooked/berry
	name = "berry pie"
	desc = "A sweet pie made from jacksberries. A popular choice for banquets among peasants, and enjoyed by all."
	list_reagents = list(/datum/reagent/consumable/nutriment = FRUITPIE_NUTRITION)
	slices_num = 4
	tastes = list("butterdough" = 1, "berries" = 1)
	filling_color = "#394da5"

/obj/item/reagent_containers/food/snacks/pie/cooked/berry/good
	eat_effect = /datum/status_effect/buff/foodbuff
	slice_path = /obj/item/reagent_containers/food/snacks/pieslice/good/berry
	tastes = list("crispy butterdough" = 1, "sweet berries" = 1)
/obj/item/reagent_containers/food/snacks/pie/cooked/berry/good/New()
	. = ..()
	good_quality_descriptors()

// -------------- POISON PIE -----------------
/obj/item/reagent_containers/food/snacks/pie/cooked/poison
	name = "berry pie"
	slices_num = 4
	list_reagents = list(/datum/reagent/consumable/nutriment = FRUITPIE_NUTRITION, /datum/reagent/berrypoison = 12)
	tastes = list("crispy butterdough" = 1, "bitter berries" =1)
	filling_color = "#394da5"

// -------------- APPLE PIE -----------------
/obj/item/reagent_containers/food/snacks/pie/cooked/apple
	name = "apple pie"
	desc = "A sweet pie made from apples. Some claim it to taste even better with cheese."
	slices_num = 4
	list_reagents = list(/datum/reagent/consumable/nutriment = FRUITPIE_NUTRITION)
	tastes = list("apples and butterdough" = 1)
/obj/item/reagent_containers/food/snacks/pie/cooked/apple/good
	eat_effect = /datum/status_effect/buff/foodbuff
	slice_path = /obj/item/reagent_containers/food/snacks/pieslice/good/apple
	tastes = list("baked apples and crispy butterdough" = 1)
/obj/item/reagent_containers/food/snacks/pie/cooked/apple/good/New()
	. = ..()
	good_quality_descriptors()

// -------------- PEAR PIE -----------------
/obj/item/reagent_containers/food/snacks/pie/cooked/pear
	name = "pear pie"
	desc = "A sweet pie made from pears. Not as famous as it's other fruit cousins."
	slices_num = 4
	list_reagents = list(/datum/reagent/consumable/nutriment = FRUITPIE_NUTRITION)
	tastes = list("pears and butterdough" = 1)
/obj/item/reagent_containers/food/snacks/pie/cooked/pear/good
	eat_effect = /datum/status_effect/buff/foodbuff
	slice_path = /obj/item/reagent_containers/food/snacks/pieslice/good/pear
	tastes = list("baked pears and crispy butterdough" = 1)
/obj/item/reagent_containers/food/snacks/pie/cooked/pear/good/New()
	. = ..()
	good_quality_descriptors()

// -------------- BOROWIKI PIE -----------------
/obj/item/reagent_containers/food/snacks/pie/cooked/borowiki
	name = "borowiki pie"
	desc = "A savory pie filled with hearty borowiki mushrooms."
	slices_num = 4
	list_reagents = list(/datum/reagent/consumable/nutriment = MEATPIE_NUTRITION)
	tastes = list("borowiki and butterdough" = 1)

/obj/item/reagent_containers/food/snacks/pie/cooked/borowiki/good
	eat_effect = /datum/status_effect/buff/foodbuff
	slice_path = /obj/item/reagent_containers/food/snacks/pieslice/good/borowiki
	tastes = list("savory borowiki and crispy butterdough" = 1)

/obj/item/reagent_containers/food/snacks/pie/cooked/borowiki/good/New()
	. = ..()
	good_quality_descriptors()

/*--------\
| Handpie |
\--------*/		// dwarven pie on the go, good shelflife until bitten, made from pie dough and mince, truffles or jacksberries

/obj/item/reagent_containers/food/snacks/foodbase/handpieraw
	name = "raw handpie"
	desc = "The dwarven take on pies, called pierogi in their dialect. A fistful of food to stand the test of time."
	icon_state = "handpie_raw"
	cooked_smell = /datum/pollutant/food/pie_base
	list_reagents = list(/datum/reagent/consumable/nutriment = SNACK_DECENT)
	w_class = WEIGHT_CLASS_NORMAL
	dropshrink = 0.8
	transfers_tastes = TRUE

/obj/item/reagent_containers/food/snacks/foodbase/handpieraw/mushroom
	w_class = WEIGHT_CLASS_NORMAL
	foodtype = GRAIN | VEGETABLES
	tastes = list("delicious truffles" = 1)

/obj/item/reagent_containers/food/snacks/foodbase/handpieraw/mince
	w_class = WEIGHT_CLASS_NORMAL
	foodtype = GRAIN | MEAT
	tastes = list("succulent meat" = 1)

/obj/item/reagent_containers/food/snacks/foodbase/handpieraw/cheese
	w_class = WEIGHT_CLASS_NORMAL
	foodtype = GRAIN | DAIRY
	tastes = list("hot cheese" = 1)

/obj/item/reagent_containers/food/snacks/foodbase/handpieraw/apple
	list_reagents = list(/datum/reagent/consumable/nutriment = SNACK_POOR)
	w_class = WEIGHT_CLASS_NORMAL
	foodtype = GRAIN | FRUIT
	tastes = list("sweet apple" = 1)

/obj/item/reagent_containers/food/snacks/foodbase/handpieraw/berry
	list_reagents = list(/datum/reagent/consumable/nutriment = SNACK_POOR)
	w_class = WEIGHT_CLASS_NORMAL
	foodtype = GRAIN | FRUIT
	tastes = list("sweet berry" = 1)

/obj/item/reagent_containers/food/snacks/foodbase/handpieraw/poison
	list_reagents = list(/datum/reagent/berrypoison = 5)
	w_class = WEIGHT_CLASS_NORMAL
	foodtype = GRAIN | FRUIT
	tastes = list("bitter berry" = 1)

/obj/item/reagent_containers/food/snacks/handpie
	name = "handpie"
	desc = "The dwarven take on pies, called pierogi in their dialect. A fistful of food to stand the test of time. This is pretty dry."
	icon_state = "handpie"
	bitesize = 4
	bonus_reagents = list(/datum/reagent/consumable/nutriment = BUTTERDOUGHSLICE_NUTRITION)
	tastes = list("dry dough" = 1)
	dropshrink = 0.8
	faretype = FARE_FINE

/obj/item/reagent_containers/food/snacks/handpie/good
	desc = "The dwarven take on pies, called pierogi in their dialect. A fistful of food to stand the test of time."
	eat_effect = /datum/status_effect/buff/foodbuff
	bitesize = 4
	tastes = list("crispy dough" = 1)
/obj/item/reagent_containers/food/snacks/handpie/good/New()
	. = ..()
	good_quality_descriptors()

/obj/item/reagent_containers/food/snacks/handpie/on_consume(mob/living/eater)
	..()
	icon_state = "handpie[bitecount]"
	if(bitecount == 1)
		rotprocess = SHELFLIFE_DECENT
		addtimer(CALLBACK(src, PROC_REF(begin_rotting)), 20, TIMER_CLIENT_TIME) //

/*--------\
| TARTSS   |
\--------*/
/*	........   Tart making   ................ */

/obj/item/reagent_containers/food/snacks/foodbase/tartcrust
	name = "tart crust"
	desc = "The delicate foundation of a tart."
	icon_state = "tartcrust"
	w_class = WEIGHT_CLASS_NORMAL
	eat_effect = /datum/status_effect/debuff/uncookedfood
	dropshrink = 0.9

/obj/item/reagent_containers/food/snacks/raw_tart
	name = "uncooked tart"
	desc = "A tart ready for the oven."
	icon_state = "tartuncooked"
	var/overlay_state = ""
	var/glaze_state = "tartuncooked_glaze"
	var/glaze_color = "#ffffff"

/obj/item/reagent_containers/food/snacks/raw_tart/Initialize()
	. = ..()
	update_appearance(UPDATE_OVERLAYS)

/obj/item/reagent_containers/food/snacks/raw_tart/update_overlays()
	. = ..()
	if(overlay_state)
		var/mutable_appearance/fill = mutable_appearance(icon, "[overlay_state]3")
		. += fill
	. += mutable_appearance(icon, "tartuncooked")
	if(glaze_state)
		var/mutable_appearance/glaze = mutable_appearance(icon, glaze_state)
		glaze.color = glaze_color
		. += glaze

/obj/item/reagent_containers/food/snacks/raw_tart/avocado
	name = "uncooked avocado tart"
	overlay_state = "fill_tart"
	glaze_color = "#7dbb7d"

/obj/item/reagent_containers/food/snacks/raw_tart/mango
	name = "uncooked mango tart"
	overlay_state = "fill_tart"
	glaze_color = "#f9c23c"

/obj/item/reagent_containers/food/snacks/raw_tart/mangosteen
	name = "uncooked mangosteen tart"
	overlay_state = "fill_tart"
	glaze_color = "#b566c7"

/obj/item/reagent_containers/food/snacks/raw_tart/pineapple
	name = "uncooked ananas tart"
	overlay_state = "fill_tart"
	glaze_color = "#f8dc4b"

/obj/item/reagent_containers/food/snacks/raw_tart/dragonfruit
	name = "uncooked piyata tart"
	overlay_state = "fill_tart"
	glaze_color = "#f0a1c2"

/*	........   Tart Cooked   ................ */
/obj/item/reagent_containers/food/snacks/tart
	name = "tart"
	desc = "A sweet and delicate pastry."

/obj/item/reagent_containers/food/snacks/tart/cooked
	list_reagents = list(/datum/reagent/consumable/nutriment = MEAL_FILLING)
	faretype = FARE_LAVISH
	portable = FALSE
	slices_num = 4
	slice_batch = TRUE
	eat_effect = null
	foodtype = GRAIN | DAIRY
	chopping_sound = TRUE
	dropshrink = 0.9

/obj/item/reagent_containers/food/snacks/tart/cooked/avocado
	name = "avocado tart"
	desc = "A smooth and creamy tart filled with mashed avocado."
	icon_state = "avocadotart"
	list_reagents = list(/datum/reagent/consumable/nutriment = FRUITPIE_NUTRITION)
	tastes = list("avocado and butterdough" = 1)
	slice_path = /obj/item/reagent_containers/food/snacks/tartslice/avocado

/obj/item/reagent_containers/food/snacks/tart/cooked/mango
	name = "mangga tart"
	desc = "A tart filled with the tropical mangga flesh."
	icon_state = "mangotart"
	list_reagents = list(/datum/reagent/consumable/nutriment = FRUITPIE_NUTRITION)
	tastes = list("mango and butterdough" = 1)
	slice_path = /obj/item/reagent_containers/food/snacks/tartslice/mango

/obj/item/reagent_containers/food/snacks/tart/cooked/mangosteen
	name = "mangosteen tart"
	desc = "A tart with the sweet tang of mangosteen."
	icon_state = "mangosteentart"
	list_reagents = list(/datum/reagent/consumable/nutriment = FRUITPIE_NUTRITION)
	tastes = list("mangosteen and butterdough" = 1)
	slice_path = /obj/item/reagent_containers/food/snacks/tartslice/mangosteen

/obj/item/reagent_containers/food/snacks/tart/cooked/pineapple
	name = "ananas tart"
	desc = "A tart bursting with bright, tangy pineapple."
	icon_state = "pineappletart"
	list_reagents = list(/datum/reagent/consumable/nutriment = FRUITPIE_NUTRITION)
	tastes = list("ananas and butterdough" = 1)
	slice_path = /obj/item/reagent_containers/food/snacks/tartslice/pineapple

/obj/item/reagent_containers/food/snacks/tart/cooked/dragonfruit
	name = "piyata tart"
	desc = "A tart topped with mild, refreshing dragonfruit."
	icon_state = "dragonfruittart"
	list_reagents = list(/datum/reagent/consumable/nutriment = FRUITPIE_NUTRITION)
	tastes = list("piyata and butterdough" = 1)
	slice_path = /obj/item/reagent_containers/food/snacks/tartslice/dragonfruit

/obj/item/reagent_containers/food/snacks/tartslice
	name = "tart slice"
	desc = "A small slice of tart."
	icon_state = ""
	list_reagents = list(/datum/reagent/consumable/nutriment = SNACK_DECENT)
	dropshrink = 0.9
	foodtype = GRAIN | DAIRY
	rotprocess = SHELFLIFE_LONG
	faretype = FARE_FINE
	portable = FALSE

/obj/item/reagent_containers/food/snacks/tartslice/avocado
	name = "avocado tart slice"
	icon_state = "avocadotart_slice"
	tastes = list("avocado and butterdough" = 1)

/obj/item/reagent_containers/food/snacks/tartslice/mango
	name = "mangga tart slice"
	icon_state = "mangotart_slice"
	tastes = list("mango and butterdough" = 1)

/obj/item/reagent_containers/food/snacks/tartslice/mangosteen
	name = "mangosteen tart slice"
	icon_state = "mangosteentart_slice"
	tastes = list("mangosteen and butterdough" = 1)

/obj/item/reagent_containers/food/snacks/tartslice/pineapple
	name = "ananas tart slice"
	icon_state = "pineappletart_slice"
	tastes = list("ananas and butterdough" = 1)

/obj/item/reagent_containers/food/snacks/tartslice/dragonfruit
	name = "piyata tart slice"
	icon_state = "dragonfruittart_slice"
	tastes = list("piyata and butterdough" = 1)
