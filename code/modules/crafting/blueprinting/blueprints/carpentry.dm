
/datum/blueprint_recipe/carpentry
	abstract_type = /datum/blueprint_recipe/carpentry
	skillcraft = /datum/skill/craft/carpentry
	category = "Carpentry"
	construct_tool = /obj/item/weapon/hammer
	craftsound = 'sound/foley/Building-01.ogg'
	verbage = "build"
	verbage_tp = "builds"
	edge_density = FALSE

/datum/blueprint_recipe/carpentry/barrel
	name = "wooden barrel"
	desc = "A sturdy wooden barrel for fermentation."
	result_type = /obj/structure/fermentation_keg
	required_materials = list(/obj/item/grown/log/tree/small = 1)
	craftdiff = 0

/datum/blueprint_recipe/carpentry/door
	name = "wooden door"
	desc = "A basic wooden door."
	result_type = /obj/structure/door
	required_materials = list(/obj/item/grown/log/tree/small = 2)
	supports_directions = TRUE
	craftdiff = 0
	build_time = 4 SECONDS

/datum/blueprint_recipe/carpentry/swing_door
	name = "swing door"
	desc = "A door that swings both ways."
	result_type = /obj/structure/door/swing
	required_materials = list(/obj/item/grown/log/tree/small = 2)
	supports_directions = TRUE
	craftdiff = 0

/datum/blueprint_recipe/carpentry/deadbolt_door
	name = "wooden door (deadbolt)"
	desc = "A reinforced wooden door with a deadbolt."
	result_type = /obj/structure/door/weak/bolt
	required_materials = list(
		/obj/item/grown/log/tree/small = 2,
		/obj/item/grown/log/tree/stick = 1
	)
	supports_directions = TRUE
	craftdiff = 1
	build_time = 4 SECONDS

/datum/blueprint_recipe/carpentry/viewport_door
	name = "wooden door (viewport)"
	desc = "A wooden door with an iron viewport."
	result_type = /obj/structure/door/viewport
	required_materials = list(
		/obj/item/grown/log/tree/small = 2,
		/obj/item/ingot/iron = 1
	)
	supports_directions = TRUE
	craftdiff = 2
	build_time = 4 SECONDS

/datum/blueprint_recipe/carpentry/fancy_door
	name = "fancy wooden door"
	desc = "An ornately crafted wooden door."
	result_type = /obj/structure/door/fancy
	required_materials = list(/obj/item/grown/log/tree/small = 2)
	supports_directions = TRUE
	craftdiff = 3
	build_time = 4 SECONDS

/datum/blueprint_recipe/carpentry/bin
	name = "wooden bin"
	desc = "A simple wooden storage bin."
	result_type = /obj/item/bin
	required_materials = list(/obj/item/grown/log/tree/small = 2)
	craftdiff = 0

/datum/blueprint_recipe/carpentry/chair
	name = "wooden chair"
	desc = "A basic wooden chair."
	result_type = /obj/structure/chair/wood/alt/chair3/crafted
	required_materials = list(/obj/item/grown/log/tree/small = 1)
	supports_directions = TRUE
	craftdiff = 0

/datum/blueprint_recipe/carpentry/fancy_chair
	name = "fancy wooden chair"
	desc = "An elegant wooden chair with silk upholstery."
	result_type = /obj/structure/chair/wood/alt/fancy/crafted
	required_materials = list(
		/obj/item/grown/log/tree/small = 1,
		/obj/item/natural/silk = 1
	)
	supports_directions = TRUE
	craftdiff = 2

/datum/blueprint_recipe/carpentry/stool
	name = "wooden stool"
	desc = "A simple wooden stool."
	result_type = /obj/structure/chair/stool/crafted
	required_materials = list(/obj/item/grown/log/tree/small = 1)
	supports_directions = TRUE
	craftdiff = 0

/datum/blueprint_recipe/carpentry/stool/bar
	name = "barstool"
	desc = "Stool with a cloth cushion."
	result_type = /obj/structure/chair/stool/bar
	required_materials = list(
		/obj/item/grown/log/tree/small = 1,
		/obj/item/natural/cloth = 1
	)
	supports_directions = TRUE
	craftdiff = 2

