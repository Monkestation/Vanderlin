/turf/closed/wall/mineral/stone
	name = "stone wall"
	desc = "A wall of smooth, unyielding stone."
	icon = 'icons/turf/smooth/walls/stone.dmi'
	icon_state = MAP_SWITCH("stone", "stone-0")
	blade_dulling = DULLING_BASH
	max_integrity = 1200
	sheet_type = /obj/item/natural/stone
	break_sound = 'sound/combat/hits/onstone/stonedeath.ogg'
	attacked_sound = list('sound/combat/hits/onstone/wallhit.ogg', 'sound/combat/hits/onstone/wallhit2.ogg', 'sound/combat/hits/onstone/wallhit3.ogg')
	smoothing_flags = SMOOTH_BITMASK
	smoothing_groups = SMOOTH_GROUP_CLOSED_WALL + SMOOTH_GROUP_WALLS_STONE
	smoothing_list = SMOOTH_GROUP_DOOR_SECRET + SMOOTH_GROUP_WALLS_STONE
	above_floor = /turf/open/floor/blocks
	baseturfs = /turf/open/floor/blocks
	neighborlay = "dirtedge"
	climbdiff = 1
	damage_deflection = 10
	hardness = 3

/turf/closed/wall/mineral/stone/window
	name = "stone murder hole"
	desc = "A wall of stone with convenient small indents on it, perfect to let loose arrows against invaders."
	icon = MAP_SWITCH('icons/turf/smooth/walls/stone.dmi', 'icons/turf/window.dmi')
	icon_state = "stone"
	opacity = FALSE
	max_integrity = 800
	explosion_block = 2
	pass_flags_self = PASSGRILLE|LETPASSTHROW|NOTLETPASSTHROWNMOB

/turf/closed/wall/mineral/stone/window/Initialize()
	. = ..()
	var/mutable_appearance/M = mutable_appearance('icons/turf/window.dmi', "stonehole", layer = ABOVE_NORMAL_TURF_LAYER)
	add_overlay(M)

/turf/closed/wall/mineral/stone/moss
	icon = 'icons/turf/smooth/walls/stone_moss.dmi'
	climbdiff = 4

/turf/closed/wall/mineral/stone/window/moss
	icon = MAP_SWITCH('icons/turf/smooth/walls/stone_moss.dmi', 'icons/turf/window.dmi')
	icon_state = MAP_SWITCH("stone", "stone_moss")
	climbdiff = 4

/turf/closed/wall/mineral/stone/moss/blue
	icon = 'icons/turf/smooth/walls/stone_moss_blue.dmi'

/turf/closed/wall/mineral/stone/window/moss/blue
	icon = MAP_SWITCH('icons/turf/smooth/walls/stone_moss_blue.dmi', 'icons/turf/window.dmi')
	icon_state = MAP_SWITCH("stone", "stone_moss_blue")

/turf/closed/wall/mineral/stone/moss/red
	icon = 'icons/turf/smooth/walls/stone_moss_red.dmi'

/turf/closed/wall/mineral/stone/window/moss/red
	icon = MAP_SWITCH('icons/turf/smooth/walls/stone_moss_red.dmi', 'icons/turf/window.dmi')
	icon_state = MAP_SWITCH("stone", "stone_moss_red")

/turf/closed/wall/mineral/decorstone
	name = "decorated stone wall"
	desc = "The mason did an excellent job etching details into this wall."
	icon = 'icons/turf/smooth/walls/stone_deco.dmi'
	icon_state = MAP_SWITCH("stone_deco", "stone_deco-0")
	blade_dulling = DULLING_BASH
	max_integrity = 2200
	sheet_type = /obj/item/natural/stone
	break_sound = 'sound/combat/hits/onstone/stonedeath.ogg'
	attacked_sound = list('sound/combat/hits/onstone/wallhit.ogg', 'sound/combat/hits/onstone/wallhit2.ogg', 'sound/combat/hits/onstone/wallhit3.ogg')
	smoothing_flags = SMOOTH_BITMASK_CARDINALS
	smoothing_groups = SMOOTH_GROUP_CLOSED_WALL + SMOOTH_GROUP_WALLS_STONE_DECO
	smoothing_list = SMOOTH_GROUP_DOOR_SECRET + SMOOTH_GROUP_WALLS_STONE_DECO
	above_floor = /turf/open/floor/blocks
	baseturfs = /turf/open/floor/blocks
	neighborlay = "dirtedge"
	climbdiff = 1
	damage_deflection = 10
	hardness = 2

