/*	..................   Wooden Floors   ................... */
/turf/open/floor/ruinedwood
	icon = 'icons/turf/constructed/wood.dmi'
	icon_state = "wooden_floor"
	footstep = FOOTSTEP_WOOD
	barefootstep = FOOTSTEP_HARD_BAREFOOT
	clawfootstep = FOOTSTEP_WOOD_CLAW
	heavyfootstep = FOOTSTEP_GENERIC_HEAVY
	landsound = 'sound/foley/jumpland/woodland.ogg'
	neighborlay = "dirtedge"
	damage_deflection = 8
	max_integrity = 600

/turf/open/floor/ruinedwood/Initialize()
	dir = pick(GLOB.cardinals)
	. = ..()

/turf/open/floor/ruinedwood/atom_destruction(damage_flag)
	. = ..()
	ScrapeAway(flags = CHANGETURF_INHERIT_AIR)

/turf/open/floor/ruinedwood/two
	icon_state = "wooden_floor2"

/turf/open/floor/ruinedwood/alt
	icon_state = "horzw"

/turf/open/floor/ruinedwood/turned
	icon_state = "wooden_floort"

/turf/open/floor/ruinedwood/turned/alt
	icon_state = "vertw"

/turf/open/floor/ruinedwood/spiral
	icon_state = "weird1"

/turf/open/floor/ruinedwood/spiralfade
	icon_state = "weird3"

/turf/open/floor/ruinedwood/chevron
	icon_state = "weird2"

/*	..................   Darker version   ................... */
/turf/open/floor/ruinedwood/darker // here problem was opposite, too bright wood for bandit lair
	color = "#d9c9b0"

/turf/open/floor/ruinedwood/turned/darker
	color = "#d9c9b0"

/turf/open/floor/tile/kitchen // faded kitchen, too dark floors look bad IMO, this much nicer
	icon_state = "tavern"

/turf/open/floor/twig
	icon = 'icons/turf/constructed/wood.dmi'
	icon_state = "twig"
	footstep = FOOTSTEP_GRASS
	barefootstep = FOOTSTEP_SOFT_BAREFOOT
	heavyfootstep = FOOTSTEP_GENERIC_HEAVY
	landsound = 'sound/foley/jumpland/grassland.ogg'
	slowdown = 0
	damage_deflection = 6
	max_integrity = 300

/turf/open/floor/twig/Initialize()
	dir = pick(GLOB.cardinals)
	. = ..()

/turf/open/floor/twig/OnCrafted(dirin, mob/user)
	. = ..()
	dir = dirin

/turf/open/floor/twig/atom_destruction(damage_flag)
	. = ..()
	ScrapeAway(flags = CHANGETURF_INHERIT_AIR)

/turf/open/floor/wood
	icon = 'icons/turf/smooth/floors/wood.dmi'
	icon_state = MAP_SWITCH("wood", "wood-0")
	footstep = FOOTSTEP_WOOD
	barefootstep = FOOTSTEP_HARD_BAREFOOT
	clawfootstep = FOOTSTEP_WOOD_CLAW
	heavyfootstep = FOOTSTEP_GENERIC_HEAVY
	landsound = 'sound/foley/jumpland/woodland.ogg'
	smoothing_flags = SMOOTH_BITMASK
	smoothing_groups = SMOOTH_GROUP_OPEN_FLOOR + SMOOTH_GROUP_FLOOR_WOOD
	damage_deflection = 8
	max_integrity = 600
//these are here so we can put wood floors next to each other but not have them smooth
/turf/open/floor/wood/nosmooth

/turf/open/floor/wood/atom_destruction(damage_flag)
	. = ..()
	ScrapeAway(flags = CHANGETURF_INHERIT_AIR)

/turf/open/floor/wood/nosmooth/saiga
	icon = 'icons/turf/smooth/floors/wood_alt.dmi'

/turf/open/floor/woodturned
	icon = 'icons/turf/smooth/floors/wood_turned.dmi'
	icon_state = MAP_SWITCH("wood", "wood-0")
	footstep = FOOTSTEP_WOOD
	barefootstep = FOOTSTEP_HARD_BAREFOOT
	clawfootstep = FOOTSTEP_WOOD_CLAW
	heavyfootstep = FOOTSTEP_GENERIC_HEAVY
	landsound = 'sound/foley/jumpland/woodland.ogg'
	smoothing_flags = SMOOTH_BITMASK
	smoothing_groups = SMOOTH_GROUP_OPEN_FLOOR + SMOOTH_GROUP_FLOOR_WOOD
	damage_deflection = 8
	max_integrity = 600

/turf/open/floor/woodturned/atom_destruction(damage_flag)
	. = ..()
	ScrapeAway(flags = CHANGETURF_INHERIT_AIR)

//these are here so we can put wood floors next to each other but not have them smooth
/turf/open/floor/woodturned/nosmooth

/turf/open/floor/woodturned/nosmooth/saiga
	icon = 'icons/turf/smooth/floors/wood_turned_alt.dmi'

/turf/open/floor/rooftop
	name = "roof"
	icon = 'icons/turf/constructed/roof.dmi'
	icon_state = MAP_SWITCH("roof", "roof-arw")
	footstep = FOOTSTEP_WOOD
	barefootstep = FOOTSTEP_HARD_BAREFOOT
	clawfootstep = FOOTSTEP_WOOD_CLAW
	heavyfootstep = FOOTSTEP_GENERIC_HEAVY
	damage_deflection = 8
	max_integrity = 800

/turf/open/floor/rooftop/atom_destruction(damage_flag)
	. = ..()
	ScrapeAway(flags = CHANGETURF_INHERIT_AIR)

/turf/open/floor/rooftop/green
	icon_state = MAP_SWITCH("roofg", "roofg-arw")

/*	..................   Grasses   ................... */
/turf/open/floor/grass
	name = "grass"
	desc = "Grass, sodden in mud and bogwater."
	icon = 'icons/turf/natural/grasses.dmi'
	icon_state = "grass"
	footstep = FOOTSTEP_GRASS
	barefootstep = FOOTSTEP_SOFT_BAREFOOT
	heavyfootstep = FOOTSTEP_GENERIC_HEAVY
	landsound = 'sound/foley/jumpland/grassland.ogg'
	slowdown = 0
	smoothing_flags = SMOOTH_EDGE
	smoothing_groups = SMOOTH_GROUP_OPEN_FLOOR + SMOOTH_GROUP_FLOOR_GRASS
	smoothing_list = SMOOTH_GROUP_FLOOR_DIRT_ROAD
	neighborlay = "grassedge"
	max_integrity = 1200
	spread_chance = 2
	burn_power = 10

