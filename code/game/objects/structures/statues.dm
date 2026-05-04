/obj/structure/statue
	name = "statue"
	desc = ""
	icon = 'icons/obj/statue.dmi'
	icon_state = ""
	density = TRUE
	anchored = FALSE
	max_integrity = 100
	var/oreAmount = 5
	var/material_drop_type
	var/impressiveness = 15
	CanAtmosPass = ATMOS_PASS_DENSITY
	var/art_type = /datum/component/art

/obj/structure/statue/Initialize()
	. = ..()
	AddComponent(art_type, impressiveness)
	addtimer(CALLBACK(src, TYPE_PROC_REF(/datum, _AddComponent), list(/datum/component/beauty, impressiveness *  75)), 0)

/obj/structure/statue/atom_deconstruct(disassembled)
	if(material_drop_type)
		var/drop_amt = oreAmount
		if(!disassembled)
			drop_amt -= 2
		if(drop_amt > 0)
			new material_drop_type(loc, drop_amt)

//******Decoration objects
//***Bone statues and giant skeleton parts.
/obj/structure/statue/bone
	anchored = TRUE
	max_integrity = 120
	impressiveness = 18 // Carved from the bones of a massive creature, it's going to be a specticle to say the least
	layer = ABOVE_ALL_MOB_LAYER

/obj/structure/statue/bone/rib
	name = "collosal rib"
	desc = ""
	oreAmount = 4
	icon = 'icons/obj/statuelarge.dmi'
	icon_state = "rib"

/obj/structure/statue/bone/skull
	name = "collosal skull"
	desc = ""
	oreAmount = 12
	icon = 'icons/obj/statuelarge.dmi'
	icon_state = "skull"

/obj/structure/statue/bone/skull/half
	desc = ""
	oreAmount = 6
	icon = 'icons/obj/statuelarge.dmi'
	icon_state = "skull-half"
