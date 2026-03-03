/* * * * * * * * * * * **
 *						*
 *		 NeuFood		*	- Basically add water to powder, then more powder
 *		 (Snacks)		*
 *						*
 * * * * * * * * * * * **/


/*------\
| Dough |
\------*/

/*	.................   Dough   ................... */
/obj/item/reagent_containers/food/snacks/dough_base
	name = "unfinished dough"
	desc = "With a little more ambition, you will conquer."
	icon_state = "dough_base"
	w_class = WEIGHT_CLASS_NORMAL

	eat_effect = /datum/status_effect/debuff/uncookedfood
	nutrition = FLOUR_NUTRITION
	faretype = FARE_IMPOVERISHED
	rotprocess = SHELFLIFE_DECENT
	foodtype = GRAIN | RAW
	tastes = list("dough" = 1)

/obj/item/reagent_containers/food/snacks/dough
	name = "dough"
	desc = "The triumph of all bakers."
	icon_state = "dough"
	slices_num = 2
	slice_batch = TRUE
	slice_path = /obj/item/reagent_containers/food/snacks/dough_slice
	bitesize = 3
	w_class = WEIGHT_CLASS_NORMAL
	slice_sound = TRUE

	eat_effect = /datum/status_effect/debuff/uncookedfood
	nutrition = DOUGH_NUTRITION
	faretype = FARE_IMPOVERISHED
	rotprocess = SHELFLIFE_DECENT
	foodtype = GRAIN | RAW
	tastes = list("dough" = 1)

/*	.................   Smalldough   ................... */
/obj/item/reagent_containers/food/snacks/dough_slice
	name = "smalldough"
	icon_state = "doughslice"
	w_class = WEIGHT_CLASS_NORMAL
	slices_num = 0

	eat_effect = /datum/status_effect/debuff/uncookedfood
	nutrition = SMALLDOUGH_NUTRITION
	faretype = FARE_IMPOVERISHED
	rotprocess = SHELFLIFE_DECENT
	foodtype = GRAIN | RAW
	tastes = list("dough" = 1)

/obj/item/reagent_containers/food/snacks/dough_slice/attackby(obj/item/I, mob/living/user, list/modifiers)
	. = ..()
	if(.)
		return
	if(user.mind)
		short_cooktime = (50 - ((user.get_skill_level(/datum/skill/craft/cooking, TRUE))*8))
	var/found_table = locate(/obj/structure/table) in (loc)
	if(istype(I, /obj/item/kitchen/rollingpin))
		if(isturf(loc)&& (found_table))
			playsound(user, 'sound/foley/rollingpin.ogg', 100, TRUE, -1)
			to_chat(user, span_notice("Rolling [src] into cracker dough."))
			if(do_after(user,long_cooktime, src))
				new /obj/item/reagent_containers/food/snacks/foodbase/hardtack_raw(loc)
				user.mind.add_sleep_experience(/datum/skill/craft/cooking, (user.STAINT*0.5))
				user.nobles_seen_servant_work()
				qdel(src)
		else
			to_chat(user, span_warning("Put [src] on a table before working it!"))
		return TRUE
	else
		to_chat(user, span_warning("Put [src] on a table before working it!"))


/*------------\
| Butterdough |
\------------*/

/*	.................   Butterdough   ................... */
/obj/item/reagent_containers/food/snacks/butterdough
	name = "butterdough"
	desc = "What is a triumph, to a legacy?"
	icon_state = "butterdough"
	slices_num = 2
	bitesize = 3
	slice_batch = TRUE
	slice_path = /obj/item/reagent_containers/food/snacks/butterdough_slice
	w_class = WEIGHT_CLASS_NORMAL
	slice_sound = TRUE

	eat_effect = /datum/status_effect/debuff/uncookedfood
	nutrition = BUTTERDOUGH_NUTRITION
	faretype = FARE_IMPOVERISHED
	rotprocess = SHELFLIFE_DECENT
	foodtype = GRAIN | RAW | DAIRY
	tastes = list("buttery dough" = 1)


/*	.................   Butterdough piece   ................... */
/obj/item/reagent_containers/food/snacks/butterdough_slice
	name = "butterdough piece"
	desc = "A slice of pedigree, to create lines of history."
	icon_state = "butterdoughslice"
	slices_num = 0
	rotprocess = SHELFLIFE_EXTREME
	w_class = WEIGHT_CLASS_NORMAL

	eat_effect = /datum/status_effect/debuff/uncookedfood
	nutrition = BUTTERDOUGHSLICE_NUTRITION
	faretype = FARE_IMPOVERISHED
	rotprocess = SHELFLIFE_DECENT
	foodtype = GRAIN | RAW | DAIRY
	tastes = list("buttery dough" = 1)

/obj/item/reagent_containers/food/snacks/butterdough_slice/attackby(obj/item/I, mob/living/user, list/modifiers)
	. = ..()
	if(.)
		return
	if(user.mind)
		short_cooktime = (50 - ((user.get_skill_level(/datum/skill/craft/cooking, TRUE))*8))
	var/found_table = locate(/obj/structure/table) in (loc)
	if(isturf(loc)&& (found_table))
		if(istype(I, /obj/item/kitchen/rollingpin))
			playsound(user, 'sound/foley/rollingpin.ogg', 100, TRUE, -1)
			to_chat(user, span_notice("Flattening [src]..."))
			if(do_after(user, short_cooktime, src))
				new /obj/item/reagent_containers/food/snacks/piedough(loc)
				user.mind.add_sleep_experience(/datum/skill/craft/cooking, (user.STAINT*0.5))
				user.nobles_seen_servant_work()
				qdel(src)
		if(I.get_sharpness())
			playsound(user, 'sound/foley/dropsound/food_drop.ogg', 40, TRUE, -1)
			to_chat(user, span_notice("Cutting the dough into strips and making a prezzel..."))
			if(do_after(user, short_cooktime, src))
				if(user.get_skill_level(/datum/skill/craft/cooking) >= 2 || isdwarf(user))
					new /obj/item/reagent_containers/food/snacks/foodbase/prezzel_raw/good(loc)
				else
					new /obj/item/reagent_containers/food/snacks/foodbase/prezzel_raw(loc)
				qdel(src)
				user.mind.add_sleep_experience(/datum/skill/craft/cooking, (user.STAINT*0.5))
				user.nobles_seen_servant_work()
	else
		to_chat(user, span_warning("Put [src] on a table before working it!"))



