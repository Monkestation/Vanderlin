/* * * * * * * * * * * **
 *						*
 *		 NeuFood		*	- Defined as edible food that can't be plated and ideally can be made in rough conditions, generally less nutritious
 *		 (Snacks)		*
 *						*
 * * * * * * * * * * * **/


/*	.............   Frysteak   ................ */
/obj/item/reagent_containers/food/snacks/cooked/frysteak
	name = "frysteak"
	desc = "A slab of beastflesh, fried to a perfect medium-rare."
	icon_state = "frysteak"
	base_icon_state = "frysteak"
	biting = TRUE
	eat_effect = null
	tastes = list("warm steak" = 1)
	list_reagents = list(/datum/reagent/consumable/nutriment = COOKED_MEAT_NUTRITION)
	slices_num = 0
	rotprocess = SHELFLIFE_DECENT
	faretype = FARE_NEUTRAL

/obj/item/reagent_containers/food/snacks/cooked/frysteak_tatos
	name = "frysteak and potato"
	desc = "A slab of beastflesh, fried to a perfect medium-rare. Served with potatos, this will nourish even a starving volf."
	icon_state = "potatosteak"
	base_icon_state = "potatosteak"
	faretype = FARE_NEUTRAL
	portable = FALSE
	list_reagents = list(/datum/reagent/consumable/nutriment = COOKED_MEAT_NUTRITION+FRYVEGGIE_NUTRITION+3)
	biting = TRUE
	eat_effect = null
	tastes = list("roasted meat" = 2, "potato" = 1)
	slices_num = 0
	faretype = FARE_NEUTRAL
	modified = TRUE
	rotprocess = SHELFLIFE_DECENT
	bitesize = 4

/obj/item/reagent_containers/food/snacks/cooked/frysteak_onion
	name = "frysteak and onions"
	desc = "A slab of beastflesh, fried to a perfect medium-rare. Garnished with tender fried onion, juices made into a simple sauce."
	icon_state = "onionsteak"
	base_icon_state = "onionsteak"
	faretype = FARE_NEUTRAL
	portable = FALSE
	list_reagents = list(/datum/reagent/consumable/nutriment = COOKED_MEAT_NUTRITION+FRYVEGGIE_NUTRITION+1)
	biting = TRUE
	eat_effect = null
	tastes = list("roasted meat" = 1, "caramelized onions" = 1)
	slices_num = 0
	modified = TRUE
	rotprocess = SHELFLIFE_DECENT
	bitesize = 5

/obj/item/reagent_containers/food/snacks/cooked/frysteak/attackby(obj/item/I, mob/living/user, list/modifiers)
	if(user.mind)
		short_cooktime = (50 - ((user.get_skill_level(/datum/skill/craft/cooking, TRUE))*8))
	if(modified)
		return TRUE
	if(bitecount >0)
		to_chat(user, span_warning("Leftovers aren't suitable for this."))
		return TRUE
	var/obj/item/reagent_containers/peppermill/mill = I
	if(istype(mill) && (!modified))
		if(!mill.reagents.has_reagent(/datum/reagent/consumable/blackpepper, 1))
			to_chat(user, "There's not enough black pepper to make anything with.")
			return TRUE
		mill.icon_state = "peppermill_grind"
		to_chat(user, "You start rubbing the steak with black pepper.")
		playsound(user, 'sound/foley/peppermill.ogg', 100, TRUE, -1)
		if(do_after(user, 3 SECONDS, src))
			if(!mill.reagents.has_reagent(/datum/reagent/consumable/blackpepper, 1))
				to_chat(user, "There's not enough black pepper to make anything with.")
				return TRUE
			mill.reagents.remove_reagent(/datum/reagent/consumable/blackpepper, 1)
			name = "peppersteak"
			desc = "Roasted flesh flanked with a generous coating of ground pepper for intense flavor."
			faretype = FARE_FINE
			portable = FALSE
			var/mutable_appearance/spice = mutable_appearance('icons/roguetown/items/food.dmi', "frysteak_spice")
			overlays += spice
			tastes = list("spicy red meat" = 2)
			meal_properties()
			bitesize = initial(bitesize)
			user.mind.add_sleep_experience(/datum/skill/craft/cooking, (user.STAINT*0.5))
			user.nobles_seen_servant_work()
	return ..()