/datum/blueprint_recipe/carpentry/loom
	name = "loom"
	desc = "A weaving loom for creating textiles."
	result_type = /obj/machinery/loom
	required_materials = list(
		/obj/item/grown/log/tree/small = 2,
		/obj/item/grown/log/tree/stick = 2,
		/obj/item/natural/fibers = 2
	)
	supports_directions = TRUE
	craftdiff = 1

/datum/blueprint_recipe/carpentry/lantern_post
	name = "lantern post"
	desc = "A tall wooden post for mounting lanterns."
	result_type = /obj/machinery/light/fueled/lanternpost/unfixed
	required_materials = list(
		/obj/item/grown/log/tree/small = 2,
		/obj/item/grown/log/tree/stick = 2
	)
	craftdiff = 1

/datum/blueprint_recipe/carpentry/wooden_cross
	name = "wooden cross"
	desc = "A religious wooden cross."
	result_type = /obj/structure/fluff/psycross/crafted
	required_materials = list(
		/obj/item/grown/log/tree/small = 1,
		/obj/item/grown/log/tree/stake = 3
	)
	craftdiff = 1

/datum/blueprint_recipe/carpentry/pyre
	name = "wooden pyre"
	desc = "A wooden funeral pyre."
	result_type = /obj/machinery/light/fueled/campfire/pyre
	required_materials = list(
		/obj/item/grown/log/tree/small = 2,
		/obj/item/grown/log/tree/stake = 3
	)
	craftdiff = 1

/datum/blueprint_recipe/carpentry/psydon_wooden_cross
	name = "wooden psycross"
	desc = "A wooden psycross dedicated to Psydon."
	required_materials = list(
		/obj/item/grown/log/tree/small = 1,
		/obj/item/grown/log/tree/stake = 3
	)
	result_type = /obj/structure/fluff/psycross/psydon
	craftdiff = 1

/datum/blueprint_recipe/carpentry/wooden_stairs_down
	name = "wooden stairs (down)"
	desc = "Wooden stairs leading downward."
	result_type = /obj/structure/stairs/d
	required_materials = list(
		/obj/item/grown/log/tree/small = 1,
		/obj/item/natural/wood/plank = 2
	)
	supports_directions = TRUE
	craftdiff = 1

/datum/blueprint_recipe/carpentry/wooden_stairs_down/check_craft_requirements(mob/user, turf/T, obj/structure/blueprint/blueprint)
	var/turf/partner = get_step_multiz(get_turf(blueprint), DOWN)
	partner = get_step(partner, turn(blueprint.blueprint_dir, 180))
	if(!isopenturf(partner))
		to_chat(user, span_warning("Need an openspace at the turf below!"))
		return FALSE
	. = ..()

/datum/blueprint_recipe/carpentry/railing
	name = "railing"
	desc = "A wooden safety railing."
	result_type = /obj/structure/fluff/railing/wood
	required_materials = list(/obj/item/grown/log/tree/small = 1)
	supports_directions = TRUE
	craftdiff = 0

/datum/blueprint_recipe/carpentry/palisade
	name = "palisade"
	desc = "A wooden defensive palisade."
	result_type = /obj/structure/fluff/railing/tall/palisade
	required_materials = list(/obj/item/grown/log/tree/stake = 2)
	supports_directions = TRUE
	craftdiff = 0

/datum/blueprint_recipe/carpentry/fence
	name = "fence"
	desc = "A tall wooden fence."
	result_type = /obj/structure/fluff/railing/tall
	required_materials = list(/obj/item/grown/log/tree/small = 1, /obj/item/natural/wood/plank = 2)
	supports_directions = TRUE
	craftdiff = 0

/datum/blueprint_recipe/carpentry/chest
	name = "chest"
	desc = "A wooden storage chest."
	result_type = /obj/structure/closet/crate/chest/crafted
	required_materials = list(
		/obj/item/grown/log/tree/stake = 1,
		/obj/item/grown/log/tree/small = 2
	)
	supports_directions = TRUE
	craftdiff = 0

/datum/blueprint_recipe/carpentry/closet
	name = "closet"
	desc = "A wooden storage closet."
	result_type = /obj/structure/closet/crate/crafted_closet/crafted
	required_materials = list(
		/obj/item/grown/log/tree/small = 2,
		/obj/item/natural/wood/plank = 1
	)
	supports_directions = TRUE
	craftdiff = 1

/datum/blueprint_recipe/carpentry/coffin
	name = "wooden coffin"
	desc = "A wooden burial coffin."
	result_type = /obj/structure/closet/crate/coffin
	required_materials = list(/obj/item/natural/wood/plank = 3)
	craftdiff = 1

