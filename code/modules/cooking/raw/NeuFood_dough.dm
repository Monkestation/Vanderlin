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
	item_weight = 200 GRAMS

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
	item_weight = 300 GRAMS

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
	item_weight = 150 GRAMS

/obj/item/reagent_containers/food/snacks/dough_slice/attackby(obj/item/I, mob/living/user, list/modifiers)
	. = ..()
	if(.)
		return
	if(user.mind)
		short_cooktime = (50 - ((GET_MOB_SKILL_VALUE_OLD(user, /datum/attribute/skill/craft/cooking))*8))
	var/found_table = locate(/obj/structure/table) in (loc)
	if(istype(I, /obj/item/kitchen/rollingpin))
		if(isturf(loc)&& (found_table))
			playsound(user, 'sound/foley/rollingpin.ogg', 100, TRUE, -1)
			to_chat(user, span_notice("Rolling [src] into flatdough."))
			if(do_after(user,long_cooktime, src))
				new /obj/item/reagent_containers/food/snacks/dough_flat(loc)
				user.mind.add_sleep_experience(/datum/attribute/skill/craft/cooking, (GET_MOB_ATTRIBUTE_VALUE(user, STAT_INTELLIGENCE)*0.5))
				user.nobles_seen_servant_work()
				qdel(src)
		else
			to_chat(user, span_warning("Put [src] on a table before working it!"))
		return TRUE
/*	else
		to_chat(user, span_warning("Put [src] on a table before working it!"))*/

/obj/item/reagent_containers/food/snacks/dough_flat
	name = "flatdough"
	icon_state = "dough_flat"
	w_class = WEIGHT_CLASS_NORMAL
	slices_num = 0

	eat_effect = /datum/status_effect/debuff/uncookedfood
	nutrition = SMALLDOUGH_NUTRITION
	faretype = FARE_IMPOVERISHED
	rotprocess = SHELFLIFE_DECENT
	foodtype = GRAIN | RAW
	tastes = list("dough" = 1)
	item_weight = 120 GRAMS

/obj/item/reagent_containers/food/snacks/dough_flat/attackby(obj/item/I, mob/living/user, list/modifiers)
	. = ..()
	if(.)
		return
	if(user.mind)
		short_cooktime = (50 - ((GET_MOB_SKILL_VALUE_OLD(user, /datum/attribute/skill/craft/cooking))*8))
	var/found_table = locate(/obj/structure/table) in (loc)
	if(I.get_sharpness())
		if(isturf(loc)&& (found_table))
			playsound(user, 'sound/foley/rollingpin.ogg', 100, TRUE, -1)
			to_chat(user, span_notice("Scoring lines into [src]..."))
			if(do_after(user,long_cooktime, src))
				new /obj/item/reagent_containers/food/snacks/foodbase/hardtack_raw(loc)
				user.mind.add_sleep_experience(/datum/attribute/skill/craft/cooking/baking, (GET_MOB_ATTRIBUTE_VALUE(user, STAT_INTELLIGENCE)*0.5))
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
	item_weight = 350 GRAMS


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
	item_weight = 175 GRAMS

/obj/item/reagent_containers/food/snacks/butterdough_slice/attackby(obj/item/I, mob/living/user, list/modifiers)
	. = ..()
	if(.)
		return
	if(user.mind)
		short_cooktime = (50 - ((GET_MOB_SKILL_VALUE_OLD(user, /datum/attribute/skill/craft/cooking))*8))
	var/found_table = locate(/obj/structure/table) in (loc)
	if(isturf(loc)&& (found_table))
		if(istype(I, /obj/item/kitchen/rollingpin))
			playsound(user, 'sound/foley/rollingpin.ogg', 100, TRUE, -1)
			to_chat(user, span_notice("Flattening [src]..."))
			if(do_after(user, short_cooktime, src))
				new /obj/item/reagent_containers/food/snacks/piedough(loc)
				user.mind.add_sleep_experience(/datum/attribute/skill/craft/cooking/baking, (GET_MOB_ATTRIBUTE_VALUE(user, STAT_INTELLIGENCE)*0.5))
				user.nobles_seen_servant_work()
				qdel(src)
		if(istype(I, /obj/item/kitchen/spoon))
			playsound(user, 'sound/foley/dropsound/food_drop.ogg', 40, TRUE, -1)
			to_chat(user, span_notice("Pressing a divot into [src]..."))
			if(do_after(user, short_cooktime, src))
				new /obj/item/reagent_containers/food/snacks/foodbase/dottart_base(loc)
				user.mind.add_sleep_experience(/datum/attribute/skill/craft/cooking, (GET_MOB_ATTRIBUTE_VALUE(user, STAT_INTELLIGENCE)*0.5))
				user.nobles_seen_servant_work()
				qdel(src)
		if(I.get_sharpness())
			playsound(user, 'sound/foley/dropsound/food_drop.ogg', 40, TRUE, -1)
			to_chat(user, span_notice("Cutting the dough into strips and making a prezzel..."))
			if(do_after(user, short_cooktime, src))
				if(GET_MOB_SKILL_VALUE_OLD(user, /datum/attribute/skill/craft/cooking) >= 2 || isdwarf(user))
					new /obj/item/reagent_containers/food/snacks/foodbase/prezzel_raw/good(loc)
				else
					new /obj/item/reagent_containers/food/snacks/foodbase/prezzel_raw(loc)
				qdel(src)
				user.mind.add_sleep_experience(/datum/attribute/skill/craft/cooking/baking, (GET_MOB_ATTRIBUTE_VALUE(user, STAT_INTELLIGENCE)*0.5))
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
	item_weight = 100 GRAMS

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
	item_weight = 100 GRAMS

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
	item_weight = 175 GRAMS

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
	item_weight = 500 GRAMS

/obj/item/reagent_containers/food/snacks/bread/slice(obj/item/W, mob/user)
	. = ..()
	if(. && !QDELETED(src))
		bitecount++
		update_appearance(UPDATE_ICON_STATE)

/obj/item/reagent_containers/food/snacks/bread/on_consume(mob/living/eater)
	..()
	if(slices_num)
		if(bitecount >= bitesize)
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
	item_weight = 80 GRAMS

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
	var/cooking = 5 SECONDS - (GET_MOB_SKILL_VALUE_OLD(user, /datum/attribute/skill/craft/cooking))*8
	playsound(user, 'sound/foley/dropsound/food_drop.ogg', 50, TRUE, -1)
	if(!do_after(user, cooking, src, display_over_user=TRUE))
		return FALSE
	modified = TRUE
	user.mind.add_sleep_experience(/datum/attribute/skill/craft/cooking/baking, (GET_MOB_ATTRIBUTE_VALUE(user, STAT_INTELLIGENCE)*0.2))
	user.nobles_seen_servant_work()
	S.reagents?.trans_to(src, S.reagents.total_volume)
	LAZYADDASSOC(bonus_reagents, /datum/reagent/consumable/nutriment, S.nutrition * 0.75)
	LAZYADDASSOC(bonus_reagents, /datum/reagent/consumable/nutriment/vitamin, S.nutrition * 0.25)
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
	item_weight = 80 GRAMS

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
	item_weight = 500 GRAMS

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
	item_weight = 300 GRAMS

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

/*	.................   Bookbread   ................... */

/obj/item/reagent_containers/food/snacks/bread/bookbread
	name = "bookbread"
	desc = "On the days when Noc's reign lengthens to its apex, all proper Ten fearing folk huddle by their warm hearths, exchanging both books and pastries such as this."
	icon_state = "bookbread"
	base_icon_state = "bookbread"
	dropshrink = 0.8
	bitesize = 4
	slices_num = 5
	slice_path = /obj/item/reagent_containers/food/snacks/bookbreadslice
	become_rot_type = null

	nutrition = BOOKBREAD_NUTRITION
	faretype = FARE_NEUTRAL
	rotprocess = null
	foodtype = GRAIN | DAIRY
	tastes = list("chewy butterdough" = 1)
	item_weight = 450 GRAMS

/obj/item/reagent_containers/food/snacks/bookbreadslice
	name = "sliced bookbread"
	desc = "About the same size and taste as an encyclopedia."
	icon_state = "bookbread_slice"
	dropshrink = 0.8

	nutrition = BOOKBREADSLICE_NUTRITION
	faretype = FARE_NEUTRAL
	rotprocess = null
	foodtype = GRAIN | DAIRY
	tastes = list("chewy butterdough" = 1)
	item_weight = 90 GRAMS

/obj/item/reagent_containers/food/snacks/bookbreadslice/attackby(obj/item/I, mob/living/user, list/modifiers)
	if(modified || !is_type_in_list(I, list(
		/obj/item/reagent_containers/food/snacks/butterslice)))
		return ..()
	var/obj/item/reagent_containers/food/snacks/S = I
	short_cooktime = (50 - ((GET_MOB_SKILL_VALUE_OLD(user, /datum/attribute/skill/craft/cooking))*8))
	playsound(user, 'sound/foley/dropsound/food_drop.ogg', 50, TRUE, -1)
	if(!do_after(user, short_cooktime, src, display_over_user=TRUE))
		return FALSE
	modified = TRUE
	user.mind.add_sleep_experience(/datum/attribute/skill/craft/cooking, (GET_MOB_ATTRIBUTE_VALUE(user, STAT_INTELLIGENCE)*0.2))
	user.nobles_seen_servant_work()
	S.reagents?.trans_to(src, S.reagents.total_volume)
	LAZYADDASSOC(bonus_reagents, /datum/reagent/consumable/nutriment, S.nutrition * 0.75)
	LAZYADDASSOC(bonus_reagents, /datum/reagent/consumable/nutriment/vitamin, S.nutrition * 0.25)
	tastes |= S.tastes

	name = "buttered [name]"
	add_overlay("bookbread_buttered")
	qdel(I)
	return ..()

/*	.................   Raspberry Bookbread   ................... */
/obj/item/reagent_containers/food/snacks/raspberrybutterdough
	name = "raspberry butterdough"
	icon_state = "butterdough_raspberry"
	bitesize = 3
	w_class = WEIGHT_CLASS_NORMAL

	eat_effect = /datum/status_effect/debuff/uncookedfood
	nutrition = BUTTERDOUGH_NUTRITION + DRIEDFRUIT_NUTRITION
	faretype = FARE_IMPOVERISHED
	rotprocess = SHELFLIFE_DECENT
	foodtype = GRAIN | RAW | DAIRY | FRUIT
	tastes = list("buttery dough" = 1, "dried raspberries" = 1)

/obj/item/reagent_containers/food/snacks/bread/bookbread/raspberry
	name = "raspberry bookbread"
	desc = "Spending the long cold months in academic rather than intimate pursuit is preferable for most devout Noccians."
	icon_state = "raspberry_bookbread"
	base_icon_state = "raspberry_bookbread"
	slice_path = /obj/item/reagent_containers/food/snacks/bookbreadslice/raspberry

	nutrition = BOOKBREAD_NUTRITION + DRIEDFRUIT_NUTRITION
	faretype = FARE_FINE
	foodtype = GRAIN | DAIRY | FRUIT
	tastes = list("chewy butterdough" = 1, "dried raspberries" = 1)
	item_weight = 380 GRAMS

/obj/item/reagent_containers/food/snacks/bookbreadslice/raspberry
	name = "sliced raspberry bookbread"
	desc = "Has a taste that puts one in the mood for a good romance novel. For obvious reasons, this flavor isnt very popular with mages."
	icon_state = "raspberry_bookbread_slice"

	nutrition = BOOKBREADSLICE_NUTRITION + DRIEDFRUIT_NUTRITION
	faretype = FARE_FINE
	foodtype = GRAIN | DAIRY | FRUIT
	tastes = list("chewy butterdough" = 1, "dried raspberries")

/*	.................   Raisin Bookbread   ................... */
/obj/item/reagent_containers/food/snacks/jacksberrybutterdough
	name = "raisin butterdough"
	icon_state = "butterdough_jacksberry"
	bitesize = 3
	w_class = WEIGHT_CLASS_NORMAL

	eat_effect = /datum/status_effect/debuff/uncookedfood
	nutrition = BUTTERDOUGH_NUTRITION + RAISIN_NUTRITION
	faretype = FARE_IMPOVERISHED
	rotprocess = SHELFLIFE_DECENT
	foodtype = GRAIN | RAW | DAIRY | FRUIT
	tastes = list("buttery dough" = 1, "raisins" = 1)
	item_weight = 380 GRAMS

