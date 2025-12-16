/datum/repeatable_crafting_recipe/crafting
	abstract_type = /datum/repeatable_crafting_recipe/crafting
	skillcraft = /datum/skill/craft/crafting
	category = "Misc Crafting"
	allow_inverse_start = TRUE
	subtypes_allowed = TRUE

/datum/repeatable_crafting_recipe/crafting/mantrap
	name = "mantrap"
	requirements = list(
		/obj/item/grown/log/tree/stake = 1,
		/obj/item/rope = 1,
		/obj/item/natural/fibers = 1,
	)
	attacked_atom = /obj/item/grown/log/tree/stake
	starting_atom  = /obj/item/rope
	output = /obj/item/restraints/legcuffs/beartrap/crafted/makeshift
	craftdiff = 1

/datum/repeatable_crafting_recipe/crafting/mantrap/create_blacklisted_paths()
	blacklisted_paths = subtypesof(/obj/item/rope)

/datum/repeatable_crafting_recipe/crafting/earnecklace
	name = "ear necklace"
	requirements = list(
		/obj/item/organ/ears= 4,
		/obj/item/rope = 1,
	)
	attacked_atom = /obj/item/rope
	starting_atom= /obj/item/organ/ears
	output = /obj/item/clothing/neck/menears
	craftdiff = 0

/datum/repeatable_crafting_recipe/crafting/earnecklace/create_blacklisted_paths()
	blacklisted_paths = subtypesof(/obj/item/rope)

/datum/repeatable_crafting_recipe/crafting/earnecklace/elf
	name = "elf ear necklace"
	requirements = list(
		/obj/item/organ/ears/elf = 4,
		/obj/item/rope = 1,
	)
	starting_atom= /obj/item/organ/ears/elf
	output = /obj/item/clothing/neck/elfears

/datum/repeatable_crafting_recipe/crafting/earnecklace/elfw
	hides_from_books = TRUE
	name = "elf ear necklace"
	requirements = list(
		/obj/item/organ/ears/elfw = 4,
		/obj/item/rope = 1,
	)
	starting_atom= /obj/item/organ/ears/elfw
	output = /obj/item/clothing/neck/elfears

/datum/repeatable_crafting_recipe/crafting/wickercloak
	name = "wicker cloak"
	requirements = list(
		/obj/item/natural/dirtclod = 2,
		/obj/item/grown/log/tree/stick= 4,
		/obj/item/natural/fibers = 3,
	)
	attacked_atom = /obj/item/natural/dirtclod
	starting_atom = /obj/item/grown/log/tree/stick
	output = /obj/item/clothing/cloak/wickercloak
	craftdiff = 0

/datum/repeatable_crafting_recipe/crafting/bog_cowl
	name = "bog cowl"
	requirements = list(
		/obj/item/natural/dirtclod= 1,
		/obj/item/grown/log/tree/stick= 3,
		/obj/item/natural/fibers = 2,
	)
	attacked_atom = /obj/item/natural/dirtclod
	starting_atom = /obj/item/grown/log/tree/stick
	output = /obj/item/clothing/neck/bogcowl
	craftdiff = 0

/datum/repeatable_crafting_recipe/crafting/skull_mask
	name = "skull mask"
	requirements = list(
		/obj/item/alch/bone= 3,
		/obj/item/natural/fibers = 1,
	)
	attacked_atom = /obj/item/natural/fibers
	starting_atom= /obj/item/alch/bone
	output = /obj/item/clothing/face/skullmask
	craftdiff = 0

/datum/repeatable_crafting_recipe/crafting/antlerhood
	name = "antler hood"
	requirements = list(
		/obj/item/alch/bone= 2,
		/obj/item/natural/hide = 1,
	)
	attacked_atom = /obj/item/natural/hide
	starting_atom= /obj/item/alch/bone
	output = /obj/item/clothing/head/antlerhood
	craftdiff = 0

/datum/repeatable_crafting_recipe/crafting/antlerhood/create_blacklisted_paths()
	blacklisted_paths = subtypesof(/obj/item/natural/hide)

/datum/repeatable_crafting_recipe/crafting/short_bow
	name = "short bow"
	requirements = list(
		/obj/item/grown/log/tree/small = 1,
		/obj/item/natural/fibers = 3,
	)
	attacked_atom = /obj/item/grown/log/tree/small
	starting_atom  = /obj/item/natural/fibers
	allow_inverse_start = FALSE
	output = /obj/item/gun/ballistic/revolver/grenadelauncher/bow/short
	craftdiff = 1

/datum/repeatable_crafting_recipe/crafting/bow
	name = "wooden bow"
	requirements = list(
		/obj/item/natural/wood/plank = 1,
		/obj/item/natural/fibers = 5,
	)

	starting_atom = /obj/item/natural/fibers
	attacked_atom = /obj/item/natural/wood/plank
	allow_inverse_start = FALSE
	output = /obj/item/gun/ballistic/revolver/grenadelauncher/bow
	craftdiff = 2

/datum/repeatable_crafting_recipe/crafting/long_bow
	name = "long bow"
	requirements = list(
		/obj/item/natural/wood/plank = 1,
		/obj/item/natural/fibers = 7,
		/obj/item/reagent_containers/food/snacks/fat = 1,
	)
	attacked_atom = /obj/item/natural/wood/plank
	starting_atom  = /obj/item/natural/fibers
	allow_inverse_start = FALSE
	output = /obj/item/gun/ballistic/revolver/grenadelauncher/bow/long
	craftdiff = 3

/datum/repeatable_crafting_recipe/crafting/wsword
	name = "wooden sword"
	requirements = list(
		/obj/item/natural/wood/plank = 1,
		/obj/item/grown/log/tree/stick = 1,
	)

	starting_atom = /obj/item/grown/log/tree/stick
	attacked_atom = /obj/item/natural/wood/plank
	output = /obj/item/weapon/mace/woodclub/train_sword
	craftdiff = 0

/datum/repeatable_crafting_recipe/crafting/wshield
	name = "wooden shield"
	requirements = list(
		/obj/item/natural/wood/plank = 2,
	)

	starting_atom = /obj/item/natural/wood/plank
	attacked_atom = /obj/item/natural/wood/plank
	output = /obj/item/weapon/shield/wood/crafted
	allow_inverse_start = FALSE // so we can typecheck less

/obj/item/weapon/shield/wood/crafted
	sellprice = 6

/datum/repeatable_crafting_recipe/crafting/heatershield
	name = "heater shield"
	requirements = list(
		/obj/item/natural/wood/plank = 2,
		/obj/item/natural/hide/cured = 1,
	)

	starting_atom = /obj/item/natural/hide/cured
	attacked_atom = /obj/item/natural/wood/plank
	output = /obj/item/weapon/shield/heater/crafted
	craftdiff = 2

/datum/repeatable_crafting_recipe/crafting/drum
	name = "drum"
	starting_atom = /obj/item/natural/hide/cured
	attacked_atom = /obj/item/grown/log/tree/small
	requirements = list(
		/obj/item/natural/hide/cured = 1,
		/obj/item/grown/log/tree/small = 1,
	)
	output = /obj/item/instrument/drum

/datum/repeatable_crafting_recipe/crafting/dart
	name = "dart"
	requirements = list(
		/obj/item/grown/log/tree/stick = 1,
		/obj/item/natural/thorn = 1,
	)

	starting_atom = /obj/item/natural/thorn
	attacked_atom = /obj/item/grown/log/tree/stick
	output = /obj/item/ammo_casing/caseless/dart
	craftdiff = 0
	output_amount = 3

/datum/repeatable_crafting_recipe/crafting/blowgun
	name = "blowgun"
	requirements = list(
		/obj/item/grown/log/tree/small= 1,
	)
	tool_usage = list(
		/obj/item/weapon/knife = list(span_notice("starts to whittle"), span_notice("start to whittle"), 'sound/items/wood_sharpen.ogg'),
	)
	attacked_atom = /obj/item/grown/log/tree/small
	starting_atom = /obj/item/weapon/knife
	output = /obj/item/gun/ballistic/revolver/grenadelauncher/blowgun

/datum/repeatable_crafting_recipe/crafting/candle
	name = "candle"
	requirements = list(
		/obj/item/reagent_containers/food/snacks/fat= 1,
		/obj/item/natural/fibers= 1,
	)
	starting_atom = /obj/item/natural/fibers
	attacked_atom = /obj/item/reagent_containers/food/snacks/fat
	output = /obj/item/candle/yellow
	output_amount = 2

/datum/repeatable_crafting_recipe/crafting/imp_saw
	name = "improvised saw"
	requirements = list(
		/obj/item/grown/log/tree/stick = 1,
		/obj/item/natural/stone = 1,
		/obj/item/natural/fibers = 1,
	)
	attacked_atom = /obj/item/grown/log/tree/stick
	starting_atom  = /obj/item/natural/fibers
	output = /obj/item/weapon/surgery/saw/improv
	craftdiff = 1

/datum/repeatable_crafting_recipe/crafting/imp_clamp
	name = "improvised clamp"
	requirements = list(
		/obj/item/grown/log/tree/stick = 2,
		/obj/item/natural/fibers = 1,
	)
	attacked_atom = /obj/item/grown/log/tree/stick
	starting_atom  = /obj/item/natural/fibers
	output = /obj/item/weapon/surgery/hemostat/improv
	craftdiff = 1

/datum/repeatable_crafting_recipe/crafting/imp_retractor
	name = "improvised retractor"
	requirements = list(
		/obj/item/grown/log/tree/stick = 2,
		/obj/item/natural/fibers = 1,
	)
	attacked_atom = /obj/item/grown/log/tree/stick
	starting_atom  = /obj/item/natural/fibers
	output = /obj/item/weapon/surgery/retractor/improv
	craftdiff = 1

/datum/repeatable_crafting_recipe/crafting/stone_mortar
	name = "stone mortar"
	requirements = list(
		/obj/item/natural/stone = 1,
	)

	starting_atom = /obj/item/weapon/knife
	attacked_atom = /obj/item/natural/stone
	output = /obj/item/reagent_containers/glass/mortar
	craftdiff = 0

