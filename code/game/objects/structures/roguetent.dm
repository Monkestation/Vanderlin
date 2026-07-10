
/obj/structure/roguetent
	name = "tent door"
	desc = "A door made of sturdy fabric and wooden frames."
	icon = 'icons/turf/walls.dmi'
	icon_state = "tent_door1"
	layer = TABLE_LAYER
	density = TRUE
	anchored = TRUE
	opacity = FALSE
	weatherproof = TRUE
	max_integrity = 100
	var/base_state = "tent_door"
	blade_dulling = DULLING_BASHCHOP
	attacked_sound = list('sound/combat/hits/onwood/woodimpact (1).ogg','sound/combat/hits/onwood/woodimpact (2).ogg')
	destroy_sound = 'sound/combat/hits/onwood/destroywalldoor.ogg'

/obj/structure/roguetent/Initialize()
	. = ..()
	update_appearance(UPDATE_ICON_STATE)

/obj/structure/roguetent/update_icon_state()
	. = ..()
	if(density)
		icon_state = "[base_state][pick(1,2)]"
	else
		icon_state = "[base_state]0"

/obj/structure/roguetent/proc/open_up(mob/user)
	visible_message("<span class='info'>[user] opens [src].</span>")
	playsound(src, 'sound/foley/equip/rummaging-02.ogg', 100, FALSE)
	density = FALSE
	set_opacity(FALSE)
	update_appearance(UPDATE_ICON_STATE)

/obj/structure/roguetent/proc/close_up(mob/user)
	visible_message("<span class='info'>[user] closes [src].</span>")
	playsound(src, 'sound/foley/equip/rummaging-02.ogg', 100, FALSE)
	density = TRUE
	set_opacity(TRUE)
	update_appearance(UPDATE_ICON_STATE)

/obj/structure/roguetent/attack_paw(mob/living/user)
	attack_hand(user)

/obj/structure/roguetent/attack_hand(mob/living/user)
	. = ..()
	if(.)
		return
	if(!density)
		close_up(user)
	else
		open_up(user)

// Preopen version, so visuals and opacity matches up round start.
/obj/structure/roguetent/preopen
	density = FALSE