/*	.................   Hardtack   ................... */
/obj/item/reagent_containers/food/snacks/foodbase/hardtack_raw
	name = "raw hardtack"
	desc = "Doughy, soft, unacceptable."
	icon_state = "raw_tack"
	w_class = WEIGHT_CLASS_NORMAL

	eat_effect = /datum/status_effect/debuff/uncookedfood
	nutrition = SMALLDOUGH_NUTRITION
	faretype = FARE_IMPOVERISHED
	rotprocess = SHELFLIFE_DECENT
	foodtype = GRAIN | RAW
	tastes = list("dough" = 1)

/obj/item/reagent_containers/food/snacks/hardtack
	name = "hardtack"
	desc = "Very, very hard and dry. Keeps well."
	icon_state = "tack"
	base_icon_state = "tack"
	biting = TRUE
	bitesize = 6

	nutrition = (SMALLDOUGH_NUTRITION+1)*COOK_MOD*DRIED_MOD
	faretype = FARE_POOR
	rotprocess = 0
	foodtype = GRAIN
	tastes = list("spelt" = 1)

/*	.................   Piedough   ................... */
/obj/item/reagent_containers/food/snacks/piedough
	name = "piedough"
	desc = "The beginning of greater things to come."
	icon_state = "piedough"
	dropshrink = 0.9
	w_class = WEIGHT_CLASS_NORMAL

	eat_effect = /datum/status_effect/debuff/uncookedfood
	nutrition = BUTTERDOUGHSLICE_NUTRITION
	faretype = FARE_IMPOVERISHED
	rotprocess = SHELFLIFE_DECENT
	foodtype = GRAIN | RAW | DAIRY
	tastes = list("buttery dough" = 1)

/*----------------\
| Sliceable bread |
\----------------*/

/*	.................   Bread   ................... */
/obj/item/reagent_containers/food/snacks/bread
	name = "bread loaf"
	desc = "One of the staple foods of commoners. A simple meal, yet a luxury men will die for."
	icon_state = "loaf"
	base_icon_state = "loaf"
	dropshrink = 0.8
	biting = TRUE
	bitesize = 5
	slices_num = 6
	slice_path = /obj/item/reagent_containers/food/snacks/breadslice
	drop_sound = 'sound/foley/dropsound/gen_drop.ogg'
	w_class = WEIGHT_CLASS_NORMAL
	slice_batch = FALSE
	slice_sound = TRUE
	become_rot_type = /obj/item/reagent_containers/food/snacks/stale_bread

	nutrition = BREAD_NUTRITION
	faretype = FARE_POOR
	rotprocess = SHELFLIFE_LONG
	foodtype = GRAIN
	tastes = list("bread" = 1)

/obj/item/reagent_containers/food/snacks/bread/slice(obj/item/W, mob/user)
	. = ..()
	if(. && !QDELETED(src))
		bitecount++
		update_appearance(UPDATE_ICON_STATE)

/obj/item/reagent_containers/food/snacks/bread/on_consume(mob/living/eater)
	..()
	if(slices_num)
		if(bitecount >= 5)
			changefood(slice_path, eater)
		else
			slices_num--

/*	.................   Breadslice & Toast   ................... */
/obj/item/reagent_containers/food/snacks/breadslice
	name = "sliced bread"
	desc = "A bit of comfort to start your dae."
	icon_state = "loaf_slice"
	dropshrink = 0.8
	become_rot_type = /obj/item/reagent_containers/food/snacks/rotten/breadslice

	nutrition = BREADSLICE_NUTRITION
	faretype = FARE_POOR
	rotprocess = SHELFLIFE_LONG
	foodtype = GRAIN
	tastes = list("bread" = 1)

/obj/item/reagent_containers/food/snacks/breadslice/attackby(obj/item/I, mob/living/user, list/modifiers)
	if(modified || !is_type_in_list(I, list(
		/obj/item/reagent_containers/food/snacks/meat/salami/slice,
		/obj/item/reagent_containers/food/snacks/cheddarslice,
		/obj/item/reagent_containers/food/snacks/cooked/egg,
		/obj/item/reagent_containers/food/snacks/fat/salo/slice,
		/obj/item/reagent_containers/food/snacks/butterslice,
		/obj/item/reagent_containers/food/snacks/meat/mince/beef/mett)))
		return ..()
	var/obj/item/reagent_containers/food/snacks/S = I
	var/cooking = 5 SECONDS - (user.get_skill_level(/datum/skill/craft/cooking, TRUE))*8
	playsound(user, 'sound/foley/dropsound/food_drop.ogg', 50, TRUE, -1)
	if(!do_after(user, cooking, src, display_over_user=TRUE))
		return FALSE
	modified = TRUE
	user.mind.add_sleep_experience(/datum/skill/craft/cooking, (user.STAINT*0.2))
	user.nobles_seen_servant_work()
	S.reagents?.trans_to(src, S.reagents.total_volume)
	LAZYADDASSOC(bonus_reagents, /datum/reagent/consumable/nutriment, S.nutrition)
	tastes |= S.tastes
	foodtype |= S.foodtype
	faretype++

	if(istype(I, /obj/item/reagent_containers/food/snacks/meat/salami/slice))
		name = "[name] & salumoi"
		desc = "[desc] A thick slice of salumoi has been added."
		add_overlay("salumoid")
	else if(istype(I, /obj/item/reagent_containers/food/snacks/cheddarslice))
		name = "[name] & cheese"
		desc = "[desc] Fat cheese slices has been added."
		add_overlay("cheesed")
	else if(istype(I, /obj/item/reagent_containers/food/snacks/cooked/egg))
		name = "[name] & egg"
		add_overlay("egged")
	else if(istype(I, /obj/item/reagent_containers/food/snacks/fat/salo/slice))
		name = "[name] & salo"
		add_overlay("salod")
	else if(istype(I, /obj/item/reagent_containers/food/snacks/butterslice))
		name = "buttered [name]"
		add_overlay("buttered")
	else if(istype(I, /obj/item/reagent_containers/food/snacks/meat/mince/beef/mett))
		name = "[name] & mett"
		add_overlay("metted")
	qdel(I)
	return ..()

/obj/item/reagent_containers/food/snacks/breadslice/toast
	name = "toasted bread"
	icon_state = "toast"
	tastes = list("crispy bread" = 1)

	nutrition = BREADSLICE_NUTRITION * COOK_MOD
	faretype = FARE_NEUTRAL
	tastes = list("bread" = 1)

