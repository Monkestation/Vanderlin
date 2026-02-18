/obj/item/neuFarm/seed/mixed_seed
	name = "mixed seeds"

/obj/item/neuFarm/seed/mixed_seed/Initialize()
	plant_def_type = pick(GLOB.plant_defs)
	. = ..()

/obj/item/neuFarm/seed
	name = "seeds"
	icon = 'icons/roguetown/items/produce.dmi'
	icon_state = "seeds"
	w_class = WEIGHT_CLASS_TINY
	resistance_flags = FLAMMABLE
	possible_item_intents = list(/datum/intent/use)
	var/datum/plant_def/plant_def_type

	var/datum/plant_genetics/seed_genetics

/obj/item/neuFarm/seed/Initialize(mapload, datum/plant_genetics/passed_genetics)
	. = ..()
	if(plant_def_type)
		var/datum/plant_def/def = GLOB.plant_defs[plant_def_type]
		color = def.seed_color
	if(icon_state == "seeds")
		icon_state = "seeds[rand(1,3)]"

	if(!passed_genetics)
		if(!seed_genetics)
			var/datum/plant_def/plant_def_instance = GLOB.plant_defs[plant_def_type]
			seed_genetics = new /datum/plant_genetics(plant_def_instance)
		else
			seed_genetics = new seed_genetics()
	else
		seed_genetics = passed_genetics.copy()

/obj/item/neuFarm/seed/Crossed(mob/living/L)
	. = ..()
	// Chance to destroy the seed as it's being stepped on
	if(prob(10) && istype(L))
		playsound(src,"plantcross", 40, FALSE)
		visible_message(span_warning("[L] crushes [src] underfoot."))
		qdel(src)

/obj/item/neuFarm/seed/examine(mob/user)
	. = ..()
	var/datum/plant_def/plant_def_instance = GLOB.plant_defs[plant_def_type]
	if(plant_def_instance)
		var/examine_name = "[plant_def_instance.seed_identity]"
		var/datum/plant_genetics/seed_genetics_instance = seed_genetics
		if(seed_genetics_instance.seed_identity_modifier)
			examine_name = "[seed_genetics_instance.seed_identity_modifier] " + examine_name
		. += span_info("I can tell these are [examine_name].")
		if(HAS_TRAIT(user, TRAIT_SEEDKNOW) || user.get_skill_level(/datum/skill/labor/farming) >= 2)
			. += plant_def_instance.get_examine_details()

/obj/item/neuFarm/seed/attack_atom(atom/attacked_atom, mob/living/user)
	if(!isturf(attacked_atom))
		return ..()

	var/turf/T = attacked_atom
	var/obj/structure/soil/soil = get_soil_on_turf(T)
	if(soil)
		try_plant_seed(user, soil)
		return TRUE
	else if(istype(T, /turf/open/floor/dirt))
		var/obj/structure/irrigation_channel/located = locate(/obj/structure/irrigation_channel) in T
		if(located)
			to_chat(user, span_notice("[located] is in the way!"))
			return
		if(!(user.get_skill_level(/datum/skill/labor/farming) >= SKILL_LEVEL_JOURNEYMAN))
			to_chat(user, span_notice("I don't know enough to make a mound without tools."))
			return
		to_chat(user, span_notice("I begin making a mound for the seeds..."))
		if(do_after(user, get_farming_do_time(user, 10 SECONDS), target = src))
			apply_farming_fatigue(user, 30)
			soil = get_soil_on_turf(T)
			if(!soil)
				soil = new /obj/structure/soil(T)
		return TRUE
	return ..()

/obj/item/neuFarm/seed/proc/try_plant_seed(mob/living/user, obj/structure/soil/soil)
	if(soil.plant)
		to_chat(user, span_warning("There is already something planted in \the [soil]!"))
		return
	if(!plant_def_type)
		return
	to_chat(user, span_notice("I plant \the [src] in \the [soil]."))
	soil.insert_plant(GLOB.plant_defs[plant_def_type], seed_genetics)
	qdel(src)

/obj/item/neuFarm/seed/wheat
	plant_def_type = /datum/plant_def/wheat

/obj/item/neuFarm/seed/wheat/ancient
	plant_def_type = /datum/plant_def/wheat
	seed_genetics = /datum/plant_genetics/heirloom/wheat_ancient

/obj/item/neuFarm/seed/oat
	plant_def_type = /datum/plant_def/oat
	color = "#a3eca3"

/obj/item/neuFarm/seed/manabloom
	plant_def_type = /datum/plant_def/manabloom
	color = "#a3cbec"

/obj/item/neuFarm/seed/apple
	plant_def_type = /datum/plant_def/apple

/obj/item/neuFarm/seed/westleach
	plant_def_type = /datum/plant_def/westleach

/obj/item/neuFarm/seed/swampleaf
	plant_def_type = /datum/plant_def/swampweed

/obj/item/neuFarm/seed/berry
	plant_def_type = /datum/plant_def/jacksberry

/obj/item/neuFarm/seed/poison_berries
	plant_def_type = /datum/plant_def/jacksberry_poison

/obj/item/neuFarm/seed/cabbage
	plant_def_type = /datum/plant_def/cabbage

/obj/item/neuFarm/seed/onion
	color = "#fff2ca"
	plant_def_type = /datum/plant_def/onion

