// rmd embeds this integration for the Forced bundled profile setting. To make the profile part of
// a Vanderlin checkout instead, copy it there and `#include` it from `vanderlin.dme`, the guard
// keeps BYOND compiling it to nothing.
//
// Vanderlin needs its globals and overlay subsystem stubbed before anything smooths, and its fluid
// pipes assemble an icon state from a connection list that normally fills in over two init passes.
#ifdef __DEMIR_BAKE__

/datum/controller/subsystem/overlays/demir_preview/New()
	SSoverlays = src
	stats = list()

/datum/controller/global_vars/demir_preview/New()
	GLOB = src
	if(!SSoverlays)
		SSoverlays = new /datum/controller/subsystem/overlays/demir_preview
	bitflag_lists = list()
	gvars_datum_init_order = list()
	InitGlobalcardinals()

/atom/proc/demir_prepare_smoothing()
	SETUP_SMOOTHING()

// MOVABLE_LIGHT uses a pre-baked mask in vis_contents. Emit the same mask as a tagged underlay so
// the editor can composite it after static lighting without starting components or signals.
/proc/demir_vanderlin_overlay_icon(pixel_bounds)
	switch(pixel_bounds)
		if(32)
			return 'icons/effects/light_overlays/light_32.dmi'
		if(64)
			return 'icons/effects/light_overlays/light_64.dmi'
		if(96)
			return 'icons/effects/light_overlays/light_96.dmi'
		if(128)
			return 'icons/effects/light_overlays/light_128.dmi'
		if(160)
			return 'icons/effects/light_overlays/light_160.dmi'
		if(192)
			return 'icons/effects/light_overlays/light_192.dmi'
		if(224)
			return 'icons/effects/light_overlays/light_224.dmi'
		if(256)
			return 'icons/effects/light_overlays/light_256.dmi'
		if(288)
			return 'icons/effects/light_overlays/light_288.dmi'
		if(320)
			return 'icons/effects/light_overlays/light_320.dmi'
		if(352)
			return 'icons/effects/light_overlays/light_352.dmi'
		if(384)
			return 'icons/effects/light_overlays/light_384.dmi'
		if(416)
			return 'icons/effects/light_overlays/light_416.dmi'
		if(448)
			return 'icons/effects/light_overlays/light_448.dmi'
		if(480)
			return 'icons/effects/light_overlays/light_480.dmi'
		if(512)
			return 'icons/effects/light_overlays/light_512.dmi'
		if(544)
			return 'icons/effects/light_overlays/light_544.dmi'
	return null

/atom/movable/proc/demir_add_overlay_light()
	if(light_system != MOVABLE_LIGHT || !light_on || !light_outer_range)
		return
	demir_add_light_mask(light_outer_range, light_color)

/atom/movable/proc/demir_add_light_mask(outer_range, mask_color)
	var/rounded_range = clamp(CEILING(outer_range, 0.5), 1, 9)
	var/pixel_bounds = ((rounded_range - 1) * 64) + 32
	var/image/mask = new
	mask.icon = demir_vanderlin_overlay_icon(pixel_bounds)
	mask.icon_state = "light2"
	mask.dir = dir
	mask.plane = O_LIGHTING_VISUAL_PLANE
	mask.appearance_flags = RESET_COLOR | RESET_ALPHA | RESET_TRANSFORM
	mask.alpha = 255
	mask.color = mask_color
	mask.pixel_x = -((pixel_bounds - 32) * 0.5)
	mask.pixel_y = mask.pixel_x
	mask.demir_overlay_light = 1
	underlays += mask

// A sconce sparks the torch it spawns in Initialize(), and the torch's light component hangs its
// mask on the sconce because the torch itself is not on a turf.
/obj/machinery/light/fueled/torchholder/demir_add_overlay_light()
	if(!ispath(torchy))
		return
	var/obj/item/flashlight/flare/torch/torch = torchy
	demir_add_light_mask(initial(torch.light_outer_range), initial(torch.light_color))

