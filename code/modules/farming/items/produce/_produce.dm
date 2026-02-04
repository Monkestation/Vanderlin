/obj/item/reagent_containers/food/snacks/produce
	icon = 'icons/roguetown/items/produce.dmi'
	dried_type = null
	resistance_flags = FLAMMABLE
	w_class = WEIGHT_CLASS_SMALL
	sellprice = 0
	force = 0
	throwforce = 0
	faretype = FARE_POOR
	var/list/pipe_reagents = list()
	var/seed
	var/bitesize_mod = 0
	var/datum/plant_genetics/source_genetics

/obj/item/reagent_containers/food/snacks/produce/fruit
	name = "fruit"
	naturalist = TRUE

/obj/item/reagent_containers/food/snacks/produce/vegetable
	name = "vegetable"
	naturalist = TRUE

/obj/item/reagent_containers/food/snacks/produce/grain
	name = "grain"
	naturalist = TRUE

/obj/item/reagent_containers/food/snacks/produce/mushroom
	name = "mushroom"
	naturalist = TRUE

/obj/item/reagent_containers/food/snacks/produce/Initialize(mapload)
	. = ..()
	if(!tastes)
		tastes = list("[name]" = 1)
	pixel_x = base_pixel_x + rand(-5, 5)
	pixel_y = base_pixel_y + rand(-5, 5)

/obj/item/reagent_containers/food/snacks/produce/Crossed(mob/living/carbon/human/H)
	..()
	if(prob(20))
		if(istype(H))
			if(eat_effect == /datum/status_effect/debuff/rotfood)
				visible_message("<span class='warning'>[H] crushes [src] underfoot.</span>")
				qdel(src)

/obj/item/reagent_containers/food/snacks/produce/attackby(obj/item/weapon, mob/user, list/modifiers)
	if(weapon && isturf(loc))
		var/turf/location = get_turf(src)
		if(seed && (user.used_intent.blade_class == BCLASS_BLUNT) && (!user.used_intent.noaa))
			playsound(src,'sound/items/seedextract.ogg', 100, FALSE)
			if(prob(5))
				user.visible_message("<span class='info'>[user] fails to extract the seeds.</span>")
				qdel(src)
				return
			user.visible_message("<span class='info'>[user] extracts the seeds.</span>")
			new seed(location, source_genetics)
			if(prob(90))
				new seed(location, source_genetics)
			if(prob(23))
				new seed(location, source_genetics)
			if(prob(6))
				new seed(location, source_genetics)
			qdel(src)
			return
		else
			return ..()
	..()

/obj/item/reagent_containers/food/snacks/produce/grain/wheat
	seed = /obj/item/neuFarm/seed/wheat
	name = "wheat grain"
	desc = "A staple grain. Bread is made from this, and from bread, springs forth life."
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
	desc = "A staple grain. Used to create oatmeal, and to feed saigas and horses."
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
	. = ..()
	if(ishuman(eater))
		var/mob/living/carbon/human/H = eater
		bitten_names |= H.real_name

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
	name = "jacksberries"
	desc = "Common berries found throughout most of Faience. A traveler's repast, or Dendor's wrath."
	icon_state = "berriesc0"
	seed = /obj/item/neuFarm/seed/berry
	tastes = list("berry" = 1)
	faretype = FARE_POOR
	bitesize = 5
	list_reagents = list(/datum/reagent/consumable/nutriment = 0.5)
	dropshrink = 0.75
	var/color_index = "good"
	rotprocess = SHELFLIFE_SHORT
	sellprice = 0 // spoil too quickly to export
	var/poisonous = FALSE

/obj/item/reagent_containers/food/snacks/produce/fruit/jacksberry/Initialize()
	. = ..()
	if(GLOB.berrycolors[color_index])
		filling_color = GLOB.berrycolors[color_index]
	else
		var/newcolor = pick(BERRYCOLORS)
		if(newcolor in GLOB.berrycolors)
			GLOB.berrycolors[color_index] = pick(BERRYCOLORS)
		else
			GLOB.berrycolors[color_index] = newcolor
		filling_color = GLOB.berrycolors[color_index]
	update_appearance(UPDATE_ICON)

/obj/item/reagent_containers/food/snacks/produce/fruit/jacksberry/on_consume(mob/living/eater)
	. = ..()
	update_appearance(UPDATE_ICON)