/obj/item/neuFarm/seed/potato
	plant_def_type = /datum/plant_def/potato

/obj/item/neuFarm/seed/sunflower
	plant_def_type = /datum/plant_def/sunflower

/obj/item/neuFarm/seed/pear
	plant_def_type = /datum/plant_def/pear

/obj/item/neuFarm/seed/turnip
	plant_def_type = /datum/plant_def/turnip

/obj/item/neuFarm/seed/fyritius
	plant_def_type = /datum/plant_def/fyritiusflower

/obj/item/neuFarm/seed/poppy
	plant_def_type = /datum/plant_def/poppy

/obj/item/neuFarm/seed/plum
	plant_def_type = /datum/plant_def/plum

/obj/item/neuFarm/seed/lemon
	plant_def_type = /datum/plant_def/lemon

/obj/item/neuFarm/seed/lime
	plant_def_type = /datum/plant_def/lime

/obj/item/neuFarm/seed/tangerine
	plant_def_type = /datum/plant_def/tangerine

/obj/item/neuFarm/seed/sugarcane
	plant_def_type = /datum/plant_def/sugarcane

/obj/item/neuFarm/seed/strawberry
	plant_def_type = /datum/plant_def/strawberry

/obj/item/neuFarm/seed/blackberry
	plant_def_type = /datum/plant_def/blackberry

/obj/item/neuFarm/seed/raspberry
	plant_def_type = /datum/plant_def/raspberry

/obj/item/neuFarm/seed/mango
	plant_def_type = /datum/plant_def/mango

/obj/item/neuFarm/seed/mangosteen
	plant_def_type = /datum/plant_def/mangosteen

/obj/item/neuFarm/seed/avocado
	plant_def_type = /datum/plant_def/avocado

/obj/item/neuFarm/seed/dragonfruit
	plant_def_type = /datum/plant_def/dragonfruit

/obj/item/neuFarm/seed/pineapple
	plant_def_type = /datum/plant_def/pineapple

//alchemical
/obj/item/neuFarm/seed/atropa
	plant_def_type = /datum/plant_def/alchemical/atropa

/obj/item/neuFarm/seed/matricaria
	plant_def_type = /datum/plant_def/alchemical/matricaria

/obj/item/neuFarm/seed/symphitum
	plant_def_type = /datum/plant_def/alchemical/symphitum

/obj/item/neuFarm/seed/taraxacum
	plant_def_type = /datum/plant_def/alchemical/taraxacum

/obj/item/neuFarm/seed/euphrasia
	plant_def_type = /datum/plant_def/alchemical/euphrasia

/obj/item/neuFarm/seed/paris
	plant_def_type = /datum/plant_def/alchemical/paris

/obj/item/neuFarm/seed/calendula
	plant_def_type = /datum/plant_def/alchemical/calendula

/obj/item/neuFarm/seed/mentha
	plant_def_type = /datum/plant_def/alchemical/mentha

/obj/item/neuFarm/seed/urtica
	plant_def_type = /datum/plant_def/alchemical/urtica

/obj/item/neuFarm/seed/salvia
	plant_def_type = /datum/plant_def/alchemical/salvia

/obj/item/neuFarm/seed/hypericum
	plant_def_type = /datum/plant_def/alchemical/hypericum

/obj/item/neuFarm/seed/benedictus
	plant_def_type = /datum/plant_def/alchemical/benedictus

/obj/item/neuFarm/seed/valeriana
	plant_def_type = /datum/plant_def/alchemical/valeriana

/obj/item/neuFarm/seed/artemisia
	plant_def_type = /datum/plant_def/alchemical/artemisia

/obj/item/neuFarm/seed/rosa
	plant_def_type = /datum/plant_def/alchemical/rosa

/obj/item/neuFarm/seed/euphorbia
	plant_def_type = /datum/plant_def/alchemical/euphorbia

/obj/item/neuFarm/seed/coffee
	plant_def_type = /datum/plant_def/coffee

/obj/item/neuFarm/seed/tea
	plant_def_type = /datum/plant_def/tea

// ----- SPORES ----- //

/obj/item/neuFarm/seed/spore
	name = "mushroom spores"
	desc = "Used to inoculate soil with mycelium for cultivation."
	icon_state = "spores"

/obj/item/neuFarm/seed/spore/Initialize(mapload, datum/plant_genetics/passed_genetics)
	. = ..()
	if(plant_def_type)
		var/datum/plant_def/def = GLOB.plant_defs[plant_def_type]
		color = def.seed_color // make a new spore color list later

/obj/item/neuFarm/seed/spore/capillus
	plant_def_type = /datum/plant_def/mushroom/capillus

/obj/item/neuFarm/seed/spore/waddle
	plant_def_type = /datum/plant_def/mushroom/waddle

/obj/item/neuFarm/seed/spore/merkel
	plant_def_type = /datum/plant_def/mushroom/merkel

/obj/item/neuFarm/seed/spore/caveweep
	plant_def_type = /datum/plant_def/mushroom/caveweep

/obj/item/neuFarm/seed/spore/borowiki
	plant_def_type = /datum/plant_def/mushroom/borowiki

/* /obj/item/neuFarm/seed/spore/chanterelle // Removing for now to expand upon later
	plant_def_type = /datum/plant_def/mushroom/chanterelle */

