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
	item_weight = 1.2 KILOGRAMS

	possible_item_intents = list(/datum/intent/shoot/puffer, /datum/intent/shoot/puffer/arc, INTENT_GENERIC)
	force = 10

	projectile_damage_multiplier = 1.625
	recoil = 8
	randomspread = 2
	spread = 3

/obj/item/gun/ballistic/powder/wheellock/puffer/conjured
	name = "puffer"
	desc = "A magically conjured copy of a eastern styled wheellock. \
		It looks and functions exactly like the original, but seems to be held together by weak magick, it looks like it will crumble at any moment."

	sellprice = 0 //Yeah, Let's not sell this.

	spawn_magazine_type = /obj/item/ammo_box/magazine/internal/barrel

	ramrod_type = null

	cocked = TRUE
	wound = TRUE
	bullet_rammed = TRUE

	var/breaking = FALSE

/obj/item/gun/ballistic/powder/wheellock/puffer/conjured/Initialize(mapload)
	. = ..()
	reagents.add_reagent(/datum/reagent/blastpowder, powder_required)

/obj/item/gun/ballistic/powder/wheellock/puffer/conjured/can_shoot(mob/living/user)
	. = ..()
	return (. && !breaking)

/obj/item/gun/ballistic/powder/wheellock/puffer/conjured/after_firing(atom/target, mob/living/user, empty_chamber, from_firing, chamber_next_round)
	. = ..()
	if(!from_firing)
		return

	if(breaking)
		return

	QDEL_IN(src, rand(2 SECONDS, 5 SECONDS)) //Apparently, a puffer being broken can still be shot, because that make sense. so we're qdel'ing it right after.
	visible_message(span_warning("The puffer begins to crumble, the enchantment falls!"))
	breaking = TRUE
