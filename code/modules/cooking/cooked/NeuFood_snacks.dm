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
	slices_num = 0
	foodtype = MEAT
	nutrition = COOKED_MEAT_NUTRITION
	rotprocess = SHELFLIFE_DECENT
	faretype = FARE_NEUTRAL

/obj/item/reagent_containers/food/snacks/cooked/frysteak_tatos
	name = "frysteak and potato"
	desc = "A slab of beastflesh, fried to a perfect medium-rare. Served with potatos, this will nourish even a starving volf."
	icon_state = "potatosteak"
	base_icon_state = "potatosteak"
	faretype = FARE_NEUTRAL
	portable = FALSE
	biting = TRUE
	eat_effect = null
	tastes = list("roasted meat" = 2, "potato" = 1)
	slices_num = 0
	faretype = FARE_NEUTRAL
	modified = TRUE
	rotprocess = SHELFLIFE_DECENT
	bitesize = 4
	nutrition = COOKED_MEAT_NUTRITION + COOKED_VEGGIE_NUTRITION + 1
	foodtype = MEAT | VEGETABLES

/obj/item/reagent_containers/food/snacks/cooked/frysteak_onion
	name = "frysteak and onions"
	desc = "A slab of beastflesh, fried to a perfect medium-rare. Garnished with tender fried onion, juices made into a simple sauce."
	icon_state = "onionsteak"
	base_icon_state = "onionsteak"
	faretype = FARE_NEUTRAL
	portable = FALSE
	nutrition = COOKED_MEAT_NUTRITION + COOKED_VEGGIE_NUTRITION + 1
	biting = TRUE
	eat_effect = null
	tastes = list("roasted meat" = 1, "caramelized onions" = 1)
	slices_num = 0
	modified = TRUE
	rotprocess = SHELFLIFE_DECENT
	bitesize = 5
	nutrition = COOKED_MEAT_NUTRITION + COOKED_VEGGIE_NUTRITION + 1
	foodtype = MEAT | VEGETABLES

/obj/item/reagent_containers/food/snacks/cooked/frysteak/attackby(obj/item/I, mob/living/user, list/modifiers)
	if(user.mind)
		short_cooktime = (50 - ((GET_MOB_SKILL_VALUE_OLD(user, /datum/attribute/skill/craft/cooking))*8))
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
			user.mind.add_sleep_experience(/datum/attribute/skill/craft/cooking, (GET_MOB_ATTRIBUTE_VALUE(user, STAT_INTELLIGENCE)*0.5))
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
	slices_num = 0
	rotprocess = SHELFLIFE_DECENT
	faretype = FARE_NEUTRAL
	nutrition = COOKED_MEAT_NUTRITION + COOKED_VEGGIE_NUTRITION
	foodtype = MEAT | VEGETABLES

/obj/item/reagent_containers/food/snacks/cooked/herbsteak/update_overlays()
	. = ..()
	. += mutable_appearance('icons/roguetown/items/food.dmi', "frysteak_spice")

/obj/item/reagent_containers/food/snacks/cooked/herbsteak/Initialize()
	. = ..()
	update_appearance(UPDATE_OVERLAYS)

/obj/item/reagent_containers/food/snacks/cooked/frysteak_salsa
	name = "frysteak and drowsbane"
	desc = "A slab of beastflesh, fried to a perfect medium-rare. It has been seasoned with highly-spicy drowsbane."
	icon_state = "steak_salsa"
	eat_effect = null
	tastes = list("warm steak" = 1, "infernal spice" = 1)
	slices_num = 0
	foodtype = MEAT | VEGETABLES
	nutrition = COOKED_MEAT_NUTRITION + COOKED_VEGGIE_NUTRITION
	rotprocess = SHELFLIFE_DECENT
	faretype = FARE_NEUTRAL
	list_reagents = list(/datum/reagent/drowsbane = 10)

/*	.............   Ribs   ................ */

