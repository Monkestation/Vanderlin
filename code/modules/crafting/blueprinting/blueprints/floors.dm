/datum/blueprint_recipe/floor
	abstract_type = /datum/blueprint_recipe/floor
	category = "Floors"
	pixel_offsets = FALSE
	build_time = 3 SECONDS

/datum/blueprint_recipe/floor/woodfloor
	name = "Wooden Floor"
	desc = "A ruined wooden floor."
	result_type = /turf/open/floor/ruinedwood
	required_materials = list(
		/obj/item/grown/log/tree/small = 1
	)
	construct_tool = /obj/item/weapon/hammer
	category = "Floors"
	floor_object = TRUE

	skillcraft = /datum/skill/craft/carpentry
	craftdiff = 1

/datum/blueprint_recipe/floor/woodfloor_turned
	name = "Rotated Wooden Floor"
	desc = "A ruined wooden floor."
	result_type = /turf/open/floor/woodturned
	required_materials = list(
		/obj/item/grown/log/tree/small = 1
	)
	construct_tool = /obj/item/weapon/hammer
	category = "Floors"
	floor_object = TRUE

	skillcraft = /datum/skill/craft/carpentry
	craftdiff = 1

/datum/blueprint_recipe/floor/woodfloor_dark
	name = "Dark Wooden Floor"
	desc = "A dark wooden floor."
	result_type = /turf/open/floor/wood
	required_materials = list(
		/obj/item/grown/log/tree/small = 1
	)
	construct_tool = /obj/item/weapon/hammer
	category = "Floors"
	floor_object = TRUE

	skillcraft = /datum/skill/craft/carpentry
	craftdiff = 1

/datum/blueprint_recipe/floor/woodplatform
	name = "Wood Platform"
	desc = "A wooden platform."
	result_type = /turf/open/floor/ruinedwood/platform
	required_materials = list(
		/obj/item/natural/wood/plank = 2
	)
	construct_tool = /obj/item/weapon/hammer
	build_time = 4 SECONDS
	category = "Floors"
	floor_object = TRUE

	skillcraft = /datum/skill/craft/carpentry
	craftdiff = 1


/datum/blueprint_recipe/floor/stonefloor
	name = "Stone Floor"
	desc = "A cobbled stone floor."
	result_type = /turf/open/floor/cobblerock
	required_materials = list(
		/obj/item/natural/stone = 1
	)
	construct_tool = /obj/item/weapon/hammer
	category = "Floors"
	floor_object = TRUE

	skillcraft = /datum/skill/craft/masonry
	craftdiff = 0

/datum/blueprint_recipe/floor/stonefloor/alt
	name = "Alterantive Stone Floor"
	desc = "A cobbled stone floor."
	result_type = /turf/open/floor/cobblerock/alt

/datum/blueprint_recipe/floor/stonefloor_cobblestone
	name = "Cobblestone Floor"
	desc = "A cobblestone floor."
	result_type = /turf/open/floor/cobble
	required_materials = list(
		/obj/item/natural/stone = 1
	)
	construct_tool = /obj/item/weapon/hammer
	category = "Floors"
	floor_object = TRUE

	skillcraft = /datum/skill/craft/masonry
	craftdiff = 0

/datum/blueprint_recipe/floor/stonefloor_cobblestone/alt
	name = "Alternative Cobblestone Floor"
	result_type = /turf/open/floor/cobble/alt

/datum/blueprint_recipe/floor/stonefloor_cobblestone/mossy
	name = "Mossy Cobblestone Floor"
	result_type = /turf/open/floor/cobble/mossy
	required_materials = list(
		/obj/item/natural/stone = 1,
		/obj/item/natural/fibers = 1,
		/obj/item/natural/dirtclod = 1
	)

/datum/blueprint_recipe/floor/stonefloor_blocks
	name = "Stone Block Floor"
	desc = "A stone block floor."
	result_type = /turf/open/floor/blocks
	required_materials = list(
		/obj/item/natural/stoneblock = 1
	)
	construct_tool = /obj/item/weapon/hammer
	category = "Floors"
	floor_object = TRUE

	skillcraft = /datum/skill/craft/masonry
	craftdiff = 1