/datum/repeatable_crafting_recipe/crafting/pestle
	name = "pestle"
	requirements = list(
		/obj/item/natural/stone = 1,
	)

	starting_atom = /obj/item/weapon/knife
	attacked_atom = /obj/item/natural/stone
	output = /obj/item/pestle
	craftdiff = 0

/datum/repeatable_crafting_recipe/crafting/stone_tongs
	name = "stone tongs"
	requirements = list(
		/obj/item/natural/stone = 1,
		/obj/item/grown/log/tree/stick = 2,
	)

	attacked_atom = /obj/item/natural/stone
	starting_atom = /obj/item/grown/log/tree/stick
	output = /obj/item/weapon/tongs/stone
	craftdiff = 0

/datum/repeatable_crafting_recipe/crafting/quarterstaff
	name = "wooden quarterstaff"
	requirements = list(
		/obj/item/grown/log/tree= 1,
	)
	tool_usage = list(
		/obj/item/weapon/knife = list(span_notice("starts to whittle"), span_notice("start to whittle"), 'sound/items/wood_sharpen.ogg'),
	)
	attacked_atom = /obj/item/grown/log/tree
	starting_atom = /obj/item/weapon/knife
	allow_inverse_start = FALSE
	output = /obj/item/weapon/polearm/woodstaff/quarterstaff
	required_intent = /datum/intent/dagger/cut
	craft_time = 5 SECONDS

/datum/repeatable_crafting_recipe/crafting/iron_quarterstaff
	name = "iron quarterstaff"
	requirements = list(
		/obj/item/weapon/polearm/woodstaff/quarterstaff = 1,
		/obj/item/ingot/iron = 1,
	)
	attacked_atom = /obj/item/weapon/polearm/woodstaff/quarterstaff
	starting_atom  = /obj/item/ingot/iron
	allow_inverse_start = FALSE
	output = /obj/item/weapon/polearm/woodstaff/quarterstaff/iron
	skillcraft = /datum/skill/craft/carpentry
	craftdiff = 2

/datum/repeatable_crafting_recipe/crafting/steel_quarterstaff
	name = "steel quarterstaff"
	requirements = list(
		/obj/item/weapon/polearm/woodstaff/quarterstaff = 1,
		/obj/item/ingot/steel = 1,
	)
	attacked_atom = /obj/item/weapon/polearm/woodstaff/quarterstaff
	starting_atom  = /obj/item/ingot/steel
	allow_inverse_start = FALSE
	output = /obj/item/weapon/polearm/woodstaff/quarterstaff/steel
	skillcraft = /datum/skill/craft/carpentry
	craftdiff = 3

/datum/repeatable_crafting_recipe/crafting/caningstick
	name = "caning stick"
	requirements = list(
		/obj/item/grown/log/tree/stick= 2,
	)
	tool_usage = list(
		/obj/item/weapon/knife = list(span_notice("starts to whittle"), span_notice("start to whittle"), 'sound/items/wood_sharpen.ogg'),
	)
	attacked_atom = /obj/item/grown/log/tree/stick
	starting_atom = /obj/item/weapon/knife
	allow_inverse_start = FALSE
	output = /obj/item/weapon/whip/cane
	craftdiff = 0

/datum/repeatable_crafting_recipe/crafting/cane
	name = "wooden cane"
	requirements = list(
		/obj/item/grown/log/tree= 1,
	)
	tool_usage = list(
		/obj/item/weapon/knife = list(span_notice("starts to whittle"), span_notice("start to whittle"), 'sound/items/wood_sharpen.ogg'),
	)
	attacked_atom = /obj/item/grown/log/tree
	starting_atom = /obj/item/weapon/knife
	allow_inverse_start = FALSE
	output = /obj/item/weapon/mace/cane
	required_intent = /datum/intent/dagger/cut
	craft_time = 5 SECONDS

/datum/repeatable_crafting_recipe/crafting/naturalcane
	name = "natural wooden cane"
	requirements = list(
		/obj/item/grown/log/tree/small= 1,
	)
	tool_usage = list(
		/obj/item/weapon/knife = list(span_notice("starts to whittle"), span_notice("start to whittle"), 'sound/items/wood_sharpen.ogg'),
	)
	attacked_atom = /obj/item/grown/log/tree/small
	starting_atom = /obj/item/weapon/knife
	allow_inverse_start = FALSE
	output = /obj/item/weapon/mace/cane/natural
	required_intent = /datum/intent/dagger/cut
	craft_time = 5 SECONDS

/datum/repeatable_crafting_recipe/crafting/spoon
	name = "wooden spoon"
	requirements = list(
		/obj/item/grown/log/tree/stick= 1,
	)
	tool_usage = list(
		/obj/item/weapon/knife = list(span_notice("starts to whittle"), span_notice("start to whittle"), 'sound/items/wood_sharpen.ogg'),
	)
	attacked_atom = /obj/item/grown/log/tree/stick
	starting_atom = /obj/item/weapon/knife
	allow_inverse_start = FALSE
	output = /obj/item/kitchen/spoon
	craft_time = 3 SECONDS

/datum/repeatable_crafting_recipe/crafting/fork
	name = "wooden fork"
	requirements = list(
		/obj/item/grown/log/tree/stick= 1,
	)
	tool_usage = list(
		/obj/item/weapon/knife = list("starts to whittle", "start whittling", 'sound/items/wood_sharpen.ogg'),
	)
	attacked_atom = /obj/item/grown/log/tree/stick
	starting_atom = /obj/item/weapon/knife
	allow_inverse_start = FALSE
	output = /obj/item/kitchen/fork
	craft_time = 3 SECONDS

/datum/repeatable_crafting_recipe/crafting/rollingpin
	name = "wooden rollingpin"
	requirements = list(
		/obj/item/grown/log/tree/small= 1,
	)
	tool_usage = list(
		/obj/item/weapon/knife = list(span_notice("starts to whittle"), span_notice("start to whittle"), 'sound/items/wood_sharpen.ogg'),
	)
	attacked_atom = /obj/item/grown/log/tree/small
	starting_atom = /obj/item/weapon/knife
	allow_inverse_start = FALSE
	output = /obj/item/kitchen/rollingpin
	craft_time = 5 SECONDS

/datum/repeatable_crafting_recipe/crafting/woodbowl
	name = "wooden bowl"
	requirements = list(
		/obj/item/grown/log/tree/small= 1,
	)
	tool_usage = list(
		/obj/item/weapon/knife = list(span_notice("starts to whittle"), span_notice("start to whittle"), 'sound/items/wood_sharpen.ogg'),
	)
	attacked_atom = /obj/item/grown/log/tree/small
	starting_atom = /obj/item/weapon/knife
	allow_inverse_start = FALSE
	output = /obj/item/reagent_containers/glass/bowl
	output_amount = 3
	craft_time = 5 SECONDS

/datum/repeatable_crafting_recipe/crafting/woodcup
	name = "wooden cup"
	requirements = list(
		/obj/item/grown/log/tree/small= 1,
	)
	tool_usage = list(
		/obj/item/weapon/knife = list(span_notice("starts to whittle"), span_notice("start to whittle"), 'sound/items/wood_sharpen.ogg'),
	)
	attacked_atom = /obj/item/grown/log/tree/small
	starting_atom = /obj/item/weapon/knife
	allow_inverse_start = FALSE
	output = /obj/item/reagent_containers/glass/cup/wooden/crafted
	output_amount = 3
	craft_time = 5 SECONDS

/datum/repeatable_crafting_recipe/crafting/woodtray
	name = "wooden tray"
	requirements = list(
		/obj/item/grown/log/tree/small= 1,
	)
	tool_usage = list(
		/obj/item/weapon/knife = list(span_notice("starts to whittle"), span_notice("start to whittle"), 'sound/items/wood_sharpen.ogg'),
	)
	attacked_atom = /obj/item/grown/log/tree/small
	starting_atom = /obj/item/weapon/knife
	allow_inverse_start = FALSE
	output = /obj/item/tray
	output_amount = 2
	craft_time = 5 SECONDS

/datum/repeatable_crafting_recipe/crafting/woodplatter
	name = "wooden platter"
	requirements = list(
		/obj/item/grown/log/tree/small= 1,
	)
	tool_usage = list(
		/obj/item/weapon/knife = list(span_notice("starts to whittle"), span_notice("start to whittle"), 'sound/items/wood_sharpen.ogg'),
	)
	attacked_atom = /obj/item/grown/log/tree/small
	starting_atom = /obj/item/weapon/knife
	allow_inverse_start = FALSE
	output = /obj/item/plate
	output_amount = 2
	craft_time = 5 SECONDS

/datum/repeatable_crafting_recipe/crafting/woodspade
	name = "wooden spade"
	requirements = list(
		/obj/item/grown/log/tree/small= 1,
		/obj/item/grown/log/tree/stick = 1,
	)
	attacked_atom = /obj/item/grown/log/tree/small
	starting_atom = /obj/item/grown/log/tree/stick
	output = /obj/item/weapon/shovel/small
	craft_time = 2 SECONDS

/datum/repeatable_crafting_recipe/crafting/pipe
	name = "wooden pipe"
	requirements = list(
		/obj/item/grown/log/tree/stick= 1,
	)
	tool_usage = list(
		/obj/item/weapon/knife = list(span_notice("starts to whittle"), span_notice("start to whittle"), 'sound/items/wood_sharpen.ogg'),
	)
	attacked_atom = /obj/item/grown/log/tree/stick
	starting_atom = /obj/item/weapon/knife
	allow_inverse_start = FALSE
	output = /obj/item/clothing/face/cigarette/pipe/crafted

/datum/repeatable_crafting_recipe/crafting/broom
	name = "broom"
	requirements = list(
		/obj/item/grown/log/tree/stick= 4,
		/obj/item/natural/fibers = 1,
	)
	attacked_atom = /obj/item/grown/log/tree/stick
	starting_atom  = /obj/item/natural/fibers
	output = /obj/item/broom