/obj/item/reagent_containers/food/snacks/bread/ribrack //I KNOW it's stupid that this is a bread subtype, but this is easier than copying the whole slicing nonsense.
	name = "cooked rib rack"
	desc = "Meat that's still attatched to the bone, so you can both feel like a beast AND keep your fingers clean."
	icon_state = "ribs"
	base_icon_state = "ribs"
	dropshrink = 1
	slice_path = /obj/item/reagent_containers/food/snacks/cooked/rib
	drop_sound = 'sound/foley/dropsound/food_drop.ogg'
	w_class = WEIGHT_CLASS_NORMAL
	slice_batch = FALSE
	slice_sound = TRUE

	nutrition = COOKED_MEAT_NUTRITION
	faretype = FARE_NEUTRAL
	rotprocess = SHELFLIFE_DECENT
	foodtype = MEAT
	tastes = list("supple cooked meat" = 1)

/obj/item/reagent_containers/food/snacks/cooked/rib
	name = "rib"
	desc = "A single rib, the meat easily falls off the bone."
	icon_state = "ribs_slice"
	eat_effect = null
	dropshrink = 0.8
	tastes = list("supple cooked meat" = 1)
	slices_num = 0
	foodtype = MEAT
	nutrition = COOKED_MEAT_NUTRITION/6
	rotprocess = SHELFLIFE_DECENT
	faretype = FARE_NEUTRAL

/obj/item/reagent_containers/food/snacks/bread/ribrack/honey
	name = "glazed rib rack"
	desc = "Sometimes even Graggarites want some luxury."
	icon_state = "honey_ribs"
	base_icon_state = "honey_ribs"
	slice_path = /obj/item/reagent_containers/food/snacks/cooked/rib/honey

	nutrition = COOKED_MEAT_NUTRITION + HONEY_NUTRITION
	faretype = FARE_FINE
	foodtype = MEAT | SUGAR
	tastes = list("supple cooked meat" = 1, "honey glaze" = 1)

/obj/item/reagent_containers/food/snacks/cooked/rib/honey
	name = "glazed rib"
	desc = "A single glazed rib, the meat easily falls off the bone."
	icon_state = "honey_ribs_slice"
	tastes = list("supple cooked meat" = 1)
	foodtype = MEAT | SUGAR
	nutrition = (COOKED_MEAT_NUTRITION + HONEY_NUTRITION)/6
	rotprocess = SHELFLIFE_DECENT
	faretype = FARE_FINE

/*	.............   Fried egg   ................ */
/obj/item/reagent_containers/food/snacks/cooked/egg
	tastes = list("fried egg" = 1)
	name = "fried egg"
	desc = "A staple of Astratan midsummer festival eating."
	icon_state = "friedegg"
	base_icon_state = "friedegg"
	biting = TRUE
	nutrition = EGG_NUTRITION*COOK_MOD
	foodtype = EGG

/obj/item/reagent_containers/food/snacks/cooked/twin_egg
	tastes = list("fried egg" = 1)
	name = "fried egg twins"
	desc = "A staple of Astratan midsummer festival eating. There are two of them."
	icon_state = "seggs"
	base_icon_state = "seggs"
	biting = TRUE
	nutrition = EGG_NUTRITION*2*COOK_MOD
	foodtype = EGG

/obj/item/reagent_containers/food/snacks/cooked/valorian_omlette
	name = "valorian omelette"
	desc = "Fried cackleberries on a bed of half-melted cheese, a dish from distant lands."
	tastes = list("fried cackleberries" = 1, "cheese" = 1)
	icon_state = "omelette"
	base_icon_state = "omelette"
	faretype = FARE_FINE
	portable = FALSE
	modified = TRUE
	rotprocess = SHELFLIFE_DECENT
	bitesize = 5
	nutrition = (EGG_NUTRITION*2 + CHEESE_NUTRITION)*COOK_MOD
	foodtype = EGG | DAIRY
	eat_effect = /datum/status_effect/buff/foodbuff

/*	.............   Caravaneer's Omelette   ................ */
/obj/item/reagent_containers/food/snacks/comelette_base
	name = "omelette base"
	desc = "All it needs now is some potato slices, for a perfect texture."
	icon_state = "comelette_base"
	foodtype = EGG | RAW
	rotprocess = SHELFLIFE_DECENT
	faretype = FARE_IMPOVERISHED