/obj/item/reagent_containers/food/snacks/stale_bread
	name = "stale bread"
	desc = "Old. Is that mold? Not fit for slicing, just eating in sullen silence."
	icon_state = "loaf"
	color = "#92908a"
	dropshrink = 0.8
	drop_sound = 'sound/foley/dropsound/gen_drop.ogg'
	w_class = WEIGHT_CLASS_NORMAL

	nutrition = BREAD_NUTRITION * 0.5
	faretype = FARE_IMPOVERISHED
	rotprocess = SHELFLIFE_EXTREME
	foodtype = GRAIN
	tastes = list("stale bread" = 1)

/obj/item/reagent_containers/food/snacks/stale_bread/raisin
	icon_state = "raisinbread6"
	tastes = list("stale bread" = 1, "old raisin" = 1)
	faretype = FARE_POOR
	foodtype = GRAIN | FRUIT
	nutrition = BREAD_NUTRITION * 0.5 + RAISIN_NUTRITION

/obj/item/reagent_containers/food/snacks/stale_bread/raisin/poison
	list_reagents = list(/datum/reagent/berrypoison = 5)

/*	.................   Raisin bread   ................... */
/obj/item/reagent_containers/food/snacks/raisindough
	name = "dough of raisins"
	icon_state = "dough_raisin"
	slices_num = 0
	w_class = WEIGHT_CLASS_NORMAL

	eat_effect = /datum/status_effect/debuff/uncookedfood
	nutrition = DOUGH_NUTRITION + RAISIN_NUTRITION
	faretype = FARE_IMPOVERISHED
	rotprocess = SHELFLIFE_DECENT
	foodtype = GRAIN | RAW | FRUIT
	tastes = list("dough" = 1, "dried fruit" = 1)

/obj/item/reagent_containers/food/snacks/bread/raisin
	name = "raisin loaf"
	desc = "Bread with raisins has a sweet taste and is both filling and preserves well."
	icon_state = "raisinbread6"
	base_icon_state = "raisinbread"
	slice_path = /obj/item/reagent_containers/food/snacks/breadslice/raisin

	become_rot_type = /obj/item/reagent_containers/food/snacks/stale_bread/raisin
	nutrition = (DOUGH_NUTRITION + RAISIN_NUTRITION) * COOK_MOD
	faretype = FARE_NEUTRAL
	rotprocess = SHELFLIFE_LONG
	foodtype = GRAIN | FRUIT
	tastes = list("bread" = 1,"dried fruit" = 1)

/obj/item/reagent_containers/food/snacks/bread/raisin/poison
	list_reagents = list(/datum/reagent/berrypoison = 5)

/obj/item/reagent_containers/food/snacks/breadslice/raisin
	name = "raisinbread slice"
	icon_state = "raisinbread_slice"

	nutrition = BREADSLICE_NUTRITION + RAISIN_NUTRITION
	rotprocess = SHELFLIFE_EXTREME
	faretype = FARE_NEUTRAL
	foodtype = GRAIN | FRUIT
	tastes = list("bread" = 1,"dried fruit" = 1)

/obj/item/reagent_containers/food/snacks/breadslice/raisin/poison
	list_reagents = list(/datum/reagent/berrypoison = 5)

/*-----------\
| Bread buns |
\-----------*/

/*	.................   Bread bun   ................... */
/obj/item/reagent_containers/food/snacks/bun
	name = "bun"
	desc = "Portable, quaint and entirely consumable"
	icon_state = "bun"
	base_icon_state = "bun"
	w_class = WEIGHT_CLASS_NORMAL
	biting = TRUE

	nutrition = SMALLDOUGH_NUTRITION * COOK_MOD
	rotprocess = SHELFLIFE_EXTREME
	faretype = FARE_POOR
	foodtype = GRAIN
	tastes = list("bread" = 1)

/obj/item/reagent_containers/food/snacks/grenzelbun
	name = "grenzelbun"
	desc = "The classic wiener in a bun, a staple food of Grenzelhoft cuisine."
	icon_state = "grenzbun"
	base_icon_state = "grenzbun"
	bitesize = 5
	w_class = WEIGHT_CLASS_NORMAL

	nutrition = (RAWMEAT_NUTRITION + SMALLDOUGH_NUTRITION) * COOK_MOD
	rotprocess = SHELFLIFE_EXTREME
	foodtype = GRAIN | MEAT
	faretype = FARE_NEUTRAL
	tastes = list("savory sausage" = 1, "bread" = 1)

/*	.................   Cheese bun   ................... */
/obj/item/reagent_containers/food/snacks/foodbase/cheesebun_raw
	name = "raw cheese bun"
	desc = "Portable, quaint and entirely consumable"
	icon_state = "cheesebun_raw"
	w_class = WEIGHT_CLASS_NORMAL

	eat_effect = /datum/status_effect/debuff/uncookedfood
	nutrition = (SMALLDOUGH_NUTRITION + CHEESE_NUTRITION)
	rotprocess = SHELFLIFE_DECENT
	foodtype = GRAIN | DAIRY | RAW
	faretype = FARE_POOR


/obj/item/reagent_containers/food/snacks/cheesebun
	name = "cheese bun"
	desc = "A treat from the Grenzelhoft kitchen."
	icon_state = "cheesebun"
	base_icon_state = "cheesebun"
	biting = TRUE
	tastes = list("crispy bread and cream cheese" = 1)
	w_class = WEIGHT_CLASS_NORMAL

	nutrition = (SMALLDOUGH_NUTRITION + CHEESE_NUTRITION) * COOK_MOD
	rotprocess = SHELFLIFE_DECENT
	foodtype = GRAIN | DAIRY
	faretype = FARE_FINE

/*---------\
| Pastries |
\---------*/

/obj/item/reagent_containers/food/snacks/frybread
	name = "frybread"
	desc = "Flatbread fried at high heat with butter to give it a crispy outside. Staple of the elven kitchen."
	icon_state = "frybread"
	base_icon_state = "frybread"
	biting = TRUE

	tastes = list("crispy bread with a soft inside" = 1)
	nutrition = BREADSLICE_NUTRITION + BUTTER_NUTRITION
	rotprocess = SHELFLIFE_EXTREME
	foodtype = GRAIN | DAIRY
	faretype = FARE_NEUTRAL

/*	.................   Pastry   ................... */
/obj/item/reagent_containers/food/snacks/pastry
	name = "pastry"
	desc = "Favored among children and sweetlovers."
	icon_state = "pastry"
	base_icon_state = "pastry"
	biting = TRUE

	tastes = list("crispy butterdough" = 1)
	nutrition = BUTTERDOUGHSLICE_NUTRITION * COOK_MOD
	rotprocess = SHELFLIFE_EXTREME
	foodtype = GRAIN | DAIRY
	faretype = FARE_NEUTRAL

