/mob/living/proc/made_into_controller_mob()
	QDEL_NULL(ai_controller)

/datum/worker_mind
	var/mob/camera/strategy_controller/master
	var/mob/living/worker
	var/worker_name
	///10 is default so 20 is double etc
	var/work_speed = 10
	///our worker walk speed
	var/walkspeed = 5
	///100 is default
	var/maximum_stamina = 100
	var/current_stamina = 100

	var/datum/work_order/current_task
	var/turf/movement_target

	var/list/worker_gear = list(
		WORKER_SLOT_HEAD,
		WORKER_SLOT_PANTS,
		WORKER_SLOT_SHIRT,
		WORKER_SLOT_SHOES,
		WORKER_SLOT_HANDS,
	)
	var/list/gear_overlays = list()
	var/list/worker_moodlets

	var/datum/idle_tendancies/idle

	var/paused = FALSE

	var/atom/movable/screen/controller_ui/controller_ui/stats

	var/list/current_path = list()
	var/next_recalc = 0

	var/datum/persistant_workorder/assigned_work

	var/paused_until = 0
	var/atom/move_back_after
	var/work_pause = FALSE
	var/datum/work_order/paused_task

	var/datum/worker_attack_strategy/attack_mode

	var/list/turf/patrol_points = list()
	var/patrol_setup_active = FALSE
	var/list/image/patrol_visual_images = list()

/datum/worker_mind/New(mob/living/new_worker, mob/camera/strategy_controller/new_master)
	. = ..()
	idle = new /datum/idle_tendancies/basic
	master = new_master
	worker = new_worker

	worker.pass_flags |= PASSMOB
	worker.density = FALSE

	worker_name = pick( world.file2list("strings/rt/names/dwarf/dwarmm.txt") )
	worker.real_name = "[worker_name] the [worker.real_name]"
	worker.name = worker.real_name

	master.add_new_worker(worker)
	worker.made_into_controller_mob()
	stats = new /atom/movable/screen/controller_ui/controller_ui(null, null, worker, src)
	START_PROCESSING(SSstrategy_master, src)

/datum/worker_mind/Destroy(force)
	STOP_PROCESSING(SSstrategy_master, src)
	for(var/slot in worker_gear)
		var/obj/gear = worker_gear?[slot]
		if(gear)
			qdel(gear)
	worker_gear = null
	worker = null
	master = null
	patrol_points = null
	assigned_work = null
	movement_target = null
	move_back_after = null
	if(paused_task)
		QDEL_NULL(paused_task)
	if(current_task)
		QDEL_NULL(current_task)
	if(attack_mode)
		QDEL_NULL(attack_mode)
	QDEL_NULL(idle)
	QDEL_NULL(stats)
	QDEL_LIST(patrol_visual_images)
	return ..()

/datum/worker_mind/proc/get_slot_layer(slot)
	switch(slot)
		if(WORKER_SLOT_HEAD)
			return HEAD_LAYER
		if(WORKER_SLOT_PANTS)
			return PANTS_LAYER
		if(WORKER_SLOT_SHIRT)
			return SHIRT_LAYER
		if(WORKER_SLOT_SHOES)
			return SHOES_LAYER
		if(WORKER_SLOT_HANDS)
			return HANDS_LAYER
		else
			return HANDS_LAYER // Default fallback

/datum/worker_mind/proc/add_gear(obj/item/item, slot, datum/worker_gear/gear_type = /datum/worker_gear)
	if(!slot || !worker_gear.Find(slot))
		return FALSE

	var/datum/worker_gear/old_gear = worker_gear[slot]

	// Remove existing gear from slot if any
	if(worker_gear[slot])
		remove_gear_from_slot(slot)

	// Create worker gear datum
	var/datum/worker_gear/new_gear = new gear_type(item, slot, src)
	worker_gear[slot] = new_gear
	item.forceMove(worker)

	// Signal gear change
	SEND_SIGNAL(src, COMSIG_WORKER_GEAR_CHANGED, slot, old_gear, new_gear)

	// Create and add overlay
	update_gear_overlay(slot)
	return TRUE

/datum/worker_mind/proc/remove_gear_from_slot(slot)
	if(!worker_gear[slot])
		return FALSE

	var/datum/worker_gear/old_gear = worker_gear[slot]
	var/datum/worker_gear/gear = worker_gear[slot]
	worker_gear[slot] = null
	gear.item.forceMove(get_turf(worker))
	qdel(gear)

	// Signal gear removal
	SEND_SIGNAL(src, COMSIG_WORKER_GEAR_CHANGED, slot, old_gear, null)

	// Remove overlay
	remove_gear_overlay(slot)
	return TRUE

