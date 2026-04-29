/datum/intent/unarmed/dragonclaw
	name = "gouge"
	icon_state = "inchop"
	attack_verb = list("slashes", "gouges", "eviscerates")
	animname = "cut"
	blade_class = BCLASS_CHOP
	hitsound = "genslash"
	penfactor = 60
	damfactor = 40
	candodge = TRUE
	canparry = TRUE
	miss_text = "slashes the air!"
	miss_sound = "bluntwooshlarge"

/mob/living/simple_animal/hostile/retaliate/voiddragon
	name = "void dragon"
	desc = "An ancient creature from a bygone age. Now would be a good time to run."
	icon = 'icons/mob/96x96/ratwood_dragon.dmi'
	icon_state = "dragon"
	icon_living = "dragon"
	icon_dead = "dragon_dead"

	health = 2500
	maxHealth = 2500
	attack_verb_continuous = "gouges"
	attack_verb_simple = "gouge"
	attack_sound = 'sound/misc/demon_attack1.ogg'
	summon_primer = "You are ancient. A creature long since banished to the void ages past, you were trapped in a seemingly timeless abyss. Now you've been freed, returned to the world- and everything has changed. It seems some of your constructs remain buried beneath the ground. How you react to these events, only time can tell."
	tier = 5
	speak_emote = list("roars")
	base_intents = list(/datum/intent/unarmed/dragonclaw)
	faction = list("aberrant")
	melee_damage_lower = 40
	melee_damage_upper = 40
	retreat_distance = 0
	minimum_distance = 0
	speed = 5
	move_to_delay = 5
	ranged = TRUE
	SET_BASE_PIXEL(-32, 0)
	aggressive = 1
	deathmessage = "collapses to the floor with a final roar, the impact rocking the ground."
	footstep_type = FOOTSTEP_MOB_HEAVY
	var/void_corruption = TRUE
	dendor_taming_chance = DENDOR_TAME_PROB_NONE
	food_max = 0

	ai_controller = /datum/ai_controller/voiddragon

/mob/living/simple_animal/hostile/retaliate/voiddragon/Initialize()
	. = ..()
	AddComponent(/datum/component/ai_aggro_system)
	ADD_TRAIT(src,TRAIT_NOFIRE, "[type]")
	ADD_TRAIT(src, TRAIT_NOBREATH, TRAIT_GENERIC)
	ADD_TRAIT(src, TRAIT_ANTIMAGIC, TRAIT_GENERIC)
	ADD_TRAIT(src, TRAIT_TOXIMMUNE, TRAIT_GENERIC)

	var/datum/ai_controller/voiddragon/controller = ai_controller
	if(controller)
		controller.blackboard[BB_DRAGON_HEALTH_PERCENTAGE] = health / maxHealth
		controller.blackboard[BB_DRAGON_CL_COOLDOWN] = 0
		controller.blackboard[BB_DRAGON_LIGHTNING_COOLDOWN] = 0
		controller.blackboard[BB_DRAGON_SUMMON_COOLDOWN] = 0
		controller.blackboard[BB_DRAGON_SLAM_COOLDOWN] = 0

	// Set up repulse spell
	var/datum/action/cooldown/spell/aoe/repulse/dragon/repulse_action = new(src)
	repulse_action.Grant(src)

/mob/living/simple_animal/hostile/retaliate/voiddragon/proc/TailSwipe(mob/victim)
	var/mob/living/target = victim
	src.visible_message(span_notice("[src] slams [target] with it's tail, knocking them to the floor!"))
	target.Paralyze(5)
	target.apply_damage(20, BRUTE)
	shake_camera(target, 2, 1)

/mob/living/simple_animal/hostile/retaliate/voiddragon/proc/SetRecoveryTime(buffer_time)
	var/datum/ai_controller/voiddragon/controller = ai_controller
	if(controller)
		controller.blackboard[BB_DRAGON_RECOVERY_TIME] = world.time + buffer_time

/mob/living/simple_animal/hostile/retaliate/voiddragon/proc/enrage()
	if(((health / maxHealth) * 100 <= 80))
		return
	var/datum/ai_controller/voiddragon/controller = ai_controller
	if(controller)
		controller.blackboard[BB_DRAGON_ENRAGED] = TRUE

/mob/living/simple_animal/hostile/retaliate/voiddragon/proc/unrage()
	var/datum/ai_controller/voiddragon/controller = ai_controller
	if(controller)
		controller.blackboard[BB_DRAGON_ENRAGED] = FALSE