/obj/item/reagent_containers/food/snacks/bread/bookbread/jacksberry
	name = "raisin bookbread"
	desc = "As Nocsmas gained broader appeal, more and more commonfolk with poor access to books instead chose to simply forego their exchanging, focusing instead on the preparation of food."
	icon_state = "jacksberry_bookbread"
	base_icon_state = "jacksberry_bookbread"
	slice_path = /obj/item/reagent_containers/food/snacks/bookbreadslice/jacksberry

	nutrition = BOOKBREAD_NUTRITION + RAISIN_NUTRITION
	faretype = FARE_FINE
	foodtype = GRAIN | DAIRY | FRUIT
	tastes = list("chewy butterdough" = 1, "raisins" = 1)

/obj/item/reagent_containers/food/snacks/bookbreadslice/jacksberry
	name = "sliced raisin bookbread"
	desc = "Has an earthy taste that reminds the eater of growth cycles and rainfall percentages. Like a delicious almanac."
	icon_state = "jacksberry_bookbread_slice"

	nutrition = BOOKBREADSLICE_NUTRITION + RAISIN_NUTRITION
	faretype = FARE_FINE
	foodtype = GRAIN | DAIRY | FRUIT
	tastes = list("chewy butterdough" = 1, "raisins")

/*	.................   Raisin Bookbread (Poison)  ................... */
/obj/item/reagent_containers/food/snacks/jacksberrybutterdough/poison
	list_reagents = list(/datum/reagent/berrypoison = 5)

/obj/item/reagent_containers/food/snacks/bread/bookbread/jacksberry/poison
	list_reagents = list(/datum/reagent/berrypoison = 5)

/obj/item/reagent_containers/food/snacks/bookbreadslice/jacksberry/poison
	list_reagents = list(/datum/reagent/berrypoison = 5)

/*	.................   Blackberry Bookbread   ................... */
/obj/item/reagent_containers/food/snacks/blackberrybutterdough
	name = "blackberry butterdough"
	icon_state = "butterdough_blackberry"
	bitesize = 3
	w_class = WEIGHT_CLASS_NORMAL

	eat_effect = /datum/status_effect/debuff/uncookedfood
	nutrition = BUTTERDOUGH_NUTRITION + DRIEDFRUIT_NUTRITION
	faretype = FARE_IMPOVERISHED
	rotprocess = SHELFLIFE_DECENT
	foodtype = GRAIN | RAW | DAIRY | FRUIT
	tastes = list("buttery dough" = 1, "dried blackberries" = 1)
	item_weight = 380 GRAMS

/obj/item/reagent_containers/food/snacks/bread/bookbread/blackberry
	name = "blackberry bookbread"
	desc = "Following Zizo's ascension, the great exchanging of books has met steady decline, as neighbor suspects neighbor more and more."
	icon_state = "blackberry_bookbread"
	base_icon_state = "blackberry_bookbread"
	slice_path = /obj/item/reagent_containers/food/snacks/bookbreadslice/blackberry

	nutrition = BOOKBREAD_NUTRITION + DRIEDFRUIT_NUTRITION
	faretype = FARE_FINE
	foodtype = GRAIN | DAIRY | FRUIT
	tastes = list("chewy butterdough" = 1, "dried blackberries" = 1)

/obj/item/reagent_containers/food/snacks/bookbreadslice/blackberry
	name = "sliced blackberry bookbread"
	desc = "It evokes a feeling of oncoming horror and dread, not unlike novels that may foretell a doom similar to what befell this very berry."
	icon_state = "blackberry_bookbread_slice"

	nutrition = BOOKBREADSLICE_NUTRITION + DRIEDFRUIT_NUTRITION
	faretype = FARE_FINE
	foodtype = GRAIN | DAIRY | FRUIT
	tastes = list("chewy butterdough" = 1, "dried blackberries")

/*	.................   Pear Bookbread   ................... */
/obj/item/reagent_containers/food/snacks/pearbutterdough
	name = "pear butterdough"
	icon_state = "butterdough_pear"
	bitesize = 3
	w_class = WEIGHT_CLASS_NORMAL

	eat_effect = /datum/status_effect/debuff/uncookedfood
	nutrition = BUTTERDOUGH_NUTRITION + DRIEDFRUIT_NUTRITION
	faretype = FARE_IMPOVERISHED
	rotprocess = SHELFLIFE_DECENT
	foodtype = GRAIN | RAW | DAIRY | FRUIT
	tastes = list("buttery dough" = 1, "dried pears" = 1)
	item_weight = 380 GRAMS

/obj/item/reagent_containers/food/snacks/bread/bookbread/pear
	name = "pear bookbread"
	desc = "Children on Nocsmas are traditionally granted both book and pastry without expectation of exchange, this variety is prefered by most little ones."
	icon_state = "pear_bookbread"
	base_icon_state = "pear_bookbread"
	slice_path = /obj/item/reagent_containers/food/snacks/bookbreadslice/pear

	nutrition = BOOKBREAD_NUTRITION + DRIEDFRUIT_NUTRITION
	faretype = FARE_FINE
	foodtype = GRAIN | DAIRY | FRUIT
	tastes = list("chewy butterdough" = 1, "dried pears" = 1)

/obj/item/reagent_containers/food/snacks/bookbreadslice/pear
	name = "sliced pear bookbread"
	desc = "Evokes the sweetness of younger, simpler times, and simpler books."
	icon_state = "pear_bookbread_slice"

	nutrition = BOOKBREADSLICE_NUTRITION + DRIEDFRUIT_NUTRITION
	faretype = FARE_FINE
	foodtype = GRAIN | DAIRY | FRUIT
	tastes = list("chewy butterdough" = 1, "dried pears")

/*	.................   Tangerine Bookbread   ................... */
/obj/item/reagent_containers/food/snacks/tangerinebutterdough
	name = "tangerine butterdough"
	icon_state = "butterdough_tangerine"
	bitesize = 3
	w_class = WEIGHT_CLASS_NORMAL

	eat_effect = /datum/status_effect/debuff/uncookedfood
	nutrition = BUTTERDOUGH_NUTRITION + DRIEDFRUIT_NUTRITION
	faretype = FARE_IMPOVERISHED
	rotprocess = SHELFLIFE_DECENT
	foodtype = GRAIN | RAW | DAIRY | FRUIT
	tastes = list("buttery dough" = 1, "dried tangerines" = 1)
	item_weight = 380 GRAMS

/obj/item/reagent_containers/food/snacks/bread/bookbread/tangerine
	name = "tangerine bookbread"
	desc = "Even the coldest, darkest nites end eventually. Better to weather them with friends than to hide away."
	icon_state = "tangerine_bookbread"
	base_icon_state = "tangerine_bookbread"
	slice_path = /obj/item/reagent_containers/food/snacks/bookbreadslice/tangerine

	nutrition = BOOKBREAD_NUTRITION + DRIEDFRUIT_NUTRITION
	faretype = FARE_FINE
	foodtype = GRAIN | DAIRY | FRUIT
	tastes = list("chewy butterdough" = 1, "dried tangerines" = 1)

/obj/item/reagent_containers/food/snacks/bookbreadslice/tangerine
	name = "sliced tangerine bookbread"
	desc = "Fills one with heroic vigor and hopeful enthusiasm, similar to historic-fantasies of old."
	icon_state = "tangerine_bookbread_slice"

	nutrition = BOOKBREADSLICE_NUTRITION + DRIEDFRUIT_NUTRITION
	faretype = FARE_FINE
	foodtype = GRAIN | DAIRY | FRUIT
	tastes = list("chewy butterdough" = 1, "dried tangerines")

/*	.................   Plum Bookbread   ................... */
/obj/item/reagent_containers/food/snacks/plumbutterdough
	name = "plum butterdough"
	icon_state = "butterdough_plum"
	bitesize = 3
	w_class = WEIGHT_CLASS_NORMAL

	eat_effect = /datum/status_effect/debuff/uncookedfood
	nutrition = BUTTERDOUGH_NUTRITION + DRIEDFRUIT_NUTRITION
	faretype = FARE_IMPOVERISHED
	rotprocess = SHELFLIFE_DECENT
	foodtype = GRAIN | RAW | DAIRY | FRUIT
	tastes = list("buttery dough" = 1, "dried plums" = 1)
	item_weight = 380 GRAMS

/obj/item/reagent_containers/food/snacks/bread/bookbread/plum
	name = "plum bookbread"
	desc = "The origin of Nocsmas are shrouded in mystery, perhaps intentionally so, though some theorize it may have had its origins as an originally Psydonian holiday."
	icon_state = "plum_bookbread"
	base_icon_state = "plum_bookbread"
	slice_path = /obj/item/reagent_containers/food/snacks/bookbreadslice/plum

	nutrition = BOOKBREAD_NUTRITION + DRIEDFRUIT_NUTRITION
	faretype = FARE_FINE
	foodtype = GRAIN | DAIRY | FRUIT
	tastes = list("chewy butterdough" = 1, "dried plums" = 1)

/obj/item/reagent_containers/food/snacks/bookbreadslice/plum
	name = "sliced plum bookbread"
	desc = "A subtle flavor, best for enjoying subtler books. Mysteries prefered."
	icon_state = "plum_bookbread_slice"

	nutrition = BOOKBREADSLICE_NUTRITION + DRIEDFRUIT_NUTRITION
	faretype = FARE_FINE
	foodtype = GRAIN | DAIRY | FRUIT
	tastes = list("chewy butterdough" = 1, "dried plums")

/*	.................   Lemon Bookbread   ................... */
/obj/item/reagent_containers/food/snacks/lemonbutterdough
	name = "lemon butterdough"
	icon_state = "butterdough_lemon"
	bitesize = 3
	w_class = WEIGHT_CLASS_NORMAL

	eat_effect = /datum/status_effect/debuff/uncookedfood
	nutrition = BUTTERDOUGH_NUTRITION + DRIEDFRUIT_NUTRITION
	faretype = FARE_IMPOVERISHED
	rotprocess = SHELFLIFE_DECENT
	foodtype = GRAIN | RAW | DAIRY | FRUIT
	tastes = list("buttery dough" = 1, "dried lemons" = 1)
	item_weight = 380 GRAMS

/obj/item/reagent_containers/food/snacks/bread/bookbread/lemon
	name = "lemon bookbread"
	desc = "Though many followers of Z find the holiday laughable, it's undeniably an important respite from the doom and gloom of the darkest month."
	icon_state = "lemon_bookbread"
	base_icon_state = "lemon_bookbread"
	slice_path = /obj/item/reagent_containers/food/snacks/bookbreadslice/lemon

	nutrition = BOOKBREAD_NUTRITION + DRIEDFRUIT_NUTRITION
	faretype = FARE_FINE
	foodtype = GRAIN | DAIRY | FRUIT
	tastes = list("chewy butterdough" = 1, "dried lemons" = 1)

/obj/item/reagent_containers/food/snacks/bookbreadslice/lemon
	name = "sliced lemon bookbread"
	desc = "Sweet but a little sour, like a good Xylixian comedy."
	icon_state = "lemon_bookbread_slice"

	nutrition = BOOKBREADSLICE_NUTRITION + DRIEDFRUIT_NUTRITION
	faretype = FARE_FINE
	foodtype = GRAIN | DAIRY | FRUIT
	tastes = list("chewy butterdough" = 1, "dried lemons")

/*	.................   Chocolate Bookbread   ................... */
/obj/item/reagent_containers/food/snacks/chocolatebutterdough
	name = "chocolate butterdough"
	icon_state = "butterdough_chocolate"
	bitesize = 3
	w_class = WEIGHT_CLASS_NORMAL

	eat_effect = /datum/status_effect/debuff/uncookedfood
	nutrition = BUTTERDOUGH_NUTRITION + CHOCCY_NUTRITION
	faretype = FARE_POOR
	rotprocess = SHELFLIFE_DECENT
	foodtype = GRAIN | RAW | DAIRY | SUGAR
	tastes = list("buttery dough" = 1, "rich chocolate" = 1)
	item_weight = 380 GRAMS

/obj/item/reagent_containers/food/snacks/choccy_chip_dough
	name = "chocolate chip cookie dough"
	icon_state = "butterdough"
	bitesize = 3
	w_class = WEIGHT_CLASS_NORMAL
	slice_path = /obj/item/reagent_containers/food/snacks/choccy_cookie_raw
	slice_batch = TRUE
	slices_num = 4

	eat_effect = /datum/status_effect/debuff/uncookedfood
	nutrition = BUTTERDOUGH_NUTRITION + CHOCCY_NUTRITION
	faretype = FARE_POOR
	rotprocess = SHELFLIFE_DECENT
	foodtype = GRAIN | RAW | DAIRY | SUGAR
	tastes = list("buttery dough" = 1, "rich chocolate" = 1)
	item_weight = 250 GRAMS

