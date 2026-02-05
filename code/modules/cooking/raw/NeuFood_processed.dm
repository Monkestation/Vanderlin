/* * * * * * * * * * * **
 *						*
 *		 NeuFood		*
 *	    (Preserves)		*
 *						*
 * * * * * * * * * * * **/

// -------------- FAT -----------------
/obj/item/reagent_containers/food/snacks/fat
	name = "fat"
	desc = ""
	icon_state = "fat"
	list_reagents = list(/datum/reagent/consumable/nutriment = SNACK_POOR)
	eat_effect = /datum/status_effect/debuff/uncookedfood
	possible_item_intents = list(/datum/intent/food, /datum/intent/splash, /datum/intent/use)

/obj/item/reagent_containers/food/snacks/fat/attack(mob/living/M, mob/user, list/modifiers)
	if(user.used_intent.type == /datum/intent/food)
		return ..()

	if(!isliving(M) || (M != user))
		return ..()

	user.visible_message("[user] starts to oil up [M]", "You start to oil up [M]")
	if(!do_after(user, 5 SECONDS, M))
		return
	M.apply_status_effect(/datum/status_effect/buff/oiled)

/obj/item/reagent_containers/food/snacks/fat/attackby(obj/item/I, mob/living/user, list/modifiers)
	var/found_table = locate(/obj/structure/table) in (loc)
	var/obj/item/reagent_containers/glass/R = I
	if(user.mind)
		long_cooktime = (90 - ((user.get_skill_level(/datum/skill/craft/cooking, TRUE))*15))
	if(isturf(loc)&& (found_table))
		if(!istype(R))
			return ..()
		if(!R.reagents.has_reagent(/datum/reagent/consumable/sugar, 33))
			to_chat(user, span_notice("Needs more sugar to work it."))
			return TRUE
		if(user.get_skill_level(/datum/skill/craft/cooking) <= 3) // cooks with less than 3 skill don´t know this recipe
			to_chat(user, span_warning("Gelatine is much too strange for you."))
			return
		to_chat(user, span_notice("Congealing the sugar..."))
		playsound(user, 'sound/foley/splishy.ogg', 100, TRUE, -1)
		if(do_after(user, long_cooktime, src))
			new /obj/item/reagent_containers/food/snacks/jellycake_base(loc)
			user.mind.add_sleep_experience(/datum/skill/craft/cooking, (user.STAINT*0.5))
			qdel(src)
			R.reagents.remove_reagent(/datum/reagent/consumable/sugar, 33)
			user.nobles_seen_servant_work()
	else
		to_chat(user, span_warning("You need to put [src] on a table to work on it."))

// TALLOW is used as an intermediate crafting ingredient for other recipes.
/obj/item/reagent_containers/food/snacks/tallow
	name = "tallow"
	desc = "Fatty tissue is harvested from slain creachurs and rendered of its membraneous sinew to produce a hard shelf-stable \
	grease."
	icon_state = "tallow"
	tastes = list("grease" = 1, "oil" = 1, "regret" =1)
	obj_flags = CAN_BE_HIT
	list_reagents = list(/datum/reagent/consumable/nutriment = SNACK_POOR)
	bitesize = 1
	dropshrink = 0.75

/obj/item/reagent_containers/food/snacks/tallow/red
	name = "redtallow"
	desc = "Fatty tissue is harvested from slain creachurs and rendered of its membraneous sinew to produce a hard shelf-stable \
	grease. It has then been soaked in blood or something blood adjacent to make for an easily sourced and rather grim wax substitute. As they say in Grenzelhoft, one uses what one has."
	icon_state = "redtallow"
	tastes = list("grease" = 1, "oil" = 1, "regret" =1, "blood"=1,)

/obj/item/reagent_containers/food/snacks/tallow/attacked_by(obj/item/I, mob/living/user)
	. = ..()
	if(istype(I, /obj/item/inqarticles/indexer))
		var/obj/item/inqarticles/indexer/IND = I
		var/success
		if(HAS_TRAIT(user, TRAIT_INQUISITION))
			if(IND.full)
				if(alert(user, "SOAK THE TALLOW?", "IT'S JUST BLOOD", "YES", "NO") != "NO")
					success = TRUE
					IND.fullreset(user)
				else
					return
				if(success)
					changefood(/obj/item/reagent_containers/food/snacks/tallow/red, user)

// -------------- SPIDER HONEY -----------------
/obj/item/reagent_containers/food/snacks/spiderhoney
	name = "spider honey"
	icon_state = "spiderhoney"
	bitesize = 3
	list_reagents = list(/datum/reagent/consumable/nutriment = SNACK_DECENT)
	w_class = WEIGHT_CLASS_TINY
	tastes = list("sweetness and spiderwebs" = 1)
	faretype = FARE_FINE

