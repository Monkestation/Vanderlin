
/datum/fish_source/ocean
	catalog_description = "Shallow Ocean"
	fish_table = list(
		FISHING_DUD = 3,
		/obj/item/reagent_containers/food/snacks/fish/angler = 1,
		/obj/item/reagent_containers/food/snacks/fish/carp = 2,
		/obj/item/reagent_containers/food/snacks/fish/shrimp = 1,
		/obj/item/reagent_containers/food/snacks/fish/eel = 6,
	)
	fish_counts = list(
		/obj/item/reagent_containers/food/snacks/fish/carp = 2,
		/obj/item/reagent_containers/food/snacks/fish/shrimp = 2,
		/obj/item/reagent_containers/food/snacks/fish/angler = 1,
		/obj/item/reagent_containers/food/snacks/fish/eel = 5,
	)
	fish_count_regen = list(
		/obj/item/reagent_containers/food/snacks/fish/eel = 3 MINUTES,
		/obj/item/reagent_containers/food/snacks/fish/carp = 3 MINUTES,
		/obj/item/reagent_containers/food/snacks/fish/shrimp = 6 MINUTES,
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
