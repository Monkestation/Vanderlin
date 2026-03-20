/// Specifically a wheel-lock pistol requiring both cocking and winding
/obj/item/gun/ballistic/powder/wheellock/puffer
	name = "puffer"
	desc = "A result of Dwarven and Humen cooperation on the Eastern continent. It uses alchemical blastpowder to propel metal balls for devastating effect."
	icon = 'icons/roguetown/weapons/32/guns.dmi'
	lefthand_file = 'icons/mob/inhands/weapons/guns_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/weapons/guns_righthand.dmi'
	icon_state = "puffer"
	base_icon_state = "puffer"
	item_state = "puffer"
	grid_height = 32
	grid_width = 96
	dropshrink = 0.7
	sellprice = 200

	possible_item_intents = list(/datum/intent/shoot/puffer, /datum/intent/shoot/puffer/arc, INTENT_GENERIC)
	force = 10

	projectile_damage_multiplier = 1.625
	recoil = 8
	randomspread = 2
	spread = 3

/obj/item/gun/ballistic/powder/wheellock/puffer/conjured
	sellprice = 0 //Yeah, Let's not sell this.

	spawn_magazine_type = /obj/item/ammo_box/magazine/internal/barrel

	ramrod_type = null
	cocked = TRUE
	wound = TRUE
	bullet_rammed = TRUE

/obj/item/gun/ballistic/powder/wheellock/puffer/conjured/Initialize(mapload)
	. = ..()
	reagents.add_reagent(/datum/reagent/blastpowder, powder_required)