/turf/open/floor/grass/Initialize()
	. = ..()
	dir = pick(GLOB.cardinals)

/turf/open/floor/grass/atom_destruction(damage_flag)
	. = ..()
	ChangeTurf(/turf/open/floor/dirt, flags = CHANGETURF_INHERIT_AIR)

/turf/open/floor/grass/healthy
	name = "healthy grass"
	desc = "Grass, somehow greener on this side."
	icon_state = "grass_healthy"
	neighborlay = "grass_healthyedge"

/turf/open/floor/grass/mixyel
	icon_state = "grass_yelmix"
	neighborlay = "grass_yelmixedge"

/turf/open/floor/grass/red
	name = "red grass"
	desc = "Grass, ripe with Dendor's bloody marrow."
	icon_state = "grass_red"
	neighborlay = "grass_rededge"

/turf/open/floor/grass/yel
	name = "yellow grass"
	desc = "Grass, blessed by Astrata's light."
	icon_state = "grass_yel"
	neighborlay = "grass_yeledge"

/turf/open/floor/grass/cold
	name = "tundra grass"
	desc = "Grass, frigid and touched by winter."
	icon_state = "grass_cold"
	neighborlay = "grass_coldedge"

/turf/open/floor/grass/hell
	name = "hell grass"
	desc = "Grass, ominous and instilling uncomfort."
	icon_state = "hellgrass"
	neighborlay = "hellgrass"

/turf/open/floor/grass/eora
	icon_state = "hellgrass"
	neighborlay = "hellgrass"

/*	..................   Snow   ................... */

/turf/open/floor/snow
	name = "snow"
	desc = "A gentle blanket of snow."
	icon = 'icons/turf/natural/snow.dmi'
	icon_state = "snow"
	footstep = FOOTSTEP_GRASS
	barefootstep = FOOTSTEP_SOFT_BAREFOOT
	heavyfootstep = FOOTSTEP_GENERIC_HEAVY
	landsound = 'sound/foley/jumpland/grassland.ogg'
	slowdown = 0
	smoothing_flags = SMOOTH_EDGE
	smoothing_groups = SMOOTH_GROUP_OPEN_FLOOR + SMOOTH_GROUP_FLOOR_SNOW
	smoothing_list = SMOOTH_GROUP_FLOOR_DIRT + SMOOTH_GROUP_FLOOR_DIRT_ROAD + SMOOTH_GROUP_FLOOR_GRASS + SMOOTH_GROUP_FLOOR_STONE
	neighborlay = "snowedge"
	spread_chance = 0

/turf/open/floor/snow/Initialize()
	dir = pick(GLOB.cardinals)
	. = ..()

/turf/open/floor/snow/rough
	name = "rough snow"
	desc = "A rugged blanket of snow."
	icon_state = "snowrough"
	neighborlay = "snowroughedge"

/turf/open/floor/snow/patchy
	name = "patchy snow"
	desc = "Half-melted snow revealing the hardy grass underneath."
	icon_state = "snowpatchy_grass"
	neighborlay = "snowpatchy_grassedge"

/*	..................   Dirts   ................... */
/turf/open/floor/dirt
	name = "dirt"
	desc = "The dirt is pocked with the scars of countless wars."
	icon = 'icons/turf/natural/soils.dmi'
	icon_state = "dirt"
	footstep = FOOTSTEP_GRASS
	barefootstep = FOOTSTEP_SOFT_BAREFOOT
	heavyfootstep = FOOTSTEP_GENERIC_HEAVY
	landsound = 'sound/foley/jumpland/dirtland.ogg'
	slowdown = 2
	smoothing_flags = SMOOTH_EDGE
	smoothing_groups = SMOOTH_GROUP_OPEN_FLOOR + SMOOTH_GROUP_FLOOR_DIRT
	smoothing_list = SMOOTH_GROUP_FLOOR_DIRT_ROAD + SMOOTH_GROUP_FLOOR_GRASS + SMOOTH_GROUP_FLOOR_STONE
	neighborlay = "dirtedge"
	spread_chance = 1.1

	var/muddy = FALSE
	var/bloodiness = 20
	var/dirt_amt = 3

/turf/open/floor/dirt/attack_hand_secondary(mob/user, list/modifiers)
	. = ..()
	if(. == SECONDARY_ATTACK_CANCEL_ATTACK_CHAIN)
		return
	if(isliving(user))
		var/mob/living/L = user
		var/obj/item/I = new /obj/item/natural/dirtclod(src)
		if(L.put_in_active_hand(I))
			L.visible_message("<span class='warning'>[L] picks up some dirt.</span>")
			dirt_amt--
			if(dirt_amt <= 0)
				src.ChangeTurf(/turf/open/floor/dirt/road, flags = CHANGETURF_INHERIT_AIR)
		else
			qdel(I)
	return SECONDARY_ATTACK_CANCEL_ATTACK_CHAIN

/turf/open/floor/dirt/Crossed(atom/movable/O)
	..()
	if(ishuman(O))
		var/mob/living/carbon/human/H = O
		if(H.shoes)
			var/obj/item/clothing/shoes/S = H.shoes
			if(!S.can_be_bloody)
				return
			var/add_blood = 0
			if(bloodiness >= BLOOD_GAIN_PER_STEP)
				add_blood = BLOOD_GAIN_PER_STEP
			else
				add_blood = bloodiness
			S.bloody_shoes[BLOOD_STATE_MUD] = min(MAX_SHOE_BLOODINESS,S.bloody_shoes[BLOOD_STATE_MUD]+add_blood)
			S.blood_state = BLOOD_STATE_MUD
			H.update_inv_shoes()
		if(water_level)
			START_PROCESSING(SSwaterlevel, src)

/turf/open/floor/dirt/Initialize()
	dir = pick(GLOB.cardinals)
	. = ..()
	update_water()

/turf/open/floor/dirt/update_water()
	water_level = max(water_level-10,0)
	if(water_level > 10) //this would be a switch on normal tiles
		color = "#95776a"
	else
		color = null
	return TRUE

