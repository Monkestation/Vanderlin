
#define MAX_PLANT_NUTRITION 300
#define SOIL_DECAY_TIME 20 MINUTES

#define QUALITY_REGULAR 1
// #define QUALITY_BRONZE 2
#define QUALITY_SILVER 2
#define QUALITY_GOLD 3
#define QUALITY_DIAMOND 4

#define BLESSING_WEED_DECAY_RATE 10 / (1 MINUTES)
#define WEED_GROWTH_RATE 3 / (1 MINUTES)
#define WEED_DECAY_RATE 5 / (1 MINUTES)
#define WEED_RESISTANCE_DECAY_RATE 20 / (1 MINUTES)

// These get multiplied by 0.0 to 1.0 depending on amount of weeds
#define WEED_WATER_CONSUMPTION_RATE 5 / (1 MINUTES)
#define WEED_NUTRITION_CONSUMPTION_RATE 2 / (1 MINUTES)

#define PLANT_REGENERATION_RATE 10 / (1 MINUTES)
#define PLANT_DECAY_RATE 10 / (1 MINUTES)
#define PLANT_BLESS_HEAL_RATE 20 / (1 MINUTES)
#define PLANT_WEEDS_HARM_RATE 10 / (1 MINUTES)

#define SOIL_WATER_DECAY_RATE 0.5 / (1 MINUTES)
#define SOIL_NUTRIMENT_DECAY_RATE 0.5 / (1 MINUTES)

/obj/structure/soil
	name = "soil"
	desc = "Dirt, ready to give life like a womb."
	icon = 'icons/roguetown/misc/soil.dmi'
	icon_state = "soil"
	density = FALSE
	climbable = FALSE
	resistance_flags = INDESTRUCTIBLE
	UUID_saving = TRUE
	/// Amount of water in the soil. It makes the plant and weeds not loose health
	var/water = 0
	/// Amount of weeds in the soil. The more of them the more water and nutrition they eat.
	var/weeds = 0
	var/nitrogen = MAX_PLANT_NITROGEN * 0.5        // N - For leafy growth, chlorophyll production
	var/phosphorus = MAX_PLANT_PHOSPHORUS * 0.5    // P - For root development, flowering, fruiting
	var/potassium = MAX_PLANT_POTASSIUM * 0.5      // K - For overall plant health, disease resistance
	/// Amount of plant health, if it drops to zero the plant won't grow, make produce and will have to be uprooted.
	var/plant_health = MAX_PLANT_HEALTH
	/// The plant that is currently planted, it is a reference to a singleton
	var/datum/plant_def/plant = null
	///our plant genetics
	var/datum/plant_genetics/plant_genetics
	/// Time of growth so far
	var/growth_time = 0
	/// Time of making produce so far
	var/produce_time = 0
	/// Whether the plant has matured
	var/matured = FALSE
	/// Whether the produce is ready for harvest
	var/produce_ready = FALSE
	/// Whether the plant is dead
	var/plant_dead = FALSE
	/// The time remaining in which the soil has been tilled and will help the plant grow
	var/tilled_time = 0
	/// The time remaining in which the soil was blessed and will help the plant grow, and make weeds decay
	var/blessed_time = 0
	///the time remaining in which the soil is pollinated.
	var/pollination_time = 0
	/// Time remaining for the soil to decay and destroy itself, only applicable when its out of water and nutriments and has no plant
	var/soil_decay_time = SOIL_DECAY_TIME
	/// Current quality tier of the crop (1-5, regular to diamond)
	var/crop_quality = QUALITY_REGULAR
	/// Tracks quality points that accumulate toward quality tier increases
	var/quality_points = 0
	///accellerated_growth
	var/accellerated_growth = 0
	/// Soil overlay icon state
	var/tilled_overlay = "soil-tilled"
	/// Water overlay icon state
	var/water_overlay = "soil-overlay"

	///the overlays we are adding to mobs
	var/list/vanished

	var/list/marked_turfs

	COOLDOWN_DECLARE(soil_update)

/obj/structure/soil/Crossed(atom/movable/AM)
	. = ..()
	if(isliving(AM))
		on_stepped(AM)

/obj/structure/soil/proc/user_harvests(mob/living/user)
	if(!produce_ready)
		return
	apply_farming_fatigue(user, 4)
	add_sleep_experience(user, /datum/skill/labor/farming, user.STAINT * 2)

	return_nutrients_to_soil()
	var/farming_skill = user.get_skill_level(/datum/skill/labor/farming, TRUE)
	var/chance_to_ruin = 50 - (farming_skill * 25)
	if(prob(chance_to_ruin))
		ruin_produce()
		to_chat(user, span_warning("I ruin the produce..."))
		return
	var/feedback = "I harvest the produce."
	var/modifier = 0
	var/chance_to_get_extra = -75 + (farming_skill * 25)
	var/chance_to_ruin_single = 75 - (farming_skill * 25)
	if(prob(chance_to_get_extra))
		feedback = "I harvest the produce well."
		modifier += 1
	else if(prob(chance_to_ruin_single))
		feedback = "I harvest the produce, ruining a little."
		modifier -= 1

	if(has_world_trait(/datum/world_trait/dendor_fertility))
		feedback = "Praise Dendor for our harvest is bountiful."
		modifier += is_ascendant(DENDOR) ? 4 : 3

	if(user.client)
		record_featured_stat(FEATURED_STATS_FARMERS, user)
		record_featured_object_stat(FEATURED_STATS_CROPS, plant.name)
		record_round_statistic(STATS_PLANTS_HARVESTED)
	to_chat(user, span_notice(feedback))
	yield_produce(modifier)
	SEND_SIGNAL(user, COMSIG_PLANT_HARVESTED)

/obj/structure/soil/proc/try_handle_harvest(obj/item/attacking_item, mob/user)
	if(istype(attacking_item, /obj/item/weapon/sickle))
		if(!plant || !produce_ready)
			to_chat(user, span_warning("There is nothing to harvest!"))
			return TRUE
		user_harvests(user)
		playsound(src,'sound/items/seed.ogg', 100, FALSE)
		return TRUE
	return FALSE

/obj/structure/soil/proc/try_handle_seed_planting(obj/item/attacking_item, mob/user)
	var/obj/item/old_item
	if(istype(attacking_item, /obj/item/storage/sack))
		var/list/seeds = list()
		for(var/obj/item/neuFarm/seed/seed in attacking_item.contents)
			seeds |= seed
		old_item = attacking_item
		if(LAZYLEN(seeds))
			attacking_item = pick(seeds)

	if(istype(attacking_item, /obj/item/neuFarm/seed)) //SLOP OBJECT PROC SHARING
		playsound(src, pick('sound/foley/touch1.ogg','sound/foley/touch2.ogg','sound/foley/touch3.ogg'), 170, TRUE)
		if(do_after(user, get_farming_do_time(user, 15), src))
			if(old_item)
				SEND_SIGNAL(old_item, COMSIG_TRY_STORAGE_TAKE, attacking_item, get_turf(user), TRUE)
			var/obj/item/neuFarm/seed/seeds = attacking_item
			seeds.try_plant_seed(user, src)
		return TRUE
	return FALSE

