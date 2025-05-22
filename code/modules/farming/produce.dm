/obj/item/reagent_containers/food/snacks/produce
	icon = 'icons/roguetown/items/produce.dmi'
	dried_type = null
	resistance_flags = FLAMMABLE
	w_class = WEIGHT_CLASS_SMALL
	sellprice = 0
	force = 0
	throwforce = 0
	var/list/pipe_reagents = list()
	var/seed
	var/bitesize_mod = 0
	var/crop_quality = 1

/obj/item/reagent_containers/food/snacks/produce/proc/set_quality(quality)
	crop_quality = quality
	update_overlays()

/obj/item/reagent_containers/food/snacks/produce/update_overlays()
	. = ..()
	// Add quality overlay to the food item
	if(crop_quality > 1)
		var/list/quality_icons = list(
			null, // Regular has no overlay
			"bronze",
			"silver",
			"gold",
			"diamond",
		)
		if(crop_quality <= length(quality_icons) && quality_icons[crop_quality])
			overlays += mutable_appearance('icons/effects/crop_quality.dmi', quality_icons[crop_quality])

/obj/item/reagent_containers/food/snacks/produce/fruit
	name = "fruit"

/obj/item/reagent_containers/food/snacks/produce/vegetable
	name = "vegetable"

/obj/item/reagent_containers/food/snacks/produce/grain
	name = "grain"

/obj/item/reagent_containers/food/snacks/produce/Initialize(mapload)
	. = ..()
	if(!tastes)
		tastes = list("[name]" = 1)
	pixel_x = rand(-5, 5)
	pixel_y = rand(-5, 5)

/obj/item/reagent_containers/food/snacks/produce/Crossed(mob/living/carbon/human/H)
	..()
	if(prob(20))
		if(istype(H))
			if(eat_effect == /datum/status_effect/debuff/rotfood)
				visible_message("<span class='warning'>[H] crushes [src] underfoot.</span>")
				qdel(src)

/obj/item/reagent_containers/food/snacks/produce/attackby(obj/item/weapon, mob/user, params)
	if(weapon && isturf(loc))
		var/turf/location = get_turf(src)
		if(seed && (user.used_intent.blade_class == BCLASS_BLUNT) && (!user.used_intent.noaa))
			playsound(src,'sound/items/seedextract.ogg', 100, FALSE)
			if(prob(5))
				user.visible_message("<span class='info'>[user] fails to extract the seeds.</span>")
				qdel(src)
				return
			user.visible_message("<span class='info'>[user] extracts the seeds.</span>")
			new seed(location)
			if(prob(90))
				new seed(location)
			if(prob(23))
				new seed(location)
			if(prob(6))
				new seed(location)
			qdel(src)
			return
		else
			return ..()
	..()

/obj/item/reagent_containers/food/snacks/produce/grain/wheat
	seed = /obj/item/neuFarm/seed/wheat
	name = "wheat grain"
	desc = ""
	icon_state = "wheat"
	gender = PLURAL
	filling_color = "#F0E68C"
	bitesize_mod = 2
	foodtype = GRAIN
	tastes = list("wheat" = 1)
	grind_results = list(/datum/reagent/flour = 10)
	dropshrink = 0.9
	mill_result = /obj/item/reagent_containers/powder/flour

/obj/item/reagent_containers/food/snacks/produce/grain/wheat/examine(mob/user)
	var/farminglvl = user.get_skill_level(/datum/skill/labor/farming)
	. += ..()
	if(farminglvl >= 0)
		. += "I can easily tell that these are wheat grains."

/obj/item/reagent_containers/food/snacks/produce/grain/oat
	seed = /obj/item/neuFarm/seed/oat
	name = "oat grain"
	desc = ""
	icon_state = "oat"
	gender = PLURAL
	filling_color = "#b1d179"
	bitesize_mod = 2
	foodtype = GRAIN
	tastes = list("oat" = 1)
	grind_results = list(/datum/reagent/flour = 10)
/obj/item/reagent_containers/food/snacks/produce/grain/oat/examine(mob/user)
	var/farminglvl = user.get_skill_level(/datum/skill/labor/farming)
	. += ..()
	if(farminglvl >= 0)
		. += "I can easily tell that these are oat groats."