/mob/living/simple_animal/hostile/retaliate/voiddragon/adjustHealth(amount, updating_health = TRUE)
	. = ..()
	var/datum/ai_controller/voiddragon/controller = ai_controller
	if(controller)
		controller.blackboard[BB_DRAGON_HEALTH_PERCENTAGE] = health / maxHealth
		controller.blackboard[BB_DRAGON_ANGER_MODIFIER] = clamp(max((maxHealth - health) / 50, controller.blackboard[BB_DRAGON_ENRAGED] ? 15 : 0), 0, 20)

/mob/living/simple_animal/hostile/retaliate/voiddragon/proc/create_lightning(atom/target)
	if(!target)
		return
	var/turf/targetturf = get_turf(target)
	var/last_dist = 0
	for(var/turf/T as anything in spiral_range_turfs(4, targetturf))
		if(!T)
			continue
		var/dist = get_dist(targetturf, T)
		if(dist > last_dist)
			last_dist = dist
			sleep(2 + min(4 - last_dist, 12) * 0.5) //gets faster
		new /obj/effect/temp_visual/target/lightning(T)

/mob/living/simple_animal/hostile/retaliate/voiddragon/proc/dragon_slam(mob/owner, range, delay, throw_range)
	var/turf/origin = get_turf(owner)
	if(!origin)
		return
	var/list/all_turfs = RANGE_TURFS(range, origin)
	for(var/sound_range = 0 to range)
		playsound(origin,'sound/misc/bamf.ogg', 600, TRUE, 10)
		for(var/turf/stomp_turf in all_turfs)
			if(get_dist(origin, stomp_turf) > sound_range)
				continue
			new /obj/effect/temp_visual/small_smoke/halfsecond(stomp_turf)
			for(var/mob/living/hit_mob in stomp_turf)
				if(hit_mob == owner || hit_mob.throwing)
					continue
				to_chat(hit_mob, span_userdanger("[owner]'s ground slam shockwave sends you flying!"))
				var/turf/thrownat = get_ranged_target_turf_direct(owner, hit_mob, throw_range, rand(-10, 10))
				hit_mob.throw_at(thrownat, 8, 2, null, TRUE, force = MOVE_FORCE_OVERPOWERING)
				hit_mob.apply_damage(20, BRUTE)
				shake_camera(hit_mob, 2, 1)
			all_turfs -= stomp_turf
		SLEEP_CHECK_DEATH(delay)

/mob/living/simple_animal/hostile/retaliate/voiddragon/proc/summon_obelisk()
	var/list/spawnLists = list(/mob/living/simple_animal/hostile/retaliate/voidstoneobelisk,/mob/living/simple_animal/hostile/retaliate/voidstoneobelisk)
	var/reinforcement_count = 2
	src.visible_message(span_cultbigbold("[src] summons aberrant obelisks from beneath the ground."))
	while(reinforcement_count > 0)
		var/list/turflist = list()
		for(var/turf/t in RANGE_TURFS(1, src))
			turflist += t

		var/turf/picked = pick(turflist)

		var/spawnTypes = pick_n_take(spawnLists)
		new spawnTypes(picked)
		reinforcement_count--
		continue

/mob/living/simple_animal/hostile/retaliate/voiddragon/proc/lava_swoop(amount = 30)
	var/datum/ai_controller/voiddragon/controller = ai_controller
	var/enraged = FALSE
	if(controller)
		enraged = controller.blackboard[BB_DRAGON_ENRAGED]

	if(health < maxHealth * 0.5)
		return swoop_attack(lava_arena = TRUE, swoop_cooldown = enraged ? 2 SECONDS : 6 SECONDS)

	INVOKE_ASYNC(src, PROC_REF(lightning_strikes), enraged ? 60 : amount)
	swoop_attack(FALSE, target, 1000) // longer cooldown until it gets reset below
	SLEEP_CHECK_DEATH(0)
	if(health < maxHealth*0.5)
		SetRecoveryTime(40)

/mob/living/simple_animal/hostile/retaliate/voiddragon/proc/lightning_strikes(amount, delay = 0.8)
	if(!target)
		return
	target.visible_message(span_colossus("Lightning starts to strike down from the sky!"))
	var/datum/ai_controller/voiddragon/controller = ai_controller
	var/enraged = FALSE
	if(controller)
		enraged = controller.blackboard[BB_DRAGON_ENRAGED]

	while(amount > 0)
		if(QDELETED(target))
			break
		var/turf/T = pick(RANGE_TURFS(enraged ? 2 : 1, target))
		new /obj/effect/temp_visual/target/lightning(T)
		amount--
		SLEEP_CHECK_DEATH(delay)