/datum/repeatable_crafting_recipe/crafting/wpsycross
	name = "wooden psycross"
	requirements = list(
		/obj/item/grown/log/tree/small= 1,
	)
	tool_usage = list(
		/obj/item/weapon/knife = list(span_notice("starts to whittle"), span_notice("start to whittle"), 'sound/items/wood_sharpen.ogg'),
	)
	attacked_atom = /obj/item/grown/log/tree/small
	starting_atom = /obj/item/weapon/knife
	allow_inverse_start = FALSE
	output = /obj/item/clothing/neck/psycross
	craft_time = 5 SECONDS

/datum/repeatable_crafting_recipe/crafting/bottle_kit
	name = "bottle kit"
	requirements = list(
		/obj/item/reagent_containers/glass/bottle = 2,
		/obj/item/paper = 2,
	)
	attacked_atom = /obj/item/paper
	starting_atom = /obj/item/reagent_containers/glass/bottle
	allow_inverse_start = FALSE
	output = /obj/item/bottle_kit
	craft_time = 5 SECONDS

/datum/repeatable_crafting_recipe/crafting/bottle_kit/create_blacklisted_paths()
	blacklisted_paths = subtypesof(/obj/item/paper)

/datum/repeatable_crafting_recipe/crafting/woodflail
	name = "wooden flail"
	requirements = list(
		/obj/item/grown/log/tree/small= 1,
		/obj/item/rope/chain = 1,
		/obj/item/grown/log/tree/stick = 1,
	)
	tool_usage = list(
		/obj/item/weapon/hammer = list("starts to hammer", "start hammering", 'sound/items/wood_sharpen.ogg'),
	)
	attacked_atom = /obj/item/grown/log/tree/small
	starting_atom = /obj/item/weapon/hammer
	allow_inverse_start = FALSE
	output = /obj/item/weapon/flail/towner
	output_amount = 2
	craftdiff = 2
	craft_time = 5 SECONDS

/datum/repeatable_crafting_recipe/crafting/militia_flail
	name = "militia flail"
	requirements = list(
		/obj/item/weapon/flail/towner= 1,
		/obj/item/ingot/iron = 1,
	)
	tool_usage = list(
		/obj/item/weapon/hammer = list("starts to hammer", "start hammering", 'sound/items/wood_sharpen.ogg'),
	)
	attacked_atom = /obj/item/weapon/flail/towner
	starting_atom = /obj/item/weapon/hammer
	allow_inverse_start = FALSE
	output = /obj/item/weapon/flail/militia
	craftdiff = 3
	craft_time = 5 SECONDS

/datum/repeatable_crafting_recipe/crafting/woodthresher
	name = "wooden thresher"
	requirements = list(
		/obj/item/grown/log/tree/small= 1,
		/obj/item/rope = 1,
		/obj/item/grown/log/tree/stick = 1,
	)
	tool_usage = list(
		/obj/item/weapon/hammer = list("starts to hammer", "start hammering", 'sound/items/wood_sharpen.ogg'),
	)
	attacked_atom = /obj/item/grown/log/tree/small
	starting_atom = /obj/item/weapon/hammer
	allow_inverse_start = FALSE
	output = /obj/item/weapon/thresher
	craftdiff = 1
	craft_time = 5 SECONDS

/datum/repeatable_crafting_recipe/crafting/woodthresher/create_blacklisted_paths()
	blacklisted_paths = subtypesof(/obj/item/rope)

/datum/repeatable_crafting_recipe/crafting/bigflail
	name = "great militia flail"
	requirements = list(
		/obj/item/weapon/thresher= 1,
		/obj/item/rope/chain = 1,
		/obj/item/ingot/iron = 1,
	)
	tool_usage = list(
		/obj/item/weapon/hammer = list("starts to hammer", "start hammering", 'sound/items/wood_sharpen.ogg'),
	)
	attacked_atom =/obj/item/weapon/thresher
	starting_atom = /obj/item/weapon/hammer
	allow_inverse_start = FALSE
	output = /obj/item/weapon/thresher/military
	craftdiff = 3
	craft_time = 5 SECONDS

/datum/repeatable_crafting_recipe/crafting/ironcudgel
	name = "peasant cudgel"
	requirements = list(
		/obj/item/weapon/mace/woodclub = 1,
		/obj/item/ingot/iron = 1,
	)
	tool_usage = list(
		/obj/item/weapon/hammer = list("starts to hammer", "start hammering", 'sound/items/wood_sharpen.ogg'),
	)
	attacked_atom = /obj/item/weapon/mace/woodclub
	starting_atom = /obj/item/weapon/hammer
	allow_inverse_start = FALSE
	output = /obj/item/weapon/mace/cudgel/carpenter
	craftdiff = 3
	craft_time = 5 SECONDS

/datum/repeatable_crafting_recipe/crafting/scroll
	name = "parchment scroll"
	requirements = list(
		/obj/item/paper = 2,
		/obj/item/natural/fibers = 1,
	)
	starting_atom = /obj/item/natural/fibers
	attacked_atom = /obj/item/paper
	output = /obj/item/paper/scroll
	craftdiff = 0

/datum/repeatable_crafting_recipe/crafting/scroll/create_blacklisted_paths()
	blacklisted_paths = subtypesof(/obj/item/paper)

/datum/repeatable_crafting_recipe/crafting/cart_upgrade
	name = "cart upgrade"
	requirements = list(
		/obj/item/natural/wood/plank= 2,
	)
	tool_usage = list(
		/obj/item/weapon/knife = list(span_notice("starts to whittle"), span_notice("start to whittle"), 'sound/items/wood_sharpen.ogg'),
	)
	attacked_atom = /obj/item/natural/wood/plank
	starting_atom = /obj/item/weapon/knife
	allow_inverse_start = FALSE
	output = /obj/item/gear/wood/basic
	craftdiff = 3
	skillcraft = /datum/skill/craft/carpentry

/datum/repeatable_crafting_recipe/crafting/wheatlbait
	name = "bait (wheat)"
	output = /obj/item/bait
	requirements = list(
		/obj/item/natural/cloth = 1,
		/obj/item/reagent_containers/food/snacks/produce/grain/wheat = 2,
	)
	starting_atom = /obj/item/reagent_containers/food/snacks/produce/grain/wheat
	attacked_atom = /obj/item/natural/cloth

/datum/repeatable_crafting_recipe/crafting/oatbait
	name = "bait (oat)"
	output = /obj/item/bait
	requirements = list(
		/obj/item/natural/cloth = 1,
		/obj/item/reagent_containers/food/snacks/produce/grain/oat = 2,
	)
	starting_atom = /obj/item/reagent_containers/food/snacks/produce/grain/oat
	attacked_atom = /obj/item/natural/cloth

/datum/repeatable_crafting_recipe/crafting/sweetbait
	name = "sweet bait (apple)"
	output = /obj/item/bait/sweet
	requirements = list(
		/obj/item/natural/cloth = 1,
		/obj/item/reagent_containers/food/snacks/produce/fruit/apple = 2,
	)
	starting_atom = /obj/item/reagent_containers/food/snacks/produce/fruit/apple
	attacked_atom = /obj/item/natural/cloth

/datum/repeatable_crafting_recipe/crafting/berrybait
	name = "sweet bait (berry)"
	output = /obj/item/bait/sweet
	requirements = list(
		/obj/item/natural/cloth = 1,
		/obj/item/reagent_containers/food/snacks/produce/fruit/jacksberry = 2,
	)
	starting_atom = /obj/item/reagent_containers/food/snacks/produce/fruit/jacksberry
	attacked_atom = /obj/item/natural/cloth

/datum/repeatable_crafting_recipe/crafting/bloodbait
	name = "blood bait"
	output = /obj/item/bait/bloody
	requirements = list(
		/obj/item/natural/cloth = 1,
		/obj/item/reagent_containers/food/snacks/meat = 2,
	)
	starting_atom = /obj/item/reagent_containers/food/snacks/meat
	attacked_atom = /obj/item/natural/cloth

//carveable glass? Sure why not
/datum/repeatable_crafting_recipe/crafting/alchemical_vial
	name = "Alchemical Vial"
	output = /obj/item/reagent_containers/glass/alchemical
	requirements = list(
		/obj/item/natural/glass = 1,
	)
	tool_usage = list(
		/obj/item/weapon/knife = list("starts to carve the glass", "start to carve the glass")
	)

	attacked_atom = /obj/item/natural/glass
	starting_atom = /obj/item/weapon/knife
	output_amount = 2
	craftdiff = 3

/datum/repeatable_crafting_recipe/crafting/alchemical_bottle
	name = "Glass Bottle"
	output = /obj/item/reagent_containers/glass/bottle
	requirements = list(
		/obj/item/natural/glass = 1,
	)
	tool_usage = list(
		/obj/item/weapon/knife = list("starts to carve the glass", "start to carve the glass")
	)

	attacked_atom = /obj/item/natural/glass
	starting_atom = /obj/item/weapon/knife
	craftdiff = 3

/datum/repeatable_crafting_recipe/crafting/zigbox
	name = "Empty Zig Box"
	output = /obj/item/storage/fancy/cigarettes/zig/empty
	requirements = list(
		/obj/item/paper = 1,
	)
	tool_usage = list(
		/obj/item/needle = list("starts to sew the parchment", "start to sew the parchment")
	)

	attacked_atom = /obj/item/paper
	starting_atom = /obj/item/needle
	craftdiff = 0

/datum/repeatable_crafting_recipe/crafting/instrument_flute
	name = "Flute"
	output = /obj/item/instrument/flute
	requirements = list(
		/obj/item/grown/log/tree/stick = 3,
		/obj/item/natural/fibers = 2
	)
	tool_usage = list(
		/obj/item/weapon/knife = list(span_notice("starts to whittle"), span_notice("start to whittle"), 'sound/items/wood_sharpen.ogg'),
	)

	attacked_atom = /obj/item/grown/log/tree/stick
	starting_atom = /obj/item/weapon/knife