/obj/item/reagent_containers/food/snacks/comelette_uncooked
	name = "uncooked caravaneer's omelette"
	desc = "Eggs and potatoes in alternating tiers, could do with some meat or onions, or a bit of time in the oven."
	icon_state = "comelette_raw"
	foodtype = EGG | VEGETABLES | RAW
	rotprocess = SHELFLIFE_DECENT
	faretype = FARE_IMPOVERISHED

/obj/item/reagent_containers/food/snacks/cooked/comelette
	name = "caraveneer's omelette"
	desc = "The very best breakfast for sharing amongst family and friends."
	tastes = list("fried cackleberries" = 1, "potato" = 1)
	icon_state = "comelette"
	faretype = FARE_NEUTRAL
	modified = TRUE
	rotprocess = SHELFLIFE_LONG
	bitesize = 6
	slices_num = 6
	slice_path = /obj/item/reagent_containers/food/snacks/comelette_slice
	slice_batch = TRUE
	slice_sound = TRUE
	nutrition = (EGG_NUTRITION*2 + VEGGIE_NUTRITION)*COOK_MOD
	foodtype = EGG | VEGETABLES
	eat_effect = /datum/status_effect/buff/foodbuff

/obj/item/reagent_containers/food/snacks/comelette_slice
	name = "caravaneer's omelette slice"
	icon_state = "comelette_slice"
	dropshrink = 0.8
	slices_num = 0
	bitesize = 3
	tastes = list("fried cackleberries" = 1, "potato" = 1)
	w_class = WEIGHT_CLASS_NORMAL
	eat_effect = /datum/status_effect/buff/foodbuff
	nutrition = ((EGG_NUTRITION*2 + VEGGIE_NUTRITION*2)*COOK_MOD)/6
	rotprocess = SHELFLIFE_LONG
	faretype = FARE_FINE
	foodtype = EGG | VEGETABLES

/*	.............   Veggie Caravaneer's Omelette   ................ */

/obj/item/reagent_containers/food/snacks/comelette_uncooked/veggie
	name = "uncooked veggie caravaneer's omelette"
	desc = "Eggs and potatoes in alternating tiers, could do with a bit of time in the oven."
	icon_state = "veggie_comelette_raw"
	foodtype = EGG | VEGETABLES | RAW
	rotprocess = SHELFLIFE_DECENT
	faretype = FARE_IMPOVERISHED

/obj/item/reagent_containers/food/snacks/cooked/comelette/veggie
	name = "caraveneer's omelette"
	desc = "The very best breakfast for sharing amongst family and friends, with extra bits of onion."
	tastes = list("fried cackleberries" = 1, "potato" = 1, "caramalized onions" = 1)
	icon_state = "veggie_comelette"
	faretype = FARE_FINE
	slice_path = /obj/item/reagent_containers/food/snacks/comelette_slice/veggie
	nutrition = (EGG_NUTRITION*2 + VEGGIE_NUTRITION*2)*COOK_MOD

/obj/item/reagent_containers/food/snacks/comelette_slice/veggie
	name = "caravaneer's omelette slice"
	icon_state = "veggie_comelette_slice"
	dropshrink = 0.8
	slices_num = 0
	bitesize = 3
	tastes = list("fried cackleberries" = 1, "potato" = 1, "caramalized onions" = 1)
	nutrition = ((EGG_NUTRITION*2 + VEGGIE_NUTRITION*2)*COOK_MOD)/6
	faretype = FARE_FINE

/*	.............   Meat Caravaneer's Omelette   ................ */

/obj/item/reagent_containers/food/snacks/comelette_uncooked/meat
	name = "uncooked meat caravaneer's omelette"
	desc = "Eggs and potatoes in alternating tiers, could do with a bit of time in the oven."
	icon_state = "meat_comelette_raw"
	foodtype = EGG | VEGETABLES | MEAT | RAW
	rotprocess = SHELFLIFE_DECENT
	faretype = FARE_IMPOVERISHED