/turf/closed/wall/mineral/decorstone/window
	name = "stone murder hole"
	desc = "A wall of decorated stone with convenient small indents on it, perfect to let loose arrows against invaders."
	icon = MAP_SWITCH('icons/turf/smooth/walls/stone_deco.dmi', 'icons/turf/window.dmi')
	icon_state = "stone_deco"
	opacity = FALSE
	max_integrity = 1800
	explosion_block = 2
	pass_flags_self = PASSGRILLE|LETPASSTHROW|NOTLETPASSTHROWNMOB

/turf/closed/wall/mineral/decorstone/window/Initialize()
	. = ..()
	var/mutable_appearance/M = mutable_appearance('icons/turf/window.dmi', "stonehole", layer = ABOVE_NORMAL_TURF_LAYER)
	add_overlay(M)

/turf/closed/wall/mineral/decorstone/moss
	icon = 'icons/turf/smooth/walls/stone_d_moss.dmi'

/turf/closed/wall/mineral/decorstone/moss/blue
	icon = 'icons/turf/smooth/walls/stone_d_moss_b.dmi'

/turf/closed/wall/mineral/decorstone/moss/red
	icon = 'icons/turf/smooth/walls/stone_d_moss_r.dmi'

/turf/closed/wall/mineral/craftstone
	name = "craftstone wall"
	desc = "A durable wall made from specially crafted stone."
	icon = 'icons/turf/smooth/walls/stone_fancy.dmi'
	icon_state = MAP_SWITCH("craftstone", "craftstone-0")
	blade_dulling = DULLING_BASH
	max_integrity = 2200
	sheet_type = /obj/item/natural/stone
	break_sound = 'sound/combat/hits/onstone/stonedeath.ogg'
	attacked_sound = list('sound/combat/hits/onstone/wallhit.ogg', 'sound/combat/hits/onstone/wallhit2.ogg', 'sound/combat/hits/onstone/wallhit3.ogg')
	smoothing_flags = SMOOTH_BITMASK
	smoothing_groups = SMOOTH_GROUP_CLOSED_WALL + SMOOTH_GROUP_WALLS_STONE_CRAFT
	smoothing_list = SMOOTH_GROUP_DOOR_SECRET + SMOOTH_GROUP_WALLS_STONE_CRAFT
	above_floor = /turf/open/floor/blocks
	baseturfs = /turf/open/floor/blocks
	neighborlay = "dirtedge"
	climbdiff = 1
	damage_deflection = 10

/turf/closed/wall/mineral/stonebrick
	name = "brick wall"
	desc = "Several rows of bricks form this wall."
	icon = 'icons/turf/smooth/walls/stone_brick.dmi'
	icon_state = MAP_SWITCH("stone_brick", "stone_brick-0")

	wallclimb = FALSE
	blade_dulling = DULLING_BASH
	max_integrity = 1500
	sheet_type = /obj/item/natural/stone
	break_sound = 'sound/combat/hits/onstone/stonedeath.ogg'
	attacked_sound = list('sound/combat/hits/onstone/wallhit.ogg', 'sound/combat/hits/onstone/wallhit2.ogg', 'sound/combat/hits/onstone/wallhit3.ogg')
	smoothing_flags = SMOOTH_BITMASK
	smoothing_groups = SMOOTH_GROUP_CLOSED_WALL + SMOOTH_GROUP_WALLS_STONE_BRICK
	smoothing_list = SMOOTH_GROUP_DOOR_SECRET + SMOOTH_GROUP_WALLS_STONE_BRICK
	above_floor = /turf/open/floor/blocks
	baseturfs = /turf/open/floor/blocks
	neighborlay = "dirtedge"
	climbdiff = 4
	damage_deflection = 20
	hardness = 2

