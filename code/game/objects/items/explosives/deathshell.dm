/obj/item/explosive/deathshell
	name = "Death Shell"
	desc = "A smooth shiny cylinder, bronze in color and material, with a styled indent on top that looks like a button. There is an archaic ticking noise inside, one which spells doom to all who dare defy the art of Malum.  Known as ´The Widow Maker´ among artificer social circles due to the inherent risk of crafting such explosives, often leading to traumatic amputations and death."
	icon_state = "deathshell"
	icon = 'icons/obj/bombs.dmi'
	w_class = WEIGHT_CLASS_NORMAL
	throwforce = 0
	slot_flags = ITEM_SLOT_HIP
	grid_height = 64
	grid_width = 32
	impact_explode = FALSE

	prob2fail = 25

	ex_dev = 1
	ex_heavy = 3
	ex_light = 2
	ex_flame = 1

	shrapnel_type = /obj/projectile/bullet/shrap
	shrapnel_radius = 5
	det_time = 10 SECONDS
