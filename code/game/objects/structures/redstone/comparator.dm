/obj/structure/redstone/comparator
	name = "redstone comparator"
	desc = "Compares or subtracts signals. Click to toggle mode."
	icon_state = "comparator"
	var/subtract_mode = FALSE

/obj/structure/redstone/comparator/recompute_power()
	var/turf/back = get_step(src, REVERSE_DIR(dir))
	var/back_power = back ? back.get_redstone_power_output(src) : 0

	var/side_power = 0
	for(var/side_dir in list(turn(dir, 90), turn(dir, -90)))
		var/turf/side = get_step(src, side_dir)
		if(side)
			side_power = max(side_power, side.get_redstone_power_output(src))

	var/output = subtract_mode ? max(0, back_power - side_power) : ((back_power >= side_power) ? back_power : 0)
	set_power(output)

/obj/structure/redstone/comparator/get_output_toward(atom/asker)
	var/turf/front = get_step(src, dir)
	if(get_turf(asker) == front)
		return power
	return 0

/obj/structure/redstone/comparator/update_icon_state()
	. = ..()
	icon_state = subtract_mode ? "comparator_subtract" : "comparator"

//we use overlays
/obj/structure/redstone/comparator/update_power_color()
	return

/obj/structure/redstone/comparator/update_overlays()
	. = ..()
	. += powered_overlay("torch_rear")
	. += powered_overlay("torch_front")

/obj/structure/redstone/comparator/attack_hand(mob/user, list/modifiers)
	. = ..()
	if(.)
		return
	subtract_mode = !subtract_mode
	to_chat(user, span_notice("You switch the comparator to [subtract_mode ? "subtraction" : "comparison"] mode."))
	update_appearance(UPDATE_ICON)
	recompute_power()
