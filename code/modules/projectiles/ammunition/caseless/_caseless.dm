/obj/item/ammo_casing/caseless
	abstract_type = /obj/item/ammo_casing/caseless
	name = "caseless round"

/obj/item/ammo_casing/caseless/fire_casing(atom/target, mob/living/user, modifiers, distro, quiet, zone_override, spread, atom/fired_from)
	. = ..()

	if(isgun(fired_from))
		var/obj/item/gun/shot_from = fired_from
		if(shot_from.chambered == src)
			shot_from.chambered = null //Nuke it. Nuke it now.

	qdel(src)