/obj/item/reagent_containers/food/snacks/choccy_cookie_raw
	name = "unbaked chocolate chip cookie"
	icon_state = "uncookedcookie"
	slices_num = 0
	w_class = WEIGHT_CLASS_TINY

	eat_effect = /datum/status_effect/debuff/uncookedfood
	nutrition = BUTTERDOUGHSLICE_NUTRITION + CHOCCY_NUTRITION
	faretype = FARE_IMPOVERISHED
	rotprocess = SHELFLIFE_DECENT
	foodtype = GRAIN | RAW | DAIRY | SUGAR
	tastes = list("buttery dough" = 1, "rich chocolate" = 1)
	item_weight = 40 GRAMS

/obj/item/reagent_containers/food/snacks/choccy_cookie
	name = "chocolate chip cookie"
	desc = "Salty cookie and sweet chocolate meet in this treat."
	icon_state = "cookie"

	nutrition = BUTTERDOUGHSLICE_NUTRITION + CHOCCY_NUTRITION
	faretype = FARE_FINE
	foodtype = GRAIN | DAIRY | SUGAR
	tastes = list("chewy butterdough" = 1, "rich chocolate" = 1)
	item_weight = 40 GRAMS

/obj/item/reagent_containers/food/snacks/choco_butterdough_slice
	name = "unbaked chocolate pastry"
	icon_state = "butterdoughslicechoc"
	slices_num = 0
	w_class = WEIGHT_CLASS_NORMAL

	eat_effect = /datum/status_effect/debuff/uncookedfood
	nutrition = BUTTERDOUGHSLICE_NUTRITION + CHOCCY_NUTRITION
	faretype = FARE_IMPOVERISHED
	rotprocess = SHELFLIFE_DECENT
	foodtype = GRAIN | RAW | DAIRY
	tastes = list("buttery dough" = 1, "rich chocolate" = 1)
	item_weight = 120 GRAMS

/obj/item/reagent_containers/food/snacks/choco_bun_raw
	name = "unbaked chocolate bun"
	icon_state = "butterdoughslicechoc"
	slices_num = 0
	w_class = WEIGHT_CLASS_NORMAL

	eat_effect = /datum/status_effect/debuff/uncookedfood
	nutrition = BUTTERDOUGHSLICE_NUTRITION + CHOCCY_NUTRITION
	faretype = FARE_IMPOVERISHED
	rotprocess = SHELFLIFE_DECENT
	foodtype = GRAIN | RAW | DAIRY
	tastes = list("buttery dough" = 1, "rich chocolate" = 1)
	item_weight = 120 GRAMS

/obj/item/reagent_containers/food/snacks/choco_bun
	name = "chocolate bun"
	desc = "A rich chocolate bun, buttery and sweet."
	icon_state = "bunchoc"
	base_icon_state = "bunchoc"
	nutrition = BUTTERDOUGHSLICE_NUTRITION + CHOCCY_NUTRITION
	faretype = FARE_LAVISH
	foodtype = GRAIN | DAIRY | SUGAR
	tastes = list("chewy butterdough" = 1, "rich chocolate" = 1)
	biting = TRUE
	item_weight = 120 GRAMS

/obj/item/reagent_containers/food/snacks/choco_pastry
	name = "chocolate pastry"
	desc = "A flaky pastry filled with rich chocolate."
	icon_state = "pastrychoc"
	base_icon_state = "pastrychoc"
	nutrition = BUTTERDOUGHSLICE_NUTRITION + CHOCCY_NUTRITION
	faretype = FARE_LAVISH
	foodtype = GRAIN | DAIRY | SUGAR
	tastes = list("buttery pastry" = 1, "rich chocolate" = 1)
	biting = TRUE
	item_weight = 120 GRAMS

/obj/item/reagent_containers/food/snacks/bread/bookbread/chocolate
	name = "chocolate bookbread"
	desc = "Nocsmas is not only a holiday for children and commoners, for Noccians are found most concentrated in the upper echelons of society. For these academics, it provies a much needed opportunity to share their secrets."
	icon_state = "chocolate_bookbread"
	base_icon_state = "chocolate_bookbread"
	slice_path = /obj/item/reagent_containers/food/snacks/bookbreadslice/chocolate

	nutrition = BOOKBREAD_NUTRITION + CHOCCY_NUTRITION
	faretype = FARE_LAVISH
	foodtype = GRAIN | DAIRY | SUGAR
	tastes = list("chewy butterdough" = 1, "rich chocolate" = 1)

/obj/item/reagent_containers/food/snacks/bookbreadslice/chocolate
	name = "sliced chocolate bookbread"
	desc = "As thick and bitter as a book of law."
	icon_state = "chocolate_bookbread_slice"

	nutrition = BOOKBREADSLICE_NUTRITION + CHOCCY_NUTRITION
	faretype = FARE_LAVISH
	foodtype = GRAIN | DAIRY | SUGAR
	tastes = list("chewy butterdough" = 1, "rich chocolate")

/*-----------------\
| Sunreed Products |
\-----------------*/

/*	.................   Sunreed Dough   ................... */
/obj/item/reagent_containers/food/snacks/masa_base
	name = "unfinished sunreed dough"
	desc = "Through innovation, folk survive. They always do."
	icon_state = "masa_base"
	w_class = WEIGHT_CLASS_NORMAL

	eat_effect = /datum/status_effect/debuff/uncookedfood
	nutrition = FLOUR_NUTRITION
	faretype = FARE_IMPOVERISHED
	rotprocess = SHELFLIFE_LONG
	foodtype = GRAIN | RAW
	tastes = list("semi-sweet dough" = 1)
	item_weight = 280 GRAMS

/obj/item/reagent_containers/food/snacks/masa
	name = "sunreed dough"
	desc = "Survive long enough, and prosper. Or at least something close."
	icon_state = "masa"
	slices_num = 2
	slice_batch = TRUE
	slice_path = /obj/item/reagent_containers/food/snacks/masa_slice
	bitesize = 3
	w_class = WEIGHT_CLASS_NORMAL
	slice_sound = TRUE

	eat_effect = /datum/status_effect/debuff/uncookedfood
	nutrition = DOUGH_NUTRITION
	faretype = FARE_IMPOVERISHED
	rotprocess = SHELFLIFE_LONG
	foodtype = GRAIN | RAW
	tastes = list("semi-sweet dough" = 1)
	item_weight = 280 GRAMS

/obj/item/reagent_containers/food/snacks/masa_slice
	name = "sunreed dough piece"
	desc = "A fraction of hope for something greater."
	icon_state = "masa_slice"
	w_class = WEIGHT_CLASS_NORMAL
	slices_num = 0

	eat_effect = /datum/status_effect/debuff/uncookedfood
	nutrition = SMALLDOUGH_NUTRITION
	faretype = FARE_IMPOVERISHED
	rotprocess = SHELFLIFE_LONG
	foodtype = GRAIN | RAW
	tastes = list("semi-sweet dough" = 1)
	item_weight = 140 GRAMS

/obj/item/reagent_containers/food/snacks/masa_slice/attackby(obj/item/I, mob/living/user, list/modifiers)
	. = ..()
	if(.)
		return
	if(user.mind)
		short_cooktime = (50 - ((GET_MOB_SKILL_VALUE_OLD(user, /datum/attribute/skill/craft/cooking/baking))*8))
	var/found_table = locate(/obj/structure/table) in (loc)
	if(istype(I, /obj/item/kitchen/rollingpin))
		if(isturf(loc)&& (found_table))
			playsound(user, 'sound/foley/rollingpin.ogg', 100, TRUE, -1)
			to_chat(user, span_notice("Flattening [src]..."))
			if(do_after(user,long_cooktime, src))
				new /obj/item/reagent_containers/food/snacks/masa_flat(loc)
				user.mind.add_sleep_experience(/datum/attribute/skill/craft/cooking/baking, (GET_MOB_ATTRIBUTE_VALUE(user, STAT_INTELLIGENCE)*0.5))
				user.nobles_seen_servant_work()
				qdel(src)
		else
			to_chat(user, span_warning("Put [src] on a table before working it!"))
		return TRUE
	else
		to_chat(user, span_warning("Put [src] on a table before working it!"))

/obj/item/reagent_containers/food/snacks/masa_flat
	name = "sunreed flat-cake"
	desc = "Something to keep our future safe."
	icon_state = "masa_flat"
	dropshrink = 0.9
	w_class = WEIGHT_CLASS_NORMAL

	eat_effect = /datum/status_effect/debuff/uncookedfood
	nutrition = SMALLDOUGH_NUTRITION
	faretype = FARE_IMPOVERISHED
	rotprocess = SHELFLIFE_LONG
	foodtype = GRAIN | RAW
	tastes = list("semi-sweet dough" = 1)
	item_weight = 120 GRAMS

/obj/item/reagent_containers/food/snacks/masa_honey
	name = "honeyed sunreed dough"
	desc = "Sweet dough with sweet honey."
	icon_state = "honey_masa"
	bitesize = 3
	w_class = WEIGHT_CLASS_NORMAL

	eat_effect = /datum/status_effect/debuff/uncookedfood
	nutrition = DOUGH_NUTRITION + HONEY_NUTRITION
	faretype = FARE_IMPOVERISHED
	rotprocess = SHELFLIFE_LONG
	foodtype = GRAIN | RAW | SUGAR
	tastes = list("semi-sweet dough" = 1, "honey" = 1)
	item_weight = 280 GRAMS

/*	.................   Sunreed Dough   ................... */

/obj/item/reagent_containers/food/snacks/sunreed_bread
	name = "sunbread"
	desc = "Preserves very well over long travels."
	icon_state = "maizebread"
	dropshrink = 0.8
	bitesize = 4
	slices_num = 4
	slice_path = /obj/item/reagent_containers/food/snacks/sunreed_bread_slice
	drop_sound = 'sound/foley/dropsound/gen_drop.ogg'
	w_class = WEIGHT_CLASS_NORMAL
	slice_sound = TRUE

	nutrition = BREAD_NUTRITION
	faretype = FARE_POOR
	rotprocess = null
	foodtype = GRAIN
	tastes = list("semi-sweet bread" = 1)
	item_weight = 450 GRAMS

/obj/item/reagent_containers/food/snacks/sunreed_bread_slice
	name = "sunbread cube"
	desc = "Cut into an exact fourth."
	icon_state = "maizebread_slice"
	dropshrink = 0.8
	bitesize = 3
	w_class = WEIGHT_CLASS_NORMAL

	nutrition = BREAD_NUTRITION/4
	faretype = FARE_POOR
	rotprocess = null
	foodtype = GRAIN
	tastes = list("semi-sweet bread" = 1)
	item_weight = 110 GRAMS

/obj/item/reagent_containers/food/snacks/sunreed_bread/honey
	name = "honeyed sunbread"
	desc = "Poor-fare with rich topping."
	icon_state = "honey_maizebread"
	dropshrink = 0.8
	slice_path = /obj/item/reagent_containers/food/snacks/sunreed_bread_slice/honey

	nutrition = BREAD_NUTRITION+HONEY_NUTRITION
	faretype = FARE_NEUTRAL
	foodtype = GRAIN | SUGAR
	tastes = list("semi-sweet bread" = 1, "honey" = 1)

/obj/item/reagent_containers/food/snacks/sunreed_bread_slice/honey
	name = "honeyed sunbread cube"
	icon_state = "honey_maizebread_slice"
	dropshrink = 0.8
	bitesize = 3
	w_class = WEIGHT_CLASS_NORMAL

	nutrition = (BREAD_NUTRITION+HONEY_NUTRITION)/4
	faretype = FARE_NEUTRAL
	foodtype = GRAIN | SUGAR
	tastes = list("semi-sweet bread" = 1, "honey" = 1)

/*	.................   Estrellas   ................... */

/obj/item/reagent_containers/food/snacks/estrella
	name = "estrella"
	desc = "A sunreed pastry moulded into a star shape, delightful to children everywhere."
	icon_state = "estrella"
	dropshrink = 0.8

	nutrition = SMALLDOUGH_NUTRITION * COOK_MOD
	faretype = FARE_POOR
	rotprocess = SHELFLIFE_LONG
	foodtype = GRAIN
	tastes = list("semi-sweet bread" = 1)
	item_weight = 50 GRAMS

