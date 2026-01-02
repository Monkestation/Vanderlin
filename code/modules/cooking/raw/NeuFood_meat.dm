/* * * * * * * * * * * **
 *						*
 *		 NeuFood		*
 *		 (Meats)		*
 *						*
 * * * * * * * * * * * **/


/*-------------------\
| Raw meats and cuts |
\-------------------*/

// Template
/obj/item/reagent_containers/food/snacks/meat
	eat_effect = /datum/status_effect/debuff/uncookedfood
	list_reagents = list(/datum/reagent/consumable/nutriment = RAWMEAT_NUTRITION)
	icon_state = "meat"
	slice_batch = TRUE // so it takes more time, changed from FALSE
	filling_color = "#8f433a"
	bitesize = 1
	rotprocess = SHELFLIFE_SHORT
	chopping_sound = TRUE
	foodtype = RAW | MEAT
	drop_sound = 'sound/foley/dropsound/gen_drop.ogg'
	become_rot_type = /obj/item/reagent_containers/food/snacks/rotten/meat

/*	.............   Raw meat   ................ */
/obj/item/reagent_containers/food/snacks/meat/steak
	ingredient_size = 2
	name = "raw meat"
	slices_num = 2
	slice_path = /obj/item/reagent_containers/food/snacks/meat/mince/beef
	slice_bclass = BCLASS_CHOP

/obj/item/reagent_containers/food/snacks/meat/human
	name = "manflesh"
	foodtype = RAW | MEAT | GROSS

/*	.............   Pigflesh, strange meat, birdmeat   ................ */
/obj/item/reagent_containers/food/snacks/meat/fatty
	name = "raw pigflesh"
	icon_state = "pigflesh"
	slices_num = 2
	slice_path = /obj/item/reagent_containers/food/snacks/meat/mince/beef
	chopping_sound = TRUE

/obj/item/reagent_containers/food/snacks/meat/strange // Low-nutrient, kind of gross. Survival food.
	name = "strange meat"
	icon_state = "strange_meat"
	slice_path = null
	slices_num = 0

/obj/item/reagent_containers/food/snacks/meat/poultry
	name = "plucked bird"
	icon_state = "poultry"
	slice_path = /obj/item/reagent_containers/food/snacks/meat/poultry/cutlet
	slices_num = 2
	slice_sound = TRUE
	ingredient_size = 4
	become_rot_type = /obj/item/reagent_containers/food/snacks/rotten/poultry

/obj/item/reagent_containers/food/snacks/meat/poultry/cutlet
	name = "bird meat"
	icon_state = "chickencutlet"
	ingredient_size = 2
	slices_num = 2
	slice_bclass = BCLASS_CHOP
	slice_path = /obj/item/reagent_containers/food/snacks/meat/mince/poultry
	become_rot_type = /obj/item/reagent_containers/food/snacks/rotten/chickenleg

/*	........   Fish sounds   ................ */
/obj/item/reagent_containers/food/snacks/fish
	chopping_sound = TRUE
	slices_num = 2
	faretype = FARE_POOR
	var/rare = FALSE
	/// Number representing how rare the fish is, 0 is the lowest common fish
	var/rarity_rank = 0

/obj/item/reagent_containers/food/snacks/fish/dead
	abstract_type = /obj/item/reagent_containers/food/snacks/fish/dead
	status = FISH_DEAD
	fish_id = "dead"

/*	........   Cooked food template   ................ */ // No choppping double cooking etc prefixed
/obj/item/reagent_containers/food/snacks/cooked
	name = "cooked meat"
	desc = ""
	icon_state = "frysteak"
	list_reagents = list(/datum/reagent/consumable/nutriment = COOKED_MEAT_NUTRITION)
	rotprocess = SHELFLIFE_DECENT
	filling_color = "#8f433a"
	foodtype = MEAT
	become_rot_type = /obj/item/reagent_containers/food/snacks/rotten/meat