/datum/blueprint_recipe/floor/stonefloor_newstone
	name = "Newstone Floor"
	desc = "A newstone floor."
	result_type = /turf/open/floor/blocks/newstone
	required_materials = list(
		/obj/item/natural/stoneblock = 1
	)
	construct_tool = /obj/item/weapon/hammer
	category = "Floors"
	floor_object = TRUE

	skillcraft = /datum/skill/craft/masonry
	craftdiff = 1

/datum/blueprint_recipe/floor/stonefloor_bluestone
	name = "Bluestone Floor"
	desc = "A bluestone floor."
	result_type = /turf/open/floor/blocks/bluestone
	required_materials = list(
		/obj/item/natural/stoneblock = 1
	)
	construct_tool = /obj/item/weapon/hammer
	category = "Floors"
	floor_object = TRUE

	skillcraft = /datum/skill/craft/masonry
	craftdiff = 1

/datum/blueprint_recipe/floor/stonefloor_herringbone
	name = "Herringbone Floor"
	desc = "A herringbone stone floor."
	result_type = /turf/open/floor/herringbone
	required_materials = list(
		/obj/item/natural/stoneblock = 1
	)
	construct_tool = /obj/item/weapon/hammer
	category = "Floors"
	floor_object = TRUE

	skillcraft = /datum/skill/craft/masonry
	craftdiff = 2

/datum/blueprint_recipe/floor/stonefloor_hexstone
	name = "Hexstone Floor"
	desc = "A hexagonal stone floor."
	result_type = /turf/open/floor/hexstone
	required_materials = list(
		/obj/item/natural/stoneblock = 1
	)
	construct_tool = /obj/item/weapon/hammer
	category = "Floors"
	floor_object = TRUE

	skillcraft = /datum/skill/craft/masonry
	craftdiff = 2


/datum/blueprint_recipe/floor/stoneplatform
	name = "Stone Platform"
	desc = "A stone platform."
	result_type = /turf/open/floor/blocks/platform
	required_materials = list(
		/obj/item/natural/stoneblock = 2
	)
	construct_tool = /obj/item/weapon/hammer
	build_time = 4 SECONDS
	category = "Floors"
	floor_object = TRUE

	skillcraft = /datum/skill/craft/masonry
	craftdiff = 1


/datum/blueprint_recipe/floor/twig
	name = "Twig Floor"
	desc = "A floor made of twigs."
	result_type = /turf/open/floor/twig
	required_materials = list(
		/obj/item/grown/log/tree/stick = 2
	)
	construct_tool = /obj/item/weapon/knife
	category = "Floors"
	floor_object = TRUE

/datum/blueprint_recipe/floor/twigplatform
	name = "Twig Platform"
	desc = "A platform made of twigs and rope."
	result_type = /turf/open/floor/twig/platform
	required_materials = list(
		/obj/item/grown/log/tree/stick = 3,
		/obj/item/rope = 1
	)
	construct_tool = /obj/item/weapon/hammer
	build_time = 4 SECONDS
	category = "Floors"
	floor_object = TRUE

	craftdiff = 1

/datum/blueprint_recipe/floor/dirtroad
	name = "Dirt Road"
	desc = "A dirt road."
	result_type = /turf/open/floor/dirt/road
	required_materials = list(
		/obj/item/natural/fibers = 1,
		/obj/item/natural/dirtclod = 3
	)
	construct_tool = /obj/item/weapon/shovel
	category = "Floors"
	floor_object = TRUE

/datum/blueprint_recipe/floor/dirt
	name = "Dirt"
	desc = "Some dirt."
	result_type = /turf/open/floor/dirt
	required_materials = list(
		/obj/item/natural/fibers = 1,
		/obj/item/natural/dirtclod = 3
	)
	construct_tool = /obj/item/weapon/shovel
	category = "Floors"
	floor_object = TRUE

