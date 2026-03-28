/obj/structure/bridge
	name = "makeshift bridge"
	desc = "A makeshift bridge made of planks"
	icon = 'icons/obj/structures/bridge/bridge.dmi'
	icon_state = "planks_1"
	density = FALSE
	anchored = TRUE
	max_integrity = 100
	layer = ABOVE_OPEN_TURF_LAYER
	obj_flags = CAN_BE_HIT | BLOCK_Z_OUT_DOWN | BLOCK_Z_IN_UP

	/// Remember initial sprite
	var/base_icon

/obj/structure/bridge/Initialize(mapload)
	. = ..()
	AddElement(/datum/element/footstep_override, footstep = FOOTSTEP_OLDWOOD)
	var/static/list/loc_connections = list(COMSIG_ATOM_EXIT = PROC_REF(on_exit))
	AddElement(/datum/element/connect_loc, loc_connections)
	// Shift sprite down when going east/west so that people properly walk on the bridge
	if(dir == EAST || dir == WEST)
		pixel_y = base_pixel_y - 7
	// Choosing one of the sprite variants
	base_icon = "planks_1"
	icon_state = base_icon
	update_appearance(UPDATE_ICON)

/obj/structure/bridge/update_icon_state()
	if(obj_broken)
		icon_state = "planks_obj_broken"
	else
		icon_state = base_icon
	return ..()

/obj/structure/bridge/update_overlays()
	. = ..()

	// Mutable appearances do not support dir so we have to use one sprite for each dir
	// Images support dir but do not support "plane="

	// Ropes and planks sprites
	. += mutable_appearance(icon, "rope_underplanks_[dir]", layer=TURF_DECAL_LAYER)
	. += mutable_appearance(icon, "rope_underchar_[dir]", layer=BELOW_MOB_LAYER)

	// Because of the layering, we need to use a special sprite when there are bridge stakes on the next turf south
	if (dir == WEST || dir == EAST)
		. += mutable_appearance(icon, "rope_overchar_[dir]", plane = GAME_PLANE_UPPER, layer=ABOVE_MOB_LAYER)
	else
		var/turf/turf_south = get_step(src, SOUTH)
		var/end = locate(/obj/structure/bridge_stakes) in turf_south
		if(end)
			. += mutable_appearance(icon, "rope_overchar_special", plane = GAME_PLANE_UPPER, layer=ABOVE_MOB_LAYER)
		else
			. += mutable_appearance(icon, "rope_overchar_[dir]", plane = GAME_PLANE_UPPER, layer=ABOVE_MOB_LAYER)


/obj/structure/bridge/take_damage(damage_amount, damage_type = BRUTE, damage_flag = 0, sound_effect = TRUE, attack_dir)
	// Avoid taking damage when integrity is already at 0
	if(obj_broken)
		return
	. = ..()

/obj/structure/bridge/CanAllowThrough(atom/movable/O, turf/target)
	. = ..()
	var/direction = get_dir(loc, target)
	if(direction != dir && direction != REVERSE_DIR(dir))
		return FALSE

/obj/structure/bridge/proc/on_exit(datum/source, atom/movable/leaving, atom/new_location)
	SIGNAL_HANDLER
	if(istype(leaving, /mob/camera))
		return
	var/direction = get_dir(loc, new_location)
	if(direction != dir && direction != REVERSE_DIR(dir))
		leaving.Bump(src)
		return COMPONENT_ATOM_BLOCK_EXIT

/obj/structure/bridge/CanAStarPass(ID, to_dir, requester)
	if(to_dir != dir && to_dir != REVERSE_DIR(dir))
		return FALSE
	return TRUE

/// Repairing a damaged bridge section back to full health
/obj/structure/bridge/proc/repair_bridge()
	if(obj_broken)
		obj_broken = FALSE  // Not obj_broken anymore
		obj_flags = initial(obj_flags)  // so we set back initial flags
		update_appearance(UPDATE_ICON_STATE)

/// Stakes at the end of a makeshift bridge
/obj/structure/bridge_stakes
	name = "makeshift bridge stakes"
	desc = "Two crude wooden poles that have been hammered down into the ground."
	icon = 'icons/obj/structures/bridge/bridge_stakes.dmi'
	icon_state = "stake_default"
	density = FALSE
	anchored = TRUE
	max_integrity = 100
	layer = ABOVE_OPEN_TURF_LAYER
	plane = GAME_PLANE
	resistance_flags = INDESTRUCTIBLE | LAVA_PROOF | FIRE_PROOF | UNACIDABLE | ACID_PROOF

/obj/structure/bridge_stakes/Initialize(mapload)
	. = ..()
	// The default sprite is just for mappers
	// Stakes will be displayed with overlays to handle the layering
	icon_state = ""
	if(dir == EAST || dir == WEST)
		pixel_y = base_pixel_y - 7
	update_appearance(UPDATE_ICON)

/obj/structure/bridge_stakes/update_overlays()
	. = ..()

	// Mutable appearances do not support dir so we have to use one sprite for each dir
	// Images support dir but do not support "plane="

	// Ropes and planks sprites (end of bridge)
	. += mutable_appearance('icons/obj/structures/bridge/bridge.dmi', "rope_underplanks_end_[dir]", layer=TURF_DECAL_LAYER)
	. += mutable_appearance('icons/obj/structures/bridge/bridge.dmi', "rope_underchar_end_[dir]", layer=BELOW_MOB_LAYER)
	. += mutable_appearance('icons/obj/structures/bridge/bridge.dmi', "rope_overchar_end_[dir]", plane = GAME_PLANE_UPPER, layer=ABOVE_MOB_LAYER)

	// Stakes sprites
	. += mutable_appearance(icon, "stake_subjective_[dir]", layer=BELOW_MOB_LAYER)
	. += mutable_appearance(icon, "stake_underchar_[dir]", layer=BELOW_MOB_LAYER)
	. += mutable_appearance(icon, "stake_overchar_[dir]", plane = GAME_PLANE_UPPER, layer=ABOVE_MOB_LAYER)
