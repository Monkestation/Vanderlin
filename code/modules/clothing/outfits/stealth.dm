
/obj/item/clothing/climbing_gear
	name = "climbing gear"
	desc = "Lets you do the impossible."
	color = null
	icon = 'icons/roguetown/clothing/storage.dmi'
	item_state = "climbing_gear" // sprites from lfwb kitbashed with grappler for inventory sprite
	icon_state = "climbing_gear" // sprites from lfwb kitbashed among each other for onmob sprite
	alternate_worn_layer = UNDER_CLOAK_LAYER
	inhand_mod = FALSE
	slot_flags = ITEM_SLOT_BACK

/obj/item/clothing/climbing_gear/equipped(mob/living/carbon/human/user, slot)
	. = ..()
	playsound(loc, 'sound/items/garrotegrab.ogg', 100, TRUE)

/obj/item/clothing/wall_grab
	name = "wall"
	item_state = "grabbing"
	icon_state = "grabbing"
	icon = 'icons/mob/roguehudgrabs.dmi'
	max_integrity = 10
	w_class = WEIGHT_CLASS_HUGE
	item_flags = ABSTRACT
	resistance_flags = INDESTRUCTIBLE | LAVA_PROOF | FIRE_PROOF | UNACIDABLE | ACID_PROOF
	no_effect = TRUE

/obj/item/clothing/wall_grab/dropped(mob/living/carbon/human/user)
	. = ..()
	if(QDELETED(src))
		return
	qdel(src)
	var/turf/openspace = user.loc
	openspace.zFall(user) // slop?

/obj/item/clothing/wall_grab/intercept_zImpact(atom/movable/AM, levels = 1) // with this shit it doesn't generate "X falls through open space". thank u guppyluxx
    . = ..()
    . |= FALL_NO_MESSAGE