/datum/repeatable_crafting_recipe/crafting/instrument_harp
	name = "Lyre"
	output = /obj/item/instrument/harp
	requirements = list(
		/obj/item/grown/log/tree/small = 1,
		/obj/item/natural/fibers = 6
	)
	tool_usage = list(
		/obj/item/weapon/knife = list(span_notice("starts to whittle"), span_notice("start to whittle"), 'sound/items/wood_sharpen.ogg'),
	)

	attacked_atom = /obj/item/grown/log/tree/small
	starting_atom = /obj/item/weapon/knife

/datum/repeatable_crafting_recipe/crafting/instrument_lute
	name = "Lute"
	output = /obj/item/instrument/lute
	requirements = list(
		/obj/item/grown/log/tree/small = 1,
		/obj/item/grown/log/tree/stick = 1,
		/obj/item/natural/fibers = 5
	)
	tool_usage = list(
		/obj/item/weapon/knife = list(span_notice("starts to whittle"), span_notice("start to whittle"), 'sound/items/wood_sharpen.ogg'),
	)

	attacked_atom = /obj/item/grown/log/tree/small
	starting_atom = /obj/item/weapon/knife

/datum/repeatable_crafting_recipe/crafting/instrument_guitar
	name = "Guitar"
	output = /obj/item/instrument/guitar
	requirements = list(
		/obj/item/instrument/lute = 1
	)
	tool_usage = list(
		/obj/item/weapon/knife = list(span_notice("starts to whittle"), span_notice("start to whittle"), 'sound/items/wood_sharpen.ogg'),
	)

	attacked_atom = /obj/item/instrument/lute
	starting_atom = /obj/item/weapon/knife

/datum/repeatable_crafting_recipe/crafting/instrument_accord
	name = "Accordion"
	output = /obj/item/instrument/accord
	requirements = list(
		/obj/item/grown/log/tree/small = 1,
		/obj/item/natural/hide/cured = 1,
		/obj/item/ingot/iron = 1,
		/obj/item/alch/bone = 1
	)
	tool_usage = list(
		/obj/item/weapon/knife = list(span_notice("starts to whittle"), span_notice("start to whittle"), 'sound/items/wood_sharpen.ogg'),
	)

	attacked_atom = /obj/item/grown/log/tree/small
	starting_atom = /obj/item/weapon/knife

/datum/repeatable_crafting_recipe/crafting/instrument_drum
	name = "Drum"
	output = /obj/item/instrument/drum
	requirements = list(
		/obj/item/grown/log/tree/small = 1,
		/obj/item/natural/hide/cured = 2
	)
	tool_usage = list(
		/obj/item/weapon/knife = list(span_notice("starts to whittle"), span_notice("start to whittle"), 'sound/items/wood_sharpen.ogg'),
	)

	attacked_atom = /obj/item/grown/log/tree/small
	starting_atom = /obj/item/weapon/knife

/datum/repeatable_crafting_recipe/crafting/instrument_hurdygurdy
	name = "Hurdy-Gurdy"
	output = /obj/item/instrument/hurdygurdy
	requirements = list(
		/obj/item/grown/log/tree/small = 2,
		/obj/item/natural/fibers = 6
	)
	tool_usage = list(
		/obj/item/weapon/knife = list(span_notice("starts to whittle"), span_notice("start to whittle"), 'sound/items/wood_sharpen.ogg'),
	)

	attacked_atom = /obj/item/grown/log/tree/stick
	starting_atom = /obj/item/weapon/knife

/datum/repeatable_crafting_recipe/crafting/instrument_viola
	name = "Viola"
	output = /obj/item/instrument/viola
	requirements = list(
		/obj/item/grown/log/tree/small = 1,
		/obj/item/grown/log/tree/stick = 2,
		/obj/item/natural/fibers = 4
	)
	tool_usage = list(
		/obj/item/weapon/knife = list(span_notice("starts to whittle"), span_notice("start to whittle"), 'sound/items/wood_sharpen.ogg'),
	)
	attacked_atom = /obj/item/grown/log/tree/small
	starting_atom = /obj/item/weapon/knife

/datum/repeatable_crafting_recipe/crafting/instrument_vocals
	name = "Vocalist's Talisman"
	output = /obj/item/instrument/vocals
	requirements = list(
		/obj/item/natural/cloth = 2,
		/obj/item/natural/fibers = 3
	)
	tool_usage = list(
		/obj/item/weapon/knife = list(span_notice("starts to whittle"), span_notice("start to whittle"), 'sound/items/wood_sharpen.ogg'),
	)
	attacked_atom = /obj/item/natural/cloth
	starting_atom = /obj/item/weapon/knife

// -------------------------- Gems ------------------------------ //

// jade //

/datum/repeatable_crafting_recipe/crafting/jade
	abstract_type = /datum/repeatable_crafting_recipe/crafting/jade
	requirements = list(
		/obj/item/gem/jade = 1,
	)
	tool_usage = list(
		/obj/item/weapon/knife = list("starts to carve out the raw joapstone", "start to carve the raw joapstone")
	)
	attacked_atom = /obj/item/gem/jade
	starting_atom = /obj/item/weapon/knife
	output_amount = 1
	craftdiff = 1

/datum/repeatable_crafting_recipe/crafting/jade/cutgem
	name = "cut joapstone gem"
	output = /obj/item/carvedgem/jade/cutgem
	craftdiff = 0

/datum/repeatable_crafting_recipe/crafting/jade/fork
	name = "joapstone fork"
	output = /obj/item/carvedgem/jade/fork
	craftdiff = 1

/datum/repeatable_crafting_recipe/crafting/jade/spoon
	name = "joapstone spoon"
	output = /obj/item/carvedgem/jade/spoon
	craftdiff = 1

/datum/repeatable_crafting_recipe/crafting/jade/cameo
	name = "joapstone cameo"
	output = /obj/item/carvedgem/jade/cameo
	craftdiff = 1

/datum/repeatable_crafting_recipe/crafting/jade/bowl
	name = "joapstone bowl"
	output = /obj/item/reagent_containers/glass/bowl/jade
	craftdiff = 1

/datum/repeatable_crafting_recipe/crafting/jade/cup
	name = "joapstone cup"
	output = /obj/item/reagent_containers/glass/cup/jade
	craftdiff = 1

/datum/repeatable_crafting_recipe/crafting/jade/platter
	name = "joapstone platter"
	output = /obj/item/plate/jade
	craftdiff = 2

/datum/repeatable_crafting_recipe/crafting/jade/ring
	name = "joapstone ring"
	output = /obj/item/clothing/ring/jade
	craftdiff = 2

/datum/repeatable_crafting_recipe/crafting/jade/amulet
	name = "joapstone amulet"
	output = /obj/item/clothing/neck/jadeamulet
	craftdiff = 2

/datum/repeatable_crafting_recipe/crafting/jade/vase
	name = "joapstone vase"
	output = /obj/item/carvedgem/jade/vase
	craftdiff = 2

/datum/repeatable_crafting_recipe/crafting/jade/figurine
	name = "joapstone figurine"
	output = /obj/item/carvedgem/jade/figurine
	craftdiff = 2

/datum/repeatable_crafting_recipe/crafting/jade/fish
	name = "joapstone fish figurine"
	output = /obj/item/carvedgem/jade/fish
	craftdiff = 2

/datum/repeatable_crafting_recipe/crafting/jade/tablet
	name = "joapstone tablet"
	output = /obj/item/carvedgem/jade/tablet
	craftdiff = 2

/datum/repeatable_crafting_recipe/crafting/jade/teapot
	name = "joapstone teapot"
	output = /obj/item/reagent_containers/glass/carafe/teapot/jade
	craftdiff = 2

/datum/repeatable_crafting_recipe/crafting/jade/bust
	name = "joapstone bust"
	output = /obj/item/carvedgem/jade/bust
	craftdiff = 3

/datum/repeatable_crafting_recipe/crafting/jade/fancyvase
	name = "fancy joapstone vase"
	output = /obj/item/carvedgem/jade/fancyvase
	craftdiff = 3

/datum/repeatable_crafting_recipe/crafting/jade/comb
	name = "joapstone comb"
	output = /obj/item/carvedgem/jade/comb
	craftdiff = 3

/datum/repeatable_crafting_recipe/crafting/jade/duck
	name = "joapstone duck"
	output = /obj/item/carvedgem/jade/duck
	craftdiff = 3

/datum/repeatable_crafting_recipe/crafting/jade/bracelet
	name = "joapstone bracelets"
	output = /obj/item/clothing/wrists/gem/jadebracelet
	craftdiff = 3

/datum/repeatable_crafting_recipe/crafting/jade/circlet
	name = "joapstone circlet"
	output = /obj/item/clothing/head/crown/circlet/jade
	craftdiff = 3

/datum/repeatable_crafting_recipe/crafting/jade/fancycup
	name = "fancy joapstone cup"
	output = /obj/item/reagent_containers/glass/cup/jadefancy
	craftdiff = 3

/datum/repeatable_crafting_recipe/crafting/jade/mask
	name = "joapstone mask"
	output = /obj/item/clothing/face/jademask
	craftdiff = 4

/datum/repeatable_crafting_recipe/crafting/jade/urn
	name = "joapstone urn"
	output = /obj/item/carvedgem/jade/urn
	craftdiff = 4

/datum/repeatable_crafting_recipe/crafting/jade/statue
	name = "joapstone statue"
	output = /obj/item/carvedgem/jade/statue
	craftdiff = 4

/datum/repeatable_crafting_recipe/crafting/jade/obelisk
	name = "joapstone obelisk"
	output = /obj/item/carvedgem/jade/obelisk
	craftdiff = 4

/datum/repeatable_crafting_recipe/crafting/jade/wyrm
	name = "joapstone wyrm"
	output = /obj/item/carvedgem/jade/wyrm
	craftdiff = 5