#define DRAKE_SWOOP_HEIGHT 270 //how high up drakes go, in pixels
#define DRAKE_SWOOP_DIRECTION_CHANGE_RANGE 5 //the range our x has to be within to not change the direction we slam from

#define SWOOP_DAMAGEABLE 1
#define SWOOP_INVULNERABLE 2


/mob/living/simple_animal/hostile/retaliate/voiddragon/proc/swoop_attack(lava_arena = FALSE, atom/movable/manual_target, swoop_cooldown = 30)
	var/datum/ai_controller/voiddragon/controller = ai_controller
	if(controller)
		controller.blackboard[BB_DRAGON_SWOOPING] |= SWOOP_DAMAGEABLE

	if(stat || controller.blackboard[BB_DRAGON_SWOOPING])
		return
	if(manual_target)
		target = manual_target
	if(!target)
		return

	playsound(src, 'sound/vo/mobs/vdragon/drgnroar.ogg', 50, TRUE, -1)
	controller.blackboard[BB_DRAGON_SWOOPING] |= SWOOP_DAMAGEABLE
	ADD_TRAIT(src, TRAIT_MOVE_FLYING, AI_ATTACK_TRAIT)
	density = FALSE
	icon_state = "shadow"
	visible_message("<span class='boldwarning'>[src] swoops up high!</span>")

	var/negative
	var/initial_x = x
	if(target.x < initial_x) //if the target's x is lower than ours, swoop to the left
		negative = TRUE
	else if(target.x > initial_x)
		negative = FALSE
	else if(target.x == initial_x) //if their x is the same, pick a direction
		negative = prob(50)
	var/obj/effect/temp_visual/dragon_flight/F = new /obj/effect/temp_visual/dragon_flight(loc, negative)

	negative = !negative //invert it for the swoop down later

	var/oldtransform = transform
	alpha = 255
	animate(src, alpha = 204, transform = matrix()*0.9, time = 3, easing = BOUNCE_EASING)
	for(var/i in 1 to 3)
		sleep(1)
		if(QDELETED(src) || stat == DEAD) //we got hit and died, rip us
			qdel(F)
			if(stat == DEAD)
				controller.blackboard[BB_DRAGON_SWOOPING] &= ~SWOOP_DAMAGEABLE
				animate(src, alpha = 255, transform = oldtransform, time = 0, flags = ANIMATION_END_NOW) //reset immediately
			return
	animate(src, alpha = 100, transform = matrix()*0.7, time = 7)
	controller.blackboard[BB_DRAGON_SWOOPING] |= SWOOP_INVULNERABLE
	mouse_opacity = MOUSE_OPACITY_TRANSPARENT
	SLEEP_CHECK_DEATH(7)

	while(target && loc != get_turf(target))
		forceMove(get_step(src, get_dir(src, target)))
		SLEEP_CHECK_DEATH(0.5)

	// Ash drake flies onto its target and rains fire down upon them
	var/descentTime = 10

	//ensure swoop direction continuity.
	if(negative)
		if(ISINRANGE(x, initial_x + 1, initial_x + DRAKE_SWOOP_DIRECTION_CHANGE_RANGE))
			negative = FALSE
	else
		if(ISINRANGE(x, initial_x - DRAKE_SWOOP_DIRECTION_CHANGE_RANGE, initial_x - 1))
			negative = TRUE
	new /obj/effect/temp_visual/dragon_flight/end(loc, negative)
	new /obj/effect/temp_visual/dragon_swoop(loc)
	animate(src, alpha = 255, transform = oldtransform, descentTime)
	SLEEP_CHECK_DEATH(descentTime)
	controller.blackboard[BB_DRAGON_SWOOPING] &= ~SWOOP_INVULNERABLE
	mouse_opacity = initial(mouse_opacity)
	icon_state = "[initial(icon_state)]"
	playsound(src, 'sound/misc/meteorimpact.ogg', 200, TRUE)
	for(var/mob/living/L in orange(1, src))
		if(L.stat)
			visible_message(span_warning("[src] slams down on [L], crushing [L.p_them()]!"))
			L.gib()
		else
			L.adjustBruteLoss(75)
			if(L && !QDELETED(L)) // Some mobs are deleted on death
				var/throw_dir = get_dir(src, L)
				if(L.loc == loc)
					throw_dir = pick(GLOB.alldirs)
				var/throwtarget = get_edge_target_turf(src, throw_dir)
				L.throw_at(throwtarget, 3)
				visible_message(span_warning("[L] is thrown clear of [src]!</span>"))
	for(var/mob/M in range(7, src))
		shake_camera(M, 15, 1)
	REMOVE_TRAIT(src, TRAIT_MOVE_FLYING, AI_ATTACK_TRAIT)
	density = TRUE
	SLEEP_CHECK_DEATH(1)
	controller.blackboard[BB_DRAGON_SWOOPING] &= ~SWOOP_DAMAGEABLE
	SetRecoveryTime(swoop_cooldown)

