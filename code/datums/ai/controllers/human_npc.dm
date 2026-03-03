
/datum/ai_controller/human_npc
	movement_delay = 0.5 SECONDS
	max_target_distance = 13
	ai_movement = /datum/ai_movement/hybrid_pathing
	blackboard = list(
		BB_WEAPON_TYPE = /obj/item/weapon,
		BB_ARMOR_CLASS = 2,
		BB_TARGETTING_DATUM = new /datum/targetting_datum/basic(),
		BB_PET_TARGETING_DATUM = new /datum/targetting_datum/basic/not_friends(),

		BB_HUMAN_NPC_ATTACK_ZONE_COUNTER = 0,  // how many times we've hit the same zone
		BB_HUMAN_NPC_LAST_ATTACK_ZONE = null,  // last zone we attacked
		BB_HUMAN_NPC_WEAKPOINT = null,         // cached weakpoint zone if we found one
		BB_HUMAN_NPC_JUMP_COOLDOWN = 0,        // world.time when we can next jump
		BB_HUMAN_NPC_FLANK_ANGLE = null,       // our claimed flank direction (degrees, 0-359)
		BB_HUMAN_NPC_FLANK_TARGET = null,      // the turf we're moving toward for flanking
		BB_HUMAN_NPC_HARASS_MODE = FALSE,      // TRUE when in hit-and-run mode
		BB_HUMAN_NPC_HARASS_RETREATING = FALSE,// TRUE when in the back-off phase of harass
		BB_HUMAN_NPC_HARASS_COOLDOWN = 0,      // world.time before we can dart in again
		BB_HUMAN_NPC_JUKE_COOLDOWN = 0,        // world.time before we can juke again
	)
	planning_subtrees = list(
		/datum/ai_planning_subtree/pet_planning,
		/datum/ai_planning_subtree/call_for_help,
		/datum/ai_planning_subtree/generic_break_restraints,
		/datum/ai_planning_subtree/use_powder,
		/datum/ai_planning_subtree/use_bandage,
		/datum/ai_planning_subtree/use_throwable,
		/datum/ai_planning_subtree/use_healing_drink,
		/datum/ai_planning_subtree/throw_grenade,
		/datum/ai_planning_subtree/generic_wield,
		/datum/ai_planning_subtree/generic_resist,
		/datum/ai_planning_subtree/generic_stand,
		/datum/ai_planning_subtree/flee_target,
		/datum/ai_planning_subtree/tree_climb,
		/datum/ai_planning_subtree/archer_base,
		/datum/ai_planning_subtree/ranged_attack_subtree,
		/datum/ai_planning_subtree/aggro_find_target,
		/datum/ai_planning_subtree/squad_flank,
		/datum/ai_planning_subtree/basic_melee_attack_subtree/human_npc,
		/datum/ai_planning_subtree/find_weapon,
		/datum/ai_planning_subtree/equip_item,
		/datum/ai_planning_subtree/retrieve_arrows,
		/datum/ai_planning_subtree/loot,
	)
	idle_behavior = /datum/idle_behavior/idle_random_walk

/datum/ai_controller/human_npc/TryPossessPawn(atom/new_pawn)
	. = ..()
	var/mob/living/living_pawn = new_pawn
	RegisterSignal(new_pawn, COMSIG_MOB_MOVESPEED_UPDATED, PROC_REF(update_movespeed))
	movement_delay = living_pawn.cached_multiplicative_slowdown
	new_pawn.AddComponent(/datum/component/ai_inventory_manager)
	new_pawn.AddElement(/datum/element/interrupt_on_damage)
	new_pawn.AddComponent(/datum/component/combat_vocalizer)

/datum/ai_controller/human_npc/UnpossessPawn(destroy)
	UnregisterSignal(pawn, list(
		COMSIG_MOB_MOVESPEED_UPDATED,
	))
	return ..()

/datum/ai_controller/human_npc/proc/update_movespeed(mob/living/pawn)
	SIGNAL_HANDLER
	movement_delay = pawn.cached_multiplicative_slowdown

/datum/ai_controller/human_npc/can_move()
	. = ..()
	if(!.)
		return FALSE
	var/mob/living/living_pawn = pawn
	if(living_pawn.pulledby)
		return FALSE
