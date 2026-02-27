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


/datum/blueprint_recipe/structure/millstone
	name = "Millstone"
	desc = "A stone millstone for grinding grain."
	result_type = /obj/structure/fluff/millstone
	required_materials = list(
		/obj/item/natural/stone = 3
	)
	construct_tool = /obj/item/weapon/hammer
	category = "Structures"

	skillcraft = /datum/skill/craft/masonry


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

	skillcraft = /datum/skill/craft/carpentry

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
	skillcraft = /datum/skill/craft/masonry
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
	skillcraft = /datum/skill/craft/masonry
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
	skillcraft = /datum/skill/craft/masonry
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
	skillcraft = /datum/skill/craft/crafting
	craftdiff = 3

/datum/blueprint_recipe/structure/astrata_cross
	name = "astrata cross"
	desc = "A metal psycross dedicated to Astrata."
	required_materials = list(
		/obj/item/ingot/iron = 3,
	)
	result_type = /obj/structure/fluff/psycross/astrata
	construct_tool = /obj/item/weapon/hammer
	skillcraft = /datum/skill/craft/crafting
	craftdiff = 3

/datum/blueprint_recipe/structure/astrata_cross_gold
	name = "golden astrata cross"
	desc = "A golden psycross dedicated to Astrata."
	required_materials = list(
		/obj/item/ingot/gold = 3,
	)
	result_type = /obj/structure/fluff/psycross/astrata/gold
	construct_tool = /obj/item/weapon/hammer
	skillcraft = /datum/skill/craft/crafting
	craftdiff = 3