/mob/living/simple_animal/hostile/retaliate/voiddragon/proc/chain_lightning(list/targets, mob/user = usr)
	targets = list()

	for(var/mob/living/target in view(7, src))
		if(target == src)
			continue
		if(istype(target,/mob/living/simple_animal/hostile/retaliate/voidstoneobelisk))
			continue
		targets += target
	if(!length(targets))
		return
	src.move_resist = MOVE_FORCE_VERY_STRONG
	var/mob/living/carbon/target = targets[1]
	var/distance = get_dist(user.loc,target.loc)
	if(distance>3)
		to_chat(user, span_colossus("[target.p_theyre(TRUE)] too far away!"))
		return
	ai_controller.PauseAi(5 SECONDS)
	if(do_after(user, 5 SECONDS, target = src))
		user.Beam(target,icon_state="lightning[rand(1,12)]",time=5)
		src.visible_message(span_colossus("[src] unleashes a storm of lightning from its maw."))
		Bolt(user,target,30,5,user)
		src.move_resist = initial(src.move_resist)

/mob/living/simple_animal/hostile/retaliate/voiddragon/proc/Bolt(mob/origin, mob/target, bolt_energy, bounces, mob/user = usr)
	origin.Beam(target,icon_state="lightning[rand(1,12)]",time=5)
	var/mob/living/carbon/current = target
	if(current.can_block_magic(MAGIC_RESISTANCE))
		current.visible_message(span_warning("[current] absorbs the spell, remaining unharmed!"), span_danger("I absorb the spell, remaining unharmed!"))
	else if(bounces < 1)
		current.electrocute_act(bolt_energy,"Lightning Bolt",flags = SHOCK_NOGLOVES)
	else
		current.electrocute_act(bolt_energy,"Lightning Bolt",flags = SHOCK_NOGLOVES)
		var/list/possible_targets = new
		for(var/mob/living/M in view(7,target))
			if(user == M || target == M && los_check(current,M)) // || origin == M ? Not sure double shockings is good or not
				continue
			possible_targets += M
		if(!possible_targets.len)
			return
		var/mob/living/next = pick(possible_targets)
		if(next)
			Bolt(current,next,max((bolt_energy-5),5),bounces-1,user)

/mob/living/simple_animal/hostile/retaliate/voiddragon/proc/los_check(mob/A, mob/B)
	//Checks for obstacles from A to B
	var/obj/dummy = new(A.loc)
	dummy.pass_flags |= PASSTABLE
	for(var/turf/turf in getline(A,B))
		for(var/atom/movable/AM in turf)
			if(!AM.CanPass(dummy,turf,1))
				qdel(dummy)
				return 0
	qdel(dummy)
	return 1


/obj/effect/temp_visual/lava_warning
	icon_state = "lavastaff_warn"
	layer = BELOW_MOB_LAYER
	light_outer_range = 2
	duration = 13

/obj/effect/temp_visual/lava_warning/ex_act()
	return

/obj/effect/temp_visual/lava_warning/Initialize(mapload, reset_time = 10)
	. = ..()
	INVOKE_ASYNC(src, PROC_REF(fall), reset_time)
	src.alpha = 63.75
	animate(src, alpha = 255, time = duration)