/obj/item/reagent_containers/food/snacks/estrella/attackby(obj/item/I, mob/living/user, list/modifiers)
	if(modified || !is_type_in_list(I, list(
		/obj/item/reagent_containers/food/snacks/sugar,
		/obj/item/reagent_containers/food/snacks/chocolate/chunk)))
		return ..()
	var/obj/item/reagent_containers/food/snacks/S = I
	short_cooktime = (50 - ((GET_MOB_SKILL_VALUE_OLD(user, /datum/attribute/skill/craft/cooking))*8))
	playsound(user, 'sound/foley/dropsound/food_drop.ogg', 50, TRUE, -1)
	if(!do_after(user, short_cooktime, src, display_over_user=TRUE))
		return FALSE
	modified = TRUE
	user.mind.add_sleep_experience(/datum/attribute/skill/craft/cooking, (GET_MOB_ATTRIBUTE_VALUE(user, STAT_INTELLIGENCE)*0.2))
	user.nobles_seen_servant_work()
	S.reagents?.trans_to(src, S.reagents.total_volume)
	LAZYADDASSOC(bonus_reagents, /datum/reagent/consumable/nutriment, S.nutrition * 0.75)
	LAZYADDASSOC(bonus_reagents, /datum/reagent/consumable/nutriment/vitamin, S.nutrition * 0.25)
	tastes |= S.tastes
	foodtype |= S.foodtype
	faretype++

	if(istype(I, /obj/item/reagent_containers/food/snacks/sugar))
		name = "sugar powdered [name]"
		desc = "[desc] Its form holds the sugar excellently."
		icon_state = "sugar_estrella"
	else if(istype(I, /obj/item/reagent_containers/food/snacks/chocolate/chunk))
		name = "chocolate dipped [name]"
		desc = "[desc] It's form holds the chocolate drizzle excelently."
		icon_state = "chocolate_estrella"
		faretype++
	qdel(I)
	return ..()

/*	.................   Huskbuns   ................... */

/obj/item/reagent_containers/food/snacks/foodbase/huskbunbase
	name = "sunreed husk"
	desc = "Sunreed dough nested in its former husk, all that's left is to add filling."
	icon_state = "huskbun_husk"
	nutrition = SMALLDOUGH_NUTRITION
	eat_effect = /datum/status_effect/debuff/uncookedfood
	w_class = WEIGHT_CLASS_NORMAL
	faretype = FARE_IMPOVERISHED
	dropshrink = 0.8
	item_weight = 150 GRAMS

/obj/item/reagent_containers/food/snacks/foodbase/huskbunraw
	name = "raw huskbun"
	desc = "The husk helps cook it, and adds to the taste."
	icon_state = "huskbun_raw"
	nutrition = SMALLDOUGH_NUTRITION
	eat_effect = /datum/status_effect/debuff/uncookedfood
	w_class = WEIGHT_CLASS_NORMAL
	faretype = FARE_IMPOVERISHED
	dropshrink = 0.8
	transfers_tastes = TRUE
	item_weight = 150 GRAMS

/obj/item/reagent_containers/food/snacks/foodbase/huskbunraw/meat
	foodtype = GRAIN | MEAT | RAW
	nutrition = SMALLDOUGH_NUTRITION + MINCE_NUTRITION
	tastes = list("crumbly sunreed dough" = 1, "succulant meat" = 1)

/obj/item/reagent_containers/food/snacks/foodbase/huskbunraw/potato
	foodtype = GRAIN | VEGETABLES
	nutrition = SMALLDOUGH_NUTRITION + VEGGIE_NUTRITION
	tastes = list("crumbly sunreed dough" = 1, "warm potato" = 1)

/obj/item/reagent_containers/food/snacks/foodbase/huskbunraw/onion
	foodtype = GRAIN | VEGETABLES
	nutrition = SMALLDOUGH_NUTRITION + VEGGIE_NUTRITION
	tastes = list("crumbly sunreed dough" = 1, "caramalized onion" = 1)

/obj/item/reagent_containers/food/snacks/foodbase/huskbunraw/cheese
	foodtype = GRAIN | DAIRY
	nutrition = SMALLDOUGH_NUTRITION + CHEESE_NUTRITION
	tastes = list("crumbly sunreed dough" = 1, "gooey cheese" = 1)

/obj/item/reagent_containers/food/snacks/huskbun
	name = "huskbun"
	desc = "Sunreed cooked in its own skin, a deliciously ironic fate."
	icon_state = "huskbun"
	bitesize = 4
	nutrition = (SMALLDOUGH_NUTRITION + MINCE_NUTRITION) * COOK_MOD
	tastes = list("crumbly sunreed dough" = 1)
	dropshrink = 0.8
	faretype = FARE_NEUTRAL
	item_weight = 150 GRAMS

/obj/item/reagent_containers/food/snacks/huskbun/attackby(obj/item/I, mob/living/user, list/modifiers)
	if(modified || !is_type_in_list(I, list(
		/obj/item/reagent_containers/food/snacks/cocaumole,
		/obj/item/reagent_containers/food/snacks/drowsbanejam)))
		return ..()
	var/obj/item/reagent_containers/food/snacks/S = I
	short_cooktime = (50 - ((GET_MOB_SKILL_VALUE_OLD(user, /datum/attribute/skill/craft/cooking))*8))
	playsound(user, 'sound/foley/dropsound/food_drop.ogg', 50, TRUE, -1)
	if(!do_after(user, short_cooktime, src, display_over_user=TRUE))
		return FALSE
	modified = TRUE
	user.mind.add_sleep_experience(/datum/attribute/skill/craft/cooking, (GET_MOB_ATTRIBUTE_VALUE(user, STAT_INTELLIGENCE)*0.2))
	user.nobles_seen_servant_work()
	S.reagents?.trans_to(src, S.reagents.total_volume)
	LAZYADDASSOC(bonus_reagents, /datum/reagent/consumable/nutriment, S.nutrition * 0.75)
	LAZYADDASSOC(bonus_reagents, /datum/reagent/consumable/nutriment/vitamin, S.nutrition * 0.25)
	tastes |= S.tastes
	foodtype |= S.foodtype
	faretype++

	if(istype(I, /obj/item/reagent_containers/food/snacks/cocaumole))
		name = "cocaumole smothered [name]"
		desc = "[desc] It has a generous serving of cocaumole on top."
		icon_state = "cocaudo_huskbun"
	else if(istype(I, /obj/item/reagent_containers/food/snacks/drowsbanejam))
		name = "drowsbane smothered [name]"
		desc = "[desc] It's coated in spicy drowsbane."
		icon_state = "drowsbane_huskbun"
	qdel(I)
	return ..()

/*	.................   Saigaitas   ................... */

/obj/item/reagent_containers/food/snacks/foodbase/saigaita
	name = "saigaita"
	desc = "Food-wrap for long travels, perfectly portable."
	icon_state = "lilsaiga_uncooked"
	nutrition = SMALLDOUGH_NUTRITION
	w_class = WEIGHT_CLASS_NORMAL
	faretype = FARE_POOR
	dropshrink = 0.8
	transfers_tastes = TRUE
	item_weight = 120 GRAMS

/obj/item/reagent_containers/food/snacks/foodbase/saigaita/meat
	foodtype = GRAIN | MEAT
	nutrition = SMALLDOUGH_NUTRITION + MINCE_NUTRITION
	tastes = list("semi-sweet bread" = 1, "succulant meat" = 1)

/obj/item/reagent_containers/food/snacks/foodbase/saigaita/potato
	foodtype = GRAIN | VEGETABLES
	nutrition = SMALLDOUGH_NUTRITION + VEGGIE_NUTRITION
	tastes = list("semi-sweet bread" = 1, "warm potato" = 1)

/obj/item/reagent_containers/food/snacks/foodbase/saigaita/onion
	foodtype = GRAIN | VEGETABLES
	nutrition = SMALLDOUGH_NUTRITION + VEGGIE_NUTRITION
	tastes = list("semi-sweet bread" = 1, "caramalized onion" = 1)

/obj/item/reagent_containers/food/snacks/foodbase/saigaita/cheese
	foodtype = GRAIN | DAIRY
	nutrition = SMALLDOUGH_NUTRITION + CHEESE_NUTRITION
	tastes = list("semi-sweet bread" = 1, "gooey cheese" = 1)

/obj/item/reagent_containers/food/snacks/foodbase/saigaita/egg
	foodtype = GRAIN | EGG
	nutrition = SMALLDOUGH_NUTRITION + EGG_NUTRITION
	tastes = list("semi-sweet bread" = 1, "scrambled egg" = 1)

/obj/item/reagent_containers/food/snacks/saigaita_cooked
	name = "grilled saigaita"
	desc = "This saigaita has been heated to perfection."
	icon_state = "lilsaiga"
	bitesize = 4
	nutrition = (SMALLDOUGH_NUTRITION + MINCE_NUTRITION) * COOK_MOD
	tastes = list("semi-sweet bread" = 1)
	dropshrink = 0.8
	faretype = FARE_NEUTRAL
	item_weight = 120 GRAMS

/obj/item/reagent_containers/food/snacks/saigaita_cooked/attackby(obj/item/I, mob/living/user, list/modifiers)
	if(modified || !is_type_in_list(I, list(
		/obj/item/reagent_containers/food/snacks/cocaumole,
		/obj/item/reagent_containers/food/snacks/drowsbanejam)))
		return ..()
	var/obj/item/reagent_containers/food/snacks/S = I
	short_cooktime = (50 - ((GET_MOB_SKILL_VALUE_OLD(user, /datum/attribute/skill/craft/cooking))*8))
	playsound(user, 'sound/foley/dropsound/food_drop.ogg', 50, TRUE, -1)
	if(!do_after(user, short_cooktime, src, display_over_user=TRUE))
		return FALSE
	modified = TRUE
	user.mind.add_sleep_experience(/datum/attribute/skill/craft/cooking, (GET_MOB_ATTRIBUTE_VALUE(user, STAT_INTELLIGENCE)*0.2))
	user.nobles_seen_servant_work()
	S.reagents?.trans_to(src, S.reagents.total_volume)
	LAZYADDASSOC(bonus_reagents, /datum/reagent/consumable/nutriment, S.nutrition * 0.75)
	LAZYADDASSOC(bonus_reagents, /datum/reagent/consumable/nutriment/vitamin, S.nutrition * 0.25)
	tastes |= S.tastes
	foodtype |= S.foodtype
	faretype++

	if(istype(I, /obj/item/reagent_containers/food/snacks/cocaumole))
		name = "cocaumole smothered [name]"
		desc = "[desc] It even has a generous serving of cocaumole on top."
		icon_state = "cocaudo_lilsaiga"
	else if(istype(I, /obj/item/reagent_containers/food/snacks/drowsbanejam))
		name = "drowsbane smothered [name]"
		desc = "[desc] It's even coated in spicy drowsbane."
		icon_state = "drowsbane_lilsaiga"
	qdel(I)
	return ..()

/*	.................   Eighthscake   ................... */

/obj/item/reagent_containers/food/snacks/eighthscake_unbaked
	name = "eighthscake base"
	desc = "Life is all about its small joys."
	icon_state = "eighthscake_uncooked"
	dropshrink = 0.8
	w_class = WEIGHT_CLASS_NORMAL
	eat_effect = /datum/status_effect/debuff/uncookedfood
	rotprocess = SHELFLIFE_LONG
	faretype = FARE_IMPOVERISHED
	foodtype = GRAIN | EGG | RAW
	nutrition = CAKEBASE_NUTRITION
	item_weight = 400 GRAMS

/obj/item/reagent_containers/food/snacks/eighthscake_unbaked/lemon
	name = "unbaked lemon eighthscake"
	icon_state = "lemon_eighthscake_uncooked"
	eat_effect = /datum/status_effect/debuff/uncookedfood
	foodtype = GRAIN | FRUIT | RAW | EGG
	nutrition = CAKEBASE_NUTRITION + FRUIT_NUTRITION

/obj/item/reagent_containers/food/snacks/eighthscake_unbaked/lime
	name = "unbaked lime eighthscake"
	icon_state = "lime_eighthscake_uncooked"
	eat_effect = /datum/status_effect/debuff/uncookedfood
	foodtype = GRAIN | FRUIT | RAW | EGG
	nutrition = CAKEBASE_NUTRITION + FRUIT_NUTRITION

/obj/item/reagent_containers/food/snacks/eighthscake
	name = "eighthscake"
	desc = "Moulded to count out eight exactly rationed slices, because even the desperate want desert."
	icon_state = "eighthscake"
	dropshrink = 0.8
	slices_num = 8
	slice_path = /obj/item/reagent_containers/food/snacks/eighthscake_slice
	w_class = WEIGHT_CLASS_NORMAL
	tastes = list("sweet sunreed dough" = 1)
	slice_batch = TRUE
	slice_sound = TRUE
	eat_effect = /datum/status_effect/buff/foodbuff
	rotprocess = SHELFLIFE_EXTREME
	faretype = FARE_NEUTRAL
	foodtype = GRAIN | JUNKFOOD | EGG
	nutrition = (CAKEBASE_NUTRITION) * COOK_MOD
	item_weight = 400 GRAMS