/*	..................   Red brick Walls   ................... */
/turf/closed/wall/mineral/stonebrick/reddish
	color = "#e0b7af"

/turf/closed/wall/mineral/decostone/fluffstone/reddish
	color = "#fbc5bc"

/turf/closed/wall/mineral/decostone/cand/reddish
	color = "#fbd2cb"

/obj/structure/stairs/stone/reddish
	color = "#ffddd7"

/turf/closed/wall/mineral/wood
	name = "wooden wall"
	desc = "A rough-hewn wall of wood."
	icon = 'icons/turf/smooth/walls/wood.dmi'
	icon_state = MAP_SWITCH("wood", "wood-0")
	blade_dulling = DULLING_BASHCHOP
	max_integrity = 1100
	break_sound = 'sound/combat/hits/onwood/destroywalldoor.ogg'
	attacked_sound = list('sound/combat/hits/onwood/woodimpact (1).ogg','sound/combat/hits/onwood/woodimpact (2).ogg')
	smoothing_flags = SMOOTH_BITMASK
	smoothing_groups = SMOOTH_GROUP_CLOSED_WALL + SMOOTH_GROUP_WALLS_WOOD
	smoothing_list = SMOOTH_GROUP_DOOR_SECRET + SMOOTH_GROUP_WALLS_WOOD
	neighborlay = "dirtedge"
	above_floor = /turf/open/floor/ruinedwood
	baseturfs = /turf/open/floor/ruinedwood
	climbdiff = 3
	explosion_block = 4
	hardness = 7

	burn_power = 100
	spread_chance = 1.8

/turf/closed/wall/mineral/wood/window
	name = "wooden window"
	desc = "A window with a rough-hewn wooden frame."
	icon = MAP_SWITCH('icons/turf/smooth/walls/wood.dmi', 'icons/turf/window.dmi')
	icon_state = "wood"
	opacity = FALSE
	max_integrity = 550
	pass_flags_self = PASSTABLE|PASSGRILLE

/turf/closed/wall/mineral/wood/window/Initialize()
	. = ..()
	var/mutable_appearance/M = mutable_appearance('icons/turf/window.dmi', "woodhole", layer = ABOVE_NORMAL_TURF_LAYER)
	add_overlay(M)

/turf/closed/wall/mineral/tent
	name = "tent"
	desc = "Made from durable fabric and wooden branches."
	icon = 'icons/turf/walls.dmi'
	icon_state = "tent"
	blade_dulling = DULLING_BASHCHOP
	max_integrity = 300
	break_sound = 'sound/combat/hits/onwood/destroywalldoor.ogg'
	attacked_sound = list('sound/combat/hits/onwood/woodimpact (1).ogg','sound/combat/hits/onwood/woodimpact (2).ogg')
	above_floor = /turf/open/floor/twig
	baseturfs = /turf/open/floor/twig
	neighborlay = "dirtedge"
	climbdiff = 1
	explosion_block = 0
	hardness = 70

	burn_power = 100
	spread_chance = 1.8


/turf/closed/wall/mineral/tent/OnCrafted(dirin, mob/user)
	dir = dirin
	return ..()

/turf/closed/wall/mineral/wooddark
	name = "dark wood wall"
	desc = "Made from durable, somewhat darker wood."
	icon = 'icons/turf/walls.dmi'
	icon_state = "corner"
	blade_dulling = DULLING_BASHCHOP
	max_integrity = 1500
	break_sound = 'sound/combat/hits/onwood/destroywalldoor.ogg'
	attacked_sound = list('sound/combat/hits/onwood/woodimpact (1).ogg','sound/combat/hits/onwood/woodimpact (2).ogg')
	above_floor = /turf/open/floor/ruinedwood
	baseturfs = /turf/open/floor/ruinedwood
	neighborlay = "dirtedge"
	climbdiff = 3
	explosion_block = 4
	hardness = 7
	burn_power = 100
	spread_chance = 1.8

