
#define RENDER_TARGET_RESOURCE_MASK "resource_mask"
#define PUTRID_ELEMENTS (	list(\
									/atom/movable/screen/putrid/cover,\
									/atom/movable/screen/putrid/background,\
									/atom/movable/screen/putrid/bar/resource_bar,\
									))

#define PERSONAL_PUTRID_ELEMENTS (list(\
	/atom/movable/screen/putrid/personal/cover,\
	/atom/movable/screen/putrid/personal/background,\
	/atom/movable/screen/putrid/personal/bar/personal_resource_bar,\
	/atom/movable/screen/putrid/personal/bar/evolution,\
))

/atom/movable/screen/putrid
	plane = ABOVE_HUD_PLANE

/atom/movable/screen/putrid/Click(location, control, params)
	. = ..()
	var/mob/living/simple_animal/hostile/retaliate/meatvine/consumed = usr
	if(!istype(consumed))
		return
	info_blurb(consumed)

/atom/movable/screen/putrid/proc/info_blurb(mob/living/simple_animal/hostile/retaliate/meatvine/consumed)

/atom/movable/screen/putrid/cover
	icon = 'icons/mob/putrid_hud/21x242.dmi'
	icon_state = "coverLEFT"
	screen_loc = "WEST,CENTER-2"
	plane = ABOVE_HUD_PLANE + 1
	layer = BACKHUD_LAYER + 0.1

/atom/movable/screen/putrid/background
	icon = 'icons/mob/putrid_hud/21x242.dmi'
	icon_state = "backgroundLEFT"
	screen_loc = "WEST,CENTER-2"
	plane = HUD_PLANE
	layer = BACKHUD_LAYER - 0.3

/atom/movable/screen/putrid/bar
	icon = 'icons/mob/putrid_hud/18x200.dmi'
	layer = BACKHUD_LAYER - 0.1
	var/current_alpha_mask_filter_offset = 0

/atom/movable/screen/putrid/bar/info_blurb(mob/living/simple_animal/hostile/retaliate/meatvine/consumed)
	if(!consumed.master)
		return
	to_chat(consumed, span_info("Current resources - [consumed.master.consumed_resource_pool]"))
	to_chat(consumed, span_info("Maximum resources - [consumed.master.consumed_resource_max]"))

/atom/movable/screen/putrid/bar/Initialize(mapload, datum/hud/hud_owner)
	. = ..()
	add_filter("alpha_mask_filter", 10, alpha_mask_filter(icon = icon('icons/mob/putrid_hud/18x200.dmi', icon_state = "mask"), y = current_alpha_mask_filter_offset, flags = MASK_INVERSE))

/atom/movable/screen/putrid/bar/proc/on_resource_change(datum/source, current_resources)
	SIGNAL_HANDLER
	var/mob/living/simple_animal/hostile/retaliate/meatvine/consumed = hud?.mymob
	if(!istype(consumed))
		return
	if(!consumed?.master)
		return

	var/percentage = (current_resources / consumed.master.consumed_resource_max) * 100
	set_alpha_offset(200 / 100 * percentage)

/atom/movable/screen/putrid/bar/proc/set_alpha_offset(amount)
	animate(get_filter("alpha_mask_filter"), time = 0.5 SECONDS, y = amount, easing = CIRCULAR_EASING)

/atom/movable/screen/putrid/bar/proc/setup_mob()
	var/mob/living/simple_animal/hostile/retaliate/meatvine/consumed = hud?.mymob
	if(!istype(consumed))
		return
	RegisterSignal(consumed?.master, COMSIG_MEATVINE_RESOURCE_CHANGE, PROC_REF(on_resource_change))

	if(consumed?.master)
		var/percentage = (consumed.master.consumed_resource_pool / consumed.master.consumed_resource_max) * 100
		current_alpha_mask_filter_offset = 200 / 100 * percentage
		set_alpha_offset(current_alpha_mask_filter_offset)

/atom/movable/screen/putrid/bar/Destroy()
	. = ..()
	if(hud?.mymob)
		UnregisterSignal(hud.mymob, COMSIG_MEATVINE_RESOURCE_CHANGE)

/atom/movable/screen/putrid/bar/resource_bar
	name = "Meatvine Resources"
	icon_state = "points"
	color = "#800000"
	screen_loc = "WEST,CENTER-2:+22"


/atom/movable/screen/putrid/personal
	plane = ABOVE_HUD_PLANE

/atom/movable/screen/putrid/personal/cover
	icon = 'icons/mob/putrid_hud/21x242.dmi'
	icon_state = "coverRIGHT"
	screen_loc = "EAST:+11,CENTER-2"
	plane = ABOVE_HUD_PLANE + 1
	layer = BACKHUD_LAYER + 0.1

/atom/movable/screen/putrid/personal/background
	icon = 'icons/mob/putrid_hud/21x242.dmi'
	icon_state = "backgroundRIGHT"
	screen_loc = "EAST:+11,CENTER-2"
	plane = HUD_PLANE
	layer = BACKHUD_LAYER - 0.3

/atom/movable/screen/putrid/personal/bar
	icon = 'icons/mob/putrid_hud/18x200.dmi'
	layer = BACKHUD_LAYER - 0.2
	var/current_alpha_mask_filter_offset = 0
	var/signal = COMSIG_MEATVINE_PERSONAL_RESOURCE_CHANGE
	var/mask_state = "mask"

/atom/movable/screen/putrid/personal/bar/info_blurb(mob/living/simple_animal/hostile/retaliate/meatvine/consumed)
	to_chat(consumed, span_info("Personal resources - [consumed.personal_resource_pool]"))
	to_chat(consumed, span_info("Maximum personal resources - [consumed.personal_resource_max]"))

