/obj/item/natural/clod/dirt
	name = "clod"
	desc = "A handful of sod."
	icon_state = "clod1"
	pile = /obj/structure/fluff/clodpile/dirt
	clod_type = "dirt"

/obj/item/natural/clod/dirt/Initialize()
	. = ..()
	icon_state = "clod[rand(1,2)]"

/obj/structure/fluff/clodpile/dirt
	name = "dirt pile"
	desc = "A collection of dirt, amalgamated into a mighty structure incomparable to any creation made by man or god alike."
	icon_state = "clodpile"
	dirt_type = /obj/item/natural/clod/dirt