// Fixtures are STATIC_LIGHT, but their light vars stay at the type defaults until update() copies
// brightness, bulb_power and bulb_colour over them through set_light().
/obj/machinery/light/demir_prepare_light_state()
	light_on = on
	if(!on)
		return
	light_power = bulb_power
	light_color = color ? color : bulb_colour
	light_outer_range = brightness
	if(light_outer_range > 0 && light_outer_range < MINIMUM_USEFUL_LIGHT_RANGE)
		light_outer_range = MINIMUM_USEFUL_LIGHT_RANGE
	if(light_inner_range >= light_outer_range)
		light_inner_range = light_outer_range / 4
	light_falloff_curve = LIGHTING_DEFAULT_FALLOFF_CURVE

// `seton(TRUE)` from Initialize()
/obj/machinery/light/fueled/demir_prepare_light_state()
	on = status == LIGHT_OK
	..()

/obj/machinery/light/fueled/torchholder/demir_prepare_light_state()
	..()
	if(!torchy)
		on = FALSE
		light_on = FALSE

// `lights_on()` from Initialize()
/obj/machinery/light/fueledstreet/demir_prepare_light_state()
	on = TRUE
	..()

// Flashlights normally derive light_on from their mapped on/icon state during Initialize().
/obj/item/flashlight/demir_prepare_light_state()
	if(icon_state == "[initial(icon_state)]-on")
		on = TRUE
	light_on = on

/obj/item/flashlight/flare/torch/prelit/demir_prepare_light_state()
	on = TRUE
	light_on = TRUE

/obj/item/flashlight/flare/torch/metal/prelit/demir_prepare_light_state()
	on = TRUE
	light_on = TRUE

/obj/item/clothing/head/helmet/leather/shaman_hood/demir_prepare_light_state()
	light_on = on

// Fluid pipes keep an associative list of connected directions keyed by the
// direction number, and assemble their icon state from those keys in list
// order. Each pipe links its neighbors pairwise from Initialize(), and
// adjacent machines link back from setup_water(). Baking every pipe from its
// own point of view reaches the same result without a load order.
/obj/structure/water_pipe/demir_bake_appearance()
	for(var/key in connected)
		connected[key] = 0

	for(var/direction in GLOB.cardinals)
		var/turf/cardinal_turf = get_step(src, direction)
		if(!cardinal_turf)
			continue

		var/connects = (locate(/obj/structure/water_pipe) in cardinal_turf)
		if(!connects)
			for(var/obj/structure/structure in cardinal_turf)
				if(!structure.accepts_water_input)
					continue
				if(!structure.valid_water_connection(direction, src))
					continue
				connects = TRUE
				break

		if(connects)
			connected["[direction]"] = 1

	if(locate(/obj/structure/water_pipe) in demir_vertical_turf(1))
		connected["[UP]"] = 1
	if(locate(/obj/structure/water_pipe) in demir_vertical_turf(-1))
		connected["[DOWN]"] = 1

	update_appearance(UPDATE_OVERLAYS)

// `GET_TURF_ABOVE()` reads the mapping subsystem's z level links, which the
// editor never builds. Adjacent z levels stack instead, the way the viewer
// draws its underlays.
/obj/structure/water_pipe/proc/demir_vertical_turf(offset)
	var/turf/here = get_turf(src)
	if(!here)
		return null

	return locate(here.x, here.y, here.z + offset)

/datum/demir/vanderlin
	default = TRUE
	var/sun_color
	// Hour of the station day, 0 to 24, on the same scale as the `start` values on /datum/time_of_day.
	// 10 is the start of daytime, which matches the fixed noon tint this profile used before.
	var/tod_hours = 10
	var/tod_step_name = "Daytime"
	var/list/tod_steps
	// Highlight toggles. Ambush-prone turfs show red, tiles weather can reach show blue.
	var/show_ambushable = FALSE
	var/show_weatherable = FALSE
	// Lit turfs are harder to ambush. 0.75 means a fully lit turf keeps a quarter of its odds.
	var/ambush_light_reduction = 0.75
	// Brightness of the current sun tint from 0 to 1, for sky-visible turfs.
	var/sun_luminance = 1
	// Every placement that emits light, collected in prepare().
	var/list/light_sources

	New()
		..()
		if(!GLOB)
			GLOB = new /datum/controller/global_vars/demir_preview
		light_sources = list()
		// Same order as SSoutdoor_effects.time_cycle_steps, midnight last.
		tod_steps = list(
			/datum/time_of_day/dawn,
			/datum/time_of_day/sunrise,
			/datum/time_of_day/daytime,
			/datum/time_of_day/sunset,
			/datum/time_of_day/dusk,
			/datum/time_of_day/midnight,
		)
		apply_time_of_day()

