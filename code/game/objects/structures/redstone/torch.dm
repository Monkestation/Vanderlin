
/obj/structure/redstone/torch
	name = "redstone torch"
	desc = "Burns with an inverted signal: lit when its mount is unpowered."
	icon_state = "torch_on"
	is_source = TRUE
	var/lit = TRUE
	// the turf it's mounted against. Defaults to a step in the
	// direction the torch faces.
	var/turf/attached_to

/obj/structure/redstone/torch/Initialize(mapload)
	. = ..()
	attached_to = get_step(src, dir)
	SSredstone.register_turf_watcher(attached_to, src)
	recompute_power()
	if(dir == NORTH)
		pixel_y = 32

/obj/structure/redstone/torch/Destroy()
	SSredstone.unregister_turf_watcher(attached_to, src)
	attached_to = null
	return ..()

/obj/structure/redstone/torch/get_output_toward(atom/asker)
	if(get_turf(asker) == attached_to)
		return 0
	return power

/obj/structure/redstone/torch/setDir(newdir)
	var/turf/old_attached = attached_to
	. = ..()
	var/turf/new_attached = get_step(src, dir)
	if(new_attached == old_attached)
		return
	SSredstone.unregister_turf_watcher(old_attached, src)
	attached_to = new_attached
	SSredstone.register_turf_watcher(attached_to, src)
	recompute_power()
	if(dir == NORTH) //I LOVE ICONS
		pixel_y = 32
	else
		pixel_y = 0

/obj/structure/redstone/torch/recompute_power()
	lit = !attached_to.get_turf_power(src)
	set_power(lit ? max_power : 0)
	update_appearance(UPDATE_ICON)

/obj/structure/redstone/torch/update_icon_state()
	. = ..()
	icon_state = lit ? "torch_on" : "torch_inverted"