/turf/open/floor/dirt/road/update_water()
	water_level = max(water_level-10,0)
	for(var/D in GLOB.cardinals)
		var/turf/TU = get_step(src, D)
		if(istype(TU, /turf/open/water))
			if(!muddy)
				become_muddy()
			return TRUE //stop processing
	if(water_level > 10) //this would be a switch on normal tiles
		if(!muddy)
			become_muddy()
//flood process goes here to spread to other turfs etc
//	if(water_level > 250)
//		return FALSE
	if(muddy)
		if(water_level <= 0)
			water_level = 0
			muddy = FALSE
			slowdown = initial(slowdown)
			icon_state = initial(icon_state)
			name = initial(name)
			footstep = initial(footstep)
			barefootstep = initial(barefootstep)
			clawfootstep = initial(clawfootstep)
			heavyfootstep = initial(heavyfootstep)
	return TRUE

/turf/open/floor/dirt/proc/become_muddy()
	if(!muddy)
		water_level = max(water_level-100,0)
		muddy = TRUE
		icon = 'icons/turf/natural/soils.dmi'
		icon_state = "mud[rand (1,3)]"
		name = "mud"
		slowdown = 2
		footstep = FOOTSTEP_MUD
		barefootstep = FOOTSTEP_MUD
		heavyfootstep = FOOTSTEP_MUD
		bloodiness = 20

/turf/open/floor/dirt/ambush

/turf/open/floor/dirt/road
	name = "dirt road"
	desc = "The dirt is pocked with the scars of countless steps."
	icon_state = "road"
	footstep = FOOTSTEP_SAND
	smoothing_flags = NONE
	smoothing_groups = SMOOTH_GROUP_OPEN_FLOOR + SMOOTH_GROUP_FLOOR_DIRT_ROAD
	smoothing_list = null
	slowdown = 0
	path_weight = 10

/turf/open/floor/dirt/road/attack_hand_secondary(mob/user, list/modifiers)
	return

/turf/open/floor/dirt/atom_destruction(damage_flag)
	. = ..()
	ScrapeAway(flags = CHANGETURF_INHERIT_AIR)

/turf/open/floor/underworld/road
	name = "ash"
	desc = "Smells like burnt wood."
	icon = 'icons/turf/natural/ash.dmi'
	icon_state = "ash"
	footstep = FOOTSTEP_SAND
	barefootstep = FOOTSTEP_SOFT_BAREFOOT
	heavyfootstep = FOOTSTEP_GENERIC_HEAVY
	landsound = 'sound/foley/jumpland/dirtland.ogg'
	slowdown = 0

/turf/open/floor/underworld/road/Initialize()
	. = ..()
	dir = rand(0,8)

/turf/open/floor/underworld/arena
	name = "sandy ash"
	desc = "This has been pranced upon by countless skeletal fighters."
	icon = 'icons/turf/natural/ash.dmi'
	icon_state = "ash3"
	footstep = FOOTSTEP_SAND
	barefootstep = FOOTSTEP_SOFT_BAREFOOT
	heavyfootstep = FOOTSTEP_GENERIC_HEAVY
	landsound = 'sound/foley/jumpland/dirtland.ogg'
	slowdown = 0

/turf/open/floor/underworld/arena/Initialize()
	. = ..()
	//dir = rand(0,8)   Need to add variants.

/turf/open/floor/underworld/space
	name = "void"
	desc = "The shifting blanket of Necra's realm."
	icon_state = "undervoid"
	footstep = FOOTSTEP_SAND
	barefootstep = FOOTSTEP_SOFT_BAREFOOT
	heavyfootstep = FOOTSTEP_GENERIC_HEAVY
	landsound = 'sound/foley/jumpland/dirtland.ogg'
	slowdown = 50

/turf/open/floor/underworld/space/sparkle_quiet
	name = "void"
	desc = "The shifting blanket of Necra's realm."
	icon_state = "undervoid2"

/turf/open/floor/underworld/space/quiet
	name = "void"
	desc = "The shifting blanket of Necra's realm."
	icon_state = "undervoid3"

/turf/open/floor/volcanic
	name = "dirt"
	desc = "The dirt is pocked with the scars of tectonic movement."
	icon = 'icons/turf/natural/soils.dmi'
	icon_state = "lavafloor"
	footstep = FOOTSTEP_SAND
	barefootstep = FOOTSTEP_SOFT_BAREFOOT
	clawfootstep = FOOTSTEP_SAND
	heavyfootstep = FOOTSTEP_GENERIC_HEAVY
	landsound = 'sound/foley/jumpland/dirtland.ogg'
	smoothing_flags = SMOOTH_EDGE
	smoothing_groups = SMOOTH_GROUP_OPEN_FLOOR + SMOOTH_GROUP_FLOOR_DIRT
	smoothing_list = SMOOTH_GROUP_FLOOR_DIRT_ROAD + SMOOTH_GROUP_FLOOR_GRASS + SMOOTH_GROUP_FLOOR_STONE
	neighborlay = "lavedge"

/turf/open/floor/volcanic/Initialize()
	dir = pick(GLOB.cardinals)
	. = ..()

/turf/open/floor/hay
	name = "hay"
	desc = "A light covering of hay strewn across the ground."
	icon = 'icons/turf/constructed/misc.dmi'
	icon_state = "hay"
	footstep = FOOTSTEP_GRASS
	barefootstep = FOOTSTEP_SOFT_BAREFOOT
	heavyfootstep = FOOTSTEP_GENERIC_HEAVY
	landsound = 'sound/foley/jumpland/grassland.ogg'
	slowdown = 0

/*	..................   Stone Block Floors   ................... */
/turf/open/floor/blocks
	icon = 'icons/turf/constructed/stone.dmi'
	icon_state = "blocks"
	footstep = FOOTSTEP_STONE
	barefootstep = FOOTSTEP_HARD_BAREFOOT
	clawfootstep = FOOTSTEP_HARD_CLAW
	heavyfootstep = FOOTSTEP_GENERIC_HEAVY
	landsound = 'sound/foley/jumpland/stoneland.ogg'
	damage_deflection = 10
	max_integrity = 2800

/turf/open/floor/blocks/Initialize()
	. = ..()
	dir = pick(GLOB.cardinals)