// Mirrors SSoutdoor_effects. The current step is the last one whose start has passed, and midnight
// when none has. When a step begins, the game animates from the previous step's color to the new
// one over min(1 hour, time until the next step), so the sun color here blends the same way based
// on how far into the step the slider is. A step with a tint list uses its first entry, which keeps
// the view deterministic instead of shimmering between bakes.
/datum/demir/vanderlin/proc/apply_time_of_day()
	var/day = 24 HOURS
	var/ticks = (tod_hours HOURS)
	var/count = length(tod_steps)

	var/index = count
	for(var/i in 1 to count)
		var/datum/time_of_day/candidate = tod_steps[i]
		if(ticks >= initial(candidate.start))
			index = i

	var/datum/time_of_day/current = tod_steps[index]
	var/datum/time_of_day/following = tod_steps[index == count ? 1 : index + 1]
	var/datum/time_of_day/previous = tod_steps[index == 1 ? count : index - 1]
	tod_step_name = initial(current.name)

	var/current_start = initial(current.start)
	var/following_start = initial(following.start)
	if(following_start <= current_start)
		following_start += day

	var/elapsed = ticks - current_start
	if(elapsed < 0)
		elapsed += day

	var/duration = min(1 HOURS, following_start - current_start)
	var/amount = 1
	if(duration > 0)
		amount = clamp(elapsed / duration, 0, 1)

	sun_color = demir_blend_hex(demir_step_tint(previous), demir_step_tint(current), amount)
	sun_luminance = ((demir_hex_channel(sun_color, 0) * 0.299) + (demir_hex_channel(sun_color, 1) * 0.587) + (demir_hex_channel(sun_color, 2) * 0.114)) / 255

// Average of a "#rrggbb" light color's channels from 0 to 1. Lights without one count as white.
/proc/demir_light_color_factor(color)
	if(!istext(color) || length(color) != 7)
		return 1
	return (demir_hex_channel(color, 0) + demir_hex_channel(color, 1) + demir_hex_channel(color, 2)) / 765

/proc/demir_step_tint(step_path)
	var/datum/time_of_day/step = step_path
	var/tint = initial(step.color)
	if(islist(tint))
		var/list/tints = tint
		tint = length(tints) ? tints[1] : COLOR_WHITE
	return tint || COLOR_WHITE

// Channel 0, 1 or 2 of a "#rrggbb" string as 0 to 255.
/proc/demir_hex_channel(color, channel)
	var/value = 0
	for(var/offset in 0 to 1)
		var/code = text2ascii(color, 2 + (channel * 2) + offset)
		var/digit = code - 48
		if(code >= 97)
			digit = code - 87
		else if(code >= 65)
			digit = code - 55
		value = (value * 16) + digit
	return value

/proc/demir_blend_hex(from, next, amount)
	var/hexdigits = "0123456789abcdef"
	var/out = "#"
	for(var/channel in 0 to 2)
		var/a = demir_hex_channel(from, channel)
		var/b = demir_hex_channel(next, channel)
		var/v = clamp(round(a + ((b - a) * amount)), 0, 255)
		var/high = round(v / 16)
		var/low = v - (high * 16)
		out += copytext(hexdigits, high + 1, high + 2)
		out += copytext(hexdigits, low + 1, low + 2)
	return out

// Sunlight is the only thing that reads sun_color, so a slider move only has to redo lighting.
/datum/demir/vanderlin/proc/request_relight()
	var/kinds = DEMIR_BAKE_LIGHT
	if(show_ambushable)
		kinds |= DEMIR_BAKE_HIGHLIGHT // ambush odds read the sun brightness
	demir_rebake(kinds)

