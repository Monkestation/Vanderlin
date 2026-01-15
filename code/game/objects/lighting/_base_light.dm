// The lighting system
//
// consists of light fixtures (/obj/machinery/light) and light tube/bulb items (/obj/item/light)

#define LIGHT_EMERGENCY_POWER_USE 0.2 //How much power emergency lights will consume per tick
// status values shared between lighting fixtures and items
#define LIGHT_OK 0
#define LIGHT_EMPTY 1
#define LIGHT_BROKEN 2
#define LIGHT_BURNED 3

#define BROKEN_SPARKS_MIN (30 SECONDS)
#define BROKEN_SPARKS_MAX (90 SECONDS)

// the standard tube light fixture
/obj/machinery/light
	name = "light fixture"
	icon = 'icons/obj/lighting.dmi'
	var/overlayicon = 'icons/obj/lighting_overlay.dmi'
	var/base_state = "tube"		// base description and icon_state
	icon_state = "tube"
	desc = ""
	layer = WALL_OBJ_LAYER
	max_integrity = 100
	var/on = FALSE					// 1 if on, 0 if off
	var/on_gs = FALSE
	var/static_power_used = 0
	var/brightness = 8			// luminosity when on, also used in power calculation
	var/bulb_power = 1			// basically the alpha of the emitted light source
	var/bulb_colour = "#FFFFFF"	// befault colour of the light.
	var/status = LIGHT_OK		// LIGHT_OK, _EMPTY, _BURNED or _BROKEN
	var/flickering = FALSE
	var/fitting = "tube"
	var/switchcount = 0			// count of number of times switched on/off
								// this is used to calc the probability the light burns out

	var/rigged = FALSE			// true if rigged to explode

	var/obj/item/stock_parts/cell/cell
	var/start_with_cell = TRUE	// if true, this fixture generates a very weak cell at roundstart

	var/nightshift_enabled = FALSE	//Currently in night shift mode?
	var/nightshift_allowed = FALSE	//Set to FALSE to never let this light get switched to night mode.
	var/nightshift_brightness = 8
	var/nightshift_light_power = 1
	var/nightshift_light_color = "#071436"

	var/dawnshift_brightness = 8
	var/dawnshift_light_power = 1
	var/dawnshift_light_color = "#364052"

	var/duskshift_brightness = 8
	var/duskshift_light_power = 1
	var/duskshift_light_color = "#505f7a"

	var/emergency_mode = FALSE	// if true, the light is in emergency mode
	var/no_emergency = FALSE	// if true, this light cannot ever have an emergency mode
	var/bulb_emergency_brightness_mul = 0.25	// multiplier for this light's base brightness in emergency power mode
	var/bulb_emergency_colour = "#FF3232"	// determines the colour of the light while it's in emergency mode
	var/bulb_emergency_pow_mul = 0.75	// the multiplier for determining the light's power in emergency mode
	var/bulb_emergency_pow_min = 0.5	// the minimum value for the light's power in emergency mode

	var/fueluse = -1 // How much fuel the machinery starts with. At -1, it is never turned off with the passing of time.

	var/obj/effect/fog_parter/fog_parter_effect = /obj/effect/fog_parter // set to null to remove fog parter

/obj/machinery/light/Move()
	if(status != LIGHT_BROKEN)
		break_light_tube(1)
	return ..()

// create a new lighting fixture
/obj/machinery/light/Initialize(mapload)
	. = ..()
	return INITIALIZE_HINT_LATELOAD

/obj/machinery/light/LateInitialize()
	. = ..()
	addtimer(CALLBACK(src, PROC_REF(update), 0), 1)

/obj/machinery/light/Destroy()
	if(istype(fog_parter_effect))
		QDEL_NULL(fog_parter_effect)
	var/area/A = get_area(src)
	if(A)
		on = FALSE
	return ..()

// /obj/machinery/light/update_icon()
// 	cut_overlays()
// 	switch(status)		// set icon_states
// 		if(LIGHT_OK)
// 			if(emergency_mode)
// 				icon_state = "[base_state]_emergency"
// 				icon_state = null
// 			else
// 				icon_state = "[base_state]"
// 				icon_state = null
// 				if(on)
// 					var/mutable_appearance/glowybit = mutable_appearance(overlayicon, base_state, ABOVE_LIGHTING_LAYER, ABOVE_LIGHTING_PLANE)
// 					glowybit.alpha = CLAMP(light_power*250, 30, 200)
// 					add_overlay(glowybit)
// 		if(LIGHT_EMPTY)
// 			icon_state = "[base_state]-empty"
// 		if(LIGHT_BURNED)
// 			icon_state = "[base_state]-burned"
// 		if(LIGHT_BROKEN)
// 			icon_state = "[base_state]-broken"
// 	return

