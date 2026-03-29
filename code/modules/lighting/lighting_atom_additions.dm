
/turf
	///Lumcount added by sources other than lighting datum objects, such as the overlay lighting component.
	var/dynamic_lumcount = 0

/atom
	var/light_power = 1 // Intensity of the light.
	///Range of the maximum brightness of light in tiles. Zero means no light.
	var/light_inner_range = 0
	///Range where light begins to taper into darkness in tiles.
	var/light_outer_range = 0
	///Adjusts curve for falloff gradient
	var/light_falloff_curve = LIGHTING_DEFAULT_FALLOFF_CURVE
	var/light_depth = 1 // how many zs we can go down through open spaces
	var/light_height = 1
	var/light_color     // Hexadecimal RGB string representing the colour of the light.
	///Boolean variable for toggleable lights. Has no effect without the proper light_system, light_range and light_power values.
	var/light_on = TRUE

	var/tmp/datum/light_source/light // Our light source. Don't fuck with this directly unless you have a good reason!
	var/tmp/list/light_sources       // Any light sources that are "inside" of us, for example, if src here was a mob that's carrying a flashlight, that flashlight's light source would be part of this list.

	var/light_system = STATIC_LIGHT
	///Bitflags to determine lighting-related atom properties.
	var/light_flags = NONE


/atom/movable
	///Lazylist to keep track on the sources of illumination.
	var/list/affected_dynamic_lights
	///Highest-intensity light affecting us, which determines our visibility.
	var/affecting_dynamic_lumi = 0

/atom/movable/Initialize(mapload, ...)
	. = ..()
	if((light_system == MOVABLE_LIGHT) && !istype(src, /atom/movable/outdoor_effect) && !istype(src, /atom/movable/lighting_object))
		AddComponent(/datum/component/overlay_lighting)
	if (has_initial_mana_pool && can_have_mana_pool())
		mana_pool = initialize_mana_pool()
		after_manapool_init()

///Keeps track of the sources of dynamic luminosity and updates our visibility with the highest.
/atom/movable/proc/update_dynamic_luminosity()
	var/highest = 0
	for(var/i in affected_dynamic_lights)
		if(affected_dynamic_lights[i] <= highest)
			continue
		highest = affected_dynamic_lights[i]
	if(highest == affecting_dynamic_lumi)
		return
	luminosity -= affecting_dynamic_lumi
	affecting_dynamic_lumi = highest
	luminosity += affecting_dynamic_lumi


///Helper to change several lighting overlay settings.
/atom/movable/proc/set_light_range_power_color(range, power, color)
	set_light_range(range)
	set_light_power(power)
	set_light_color(color)

/obj/effect/overlay/light_visible
	name = ""
	icon = 'icons/effects/light_overlays/light_32.dmi'
	icon_state = "light2"
	plane = O_LIGHTING_VISUAL_PLANE
	appearance_flags = RESET_COLOR | RESET_ALPHA | RESET_TRANSFORM
	mouse_opacity = MOUSE_OPACITY_TRANSPARENT
	alpha = 0
	vis_flags = NONE
	blocks_emissive = NONE