/obj/item/reagent_containers/food/snacks/cooked/comelette/meat
	name = "caraveneer's omelette"
	desc = "The very best breakfast for sharing amongst family and friends, with little bits of meat."
	tastes = list("fried cackleberries" = 1, "potato" = 1, "succulant meat" = 1)
	icon_state = "meat_comelette"
	faretype = FARE_FINE
	slice_path = /obj/item/reagent_containers/food/snacks/comelette_slice/meat
	nutrition = (EGG_NUTRITION*2 + VEGGIE_NUTRITION + MINCE_NUTRITION)*COOK_MOD
	foodtype = EGG | VEGETABLES | MEAT

/obj/item/reagent_containers/food/snacks/comelette_slice/meat
	name = "caravaneer's omelette slice"
	icon_state = "meat_comelette_slice"
	dropshrink = 0.8
	slices_num = 0
	bitesize = 3
	tastes = list("fried cackleberries" = 1, "potato" = 1, "succulant meat" = 1)
	nutrition = ((EGG_NUTRITION*2 + VEGGIE_NUTRITION + MINCE_NUTRITION)*COOK_MOD)/6
	faretype = FARE_FINE
	foodtype = EGG | VEGETABLES | MEAT

/*	.............   Frybird   ................ */
/obj/item/reagent_containers/food/snacks/cooked/frybird
	name = "frybird"
	desc = "Poultry scorched to a perfect delicious crisp."
	icon_state = "frybird"
	base_icon_state = "frybird"
	tastes = list("frybird" = 1)
	biting = TRUE
	nutrition = COOKED_MEAT_NUTRITION
	foodtype = MEAT

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
	nutrition = (RAWMEAT_NUTRITION + VEGGIE_NUTRITION + 1)*COOK_MOD
	foodtype = MEAT|VEGETABLES
	eat_effect = /datum/status_effect/buff/foodbuff


/obj/item/reagent_containers/food/snacks/cooked/herbbird
	name = "herbird"//yes it's meant to be herb-ird, because herbbird is a bit weird
	desc = "Poultry scorched to a perfect delicious crisp. It has been seasoned with herbs."
	icon_state = "frybird"
	base_icon_state = "frybird"
	biting = TRUE
	modified = TRUE
	eat_effect = /datum/status_effect/buff/foodbuff
	tastes = list("frybird" = 1, "herbs" = 1)
	nutrition = (RAWMEAT_NUTRITION + 1)*COOK_MOD + 1
	foodtype = MEAT|VEGETABLES
	eat_effect = /datum/status_effect/buff/foodbuff
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
	faretype = FARE_FINE
	nutrition = COOKED_FATTYMEAT_NUTRITION

/obj/item/reagent_containers/food/snacks/cooked/royal_truffle
	name = "royal truffles"
	desc = "The height of decadence, a precious truffle pig, turned into an amusing meal, served on a bed of its beloved golden truffles."
	icon_state = "royaltruffles"
	base_icon_state = "royaltruffles"
	tastes = list("salted ham" = 1, "divine truffles" = 1)
	biting = TRUE
	filling_color = "#8a0000"
	become_rot_type = /obj/item/reagent_containers/food/snacks/rotten/bacon
	faretype = FARE_FINE
	modified = TRUE
	rotprocess = SHELFLIFE_DECENT
	bitesize = 5
	nutrition = COOKED_FATTYMEAT_NUTRITION+COOKED_VEGGIE_NUTRITION

/*	.............   Frything   ................ */
/obj/item/reagent_containers/food/snacks/cooked/strange
	name = "fried strange meat"
	desc = "Whatever it was, it's roasted."
	icon_state = "fried_strange"
	base_icon_state = "fried_strange"
	biting = TRUE
	faretype = FARE_POOR
	nutrition = COOKED_MEAT_NUTRITION * 0.5

/*---------------\
| Sausage snacks |
\---------------*/

/*	.............   Sausage & Wiener   ................ */
/obj/item/reagent_containers/food/snacks/cooked/sausage
	name = "sausage"
	desc = "Delicious flesh stuffed in an intestine casing."
	icon_state = "wiener"
	base_icon_state = "wiener"
	nutrition = COOKED_SAUSAGE_NUTRITION+COOKED_VEGGIE_NUTRITION
	tastes = list("savory sausage" = 2)
	rotprocess = SHELFLIFE_EXTREME
	biting = TRUE
	faretype = FARE_NEUTRAL

