/obj/item/queen_bee
	name = "queen bee"
	desc = "The heart of a bee colony."
	icon = 'icons/obj/structures/apiary.dmi'
	icon_state = "queen_bee"

	var/datum/bee_genetics/genetics = null
	var/queen_age = 0
	var/queen_health = 100
	var/max_queen_age = 30

/obj/item/queen_bee/Initialize()
	. = ..()
	if(!genetics)
		genetics = new /datum/bee_genetics()
	START_PROCESSING(SSobj, src)

/obj/item/queen_bee/Destroy()
	STOP_PROCESSING(SSobj, src)
	return ..()

/obj/item/queen_bee/process()
	queen_age += 0.01

	if(queen_age > (max_queen_age * 0.7))
		queen_health -= 0.05

	if(queen_health <= 0)
		visible_message(span_warning("[src] dies of old age!"))
		qdel(src)

/obj/effect/bee_swarm
	name = "bee swarm"
	desc = "A buzzing swarm of bees looking for a place to build a new hive."
	icon = 'icons/obj/structures/apiary.dmi'
	icon_state = "bee"
	density = FALSE
	anchored = FALSE
	pass_flags = PASSTABLE | PASSMOB

	var/bee_count = 5
	var/obj/item/queen_bee/queen_bee = null
	var/search_time = 0
	var/established = FALSE

/obj/effect/bee_swarm/Initialize()
	. = ..()
	START_PROCESSING(SSobj, src)
	update_appearance(UPDATE_OVERLAYS)
	addtimer(CALLBACK(src, PROC_REF(swarm_timeout)), 5 MINUTES)

/obj/effect/bee_swarm/Destroy()
	STOP_PROCESSING(SSobj, src)
	if(queen_bee && !established)
		qdel(queen_bee)
	return ..()

/obj/effect/bee_swarm/process()
	if(!established)
		if(prob(50))
			var/turf/T = get_step(src, pick(GLOB.alldirs))
			if(T)
				Move(T)

	search_time++

	if(search_time >= 20)
		search_time = 0
		find_new_home()

/obj/effect/bee_swarm/proc/find_new_home()
	var/turf/T = get_turf(src)
	if(!T.density && !locate(/obj/structure/apiary) in T)
		var/suitable = TRUE
		for(var/atom/A in T)
			if(A.density)
				suitable = FALSE
				break

		if(suitable && prob(20))
			establish_hive()

/obj/effect/bee_swarm/proc/establish_hive()
	var/obj/structure/apiary/A = new(get_turf(src))
	A.bee_count = bee_count
	A.insert_queen(queen_bee)
	queen_bee = null
	established = TRUE
	visible_message(span_notice("The swarm has established a new hive!"))
	qdel(src)

/obj/effect/bee_swarm/proc/swarm_timeout()
	if(!established)
		visible_message(span_notice("The bee swarm disperses without finding a suitable home."))
		qdel(src)

/obj/effect/bee_swarm/update_overlays()
	. = ..()

	var/bee_spawn = bee_count - 1
	if(!bee_spawn)
		return

	for(var/i=1 to min(bee_spawn, 10))
		var/mutable_appearance/bee = mutable_appearance('icons/obj/structures/apiary.dmi', "bee")
		bee.pixel_x = rand(12, -12)
		bee.pixel_y = rand(12, -12)
		. += bee

/obj/effect/bees
	name = "bees"
	icon = 'icons/obj/structures/apiary.dmi'
	icon_state = "bee"
	pass_flags = PASSTABLE | PASSMOB

	var/atom/target
	var/obj/effect/bees/merge_target
	var/obj/structure/apiary/hive

	var/stored_pollen = 0
	var/bee_count = 1

	var/bee_state = BEE_STATE_IDLE
	var/turf/last_pollinated

	var/bee_efficiency = 1.0
	var/bee_aggression = 0
	var/bee_lifespan = 1.0
	var/bee_color = "#FFD700"
	var/bee_disease_resistance = 1.0

	var/agitated = FALSE
	var/agitation_countdown = 0
	var/list/attacked_mobs = list()

	var/seasonal_activity = 1.0

/obj/effect/bees/update_overlays()
	. = ..()
	var/bee_spawn = bee_count - 1
	if(!bee_spawn)
		return

	for(var/i=1 to bee_spawn)
		var/mutable_appearance/bee = mutable_appearance(icon, icon_state)
		bee.pixel_x = rand(12, -12)
		bee.pixel_y = rand(12, -12)
		bee.color = bee_color
		. += bee

/obj/effect/bees/Initialize()
	. = ..()
	START_PROCESSING(SSfaster_obj, src)
	update_appearance(UPDATE_OVERLAYS)

/obj/effect/bees/process()
	switch(bee_state)
		if(BEE_STATE_MERGING)
			process_merging()
		if(BEE_STATE_RETURNING)
			process_returning()
		if(BEE_STATE_AGITATED)
			process_agitated()
		if(BEE_STATE_POLLINATING)
			return // Handled by timer
		if(BEE_STATE_IDLE)
			process_idle()