/obj/structure/soil/proc/try_handle_uprooting(obj/item/attacking_item, mob/user)
	if(istype(attacking_item, /obj/item/weapon/shovel))
		var/obj/item/weapon/shovel/shovel = attacking_item
		to_chat(user, span_notice("I begin to uproot the crop..."))
		playsound(src,'sound/items/dig_shovel.ogg', 100, TRUE)
		if(do_after(user, get_farming_do_time(user, 4 SECONDS * shovel.time_multiplier), src))
			to_chat(user, span_notice("I uproot the crop."))
			playsound(src,'sound/items/dig_shovel.ogg', 100, TRUE)
			uproot()
		return TRUE
	return FALSE

/obj/structure/soil/proc/try_handle_tilling(obj/item/attacking_item, mob/user)
	if(istype(attacking_item, /obj/item/weapon/hoe))
		var/obj/item/weapon/hoe/hoe = attacking_item
		to_chat(user, span_notice("I begin to till the soil..."))
		playsound(src,'sound/items/dig_shovel.ogg', 100, TRUE)
		if(do_after(user, get_farming_do_time(user, 3 SECONDS * hoe.time_multiplier), src))
			to_chat(user, span_notice("I till the soil."))
			playsound(src,'sound/items/dig_shovel.ogg', 100, TRUE)
			user_till_soil(user)
		return TRUE
	return FALSE

/obj/structure/soil/proc/try_handle_watering(obj/item/attacking_item, mob/user)
	var/water_amount = 0
	if(istype(attacking_item, /obj/item/reagent_containers))
		if(water >= MAX_PLANT_WATER * 0.8)
			to_chat(user, span_warning("The soil is already wet!"))
			return TRUE
		var/obj/item/reagent_containers/container = attacking_item
		if(container.reagents.has_reagent(/datum/reagent/water, 15))
			container.reagents.remove_reagent(/datum/reagent/water, 15)
			water_amount = 150
		else if(container.reagents.has_reagent(/datum/reagent/water/gross, 30))
			container.reagents.remove_reagent(/datum/reagent/water/gross, 30)
			water_amount = 150
		else
			to_chat(user, span_warning("There's no water in \the [container]!"))
			return TRUE
	if(water_amount > 0)
		var/list/wash = list('sound/foley/waterwash (1).ogg','sound/foley/waterwash (2).ogg')
		playsound(user, pick_n_take(wash), 100, FALSE)
		to_chat(user, span_notice("I water the soil."))
		adjust_water(water_amount)
		return TRUE
	return FALSE

/obj/structure/soil/proc/try_handle_fertilizing(obj/item/attacking_item, mob/user)
	var/fertilize_success = FALSE

	if(istype(attacking_item, /obj/item/fertilizer))
		var/obj/item/fertilizer/fert = attacking_item
		fertilize_success = apply_fertilizer(fert, user)
	else if(istype(attacking_item, /obj/item/natural/poo))
		// Manure is balanced NPK with high nitrogen
		if(can_accept_fertilizer())
			to_chat(user, span_notice("I fertilize the soil with manure."))
			adjust_nitrogen(60)
			adjust_phosphorus(40)
			adjust_potassium(50)
			fertilize_success = TRUE
		else
			to_chat(user, span_warning("The soil is already well fertilized!"))
	if(fertilize_success)
		qdel(attacking_item)
		return TRUE
	return FALSE

/obj/structure/soil/proc/can_accept_fertilizer()
	return (nitrogen < MAX_PLANT_NITROGEN * 0.8 || phosphorus < MAX_PLANT_PHOSPHORUS * 0.8 || potassium < MAX_PLANT_POTASSIUM * 0.8)

/obj/structure/soil/proc/apply_fertilizer(obj/item/fertilizer/fert, mob/user)
	if(!can_accept_fertilizer())
		to_chat(user, span_warning("The soil is already well fertilized!"))
		return FALSE

	to_chat(user, span_notice("I fertilize the soil with [fert.name]."))
	adjust_nitrogen(fert.nitrogen_content)
	adjust_phosphorus(fert.phosphorus_content)
	adjust_potassium(fert.potassium_content)
	return TRUE

/obj/structure/soil/proc/try_handle_deweed(obj/item/attacking_item, mob/living/user)
	if(weeds < MAX_PLANT_WEEDS * 0.3)
		return FALSE
	if(attacking_item == null)
		to_chat(user, span_notice("I begin ripping out the weeds with my hands..."))
		if(do_after(user, get_farming_do_time(user, 3 SECONDS), src))
			apply_farming_fatigue(user, 20)
			to_chat(user, span_notice("I rip out the weeds."))
			deweed()
			add_sleep_experience(user, /datum/skill/labor/farming, user.STAINT * 0.2)
			SEND_SIGNAL(user, COMSIG_PLANT_TENDED)
		return TRUE
	if(istype(attacking_item, /obj/item/weapon/hoe))
		apply_farming_fatigue(user, 10)
		to_chat(user, span_notice("I rip out the weeds with the [attacking_item]"))
		deweed()
		add_sleep_experience(user, /datum/skill/labor/farming, user.STAINT * 0.2)
		SEND_SIGNAL(user, COMSIG_PLANT_TENDED)
		return TRUE
	return FALSE

/obj/structure/soil/proc/try_handle_flatten(obj/item/attacking_item, mob/user)
	if(plant)
		return FALSE
	if(istype(attacking_item, /obj/item/weapon/shovel))
		to_chat(user, span_notice("I begin flattening the soil with \the [attacking_item]..."))
		var/obj/item/weapon/shovel/shovel = attacking_item
		playsound(src,'sound/items/dig_shovel.ogg', 100, TRUE)
		if(do_after(user, get_farming_do_time(user, 3 SECONDS * shovel.time_multiplier), src))
			if(plant)
				return FALSE
			apply_farming_fatigue(user, 10)
			playsound(src,'sound/items/dig_shovel.ogg', 100, TRUE)
			to_chat(user, span_notice("I flatten the soil."))
			decay_soil()
		return TRUE
	return FALSE

/obj/structure/soil/attack_hand(mob/living/user)
	if(plant && produce_ready)
		to_chat(user, span_notice("I begin collecting the produce..."))
		if(do_after(user, get_farming_do_time(user, 4 SECONDS), src))
			playsound(src,'sound/items/seed.ogg', 100, FALSE)
			user_harvests(user)
		return
	if(plant && plant_dead)
		to_chat(user, span_notice("I begin to remove the dead crop..."))
		if(do_after(user, get_farming_do_time(user, 6 SECONDS), src))
			if(!plant || !plant_dead)
				return
			apply_farming_fatigue(user, 10)
			to_chat(user, span_notice("I remove the crop."))
			playsound(src,'sound/items/seed.ogg', 100, FALSE)
			uproot()
			add_sleep_experience(user, /datum/skill/labor/farming, user.STAINT * 0.2)
		return
	. = ..()

