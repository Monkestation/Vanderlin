/obj/projectile/bullet/shrap
	name = "lead fragment"
	icon = 'icons/obj/shards.dmi'
	icon_state = "small"
	damage = 45
	damage_type = BRUTE
	woundclass = BCLASS_SHOT
	range = 5
	impact_effect_type = /obj/effect/temp_visual/impact_effect
	flag =  "piercing"
	speed = 0.8
	reduce_crit_chance = 7

/obj/item/ammo_casing/caseless/grenadeshell
	name = "Grenade Shell"
	desc = "A metal tube with a tight screw cap and slots for shrapnel."
	icon_state = "grenade_shell"
	icon = 'icons/obj/bombs.dmi'
	w_class = WEIGHT_CLASS_NORMAL
	throwforce = 0
	slot_flags = ITEM_SLOT_HIP
	grid_height = 64
	grid_width = 32

/obj/item/explosive/canister_bomb
	name = "Canister Bomb"
	desc = "A professional Grenzelhoftan explosive, filled with lead shrapnel and sticky blastpowder. This specific grenade design was recently declassified, being left over from the first Grenzelhoft-Rosewood war."
	icon_state = "canbomb"
	icon = 'icons/obj/bombs.dmi'
	w_class = WEIGHT_CLASS_NORMAL
	throwforce = 0
	slot_flags = ITEM_SLOT_HIP
	grid_height = 64
	grid_width = 32
	impact_explode = FALSE

	prob2fail = 5

	ex_dev = 1
	ex_heavy = 3
	ex_light = 2
	ex_flame = 1

	shrapnel_type = /obj/projectile/bullet/shrap
	shrapnel_radius = 5
	det_time = 10 SECONDS
