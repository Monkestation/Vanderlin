/obj/structure/wild_plant
	name = "wild "
	desc = "A wild "
	icon_state = "tea2"
	icon = 'icons/roguetown/misc/crops.dmi'
	abstract_type = /obj/structure/wild_plant
	var/datum/plant_def/plant_type
	var/spread_chance = 75

/obj/structure/wild_plant/Initialize(mapload, incoming_type, incoming_spread)
	. = ..()
	if(incoming_type)
		plant_type = incoming_type
	if(!plant_type)
		plant_type = /datum/plant_def/cabbage
	plant_type = new plant_type

	if(incoming_spread)
		spread_chance = incoming_spread
	if(prob(spread_chance))
		try_spread()

	name = name + plant_type.name
	desc = desc + plant_type.name

	pixel_x = base_pixel_x + rand(-12, 12)
	pixel_y = base_pixel_y + rand(-12, 12)

	icon_state = "[plant_type.icon_state]2"

/obj/structure/wild_plant/Destroy()
	if(istype(plant_type))
		QDEL_NULL(plant_type)
	return ..()

/obj/structure/wild_plant/Crossed(mob/living/carbon/human/H)
	playsound(src, "plantcross", 80, FALSE, -1)

/obj/structure/wild_plant/proc/try_spread()
	var/list/dirs = GLOB.cardinals.Copy()

	dirs = shuffle(dirs)

	for(var/direction in dirs)
		var/turf/open/turf = get_step(src, direction)
		if(!istype(turf, /turf/open/floor/dirt) && !istype(turf, /turf/open/floor/grass) && !istype(turf, /turf/open/floor/snow))
			continue
		var/obj/structure/wild_plant/plant = locate(/obj/structure/wild_plant) in turf
		if(plant)
			continue
		if(is_anchored_dense_turf(turf))
			continue
		new /obj/structure/wild_plant(turf, plant_type.type, spread_chance - 20)

		if(!prob(spread_chance))
			return

/obj/structure/wild_plant/attack_hand(mob/user)
	. = ..()
	if(do_after(user, get_farming_do_time(user, 4 SECONDS), src))
		playsound(src,'sound/items/seed.ogg', 100, FALSE)
		user_harvests(user)
	return

/obj/structure/wild_plant/proc/user_harvests(mob/living/user)
	apply_farming_fatigue(user, 4)
	add_sleep_experience(user, /datum/skill/labor/farming, user.STAINT * 2)

	var/farming_skill = user.get_skill_level(/datum/skill/labor/farming, TRUE)
	var/feedback = "I harvest the produce."
	var/modifier = 0
	var/chance_to_ruin_single = 75 - (farming_skill * 25)
	if(prob(chance_to_ruin_single))
		feedback = "I harvest the produce, ruining a little."
		modifier -= 1
	var/chance_to_get_extra = -75 + (farming_skill * 25)
	if(prob(chance_to_get_extra))
		feedback = "I harvest the produce well."
		modifier += 1

	if(has_world_trait(/datum/world_trait/dendor_fertility))
		feedback = "Praise Dendor for our harvest is bountiful."
		modifier += is_ascendant(DENDOR) ? 4 : 3

	if(user.client)
		record_featured_stat(FEATURED_STATS_FARMERS, user)
		record_featured_object_stat(FEATURED_STATS_CROPS, plant_type.name)
		record_round_statistic(STATS_PLANTS_HARVESTED)
	to_chat(user, span_notice(feedback))
	yield_produce(modifier)

/obj/structure/wild_plant/proc/yield_produce(modifier = 0)
	var/base_amount = rand(plant_type.produce_amount_min, plant_type.produce_amount_max)
	var/spawn_amount = max(base_amount + modifier, 1)
	for(var/i in 1 to spawn_amount)
		new plant_type.produce_type(loc)
	qdel(src)

/obj/structure/wild_plant/random/Initialize()
	plant_type = pick(subtypesof(/datum/plant_def))
	spread_chance = rand(25, 100)
	return ..()

/obj/structure/wild_plant/manabloom
	plant_type = /datum/plant_def/manabloom

/obj/structure/wild_plant/manabloom/Initialize()
	spread_chance = rand(25, 50)
	return ..()

/obj/structure/wild_plant/nospread
	spread_chance = 0

/obj/structure/wild_plant/nospread/manabloom
	icon_state = "manabloom2"
	plant_type = /datum/plant_def/manabloom

/obj/structure/wild_plant/nospread/poppy
	icon_state = "poppy2"
	plant_type = /datum/plant_def/poppy

/obj/structure/wild_plant/nospread/cabbage
	icon_state = "cabbage2"
	plant_type = /datum/plant_def/cabbage