/obj/effect/temp_visual/lava_warning/proc/fall(reset_time)
	var/turf/T = get_turf(src)
	playsound(T,'sound/magic/fleshtostone.ogg', 80, TRUE)
	sleep(duration)
	playsound(T,'sound/magic/fireball.ogg', 200, TRUE)

	for(var/mob/living/L in T.contents)
		if(istype(L, /mob/living/simple_animal/hostile/retaliate/voiddragon))
			continue
		L.adjustFireLoss(10)
		to_chat(L, "<span class='userdanger'>You fall directly into the pool of lava!</span>")

	// changes turf to lava temporarily
	if(!T.density && !islava(T))
		var/lava_turf = /turf/open/lava
		var/reset_turf = T.type
		T.ChangeTurf(lava_turf)
		sleep(reset_time)
		T.ChangeTurf(reset_turf)


/mob/living/simple_animal/hostile/retaliate/voiddragon/proc/void_pull(atom/target)
	var/turf/T = get_turf(src)
	playsound(T, 'sound/magic/charging_lightning.ogg', 100, TRUE)

	// Visual effect
	new /obj/effect/temp_visual/dragon_swirl(T)

	// Pull in all mobs within range
	for(var/mob/living/L in range(7, src))
		if(L == src || L.stat == DEAD)
			continue
		L.visible_message(span_warning("[L] is pulled toward [src]!"))

		var/throw_dist = get_dist(L, src)

		// Calculate throw speed based on distance
		var/throw_speed = max(1, 3 - round(throw_dist / 3))
		L.throw_at(src, throw_dist, throw_speed)
		L.apply_damage(10, BRUTE)
		if(void_corruption)
			L.apply_status_effect(/datum/status_effect/void_corruption)

	addtimer(CALLBACK(src, PROC_REF(void_pull_aftermath)), 1 SECONDS)

/mob/living/simple_animal/hostile/retaliate/voiddragon/proc/void_pull_aftermath()
	var/turf/T = get_turf(src)
	playsound(T, 'sound/magic/fireball.ogg', 200, TRUE)

	for(var/mob/living/L in range(2, src))
		if(L == src)
			continue
		L.apply_damage(15, BRUTE)
		new /obj/effect/temp_visual/dragon_strike(get_turf(L))

/mob/living/simple_animal/hostile/retaliate/voiddragon/proc/create_shadow_clones()
	// Create 2-3 shadow clones that attack nearby players
	var/num_clones = rand(2, 3)
	var/list/clone_locations = list()

	// Find suitable positions for clones
	for(var/turf/open/T in range(5, src))
		if(!T.density && !locate(/mob) in T)
			clone_locations += T

	if(length(clone_locations) < num_clones)
		num_clones = length(clone_locations)

	if(num_clones <= 0)
		return

	var/turf/T = get_turf(src)
	playsound(T, 'sound/magic/blink.ogg', 100, TRUE)
	new /obj/effect/temp_visual/dragon_shadow(T)

	alpha = 150

	// Spawn clones
	for(var/i in 1 to num_clones)
		if(!length(clone_locations))
			break
		var/turf/clone_loc = pick_n_take(clone_locations)
		new /mob/living/simple_animal/hostile/dragon_clone(clone_loc, src)
		new /obj/effect/temp_visual/dragon_shadow(clone_loc)

	addtimer(CALLBACK(src, PROC_REF(remove_transparency)), 30 SECONDS)

/mob/living/simple_animal/hostile/retaliate/voiddragon/proc/remove_transparency()
	alpha = initial(alpha)

/mob/living/simple_animal/hostile/retaliate/voiddragon/proc/wing_gust()

	var/turf/T = get_turf(src)
	playsound(T, 'sound/magic/meteorstorm.ogg', 100, TRUE)

	T.pollute_turf(/datum/pollutant/smoke, 300)

	for(var/mob/living/L in range(6, src))
		if(L == src)
			continue

		var/throw_dir = get_dir(src, L)
		var/throw_dist = max(2, 6 - get_dist(src, L))

		L.visible_message(span_danger("[L] is blown away by [src]'s wing gust!"))
		L.throw_at(get_edge_target_turf(L, throw_dir), throw_dist, 2)
		L.apply_damage(5, BRUTE)

		// Apply a brief stun
		L.Knockdown(0.5 SECONDS)

/mob/living/simple_animal/hostile/retaliate/voiddragon/proc/void_explosion(atom/target)
	var/turf/T = get_turf(target)

	visible_message(span_colossus("[src] begins to form a pulsating ball of void energy!"))

	new /obj/effect/temp_visual/dragon_explosion_target(T)

	playsound(src, 'sound/magic/charging_lightning.ogg', 100, TRUE)

	addtimer(CALLBACK(src, PROC_REF(void_explosion_detonate), T), 3 SECONDS)

