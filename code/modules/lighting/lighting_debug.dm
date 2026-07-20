/obj/item/multitool/light_debug
	name = "lighting debug projector"
	icon = 'icons/roguetown/items/misc.dmi'
	icon_state = "multitool"
	var/operating = FALSE
	var/range_to_use = 8
	var/datum/proximity_monitor/advanced/debug_lights/current = null
	var/field_type = /datum/proximity_monitor/advanced/debug_lights

/obj/item/multitool/light_debug/Destroy()
	QDEL_NULL(current)
	return ..()

/obj/item/multitool/light_debug/proc/setup_debug_field()
	current = new field_type(src, range_to_use, FALSE)
	current.recalculate_field(full_recalc = TRUE)

/obj/item/multitool/light_debug/attack_self(mob/user, list/modifiers)
	operating = !operating
	to_chat(user, span_notice("You turn [src] [operating? "on":"off"]."))
	if(!istype(current) && operating)
		setup_debug_field()
	else if(!operating)
		QDEL_NULL(current)

/datum/proximity_monitor/advanced/debug_lights/proc/get_color_matrix(turf/target)
	return target.lighting_object?.color

/datum/proximity_monitor/advanced/debug_lights
	var/list/managed = list()

/datum/proximity_monitor/advanced/debug_lights/setup_field_turf(turf/target)
	. = ..()
	var/list/matrix = get_color_matrix(target)
	if(matrix == null)
		return
	var/list/_used = matrix.Copy()
	_used[20] = 100/255
	var/mutable_appearance/MA = mutable_appearance(
		LIGHTING_ICON,
		"lighting_transparent",
		plane = ABOVE_LIGHTING_PLANE,
		color = _used,
	)
	managed[REF(target)] = MA
	target.add_overlay(managed[REF(target)])

/datum/proximity_monitor/advanced/debug_lights/cleanup_field_turf(turf/target)
	. = ..()
	target.cut_overlay(managed[REF(target)])
	managed[REF(target)] = null

/obj/item/multitool/light_debug/sunlight
	name = "sunlight debug projector"
	field_type = /datum/proximity_monitor/advanced/debug_lights/sunlight

/datum/proximity_monitor/advanced/debug_lights/sunlight/get_color_matrix(turf/target)
	return target.outdoor_effect?.sunlight_overlay?.color