/turf/closed/wall/mineral/wooddark/OnCrafted(dirin, mob/user)
	if(dirin == NORTH || dirin == SOUTH)
		icon_state = "vertwooddark"
	else
		icon_state = "horizwooddark"
	. = ..()

/turf/closed/wall/mineral/wooddark/horizontal
	icon_state = "horizwooddark"

/turf/closed/wall/mineral/wooddark/vertical
	icon_state = "vertwooddark"

/turf/closed/wall/mineral/wooddark/end
	icon_state = "endwooddark"

/turf/closed/wall/mineral/wooddark/slitted
	icon_state = "slittedwooddark"

/turf/closed/wall/mineral/wooddark/window
	name = "dark wood window"
	icon_state = "subwindow"
	opacity = FALSE
	explosion_block = 1
	pass_flags_self = PASSTABLE|PASSGRILLE

/turf/closed/wall/mineral/wooddark/window/OnCrafted(dirin, mob/user)
	SHOULD_CALL_PARENT(FALSE)
	SEND_SIGNAL(user, COMSIG_ITEM_CRAFTED, user, type)
	record_featured_stat(FEATURED_STATS_CRAFTERS, user)
	record_featured_object_stat(FEATURED_STATS_CRAFTED_ITEMS, name)
	add_abstract_elastic_data(ELASCAT_CRAFTING, "[name]", 1)
	return

/turf/closed/wall/mineral/roofwall
	name = "wall"
	icon = 'icons/turf/walls.dmi'
	icon_state = ""
	blade_dulling = DULLING_BASHCHOP
	max_integrity = 1100
	break_sound = 'sound/combat/hits/onwood/destroywalldoor.ogg'
	attacked_sound = list('sound/combat/hits/onwood/woodimpact (1).ogg','sound/combat/hits/onwood/woodimpact (2).ogg')
	above_floor = /turf/open/floor/rooftop
	baseturfs = /turf/open/floor/ruinedwood
	neighborlay = "dirtedge"
	climbdiff = 3
	hardness = 7

	burn_power = 100
	spread_chance = 1.4


/turf/closed/wall/mineral/roofwall/center
	icon_state = "roofTurf_I"

/turf/closed/wall/mineral/roofwall/middle
	icon_state = "roofTurf_M"

/turf/closed/wall/mineral/roofwall/outercorner
	icon_state = "roofTurf_OC"

/turf/closed/wall/mineral/roofwall/innercorner
	icon_state = "roofTurf_IC"

/turf/closed/wall/mineral/decowood
	name = "daub wall"
	desc = "A wattle and daub wall."
	icon = 'icons/turf/walls.dmi'
	icon_state = "decowood"
	blade_dulling = DULLING_BASHCHOP
	max_integrity = 900
	break_sound = 'sound/combat/hits/onwood/destroywalldoor.ogg'
	attacked_sound = list('sound/combat/hits/onwood/woodimpact (1).ogg','sound/combat/hits/onwood/woodimpact (2).ogg')
//	sheet_type = /obj/item/grown/log/tree/lumber
	above_floor = /turf/open/floor/ruinedwood
	baseturfs = /turf/open/floor/ruinedwood
	neighborlay = "dirtedge"
	climbdiff = 3
	explosion_block = 4
	hardness = 7

	burn_power = 100
	spread_chance = 1.8

/turf/closed/wall/mineral/decowood/Initialize()
	. = ..()
	dir = pick(GLOB.cardinals)

/turf/closed/wall/mineral/decowood/vert
	icon_state = "decowood-vert"

/turf/closed/wall/mineral/decostone
	name = "decorated stone wall"
	desc = "The mason did an excellent job etching details into this wall."
	icon = 'icons/turf/walls.dmi'
	icon_state = "decostone-b"
	wallclimb = FALSE
	blade_dulling = DULLING_BASH
	max_integrity = 2200
	sheet_type = /obj/item/natural/stone
	break_sound = 'sound/combat/hits/onstone/stonedeath.ogg'
	attacked_sound = list('sound/combat/hits/onstone/wallhit.ogg', 'sound/combat/hits/onstone/wallhit2.ogg', 'sound/combat/hits/onstone/wallhit3.ogg')
	above_floor = /turf/open/floor/blocks
	baseturfs = /turf/open/floor/blocks
	neighborlay = "dirtedge"
	climbdiff = 1
	hardness = 2

