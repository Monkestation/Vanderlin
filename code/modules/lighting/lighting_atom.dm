/// Will update the light (duh).
/// Creates or destroys it if needed, makes it update values, makes sure it's got the correct source turf...
/atom/proc/update_light()
	SHOULD_NOT_SLEEP(TRUE)

	if(light_system != STATIC_LIGHT)
		CRASH("update_light() for [src] with following light_system value: [light_system]")

	if (!light_power || !light_outer_range || !light_on) // We won't emit light anyways, destroy the light source.
		QDEL_NULL(light)
	else
		if (!ismovable(loc)) // We choose what atom should be the top atom of the light here.
			. = src
		else
			. = loc

		if (!QDELETED(light)) // Update the light or create it if it does not exist.
			light.update(.)
		else
			light = new/datum/light_source(src, .)

// The proc you should always use to set the light of this atom.
// Nonesensical value for l_color default, so we can detect if it gets set to null.
#define NONSENSICAL_VALUE -99999
/atom/proc/set_light(l_outer_range, l_inner_range, l_power, l_falloff_curve = LIGHTING_DEFAULT_FALLOFF_CURVE, l_color = NONSENSICAL_VALUE, l_on)
	if(l_outer_range > 0 && l_outer_range < MINIMUM_USEFUL_LIGHT_RANGE)
		l_outer_range = MINIMUM_USEFUL_LIGHT_RANGE //Brings the range up to 1.4, which is just barely brighter than the soft lighting that surrounds players.

	if(SEND_SIGNAL(src, COMSIG_ATOM_SET_LIGHT, l_inner_range, l_outer_range, l_power, l_falloff_curve, l_color, l_on) & COMPONENT_BLOCK_LIGHT_UPDATE)
		return

	if(!isnull(l_power))
		set_light_power(l_power)

	if(!isnull(l_inner_range) || !isnull(l_outer_range))
		if(l_inner_range >= l_outer_range)
			l_inner_range = l_outer_range / 4
		set_light_range(l_inner_range, l_outer_range)

	if(l_falloff_curve != NONSENSICAL_VALUE)
		if(!l_falloff_curve || l_falloff_curve <= 0)
			l_falloff_curve = LIGHTING_DEFAULT_FALLOFF_CURVE
		set_light_curve(l_falloff_curve)

	if(l_color != NONSENSICAL_VALUE)
		set_light_color(l_color)
	if(!isnull(l_on))
		set_light_on(l_on)
	update_light()

#undef NONSENSICAL_VALUE

/// Setter for the light color of this atom.
/atom/proc/set_light_color(new_color)
	if(new_color == light_color)
		return
	if(SEND_SIGNAL(src, COMSIG_ATOM_SET_LIGHT_COLOR, new_color) & COMPONENT_BLOCK_LIGHT_UPDATE)
		return
	. = light_color
	light_color = new_color
	SEND_SIGNAL(src, COMSIG_ATOM_UPDATE_LIGHT_COLOR, .)

/atom/proc/set_light_range(new_inner_range, new_outer_range)
	if(isnull(new_inner_range) && new_outer_range)
		new_inner_range = new_outer_range/4
	if(isnull(new_outer_range) && new_inner_range)
		new_outer_range = new_inner_range

	if((new_inner_range == light_inner_range) && (new_outer_range == light_outer_range))
		return
	if(SEND_SIGNAL(src, COMSIG_ATOM_SET_LIGHT_RANGE, new_inner_range, new_outer_range) & COMPONENT_BLOCK_LIGHT_UPDATE)
		return
	var/old_outer_range = light_outer_range
	var/old_inner_range = light_inner_range

	light_outer_range = new_outer_range
	light_inner_range = new_inner_range
	SEND_SIGNAL(src, COMSIG_ATOM_UPDATE_LIGHT_RANGE, old_inner_range, old_outer_range)
	return TRUE

/// Setter for this atom's light falloff curve.
/atom/proc/set_light_curve(new_curve)
	if(new_curve == light_falloff_curve)
		return
	if(SEND_SIGNAL(src, COMSIG_ATOM_SET_LIGHT_CURVE, new_curve) & COMPONENT_BLOCK_LIGHT_UPDATE)
		return
	. = light_falloff_curve
	light_falloff_curve = new_curve
	SEND_SIGNAL(src, COMSIG_ATOM_UPDATE_LIGHT_CURVE, .)