/datum/blueprint_recipe/floor/tavern
	name = "Checkered Floor"
	desc = "Checkered floor of stone and clay bricks."
	result_type = /turf/open/floor/tile/kitchen
	required_materials = list(
		/obj/item/natural/stoneblock = 2,
		/obj/item/natural/brick = 2
	)
	construct_tool = /obj/item/weapon/hammer
	category = "Floors"
	floor_object = TRUE

	skillcraft = /datum/skill/craft/masonry
	craftdiff = 2

/datum/blueprint_recipe/floor/tile
	name = "Tiled Floor"
	desc = "Tiled floor of stone and clay bricks."
	result_type = /turf/open/floor/tile
	required_materials = list(
		/obj/item/natural/stoneblock = 2,
		/obj/item/natural/brick = 2
	)
	construct_tool = /obj/item/weapon/hammer
	category = "Floors"
	floor_object = TRUE

	skillcraft = /datum/skill/craft/masonry
	craftdiff = 2

/datum/blueprint_recipe/floor/tile_green
	name = "Green Tiled Floor"
	desc = "Tiled floor of stone and clay bricks."
	result_type = /turf/open/floor/tile/checker_green
	required_materials = list(
		/obj/item/natural/stoneblock = 2,
		/obj/item/natural/brick = 2
	)
	construct_tool = /obj/item/weapon/hammer
	category = "Floors"
	floor_object = TRUE

	skillcraft = /datum/skill/craft/masonry
	craftdiff = 2

/datum/blueprint_recipe/floor/masonic
	name = "Masonic Tile"
	desc = "Masonic flooring made of stone blocks."
	result_type = /turf/open/floor/tile/masonic
	required_materials = list(
		/obj/item/natural/stoneblock = 2
	)
	construct_tool = /obj/item/weapon/hammer
	category = "Floors"
	floor_object = TRUE

	skillcraft = /datum/skill/craft/masonry
	craftdiff = 2

/datum/blueprint_recipe/floor/masonic/single
	name = "Masonic Single Tile"
	result_type = /turf/open/floor/tile/masonic/single

/datum/blueprint_recipe/floor/masonic/inverted
	name = "Inverted Masonic Tile"
	result_type = /turf/open/floor/tile/masonic/inverted

/datum/blueprint_recipe/floor/masonic/spiral
	name = "Spiral Masonic Tile"
	result_type = /turf/open/floor/tile/masonic/spiral
	craftdiff = 3

/datum/blueprint_recipe/floor/brick
	name = "Brick Tile"
	desc = "Brick flooring."
	result_type = /turf/open/floor/tile/brick
	required_materials = list(
		/obj/item/natural/brick = 2
	)
	construct_tool = /obj/item/weapon/hammer
	category = "Floors"
	floor_object = TRUE

	skillcraft = /datum/skill/craft/masonry
	craftdiff = 1

/datum/blueprint_recipe/floor/brick/brown
	name = "Brown Brick"
	result_type = /turf/open/floor/tile/brownbrick


/datum/blueprint_recipe/floor/diamond
	name = "Diamond Tile"
	desc = "Luxurious diamond-pattern flooring made of stone blocks."
	result_type = /turf/open/floor/tile/diamond
	required_materials = list(
		/obj/item/natural/stoneblock = 2
	)
	construct_tool = /obj/item/weapon/hammer
	category = "Floors"
	floor_object = TRUE
	skillcraft = /datum/skill/craft/masonry
	craftdiff = 2

/datum/blueprint_recipe/floor/diamond_blue
	name = "Blue Diamond Tile"
	desc = "Elegant blue diamond-pattern flooring made of stone blocks."
	result_type = /turf/open/floor/tile/diamond/blue
	required_materials = list(
		/obj/item/natural/stoneblock = 2
	)
	construct_tool = /obj/item/weapon/hammer
	category = "Floors"
	floor_object = TRUE
	skillcraft = /datum/skill/craft/masonry
	craftdiff = 2

/datum/blueprint_recipe/floor/diamond_purple
	name = "Purple Diamond Tile"
	desc = "Regal purple diamond-pattern flooring made of stone blocks."
	result_type = /turf/open/floor/tile/diamond/purple
	required_materials = list(
		/obj/item/natural/stoneblock = 2
	)
	construct_tool = /obj/item/weapon/hammer
	category = "Floors"
	floor_object = TRUE
	skillcraft = /datum/skill/craft/masonry
	craftdiff = 2