/*	.................   Raisin Biscuit   ................... */
/obj/item/reagent_containers/food/snacks/foodbase/biscuit_raw
	name = "uncooked raisin biscuit"
	icon_state = "biscuit_raw"
	rotprocess = SHELFLIFE_DECENT
	nutrition = BUTTERDOUGHSLICE_NUTRITION + RAISIN_NUTRITION
	foodtype = GRAIN | DAIRY | FRUIT | RAW
	faretype = FARE_IMPOVERISHED

/obj/item/reagent_containers/food/snacks/foodbase/biscuit_raw/good

/obj/item/reagent_containers/food/snacks/biscuit
	name = "biscuit"
	desc = "A treat made for a wretched dog like you."
	icon_state = "biscuit"
	base_icon_state = "biscuit"
	biting = TRUE
	tastes = list("crispy butterdough" = 1, "raisins" = 1)
	faretype = FARE_POOR
	foodtype = GRAIN | DAIRY | FRUIT
	nutrition = (BUTTERDOUGHSLICE_NUTRITION + RAISIN_NUTRITION) * COOK_MOD * DRIED_MOD
	rotprocess = SHELFLIFE_EXTREME

/obj/item/reagent_containers/food/snacks/biscuit/good
	eat_effect = /datum/status_effect/buff/foodbuff
	faretype = FARE_FINE

/obj/item/reagent_containers/food/snacks/biscuit/good/Initialize(mapload)
	. = ..()
	good_quality_descriptors()

/obj/item/reagent_containers/food/snacks/biscuit/poison
	list_reagents = list(/datum/reagent/berrypoison = 5)

/*	.................   Prezzel   ................... */
/obj/item/reagent_containers/food/snacks/foodbase/prezzel_raw
	name = "uncooked prezzel"
	icon_state = "prezzel_raw"
	dropshrink = 0.8
	rotprocess = SHELFLIFE_DECENT
	nutrition = BUTTERDOUGHSLICE_NUTRITION
	foodtype = GRAIN | DAIRY | RAW
	faretype = FARE_IMPOVERISHED

/obj/item/reagent_containers/food/snacks/foodbase/prezzel_raw/good

/obj/item/reagent_containers/food/snacks/prezzel
	name = "lacklustre prezzel"
	desc = "The next best thing since sliced bread, originally a dwarven pastry, now seeing mass appeal."
	icon_state = "prezzel"
	base_icon_state = "prezzel"
	dropshrink = 0.8
	biting = TRUE
	rotprocess = SHELFLIFE_LONG
	foodtype = GRAIN | DAIRY
	nutrition = BUTTERDOUGH_NUTRITION * COOK_MOD
	tastes = list("crispy butterdough" = 1)
	faretype = FARE_NEUTRAL

/obj/item/reagent_containers/food/snacks/prezzel/good
	name = "prezzel"
	eat_effect = /datum/status_effect/buff/foodbuff
	faretype = FARE_FINE

/obj/item/reagent_containers/food/snacks/prezzel/good/Initialize(mapload)
	. = ..()
	good_quality_descriptors()

/*	.................   Apple Fritter   ................... */

/obj/item/reagent_containers/food/snacks/foodbase/fritter_raw
	name = "uncooked apple fritter"
	icon_state = "applefritterraw"
	dropshrink = 0.8

	nutrition = BUTTERDOUGHSLICE_NUTRITION + FRUIT_NUTRITION
	foodtype = GRAIN | DAIRY | RAW | FRUIT
	faretype = FARE_IMPOVERISHED

/obj/item/reagent_containers/food/snacks/foodbase/fritter_raw/good

/obj/item/reagent_containers/food/snacks/fritter
	name = "apple fritter"
	desc = "Having deep origins in the culture of Vanderlin, the humble fritter is perhaps the most patriotic pastry out there, long may it reign!"
	icon_state = "applefritter"
	dropshrink = 0.8
	tastes = list("crispy butterdough" = 1, "sweet apple bits" = 1)
	faretype = FARE_FINE
	foodtype = GRAIN | DAIRY | FRUIT | JUNKFOOD
	nutrition = (BUTTERDOUGHSLICE_NUTRITION + FRUIT_NUTRITION) * COOK_MOD

/obj/item/reagent_containers/food/snacks/fritter/good
	name = "apple fritter"
	eat_effect = /datum/status_effect/buff/foodbuff
	faretype = FARE_LAVISH

/obj/item/reagent_containers/food/snacks/fritter/good/Initialize(mapload)
	. = ..()
	good_quality_descriptors()

/*------\
| Cakes |
\------*/

/*	.................   Cake   ................... */
/obj/item/reagent_containers/food/snacks/cake
	name = "cake base"
	desc = "With this sweet thing, you shall make them sing. With jacksberry filling a cheesecake can be made. More exotic cakes require different fruit fillings."
	icon_state = "cake"
	dropshrink = 0.8
	w_class = WEIGHT_CLASS_NORMAL
	eat_effect = /datum/status_effect/debuff/uncookedfood
	rotprocess = SHELFLIFE_LONG
	faretype = FARE_IMPOVERISHED
	foodtype = GRAIN | DAIRY | EGG | RAW
	nutrition = CAKEBASE_NUTRITION

/obj/item/reagent_containers/food/snacks/chescake
	name = "cheesecake base"
	desc = "With this sweet thing, you shall make them sing. Lacking fresh cheese glazing."
	icon_state = "cake_filled"
	dropshrink = 0.8
	w_class = WEIGHT_CLASS_NORMAL
	eat_effect = /datum/status_effect/debuff/uncookedfood
	rotprocess = SHELFLIFE_LONG
	faretype = FARE_IMPOVERISHED
	foodtype = GRAIN | DAIRY | EGG | RAW
	nutrition = CAKEBASE_NUTRITION + RAISIN_NUTRITION

/obj/item/reagent_containers/food/snacks/zybcake
	name = "zaladin cake base"
	desc = "With this sweet thing, you shall make them sing. Lacking spider-honey glazing."
	icon_state = "cake_filled"
	dropshrink = 0.8
	eat_effect = /datum/status_effect/debuff/uncookedfood
	rotprocess = SHELFLIFE_LONG
	faretype = FARE_IMPOVERISHED
	foodtype = GRAIN | DAIRY | FRUIT | RAW | EGG
	nutrition = CAKEBASE_NUTRITION + FRUIT_NUTRITION