/obj/structure/wild_plant/nospread/onion
	icon_state = "onion2"
	plant_type = /datum/plant_def/onion

/obj/structure/wild_plant/nospread/wheat
	icon_state = "wheat2"
	plant_type = /datum/plant_def/wheat

/obj/structure/wild_plant/nospread/oat
	icon_state = "oat2"
	plant_type = /datum/plant_def/oat

/obj/structure/wild_plant/nospread/westleach
	icon_state = "westleach2"
	plant_type = /datum/plant_def/westleach

/obj/structure/wild_plant/nospread/jacksberry
	icon_state = "berry2"
	plant_type = /datum/plant_def/jacksberry

/obj/structure/wild_plant/nospread/jacksberry_poison
	icon_state = "berry2"
	plant_type = /datum/plant_def/jacksberry_poison

/obj/structure/wild_plant/nospread/strawberry
	icon_state = "strawberry2"
	plant_type = /datum/plant_def/strawberry

/obj/structure/wild_plant/nospread/blackberry
	icon_state = "blackberry2"
	plant_type = /datum/plant_def/blackberry

/obj/structure/wild_plant/nospread/raspberry
	icon_state = "raspberry2"
	plant_type = /datum/plant_def/raspberry

/obj/structure/wild_plant/nospread/apple
	icon_state = "apple2"
	plant_type = /datum/plant_def/apple

/obj/structure/wild_plant/nospread/pear
	icon_state = "pear2"
	plant_type = /datum/plant_def/pear

/obj/structure/wild_plant/nospread/plum
	icon_state = "plumtree2"
	plant_type = /datum/plant_def/plum

/obj/structure/wild_plant/nospread/tangerine
	icon_state = "tangerinetree2"
	plant_type = /datum/plant_def/tangerine

/obj/structure/wild_plant/nospread/lime
	icon_state = "limetree2"
	plant_type = /datum/plant_def/lime

/obj/structure/wild_plant/nospread/lemon
	icon_state = "lemontree2"
	plant_type = /datum/plant_def/lemon

/obj/structure/wild_plant/nospread/sugarcane
	icon_state = "sugarcane2"
	plant_type = /datum/plant_def/sugarcane

/obj/structure/wild_plant/nospread/potato
	icon_state = "potato2"
	plant_type = /datum/plant_def/potato

/obj/structure/wild_plant/nospread/turnip
	icon_state = "turnip2"
	plant_type = /datum/plant_def/turnip

/obj/structure/wild_plant/nospread/swampweed
	icon_state = "swampweed2"
	plant_type = /datum/plant_def/swampweed

/obj/structure/wild_plant/nospread/sunflower
	icon_state = "sunflower2"
	plant_type = /datum/plant_def/sunflower

/obj/structure/wild_plant/nospread/fyritiusflower
	icon_state = "fyritius2"
	plant_type = /datum/plant_def/fyritiusflower

/obj/structure/wild_plant/nospread/mango
	icon_state = "mangotree2"
	plant_type = /datum/plant_def/mango

/obj/structure/wild_plant/nospread/avocado
	icon_state = "avocadotree2"
	plant_type = /datum/plant_def/avocado

/obj/structure/wild_plant/nospread/mangosteen
	icon_state = "mangosteentree2"
	plant_type = /datum/plant_def/mangosteen

/obj/structure/wild_plant/nospread/pineapple
	icon_state = "pineapple2"
	plant_type = /datum/plant_def/pineapple

/obj/structure/wild_plant/nospread/dragonfruit
	icon_state = "dragonfruit2"
	plant_type = /datum/plant_def/dragonfruit

/* Wild Mushrooms */
/obj/structure/wild_plant/nospread/mushroom
	icon = 'icons/roguetown/misc/dikaryawild.dmi'

/obj/structure/wild_plant/nospread/mushroom/capillus
	icon_state = "capillus2"
	plant_type = /datum/plant_def/mushroom/capillus

/obj/structure/wild_plant/nospread/mushroom/waddle
	icon_state = "waddle2"
	plant_type = /datum/plant_def/mushroom/waddle

/obj/structure/wild_plant/nospread/mushroom/merkel
	icon_state = "merkel2"
	plant_type = /datum/plant_def/mushroom/merkel

/obj/structure/wild_plant/nospread/mushroom/caveweep
	icon_state = "caveweep2"
	plant_type = /datum/plant_def/mushroom/caveweep

/obj/structure/wild_plant/nospread/mushroom/borowiki
	icon_state = "borowiki2"
	plant_type = /datum/plant_def/mushroom/borowiki

/* /obj/structure/wild_plant/nospread/mushroom/chanterelle // Removing for now to expand upon later
	icon_state = "chanterelle2"
	plant_type = /datum/plant_def/mushroom/chanterelle */