/turf/open/floor/blocks/atom_destruction(damage_flag)
	. = ..()
	ScrapeAway(flags = CHANGETURF_INHERIT_AIR)

/turf/open/floor/blocks/stonered
	icon = 'icons/turf/constructed/tile.dmi'
	icon_state = "stoneredlarge"

/turf/open/floor/blocks/stonered/tiny
	icon_state = "stoneredtiny"

/turf/open/floor/blocks/green
	icon_state = "greenblocks"

/turf/open/floor/blocks/carved
	icon = 'icons/turf/constructed/tile.dmi'
	icon_state = "carvedstone"

/turf/open/floor/blocks/bluestone
	icon = 'icons/turf/constructed/tile.dmi'
	icon_state = "bluestone2"

/turf/open/floor/blocks/newstone
	icon = 'icons/turf/constructed/tile.dmi'
	icon_state = "newstone2"

/turf/open/floor/blocks/newstone/alt
	icon_state = "bluestone"

/turf/open/floor/blocks/snow
	icon_state = "snowblocks"

/turf/open/floor/blocks/paving
	icon = 'icons/turf/constructed/tile.dmi'
	icon_state = "paving"

/turf/open/floor/blocks/paving/vert
	icon_state = "paving-t"

/turf/open/floor/greenstone
	icon_state = "greenstone"
	footstep = FOOTSTEP_STONE
	barefootstep = FOOTSTEP_HARD_BAREFOOT
	clawfootstep = FOOTSTEP_HARD_CLAW
	heavyfootstep = FOOTSTEP_GENERIC_HEAVY
	landsound = 'sound/foley/jumpland/stoneland.ogg'
	icon = 'icons/turf/greenstone.dmi'
	damage_deflection = 10
	max_integrity = 800
	break_sound = 'sound/combat/hits/onstone/stonedeath.ogg'
	attacked_sound = list('sound/combat/hits/onstone/wallhit.ogg', 'sound/combat/hits/onstone/wallhit2.ogg', 'sound/combat/hits/onstone/wallhit3.ogg')

/turf/open/floor/greenstone/atom_destruction(damage_flag)
	. = ..()
	ScrapeAway(flags = CHANGETURF_INHERIT_AIR)

/turf/open/floor/greenstone/runed
	icon_state = "greenstoneruned"

/turf/open/floor/greenstone/glyph1
	icon_state = "glyph1"

/turf/open/floor/greenstone/glyph2
	icon_state = "glyph2"

/turf/open/floor/greenstone/glyph3
	icon_state = "glyph3"

/turf/open/floor/greenstone/glyph4
	icon_state = "glyph4"

/turf/open/floor/greenstone/glyph5
	icon_state = "glyph5"

/turf/open/floor/greenstone/glyph6
	icon_state = "glyph6"

/turf/open/floor/hexstone
	icon = 'icons/turf/constructed/stone.dmi'
	icon_state = "hexstone"
	footstep = FOOTSTEP_STONE
	barefootstep = FOOTSTEP_HARD_BAREFOOT
	clawfootstep = FOOTSTEP_HARD_CLAW
	heavyfootstep = FOOTSTEP_GENERIC_HEAVY
	landsound = 'sound/foley/jumpland/stoneland.ogg'
	damage_deflection = 10
	max_integrity = 800
	break_sound = 'sound/combat/hits/onstone/stonedeath.ogg'
	attacked_sound = list('sound/combat/hits/onstone/wallhit.ogg', 'sound/combat/hits/onstone/wallhit2.ogg', 'sound/combat/hits/onstone/wallhit3.ogg')

/turf/open/floor/hexstone/Initialize()
	. = ..()
	dir = pick(GLOB.cardinals)

/turf/open/floor/hexstone/atom_destruction(damage_flag)
	. = ..()
	ScrapeAway(flags = CHANGETURF_INHERIT_AIR)

/*	..................   Church Floors   ................... */

/turf/open/floor/churchmarble
	icon = 'icons/turf/constructed/church.dmi'
	icon_state = "church_marble"
	footstep = FOOTSTEP_STONE
	barefootstep = FOOTSTEP_HARD_BAREFOOT
	clawfootstep = FOOTSTEP_HARD_CLAW
	heavyfootstep = FOOTSTEP_GENERIC_HEAVY
	landsound = 'sound/foley/jumpland/stoneland.ogg'

	damage_deflection = 10
	max_integrity = 800
	break_sound = 'sound/combat/hits/onstone/stonedeath.ogg'
	attacked_sound = list('sound/combat/hits/onstone/wallhit.ogg', 'sound/combat/hits/onstone/wallhit2.ogg', 'sound/combat/hits/onstone/wallhit3.ogg')
	shine = SHINE_SHINY

/turf/open/floor/churchmarble/Initialize()
	. = ..()
	dir = pick(GLOB.cardinals)

/turf/open/floor/churchmarble/atom_destruction(damage_flag)
	. = ..()
	ScrapeAway(flags = CHANGETURF_INHERIT_AIR)

/turf/open/floor/church
	icon = 'icons/turf/constructed/church.dmi'
	icon_state = "church"
	footstep = FOOTSTEP_STONE
	barefootstep = FOOTSTEP_HARD_BAREFOOT
	clawfootstep = FOOTSTEP_HARD_CLAW
	heavyfootstep = FOOTSTEP_GENERIC_HEAVY
	landsound = 'sound/foley/jumpland/stoneland.ogg'
	damage_deflection = 10
	max_integrity = 800
	break_sound = 'sound/combat/hits/onstone/stonedeath.ogg'
	attacked_sound = list('sound/combat/hits/onstone/wallhit.ogg', 'sound/combat/hits/onstone/wallhit2.ogg', 'sound/combat/hits/onstone/wallhit3.ogg')

/turf/open/floor/church/atom_destruction(damage_flag)
	. = ..()
	ScrapeAway(flags = CHANGETURF_INHERIT_AIR)

/turf/open/floor/church/Initialize()
	. = ..()
	dir = pick(GLOB.cardinals)