/obj/structure/soil/attack_hand_secondary(mob/user, list/modifiers)
	. = ..()
	if(. == SECONDARY_ATTACK_CANCEL_ATTACK_CHAIN)
		return
	user.changeNext_move(CLICK_CD_FAST)
	if(try_handle_deweed(null, user, null))
		return SECONDARY_ATTACK_CANCEL_ATTACK_CHAIN

/obj/structure/soil/attackby_secondary(obj/item/weapon, mob/user, list/modifiers)
	. = ..()
	if(. == SECONDARY_ATTACK_CANCEL_ATTACK_CHAIN)
		return
	user.changeNext_move(CLICK_CD_FAST)
	if(try_handle_deweed(weapon, user, null))
		return SECONDARY_ATTACK_CANCEL_ATTACK_CHAIN
	if(try_handle_flatten(weapon, user, null))
		return SECONDARY_ATTACK_CANCEL_ATTACK_CHAIN

/obj/structure/soil/attackby(obj/item/attacking_item, mob/user, list/modifiers)
	user.changeNext_move(CLICK_CD_FAST)
	if(try_handle_seed_planting(attacking_item, user))
		return
	if(try_handle_uprooting(attacking_item, user))
		return
	if(try_handle_tilling(attacking_item, user))
		return
	if(try_handle_watering(attacking_item, user))
		return
	if(try_handle_harvest(attacking_item, user))
		return
	if(try_handle_fertilizing(attacking_item, user))
		return
	for(var/obj/item/bagged_item in attacking_item.contents)
		if(try_handle_fertilizing(bagged_item, user))
			return
	return ..()

/obj/structure/soil/proc/on_stepped(mob/living/stepper)
	if(!plant)
		return
	if(istype(stepper, /mob/living/simple_animal/hostile/gnome_homunculus))//prevents damaging of plants
		return
	if(stepper.m_intent == MOVE_INTENT_SNEAK)
		return
	if(stepper.m_intent == MOVE_INTENT_WALK)
		adjust_plant_health(-2.5)
	else if(stepper.m_intent == MOVE_INTENT_RUN)
		adjust_plant_health(-5)
	playsound(src, "plantcross", 90, FALSE)

/obj/structure/soil/proc/deweed()
	if(weeds >= MAX_PLANT_WEEDS * 0.3)
		playsound(src, "plantcross", 90, FALSE)
	adjust_weeds(-100)

/obj/structure/soil/proc/user_till_soil(mob/user)
	apply_farming_fatigue(user, 10)
	till_soil(15 MINUTES * get_farming_effort_multiplier(user))

/obj/structure/soil/proc/till_soil(time = 30 MINUTES)
	tilled_time = time
	adjust_plant_health(-20, FALSE)
	adjust_weeds(-30, FALSE)
	if(plant)
		playsound(src, "plantcross", 90, FALSE)
	update_appearance(UPDATE_OVERLAYS)

/obj/structure/soil/proc/bless_soil()
	blessed_time = 15 MINUTES
	// It's a miracle! Plant comes back to life when blessed by Dendor
	if(plant && plant_dead)
		plant_dead = FALSE
		plant_health = 10.0
		update_appearance(UPDATE_OVERLAYS)

	// Dendor provides balanced nutrients if low
	if(nitrogen < 30)
		adjust_nitrogen(max(30 - nitrogen, 0))
	if(phosphorus < 30)
		adjust_phosphorus(max(30 - phosphorus, 0))
	if(potassium < 30)
		adjust_potassium(max(30 - potassium, 0))

	// If low on water, Dendor provides
	if(water < 30)
		adjust_water(max(30 - water, 0))

	// And it grows a little!
	if(plant)
		if(add_growth(2 MINUTES))
			update_appearance(UPDATE_OVERLAYS)

/// adjust water
/obj/structure/soil/proc/adjust_water(adjust_amount)
	water = clamp(water + adjust_amount, 0, MAX_PLANT_WATER)

/obj/structure/soil/proc/adjust_nitrogen(amount)
	nitrogen = clamp(nitrogen + amount, 0, MAX_PLANT_NITROGEN)

/obj/structure/soil/proc/adjust_phosphorus(amount)
	phosphorus = clamp(phosphorus + amount, 0, MAX_PLANT_PHOSPHORUS)

/obj/structure/soil/proc/adjust_potassium(amount)
	potassium = clamp(potassium + amount, 0, MAX_PLANT_POTASSIUM)

/obj/structure/soil/proc/get_total_npk()
	return nitrogen + phosphorus + potassium

/// adjust weeds
/obj/structure/soil/proc/adjust_weeds(adjust_amount)
	weeds = clamp(weeds + adjust_amount, 0, MAX_PLANT_WEEDS)

/// adjust plant health. Returns whether to force an overlay update.
/obj/structure/soil/proc/adjust_plant_health(adjust_amount)
	if(!plant || plant_dead)
		return

	plant_health = clamp(plant_health + adjust_amount, 0, MAX_PLANT_HEALTH)

	if(plant_health <= 0)
		plant_dead = TRUE
		produce_ready = FALSE
		return TRUE

/obj/structure/soil/Initialize()
	START_PROCESSING(SSprocessing, src)
	GLOB.weather_act_upon_list += src
	. = ..()

/obj/structure/soil/Destroy()
	STOP_PROCESSING(SSprocessing, src)
	remove_signals()
	GLOB.weather_act_upon_list -= src
	. = ..()

/obj/structure/soil/weather_act_on(weather_trait, severity)
	if(weather_trait != PARTICLEWEATHER_RAIN)
		return
	water = min(MAX_PLANT_WATER, water + min(5, severity / 4))

/obj/structure/soil/process()
	var/dt = 10
	var/force_update = FALSE
	process_weeds(dt)
	force_update = process_plant(dt)
	if(world.time < accellerated_growth)
		force_update = process_plant(dt)
	process_soil(dt)
	if(soil_decay_time <= 0)
		decay_soil(TRUE)
		return
	if(force_update)
		update_appearance(UPDATE_OVERLAYS)
		return
	if(!COOLDOWN_FINISHED(src, soil_update))
		return
	COOLDOWN_START(src, soil_update, 10 SECONDS)
	update_appearance(UPDATE_OVERLAYS) // only update icon after all the processes have run

/obj/structure/soil/update_overlays()
	. = ..()
	if(tilled_time > 0)
		. += tilled_overlay
	. += get_water_overlay()
	. += get_nutri_overlay()
	if(plant)
		. += get_plant_overlay()
	if(weeds >= MAX_PLANT_WEEDS * 0.6)
		. += "weeds2"
	else if (weeds >= MAX_PLANT_WEEDS * 0.3)
		. += "weeds1"