/*-----------------------\
| Mince & Sausage making |
\-----------------------*/

/*	.............   Minced meat & stuffing sausages   ................ */
/obj/item/reagent_containers/food/snacks/meat/mince
	name = "mince template. BUGREPORT"
	icon_state = "meatmince"
	ingredient_size = 2
	bitesize = 1
	slice_path = null
	filling_color = "#8a0000"
	rotprocess = SHELFLIFE_TINY
	become_rot_type = /obj/item/reagent_containers/food/snacks/rotten/mince

/obj/item/reagent_containers/food/snacks/meat/mince/throw_impact(atom/hit_atom, datum/thrownthing/thrownthing)
	new /obj/effect/decal/cleanable/food/mess(get_turf(src))
	playsound(get_turf(src), 'sound/foley/meatslap.ogg', 100, TRUE, -1)
	..()
	qdel(src)


/obj/item/reagent_containers/food/snacks/meat/mince/beef
	name = "minced meat"
	icon_state = "meatmince"

/obj/item/reagent_containers/food/snacks/meat/mince/beef/cooked
	name = "cooked minced meat"
	eat_effect = null
	foodtype = MEAT
	rotprocess = SHELFLIFE_DECENT
	list_reagents = list(/datum/reagent/consumable/nutriment = SNACK_DECENT)
	color = "#a0655f"

/obj/item/reagent_containers/food/snacks/meat/mince/fish
	name = "minced fish"
	icon_state = "fishmince"

/obj/item/reagent_containers/food/snacks/meat/mince/fish/cooked
	name = "cooked minced fish"
	eat_effect = null
	foodtype = MEAT
	rotprocess = SHELFLIFE_DECENT
	list_reagents = list(/datum/reagent/consumable/nutriment = SNACK_DECENT)
	color = "#a0655f"

/obj/item/reagent_containers/food/snacks/meat/mince/poultry
	name = "minced poultry"
	icon_state = "birdmince"

/obj/item/reagent_containers/food/snacks/meat/mince/poultry/cooked
	name = "cooked minced poultry"
	eat_effect = null
	foodtype = MEAT
	rotprocess = SHELFLIFE_DECENT
	list_reagents = list(/datum/reagent/consumable/nutriment = SNACK_DECENT)
	color = "#a0655f"

/*	..................   METT   ................... */
/obj/item/reagent_containers/food/snacks/meat/mince/beef/mett
	name = "grenzel mett"
	desc = "A popular topping for bread in Grenzelhoft, while simply bizarre to people from Vanderlin."
	icon_state = "mett_minced"
	list_reagents = list(/datum/reagent/consumable/nutriment = SNACK_NUTRITIOUS)
	bitesize = 3
	slice_path = /obj/item/reagent_containers/food/snacks/meat/mince/beef/mett/slice
	slices_num = 3
	slice_batch = TRUE
	slice_sound = TRUE
	eat_effect = null
	rotprocess = SHELFLIFE_TINY
	faretype = FARE_POOR

/obj/item/reagent_containers/food/snacks/meat/mince/beef/mett/slice
	name = "grenzel mett"
	icon_state = "mett_slice"
	bitesize = 1
	slices_num = FALSE
	slice_path = FALSE
	list_reagents = list(/datum/reagent/consumable/nutriment = SNACK_POOR)

/*	..................   Sausage & Wiener   ................... */
/obj/item/reagent_containers/food/snacks/meat/sausage
	name = "raw sausage"
	icon_state = "raw_wiener"
	ingredient_size = 1
	become_rot_type = /obj/item/reagent_containers/food/snacks/rotten/sausage

/obj/item/reagent_containers/food/snacks/meat/wiener
	name = "raw wiener"
	icon_state = "raw_wiener"
	ingredient_size = 1
	become_rot_type = /obj/item/reagent_containers/food/snacks/rotten/sausage


