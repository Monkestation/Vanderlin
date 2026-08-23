/datum/blueprint_recipe/structure
	abstract_type = /datum/blueprint_recipe/structure
	category = "Structures"
	build_time = 4 SECONDS

/datum/blueprint_recipe/structure/tentdoor
	name = "Tent Door"
	desc = "A tent door structure."
	result_type = /obj/structure/roguetent
	required_materials = list(
		/obj/item/grown/log/tree/stick = 1,
		/obj/item/natural/cloth = 1
	)
	construct_tool = /obj/item/weapon/knife
	category = "Structures"
	build_time = 3 SECONDS

/datum/blueprint_recipe/structure/tentdoor
	name = "Blue Tent Door"
	desc = "A tent door structure."
	result_type = /obj/structure/tentdoor
	required_materials = list(
		/obj/item/grown/log/tree/stick = 1,
		/obj/item/natural/cloth = 1
	)
	construct_tool = /obj/item/weapon/knife
	category = "Structures"
	build_time = 3 SECONDS

/datum/blueprint_recipe/structure/tentdoor/cyan
	name = "Cyan Tent Door"
	desc = "A tent door structure."
	result_type = /obj/structure/tentdoor/cyan
	required_materials = list(
		/obj/item/grown/log/tree/stick = 1,
		/obj/item/natural/cloth = 1
	)
	construct_tool = /obj/item/weapon/knife
	category = "Structures"
	build_time = 3 SECONDS

/datum/blueprint_recipe/structure/tentdoor/brown
	name = "Brown Tent Door"
	desc = "A tent door structure."
	result_type = /obj/structure/tentdoor/brown
	required_materials = list(
		/obj/item/grown/log/tree/stick = 1,
		/obj/item/natural/cloth = 1
	)
	construct_tool = /obj/item/weapon/knife
	category = "Structures"
	build_time = 3 SECONDS

/datum/blueprint_recipe/structure/tentdoor/green
	name = "Green Tent Door"
	desc = "A tent door structure."
	result_type = /obj/structure/tentdoor/green
	required_materials = list(
		/obj/item/grown/log/tree/stick = 1,
		/obj/item/natural/cloth = 1
	)
	construct_tool = /obj/item/weapon/knife
	category = "Structures"
	build_time = 3 SECONDS

/datum/blueprint_recipe/structure/tentdoor/purple
	name = "Purple Tent Door"
	desc = "A tent door structure."
	result_type = /obj/structure/tentdoor/purple
	required_materials = list(
		/obj/item/grown/log/tree/stick = 1,
		/obj/item/natural/cloth = 1
	)
	construct_tool = /obj/item/weapon/knife
	category = "Structures"
	build_time = 3 SECONDS

/datum/blueprint_recipe/structure/tentdoor/red
	name = "Red Tent Door"
	desc = "A tent door structure."
	result_type = /obj/structure/tentdoor/red
	required_materials = list(
		/obj/item/grown/log/tree/stick = 1,
		/obj/item/natural/cloth = 1
	)
	construct_tool = /obj/item/weapon/knife
	category = "Structures"
	build_time = 3 SECONDS

/datum/blueprint_recipe/structure/tentdoor/reddeco
	name = "Decorated Red Tent Door"
	desc = "A tent door embossed with gold."
	result_type = /obj/structure/tentdoor/reddeco
	required_materials = list(
		/obj/item/grown/log/tree/stick = 1,
		/obj/item/natural/cloth = 1
	)
	construct_tool = /obj/item/weapon/knife
	category = "Structures"
	build_time = 3 SECONDS

/datum/blueprint_recipe/structure/tentdoor/purpledeco
	name = "Decorated Purple Tent Door"
	desc = "A tent door embossed with gold."
	result_type = /obj/structure/tentdoor/purpledeco
	required_materials = list(
		/obj/item/grown/log/tree/stick = 1,
		/obj/item/natural/cloth = 1
	)
	construct_tool = /obj/item/weapon/knife
	category = "Structures"
	build_time = 3 SECONDS

/datum/blueprint_recipe/structure/tentdoor/greendeco
	name = "Decorated Green Tent Door"
	desc = "A tent door embossed with gold."
	result_type = /obj/structure/tentdoor/greendeco
	required_materials = list(
		/obj/item/grown/log/tree/stick = 1,
		/obj/item/natural/cloth = 1
	)
	construct_tool = /obj/item/weapon/knife
	category = "Structures"
	build_time = 3 SECONDS