// -------------- SPIDER-HONEY CAKE (Zaladin) -----------------
/obj/item/reagent_containers/food/snacks/zybcake_ready
	name = "unbaked zaladin cake"
	icon_state = "honeycakeuncook"
	dropshrink = 0.8
	slices_num = 0
	w_class = WEIGHT_CLASS_NORMAL
	rotprocess = SHELFLIFE_DECENT
	eat_effect = /datum/status_effect/debuff/uncookedfood
	rotprocess = SHELFLIFE_LONG
	faretype = FARE_IMPOVERISHED
	foodtype = GRAIN | DAIRY | FRUIT | RAW | EGG
	nutrition = CAKEBASE_NUTRITION + FRUIT_NUTRITION + HONEY_NUTRITION

/obj/item/reagent_containers/food/snacks/zybcake_cooked
	name = "zalad cake"
	desc = "Cake glazed with honey, in the famous Zaladin fashion, a delicious sweet treat. Said to be very hard to poison, perhaps the honey counteracting such malicious concotions."
	icon_state = "honeycake"
	dropshrink = 0.8
	slices_num = 6
	slice_path = /obj/item/reagent_containers/food/snacks/zybcake_slice
	w_class = WEIGHT_CLASS_NORMAL
	tastes = list("cake"=1, "pear" = 1, "delicious honeyfrosting"=1)
	slice_batch = TRUE
	slice_sound = TRUE
	eat_effect = /datum/status_effect/buff/foodbuff
	faretype = FARE_LAVISH
	rotprocess = SHELFLIFE_LONG
	faretype = FARE_IMPOVERISHED
	foodtype = GRAIN | FRUIT | SUGAR | DAIRY | JUNKFOOD | EGG
	nutrition = (CAKEBASE_NUTRITION + FRUIT_NUTRITION + HONEY_NUTRITION) * COOK_MOD

/obj/item/reagent_containers/food/snacks/zybcake_slice
	name = "zalad cake slice"
	icon_state = "hcake_slice"
	base_icon_state = "hcake_slice"
	dropshrink = 0.8
	slices_num = 0
	bitesize = 2
	biting = TRUE
	w_class = WEIGHT_CLASS_NORMAL
	foodtype = GRAIN | FRUIT | SUGAR | DAIRY | JUNKFOOD | EGG
	tastes = list("cake"=1, "pear" = 1, "delicious honeyfrosting"=1)
	eat_effect = /datum/status_effect/buff/foodbuff
	nutrition = ((CAKEBASE_NUTRITION + FRUIT_NUTRITION + HONEY_NUTRITION) * COOK_MOD) * SLICED_MOD
	rotprocess = SHELFLIFE_DECENT
	faretype = FARE_LAVISH

// -------------- CHEESECAKE -----------------
/obj/item/reagent_containers/food/snacks/chescake_ready
	name = "unbaked cake of cheese"
	icon_state = "cheesecakeuncook"
	dropshrink = 0.8
	slices_num = 0
	w_class = WEIGHT_CLASS_NORMAL
	rotprocess = SHELFLIFE_DECENT
	eat_effect = /datum/status_effect/debuff/uncookedfood
	rotprocess = SHELFLIFE_LONG
	faretype = FARE_IMPOVERISHED
	foodtype = GRAIN | DAIRY | FRUIT | RAW | EGG
	nutrition = CAKEBASE_NUTRITION + RAISIN_NUTRITION + CHEESE_NUTRITION

/obj/item/reagent_containers/food/snacks/chescake_ready/poison
	list_reagents = list(/datum/reagent/berrypoison = 6)

/obj/item/reagent_containers/food/snacks/cheesecake_cooked
	name = "cheesecake"
	desc = "Humenity's favored creation."
	icon_state = "cheesecake"
	dropshrink = 0.8
	slices_num = 6
	slice_path = /obj/item/reagent_containers/food/snacks/cheesecake_slice
	w_class = WEIGHT_CLASS_NORMAL
	tastes = list("cake"=1, "jacksberry" = 1, "creamy cheese"=1)
	slice_batch = TRUE
	slice_sound = TRUE
	eat_effect = /datum/status_effect/buff/foodbuff
	nutrition = (CAKEBASE_NUTRITION + RAISIN_NUTRITION + CHEESE_NUTRITION) * COOK_MOD
	rotprocess = SHELFLIFE_EXTREME
	faretype = FARE_FINE
	foodtype = GRAIN | DAIRY | FRUIT | EGG | JUNKFOOD

/obj/item/reagent_containers/food/snacks/cheesecake_cooked/poison
	list_reagents = list(/datum/reagent/berrypoison = 10)

/obj/item/reagent_containers/food/snacks/cheesecake_slice
	name = "cheesecake slice"
	icon_state = "cheesecake_slice"
	base_icon_state = "cheesecake_slice"
	dropshrink = 0.8
	slices_num = 0
	bitesize = 2
	biting = TRUE
	tastes = list("cake"=1, "jacksberry" = 1, "creamy cheese"=1)
	w_class = WEIGHT_CLASS_NORMAL
	eat_effect = /datum/status_effect/buff/foodbuff
	nutrition = ((CAKEBASE_NUTRITION + RAISIN_NUTRITION + CHEESE_NUTRITION) * COOK_MOD) * SLICED_MOD
	rotprocess = SHELFLIFE_LONG
	faretype = FARE_FINE
	foodtype = GRAIN | DAIRY | FRUIT | EGG | JUNKFOOD

/obj/item/reagent_containers/food/snacks/cheesecake_slice/poison
	list_reagents = list(/datum/reagent/berrypoison = 1.25)

/*	.................   STRAWBERRY CAKE   ................... */

/obj/item/reagent_containers/food/snacks/strawbycake
	name = "strawberry cake base"
	desc = "With this sweet thing, you shall make them sing. Lacking sugar frosting."
	icon_state = "cake_filled"
	dropshrink = 0.8
	w_class = WEIGHT_CLASS_NORMAL
	eat_effect = /datum/status_effect/debuff/uncookedfood
	rotprocess = SHELFLIFE_DECENT
	faretype = FARE_IMPOVERISHED
	foodtype = GRAIN | DAIRY | FRUIT | RAW | EGG
	nutrition = CAKEBASE_NUTRITION + FRUIT_NUTRITION