// ^ PSA: next time you want to do this, make and run an updatepaths migration in tools/UpdatePaths
/obj/item/reagent_containers/food/snacks/produce/fruit/apple
	seed = /obj/item/neuFarm/seed/apple
	name = "apple"
	desc = "The humble apple. A sweet and nutritious fruit."
	icon_state = "apple"
	bitesize = 3
	foodtype = FRUIT
	tastes = list("apple" = 1)
	trash = /obj/item/trash/applecore
	faretype = FARE_POOR
	mob_overlay_icon = 'icons/roguetown/clothing/onmob/64x64/head.dmi'
	slot_flags = ITEM_SLOT_HEAD
	worn_x_dimension = 64
	list_reagents = list(/datum/reagent/consumable/nutriment = 1)
	worn_y_dimension = 64
	rotprocess = SHELFLIFE_DECENT
	sellprice = 0 // spoil too quickly to export
	var/equippedloc = null
	var/list/bitten_names = list()

/obj/item/reagent_containers/food/snacks/produce/fruit/apple/on_consume(mob/living/eater)
	..()
	if(ishuman(eater))
		var/mob/living/carbon/human/H = eater
		if(!(H.real_name in bitten_names))
			bitten_names += H.real_name

/obj/item/reagent_containers/food/snacks/produce/fruit/apple/blockproj(mob/living/carbon/human/H)
	if(prob(98))
		H.visible_message(span_notice("[H] is saved by the apple!"))
		H.dropItemToGround(H.head)
		return 1
	else
		H.dropItemToGround(H.head)
		return 0

/obj/item/reagent_containers/food/snacks/produce/fruit/apple/equipped(mob/M)
	..()
	if(ishuman(M))
		var/mob/living/carbon/human/H = M
		if(H.head == src)
			equippedloc = H.loc
			START_PROCESSING(SSobj, src)

/obj/item/reagent_containers/food/snacks/produce/fruit/apple/process()
	. = ..()
	if(ishuman(loc))
		var/mob/living/carbon/human/H = loc
		if(H.head == src)
			if(equippedloc != H.loc)
				H.dropItemToGround(H.head)

/obj/item/reagent_containers/food/snacks/produce/fruit/strawberry
	seed = /obj/item/neuFarm/seed/strawberry
	name = "strawberry"
	desc = "A delectable strawberry."
	icon_state = "strawberry"
	tastes = list("strawberry" = 1)
	faretype = FARE_NEUTRAL
	bitesize = 5
	list_reagents = list(/datum/reagent/consumable/nutriment = 0.5)
	dropshrink = 0.75
	rotprocess = SHELFLIFE_SHORT
	sellprice = 0 // spoil too quickly to export


/obj/item/reagent_containers/food/snacks/produce/fruit/raspberry
	seed = /obj/item/neuFarm/seed/raspberry
	name = "raspberry"
	desc = "A delectable raspberry."
	icon_state = "raspberry"
	tastes = list("raspberry" = 1)
	faretype = FARE_NEUTRAL
	bitesize = 5
	list_reagents = list(/datum/reagent/consumable/nutriment = 0.5)
	dropshrink = 0.75
	rotprocess = SHELFLIFE_SHORT
	sellprice = 0 // spoil too quickly to export


/obj/item/reagent_containers/food/snacks/produce/fruit/blackberry
	seed = /obj/item/neuFarm/seed/blackberry
	name = "blackberry"
	desc = "A delectable blackberry."
	icon_state = "blackberry"
	tastes = list("blackberry" = 1)
	faretype = FARE_NEUTRAL
	bitesize = 5
	list_reagents = list(/datum/reagent/consumable/nutriment = 0.5)
	dropshrink = 0.75
	rotprocess = SHELFLIFE_SHORT
	sellprice = 0 // spoil too quickly to export

/obj/item/reagent_containers/food/snacks/produce/fruit/jacksberry
	seed = /obj/item/neuFarm/seed/berry
	name = "jacksberries"
	desc = "Common berries found throughout Enigma and surrounding lands. A traveler's repast, or Dendor's wrath."
	icon_state = "berries"
	tastes = list("berry" = 1)
	faretype = FARE_NEUTRAL
	bitesize = 5
	list_reagents = list(/datum/reagent/consumable/nutriment = 0.5)
	dropshrink = 0.75
	var/color_index = "good"
	rotprocess = SHELFLIFE_SHORT
	sellprice = 0 // spoil too quickly to export
	var/poisonous = FALSE

/obj/item/reagent_containers/food/snacks/produce/fruit/jacksberry/Initialize()
	if(GLOB.berrycolors[color_index])
		filling_color = GLOB.berrycolors[color_index]
	else
		var/newcolor = pick(BERRYCOLORS)
		if(newcolor in GLOB.berrycolors)
			GLOB.berrycolors[color_index] = pick(BERRYCOLORS)
		else
			GLOB.berrycolors[color_index] = newcolor
		filling_color = GLOB.berrycolors[color_index]
	update_icon()
	..()

