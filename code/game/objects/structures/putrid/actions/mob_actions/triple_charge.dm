/datum/action/cooldown/meatvine/personal/triple_charge
	name = "Triple Charge Attack"
	desc = "Charge three times in rapid succession at a location, overwhelming your prey."
	button_icon_state = "ravager_charge"
	cooldown_time = 30 SECONDS
	personal_resource_cost = 35
	/// Delay before the charge actually occurs
	var/charge_delay = 0.3 SECONDS
	/// The amount of turfs we move past the target
	var/charge_past = 3
	/// The maximum distance we can charge
	var/charge_distance = 7
	/// The sleep time before moving in deciseconds while charging
	var/charge_speed = 0.5
	/// The damage the charger does when bumping into something
	var/charge_damage = 25
	/// If we destroy objects while charging
	var/destroy_objects = FALSE
	/// If the current move is being triggered by us or not
	var/actively_moving = FALSE
	/// List of charging mobs
	var/list/charging = list()

/datum/action/cooldown/meatvine/personal/triple_charge/Activate(atom/target)
	. = ..()
	if(!.)
		return FALSE

	if(!target)
		return FALSE

	playsound(owner, 'sound/misc/meteorimpact.ogg', 100, TRUE, 8, 0.9)

	// Perform three charges in sequence
	for(var/i in 0 to 2)
		do_charge(owner, target, charge_delay - 2 * i, charge_past)

	return TRUE

/datum/action/cooldown/meatvine/personal/triple_charge/proc/do_charge(atom/movable/charger, atom/target_atom, delay, past)
	if(!target_atom || target_atom == owner)
		return
	var/chargeturf = get_turf(target_atom)
	if(!chargeturf)
		return
	var/dir = get_dir(charger, target_atom)
	var/turf/target = get_ranged_target_turf(chargeturf, dir, past)
	if(!target)
		return

	if(charger in charging)
		SSmove_manager.stop_looping(charger)

	charging += charger
	actively_moving = FALSE
	RegisterSignal(charger, COMSIG_MOVABLE_BUMP, PROC_REF(on_bump), TRUE)
	RegisterSignal(charger, COMSIG_MOVABLE_PRE_MOVE, PROC_REF(on_move), TRUE)
	RegisterSignal(charger, COMSIG_MOVABLE_MOVED, PROC_REF(on_moved), TRUE)
	charger.setDir(dir)

	sleep(delay)

	var/time_to_hit = min(get_dist(charger, target), charge_distance) * charge_speed

	var/datum/move_loop/new_loop = SSmove_manager.home_onto(charger, target, delay = charge_speed, timeout = time_to_hit, priority = MOVEMENT_ABOVE_SPACE_PRIORITY)
	if(!new_loop)
		return
	RegisterSignal(new_loop, COMSIG_MOVELOOP_PREPROCESS_CHECK, PROC_REF(pre_move))
	RegisterSignal(new_loop, COMSIG_MOVELOOP_POSTPROCESS, PROC_REF(post_move))
	RegisterSignal(new_loop, COMSIG_PARENT_QDELETING, PROC_REF(charge_end))

	sleep(time_to_hit + charge_speed)
	charger.setDir(dir)

	return TRUE

/datum/action/cooldown/meatvine/personal/triple_charge/proc/pre_move(datum)
	SIGNAL_HANDLER
	actively_moving = TRUE

/datum/action/cooldown/meatvine/personal/triple_charge/proc/post_move(datum)
	SIGNAL_HANDLER
	actively_moving = FALSE

/datum/action/cooldown/meatvine/personal/triple_charge/proc/charge_end(datum/move_loop/source)
	SIGNAL_HANDLER
	var/atom/movable/charger = source.moving
	UnregisterSignal(charger, list(COMSIG_MOVABLE_BUMP, COMSIG_MOVABLE_PRE_MOVE, COMSIG_MOVABLE_MOVED))
	actively_moving = FALSE
	charging -= charger

/datum/action/cooldown/meatvine/personal/triple_charge/proc/on_move(atom/source, atom/new_loc)
	SIGNAL_HANDLER
	if(!actively_moving)
		return COMPONENT_MOVABLE_BLOCK_PRE_MOVE
	new /obj/effect/temp_visual/decoy/fading(source.loc, source)

/datum/action/cooldown/meatvine/personal/triple_charge/proc/on_moved(atom/source)
	SIGNAL_HANDLER
	playsound(source, 'sound/misc/meteorimpact.ogg', 200, TRUE, 2, TRUE)

/datum/action/cooldown/meatvine/personal/triple_charge/proc/on_bump(atom/movable/source, atom/target)
	SIGNAL_HANDLER
	if(owner == target)
		return
	if(destroy_objects)
		if(isturf(target))
			target.ex_act(2)
		if(isobj(target) && target.density)
			target.ex_act(2)

	try_hit_target(source, target)

/datum/action/cooldown/meatvine/personal/triple_charge/proc/try_hit_target(atom/movable/source, atom/target)
	if(can_hit_target(source, target))
		hit_target(source, target, charge_damage)

/datum/action/cooldown/meatvine/personal/triple_charge/proc/can_hit_target(atom/movable/source, atom/target)
	if(!isliving(target))
		if(!target.density || target.CanPass(source, get_dir(target, source)))
			return FALSE
		return TRUE
	if(istype(target, /mob/living/simple_animal/hostile/retaliate/meatvine))
		return FALSE
	return TRUE

/datum/action/cooldown/meatvine/personal/triple_charge/proc/hit_target(atom/movable/source, atom/target, damage_dealt)
	if(!isliving(target))
		source.visible_message(span_danger("[source] smashes into [target]!"))
		return

	var/mob/living/living_target = target
	living_target.visible_message(span_danger("[source] charges into [living_target]!"), span_userdanger("[source] charges into you!"))
	living_target.Knockdown(0.6 SECONDS)
	living_target.apply_damage(damage_dealt, BRUTE)
	playsound(get_turf(living_target), 'sound/misc/meteorimpact.ogg', 100, TRUE)
	shake_camera(living_target, 4, 3)

/datum/action/cooldown/meatvine/personal/triple_charge/evaluate_ai_score(datum/ai_controller/controller)
	var/mob/living/simple_animal/hostile/retaliate/meatvine/consumed = owner
	var/atom/target = controller.blackboard[BB_BASIC_MOB_CURRENT_TARGET]

	if(!target)
		return 0

	var/distance = get_dist(consumed, target)

	// Prefer triple charge for distant or tough targets
	if(distance >= 4 && distance <= 7)
		if(isliving(target))
			var/mob/living/living_target = target
			if(living_target.health > 100) // Tougher target
				return 30
		return 20

	return 0

/datum/action/cooldown/meatvine/personal/triple_charge/ai_use_ability(datum/ai_controller/controller)
	var/atom/target = controller.blackboard[BB_BASIC_MOB_CURRENT_TARGET]

	if(!target)
		return FALSE

	return Activate(target)
