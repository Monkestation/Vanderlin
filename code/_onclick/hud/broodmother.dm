#define RENDER_TARGET_BAR_MASK "bar_mask"

#define BROODMOTHER_HUD_ELEMENTS (	list(\
									/atom/movable/screen/broodmother/cover,\
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
	icon = 'icons/mob/broodmother_hud/cover.dmi'
	icon_state = "cover"
	screen_loc = "WEST:-86,TOP:-2"
	plane = HUD_PLANE

/atom/movable/screen/broodmother/mask
	render_target = RENDER_TARGET_BAR_MASK
	icon_state = "mask"

/atom/movable/screen/broodmother/bar
	icon = 'icons/mob/broodmother_hud/4x128.dmi'
	var/current_alpha_mask_filter_offset = 0
	var/tier

/atom/movable/screen/broodmother/bar/info_blurb(mob/living/simple_animal/hostile/retaliate/troll/broodmother/broodmother)
	to_chat(broodmother, span_info("Current biomass amount - [broodmother.vars["tier_[tier]_biomass_amount"]]"))
	to_chat(broodmother, span_info("Amount needed for laying egg - [broodmother.vars["tier_[tier]_biomass_cost"]]"))

/atom/movable/screen/broodmother/bar/Initialize(mapload, datum/hud/hud_owner)
	. = ..()
	add_filter("alpha_mask_filter", 10, alpha_mask_filter(icon = icon('icons/mob/broodmother_hud/4x128.dmi', icon_state = "mask"), y = current_alpha_mask_filter_offset, flags = MASK_INVERSE))

/atom/movable/screen/broodmother/bar/proc/on_biomass_change(datum/source, current_biomass, _tier)
	SIGNAL_HANDLER
	if(tier != _tier)
		return

	set_alpha_offset(128 / 100 * current_biomass)

/atom/movable/screen/broodmother/bar/proc/adjust_alpha_offset(amount)
	current_alpha_mask_filter_offset = clamp(current_alpha_mask_filter_offset + amount, 0, 128)
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
	current_alpha_mask_filter_offset = 128/100 * mother.vars["tier_[tier]_biomass_amount"]
	update_mask_offset()

/atom/movable/screen/broodmother/bar/Destroy()
	. = ..()
	UnregisterSignal(hud.mymob, COMSIG_BROODMOTHER_BIOMASS_CHANGE)

/atom/movable/screen/broodmother/button
	icon = 'icons/mob/broodmother_hud/8x8.dmi'
	var/tier

/atom/movable/screen/broodmother/button/Click(location, control, params)
	. = ..()
	var/mob/living/simple_animal/hostile/retaliate/troll/broodmother/broodmother = usr
	if(!istype(broodmother))
		return

	broodmother.attempt_lay_egg(tier)

/atom/movable/screen/broodmother/bar/tier_1_biomass_bar
	name = "Tier 1 Biomass"
	icon_state = "t1_biomass"
	screen_loc = "WEST:-80,TOP:-4"
	tier = 1

/atom/movable/screen/broodmother/button/tier_1_biomass_lay
	name = "Lay a tier 1 egg"
	icon_state = "t1_lay_egg"
	screen_loc = "WEST:-82,TOP:-134"
	tier = 1

/atom/movable/screen/broodmother/bar/tier_2_biomass_bar
	name = "Tier 2 Biomass"
	icon_state = "t2_biomass"
	screen_loc = "WEST:-70,TOP:-4"
	tier = 2

/atom/movable/screen/broodmother/button/tier_2_biomass_lay
	name = "Lay a tier 2 egg"
	icon_state = "t2_lay_egg"
	screen_loc = "WEST:-72,TOP:-134"
	tier = 2

/atom/movable/screen/broodmother/bar/tier_3_biomass_bar
	name = "Tier 3 Biomass"
	icon_state = "t3_biomass"
	screen_loc = "WEST:-60,TOP:-4"
	tier = 3

/atom/movable/screen/broodmother/button/tier_3_biomass_lay
	name = "Lay a tier 3 egg"
	icon_state = "t3_lay_egg"
	screen_loc = "WEST:-62,TOP:-134"
	tier = 3

/datum/hud/broodmother/New(mob/owner)
	..()
	var/atom/movable/screen/using

	scannies = new /atom/movable/screen/scannies
	scannies.set_new_hud(src)
	static_inventory += scannies
	if(owner.client?.prefs?.crt == TRUE)
		scannies.alpha = 70

	for(var/element as anything in BROODMOTHER_HUD_ELEMENTS)
		using = new element()
		using.set_new_hud(src)
		static_inventory += using

#undef RENDER_TARGET_BAR_MASK
#undef BROODMOTHER_HUD_ELEMENTS
