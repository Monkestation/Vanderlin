/obj/effect/temp_visual/pillar_warning
	icon = 'icons/effects/effects.dmi'
	icon_state = "spellwarning"
	layer = ABOVE_MOB_LAYER
	duration = 2 SECONDS

/obj/effect/temp_visual/pillar_warning/Initialize(mapload, life)
	if(life)
		duration = life
	. = ..()

/obj/effect/temp_visual/pillar_warning/fadein
	alpha = 0

/obj/effect/temp_visual/pillar_warning/fadein/Initialize(mapload, life)
	. = ..()
	animate(src, alpha = 255, time = duration)

/obj/effect/temp_visual/fire_pillar
	icon = 'icons/effects/32x96.dmi'
	icon_state = "sunstrike"
	light_outer_range = 2
	light_color = LIGHT_COLOR_FIRE
	duration = 1 SECONDS

/obj/effect/temp_visual/dragonfire
	icon = 'icons/effects/fire.dmi'
	icon_state = "3"
	layer = GASFIRE_LAYER
	light_outer_range = LIGHT_RANGE_FIRE
	light_color = LIGHT_COLOR_FIRE
	blend_mode = BLEND_ADD
	duration = 8