/mob/living/simple_animal/hostile/retaliate/voiddragon/proc/void_explosion_detonate(turf/target)
	if(!target)
		return

	playsound(target, 'sound/magic/disintegrate.ogg', 200, TRUE)

	new /obj/effect/temp_visual/dragon_explosion(target)

	for(var/mob/living/L in range(3, target))
		var/dist = get_dist(target, L)
		var/damage = 30 * (1 - (dist / 4)) // 30 damage at epicenter, scaling down with distance
		L.apply_damage(damage, BRUTE)
		if(void_corruption)
			L.apply_status_effect(/datum/status_effect/void_corruption)

		var/throw_dir = get_dir(target, L)
		L.throw_at(get_edge_target_turf(L, throw_dir), 3, 2)

/mob/living/simple_animal/hostile/retaliate/voiddragon/proc/phase_shift()
	visible_message(span_colossus("[src] phases out of reality!"))

	incorporeal_move = INCORPOREAL_MOVE_JAUNT
	status_flags |= GODMODE
	playsound(src, 'sound/magic/ethereal_enter.ogg', 100, TRUE)
	alpha = 128

	var/phase_attacks = rand(3, 5)
	phase_shift_attack(phase_attacks)

/mob/living/simple_animal/hostile/retaliate/voiddragon/proc/phase_shift_attack(attacks_remaining)
	if(attacks_remaining <= 0)
		phase_shift_end()
		return

	var/list/possible_turfs = list()
	for(var/turf/open/T in range(10, src))
		if(!T.density)
			possible_turfs += T

	if(!length(possible_turfs))
		phase_shift_end()
		return
	var/turf/target_turf = pick(possible_turfs)
	forceMove(target_turf)

	playsound(target_turf, 'sound/magic/ethereal_exit.ogg', 100, TRUE)
	new /obj/effect/temp_visual/dragon_teleport(target_turf)

	for(var/mob/living/L in range(2, src))
		if(L == src)
			continue
		L.apply_damage(15, BRUTE)
		new /obj/effect/temp_visual/dragon_phase_strike(get_turf(L))

	addtimer(CALLBACK(src, PROC_REF(phase_shift_attack), attacks_remaining - 1), 1.5 SECONDS)

/mob/living/simple_animal/hostile/retaliate/voiddragon/proc/phase_shift_end()
	incorporeal_move = initial(incorporeal_move)
	status_flags &= ~GODMODE
	alpha = initial(alpha)

	playsound(src, 'sound/magic/ethereal_exit.ogg', 100, TRUE)
	visible_message(span_colossus("[src] phases back into reality!"))

	Stun(1 SECONDS)

/obj/effect/temp_visual/dragon_swirl
	icon = 'icons/effects/effects.dmi'
	icon_state = "shield1"
	duration = 10
	randomdir = 0

/obj/effect/temp_visual/dragon_shadow
	icon = 'icons/effects/effects.dmi'
	icon_state = "shadow"
	duration = 5
	randomdir = 0

/obj/effect/temp_visual/dragon_explosion_target
	icon = 'icons/effects/effects.dmi'
	icon_state = "target"
	duration = 30
	randomdir = 0

/obj/effect/temp_visual/dragon_explosion
	icon = 'icons/effects/effects.dmi'
	icon_state = "explosion"
	duration = 10
	randomdir = 0

/obj/effect/temp_visual/dragon_teleport
	icon = 'icons/effects/effects.dmi'
	icon_state = "blink"
	duration = 5
	randomdir = 0

/obj/effect/temp_visual/dragon_phase_strike
	icon = 'icons/effects/effects.dmi'
	icon_state = "slash"
	duration = 5
	randomdir = 0

/obj/effect/temp_visual/dragon_strike
	icon = 'icons/effects/effects.dmi'
	icon_state = "impact"
	duration = 5
	randomdir = 0

// Shadow clone implementation (simplified)
/mob/living/simple_animal/hostile/dragon_clone
	name = "void dragon shadow"
	desc = "A shadowy clone of the void dragon, almost translucent but still deadly."
	icon = 'icons/mob/96x96/ratwood_dragon.dmi'
	icon_state = "dragon"
	icon_living = "dragon"
	maxHealth = 75
	health = 75
	harm_intent_damage = 0
	obj_damage = 40
	melee_damage_lower = 10
	melee_damage_upper = 20
	attack_verb_continuous = "slashes"
	attack_verb_simple = "slash"
	attack_sound = 'sound/magic/demon_attack1.ogg'
	speak_emote = list("roars")
	alpha = 160
	ai_controller = /datum/ai_controller/big_rat
	var/lifetime = 30 SECONDS
	var/mob/living/simple_animal/hostile/retaliate/voiddragon/parent_dragon