/obj/item/reagent_containers/food/snacks/eighthscake/lemon
	name = "lemon eighthscake"
	desc = "Moulded to count out eight exactly rationed slices, because even the desperate want desert. This one has splendid little bits of lemon and glaze."
	icon_state = "lemon_eighthscake"
	slice_path = /obj/item/reagent_containers/food/snacks/eighthscake_slice/lemon
	tastes = list("sweet sunreed dough" = 1, "lemon glaze" = 1)
	faretype = FARE_FINE
	foodtype = GRAIN | JUNKFOOD | EGG | FRUIT
	nutrition = (CAKEBASE_NUTRITION + FRUIT_NUTRITION) * COOK_MOD

/obj/item/reagent_containers/food/snacks/eighthscake/lime
	name = "lime eighthscake"
	desc = "Moulded to count out eight exactly rationed slices, because even the desperate want desert. This one has splendid little bits of lime and glaze."
	icon_state = "lemon_eighthscake"
	slice_path = /obj/item/reagent_containers/food/snacks/eighthscake_slice/lime
	tastes = list("sweet sunreed dough" = 1, "lime glaze" = 1)
	faretype = FARE_FINE
	foodtype = GRAIN | JUNKFOOD | EGG | FRUIT
	nutrition = (CAKEBASE_NUTRITION + FRUIT_NUTRITION) * COOK_MOD

/obj/item/reagent_containers/food/snacks/eighthscake_slice
	name = "eighthscake slice"
	desc = "A perfectly rationed eighth of an eighthscake."
	icon_state = "eighthscake_slice"
	dropshrink = 0.8
	w_class = WEIGHT_CLASS_SMALL
	tastes = list("sweet sunreed dough" = 1)
	eat_effect = /datum/status_effect/buff/foodbuff
	rotprocess = SHELFLIFE_EXTREME
	faretype = FARE_NEUTRAL
	foodtype = GRAIN | JUNKFOOD | EGG
	nutrition = ((CAKEBASE_NUTRITION) * COOK_MOD)/8
	item_weight = 50 GRAMS

/obj/item/reagent_containers/food/snacks/eighthscake_slice/lemon
	name = "lemon eighthscake slice"
	desc = "A perfectly rationed eighth of an eighthscake. This one has splendid little bits of lemon and glaze."
	icon_state = "lemon_eighthscake_slice"
	tastes = list("sweet sunreed dough" = 1, "lemon glaze" = 1)
	faretype = FARE_FINE
	foodtype = GRAIN | JUNKFOOD | EGG | FRUIT
	nutrition = ((CAKEBASE_NUTRITION + FRUIT_NUTRITION) * COOK_MOD)/8

/obj/item/reagent_containers/food/snacks/eighthscake_slice/lime
	name = "lime eighthscake slice"
	desc = "A perfectly rationed eighth of an eighthscake. This one has splendid little bits of lime and glaze."
	icon_state = "lemon_eighthscake_slice"
	tastes = list("sweet sunreed dough" = 1, "lime glaze" = 1)
	faretype = FARE_FINE
	foodtype = GRAIN | JUNKFOOD | EGG | FRUIT
	nutrition = ((CAKEBASE_NUTRITION + FRUIT_NUTRITION) * COOK_MOD)/8

/*	.................   Platos   ................... */

/obj/item/reagent_containers/food/snacks/tostada
	name = "sunreed plato"
	desc = "Fried sunreed which makes a delicious plate."
	icon_state = "tostada"
	bitesize = 5
	nutrition = SMALLDOUGH_NUTRITION * COOK_MOD
	tastes = list("crunchy sunreed dough" = 1)
	dropshrink = 0.8
	faretype = FARE_POOR
	item_weight = 100 GRAMS

/obj/item/reagent_containers/food/snacks/tostada/attackby(obj/item/I, mob/living/user, list/modifiers)
	. = ..()
	if(.)
		return
	if(user.mind)
		short_cooktime = (50 - ((GET_MOB_SKILL_VALUE_OLD(user, /datum/attribute/skill/craft/cooking))*8))
	var/found_table = locate(/obj/structure/table) in (loc)
	if(isturf(loc)&& (found_table))
		if(istype(I, /obj/item/kitchen/rollingpin))
			playsound(user, 'sound/foley/dropsound/food_drop.ogg', 100, TRUE, -1)
			to_chat(user, span_notice("Breaking up [src]..."))
			if(do_after(user, short_cooktime, src))
				new /obj/item/reagent_containers/food/snacks/chippile(loc)
				user.mind.add_sleep_experience(/datum/attribute/skill/craft/cooking, (GET_MOB_ATTRIBUTE_VALUE(user, STAT_INTELLIGENCE)*0.5))
				user.nobles_seen_servant_work()
				qdel(src)
	else
		to_chat(user, span_warning("Put [src] on a table before working it!"))

/obj/item/reagent_containers/food/snacks/tostada_meat
	name = "steak plato"
	desc = "Succulent frysteak on an edible plate."
	icon_state = "tostada_steak"
	bitesize = 5
	nutrition = (SMALLDOUGH_NUTRITION + RAWMEAT_NUTRITION) * COOK_MOD
	tastes = list("crunchy sunreed dough" = 1, "warm steak" = 1)
	dropshrink = 0.8
	faretype = FARE_NEUTRAL
	item_weight = 100 GRAMS

/obj/item/reagent_containers/food/snacks/tostada_meat/attackby(obj/item/I, mob/living/user, list/modifiers)
	if(modified || !is_type_in_list(I, list(
		/obj/item/reagent_containers/food/snacks/cocaumole,
		/obj/item/reagent_containers/food/snacks/drowsbanejam,
		/obj/item/reagent_containers/food/snacks/cheddarslice)))
		return ..()
	var/obj/item/reagent_containers/food/snacks/S = I
	short_cooktime = (50 - ((GET_MOB_SKILL_VALUE_OLD(user, /datum/attribute/skill/craft/cooking))*8))
	playsound(user, 'sound/foley/dropsound/food_drop.ogg', 50, TRUE, -1)
	if(!do_after(user, short_cooktime, src, display_over_user=TRUE))
		return FALSE
	modified = TRUE
	user.mind.add_sleep_experience(/datum/attribute/skill/craft/cooking, (GET_MOB_ATTRIBUTE_VALUE(user, STAT_INTELLIGENCE)*0.2))
	user.nobles_seen_servant_work()
	S.reagents?.trans_to(src, S.reagents.total_volume)
	LAZYADDASSOC(bonus_reagents, /datum/reagent/consumable/nutriment, S.nutrition * 0.75)
	LAZYADDASSOC(bonus_reagents, /datum/reagent/consumable/nutriment/vitamin, S.nutrition * 0.25)
	tastes |= S.tastes
	foodtype |= S.foodtype
	faretype++

	if(istype(I, /obj/item/reagent_containers/food/snacks/cocaumole))
		name = "cocaumole smothered [name]"
		desc = "[desc] It has cocaumole dripping over it."
		add_overlay("tostada_cocaumole")
	else if(istype(I, /obj/item/reagent_containers/food/snacks/drowsbanejam))
		name = "drowsbane smothered [name]"
		desc = "[desc] It's smothered in spicy drowsbane."
		add_overlay("tostada_salsa")
	else if(istype(I, /obj/item/reagent_containers/food/snacks/cheddarslice))
		name = "cheese covered [name]"
		desc = "[desc] A thick slice of cheese has been put ontop."
		add_overlay("tostada_cheese")
	qdel(I)
	return ..()

/obj/item/reagent_containers/food/snacks/tostada_meat/chicken
	name = "frybird plato"
	desc = "Fried bird on an edible plate."
	icon_state = "tostada_steak"
	nutrition = (SMALLDOUGH_NUTRITION + RAWMEAT_NUTRITION) * COOK_MOD
	tastes = list("crunchy sunreed dough" = 1, "frybird" = 1)

/obj/item/reagent_containers/food/snacks/tostada_meat/fish
	name = "fish plato"
	desc = "Crispy fish on an edible plate."
	icon_state = "tostada_fish"
	nutrition = (SMALLDOUGH_NUTRITION + RAWMEAT_NUTRITION) * COOK_MOD
	tastes = list("crunchy sunreed dough" = 1, "crispy fish" = 1)

/obj/item/reagent_containers/food/snacks/tostada_meat/egg
	name = "egg plato"
	desc = "Sunny-side egg on an edible plate."
	icon_state = "tostada_egg"
	nutrition = (SMALLDOUGH_NUTRITION + EGG_NUTRITION) * COOK_MOD
	tastes = list("crunchy sunreed dough" = 1, "fried egg" = 1)

/*	.................   Sun Crackers   ................... */

/obj/item/reagent_containers/food/snacks/chippile
	name = "sun-crackers"
	desc = "A pile of crunchy sun-crackers."
	icon_state = "chippile"
	bitesize = 4
	nutrition = SMALLDOUGH_NUTRITION * COOK_MOD
	tastes = list("crunchy sunreed dough" = 1)
	dropshrink = 0.8
	faretype = FARE_POOR
	var/amount = 5
	var/stacktype = /obj/item/reagent_containers/food/snacks/chip
	item_weight = 150 GRAMS

/obj/item/reagent_containers/food/snacks/chippile/attack_hand_secondary(mob/user, list/modifiers) //Plundered bundle code shhhh
	. = ..()
	if(. == SECONDARY_ATTACK_CANCEL_ATTACK_CHAIN)
		return
	. = SECONDARY_ATTACK_CANCEL_ATTACK_CHAIN
	if(amount <= 0)
		qdel(src)
		return
	var/mob/living/carbon/human/H = user
	switch(amount)
		if(2)
			if(!user.temporarilyRemoveItemFromInventory(src))
				return
			var/obj/F = new stacktype(get_turf(src))
			var/obj/F2 = new stacktype(get_turf(src))
			H.put_in_hands(F)
			H.put_in_hands(F2)
			qdel(src)
			return
		if(1)
			if(!user.temporarilyRemoveItemFromInventory(src))
				return
			var/obj/F = new stacktype(get_turf(src))
			H.put_in_hands(F)
			qdel(src)
			return
		else
			amount -= 1
			var/obj/F = new stacktype(get_turf(src))
			H.put_in_hands(F)
			to_chat(user, span_notice("You remove a chip from the pile."))
			bitecount++

/obj/item/reagent_containers/food/snacks/chippile/on_consume(mob/living/eater)
	..()
	if(amount)
		if(bitecount >= bitesize)
			changefood(stacktype, eater)
		else
			amount--

/obj/item/reagent_containers/food/snacks/chippile/cocaumole
	name = "cocaumole smothered sun-crackers"
	desc = "A pile of crunchy sun-crackers, smothered in savory cocaumole."
	icon_state = "chippile_cocaumole"
	nutrition = (SMALLDOUGH_NUTRITION + COOKED_VEGGIE_NUTRITION) * COOK_MOD
	tastes = list("crunchy sunreed dough" = 1, "savory goo" = 1)
	faretype = FARE_NEUTRAL
	stacktype = /obj/item/reagent_containers/food/snacks/chip_cocaumole

/obj/item/reagent_containers/food/snacks/chippile/drowsbane
	name = "drowsbane smothered sun-crackers"
	desc = "A pile of crunchy sun-crackers, smothered in spicy drowsbane."
	icon_state = "chippile_salsa"
	nutrition = (SMALLDOUGH_NUTRITION + COOKED_VEGGIE_NUTRITION) * COOK_MOD
	tastes = list("crunchy sunreed dough" = 1, "infernal spice" = 1)
	faretype = FARE_NEUTRAL
	stacktype = /obj/item/reagent_containers/food/snacks/chip_drowsbane
	list_reagents = list(/datum/reagent/drowsbane = 10)

/obj/item/reagent_containers/food/snacks/chip
	name = "sun-crackers"
	desc = "A single sun-cracker. Great for dipping."
	icon_state = "chip"
	bitesize = 1
	nutrition = (SMALLDOUGH_NUTRITION * COOK_MOD)/5
	tastes = list("crunchy sunreed dough" = 1)
	dropshrink = 0.8
	faretype = FARE_POOR
	item_weight = 30 GRAMS