/turf/open/floor/churchbrick
	icon = 'icons/turf/constructed/church.dmi'
	icon_state = "church_marble"
	footstep = FOOTSTEP_STONE
	barefootstep = FOOTSTEP_HARD_BAREFOOT
	clawfootstep = FOOTSTEP_HARD_CLAW
	heavyfootstep = FOOTSTEP_GENERIC_HEAVY
	landsound = 'sound/foley/jumpland/stoneland.ogg'
	damage_deflection = 10
	max_integrity = 800
	break_sound = 'sound/combat/hits/onstone/stonedeath.ogg'
	attacked_sound = list('sound/combat/hits/onstone/wallhit.ogg', 'sound/combat/hits/onstone/wallhit2.ogg', 'sound/combat/hits/onstone/wallhit3.ogg')

/turf/open/floor/churchbrick/atom_destruction(damage_flag)
	. = ..()
	ScrapeAway(flags = CHANGETURF_INHERIT_AIR)

/turf/open/floor/churchbrick/Initialize()
	. = ..()
	dir = pick(GLOB.cardinals)

/turf/open/floor/churchrough
	icon = 'icons/turf/constructed/church.dmi'
	icon_state = "church_rough"
	footstep = FOOTSTEP_STONE
	barefootstep = FOOTSTEP_HARD_BAREFOOT
	clawfootstep = FOOTSTEP_HARD_CLAW
	heavyfootstep = FOOTSTEP_GENERIC_HEAVY
	landsound = 'sound/foley/jumpland/stoneland.ogg'
	damage_deflection = 10
	max_integrity = 800
	break_sound = 'sound/combat/hits/onstone/stonedeath.ogg'
	attacked_sound = list('sound/combat/hits/onstone/wallhit.ogg', 'sound/combat/hits/onstone/wallhit2.ogg', 'sound/combat/hits/onstone/wallhit3.ogg')

/turf/open/floor/churchrough/atom_destruction(damage_flag)
	. = ..()
	ScrapeAway(flags = CHANGETURF_INHERIT_AIR)

/turf/open/floor/churchrough/Initialize()
	. = ..()
	dir = pick(GLOB.cardinals)

// Church Variants
// Purple
/turf/open/floor/church/purple
	icon_state = "church-purple"

/turf/open/floor/churchmarble/purple
	icon_state = "church-purple_marble"

/turf/open/floor/churchrough/purple
	icon_state = "church-purple_rough"

// Violet - old purple
/turf/open/floor/church/violet
	icon_state = "church-violet"

/turf/open/floor/churchmarble/violet
	icon_state = "church-violet_marble"

/turf/open/floor/churchrough/violet
	icon_state = "church-violet_rough"

// Rust - Maroon, good for inhumen.
/turf/open/floor/church/rust
	icon_state = "church-rust"

/turf/open/floor/churchmarble/rust
	icon_state = "church-rust_marble"

/turf/open/floor/churchrough/rust
	icon_state = "church-rust_rough"

// Pale - Sandy, use in Deshret maybe
/turf/open/floor/church/pale
	icon_state = "church-pale"

/turf/open/floor/churchmarble/pale
	icon_state = "church-pale_marble"

/turf/open/floor/churchrough/pale
	icon_state = "church-pale_rough"

// Gold - Astratan theme?
/turf/open/floor/church/gold
	icon_state = "church-gold"

/turf/open/floor/churchmarble/gold
	icon_state = "church-gold_marble"

/turf/open/floor/churchrough/gold
	icon_state = "church-gold_marble"

// Green - Dendor shrines.
/turf/open/floor/church/green
	icon_state = "church-green"

/turf/open/floor/churchmarble/green
	icon_state = "church-green_marble"

/turf/open/floor/churchrough/green
	icon_state = "church-green_rough"

//
/turf/open/floor/herringbone
	icon = 'icons/turf/constructed/stone.dmi'
	icon_state = "herringbone"
	footstep = FOOTSTEP_STONE
	barefootstep = FOOTSTEP_HARD_BAREFOOT
	clawfootstep = FOOTSTEP_HARD_CLAW
	heavyfootstep = FOOTSTEP_GENERIC_HEAVY
	landsound = 'sound/foley/jumpland/stoneland.ogg'
	smoothing_flags = SMOOTH_EDGE
	smoothing_groups = SMOOTH_GROUP_OPEN_FLOOR + SMOOTH_GROUP_FLOOR_STONE
	smoothing_list = SMOOTH_GROUP_FLOOR_DIRT_ROAD + SMOOTH_GROUP_FLOOR_GRASS
	neighborlay = "herringedge"

	damage_deflection = 10
	max_integrity = 800
	break_sound = 'sound/combat/hits/onstone/stonedeath.ogg'
	attacked_sound = list('sound/combat/hits/onstone/wallhit.ogg', 'sound/combat/hits/onstone/wallhit2.ogg', 'sound/combat/hits/onstone/wallhit3.ogg')

/turf/open/floor/herringbone/atom_destruction(damage_flag)
	. = ..()
	ScrapeAway(flags = CHANGETURF_INHERIT_AIR)

/*	..................   Cobblestone   ................... */
/turf/open/floor/cobble
	icon = 'icons/turf/constructed/stone.dmi'
	icon_state = "cobblestone1"
	footstep = FOOTSTEP_STONE
	barefootstep = FOOTSTEP_HARD_BAREFOOT
	clawfootstep = FOOTSTEP_HARD_CLAW
	heavyfootstep = FOOTSTEP_GENERIC_HEAVY
	landsound = 'sound/foley/jumpland/stoneland.ogg'
	smoothing_flags = SMOOTH_EDGE
	smoothing_groups = SMOOTH_GROUP_OPEN_FLOOR + SMOOTH_GROUP_FLOOR_STONE
	smoothing_list = SMOOTH_GROUP_FLOOR_DIRT_ROAD + SMOOTH_GROUP_FLOOR_GRASS
	neighborlay = "cobbleedge"
	max_integrity = 1200

/turf/open/floor/cobble/atom_destruction(damage_flag)
	. = ..()
	ChangeTurf(/turf/open/floor/dirt, flags = CHANGETURF_INHERIT_AIR)
	new /obj/item/natural/stone(src)

/turf/open/floor/cobble/Initialize()
	. = ..()
	icon_state = "cobblestone[rand(1,3)]"

/turf/open/floor/cobble/alt
	icon_state = "cobblestonealt1"
	neighborlay = "cobbleedgealt"

/turf/open/floor/cobble/alt/Initialize()
	. = ..()
	icon_state = "cobblestonealt[rand(1,3)]"

