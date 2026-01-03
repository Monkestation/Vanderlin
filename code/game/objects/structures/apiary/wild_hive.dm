/obj/structure/beehive/wild
	name = "wild beehive"
	desc = "A natural bee colony formed in the wild."
	icon = 'icons/obj/structures/apiary.dmi'
	icon_state = "wild_hive"
	density = TRUE
	anchored = TRUE

	var/bee_count = 0
	var/max_bees = 15
	var/aggressiveness = 50
	var/list/bee_objects = list()

/obj/structure/beehive/wild/Initialize()
	. = ..()
	START_PROCESSING(SSobj, src)
	bee_count = rand(5, max_bees)
	aggressiveness = rand(30, 70)
	addtimer(CALLBACK(src, PROC_REF(send_out_bees)), rand(100, 300))

/obj/structure/beehive/wild/Destroy()
	STOP_PROCESSING(SSobj, src)
	for(var/obj/effect/bees/B in bee_objects)
		qdel(B)
	bee_objects.Cut()
	new /obj/item/queen_bee(get_turf(src))
	return ..()

/obj/structure/beehive/wild/process()
	if(bee_count < max_bees && prob(5))
		bee_count++

/obj/structure/beehive/wild/proc/send_out_bees()
	if(bee_count <= 0)
		addtimer(CALLBACK(src, PROC_REF(send_out_bees)), rand(100, 300))
		return

	if(SSParticleWeather.runningWeather?.target_trait == PARTICLEWEATHER_RAIN || SSParticleWeather.runningWeather?.target_trait == PARTICLEWEATHER_SNOW)
		addtimer(CALLBACK(src, PROC_REF(send_out_bees)), rand(100, 300))
		return

	var/obj/effect/bees/wild/B = new(get_turf(src))
	B.home_hive = src
	B.bee_count = 1
	B.bee_aggression = aggressiveness
	bee_objects += B
	bee_count--

	if(prob(70))
		B.find_pollination_target()
	else
		B.wander_behavior = TRUE

	addtimer(CALLBACK(src, PROC_REF(send_out_bees)), rand(100, 300))

/obj/structure/beehive/wild/attack_hand(mob/user)
	user.visible_message(span_warning("[user] disturbs [src]!"), span_warning("You disturb the wild beehive!"))

	var/protected = is_wearing_bee_protection(user)

	if(!protected || prob(aggressiveness))
		agitate_bees(user)

	if(protected && prob(30))
		to_chat(user, span_notice("You manage to extract some honey!"))
		new /obj/item/reagent_containers/food/snacks/spiderhoney/honey/wild(get_turf(src))

/obj/structure/beehive/wild/proc/agitate_bees(mob/target)
	visible_message(span_danger("Bees swarm out of [src] angrily!"))

	var/release_count = min(bee_count, rand(3, 8))
	bee_count -= release_count

	for(var/i=1 to release_count)
		var/obj/effect/bees/wild/B = new(get_turf(src))
		B.home_hive = src
		B.bee_count = 1
		B.bee_aggression = min(aggressiveness + 20, 100)
		B.agitated = TRUE
		B.agitation_countdown = 100
		B.bee_state = BEE_STATE_AGITATED

		if(target)
			B.target_mob = target
			B.attacked_mobs[target] = TRUE

		bee_objects += B

/obj/effect/bees/wild
	var/obj/structure/beehive/wild/home_hive = null
	var/mob/living/target_mob = null
	var/wander_behavior = FALSE
	var/return_home_timer = 0

/obj/effect/bees/wild/process()
	. = ..()
	if(agitated && target_mob)
		if(get_dist(src, target_mob) > 1)
			var/turf/T = get_step_towards(src, target_mob)
			Move(T)
		else
			attack_mob(target_mob)

	else if(wander_behavior)
		if(prob(40))
			var/turf/T = get_step(src, pick(GLOB.alldirs))
			Move(T)

		return_home_timer++

		if(return_home_timer > 50)
			return_to_wild_hive()

	if(home_hive && ((agitation_countdown <= 0 && agitated) || stored_pollen > 5))
		return_to_wild_hive()

/obj/effect/bees/wild/proc/find_pollination_target()
	var/list/targets = list()
	for(var/obj/structure/soil/soil in view(10, src))
		if(!soil.plant)
			continue
		targets |= soil
	for(var/obj/structure/flora/grass/herb/herb in view(10, src))
		targets |= herb

	if(targets.len)
		target = pick(targets)

/obj/effect/bees/wild/proc/return_to_wild_hive()
	if(!home_hive)
		return

	if(get_dist(src, home_hive) > 0)
		var/turf/T = get_step_towards(src, home_hive)
		Move(T)
	else
		enter_wild_hive()

/obj/effect/bees/wild/proc/enter_wild_hive()
	if(!home_hive)
		return

	home_hive.bee_count += bee_count
	home_hive.bee_objects -= src
	qdel(src)

/obj/effect/decal/cleanable/insect
