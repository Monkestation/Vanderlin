/datum/repeatable_crafting_recipe/bomb
	abstract_type = /datum/repeatable_crafting_recipe/bomb
	skillcraft = /datum/skill/craft/bombs
	craftdiff = 2
	category = "Bombs"

/datum/repeatable_crafting_recipe/bomb/homemade
	name = "homemade bottle bomb"

	requirements = list(
		/obj/item/natural/cloth = 1,
		/obj/item/reagent_containers/food/snacks/produce/fyritius = 1,
		/obj/item/reagent_containers/glass/bottle = 1,
	)
	reagent_requirements = list(
		/datum/reagent/consumable/ethanol = 10
	)

	starting_atom = /obj/item/natural/cloth
	attacked_atom = /obj/item/reagent_containers/glass/bottle
	output = /obj/item/explosive/bottle/homemade
	craft_time = 1 SECONDS
	subtypes_allowed = TRUE
	reagent_subtypes_allowed = TRUE

/datum/repeatable_crafting_recipe/bomb/smokebomb
	name = "smoke bomb"

	requirements = list(
		/obj/item/reagent_containers/food/snacks/produce/fyritius = 1,
		/obj/item/reagent_containers/glass/bottle = 1,
		/obj/item/fertilizer/ash = 2,
	)

	starting_atom = /obj/item/fertilizer/ash
	attacked_atom = /obj/item/reagent_containers/glass/bottle
	output = /obj/item/smokebomb
	craft_time = 1 SECONDS
	subtypes_allowed = TRUE

/datum/repeatable_crafting_recipe/bomb/poisonbomb
	name = "poison bomb"

	requirements = list(
		/obj/item/smokebomb = 1,
		/obj/item/alch/herb/atropa = 1,
		/obj/item/alch/herb/paris = 1,
	)

	starting_atom = /obj/item/alch/herb/atropa
	attacked_atom = /obj/item/smokebomb
	output = /obj/item/smokebomb/poison_bomb
	craft_time = 1 SECONDS
	craftdiff = 1
	subtypes_allowed = TRUE

/datum/repeatable_crafting_recipe/bomb/pipe_bomb
	name = "homemade pipe bomb"

	requirements = list(
		/obj/item/natural/fibers = 1,
		/obj/item/reagent_containers/powder/blastpowder = 2,
		/obj/item/reagent_containers/glass/bottle = 1,
	)

	starting_atom = /obj/item/natural/fibers
	attacked_atom = /obj/item/reagent_containers/glass/bottle
	output = /obj/item/explosive
	craft_time = 1 SECONDS
	subtypes_allowed = TRUE
	reagent_subtypes_allowed = TRUE

/datum/repeatable_crafting_recipe/bomb/canister_bomb
	name = "Canister Grenade"

	requirements = list(
		/obj/item/natural/fibers = 1,
		/obj/item/reagent_containers/powder/blastpowder = 2,
		/obj/item/ammo_casing/caseless/grenadeshell = 1,
		/obj/item/ammo_casing/caseless/bullet = 8,
	)

	starting_atom = /obj/item/natural/fibers
	attacked_atom = /obj/item/ammo_casing/caseless/grenadeshell
	output = /obj/item/explosive/canister_bomb
	craft_time = 11 SECONDS
	craftdiff = 4
	subtypes_allowed = TRUE
	reagent_subtypes_allowed = TRUE

/datum/repeatable_crafting_recipe/bomb/gunpowder
	name = "blastpowder"
	requirements = list(
		/obj/item/reagent_containers/food/snacks/badrecipe = 1,
		/obj/item/alch/coaldust = 1,
		/obj/item/alch/firedust = 1,
	)
	tool_usage = list(
		/obj/item/pestle = list(span_notice("starts to grind together"), span_notice("start to grind together"), 'sound/foley/mortarpestle.ogg'),
	)

	attacked_atom = /obj/item/reagent_containers/glass/mortar
	starting_atom = /obj/item/pestle
	output = /obj/item/reagent_containers/powder/blastpowder
	output_amount = 3
	craft_time = 5 SECONDS

/datum/repeatable_crafting_recipe/bomb/breaching_charge
	name = "breaching charge"
	requirements = list(
		/obj/item/reagent_containers/powder/blastpowder = 2,
		/obj/item/natural/fibers = 1,
		/obj/item/natural/cloth = 1,
	)

	attacked_atom = /obj/item/natural/cloth
	starting_atom = /obj/item/reagent_containers/powder/blastpowder
	output = /obj/item/breach_charge
	craft_time = 5 SECONDS