/obj/item/reagent_containers/food/snacks/chip_cocaumole
	name = "cocaumole dipped sun-cracker"
	desc = "A single sun-cracker. Dipped in savory cocaumole."
	icon_state = "chip_cocaumole"
	bitesize = 1
	nutrition = ((SMALLDOUGH_NUTRITION + COOKED_VEGGIE_NUTRITION)* COOK_MOD)/5
	tastes = list("crunchy sunreed dough" = 1, "savory goo" = 1)
	dropshrink = 0.8
	faretype = FARE_NEUTRAL
	item_weight = 30 GRAMS

/obj/item/reagent_containers/food/snacks/chip_drowsbane
	name = "drowsbane dipped sun-cracker"
	desc = "A single sun-cracker. Dipped in spicy drowsbane."
	icon_state = "chip_salsa"
	bitesize = 1
	nutrition = ((SMALLDOUGH_NUTRITION + COOKED_VEGGIE_NUTRITION)* COOK_MOD)/5
	tastes = list("crunchy sunreed dough" = 1, "infernal spice" = 1)
	dropshrink = 0.8
	faretype = FARE_NEUTRAL
	list_reagents = list(/datum/reagent/drowsbane = 2)
	item_weight = 30 GRAMS

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
	item_weight = 100 GRAMS

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
	item_weight = 180 GRAMS

/obj/item/reagent_containers/food/snacks/grenzelbun_cocaumole
	name = "grenzelbun with cocaumole"
	desc = "A staple of Grenzelhoft cuisine, altered by Tiefling wanderers."
	icon_state = "grenzbun_cocaumole"
	bitesize = 5
	w_class = WEIGHT_CLASS_NORMAL

	nutrition = (RAWMEAT_NUTRITION + SMALLDOUGH_NUTRITION + VEGGIE_NUTRITION) * COOK_MOD
	rotprocess = SHELFLIFE_EXTREME
	foodtype = GRAIN | MEAT | VEGETABLES
	faretype = FARE_FINE
	tastes = list("savory sausage" = 1, "bread" = 1, "savory goo" = 1)
	item_weight = 180 GRAMS

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
	item_weight = 130 GRAMS


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
	item_weight = 130 GRAMS

/*	.................   Xylix Bun   ................... */
/obj/item/reagent_containers/food/snacks/foodbase/xylixbun_raw
	name = "mysterious dough"
	desc = "This dough seems entirely inconspicous, sure to bake into a regular bun."
	icon_state = "xylixdough"
	w_class = WEIGHT_CLASS_NORMAL

	eat_effect = /datum/status_effect/debuff/uncookedfood
	nutrition = (SMALLDOUGH_NUTRITION + VEGGIE_NUTRITION)
	rotprocess = SHELFLIFE_DECENT
	foodtype = GRAIN | DAIRY | RAW
	faretype = FARE_IMPOVERISHED
	list_reagents = list(/datum/reagent/drowsbane = 5)
	item_weight = 120 GRAMS


/obj/item/reagent_containers/food/snacks/xylixbun
	name = "xylixbun"
	desc = "A very smug looking bun throwing up a holy gesture. Surely nothing bad could come of eating this?"
	icon_state = "xylixbun"
	tastes = list("horribly spicy bread" = 1)
	w_class = WEIGHT_CLASS_NORMAL

	nutrition = (SMALLDOUGH_NUTRITION + VEGGIE_NUTRITION) * COOK_MOD
	rotprocess = SHELFLIFE_DECENT
	foodtype = GRAIN | DAIRY
	faretype = FARE_POOR
	list_reagents = list(/datum/reagent/drowsbane = 20) //Sublethal levels.
	item_weight = 120 GRAMS

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
	item_weight = 100 GRAMS

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
	item_weight = 80 GRAMS

/*	.................   Raisin Biscuit   ................... */
/obj/item/reagent_containers/food/snacks/foodbase/biscuit_raw
	name = "uncooked raisin biscuit"
	icon_state = "biscuit_raw"
	rotprocess = SHELFLIFE_DECENT
	nutrition = BUTTERDOUGHSLICE_NUTRITION + RAISIN_NUTRITION
	foodtype = GRAIN | DAIRY | FRUIT | RAW
	faretype = FARE_IMPOVERISHED
	item_weight = 60 GRAMS

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
	item_weight = 60 GRAMS

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
	item_weight = 80 GRAMS

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
	item_weight = 100 GRAMS

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
	item_weight = 100 GRAMS

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
	item_weight = 400 GRAMS

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
	item_weight = 400 GRAMS

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
	item_weight = 400 GRAMS

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
	item_weight = 400 GRAMS

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
	item_weight = 600 GRAMS

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
	item_weight = 100 GRAMS

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
	item_weight = 400 GRAMS

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
	item_weight = 600 GRAMS

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
	item_weight = 100 GRAMS

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
	item_weight = 400 GRAMS

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
	item_weight = 600 GRAMS

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
	item_weight = 600 GRAMS

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
	item_weight = 100 GRAMS

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
	item_weight = 400 GRAMS

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
	item_weight = 600 GRAMS

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
	item_weight = 600 GRAMS

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
	item_weight = 100 GRAMS

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
	item_weight = 400 GRAMS

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
	item_weight = 600 GRAMS

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
	item_weight = 600 GRAMS

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
	item_weight = 100 GRAMS

/*	.................   TAMTO SILK CAKE   ................... */

/obj/item/reagent_containers/food/snacks/tamtocake
	name = "tamto silk cake base"
	desc = "With this sweet thing, you shall make them sing. Lacking fresh cheese glazing."
	icon_state = "cake_filled"
	dropshrink = 0.8
	w_class = WEIGHT_CLASS_NORMAL
	eat_effect = /datum/status_effect/debuff/uncookedfood
	rotprocess = SHELFLIFE_DECENT
	faretype = FARE_IMPOVERISHED
	foodtype = GRAIN | DAIRY | FRUIT | RAW | EGG
	nutrition = CAKEBASE_NUTRITION + FRUIT_NUTRITION
	item_weight = 400 GRAMS

/obj/item/reagent_containers/food/snacks/tamtocake_ready
	name = "unbaked tamto silk cake"
	icon_state = "tomatosilk_raw"
	dropshrink = 0.9
	slices_num = 0
	w_class = WEIGHT_CLASS_NORMAL
	eat_effect = /datum/status_effect/debuff/uncookedfood
	rotprocess = SHELFLIFE_DECENT
	faretype = FARE_IMPOVERISHED
	foodtype = GRAIN | DAIRY | FRUIT | RAW | EGG
	nutrition = CAKEBASE_NUTRITION + FRUIT_NUTRITION + CHEESE_NUTRITION
	item_weight = 600 GRAMS

/obj/item/reagent_containers/food/snacks/tamtocake_cooked
	name = "tamto silk cake"
	desc = "A silky smooth cake with delectably sweet tamto filling, originating from the bogs of Daftmarsh."
	icon_state = "tomatosilk"
	dropshrink = 0.9
	slices_num = 6
	slice_path = /obj/item/reagent_containers/food/snacks/tamtocake_slice
	w_class = WEIGHT_CLASS_NORMAL
	tastes = list("cake"=1, "sweet tamto" = 1, "creamy cheese"=1)
	slice_batch = TRUE
	slice_sound = TRUE
	rotprocess = SHELFLIFE_LONG
	eat_effect = /datum/status_effect/buff/foodbuff
	faretype = FARE_LAVISH
	foodtype = GRAIN | DAIRY | FRUIT | EGG | JUNKFOOD
	nutrition = (CAKEBASE_NUTRITION + FRUIT_NUTRITION + CHEESE_NUTRITION) * COOK_MOD
	item_weight = 600 GRAMS

/obj/item/reagent_containers/food/snacks/tamtocake_slice
	name = "tamto silk cake slice"
	icon_state = "tomatosilk_slice"
	dropshrink = 0.8
	slices_num = 0
	bitesize = 2
	tastes = list("cake"=1, "sweet tamto" = 1, "creamy cheese"=1)
	w_class = WEIGHT_CLASS_NORMAL
	rotprocess = SHELFLIFE_DECENT
	eat_effect = /datum/status_effect/buff/foodbuff
	faretype = FARE_FINE
	foodtype = GRAIN | DAIRY | FRUIT | EGG | JUNKFOOD
	nutrition = ((CAKEBASE_NUTRITION + FRUIT_NUTRITION + CHEESE_NUTRITION) * COOK_MOD) * SLICED_MOD
	item_weight = 100 GRAMS

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
	item_weight = 70 GRAMS

/obj/item/reagent_containers/food/snacks/scone
	name = "plain scone"
	desc = "A delightfully fancy treat adored by the upper echelons of Kingsfield."
	icon_state = "cookedscone"
	tastes = list("crumbly butterdough" = 1, "sweet" = 1)
	rotprocess = SHELFLIFE_LONG
	faretype = FARE_NEUTRAL
	foodtype = GRAIN | DAIRY | SUGAR
	nutrition = (BUTTERDOUGHSLICE_NUTRITION + SUGAR_NUTRITION) * COOK_MOD
	item_weight = 70 GRAMS


/*	.................   Tangerine Scone   ................... */

/obj/item/reagent_containers/food/snacks/foodbase/scone_raw_tangerine
	name = "unbaked tangerine scone"
	icon_state = "uncookedtangerinescone"
	eat_effect = /datum/status_effect/debuff/uncookedfood
	rotprocess = SHELFLIFE_DECENT
	faretype = FARE_IMPOVERISHED
	foodtype = GRAIN | DAIRY | RAW | SUGAR | FRUIT
	nutrition = BUTTERDOUGHSLICE_NUTRITION + SUGAR_NUTRITION + FRUIT_NUTRITION
	item_weight = 70 GRAMS

/obj/item/reagent_containers/food/snacks/scone_tangerine
	name = "tangerine scone"
	desc = "A delightfully fancy treat adored by the upper echelons of Kingsfield, complete with tangerine frosting."
	icon_state = "cookedtangerinescone"
	tastes = list("crumbly butterdough" = 1, "sweet" = 1, "tangerine" = 1)
	eat_effect = /datum/status_effect/buff/foodbuff
	faretype = FARE_FINE
	foodtype = GRAIN | DAIRY | SUGAR | FRUIT
	nutrition = (BUTTERDOUGHSLICE_NUTRITION + SUGAR_NUTRITION + FRUIT_NUTRITION) * COOK_MOD
	item_weight = 70 GRAMS

/*	.................   Plum Scone   ................... */

/obj/item/reagent_containers/food/snacks/foodbase/scone_raw_plum
	name = "unbaked plum scone"
	icon_state = "uncookedplumscone"
	eat_effect = /datum/status_effect/debuff/uncookedfood
	rotprocess = SHELFLIFE_DECENT
	faretype = FARE_IMPOVERISHED
	foodtype = GRAIN | DAIRY | RAW | SUGAR | FRUIT
	nutrition = BUTTERDOUGHSLICE_NUTRITION + SUGAR_NUTRITION + FRUIT_NUTRITION
	item_weight = 70 GRAMS

/obj/item/reagent_containers/food/snacks/scone_plum
	name = "plum scone"
	desc = "A delightfully fancy treat adored by the upper echelons of Kingsfield, complete with plum filling."
	icon_state = "cookedplumscone"
	tastes = list("crumbly butterdough" = 1, "sweet" = 1, "plum" = 1)
	eat_effect = /datum/status_effect/buff/foodbuff
	faretype = FARE_FINE
	foodtype = GRAIN | DAIRY | SUGAR | FRUIT
	nutrition = (BUTTERDOUGHSLICE_NUTRITION + SUGAR_NUTRITION + FRUIT_NUTRITION) * COOK_MOD
	item_weight = 70 GRAMS

/*	.................   Chocolate Scone   ................... */

/obj/item/reagent_containers/food/snacks/foodbase/scone_raw_choco
	name = "unbaked chocolate scone"
	icon_state = "uncookedchocscone"
	eat_effect = /datum/status_effect/debuff/uncookedfood
	rotprocess = SHELFLIFE_DECENT
	faretype = FARE_IMPOVERISHED
	foodtype = GRAIN | DAIRY | RAW | SUGAR
	nutrition = BUTTERDOUGHSLICE_NUTRITION + SUGAR_NUTRITION + CHOCCY_NUTRITION
	item_weight = 70 GRAMS

/obj/item/reagent_containers/food/snacks/scone_choco
	name = "chocolate scone"
	desc = "A luxurious treat made with exotic chocolate."
	icon_state = "cookedsconechoc"
	tastes = list("crumbly butterdough" = 1, "sweet" = 1, "rich chocolate" = 1)
	eat_effect = /datum/status_effect/buff/foodbuff
	faretype = FARE_FINE
	foodtype = GRAIN | DAIRY | SUGAR
	nutrition = (BUTTERDOUGHSLICE_NUTRITION + SUGAR_NUTRITION + CHOCCY_NUTRITION) * COOK_MOD
	item_weight = 70 GRAMS

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
	item_weight = 120 GRAMS