/datum/repeatable_crafting_recipe/crafting/jade/kukri
	name = "joapstone kukri"
	output = /obj/item/weapon/knife/stone/kukri
	craftdiff = 5

// shell //

/datum/repeatable_crafting_recipe/crafting/shell
	abstract_type = /datum/repeatable_crafting_recipe/crafting/shell
	requirements = list(
		/obj/item/carvedgem/shell/rawshell = 1,
	)
	tool_usage = list(
		/obj/item/weapon/knife = list("starts to carve out the clam shell", "start to carve out the clam shell")
	)
	attacked_atom = /obj/item/carvedgem/shell/rawshell
	starting_atom = /obj/item/weapon/knife
	output_amount = 1
	craftdiff = 1

/datum/repeatable_crafting_recipe/crafting/shell/openclam
	name = "opened clam"
	output = list (
		/obj/item/carvedgem/shell/openoyster,
		/obj.item/carvedgem/rose/rawrose
	)

	requirements = list(
		/obj/item/gem/oyster = 1
	)
	tool_usage = list(
		/obj/item/weapon/knife = list("starts to pry open the clam shell", "pry open the clam shell")
	)
	attacked_atom = /obj/item/gem/oyster
	starting_atom = /obj/item/weapon/knife
	output_amount = 1
	craftdiff = 0

/datum/repeatable_crafting_recipe/crafting/shell/rawshell

	name = "2x clam shells "
	output = /obj/item/carvedgem/shell/rawshell
	requirements = list(
		/obj/item/carvedgem/shell/openoyster = 1
	)
	tool_usage = list(
		/obj/item/weapon/knife = list("starts to pull apart the clam shell", "pull apart the clam shell")
	)
	attacked_atom = /obj/item/carvedgem/shell/openoyster
	starting_atom = /obj/item/weapon/knife
	output_amount = 2
	craftdiff = 0

/datum/repeatable_crafting_recipe/crafting/shell/cutgem
	name = "polished clam shell"
	output = /obj/item/carvedgem/shell/cutgem
	craftdiff = 0

/datum/repeatable_crafting_recipe/crafting/shell/fork
	name = "shell fork"
	output = /obj/item/carvedgem/shell/fork
	craftdiff = 1

/datum/repeatable_crafting_recipe/crafting/shell/spoon
	name = "shell spoon"
	output = /obj/item/carvedgem/shell/spoon
	craftdiff = 1

/datum/repeatable_crafting_recipe/crafting/shell/cameo
	name = "shell cameo"
	output = /obj/item/carvedgem/shell/cameo
	craftdiff = 1

/datum/repeatable_crafting_recipe/crafting/shell/bowl
	name = "shell bowl"
	output = /obj/item/reagent_containers/glass/bowl/shell
	craftdiff = 1

/datum/repeatable_crafting_recipe/crafting/shell/cup
	name = "shell cup"
	output = /obj/item/reagent_containers/glass/cup/shell
	craftdiff = 1

/datum/repeatable_crafting_recipe/crafting/shell/platter
	name = "shell platter"
	output = /obj/item/plate/shell
	craftdiff = 2

/datum/repeatable_crafting_recipe/crafting/shell/ring
	name = "shell ring"
	output = /obj/item/clothing/ring/shell
	craftdiff = 2

/datum/repeatable_crafting_recipe/crafting/shell/teapot
	name = "shell teapot"
	output = /obj/item/reagent_containers/glass/carafe/teapot/shell
	craftdiff = 2

/datum/repeatable_crafting_recipe/crafting/shell/amulet
	name = "shell amulet"
	output = /obj/item/clothing/neck/shellamulet
	craftdiff = 2

/datum/repeatable_crafting_recipe/crafting/shell/figurine
	name = "shell figurine"
	output = /obj/item/carvedgem/shell/figurine
	craftdiff = 2

/datum/repeatable_crafting_recipe/crafting/shell/tablet
	name = "shell tablet"
	output = /obj/item/carvedgem/shell/tablet
	craftdiff = 2

/datum/repeatable_crafting_recipe/crafting/shell/fish
	name = "shell fish figurine"
	output = /obj/item/carvedgem/shell/fish
	craftdiff = 2

/datum/repeatable_crafting_recipe/crafting/shell/vase
	name = "shell vase"
	output = /obj/item/carvedgem/shell/vase
	craftdiff = 2

/datum/repeatable_crafting_recipe/crafting/shell/bust
	name = "shell bust"
	output = /obj/item/carvedgem/shell/bust
	craftdiff = 3

/datum/repeatable_crafting_recipe/crafting/shell/circlet
	name = "shell circlet"
	output = /obj/item/clothing/head/crown/circlet/shell
	craftdiff = 3

/datum/repeatable_crafting_recipe/crafting/shell/bracelet
	name = "shell bracelets"
	output = /obj/item/clothing/wrists/gem/shellbracelet
	craftdiff = 3

/datum/repeatable_crafting_recipe/crafting/shell/fancycup
	name = "fancy shell cup"
	output = /obj/item/reagent_containers/glass/cup/shellfancy
	craftdiff = 3

/datum/repeatable_crafting_recipe/crafting/shell/fancyvase
	name = "fancy shell vase"
	output = /obj/item/carvedgem/shell/fancyvase
	craftdiff = 3

/datum/repeatable_crafting_recipe/crafting/shell/comb
	name = "shell comb"
	output = /obj/item/carvedgem/shell/comb
	craftdiff = 3

/datum/repeatable_crafting_recipe/crafting/shell/duck
	name = "shell duck"
	output = /obj/item/carvedgem/shell/duck
	craftdiff = 3

/datum/repeatable_crafting_recipe/crafting/shell/mask
	name = "shell mask"
	output = /obj/item/clothing/face/shellmask
	craftdiff = 4

/datum/repeatable_crafting_recipe/crafting/shell/urn
	name = "shell urn"
	output = /obj/item/carvedgem/shell/urn
	craftdiff = 4

/datum/repeatable_crafting_recipe/crafting/shell/statue
	name = "shell statue"
	output = /obj/item/carvedgem/shell/statue
	craftdiff = 4

/datum/repeatable_crafting_recipe/crafting/shell/obelisk
	name = "shell obelisk"
	output = /obj/item/carvedgem/shell/obelisk
	craftdiff = 4

/datum/repeatable_crafting_recipe/crafting/shell/turtle
	name = "turtle carving"
	output = /obj/item/carvedgem/shell/turtle
	craftdiff = 5

/datum/repeatable_crafting_recipe/crafting/shell/rungu
	name = "shell rungu"
	output = /obj/item/weapon/mace/cudgel/shellrungu
	craftdiff = 5

// rose //

/datum/repeatable_crafting_recipe/crafting/rose
	abstract_type = /datum/repeatable_crafting_recipe/crafting/rose
	requirements = list(
		/obj/item/carvedgem/rose/rawrose = 1,
	)
	tool_usage = list(
		/obj/item/weapon/knife = list("carves the rosellusk pearl", "carve the rosellusk pearl")
	)
	attacked_atom = /obj/item/carvedgem/rose/rawrose
	starting_atom = /obj/item/weapon/knife
	output_amount = 1
	craftdiff = 1

/datum/repeatable_crafting_recipe/crafting/rose/cutgem
	name = "rosellusk pearl"
	output = /obj/item/carvedgem/rose/cutgem
	requirements = list(
		/obj/item/carvedgem/rose/rawrose = 1,
	)
	tool_usage = list(
		/obj/item/weapon/knife = list("refines the rosellusk pearl", "refine the rosellusk pearl")
	)
	attacked_atom = /obj/item/carvedgem/rose/rawrose
	starting_atom = /obj/item/weapon/knife
	output_amount = 1
	craftdiff = 0

/datum/repeatable_crafting_recipe/crafting/rose/spoon
	name = "rosellusk spoon"
	output = /obj/item/carvedgem/rose/spoon
	craftdiff = 1

/datum/repeatable_crafting_recipe/crafting/rose/fork
	name = "rosellusk fork"
	output = /obj/item/carvedgem/rose/fork
	craftdiff = 1

/datum/repeatable_crafting_recipe/crafting/rose/cup
	name = "rosellusk cup"
	output = /obj/item/reagent_containers/glass/cup/rose
	craftdiff = 1

/datum/repeatable_crafting_recipe/crafting/rose/bowl
	name = "rosellusk bowl"
	output = /obj/item/reagent_containers/glass/bowl/rose
	craftdiff = 1

/datum/repeatable_crafting_recipe/crafting/rose/cameo
	name = "rosellusk cameo"
	output = /obj/item/carvedgem/rose/cameo
	craftdiff = 1

/datum/repeatable_crafting_recipe/crafting/rose/figurine
	name = "rosellusk figurine"
	output = /obj/item/carvedgem/rose/figurine
	craftdiff = 2

/datum/repeatable_crafting_recipe/crafting/rose/fish
	name = "rosellusk fish figurine"
	output = /obj/item/carvedgem/rose/fish
	craftdiff = 2

/datum/repeatable_crafting_recipe/crafting/rose/vase
	name = "rosellusk vase"
	output = /obj/item/carvedgem/rose/vase
	craftdiff = 2

/datum/repeatable_crafting_recipe/crafting/rose/tablet
	name = "rosellusk tablet"
	output = /obj/item/carvedgem/rose/tablet
	craftdiff = 2

/datum/repeatable_crafting_recipe/crafting/rose/teapot
	name = "rosellusk teapot"
	output = /obj/item/reagent_containers/glass/carafe/teapot/rose
	craftdiff = 2

/datum/repeatable_crafting_recipe/crafting/rose/ring
	name = "rosellusk ring"
	output = /obj/item/clothing/ring/rose
	craftdiff = 2

/datum/repeatable_crafting_recipe/crafting/rose/amulet
	name = "rosellusk amulet"
	output = /obj/item/clothing/neck/roseamulet
	craftdiff = 2

