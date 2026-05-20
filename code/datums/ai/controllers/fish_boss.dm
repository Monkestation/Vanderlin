/datum/ai_controller/fishboss
	movement_delay = 1 SECONDS
	ai_movement = /datum/ai_movement/hybrid_pathing
	blackboard = list(
		BB_TARGETTING_DATUM = new /datum/targetting_datum/basic(),
		BB_MINIONS_TO_SPAWN = 2,
		BB_NEXT_SUMMON = 0,
		BB_SPAWNED_MOBS = 0,
		BB_RANGED_COOLDOWN = 0,
		BB_RAGE_PHASE = 0,      // Track boss phase (0-3)
		BB_FISHBOSS_SPECIAL_COOLDOWN = 0, // Cooldown for special abilities
		BB_FISHBOSS_TIDAL_WAVE_COOLDOWN = 0, // Specific cooldown for tidal wave
		BB_FISHBOSS_WHIRLPOOL_COOLDOWN = 0,  // Specific cooldown for whirlpool
		BB_FISHBOSS_DEEP_CALL_COOLDOWN = 0   // Specific cooldown for deep call
	)
	planning_subtrees = list(
		/datum/ai_planning_subtree/fishboss_check_environment,
		/datum/ai_planning_subtree/aggro_find_target,
		/datum/ai_planning_subtree/fishboss_check_phase,
		/datum/ai_planning_subtree/fishboss_summon_minions,
		/datum/ai_planning_subtree/fishboss_special_ability,
		/datum/ai_planning_subtree/basic_melee_attack_subtree/opportunistic,
		/datum/ai_planning_subtree/basic_ranged_attack_subtree,
	)
	idle_behavior = /datum/idle_behavior/idle_random_walk


// Deep water tile - slows movement and can be used by the boss to heal pretty much used in the arena.
/obj/effect/deep_water
	name = "deep water"
	desc = "Unnaturally dark water that seems to be deeper than it appears."
	icon = 'icons/effects/water.dmi'  // Replace with appropriate icon
	icon_state = "deep"  // Replace with appropriate icon_state
	anchored = TRUE
	layer = BELOW_MOB_LAYER
	var/slow_factor = 2
	var/heal_amount = 5

/obj/effect/deep_water/Initialize()
	. = ..()
	START_PROCESSING(SSobj, src)

/obj/effect/deep_water/Destroy()
	STOP_PROCESSING(SSobj, src)
	return ..()

/obj/effect/deep_water/process()
	for(var/mob/living/L in loc)
		if(istype(L, /mob/living/simple_animal/hostile/boss/fishboss))
			// Heal the boss if it's in deep water
			var/mob/living/simple_animal/hostile/boss/fishboss/F = L
			F.adjustHealth(-heal_amount)
			if(prob(30))
				new /obj/effect/temp_visual/heal(get_turf(F))
		else if( !("deepone" in L.faction))
			// Slow down players/non-deep ones
			L.add_movespeed_modifier(MOVESPEED_ID_FISH_BOSS, multiplicative_slowdown = 2)

			// Small chance of damage from unseen creatures in the water
			if(prob(5))
				L.apply_damage(3, BRUTE)
				to_chat(L, "<span class='danger'>Something brushes against you in the dark water!</span>")

/obj/effect/deep_water/Crossed(atom/movable/AM)
	. = ..()
	if(isliving(AM) && !("deepone" in AM:faction))
		to_chat(AM, "<span class='warning'>The water is surprisingly deep and difficult to move through!</span>")

/obj/effect/deep_water/Uncrossed(atom/movable/AM)
	. = ..()

	if(!isliving(AM))
		return

	var/mob/living/L = AM
	if("deepone" in L.faction)
		return

	L.remove_movespeed_modifier(MOVESPEED_ID_FISH_BOSS)