/turf/closed/wall/mineral/decostone/long
	icon_state = "decostone-l"

/obj/structure/thronething
	name = "stone wall"
	icon = 'icons/turf/walls.dmi'
	resistance_flags = INDESTRUCTIBLE
	opacity = 0
	icon_state = "decostone-l"

/turf/closed/wall/mineral/decostone/center
	icon_state = "decostone-c"

/turf/closed/wall/mineral/decostone/end
	icon_state = "decostone-e"

/turf/closed/wall/mineral/decostone/cand
	icon_state = "decostone-cand"

/turf/closed/wall/mineral/decostone/fluffstone
	icon_state = "fluffstone"

//green moss
/turf/closed/wall/mineral/decostone/moss
	icon_state = "decostone-b-green"

/turf/closed/wall/mineral/decostone/moss/long
	icon_state = "decostone-l-green"

/turf/closed/wall/mineral/decostone/moss/end
	icon_state = "decostone-e-green"

/turf/closed/wall/mineral/decostone/moss/cand
	icon_state = "decostone-cand-green"

//blue moss
/turf/closed/wall/mineral/decostone/moss/blue
	icon_state = "decostone-b-blue"

/turf/closed/wall/mineral/decostone/moss/blue/long
	icon_state = "decostone-l-blue"

/turf/closed/wall/mineral/decostone/moss/blue/end
	icon_state = "decostone-e-blue"

/turf/closed/wall/mineral/decostone/moss/blue/cand
	icon_state = "decostone-cand-blue"

//red moss
/turf/closed/wall/mineral/decostone/moss/red
	icon_state = "decostone-b-red"

/turf/closed/wall/mineral/decostone/moss/red/long
	icon_state = "decostone-l-red"

/turf/closed/wall/mineral/decostone/moss/red/end
	icon_state = "decostone-e-red"

/turf/closed/wall/mineral/decostone/moss/red/cand
	icon_state = "decostone-cand-red"

/turf/closed/dungeon_void
	name = "thick dungeon shroud"
	icon = 'icons/turf/walls.dmi'
	icon_state = "shroud1"

/turf/closed/sea_fog
	name = "thick sea fog"
	icon = 'icons/effects/effects.dmi'
	density = TRUE
	opacity = TRUE
	icon_state = "mfoam"
	plane = FLOOR_PLANE

/turf/closed/wall/mineral/pipe
	name = "metal wall"
	icon = 'icons/turf/smooth/walls/pipe_used.dmi'
	icon_state = MAP_SWITCH("pipe", "pipe-0")
	blade_dulling = DULLING_BASH
	max_integrity = 10000
	sheet_type = null
	break_sound = 'sound/combat/hits/onmetal/sheet (1).ogg'
	attacked_sound = list('sound/combat/hits/onmetal/attackpipewall (1).ogg','sound/combat/hits/onmetal/attackpipewall (2).ogg')
	smoothing_flags = SMOOTH_BITMASK_CARDINALS
	smoothing_groups = SMOOTH_GROUP_CLOSED_WALL + SMOOTH_GROUP_WALLS_PIPE
	smoothing_list = SMOOTH_GROUP_DOOR_SECRET + SMOOTH_GROUP_WALLS_PIPE
	above_floor = /turf/open/floor/concrete
	baseturfs = /turf/open/floor/concrete
	climbdiff = 1
	damage_deflection = 20
	hardness = 10