/atom/movable/screen/putrid/personal/bar/Initialize(mapload, datum/hud/hud_owner)
	. = ..()
	add_filter("alpha_mask_filter", 10, alpha_mask_filter(icon = icon('icons/mob/putrid_hud/18x200.dmi', icon_state = mask_state), y = current_alpha_mask_filter_offset, flags = MASK_INVERSE))

/atom/movable/screen/putrid/personal/bar/proc/on_resource_change(datum/source, current_resources)
	SIGNAL_HANDLER
	var/mob/living/simple_animal/hostile/retaliate/meatvine/consumed = hud?.mymob
	if(!istype(consumed))
		return
	if(!consumed)
		return

	var/percentage = (current_resources / consumed.personal_resource_max) * 100
	set_alpha_offset(200 / 100 * percentage)

/atom/movable/screen/putrid/personal/bar/proc/set_alpha_offset(amount)
	animate(get_filter("alpha_mask_filter"), time = 0.5 SECONDS, y = amount, easing = CIRCULAR_EASING)

/atom/movable/screen/putrid/personal/bar/proc/setup_mob()
	var/mob/living/simple_animal/hostile/retaliate/meatvine/consumed = hud?.mymob
	if(!istype(consumed))
		return
	RegisterSignal(consumed, signal, PROC_REF(on_resource_change))

	if(consumed)
		var/percentage = (consumed.personal_resource_pool / consumed.personal_resource_max) * 100
		current_alpha_mask_filter_offset = 200 / 100 * percentage
		set_alpha_offset(current_alpha_mask_filter_offset)

/atom/movable/screen/putrid/personal/bar/Destroy()
	. = ..()
	if(hud?.mymob)
		UnregisterSignal(hud.mymob, signal)

/atom/movable/screen/putrid/personal/bar/personal_resource_bar
	name = "Personal Resources"
	icon_state = "points"
	color = "#33ff66"
	screen_loc = "EAST:+16,CENTER-2:+22"

/atom/movable/screen/putrid/personal/bar/evolution
	name = ""
	icon_state = "goal"
	color = null
	screen_loc = "EAST:+16,CENTER-2:+22"
	signal = COMSIG_MEATVINE_PERSONAL_EVOLUTION_CHANGE
	mask_state = "mask_goal"
	layer = BACKHUD_LAYER - 0.1

/atom/movable/screen/putrid/personal/bar/evolution/info_blurb(mob/living/simple_animal/hostile/retaliate/meatvine/consumed)
	return

/atom/movable/screen/putrid/personal/bar/evolution/on_resource_change(datum/source, current_resources)
	var/mob/living/simple_animal/hostile/retaliate/meatvine/consumed = hud?.mymob
	if(!consumed)
		return

	var/percentage = (current_resources / consumed.evolution_max) * 100
	set_alpha_offset(200 / 100 * percentage)

/datum/hud/putrid/New(mob/owner)
	..()
	var/atom/movable/screen/using

	scannies = new /atom/movable/screen/scannies
	scannies.set_new_hud(src)
	static_inventory += scannies
	if(owner.client?.prefs?.crt == TRUE)
		scannies.alpha = 70

	for(var/element as anything in PUTRID_ELEMENTS)
		using = new element()
		using.set_new_hud(src)
		static_inventory += using

	for(var/element as anything in PERSONAL_PUTRID_ELEMENTS)
		using = new element()
		using.set_new_hud(src)
		static_inventory += using

	setup_mob()


/datum/hud/putrid/show_hud(version, mob/viewmob)
	. = ..()

	var/index = -1
	for(var/datum/action/cooldown/meatvine/action in mymob?.actions)
		// Skip personal abilities
		if(istype(action, /datum/action/cooldown/meatvine/personal))
			continue

		var/atom/movable/screen/movable/action_button/button = action.viewers[src]
		var/action_spot = "WEST+1:-13,CENTER[index >= 0 ? "+" : ""][index]:[((index + 2) * 2) - 2]"
		position_action(button, action_spot)
		action.default_button_position = action_spot
		index++

	index = -1
	for(var/datum/action/cooldown/meatvine/personal/action in mymob?.actions)
		var/atom/movable/screen/movable/action_button/button = action.viewers[src]
		var/action_spot = "EAST-1:+13,CENTER[index >= 0 ? "+" : ""][index]:[((index + 2) * 2) - 2]"
		position_action(button, action_spot)
		action.default_button_position = action_spot
		index++


/datum/hud/putrid/plane_masters_update()
	. = ..()
	for(var/item in plane_masters)
		var/atom/movable/screen/plane_master/weather_effect/sun = plane_masters[item]
		if(!istype(sun))
			continue
		sun?.screen_loc = "CENTER,CENTER"


/datum/hud/putrid/proc/setup_mob()
	var/atom/movable/screen/putrid/bar/resource_bar/bar = locate(/atom/movable/screen/putrid/bar/resource_bar) in static_inventory
	bar?.setup_mob()

	var/atom/movable/screen/putrid/personal/bar/personal_resource_bar/personal_bar = locate(/atom/movable/screen/putrid/personal/bar/personal_resource_bar) in static_inventory
	personal_bar?.setup_mob()

	var/atom/movable/screen/putrid/personal/bar/evolution/evolution = locate(/atom/movable/screen/putrid/personal/bar/evolution) in static_inventory
	evolution?.setup_mob()

#undef RENDER_TARGET_RESOURCE_MASK
#undef PUTRID_ELEMENTS
#undef PERSONAL_PUTRID_ELEMENTS