/obj/item/reagent_containers/food/snacks/strawbycake_ready
	name = "unbaked strawberry cake"
	icon_state = "strawberrycakeuncooked"
	dropshrink = 0.8
	slices_num = 0
	w_class = WEIGHT_CLASS_NORMAL
	eat_effect = /datum/status_effect/debuff/uncookedfood
	rotprocess = SHELFLIFE_DECENT
	faretype = FARE_IMPOVERISHED
	foodtype = GRAIN | DAIRY | FRUIT | RAW | EGG | SUGAR
	nutrition = CAKEBASE_NUTRITION + FRUIT_NUTRITION + SUGAR_NUTRITION

/obj/item/reagent_containers/food/snacks/strawbycake_cooked
	name = "strawberry cake"
	desc = "Traditionally made with sugarbeet frosting, an elvish treat as old as time. Commonly served at elf weddings."
	icon_state = "strawberrycake"
	dropshrink = 0.8
	slices_num = 6
	slice_path = /obj/item/reagent_containers/food/snacks/strawbycake_slice
	w_class = WEIGHT_CLASS_NORMAL
	tastes = list("cake"=1, "strawberry" = 1, "sugar"=1)
	slice_batch = TRUE
	slice_sound = TRUE
	rotprocess = SHELFLIFE_LONG
	eat_effect = /datum/status_effect/buff/foodbuff
	faretype = FARE_LAVISH
	foodtype = GRAIN | DAIRY | FRUIT | EGG | SUGAR | JUNKFOOD
	nutrition = (CAKEBASE_NUTRITION + FRUIT_NUTRITION + SUGAR_NUTRITION) * COOK_MOD

/obj/item/reagent_containers/food/snacks/strawbycake_slice
	name = "strawberry cake slice"
	icon_state = "strawberrycakeslice"
	dropshrink = 0.8
	slices_num = 0
	bitesize = 2
	tastes = list("cake"=1, "strawberry" = 1, "sugar"=1)
	w_class = WEIGHT_CLASS_NORMAL
	rotprocess = SHELFLIFE_DECENT
	eat_effect = /datum/status_effect/buff/foodbuff
	faretype = FARE_FINE
	foodtype = GRAIN | DAIRY | FRUIT | EGG | SUGAR | JUNKFOOD
	nutrition = ((CAKEBASE_NUTRITION + FRUIT_NUTRITION + SUGAR_NUTRITION) * COOK_MOD) * SLICED_MOD

/*	.................   CRIMSON PINE CAKE   ................... */

/obj/item/reagent_containers/food/snacks/crimsoncake
	name = "crimson pine cake base"
	desc = "With this sweet thing, you shall make them sing. Lacking chocolate bits."
	icon_state = "cake_filled"
	dropshrink = 0.8
	w_class = WEIGHT_CLASS_NORMAL
	eat_effect = /datum/status_effect/debuff/uncookedfood
	rotprocess = SHELFLIFE_DECENT
	faretype = FARE_IMPOVERISHED
	foodtype = GRAIN | DAIRY | FRUIT | RAW | EGG
	nutrition = CAKEBASE_NUTRITION + FRUIT_NUTRITION

/obj/item/reagent_containers/food/snacks/crimsoncake_ready
	name = "unbaked crimson pine cake"
	icon_state = "crimsonpinecakeraw"
	slices_num = 0
	w_class = WEIGHT_CLASS_NORMAL
	eat_effect = /datum/status_effect/debuff/uncookedfood
	rotprocess = SHELFLIFE_DECENT
	faretype = FARE_IMPOVERISHED
	foodtype = GRAIN | DAIRY | FRUIT | RAW | EGG | SUGAR
	nutrition = CAKEBASE_NUTRITION + FRUIT_NUTRITION + CHOCCY_NUTRITION

/obj/item/reagent_containers/food/snacks/crimsoncake_cooked
	name = "crimson pine cake"
	desc = "A fusion of Crimson Elf and Grenzelhoftian cuisines, the cake originates from the Valorian Republics. Rumor has it that one of the many casus belli in the Republics was based upon a disagreement on the cakes exact recipe."
	icon_state = "crimsonpinecake"
	slices_num = 6
	slice_path = /obj/item/reagent_containers/food/snacks/crimsoncake_slice
	list_reagents = list(/datum/reagent/consumable/ethanol/plum_wine = (CAKEBASE_NUTRITION + FRUIT_NUTRITION + CHOCCY_NUTRITION) * COOK_MOD)
	tastes = list("cake"=1, "chocolate" = 1, "plum"=1)
	slice_batch = TRUE
	slice_sound = TRUE
	rotprocess = SHELFLIFE_EXTREME
	eat_effect = /datum/status_effect/buff/foodbuff
	faretype = FARE_LAVISH
	foodtype = GRAIN | DAIRY | FRUIT | EGG | SUGAR | JUNKFOOD
	nutrition = (CAKEBASE_NUTRITION + FRUIT_NUTRITION + CHOCCY_NUTRITION) * COOK_MOD

/obj/item/reagent_containers/food/snacks/crimsoncake_slice
	name = "crimson pine cake slice"
	icon_state = "crimsonpinecakeslice"
	dropshrink = 0.8
	slices_num = 0
	bitesize = 2
	tastes = list("cake"=1, "chocolate" = 1, "plum"=1)
	w_class = WEIGHT_CLASS_NORMAL
	rotprocess = SHELFLIFE_DECENT
	eat_effect = /datum/status_effect/buff/foodbuff
	faretype = FARE_LAVISH
	foodtype = GRAIN | DAIRY | FRUIT | EGG | SUGAR | JUNKFOOD
	nutrition = (CAKEBASE_NUTRITION + FRUIT_NUTRITION + CHOCCY_NUTRITION) * COOK_MOD * SLICED_MOD

/*	.................   TANGERINE CAKE   ................... */

/obj/item/reagent_containers/food/snacks/tangerinecake
	name = "scarletharp cake base"
	desc = "With this sweet thing, you shall make them sing. Lacking sugar frosting."
	icon_state = "cake_filled"
	dropshrink = 0.8
	w_class = WEIGHT_CLASS_NORMAL
	eat_effect = /datum/status_effect/debuff/uncookedfood
	rotprocess = SHELFLIFE_DECENT
	faretype = FARE_IMPOVERISHED
	foodtype = GRAIN | DAIRY | FRUIT | RAW | EGG
	nutrition = CAKEBASE_NUTRITION + FRUIT_NUTRITION

/obj/item/reagent_containers/food/snacks/tangerinecake_ready
	name = "unbaked scarletharp cake"
	icon_state = "tangerinecakeraw"
	dropshrink = 0.9
	slices_num = 0
	w_class = WEIGHT_CLASS_NORMAL
	eat_effect = /datum/status_effect/debuff/uncookedfood
	rotprocess = SHELFLIFE_DECENT
	faretype = FARE_IMPOVERISHED
	foodtype = GRAIN | DAIRY | FRUIT | RAW | EGG | SUGAR
	nutrition = CAKEBASE_NUTRITION + FRUIT_NUTRITION + SUGAR_NUTRITION