// -------------- TIEFLING SUGAR -----------------
/obj/item/reagent_containers/food/snacks/tiefsugar
	name = "Tiefling Sugar"
	desc ="Originating from subterra, Tiefling blood that has been expertly dried and mixed into a sugar base, sweetens when boiled."
	icon = 'icons/roguetown/items/produce.dmi'
	icon_state = "tsugar"
	tastes = list("sweet" = 1)
	list_reagents = list(/datum/reagent/blood/tiefling = 11)


// -------------- CHOCOLATE -----------------
/obj/item/reagent_containers/food/snacks/chocolate
	name = "chocolate bar"
	desc = "Unbelievably fancy chocolate, imported all the way from distant Grenzelhoft"
	icon_state = "chocolate"
	bitesize = 4
	list_reagents = list(/datum/reagent/consumable/nutriment = SNACK_DECENT)
	w_class = WEIGHT_CLASS_TINY
	tastes = list("rich sweetness" = 1)
	faretype = FARE_FINE
	rotprocess = null
	eat_effect = /datum/status_effect/buff/foodbuff

// -------------- SALUMOI (dwarven smoked sausage) -----------------
/obj/item/reagent_containers/food/snacks/meat/salami
	name = "salumoi"
	desc = "Traveling food invented by dwarves. Said to last for ten yils before spoiling"
	icon_state = "salumoi5"
	eat_effect = null
	slices_num = 4
	bitesize = 5
	slice_batch = FALSE
	list_reagents = list(/datum/reagent/consumable/nutriment = SAUSAGE_NUTRITION)
	slice_path = /obj/item/reagent_containers/food/snacks/meat/salami/slice
	tastes = list("salted meat" = 1)
	rotprocess = null
	slice_sound = TRUE
	faretype = FARE_POOR

/obj/item/reagent_containers/food/snacks/meat/salami/update_icon_state()
	if(slices_num)
		icon_state = "salumoi[slices_num]"
	else
		icon_state = "salumoi_slice"
	return ..()

/obj/item/reagent_containers/food/snacks/meat/salami/on_consume(mob/living/eater)
	..()
	if(slices_num)
		switch(bitecount)
			if(1)
				slices_num = 4
			if(2)
				slices_num = 3
			if(3)
				slices_num = 2
			if(4)
				changefood(slice_path, eater)

/obj/item/reagent_containers/food/snacks/meat/salami/slice
	eat_effect = null
	slices_num = 0
	name = "salumoi"
	icon_state = "salumoi_slice"
	list_reagents = list(/datum/reagent/consumable/nutriment = SNACK_POOR)
	bitesize = 1
	tastes = list("salted meat" = 1)
	faretype = FARE_NEUTRAL

// -------------- COPPIETTE (dried meat) -----------------
/obj/item/reagent_containers/food/snacks/cooked/coppiette
	name = "coppiette"
	desc = "Dried meat sticks."
	icon_state = "coppiette"
	base_icon_state = "coppiette"
	biting = TRUE
	bitesize = 5
	tastes = list("salted meat" = 1)
	rotprocess = null
	list_reagents = list(/datum/reagent/consumable/nutriment = SNACK_DECENT)
	faretype = FARE_POOR


// -------------- SALTFISH -----------------
/obj/item/reagent_containers/food/snacks/saltfish
	name = "saltfish"
	desc = "Dried fish."
	icon = 'icons/roguetown/misc/fish.dmi'
	icon_state = "clownfishdried"
	eat_effect = null
	bitesize = 4
	slice_path = null
	tastes = list("salted meat" = 1)
	rotprocess = null
	list_reagents = list(/datum/reagent/consumable/nutriment = SNACK_NUTRITIOUS)
	dropshrink = 0.6
	faretype = FARE_POOR

/obj/item/reagent_containers/food/snacks/saltfish/CheckParts(list/parts_list)
	for(var/obj/item/reagent_containers/food/snacks/M in parts_list)
		icon_state = "[initial(M.icon_state)]dried"
		qdel(M)

// -------------- SALO (salted fat) -----------------
/obj/item/reagent_containers/food/snacks/fat/salo
	name = "salo"
	icon_state = "salo4"
	list_reagents = list(/datum/reagent/consumable/nutriment = COOKED_FAT_NUTRITION+COOKED_FAT_NUTRITION)
	bitesize = 4
	slice_path = /obj/item/reagent_containers/food/snacks/fat/salo/slice
	slices_num = 4
	slice_batch = FALSE
	slice_sound = TRUE
	eat_effect = null
	faretype = FARE_POOR

/obj/item/reagent_containers/food/snacks/fat/salo/update_icon_state()
	if(slices_num)
		icon_state = "salo[slices_num]"
	else
		icon_state = "saloslice"
	return ..()

/obj/item/reagent_containers/food/snacks/fat/salo/on_consume(mob/living/eater)
	..()
	if(slices_num)
		if(bitecount == 1)
			slices_num = 3
		if(bitecount == 2)
			slices_num = 2
		if(bitecount == 3)
			changefood(slice_path, eater)

