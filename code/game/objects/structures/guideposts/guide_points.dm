/// Global map of waypoint_id = /obj/effect/landmark/waypoint_target
GLOBAL_LIST_EMPTY(waypoint_targets)

/obj/effect/landmark/waypoint_target
	name = "waypoint target"
	desc = "Destination marker for wayfinding signs."
	icon = 'icons/turf/debug.dmi'
	icon_state = "end"
	invisibility = INVISIBILITY_ABSTRACT
	anchored = TRUE
	/// Unique string identifier for waypost lookups
	var/waypoint_id

/obj/effect/landmark/waypoint_target/Initialize(mapload)
	. = ..()
	if(waypoint_id)
		GLOB.waypoint_targets[waypoint_id] = src

/obj/effect/landmark/waypoint_target/Destroy(force)
	if(waypoint_id && GLOB.waypoint_targets[waypoint_id] == src)
		GLOB.waypoint_targets -= waypoint_id
	return ..()

/obj/effect/landmark/waypoint_target/smithy
	name = "Smithy"
	waypoint_id = "smithy"
	icon = 'icons/roguetown/misc/decoration.dmi'
	icon_state = "shopsign_weaponsmith_left"

/obj/effect/landmark/waypoint_target/clinic
	name = "Clinic"
	waypoint_id = "clinic"
	icon = 'icons/roguetown/misc/decoration.dmi'
	icon_state = "feldsher"

/obj/effect/landmark/waypoint_target/apoth
	name = "Apothecary"
	waypoint_id = "apothecary"
	icon = 'icons/roguetown/misc/decoration.dmi'
	icon_state = "shopsign_apothecary_right"

/obj/effect/landmark/waypoint_target/tailor
	name = "Tailor"
	waypoint_id = "tailor"
	icon = 'icons/roguetown/misc/decoration.dmi'
	icon_state = "shopsign_tailor_left"

/obj/effect/landmark/waypoint_target/inn
	name = "Drunken Saiga"
	waypoint_id = "inn"
	icon = 'icons/roguetown/misc/decoration.dmi'
	icon_state = "shopsign_inn_saiga_left"

/obj/effect/landmark/waypoint_target/merchant
	name = "Merchant"
	waypoint_id = "merchant"
	icon = 'icons/roguetown/misc/decoration.dmi'
	icon_state = "shopsign_merchant_left"

/obj/effect/landmark/waypoint_target/mage
	name = "Mage's Guild"
	waypoint_id = "mage"
	icon = 'icons/roguetown/misc/decoration.dmi'
	icon_state = "moon"
