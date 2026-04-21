#define POINT_TIME (2.5 SECONDS)

/**
 * Point at an atom
 *
 * mob verbs are faster than object verbs. See
 * [this byond forum post](https://secure.byond.com/forum/?post=1326139&page=2#comment8198716)
 * for why this isn't atom/verb/pointed()
 *
 * note: ghosts can point, this is intended
 *
 * visible_message will handle invisibility properly
 *
 * overridden here and in /mob/dead/observer for different point span classes and sanity checks
 */
/mob/verb/pointed(atom/pointed_atom as mob|obj|turf in view())
	set name = "Point To"
	set category = "IC"

	if(istype(pointed_atom, /obj/effect/temp_visual/point))
		return FALSE

	DEFAULT_QUEUE_OR_CALL_VERB(VERB_CALLBACK(src, PROC_REF(linepoint), pointed_atom))

/mob/proc/linepoint(atom/pointed_atom as mob|obj|turf in view())
	if(world.time < lastpoint + POINT_TIME)
		return FALSE

	if(stat)
		return FALSE

	if(client)
		if(!src || !isturf(src.loc) || !(pointed_atom in view(client.view, src)))
			return FALSE

	if (pointed_atom in src)
		create_point_bubble(pointed_atom)
		return FALSE

	var/turf/tile = get_turf(pointed_atom)
	if (!tile)
		return FALSE

	var/turf/our_tile = get_turf(src)
	var/obj/visual = new /obj/effect/temp_visual/point/still(our_tile, invisibility)
	SEND_SIGNAL(src, COMSIG_MOB_POINTED, pointed_atom)
	animate(visual, pixel_x = (tile.x - our_tile.x) * world.icon_size + pointed_atom.pixel_x, pixel_y = (tile.y - our_tile.y) * world.icon_size + pointed_atom.pixel_y, time = 2, easing = EASE_OUT)

	lastpoint = world.time
	var/obj/item/held_item = get_active_held_item()
	if(held_item)
		visible_message(span_info("[src] points [held_item] at [pointed_atom]."), span_info("I point [held_item] at [pointed_atom]."))
	else
		visible_message(span_info("[src] points at [pointed_atom]."), span_info("I point at [pointed_atom]."))

	return TRUE

/atom/movable/proc/create_point_bubble(atom/pointed_atom)
	var/mutable_appearance/thought_bubble = mutable_appearance(
		'icons/effects/effects.dmi',
		"thought_bubble",
		plane = POINT_PLANE,
		appearance_flags = KEEP_APART,
	)

	var/mutable_appearance/pointed_atom_appearance = new(pointed_atom.appearance)
	pointed_atom_appearance.blend_mode = BLEND_INSET_OVERLAY
	pointed_atom_appearance.plane = FLOAT_PLANE
	pointed_atom_appearance.layer = FLOAT_LAYER
	pointed_atom_appearance.pixel_x = 0
	pointed_atom_appearance.pixel_y = 0
	thought_bubble.overlays += pointed_atom_appearance
	// pointed_atom_appearance.remove_filter(HOVER_OUTLINE_FILTER)

	thought_bubble.pixel_w = 16
	thought_bubble.pixel_z = 32
	thought_bubble.alpha = 200

	var/mutable_appearance/point_visual = mutable_appearance(
		'icons/hud/screen_gen.dmi',
		"arrow"
	)

	thought_bubble.overlays += point_visual

	add_overlay(thought_bubble)
	addtimer(CALLBACK(src, PROC_REF(clear_point_bubble), thought_bubble), POINT_TIME)

/atom/movable/proc/clear_point_bubble(mutable_appearance/thought_bubble)
	cut_overlay(thought_bubble)

/obj/effect/temp_visual/point
	name = "pointer"
	icon = 'icons/mob/screen_gen.dmi'
	icon_state = "arrow"
	plane = POINT_PLANE
	duration = 3 SECONDS
	fade_time = 1 SECONDS

/obj/effect/temp_visual/point/still
	icon_state = "arrow_still"

/obj/effect/temp_visual/point/Initialize(mapload, set_invis = 0)
	. = ..()
	var/atom/old_loc = loc
	loc = get_turf(src) // We don't want to actualy trigger anything when it moves
	pixel_x = old_loc.pixel_x
	pixel_y = old_loc.pixel_y
	invisibility = set_invis

// need to update cone on overlays change
/mob/living/create_point_bubble(atom/pointed_atom)
	. = ..()
	update_cone()

/mob/living/clear_point_bubble(mutable_appearance/thought_bubble)
	. = ..()
	update_cone()

#undef POINT_TIME