/mob/living/simple_animal/hostile/dragon_clone/Initialize(mapload, parent)
	. = ..()
	parent_dragon = parent
	addtimer(CALLBACK(src, PROC_REF(clone_expire)), lifetime)

/mob/living/simple_animal/hostile/dragon_clone/proc/clone_expire()
	visible_message(span_notice("[src] dissipates into shadows!"))
	new /obj/effect/temp_visual/dragon_shadow(get_turf(src))
	qdel(src)

/obj/effect/temp_visual/drakewall
	desc = "An ash drakes true flame."
	name = "Fire Barrier"
	icon = 'icons/effects/fire.dmi'
	icon_state = "1"
	anchored = TRUE
	opacity = FALSE
	density = TRUE
	duration = 82
	color = COLOR_DARK_ORANGE

/obj/effect/temp_visual/drakewall/CanAtmosPass(direction)
	return !density


/obj/effect/temp_visual/dragon_swoop
	name = "certain death"
	desc = "Don't just stand there, move!"
	icon = 'icons/effects/96x96.dmi'
	icon_state = "void_blink_in"
	layer = BELOW_MOB_LAYER
	SET_BASE_PIXEL(-32, -32)
	color = "#FF0000"
	duration = 10

/obj/effect/temp_visual/dragon_flight
	icon = 'icons/mob/96x96/ratwood_dragon.dmi'
	icon_state = "dragon"
	layer = ABOVE_ALL_MOB_LAYER
	SET_BASE_PIXEL(-32, 10)
	randomdir = FALSE

/obj/effect/temp_visual/dragon_flight/Initialize(mapload, negative)
	. = ..()
	INVOKE_ASYNC(src, PROC_REF(flight), negative)

/obj/effect/temp_visual/dragon_flight/proc/flight(negative)
	if(negative)
		animate(src, pixel_x = -DRAKE_SWOOP_HEIGHT*0.1, pixel_z = DRAKE_SWOOP_HEIGHT*0.15, time = 3, easing = BOUNCE_EASING)
	else
		animate(src, pixel_x = DRAKE_SWOOP_HEIGHT*0.1, pixel_z = DRAKE_SWOOP_HEIGHT*0.15, time = 3, easing = BOUNCE_EASING)
	sleep(3)
	icon_state = "dragon_swoop"
	if(negative)
		animate(src, pixel_x = -DRAKE_SWOOP_HEIGHT, pixel_z = DRAKE_SWOOP_HEIGHT, time = 7)
	else
		animate(src, pixel_x = DRAKE_SWOOP_HEIGHT, pixel_z = DRAKE_SWOOP_HEIGHT, time = 7)

/obj/effect/temp_visual/dragon_flight/end
	pixel_x = DRAKE_SWOOP_HEIGHT
	pixel_z = DRAKE_SWOOP_HEIGHT
	duration = 10

/obj/effect/temp_visual/dragon_flight/end/flight(negative)
	if(negative)
		pixel_x = -DRAKE_SWOOP_HEIGHT
		animate(src, pixel_x = -32, pixel_z = 0, time = 5)
	else
		animate(src, pixel_x = -32, pixel_z = 0, time = 5)

#undef DRAKE_SWOOP_HEIGHT
#undef DRAKE_SWOOP_DIRECTION_CHANGE_RANGE
#undef SWOOP_DAMAGEABLE
#undef SWOOP_INVULNERABLE

/datum/status_effect/void_corruption
	id = "void_corruption"
	status_type = STATUS_EFFECT_UNIQUE
	duration = 30 SECONDS
	alert_type = /atom/movable/screen/alert/status_effect/void_corruption

	var/damage_tick = 2 SECONDS
	var/next_damage_time = 0
	var/damage_per_tick = 2
	var/spread_range = 2
	var/spread_chance = 20
	var/corruption_stage = 1
	var/max_stage = 3
	var/stage_threshold = 10 SECONDS
	var/next_stage_time = 0

