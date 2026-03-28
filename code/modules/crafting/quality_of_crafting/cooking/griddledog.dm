/datum/repeatable_crafting_recipe/cooking/wiener_stick
	name = "Skewered Wiener"
	subtypes_allowed = TRUE
	requirements = list(
		/obj/item/reagent_containers/food/snacks/cooked/sausage = 1,
		/obj/item/grown/log/tree/stick = 1,
	)
	attacked_atom = /obj/item/reagent_containers/food/snacks/cooked/sausage
	starting_atom = /obj/item/grown/log/tree/stick
	output = /obj/item/reagent_containers/food/snacks/cooked/sausage_sticked
	subtypes_allowed = TRUE
	craft_time = 3 SECONDS
	crafting_sound = 'sound/foley/dropsound/food_drop.ogg'
	extra_chance = 100
	crafting_message = "skewer the sausage"

/datum/repeatable_crafting_recipe/cooking/raw_griddle_dog
	category = "Vanderlin Cuisine"
	name = "Raw Griddledog"

	requirements = list(
		/obj/item/reagent_containers/food/snacks/cooked/sausage_sticked = 1,
		/obj/item/reagent_containers/food/snacks/butterdough_slice = 1,
	)
	attacked_atom = /obj/item/reagent_containers/food/snacks/butterdough_slice
	starting_atom = /obj/item/reagent_containers/food/snacks/cooked/sausage_sticked
	allow_inverse_start = TRUE
	output = /obj/item/reagent_containers/food/snacks/foodbase/griddledog_raw
	required_table = TRUE
	craft_time = 6 SECONDS
	crafting_sound = 'sound/foley/kneading_alt.ogg'
	sound_volume = 90
	crafting_message = "cover the sausage with dough"
	extra_chance = 100
	skillcraft = /datum/attribute/skill/craft/cooking/baking