/// Setter for the light power of this atom.
/atom/proc/set_light_power(new_power)
	if(new_power == light_power)
		return
	if(SEND_SIGNAL(src, COMSIG_ATOM_SET_LIGHT_POWER, new_power) & COMPONENT_BLOCK_LIGHT_UPDATE)
		return
	. = light_power
	light_power = new_power
	SEND_SIGNAL(src, COMSIG_ATOM_UPDATE_LIGHT_POWER, .)

/// Setter for whether or not this atom's light is on.
/atom/proc/set_light_on(new_value)
	if(new_value == light_on)
		return
	if(SEND_SIGNAL(src, COMSIG_ATOM_SET_LIGHT_ON, new_value) & COMPONENT_BLOCK_LIGHT_UPDATE)
		return
	. = light_on
	light_on = new_value
	SEND_SIGNAL(src, COMSIG_ATOM_UPDATE_LIGHT_ON, .)

/**
  * Updates the atom's opacity value.
  *
  * This exists to act as a hook for associated behavior.
  * It notifies (potentially) affected light sources so they can update (if needed).
  */
/atom/proc/set_opacity(new_opacity)
	if (new_opacity == opacity)
		return
	SEND_SIGNAL(src, COMSIG_ATOM_SET_OPACITY, new_opacity)
	. = opacity
	opacity = new_opacity

/atom/movable/set_opacity(new_opacity)
	. = ..()
	if(isnull(.) || !isturf(loc))
		return

	if(opacity)
		AddElement(/datum/element/light_blocking)
	else
		RemoveElement(/datum/element/light_blocking)

/turf/set_opacity(new_opacity)
	. = ..()
	if(isnull(.))
		return
	recalculate_directional_opacity()

/atom/vv_edit_var(var_name, var_value)
	switch (var_name)
		if ("light_outer_range")
			set_light(l_outer_range=var_value)
			datum_flags |= DF_VAR_EDITED
			return TRUE

		if ("light_power")
			set_light(l_power=var_value)
			datum_flags |= DF_VAR_EDITED
			return TRUE

		if ("light_color")
			set_light(l_color=var_value)
			datum_flags |= DF_VAR_EDITED
			return TRUE

	return ..()


/atom/proc/flash_lighting_fx(_range = FLASH_LIGHT_RANGE, _power = FLASH_LIGHT_POWER, _color = LIGHT_COLOR_WHITE, _duration = FLASH_LIGHT_DURATION, _reset_lighting = TRUE)
	return

/turf/flash_lighting_fx(_range = FLASH_LIGHT_RANGE, _power = FLASH_LIGHT_POWER, _color = LIGHT_COLOR_WHITE, _duration = FLASH_LIGHT_DURATION, _reset_lighting = TRUE)
	if(!_duration)
		stack_trace("Lighting FX obj created on a turf without a duration")
	new /obj/effect/dummy/lighting_obj (src, _color, _range, _power, _duration)

/obj/flash_lighting_fx(_range = FLASH_LIGHT_RANGE, _power = FLASH_LIGHT_POWER, _color = LIGHT_COLOR_WHITE, _duration = FLASH_LIGHT_DURATION, _reset_lighting = TRUE)
	var/temp_color
	var/temp_power
	var/temp_range
	if(!_reset_lighting) //incase the obj already has a lighting color that you don't want cleared out after, ie computer monitors.
		temp_color = light_color
		temp_power = light_power
		temp_range = light_outer_range
	set_light(_range, light_inner_range, _power, l_color =_color)
	addtimer(CALLBACK(src, TYPE_PROC_REF(/atom, set_light), _reset_lighting ? initial(light_outer_range) : temp_range, initial(light_inner_range), _reset_lighting ? initial(light_power) : temp_power, _reset_lighting ? initial(light_color) : temp_color), _duration, TIMER_OVERRIDE|TIMER_UNIQUE)

/mob/living/flash_lighting_fx(_range = FLASH_LIGHT_RANGE, _power = FLASH_LIGHT_POWER, _color = LIGHT_COLOR_WHITE, _duration = FLASH_LIGHT_DURATION, _reset_lighting = TRUE)
	mob_light(_color, _range, _power, _duration)

/mob/living/proc/mob_light(_color, _range, _power, _duration)
	var/obj/effect/dummy/lighting_obj/moblight/mob_light_obj = new (src, _color, _range, _power, _duration)
	return mob_light_obj

