/datum/fish_source/water
	catalog_description = "Calm Waters"
	fish_table = list(
		FISHING_DUD = 2,
		/obj/item/reagent_containers/food/snacks/fish/carp = 6,
		/obj/item/reagent_containers/food/snacks/fish/eel = 2,
		/obj/item/reagent_containers/food/snacks/fish/angler = 1,
		/obj/item/reagent_containers/food/snacks/fish/clownfish = 1,
	)
	fish_counts = list(
		/obj/item/reagent_containers/food/snacks/fish/carp = 6,
		/obj/item/reagent_containers/food/snacks/fish/eel = 2,
		/obj/item/reagent_containers/food/snacks/fish/angler = 1,
		/obj/item/reagent_containers/food/snacks/fish/clownfish = 1,
	)
	fish_count_regen = list(
		/obj/item/reagent_containers/food/snacks/fish/carp = 2 MINUTES,
		/obj/item/reagent_containers/food/snacks/fish/eel = 4 MINUTES,
		/obj/item/reagent_containers/food/snacks/fish/angler = 30 MINUTES,
		/obj/item/reagent_containers/food/snacks/fish/clownfish = 20 MINUTES,
	)
	fish_source_flags = FISH_SOURCE_FLAG_EXPLOSIVE_MALUS
	associated_safe_turfs = list(/turf/open/water)
	fishing_difficulty = FISHING_DEFAULT_DIFFICULTY + 12

/datum/fish_source/ocean
	catalog_description = "Shallow Ocean"
	background = "background_tray"
	fish_table = list(
		FISHING_DUD = 3,
		/obj/item/reagent_containers/food/snacks/fish/angler = 1,
		/obj/item/reagent_containers/food/snacks/fish/clownfish = 2,
		/obj/item/reagent_containers/food/snacks/fish/shrimp = 3,
	)
	fish_counts = list(
		/obj/item/reagent_containers/food/snacks/fish/clownfish = 3,
		/obj/item/reagent_containers/food/snacks/fish/shrimp = 4,
		/obj/item/reagent_containers/food/snacks/fish/angler = 1,
	)
	fish_count_regen = list(
		/obj/item/reagent_containers/food/snacks/fish/clownfish = 4 MINUTES,
		/obj/item/reagent_containers/food/snacks/fish/shrimp = 3 MINUTES,
		/obj/item/reagent_containers/food/snacks/fish/angler = 32 MINUTES,
	)
	fish_source_flags = FISH_SOURCE_FLAG_EXPLOSIVE_MALUS
	associated_safe_turfs = list(/turf/open/water/ocean)
	fishing_difficulty = FISHING_DEFAULT_DIFFICULTY + 15

/datum/fish_source/ocean/deep
	catalog_description = "Deep Ocean"
	fish_table = list(
		FISHING_DUD = 3,
		/obj/item/reagent_containers/food/snacks/fish/angler = 6,
		/obj/item/reagent_containers/food/snacks/fish/swordfish = 5,
		/obj/item/reagent_containers/food/snacks/fish/carp = 2,
		/obj/item/reagent_containers/food/snacks/fish/shrimp = 1,
		/obj/item/reagent_containers/food/snacks/fish/eel = 2,
	)
	fish_counts = list(
		/obj/item/reagent_containers/food/snacks/fish/carp = 1,
		/obj/item/reagent_containers/food/snacks/fish/shrimp = 1,
		/obj/item/reagent_containers/food/snacks/fish/angler = 3,
		/obj/item/reagent_containers/food/snacks/fish/eel = 5,
	)
	fish_count_regen = list(
		/obj/item/reagent_containers/food/snacks/fish/eel = 3 MINUTES,
		/obj/item/reagent_containers/food/snacks/fish/carp = 3 MINUTES,
		/obj/item/reagent_containers/food/snacks/fish/shrimp = 6 MINUTES,
		/obj/item/reagent_containers/food/snacks/fish/angler = 5 MINUTES,
	)
	fish_source_flags = FISH_SOURCE_FLAG_EXPLOSIVE_MALUS
	associated_safe_turfs = list(/turf/open/water/ocean/deep)
	fishing_difficulty = FISHING_DEFAULT_DIFFICULTY + 15