/datum/blueprint_recipe/floor/bath
	name = "Bath Tile"
	desc = "Clean bathroom-style tiling made of stone blocks."
	result_type = /turf/open/floor/tile/bath
	required_materials = list(
		/obj/item/natural/stoneblock = 2
	)
	construct_tool = /obj/item/weapon/hammer
	category = "Floors"
	floor_object = TRUE
	skillcraft = /datum/skill/craft/masonry
	craftdiff = 2

/datum/blueprint_recipe/floor/bath/pool
	name = "Pool Edge Tile"
	desc = "Clean bathroom-style tiling made of stone blocks."
	result_type = /turf/open/floor/tile/bath/pool
	required_materials = list(
		/obj/item/natural/stoneblock = 2
	)
	construct_tool = /obj/item/weapon/hammer
	category = "Floors"
	floor_object = TRUE
	skillcraft = /datum/skill/craft/masonry
	craftdiff = 2

/datum/blueprint_recipe/floor/bfloorz
	name = "Blue Floor Tile"
	desc = "Distinctive blue flooring made of stone blocks."
	result_type = /turf/open/floor/tile/bfloorz
	required_materials = list(
		/obj/item/natural/stoneblock = 2
	)
	construct_tool = /obj/item/weapon/hammer
	category = "Floors"
	floor_object = TRUE
	skillcraft = /datum/skill/craft/masonry
	craftdiff = 2

/datum/blueprint_recipe/floor/tilerg
	name = "Green Tile"
	desc = "Decorative green tiling made of stone blocks."
	result_type = /turf/open/floor/tile/tilerg
	required_materials = list(
		/obj/item/natural/stoneblock = 2
	)
	construct_tool = /obj/item/weapon/hammer
	category = "Floors"
	floor_object = TRUE
	skillcraft = /datum/skill/craft/masonry
	craftdiff = 2

/datum/blueprint_recipe/floor/checker
	name = "Checker Tile"
	desc = "Classic checkered flooring made of stone blocks."
	result_type = /turf/open/floor/tile/checker
	required_materials = list(
		/obj/item/natural/stoneblock = 2
	)
	construct_tool = /obj/item/weapon/hammer
	category = "Floors"
	floor_object = TRUE
	skillcraft = /datum/skill/craft/masonry
	craftdiff = 2

/datum/blueprint_recipe/floor/checkeralt
	name = "Alternative Checker Tile"
	desc = "Alternative checkered tile pattern made of stone blocks."
	result_type = /turf/open/floor/tile/checkeralt
	required_materials = list(
		/obj/item/natural/stoneblock = 2
	)
	construct_tool = /obj/item/weapon/hammer
	category = "Floors"
	floor_object = TRUE
	skillcraft = /datum/skill/craft/masonry
	craftdiff = 2

/datum/blueprint_recipe/floor/church
	name = "Church Tile"
	desc = "Flooring fit for a clergy."
	result_type = /turf/open/floor/church
	required_materials = list(
		/obj/item/natural/stoneblock = 2
	)
	construct_tool = /obj/item/weapon/hammer
	category = "Floors"
	floor_object = TRUE
	skillcraft = /datum/skill/craft/masonry
	craftdiff = 3

/datum/blueprint_recipe/floor/church_purple
	name = "Purple Church Tile"
	desc = "Flooring fit for a clergy."
	result_type = /turf/open/floor/church/purple
	required_materials = list(
		/obj/item/natural/brick = 2
	)
	construct_tool = /obj/item/weapon/hammer
	category = "Floors"
	floor_object = TRUE
	skillcraft = /datum/skill/craft/masonry
	craftdiff = 3

/datum/blueprint_recipe/floor/marble_church
	name = "Marble Church Floor"
	desc = "Flooring fit for a clergy."
	result_type = /turf/open/floor/churchmarble
	required_materials = list(
		/obj/item/natural/stoneblock = 3
	)
	construct_tool = /obj/item/weapon/hammer
	category = "Floors"
	floor_object = TRUE
	skillcraft = /datum/skill/craft/masonry
	craftdiff = 4

