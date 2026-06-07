/datum/ai_controller/cat
	movement_delay = 0.4 SECONDS
	ai_movement = /datum/ai_movement/hybrid_pathing
	blackboard = list(
		BB_TARGETTING_DATUM = new /datum/targetting_datum/basic/allow_items(),
		BB_PET_TARGETING_DATUM = new /datum/targetting_datum/basic/not_friends(),
		BB_HOSTILE_MEOWS = list("Mawwww", "Mrewwww", "mhhhhng..."),
		BB_HUNGRY_MEOW = list("mrrp...", "mraw..."),

		BB_CAT_RACISM = TRUE,
		BB_CAT_REST_CHANCE = 1,
		BB_CAT_SIT_CHANCE = 1,
		BB_CAT_GET_UP_CHANCE = 2,
		BB_CAT_GROOM_CHANCE = 1,
	)
	planning_subtrees = list(
		/datum/ai_planning_subtree/pet_planning,
		/datum/ai_planning_subtree/flee_target/from_flee_key/cat_struggle,
		/datum/ai_planning_subtree/cat_rest_behavior,
		/datum/ai_planning_subtree/detect_vampire_or_race,
		/datum/ai_planning_subtree/find_food,
		/datum/ai_planning_subtree/bring_food_to_babies,
		/datum/ai_planning_subtree/basic_melee_attack_subtree/cat,
		/datum/ai_planning_subtree/territorial_struggle,
		/datum/ai_planning_subtree/make_babies
	)
	idle_behavior = /datum/idle_behavior/idle_random_walk

/datum/ai_controller/kitten
	movement_delay = 0.4 SECONDS
	ai_movement = /datum/ai_movement/hybrid_pathing
	blackboard = list(
		BB_TARGETTING_DATUM = new /datum/targetting_datum/basic/allow_items(),
		BB_PET_TARGETING_DATUM = new /datum/targetting_datum/basic/not_friends(),
		BB_FIND_MOM_TYPES = list(/mob/living/simple_animal/pet/cat),
		BB_IGNORE_MOM_TYPES = list(/mob/living/simple_animal/pet/cat/kitten),
		BB_HUNGRY_MEOW = list("mrrp...", "mraw..."),
	)
	planning_subtrees = list(
		/datum/ai_planning_subtree/pet_planning,
		/datum/ai_planning_subtree/simple_find_nearest_target_to_flee,
		/datum/ai_planning_subtree/flee_target,
		/datum/ai_planning_subtree/detect_vampire_or_race,
		/datum/ai_planning_subtree/beg_human,
		/datum/ai_planning_subtree/find_food/rat,
		/datum/ai_planning_subtree/basic_melee_attack_subtree/cat,
		/datum/ai_planning_subtree/look_for_adult/kitten,
	)
	idle_behavior = /datum/idle_behavior/idle_random_walk
