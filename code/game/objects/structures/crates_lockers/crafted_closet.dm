/obj/structure/closet/crate/crafted_closet
	name = "closet"
	desc = ""
	icon = 'icons/roguetown/misc/structure.dmi'
	base_icon_state = "closet"
	icon_state = "closet"
	drag_slowdown = 4
	horizontal = FALSE
	allow_dense = FALSE
	open_sound = 'sound/foley/doors/creak.ogg'
	close_sound = 'sound/foley/latch.ogg'
	max_integrity = 200
	blade_dulling = DULLING_BASHCHOP
	dense_when_open = FALSE
	mob_storage_capacity = 2

/obj/structure/closet/crate/crafted_closet/inn/south
	base_icon_state = "closet3"
	icon_state = "closet3"
	dir = SOUTH
	SET_BASE_PIXEL(0, 16)

/obj/structure/closet/crate/crafted_closet/inn
	base_icon_state = "closet3"
	icon_state = "closet3"

/obj/structure/closet/crate/crafted_closet/inn/chest
	base_icon_state = "woodchest"
	icon_state = "woodchest"

/obj/structure/closet/crate/crafted_closet/dark
	base_icon_state = "closetdark"
	icon_state = "closetdark"

/obj/structure/closet/crate/crafted_closet/lord
	lock = /datum/lock/key/lord
	base_icon_state = "closetlord"
	icon_state = "closetlord"

/obj/structure/closet/crate/crafted_closet/atarms
	lock = /datum/lock/key/atarms
	base_icon_state = "closetdark"
	icon_state = "closetdark"

/obj/structure/closet/crate/crafted_closet/steward
	lock = /datum/lock/key/steward
	base_icon_state = "closetdark"
	icon_state = "closetdark"