/obj/item/reagent_containers/food/snacks/fat/salo/slice
	name = "salo"
	icon_state = "saloslice"
	bitesize = 2
	slices_num = FALSE
	slice_path = FALSE
	list_reagents = list(/datum/reagent/consumable/nutriment = SNACK_POOR)

/*------------\
| Dried Fruit |
\------------*/

// -------------- RAISINS -----------------
/obj/item/reagent_containers/food/snacks/raisins
	name = "raisins"
	icon = 'icons/roguetown/items/produce.dmi'
	icon_state = "raisins"
	base_icon_state = "raisins"
	biting = TRUE
	bitesize = 5
	list_reagents = list(/datum/reagent/consumable/nutriment = SNACK_POOR)
	w_class = WEIGHT_CLASS_TINY
	tastes = list("dried fruit" = 1)
	foodtype = GRAIN
	faretype = FARE_POOR

/obj/item/reagent_containers/food/snacks/raisins/CheckParts(list/parts_list)
	..()
	for(var/obj/item/reagent_containers/food/snacks/M in parts_list)
		color = M.filling_color
		if(M.reagents)
			M.reagents.remove_reagent(/datum/reagent/consumable/nutriment, M.reagents.total_volume)
			M.reagents.trans_to(src, M.reagents.total_volume)
		qdel(M)

/obj/item/reagent_containers/food/snacks/raisins/poison
	list_reagents = list(/datum/reagent/consumable/nutriment = SNACK_POOR, /datum/reagent/berrypoison = 4)
	tastes = list("bitter dried fruit" = 1)

// -------------- STRAWBERRY -----------------

/obj/item/reagent_containers/food/snacks/strawberry_dried
	name = "dried strawberry"
	icon_state = "driedstrawberry"
	dropshrink = 0.8
	bitesize = 3
	list_reagents = list(/datum/reagent/consumable/nutriment = SNACK_POOR)
	w_class = WEIGHT_CLASS_TINY
	tastes = list("dried fruit" = 1)
	foodtype = FRUIT
	faretype = FARE_NEUTRAL

// -------------- TANGERINE -----------------

/obj/item/reagent_containers/food/snacks/tangerine_dried
	name = "dried tangerine"
	icon_state = "driedtangerine"
	dropshrink = 0.8
	bitesize = 3
	list_reagents = list(/datum/reagent/consumable/nutriment = SNACK_POOR)
	w_class = WEIGHT_CLASS_TINY
	tastes = list("dried fruit" = 1)
	foodtype = FRUIT
	faretype = FARE_NEUTRAL

// -------------- PLUM -----------------

/obj/item/reagent_containers/food/snacks/plum_dried
	name = "dried plum"
	icon_state = "driedplum"
	dropshrink = 0.8
	bitesize = 3
	list_reagents = list(/datum/reagent/consumable/nutriment = SNACK_POOR)
	w_class = WEIGHT_CLASS_TINY
	tastes = list("dried fruit" = 1)
	foodtype = FRUIT
	faretype = FARE_NEUTRAL

// -------------- APPLE -----------------

/obj/item/reagent_containers/food/snacks/apple_dried
	name = "dried apple"
	icon_state = "driedapple"
	dropshrink = 0.8
	bitesize = 3
	list_reagents = list(/datum/reagent/consumable/nutriment = SNACK_POOR)
	w_class = WEIGHT_CLASS_TINY
	tastes = list("dried fruit" = 1)
	foodtype = FRUIT
	faretype = FARE_NEUTRAL

// -------------- PEAR -----------------

/obj/item/reagent_containers/food/snacks/pear_dried
	name = "dried pear"
	icon_state = "driedpear"
	dropshrink = 0.8
	bitesize = 3
	list_reagents = list(/datum/reagent/consumable/nutriment = SNACK_POOR)
	w_class = WEIGHT_CLASS_TINY
	tastes = list("dried fruit" = 1)
	foodtype = FRUIT
	faretype = FARE_NEUTRAL

/***************** Mushrooms *****************/

/obj/item/reagent_containers/food/snacks/waddle_dried
	name = "dried waddle"
	desc = "A waddle mushroom that has been dried for use in tea. Not pleasant to eat in this state."
	icon_state = "driedwaddle"
	dropshrink = 1
	bitesize = 3
	list_reagents = list(/datum/reagent/consumable/nutriment = SNACK_POOR)
	w_class = WEIGHT_CLASS_TINY
	tastes = list("woody" = 1,"bitter" = 1)
	foodtype = MUSHROOM
	faretype = FARE_POOR
	eat_effect = /datum/status_effect/debuff/uncookedfood

/*------------\
| Salted milk |
\------------*/		// The base for making butter and cheese