/obj/item/reagent_containers/food/snacks/produce/fruit/jacksberry/on_consume(mob/living/eater)
	..()
	update_icon()

/obj/item/reagent_containers/food/snacks/produce/fruit/jacksberry/update_icon()
	cut_overlays()
	var/used_state = "berriesc0"
	if(bitecount == 1)
		used_state = "berriesc1"
	if(bitecount == 2)
		used_state = "berriesc2"
	if(bitecount == 3)
		used_state = "berriesc3"
	if(bitecount == 4)
		used_state = "berriesc4"
	var/image/item_overlay = image(used_state)
	item_overlay.color = filling_color
	add_overlay(item_overlay)

/obj/item/reagent_containers/food/snacks/produce/fruit/jacksberry/poison
	seed = /obj/item/neuFarm/seed/poison_berries
	icon_state = "berries"
	tastes = list("berry" = 1)
	list_reagents = list(/datum/reagent/berrypoison = 5)
	grind_results = list(/datum/reagent/berrypoison = 5)
	color_index = "bad"
	poisonous = TRUE

/obj/item/reagent_containers/food/snacks/produce/fruit/jacksberry/examine(mob/user)
	var/farminglvl = user.get_skill_level(/datum/skill/labor/farming)
	. = ..()
	// Foragers can always detect if a berry is safe or poisoned
	if(HAS_TRAIT(user, TRAIT_FORAGER))
		if(poisonous)
			. += span_warning("This berry looks suspicious. I sense it might be poisoned.")
		else
			. += span_notice("This berry looks safe to eat.")
	// Non-Foragers with high farming skill can detect poisoned berries
	else if(farminglvl >= 3)
		if(poisonous)
			. += span_warning("These berries appear to be poisonous.</span>")
		else
			. += span_notice("This berry looks safe to eat.")

/*	..................   Swamp weed   ................... */
/obj/item/reagent_containers/food/snacks/produce/swampweed
	seed = /obj/item/neuFarm/seed/swampleaf
	name = "swampweed"
	desc = "A weed that can be dried and smoked to induce a relaxed state."
	icon_state = "swampweed"
	filling_color = "#008000"
	bitesize_mod = 1
	foodtype = VEGETABLES
	list_reagents = list(/datum/reagent/consumable/nutriment = 1, /datum/reagent/berrypoison = 1)
	tastes = list("sweet" = 1,"bitterness" = 1)
	eat_effect = /datum/status_effect/debuff/badmeal
	rotprocess = SHELFLIFE_LONG
	sellprice = 0 // only dried has value

/obj/item/reagent_containers/food/snacks/produce/swampweed_dried
	seed = null
	name = "swampweed"
	desc = "A dried weed that can be smoked to induce a relaxed state."
	icon_state = "swampweedd"
	dry = TRUE
	pipe_reagents = list(/datum/reagent/drug/space_drugs = 30)
	list_reagents = list(/datum/reagent/drug/space_drugs = 2,/datum/reagent/consumable/nutriment = 1)
	grind_results = list(/datum/reagent/drug/space_drugs = 5)
	eat_effect = /datum/status_effect/debuff/badmeal
	rotprocess = null
	sellprice = 2


/*	..................   Westleach leaf   ................... */
/obj/item/reagent_containers/food/snacks/produce/westleach
	seed = /obj/item/neuFarm/seed/westleach
	name = "westleach leaf"
	desc = "A common, strong-smelling leaf that is often dried and smoked. Also known as pipeweed."
	icon_state = "westleach"
	filling_color = "#008000"
	bitesize_mod = 1
	foodtype = VEGETABLES
	tastes = list("sweet" = 1,"bitterness" = 1)
	list_reagents = list(/datum/reagent/drug/nicotine = 2, /datum/reagent/consumable/nutriment = 1, /datum/reagent/berrypoison = 2)
	grind_results = list(/datum/reagent/drug/nicotine = 5)
	eat_effect = /datum/status_effect/debuff/badmeal
	rotprocess = SHELFLIFE_LONG
	sellprice = 0 // only dried has value

/obj/item/reagent_containers/food/snacks/produce/dry_westleach
	seed = null
	name = "dried westleach leaf"
	desc = "A common, strong-smelling leaf dried for smoking."
	icon_state = "westleachd"
	dry = TRUE
	pipe_reagents = list(/datum/reagent/drug/nicotine = 30)
	eat_effect = /datum/status_effect/debuff/badmeal
	list_reagents = list(/datum/reagent/drug/nicotine = 5, /datum/reagent/consumable/nutriment = 1)
	grind_results = list(/datum/reagent/drug/nicotine = 10)
	rotprocess = null
	sellprice = 1