/datum/blueprint_recipe/floor/churchbrick
	name = "Church Brick Floor"
	desc = "Flooring fit for a clergy."
	result_type = /turf/open/floor/churchbrick
	required_materials = list(
		/obj/item/natural/brick = 2
	)
	construct_tool = /obj/item/weapon/hammer
	category = "Floors"
	floor_object = TRUE
	skillcraft = /datum/skill/craft/masonry
	craftdiff = 3

/datum/blueprint_recipe/floor/roughchurch
	name = "Rough Church Brick Floor"
	desc = "Flooring fit for a clergy."
	result_type = /turf/open/floor/churchrough
	required_materials = list(
		/obj/item/natural/stoneblock = 2
	)
	construct_tool = /obj/item/weapon/hammer
	category = "Floors"
	floor_object = TRUE
	skillcraft = /datum/skill/craft/masonry
	craftdiff = 2

/datum/blueprint_recipe/floor/roughchurch_purple
	name = "Purple Rough Church Brick Floor"
	desc = "Flooring fit for a clergy."
	result_type = /turf/open/floor/churchrough/purple
	required_materials = list(
		/obj/item/natural/brick = 2
	)
	construct_tool = /obj/item/weapon/hammer
	category = "Floors"
	floor_object = TRUE
	skillcraft = /datum/skill/craft/masonry
	craftdiff = 2

/datum/blueprint_recipe/floor/grass
	name = "Grass"
	desc = "Some grass."
	result_type = /turf/open/floor/grass
	required_materials = list(
		/obj/item/natural/fibers = 2,
		/obj/item/neuFarm/seed = 1,
		/obj/item/natural/dirtclod = 2
	)
	construct_tool = /obj/item/weapon/shovel
	category = "Floors"
	floor_object = TRUE

/datum/blueprint_recipe/floor/grassyellow
	name = "Yellow Grass"
	desc = "Some grass."
	result_type = /turf/open/floor/grass/yel
	required_materials = list(
		/obj/item/natural/fibers = 2,
		/obj/item/neuFarm/seed = 1,
		/obj/item/natural/dirtclod = 2
	)
	construct_tool = /obj/item/weapon/shovel
	category = "Floors"
	floor_object = TRUE

/datum/blueprint_recipe/floor/grassred
	name = "Red Grass"
	desc = "Some grass."
	result_type = /turf/open/floor/grass/red
	required_materials = list(
		/obj/item/natural/fibers = 2,
		/obj/item/neuFarm/seed = 1,
		/obj/item/natural/dirtclod = 2
	)
	construct_tool = /obj/item/weapon/shovel
	category = "Floors"
	floor_object = TRUE

/datum/blueprint_recipe/floor/grassmixyel
	name = "Mixed Yellow Grass"
	desc = "Some grass."
	result_type = /turf/open/floor/grass/mixyel
	required_materials = list(
		/obj/item/natural/fibers = 2,
		/obj/item/neuFarm/seed = 1,
		/obj/item/natural/dirtclod = 2
	)
	construct_tool = /obj/item/weapon/shovel
	category = "Floors"
	floor_object = TRUE

/datum/blueprint_recipe/floor/grasscold
	name = "Tundra Grass"
	desc = "Some grass."
	result_type = /turf/open/floor/grass/cold
	required_materials = list(
		/obj/item/natural/fibers = 2,
		/obj/item/neuFarm/seed = 1,
		/obj/item/natural/dirtclod = 2
	)
	construct_tool = /obj/item/weapon/shovel
	category = "Floors"
	floor_object = TRUE

/datum/blueprint_recipe/floor/grasshealthy
	name = "Healthy Grass"
	desc = "A bit of extra fertilizer makes the difference."
	result_type = /turf/open/floor/grass/healthy
	required_materials = list(
		/obj/item/natural/fibers = 3,
		/obj/item/neuFarm/seed = 1,
		/obj/item/natural/dirtclod = 3
	)
	construct_tool = /obj/item/weapon/shovel
	category = "Floors"
	floor_object = TRUE