/datum/reagent/consumable/milk/gote
	name = "gote milk"
	taste_description = "gote milk"

/datum/reagent/consumable/milk/salted_gote
	name = "salted gote milk"
	taste_description = "salty gote-milk"

/datum/reagent/consumable/milk/salted
	name = "salted milk"
	taste_description = "salty milk"



/*-------\
| Butter |
\-------*/

/*	............   Churning butter   ................ */
/obj/item/reagent_containers/glass/bucket/wooden/attackby(obj/item/I, mob/living/user, list/modifiers)
	if(user.mind)
		long_cooktime = (200 - ((user.get_skill_level(/datum/skill/craft/cooking, TRUE))*22))
	if(istype(I, /obj/item/kitchen/spoon))
		if(!reagents.has_reagent(/datum/reagent/consumable/milk/salted, 15) && !reagents.has_reagent(/datum/reagent/consumable/milk/salted_gote, 15))
			to_chat(user, span_warning(">Not enough salted milk."))
			return
		user.adjust_stamina(40) // forgot stamina is our lovely stamloss proc here
		user.visible_message("<span class='info'>[user] churns butter...</span>")
		playsound(user, 'sound/foley/butterchurn.ogg', 100, TRUE, -1)
		if(do_after(user, long_cooktime, src))
			user.adjust_stamina(50)
			if(reagents.has_reagent(/datum/reagent/consumable/milk/salted, 15))
				reagents.remove_reagent(/datum/reagent/consumable/milk/salted, 15)
			if(reagents.has_reagent(/datum/reagent/consumable/milk/salted_gote, 15))
				reagents.remove_reagent(/datum/reagent/consumable/milk/salted_gote, 15)
			new /obj/item/reagent_containers/food/snacks/butter(drop_location())
			user.mind.add_sleep_experience(/datum/skill/craft/cooking, (user.STAINT))
			user.nobles_seen_servant_work()
		return
	..()

// -------------- BUTTER -----------------
/obj/item/reagent_containers/food/snacks/butter
	name = "stick of butter"
	desc = ""
	icon_state = "butter6"
	list_reagents = list(/datum/reagent/consumable/nutriment = BUTTER_NUTRITION * 2)
	foodtype = DAIRY
	eat_effect = /datum/status_effect/debuff/uncookedfood
	slice_path = /obj/item/reagent_containers/food/snacks/butterslice
	slices_num = 6
	slice_batch = FALSE
	bitesize = 6
	slice_sound = TRUE
	tastes = list("raw unsalted butter" = 1)
	faretype = FARE_IMPOVERISHED

/obj/item/reagent_containers/food/snacks/butter/update_icon_state()
	if(slices_num)
		icon_state = "butter[slices_num]"
	else
		icon_state = "butter_slice"
	return ..()

/obj/item/reagent_containers/food/snacks/butter/on_consume(mob/living/eater)
	..()
	if(slices_num)
		switch(bitecount)
			if(1)
				slices_num = 5
			if(2)
				slices_num = 4
			if(3)
				slices_num = 3
			if(4)
				slices_num = 2
			if(5)
				changefood(slice_path, eater)

/obj/item/reagent_containers/food/snacks/butterslice
	icon_state = "butter_slice"
	name = "butter"
	foodtype = DAIRY
	eat_effect = /datum/status_effect/debuff/uncookedfood
	list_reagents = list(/datum/reagent/consumable/nutriment = 1)
	tastes = list("raw unsalted butter" = 1)
	bitesize = 1
	faretype = FARE_IMPOVERISHED

/*	............   Pestran Stick   ................ */

/obj/item/reagent_containers/food/snacks/pestranstick
	name = "pestran stick"
	desc = "An unappetizing snack adored by devout Pestrans, somehow doesn't taste half bad."
	icon_state = "pestranstick"
	list_reagents = list(/datum/reagent/consumable/nutriment = BUTTER_NUTRITION)
	tastes = list("raw unsalted butter on a stick" = 1)
	trash = /obj/item/grown/log/tree/stick
	foodtype = DAIRY
	bitesize = 3
	faretype = FARE_POOR

/*-------\
| Cheese |
\-------*/