// update the icon_state and luminosity of the light depending on its state
/obj/machinery/light/proc/update(trigger = TRUE)
	emergency_mode = FALSE
	var/should_update_light = !isnull(set_light_on(on))
	if(on)
		var/BR = brightness
		var/PO = bulb_power
		var/CO = bulb_colour
		if(color)
			CO = color
		if(nightshift_enabled)
			switch(nightshift_enabled)
				if("night")
					BR = nightshift_brightness
					PO = nightshift_light_power
					if(!color)
						CO = nightshift_light_color
				if("dusk")
					BR = duskshift_brightness
					PO = duskshift_light_power
					if(!color)
						CO = duskshift_light_color
				if("dawn")
					BR = dawnshift_brightness
					PO = dawnshift_light_power
					if(!color)
						CO = dawnshift_light_color
				if("day")
					BR = brightness
					PO = bulb_power
					CO = bulb_colour
					if(color)
						CO = color
		var/matching = light && BR == light.light_outer_range && PO == light.light_power && CO == light.light_color
		if(!matching)
			switchcount++
			if(rigged)
				if(status == LIGHT_OK && trigger)
					explode()
			else
				set_light(BR, light_inner_range, PO, l_color = CO)
	else
		emergency_mode = TRUE
		START_PROCESSING(SSmachines, src)
	if(should_update_light)
		update_light()
	update_appearance(UPDATE_ICON_STATE)
	broken_sparks(start_only=TRUE)

/obj/machinery/light/update_atom_colour()
	..()
	update()

/obj/machinery/light/proc/broken_sparks(start_only=FALSE)
	if(status == LIGHT_BROKEN && has_power())
		if(!start_only)
			do_sparks(3, TRUE, src)
		var/delay = rand(BROKEN_SPARKS_MIN, BROKEN_SPARKS_MAX)
		addtimer(CALLBACK(src, PROC_REF(broken_sparks)), delay, TIMER_UNIQUE | TIMER_NO_HASH_WAIT)

/obj/machinery/light/process()
	if(on)
		if(initial(fueluse) > 0)
			if(fueluse > 0)
				fueluse = max(fueluse - 10, 0)
			if(fueluse == 0)
				burn_out()
	else
		return PROCESS_KILL


/obj/machinery/light/proc/burn_out()
	if(on)
		on = FALSE
		update()
		update_appearance(UPDATE_ICON_STATE)

// attempt to set the light's on/off status
// will not switch on if broken/burned/empty
/obj/machinery/light/proc/seton(s)
	on = (s && status == LIGHT_OK)
	update()

/obj/machinery/light/deconstruct(disassembled = TRUE)
	qdel(src)

/obj/machinery/light/take_damage(damage_amount, damage_type = BRUTE, damage_flag = 0, sound_effect = 1)
	. = ..()
	if(. && !QDELETED(src))
		if(prob(damage_amount * 5))
			break_light_tube()

// returns whether this light has power
// true if area has power and lightswitch is on
/obj/machinery/light/proc/has_power()
	return TRUE

/obj/machinery/light/proc/flicker(amount = rand(10, 20))
	set waitfor = 0
	if(flickering)
		return
	flickering = 1
	if(on && status == LIGHT_OK)
		for(var/i = 0; i < amount; i++)
			if(status != LIGHT_OK)
				break
			on = !on
			update(0)
			sleep(rand(5, 15))
		on = (status == LIGHT_OK)
		update(0)
	flickering = 0

// attack with hand - remove tube/bulb
// if hands aren't protected and the light is on, burn the player

/obj/machinery/light/attack_hand(mob/living/carbon/human/user)
	. = ..()
	if(.)
		return
	user.changeNext_move(CLICK_CD_MELEE)
	add_fingerprint(user)

// break the light and make sparks if was on

/obj/machinery/light/proc/break_light_tube(skip_sound_and_sparks = 0)
	if(status == LIGHT_EMPTY || status == LIGHT_BROKEN)
		return

	if(!skip_sound_and_sparks)
		if(status == LIGHT_OK || status == LIGHT_BURNED)
			playsound(src, 'sound/blank.ogg', 75, TRUE)
		if(on)
			do_sparks(3, TRUE, src)
	status = LIGHT_BROKEN
	update()

/obj/machinery/light/proc/fix()
	if(status == LIGHT_OK)
		return
	status = LIGHT_OK
	brightness = initial(brightness)
	on = TRUE
	update()

// called when on fire

/obj/machinery/light/temperature_expose(exposed_temperature, exposed_volume)
	if(prob(max(0, exposed_temperature - 673)))   //0% at <400C, 100% at >500C
		break_light_tube()

// explode the light

/obj/machinery/light/proc/explode()
	set waitfor = 0
	var/turf/T = get_turf(src.loc)
	break_light_tube()	// break it first to give a warning
	sleep(2)
	explosion(T, 0, 0, 2, 2)
	sleep(1)
	qdel(src)

// FOG RELATED PROC OVERRIDES

/obj/machinery/light/set_light_on(new_value)
	. = ..()
	if(isnull(fog_parter_effect))
		return
	if(on)
		if(!istype(fog_parter_effect))
			fog_parter_effect = new fog_parter_effect(get_turf(src), light_outer_range)
	else
		if(istype(fog_parter_effect)) // to check if its initialized instead of a path
			qdel(fog_parter_effect)
		fog_parter_effect = initial(fog_parter_effect)

/obj/machinery/light/set_light_range(new_inner_range, new_outer_range)
	. = ..()
	if(isnull(.))
		return
	if(istype(fog_parter_effect))
		fog_parter_effect.set_range(light_outer_range)