/datum/blueprint_recipe/floor/hay
	name = "Hay"
	desc = "Some hay."
	result_type = /turf/open/floor/hay
	required_materials = list(
		/obj/item/natural/fibers = 3,
		/obj/item/natural/chaff = 2,
		/obj/item/natural/dirtclod = 1
	)
	construct_tool = /obj/item/weapon/pitchfork
	category = "Floors"
	floor_object = TRUE

/datum/blueprint_recipe/floor/woodflooralt
	name = "Alternative Wooden Floor"
	desc = "A ruined wooden floor."
	result_type = /turf/open/floor/ruinedwood/alt
	required_materials = list(
		/obj/item/grown/log/tree/small = 1
	)
	construct_tool = /obj/item/weapon/hammer
	category = "Floors"
	floor_object = TRUE

	skillcraft = /datum/skill/craft/carpentry
	craftdiff = 1

/datum/blueprint_recipe/floor/woodfloortwo
	name = "Alternative Wooden Floor"
	desc = "A ruined wooden floor."
	result_type = /turf/open/floor/ruinedwood/two
	required_materials = list(
		/obj/item/grown/log/tree/small = 1
	)
	construct_tool = /obj/item/weapon/hammer
	category = "Floors"
	floor_object = TRUE

	skillcraft = /datum/skill/craft/carpentry
	craftdiff = 1

/datum/blueprint_recipe/floor/woodfloorturned
	name = "Rotated Wooden Floor"
	desc = "A ruined wooden floor."
	result_type = /turf/open/floor/ruinedwood/turned
	required_materials = list(
		/obj/item/grown/log/tree/small = 1
	)
	construct_tool = /obj/item/weapon/hammer
	category = "Floors"
	floor_object = TRUE

	skillcraft = /datum/skill/craft/carpentry
	craftdiff = 1

/datum/blueprint_recipe/floor/woodfloorturnedalt
	name = "Alternative Rotated Ruined Wooden Floor"
	desc = "A ruined wooden floor."
	result_type = /turf/open/floor/ruinedwood/turned/alt
	required_materials = list(
		/obj/item/grown/log/tree/small = 1
	)
	construct_tool = /obj/item/weapon/hammer
	category = "Floors"
	floor_object = TRUE

	skillcraft = /datum/skill/craft/carpentry
	craftdiff = 1

/datum/blueprint_recipe/floor/woodfloorturned
	name = "Rotated Ruined Wooden Floor"
	desc = "A ruined wooden floor."
	result_type = /turf/open/floor/ruinedwood/turned
	required_materials = list(
		/obj/item/grown/log/tree/small = 1
	)
	construct_tool = /obj/item/weapon/hammer
	category = "Floors"
	floor_object = TRUE

	skillcraft = /datum/skill/craft/carpentry
	craftdiff = 1

/datum/blueprint_recipe/floor/ruinedspiral
	name = "Spiral Ruined Wooden Floor"
	desc = "A ruined wooden floor."
	result_type = /turf/open/floor/ruinedwood/spiral
	required_materials = list(
		/obj/item/grown/log/tree/small = 1
	)
	construct_tool = /obj/item/weapon/hammer
	category = "Floors"
	floor_object = TRUE

	skillcraft = /datum/skill/craft/carpentry
	craftdiff = 1

/datum/blueprint_recipe/floor/ruinedspiralfade
	name = "Faded Spiral Ruined Wooden Floor"
	desc = "A ruined wooden floor."
	result_type = /turf/open/floor/ruinedwood/spiralfade
	required_materials = list(
		/obj/item/grown/log/tree/small = 1
	)
	construct_tool = /obj/item/weapon/hammer
	category = "Floors"
	floor_object = TRUE

	skillcraft = /datum/skill/craft/carpentry
	craftdiff = 1