/*	............   Making fresh cheese   ................ */
/obj/item/reagent_containers/glass/bucket/wooden/attackby(obj/item/I, mob/living/user, list/modifiers)
	if(user.mind)
		long_cooktime = (100 - ((user.get_skill_level(/datum/skill/craft/cooking, TRUE))*12))
	if(istype(I, /obj/item/natural/cloth) && (user.used_intent.type == INTENT_USE || user.used_intent.type == INTENT_SOAK))
		var/milk = null
		var/cheese = null
		if(reagents.has_reagent(/datum/reagent/consumable/milk/salted, 5))
			milk = /datum/reagent/consumable/milk/salted
			cheese = /obj/item/reagent_containers/food/snacks/cheese
		if(reagents.has_reagent(/datum/reagent/consumable/milk/salted_gote, 5))
			milk = /datum/reagent/consumable/milk/salted_gote
			cheese = /obj/item/reagent_containers/food/snacks/cheese
		if(milk)
			if(I.reagents.total_volume > 0)
				to_chat(user, span_warning("The [I.name] is still soaked with something."))
			else
				user.visible_message("<span class='info'>[user] strains fresh cheese...</span>")
				playsound(src, pick('sound/foley/waterwash (1).ogg','sound/foley/waterwash (2).ogg'), 100, FALSE)
				if(do_after(user, long_cooktime, src))
					reagents.remove_reagent(milk, 5)
					new cheese(drop_location())
					user.mind.add_sleep_experience(/datum/skill/craft/cooking, (user.STAINT))
				user.nobles_seen_servant_work()
			return
	..()

/*	............   Making cheese wheel   ................ */
/obj/item/natural/cloth/attackby(obj/item/I, mob/living/user, list/modifiers)
	var/found_table = locate(/obj/structure/table) in (loc)
	if(istype(I, /obj/item/reagent_containers/food/snacks/cheese))
		if(isturf(loc)&& (found_table))
			user.visible_message("<span class='info'>[user] starts packing the cloth with fresh cheese...</span>")
			playsound(user, 'sound/foley/dropsound/food_drop.ogg', 30, TRUE, -1)
			if(do_after(user,3 SECONDS, src))
				new /obj/item/reagent_containers/food/snacks/foodbase/cheesewheel_start(loc)
				user.mind.add_sleep_experience(/datum/skill/craft/cooking, (user.STAINT*0.5))
				qdel(I)
				qdel(src)
				user.nobles_seen_servant_work()
			return
		else
			to_chat(user, span_warning("You need to put [src] on a table to work on it."))
	..()

/obj/item/reagent_containers/food/snacks/foodbase/cheesewheel_start
	name = "unfinished cheese wheel"
	icon_state = "cheesewheel_1"
	w_class = WEIGHT_CLASS_BULKY
	do_random_pixel_offset = FALSE
	grid_height = 32
	grid_width = 96

/obj/item/reagent_containers/food/snacks/foodbase/cheesewheel_start/attackby(obj/item/I, mob/living/user, list/modifiers)
	var/found_table = locate(/obj/structure/table) in (loc)
	if(user.mind)
		short_cooktime = (50 - ((user.get_skill_level(/datum/skill/craft/cooking, TRUE))*8))
	if(istype(I, /obj/item/reagent_containers/food/snacks/cheese))
		if(isturf(loc)&& (found_table))
			playsound(user, 'sound/foley/dropsound/food_drop.ogg', 30, TRUE, -1)
			if(do_after(user, short_cooktime, src))
				new /obj/item/reagent_containers/food/snacks/foodbase/cheesewheel_two(loc)
				qdel(I)
				qdel(src)
		else
			to_chat(user, span_warning("You need to put [src] on a table to work on it."))
	else
		return ..()

/obj/item/reagent_containers/food/snacks/foodbase/cheesewheel_two
	name = "unfinished cheese wheel"
	icon_state = "cheesewheel_2"
	w_class = WEIGHT_CLASS_BULKY
	do_random_pixel_offset = FALSE
	grid_height = 32
	grid_width = 96

/obj/item/reagent_containers/food/snacks/foodbase/cheesewheel_two/attackby(obj/item/I, mob/user, list/modifiers)
	var/found_table = locate(/obj/structure/table) in (loc)
	if(user.mind)
		short_cooktime = (50 - ((user.get_skill_level(/datum/skill/craft/cooking, TRUE))*8))
	if(istype(I, /obj/item/reagent_containers/food/snacks/cheese))
		if(isturf(loc)&& (found_table))
			playsound(user, 'sound/foley/dropsound/food_drop.ogg', 30, TRUE, -1)
			if(do_after(user, short_cooktime, src))
				new /obj/item/reagent_containers/food/snacks/foodbase/cheesewheel_three(loc)
				qdel(I)
				qdel(src)
		else
			to_chat(user, span_warning("You need to put [src] on a table to work on it."))
	else
		return ..()

/obj/item/reagent_containers/food/snacks/foodbase/cheesewheel_three
	name = "unfinished cheese wheel"
	icon_state = "cheesewheel_3"
	w_class = WEIGHT_CLASS_BULKY
	do_random_pixel_offset = FALSE
	grid_height = 32
	grid_width = 96

