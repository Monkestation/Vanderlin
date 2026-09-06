GLOBAL_LIST_EMPTY(mob_stock_points)

/obj/effect/landmark/mob_stock_point
	name = "mob stock spawn point"
	icon_state = "x2"

/obj/effect/landmark/mob_stock_point/Initialize(mapload)
	. = ..()
	GLOB.mob_stock_points += src

/obj/effect/landmark/mob_stock_point/Destroy()
	GLOB.mob_stock_points -= src
	return ..()