/datum/blueprint_recipe/floor/ruinedchevron
	name = "Chevron Ruined Wooden Floor"
	desc = "A ruined wooden floor."
	result_type = /turf/open/floor/ruinedwood/chevron
	required_materials = list(
		/obj/item/grown/log/tree/small = 1
	)
	construct_tool = /obj/item/weapon/hammer
	category = "Floors"
	floor_object = TRUE

	skillcraft = /datum/skill/craft/carpentry
	craftdiff = 1

/datum/blueprint_recipe/floor/ruineddark
	name = "Dark Ruined Wooden Floor"
	desc = "A ruined wooden floor."
	result_type = /turf/open/floor/ruinedwood/darker
	required_materials = list(
		/obj/item/grown/log/tree/small = 1
	)
	construct_tool = /obj/item/weapon/hammer
	category = "Floors"
	floor_object = TRUE

	skillcraft = /datum/skill/craft/carpentry
	craftdiff = 1

/datum/blueprint_recipe/floor/ruineddarkturned
	name = "Rotated Dark Ruined Wooden Floor"
	desc = "A ruined wooden floor."
	result_type = /turf/open/floor/ruinedwood/turned/darker
	required_materials = list(
		/obj/item/grown/log/tree/small = 1
	)
	construct_tool = /obj/item/weapon/hammer
	category = "Floors"
	floor_object = TRUE

	skillcraft = /datum/skill/craft/carpentry
	craftdiff = 1

/datum/blueprint_recipe/floor/roof
	name = "Tile Roofing"
	desc = "Tiled roof made of clay bricks."
	result_type = /turf/open/floor/rooftop
	required_materials = list(
		/obj/item/natural/brick = 2
	)
	supports_directions = TRUE
	construct_tool = /obj/item/weapon/hammer
	category = "Floors"
	floor_object = TRUE

	skillcraft = /datum/skill/craft/masonry
	craftdiff = 2

/datum/blueprint_recipe/floor/roof_green
	name = "Stone Tile Roofing"
	desc = "Tiled roof made of stone blocks."
	result_type = /turf/open/floor/rooftop/green
	required_materials = list(
		/obj/item/natural/stoneblock = 2
	)
	supports_directions = TRUE
	construct_tool = /obj/item/weapon/hammer
	category = "Floors"
	floor_object = TRUE

	skillcraft = /datum/skill/craft/masonry
	craftdiff = 2

/datum/blueprint_recipe/floor/stonefloor_blocksred
	name = "Red Stone Block Floor"
	desc = "A stone block floor."
	result_type = /turf/open/floor/blocks/stonered
	required_materials = list(
		/obj/item/natural/stoneblock = 1
	)
	construct_tool = /obj/item/weapon/hammer
	category = "Floors"
	floor_object = TRUE

	skillcraft = /datum/skill/craft/masonry
	craftdiff = 1

/datum/blueprint_recipe/floor/stonefloor_blocksgreen
	name = "Green Stone Block Floor"
	desc = "A stone block floor."
	result_type = /turf/open/floor/blocks/green
	required_materials = list(
		/obj/item/natural/stoneblock = 1
	)
	construct_tool = /obj/item/weapon/hammer
	category = "Floors"
	floor_object = TRUE

	skillcraft = /datum/skill/craft/masonry
	craftdiff = 1

/datum/blueprint_recipe/floor/stonefloor_blocksredtiny
	name = "Tiny Red Stone Block Floor"
	desc = "A stone block floor."
	result_type = /turf/open/floor/blocks/stonered/tiny
	required_materials = list(
		/obj/item/natural/stoneblock = 1
	)
	construct_tool = /obj/item/weapon/hammer
	category = "Floors"
	floor_object = TRUE

	skillcraft = /datum/skill/craft/masonry
	craftdiff = 1

/datum/blueprint_recipe/floor/stonefloor_newblue
	name = "New Blue Stone Block Floor"
	desc = "A stone block floor."
	result_type = /turf/open/floor/blocks/newstone/alt
	required_materials = list(
		/obj/item/natural/stoneblock = 1
	)
	construct_tool = /obj/item/weapon/hammer
	category = "Floors"
	floor_object = TRUE

	skillcraft = /datum/skill/craft/masonry
	craftdiff = 1

