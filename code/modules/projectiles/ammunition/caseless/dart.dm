/obj/item/ammo_casing/caseless/dart
	name = "dart"
	desc = "A thorn fashioned into a primitive dart."
	projectile_type = /obj/projectile/bullet/reusable/dart
	icon = 'icons/roguetown/weapons/ammo.dmi'
	icon_state = "dart"
	caliber = "dart"
	dropshrink = 0.9
	max_integrity = 10
	force = DAMAGE_KNIFE / 2
	item_weight = 15 GRAMS

	firing_effect_type = null

/obj/item/ammo_casing/caseless/dart/Initialize(mapload, ...)
	. = ..()
	AddElement(/datum/element/tipped_item, _max_reagents = 3, _dip_amount = 3, _attack_injects = FALSE)

/obj/item/ammo_casing/caseless/dart/poison
	name = "poison dart"
	desc = "A dart with its tip coated in a weak poison."
	icon_state = "dart_poison"
	projectile_type = /obj/projectile/bullet/reusable/dart/poison

/obj/item/ammo_casing/caseless/dart/poison/Initialize(mapload, ...)
	. = ..()
	reagents.add_reagent(/datum/reagent/berrypoison, 3)