/datum/blueprint_recipe/carpentry/hay_bed
	name = "hay bed"
	desc = "A simple bed stuffed with hay."
	result_type = /obj/structure/bed/hay
	required_materials = list(
		/obj/item/natural/wood/plank = 2,
		/obj/item/natural/cloth = 1
	)
	construct_tool = /obj/item/needle // Special case - needs sewing
	supports_directions = TRUE
	craftdiff = 2

/datum/blueprint_recipe/carpentry/wool_bed
	name = "wool bed"
	desc = "A comfortable bed with wool stuffing."
	result_type = /obj/structure/bed/wool
	required_materials = list(
		/obj/item/natural/wood/plank = 2,
		/obj/item/natural/cloth = 1
	)
	construct_tool = /obj/item/needle // Special case - needs sewing
	supports_directions = TRUE
	craftdiff = 4

/datum/blueprint_recipe/carpentry/double_wool_bed
	name = "double wool bed"
	desc = "A large double bed with wool stuffing."
	result_type = /obj/structure/bed/wool/double
	required_materials = list(
		/obj/item/natural/wood/plank = 3,
		/obj/item/natural/cloth = 3
	)
	construct_tool = /obj/item/needle // Special case - needs sewing
	supports_directions = TRUE
	craftdiff = 4

/datum/blueprint_recipe/carpentry/nice_bed
	name = "nice bed"
	desc = "A luxurious bed with fur coverings."
	result_type = /obj/structure/bed
	required_materials = list(
		/obj/item/natural/wood/plank = 2,
		/obj/item/natural/cloth = 2,
		/obj/item/natural/fur = 1
	)
	construct_tool = /obj/item/needle // Special case - needs sewing
	supports_directions = TRUE
	craftdiff = 5

/datum/blueprint_recipe/carpentry/inn_bed
	name = "nice bed without sheets"
	desc = "A quality bed frame without bedding."
	result_type = /obj/structure/bed/inn
	required_materials = list(
		/obj/item/natural/wood/plank = 2,
		/obj/item/natural/cloth = 2,
		/obj/item/natural/fur = 1
	)
	construct_tool = /obj/item/needle // Special case - needs sewing
	supports_directions = TRUE
	craftdiff = 5

/datum/blueprint_recipe/carpentry/double_inn_bed
	name = "double nice bed"
	desc = "A large quality bed frame."
	result_type = /obj/structure/bed/inn/double
	required_materials = list(
		/obj/item/natural/wood/plank = 2,
		/obj/item/natural/cloth = 4,
		/obj/item/natural/fur = 2
	)
	construct_tool = /obj/item/needle // Special case - needs sewing
	supports_directions = TRUE
	craftdiff = 5

/datum/blueprint_recipe/carpentry/custom_sign
	name = "custom sign"
	desc = "A wooden sign for custom messages."
	result_type = /obj/structure/fluff/customsign
	required_materials = list(
		/obj/item/grown/log/tree/stick = 1,
		/obj/item/natural/wood/plank = 1
	)
	supports_directions = TRUE
	craftdiff = 0

/datum/blueprint_recipe/carpentry/training_dummy
	name = "training dummy"
	desc = "A practice dummy for combat training."
	result_type = /obj/structure/fluff/statue/tdummy
	required_materials = list(
		/obj/item/natural/wood/plank = 1,
		/obj/item/grown/log/tree/small = 1,
		/obj/item/grown/log/tree/stick = 1
	)
	craftdiff = 1

/datum/blueprint_recipe/carpentry/display_stand
	name = "display stand"
	desc = "A stand for displaying items."
	result_type = /obj/structure/mannequin
	required_materials = list(
		/obj/item/natural/wood/plank = 1,
		/obj/item/grown/log/tree/small = 1,
		/obj/item/grown/log/tree/stick = 3
	)
	supports_directions = TRUE
	craftdiff = 2

/datum/blueprint_recipe/carpentry/female_mannequin
	name = "female mannequin"
	desc = "A female display mannequin."
	result_type = /obj/structure/mannequin/male/female
	required_materials = list(
		/obj/item/natural/wood/plank = 1,
		/obj/item/grown/log/tree/small = 1,
		/obj/item/ingot/iron = 1,
		/obj/item/natural/cloth = 1
	)
	supports_directions = TRUE
	craftdiff = 2