/datum/fish_source/swamp
	catalog_description = "Murky Swamp"
	background = "background_dank"
	fish_table = list(
		FISHING_DUD = 4,
		/obj/item/reagent_containers/food/snacks/fish/eel = 6,
		/obj/item/reagent_containers/food/snacks/fish/carp = 2,
		/obj/item/reagent_containers/food/snacks/fish/shrimp = 1,
	)
	fish_counts = list(
		/obj/item/reagent_containers/food/snacks/fish/eel = 6,
		/obj/item/reagent_containers/food/snacks/fish/carp = 2,
		/obj/item/reagent_containers/food/snacks/fish/shrimp = 1,
	)
	fish_count_regen = list(
		/obj/item/reagent_containers/food/snacks/fish/eel = 2 MINUTES,
		/obj/item/reagent_containers/food/snacks/fish/carp = 4 MINUTES,
		/obj/item/reagent_containers/food/snacks/fish/shrimp = 8 MINUTES,
	)
	fish_source_flags = FISH_SOURCE_FLAG_EXPLOSIVE_MALUS
	associated_safe_turfs = list(/turf/open/water/swamp)
	fishing_difficulty = FISHING_DEFAULT_DIFFICULTY + 10

/datum/fish_source/swamp/deep
	catalog_description = "Deep Swamp Waters"
	fish_table = list(
		FISHING_DUD = 3,
		/obj/item/reagent_containers/food/snacks/fish/eel = 5,
		/obj/item/reagent_containers/food/snacks/fish/carp = 3,
		/obj/item/reagent_containers/food/snacks/fish/shrimp = 1,
		/obj/item/reagent_containers/food/snacks/fish/angler = 2,
	)
	fish_counts = list(
		/obj/item/reagent_containers/food/snacks/fish/eel = 5,
		/obj/item/reagent_containers/food/snacks/fish/carp = 3,
		/obj/item/reagent_containers/food/snacks/fish/shrimp = 1,
		/obj/item/reagent_containers/food/snacks/fish/angler = 2,
	)
	fish_count_regen = list(
		/obj/item/reagent_containers/food/snacks/fish/eel = 2 MINUTES,
		/obj/item/reagent_containers/food/snacks/fish/carp = 3 MINUTES,
		/obj/item/reagent_containers/food/snacks/fish/shrimp = 7 MINUTES,
		/obj/item/reagent_containers/food/snacks/fish/angler = 25 MINUTES,
	)
	fish_source_flags = FISH_SOURCE_FLAG_EXPLOSIVE_MALUS
	associated_safe_turfs = list(/turf/open/water/swamp/deep)
	fishing_difficulty = FISHING_DEFAULT_DIFFICULTY + 20

/datum/fish_source/cleanshallow
	catalog_description = "Clean Shallows"
	background = "background_ice"
	fish_table = list(
		FISHING_DUD = 2,
		/obj/item/reagent_containers/food/snacks/fish/carp = 5,
		/obj/item/reagent_containers/food/snacks/fish/eel = 3,
	)
	fish_counts = list(
		/obj/item/reagent_containers/food/snacks/fish/carp = 5,
		/obj/item/reagent_containers/food/snacks/fish/eel = 3,
	)
	fish_count_regen = list(
		/obj/item/reagent_containers/food/snacks/fish/carp = 2 MINUTES,
		/obj/item/reagent_containers/food/snacks/fish/eel = 4 MINUTES,
	)
	fish_source_flags = FISH_SOURCE_FLAG_EXPLOSIVE_MALUS
	associated_safe_turfs = list(/turf/open/water/cleanshallow)
	fishing_difficulty = FISHING_DEFAULT_DIFFICULTY + 5