/datum/blueprint_recipe/structure/tentdoor/browndeco
	name = "Decorated Brown Tent Door"
	desc = "A tent door embossed with gold."
	result_type = /obj/structure/tentdoor/browndeco
	required_materials = list(
		/obj/item/grown/log/tree/stick = 1,
		/obj/item/natural/cloth = 1
	)
	construct_tool = /obj/item/weapon/knife
	category = "Structures"
	build_time = 3 SECONDS

/datum/blueprint_recipe/structure/tentdoor/cyandeco
	name = "Decorated Cyan Tent Door"
	desc = "A tent door embossed with gold."
	result_type = /obj/structure/tentdoor/cyandeco
	required_materials = list(
		/obj/item/grown/log/tree/stick = 1,
		/obj/item/natural/cloth = 1
	)
	construct_tool = /obj/item/weapon/knife
	category = "Structures"
	build_time = 3 SECONDS

/datum/blueprint_recipe/structure/tentdoor/bluedeco
	name = "Decorated Blue Tent Door"
	desc = "A tent door embossed with gold."
	result_type = /obj/structure/tentdoor/bluedeco
	required_materials = list(
		/obj/item/grown/log/tree/stick = 1,
		/obj/item/natural/cloth = 1
	)
	construct_tool = /obj/item/weapon/knife
	category = "Structures"
	build_time = 3 SECONDS

/datum/blueprint_recipe/structure/tentdoor/noc
	name = "Decorated Navy Tent Door"
	desc = "A tent door embossed with silver."
	result_type = /obj/structure/tentdoor/noc
	required_materials = list(
		/obj/item/grown/log/tree/stick = 1,
		/obj/item/natural/cloth = 1
	)
	construct_tool = /obj/item/weapon/knife
	category = "Structures"
	build_time = 3 SECONDS

/datum/blueprint_recipe/structure/anvil
	name = "Anvil"
	desc = "A heavy iron anvil for metalworking."
	result_type = /obj/machinery/anvil
	required_materials = list(
		/obj/item/ingot/iron = 1
	)
	construct_tool = /obj/item/weapon/hammer
	build_time = 5 SECONDS
	category = "Structures"


/datum/blueprint_recipe/structure/campfire
	name = "Campfire"
	desc = "A simple campfire for light and warmth."
	result_type = /obj/machinery/light/fueled/campfire
	required_materials = list(
		/obj/item/grown/log/tree/stick = 2
	)
	construct_tool = /obj/item/grown/log/tree/stick
	category = "Structures"


/datum/blueprint_recipe/structure/densefire
	name = "Greater Campfire"
	desc = "A larger, more efficient campfire."
	result_type = /obj/machinery/light/fueled/campfire/densefire
	required_materials = list(
		/obj/item/grown/log/tree/stick = 2,
		/obj/item/natural/stone = 2
	)
	construct_tool = /obj/item/grown/log/tree/stick
	category = "Structures"


/datum/blueprint_recipe/structure/cookpit
	name = "Hearth"
	desc = "A stone hearth for cooking and warmth."
	result_type = /obj/machinery/light/fueled/hearth
	required_materials = list(
		/obj/item/grown/log/tree/stick = 1,
		/obj/item/natural/stone = 3
	)
	construct_tool = /obj/item/grown/log/tree/stick
	category = "Structures"


/datum/blueprint_recipe/structure/brazier
	name = "Brazier"
	desc = "A wooden brazier with coal for heating."
	result_type = /obj/machinery/light/fueled/firebowl/stump
	required_materials = list(
		/obj/item/grown/log/tree/small = 1,
		/obj/item/ore/coal = 1
	)
	construct_tool = /obj/item/grown/log/tree/small
	category = "Structures"


/datum/blueprint_recipe/structure/standing
	name = "Standing Fire"
	desc = "A standing stone fire bowl."
	result_type = /obj/machinery/light/fueled/firebowl/standing
	required_materials = list(
		/obj/item/natural/stone = 1,
		/obj/item/ore/coal = 1
	)
	construct_tool = /obj/item/weapon/hammer
	category = "Structures"


/datum/blueprint_recipe/structure/standingblue
	name = "Standing Fire (Blue)"
	desc = "A standing stone fire bowl with blue flames."
	result_type = /obj/machinery/light/fueled/firebowl/standing/blue
	required_materials = list(
		/obj/item/natural/stone = 1,
		/obj/item/ore/coal = 1,
		/obj/item/fertilizer/ash = 1
	)
	construct_tool = /obj/item/weapon/hammer
	category = "Structures"


