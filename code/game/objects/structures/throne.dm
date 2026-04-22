/obj/structure/throne
	name = "throne"
	desc = "A big throne, to hold the Lord's giant personality. Say 'help' with the crown on your head if you are confused."
	icon = 'icons/roguetown/misc/96x96.dmi'
	icon_state = "throne"
	density = FALSE
	can_buckle = 1
	SET_BASE_PIXEL(-32, 0)
	max_integrity = 999999
	buckle_lying = FALSE
	obj_flags = NONE
	uses_lord_coloring = LORD_PRIMARY | LORD_SECONDARY
	var/throat_mode = "None"

/obj/structure/throne/post_buckle_mob(mob/living/M)
	..()
	density = TRUE
	M.add_offsets(type, x_add = 0, y_add = 8)

/obj/structure/throne/post_unbuckle_mob(mob/living/M)
	. = ..()
	density = FALSE
	M.remove_offsets(type)

/obj/structure/throne/statues	// alt version with more statue but covers side tables less.
	icon = 'icons/roguetown/misc/throne_alt.dmi'

/obj/structure/throne/vthrone
	name = "The Blood Throne"
	desc = "A big ominous throne."
	icon = 'icons/roguetown/misc/vthrone.dmi'

/obj/structure/throne/examine(mob/user)
	. = ..()
	. += span_notice("The current mode is [throat_mode].")

/obj/structure/throne/proc/do_filters_glow()
	filters = filter(type = "rays", size = 80, color = "#a38c2e")

/obj/structure/throne/proc/remove_filters_glow()
	filters = null