/obj/structure/soil/proc/get_water_overlay()
	return mutable_appearance(
		icon,
		water_overlay,
		color = "#000033",
		alpha = (100 * (water / MAX_PLANT_WATER)),
	)

/obj/structure/soil/proc/get_nutri_overlay()
	return mutable_appearance(
		icon,
		tilled_overlay,
		color = "#6d3a00",
		alpha = (50 * (get_total_npk() / MAX_PLANT_NUTRITION)),
	)

/obj/structure/soil/proc/get_plant_overlay()
	var/plant_color
	var/health_percent = plant_health / MAX_PLANT_HEALTH
	if(!plant_dead)
		if(health_percent < 0.3)
			plant_color = "#9c7b43"
		else if(health_percent < 0.6)
			plant_color = "#d8b573"
	var/plant_state = "[plant.icon_state]3"
	if(!plant_dead)
		if(produce_ready)
			plant_state = "[plant.icon_state]2"
		else if(matured)
			plant_state = "[plant.icon_state]1"
		else
			plant_state = "[plant.icon_state]0"

	if(istype(plant, /datum/plant_def/alchemical))
		if(plant_state == "[plant.icon_state]0")
			plant_state = "herb0"
		else if(plant_state == "[plant.icon_state]3")
			plant_state = "herb3"

	return mutable_appearance(plant.icon, plant_state, color = plant_color)

/obj/structure/soil/examine(mob/user)
	. = ..()
	// Plant description
	if(plant)
		. += span_info("\The [plant.name] is growing here...")
		// Plant health feedback
		if(plant_dead == TRUE)
			. += span_warning("It's dead!")
		else if(plant_health <=  MAX_PLANT_HEALTH * 0.3)
			. += span_warning("It's dying!")
		else if (plant_health <=  MAX_PLANT_HEALTH * 0.6)
			. += span_warning("It's brown and unhealthy...")
		// Plant maturation and produce feedback
		if(matured)
			. += span_info("It's fully grown but perhaps not yet ripe.")
		else
			. += span_info("It's far from fully grown.")
		if(produce_ready)
			. += span_info("It's ready for harvest.")
	// Water feedback
	if(water <= MAX_PLANT_WATER * 0.15)
		. += span_warning("The soil is thirsty.")
	else if (water <= MAX_PLANT_WATER * 0.5)
		. += span_info("The soil is moist.")
	else
		. += span_info("The soil is wet.")
	// Nutrition feedback
	if(nitrogen < MAX_PLANT_NITROGEN * 0.15)
		. += span_warning("The plant is lacking Nitrogen.")
	else if(nitrogen < MAX_PLANT_NITROGEN * 0.3)
		. += span_info("The plant is running low on Nitrogen.")
	if(potassium < MAX_PLANT_POTASSIUM * 0.15)
		. += span_warning("The plant is lacking Potassium.")
	else if(potassium < MAX_PLANT_POTASSIUM * 0.3)
		. += span_info("The plant is running low on Potassium.")
	if(phosphorus < MAX_PLANT_PHOSPHORUS * 0.15)
		. += span_warning("The plant is lacking Phosphorus.")
	else if(phosphorus < MAX_PLANT_PHOSPHORUS * 0.3)
		. += span_info("The plant is running low on Phosphorus.")
	// Weeds feedback
	if(weeds >= MAX_PLANT_WEEDS * 0.6)
		. += span_warning("It's overtaken by the weeds!")
	else if (weeds >= MAX_PLANT_WEEDS * 0.3)
		. += span_warning("Weeds are growing out...")
	// Tilled feedback
	if(tilled_time > 0)
		. += span_info("The soil is tilled.")
	// Blessed feedback
	if(blessed_time > 0)
		. += span_good("The soil seems blessed.")
	if(pollination_time > 0)
		. += span_good("The soil has been pollinated.")

/obj/structure/soil/proc/process_weeds(dt)
	// Blessed soil will have the weeds die
	if(blessed_time > 0)
		adjust_weeds(-dt * BLESSING_WEED_DECAY_RATE)
	if(plant && plant.weed_immune)
		// Weeds die if the plant is immune to them
		adjust_weeds(-dt * WEED_RESISTANCE_DECAY_RATE)
		return
	if(water <= 0)
		// Weeds die without water in soil
		adjust_weeds(-dt * WEED_DECAY_RATE)
		return

	// Weeds eat water and NPK nutrients to grow
	var/weed_factor = weeds / MAX_PLANT_WEEDS
	adjust_water(-dt * weed_factor * WEED_WATER_CONSUMPTION_RATE)
	adjust_nitrogen(-dt * weed_factor * WEED_NUTRITION_CONSUMPTION_RATE)
	adjust_phosphorus(-dt * weed_factor * WEED_NUTRITION_CONSUMPTION_RATE)
	adjust_potassium(-dt * weed_factor * WEED_NUTRITION_CONSUMPTION_RATE)

	if((get_total_npk() > 0) && plant_genetics)
		var/genetic_value = (100 - plant_genetics.disease_resistance) * 0.03
		adjust_weeds(dt * WEED_GROWTH_RATE * genetic_value)

/obj/structure/soil/proc/process_plant(dt)
	if(!plant)
		return
	if(plant_dead)
		return
	var/should_update
	process_plant_nutrition(dt)
	should_update = process_plant_health(dt)
	if(!produce_ready)
		process_crop_quality(dt)
	return should_update

/obj/structure/soil/proc/process_crop_quality(dt)
	if(!plant || plant_dead || produce_ready)
		return

	var/quality_potential = 0.5
	if(plant_genetics)
		var/genetics_trait = plant_genetics.quality_trait
		if(genetics_trait <= 40)
			quality_potential = 0.2 + (genetics_trait / 40) * 0.3
		else if(genetics_trait <= 60)
			quality_potential = 0.5 + ((genetics_trait - 40) / 20) * 0.2
		else
			quality_potential = 0.7 + ((genetics_trait - 60) / 40) * 0.5

	var/growth_bonus = clamp((1 - (plant.maturation_time / (12 MINUTES))) * 0.3, -0.2, 0.3)
	quality_potential += growth_bonus
	quality_potential = clamp(quality_potential, 0.1, 1.5)

	var/conditions_quality = 0.7
	if(tilled_time > 0)
		conditions_quality += 0.1
	if(pollination_time > 0)
		conditions_quality += 0.15
	if(blessed_time > 0)
		conditions_quality += 0.2
	if(has_world_trait(/datum/world_trait/dendor_fertility))
		conditions_quality += is_ascendant(DENDOR) ? 0.4 : 0.2

	var/npk_balance_quality = calculate_npk_quality_modifier()
	conditions_quality *= npk_balance_quality

	// Water requirements
	if(water >= MAX_PLANT_WATER * 0.9)
		conditions_quality += 0.2
	else if(water >= MAX_PLANT_WATER * 0.7)
		conditions_quality += 0.1
	else if(water < MAX_PLANT_WATER * 0.5)
		conditions_quality *= 0.7
	else if(water < MAX_PLANT_WATER * 0.3)
		conditions_quality *= 0.5

	// Weed penalties
	if(weeds >= MAX_PLANT_WEEDS * 0.6)
		conditions_quality *= 0.6
	else if(weeds >= MAX_PLANT_WEEDS * 0.3)
		conditions_quality *= 0.8

	conditions_quality = clamp(conditions_quality, 0.1, 1.8)

	var/quality_rate = quality_potential * conditions_quality

	// Phase-based quality accumulation rates
	var/phase_multiplier = 1.0
	if(!matured)
		phase_multiplier = 1.2

	// Calculate max quality points based on total potential time
	// Base time + production time + reasonable harvest window
	var/total_potential_time = plant.maturation_time + plant.produce_time + (20 MINUTES)
	var/max_quality_points = 30 * (total_potential_time / (6 MINUTES))

	var/progress_ratio = quality_points / max_quality_points
	var/diminishing_returns = 1 - (progress_ratio * 0.8)  // Slightly reduced diminishing returns

	// Accumulate quality points
	quality_points += (dt / 10) * quality_rate * 0.26 * phase_multiplier * diminishing_returns
	quality_points = min(quality_points, max_quality_points)

	// Quality tier thresholds
	if(quality_points >= max_quality_points * 0.9)
		crop_quality = QUALITY_DIAMOND
	else if(quality_points >= max_quality_points * 0.7)
		crop_quality = QUALITY_GOLD
	else if(quality_points >= max_quality_points * 0.5)
		crop_quality = QUALITY_SILVER
	else
		crop_quality = QUALITY_REGULAR