/obj/effect/bees/proc/process_merging()
	if(!merge_target || QDELETED(merge_target))
		bee_state = BEE_STATE_IDLE
		merge_target = null
		return

	var/turf/turf = get_step_towards2(src, merge_target)
	Move(turf, get_dir(src, turf))

	if(get_dist(merge_target, src) == 0)
		merge_target.bee_count += bee_count
		merge_target.update_appearance(UPDATE_OVERLAYS)
		merge_target = null
		hive?.bee_objects -= src
		qdel(src)

/obj/effect/bees/proc/process_returning()
	if(!validate_hive())
		return

	var/turf/turf = get_step_towards2(src, target)
	Move(turf, get_dir(src, turf))

	if(get_dist(target, src) == 0)
		if(istype(target, /obj/structure/apiary))
			enter_hive()
		else
			bee_state = BEE_STATE_IDLE
			target = null

/obj/effect/bees/proc/process_agitated()
	if(agitation_countdown > 0)
		agitation_countdown--
		attack_nearby_targets()
	else
		agitated = FALSE
		attacked_mobs.Cut()
		bee_state = BEE_STATE_IDLE

/obj/effect/bees/proc/process_idle()
	if(target)
		var/turf/turf = get_step_towards2(src, target)
		Move(turf, get_dir(src, turf))
		if(get_dist(target, src) == 0)
			target = null
			try_pollinate()

/obj/effect/bees/proc/validate_hive()
	if(!hive || QDELETED(hive))
		qdel(src)
		return FALSE
	return TRUE

/obj/effect/bees/proc/enter_hive()
	if(!validate_hive())
		return

	hive.bee_objects -= src
	hive.sleeping_bees += bee_count
	hive.outside_bees -= bee_count
	hive.pollen += stored_pollen
	hive.on_bee_enter(bee_count)
	hive = null
	target = null
	qdel(src)

/obj/effect/bees/proc/try_pollinate()
	if(bee_state == BEE_STATE_POLLINATING)
		return TRUE
	if(last_pollinated == get_turf(src))
		return FALSE

	if(prob((1 - seasonal_activity) * 100))
		return FALSE

	var/turf/turf = get_turf(src)
	var/obj/structure/soil/soil = locate(/obj/structure/soil) in turf
	var/obj/structure/flora/grass/herb/herb = locate(/obj/structure/flora/grass/herb) in turf
	if(!soil && !herb)
		return FALSE

	bee_state = BEE_STATE_POLLINATING
	addtimer(CALLBACK(src, PROC_REF(finish_pollinating), turf), (BEE_POLLINATION_TIME / (seasonal_activity * bee_efficiency)))
	return TRUE

/obj/effect/bees/proc/finish_pollinating(turf/turf)
	var/obj/structure/soil/soil = locate(/obj/structure/soil) in turf
	soil?.pollination_time = 5 MINUTES
	bee_state = BEE_STATE_IDLE
	last_pollinated = get_turf(src)

	stored_pollen += rand(1, 2) * bee_count * bee_efficiency

	// Record what plant type was pollinated
	if(soil?.plant)
		var/plant_type = soil.plant.type
		if(hive && !isnull(hive))
			hive.add_pollen(plant_type, rand(1, 2) * bee_count * bee_efficiency)

	var/obj/structure/flora/grass/herb/herb = locate(/obj/structure/flora/grass/herb) in turf
	if(herb)
		if(hive && !isnull(hive))
			hive.add_pollen(herb.type, rand(1, 2) * bee_count * bee_efficiency)

	if(stored_pollen > (BEE_RETURN_THRESHOLD * bee_count))
		return_to_hive()

/obj/effect/bees/proc/return_to_hive()
	if(!validate_hive())
		return
	target = hive
	bee_state = BEE_STATE_RETURNING

/obj/effect/bees/proc/attack_nearby_targets()
	if(bee_state == BEE_STATE_POLLINATING || merge_target)
		return

	var/attack_chance = (bee_aggression * seasonal_activity) / 100
	if(!prob(attack_chance))
		return

	for(var/mob/living/carbon/human/H in view(1, src))
		if(is_wearing_bee_protection(H))
			continue
		if(attacked_mobs[H])
			continue

		attack_mob(H)
		break

/obj/effect/bees/proc/attack_mob(mob/living/carbon/human/H)
	var/obj/item/bodypart/affecting = H.get_bodypart(pick(BODY_ZONE_CHEST, BODY_ZONE_PRECISE_L_HAND, BODY_ZONE_PRECISE_R_HAND, BODY_ZONE_L_LEG, BODY_ZONE_R_LEG, BODY_ZONE_HEAD))

	H.visible_message("<span class='danger'>[src] stings [H] in the [affecting.name]!</span>", \
					  "<span class='userdanger'>You feel a sharp stinging pain in your [affecting.name]!</span>")

	H.adjustToxLoss(1)
	H.reagents.add_reagent(/datum/reagent/toxin/venom, 2)
	attacked_mobs[H] = TRUE

	// Agitate more bees nearby
	for(var/obj/effect/bees/B in view(3, src))
		if(prob(50))
			B.agitate(H, 30)

/obj/effect/bees/proc/agitate(mob/target, duration)
	agitated = TRUE
	agitation_countdown = duration
	bee_state = BEE_STATE_AGITATED

	if(target)
		attacked_mobs[target] = TRUE

/obj/effect/bees/proc/inherit_genetics(datum/bee_genetics/genetics)
	if(!genetics)
		return
	genetics.apply_to_bee(src)