/obj/item/reagent_containers/food/snacks/foodbase/cheesewheel_three/attackby(obj/item/I, mob/living/user, list/modifiers)
	var/found_table = locate(/obj/structure/table) in (loc)
	if(user.mind)
		short_cooktime = (50 - ((user.get_skill_level(/datum/skill/craft/cooking, TRUE))*8))
	if(istype(I, /obj/item/reagent_containers/food/snacks/cheese) && icon_state != "cheesewheel_end")
		if(isturf(loc)&& (found_table))
			playsound(user, 'sound/foley/dropsound/food_drop.ogg', 30, TRUE, -1)
			user.mind.add_sleep_experience(/datum/skill/craft/cooking, (user.STAINT*0.5))
			if(do_after(user, short_cooktime, src))
				qdel(I)
				name = "maturing cheese wheel"
				icon_state = "cheesewheel_end"
				desc = "Slowly solidifying, best left alone a bit longer."
				addtimer(CALLBACK(src, PROC_REF(maturing_done)), 5 MINUTES)
				user.nobles_seen_servant_work()
		else
			to_chat(user, span_warning("You need to put [src] on a table to work on it."))
	else
		return ..()

/obj/item/reagent_containers/food/snacks/foodbase/cheesewheel_three/proc/maturing_done()
	playsound(src, 'sound/foley/rustle2.ogg', 100, TRUE, -1)
	new /obj/item/reagent_containers/food/snacks/cheddar(get_turf(src))
	new /obj/item/natural/cloth(get_turf(src))
	qdel(src)


// -------------- CHEESE -----------------
/obj/item/reagent_containers/food/snacks/cheese
	name = "fresh cheese"
	icon_state = "freshcheese"
	bitesize = 1
	list_reagents = list(/datum/reagent/consumable/nutriment = CHEESE_NUTRITION)
	w_class = WEIGHT_CLASS_TINY
	tastes = list("cheese" = 1)
	foodtype = GRAIN
	eat_effect = null
	rotprocess = SHELFLIFE_DECENT
	become_rot_type = null
	slice_path = null
	faretype = FARE_POOR

/obj/item/reagent_containers/food/snacks/cheese/gote
	name = "fresh gote cheese"

/obj/item/reagent_containers/food/snacks/cheddar
	name = "wheel of cheese"
	icon_state = "cheesewheel"
	dropshrink = 0.8
	bitesize = 6
	list_reagents = list(/datum/reagent/consumable/nutriment = CHEESE_NUTRITION*4)
	w_class = WEIGHT_CLASS_NORMAL
	tastes = list("cheese" = 1)
	eat_effect = null
	rotprocess = SHELFLIFE_LONG
	slices_num = 6
	slice_batch = TRUE
	slice_path = /obj/item/reagent_containers/food/snacks/cheese_wedge
	become_rot_type = /obj/item/reagent_containers/food/snacks/cheddar/aged
	slice_sound = TRUE
	grid_height = 32
	grid_width = 96

/obj/item/reagent_containers/food/snacks/cheddar/aged
	name = "wheel of aged cheese"
	icon_state = "blue_cheese"
	slice_path = /obj/item/reagent_containers/food/snacks/cheese_wedge/aged
	become_rot_type = null
	rotprocess = null
	sellprice = 60
	faretype = FARE_FINE

/obj/item/reagent_containers/food/snacks/cheese_wedge
	name = "wedge of cheese"
	icon_state = "cheese_wedge"
	dropshrink = 0.8
	list_reagents = list(/datum/reagent/consumable/nutriment = SNACK_DECENT)
	w_class = WEIGHT_CLASS_TINY
	tastes = list("cheese" = 1)
	rotprocess = SHELFLIFE_LONG
	slice_batch = TRUE
	slice_path = /obj/item/reagent_containers/food/snacks/cheddarslice
	slices_num = 3
	become_rot_type = /obj/item/reagent_containers/food/snacks/cheese_wedge/aged
	baitpenalty = 0
	isbait = TRUE
	fishloot = list(/obj/item/reagent_containers/food/snacks/fish/carp = 10,
					/obj/item/reagent_containers/food/snacks/fish/eel = 5,
					/obj/item/reagent_containers/food/snacks/fish/angler = 1,
					/obj/item/reagent_containers/food/snacks/fish/shrimp = 3)

/obj/item/reagent_containers/food/snacks/cheese_wedge/aged
	name = "wedge of aged cheese"
	icon_state = "blue_cheese_wedge"
	slice_path = /obj/item/reagent_containers/food/snacks/cheddarslice/aged
	become_rot_type = null
	rotprocess = null
	sellprice = 10
	faretype = FARE_FINE

/obj/item/reagent_containers/food/snacks/cheddarslice
	name = "slice of cheese"
	icon_state = "cheese_slice"
	bitesize = 1
	dropshrink = 0.8
	list_reagents = list(/datum/reagent/consumable/nutriment = 2)
	w_class = WEIGHT_CLASS_TINY
	tastes = list("cheese" = 1)
	eat_effect = null
	rotprocess = SHELFLIFE_SHORT
	slices_num = null
	slice_path = null
	become_rot_type = null
	baitpenalty = 0
	isbait = TRUE
	fishloot = list(/obj/item/reagent_containers/food/snacks/fish/carp = 10,
					/obj/item/reagent_containers/food/snacks/fish/eel = 5,
					/obj/item/reagent_containers/food/snacks/fish/shrimp = 3)
	faretype = FARE_FINE