/obj/item/reagent_containers/food/snacks/griddlecake
	name = "griddlecake"
	desc = "Enjoyed by mercenaries throughout Psydonia, though despite their prevalence no one quite knows the origin."
	bitesize = 6
	icon_state = "griddlecake"
	tastes = list("fluffy butterdough" = 1)
	rotprocess = SHELFLIFE_LONG
	faretype = FARE_NEUTRAL
	foodtype = GRAIN | DAIRY | EGG
	nutrition = (BUTTERDOUGHSLICE_NUTRITION + EGG_NUTRITION) * COOK_MOD
	item_weight = 120 GRAMS

/*	.................   Lemon Griddlecake   ................... */

/obj/item/reagent_containers/food/snacks/foodbase/lemongriddlecake_raw
	name = "raw lemon griddlecake"
	icon_state = "rawgriddlecakelemon"
	eat_effect = /datum/status_effect/debuff/uncookedfood
	rotprocess = SHELFLIFE_DECENT
	faretype = FARE_IMPOVERISHED
	foodtype = GRAIN | DAIRY | RAW | EGG | FRUIT
	nutrition = BUTTERDOUGHSLICE_NUTRITION + EGG_NUTRITION + FRUIT_NUTRITION
	item_weight = 120 GRAMS

/obj/item/reagent_containers/food/snacks/griddlecake/lemon
	name = "lemon griddlecake"
	desc = "Enjoyed by mercenaries throughout Psydonia, though despite their prevalence no one quite knows the origin."
	bitesize = 6
	icon_state = "griddlecakelemon"
	tastes = list("fluffy butterdough" = 1, "sweet" = 1, "lemon" = 1)
	rotprocess = SHELFLIFE_LONG
	faretype = FARE_FINE
	eat_effect = /datum/status_effect/buff/foodbuff
	foodtype = GRAIN | DAIRY | EGG | FRUIT
	nutrition = (BUTTERDOUGHSLICE_NUTRITION + EGG_NUTRITION + FRUIT_NUTRITION) * COOK_MOD
	item_weight = 120 GRAMS

/*	.................   Apple Griddlecake   ................... */

/obj/item/reagent_containers/food/snacks/foodbase/applegriddlecake_raw
	name = "raw apple griddlecake"
	icon_state = "rawgriddlecakeapple"
	eat_effect = /datum/status_effect/debuff/uncookedfood
	rotprocess = SHELFLIFE_DECENT
	faretype = FARE_IMPOVERISHED
	foodtype = GRAIN | DAIRY | RAW | EGG | FRUIT
	nutrition = BUTTERDOUGHSLICE_NUTRITION + EGG_NUTRITION + FRUIT_NUTRITION
	item_weight = 120 GRAMS

/obj/item/reagent_containers/food/snacks/griddlecake/apple
	name = "apple griddlecake"
	desc = "Enjoyed by mercenaries throughout Psydonia, though despite their prevalence no one quite knows the origin."
	bitesize = 6
	icon_state = "griddlecakeapple"
	tastes = list("fluffy butterdough" = 1, "sweet" = 1, "apple" = 1)
	rotprocess = SHELFLIFE_LONG
	faretype = FARE_FINE
	eat_effect = /datum/status_effect/buff/foodbuff
	foodtype = GRAIN | DAIRY | EGG | FRUIT
	nutrition = (BUTTERDOUGHSLICE_NUTRITION + EGG_NUTRITION + FRUIT_NUTRITION) * COOK_MOD
	item_weight = 120 GRAMS

/*	.................   Berry Griddlecake   ................... */

/obj/item/reagent_containers/food/snacks/foodbase/berrygriddlecake_raw
	name = "raw jacksberry griddlecake"
	icon_state = "rawgriddlecakeberry"
	eat_effect = /datum/status_effect/debuff/uncookedfood
	rotprocess = SHELFLIFE_DECENT
	faretype = FARE_IMPOVERISHED
	foodtype = GRAIN | DAIRY | RAW | EGG | FRUIT
	nutrition = BUTTERDOUGHSLICE_NUTRITION + EGG_NUTRITION + RAISIN_NUTRITION
	item_weight = 120 GRAMS

/obj/item/reagent_containers/food/snacks/griddlecake/berry
	name = "jacksberry griddlecake"
	desc = "Enjoyed by mercenaries throughout Psydonia, though despite their prevalence no one quite knows the origin."
	bitesize = 6
	icon_state = "griddlecakeberry"
	tastes = list("fluffy butterdough" = 1, "sweet" = 1, "berry" = 1)
	rotprocess = SHELFLIFE_LONG
	faretype = FARE_FINE
	eat_effect = /datum/status_effect/buff/foodbuff
	foodtype = GRAIN | DAIRY | EGG | FRUIT
	nutrition = (BUTTERDOUGHSLICE_NUTRITION + EGG_NUTRITION + RAISIN_NUTRITION) * COOK_MOD
	item_weight = 120 GRAMS

/obj/item/reagent_containers/food/snacks/griddlecake/berry/poison
	list_reagents = list(/datum/reagent/berrypoison = 5)

/*	.................   Griddlecake Condiments   ................... */

/obj/item/reagent_containers/food/snacks/griddlecake/attackby(obj/item/I, mob/living/user, list/modifiers)
	if(modified || !is_type_in_list(I, list(
		/obj/item/reagent_containers/food/snacks/butterslice,
		/obj/item/reagent_containers/food/snacks/spiderhoney,
		/obj/item/reagent_containers/food/snacks/chocolate/chunk)))
		return ..()
	var/obj/item/reagent_containers/food/snacks/S = I
	var/cooking = 5 SECONDS - (GET_MOB_SKILL_VALUE_OLD(user, /datum/attribute/skill/craft/cooking))*8
	playsound(user, 'sound/foley/dropsound/food_drop.ogg', 50, TRUE, -1)
	if(!do_after(user, cooking, src, display_over_user=TRUE))
		return FALSE
	modified = TRUE
	faretype++
	user.mind.add_sleep_experience(/datum/attribute/skill/craft/cooking/baking, (GET_MOB_ATTRIBUTE_VALUE(user, STAT_INTELLIGENCE)*0.2))
	user.nobles_seen_servant_work()
	S.reagents?.trans_to(src, S.reagents.total_volume)
	LAZYADDASSOC(bonus_reagents, /datum/reagent/consumable/nutriment, S.nutrition * 0.75)
	LAZYADDASSOC(bonus_reagents, /datum/reagent/consumable/nutriment/vitamin, S.nutrition * 0.25)
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

/*----------\
| Dot Tarts |
\----------*/

/*	.................   Unfinished Dot Tarts   ................... */

/obj/item/reagent_containers/food/snacks/foodbase/dottart_base
	name = "unfilled dot tart"
	icon_state = "dottart_base"
	eat_effect = /datum/status_effect/debuff/uncookedfood
	rotprocess = SHELFLIFE_DECENT
	faretype = FARE_IMPOVERISHED
	foodtype = GRAIN | DAIRY | RAW
	nutrition = BUTTERDOUGHSLICE_NUTRITION
	item_weight = 60 GRAMS

/obj/item/reagent_containers/food/snacks/foodbase/dottart_base/strawberry
	name = "raw strawberry dot tart"
	icon_state = "strawberry_dottart_base"
	foodtype = GRAIN | DAIRY | RAW | FRUIT
	nutrition = BUTTERDOUGHSLICE_NUTRITION + FRUIT_NUTRITION

/obj/item/reagent_containers/food/snacks/foodbase/dottart_base/tangerine
	name = "raw tangerine dot tart"
	icon_state = "tangerine_dottart_base"
	foodtype = GRAIN | DAIRY | RAW | FRUIT
	nutrition = BUTTERDOUGHSLICE_NUTRITION + FRUIT_NUTRITION

/obj/item/reagent_containers/food/snacks/foodbase/dottart_base/plum
	name = "raw plum dot tart"
	icon_state = "plum_dottart_base"
	foodtype = GRAIN | DAIRY | RAW | FRUIT
	nutrition = BUTTERDOUGHSLICE_NUTRITION + FRUIT_NUTRITION

/obj/item/reagent_containers/food/snacks/foodbase/dottart_base/blackberry
	name = "raw blackberry dot tart"
	icon_state = "blackberry_dottart_base"
	foodtype = GRAIN | DAIRY | RAW | FRUIT
	nutrition = BUTTERDOUGHSLICE_NUTRITION + FRUIT_NUTRITION

/obj/item/reagent_containers/food/snacks/foodbase/dottart_base/raspberry
	name = "raw raspberry dot tart"
	icon_state = "raspberry_dottart_base"
	foodtype = GRAIN | DAIRY | RAW | FRUIT
	nutrition = BUTTERDOUGHSLICE_NUTRITION + FRUIT_NUTRITION

/obj/item/reagent_containers/food/snacks/foodbase/dottart_base/lemon
	name = "raw lemon dot tart"
	icon_state = "lemon_dottart_base"
	foodtype = GRAIN | DAIRY | RAW | FRUIT
	nutrition = BUTTERDOUGHSLICE_NUTRITION + FRUIT_NUTRITION

/obj/item/reagent_containers/food/snacks/foodbase/dottart_base/lime
	name = "raw lime dot tart"
	icon_state = "lime_dottart_base"
	foodtype = GRAIN | DAIRY | RAW | FRUIT
	nutrition = BUTTERDOUGHSLICE_NUTRITION + FRUIT_NUTRITION

/obj/item/reagent_containers/food/snacks/foodbase/dottart_base/pear
	name = "raw pear dot tart"
	icon_state = "pear_dottart_base"
	foodtype = GRAIN | DAIRY | RAW | FRUIT
	nutrition = BUTTERDOUGHSLICE_NUTRITION + FRUIT_NUTRITION

/*	.................   Finished Dot Tarts   ................... */

/obj/item/reagent_containers/food/snacks/dottart_strawberry
	name = "strawberry dot tart"
	desc = "A small strawberry jam-filled pastry, for when a whole pie would be inapropriate for canapes."
	bitesize = 2
	icon_state = "strawberry_dottart"
	tastes = list("crispy butterdough" = 1, "strawberry jam" = 1)
	rotprocess = SHELFLIFE_LONG
	faretype = FARE_NEUTRAL
	foodtype = GRAIN | DAIRY | FRUIT
	nutrition = (BUTTERDOUGHSLICE_NUTRITION + FRUIT_NUTRITION) * COOK_MOD
	item_weight = 60 GRAMS

/obj/item/reagent_containers/food/snacks/dottart_tangerine
	name = "tangerine dot tart"
	desc = "A small tangerine jam-filled pastry, for when a whole pie would be inapropriate for canapes."
	bitesize = 2
	icon_state = "tangerine_dottart"
	tastes = list("crispy butterdough" = 1, "tangerine jam" = 1)
	rotprocess = SHELFLIFE_LONG
	faretype = FARE_NEUTRAL
	foodtype = GRAIN | DAIRY | FRUIT
	nutrition = (BUTTERDOUGHSLICE_NUTRITION + FRUIT_NUTRITION) * COOK_MOD
	item_weight = 60 GRAMS

/obj/item/reagent_containers/food/snacks/dottart_plum
	name = "plum dot tart"
	desc = "A small plum jam-filled pastry, for when a whole pie would be inapropriate for canapes."
	bitesize = 2
	icon_state = "plum_dottart"
	tastes = list("crispy butterdough" = 1, "plum jam" = 1)
	rotprocess = SHELFLIFE_LONG
	faretype = FARE_NEUTRAL
	foodtype = GRAIN | DAIRY | FRUIT
	nutrition = (BUTTERDOUGHSLICE_NUTRITION + FRUIT_NUTRITION) * COOK_MOD
	item_weight = 60 GRAMS

/obj/item/reagent_containers/food/snacks/dottart_blackberry
	name = "blackberry dot tart"
	desc = "A small blackberry jam-filled pastry, for when a whole pie would be inapropriate for canapes."
	bitesize = 2
	icon_state = "blackberry_dottart"
	tastes = list("crispy butterdough" = 1, "blackberry jam" = 1)
	rotprocess = SHELFLIFE_LONG
	faretype = FARE_NEUTRAL
	foodtype = GRAIN | DAIRY | FRUIT
	nutrition = (BUTTERDOUGHSLICE_NUTRITION + FRUIT_NUTRITION) * COOK_MOD
	item_weight = 60 GRAMS

