/obj/item/explosive/time_bomb
	name = "Time Bomb"
	desc = "Three canister bombs tied together with a long fuse, perfect for hiding in elven luggage. The length of the fuse should provide around 5 minutes of time before detonation."
	icon_state = "timebomb"
	icon = 'icons/obj/bombs.dmi'
	w_class = WEIGHT_CLASS_NORMAL
	throwforce = 0
	slot_flags = ITEM_SLOT_HIP
	grid_height = 96
	grid_width = 96
	impact_explode = FALSE

	prob2fail = 20

	ex_dev = 2
	ex_heavy = 3
	ex_light = 5
	ex_flame = 4

	det_time = 300 SECONDS