/obj/item/reagent_containers/food/snacks/cheddarslice/aged
	name = "slice of aged cheese"
	icon_state = "blue_cheese_slice"
	become_rot_type = null
	rotprocess = null
	faretype = FARE_FINE

/*--------\
| Gelatine |
\--------*/

// -------------- Gelatine Base -----------------

/obj/item/reagent_containers/food/snacks/jellycake_base
	name = "plain gelatie cake"
	desc = "A mildly unappetising desert, fittingly considered a delicacy by orcs. Though it is traditionally made plain, chefs often mercifully flavor it with fruit."
	icon_state = "basegelatinecake"
	dropshrink = 0.8
	slice_path = /obj/item/reagent_containers/food/snacks/jellyslice_base
	slices_num = 4
	list_reagents = list(/datum/reagent/consumable/nutriment = SNACK_DECENT*4)
	w_class = WEIGHT_CLASS_NORMAL
	tastes = list("unflavored gelatine" = 1)
	foodtype = MEAT | SUGAR
	slice_batch = TRUE
	slice_sound = TRUE
	eat_effect = /datum/status_effect/debuff/uncookedfood
	rotprocess = null
	bitesize = 4
	faretype = FARE_POOR

/obj/item/reagent_containers/food/snacks/jellyslice_base
	name = "plain gelatine slice"
	icon_state = "basegelatinslice"
	dropshrink = 0.8
	slices_num = 0
	bitesize = 2
	list_reagents = list(/datum/reagent/consumable/nutriment = SNACK_DECENT)
	tastes = list("unflavored gelatine" = 1)
	eat_effect = /datum/status_effect/debuff/uncookedfood
	w_class = WEIGHT_CLASS_NORMAL
	foodtype = MEAT | SUGAR
	rotprocess = null
	faretype = FARE_POOR

// -------------- Apple Gelatine -----------------

/obj/item/reagent_containers/food/snacks/jellycake_apple
	name = "apple gelatine cake"
	desc = "A mildly unappetising desert, fittingly considered a delicacy by orcs. This one is colored blood(apple)-red."
	icon_state = "applegelatinecake"
	dropshrink = 0.8
	slice_path = /obj/item/reagent_containers/food/snacks/jellyslice_apple
	slices_num = 4
	list_reagents = list(/datum/reagent/consumable/nutriment = SNACK_DECENT*4)
	w_class = WEIGHT_CLASS_NORMAL
	tastes = list("sweet gelatine" = 1, "sweet apple"  = 1)
	foodtype = MEAT | SUGAR | FRUIT
	slice_batch = TRUE
	slice_sound = TRUE
	eat_effect = /datum/status_effect/buff/foodbuff
	rotprocess = null
	bitesize = 4
	faretype = FARE_FINE

/obj/item/reagent_containers/food/snacks/jellyslice_apple
	name = "apple gelatine slice"
	icon_state = "applegelatineslice"
	dropshrink = 0.8
	slices_num = 0
	bitesize = 2
	list_reagents = list(/datum/reagent/consumable/nutriment = SNACK_DECENT)
	tastes = list("sweet gelatine" = 1, "sweet apple" = 1)
	w_class = WEIGHT_CLASS_NORMAL
	foodtype = MEAT | SUGAR | FRUIT
	rotprocess = null
	faretype = FARE_FINE

// -------------- Tangeringe Gelatine -----------------

/obj/item/reagent_containers/food/snacks/jellycake_tangerine
	name = "tangerine gelatine cake"
	desc = "A mildly unappetising desert, fittingly considered a delicacy by orcs. This one is bittersweet, like the triumph of battle."
	icon_state = "tangerinegelatinecake"
	dropshrink = 0.8
	slice_path = /obj/item/reagent_containers/food/snacks/jellyslice_tangerine
	slices_num = 4
	list_reagents = list(/datum/reagent/consumable/nutriment = SNACK_DECENT*4)
	w_class = WEIGHT_CLASS_NORMAL
	tastes = list("sweet gelatine" = 1, "sweet tangerine" = 1)
	foodtype = MEAT | SUGAR | FRUIT
	slice_batch = TRUE
	slice_sound = TRUE
	eat_effect = /datum/status_effect/buff/foodbuff
	rotprocess = null
	bitesize = 4
	faretype = FARE_FINE

