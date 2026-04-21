// Coral formation - can be used by the boss as cover or to block player movement
/obj/effect/temp_visual/coral_spawn
	icon = 'icons/effects/effects.dmi'
	icon_state = "trap"
	layer = BELOW_MOB_LAYER
	plane = GAME_PLANE
	light_outer_range = 2
	duration = 1.2 SECONDS
	var/explode_sound = list('sound/misc/explode/incendiary (1).ogg','sound/misc/explode/incendiary (2).ogg')

/obj/effect/temp_visual/coral_spawn/Initialize(mapload, list/flame_hit)
	. = ..()
	INVOKE_ASYNC(src, PROC_REF(storm), flame_hit)

/obj/effect/temp_visual/coral_spawn/proc/storm(list/flame_hit)	//electroshocktherapy
	var/turf/T = get_turf(src)
	sleep(duration)
	new /obj/structure/coral_formation(T)



/obj/structure/coral_formation
	name = "living coral"
	desc = "A sharp formation of living coral that pulses with an eerie light."
	icon = 'icons/obj/coral.dmi'  // Replace with appropriate icon
	icon_state = "coral"  // Replace with appropriate icon_state
	density = TRUE
	anchored = TRUE
	var/health = 150
	var/max_health = 150
	var/damage_on_contact = 10
	var/can_grow = TRUE
	var/range = 2
	var/grow_chance = 2

/obj/structure/coral_formation/Initialize()
	. = ..()
	add_filter("coral_glow", 2, outline_filter(1, "#3366FF"))
	START_PROCESSING(SSobj, src)

/obj/structure/coral_formation/Destroy()
	STOP_PROCESSING(SSobj, src)
	return ..()

/obj/structure/coral_formation/process()
	// Chance to grow to adjacent tiles
	if(can_grow && prob(grow_chance))
		var/list/cardinals = GLOB.cardinals.Copy()
		for(var/direction in cardinals)
			var/turf/T = get_step(src, direction)
			if(istype(T, /turf/open/floor) && !T.density && !locate(/obj/structure/coral_formation) in T)
				if(prob(20))
					new /obj/structure/coral_formation/small(T)
					break

/obj/structure/coral_formation/Bumped(atom/movable/AM)
	. = ..()
	if(isliving(AM) && !("deepone" in AM:faction))
		playsound(src, pick('sound/combat/hits/bladed/smallslash (1).ogg', 'sound/combat/hits/bladed/smallslash (2).ogg', 'sound/combat/hits/bladed/smallslash (3).ogg'), 50, FALSE)
		for(var/mob/living/mob in range(range, src))
			mob.apply_damage(damage_on_contact, BRUTE)
			to_chat(mob, "<span class='danger'>Coral shard fly into you!</span>")

/obj/structure/coral_formation/attackby(obj/item/W, mob/user, list/modifiers)
	. = ..()
	health -= W.force
	if(health <= 0)
		to_chat(user, "<span class='notice'>The coral formation crumbles!</span>")
		qdel(src)

/obj/structure/coral_formation/small
	name = "small coral growth"
	desc = "A small formation of sharp coral."
	icon_state = "coral_small"  // Would need a new sprite
	health = 50
	max_health = 50
	damage_on_contact = 5
	can_grow = FALSE
	range = 1

// Add boss ability to create coral walls
/datum/ai_behavior/fishboss_coral_wall
	action_cooldown = 0.5 SECONDS

/datum/ai_behavior/fishboss_coral_wall/perform(delta_time, datum/ai_controller/controller)
	. = ..()
	var/mob/living/simple_animal/hostile/boss/fishboss/boss = controller.pawn
	if(!istype(boss))
		finish_action(controller, FALSE)
		return

	boss.visible_message("<span class='warning'>[boss] gestures, causing coral to violently erupt from the ground!</span>")
	//playsound(boss, 'sound/effects/break_stone.ogg', 100, TRUE) // Replace with appropriate sound

	// Create a line of coral between the boss and its target
	var/atom/target = controller.blackboard[BB_BASIC_MOB_CURRENT_TARGET]
	if(!QDELETED(target))
		var/turf/boss_turf = get_turf(boss)
		var/turf/target_turf = get_turf(target)

		if(boss_turf && target_turf)
			var/list/line = getline(boss_turf, target_turf)
			// Remove the turfs at the beginning and end of the line (boss and target positions)
			if(length(line) > 2)
				line = line.Copy(2, length(line))
				// Only use half the line to not trap the target completely
				var/coral_length = max(1, round(length(line) / 2))
				for(var/i = 1 to coral_length)
					var/turf/T = line[i]
					if(istype(T, /turf/open/floor) && !T.density && !locate(/obj/structure/coral_formation) in T)
						new /obj/effect/temp_visual/coral_spawn(T)

	// Set cooldown in the controller blackboard
	controller.set_blackboard_key(BB_FISHBOSS_SPECIAL_COOLDOWN, world.time + 40 SECONDS)
	finish_action(controller, TRUE)