/obj/item/reagent_containers/food/snacks/produce/fruit/jacksberry/update_icon_state()
	. = ..()
	switch(bitecount)
		if(1)
			icon_state = "berriesc1"
		if(2)
			icon_state = "berriesc2"
		if(3)
			icon_state = "berriesc3"
		if(4)
			icon_state = "berriesc4"
	color = filling_color

/obj/item/reagent_containers/food/snacks/produce/fruit/jacksberry/update_overlays()
	. = ..()
	var/mutable_appearance/M = mutable_appearance(icon, "berries")
	. += M

/obj/item/reagent_containers/food/snacks/produce/fruit/jacksberry/poison
	seed = /obj/item/neuFarm/seed/poison_berries
	list_reagents = list(/datum/reagent/berrypoison = 5)
	grind_results = list(/datum/reagent/berrypoison = 5)
	color_index = "bad"
	poisonous = TRUE

/obj/item/reagent_containers/food/snacks/produce/fruit/jacksberry/examine(mob/user)
	var/farminglvl = user.get_skill_level(/datum/skill/labor/farming)
	. = ..()
	// Foragers can always detect if p berry is safe or poisoned
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
	desc = "A sleep alternative for those determined enough."
	icon_state = "lemon"
	bitesize = 2
	foodtype = FRUIT
	tastes = list("lemon" = 1)
	rotprocess = SHELFLIFE_DECENT

/obj/item/reagent_containers/food/snacks/produce/fruit/lime
	name = "lime"
	seed = /obj/item/neuFarm/seed/lime
	desc = "Along with its other citrus cousins, limes are well-loved by sailors and seafolk for their ability to keep and stave off scurvy."
	icon_state = "lime"
	bitesize = 2
	foodtype = FRUIT
	tastes = list("lime" = 1)
	rotprocess = SHELFLIFE_DECENT

/obj/item/reagent_containers/food/snacks/produce/fruit/tangerine
	name = "tangerine"
	seed = /obj/item/neuFarm/seed/tangerine
	desc = "A citrus fruit loved by kids for its peelablity and more mild sweetness compared to limes and lemons."
	icon_state = "tangerine"
	bitesize = 2
	foodtype = FRUIT
	tastes = list("tangerine" = 1)
	rotprocess = SHELFLIFE_DECENT

/obj/item/reagent_containers/food/snacks/produce/fruit/plum
	name = "plum"
	seed = /obj/item/neuFarm/seed/plum
	desc = "A fruit with a large seed in the middle. Its blossoms are enjoyed in the spring, and its fruits in the summer."
	icon_state = "plum"
	bitesize = 2
	foodtype = FRUIT
	tastes = list("plum" = 1)
	rotprocess = SHELFLIFE_DECENT

/obj/item/reagent_containers/food/snacks/produce/fruit/mango
	name = "mangga"
	seed = /obj/item/neuFarm/seed/mango
	desc = "A golden tropical fruit bursting with sweet, juicy flesh."
	icon_state = "mango"
	bitesize = 2
	dropshrink = 0.8
	foodtype = FRUIT
	slices_num = 2
	slice_path = /obj/item/reagent_containers/food/snacks/fruit/mango_half
	chopping_sound = TRUE
	tastes = list("mangga" = 1)
	rotprocess = SHELFLIFE_SHORT

/obj/item/reagent_containers/food/snacks/produce/fruit/mangosteen
	name = "mangosteen"
	seed = /obj/item/neuFarm/seed/mangosteen
	desc = "A tropical fruit with a thick purple rind and white segments within."
	icon_state = "mangosteen"
	bitesize = 2
	dropshrink = 0.8
	foodtype = FRUIT
	slices_num = 1
	slice_path = /obj/item/reagent_containers/food/snacks/fruit/mangosteen_opened
	chopping_sound = TRUE
	tastes = list("mangosteen" = 1)
	rotprocess = SHELFLIFE_SHORT

/obj/item/reagent_containers/food/snacks/produce/fruit/avocado
	name = "avocado"
	seed = /obj/item/neuFarm/seed/avocado
	desc = "A verdant tropical fruit known for its smooth and creamy flesh."
	icon_state = "avocado"
	bitesize = 2
	dropshrink = 0.9
	foodtype = FRUIT
	slices_num = 2
	slice_path = /obj/item/reagent_containers/food/snacks/fruit/avocado_half
	chopping_sound = TRUE
	tastes = list("avocado" = 1)
	rotprocess = SHELFLIFE_DECENT