/*	..................   Cabbage   ................... */
/obj/item/reagent_containers/food/snacks/produce/vegetable/cabbage
	name = "cabbage"
	desc = "A vegetable with thick leaves, seen as a symbol of prosperity by some elves."
	seed = /obj/item/neuFarm/seed/cabbage
	icon_state = "cabbage"
	tastes = list("cabbage" = 1)
	filling_color = "#88c8a0"
	bitesize = 1
	foodtype = VEGETABLES
	list_reagents = list(/datum/reagent/consumable/nutriment = 2)
	rotprocess = SHELFLIFE_LONG
	slices_num = 2
	slice_path = /obj/item/reagent_containers/food/snacks/veg/cabbage_sliced
	chopping_sound = TRUE

/*	..................   Onions   ................... */
/obj/item/reagent_containers/food/snacks/produce/vegetable/onion
	name = "onion"
	desc = "A wonderful vegetable with many layers and a broad flavor profile."
	seed = /obj/item/neuFarm/seed/onion
	icon_state = "onion"
	dropshrink = 0.9
	slices_num = 1
	slice_path = /obj/item/reagent_containers/food/snacks/veg/onion_sliced
	tastes = list("onion" = 1)
	filling_color = "#fdfaca"
	bitesize = 1
	foodtype = VEGETABLES
	list_reagents = list(/datum/reagent/consumable/nutriment = 2)
	chopping_sound = TRUE
	rotprocess = SHELFLIFE_LONG

/obj/item/reagent_containers/food/snacks/produce/vegetable/onion/slice(accuracy, obj/item/W, mob/living/user) // ROGTODO watering eyes
	var/datum/effect_system/smoke_spread/chem/transparent/S = new	//Since the onion is destroyed when it's sliced,
	var/splat_location = get_turf(src)	//we need to set up the smoke beforehand
	S.attach(splat_location)
	S.set_up(reagents, 0, splat_location, 0)
	if(..())
		S.start()
		return TRUE
	qdel(S)


/*	..................   Potato   ................... */
/obj/item/reagent_containers/food/snacks/produce/vegetable/potato
	name = "potato"
	desc = "A spud, dwarven icon of growth."
	seed = /obj/item/neuFarm/seed/potato
	icon_state = "potato"
	tastes = list("potato" = 1)
	filling_color = "#d8d8b6"
	slices_num = 1
	slice_path = /obj/item/reagent_containers/food/snacks/veg/potato_sliced
	eat_effect = null
	foodtype = VEGETABLES
	chopping_sound = TRUE
	list_reagents = list(/datum/reagent/consumable/nutriment = 3)
	bitesize = 1
	rotprocess = null

/*	..................  Pear   ................... */ // for cider or eating raw
/obj/item/reagent_containers/food/snacks/produce/fruit/pear
	name = "pear"
	seed = /obj/item/neuFarm/seed/pear
	desc = "Too sweet for many, a favored treat for little ones. Dwarves do love them."
	icon_state = "pear"
	bitesize = 2
	foodtype = FRUIT
	tastes = list("pear" = 1)
	rotprocess = SHELFLIFE_DECENT

/obj/item/reagent_containers/food/snacks/produce/fruit/lemon
	name = "lemon"
	seed = /obj/item/neuFarm/seed/lemon
	desc = "Too sweet for many, a favored treat for little ones. Dwarves do love them."
	icon_state = "lemon"
	bitesize = 2
	foodtype = FRUIT
	tastes = list("lemon" = 1)
	rotprocess = SHELFLIFE_DECENT

/obj/item/reagent_containers/food/snacks/produce/fruit/lime
	name = "lime"
	seed = /obj/item/neuFarm/seed/lime
	desc = "Too sweet for many, a favored treat for little ones. Dwarves do love them."
	icon_state = "lime"
	bitesize = 2
	foodtype = FRUIT
	tastes = list("lime" = 1)
	rotprocess = SHELFLIFE_DECENT

/obj/item/reagent_containers/food/snacks/produce/fruit/tangerine
	name = "tangerine"
	seed = /obj/item/neuFarm/seed/tangerine
	desc = "Too sweet for many, a favored treat for little ones. Dwarves do love them."
	icon_state = "tangerine"
	bitesize = 2
	foodtype = FRUIT
	tastes = list("tangerine" = 1)
	rotprocess = SHELFLIFE_DECENT

/obj/item/reagent_containers/food/snacks/produce/fruit/plum
	name = "plum"
	seed = /obj/item/neuFarm/seed/plum
	desc = "Too sweet for many, a favored treat for little ones. Dwarves do love them."
	icon_state = "plum"
	bitesize = 2
	foodtype = FRUIT
	tastes = list("plum" = 1)
	rotprocess = SHELFLIFE_DECENT