// Optional: Add a proc to show current quality progress to players
/obj/structure/soil/proc/get_quality_info()
	if(!matured || !plant)
		return "Plant not mature enough to assess quality."

	var/total_potential_time = plant.maturation_time + plant.produce_time + (20 MINUTES)
	var/max_quality_points = 30 * (total_potential_time / (6 MINUTES))
	var/progress_percent = round((quality_points / max_quality_points) * 100, 1)

	var/quality_name = "Regular"
	switch(crop_quality)
		if(QUALITY_SILVER)
			quality_name = "Silver"
		if(QUALITY_GOLD)
			quality_name = "Gold"
		if(QUALITY_DIAMOND)
			quality_name = "Diamond"

	return "Current Quality: [quality_name] ([progress_percent]% of maximum potential)"

// Calculate quality modifier based on NPK balance
/obj/structure/soil/proc/calculate_npk_quality_modifier()
	if(!plant)
		return 1.0

	// Check which nutrients are actually required
	var/needs_nitrogen = plant.nitrogen_requirement > 0
	var/needs_phosphorus = plant.phosphorus_requirement > 0
	var/needs_potassium = plant.potassium_requirement > 0
	var/nutrients_needed = needs_nitrogen + needs_phosphorus + needs_potassium

	// If plant needs no nutrients, return perfect quality
	if(nutrients_needed == 0)
		return 1.4

	// Calculate sufficiency for each required nutrient
	var/quality_factors = list()

	if(needs_nitrogen)
		var/n_sufficiency = min(nitrogen / plant.nitrogen_requirement, 2.0)
		quality_factors += n_sufficiency

	if(needs_phosphorus)
		var/p_sufficiency = min(phosphorus / plant.phosphorus_requirement, 2.0)
		quality_factors += p_sufficiency

	if(needs_potassium)
		var/k_sufficiency = min(potassium / plant.potassium_requirement, 2.0)
		quality_factors += k_sufficiency

	// For single-nutrient plants, use simple sufficiency
	if(nutrients_needed == 1)
		var/sufficiency = quality_factors[1]
		// Convert sufficiency to quality modifier (0.5 to 1.4 range)
		if(sufficiency <= 0.1)
			return 0.5  // Severe deficiency
		else if(sufficiency >= 1.0)
			return clamp(1.0 + (sufficiency - 1.0) * 0.4, 1.0, 1.4)  // Bonus for excess
		else
			return clamp(0.5 + (sufficiency * 0.5), 0.5, 1.0)  // Scaling up to normal

	// For multi-nutrient plants, calculate balance
	var/total_requirements = plant.nitrogen_requirement + plant.phosphorus_requirement + plant.potassium_requirement
	var/total_available = 0

	if(needs_nitrogen)
		total_available += nitrogen
	if(needs_phosphorus)
		total_available += phosphorus
	if(needs_potassium)
		total_available += potassium

	if(total_available <= 0)
		return 0.5  // Severe nutrient deficiency

	// Calculate ideal vs actual ratios only for required nutrients
	var/deviation_sum = 0

	if(needs_nitrogen)
		var/ideal_n_ratio = plant.nitrogen_requirement / total_requirements
		var/actual_n_ratio = nitrogen / total_available
		deviation_sum += abs(actual_n_ratio - ideal_n_ratio)

	if(needs_phosphorus)
		var/ideal_p_ratio = plant.phosphorus_requirement / total_requirements
		var/actual_p_ratio = phosphorus / total_available
		deviation_sum += abs(actual_p_ratio - ideal_p_ratio)

	if(needs_potassium)
		var/ideal_k_ratio = plant.potassium_requirement / total_requirements
		var/actual_k_ratio = potassium / total_available
		deviation_sum += abs(actual_k_ratio - ideal_k_ratio)

	// Convert deviation to balance modifier
	var/balance_modifier = clamp(1.4 - (deviation_sum * 2), 0.6, 1.4)

	// Overall availability modifier
	var/availability_ratio = total_available / total_requirements
	var/availability_modifier = clamp(0.5 + (availability_ratio * 0.5), 0.5, 1.4)

	// Average sufficiency of required nutrients
	var/avg_sufficiency = 0
	for(var/factor in quality_factors)
		avg_sufficiency += factor
	avg_sufficiency /= nutrients_needed
	avg_sufficiency = min(avg_sufficiency, 1.0)

	// Combine all factors
	return balance_modifier * availability_modifier * (0.8 + avg_sufficiency * 0.4)

/obj/structure/soil/proc/process_plant_health(dt)
	if(!plant)
		return
	var/drain_rate = plant.water_drain_rate
	var/should_update = FALSE

	if(plant_genetics)
		var/efficiency_modifier = (plant_genetics.water_efficiency - TRAIT_GRADE_AVERAGE) / 100
		drain_rate *= (1 - efficiency_modifier * 0.4) // Up to 20% less water consumption

	var/weed_damage_multiplier = 1.0
	if(plant_genetics)
		var/hardiness_modifier = (plant_genetics.cold_resistance - TRAIT_GRADE_AVERAGE) / 100
		weed_damage_multiplier = (1 - hardiness_modifier * 0.5) // Up to 25% less weed damage

	// Lots of weeds harm the plant
	if(weeds >= MAX_PLANT_WEEDS * 0.6)
		should_update |= adjust_plant_health(-dt * PLANT_WEEDS_HARM_RATE * weed_damage_multiplier)

	// Regenerate plant health if we dont drain water, or we have the water
	if(drain_rate <= 0 || water > 0)
		should_update |= adjust_plant_health(dt * PLANT_REGENERATION_RATE)
	if(drain_rate > 0)
		// If we're dry and we want to drain water, we loose health
		if(water <= 0)
			should_update |= adjust_plant_health(-dt * PLANT_DECAY_RATE)
		else
			// Drain water with genetics modifier
			adjust_water(-dt * drain_rate)
	// Blessed plants heal!!
	if(blessed_time > 0)
		should_update |= adjust_plant_health(dt * PLANT_BLESS_HEAL_RATE)
	return should_update