/datum/worker_mind/proc/remove_gear(obj/item/item)
	for(var/slot in worker_gear)
		var/datum/worker_gear/gear = worker_gear[slot]
		if(gear && gear.item == item)
			remove_gear_from_slot(slot)
			return TRUE
	return FALSE

/datum/worker_mind/proc/update_gear_overlay(slot)
	var/datum/worker_gear/gear = worker_gear[slot]
	if(!gear || !gear.item)
		return
	// Remove existing overlay for this slot
	remove_gear_overlay(slot)

	if(slot == WORKER_SLOT_HANDS && gear.item.experimental_inhand)
		var/used_prop
		var/list/prop

		if(gear.item.altgripped)
			used_prop = "altgrip"
			prop = gear.item.getonmobprop(used_prop)

		if(!prop && HAS_TRAIT(gear.item, TRAIT_WIELDED))
			used_prop = "wielded"
			prop = gear.item.getonmobprop(used_prop)

		if(!prop)
			used_prop = "gen"
			prop = gear.item.getonmobprop(used_prop)

		if(gear.item.force_reupdate_inhand)
			if(gear.item.onprop?[used_prop])
				prop = gear.item.onprop[used_prop]
			else
				LAZYSET(gear.item.onprop, used_prop, prop)

		if(!prop)
			return

		var/flipsprite = TRUE

		var/mutable_appearance/inhand_overlay = mutable_appearance(
			gear.item.getmoboverlay(used_prop, prop, mirrored=flipsprite),
			layer=get_slot_layer(slot)
		)
		var/mutable_appearance/behindhand_overlay = mutable_appearance(
			gear.item.getmoboverlay(used_prop, prop, behind=TRUE, mirrored=flipsprite),
			layer=get_slot_layer(slot) - 1 // Behind layer
		)

		inhand_overlay = center_image(inhand_overlay, gear.item.inhand_x_dimension, gear.item.inhand_y_dimension)
		behindhand_overlay = center_image(behindhand_overlay, gear.item.inhand_x_dimension, gear.item.inhand_y_dimension)

		gear_overlays[slot] = list(inhand_overlay, behindhand_overlay)
		worker.add_overlay(inhand_overlay)
		worker.add_overlay(behindhand_overlay)

		if(gear.item.blocks_emissive != EMISSIVE_BLOCK_NONE)
			var/mutable_appearance/emissive_front = emissive_blocker(
				gear.item.getmoboverlay(used_prop, prop, mirrored=flipsprite),
				layer=get_slot_layer(slot),
				appearance_flags = NONE
			)
			emissive_front.pixel_y = inhand_overlay.pixel_y
			emissive_front.pixel_x = inhand_overlay.pixel_x

			var/mutable_appearance/emissive_back = emissive_blocker(
				gear.item.getmoboverlay(used_prop, prop, behind=TRUE, mirrored=flipsprite),
				layer=get_slot_layer(slot) - 1,
				appearance_flags = NONE
			)
			emissive_back.pixel_y = behindhand_overlay.pixel_y
			emissive_back.pixel_x = behindhand_overlay.pixel_x

			worker.add_overlay(emissive_front)
			worker.add_overlay(emissive_back)


			gear_overlays[slot] += list(emissive_front, emissive_back)

		return

	var/layer = get_slot_layer(slot)
	var/mutable_appearance/gear_overlay = gear.item.build_worn_icon(
		age = "Adult",
		default_layer = layer,
		default_icon_file = get_icon_file(slot),
		isinhands = (slot == WORKER_SLOT_HANDS)
	)
	if(gear_overlay)
		gear_overlays[slot] = gear_overlay
		worker.add_overlay(gear_overlay)


/datum/worker_mind/proc/get_icon_file(slot)
	switch(slot)
		if(WORKER_SLOT_HEAD)
			return 'icons/roguetown/clothing/onmob/head.dmi'
		if(WORKER_SLOT_PANTS)
			return 'icons/roguetown/clothing/onmob/pants.dmi'
		if(WORKER_SLOT_SHIRT)
			return 'icons/roguetown/clothing/onmob/shirts.dmi'
		if(WORKER_SLOT_SHOES)
			return 'icons/roguetown/clothing/onmob/feet.dmi'
		if(WORKER_SLOT_HANDS)
			var/obj/item/item = get_item_in_slot(WORKER_SLOT_HANDS)
			return item.righthand_file

