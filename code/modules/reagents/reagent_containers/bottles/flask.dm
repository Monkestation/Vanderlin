/obj/item/reagent_containers/glass/bottle/aflask
	name = "alchemical flask"
	desc = "A small metal flask used for the secure storing of alchemical powders."
	icon = 'icons/roguetown/items/cooking.dmi'
	icon_state = "aflask"
	list_reagents = list(/datum/reagent/blastpowder = 30)
	can_label_container = FALSE

/obj/item/reagent_containers/glass/bottle/aflask/Initialize()
	. = ..()
	icon_state = "aflask"