/obj/item/reagent_containers/food/snacks/cooked/sausage_cabbage
	name = "wiener on cabbage"
	desc = "A rich and heavy meal, perfect ration for a soldier on the march."
	icon_state = "wienercabbage"
	base_icon_state = "wienercabbage"
	nutrition = COOKED_SAUSAGE_NUTRITION+COOKED_VEGGIE_NUTRITION
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
	nutrition = COOKED_SAUSAGE_NUTRITION+COOKED_VEGGIE_NUTRITION
	tastes = list("fried potato" = 1)
	foodtype = VEGETABLES | MEAT
	faretype = FARE_NEUTRAL
	modified = TRUE
	rotprocess = SHELFLIFE_DECENT
	bitesize = 5

/obj/item/reagent_containers/food/snacks/cooked/sausage_cocaumole
	name = "wiener with cocaumole"
	desc = "Stout and savory."
	icon_state = "wiener_cocaumole"
	nutrition = COOKED_SAUSAGE_NUTRITION+COOKED_VEGGIE_NUTRITION
	tastes = list("savory goo" = 1)
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
	nutrition = COOKED_SAUSAGE_NUTRITION+COOKED_VEGGIE_NUTRITION
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
	nutrition = COOKED_SAUSAGE_NUTRITION
	tastes = list("grilled sausage" = 2)
	foodtype = MEAT
	faretype = FARE_NEUTRAL
	modified = TRUE
	portable = TRUE
	bitesize = 4

/obj/item/reagent_containers/food/snacks/cooked/sausage/wiener // wiener meant to be made from beef or maybe mince + bacon, luxury sausage, not implemented yet
	name = "wiener"
	nutrition = COOKED_FATTYMEAT_NUTRITION

/*	.............   Sausages on sticks   ................ */
/obj/item/reagent_containers/food/snacks/cooked/sausage_sticked
	name = "sausage onna stick"
	desc = "A sausage skewered for convenience and cleanliness, classic Grenzelhoftian street food."
	nutrition = COOKED_SAUSAGE_NUTRITION
	icon_state = "sausageonastick"
	tastes = list("savory sausage" = 2)
	trash = /obj/item/grown/log/tree/stick
	rotprocess = SHELFLIFE_EXTREME
	faretype = FARE_NEUTRAL
	foodtype = MEAT

/obj/item/reagent_containers/food/snacks/foodbase/griddledog_raw
	name = "uncooked griddledog"
	desc = "A sausage covered with dough, begging to be fried."
	nutrition = RAWMEAT_NUTRITION + BUTTERDOUGHSLICE_NUTRITION
	icon_state = "rawgriddledog"
	tastes = list("savory sausage" = 2, "butterdough" = 1)
	trash = /obj/item/grown/log/tree/stick
	rotprocess = SHELFLIFE_EXTREME
	faretype = FARE_POOR
	foodtype = GRAIN | MEAT | RAW

/obj/item/reagent_containers/food/snacks/cooked/griddledog
	name = "griddledog"
	desc = "A classic piece of Grenzelhoftian street food, the fried butterdough is a Vanderlinian adulteration."
	nutrition = COOKED_SAUSAGE_NUTRITION + BUTTERDOUGHSLICE_NUTRITION * COOK_MOD
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
	nutrition = COOKED_VEGGIE_NUTRITION
	foodtype = VEGETABLES
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
	nutrition = COOKED_VEGGIE_NUTRITION
	foodtype = VEGETABLES
	rotprocess = SHELFLIFE_LONG
	faretype = FARE_POOR

/*	.............   Fried onions   ................ */
/obj/item/reagent_containers/food/snacks/onion_fried
	name = "fried onion"
	desc = "Seared onions roasted to a delicious set of rings."
	icon_state = "onion_fried"
	base_icon_state = "onion_fried"
	biting = TRUE
	nutrition = COOKED_VEGGIE_NUTRITION
	foodtype = VEGETABLES
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
	nutrition = COOKED_VEGGIE_NUTRITION
	foodtype = VEGETABLES
	tastes = list("warm potato" = 1)
	rotprocess = SHELFLIFE_EXTREME
	faretype = FARE_NEUTRAL
	portable = FALSE