/datum/repeatable_crafting_recipe/crafting/rose/platter
	name = "rosellusk platter"
	output = /obj/item/plate/rose
	craftdiff = 2

/datum/repeatable_crafting_recipe/crafting/rose/bust
	name = "rosellusk bust"
	output = /obj/item/carvedgem/rose/bust
	craftdiff = 3

/datum/repeatable_crafting_recipe/crafting/rose/fancyvase
	name = "fancy rosellusk vase"
	output = /obj/item/carvedgem/rose/fancyvase
	craftdiff = 3

/datum/repeatable_crafting_recipe/crafting/rose/comb
	name = "rosellusk comb"
	output = /obj/item/carvedgem/rose/comb
	craftdiff = 3

/datum/repeatable_crafting_recipe/crafting/rose/duck
	name = "rosellusk duck"
	output = /obj/item/carvedgem/rose/duck
	craftdiff = 3

/datum/repeatable_crafting_recipe/crafting/rose/bracelet
	name = "rosellusk bracelets"
	output = /obj/item/clothing/wrists/gem/rosebracelet
	craftdiff = 3

/datum/repeatable_crafting_recipe/crafting/rose/circlet
	name = "rosellusk circlet"
	output = /obj/item/clothing/head/crown/circlet/rose
	craftdiff = 3

/datum/repeatable_crafting_recipe/crafting/rose/fancycup
	name = "fancy rosellusk cup"
	output = /obj/item/reagent_containers/glass/cup/rosefancy
	craftdiff = 3

/datum/repeatable_crafting_recipe/crafting/rose/urn
	name = "rosellusk urn"
	output = /obj/item/carvedgem/rose/urn
	craftdiff = 4

/datum/repeatable_crafting_recipe/crafting/rose/statue
	name = "rosellusk statue"
	output = /obj/item/carvedgem/rose/statue
	craftdiff = 4

/datum/repeatable_crafting_recipe/crafting/rose/obelisk
	name = "rosellusk obelisk"
	output = /obj/item/carvedgem/rose/obelisk
	craftdiff = 4

/datum/repeatable_crafting_recipe/crafting/rose/mask
	name = "rosellusk mask"
	output = /obj/item/clothing/face/rosemask
	craftdiff = 4

/datum/repeatable_crafting_recipe/crafting/rose/flower
	name = "rosellusk flower carving"
	output = /obj/item/carvedgem/rose/flower
	craftdiff = 5

/datum/repeatable_crafting_recipe/crafting/rose/carp
	name = "rosellusk carp statue"
	output = /obj/item/carvedgem/rose/carp
	craftdiff = 5

// onyxa //

/datum/repeatable_crafting_recipe/crafting/onyxa
	abstract_type = /datum/repeatable_crafting_recipe/crafting/onyxa
	requirements = list(
		/obj/item/gem/onyxa = 1,
	)
	tool_usage = list(
		/obj/item/weapon/knife = list("carves out the onyxa", "carve out the onyxa")
	)
	attacked_atom = /obj/item/gem/onyxa
	starting_atom = /obj/item/weapon/knife
	output_amount = 1
	craftdiff = 1

/datum/repeatable_crafting_recipe/crafting/onyxa/cutgem
	name = "cut onyxa gem"
	output = /obj/item/carvedgem/onyxa/cutgem
	craftdiff = 0

/datum/repeatable_crafting_recipe/crafting/onyxa/fork
	name = "onyxa fork"
	output = /obj/item/carvedgem/onyxa/fork
	craftdiff = 1

/datum/repeatable_crafting_recipe/crafting/onyxa/spoon
	name = "onyxa spoon"
	output = /obj/item/carvedgem/onyxa/spoon
	craftdiff = 1

/datum/repeatable_crafting_recipe/crafting/onyxa/cameo
	name = "onyxa cameo"
	output = /obj/item/carvedgem/onyxa/cameo
	craftdiff = 1

/datum/repeatable_crafting_recipe/crafting/onyxa/cup
	name = "onyxa cup"
	output = /obj/item/reagent_containers/glass/cup/onyxa
	craftdiff = 1

/datum/repeatable_crafting_recipe/crafting/onyxa/bowl
	name = "onyxa bowl"
	output = /obj/item/reagent_containers/glass/bowl/onyxa
	craftdiff = 1

/datum/repeatable_crafting_recipe/crafting/onyxa/figurine
	name = "onyxa figurine"
	output = /obj/item/carvedgem/onyxa/figurine
	craftdiff = 2

/datum/repeatable_crafting_recipe/crafting/onyxa/fish
	name = "onyxa fish figurine"
	output = /obj/item/carvedgem/onyxa/fish
	craftdiff = 2

/datum/repeatable_crafting_recipe/crafting/onyxa/vase
	name = "onyxa vase"
	output = /obj/item/carvedgem/onyxa/vase
	craftdiff = 2

/datum/repeatable_crafting_recipe/crafting/onyxa/tablet
	name = "onyxa tablet"
	output = /obj/item/carvedgem/onyxa/tablet
	craftdiff = 2

/datum/repeatable_crafting_recipe/crafting/onyxa/teapot
	name = "onyxa teapot"
	output = /obj/item/reagent_containers/glass/carafe/teapot/onyxa
	craftdiff = 2

/datum/repeatable_crafting_recipe/crafting/onyxa/ring
	name = "onyxa ring"
	output = /obj/item/clothing/ring/onyxa
	craftdiff = 2

/datum/repeatable_crafting_recipe/crafting/onyxa/amulet
	name = "onyxa amulet"
	output = /obj/item/clothing/neck/onyxaamulet
	craftdiff = 2

/datum/repeatable_crafting_recipe/crafting/onyxa/platter
	name = "onyxa platter"
	output = /obj/item/plate/onyxa
	craftdiff = 2

/datum/repeatable_crafting_recipe/crafting/onyxa/bust
	name = "onyxa bust"
	output = /obj/item/carvedgem/onyxa/bust
	craftdiff = 3

/datum/repeatable_crafting_recipe/crafting/onyxa/fancyvase
	name = "fancy onyxa vase"
	output = /obj/item/carvedgem/onyxa/fancyvase
	craftdiff = 3

/datum/repeatable_crafting_recipe/crafting/onyxa/comb
	name = "onyxa comb"
	output = /obj/item/carvedgem/onyxa/comb
	craftdiff = 3

/datum/repeatable_crafting_recipe/crafting/onyxa/duck
	name = "onyxa duck"
	output = /obj/item/carvedgem/onyxa/duck
	craftdiff = 3

/datum/repeatable_crafting_recipe/crafting/onyxa/fancycup
	name = "fancy onyxa cup"
	output = /obj/item/reagent_containers/glass/cup/onyxafancy
	craftdiff = 3

/datum/repeatable_crafting_recipe/crafting/onyxa/bracelet
	name = "onyxa bracelets"
	output = /obj/item/clothing/wrists/gem/onyxabracelet
	craftdiff = 3

/datum/repeatable_crafting_recipe/crafting/onyxa/circlet
	name = "onyxa circlet"
	output = /obj/item/clothing/head/crown/circlet/onyxa
	craftdiff = 3

/datum/repeatable_crafting_recipe/crafting/onyxa/mask
	name = "onyxa mask"
	output = /obj/item/clothing/face/onyxamask
	craftdiff = 4

/datum/repeatable_crafting_recipe/crafting/onyxa/urn
	name = "onyxa urn"
	output = /obj/item/carvedgem/onyxa/urn
	craftdiff = 4

/datum/repeatable_crafting_recipe/crafting/onyxa/statue
	name = "onyxa statue"
	output = /obj/item/carvedgem/onyxa/statue
	craftdiff = 4

/datum/repeatable_crafting_recipe/crafting/onyxa/obelisk
	name = "onyxa obelisk"
	output = /obj/item/carvedgem/onyxa/obelisk
	craftdiff = 4

/datum/repeatable_crafting_recipe/crafting/onyxa/urn
	name = "onyxa urn"
	output = /obj/item/carvedgem/onyxa/urn
	craftdiff = 4

/datum/repeatable_crafting_recipe/crafting/onyxa/spider
	name = "onyxa spider statue"
	output = /obj/item/carvedgem/onyxa/spider
	craftdiff = 5

/datum/repeatable_crafting_recipe/crafting/onyxa/snake
	name = "onyxa snake statue"
	output = /obj/item/carvedgem/onyxa/snake
	craftdiff = 5

// ceruleabaster //

/datum/repeatable_crafting_recipe/crafting/turq
	abstract_type = /datum/repeatable_crafting_recipe/crafting/turq
	requirements = list(
		/obj/item/gem/turq = 1,
	)
	tool_usage = list(
		/obj/item/weapon/knife = list("carves out the raw ceruleabaster", "carve out the raw ceruleabaster")
	)
	attacked_atom = /obj/item/gem/turq
	starting_atom = /obj/item/weapon/knife
	output_amount = 1
	craftdiff = 1

/datum/repeatable_crafting_recipe/crafting/turq/cutgem
	name = "cut ceruleabaster gem"
	output = /obj/item/carvedgem/turq/cutgem
	craftdiff = 0

/datum/repeatable_crafting_recipe/crafting/turq/fork
	name = "ceruleabaster fork"
	output = /obj/item/carvedgem/turq/fork
	craftdiff = 1

/datum/repeatable_crafting_recipe/crafting/turq/spoon
	name = "ceruleabaster spoon"
	output = /obj/item/carvedgem/turq/spoon
	craftdiff = 1

/datum/repeatable_crafting_recipe/crafting/turq/cameo
	name = "ceruleabaster cameo"
	output = /obj/item/carvedgem/turq/cameo
	craftdiff = 1

/datum/repeatable_crafting_recipe/crafting/turq/bowl
	name = "ceruleabaster bowl"
	output = /obj/item/reagent_containers/glass/bowl/turq
	craftdiff = 1

/datum/repeatable_crafting_recipe/crafting/turq/cup
	name = "ceruleabaster cup"
	output = /obj/item/reagent_containers/glass/cup/turq
	craftdiff = 1