/datum/blueprint_recipe/carpentry/male_mannequin
	name = "male mannequin"
	desc = "A male display mannequin."
	result_type = /obj/structure/mannequin/male
	required_materials = list(
		/obj/item/natural/wood/plank = 1,
		/obj/item/grown/log/tree/small = 1,
		/obj/item/ingot/iron = 1,
		/obj/item/natural/cloth = 1
	)
	supports_directions = TRUE
	craftdiff = 2

/datum/blueprint_recipe/carpentry/wall_ladder
	name = "wall ladder"
	desc = "A ladder that mounts to walls."
	result_type = /obj/structure/wallladder
	required_materials = list(
		/obj/item/natural/wood/plank = 2,
		/obj/item/grown/log/tree/stick = 3
	)
	supports_directions = TRUE
	craftdiff = 0
	check_adjacent_wall = TRUE

/datum/blueprint_recipe/carpentry/wooden_table
	name = "wooden table"
	desc = "A sturdy wooden table."
	result_type = /obj/structure/table/wood/crafted
	required_materials = list(
		/obj/item/grown/log/tree/stick = 2,
		/obj/item/natural/wood/plank = 1
	)
	supports_directions = TRUE
	craftdiff = 0

/datum/blueprint_recipe/carpentry/pillory
	name = "pillory"
	desc = "A restraining device for punishment."
	result_type = /obj/structure/pillory
	required_materials = list(
		/obj/item/grown/log/tree/small = 2,
		/obj/item/ingot/iron = 1,
	)
	supports_directions = TRUE
	craftdiff = 2

/datum/blueprint_recipe/carpentry/easel
	name = "wooden easel"
	desc = "An easel for painting and art."
	result_type = /obj/structure/easel
	required_materials = list(
		/obj/item/grown/log/tree/small = 1,
		/obj/item/grown/log/tree/stick = 2
	)
	supports_directions = TRUE
	craftdiff = 0

/datum/blueprint_recipe/carpentry/operating_table
	name = "operating table"
	desc = "A table designed for medical procedures."
	result_type = /obj/structure/table/optable
	required_materials = list(/obj/item/natural/wood/plank = 2)
	supports_directions = TRUE
	craftdiff = 2

/datum/blueprint_recipe/carpentry/meathook
	name = "meathook"
	desc = "A hook for hanging and processing meat."
	result_type = /obj/structure/meathook
	required_materials = list(
		/obj/item/natural/wood/plank = 1,
		/obj/item/grown/log/tree/small = 1,
		/obj/item/natural/stone = 1
	)
	craftdiff = 1

/datum/blueprint_recipe/carpentry/spider_nest
	name = "spider nesting house"
	desc = "A constructed nest for spiders."
	result_type = /obj/structure/spider/nest/constructed
	required_materials = list(/obj/item/natural/wood/plank = 3)
	craftdiff = 1

/datum/blueprint_recipe/carpentry/composter
	name = "composter"
	desc = "A constructed composter."
	result_type = /obj/structure/composter
	required_materials = list(/obj/item/grown/log/tree/small = 1)
	craftdiff = 0

/datum/blueprint_recipe/carpentry/plough
	name = "plough"
	desc = "A plough."
	result_type = /obj/structure/plough
	required_materials = list(
		/obj/item/grown/log/tree/small = 2,
		/obj/item/ingot/iron = 1
	)
	build_time = 4 SECONDS

/datum/blueprint_recipe/carpentry/handcart
	name = "wooden handcart"
	desc = "A wooden handcart."
	result_type = /obj/structure/handcart
	required_materials = list(
		/obj/item/grown/log/tree/small = 3,
		/obj/item/rope = 1
	)
	craftdiff = 1

/datum/blueprint_recipe/carpentry/noose
	name = "noose"
	desc = "hangs from the ceiling."
	result_type = /obj/structure/noose
	required_materials = list(
		/obj/item/rope = 1
	)
	build_time = 4 SECONDS
	requires_ceiling = TRUE

/datum/blueprint_recipe/carpentry/apiary
	name = "Apiary"
	desc = "A home for bees."
	result_type = /obj/structure/apiary
	required_materials = list(
		/obj/item/grown/log/tree/small = 2,
		/obj/item/natural/wood/plank = 2,
		/obj/item/natural/fibers = 2
	)
	craftdiff = 1