/obj/structure/soil/proc/improve_genetics_naturally()
	if(!plant_genetics)
		return new /datum/plant_genetics()

	var/datum/plant_genetics/improved = plant_genetics.copy()

	// Small chance to improve each trait based on growing conditions
	var/improvement_chance = 10

	// Better conditions = higher improvement chance
	if(blessed_time > 0)
		improvement_chance += 15
	if(tilled_time > 0)
		improvement_chance += 10
	if(pollination_time > 0)
		improvement_chance += 10
	if(crop_quality >= QUALITY_SILVER) // the rich get richer
		improvement_chance += 20

	// Improve two random traits
	if(prob(improvement_chance))
		improved.mutate_traits(amount = 2)

	improved.generation += 1
	return improved

/obj/structure/soil/proc/process_plant_nutrition(dt)
	if(!plant)
		return
	var/turf/location = loc
	if(!plant.can_grow_underground && !location.can_see_sky())
		return
	// If matured and produce is ready, don't process plant nutrition
	if(matured && produce_ready)
		return
	var/drain_rate = plant.water_drain_rate
	// If we drain water, and have no water, we can't grow
	if(drain_rate > 0 && water <= 0)
		return

	var/growth_multiplier = 1.0
	var/nutriment_eat_multiplier = 1.0

	// Environmental modifiers
	if(tilled_time > 0)
		growth_multiplier *= 1.6
	if(blessed_time > 0)
		growth_multiplier *= 2.0
		nutriment_eat_multiplier *= 0.4
	if(pollination_time > 0)
		growth_multiplier *= 1.75
		nutriment_eat_multiplier *= 0.6
	if(has_world_trait(/datum/world_trait/dendor_fertility))
		growth_multiplier *= is_ascendant(DENDOR) ? 2.5 : 2.0
		nutriment_eat_multiplier *= is_ascendant(DENDOR) ? 0.3 : 0.4
	if(has_world_trait(/datum/world_trait/fertility))
		growth_multiplier *= 1.5
	if(has_world_trait(/datum/world_trait/dendor_drought))
		growth_multiplier *= is_ascendant(DENDOR) ? 0.3 : 0.4
		nutriment_eat_multiplier *= is_ascendant(DENDOR) ? 2.5 : 2

	// Weed interference
	if(weeds >= MAX_PLANT_WEEDS * 0.3)
		growth_multiplier *= 0.75
	if(weeds >= MAX_PLANT_WEEDS * 0.6)
		growth_multiplier *= 0.75

	// Health-based growth reduction
	if(plant_health <= MAX_PLANT_HEALTH * 0.6)
		growth_multiplier *= 0.75
	if(plant_health <= MAX_PLANT_HEALTH * 0.3)
		growth_multiplier *= 0.75

	// Mushrooms are more efficient in the mushroom mound
	if(istype(src, /obj/structure/soil/mushmound) && plant.mound_growth)
		growth_multiplier *= 1.2
		nutriment_eat_multiplier *= 0.8
	var/target_growth_time = growth_multiplier * dt
	return process_npk_growth(target_growth_time, nutriment_eat_multiplier, dt)

/obj/structure/soil/proc/process_npk_growth(target_growth_time, nutriment_multiplier = 1.0, dt)
	if(!plant)
		return

	// Calculate base NPK requirements for this time step
	var/nitrogen_needed = 0
	var/phosphorus_needed = 0
	var/potassium_needed = 0
	var/total_growth_time

	if(plant.perennial) //perennials are hungry fucks
		if(!matured)
			// Maturation phase
			total_growth_time = plant.maturation_time
			if(plant.nitrogen_requirement > 0)
				nitrogen_needed = (plant.nitrogen_requirement / total_growth_time) * target_growth_time
			if(plant.phosphorus_requirement > 0)
				phosphorus_needed = (plant.phosphorus_requirement / total_growth_time) * target_growth_time
			if(plant.potassium_requirement > 0)
				potassium_needed = (plant.potassium_requirement / total_growth_time) * target_growth_time
		else
			// Production phase, perennials use nutrients more "effectively" and need less
			total_growth_time = plant.produce_time
			if(plant.nitrogen_requirement > 0)
				nitrogen_needed = ((plant.nitrogen_requirement * 0.6) / total_growth_time) * target_growth_time
			if(plant.phosphorus_requirement > 0)
				phosphorus_needed = ((plant.phosphorus_requirement * 0.6) / total_growth_time) * target_growth_time
			if(plant.potassium_requirement > 0)
				potassium_needed = ((plant.potassium_requirement * 0.6)/ total_growth_time) * target_growth_time
	else
		total_growth_time = plant.maturation_time + plant.produce_time
		if(plant.nitrogen_requirement > 0)
			nitrogen_needed = (plant.nitrogen_requirement / total_growth_time) * target_growth_time
		if(plant.phosphorus_requirement > 0)
			phosphorus_needed = (plant.phosphorus_requirement / total_growth_time) * target_growth_time
		if(plant.potassium_requirement > 0)
			potassium_needed = (plant.potassium_requirement / total_growth_time) * target_growth_time

	// Apply nutrient multipliers only to nutrients that are actually needed
	if(nitrogen_needed > 0)
		nitrogen_needed *= nutriment_multiplier
	if(phosphorus_needed > 0)
		phosphorus_needed *= nutriment_multiplier
	if(potassium_needed > 0)
		potassium_needed *= nutriment_multiplier

	// Apply genetics modifiers if available
	if(plant_genetics)
		var/efficiency_modifier = (plant_genetics.water_efficiency - TRAIT_GRADE_AVERAGE) / 100
		if(nitrogen_needed > 0)
			nitrogen_needed *= (1 - efficiency_modifier * 0.3)
		if(phosphorus_needed > 0)
			phosphorus_needed *= (1 - efficiency_modifier * 0.3)
		if(potassium_needed > 0)
			potassium_needed *= (1 - efficiency_modifier * 0.3)

	// Check availability and calculate factors for each nutrient that's actually needed
	var/nitrogen_factor = 0
	var/phosphorus_factor = 0
	var/potassium_factor = 0

	if(nitrogen_needed > 0)
		var/nitrogen_available = min(nitrogen_needed, nitrogen)
		nitrogen_factor = nitrogen_available / nitrogen_needed

	if(phosphorus_needed > 0)
		var/phosphorus_available = min(phosphorus_needed, phosphorus)
		phosphorus_factor = phosphorus_available / phosphorus_needed

	if(potassium_needed > 0)
		var/potassium_available = min(potassium_needed, potassium)
		potassium_factor = potassium_available / potassium_needed

	// Find the best available nutrient (highest satisfaction ratio)
	var/limiting_factor = max(nitrogen_factor, phosphorus_factor, potassium_factor)

	// If no nutrients are needed, allow full growth
	if(nitrogen_needed == 0 && phosphorus_needed == 0 && potassium_needed == 0)
		limiting_factor = 1.0

	// Consume only the nutrient that's providing the growth
	if(limiting_factor > 0)
		if(nitrogen_factor == limiting_factor && nitrogen_needed > 0)
			adjust_nitrogen(-nitrogen_needed * limiting_factor)
		else if(phosphorus_factor == limiting_factor && phosphorus_needed > 0)
			adjust_phosphorus(-phosphorus_needed * limiting_factor)
		else if(potassium_factor == limiting_factor && potassium_needed > 0)
			adjust_potassium(-potassium_needed * limiting_factor)

	// Apply growth based on limiting factor
	var/actual_growth_time = target_growth_time * limiting_factor
	// Each deficient nutrient lowers growth rate by 5%
	if(nitrogen_needed && nitrogen_factor < 0.1)
		actual_growth_time *= 0.95
	if(phosphorus_needed && phosphorus_factor < 0.1)
		actual_growth_time *= 0.95
	if(potassium_needed && potassium_factor < 0.1)
		actual_growth_time *= 0.95

	// Nutrient deficiency affects plant health only if nutrients are required but unavailable
	var/any_nutrients_needed = (nitrogen_needed > 0 || phosphorus_needed > 0 || potassium_needed > 0)
	if(any_nutrients_needed && limiting_factor < 0.1)
		adjust_plant_health(-dt * NUTRIENT_DEFICIENCY_DAMAGE_RATE)

	return add_growth(actual_growth_time)