// Relative ambush odds of a placement from 0 to 1, for the red highlight. A turf can only spawn an
// ambush if it is open, its area has ambush_mobs or ambush_types, and it is an instance of one of
// the area's ambush_types. Light then lowers the odds, and a fully lit turf is never used, so it
// is not shaded at all. The region danger level is not used: SSregionthreat isn't built in the
// editor, and GLOB.ambush_chance_pct is the same for every turf.
/atom/proc/demir_ambush_odds()
	return 0

/turf/demir_ambush_odds()
	if(istype(src, /turf/closed))
		return 0
	var/area/here = get_area(src)
	if(!length(here.ambush_types) && !length(here?.ambush_mobs))
		return 0
	// Ambushes only spawn on an area's ambush_types (the woods' grass). No match, no spawn, and an
	// area with no ambush_types allows none.
	var/allowed = FALSE
	if(src.type in here.ambush_types)
		allowed = TRUE
	if(!allowed)
		return 0
	var/datum/demir/vanderlin/profile = demir_profile()
	var/lit = profile.turf_luminosity(src)
	if(lit >= 1)
		return 0
	return 1 - (profile.ambush_light_reduction * lit)

// Approximate turf brightness from 0 to 1. The editor solves the lightmap after highlights are
// collected, so the profile estimates it: the sun tint's brightness on sky-visible turfs, plus every
// light source in range with the game's own falloff (inner and outer range, falloff curve, power
// squared, and the average of the light's color channels, since a lumcount averages r, g and b).
// The sum is capped at 1. Walls don't block light here, so a lamp behind one still counts.
/datum/demir/vanderlin/proc/turf_luminosity(turf/here)
	var/lit = 0
	if(here.demir_sees_sky())
		lit = sun_luminance
	for(var/atom/source in light_sources)
		var/turf/at = get_turf(source)
		if(!at || at.z != here.z)
			continue
		var/dx = at.x - here.x
		var/dy = at.y - here.y
		var/outer = max(source.light_outer_range, MINIMUM_USEFUL_LIGHT_RANGE)
		if(abs(dx) >= outer || abs(dy) >= outer)
			continue
		var/dist = sqrt((dx * dx) + (dy * dy))
		if(dist >= outer)
			continue
		// Same falloff as LUM_FALLOFF and APPLY_CORNER in the light_source datum.
		var/falloff = clamp(-((dist - outer) / max(outer - source.light_inner_range, 1)), 0, 1) ** source.light_falloff_curve
		var/strength = (source.light_power ** 2) * (source.light_power < 0 ? -1 : 1)
		lit += falloff * strength * demir_light_color_factor(source.light_color)
	return clamp(lit, 0, 1)

// Weather reaches a turf when it is not weatherproof. can_weather() reads turf.outdoor_effect and
// is_weatherproof() walks the z stack through the mapping subsystem, neither of which the editor
// builds, so this reuses demir_sees_sky() above: pseudo roofs, the turf above, openspace with
// weatherproof structures, and finally the area's outdoors flag.
/atom/proc/demir_weatherable()
	return FALSE

/turf/demir_weatherable()
	return !!demir_sees_sky()

#define DEMIR_VANDERLIN_AMBUSH_COLOR "#ff3030"
#define DEMIR_VANDERLIN_WEATHER_COLOR "#3080ff"

/datum/demir/vanderlin/highlights(atom/target)
	var/list/regions = list()
	if(show_ambushable)
		var/odds = target.demir_ambush_odds()
		if(odds > 0)
			regions += list(list("x" = 0, "y" = 0, "width" = 1, "height" = 1, "color" = DEMIR_VANDERLIN_AMBUSH_COLOR, "fill" = 0.08 + (odds * 0.5), "outline" = 1, "when" = DEMIR_HIGHLIGHT_ALWAYS))
	if(show_weatherable && target.demir_weatherable())
		regions += list(list("x" = 0, "y" = 0, "width" = 1, "height" = 1, "color" = DEMIR_VANDERLIN_WEATHER_COLOR, "fill" = 0.25, "outline" = 1, "when" = DEMIR_HIGHLIGHT_ALWAYS))
	return regions

// The Vanderlin panel. Add a new section by writing a ui_<name>() proc and calling it below.
/datum/demir/vanderlin/ui(atom/target)
	imgui_set_next_window_size(300, 200)
	if(imgui_begin("Vanderlin"))
		ui_time_of_day()
		ui_highlights()
	// Dear ImGui style: end is called even when begin returns false (collapsed window).
	imgui_end()