/obj/item/reagent_containers/food/snacks/cooked/herbsteak
	name = "herbsteak"
	desc = "A slab of beastflesh, fried to a perfect medium-rare. It has been seasoned with herbs."
	icon_state = "frysteak"
	base_icon_state = "frysteak"
	biting = TRUE
	eat_effect = /datum/status_effect/buff/foodbuff
	tastes = list("warm steak" = 1, "herbs" = 1)
	list_reagents = list(/datum/reagent/consumable/nutriment = COOKED_MEAT_NUTRITION+2)
	slices_num = 0
	rotprocess = SHELFLIFE_DECENT
	faretype = FARE_NEUTRAL

/obj/item/reagent_containers/food/snacks/cooked/herbsteak/update_overlays()
	. = ..()
	. += mutable_appearance('icons/roguetown/items/food.dmi', "frysteak_spice")

/obj/item/reagent_containers/food/snacks/cooked/herbsteak/Initialize()
	. = ..()
	update_appearance(UPDATE_OVERLAYS)

/*	.............   Fried egg   ................ */
/obj/item/reagent_containers/food/snacks/cooked/egg
	list_reagents = list(/datum/reagent/consumable/nutriment = EGG_NUTRITION)
	tastes = list("fried egg" = 1)
	name = "fried egg"
	desc = "A staple of Astratan midsummer festival eating."
	icon_state = "friedegg"
	base_icon_state = "friedegg"
	biting = TRUE

/obj/item/reagent_containers/food/snacks/cooked/twin_egg
	list_reagents = list(/datum/reagent/consumable/nutriment = EGG_NUTRITION+EGG_NUTRITION)
	tastes = list("fried egg" = 1)
	name = "fried egg twins"
	desc = "A staple of Astratan midsummer festival eating. There are two of them."
	icon_state = "seggs"
	base_icon_state = "seggs"
	biting = TRUE

/obj/item/reagent_containers/food/snacks/cooked/valorian_omlette
	name = "valorian omelette"
	desc = "Fried cackleberries on a bed of half-melted cheese, a dish from distant lands."
	list_reagents = list(/datum/reagent/consumable/nutriment = EGG_NUTRITION+EGG_NUTRITION+CHEESE_NUTRITION+1)
	tastes = list("fried cackleberries" = 1, "cheese" = 1)
	icon_state = "omelette"
	base_icon_state = "omelette"
	faretype = FARE_FINE
	portable = FALSE
	modified = TRUE
	rotprocess = SHELFLIFE_DECENT
	bitesize = 5

/*	.............   Frybird   ................ */
/obj/item/reagent_containers/food/snacks/cooked/frybird
	name = "frybird"
	desc = "Poultry scorched to a perfect delicious crisp."
	icon_state = "frybird"
	base_icon_state = "frybird"
	tastes = list("frybird" = 1)
	biting = TRUE

/obj/item/reagent_containers/food/snacks/cooked/frybird_tatos
	name = "frybird and tatos"
	desc = "Poultry scorched to a perfect delicious crisp. Some warm tatos accompany it."
	icon_state = "frybirdtato"
	base_icon_state = "frybirdtato"
	tastes = list("frybird" = 1, "warm tato" = 1)
	modified = TRUE
	biting = TRUE
	rotprocess = SHELFLIFE_DECENT
	bitesize = 5

/obj/item/reagent_containers/food/snacks/cooked/herbbird
	name = "herbird"//yes it's meant to be herb-ird, because herbbird is a bit weird
	desc = "Poultry scorched to a perfect delicious crisp. It has been seasoned with herbs."
	icon_state = "frybird"
	base_icon_state = "frybird"
	biting = TRUE
	modified = TRUE
	eat_effect = /datum/status_effect/buff/foodbuff
	tastes = list("frybird" = 1, "herbs" = 1)
	list_reagents = list(/datum/reagent/consumable/nutriment = COOKED_MEAT_NUTRITION+2)
	slices_num = 0
	rotprocess = SHELFLIFE_DECENT
	faretype = FARE_NEUTRAL