/datum/repeatable_crafting_recipe/crafting/turq/figurine
	name = "ceruleabaster figurine"
	output = /obj/item/carvedgem/turq/figurine
	craftdiff = 2

/datum/repeatable_crafting_recipe/crafting/turq/fish
	name = "ceruleabaster fish figurine"
	output = /obj/item/carvedgem/turq/fish
	craftdiff = 2

/datum/repeatable_crafting_recipe/crafting/turq/vase
	name = "ceruleabaster vase"
	output = /obj/item/carvedgem/turq/vase
	craftdiff = 2

/datum/repeatable_crafting_recipe/crafting/turq/amulet
	name = "ceruleabaster amulet"
	output = /obj/item/clothing/neck/turqamulet
	craftdiff = 2

/datum/repeatable_crafting_recipe/crafting/turq/tablet
	name = "ceruleabaster tablet"
	output = /obj/item/carvedgem/turq/tablet
	craftdiff = 2

/datum/repeatable_crafting_recipe/crafting/turq/ring
	name = "ceruleabaster ring"
	output = /obj/item/clothing/ring/turq
	craftdiff = 2

/datum/repeatable_crafting_recipe/crafting/turq/platter
	name = "ceruleabaster platter"
	output = /obj/item/plate/turq
	craftdiff = 2

/datum/repeatable_crafting_recipe/crafting/turq/bracelet
	name = "ceruleabaster bracelets"
	output = /obj/item/clothing/wrists/gem/turqbracelet
	craftdiff = 3

/datum/repeatable_crafting_recipe/crafting/turq/circlet
	name = "ceruleabaster circlet"
	output = /obj/item/clothing/head/crown/circlet/turq
	craftdiff = 3

/datum/repeatable_crafting_recipe/crafting/turq/fancycup
	name = "fancy ceruleabaster cup"
	output = /obj/item/reagent_containers/glass/cup/turqfancy
	craftdiff = 3

/datum/repeatable_crafting_recipe/crafting/turq/fancyvase
	name = "fancy ceruleabaster vase"
	output = /obj/item/carvedgem/turq/fancyvase
	craftdiff = 3

/datum/repeatable_crafting_recipe/crafting/turq/bust
	name = "ceruleabaster bust"
	output = /obj/item/carvedgem/turq/bust
	craftdiff = 3

/datum/repeatable_crafting_recipe/crafting/turq/comb
	name = "ceruleabaster comb"
	output = /obj/item/carvedgem/turq/comb
	craftdiff = 3

/datum/repeatable_crafting_recipe/crafting/turq/duck
	name = "ceruleabaster duck"
	output = /obj/item/carvedgem/turq/duck
	craftdiff = 3

/datum/repeatable_crafting_recipe/crafting/turq/urn
	name = "ceruleabaster urn"
	output = /obj/item/carvedgem/turq/urn
	craftdiff = 4

/datum/repeatable_crafting_recipe/crafting/turq/statue
	name = "ceruleabaster statue"
	output = /obj/item/carvedgem/turq/statue
	craftdiff = 4

/datum/repeatable_crafting_recipe/crafting/turq/obelisk
	name = "ceruleabaster obelisk"
	output = /obj/item/carvedgem/turq/obelisk
	craftdiff = 4

/datum/repeatable_crafting_recipe/crafting/turq/mask
	name = "ceruleabaster mask"
	output = /obj/item/clothing/face/turqmask
	craftdiff = 4

/datum/repeatable_crafting_recipe/crafting/turq/ka
	name = "ceruleabaster ka statue"
	output = /obj/item/carvedgem/turq/ka
	craftdiff = 5

/datum/repeatable_crafting_recipe/crafting/turq/scarab
	name = "ceruleabaster scarab"
	output = /obj/item/carvedgem/turq/scarab
	craftdiff = 5

// aoetal //

/datum/repeatable_crafting_recipe/crafting/coral
	abstract_type = /datum/repeatable_crafting_recipe/crafting/coral
	requirements = list(
		/obj/item/gem/coral = 1,
	)
	tool_usage = list(
		/obj/item/weapon/knife = list("carves out the raw aoetal", "carve out the raw aoetal")
	)
	attacked_atom = /obj/item/gem/coral
	starting_atom = /obj/item/weapon/knife
	output_amount = 1
	craftdiff = 1

/datum/repeatable_crafting_recipe/crafting/coral/cutgem
	name = "cut aoetal gem"
	output = /obj/item/carvedgem/coral/cutgem
	craftdiff = 0

/datum/repeatable_crafting_recipe/crafting/coral/fork
	name = "aoetal fork"
	output = /obj/item/carvedgem/coral/fork
	craftdiff = 1

/datum/repeatable_crafting_recipe/crafting/coral/spoon
	name = "aoetal spoon"
	output = /obj/item/carvedgem/coral/spoon
	craftdiff = 1

/datum/repeatable_crafting_recipe/crafting/coral/cameo
	name = "aoetal cameo"
	output = /obj/item/carvedgem/coral/cameo
	craftdiff = 1

/datum/repeatable_crafting_recipe/crafting/coral/cup
	name = "aoetal cup"
	output = /obj/item/reagent_containers/glass/cup/coral
	craftdiff = 1

/datum/repeatable_crafting_recipe/crafting/coral/bowl
	name = "aoetal bowl"
	output = /obj/item/reagent_containers/glass/bowl/coral
	craftdiff = 1

/datum/repeatable_crafting_recipe/crafting/coral/figurine
	name = "aoetal figurine"
	output = /obj/item/carvedgem/coral/figurine
	craftdiff = 2

/datum/repeatable_crafting_recipe/crafting/coral/fish
	name = "aoetal fish figurine"
	output = /obj/item/carvedgem/coral/fish
	craftdiff = 2

/datum/repeatable_crafting_recipe/crafting/coral/vase
	name = "aoetal vase"
	output = /obj/item/carvedgem/coral/vase
	craftdiff = 2

/datum/repeatable_crafting_recipe/crafting/coral/tablet
	name = "aoetal tablet"
	output = /obj/item/carvedgem/coral/tablet
	craftdiff = 2

/datum/repeatable_crafting_recipe/crafting/coral/teapot
	name = "aoetal teapot"
	output = /obj/item/reagent_containers/glass/carafe/teapot/coral
	craftdiff = 2

/datum/repeatable_crafting_recipe/crafting/coral/platter
	name = "aoetal platter"
	output = /obj/item/plate/coral
	craftdiff = 2

/datum/repeatable_crafting_recipe/crafting/coral/amulet
	name = "aoetal amulet"
	output = /obj/item/clothing/neck/coralamulet
	craftdiff = 2

/datum/repeatable_crafting_recipe/crafting/coral/ring
	name = "aoetal ring"
	output = /obj/item/clothing/ring/coral
	craftdiff = 2

/datum/repeatable_crafting_recipe/crafting/coral/bust
	name = "aoetal bust"
	output = /obj/item/carvedgem/coral/bust
	craftdiff = 3

/datum/repeatable_crafting_recipe/crafting/coral/fancyvase
	name = "fancy aoetal vase"
	output = /obj/item/carvedgem/coral/fancyvase
	craftdiff = 3

/datum/repeatable_crafting_recipe/crafting/coral/comb
	name = "aoetal comb"
	output = /obj/item/carvedgem/coral/comb
	craftdiff = 3

/datum/repeatable_crafting_recipe/crafting/coral/duck
	name = "aoetal duck"
	output = /obj/item/carvedgem/coral/duck
	craftdiff = 3

/datum/repeatable_crafting_recipe/crafting/coral/fancycup
	name = "fancy aoetal cup"
	output = /obj/item/reagent_containers/glass/cup/coralfancy
	craftdiff = 3

/datum/repeatable_crafting_recipe/crafting/coral/circlet
	name = "aoetal circlet"
	output = /obj/item/clothing/head/crown/circlet/coral
	craftdiff = 3

/datum/repeatable_crafting_recipe/crafting/coral/bracelet
	name = "aoetal bracelets"
	output = /obj/item/clothing/wrists/gem/coralbracelet
	craftdiff = 3

/datum/repeatable_crafting_recipe/crafting/coral/mask
	name = "aoetal mask"
	output = /obj/item/clothing/face/coralmask
	craftdiff = 4

/datum/repeatable_crafting_recipe/crafting/coral/statue
	name = "aoetal statue"
	output = /obj/item/carvedgem/coral/statue
	craftdiff = 4

/datum/repeatable_crafting_recipe/crafting/coral/urn
	name = "aoetal urn"
	output = /obj/item/carvedgem/coral/urn
	craftdiff = 4

/datum/repeatable_crafting_recipe/crafting/coral/obelisk
	name = "aoetal obelisk"
	output = /obj/item/carvedgem/coral/obelisk
	craftdiff = 4

/datum/repeatable_crafting_recipe/crafting/coral/jaw
	name = "shark jaw statue"
	output = /obj/item/carvedgem/coral/jaw
	craftdiff = 5

/datum/repeatable_crafting_recipe/crafting/coral/shark
	name = "aoetal shark statue"
	output = /obj/item/carvedgem/coral/shark
	craftdiff = 5

// petriamber //

/datum/repeatable_crafting_recipe/crafting/amber
	abstract_type = /datum/repeatable_crafting_recipe/crafting/amber
	requirements = list(
		/obj/item/gem/amber = 1,
	)
	tool_usage = list(
		/obj/item/weapon/knife = list("carves out the raw petriamber", "carve out the raw petriamber")
	)
	attacked_atom = /obj/item/gem/amber
	starting_atom = /obj/item/weapon/knife
	output_amount = 1
	craftdiff = 1

/datum/repeatable_crafting_recipe/crafting/amber/cutgem
	name = "cut petriamber gem"
	output = /obj/item/carvedgem/amber/cutgem
	craftdiff = 0

/datum/repeatable_crafting_recipe/crafting/amber/spoon
	name = "petriamber spoon"
	output = /obj/item/carvedgem/amber/spoon
	craftdiff = 1