/datum/demir/vanderlin/proc/ui_highlights()
	imgui_separator("Highlights (Performance Heavy)")
	var/new_ambushable = imgui_checkbox("Ambushable (red, darker = likelier, doesn't update in real time.)", show_ambushable)
	var/new_weatherable = imgui_checkbox("Weatherable (blue)", show_weatherable)
	if(new_ambushable != show_ambushable || new_weatherable != show_weatherable)
		show_ambushable = new_ambushable
		show_weatherable = new_weatherable
		demir_rebake(DEMIR_BAKE_HIGHLIGHT)

/datum/demir/vanderlin/proc/ui_time_of_day()
	imgui_separator("Time of day")
	var/new_hours = imgui_slider("Hour", tod_hours, 0, 24)
	var/whole = round(new_hours)
	var/minutes = round((new_hours - whole) * 60)
	var/pad = minutes < 10 ? "0" : ""
	imgui_text("[whole]:[pad][minutes]  [tod_step_name]")
	if(new_hours != tod_hours)
		tod_hours = new_hours
		apply_time_of_day()
		request_relight()

/atom/proc/demir_prepare_light_state()
	return

/datum/demir/vanderlin/prepare(atom/target)
	target.demir_prepare_smoothing()
	target.demir_prepare_light_state()
	if(target.light_on && target.light_outer_range && target.light_power)
		light_sources += target

/atom/proc/demir_bake_appearance()
	if(smoothing_flags & USES_SMOOTHING)
		smooth_icon()

/atom/proc/demir_finish_appearance()
	return

/atom/movable/demir_finish_appearance()
	demir_add_overlay_light()

// Water pipes bypass both generic smoothing and overlay lighting.
/obj/structure/water_pipe/demir_finish_appearance()
	return

/datum/demir/vanderlin/bake(atom/target)
	target.demir_bake_appearance()
	target.demir_finish_appearance()

// `is_sky_visible()` walks the z stack through the mapping subsystem's level links and a
// transparency trait, neither of which the editor builds. Adjacent z levels stack instead, the way
// the water pipes above already assume.
/turf/proc/demir_sees_sky()
	if(pseudo_roof)
		return FALSE
	var/turf/above = locate(x, y, z + 1)
	if(above)
		return above.demir_sky_passes()
	var/area/here = get_area(src)
	return here && here.outdoors

/turf/proc/demir_sky_passes()
	return FALSE

/turf/open/openspace/demir_sky_passes()
	for(var/obj/structure/thing in src)
		if(thing.weatherproof)
			return FALSE
	return demir_sees_sky()

/atom/proc/demir_apply_light()
	if(light_system != STATIC_LIGHT || !light_on || !light_outer_range || !light_power)
		return
	demir_light_range = max(light_outer_range, MINIMUM_USEFUL_LIGHT_RANGE)
	demir_light_inner_range = light_inner_range
	demir_light_curve = light_falloff_curve
	// APPLY_CORNER squares the power and puts the sign back afterwards.
	demir_light_power = (light_power ** 2) * (light_power < 0 ? -1 : 1)
	demir_light_color = light_color
	// LUM_FALLOFF measures flat distance, with no pseudo z term under the root.
	demir_light_height = 0

// Sunlight spreads GLOBAL_LIGHT_RANGE tiles from every turf that can see the sky, and HARD_SUN is
// the -0.5 under the root. Corners keep the closest source rather than the sum, so this is a peak
// source. A lit turf reaches its own corners at full strength, which is what makes the outdoors
// read as daylight without an explicit border pass.
/turf/demir_apply_light()
	if(!demir_sees_sky())
		return ..()
	demir_light_range = 3
	demir_light_power = 1
	demir_light_height = -0.5
	var/datum/demir/vanderlin/profile = demir_profile()
	demir_light_color = profile.sun_color
	demir_light_peak = 1

/area/demir_apply_light()
	demir_fullbright = !dynamic_lighting

/datum/demir/vanderlin/light(atom/target)
	target.demir_apply_light()

#endif