/datum/blueprint_recipe/structure/rack
	name = "Rack"
	desc = "A simple wooden storage rack."
	result_type = /obj/structure/rack
	required_materials = list(
		/obj/item/grown/log/tree/stick = 3
	)
	construct_tool = /obj/item/weapon/knife
	category = "Structures"


/datum/blueprint_recipe/structure/dryingrack
	name = "Drying Rack"
	desc = "A rack for drying and tanning materials."
	result_type = /obj/machinery/tanningrack
	required_materials = list(
		/obj/item/grown/log/tree/stick = 3
	)
	construct_tool = null
	category = "Structures"

/datum/blueprint_recipe/structure/curtain
	name = "Curtain"
	desc = "A long-draped curtain."
	result_type = /obj/structure/curtain/bounty
	required_materials = list(
		/obj/item/grown/log/tree/stick = 1,
		/obj/item/natural/cloth = 2
	)
	construct_tool = /obj/item/needle
	category = "Structures"
	skillcraft = /datum/attribute/skill/misc/sewing


/datum/blueprint_recipe/structure/curtain/bluecurtain
	name = "Fancy Blue Curtain"
	desc = "A long-draped curtain."
	result_type = /obj/structure/curtain/bluecurtain
	required_materials = list(
		/obj/item/grown/log/tree/stick = 1,
		/obj/item/natural/cloth = 2
	)
	construct_tool = /obj/item/needle
	category = "Structures"
	skillcraft = /datum/attribute/skill/misc/sewing

/datum/blueprint_recipe/structure/curtain/cyancurtain
	name = "Fancy Cyan Curtain"
	desc = "A long-draped curtain."
	result_type = /obj/structure/curtain/cyancurtain
	required_materials = list(
		/obj/item/grown/log/tree/stick = 1,
		/obj/item/natural/cloth = 2
	)
	construct_tool = /obj/item/needle
	category = "Structures"
	skillcraft = /datum/attribute/skill/misc/sewing

/datum/blueprint_recipe/structure/curtain/browncurtain
	name = "Fancy Brown Curtain"
	desc = "A long-draped curtain."
	result_type = /obj/structure/curtain/browncurtain
	required_materials = list(
		/obj/item/grown/log/tree/stick = 1,
		/obj/item/natural/cloth = 2
	)
	construct_tool = /obj/item/needle
	category = "Structures"
	skillcraft = /datum/attribute/skill/misc/sewing

/datum/blueprint_recipe/structure/curtain/greencurtain
	name = "Fancy Green Curtain"
	desc = "A long-draped curtain."
	result_type = /obj/structure/curtain/greencurtain
	required_materials = list(
		/obj/item/grown/log/tree/stick = 1,
		/obj/item/natural/cloth = 2
	)
	construct_tool = /obj/item/needle
	category = "Structures"
	skillcraft = /datum/attribute/skill/misc/sewing

/datum/blueprint_recipe/structure/curtain/purplecurtain
	name = "Fancy Purple Curtain"
	desc = "A long-draped curtain."
	result_type = /obj/structure/curtain/purplecurtain
	required_materials = list(
		/obj/item/grown/log/tree/stick = 1,
		/obj/item/natural/cloth = 2
	)
	construct_tool = /obj/item/needle
	category = "Structures"
	skillcraft = /datum/attribute/skill/misc/sewing

/datum/blueprint_recipe/structure/curtain/redcurtain
	name = "Fancy Red Curtain"
	desc = "A long-draped curtain."
	result_type = /obj/structure/curtain/redcurtain
	required_materials = list(
		/obj/item/grown/log/tree/stick = 1,
		/obj/item/natural/cloth = 2
	)
	construct_tool = /obj/item/needle
	category = "Structures"
	skillcraft = /datum/attribute/skill/misc/sewing

/datum/blueprint_recipe/structure/curtain/noccurtain
	name = "Fancy Navy Curtain"
	desc = "Decorative navy curtains, popular amongst Noccites."
	result_type = /obj/structure/curtain/noccurtain
	required_materials = list(
		/obj/item/grown/log/tree/stick = 1,
		/obj/item/natural/cloth = 2
	)
	construct_tool = /obj/item/needle
	category = "Structures"
	skillcraft = /datum/attribute/skill/misc/sewing

