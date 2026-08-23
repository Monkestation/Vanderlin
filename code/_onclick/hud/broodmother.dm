#define BROODMOTHER_HUD_ELEMENTS (	list(\
									/atom/movable/screen/broodmother/cover,\
									/atom/movable/screen/broodmother/background,\
									)\
									+\
									subtypesof(/atom/movable/screen/broodmother/bar)\
									+\
									subtypesof(/atom/movable/screen/broodmother/button)\
									)

/atom/movable/screen/broodmother
	plane = ABOVE_HUD_PLANE

/atom/movable/screen/broodmother/Click(location, control, params)
	. = ..()
	var/mob/living/simple_animal/hostile/retaliate/troll/broodmother/broodmother = usr
	info_blurb(broodmother)

/atom/movable/screen/broodmother/proc/info_blurb(mob/living/simple_animal/hostile/retaliate/troll/broodmother/broodmother)

/atom/movable/screen/broodmother/cover
	icon = 'icons/mob/putrid_hud/21x242.dmi'
	icon_state = "coverLEFT"
	screen_loc = "WEST,CENTER-2"
	plane = ABOVE_HUD_PLANE + 1
	layer = BACKHUD_LAYER + 0.1

/atom/movable/screen/broodmother/background
	icon = 'icons/mob/putrid_hud/21x242.dmi'
	icon_state = "backgroundLEFT"
	screen_loc = "WEST,CENTER-2"
	plane = HUD_PLANE
	layer = BACKHUD_LAYER - 0.3

/atom/movable/screen/broodmother/bar
	icon = 'icons/mob/putrid_hud/18x200.dmi'
	layer = BACKHUD_LAYER - 0.1
	var/current_alpha_mask_filter_offset = 0
	var/tier
	var/mask_state = "mask"

/atom/movable/screen/broodmother/bar/info_blurb(mob/living/simple_animal/hostile/retaliate/troll/broodmother/broodmother)
	to_chat(broodmother, span_info("Current biomass amount - [broodmother.vars["tier_[tier]_biomass_amount"]]"))
	to_chat(broodmother, span_info("Amount needed for laying egg - [broodmother.vars["tier_[tier]_biomass_cost"]]"))

/atom/movable/screen/broodmother/bar/Initialize(mapload, datum/hud/hud_owner)
	. = ..()
	add_filter("alpha_mask_filter", 10, alpha_mask_filter(icon = icon('icons/mob/putrid_hud/18x200.dmi', icon_state = mask_state), y = current_alpha_mask_filter_offset, flags = MASK_INVERSE))

/atom/movable/screen/broodmother/bar/proc/on_biomass_change(mob/living/simple_animal/hostile/retaliate/troll/broodmother/source, current_biomass, _tier)
	SIGNAL_HANDLER
	if(tier != _tier)
		return

	set_alpha_offset(200 / 100 * current_biomass)
	for(var/atom/movable/screen/broodmother/button/button in source?.hud_used.static_inventory)
		if(button.tier != tier)
			continue
		if(!source.egg_laying_checks(tier))
			button.color = "#610000"
			continue
		button.color = null

/atom/movable/screen/broodmother/bar/proc/adjust_alpha_offset(amount)
	current_alpha_mask_filter_offset = clamp(current_alpha_mask_filter_offset + amount, 0, 200)
	set_alpha_offset(current_alpha_mask_filter_offset)

/atom/movable/screen/broodmother/bar/proc/update_mask_offset()
	set_alpha_offset(current_alpha_mask_filter_offset)

/atom/movable/screen/broodmother/bar/proc/set_alpha_offset(amount)
	animate(get_filter("alpha_mask_filter"), time = 0.5 SECONDS, y = amount, easing = CIRCULAR_EASING)

/atom/movable/screen/broodmother/bar/set_new_hud(datum/hud/hud_owner)
	. = ..()
	if(isnull(tier))
		stack_trace("tier was null")

	RegisterSignal(hud.mymob, COMSIG_BROODMOTHER_BIOMASS_CHANGE, PROC_REF(on_biomass_change))

	var/mob/living/simple_animal/hostile/retaliate/troll/broodmother/mother = hud.mymob
	current_alpha_mask_filter_offset = 200/100 * mother.vars["tier_[tier]_biomass_amount"]
	update_mask_offset()

