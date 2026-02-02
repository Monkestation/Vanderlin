/datum/ai_controller/species_hostile
	movement_delay = 0.5 SECONDS

	ai_movement = /datum/ai_movement/hybrid_pathing

	blackboard = list(
		BB_WEAPON_TYPE = /obj/item/weapon,
		BB_ARMOR_CLASS = 2,

		BB_TARGETTING_DATUM = new /datum/targetting_datum/basic(),
		BB_PET_TARGETING_DATUM = new /datum/targetting_datum/basic/not_friends(),

	)

	planning_subtrees = list(
		/datum/ai_planning_subtree/pet_planning,
		/datum/ai_planning_subtree/generic_resist,
		/datum/ai_planning_subtree/flee_target,

		/datum/ai_planning_subtree/aggro_find_target/species_hostile,
		/datum/ai_planning_subtree/basic_melee_attack_subtree/species_hostile,

		/datum/ai_planning_subtree/find_weapon,
		/datum/ai_planning_subtree/equip_item,

	)


/datum/ai_controller/species_hostile/TryPossessPawn(atom/new_pawn)
	. = ..()
	var/mob/living/living_pawn = new_pawn
	RegisterSignal(new_pawn, COMSIG_MOB_MOVESPEED_UPDATED, PROC_REF(update_movespeed))
	movement_delay = living_pawn.cached_multiplicative_slowdown


/datum/ai_controller/species_hostile/UnpossessPawn(destroy)

	UnregisterSignal(pawn, list(
		COMSIG_MOB_MOVESPEED_UPDATED,
	))

	return ..() //Run parent at end

/datum/ai_controller/species_hostile/proc/update_movespeed(mob/living/pawn)
	SIGNAL_HANDLER
	movement_delay = pawn.cached_multiplicative_slowdown