/*	..................   Turnip   ................... */ // only for veggie soup
/obj/item/reagent_containers/food/snacks/produce/vegetable/turnip
	name = "turnip"
	desc = "A shield against hunger, naught else."
	seed = /obj/item/neuFarm/seed/turnip
	icon_state = "turnip"
	tastes = list("dirt" = 1)
	bitesize = 1
	slices_num = 1
	slice_path = /obj/item/reagent_containers/food/snacks/veg/turnip_sliced
	foodtype = VEGETABLES
	list_reagents = list(/datum/reagent/consumable/nutriment = 1)
	chopping_sound = TRUE
	dropshrink = 0.9
	rotprocess = SHELFLIFE_EXTREME

/*	..................   Sunflower   ................... */
/obj/item/reagent_containers/food/snacks/produce/sunflower
	seed = /obj/item/neuFarm/seed/sunflower
	name = "sunflower"
	desc = ""
	icon_state = "sunflower"
	mob_overlay_icon = 'icons/roguetown/clothing/onmob/head_items.dmi'
	seed = /obj/item/neuFarm/seed/sunflower
	slot_flags = ITEM_SLOT_HEAD
	throwforce = 0
	w_class = WEIGHT_CLASS_TINY
	throw_speed = 1
	throw_range = 3
	list_reagents = list(/datum/reagent/consumable/nutriment = 0)
	dropshrink = 0.8
	rotprocess = null


/obj/item/reagent_containers/food/snacks/produce/sugarcane
	seed = /obj/item/neuFarm/seed/sugarcane
	name = "sugarcane"
	desc = ""
	icon_state = "sugarcane"
	seed = /obj/item/neuFarm/seed/sugarcane
	throwforce = 0
	w_class = WEIGHT_CLASS_TINY
	throw_speed = 1
	throw_range = 3
	list_reagents = list(/datum/reagent/consumable/nutriment = 2, /datum/reagent/consumable/sugar = 5)
	dropshrink = 0.8
	rotprocess = null
	mill_result = /obj/item/reagent_containers/food/snacks/sugar

/obj/item/reagent_containers/food/snacks/sugar
	name = "sugar"
	desc ="Milled sugarcane, sweet as can be."
	icon = 'icons/roguetown/items/produce.dmi'
	icon_state = "salt"
	tastes = list("sweet" = 1)
	list_reagents = list(/datum/reagent/consumable/sugar = 15)

/*	..................   Fyritius Flower   ................... */ // some sort of funni fire flowers. Dunno just moving them here for consistency.
/obj/item/reagent_containers/food/snacks/produce/fyritius
	name = "fyritius flower"
	seed = /obj/item/neuFarm/seed/fyritius // if mass producing these breaks shit just comment it out
	desc = ""
	icon_state = "fyritius"
	tastes = list("tastes like a burning coal and fire" = 1)
	bitesize = 1
	list_reagents = list(/datum/reagent/consumable/nutriment = 2, /datum/reagent/toxin/fyritiusnectar = 5)
	dropshrink = 0.8
	rotprocess = null
	w_class = WEIGHT_CLASS_TINY
	throw_speed = 1
	throw_range = 3

/* .......... Poppies ........ */
/obj/item/reagent_containers/food/snacks/produce/poppy
	name = "poppy"
	desc = "For their crimson beauty and the sedating effect of their crushed seeds, these flowers are considered a symbol of Eora."
	icon_state = "poppy"
	seed = /obj/item/neuFarm/seed/poppy
	throwforce = 0
	w_class = WEIGHT_CLASS_TINY
	throw_speed = 1
	throw_range = 3
	list_reagents = list(/datum/reagent/consumable/nutriment = 0)
	dropshrink = 0.5
	rotprocess = null

/*
/obj/item/reagent_containers/food/snacks/produce/garlic
	name = "garlic"
	desc = "Your last line of defense against the vampiric horde."
//	seed = /obj/item/neuFarm/seed/garlic

/obj/item/reagent_containers/food/snacks/produce/amanita
//	seed = /obj/item/neuFarm/seed/mycelium/amanita
	name = "strange red mushroom"
	icon_state = "amanita"
	filling_color = "#daabab"
	bitesize = 3
	foodtype = GROSS
	tastes = list("numb" = 1)
	list_reagents = list(/datum/reagent/consumable/nutriment = 3, /datum/reagent/toxin/amanitin = 3)
	grind_results = list(/datum/reagent/toxin/amanitin = 6)

*/
