/obj/machinery/light/fueledstreet
	name = "street lamp"
	icon = 'icons/roguetown/misc/tallstructure.dmi'
	icon_state = "slamp1"
	var/state_suffix = "1"
	base_state = "slamp"
	brightness = 10
	//nightshift_allowed = FALSE
	bulb_colour = "#e4ff6c"
	bulb_power = 1
	resistance_flags = INDESTRUCTIBLE
	pass_flags_self = LETPASSTHROW
	smeltresult = /obj/item/ingot/bronze

/obj/machinery/light/fueledstreet/Initialize()
	. = ..()
	lights_on()
	GLOB.streetlamp_list += src

/obj/machinery/light/fueledstreet/Destroy()
	GLOB.streetlamp_list -= src
	GLOB.fires_list -= src
	return ..()

/obj/machinery/light/fueledstreet/midlamp
	icon = 'icons/roguetown/misc/64x64.dmi'
	icon_state = "midlamp1"
	base_state = "midlamp"
	SET_BASE_PIXEL(-16, 0)
	density = TRUE

/obj/machinery/light/fueledstreet/orange
	icon_state = "o_slamp1"
	bulb_colour = "#e9a387"
	base_state = "o_slamp"
	state_suffix = "1"

/obj/machinery/light/fueledstreet/orange/wall
	icon_state = "o_wlamp1_nozap"
	base_state = "o_wlamp"
	state_suffix = "_nozap"

/obj/machinery/light/fueledstreet/proc/lights_out(permanent)
	on = FALSE
	update()
	update_appearance(UPDATE_ICON_STATE)
	if(!permanent)
		addtimer(CALLBACK(src, PROC_REF(lights_on)), 5 MINUTES)

/obj/machinery/light/fueledstreet/proc/lights_on()
	on = TRUE
	update()
	update_appearance(UPDATE_ICON_STATE)

/obj/machinery/light/fueledstreet/update_icon_state()
	. = ..()
	if(on)
		icon_state = "[base_state][state_suffix]"
	else
		icon_state = "[base_state]0"

/obj/machinery/light/fueledstreet/update()
	. = ..()
	if(on)
		GLOB.fires_list |= src
	else
		GLOB.fires_list -= src

//SLOP CODE :)))) it'll do but i'm not happy with where we are for the sprites for these.
/obj/machinery/light/fueledstreet/blue
	icon_state = "slamp3"
	bulb_colour = "#6cfdff"
	base_state = "slamp"
	state_suffix = "3"

/obj/machinery/light/fueledstreet/blue/midlamp
	icon = 'icons/roguetown/misc/64x64.dmi'
	icon_state = "midlamp3"
	base_state = "midlamp"
	state_suffix = "3"
	SET_BASE_PIXEL(0, -16)
	density = TRUE

/obj/machinery/light/fueledstreet/blue/wall
	icon_state = "wlamp3"
	base_state = "wlamp"
	state_suffix = "3"