/obj/item/reagent_containers/food/snacks/tangerinecake_cooked
	name = "scarletharp cake"
	desc = "The Scarletharp cake, named not so aptly for its town of origin, is a twist on the traditional lunch cake substituting the dried fruit bits for a center filling of tangerine jam."
	icon_state = "tangerinecake"
	dropshrink = 0.9
	slices_num = 6
	slice_path = /obj/item/reagent_containers/food/snacks/tangerinecake_slice
	w_class = WEIGHT_CLASS_NORMAL
	tastes = list("cake"=1, "tangerine" = 1, "sugar"=1)
	slice_batch = TRUE
	slice_sound = TRUE
	rotprocess = SHELFLIFE_LONG
	eat_effect = /datum/status_effect/buff/foodbuff
	faretype = FARE_LAVISH
	foodtype = GRAIN | DAIRY | FRUIT | EGG | SUGAR | JUNKFOOD
	nutrition = (CAKEBASE_NUTRITION + FRUIT_NUTRITION + SUGAR_NUTRITION) * COOK_MOD

/obj/item/reagent_containers/food/snacks/tangerinecake_slice
	name = "scarletharp cake slice"
	icon_state = "tangerinecakeslice"
	dropshrink = 0.8
	slices_num = 0
	bitesize = 2
	tastes = list("cake"=1, "tangerine" = 1, "sugar"=1)
	w_class = WEIGHT_CLASS_NORMAL
	rotprocess = SHELFLIFE_DECENT
	eat_effect = /datum/status_effect/buff/foodbuff
	faretype = FARE_FINE
	foodtype = GRAIN | DAIRY | FRUIT | EGG | SUGAR | JUNKFOOD
	nutrition = ((CAKEBASE_NUTRITION + FRUIT_NUTRITION + SUGAR_NUTRITION) * COOK_MOD) * SLICED_MOD

/*-------\
| Scones |
\-------*/

/*	.................   Plain Scone   ................... */

/obj/item/reagent_containers/food/snacks/foodbase/scone_raw
	name = "unbaked scone"
	icon_state = "uncookedsconebase"
	eat_effect = /datum/status_effect/debuff/uncookedfood
	rotprocess = SHELFLIFE_DECENT
	faretype = FARE_IMPOVERISHED
	foodtype = GRAIN | DAIRY | RAW | SUGAR
	nutrition = BUTTERDOUGHSLICE_NUTRITION + SUGAR_NUTRITION

/obj/item/reagent_containers/food/snacks/scone
	name = "plain scone"
	desc = "A delightfully fancy treat adored by the upper echelons of Kingsfield."
	icon_state = "cookedscone"
	tastes = list("crumbly butterdough" = 1, "sweet" = 1)
	rotprocess = SHELFLIFE_LONG
	faretype = FARE_NEUTRAL
	foodtype = GRAIN | DAIRY | SUGAR
	nutrition = (BUTTERDOUGHSLICE_NUTRITION + SUGAR_NUTRITION) * COOK_MOD


/*	.................   Tangerine Scone   ................... */

/obj/item/reagent_containers/food/snacks/foodbase/scone_raw_tangerine
	name = "unbaked tangerine scone"
	icon_state = "uncookedtangerinescone"
	eat_effect = /datum/status_effect/debuff/uncookedfood
	rotprocess = SHELFLIFE_DECENT
	faretype = FARE_IMPOVERISHED
	foodtype = GRAIN | DAIRY | RAW | SUGAR | FRUIT
	nutrition = BUTTERDOUGHSLICE_NUTRITION + SUGAR_NUTRITION + FRUIT_NUTRITION

/obj/item/reagent_containers/food/snacks/scone_tangerine
	name = "tangerine scone"
	desc = "A delightfully fancy treat adored by the upper echelons of Kingsfield, complete with tangerine frosting."
	icon_state = "cookedtangerinescone"
	tastes = list("crumbly butterdough" = 1, "sweet" = 1, "tangerine" = 1)
	eat_effect = /datum/status_effect/buff/foodbuff
	faretype = FARE_FINE
	foodtype = GRAIN | DAIRY | SUGAR | FRUIT
	nutrition = (BUTTERDOUGHSLICE_NUTRITION + SUGAR_NUTRITION + FRUIT_NUTRITION) * COOK_MOD

/*	.................   Plum Scone   ................... */

/obj/item/reagent_containers/food/snacks/foodbase/scone_raw_plum
	name = "unbaked plum scone"
	icon_state = "uncookedplumscone"
	eat_effect = /datum/status_effect/debuff/uncookedfood
	rotprocess = SHELFLIFE_DECENT
	faretype = FARE_IMPOVERISHED
	foodtype = GRAIN | DAIRY | RAW | SUGAR | FRUIT
	nutrition = BUTTERDOUGHSLICE_NUTRITION + SUGAR_NUTRITION + FRUIT_NUTRITION

/obj/item/reagent_containers/food/snacks/scone_plum
	name = "plum scone"
	desc = "A delightfully fancy treat adored by the upper echelons of Kingsfield, complete with plum filling."
	icon_state = "cookedplumscone"
	tastes = list("crumbly butterdough" = 1, "sweet" = 1, "plum" = 1)
	eat_effect = /datum/status_effect/buff/foodbuff
	faretype = FARE_FINE
	foodtype = GRAIN | DAIRY | SUGAR | FRUIT
	nutrition = (BUTTERDOUGHSLICE_NUTRITION + SUGAR_NUTRITION + FRUIT_NUTRITION) * COOK_MOD

/*-------------\
| Griddlecakes |
\-------------*/

/*	.................   Plain Griddlecake   ................... */

/obj/item/reagent_containers/food/snacks/foodbase/griddlecake_raw
	name = "raw griddlecake"
	icon_state = "rawgriddlecake"
	eat_effect = /datum/status_effect/debuff/uncookedfood
	rotprocess = SHELFLIFE_DECENT
	faretype = FARE_IMPOVERISHED
	foodtype = GRAIN | DAIRY | RAW | EGG
	nutrition = BUTTERDOUGHSLICE_NUTRITION + EGG_NUTRITION

