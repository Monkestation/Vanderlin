/obj/structure/redstone/repeater
	name = "redstone repeater"
	desc = "Repeats and delays a signal, one direction only. Right-click to change delay."
	icon_state = "repeater"
	var/delay_pips = 1 // 1-4, matches delay_1..delay_4 overlay art
	var/locked = FALSE
	var/pending_target = -1 // -1 = nothing queued

/obj/structure/redstone/repeater/recompute_power()
	var/turf/back = get_step(src, REVERSE_DIR(dir))
	var/input_power = back ? back.get_redstone_power_output(src) : 0

	var/side_locked = FALSE
	for(var/side_dir in list(turn(dir, 90), turn(dir, -90)))
		var/turf/side = get_step(src, side_dir)
		if(!side)
			continue
		for(var/obj/structure/redstone/repeater/R in side)
			if(R.dir == side_dir && R.power > 0)
				side_locked = TRUE
				break

	if(locked != side_locked)
		locked = side_locked
		update_appearance(UPDATE_ICON)

	if(locked)
		return

	var/target = input_power ? max_power : 0
	if(target == power || target == pending_target)
		return
	pending_target = target
	addtimer(CALLBACK(src, PROC_REF(apply_output), target), delay_pips * SSredstone.wait)

/obj/structure/redstone/repeater/proc/apply_output(target)
	pending_target = -1
	if(locked)
		return
	set_power(target)

/obj/structure/redstone/repeater/get_output_toward(atom/asker)
	var/turf/front = get_step(src, dir)
	if(get_turf(asker) == front)
		return power
	return 0

//we use overlays
/obj/structure/redstone/repeater/update_power_color()
	return

/obj/structure/redstone/repeater/update_overlays()
	. = ..()
	. += powered_overlay("delay_[delay_pips]")

/obj/structure/redstone/repeater/attack_hand_secondary(mob/user, list/modifiers)
	. = ..()
	if(.)
		return
	delay_pips = (delay_pips % 4) + 1 // cycles 1 -> 2 -> 3 -> 4 -> 1
	to_chat(user, span_notice("You set the repeater's delay to [delay_pips]."))
	update_appearance(UPDATE_ICON)
	recompute_power()