/turf/open/floor/cobble/mossy
	icon_state = "mossystone1"
	neighborlay = "mossyedgealt"

/turf/open/floor/cobble/mossy/Initialize()
	. = ..()
	icon_state = "mossystone[rand(1,3)]"

/turf/open/floor/cobble/snow
	icon_state = "snowcobble1"
	neighborlay = "snowcobbleedge"

/turf/open/floor/cobble/snow/Initialize()
	. = ..()
	icon_state = "snowcobble[rand(1,3)]"

/turf/open/floor/cobblerock
	icon = 'icons/turf/constructed/stone.dmi'
	icon_state = "cobblerock"
	footstep = FOOTSTEP_STONE
	barefootstep = FOOTSTEP_HARD_BAREFOOT
	clawfootstep = FOOTSTEP_HARD_CLAW
	heavyfootstep = FOOTSTEP_GENERIC_HEAVY
	landsound = 'sound/foley/jumpland/stoneland.ogg'
	smoothing_flags = SMOOTH_EDGE
	smoothing_groups = SMOOTH_GROUP_OPEN_FLOOR + SMOOTH_GROUP_FLOOR_STONE
	smoothing_list = SMOOTH_GROUP_FLOOR_DIRT_ROAD + SMOOTH_GROUP_FLOOR_GRASS
	neighborlay = "cobblerock"
	max_integrity = 1200

/turf/open/floor/cobblerock/atom_destruction(damage_flag)
	. = ..()
	ScrapeAway(flags = CHANGETURF_INHERIT_AIR)

/turf/open/floor/cobblerock/alt
	icon_state = "cobblealt"

/turf/open/floor/cobblerock/snow
	icon_state = "snowcobblerock"
	neighborlay = "snowcobblerock"

/*	..................   Bigger decals for mappers   ................... */
/obj/effect/decal/cobbleedge
	name = ""
	desc = ""
	icon = 'icons/turf/constructed/stone.dmi'
	icon_state = "cobblestone_edges"
	mouse_opacity = 0

/obj/effect/decal/cobbleedge/alt
	icon_state = "cobblestonealt_edges"

/obj/effect/decal/cobbleedge/mossy
	icon_state = "mossystonealt_edges"

/obj/effect/decal/cobbleedge/snow
	icon_state = "snowcobble_edges"

/obj/effect/decal/cobblerockedge
	name = ""
	desc = ""
	icon = 'icons/turf/floors.dmi'
	icon_state = "cobble_edges"
	mouse_opacity = 0

/obj/effect/decal/cobblerockedge/alt
	icon_state = "cobblealt_edges"

/obj/effect/decal/borderfall
	icon = 'icons/turf/constructed/misc.dmi'
	icon_state = "borderfall"

/*	..................   Miscellany   ................... */
/turf/open/floor/tile
	icon = 'icons/turf/constructed/tile.dmi'
	icon_state = "chess"
	landsound = 'sound/foley/jumpland/tileland.ogg'
	footstep = FOOTSTEP_FLOOR
	barefootstep = FOOTSTEP_HARD_BAREFOOT
	clawfootstep = FOOTSTEP_HARD_CLAW
	heavyfootstep = FOOTSTEP_GENERIC_HEAVY
	footstepstealth = TRUE
	damage_deflection = 10
	max_integrity = 800

/turf/open/floor/tile/atom_destruction(damage_flag)
	. = ..()
	ScrapeAway(flags = CHANGETURF_INHERIT_AIR)

/turf/open/floor/tile/masonic
	icon_state = "masonic"

/turf/open/floor/tile/masonic/single
	icon_state = "masonicsingle"

/turf/open/floor/tile/masonic/inverted
	icon_state = "masonicsingleinvert"

/turf/open/floor/tile/masonic/spiral
	icon_state = "masonicspiral"

/turf/open/floor/tile/brick
	icon_state = "bricktile"

/turf/open/floor/tile/brownbrick
	icon_state = "brown"

/turf/open/floor/tile/diamond
	icon_state = "dia_tile"

/turf/open/floor/tile/diamond/blue
	icon_state = "dia_tile1"

/turf/open/floor/tile/diamond/purple
	icon_state = "dia_tile2"

/turf/open/floor/tile/bath
	icon_state = "bathtile"

/turf/open/floor/tile/bath/pool
	icon_state = "bathtile_pool"

/turf/open/floor/tile/bfloorz
	icon_state = "bfloorz"

/turf/open/floor/tile/tilerg
	icon_state = "tilerg"

/turf/open/floor/tile/checker
	icon_state = "linoleum"

/turf/open/floor/tile/checkeralt
	icon_state = "tile"

/turf/open/floor/concrete
	icon = 'icons/turf/constructed/stone.dmi'
	icon_state = "concretefloor1"
	landsound = 'sound/foley/jumpland/stoneland.ogg'
	footstep = FOOTSTEP_STONE
	barefootstep = FOOTSTEP_HARD_BAREFOOT
	clawfootstep = FOOTSTEP_HARD_CLAW
	heavyfootstep = FOOTSTEP_GENERIC_HEAVY
	damage_deflection = 10
	max_integrity = 1200
	break_sound = 'sound/combat/hits/onstone/stonedeath.ogg'
	attacked_sound = list('sound/combat/hits/onstone/wallhit.ogg', 'sound/combat/hits/onstone/wallhit2.ogg', 'sound/combat/hits/onstone/wallhit3.ogg')

/turf/open/floor/concrete/atom_destruction(damage_flag)
	. = ..()
	src.ChangeTurf(/turf/open/floor/dirt, flags = CHANGETURF_INHERIT_AIR)
	new /obj/item/natural/stone(src)

/turf/open/floor/concrete/Initialize()
	. = ..()
	icon_state = "concretefloor[rand(1,2)]"
	dir = pick(GLOB.cardinals)

/turf/open/floor/metal
	icon = 'icons/turf/constructed/metal.dmi'
	icon_state = "plating1"
	landsound = 'sound/foley/jumpland/metalland.ogg'
	footstep = FOOTSTEP_PLATING
	barefootstep = FOOTSTEP_HARD_BAREFOOT
	clawfootstep = FOOTSTEP_HARD_CLAW
	heavyfootstep = FOOTSTEP_GENERIC_HEAVY
	footstepstealth = TRUE
	damage_deflection = 16
	max_integrity = 1400
	attacked_sound = list('sound/combat/hits/onmetal/grille (1).ogg', 'sound/combat/hits/onmetal/grille (2).ogg', 'sound/combat/hits/onmetal/grille (3).ogg')
	flags_1 = CONDUCT_1