/datum/worker_mind/proc/remove_gear_overlay(slot)
	if(gear_overlays[slot])
		worker.cut_overlay(gear_overlays[slot])
		gear_overlays -= slot

/datum/worker_mind/proc/update_all_gear_overlays()
	// Clear all existing overlays
	for(var/slot in gear_overlays)
		worker.cut_overlay(gear_overlays[slot])
	gear_overlays.Cut()

	// Recreate all overlays
	for(var/slot in worker_gear)
		if(worker_gear[slot])
			update_gear_overlay(slot)

/datum/worker_mind/proc/get_gear_in_slot(slot)
	return worker_gear[slot]

/datum/worker_mind/proc/get_item_in_slot(slot)
	var/datum/worker_gear/gear = worker_gear[slot]
	return gear?.item

/datum/worker_mind/proc/has_gear_in_slot(slot)
	return worker_gear[slot] != null

/datum/worker_mind/proc/get_total_walkspeed_modifier()
	var/total_modifier = 0
	for(var/slot in worker_gear)
		var/datum/worker_gear/gear = worker_gear[slot]
		if(gear)
			total_modifier += gear.get_walkspeed_modifier()
	return total_modifier

/datum/worker_mind/proc/get_effective_walkspeed()
	return walkspeed + get_total_walkspeed_modifier()

/datum/worker_mind/proc/head_to_target()
	if(!movement_target)
		return

	if(next_recalc < world.time)
		enhanced_pathfinding()
		next_recalc = world.time + 2 SECONDS
	if(!length(current_path) && !worker.CanReach(movement_target))
		enhanced_pathfinding()
		if(!length(current_path))
			current_task.stop_work("no path")
	if(length(current_path) >= 3)
		walk_to(worker, current_path[3],0, get_effective_walkspeed())
		current_path -= current_path[3]
		current_path -= current_path[2]
		current_path -= current_path[1]
	else
		walk_to(worker, current_path[length(current_path)],0, get_effective_walkspeed())
		current_path = list()

/datum/worker_mind/proc/start_task()
	current_task.start_working(worker)

/datum/worker_mind/process()
	if(worker.stat >= DEAD)
		return
	check_worktree()
	update_stat_panel()

/datum/worker_mind/proc/start_idle()
	SEND_SIGNAL(src, COMSIG_WORKER_IDLE_START, idle)
	idle.perform_idle(master, worker)

/datum/worker_mind/proc/try_restore_stamina()
	if(!length(master.constructed_building_nodes))
		var/list/turfs = view(6, worker)
		shuffle_inplace(turfs)
		for(var/turf/open/open in turfs)
			set_current_task(/datum/work_order/nappy_time, open)
			break
	else
		for(var/obj/effect/building_node/node in master.constructed_building_nodes)
			if(!istype(node, /obj/effect/building_node/kitchen))
				continue
			set_current_task(/datum/work_order/go_try_eat, node)
			return

		var/list/turfs = view(6, worker)
		shuffle_inplace(turfs)
		for(var/turf/open/open in turfs)
			set_current_task(/datum/work_order/nappy_time, open)
			break

/datum/worker_mind/proc/set_current_task(datum/work_order/order, ...)
	var/list/arg_list = list(worker) + args
	var/old_task = current_task
	current_task = new order(arglist(arg_list))
	SEND_SIGNAL(src, COMSIG_WORKER_TASK_STARTED, current_task, old_task)
	update_stat_panel()

/datum/worker_mind/proc/finish_work(success, stamina_cost)
	var/old_stamina = current_stamina
	var/finished_task = current_task
	current_stamina = max(0, current_stamina - stamina_cost)

	SEND_SIGNAL(src, COMSIG_WORKER_TASK_FINISHED, finished_task, success, stamina_cost)
	SEND_SIGNAL(src, COMSIG_WORKER_STAMINA_CHANGED, old_stamina, current_stamina, "task completion")

	current_task = null
	movement_target = null
	set_paused_state(FALSE, "work finished")
	walk(worker, 0)

/datum/worker_mind/proc/stop_working()
	var/stopped_task = current_task
	current_task = null
	movement_target = null
	set_paused_state(FALSE, "work stopped")

	if(stopped_task)
		SEND_SIGNAL(src, COMSIG_WORKER_TASK_FAILED, stopped_task, "work stopped")

	walk(worker, 0)

/datum/worker_mind/proc/set_movement_target(atom/target)
	var/old_target = movement_target
	walk(worker, 0)
	movement_target = target
	SEND_SIGNAL(src, COMSIG_WORKER_MOVEMENT_SET, old_target, target)