/atom/movable/screen/broodmother/bar/Destroy()
	. = ..()
	UnregisterSignal(hud.mymob, COMSIG_BROODMOTHER_BIOMASS_CHANGE)

/atom/movable/screen/broodmother/button
	icon = 'icons/hud/broodmother_abilities.dmi'
	no_over_text = FALSE
	var/tier

	var/obj/structure/broodmother_egg/selected_override
	var/list/overrides
	var/image/override_overlay

/atom/movable/screen/broodmother/button/Click(location, control, params)
	. = ..()
	var/mob/living/simple_animal/hostile/retaliate/troll/broodmother/broodmother = usr
	if(!istype(broodmother))
		return
	var/list/modifiers = params2list(params)
	if(LAZYACCESS(modifiers, RIGHT_CLICK) && length(overrides))
		rotate_overide()
		return
	broodmother.attempt_lay_egg(tier, selected_override)

/atom/movable/screen/broodmother/button/proc/rotate_overide()
	if(!length(overrides))
		return

	var/current_index = overrides.Find(selected_override)
	selected_override = overrides[(current_index % length(overrides)) + 1]
	name = "Lay [initial(selected_override.hud_name)]"
	update_override_overlay()

/atom/movable/screen/broodmother/button/proc/update_override_overlay()
	if(override_overlay)
		cut_overlay(override_overlay)
		override_overlay = null

	if(!selected_override)
		return

	override_overlay = image(icon = selected_override.icon, icon_state = selected_override.icon_state)
	add_overlay(override_overlay)

/atom/movable/screen/broodmother/bar/tier_1_biomass_bar
	name = "Tier 1 Biomass"
	icon_state = "points_1"
	mask_state = "points_1_mask"
	screen_loc = "WEST,CENTER-2:+22"
	tier = 1

/atom/movable/screen/broodmother/button/tier_1_biomass_lay
	name = "Lay a tier 1 egg"
	icon_state = "tier1"
	screen_loc = "WEST+1:-13,CENTER-1:0"
	tier = 1
	overrides = list(
		/obj/structure/broodmother_egg/goblin,
		/obj/structure/broodmother_egg/goblin/moon,
		/obj/structure/broodmother_egg/goblin/hell,
		/obj/structure/broodmother_egg/goblin/sea,
		/obj/structure/broodmother_egg/goblin/cave,
	)

/atom/movable/screen/broodmother/bar/tier_2_biomass_bar
	name = "Tier 2 Biomass"
	icon_state = "points_2"
	mask_state = "points_2_mask"
	screen_loc = "WEST,CENTER-2:+22"
	tier = 2

/atom/movable/screen/broodmother/button/tier_2_biomass_lay
	name = "Lay an Orc Egg"
	icon_state = "tier2"
	screen_loc = "WEST+1:-13,CENTER+0:2"
	tier = 2

/atom/movable/screen/broodmother/bar/tier_3_biomass_bar
	name = "Tier 3 Biomass"
	icon_state = "points_3"
	mask_state = "points_3_mask"
	screen_loc = "WEST,CENTER-2:+22"
	tier = 3

/atom/movable/screen/broodmother/button/tier_3_biomass_lay
	name = "Lay a Troll Egg"
	icon_state = "tier3"
	screen_loc = "WEST+1:-13,CENTER+1:4"
	tier = 3
	overrides = list(
		/obj/structure/broodmother_egg/troll,
		/obj/structure/broodmother_egg/troll/sea,
		/obj/structure/broodmother_egg/troll/cave,
		/obj/structure/broodmother_egg/troll/axe,
	)

/datum/hud/broodmother/New(mob/owner)
	..()

	for(var/element in BROODMOTHER_HUD_ELEMENTS)
		var/atom/movable/screen/using = new element()
		using.set_new_hud(src)
		static_inventory += using

	backhudl = new /atom/movable/screen/backhudl/empty_border(null, src)
	static_inventory += backhudl

	button_effects(owner)

/datum/hud/broodmother/proc/button_effects(mob/living/simple_animal/hostile/retaliate/troll/broodmother/mob)
	for(var/atom/movable/screen/broodmother/button/button in static_inventory)
		if(length(button.overrides))
			button.rotate_overide()
		if(!mob.egg_laying_checks(button.tier))
			button.color = "#610000"
			continue
		button.color = null

#undef BROODMOTHER_HUD_ELEMENTS