/turf/open/floor/metal/alt
	icon_state = "plating2"

/turf/open/floor/metal/atom_destruction(damage_flag)
	. = ..()
	ScrapeAway(flags = CHANGETURF_INHERIT_AIR)

/turf/open/floor/metal/Initialize()
	. = ..()
	dir = pick(GLOB.cardinals)

/turf/open/floor/metal/barograte
	icon_state = "barograte"

/turf/open/floor/metal/barograte/open
	icon_state = "barograteopen"

/turf/open/floor/carpet/lord
	icon_state = ""

/turf/open/floor/carpet/lord/Initialize()
	. = ..()
	if(GLOB.lordprimary && GLOB.lordsecondary)
		lordcolor()
	else
		RegisterSignal(SSdcs, COMSIG_LORD_COLORS_SET, TYPE_PROC_REF(/turf/open/floor/carpet/lord, lordcolor))

/turf/open/floor/carpet/lord/center
	icon_state = "carpet_c"

/turf/open/floor/carpet/lord/center/Initialize()
	. = ..()
	dir = pick(GLOB.cardinals)

/turf/open/floor/carpet/lord/left
	icon_state = "carpet_l"

/turf/open/floor/carpet/lord/right
	icon_state = "carpet_r"

/turf/open/floor/carpet/lord/corner
	icon_state = "carpet_corner"

/turf/open/floor/carpet/lord/corrner_inner
	icon_state = "carpet_cornerin"

/turf/open/floor/carpet/green
	icon_state = "carpet_inn"

/turf/open/floor/naturalstone
	icon = 'icons/turf/natural/stones.dmi'
	icon_state = "digstone"
	footstep = FOOTSTEP_STONE
	barefootstep = FOOTSTEP_HARD_BAREFOOT
	clawfootstep = FOOTSTEP_HARD_CLAW
	heavyfootstep = FOOTSTEP_GENERIC_HEAVY
	landsound = 'sound/foley/jumpland/grassland.ogg'

/turf/open/floor/plank
	icon = 'icons/turf/constructed/misc.dmi'
	icon_state = "plank"
	footstep = FOOTSTEP_WOOD
	barefootstep = FOOTSTEP_HARD_BAREFOOT
	clawfootstep = FOOTSTEP_WOOD_CLAW
	heavyfootstep = FOOTSTEP_GENERIC_HEAVY
	landsound = 'sound/foley/jumpland/woodland.ogg'
	damage_deflection = 8
	max_integrity = 1000

/turf/open/floor/plank/atom_destruction(damage_flag)
	. = ..()
	ScrapeAway(flags = CHANGETURF_INHERIT_AIR)

/turf/open/floor/plank/h
	icon_state = "plank2"

/turf/open/floor/tile/checker_green
	icon_state = "tile"
	color = "#94df5b"

/turf/open/floor/abyss_tile
	icon = 'icons/delver/abyss_objects.dmi'
	icon_state = "abysstile-1"

/turf/open/floor/abyss_tile/two
	icon_state = "abysstile-2"

/turf/open/floor/abyss_tile/three
	icon_state = "abysstile-3"

/turf/open/floor/sandstone
	icon_state = "sandstone"
	footstep = FOOTSTEP_STONE
	barefootstep = FOOTSTEP_HARD_BAREFOOT
	clawfootstep = FOOTSTEP_HARD_CLAW
	heavyfootstep = FOOTSTEP_GENERIC_HEAVY
	landsound = 'sound/foley/jumpland/grassland.ogg'

/*	..................  Platforms   ................... */
/turf/open/floor/ruinedwood/platform
	name = "wood platform"
	desc = "A destructible platform to traverse gaps."
	damage_deflection = 6
	max_integrity = 600
	break_sound = 'sound/combat/hits/onwood/destroywalldoor.ogg'
	attacked_sound = list('sound/combat/hits/onwood/fence_hit1.ogg','sound/combat/hits/onwood/fence_hit2.ogg','sound/combat/hits/onwood/fence_hit3.ogg')

/turf/open/floor/twig/platform
	name = "twig platform"
	desc = "A destructible platform to traverse gaps."
	damage_deflection = 4
	max_integrity = 150
	break_sound = 'sound/combat/hits/onwood/destroywalldoor.ogg'
	attacked_sound = list('sound/combat/hits/onwood/fence_hit1.ogg','sound/combat/hits/onwood/fence_hit2.ogg','sound/combat/hits/onwood/fence_hit3.ogg')

/turf/open/floor/blocks/platform
	name = "stone platform"
	desc = "A destructible platform to traverse gaps."
	damage_deflection = 8
	max_integrity = 800
	break_sound = 'sound/combat/hits/onstone/stonedeath.ogg'
	attacked_sound = list('sound/combat/hits/onstone/wallhit.ogg', 'sound/combat/hits/onstone/wallhit2.ogg', 'sound/combat/hits/onstone/wallhit3.ogg')


/turf/open/glass
	name = "Glass floor"
	icon = 'icons/turf/floors.dmi'
	icon_state = "woodglass"

	footstep = FOOTSTEP_PLATING
	barefootstep = FOOTSTEP_HARD_BAREFOOT
	clawfootstep = FOOTSTEP_HARD_CLAW
	heavyfootstep = FOOTSTEP_GENERIC_HEAVY


/turf/open/floor/abyss_sand
	name = "abyssal sand"
	desc = "Warm sand that, sadly, have been mixed with dirt."
	icon_state = "sand_abyss"
	icon = 'icons/delver/abyss_objects.dmi'
	layer = MID_TURF_LAYER
	footstep = FOOTSTEP_SAND
	barefootstep = FOOTSTEP_SOFT_BAREFOOT
	heavyfootstep = FOOTSTEP_GENERIC_HEAVY
	landsound = 'sound/foley/jumpland/grassland.ogg'
	slowdown = 0

/turf/open/floor/abyss_sand/path
	icon_state = "path_abyss"

