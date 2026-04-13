/datum/repeatable_crafting_recipe/cooking/jellycake
	abstract_type = /datum/repeatable_crafting_recipe/cooking/jellycake
	required_table = TRUE
	minimum_skill_level = 3
	craft_time = 9 SECONDS
	crafting_sound = 'sound/foley/kneading_alt.ogg'
	extra_chance = 100
	attacked_atom = /obj/item/reagent_containers/food/snacks/jellycake_base
	skillcraft = /datum/attribute/skill/craft/cooking/confectionery

/datum/repeatable_crafting_recipe/cooking/jellycake/apple
	name = "Apple Jellycake"

	requirements = list(
		/obj/item/reagent_containers/food/snacks/produce/fruit/apple = 1,
		/obj/item/reagent_containers/food/snacks/jellycake_base = 1,
	)
	starting_atom = /obj/item/reagent_containers/food/snacks/produce/fruit/apple
	output = /obj/item/reagent_containers/food/snacks/jellycake_apple
	crafting_message = "mix apple into the gelatine"

/datum/repeatable_crafting_recipe/cooking/jellycake/dried_apple
	name = "Dried Apple Jellycake"

	requirements = list(
		/obj/item/reagent_containers/food/snacks/apple_dried = 1,
		/obj/item/reagent_containers/food/snacks/jellycake_base = 1,
	)
	starting_atom = /obj/item/reagent_containers/food/snacks/apple_dried
	output = /obj/item/reagent_containers/food/snacks/jellycake_apple
	crafting_message = "mix dried apple into the gelatine"

/datum/repeatable_crafting_recipe/cooking/jellycake/tangerine
	name = "Tangerine Jellycake"

	requirements = list(
		/obj/item/reagent_containers/food/snacks/produce/fruit/tangerine = 1,
		/obj/item/reagent_containers/food/snacks/jellycake_base = 1,
	)
	starting_atom = /obj/item/reagent_containers/food/snacks/produce/fruit/tangerine
	output = /obj/item/reagent_containers/food/snacks/jellycake_tangerine
	crafting_message = "mix tangerine into the gelatine"

/datum/repeatable_crafting_recipe/cooking/jellycake/dried_tangerine
	name = "Dried Tangerine Jellycake"

	requirements = list(
		/obj/item/reagent_containers/food/snacks/tangerine_dried = 1,
		/obj/item/reagent_containers/food/snacks/jellycake_base = 1,
	)
	starting_atom = /obj/item/reagent_containers/food/snacks/tangerine_dried
	output = /obj/item/reagent_containers/food/snacks/jellycake_tangerine
	crafting_message = "mix dried tangerine into the gelatine"

/datum/repeatable_crafting_recipe/cooking/jellycake/plum
	name = "Plum Jellycake"

	requirements = list(
		/obj/item/reagent_containers/food/snacks/produce/fruit/plum = 1,
		/obj/item/reagent_containers/food/snacks/jellycake_base = 1,
	)
	starting_atom = /obj/item/reagent_containers/food/snacks/produce/fruit/plum
	output = /obj/item/reagent_containers/food/snacks/jellycake_plum
	crafting_message = "mix plum into the gelatine"

/datum/repeatable_crafting_recipe/cooking/jellycake/dried_plum
	name = "Dried Plum Jellycake"

	requirements = list(
		/obj/item/reagent_containers/food/snacks/plum_dried = 1,
		/obj/item/reagent_containers/food/snacks/jellycake_base = 1,
	)
	starting_atom = /obj/item/reagent_containers/food/snacks/plum_dried
	output = /obj/item/reagent_containers/food/snacks/jellycake_plum
	crafting_message = "mix dried plum into the gelatine"

/datum/repeatable_crafting_recipe/cooking/jellycake/pear
	name = "Pear Jellycake"

	requirements = list(
		/obj/item/reagent_containers/food/snacks/produce/fruit/pear = 1,
		/obj/item/reagent_containers/food/snacks/jellycake_base = 1,
	)
	starting_atom = /obj/item/reagent_containers/food/snacks/produce/fruit/pear
	output = /obj/item/reagent_containers/food/snacks/jellycake_pear
	crafting_message = "mix pear into the gelatine"

/datum/repeatable_crafting_recipe/cooking/jellycake/dried_pear
	name = "Dried Pear Jellycake"

	requirements = list(
		/obj/item/reagent_containers/food/snacks/pear_dried = 1,
		/obj/item/reagent_containers/food/snacks/jellycake_base = 1,
	)
	starting_atom = /obj/item/reagent_containers/food/snacks/pear_dried
	output = /obj/item/reagent_containers/food/snacks/jellycake_pear
	crafting_message = "mix dried pear into the gelatine"

/datum/repeatable_crafting_recipe/cooking/jellycake/lime
	name = "Lime Jellycake"

	requirements = list(
		/obj/item/reagent_containers/food/snacks/produce/fruit/lime = 1,
		/obj/item/reagent_containers/food/snacks/jellycake_base = 1,
	)
	starting_atom = /obj/item/reagent_containers/food/snacks/produce/fruit/lime
	output = /obj/item/reagent_containers/food/snacks/jellycake_lime
	crafting_message = "mix lime into the gelatine"