/datum/fish_source/river
	catalog_description = "Flowing River"
	fish_table = list(
		FISHING_DUD = 2,
		/obj/item/reagent_containers/food/snacks/fish/carp = 6,
		/obj/item/reagent_containers/food/snacks/fish/eel = 2,
		/obj/item/reagent_containers/food/snacks/fish/angler = 1,
	)
	fish_counts = list(
		/obj/item/reagent_containers/food/snacks/fish/carp = 6,
		/obj/item/reagent_containers/food/snacks/fish/eel = 2,
		/obj/item/reagent_containers/food/snacks/fish/angler = 1,
	)
	fish_count_regen = list(
		/obj/item/reagent_containers/food/snacks/fish/carp = 2 MINUTES,
		/obj/item/reagent_containers/food/snacks/fish/eel = 4 MINUTES,
		/obj/item/reagent_containers/food/snacks/fish/angler = 30 MINUTES,
	)
	fish_source_flags = FISH_SOURCE_FLAG_EXPLOSIVE_MALUS
	associated_safe_turfs = list(/turf/open/water/river)
	fishing_difficulty = FISHING_DEFAULT_DIFFICULTY + 12

/datum/fish_source/sewer
	catalog_description = "Filthy Sewers"
	background = "background_dank"
	fish_table = list(
		FISHING_DUD = 5,
		/obj/item/coin/copper = 3,
		/obj/item/reagent_containers/food/snacks/smallrat/dead = 3,
		/obj/item/reagent_containers/food/snacks/rotten/meat = 2,
		/obj/item/reagent_containers/food/snacks/rotten/bacon = 1,
		/obj/item/reagent_containers/food/snacks/rotten/sausage = 1,
		/obj/item/reagent_containers/food/snacks/rotten/breadslice = 2,
		/obj/item/reagent_containers/food/snacks/rotten/egg = 1,
		/obj/item/reagent_containers/food/snacks/rotten/mince = 1,
		/obj/item/natural/fibers = 2,
		/obj/item/clothing/shoes/boots/leather = 1,
		/obj/item/reagent_containers/food/snacks/fish/eel = 1,
		/obj/item/reagent_containers/food/snacks/
	)
	fish_counts = list(
		/obj/item/coin/copper = 5,
		/obj/item/reagent_containers/food/snacks/smallrat/dead = 4,
		/obj/item/reagent_containers/food/snacks/rotten/meat = 3,
		/obj/item/reagent_containers/food/snacks/rotten/bacon = 2,
		/obj/item/reagent_containers/food/snacks/rotten/sausage = 2,
		/obj/item/reagent_containers/food/snacks/rotten/breadslice = 3,
		/obj/item/reagent_containers/food/snacks/rotten/egg = 2,
		/obj/item/reagent_containers/food/snacks/rotten/mince = 2,
		/obj/item/natural/fibers = 3,
		/obj/item/clothing/shoes/boots/leather = 1,
		/obj/item/reagent_containers/food/snacks/fish/eel = 1,
	)
	fish_count_regen = list(
		/obj/item/coin/copper = 10 MINUTES,
		/obj/item/reagent_containers/food/snacks/smallrat/dead = 9 MINUTES,
		/obj/item/reagent_containers/food/snacks/rotten/meat = 8 MINUTES,
		/obj/item/reagent_containers/food/snacks/rotten/bacon = 12 MINUTES,
		/obj/item/reagent_containers/food/snacks/rotten/sausage = 12 MINUTES,
		/obj/item/reagent_containers/food/snacks/rotten/breadslice = 8 MINUTES,
		/obj/item/reagent_containers/food/snacks/rotten/egg = 15 MINUTES,
		/obj/item/reagent_containers/food/snacks/rotten/mince = 12 MINUTES,
		/obj/item/natural/fibers = 5 MINUTES,
		/obj/item/clothing/shoes/boots/leather = 45 MINUTES,
		/obj/item/reagent_containers/food/snacks/fish/eel = 60 MINUTES,
	)
	fish_source_flags = FISH_SOURCE_FLAG_EXPLOSIVE_MALUS
	associated_safe_turfs = list(/turf/open/water/sewer) // adjust to your sewer turf type
	fishing_difficulty = FISHING_DEFAULT_DIFFICULTY + 5
