/mob/living/simple_animal/hostile/retaliate/meatvine
	name = "Horrible creature"
	desc = "What is that?!"
	icon = 'icons/obj/cellular/meat.dmi'
	icon_state = "bloodling_stage_1"
	icon_living = "bloodling_stage_1"
	icon_dead = "bloodling_stage_1_dead"
	faction = list("meat")

	health = VOLF_HEALTH
	maxHealth = VOLF_HEALTH

	melee_damage_lower = 15
	melee_damage_upper = 20

	base_constitution = 6
	base_strength = 6
	base_speed = 12

	simple_detect_bonus = 20
	retreat_distance = 0
	minimum_distance = 0
	deaggroprob = 0
	defprob = 35
	defdrain = 5

	aggressive = 1

	hud_type = /datum/hud/putrid
	see_in_dark = 10

	environment_smash = TRUE
	stat_attack = 1

	ai_controller = /datum/ai_controller/meatvine_defender

	pass_flags = PASSTABLE
	can_buckle = TRUE
	buckle_lying = 0

	var/tether_distance = 3

	var/obj/effect/meatvine_controller/master
	var/personal_resource_pool = 0
	var/personal_resource_max = PERSONAL_RESOURCE_MAX
	var/is_draining_well = FALSE
	var/obj/structure/meatvine/healing_well/draining_target = null
	var/last_drain_time = 0
	var/datum/component/team_monitor/putrid_monitor

	var/evolution_progress = 0
	var/evolution_max = 100
	var/list/possible_evolutions = list(
		/mob/living/simple_animal/hostile/retaliate/meatvine/range,
		/mob/living/simple_animal/hostile/retaliate/meatvine/runner,
		/mob/living/simple_animal/hostile/retaliate/meatvine/tank,
		/mob/living/simple_animal/hostile/retaliate/meatvine/constructor,
	)

	var/list/personal_abilities = list(
		/datum/action/cooldown/meatvine/personal/drain_well,
		/datum/action/cooldown/meatvine/personal/lunge,
	)

	var/list/structures = list(
		/datum/action/cooldown/meatvine/spread_spike,
	)

/mob/living/simple_animal/hostile/retaliate/meatvine/Initialize()
	. = ..()
	AddComponent(/datum/component/ai_aggro_system)
	ADD_TRAIT(src, TRAIT_PUTRID, INNATE_TRAIT)
	add_spell(/datum/action/cooldown/meatvine/spread_floor)
	add_spell(/datum/action/cooldown/meatvine/spread_wall)

	for(var/path in structures)
		add_spell(path)

	for(var/path in personal_abilities)
		add_spell(path)

/mob/living/simple_animal/hostile/retaliate/meatvine/Destroy()
	if(master)
		master?.mobs -= src
		master = null
		puff_gas()
		var/turf/turf = get_turf(src)
		turf.pollute_turf(/datum/pollutant/steam, 100)
		turf.add_liquid(/datum/reagent/blood, 20)
	return ..()

/mob/living/simple_animal/hostile/retaliate/meatvine/death()
	puff_gas()
	QDEL_IN(src, rand(60, 120) SECONDS)
	return ..()

/mob/living/simple_animal/hostile/retaliate/meatvine/Life(seconds_per_tick, times_fired)
	. = ..()
	if(stat != DEAD)
		regenerate_personal_resources(seconds_per_tick)

/mob/living/simple_animal/hostile/retaliate/meatvine/MouseDrop_T(atom/dropping, mob/user)
	. = ..()
	if(user != src)
		return

	// Check if we can buckle the target
	if(isitem(dropping))
		var/obj/item/I = dropping
		if(user.dropItemToGround(I))
			I.forceMove(loc)
			buckle_mob(I, TRUE)
			to_chat(user, span_notice("You attach [I] to yourself."))
		return

	if(isliving(dropping))
		var/mob/living/L = dropping
		if(L.body_position == LYING_DOWN || L.stat != CONSCIOUS)
			buckle_mob(L, TRUE)
			to_chat(user, span_notice("You grab onto [L]."))
		return

/mob/living/simple_animal/hostile/retaliate/meatvine/UnarmedAttack(atom/A, proximity_flag, list/modifiers, atom/source)
	if(!istype(A, /obj/structure/meatvine/papameat) && !istype(A, /obj/structure/meatvine/intestine_wormhole))
		return . = ..()

	if(istype(A, /obj/structure/meatvine/intestine_wormhole))
		var/obj/structure/meatvine/intestine_wormhole/hole = A
		hole.try_use(src)
		return TRUE

	// Check if we have something buckled to feed
	if(has_buckled_mobs())
		var/atom/movable/buckled_thing = buckled_mobs[1]
		try_feed_to_papameat(buckled_thing, A, src)
		return TRUE
	if(evolution_progress >= evolution_max)
		var/obj/structure/meatvine/papameat/nearest_papa = A
		nearest_papa.begin_evolution(src)
		return TRUE


/mob/living/simple_animal/hostile/retaliate/meatvine/proc/generate_monitor()
	var/monitor_key = "putrid_[REF(master)]"
	putrid_monitor = AddComponent(/datum/component/team_monitor, monitor_key, null)
	putrid_monitor.show_hud(src)
	master.mobs |= src

/mob/living/simple_animal/hostile/retaliate/meatvine/proc/add_team_tracker(atom/target, timer)
	var/tracker = target.AddComponent(/datum/component/tracking_beacon, "putrid_[REF(master)]", null, null, TRUE, "#ec2626")
	putrid_monitor.add_to_tracking_network(tracker)
	if(timer)
		addtimer(CALLBACK(src, PROC_REF(remove_team_tracker), tracker), timer)

