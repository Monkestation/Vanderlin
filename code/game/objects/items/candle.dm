#define CANDLE_LUMINOSITY	3
/obj/item/candle
	name = "candle"
	desc = ""
	icon = 'icons/obj/candle.dmi'
	icon_state = "candle1"
	item_state = "candle1"
	base_icon_state = "candle"
	w_class = WEIGHT_CLASS_TINY
	light_color = LIGHT_COLOR_FIRE
	dropshrink = 0.8
	heat = 1000
	var/wax = 1000
	var/lit = FALSE
	var/infinite = FALSE
	var/start_lit = FALSE

/obj/item/candle/lit
	start_lit = TRUE
	icon_state = "candle1_lit"

/obj/item/candle/Initialize()
	. = ..()
	if(start_lit)
		light()

/obj/item/candle/update_icon_state()
	. = ..()
	if(!infinite)
		icon_state = "[base_icon_state][(wax > 400) ? ((wax > 750) ? 1 : 2) : 3][lit ? "_lit" : ""]"
	else
		icon_state = "[base_icon_state][lit ? "_lit" : ""]"

/obj/item/candle/afterattack(atom/movable/A, mob/user, proximity, list/modifiers)
	. = ..()
	if(!proximity)
		return
	if(lit)
		A.fire_act()

/obj/item/candle/Crossed(H as mob|obj)
	if(ishuman(H)) //i guess carp and shit shouldn't set them off
		var/mob/living/carbon/M = H
		if(M.m_intent == MOVE_INTENT_RUN)
			wax = 100
			put_out_candle()

/obj/item/candle/fire_act(added, maxstacks)
	if(!lit)
		light()
	return ..()

/obj/item/candle/spark_act()
	fire_act()

/obj/item/candle/get_temperature()
	return lit * heat

/obj/item/candle/proc/light(show_message)
	if(!lit)
		lit = TRUE
		if(show_message)
			usr.visible_message(show_message)
		set_light(CANDLE_LUMINOSITY)
		START_PROCESSING(SSobj, src)
		update_appearance(UPDATE_ICON_STATE)

/obj/item/candle/proc/put_out_candle()
	if(!lit)
		return
	lit = FALSE
	update_appearance(UPDATE_ICON_STATE)
	set_light(0)
	return TRUE

/obj/item/candle/extinguish()
	put_out_candle()
	return ..()

/obj/item/candle/process()
	if(!lit)
		return PROCESS_KILL
	if(!infinite)
		wax--
	if(!wax)
		var/obj/item/trash/candle/candle = new /obj/item/trash/candle(get_turf(src))
		var/datum/component/storage/STR = loc.GetComponent(/datum/component/storage)
		if(STR)
			SEND_SIGNAL(loc, COMSIG_TRY_STORAGE_INSERT, candle, null, TRUE, TRUE)
		else
			candle.forceMove(loc)

		qdel(src)
	update_appearance(UPDATE_ICON_STATE)
	open_flame()

/obj/item/candle/attack_self(mob/user, list/modifiers)
	if(put_out_candle())
		user.visible_message("<span class='notice'>[user] snuffs [src].</span>")

/obj/item/candle/yellow
	icon = 'icons/roguetown/items/lighting.dmi'

/obj/item/candle/yellow/lit
	start_lit = TRUE
	icon_state = "candle1_lit"

/obj/item/candle/infinite
	infinite = TRUE
	start_lit = TRUE

/obj/item/candle/skull
	icon = 'icons/roguetown/items/lighting.dmi'
	icon_state = "skullcandle"
	base_icon_state = "skullcandle"
	infinite = TRUE
	light_color = "#670086"

/obj/item/candle/skull/lit
	start_lit = TRUE
	icon_state = "skullcandle_lit"

/obj/item/candle/skull/darkskull
	icon_state = "darkskullcandle"
	base_icon_state = "darkskullcandle"
	infinite = TRUE
	light_color = LIGHT_COLOR_LAVENDER

/obj/item/candle/skull/darkskull/lit
	start_lit = TRUE
	icon_state = "darkskullcandle_lit"

/obj/item/candle/eora
	icon = 'icons/roguetown/items/lighting.dmi'
	name = "eora's candle"
	desc = ""
	color = "#f858b5ff"
	light_color = "#ff13d8ff"
	infinite = TRUE

/obj/item/candle/eora/lit
	start_lit = TRUE
	icon_state = "candle1_lit"

/obj/item/candle/yellow/lit/infinite
	light_power = 1
	light_outer_range =  4
	start_lit = TRUE
	infinite = TRUE
	icon_state = "candle1_lit"
	anchored = TRUE

/obj/item/candle/yellow/lit/infinite/strong
	light_power = 2
	light_outer_range =  4

/obj/item/candle/yellow/lit/infinite/strong/skull
	icon_state = "skullcandle_lit"

#undef CANDLE_LUMINOSITY