/turf/open/floor/sand
	name = "gravelly sand"
	desc = "Dark grey gravel which has been ground smooth by water over aeons."
	icon_state = "gravel"
	icon = 'icons/turf/natural/soils.dmi'
	layer = MID_TURF_LAYER
	footstep = FOOTSTEP_SAND
	barefootstep = FOOTSTEP_SOFT_BAREFOOT
	heavyfootstep = FOOTSTEP_GENERIC_HEAVY
	landsound = 'sound/foley/jumpland/grassland.ogg'
	slowdown = 0
	var/randomized = TRUE
	var/blood_sand = FALSE
	smoothing_flags = SMOOTH_EDGE
	smoothing_groups = SMOOTH_GROUP_OPEN_FLOOR + SMOOTH_GROUP_FLOOR_DIRT_ROAD
	neighborlay = "graveledge"

/turf/open/floor/sand/Initialize()
	. = ..()
	dir = pick(GLOB.cardinals)

/turf/open/floor/sand/sandstone
	name = "sandstone gravel"
	desc = "Chunky sandstone, disintegrated naturally over time into a less-than-comfortable cobble."
	icon_state = "sandgravel"

/turf/open/floor/sand/desert
	icon = 'icons/delver/desert_objects.dmi'
	icon_state = "sand-1"
	name = "sand"
	desc = "Warm sand that, sadly, have been mixed with dirt."

/turf/open/floor/sand/desert/Initialize()
	. = ..()
	if(randomized)
		var/random_num = rand(1, 12)
		icon_state = "sand-[random_num]"

/turf/open/floor/sand/desert/proc/make_bloodied()
	if(blood_sand)
		return
	blood_sand = TRUE
	icon_state = "bloody"

	for(var/direction in list(NORTH, SOUTH, EAST, WEST, NORTHEAST, NORTHWEST, SOUTHEAST, SOUTHWEST))
		var/turf/open/floor/sand/desert/adjacent_turf = get_step(src, direction)
		if(istype(adjacent_turf))
			var/dir_name = dir_to_name(direction)
			adjacent_turf.set_bloody_direction(dir_name)

/turf/open/floor/sand/desert/proc/set_bloody_direction(direction_name)
	if(blood_sand)
		return
	blood_sand = TRUE
	icon_state = "bloody-[direction_name]"

/turf/open/floor/sand/desert/proc/dir_to_name(direction)
	switch(direction)
		if(NORTH)
			return "n"
		if(SOUTH)
			return "s"
		if(EAST)
			return "e"
		if(WEST)
			return "w"
		if(NORTHEAST)
			return "ne"
		if(NORTHWEST)
			return "nw"
		if(SOUTHEAST)
			return "se"
		if(SOUTHWEST)
			return "sw"
	return "n" // fallback

/turf/open/floor/sand/bloodied
	icon_state = "bloody"
	randomized = FALSE

/turf/open/floor/sandstone_tile
	icon = 'icons/delver/desert_objects.dmi'
	icon_state = "sandstonefloor-1"

/turf/open/floor/sandstone_tile/two
	icon_state = "sandstonefloor-2"

/turf/open/floor/sandstone_tile/three
	icon_state = "sandstonefloor-3"

/turf/open/floor/sandstone_tile/four
	icon_state = "sandstonefloor-4"

/turf/open/floor/sandstone_tile/five
	icon_state = "sandstonefloor-5"

/turf/open/floor/sandstone_tile/six
	icon_state = "sandstonefloor-6"

/turf/open/floor/cracked_earth
	icon = 'icons/delver/desert_objects.dmi'
	icon_state = "cracked_earth"
	smoothing_groups = SMOOTH_GROUP_OPEN_FLOOR + SMOOTH_GROUP_FLOOR_DIRT_ROAD

/turf/open/floor/cracked_earth/Initialize(mapload)
	. = ..()
	dir = pick(GLOB.cardinals)

/turf/open/floor/flesh
	name = "nerve threads"
	icon = 'icons/turf/flesh_tile.dmi'
	desc = "A pulsing mass of flesh. It shivers and writhes at any touch."
	icon_state = MAP_SWITCH("flesh_tile", "flesh_tile-0")
	transform = MAP_SWITCH(TRANSLATE_MATRIX(-16, -16), matrix())
	smoothing_flags = SMOOTH_BITMASK
	smoothing_groups = SMOOTH_GROUP_OPEN_FLOOR + SMOOTH_GROUP_FLOOR_FLESH
	smoothing_list = SMOOTH_GROUP_FLOOR_FLESH
	layer = HIGH_TURF_LAYER
	color = "#bf5252"

/turf/open/floor/flesh/get_smooth_underlay_icon(mutable_appearance/underlay_appearance, turf/asking_turf, adjacency_dir)
	. = ..()
	if (!.)
		return

	if(!smoothing_flags)
		return

	var/matrix/translation = new
	translation.Translate(-9, -9)
	transform = translation

	underlay_appearance.transform = transform

/turf/open/floor/mushroom
	name = "mushroom floor"
	desc = "A patch of mushrooms."
	icon_state = "mushroom"
	base_icon_state = "mushroom"
	transform = MAP_SWITCH(TRANSLATE_MATRIX(-9, -9), matrix())
	smoothing_flags = SMOOTH_BITMASK
	smoothing_groups = SMOOTH_GROUP_MUSHROOM
	smoothing_list = SMOOTH_GROUP_CLOSED_WALL + SMOOTH_GROUP_MUSHROOM
	icon = 'icons/turf/smooth/floors/mushroom.dmi'
	layer = HIGH_TURF_LAYER
	color = "#777777"
	var/mushroom_color = "red"

/turf/open/floor/mushroom/get_smooth_underlay_icon(mutable_appearance/underlay_appearance, turf/asking_turf, adjacency_dir)
	. = ..()
	if (!.)
		return

	if(!smoothing_flags)
		return

	var/matrix/translation = new
	translation.Translate(-9, -9)
	transform = translation

	underlay_appearance.transform = transform

/turf/open/floor/mushroom/blue
	icon_state = "mushroom_blue"
	base_icon_state = "mushroom_blue"
	icon = 'icons/turf/smooth/floors/mushroom_blue.dmi'
	mushroom_color = "blue"

/turf/open/floor/mushroom/green
	icon_state = "mushroom_green"
	base_icon_state = "mushroom_green"
	icon = 'icons/turf/smooth/floors/mushroom_green.dmi'
	mushroom_color = "green"
