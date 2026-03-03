/datum/ai_controller/basic_controller/chicken
	movement_delay = 0.8 SECONDS

	blackboard = list(
		BB_TARGETTING_DATUM = new /datum/targetting_datum/basic/allow_items(),
		BB_NEST_LIST = list(/obj/structure/fluff/nest),
		BB_NEST_MATERIAL_LIST = list(/obj/item/natural/fibers, /obj/item/grown/log/tree/stick),
		BB_NEST_IGNORE_LIST = list(),
	)

	ai_traits = STOP_MOVING_WHEN_PULLED
	ai_movement = /datum/ai_movement/astar
	idle_behavior = /datum/idle_behavior/idle_random_walk
	planning_subtrees = list(
		/datum/ai_planning_subtree/lay_egg,
		/datum/ai_planning_subtree/find_food,
		//attacking the food will eat it
		/datum/ai_planning_subtree/basic_melee_attack_subtree,
		/datum/ai_planning_subtree/find_nearest_thing_which_attacked_me_to_flee,
		/datum/ai_planning_subtree/flee_target,
	)

/datum/ai_controller/basic_controller/chicken/baby
	blackboard = list(
		BB_TARGETTING_DATUM = new /datum/targetting_datum/basic/allow_items(),
		BB_FIND_MOM_TYPES = list(/mob/living/simple_animal/hostile/retaliate/chicken),
	)

	ai_traits = STOP_MOVING_WHEN_PULLED
	ai_movement = /datum/ai_movement/astar
	idle_behavior = /datum/idle_behavior/idle_random_walk
	planning_subtrees = list(
		/datum/ai_planning_subtree/find_food,
		//attacking the food will eat it
		/datum/ai_planning_subtree/basic_melee_attack_subtree,
		/datum/ai_planning_subtree/find_nearest_thing_which_attacked_me_to_flee,
		/datum/ai_planning_subtree/flee_target,
		/datum/ai_planning_subtree/look_for_adult,
	)
