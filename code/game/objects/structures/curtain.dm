/obj/structure/curtain
	name = "curtain"
	desc = ""
	icon = 'icons/obj/watercloset.dmi'
	icon_state = "bathroom-open"
	var/icon_type = "bathroom"//used in making the icon state
	color = "#ACD1E9" //Default color, didn't bother hardcoding other colors, mappers can and should easily change it.
	alpha = 200 //Mappers can also just set this to 255 if they want curtains that can't be seen through
	plane = GAME_PLANE_UPPER
	anchored = TRUE
	opacity = FALSE
	density = FALSE
	var/open = TRUE
	var/directional = FALSE //Can it be closed from one side only? i.e. Window curtains vs surgical drapes, curtain doors...

/obj/structure/curtain/proc/toggle(mob/user)
	user.changeNext_move(CLICK_CD_FAST)
	if(directional && !(get_dir(src, user) == dir))
		to_chat(user, span_notice("I can't reach the curtains from this side."))
		return
	if(open)
		set_opacity(TRUE)
		icon_state = "[icon_type]-open"
		open = FALSE
	else
		set_opacity(FALSE)
		icon_state = "[icon_type]-closed"
		open = TRUE
	update_appearance(UPDATE_ICON_STATE)

/obj/structure/curtain/update_icon_state()
	. = ..()
	icon_state = "[icon_type]-[open ? "open" : "closed"]"

/obj/structure/curtain/wirecutter_act(mob/living/user, obj/item/I)
	..()
	if(anchored)
		return TRUE

	user.visible_message("<span class='warning'>[user] cuts apart [src].</span>",
		"<span class='notice'>I start to cut apart [src].</span>", "<span class='hear'>I hear cutting.</span>")
	if(I.use_tool(src, user, 50, volume=100) && !anchored)
		to_chat(user, "<span class='notice'>I cut apart [src].</span>")
		deconstruct()

	return TRUE

/obj/structure/curtain/attack_hand(mob/user)
	. = ..()
	if(.)
		return
	toggle(user)

/obj/structure/curtain/dir
	icon_state = MAP_SWITCH("bathroom-open", "curtaindir")
	directional = TRUE

/obj/structure/curtain/bounty
	icon_type = "bounty"
	icon_state = "bounty-open"
	color = null
	alpha = 255

/obj/structure/curtain/bounty/dir
	icon_state = MAP_SWITCH("bounty-open", "bountydir")
	directional = TRUE