/obj/item/reagent_containers/food/snacks/cooked/herbbird/update_overlays()
	. = ..()
	. += mutable_appearance('icons/roguetown/items/food.dmi', "roast_spice")

/obj/item/reagent_containers/food/snacks/cooked/herbbird/Initialize()
	. = ..()
	update_appearance(UPDATE_OVERLAYS)

/*	.............   Han   ................ */
/obj/item/reagent_containers/food/snacks/cooked/ham
	name = "ham"
	desc = "A trufflepig's retirement plan."
	icon_state = "ham"
	base_icon_state = "ham"
	biting = TRUE
	filling_color = "#8a0000"
	become_rot_type = /obj/item/reagent_containers/food/snacks/rotten/bacon
	list_reagents = list(/datum/reagent/consumable/nutriment = COOKED_MEAT_NUTRITION+1)
	faretype = FARE_FINE

/obj/item/reagent_containers/food/snacks/cooked/royal_truffle
	name = "royal truffles"
	desc = "The height of decadence, a precious truffle pig, turned into an amusing meal, served on a bed of its beloved golden truffles."
	icon_state = "royaltruffles"
	base_icon_state = "royaltruffles"
	list_reagents = list(/datum/reagent/consumable/nutriment = COOKED_MEAT_NUTRITION+COOKED_MEAT_NUTRITION+2)
	tastes = list("salted ham" = 1, "divine truffles" = 1)
	biting = TRUE
	filling_color = "#8a0000"
	become_rot_type = /obj/item/reagent_containers/food/snacks/rotten/bacon
	faretype = FARE_FINE
	modified = TRUE
	rotprocess = SHELFLIFE_DECENT
	bitesize = 5

/obj/item/reagent_containers/food/snacks/cooked/royal_truffle/toxin
	list_reagents = list(/datum/reagent/consumable/nutriment = COOKED_MEAT_NUTRITION, /datum/reagent/berrypoison = 10)



/*	.............   Frything   ................ */
/obj/item/reagent_containers/food/snacks/cooked/strange
	name = "fried strange meat"
	desc = "Whatever it was, it's roasted."
	icon_state = "fried_strange"
	base_icon_state = "fried_strange"
	list_reagents = list(/datum/reagent/consumable/nutriment = RAWMEAT_NUTRITION) // raw meat nutrition but without getting sick
	biting = TRUE
	faretype = FARE_POOR

/*---------------\
| Sausage snacks |
\---------------*/

/*	.............   Sausage & Wiener   ................ */
/obj/item/reagent_containers/food/snacks/cooked/sausage
	name = "sausage"
	desc = "Delicious flesh stuffed in an intestine casing."
	icon_state = "wiener"
	base_icon_state = "wiener"
	list_reagents = list(/datum/reagent/consumable/nutriment = SAUSAGE_NUTRITION)
	tastes = list("savory sausage" = 2)
	rotprocess = SHELFLIFE_EXTREME
	biting = TRUE
	faretype = FARE_NEUTRAL

/obj/item/reagent_containers/food/snacks/cooked/sausage_cabbage
	name = "wiener on cabbage"
	desc = "A rich and heavy meal, perfect ration for a soldier on the march."
	icon_state = "wienercabbage"
	base_icon_state = "wienercabbage"
	list_reagents = list(/datum/reagent/consumable/nutriment = SAUSAGE_NUTRITION + FRYVEGGIE_NUTRITION + 1)
	tastes = list("cabbage" = 1)
	foodtype = VEGETABLES | MEAT
	faretype = FARE_NEUTRAL
	modified = TRUE
	rotprocess = SHELFLIFE_DECENT
	bitesize = 5

/obj/item/reagent_containers/food/snacks/cooked/sausage_potato
	name = "wiener on tato"
	desc = "Stout and nourishing."
	icon_state = "wienerpotato"
	base_icon_state = "wienerpotato"
	list_reagents = list(/datum/reagent/consumable/nutriment = SAUSAGE_NUTRITION + FRYVEGGIE_NUTRITION + 2)
	tastes = list("fried potato" = 1)
	foodtype = VEGETABLES | MEAT
	faretype = FARE_NEUTRAL
	modified = TRUE
	rotprocess = SHELFLIFE_DECENT
	bitesize = 5