/obj/item/reagent_containers/food/snacks/griddlecake
	name = "griddlecake"
	desc = "Enjoyed by mercenaries throughout Psydonia, though despite its prevalence no one quite knows its origin."
	bitesize = 6
	icon_state = "griddlecake"
	tastes = list("fluffy butterdough" = 1)
	rotprocess = SHELFLIFE_LONG
	faretype = FARE_NEUTRAL
	foodtype = GRAIN | DAIRY | EGG
	nutrition = (BUTTERDOUGHSLICE_NUTRITION + EGG_NUTRITION) * COOK_MOD

/*	.................   Lemon Griddlecake   ................... */

/obj/item/reagent_containers/food/snacks/foodbase/lemongriddlecake_raw
	name = "raw lemon griddlecake"
	icon_state = "rawgriddlecakelemon"
	eat_effect = /datum/status_effect/debuff/uncookedfood
	rotprocess = SHELFLIFE_DECENT
	faretype = FARE_IMPOVERISHED
	foodtype = GRAIN | DAIRY | RAW | EGG | FRUIT
	nutrition = BUTTERDOUGHSLICE_NUTRITION + EGG_NUTRITION + FRUIT_NUTRITION

/obj/item/reagent_containers/food/snacks/griddlecake/lemon
	name = "lemon griddlecake"
	desc = "Enjoyed by mercenaries throughout Psydonia, though despite its prevalence no one quite knows its origin."
	bitesize = 6
	icon_state = "griddlecakelemon"
	tastes = list("fluffy butterdough" = 1, "sweet" = 1, "lemon" = 1)
	rotprocess = SHELFLIFE_LONG
	faretype = FARE_FINE
	eat_effect = /datum/status_effect/buff/foodbuff
	foodtype = GRAIN | DAIRY | EGG | FRUIT
	nutrition = (BUTTERDOUGHSLICE_NUTRITION + EGG_NUTRITION + FRUIT_NUTRITION) * COOK_MOD

/*	.................   Apple Griddlecake   ................... */

/obj/item/reagent_containers/food/snacks/foodbase/applegriddlecake_raw
	name = "raw apple griddlecake"
	icon_state = "rawgriddlecakeapple"
	eat_effect = /datum/status_effect/debuff/uncookedfood
	rotprocess = SHELFLIFE_DECENT
	faretype = FARE_IMPOVERISHED
	foodtype = GRAIN | DAIRY | RAW | EGG | FRUIT
	nutrition = BUTTERDOUGHSLICE_NUTRITION + EGG_NUTRITION + FRUIT_NUTRITION

/obj/item/reagent_containers/food/snacks/griddlecake/apple
	name = "apple griddlecake"
	desc = "Enjoyed by mercenaries throughout Psydonia, though despite its prevalence no one quite knows its origin."
	bitesize = 6
	icon_state = "griddlecakeapple"
	tastes = list("fluffy butterdough" = 1, "sweet" = 1, "apple" = 1)
	rotprocess = SHELFLIFE_LONG
	faretype = FARE_FINE
	eat_effect = /datum/status_effect/buff/foodbuff
	foodtype = GRAIN | DAIRY | EGG | FRUIT
	nutrition = (BUTTERDOUGHSLICE_NUTRITION + EGG_NUTRITION + FRUIT_NUTRITION) * COOK_MOD

/*	.................   Berry Griddlecake   ................... */

/obj/item/reagent_containers/food/snacks/foodbase/berrygriddlecake_raw
	name = "raw jacksberry griddlecake"
	icon_state = "rawgriddlecakeberry"
	eat_effect = /datum/status_effect/debuff/uncookedfood
	rotprocess = SHELFLIFE_DECENT
	faretype = FARE_IMPOVERISHED
	foodtype = GRAIN | DAIRY | RAW | EGG | FRUIT
	nutrition = BUTTERDOUGHSLICE_NUTRITION + EGG_NUTRITION + RAISIN_NUTRITION

/obj/item/reagent_containers/food/snacks/griddlecake/berry
	name = "jacksberry griddlecake"
	desc = "Enjoyed by mercenaries throughout Psydonia, though despite its prevalence no one quite knows its origin."
	bitesize = 6
	icon_state = "griddlecakeberry"
	tastes = list("fluffy butterdough" = 1, "sweet" = 1, "berry" = 1)
	rotprocess = SHELFLIFE_LONG
	faretype = FARE_FINE
	eat_effect = /datum/status_effect/buff/foodbuff
	foodtype = GRAIN | DAIRY | EGG | FRUIT
	nutrition = (BUTTERDOUGHSLICE_NUTRITION + EGG_NUTRITION + RAISIN_NUTRITION) * COOK_MOD

/obj/item/reagent_containers/food/snacks/griddlecake/berry/poison
	list_reagents = list(/datum/reagent/berrypoison = 5)

/*	.................   Griddlecake Condiments   ................... */

/obj/item/reagent_containers/food/snacks/griddlecake/attackby(obj/item/I, mob/living/user, list/modifiers)
	if(modified || !is_type_in_list(I, list(
		/obj/item/reagent_containers/food/snacks/butterslice,
		/obj/item/reagent_containers/food/snacks/spiderhoney,
		/obj/item/reagent_containers/food/snacks/chocolate)))
		return ..()
	var/obj/item/reagent_containers/food/snacks/S = I
	var/cooking = 5 SECONDS - (user.get_skill_level(/datum/skill/craft/cooking, TRUE))*8
	playsound(user, 'sound/foley/dropsound/food_drop.ogg', 50, TRUE, -1)
	if(!do_after(user, cooking, src, display_over_user=TRUE))
		return FALSE
	modified = TRUE
	faretype++
	user.mind.add_sleep_experience(/datum/skill/craft/cooking, (user.STAINT*0.2))
	user.nobles_seen_servant_work()
	S.reagents?.trans_to(src, S.reagents.total_volume)
	LAZYADDASSOC(bonus_reagents, /datum/reagent/consumable/nutriment, S.nutrition)
	if(istype(I, /obj/item/reagent_containers/food/snacks/butterslice))
		name = "buttered [name]"
		desc = "[desc] A melting pat of butter has been added."
		add_overlay("griddlebutter")
	else if(istype(I, /obj/item/reagent_containers/food/snacks/spiderhoney))
		name = "honey syruped [name]"
		desc = "[desc] A generous serving of honey has been poured on top."
		add_overlay("griddlehoney")
	else if(istype(I, /obj/item/reagent_containers/food/snacks/chocolate))
		name = "chocolate drizzled [name]"
		desc = "[desc] Luxurious chocolate has been drizzled on top."
		add_overlay("griddlechocolate")
