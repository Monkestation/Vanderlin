/obj/structure/boiler
	name = "boiler"

	icon_state = "boiler"
	icon = 'icons/obj/rotation_machines.dmi'
	layer = 5
	accepts_water_input = TRUE

	var/fuel = 100

	var/stored_steam = 0
	var/maximum_steam = 1024
	var/pressure_target = 1024

/obj/structure/boiler/Initialize()
	. = ..()
	START_PROCESSING(SSobj, src)

/obj/structure/boiler/Destroy()
	STOP_PROCESSING(SSobj, src)
	if(output)
		output.remove_provider(/datum/reagent/steam, stored_steam)
	. = ..()

/obj/structure/boiler/attack_hand(mob/user, list/modifiers)
	var/new_output = input(user, "Set the steam output pressure.", "boiler") as num|null
	if(!new_output)
		return
	if(!Adjacent(user))
		return
	pressure_target = clamp(new_output, 0, maximum_steam)
	to_chat(user, "You set the steam output pressure to [pressure_target].")
	return TRUE

/obj/structure/boiler/setup_water()
	var/turf/east_turf = get_step(src, turn(dir, 90))
	var/turf/west_turf = get_step(src, turn(dir, -90))

	input = locate(/obj/structure/water_pipe) in east_turf
	output = locate(/obj/structure/water_pipe) in west_turf

/obj/structure/boiler/return_rotation_chat()
	return	"Input Pressure:[input ? input.water_pressure : "0"]\n\
			Output Pressure: ACTL:[min(pressure_target, stored_steam)] TGT:[pressure_target]\n\
			Stored Steam:[stored_steam ? round((stored_steam / maximum_steam) * 100, 1 ): "0"]%"

// Assume boiler is facing south (dir = SOUTH). Input is coming in from the right (direction = WEST) and output is to the left (direction = EAST)
/obj/structure/boiler/valid_water_connection(direction, obj/structure/water_pipe/pipe)
	if(direction == turn(dir, -90))
		input = pipe
		return TRUE
	if(direction == turn(dir, 90))
		output = pipe
		return TRUE
	return FALSE

/obj/structure/boiler/process()
	if(input && fuel && length(input.providers))
		var/obj/structure/water_pipe/picked_provider = pick(input.providers)
		var/steam_left = maximum_steam - stored_steam
		var/taking_pressure = min(steam_left,input.water_pressure)
		if(taking_pressure)
			picked_provider?.taking_from?.use_water_pressure(taking_pressure * 0.5)
		stored_steam += taking_pressure

	var/true_pressure = min(pressure_target, stored_steam)
	if(!output || !true_pressure)
		return
	output.make_provider(/datum/reagent/steam, true_pressure, src)

/obj/structure/boiler/use_water_pressure(pressure)
	stored_steam -= pressure
	if(!output)
		return
	var/true_pressure = min(pressure_target, stored_steam)
	output.make_provider(/datum/reagent/steam, true_pressure, src)

/datum/reagent/steam
	name = "Steam"
