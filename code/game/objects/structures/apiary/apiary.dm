/proc/is_wearing_bee_protection(mob/living/carbon/human/H)
	if(!istype(H))
		return FALSE

	var/head_protected = FALSE
	var/body_protected = FALSE

	var/obj/item/clothing/head/head_item = H.get_item_by_slot(ITEM_SLOT_HEAD)
	if(head_item && (head_item.flags_cover & HEADCOVERSMOUTH))
		head_protected = TRUE

	var/obj/item/clothing/armor/suit_item = H.get_item_by_slot(ITEM_SLOT_ARMOR)
	if(suit_item && (suit_item.body_parts_covered & CHEST))
		body_protected = TRUE

	return head_protected && body_protected

// ============================================================================
// APIARY STRUCTURE
// ============================================================================

/obj/structure/apiary
	name = "apiary"
	desc = "A structure housing bees that produce honey and pollinate plants."
	icon = 'icons/obj/structures/apiary.dmi'
	icon_state = "beebox-empty"

	var/stored_combs = 0
	var/outside_bees = 0
	var/sleeping_bees = 0

	var/bee_count = 0
	var/max_bees = APIARY_BASE_MAX_BEES

	var/list/bee_objects = list()

	var/comb_progress = 0
	var/pollen = 0

	// Queen bee system
	var/obj/item/queen_bee/queen_bee = null
	var/datum/bee_genetics/genetics = null
	var/queen_maturity = 0
	var/queen_deceased = FALSE

	// Disease system
	var/has_disease = FALSE
	var/datum/bee_disease/disease = null
	var/disease_severity = 0
	var/disease_progression = 0
	var/treatment_progress = 0

	// Swarm mechanics
	var/swarm_progress = 0
	var/can_swarm = TRUE
	var/last_swarm_time = 0

	// Honey types system
	var/list/pollen_data = list()

/obj/structure/apiary/Initialize()
	. = ..()
	START_PROCESSING(SSobj, src)

/obj/structure/apiary/update_icon_state()
	. = ..()
	if(stored_combs > 0)
		icon_state = "beebox-full"
	else
		icon_state = "beebox-empty"

/obj/structure/apiary/process()
	validate_queen()
	process_comb_gain()

	if((outside_bees + bee_count) < max_bees)
		try_create_bees()

	if(bee_count)
		try_send_bees_out()

	process_bee_objects()

	if(has_disease)
		process_disease()

	check_for_disease()

	if(!queen_bee)
		handle_queenless_hive()
	else
		handle_queen_breeding()

	if(bee_count > (max_bees * 0.8) && queen_bee && can_swarm)
		process_swarm()

/obj/structure/apiary/proc/validate_queen()
	if(!queen_bee)
		return FALSE
	if(QDELETED(queen_bee))
		queen_bee = null
		genetics = null
		return FALSE
	if(queen_bee.loc != src)
		queen_bee = null
		genetics = null
		return FALSE
	return TRUE

/obj/structure/apiary/proc/handle_queenless_hive()
	if(!queen_deceased)
		queen_deceased = TRUE

	if(bee_count > 0 && prob(5))
		bee_count--

	if(bee_count >= 10 && pollen >= APIARY_QUEEN_CREATION_POLLEN && stored_combs >= APIARY_QUEEN_CREATION_COMBS && !queen_deceased)
		queen_maturity += 0.2
		if(queen_maturity >= 100)
			create_new_queen()

/obj/structure/apiary/proc/handle_queen_breeding()
	if((outside_bees + bee_count) < max_bees && prob(30))
		try_create_bees()

/obj/structure/apiary/proc/add_pollen(plant_type, amount = 1)
	if(!pollen_data[plant_type])
		pollen_data[plant_type] = 0
	pollen_data[plant_type] += amount

/obj/structure/apiary/proc/get_dominant_pollen_source()
	if(!length(pollen_data))
		return null

	var/dominant_type
	var/highest_count = 0

	for(var/type in pollen_data)
		if(pollen_data[type] > highest_count)
			highest_count = pollen_data[type]
			dominant_type = type

	return dominant_type

/obj/structure/apiary/attack_hand(mob/user)
	if(queen_bee && user.a_intent == INTENT_HELP && is_wearing_bee_protection(user))
		user.visible_message("[user] carefully reaches into [src].", "You carefully extract the queen bee from [src].")

		if(!do_after(user, 5 SECONDS, src))
			return

		var/obj/item/queen_bee/extracted_queen = new(get_turf(src))
		if(genetics)
			extracted_queen.genetics = genetics.copy()
		extracted_queen.queen_age = queen_bee.queen_age
		extracted_queen.queen_health = queen_bee.queen_health

		user.put_in_hands(extracted_queen)
		queen_bee = null
		genetics = null

		agitate_bees(80, user)
		return

	if(!stored_combs)
		return ..()

	var/safe_handling = is_wearing_bee_protection(user)

	if(!safe_handling && genetics && prob(genetics.aggression))
		agitate_bees(80, user)
		return

	user.visible_message("[user] starts to collect combs from [src].", "You start to collect combs from [src]")

	if(!do_after(user, 2.5 SECONDS, src))
		return

	var/honey_path = determine_honey_type()

	for(var/i=1 to stored_combs)
		new honey_path(get_turf(src))

	stored_combs = 0
	update_appearance(UPDATE_ICON_STATE)