/datum/blueprint_recipe/floor/paving
	name = "Paved Stone Block Floor"
	desc = "A stone block floor."
	result_type = /turf/open/floor/blocks/paving
	required_materials = list(
		/obj/item/natural/stoneblock = 2
	)
	construct_tool = /obj/item/weapon/hammer
	category = "Floors"
	floor_object = TRUE

	skillcraft = /datum/skill/craft/masonry
	craftdiff = 2

/datum/blueprint_recipe/floor/pavingvertical
	name = "Vertical Paved Stone Block Floor"
	desc = "A stone block floor."
	result_type = /turf/open/floor/blocks/paving/vert
	required_materials = list(
		/obj/item/natural/stoneblock = 2
	)
	construct_tool = /obj/item/weapon/hammer
	category = "Floors"
	floor_object = TRUE

	skillcraft = /datum/skill/craft/masonry
	craftdiff = 2

/datum/blueprint_recipe/floor/greenstone
	name = "Rough Greenstone Floors"
	desc = "A stone floor."
	result_type = /turf/open/floor/greenstone
	required_materials = list(
		/obj/item/natural/stone = 2
	)
	construct_tool = /obj/item/weapon/hammer
	category = "Floors"
	floor_object = TRUE

	skillcraft = /datum/skill/craft/masonry
	craftdiff = 1

/datum/blueprint_recipe/floor/greenstone/runed
	name = "Rough Runed Greenstone Floors"
	required_materials = list(
		/obj/item/natural/stone = 2,
		/obj/item/gem/amethyst = 1,
	)
	craftdiff = 3
	skillcraft = /datum/skill/magic/arcane
	result_type = /turf/open/floor/greenstone/runed

/datum/blueprint_recipe/floor/greenstone/glyph
	name = "Rough Glyph Greenstone Floors"
	required_materials = list(
		/obj/item/natural/stone = 2,
		/obj/item/gem/amethyst = 1,
	)
	craftdiff = 2
	skillcraft = /datum/skill/magic/arcane
	result_type = /turf/open/floor/greenstone/glyph1

/datum/blueprint_recipe/floor/greenstone/glyph/two
	result_type = /turf/open/floor/greenstone/glyph2

/datum/blueprint_recipe/floor/greenstone/glyph/three
	result_type = /turf/open/floor/greenstone/glyph3

/datum/blueprint_recipe/floor/greenstone/glyph/four
	result_type = /turf/open/floor/greenstone/glyph4

/datum/blueprint_recipe/floor/greenstone/glyph/five
	result_type = /turf/open/floor/greenstone/glyph5

/datum/blueprint_recipe/floor/greenstone/glyph/six
	result_type = /turf/open/floor/greenstone/glyph6

/datum/blueprint_recipe/floor/glass
	name = "Wood Framed Glass Floor"
	desc = "A glass floor."
	required_materials = list(
		/obj/item/natural/wood/plank = 2,
		/obj/item/natural/glass = 2,
	)
	craftdiff = 2
	skillcraft = /datum/skill/craft/carpentry
	result_type = /turf/open/glass

/datum/blueprint_recipe/floor/concrete
	name = "Concrete Floor"
	desc = "A slab of stone"
	required_materials = list(
		/obj/item/natural/stone = 2,
	)
	craftdiff = 2
	skillcraft = /datum/skill/craft/masonry
	result_type = /turf/open/floor/concrete

/datum/blueprint_recipe/floor/metal
	name = "Metal Floor"
	desc = "Ingots hammered into a floor"
	required_materials = list(
		/obj/item/ingot/iron = 2,
	)
	craftdiff = 2
	skillcraft = /datum/skill/craft/blacksmithing
	result_type = /turf/open/floor/metal

/datum/blueprint_recipe/floor/metal/alt
	name = "Alternative Metal Floor"
	result_type = /turf/open/floor/metal/alt

/datum/blueprint_recipe/floor/metal/grate
	name = "Metal Grate (Closed)"
	result_type = /turf/open/floor/metal/barograte

/datum/blueprint_recipe/floor/metal/opengrate
	name = "Metal Grate (Open)"
	result_type = /turf/open/floor/metal/barograte/open