/atom/movable/screen/alert/status_effect/void_corruption
	name = "Void Corruption"
	desc = "Void energy is eating away at your very being!"
	icon_state = "poison" // "void_corruption"  // ICON NEEDED

/datum/status_effect/void_corruption/on_creation(mob/living/new_owner, duration_override)
	next_stage_time = world.time + stage_threshold
	return ..()

/datum/status_effect/void_corruption/on_apply()
	. = ..()
	if(ishuman(owner))
		var/mob/living/carbon/human/H = owner
		H.add_overlay(mutable_appearance('icons/effects/effects.dmi', "void_corruption_overlay", -BODY_BEHIND_LAYER))
		to_chat(H, span_danger("I feel void energy seeping into my body, corrupting my flesh!"))
		H.playsound_local(get_turf(H), 'sound/effects/ghost.ogg', 50, TRUE)

	next_damage_time = world.time + damage_tick

/datum/status_effect/void_corruption/on_remove()
	. = ..()
	if(ishuman(owner))
		var/mob/living/carbon/human/H = owner
		H.cut_overlay(mutable_appearance('icons/effects/effects.dmi', "void_corruption_overlay"))
		to_chat(H, span_notice("The void corruption fades from my body."))

/datum/status_effect/void_corruption/tick()
	if(world.time >= next_damage_time)
		apply_damage()
		next_damage_time = world.time + damage_tick

	if(world.time >= next_stage_time && corruption_stage < max_stage)
		advance_corruption_stage()

	spread()

/datum/status_effect/void_corruption/proc/apply_damage()
	if(QDELETED(owner) || owner.stat == DEAD)
		qdel(src)
		return

	var/actual_damage = damage_per_tick * corruption_stage
	owner.apply_damage(actual_damage, BRUTE)

	new /obj/effect/temp_visual/void_corruption(get_turf(owner))

	if(prob(50))
		to_chat(owner, span_warning("The void corruption burns my flesh!"))

	if(corruption_stage >= 2 && prob(25))
		owner.adjust_confusion(4 SECONDS)

	if(corruption_stage >= 3 && prob(15))
		owner.Paralyze(0.5 SECONDS)
		to_chat(owner, span_danger("My muscles seize as void energy surges through me!"))

/datum/status_effect/void_corruption/proc/advance_corruption_stage()
	corruption_stage++
	next_stage_time = world.time + stage_threshold

	if(ishuman(owner))
		var/mob/living/carbon/human/H = owner
		H.cut_overlay(mutable_appearance('icons/effects/effects.dmi', "void_corruption_overlay"))
		H.add_overlay(mutable_appearance('icons/effects/effects.dmi', "void_corruption_overlay[corruption_stage]", -BODY_BEHIND_LAYER))
		to_chat(H, span_danger("My void corruption is spreading!"))
		H.playsound_local(get_turf(H), 'sound/effects/ghost2.ogg', 50, TRUE)

	damage_tick = initial(damage_tick) * (1 - (corruption_stage * 0.2))  // Damage occurs more frequently
	spread_chance = initial(spread_chance) + (corruption_stage * 10)     // More likely to spread

/datum/status_effect/void_corruption/proc/spread()
	if(corruption_stage < 2 || !prob(spread_chance))
		return

	for(var/mob/living/L in range(spread_range, owner))
		if(L == owner || L.stat == DEAD || L.has_status_effect(/datum/status_effect/void_corruption))
			continue
		if(istype(L, /mob/living/simple_animal/hostile/retaliate/voiddragon))
			continue

		if(prob(spread_chance - (get_dist(owner, L) * 10)))
			to_chat(L, span_userdanger("Void energy jumps from [owner] to you!"))
			to_chat(owner, span_warning("My corruption spreads to [L]!"))
			var/spread_duration = max(5 SECONDS, duration * 0.9)
			L.apply_status_effect(/datum/status_effect/void_corruption, spread_duration)
			new /obj/effect/temp_visual/void_corruption_spread(get_turf(L))
			break

/datum/status_effect/void_corruption/proc/purge_corruption()
	to_chat(owner, span_notice("The void corruption is purged from my system!"))
	qdel(src)

// Visual effects
/obj/effect/temp_visual/void_corruption
	icon = 'icons/effects/effects.dmi'
	icon_state = "void_energy"
	duration = 5
	randomdir = 1

/obj/effect/temp_visual/void_corruption_spread
	icon = 'icons/effects/effects.dmi'
	icon_state = "void_arc"
	duration = 5
	randomdir = 0