/obj/structure/apiary/attackby(obj/item/I, mob/user, params)
	if(istype(I, /obj/item/queen_bee))
		if(queen_bee)
			to_chat(user, span_warning("There's already a queen!"))
			return
		insert_queen(I)

/obj/structure/apiary/proc/process_comb_gain()
	if(!pollen)
		return

	var/pollen_multi = CEILING(bee_count * 0.5, 1)
	if(genetics)
		pollen_multi *= genetics.efficiency

	var/pollen_to_process = min(pollen_multi, pollen)
	pollen -= pollen_to_process
	comb_progress += pollen_to_process

	if(comb_progress > APIARY_COMB_COST)
		stored_combs = min(stored_combs + 1, 5)
		comb_progress -= APIARY_COMB_COST
		update_appearance(UPDATE_ICON_STATE)

	if(comb_progress > APIARY_COMB_COST)
		comb_progress = APIARY_COMB_COST

	if(stored_combs >= 5)
		pollen = 0

/obj/structure/apiary/proc/process_bee_objects()
	if(SSParticleWeather.runningWeather?.target_trait == PARTICLEWEATHER_RAIN || SSParticleWeather.runningWeather?.target_trait == PARTICLEWEATHER_SNOW)
		for(var/obj/effect/bees/bee in bee_objects)
			bee.return_to_hive()
		return

	for(var/obj/effect/bees/bee in bee_objects)
		if(bee.bee_state != BEE_STATE_IDLE)
			continue
		if(!bee.try_pollinate())
			give_bee_target()

/obj/structure/apiary/proc/process_disease()
	if(!disease)
		return

	disease_progression += 1

	if(disease_progression >= 100)
		disease_progression = 0
		disease_severity += 10

	disease.apply_effects(src)

	if(disease_severity >= disease.severity_threshold)
		visible_message(span_warning("[src] colony collapses from disease!"))
		bee_count = 0
		outside_bees = 0
		for(var/obj/effect/bees/B in bee_objects)
			qdel(B)
		bee_objects.Cut()
		has_disease = FALSE
		disease = null
		disease_severity = 0
		queen_deceased = TRUE
		if(queen_bee)
			qdel(queen_bee)
			queen_bee = null
			genetics = null

/obj/structure/apiary/proc/check_for_disease()
	if(prob(100 - DISEASE_CHECK_CHANCE))
		return

	if(has_disease)
		return

	var/infected_nearby = FALSE
	for(var/obj/structure/apiary/A in view(5, src))
		if(A.has_disease)
			infected_nearby = TRUE
			break

	var/infection_chance = infected_nearby ? DISEASE_NEARBY_INFECTION : DISEASE_BASE_INFECTION

	if(genetics)
		infection_chance = max(0, infection_chance - (genetics.disease_resistance * 3))

	if(prob(infection_chance))
		var/disease_type = pick(GLOB.bee_diseases)
		disease = GLOB.bee_diseases[disease_type]
		has_disease = TRUE
		disease_severity = 10
		visible_message(span_warning("The bees in [src] seem agitated."))

/obj/structure/apiary/proc/agitate_bees(chance, mob/user)
	if(prob(chance) && bee_count > 0)
		var/agitated_count = rand(1, min(5, bee_count))
		bee_count -= agitated_count
		outside_bees += agitated_count

		visible_message(span_warning("Bees swarm out of [src] angrily!"))

		for(var/i in 1 to agitated_count)
			var/obj/effect/bees/B = new(get_turf(src))
			B.hive = src
			B.bee_count = 1
			B.agitate(user, 100)
			if(genetics)
				genetics.apply_to_bee(B)
			else
				B.bee_aggression = 50
			bee_objects += B

/obj/structure/apiary/proc/calm_bees()
	for(var/obj/effect/bees/B in bee_objects)
		B.agitated = FALSE
		B.agitation_countdown = 0
		B.attacked_mobs.Cut()
		B.bee_state = BEE_STATE_IDLE

/obj/structure/apiary/proc/determine_honey_type()
	var/list/honey_value = list()

	for(var/datum/plant_def/plant_type as anything in pollen_data)
		if(!ispath(plant_type))
			continue
		if(!initial(plant_type.honey_type))
			continue
		if(!(initial(plant_type.honey_type) in honey_value))
			honey_value |= initial(plant_type.honey_type)
			honey_value[initial(plant_type.honey_type)] = 0
		honey_value[initial(plant_type.honey_type)] += pollen_data[plant_type]

	for(var/obj/structure/flora/grass/herb/plant_type as anything in pollen_data)
		if(!ispath(plant_type))
			continue
		if(!initial(plant_type.honey_type))
			continue
		if(!(initial(plant_type.honey_type) in honey_value))
			honey_value |= initial(plant_type.honey_type)
			honey_value[initial(plant_type.honey_type)] = 0
		honey_value[initial(plant_type.honey_type)] += pollen_data[plant_type]

	pollen_data.Cut()

	if(!length(honey_value))
		return /obj/item/reagent_containers/food/snacks/spiderhoney/honey

	var/highest
	for(var/item in honey_value)
		if(!highest)
			highest = item
			continue
		if(honey_value[highest] < honey_value[item])
			highest = item

	return highest

