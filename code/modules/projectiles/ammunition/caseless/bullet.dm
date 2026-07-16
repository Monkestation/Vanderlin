/obj/item/ammo_casing/caseless/bullet
	name = "lead ball"
	desc = "A round lead shot, simple and spherical."
	projectile_type = /obj/projectile/bullet/reusable/bullet
	caliber = "musketball"
	icon = 'icons/roguetown/weapons/ammo.dmi'
	icon_state = "musketball"
	dropshrink = 0.5
	possible_item_intents = list(INTENT_USE)
	force = DAMAGE_KNIFE - 7
	item_weight = 75 GRAMS

/obj/item/ammo_casing/caseless/pelletshot
	name = "pelletshot"
	desc = "A handful of pellet shots, made to punch many holes into a packed bunch of enemies."
	icon = 'icons/roguetown/weapons/ammo.dmi'
	icon_state = "pellets"
	projectile_type = /obj/projectile/bullet/pellet
	caliber = "blundershot" //shotgun variant of lead balls essentially
	dropshrink = 0.5
	possible_item_intents = list(INTENT_USE)
	pellets = 6
	variance = 10
	randomspread = TRUE

	force = DAMAGE_KNIFE - 7
	item_weight = 75 GRAMS

/obj/item/ammo_casing/caseless/pelletshot/coin
	var/coin_type = null

/obj/item/ammo_casing/caseless/pelletshot/coin/examine(mob/user)
	. = ..()
	. += span_info("It looks like you could rig this back up to regular coins.")

/obj/item/ammo_casing/caseless/pelletshot/coin/attack_self_secondary(mob/user, list/modifiers)
	. = ..()
	if(!coin_type)
		return
	if(!do_after(user, 3 SECONDS, src))
		to_chat(user, span_warning("You stop rigging back [src]."))
		return SECONDARY_ATTACK_CANCEL_ATTACK_CHAIN
	var/obj/item/coin/coin_new = new coin_type(get_turf(src))
	coin_new.set_quantity(pellets)
	user.equip_to_slot_if_possible(coin_new, ITEM_SLOT_HANDS)
	qdel(src)
	return SECONDARY_ATTACK_CANCEL_ATTACK_CHAIN

/obj/item/ammo_casing/caseless/pelletshot/coin/zenar
	name = "zenarshot"
	desc = "A handful of pellet shots out of zenars, made to punch many holes into a packed bunch of enemies."
	icon_state = "pellets_zenar"
	projectile_type = /obj/projectile/bullet/pellet/zenar
	coin_type = /obj/item/coin/gold

/obj/item/ammo_casing/caseless/pelletshot/coin/zil
	name = "zilshot"
	desc = "A handful of pellet shots out of zils, made to punch many holes into a packed bunch of enemies."
	icon_state = "pellets_zenarii"
	projectile_type = /obj/projectile/bullet/pellet/zil
	coin_type = /obj/item/coin/silver

/obj/item/ammo_casing/caseless/pelletshot/coin/zenny
	name = "zennyshot"
	desc = "A handful of pellet shots out of zennies, made to punch many holes into a packed bunch of enemies."
	icon_state = "pellets_zenny"
	projectile_type = /obj/projectile/bullet/pellet/zenny
	coin_type = /obj/item/coin/copper

/obj/item/ammo_casing/caseless/pelletshot/glass
	name = "glasshot"
	desc = "A handful of pellet shots out of glass shards, made to bleed a packed bunch of enemies."
	icon_state = "pellets_shard"
	projectile_type = /obj/projectile/bullet/pellet/glass
	pellets = 9

/obj/item/ammo_casing/caseless/pelletshot/salt
	name = "saltshot"
	desc = "A handful of pellet shots out of salt, made to incapacitate a packed bunch of enemies."
	icon_state = "pellets_salt"
	projectile_type = /obj/projectile/bullet/pellet/salt
	pellets = 9

/obj/item/ammo_casing/caseless/cball
	name = "large cannonball"
	desc = "A round lead ball. Complex and still spherical."
	icon = 'icons/roguetown/weapons/ammo.dmi'
	icon_state = "cannonball"
	projectile_type = /obj/projectile/bullet/reusable/cannonball
	caliber = "cannoball"
	possible_item_intents = list(INTENT_USE)
	max_integrity = 1
	randomspread = 0
	variance = 0
	force = DAMAGE_KNIFE
	item_weight = 70
	grid_width = 96
	grid_height = 96
	w_class = WEIGHT_CLASS_HUGE
	resistance_flags = EVERYTHING_PROOF | EXPLOSION_MOVE_PROOF
	throw_range = 1
	item_weight = 70 KILOGRAMS

/obj/item/ammo_casing/caseless/cball/grapeshot
	name = "berryshot"
	desc = "A large pouch of smaller lead balls. Not as complex and not as spherical."
	icon_state = "grapeshot" // NEEDS SPRITE
	dropshrink = 0.5
	projectile_type = /obj/projectile/bullet/fragment
