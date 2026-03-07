/datum/ai_controller/human_bum
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
		/datum/ai_planning_subtree/call_for_help,
		/datum/ai_planning_subtree/generic_break_restraints,
		/datum/ai_planning_subtree/generic_resist,
		/datum/ai_planning_subtree/use_powder/bum,
		/datum/ai_planning_subtree/use_bandage,
		/datum/ai_planning_subtree/use_throwable,
		/datum/ai_planning_subtree/use_healing_drink,
		/datum/ai_planning_subtree/throw_grenade,
		/datum/ai_planning_subtree/flee_target,

		/datum/ai_planning_subtree/tree_climb,
		/datum/ai_planning_subtree/archer_base,
		/datum/ai_planning_subtree/ranged_attack_subtree,

		/datum/ai_planning_subtree/target_retaliate/bum,
		/datum/ai_planning_subtree/basic_melee_attack_subtree/human_npc,

		/datum/ai_planning_subtree/find_weapon,
		/datum/ai_planning_subtree/equip_item,
		/datum/ai_planning_subtree/retrieve_arrows,
		/datum/ai_planning_subtree/mug,
		/datum/ai_planning_subtree/loot,

	)

	idle_behavior = /datum/idle_behavior/idle_random_bum


/datum/ai_controller/human_bum/aggressive
	planning_subtrees = list(
		/datum/ai_planning_subtree/pet_planning,
		/datum/ai_planning_subtree/call_for_help,
		/datum/ai_planning_subtree/generic_break_restraints,
		/datum/ai_planning_subtree/generic_resist,
		/datum/ai_planning_subtree/use_powder/bum,
		/datum/ai_planning_subtree/use_bandage,
		/datum/ai_planning_subtree/use_throwable,
		/datum/ai_planning_subtree/use_healing_drink,
		/datum/ai_planning_subtree/throw_grenade,
		/datum/ai_planning_subtree/flee_target,

		/datum/ai_planning_subtree/tree_climb,
		/datum/ai_planning_subtree/archer_base,
		/datum/ai_planning_subtree/ranged_attack_subtree,

		/datum/ai_planning_subtree/aggro_find_target/bum,
		/datum/ai_planning_subtree/basic_melee_attack_subtree/human_npc,

		/datum/ai_planning_subtree/find_weapon,
		/datum/ai_planning_subtree/equip_item,
		/datum/ai_planning_subtree/retrieve_arrows,
		/datum/ai_planning_subtree/mug,
		/datum/ai_planning_subtree/loot,

	)

/datum/ai_controller/human_bum/TryPossessPawn(atom/new_pawn)
	. = ..()
	var/mob/living/living_pawn = new_pawn
	RegisterSignal(new_pawn, COMSIG_MOB_MOVESPEED_UPDATED, PROC_REF(update_movespeed))
	movement_delay = living_pawn.cached_multiplicative_slowdown
	new_pawn.AddComponent(/datum/component/ai_inventory_manager)
	new_pawn.AddElement(/datum/element/interrupt_on_damage)
	new_pawn.AddComponent(/datum/component/combat_vocalizer)

/datum/ai_controller/human_bum/UnpossessPawn(destroy)

	UnregisterSignal(pawn, list(
		COMSIG_MOB_MOVESPEED_UPDATED,
	))

	return ..() //Run parent at end

/datum/ai_controller/human_bum/proc/update_movespeed(mob/living/pawn)
	SIGNAL_HANDLER
	movement_delay = pawn.cached_multiplicative_slowdown