/datum/blueprint_recipe/structure/bed
	name = "Bed"
	desc = "A simple wooden bed with fiber bedding."
	result_type = /obj/structure/bed/shit
	required_materials = list(
		/obj/item/grown/log/tree/small = 1,
		/obj/item/natural/fibers = 1
	)
	construct_tool = /obj/item/weapon/knife
	category = "Structures"

/datum/blueprint_recipe/structure/wickertrunk
	name = "Wicker Trunk"
	desc = "Fibers interwoven to make a somewhat sturdy trunk."
	result_type = /obj/structure/closet/crate/chest/wickertrunk
	required_materials = list(
		/obj/item/natural/fibers = 2,
		/obj/item/grown/log/tree/stick = 1
	)
	construct_tool = /obj/item/weapon/knife
	category = "Structures"

/datum/blueprint_recipe/structure/wickertrunk/red
	name = "Wicker Trunk With Red Throw"
	desc = "A somewhat sturdy wicker trunk covered in a red linen throw rug, quaint."
	result_type = /obj/structure/closet/crate/chest/wickertrunk/red
	required_materials = list(
		/obj/item/natural/fibers = 2,
		/obj/item/grown/log/tree/stick = 1,
		/obj/item/natural/cloth = 1
	)
	construct_tool = /obj/item/weapon/knife
	category = "Structures"

/datum/blueprint_recipe/structure/wickertrunk/blue
	name = "Wicker Trunk With Blue Throw"
	desc = "A somewhat sturdy wicker trunk covered in a blue linen throw rug, quaint."
	result_type = /obj/structure/closet/crate/chest/wickertrunk/blue
	required_materials = list(
		/obj/item/natural/fibers = 2,
		/obj/item/grown/log/tree/stick = 1,
		/obj/item/natural/cloth = 1
	)
	construct_tool = /obj/item/weapon/knife
	category = "Structures"

/datum/blueprint_recipe/structure/shippingcrate
	name = "Shipping Crate"
	desc = "A sturdy crate made up of wood planks and held together with bronze nails."
	result_type = /obj/structure/closet/crate/chest/shippingcrate
	required_materials = list(
		/obj/item/grown/log/tree/stick = 3
	)
	construct_tool = /obj/item/weapon/hammer
	category = "Structures"

/datum/blueprint_recipe/structure/moonrug
	name = "Moon Rug"
	desc = "A decorative rug depicting the phases of the moon."
	result_type = /obj/structure/fluff/moonrug
	required_materials = list(
		/obj/item/natural/cloth = 3
	)
	construct_tool = /obj/item/needle
	category = "Structures"
	skillcraft = /datum/attribute/skill/misc/sewing

/datum/blueprint_recipe/structure/fibermat/square
	name = "Square Fiber Mat"
	desc = "A rustic mat woven from fiber."
	result_type = /obj/structure/fluff/fibermat/square
	required_materials = list(
		/obj/item/natural/fibers = 2
	)
	construct_tool = /obj/item/needle
	category = "Structures"
	skillcraft = /datum/attribute/skill/misc/sewing

/datum/blueprint_recipe/structure/fibermat/round
	name = "Round Fiber Mat"
	desc = "A rustic mat woven from fiber."
	result_type = /obj/structure/fluff/fibermat/round
	required_materials = list(
		/obj/item/natural/fibers = 2
	)
	construct_tool = /obj/item/needle
	category = "Structures"
	skillcraft = /datum/attribute/skill/misc/sewing

/datum/blueprint_recipe/structure/clutter/books
	name = "Clutter (Books)"
	desc = "A few stacks of books with a pot of ink & quill waiting for inspiration."
	result_type = /obj/structure/fluff/clutter/books
	required_materials = list(
		/obj/item/natural/fibers = 2
	)
	category = "Structures"

/datum/blueprint_recipe/structure/clutter/teapot
	name = "Clutter (Teapot)"
	desc = "A teapot & accompanying cups on a mat."
	result_type = /obj/structure/fluff/clutter/teapot
	required_materials = list(
		/obj/item/natural/stone = 2
	)
	category = "Structures"

/datum/blueprint_recipe/structure/clutter/shrub/tundra
	name = "potted shrub"
	desc = "A stone pot with a cold tundra shrub there-in."
	result_type = /obj/structure/fluff/clutter/shrub/tundra
	required_materials = list(
		/obj/item/natural/stone = 2
	)
	category = "Structures"

/datum/blueprint_recipe/structure/clutter/shrub/red
	name = "potted shrub"
	desc = "A stone pot with a red autumnal shrub there-in."
	result_type = /obj/structure/fluff/clutter/shrub/red
	required_materials = list(
		/obj/item/natural/stone = 2
	)
	category = "Structures"