/*	.............   Grilled Sunreed   ................ */
/obj/item/reagent_containers/food/snacks/produce/vegetable/sunreed_cooked
	name = "grilled sunreed"
	desc = "Sunreed cooked to soften it somewhat."
	icon = 'icons/roguetown/items/food.dmi'
	icon_state = "maize_cooked"
	bitesize = 5
	nutrition = COOKED_VEGGIE_NUTRITION
	foodtype = VEGETABLES
	tastes = list("softened sunreed" = 1)
	rotprocess = SHELFLIFE_LONG
	faretype = FARE_NEUTRAL

/obj/item/reagent_containers/food/snacks/produce/vegetable/sunreed_cooked/attackby(obj/item/I, mob/living/user, list/modifiers)
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
	LAZYADDASSOC(bonus_reagents, /datum/reagent/consumable/nutriment, S.nutrition)
	tastes |= S.tastes
	desc = "[desc] Butter melts over the top."
	name = "buttered [name]"
	add_overlay("maize_buttered")
	qdel(I)
	return ..()

/*	.............   Cocaumole   ................ */

/obj/item/reagent_containers/food/snacks/cocaumole
	name = "cocaumole"
	icon_state = "cocaumole"
	desc = "The delicious gooey inside of a cocaudo. Makes for great topping."
	bitesize = 3
	slices_num = 3
	slice_batch = TRUE
	slice_sound = TRUE
	slice_path = /obj/item/reagent_containers/food/snacks/cocaumole/slice
	nutrition = COOKED_VEGGIE_NUTRITION
	foodtype = VEGETABLES
	tastes = list("savory goo" = 1)
	rotprocess = SHELFLIFE_DECENT
	faretype = FARE_NEUTRAL
	portable = FALSE

/obj/item/reagent_containers/food/snacks/cocaumole/slice
	name = "cocaumole slice"
	icon_state = "cocaumole_slice"
	bitesize = 1
	slices_num = null
	slice_batch = FALSE
	slice_path = null
	nutrition = COOKED_VEGGIE_NUTRITION/3

/*	.............   Drowsbane Jam   ................ */

/obj/item/reagent_containers/food/snacks/drowsbanejam
	name = "drowsbane jam"
	icon_state = "salsa"
	desc = "A tantalizingly spicy jam. Incredibly toxic to dark-elves."
	bitesize = 3
	slices_num = 3
	slice_batch = TRUE
	slice_sound = TRUE
	slice_path = /obj/item/reagent_containers/food/snacks/drowsbanejam/slice
	nutrition = COOKED_VEGGIE_NUTRITION
	foodtype = VEGETABLES
	tastes = list("infernal spice" = 1)
	rotprocess = SHELFLIFE_DECENT
	faretype = FARE_NEUTRAL
	portable = FALSE
	list_reagents = list(/datum/reagent/drowsbane = 10)

/obj/item/reagent_containers/food/snacks/drowsbanejam/slice
	name = "drowsbane jam slice"
	icon_state = "salsa_slice"
	bitesize = 1
	slices_num = 0
	slice_batch = FALSE
	nutrition = COOKED_VEGGIE_NUTRITION/3

/*	.............   Baked Pompkaun  ................ */
/obj/item/reagent_containers/food/snacks/fruit/pompkaun_goo/cooked
	name = "baked pompkaun goo"
	desc = "Mixed pompkaun goo and seeds, baked to perfection."
	icon = 'icons/roguetown/items/food.dmi'
	icon_state = "pompkaun_cooked"
	bitesize = 3
	nutrition = (FRUIT_NUTRITION) * COOK_MOD
	foodtype = FRUIT
	tastes = list("sweet pompkaun goo" = 1)
	rotprocess = SHELFLIFE_DECENT
	faretype = FARE_NEUTRAL
	portable = FALSE

/*-------\
| Salads |
\-------*/