/obj/structure/soil/proc/return_nutrients_to_soil()
	if(!plant)
		return

	adjust_nitrogen(plant.nitrogen_production)
	adjust_phosphorus(plant.phosphorus_production)
	adjust_potassium(plant.potassium_production)

	for(var/direction in GLOB.cardinals)
		var/turf/cardinal_turf = get_step(src, direction)
		for(var/obj/structure/soil/soil in cardinal_turf)
			if(soil == src)
				continue
			soil.adjust_nitrogen(FLOOR(plant.nitrogen_production, 1) / 2)
			soil.adjust_phosphorus(FLOOR(plant.phosphorus_production, 1) / 2)
			soil.adjust_potassium(FLOOR(plant.potassium_production, 1) / 2)

/obj/structure/soil/proc/add_growth(added_growth)
	if(!plant)
		return
	growth_time += added_growth
	if(!matured)
		if(growth_time >= plant.maturation_time)
			matured = TRUE
			return TRUE
		return
	produce_time += added_growth
	if(produce_time >= plant.produce_time)
		produce_time -= plant.produce_time
		produce_ready = TRUE
		return TRUE

/obj/structure/soil/proc/process_soil(dt)
	var/found_irrigation = FALSE
	for(var/obj/structure/irrigation_channel/channel in range(1, src))
		if(!istype(channel))
			continue
		if(!channel.water_logged)
			continue
		found_irrigation = TRUE
		channel.water_parent.cached_use -= 0.05
		START_PROCESSING(SSobj, channel.water_parent)
		break
	// If plant exists and is not dead, nutriment or water is not zero, reset the decay timer
	if(get_total_npk() > 0 || water > 0 || (plant != null && plant_health > 0))
		soil_decay_time = SOIL_DECAY_TIME
	else
		// Otherwise, "decay" the soil
		soil_decay_time = max(soil_decay_time - dt, 0)

	if(!found_irrigation)
		adjust_water(-dt * SOIL_WATER_DECAY_RATE, FALSE)
	else
		adjust_water(dt)

	tilled_time = max(tilled_time - dt, 0)
	blessed_time = max(blessed_time - dt, 0)
	pollination_time = max(pollination_time - dt, 0)

/obj/structure/soil/proc/decay_soil()
	plant = null
	plant_genetics = null
	qdel(src)

/obj/structure/soil/proc/uproot(loot = TRUE)
	if(!plant)
		return
	adjust_weeds(-100) // we update icon lower (if needed)
	if(loot)
		yield_uproot_loot()
	if(produce_ready)
		ruin_produce()
	plant = null
	remove_signals()
	plant_genetics = null
	update_appearance(UPDATE_OVERLAYS)

/// Spawns uproot loot, such as a long from an apple tree when removing the tree
/obj/structure/soil/proc/yield_uproot_loot()
	if(!matured || !plant.uproot_loot)
		return
	for(var/loot_type in plant.uproot_loot)
		new loot_type(loc)

/// Yields produce on its tile if it's ready for harvest
/obj/structure/soil/proc/ruin_produce()
	produce_ready = FALSE
	update_appearance(UPDATE_OVERLAYS)

/// Yields produce on its tile if it's ready for harvest

/obj/structure/soil/proc/yield_produce(modifier = 0)
	if(!produce_ready || !plant_genetics)
		return

	// GENETICS: Enhanced yield calculation
	var/base_amount = rand(plant.produce_amount_min, plant.produce_amount_max)

	// Genetics yield bonus - more significant impact
	var/genetics_yield_bonus = max(round((plant_genetics.yield_trait - TRAIT_GRADE_AVERAGE) / 25), 0) // Every 25 points = +1 produce

	// Calculate final yield amount
	var/spawn_amount = max(base_amount + modifier + genetics_yield_bonus, 1)

	var/datum/plant_genetics/new_genetics = improve_genetics_naturally()

	for(var/i in 1 to spawn_amount)
		var/obj/item/produce = new plant.produce_type(loc)
		produce.set_quality(crop_quality)
		if(produce && istype(produce, /obj/item/reagent_containers/food/snacks/produce))
			var/obj/item/reagent_containers/food/snacks/produce/P = produce
			// Pass genetics to the produce for seed extraction
			P.source_genetics = new_genetics.copy()

	// Reset produce state
	produce_ready = FALSE
	if(!plant?.perennial)
		uproot(loot = FALSE)

	// Reset quality for next growth cycle if plant is perennial
	if(plant?.perennial)
		crop_quality = QUALITY_REGULAR
		quality_points = 0

	update_appearance(UPDATE_OVERLAYS)


/obj/structure/soil/proc/insert_plant(datum/plant_def/new_plant, datum/plant_genetics/new_genetics)
	if(plant)
		return
	plant = new_plant
	if(initial(new_plant.see_through))
		add_signals()
	plant_health = MAX_PLANT_HEALTH
	growth_time = 0
	produce_time = 0
	matured = FALSE
	produce_ready = FALSE
	plant_dead = FALSE
	plant_genetics = new_genetics
	// Reset quality values
	crop_quality = QUALITY_REGULAR
	quality_points = 0
	update_appearance(UPDATE_OVERLAYS)