/obj/structure/apiary/proc/try_send_bees_out()
	if(SSParticleWeather.runningWeather?.target_trait == PARTICLEWEATHER_RAIN)
		return

	if(SSParticleWeather.runningWeather?.target_trait == PARTICLEWEATHER_SNOW)
		return

	if(pollen && stored_combs < 5)
		return

	var/obj/effect/bees/new_bee = new(get_turf(src))
	if(genetics)
		genetics.apply_to_bee(new_bee)

	if(length(bee_objects))
		for(var/obj/effect/bees/bee in bee_objects)
			if(bee.bee_count > BEE_MERGE_THRESHOLD)
				continue
			new_bee.merge_target = bee
			new_bee.bee_state = BEE_STATE_MERGING
			outside_bees++
			bee_count--
			return

	new_bee.hive = src
	outside_bees++
	bee_count--
	bee_objects += new_bee

/obj/structure/apiary/proc/process_swarm()
	if(world.time < (last_swarm_time + SWARM_COOLDOWN))
		return

	swarm_progress += 0.1

	if(swarm_progress > SWARM_THRESHOLD && prob(10))
		visible_message(span_warning("The bees in [src] are extremely active!"))

	if(swarm_progress >= 100)
		create_swarm()

/obj/structure/apiary/proc/create_swarm()
	swarm_progress = 0
	last_swarm_time = world.time
	var/obj/item/queen_bee/new_queen = new(get_turf(src))

	if(genetics)
		new_queen.genetics = genetics.copy()
		new_queen.genetics.mutate(20)

	var/swarm_size = rand(SWARM_MIN_SIZE, SWARM_MAX_SIZE)
	bee_count -= swarm_size

	visible_message(span_warning("A swarm of bees emerges from [src]!"))

	var/obj/effect/bee_swarm/swarm = new(get_turf(src))
	swarm.bee_count = swarm_size
	swarm.queen_bee = new_queen

	swarm.find_new_home()

/obj/structure/apiary/proc/give_bee_target()
	var/list/targets = list()
	for(var/obj/structure/soil/soil in view(BEE_WANDERING_RANGE, src))
		if(!soil.plant)
			continue
		targets |= soil
	for(var/obj/structure/flora/grass/herb/herb in view(BEE_WANDERING_RANGE, src))
		targets |= herb

	for(var/obj/effect/bees/bee in bee_objects)
		if(bee.bee_state != BEE_STATE_IDLE)
			continue
		if(targets.len)
			bee.target = pick(targets)

/obj/structure/apiary/proc/try_create_bees()
	if(!comb_progress)
		return
	if((outside_bees + bee_count + sleeping_bees) > max_bees)
		return

	if(comb_progress < APIARY_BEE_CREATION_COST)
		return

	comb_progress -= APIARY_BEE_CREATION_COST
	bee_count++

/obj/structure/apiary/proc/on_bee_enter(amount)
	addtimer(CALLBACK(src, PROC_REF(finish_sleep), amount), 30 SECONDS)

/obj/structure/apiary/proc/finish_sleep(amount)
	sleeping_bees -= amount
	bee_count += amount

/obj/structure/apiary/proc/create_new_queen()
	queen_maturity = 0
	pollen -= APIARY_QUEEN_CREATION_POLLEN
	stored_combs -= APIARY_QUEEN_CREATION_COMBS
	update_appearance(UPDATE_ICON_STATE)

	var/obj/item/queen_bee/new_queen = new(get_turf(src))
	new_queen.genetics = new /datum/bee_genetics()
	new_queen.genetics.efficiency = rand(80, 120)/100
	new_queen.genetics.aggression = rand(0, 30)
	new_queen.genetics.lifespan = rand(80, 120)/100
	new_queen.genetics.color = pick("#FFD700", "#FFA500", "#FFFF00", "#DAA520")
	new_queen.genetics.disease_resistance = rand(80, 120)/100

	visible_message(span_notice("A new queen bee emerges from [src]!"))

	insert_queen(new_queen)

/obj/structure/apiary/proc/insert_queen(obj/item/queen_bee/new_queen)
	queen_bee = new_queen
	genetics = new_queen.genetics
	queen_deceased = FALSE
	max_bees = APIARY_BASE_MAX_BEES + (genetics.efficiency * 10)
	bee_count++
	visible_message(span_notice("The bees in [src] welcome their new queen!"))
	new_queen.forceMove(src)

/obj/structure/apiary/starter
	bee_count = 5
	stored_combs = 0
	comb_progress = 0

/obj/structure/apiary/starter/Initialize()
	. = ..()
	create_new_queen()