/obj/item/reagent_containers/food/snacks/produce/fruit/dragonfruit
	name = "piyata"
	seed = /obj/item/neuFarm/seed/dragonfruit
	desc = "A spiky fruit with a pink skin and white flesh, Its taste is mild yet refreshing."
	icon_state = "dragonfruit"
	bitesize = 2
	dropshrink = 0.7
	foodtype = FRUIT
	slices_num = 2
	slice_path = /obj/item/reagent_containers/food/snacks/fruit/dragonfruit_half
	chopping_sound = TRUE
	tastes = list("piyata" = 1)
	rotprocess = SHELFLIFE_DECENT

/obj/item/reagent_containers/food/snacks/produce/fruit/pineapple
	name = "ananas"
	seed = /obj/item/neuFarm/seed/pineapple
	desc = "A spiky fruit with golden skin, Its taste is tangy yet sweet and refreshing."
	icon_state = "pineapple"
	bitesize = 2
	dropshrink = 0.9
	foodtype = FRUIT
	slices_num = 4
	slice_path = /obj/item/reagent_containers/food/snacks/fruit/pineapple_slice
	chopping_sound = TRUE
	tastes = list("ananas" = 1)
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
	desc = "Astratas favoured flower, said to carry some of her warmth and radiance. Astratan acolytes hold them in high regard."
	icon_state = "sunflower"
	mob_overlay_icon = 'icons/roguetown/clothing/onmob/head_items.dmi'
	slot_flags = ITEM_SLOT_HEAD
	throwforce = 0
	w_class = WEIGHT_CLASS_TINY
	throw_speed = 1
	throw_range = 3
	list_reagents = list(/datum/reagent/consumable/nutriment = 0)
	dropshrink = 0.8
	rotprocess = null

/*	..................   Sugarcane   ................... */
/obj/item/reagent_containers/food/snacks/produce/sugarcane
	seed = /obj/item/neuFarm/seed/sugarcane
	name = "sugarcane"
	desc = "A crop best suited for a warmer climate, raw sugar cane is considered a sweet snack by some sea elves."
	icon_state = "sugarcane"
	throwforce = 0
	faretype = FARE_FINE //Reasoning: Sugarcane is a rare import. You can also chew sugarcane fibers. Try some out next time you have some!
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
	desc = "A flower that's colored like flickering flames. Said to contain a bit of the power of fire as well."
	icon_state = "fyritius"
	tastes = list("tastes like a burning coal and fire" = 1)
	bitesize = 1
	list_reagents = list(/datum/reagent/consumable/nutriment = 2, /datum/reagent/toxin/fyritiusnectar = 5)
	dropshrink = 0.8
	rotprocess = null
	w_class = WEIGHT_CLASS_TINY
	throw_speed = 1
	throw_range = 3

/obj/item/reagent_containers/food/snacks/produce/fyritius/attacked_by(obj/item/I, mob/living/user)
	. = ..()
	if(istype(I, /obj/item/inqarticles/indexer))
		var/obj/item/inqarticles/indexer/IND = I
		var/success
		if(HAS_TRAIT(user, TRAIT_INQUISITION))
			if(IND.cursedblood)
				if(alert(user, "DRENCH THE FYRITIUS?", "CURSED BLOOD", "YES", "NO") != "NO")
					success = TRUE
					IND.fullreset(user)
				else
					return
				if(success)
					changefood(/obj/item/reagent_containers/food/snacks/produce/fyritius/bloodied, user)

/obj/item/reagent_containers/food/snacks/produce/fyritius/bloodied
	name = "bloodied fyritius flower"
	desc = "A once delicate orange flower, now soaked with gruesome accursed blood that slowly burns it away."
	icon_state = "fyritius_blood"
	filling_color = "#ff3300"
	tastes = list("tastes like a burning coal and fire and blood" = 1)
	bitesize = 1
	list_reagents = list(/datum/reagent/consumable/nutriment = 2, /datum/reagent/toxin/fyritiusnectar = 5)
	rotprocess = SHELFLIFE_TINY

/obj/item/reagent_containers/food/snacks/produce/fyritius/bloodied/become_rotten()
	visible_message(span_danger("[src] burns into ash!"))
	new /obj/effect/decal/cleanable/ash(get_turf(src))
	qdel(src)
	return TRUE

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
	mob_overlay_icon = 'icons/roguetown/clothing/onmob/head_items.dmi'
	slot_flags = ITEM_SLOT_HEAD|ITEM_SLOT_MASK
	body_parts_covered = NONE
	alternate_worn_layer  = 8.9