/obj/item/reagent_containers/food/snacks/dottart_raspberry
	name = "raspberry dot tart"
	desc = "A small raspberry jam-filled pastry, for when a whole pie would be inapropriate for canapes."
	bitesize = 2
	icon_state = "raspberry_dottart"
	tastes = list("crispy butterdough" = 1, "raspberry jam" = 1)
	rotprocess = SHELFLIFE_LONG
	faretype = FARE_NEUTRAL
	foodtype = GRAIN | DAIRY | FRUIT
	nutrition = (BUTTERDOUGHSLICE_NUTRITION + FRUIT_NUTRITION) * COOK_MOD
	item_weight = 60 GRAMS

/obj/item/reagent_containers/food/snacks/dottart_lemon
	name = "lemon dot tart"
	desc = "A small lemon jam-filled pastry, for when a whole pie would be inapropriate for canapes."
	bitesize = 2
	icon_state = "lemon_dottart"
	tastes = list("crispy butterdough" = 1, "lemon jam" = 1)
	rotprocess = SHELFLIFE_LONG
	faretype = FARE_NEUTRAL
	foodtype = GRAIN | DAIRY | FRUIT
	nutrition = (BUTTERDOUGHSLICE_NUTRITION + FRUIT_NUTRITION) * COOK_MOD
	item_weight = 60 GRAMS

/obj/item/reagent_containers/food/snacks/dottart_lime
	name = "lime dot tart"
	desc = "A small lime jam-filled pastry, for when a whole pie would be inapropriate for canapes."
	bitesize = 2
	icon_state = "lime_dottart"
	tastes = list("crispy butterdough" = 1, "lime jam" = 1)
	rotprocess = SHELFLIFE_LONG
	faretype = FARE_NEUTRAL
	foodtype = GRAIN | DAIRY | FRUIT
	nutrition = (BUTTERDOUGHSLICE_NUTRITION + FRUIT_NUTRITION) * COOK_MOD
	item_weight = 60 GRAMS

/obj/item/reagent_containers/food/snacks/dottart_pear
	name = "pear dot tart"
	desc = "A small pear jam-filled pastry, for when a whole pie would be inapropriate for canapes."
	bitesize = 2
	icon_state = "pear_dottart"
	tastes = list("crispy butterdough" = 1, "pear jam" = 1)
	rotprocess = SHELFLIFE_LONG
	faretype = FARE_NEUTRAL
	foodtype = GRAIN | DAIRY | FRUIT
	nutrition = (BUTTERDOUGHSLICE_NUTRITION + FRUIT_NUTRITION) * COOK_MOD
	item_weight = 60 GRAMS

/*---------------------\
| Tamto Plates (Pizza) |
\---------------------*/

/*	.................   Unfinished Tamto Plates   ................... */

/obj/item/reagent_containers/food/snacks/foodbase/tamtoplate_base
	name = "unfinished tamto plate"
	icon_state = "pizza_base"
	dropshrink = 0.9
	eat_effect = /datum/status_effect/debuff/uncookedfood
	w_class = WEIGHT_CLASS_NORMAL
	rotprocess = SHELFLIFE_DECENT
	faretype = FARE_IMPOVERISHED
	foodtype = GRAIN | FRUIT | RAW
	nutrition = SMALLDOUGH_NUTRITION + FRUIT_NUTRITION
	item_weight = 450 GRAMS

/obj/item/reagent_containers/food/snacks/foodbase/tamtoplate_unfinished
	name = "unbaked cheese tamto plate"
	icon_state = "pizza_uncooked"
	dropshrink = 0.9
	eat_effect = /datum/status_effect/debuff/uncookedfood
	w_class = WEIGHT_CLASS_NORMAL
	rotprocess = SHELFLIFE_DECENT
	faretype = FARE_IMPOVERISHED
	foodtype = GRAIN | FRUIT | RAW | DAIRY
	nutrition = SMALLDOUGH_NUTRITION + FRUIT_NUTRITION + CHEESE_NUTRITION
	item_weight = 450 GRAMS

/obj/item/reagent_containers/food/snacks/foodbase/tamtoplate_unfinished_meat
	name = "unbaked sausage tamto plate"
	icon_state = "meat_pizza_uncooked"
	dropshrink = 0.9
	eat_effect = /datum/status_effect/debuff/uncookedfood
	w_class = WEIGHT_CLASS_NORMAL
	rotprocess = SHELFLIFE_DECENT
	faretype = FARE_IMPOVERISHED
	foodtype = GRAIN | FRUIT | RAW | DAIRY | MEAT
	nutrition = SMALLDOUGH_NUTRITION + FRUIT_NUTRITION + CHEESE_NUTRITION + RAWMEAT_NUTRITION
	item_weight = 450 GRAMS

/obj/item/reagent_containers/food/snacks/foodbase/tamtoplate_unfinished_fish
	name = "unbaked fish tamto plate"
	icon_state = "fish_pizza_uncooked"
	dropshrink = 0.9
	eat_effect = /datum/status_effect/debuff/uncookedfood
	w_class = WEIGHT_CLASS_NORMAL
	rotprocess = SHELFLIFE_DECENT
	faretype = FARE_IMPOVERISHED
	foodtype = GRAIN | FRUIT | RAW | DAIRY | MEAT
	nutrition = SMALLDOUGH_NUTRITION + FRUIT_NUTRITION + CHEESE_NUTRITION + MINCE_NUTRITION
	item_weight = 450 GRAMS

/obj/item/reagent_containers/food/snacks/foodbase/tamtoplate_unfinished_onion
	name = "unbaked onion tamto plate"
	icon_state = "onion_pizza_uncooked"
	dropshrink = 0.9
	eat_effect = /datum/status_effect/debuff/uncookedfood
	w_class = WEIGHT_CLASS_NORMAL
	rotprocess = SHELFLIFE_DECENT
	faretype = FARE_IMPOVERISHED
	foodtype = GRAIN | FRUIT | RAW | DAIRY | VEGETABLES
	nutrition = SMALLDOUGH_NUTRITION + FRUIT_NUTRITION + CHEESE_NUTRITION + VEGGIE_NUTRITION
	item_weight = 450 GRAMS

/*	.................   Finished Tamto Plates   ................... */

/obj/item/reagent_containers/food/snacks/tamtoplate
	name = "cheese tamto plate"
	desc = "A deliciously greasy cheese half-pie originating from the trade-capital of Vanderlin, long may it reign!"
	bitesize = 6
	slices_num = 6
	slice_path = /obj/item/reagent_containers/food/snacks/tamtoplate_slice
	w_class = WEIGHT_CLASS_NORMAL
	slice_batch = TRUE
	slice_sound = TRUE
	icon_state = "pizza"
	dropshrink = 0.9
	tastes = list("crispy dough" = 1, "warm tomato" = 1, "gooey cheese" = 1, "")
	rotprocess = SHELFLIFE_LONG
	faretype = FARE_NEUTRAL
	foodtype = GRAIN | FRUIT | DAIRY
	nutrition = (SMALLDOUGH_NUTRITION + FRUIT_NUTRITION + CHEESE_NUTRITION) * COOK_MOD
	item_weight = 450 GRAMS

/obj/item/reagent_containers/food/snacks/tamtoplate/meat
	name = "sausage tamto plate"
	desc = "A deliciously greasy sausage half-pie originating from the trade-capital of Vanderlin, long may it reign!"
	slice_path = /obj/item/reagent_containers/food/snacks/tamtoplate_slice/meat
	icon_state = "meat_pizza"
	tastes = list("crispy dough" = 1, "warm tomato" = 1, "gooey cheese" = 1, "savory sausage")
	faretype = FARE_FINE
	foodtype = GRAIN | FRUIT | DAIRY | MEAT
	nutrition = (SMALLDOUGH_NUTRITION + FRUIT_NUTRITION + CHEESE_NUTRITION + RAWMEAT_NUTRITION) * COOK_MOD
	item_weight = 450 GRAMS

/obj/item/reagent_containers/food/snacks/tamtoplate/fish
	name = "sausage tamto plate"
	desc = "A deliciously greasy fish half-pie originating from the trade-capital of Vanderlin, long may it reign!"
	slice_path = /obj/item/reagent_containers/food/snacks/tamtoplate_slice/fish
	icon_state = "fish_pizza"
	tastes = list("crispy dough" = 1, "warm tomato" = 1, "gooey cheese" = 1, "crispy fish" = 1)
	faretype = FARE_FINE
	foodtype = GRAIN | FRUIT | DAIRY | MEAT
	nutrition = (SMALLDOUGH_NUTRITION + FRUIT_NUTRITION + CHEESE_NUTRITION + MINCE_NUTRITION) * COOK_MOD
	item_weight = 450 GRAMS

/obj/item/reagent_containers/food/snacks/tamtoplate/onion
	name = "onion tamto plate"
	desc = "A deliciously greasy onion half-pie originating from the trade-capital of Vanderlin, long may it reign!"
	slice_path = /obj/item/reagent_containers/food/snacks/tamtoplate_slice/onion
	icon_state = "onion_pizza"
	tastes = list("crispy dough" = 1, "warm tomato" = 1, "gooey cheese" = 1, "crunchy onion" = 1)
	faretype = FARE_FINE
	foodtype = GRAIN | FRUIT | DAIRY | VEGETABLES
	nutrition = (SMALLDOUGH_NUTRITION + FRUIT_NUTRITION + CHEESE_NUTRITION + VEGGIE_NUTRITION) * COOK_MOD
	item_weight = 450 GRAMS

/*	.................  Tamto Plate Slices   ................... */

/obj/item/reagent_containers/food/snacks/tamtoplate_slice
	name = "cheese tamto plate slice"
	desc = "A deliciously greasy cheese half-pie originating from the trade-capital of Vanderlin, long may it reign!"
	bitesize = 3
	w_class = WEIGHT_CLASS_SMALL
	icon_state = "pizza_slice"
	dropshrink = 0.8
	tastes = list("crispy dough" = 1, "warm tomato" = 1, "gooey cheese" = 1, "")
	rotprocess = SHELFLIFE_LONG
	faretype = FARE_NEUTRAL
	foodtype = GRAIN | FRUIT | DAIRY
	nutrition = ((SMALLDOUGH_NUTRITION + FRUIT_NUTRITION + CHEESE_NUTRITION) * COOK_MOD) * SLICED_MOD
	item_weight = 75 GRAMS

/obj/item/reagent_containers/food/snacks/tamtoplate_slice/meat
	name = "sausage tamto plate slice"
	desc = "A deliciously greasy sausage half-pie originating from the trade-capital of Vanderlin, long may it reign!"
	icon_state = "meat_pizza_slice"
	tastes = list("crispy dough" = 1, "warm tomato" = 1, "gooey cheese" = 1, "savory sausage")
	faretype = FARE_FINE
	foodtype = GRAIN | FRUIT | DAIRY | MEAT
	nutrition = ((SMALLDOUGH_NUTRITION + FRUIT_NUTRITION + CHEESE_NUTRITION + RAWMEAT_NUTRITION) * COOK_MOD) * SLICED_MOD
	item_weight = 75 GRAMS

/obj/item/reagent_containers/food/snacks/tamtoplate_slice/fish
	name = "sausage tamto plate"
	desc = "A deliciously greasy fish half-pie originating from the trade-capital of Vanderlin, long may it reign!"
	icon_state = "fish_pizza_slice"
	tastes = list("crispy dough" = 1, "warm tomato" = 1, "gooey cheese" = 1, "crispy fish" = 1)
	faretype = FARE_FINE
	foodtype = GRAIN | FRUIT | DAIRY | MEAT
	nutrition = ((SMALLDOUGH_NUTRITION + FRUIT_NUTRITION + CHEESE_NUTRITION + MINCE_NUTRITION) * COOK_MOD) * SLICED_MOD
	item_weight = 75 GRAMS

/obj/item/reagent_containers/food/snacks/tamtoplate_slice/onion
	name = "onion tamto plate slice"
	desc = "A deliciously greasy onion half-pie originating from the trade-capital of Vanderlin, long may it reign!"
	icon_state = "onion_pizza_slice"
	tastes = list("crispy dough" = 1, "warm tomato" = 1, "gooey cheese" = 1, "crunchy onion" = 1)
	faretype = FARE_FINE
	foodtype = GRAIN | FRUIT | DAIRY | VEGETABLES
	nutrition = ((SMALLDOUGH_NUTRITION + FRUIT_NUTRITION + CHEESE_NUTRITION + VEGGIE_NUTRITION) * COOK_MOD) * SLICED_MOD
	item_weight = 75 GRAMS
