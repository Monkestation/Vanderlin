/obj/item/ammo_casing/caseless/bolt
	name = "bolt"
	desc = "A small and sturdy bolt, with simple plume and metal tip, alongside a groove to load onto a crossbow."
	icon = 'icons/roguetown/weapons/ammo.dmi'
	icon_state = "bolt"
	projectile_type = /obj/projectile/bullet/reusable/bolt
	possible_item_intents = list(DAGGER_THRUST)
	caliber = "bolt"
	dropshrink = 0.8
	max_integrity = 10
	force = DAMAGE_KNIFE - 2
	embedding = list("embedded_pain_multiplier" = 3, "embedded_fall_chance" = 0)
	item_weight = 35 GRAMS

	firing_effect_type = null

/obj/item/ammo_casing/caseless/bolt/Initialize(mapload, ...)
	. = ..()
	AddElement(/datum/element/tipped_item, _max_reagents = 2, _dip_amount = 2, _attack_injects = FALSE)

/obj/item/ammo_casing/caseless/bolt/poison
	name = "poison bolt"
	desc = "A bolt coated with a weak poison."
	icon_state = "bolt_poison"

/obj/item/ammo_casing/caseless/bolt/poison/Initialize(mapload, ...)
	. = ..()
	reagents.add_reagent(/datum/reagent/berrypoison, 2)

/obj/item/ammo_casing/caseless/bolt/poison/potent
	desc = "A bolt coated with a potent poison."

/obj/item/ammo_casing/caseless/bolt/poison/potent/Initialize(mapload, ...)
	. = ..()
	reagents.add_reagent(/datum/reagent/strongpoison, 2)

/obj/item/ammo_casing/caseless/bolt/pyro
	name = "pyroclastic bolt"
	desc = "A bolt smeared with a flammable tincture."
	icon_state = "bolt_pyroclastic"
	projectile_type = /obj/projectile/bullet/reusable/bolt/pyro

/obj/item/ammo_casing/caseless/bolt/pyro/Initialize(mapload, ...)
	. = ..()
	RemoveElement(/datum/element/tipped_item)
	qdel(reagents)

/obj/item/ammo_casing/caseless/bolt/holy
	name = "sunderbolt"
	desc = "A silver-tipped bolt, containing a small vial of holy water. Though it inflicts lesser wounds on living flesh, it exceeds when employed against the unholy; a snap and a crack, followed by a fiery surprise. </br>'One baptism for the remission of sins.'"
	icon_state = "bolt_holywater"
	projectile_type = /obj/projectile/bullet/reusable/bolt/holy

/obj/item/ammo_casing/caseless/bolt/holy/Initialize()
	. = ..()
	reagents.add_reagent(/datum/reagent/water/blessed, 5)