/mob/living/simple_animal/hostile/retaliate/meatvine/proc/remove_team_tracker(datum/component/tracking_beacon/tracker)
	qdel(tracker)

/mob/living/simple_animal/hostile/retaliate/meatvine/proc/try_feed_to_papameat(atom/movable/food, obj/structure/meatvine/papameat/nearest_papa, mob/user)
	if(!nearest_papa)
		to_chat(user, span_warning("No papa meat nearby to feed!"))
		return FALSE

	var/organic_value = calculate_organic_value(food)

	if(organic_value <= 0)
		to_chat(user, span_warning("[food] is not suitable food!"))
		return FALSE

	unbuckle_mob(food, TRUE)

	to_chat(user, span_notice("You begin feeding [food] to the papa meat..."))

	if(!do_after(user, 3 SECONDS, nearest_papa))
		to_chat(user, span_warning("You stop feeding [food]."))
		return FALSE

	visible_message(span_danger("[src] feeds [food] to [nearest_papa]!"))

	if(nearest_papa.master)
		nearest_papa.master.feed_organic_matter(organic_value)

	gain_evolution_progress(organic_value * 0.5)

	qdel(food)
	return TRUE

/mob/living/simple_animal/hostile/retaliate/meatvine/proc/calculate_organic_value(atom/movable/food)
	var/value = 0

	if(istype(food, /obj/item/reagent_containers/food))
		var/obj/item/reagent_containers/food/meat = food
		if(meat.foodtype & MEAT)
			value = 10
	else if(istype(food, /obj/item/bodypart))
		value = 50
	else if(istype(food, /obj/item/organ))
		value = 30
	else if(isliving(food))
		var/mob/living/L = food
		if(L.stat == DEAD)
			value = 100

	return value

/mob/living/simple_animal/hostile/retaliate/meatvine/proc/gain_evolution_progress(amount)
	evolution_progress = min(evolution_progress + amount, evolution_max)
	SEND_SIGNAL(src, COMSIG_MEATVINE_PERSONAL_EVOLUTION_CHANGE, evolution_progress)
	if(evolution_progress >= evolution_max)
		to_chat(src, span_nicegreen("You are ready to evolve! Find a hive and click on it to begin evolution."))
		var/datum/component/team_monitor/monitor = return_tracker()
		if(!monitor)
			monitor = create_tracker()
		var/atom/closest_struct = get_closest_atom(/obj/structure/meatvine/papameat, master.papameats, src)
		var/datum/component/tracking_beacon/beacon = closest_struct.AddComponent(/datum/component/tracking_beacon, monitor_key, null, null, TRUE, "#f3d594")
		monitor.add_to_tracking_network(beacon)

/mob/living/simple_animal/hostile/retaliate/meatvine/proc/regenerate_personal_resources(seconds_per_tick)
	if(is_draining_well)
		return
	var/regen_amount = PERSONAL_RESOURCE_REGEN_RATE * seconds_per_tick
	adjust_personal_resources(regen_amount)

/mob/living/simple_animal/hostile/retaliate/meatvine/proc/adjust_personal_resources(amount)
	var/old_resources = personal_resource_pool
	personal_resource_pool = clamp(personal_resource_pool + amount, 0, personal_resource_max)
	if(old_resources != personal_resource_pool)
		SEND_SIGNAL(src, COMSIG_MEATVINE_PERSONAL_RESOURCE_CHANGE, personal_resource_pool)
	return personal_resource_pool

/mob/living/simple_animal/hostile/retaliate/meatvine/proc/try_spend_personal_resources(amount)
	if(personal_resource_pool >= amount)
		adjust_personal_resources(-amount)
		return TRUE
	return FALSE

/mob/living/simple_animal/hostile/retaliate/meatvine/proc/start_draining_well(obj/structure/meatvine/healing_well/well)
	if(is_draining_well)
		to_chat(src, span_warning("Already draining a well!"))
		return FALSE
	if(world.time < last_drain_time + HEALING_WELL_DRAIN_COOLDOWN)
		var/time_left = round((last_drain_time + HEALING_WELL_DRAIN_COOLDOWN - world.time) / 10)
		to_chat(src, span_warning("Must wait [time_left] seconds before draining again!"))
		return FALSE
	if(well.is_being_drained)
		to_chat(src, span_warning("This well is already being drained!"))
		return FALSE
	if(get_dist(src, well) > 1)
		to_chat(src, span_warning("Must be adjacent to the healing well!"))
		return FALSE
	is_draining_well = TRUE
	draining_target = well
	well.start_drain(src)
	to_chat(src, span_notice("You begin draining the healing well..."))
	if(!do_after(src, HEALING_WELL_DRAIN_TIME, well))
		well.restore_healing()
		return FALSE
	if(QDELETED(well))
		cancel_well_drain()
		to_chat(src, span_warning("The drain was interrupted!"))
		return
	adjust_personal_resources(HEALING_WELL_DRAIN_AMOUNT)
	is_draining_well = FALSE
	draining_target = null
	last_drain_time = world.time
	well.finish_drain()
	to_chat(src, span_boldnotice("Drained [HEALING_WELL_DRAIN_AMOUNT] personal resources from the healing well!"))
	to_chat(src, span_info("Personal resources: [personal_resource_pool]/[personal_resource_max]"))

/mob/living/simple_animal/hostile/retaliate/meatvine/proc/cancel_well_drain()
	if(!is_draining_well)
		return
	is_draining_well = FALSE
	if(draining_target)
		draining_target.restore_healing()
		draining_target = null

/mob/living/simple_animal/hostile/retaliate/meatvine/proc/puff_gas()
	if(!prob(50))
		return
	var/turf/turf = get_turf(src)
	turf.pollute_turf(/datum/pollutant/rot, 100)
	return
