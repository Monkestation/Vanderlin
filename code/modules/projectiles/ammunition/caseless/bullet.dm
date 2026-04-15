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