/datum/worker_mind/proc/set_paused_state(new_state, reason = "unknown")
	if(paused != new_state)
		var/old_state = paused
		paused = new_state
		SEND_SIGNAL(src, COMSIG_WORKER_PAUSED_CHANGED, old_state, new_state, reason)

/datum/worker_mind/proc/add_test_instrument()
	var/obj/item/instrument/guitar/guitar = new(get_turf(worker))
	add_gear(guitar, WORKER_SLOT_HANDS, /datum/worker_gear/instrument)

/datum/worker_mind/proc/add_miner_gear()
	var/obj/item/weapon/pick/pick = new(get_turf(worker))
	add_gear(pick, WORKER_SLOT_HANDS, /datum/worker_gear/pickaxe)

	var/obj/item/clothing/head/armingcap/head = new(get_turf(worker))
	add_gear(head, WORKER_SLOT_HEAD, /datum/worker_gear/miner_cap)

	var/obj/item/clothing/armor/gambeson/light/striped/armor = new(get_turf(worker))
	add_gear(armor, WORKER_SLOT_SHIRT, /datum/worker_gear/miner_chest)

	var/obj/item/clothing/pants/trou/pants = new(get_turf(worker))
	add_gear(pants, WORKER_SLOT_PANTS, /datum/worker_gear/miner_pants)

	var/obj/item/clothing/shoes/boots/leather/shoes = new(get_turf(worker))
	add_gear(shoes, WORKER_SLOT_SHOES, /datum/worker_gear/miner_shoes)

/datum/worker_mind/proc/play_testing_song()
	if(current_task)
		current_task.stop_work("debug stop")

	var/datum/worker_gear/gear = get_gear_in_slot(WORKER_SLOT_HANDS)
	if(gear && istype(gear.item, /obj/item/instrument))
		var/list/turfs = view(6, worker)
		shuffle_inplace(turfs)
		for(var/turf/open/open in turfs)
			set_current_task(/datum/work_order/play_music, open, gear.item)
			break

/datum/worker_mind/proc/update_stat_panel()
	stats.update_text()

/datum/worker_mind/proc/check_paused_state()
	if(work_pause && (world.time > paused_until) && !current_task)
		set_movement_target(move_back_after)
		work_pause = FALSE
		current_task = paused_task
		paused_task = null
		return TRUE
	return FALSE

/datum/worker_mind/proc/check_worktree()
	if(paused)
		return

	if(attack_mode)
		if(attack_mode.current_target)
			if(!attack_mode.can_attack_target())
				walk_to(worker, attack_mode.current_target, 1, get_effective_walkspeed())
			return
		else if(attack_mode.find_targets())
			if(!attack_mode.can_attack_target())
				walk_to(worker, attack_mode.current_target, 1, get_effective_walkspeed())
				return

	if(check_paused_state())
		return

	if(movement_target && (!worker.CanReach(movement_target)))
		head_to_target()
		return
	if(current_task && world.time > paused_until)
		start_task()
		return
	if(current_stamina <= 0)
		try_restore_stamina()
		return
	if(assigned_work && !current_task && !paused_task)
		assigned_work.apply_to_worker(worker)
		return
	if(master.should_stop_idle(src))
		return
	start_idle()

/datum/worker_mind/proc/pause_task_for(duration = 60 SECONDS, atom/after_pause_target)
	move_back_after = after_pause_target
	work_pause = TRUE
	paused_task = current_task
	current_task = null
	paused_until = world.time + duration
	set_paused_state(TRUE, "task paused for [duration/10] seconds")

/datum/worker_mind/proc/stop_chase()
	walk(worker, 0)

/datum/worker_mind/proc/suppress_attack()
	var/old_target = attack_mode?.current_target
	attack_mode?.lose_target()
	stop_chase()
	SEND_SIGNAL(src, COMSIG_WORKER_ATTACK_END, old_target, "suppressed")

/datum/worker_mind/proc/apply_attack_strategy(datum/worker_attack_strategy/attack_path = /datum/worker_attack_strategy)
	var/datum/worker_attack_strategy/new_attack = new attack_path(worker)
	attack_mode = new_attack
	SEND_SIGNAL(src, COMSIG_WORKER_ATTACK_START, attack_mode.current_target)

/datum/worker_mind/proc/enhanced_pathfinding()
	if(!movement_target)
		return

	current_path = get_path_to(worker, get_turf(movement_target),
		TYPE_PROC_REF(/turf, Heuristic_cardinal_3d), 32 + 1, 250, 1)
	SEND_SIGNAL(src, COMSIG_AI_PATH_GENERATED, current_path)