/obj/item/reagent_containers/food/snacks/cooked/sausage_onion
	name = "wiener and onions"
	desc = "Stout and flavourful."
	icon_state = "wieneronion"
	base_icon_state = "wieneronion"
	list_reagents = list(/datum/reagent/consumable/nutriment = SAUSAGE_NUTRITION + FRYVEGGIE_NUTRITION + 1)
	tastes = list("fried onions" = 1)
	foodtype = VEGETABLES | MEAT
	faretype = FARE_NEUTRAL
	modified = TRUE
	rotprocess = SHELFLIFE_DECENT
	bitesize = 5

/obj/item/reagent_containers/food/snacks/cooked/sausage_sticked
	name = "sausage on a stick"
	desc = "A meaty, portable snack perfect for campfires or fairs."
	icon_state = "wienerstick"
	base_icon_state = "wienerstick"
	list_reagents = list(/datum/reagent/consumable/nutriment = SAUSAGE_NUTRITION)
	tastes = list("grilled sausage" = 2)
	foodtype = MEAT
	faretype = FARE_NEUTRAL
	modified = TRUE
	portable = TRUE
	bitesize = 4

/obj/item/reagent_containers/food/snacks/cooked/sausage/wiener // wiener meant to be made from beef or maybe mince + bacon, luxury sausage, not implemented yet
	name = "wiener"
/*	.............   Sausages on sticks   ................ */
/obj/item/reagent_containers/food/snacks/cooked/sausage_sticked
	name = "sausage onna stick"
	desc = "A sausage skewered for convenience and cleanliness, classic Grenzelhoftian street food."
	list_reagents = list(/datum/reagent/consumable/nutriment = SAUSAGE_NUTRITION+1)
	icon_state = "sausageonastick"
	tastes = list("savory sausage" = 2)
	trash = /obj/item/grown/log/tree/stick
	rotprocess = SHELFLIFE_EXTREME
	faretype = FARE_NEUTRAL
	foodtype = MEAT

/obj/item/reagent_containers/food/snacks/foodbase/griddledog_raw
	name = "uncooked griddledog"
	desc = "A sausage covered with dough, begging to be fried."
	list_reagents = list(/datum/reagent/consumable/nutriment = SAUSAGE_NUTRITION+BUTTERDOUGHSLICE_NUTRITION)
	icon_state = "rawgriddledog"
	tastes = list("savory sausage" = 2, "butterdough" = 1)
	trash = /obj/item/grown/log/tree/stick
	rotprocess = SHELFLIFE_EXTREME
	faretype = FARE_POOR
	foodtype = GRAIN | MEAT

/obj/item/reagent_containers/food/snacks/cooked/griddledog
	name = "griddledog"
	desc = "A classic piece of Grenzelhoftian street food, the fried butterdough is a Vanderlinian adulteration."
	list_reagents = list(/datum/reagent/consumable/nutriment = SAUSAGE_NUTRITION+BUTTERDOUGHSLICE_NUTRITION+2)
	icon_state = "griddledog"
	tastes = list("savory sausage" = 2, "crispy butterdough" = 1)
	trash = /obj/item/grown/log/tree/stick
	rotprocess = SHELFLIFE_EXTREME
	faretype = FARE_FINE
	eat_effect = /datum/status_effect/buff/foodbuff
	foodtype = GRAIN | MEAT

/*---------------\
| Cooked veggies |
\---------------*/

/*	.............   Cooked cabbage   ................ */
/obj/item/reagent_containers/food/snacks/cabbage_fried
	name = "cooked cabbage"
	desc = "A peasant's delight."
	icon_state = "cabbage_fried"
	base_icon_state = "cabbage_fried"
	biting = TRUE
	list_reagents = list(/datum/reagent/consumable/nutriment = FRYVEGGIE_NUTRITION)
	tastes = list("warm cabbage" = 1)
	rotprocess = SHELFLIFE_LONG
	faretype = FARE_POOR
	portable = FALSE