/datum/repeatable_crafting_recipe/crafting/amber/fork
	name = "petriamber fork"
	output = /obj/item/carvedgem/amber/fork
	craftdiff = 1

/datum/repeatable_crafting_recipe/crafting/amber/cameo
	name = "petriamber cameo"
	output = /obj/item/carvedgem/amber/cameo
	craftdiff = 1

/datum/repeatable_crafting_recipe/crafting/amber/bowl
	name = "petriamber bowl"
	output = /obj/item/reagent_containers/glass/bowl/amber
	craftdiff = 1

/datum/repeatable_crafting_recipe/crafting/amber/cup
	name = "petriamber cup"
	output = /obj/item/reagent_containers/glass/cup/amber
	craftdiff = 1

/datum/repeatable_crafting_recipe/crafting/amber/figurine
	name = "petriamber figurine"
	output = /obj/item/carvedgem/amber/figurine
	craftdiff = 2

/datum/repeatable_crafting_recipe/crafting/amber/fish
	name = "petriamber fish figurine"
	output = /obj/item/carvedgem/amber/fish
	craftdiff = 2

/datum/repeatable_crafting_recipe/crafting/amber/tablet
	name = "petriamber tablet"
	output = /obj/item/carvedgem/amber/tablet
	craftdiff = 2

/datum/repeatable_crafting_recipe/crafting/amber/vase
	name = "petriamber vase"
	output = /obj/item/carvedgem/amber/vase
	craftdiff = 2

/datum/repeatable_crafting_recipe/crafting/amber/teapot
	name = "petriamber teapot"
	output = /obj/item/reagent_containers/glass/carafe/teapot/amber
	craftdiff = 2

/datum/repeatable_crafting_recipe/crafting/amber/platter
	name = "petriamber platter"
	output = /obj/item/plate/amber
	craftdiff = 2

/datum/repeatable_crafting_recipe/crafting/amber/ring
	name = "petriamber ring"
	output = /obj/item/clothing/ring/amber
	craftdiff = 2

/datum/repeatable_crafting_recipe/crafting/amber/amulet
	name = "petriamber amulet"
	output = /obj/item/clothing/neck/amberamulet
	craftdiff = 2

/datum/repeatable_crafting_recipe/crafting/amber/bracelet
	name = "petriamber bracelets"
	output = /obj/item/clothing/wrists/gem/amberbracelet
	craftdiff = 3

/datum/repeatable_crafting_recipe/crafting/amber/circlet
	name = "petriamber circlet"
	output = /obj/item/clothing/head/crown/circlet/amber
	craftdiff = 3

/datum/repeatable_crafting_recipe/crafting/amber/fancycup
	name = "fancy petriamber cup"
	output = /obj/item/reagent_containers/glass/cup/amberfancy
	craftdiff = 3

/datum/repeatable_crafting_recipe/crafting/amber/fancyvase
	name = "fancy petriamber vase"
	output = /obj/item/carvedgem/amber/fancyvase
	craftdiff = 3

/datum/repeatable_crafting_recipe/crafting/amber/bust
	name = "petriamber bust"
	output = /obj/item/carvedgem/amber/bust
	craftdiff = 3

/datum/repeatable_crafting_recipe/crafting/amber/comb
	name = "petriamber comb"
	output = /obj/item/carvedgem/amber/comb
	craftdiff = 3

/datum/repeatable_crafting_recipe/crafting/amber/duck
	name = "petriamber duck"
	output = /obj/item/carvedgem/amber/duck
	craftdiff = 3

/datum/repeatable_crafting_recipe/crafting/amber/mask
	name = "petriamber mask"
	output = /obj/item/clothing/face/ambermask
	craftdiff = 4

/datum/repeatable_crafting_recipe/crafting/amber/obelisk
	name = "petriamber obelisk"
	output = /obj/item/carvedgem/amber/obelisk
	craftdiff = 4

/datum/repeatable_crafting_recipe/crafting/amber/urn
	name = "petriamber urn"
	output = /obj/item/carvedgem/amber/urn
	craftdiff = 4

/datum/repeatable_crafting_recipe/crafting/amber/statue
	name = "petriamber statue"
	output = /obj/item/carvedgem/amber/statue
	craftdiff = 4

/datum/repeatable_crafting_recipe/crafting/amber/beaver
	name = "petriamber beaver statue"
	output = /obj/item/carvedgem/amber/beaver
	craftdiff = 5

/datum/repeatable_crafting_recipe/crafting/amber/sun
	name = "petriamber sun carving"
	output = /obj/item/carvedgem/amber/sun
	craftdiff = 5

// opaloise //

/datum/repeatable_crafting_recipe/crafting/opal
	abstract_type = /datum/repeatable_crafting_recipe/crafting/opal
	requirements = list(
		/obj/item/gem/opal = 1,
	)
	tool_usage = list(
		/obj/item/weapon/knife = list("carves out the raw opaloise", "carve out the raw opaloise")
	)
	attacked_atom = /obj/item/gem/opal
	starting_atom = /obj/item/weapon/knife
	output_amount = 1
	craftdiff = 1

/datum/repeatable_crafting_recipe/crafting/opal/cutgem
	name = "cut opaloise gem"
	output = /obj/item/carvedgem/opal/cutgem
	craftdiff = 0

/datum/repeatable_crafting_recipe/crafting/opal/spoon
	name = "opaloise spoon"
	output = /obj/item/carvedgem/opal/spoon
	craftdiff = 1

/datum/repeatable_crafting_recipe/crafting/opal/fork
	name = "opaloise fork"
	output = /obj/item/carvedgem/opal/fork
	craftdiff = 1

/datum/repeatable_crafting_recipe/crafting/opal/cameo
	name = "opaloise cameo"
	output = /obj/item/carvedgem/opal/cameo
	craftdiff = 1

/datum/repeatable_crafting_recipe/crafting/opal/bowl
	name = "opaloise bowl"
	output = /obj/item/reagent_containers/glass/bowl/opal
	craftdiff = 1

/datum/repeatable_crafting_recipe/crafting/opal/cup
	name = "opaloise cup"
	output = /obj/item/reagent_containers/glass/cup/opal
	craftdiff = 1

/datum/repeatable_crafting_recipe/crafting/opal/teapot
	name = "opaloise teapot"
	output = /obj/item/reagent_containers/glass/carafe/teapot/opal
	craftdiff = 2

/datum/repeatable_crafting_recipe/crafting/opal/platter
	name = "opaloise platter"
	output = /obj/item/plate/opal
	craftdiff = 2

/datum/repeatable_crafting_recipe/crafting/opal/ring
	name = "opaloise ring"
	output = /obj/item/clothing/ring/opal
	craftdiff = 2

/datum/repeatable_crafting_recipe/crafting/opal/amulet
	name = "opaloise amulet"
	output = /obj/item/clothing/neck/opalamulet
	craftdiff = 2

/datum/repeatable_crafting_recipe/crafting/opal/figurine
	name = "opaloise figurine"
	output = /obj/item/carvedgem/opal/figurine
	craftdiff = 2

/datum/repeatable_crafting_recipe/crafting/opal/fish
	name = "opaloise fish figurine"
	output = /obj/item/carvedgem/opal/fish
	craftdiff = 2

/datum/repeatable_crafting_recipe/crafting/opal/vase
	name = "opaloise vase"
	output = /obj/item/carvedgem/opal/vase
	craftdiff = 2

/datum/repeatable_crafting_recipe/crafting/opal/tablet
	name = "opaloise tablet"
	output = /obj/item/carvedgem/opal/tablet
	craftdiff = 2

/datum/repeatable_crafting_recipe/crafting/opal/bracelet
	name = "opaloise bracelets"
	output = /obj/item/clothing/wrists/gem/opalbracelet
	craftdiff = 3

/datum/repeatable_crafting_recipe/crafting/opal/circlet
	name = "opaloise circlet"
	output = /obj/item/clothing/head/crown/circlet/opal
	craftdiff = 3

/datum/repeatable_crafting_recipe/crafting/opal/fancycup
	name = "fancy opaloise cup"
	output = /obj/item/reagent_containers/glass/cup/opalfancy
	craftdiff = 3

/datum/repeatable_crafting_recipe/crafting/opal/bust
	name = "opaloise bust"
	output = /obj/item/carvedgem/opal/bust
	craftdiff = 3

/datum/repeatable_crafting_recipe/crafting/opal/fancyvase
	name = "fancy opaloise vase"
	output = /obj/item/carvedgem/opal/fancyvase
	craftdiff = 3

/datum/repeatable_crafting_recipe/crafting/opal/comb
	name = "opaloise comb"
	output = /obj/item/carvedgem/opal/comb
	craftdiff = 3

/datum/repeatable_crafting_recipe/crafting/opal/duck
	name = "opaloise duck"
	output = /obj/item/carvedgem/opal/duck
	craftdiff = 3

/datum/repeatable_crafting_recipe/crafting/opal/mask
	name = "opaloise mask"
	output = /obj/item/clothing/face/opalmask
	craftdiff = 4

/datum/repeatable_crafting_recipe/crafting/opal/obelisk
	name = "opaloise obelisk"
	output = /obj/item/carvedgem/opal/obelisk
	craftdiff = 4

/datum/repeatable_crafting_recipe/crafting/opal/urn
	name = "opaloise urn"
	output = /obj/item/carvedgem/opal/urn
	craftdiff = 4

/datum/repeatable_crafting_recipe/crafting/opal/statue
	name = "opaloise statue"
	output = /obj/item/carvedgem/opal/statue
	craftdiff = 4

/datum/repeatable_crafting_recipe/crafting/opal/crab
	name = "opaloise crab sculpture"
	output = /obj/item/carvedgem/opal/crab
	craftdiff = 5

/datum/repeatable_crafting_recipe/crafting/opal/knife
	name = "opaloise knife"
	output = /obj/item/weapon/knife/stone/opal
	craftdiff = 5
