/obj/effect/temp_visual/spell_impact
	icon = 'icons/effects/spell_cast.dmi'
	icon_state = "particle_up"
	layer = ABOVE_ALL_MOB_LAYER
	duration = 1 SECONDS
	randomdir = FALSE
	light_outer_range = 3
	light_color = "#FFFFFF"
	mouse_opacity = MOUSE_OPACITY_TRANSPARENT

/obj/effect/temp_visual/spell_impact/Initialize(mapload, impact_color = "#FFFFFF", intensity = SPELL_IMPACT_LOW)
	. = ..()
	color = impact_color
	light_color = impact_color

	switch(intensity)
		if(SPELL_IMPACT_LOW)
			light_outer_range = 3
		if(SPELL_IMPACT_MEDIUM)
			light_outer_range = 5
		if(SPELL_IMPACT_HIGH)
			light_outer_range = 7