/obj/item/reagent_containers/food/snacks/salad
	name = "salad"
	desc = "Cut fresh vegetables, loved by peasants and health-conscious nobles alike."
	icon = 'icons/roguetown/items/cooking.dmi' //This is so it can grab bowl sprites. Salad sprites are stored there also. Check bowl code in NeuFood.dm for details.
	icon_state = ""
	bitesize = 5
	dropshrink = 0.8
	nutrition = (VEGGIE_NUTRITION) * COOK_MOD
	foodtype = VEGETABLES
	trash = /obj/item/reagent_containers/glass/bowl
	tastes = list("fresh cabbage" = 1)
	rotprocess = null
	faretype = FARE_NEUTRAL
	portable = FALSE

/obj/item/reagent_containers/food/snacks/salad/attackby(obj/item/I, mob/living/user, list/modifiers)
	if(modified || !is_type_in_list(I, list(
		/obj/item/reagent_containers/food/snacks/onion_fried,
		/obj/item/reagent_containers/food/snacks/produce/vegetable/potato/fried,
		/obj/item/reagent_containers/food/snacks/cooked/frysteak,
		/obj/item/reagent_containers/food/snacks/produce/grain/sunreed,
		/obj/item/reagent_containers/food/snacks/fruit/tamto_slice)))
		return ..()
	var/obj/item/reagent_containers/food/snacks/S = I
	short_cooktime = (50 - ((GET_MOB_SKILL_VALUE_OLD(user, /datum/attribute/skill/craft/cooking))*8))
	playsound(user, 'sound/foley/chopping_block.ogg', 40, TRUE, -1)
	if(!do_after(user, short_cooktime, src, display_over_user=TRUE))
		return FALSE
	modified = TRUE
	user.mind.add_sleep_experience(/datum/attribute/skill/craft/cooking, (GET_MOB_ATTRIBUTE_VALUE(user, STAT_INTELLIGENCE)*0.5))
	user.nobles_seen_servant_work()
	S.reagents?.trans_to(src, S.reagents.total_volume)
	LAZYADDASSOC(bonus_reagents, /datum/reagent/consumable/nutriment, S.nutrition)
	tastes |= S.tastes
	foodtype |= S.foodtype
	faretype++

	if(istype(I, /obj/item/reagent_containers/food/snacks/onion_fried))
		name = "[name] with onions"
		desc = "[desc] Fried onions have been minced overtop."
		add_overlay("onion_salad")
	else if(istype(I, /obj/item/reagent_containers/food/snacks/produce/vegetable/potato/fried))
		name = "[name] with potatoes"
		desc = "[desc] Fried potato wedges have been placed overtop."
		add_overlay("potato_salad")
	else if(istype(I, /obj/item/reagent_containers/food/snacks/cooked/frysteak))
		name = "[name] with meat"
		desc = "[desc] Perhaps counterintuitively, frysteak has been chopped overtop."
		add_overlay("meat_salad")
	else if(istype(I, /obj/item/reagent_containers/food/snacks/produce/grain/sunreed)) //Of note, in cooking.dmi I have stored overlays for greyscaled fruit and dressing. I've been coding this food so long, that I can't be bothered to add them. But YOU can. Credit for 7erracotta for the sprites.
		name = "[name] with sunreed"
		desc = "[desc] Crunchy sunreed has been scatered overtop."
		add_overlay("corn_salad")
	qdel(I)
	return ..()

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
	rotprocess = SHELFLIFE_LONG
	nutrition = COOKED_MEAT_NUTRITION * 2
	faretype = FARE_FINE
	portable = FALSE
	foodtype = MEAT

/obj/item/reagent_containers/food/snacks/cooked/roastchicken/attackby(obj/item/I, mob/living/user, list/modifiers)
	var/obj/item/reagent_containers/peppermill/mill = I
	if(user.mind)
		short_cooktime = (50 - ((GET_MOB_SKILL_VALUE_OLD(user, /datum/attribute/skill/craft/cooking))*8))
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
			user.mind.add_sleep_experience(/datum/attribute/skill/craft/cooking, (GET_MOB_ATTRIBUTE_VALUE(user, STAT_INTELLIGENCE)*0.5))
			user.nobles_seen_servant_work()
	return ..()