/obj/structure/soil/proc/add_signals()
	var/turf/above = get_step(src, NORTH)
	RegisterSignal(above, COMSIG_ATOM_ENTERED, PROC_REF(on_entered))
	RegisterSignal(above, COMSIG_TURF_EXITED, PROC_REF(on_exited))
	LAZYADD(marked_turfs, above)
	RegisterSignal(get_step(above, WEST), COMSIG_ATOM_ENTERED, PROC_REF(on_entered))
	RegisterSignal(get_step(above, WEST), COMSIG_TURF_EXITED, PROC_REF(on_exited))
	LAZYADD(marked_turfs, get_step(above, WEST))
	RegisterSignal(get_step(above, EAST), COMSIG_ATOM_ENTERED, PROC_REF(on_entered))
	RegisterSignal(get_step(above, EAST), COMSIG_TURF_EXITED, PROC_REF(on_exited))
	LAZYADD(marked_turfs, get_step(above, EAST))

/obj/structure/soil/proc/remove_signals()
	var/turf/above = get_step(src, NORTH)
	UnregisterSignal(above, COMSIG_ATOM_ENTERED)
	UnregisterSignal(above, COMSIG_TURF_EXITED)
	UnregisterSignal(get_step(above, WEST), COMSIG_ATOM_ENTERED)
	UnregisterSignal(get_step(above, WEST), COMSIG_TURF_EXITED)
	UnregisterSignal(get_step(above, EAST), COMSIG_ATOM_ENTERED)
	UnregisterSignal(get_step(above, EAST), COMSIG_TURF_EXITED)
	LAZYCLEARLIST(marked_turfs)
	for(var/mob/mob as anything in vanished)
		var/image/overlay = LAZYACCESS(vanished, mob)
		LAZYREMOVE(vanished, mob)
		if(!overlay)
			continue
		mob.client?.images -= overlay

/obj/structure/soil/proc/on_entered(datum/source, mob/crossed)
	if(!isliving(crossed))
		return
	if(!crossed.client)
		return
	if(LAZYACCESS(vanished, crossed))
		return

	var/image/overlay = image(src)
	overlay.appearance = appearance
	overlay.loc = src
	overlay.override = TRUE
	overlay.plane = SEETHROUGH_PLANE
	overlay.appearance_flags = KEEP_APART

	var/mutable_appearance/MA = mutable_appearance(icon, icon_state)
	MA.appearance_flags = KEEP_APART
	MA.plane = initial(plane)
	overlay.overlays += MA
	animate(overlay, alpha = 110, time = 0.3 SECONDS)

	crossed.client.images += overlay
	LAZYADDASSOC(vanished, crossed, overlay)


/obj/structure/soil/proc/on_exited(turf/source, mob/crossed, direction)
	if(!isliving(crossed))
		return
	if(get_step(source, crossed.dir) in marked_turfs)
		return
	if(!crossed.client)
		return
	var/image/overlay = LAZYACCESS(vanished, crossed)
	LAZYREMOVE(vanished, crossed)
	if(!overlay)
		return
	crossed.client.images -= overlay

/obj/structure/soil/debug_soil
	var/obj/item/neuFarm/seed/seed_to_grow

/obj/structure/soil/debug_soil/random/Initialize()
	seed_to_grow = pick(subtypesof(/obj/item/neuFarm/seed) - /obj/item/neuFarm/seed/mixed_seed - /obj/item/neuFarm/seed/spore)
	. = ..()

/obj/structure/soil/debug_soil/Initialize()
	. = ..()
	if(!seed_to_grow)
		return
	var/debug_seed_genetics = initial(seed_to_grow.seed_genetics)
	if(!debug_seed_genetics)
		var/datum/plant_def/plant_def_instance = GLOB.plant_defs[initial(seed_to_grow.plant_def_type)]
		debug_seed_genetics = new /datum/plant_genetics(plant_def_instance)
	else
		debug_seed_genetics = new debug_seed_genetics()
	insert_plant(GLOB.plant_defs[initial(seed_to_grow.plant_def_type)], debug_seed_genetics)
	add_growth(plant.maturation_time)
	add_growth(plant.produce_time)

/*	..................   Mushroom Mound   ................... */
/obj/structure/soil/mushmound
	name = "mushroom mound"
	desc = "A mound made of chaff and nitesoil. A suitable place to grow mushrooms and not much else."
	icon_state = "mushmound"
	anchored = TRUE
	climbable = FALSE
	climb_offset = 10
	max_integrity = 100
	resistance_flags = NONE
	debris = list(/obj/item/natural/poo = 1)
	attacked_sound = "plantcross"
	tilled_overlay = "mushmound-tilled"
	water_overlay = "mushmound-overlay"

/obj/structure/soil/mushmound/debug_mushmound
	var/obj/item/neuFarm/seed/seed_to_grow

/obj/structure/soil/mushmound/debug_mushmound/Initialize()
	. = ..()
	if(!seed_to_grow)
		return
	var/debug_seed_genetics = initial(seed_to_grow.seed_genetics)
	if(!debug_seed_genetics)
		var/datum/plant_def/plant_def_instance = GLOB.plant_defs[initial(seed_to_grow.plant_def_type)]
		debug_seed_genetics = new /datum/plant_genetics(plant_def_instance)
	else
		debug_seed_genetics = new debug_seed_genetics()
	insert_plant(GLOB.plant_defs[initial(seed_to_grow.plant_def_type)], debug_seed_genetics)
	add_growth(plant.maturation_time)
	add_growth(plant.produce_time)

/obj/structure/soil/mushmound/debug_mushmound/random/Initialize()
	seed_to_grow = pick(subtypesof(/obj/item/neuFarm/seed/spore))
	. = ..()

#undef MAX_PLANT_HEALTH
#undef MAX_PLANT_NUTRITION
#undef MAX_PLANT_WEEDS
#undef SOIL_DECAY_TIME

#undef QUALITY_REGULAR
// #undef QUALITY_BRONZE
#undef QUALITY_SILVER
#undef QUALITY_GOLD
#undef QUALITY_DIAMOND

#undef BLESSING_WEED_DECAY_RATE
#undef WEED_GROWTH_RATE
#undef WEED_DECAY_RATE
#undef WEED_RESISTANCE_DECAY_RATE

#undef WEED_WATER_CONSUMPTION_RATE
#undef WEED_NUTRITION_CONSUMPTION_RATE

#undef PLANT_REGENERATION_RATE
#undef PLANT_DECAY_RATE
#undef PLANT_BLESS_HEAL_RATE
#undef PLANT_WEEDS_HARM_RATE

#undef SOIL_WATER_DECAY_RATE
#undef SOIL_NUTRIMENT_DECAY_RATE