/*	.............   Baked potato   ................ */
/obj/item/reagent_containers/food/snacks/produce/vegetable/potato/baked
	name = "baked potatos"
	desc = "A dwarven favorite, as a meal or a game of hot potato."
	icon = 'icons/roguetown/items/food.dmi'
	icon_state = "potato_baked"
	base_icon_state = "potato_baked"
	bitesize = 3
	biting = TRUE
	list_reagents = list(/datum/reagent/consumable/nutriment = FRYVEGGIE_NUTRITION)
	rotprocess = SHELFLIFE_LONG
	faretype = FARE_POOR

/*	.............   Fried onions   ................ */
/obj/item/reagent_containers/food/snacks/onion_fried
	name = "fried onion"
	desc = "Seared onions roasted to a delicious set of rings."
	icon_state = "onion_fried"
	base_icon_state = "onion_fried"
	biting = TRUE
	list_reagents = list(/datum/reagent/consumable/nutriment = FRYVEGGIE_NUTRITION)
	tastes = list("savoury morsel" = 1)
	rotprocess = SHELFLIFE_LONG
	faretype = FARE_POOR
	portable = FALSE

/*	.............   Fried potato   ................ */
/obj/item/reagent_containers/food/snacks/produce/vegetable/potato/fried
	name = "fried potato"
	desc = "Potato bits, well roasted."
	icon = 'icons/roguetown/items/food.dmi'
	icon_state = "potato_fried"
	base_icon_state = "potato_fried"
	bitesize = 3
	biting = TRUE
	list_reagents = list(/datum/reagent/consumable/nutriment = FRYVEGGIE_NUTRITION)
	tastes = list("warm potato" = 1)
	rotprocess = SHELFLIFE_EXTREME
	faretype = FARE_NEUTRAL
	portable = FALSE

/*---------------\
| Chicken meals |
\---------------*/

/*	.................   Chicken roast   ................... */
/obj/item/reagent_containers/food/snacks/cooked/roastchicken
	name = "roast bird"
	desc = "A plump bird, roasted to a perfect temperature and bears a crispy skin."
	icon_state = "roast"
	base_icon_state = "roast"
	tastes = list("tasty birdmeat" = 1)
	bitesize = 5
	biting = TRUE
	list_reagents = list(/datum/reagent/consumable/nutriment = COOKED_MEAT_NUTRITION+COOKED_MEAT_NUTRITION+1)
	rotprocess = SHELFLIFE_LONG
	faretype = FARE_FINE
	portable = FALSE

/obj/item/reagent_containers/food/snacks/cooked/roastchicken/attackby(obj/item/I, mob/living/user, list/modifiers)
	var/obj/item/reagent_containers/peppermill/mill = I
	if(user.mind)
		short_cooktime = (50 - ((user.get_skill_level(/datum/skill/craft/cooking, TRUE))*8))
	if(modified)
		return TRUE
	if(bitecount >0)
		to_chat(user, span_warning("Leftovers aren't suitable for this."))
		return TRUE
	else if(istype(mill))
		if(!mill.reagents.has_reagent(/datum/reagent/consumable/blackpepper, 1))
			to_chat(user, "There's not enough black pepper to make anything with.")
			return TRUE
		mill.icon_state = "peppermill_grind"
		to_chat(user, "You start rubbing the bird roast with black pepper.")
		playsound(user, 'sound/foley/peppermill.ogg', 100, TRUE, -1)
		if(do_after(user,3 SECONDS, src))
			if(!mill.reagents.has_reagent(/datum/reagent/consumable/blackpepper, 1))
				to_chat(user, "There's not enough black pepper to make anything with.")
				return TRUE
			mill.reagents.remove_reagent(/datum/reagent/consumable/blackpepper, 1)
			name = "spiced [name]"
			desc = "A plump bird, roasted to perfection, spiced to taste divine."
			faretype = FARE_LAVISH
			portable = FALSE
			var/mutable_appearance/spice = mutable_appearance('icons/roguetown/items/food.dmi', "roast_spice")
			overlays += spice
			tastes = list("spicy birdmeat" = 2)
			modified = TRUE
			user.mind.add_sleep_experience(/datum/skill/craft/cooking, (user.STAINT*0.5))
			user.nobles_seen_servant_work()
	return ..()