/* .......... Mushrooms ........ */
/obj/item/reagent_containers/food/snacks/produce/mushroom/capillus
	name = "capillus mort"
	desc = "Also called Corpse Caps or Necra’s Nightcaps, this toxic fungus was first discovered by Necran gravetenders, growing amongst tombs. It has long since been harvested and dried to make use of its fibrous gills in the weaving of winding sheets."
	icon_state = "capillus"
	seed = /obj/item/neuFarm/seed/spore/capillus
	throwforce = 0
	tastes = list("bitter" = 1,"fibrous" = 1)
	w_class = WEIGHT_CLASS_TINY
	throw_speed = 1
	throw_range = 3
	list_reagents = list(/datum/reagent/consumable/nutriment = 0, /datum/reagent/berrypoison = 1)
	dropshrink = 0.8
	rotprocess = SHELFLIFE_EXTREME
	eat_effect = /datum/status_effect/debuff/badmeal

/obj/item/reagent_containers/food/snacks/produce/mushroom/waddle
	name = "waddle"
	desc = "A staple to all those that wander the forests of Faience. Its bright color and unique shape have lent it its name. Some even say it tastes like roast bird."
	icon_state = "waddle"
	seed = /obj/item/neuFarm/seed/spore/waddle
	throwforce = 0
	tastes = list("meaty" = 1)
	w_class = WEIGHT_CLASS_TINY
	throw_speed = 1
	throw_range = 3
	list_reagents = list(/datum/reagent/consumable/nutriment = 1)
	dropshrink = 0.8
	rotprocess = SHELFLIFE_DECENT

/obj/item/reagent_containers/food/snacks/produce/mushroom/merkel
	name = "merkel"
	desc = "A rare fungus popularized by the ruling class of Grenzelhoft. It has been said that these mushrooms smell SO divine when prepared correctly, it could raise a man from the dead."
	icon_state = "merkel"
	seed = /obj/item/neuFarm/seed/spore/merkel
	throwforce = 0
	tastes = list("sweet" = 1,"nutty" = 1,"rich" = 1)
	w_class = WEIGHT_CLASS_TINY
	throw_speed = 1
	throw_range = 3
	list_reagents = list(/datum/reagent/consumable/nutriment = 1)
	dropshrink = 0.8
	rotprocess = SHELFLIFE_DECENT

/obj/item/reagent_containers/food/snacks/produce/mushroom/caveweep
	name = "caveweep"
	desc = "Once thought to be the wept tears of Psydonia itself, this fungus can be found growing deep within the damp caves along the coasts of Faience. It is known only to those brave enough to delve their depths and discover its unique, briney flavors."
	icon_state = "caveweep"
	seed = /obj/item/neuFarm/seed/spore/caveweep
	throwforce = 0
	tastes = list("sweet" = 1,"briny" = 1)
	w_class = WEIGHT_CLASS_TINY
	throw_speed = 1
	throw_range = 3
	list_reagents = list(/datum/reagent/consumable/nutriment = 1)
	dropshrink = 0.8
	rotprocess = SHELFLIFE_DECENT

/obj/item/reagent_containers/food/snacks/produce/mushroom/borowiki
	name = "borowiki"
	desc = "Also known as Cépes to the Drow, this fungus was cultivated over generations into this hearty crop by the Dwarves of the mountain passes. It is not known which of them were the first to discover it, though their use by the surface dwelling species of Psydonia has grown significantly in the last few centuries."
	icon_state = "borowiki"
	seed = /obj/item/neuFarm/seed/spore/borowiki
	throwforce = 0
	tastes = list("earthy" = 1,"nutty" = 1)
	w_class = WEIGHT_CLASS_TINY
	throw_speed = 1
	throw_range = 3
	list_reagents = list(/datum/reagent/consumable/nutriment = 2)
	dropshrink = 0.8
	rotprocess = SHELFLIFE_DECENT

/* /obj/item/reagent_containers/food/snacks/produce/mushroom/chanterelle // Removing for now to expand upon later
	name = "chanterelle"
	desc =
	icon_state = "chanterelle"
	seed = /obj/item/neuFarm/seed/spore/chanterelle
	throwforce = 0
	tastes = list("fruity" = 1,"earthy" = 1)
	w_class = WEIGHT_CLASS_TINY
	throw_speed = 1
	throw_range = 3
	list_reagents = list(/datum/reagent/consumable/nutriment = 1)
	dropshrink = 0.8
	rotprocess = SHELFLIFE_DECENT

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

/proc/display_shit()
	var/list/list = subtypesof(/obj/item/alch)
	var/type_list = ""
	for(var/i in list)
		type_list += "[i], "
	usr << browse(list)