/obj/item/reagent_containers/food/snacks/jellyslice_tangerine
	name = "tangerine gelatine slice"
	icon_state = "tangerinegelatineslice"
	dropshrink = 0.8
	slices_num = 0
	bitesize = 2
	list_reagents = list(/datum/reagent/consumable/nutriment = SNACK_DECENT)
	tastes = list("sweet gelatine" = 1, "sweet tangerine")
	w_class = WEIGHT_CLASS_NORMAL
	foodtype = MEAT | SUGAR | FRUIT
	rotprocess = null
	faretype = FARE_FINE

// -------------- Plum Gelatine -----------------

/obj/item/reagent_containers/food/snacks/jellycake_plum
	name = "plum gelatine cake"
	desc = "A mildly unappetising desert, fittingly considered a delicacy by orcs. Like the plum this treat is made from, orcs persevere against all."
	icon_state = "plumgelatinecake"
	dropshrink = 0.8
	slice_path = /obj/item/reagent_containers/food/snacks/jellyslice_plum
	slices_num = 4
	list_reagents = list(/datum/reagent/consumable/nutriment = SNACK_DECENT*4)
	w_class = WEIGHT_CLASS_NORMAL
	tastes = list("sweet gelatine" = 1, "sweet plum" = 1)
	foodtype = MEAT | SUGAR | FRUIT
	slice_batch = TRUE
	slice_sound = TRUE
	eat_effect = /datum/status_effect/buff/foodbuff
	rotprocess = null
	bitesize = 4
	faretype = FARE_FINE

/obj/item/reagent_containers/food/snacks/jellyslice_plum
	name = "plum gelatine slice"
	icon_state = "plumgelatineslice"
	dropshrink = 0.8
	slices_num = 0
	bitesize = 2
	list_reagents = list(/datum/reagent/consumable/nutriment = SNACK_DECENT)
	tastes = list("sweet gelatine" = 1, "sweet plum")
	w_class = WEIGHT_CLASS_NORMAL
	foodtype = MEAT | SUGAR | FRUIT
	rotprocess = null
	faretype = FARE_FINE

// -------------- Lime Gelatine -----------------

/obj/item/reagent_containers/food/snacks/jellycake_lime
	name = "lime gelatine cake"
	desc = "A mildly unappetising desert, fittingly considered a delicacy by orcs. This one is green, naturally."
	icon_state = "limegelatinecake"
	dropshrink = 0.8
	slice_path = /obj/item/reagent_containers/food/snacks/jellyslice_lime
	slices_num = 4
	list_reagents = list(/datum/reagent/consumable/nutriment = SNACK_DECENT*4)
	w_class = WEIGHT_CLASS_NORMAL
	tastes = list("sweet gelatine" = 1, "sweet lime" = 1)
	foodtype = MEAT | SUGAR | FRUIT
	slice_batch = TRUE
	slice_sound = TRUE
	eat_effect = /datum/status_effect/buff/foodbuff
	rotprocess = null
	bitesize = 4
	faretype = FARE_FINE

/obj/item/reagent_containers/food/snacks/jellyslice_lime
	name = "lime gelatine slice"
	icon_state = "limegelatineslice"
	dropshrink = 0.8
	slices_num = 0
	bitesize = 2
	list_reagents = list(/datum/reagent/consumable/nutriment = SNACK_DECENT)
	tastes = list("sweet gelatine" = 1, "sweet lime")
	w_class = WEIGHT_CLASS_NORMAL
	foodtype = MEAT | SUGAR | FRUIT
	rotprocess = null
	faretype = FARE_FINE

// -------------- Pear Gelatine -----------------

/obj/item/reagent_containers/food/snacks/jellycake_pear
	name = "pear gelatine cake"
	desc = "A mildly unappetising dessert, fittingly considered a delicacy by orcs. This flavor is a strange fusion of Zalad and Orcish cuisines."
	icon_state = "peargelatinecake"
	dropshrink = 0.8
	slice_path = /obj/item/reagent_containers/food/snacks/jellyslice_pear
	slices_num = 4
	list_reagents = list(/datum/reagent/consumable/nutriment = SNACK_DECENT*4)
	w_class = WEIGHT_CLASS_NORMAL
	tastes = list("sweet gelatine" = 1, "sweet pear" = 1)
	foodtype = MEAT | SUGAR | FRUIT
	slice_batch = TRUE
	slice_sound = TRUE
	eat_effect = /datum/status_effect/buff/foodbuff
	rotprocess = null
	bitesize = 4
	faretype = FARE_FINE

/obj/item/reagent_containers/food/snacks/jellyslice_pear
	name = "pear gelatine slice"
	icon_state = "peargelatineslice"
	dropshrink = 0.8
	slices_num = 0
	bitesize = 2
	list_reagents = list(/datum/reagent/consumable/nutriment = SNACK_DECENT)
	tastes = list("sweet gelatine" = 1, "sweet pear")
	w_class = WEIGHT_CLASS_NORMAL
	foodtype = MEAT | SUGAR | FRUIT
	rotprocess = null
	faretype = FARE_FINE
