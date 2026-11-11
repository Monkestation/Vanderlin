
/obj/structure/tentdoor
	name = "blue tent door"
	desc = "A doors made from coloured fabric and wooden supports. "
	icon = 'icons/turf/walls.dmi'
	icon_state = "tentdoor_blue-closed"
	var/icon_type = "tentdoor_blue"//used in making the icon state
	alpha = 255 //Mappers can also just set this to 255 if they want curtains that can't be seen through
	layer = TABLE_LAYER
	anchored = TRUE
	opacity = FALSE
	density = TRUE
	weatherproof = TRUE
	max_integrity = 100
	attacked_sound = list('sound/combat/hits/onwood/woodimpact (1).ogg','sound/combat/hits/onwood/woodimpact (2).ogg')
	destroy_sound = 'sound/combat/hits/onwood/destroywalldoor.ogg'
	var/open = TRUE

/obj/structure/tentdoor/proc/toggle(mob/user)
	user.changeNext_move(CLICK_CD_FAST)
	if(open)
		playsound(src, 'sound/foley/equip/rummaging-02.ogg', 100, FALSE)
		set_opacity(TRUE)
		icon_state = "[icon_type]-open"
		open = FALSE
		density = TRUE
	else
		playsound(src, 'sound/foley/equip/rummaging-02.ogg', 100, FALSE)
		set_opacity(FALSE)
		icon_state = "[icon_type]-closed"
		open = TRUE
		density = FALSE
	update_appearance(UPDATE_ICON_STATE)

/obj/structure/tentdoor/update_icon_state()
	. = ..()
	icon_state = "[icon_type]-[open ? "open" : "closed"]"

/obj/structure/tentdoor/attack_hand(mob/user)
	. = ..()
	if(.)
		return
	toggle(user)

/obj/structure/tentdoor/preopen
	density = FALSE

/obj/structure/tentdoor/cyan
	icon_type = "tentdoor_cyan"
	icon_state = "tentdoor_cyan-closed"
	name = "cyan tent door"

/obj/structure/tentdoor/brown
	icon_type = "tentdoor_brown"
	icon_state = "tentdoor_brown-closed"
	name = "brown tent door"

/obj/structure/tentdoor/green
	icon_type = "tentdoor_green"
	icon_state = "tentdoor_green-closed"
	name = "green tent door"

/obj/structure/tentdoor/purple
	icon_type = "tentdoor_purple"
	icon_state = "tentdoor_purple-closed"
	name = "purple tent door"

/obj/structure/tentdoor/red
	icon_type = "tentdoor_red"
	icon_state = "tentdoor_red-closed"
	name = "red tent door"

/obj/structure/tentdoor/bluedeco
	icon_type = "tentdoor_bluedeco"
	icon_state = "tentdoor_bluedeco-closed"
	name = "decorated blue tent door"

/obj/structure/tentdoor/cyandeco
	icon_type = "tentdoor_cyandeco"
	icon_state = "tentdoor_cyandeco-closed"
	name = "decorated cyan tent door"

/obj/structure/tentdoor/browndeco
	icon_type = "tentdoor_browndeco"
	icon_state = "tentdoor_browndeco-closed"
	name = "decorated brown tent door"

/obj/structure/tentdoor/greendeco
	icon_type = "tentdoor_greendeco"
	icon_state = "tentdoor_greendeco-closed"
	name = "decorated green tent door"

/obj/structure/tentdoor/purpledeco
	icon_type = "tentdoor_purpledeco"
	icon_state = "tentdoor_purpledeco-closed"
	name = "decorated purple tent door"

/obj/structure/tentdoor/reddeco
	icon_type = "tentdoor_reddeco"
	icon_state = "tentdoor_reddeco-closed"
	name = "decorated red tent door"

/obj/structure/tentdoor/noc
	icon_type = "tentdoor_noc"
	icon_state = "tentdoor_noc-closed"
	name = "decorated navy tent door"
