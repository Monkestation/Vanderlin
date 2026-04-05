/obj/item/ammo_casing/caseless/arrow
	name = "arrow"
	desc = "A fletched projectile, with simple plumes and metal tip."
	icon = 'icons/roguetown/weapons/ammo.dmi'
	icon_state = "arrow"
	possible_item_intents = list(DAGGER_THRUST)
	force = DAMAGE_KNIFE - 2
	dropshrink = 0.8
	max_integrity = 20
	embedding = list("embedded_pain_multiplier" = 3, "embedded_fall_chance" = 0)
	item_weight = 26 GRAMS

	projectile_type = /obj/projectile/bullet/reusable/arrow
	caliber = "arrow"
	firing_effect_type = null

/obj/item/ammo_casing/caseless/arrow/Initialize(mapload, ...)
	. = ..()
	AddElement(/datum/element/tipped_item, _max_reagents = 2, _dip_amount = 2, _attack_injects = FALSE)

/obj/item/ammo_casing/caseless/arrow/stone
	name = "stone arrow"
	desc = "A fletched projectile with a stone tip."
	icon_state = "stonearrow"
	projectile_type = /obj/projectile/bullet/reusable/arrow/stone //weaker projectile
	max_integrity = 5

/obj/item/ammo_casing/caseless/arrow/poison
	name = "poison arrow"
	desc = "An arrow with its tip coated in a weak poison."
	icon_state = "arrow_poison"

/obj/item/ammo_casing/caseless/arrow/poison/Initialize(mapload, ...)
	. = ..()
	reagents.add_reagent(/datum/reagent/berrypoison, 2)

/obj/item/ammo_casing/caseless/arrow/poison/potent
	desc = "An arrow with its tip coated in a potent poison."

/obj/item/ammo_casing/caseless/arrow/poison/potent/Initialize(mapload, ...)
	. = ..()
	reagents.add_reagent(/datum/reagent/strongpoison, 2)

/obj/projectile/bullet/reusable/arrow/spiced
	name = "spiced arrow"
	desc = "A profane arrow infused with spice."
	icon_state = "arrowspice_proj"

/obj/projectile/bullet/reusable/arrow/spiced/Initialize(mapload, ...)
	. = ..()
	reagents.add_reagent(/datum/reagent/druqks, 20)

/obj/item/ammo_casing/caseless/arrow/pyro
	name = "pyroclastic arrow"
	desc = "An arrow with its tip smeared with a flammable tincture."
	projectile_type = /obj/projectile/bullet/reusable/arrow/pyro
	icon_state = "arrow_pyroclastic"
	max_integrity = 10
	force = DAMAGE_KNIFE - 2

/obj/item/ammo_casing/caseless/arrow/pyro/Initialize(mapload, ...)
	. = ..()
	RemoveElement(/datum/element/tipped_item)
	qdel(reagents)

/obj/item/ammo_casing/caseless/arrow/vial
	abstract_type = /obj/item/ammo_casing/caseless/arrow/vial
	name = "vial arrow"
	desc = "An arrow with its tip replaced by a vial of... something, shatters on impact."
	icon_state = "arrow_vial"
	max_integrity = 10
	possible_item_intents = list(/datum/intent/hit)
	force = DAMAGE_KNIFE - 2
	var/datum/reagent/reagent

/obj/item/ammo_casing/caseless/arrow/vial/Initialize(mapload, ...)
	. = ..()
	RemoveElement(/datum/element/tipped_item)
	update_appearance(UPDATE_OVERLAYS)

/obj/item/ammo_casing/caseless/arrow/vial/update_overlays()
	. = ..()
	if(reagent)
		var/mutable_appearance/filling = mutable_appearance(icon, "[icon_state]_filling")
		filling.color = initial(reagent.color)
		. += filling

/obj/item/ammo_casing/caseless/arrow/vial/water
	projectile_type = /obj/projectile/bullet/reusable/arrow/vial/water
	reagent = /datum/reagent/water

/obj/item/ammo_casing/caseless/arrow/water
	name = "water arrow"
	desc = "An arrow with its tip replaced by a water crystal, creates a splash on impact."
	icon_state = "arrow_water"
	projectile_type = /obj/projectile/bullet/reusable/arrow/water
	max_integrity = 10
	force = DAMAGE_KNIFE - 2

/obj/item/ammo_casing/caseless/arrow/water/Initialize(mapload, ...)
	. = ..()
	RemoveElement(/datum/element/tipped_item)

/obj/item/ammo_casing/caseless/arrow/bone
	name = "bone arrow"
	desc = "A fletched projectile with a bone tip."
	icon_state = "bonearrow"
	projectile_type = /obj/projectile/bullet/reusable/arrow/bone //weaker projectile
	max_integrity = 15