/datum/blueprint_recipe/structure/millstone
	name = "Millstone"
	desc = "A stone millstone for grinding grain."
	result_type = /obj/structure/fluff/millstone
	required_materials = list(
		/obj/item/natural/stone = 3
	)
	construct_tool = /obj/item/weapon/hammer
	category = "Structures"

	skillcraft = /datum/attribute/skill/craft/masonry


/datum/blueprint_recipe/structure/noose
	name = "Noose"
	desc = "Hangs from the ceiling."
	result_type = /obj/structure/noose
	required_materials = list(
		/obj/item/rope = 1
	)
	construct_tool = /obj/item/rope
	verbage = "tie"
	verbage_tp = "ties"
	category = "Structures"
	requires_ceiling = TRUE


/datum/blueprint_recipe/structure/pottery_lathe
	name = "Potter Lathe"
	desc = "A lathe for creating pottery."
	result_type = /obj/structure/pottery_lathe
	required_materials = list(
		/obj/item/natural/stone = 2,
		/obj/item/grown/log/tree/small = 1
	)
	construct_tool = /obj/item/weapon/hammer
	category = "Structures"

	skillcraft = /datum/attribute/skill/craft/carpentry

/datum/blueprint_recipe/structure/torchholder
	name = "Sconce"
	desc = "A stone wall sconce for holding torches."
	result_type = /obj/machinery/light/fueled/torchholder
	required_materials = list(
		/obj/item/natural/stone = 2
	)
	construct_tool = /obj/item/weapon/hammer
	category = "Wall Fixtures"
	floor_object = FALSE
	skillcraft = /datum/attribute/skill/craft/masonry
	check_adjacent_wall = TRUE
	supports_directions = TRUE
	inverse_check = TRUE

/datum/blueprint_recipe/structure/wallcandle
	name = "Wall Candles"
	desc = "Stone wall-mounted candleholders."
	result_type = /obj/machinery/light/fueled/wallfire/candle
	required_materials = list(
		/obj/item/natural/stone = 1,
		/obj/item/candle/yellow = 1
	)
	construct_tool = /obj/item/weapon/hammer
	category = "Wall Fixtures"
	floor_object = FALSE
	skillcraft = /datum/attribute/skill/craft/masonry
	check_adjacent_wall = TRUE
	supports_directions = TRUE
	place_on_wall = TRUE

/datum/blueprint_recipe/structure/wallcandleblue
	name = "Wall Candles (Blue)"
	desc = "Stone wall-mounted candleholders with blue flames."
	result_type = /obj/machinery/light/fueled/wallfire/candle/blue
	required_materials = list(
		/obj/item/natural/stone = 1,
		/obj/item/candle/yellow = 1,
		/obj/item/fertilizer/ash = 1
	)
	construct_tool = /obj/item/weapon/hammer
	category = "Wall Fixtures"
	floor_object = FALSE
	skillcraft = /datum/attribute/skill/craft/masonry
	check_adjacent_wall = TRUE
	supports_directions = TRUE
	place_on_wall = TRUE

/datum/blueprint_recipe/structure/psydon_metal_cross
	name = "metal psycross"
	desc = "A metal psycross dedicated to Psydon."
	required_materials = list(
		/obj/item/ingot/iron = 3,
	)
	result_type = /obj/structure/fluff/psycross/psydon/metal
	construct_tool = /obj/item/weapon/hammer
	skillcraft = /datum/attribute/skill/craft/crafting
	craftdiff = 3

/datum/blueprint_recipe/structure/astrata_cross
	name = "astrata cross"
	desc = "A metal psycross dedicated to Astrata."
	required_materials = list(
		/obj/item/ingot/iron = 3,
	)
	result_type = /obj/structure/fluff/psycross/astrata
	construct_tool = /obj/item/weapon/hammer
	skillcraft = /datum/attribute/skill/craft/crafting
	craftdiff = 3

/datum/blueprint_recipe/structure/astrata_cross_gold
	name = "golden astrata cross"
	desc = "A golden psycross dedicated to Astrata."
	required_materials = list(
		/obj/item/ingot/gold = 3,
	)
	result_type = /obj/structure/fluff/psycross/astrata/gold
	construct_tool = /obj/item/weapon/hammer
	skillcraft = /datum/attribute/skill/craft/crafting
	craftdiff = 3

