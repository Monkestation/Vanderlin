///so this is the most important step of the dungeon maker if you don't put these down right your gonna obliterate the dungeon
/obj/effect/dungeon_directional_helper
	name = "Dungeon Direction Helper"
	desc = "These help stitch together dungeons, it looks for the opposite direction on a template, basically write in the template if it has this, invis on creation"

	icon = 'icons/effects/dungeon_helper.dmi'
	icon_state = "helper"
	invisibility = INVISIBILITY_ABSTRACT
	mouse_opacity = MOUSE_OPACITY_TRANSPARENT

	var/top = FALSE

INITIALIZE_IMMEDIATE(/obj/effect/dungeon_directional_helper)

/obj/effect/dungeon_directional_helper/Initialize(mapload, ...)
	. = ..()
	var/turf/opposite_turf = get_step(get_turf(src), dir)

	if(!locate(/obj/effect/dungeon_directional_helper) in opposite_turf)
		SSdungeon_generator.markers |= src

	alpha = 0

/obj/effect/dungeon_directional_helper/Destroy(force)
	if(src in SSdungeon_generator.markers)
		SSdungeon_generator.markers -= src
	return ..()

/obj/effect/dungeon_directional_helper/south
	dir = SOUTH

/obj/effect/dungeon_directional_helper/north
	dir = NORTH

/obj/effect/dungeon_directional_helper/east
	dir = EAST

/obj/effect/dungeon_directional_helper/west
	dir = WEST

/obj/effect/dungeon_directional_helper/south/top
	dir = SOUTH
	top = TRUE

/obj/effect/dungeon_directional_helper/north/top
	dir = NORTH
	top = TRUE

/obj/effect/dungeon_directional_helper/east/top
	dir = EAST
	top = TRUE

/obj/effect/dungeon_directional_helper/west/top
	dir = WEST
	top = TRUE

