/mob/living/simple_animal/hostile
	faction = list(FACTION_HOSTILE)
	obj_damage = 40
	environment_smash = ENVIRONMENT_SMASH_STRUCTURES //Bitflags. Set to ENVIRONMENT_SMASH_STRUCTURES to break closets,tables,racks, etc; ENVIRONMENT_SMASH_WALLS for walls; ENVIRONMENT_SMASH_RWALLS for rwalls
	var/atom/target
	var/ranged = FALSE
	var/rapid = 0 //How many shots per volley.
	var/rapid_fire_delay = 2 //Time between rapid fire shots

	var/projectiletype	//set ONLY it and NULLIFY casingtype var, if we have ONLY projectile
	var/projectilesound
	var/casingtype		//set ONLY it and NULLIFY projectiletype, if we have projectile IN CASING
	var/move_to_delay = 3 //delay for the automated movement.
	var/list/friends = list()
	var/list/emote_taunt = list()
	var/taunt_chance = 0

	var/rapid_melee = 1			 //Number of melee attacks between each npc pool tick. Spread evenly.
	var/melee_queue_distance = 4 //If target is close enough start preparing to hit them if we have rapid_melee enabled

	var/ranged_message = "fires" //Fluff text for ranged mobs
	var/ranged_cooldown = 0 //What the current cooldown on ranged attacks is, generally world.time + ranged_cooldown_time
	var/ranged_cooldown_time = 30 //How long, in deciseconds, the cooldown of ranged attacks is
	var/ranged_ignores_vision = FALSE //if it'll fire ranged attacks even if it lacks vision on its target, only works with environment smash
	var/retreat_distance = null //If our mob runs from players when they're too close, set in tile distance. By default, mobs do not retreat.
	var/minimum_distance = 1 //Minimum approach distance, so ranged mobs chase targets down, but still keep their distance set in tiles to the target, set higher to make mobs keep distance


//These vars are related to how mobs locate and target
	var/robust_searching = 0 //By default, mobs have a simple searching method, set this to 1 for the more scrutinous searching (stat_attack, stat_exclusive, etc), should be disabled on most mobs
	var/vision_range = 6 //How big of an area to search for targets in, a vision of 9 attempts to find targets as soon as they walk into screen view
	var/aggro_vision_range = 18 //If a mob is aggro, we search in this radius. Defaults to 9 to keep in line with original simple mob aggro radius
	var/stat_attack = CONSCIOUS //Mobs with stat_attack to UNCONSCIOUS will attempt to attack things that are unconscious, Mobs with stat_attack set to DEAD will attempt to attack the dead.
	var/stat_exclusive = FALSE //Mobs with this set to TRUE will exclusively attack things defined by stat_attack, stat_attack DEAD means they will only attack corpses
	var/atom/targets_from = null //all range/attack/etc. calculations should be done from this atom, defaults to the mob itself, useful for Vehicles and such

	var/lose_patience_timer_id //id for a timer to call LoseTarget(), used to stop mobs fixating on a target they can't reach
	var/lose_patience_timeout = 300 //30 seconds by default, so there's no major changes to AI behaviour, beyond actually bailing if stuck forever

	var/del_on_deaggro = 0 //seconds to delete after losing aggro
	var/last_aggro_loss = null

	var/retreat_health

	var/next_seek

	cmode = 1
	setparrytime = 30
	dodgetime = 30


/mob/living/simple_animal/hostile/Initialize()
	. = ..()
	last_aggro_loss = world.time //so we delete even if we never found a target
	if(!targets_from)
		targets_from = src

	if(ranged)
		if(projectiletype)
			AddComponent(/datum/component/ranged_attacks, projectile_type = projectiletype, projectile_sound = projectilesound, burst_shots = rapid, burst_intervals = rapid_fire_delay, cooldown_time = ranged_cooldown_time, ranged_message = ranged_message)
		else if(casingtype)
			AddComponent(/datum/component/ranged_attacks, casing_type = casingtype, projectile_sound = projectilesound, burst_shots = rapid, burst_intervals = rapid_fire_delay, cooldown_time = ranged_cooldown_time, ranged_message = ranged_message)

/mob/living/simple_animal/hostile/Destroy()
	target = null
	targets_from = null
	return ..()

/mob/living/simple_animal/hostile/Life()
	. = ..()
	if(!.) //dead
		walk(src, 0) //stops walking
		return 0

/mob/living/proc/AttackingTarget(mob/living/passed_target)
	return

/mob/living/simple_animal/hostile/AttackingTarget(mob/living/passed_target)
	if(SEND_SIGNAL(src, COMSIG_HOSTILE_PRE_ATTACKINGTARGET, passed_target) & COMPONENT_HOSTILE_NO_PREATTACK)
		return FALSE //but more importantly return before attack_animal called
	SEND_SIGNAL(src, COMSIG_HOSTILE_ATTACKINGTARGET, passed_target)
	var/mob/living/actual_target = passed_target
	if(!actual_target)
		actual_target = target
	if(!QDELETED(actual_target))
		return actual_target.attack_animal(src)
