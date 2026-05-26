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

/// I would rather let powder interact with every container, but containers are fucked so
/obj/item/reagent_containers/glass/bottle/aflask/attackby(obj/item/attacking_item, mob/living/user, list/modifiers)
	. = ..()
	if(istype(attacking_item, /obj/item/reagent_containers/powder/blastpowder))
		if(reagents.holder_full())
			balloon_alert(user, "full!")
			return

		var/obj/item/reagent_containers/powder/blasting = attacking_item
		blasting.transfer_powder(src, blasting.reagents.total_volume, user = user)
		to_chat(user, span_notice("I refill [src] with blastpowder."))