/turf/closed/wall/mineral/underbrick
	name = "erebus stone wall"
	desc = "The toils of hard-working shades."
	icon = 'icons/turf/smooth/walls/brick_under.dmi'
	icon_state = MAP_SWITCH("underbrick", "underbrick-0")
	wallclimb = FALSE
	blade_dulling = DULLING_BASH
	max_integrity = 99999
	sheet_type = null
	break_sound = 'sound/combat/hits/onstone/stonedeath.ogg'
	attacked_sound = list('sound/combat/hits/onstone/wallhit.ogg', 'sound/combat/hits/onstone/wallhit2.ogg', 'sound/combat/hits/onstone/wallhit3.ogg')
	smoothing_flags = SMOOTH_BITMASK_CARDINALS
	smoothing_groups = SMOOTH_GROUP_CLOSED_WALL + SMOOTH_GROUP_WALLS_EREBUS
	smoothing_list = SMOOTH_GROUP_DOOR_SECRET + SMOOTH_GROUP_WALLS_EREBUS
	above_floor = /turf/open/floor/church
	baseturfs = /turf/open/floor/church
	neighborlay = "dirtedge"
	climbdiff = 6

//NO. BAD SKELETONS
/turf/closed/wall/mineral/underbrick/TerraformTurf(path, new_baseturf, flags, defer_change = FALSE, ignore_air = FALSE)
	return

/turf/closed/wall/mineral/underbrick/acid_act(acidpwr, acid_volume, acid_id)
	return 0

/turf/closed/wall/mineral/underbrick/Melt()
	to_be_destroyed = FALSE
	return src

/turf/closed/wall/mineral/abyssal
	name = "abyssal wall"
	icon = 'icons/delver/abyss_walls.dmi'
	icon_state = MAP_SWITCH("wallformed", "wallformed")
	blade_dulling = DULLING_BASH
	max_integrity = 99999
	sheet_type = null
	break_sound = 'sound/combat/hits/onmetal/sheet (1).ogg'
	attacked_sound = list('sound/combat/hits/onmetal/attackpipewall (1).ogg','sound/combat/hits/onmetal/attackpipewall (2).ogg')
	above_floor = /turf/open/floor/concrete
	baseturfs = /turf/open/floor/concrete
	climbdiff = 1
	damage_deflection = 20
	hardness = 10

/turf/closed/wall/mineral/desert_sandstone
	name = "sandstone wall"
	icon = 'icons/delver/desert_sandstone.dmi'
	icon_state = MAP_SWITCH("wallformed", "wallformed")
	blade_dulling = DULLING_BASH
	max_integrity = 99999
	sheet_type = null
	break_sound = 'sound/combat/hits/onmetal/sheet (1).ogg'
	attacked_sound = list('sound/combat/hits/onmetal/attackpipewall (1).ogg','sound/combat/hits/onmetal/attackpipewall (2).ogg')
	above_floor = /turf/open/floor/sandstone
	baseturfs = /turf/open/floor/sandstone
	climbdiff = 1
	damage_deflection = 20
	hardness = 10

/turf/closed/wall/mineral/desert_sandstone/window
	name = "sandstone window"
	opacity = FALSE
	var/state = "window_open"

/turf/closed/wall/mineral/desert_sandstone/window/Initialize(mapload, ...)
	. = ..()
	add_overlay(mutable_appearance('icons/delver/desert_objects.dmi', state, layer = ABOVE_NORMAL_TURF_LAYER))

/turf/closed/wall/mineral/desert_sandstone/window/brass
	state = "window_brass"

/turf/closed/wall/mineral/desert_soapstone
	name = "soapstone wall"
	icon = 'icons/delver/desert_slopstone.dmi'
	icon_state = MAP_SWITCH("wallformed", "wallformed")
	blade_dulling = DULLING_BASH
	max_integrity = 99999
	sheet_type = null
	break_sound = 'sound/combat/hits/onmetal/sheet (1).ogg'
	attacked_sound = list('sound/combat/hits/onmetal/attackpipewall (1).ogg','sound/combat/hits/onmetal/attackpipewall (2).ogg')
	above_floor = /turf/open/floor/sandstone
	baseturfs = /turf/open/floor/sandstone
	climbdiff = 1
	damage_deflection = 20
	hardness = 10
