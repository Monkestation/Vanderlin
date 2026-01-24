
/datum/repeatable_crafting_recipe/cooking/soap
	name = "soap"
	tool_usage = list(
		/obj/item/pestle = list("starts to grind materials in the mortar", "start to grind materials in the mortar", 'sound/foley/mortarpestle.ogg'),
	)

	reagent_requirements = list(
		/datum/reagent/water = 10,
	)
	requirements = list(
		/obj/item/fertilizer/ash = 1,
		/obj/item/reagent_containers/food/snacks/fat = 1,
	)
	output = /obj/item/soap
	starting_atom = /obj/item/pestle
	attacked_atom = /obj/item/reagent_containers/glass/mortar
	tool_use_time = 4 SECONDS
	craft_time = 6 SECONDS

/datum/repeatable_crafting_recipe/cooking/soap/bath
	name = "herbal soap "
	tool_usage = list(
		/obj/item/pestle = list("starts to grind materials in the mortar", "start to grind materials in the mortar", 'sound/foley/mortarpestle.ogg'),
	)

	requirements = list(
		/obj/item/fertilizer/ash = 1,
		/obj/item/reagent_containers/food/snacks/fat = 1,
		/obj/item/alch/herb/mentha = 1,
	)
	output = /obj/item/soap/bath

/datum/repeatable_crafting_recipe/cooking/apple_fritter_raw
	name = "Raw Apple Fritter"

	requirements = list(
		/obj/item/reagent_containers/food/snacks/produce/fruit/apple = 1,
		/obj/item/reagent_containers/food/snacks/butterdough_slice = 1,
	)
	attacked_atom = /obj/item/reagent_containers/food/snacks/butterdough_slice
	starting_atom = /obj/item/reagent_containers/food/snacks/produce/fruit/apple
	output = /obj/item/reagent_containers/food/snacks/foodbase/fritter_raw
	required_table = TRUE
	craft_time = 6 SECONDS
	crafting_sound = 'sound/foley/dropsound/food_drop.ogg'
	crafting_message = "add apple bits to the dough"
	extra_chance = 100

/datum/repeatable_crafting_recipe/cooking/apple_fritter_raw/create_outputs(list/to_delete, mob/user)
	var/output_path = output
	if(user.get_skill_level(/datum/skill/craft/cooking) >= 2)
		output_path =  /obj/item/reagent_containers/food/snacks/foodbase/fritter_raw/good
	var/list/outputs = list()

	for(var/spawn_count = 1 to output_amount)
		var/obj/item/new_item = new output_path(get_turf(user))

		new_item.sellprice = sellprice
		new_item.randomize_price()

		if(length(pass_types_in_end))
			var/list/parts = list()
			for(var/obj/item/listed as anything in to_delete)
				if(!is_type_in_list(listed, pass_types_in_end))
					continue
				parts += listed
			new_item.CheckParts(parts)

		new_item.OnCrafted(user.dir, user)

		outputs += new_item

	return outputs

/datum/repeatable_crafting_recipe/cooking/beef_mett
	name = "Grenzel Mett"

	requirements = list(
		/obj/item/reagent_containers/food/snacks/veg/onion_sliced = 1,
		/obj/item/reagent_containers/food/snacks/meat/mince/beef = 1,
	)
	required_table = TRUE
	subtypes_allowed = FALSE
	attacked_atom = /obj/item/reagent_containers/food/snacks/meat/mince/beef
	starting_atom = /obj/item/reagent_containers/food/snacks/veg/onion_sliced
	allow_inverse_start = TRUE
	output = /obj/item/reagent_containers/food/snacks/meat/mince/beef/mett
	craft_time = 5 SECONDS
	crafting_sound = 'sound/foley/kneading_alt.ogg'
	crafting_message = "knead onions into the mince"
	extra_chance = 100

/datum/repeatable_crafting_recipe/cooking/raw_sausage
	name = "Fatty Raw Sausage"

	requirements = list(
		/obj/item/reagent_containers/food/snacks/fat = 1,
		/obj/item/reagent_containers/food/snacks/meat/mince = 1,
	)
	subtypes_allowed = TRUE
	required_table = TRUE
	attacked_atom = /obj/item/reagent_containers/food/snacks/meat/mince
	starting_atom = /obj/item/reagent_containers/food/snacks/fat
	allow_inverse_start = TRUE
	output = /obj/item/reagent_containers/food/snacks/meat/sausage
	craft_time = 9 SECONDS
	crafting_sound = 'sound/foley/dropsound/food_drop.ogg'
	crafting_message = "stuff a wiener"
	extra_chance = 100

/datum/repeatable_crafting_recipe/cooking/raw_sausage_alt
	name = "Lean Raw Sausage"

	requirements = list(
		/obj/item/reagent_containers/food/snacks/meat/mince = 2,
	)
	subtypes_allowed = TRUE
	required_table = TRUE
	attacked_atom = /obj/item/reagent_containers/food/snacks/meat/mince
	starting_atom = /obj/item/reagent_containers/food/snacks/meat/mince
	output = /obj/item/reagent_containers/food/snacks/meat/sausage
	craft_time = 9 SECONDS
	crafting_sound = 'sound/foley/dropsound/food_drop.ogg'
	crafting_message = "stuff a wiener"
	extra_chance = 100

/datum/repeatable_crafting_recipe/cooking/pestranstick
	name = "Pestran Stick"

	requirements = list(
		/obj/item/reagent_containers/food/snacks/butterslice = 1,
		/obj/item/grown/log/tree/stick = 1,
	)
	required_table = TRUE
	attacked_atom = /obj/item/reagent_containers/food/snacks/butterslice
	starting_atom = /obj/item/grown/log/tree/stick
	output = /obj/item/reagent_containers/food/snacks/pestranstick
	craft_time = 5 SECONDS
	crafting_sound = 'sound/foley/dropsound/food_drop.ogg'
	crafting_message = "skewer the butter"
	extra_chance = 100

/datum/repeatable_crafting_recipe/cooking/twoegg
	name = "Twin Eggs"

	requirements = list(
		/obj/item/reagent_containers/food/snacks/cooked/egg = 2,
	)
	required_table = TRUE
	attacked_atom = /obj/item/reagent_containers/food/snacks/cooked/egg
	starting_atom = /obj/item/reagent_containers/food/snacks/cooked/egg
	output = /obj/item/reagent_containers/food/snacks/cooked/twin_egg
	craft_time = 5 SECONDS
	crafting_sound = 'sound/foley/dropsound/food_drop.ogg'
	extra_chance = 100

/datum/repeatable_crafting_recipe/cooking/valorian_omlette
	name = "Valorian Omlette"

	requirements = list(
		/obj/item/reagent_containers/food/snacks/cooked/twin_egg = 1,
		/obj/item/reagent_containers/food/snacks/cheese_wedge = 1,
	)
	required_table = TRUE
	attacked_atom = /obj/item/reagent_containers/food/snacks/cooked/twin_egg
	starting_atom = /obj/item/reagent_containers/food/snacks/cheese_wedge
	allow_inverse_start = TRUE
	output = /obj/item/reagent_containers/food/snacks/cooked/valorian_omlette
	craft_time = 5 SECONDS
	crafting_sound = 'sound/foley/dropsound/food_drop.ogg'
	extra_chance = 100

/datum/repeatable_crafting_recipe/cooking/royal_truffle
	name = "Royal Truffles"

	requirements = list(
		/obj/item/reagent_containers/food/snacks/cooked/ham = 1,
		/obj/item/reagent_containers/food/snacks/cooked/truffle = 1,
	)
	required_table = TRUE
	attacked_atom = /obj/item/reagent_containers/food/snacks/cooked/ham
	starting_atom = /obj/item/reagent_containers/food/snacks/cooked/truffle
	allow_inverse_start = TRUE
	output = /obj/item/reagent_containers/food/snacks/cooked/royal_truffle
	craft_time = 2 SECONDS
	crafting_sound = 'sound/foley/dropsound/food_drop.ogg'
	extra_chance = 100

/datum/repeatable_crafting_recipe/cooking/royal_truffle_toxic
	hides_from_books = TRUE
	name = "Royal Truffles"

	requirements = list(
		/obj/item/reagent_containers/food/snacks/cooked/ham = 1,
		/obj/item/reagent_containers/food/snacks/cooked/truffle_toxic = 1,
	)
	required_table = TRUE
	attacked_atom = /obj/item/reagent_containers/food/snacks/cooked/ham
	starting_atom = /obj/item/reagent_containers/food/snacks/cooked/truffle_toxic
	allow_inverse_start = TRUE
	output = /obj/item/reagent_containers/food/snacks/cooked/royal_truffle/toxin
	craft_time = 2 SECONDS
	crafting_sound = 'sound/foley/dropsound/food_drop.ogg'
	extra_chance = 100

/datum/repeatable_crafting_recipe/cooking/herbs
	name = "herbs and spices"
	tool_usage = list(
		/obj/item/pestle = list("starts to grind and mix herbs in the mortar", "start to grind and mix herbs in the mortar", 'sound/foley/mortarpestle.ogg'),
	)
	requirements = list(
		/obj/item/alch/herb = 4,
	)
	subtypes_allowed = TRUE
	output = /obj/item/reagent_containers/powder/herbs
	output_amount = 3
	starting_atom = /obj/item/pestle
	attacked_atom = /obj/item/reagent_containers/glass/mortar

/datum/repeatable_crafting_recipe/cooking/saltedseeds
	name = "Salted Seeds"

	requirements = list(
		/obj/item/reagent_containers/food/snacks/roastseeds = 3,
		/obj/item/reagent_containers/powder/salt = 1,
	)
	required_table = TRUE
	attacked_atom = /obj/item/reagent_containers/powder/salt
	starting_atom = /obj/item/reagent_containers/food/snacks/roastseeds
	output = /obj/item/reagent_containers/food/snacks/roastseeds
	output_amount = 3
	craft_time = 8 SECONDS
	crafting_sound = 'sound/foley/dropsound/food_drop.ogg'
	crafting_message = "mix the salt and seeds"
	extra_chance = 100

// Redtallow can be crafted using visceras (rendered from animal sinew)
/datum/repeatable_crafting_recipe/tallow/red
	name = "red tallow"

	requirements = list(
		/obj/item/alch/viscera = 1,
		/obj/item/reagent_containers/food/snacks/tallow = 1,
	)

	starting_atom = /obj/item/alch/viscera
	attacked_atom = /obj/item/reagent_containers/food/snacks/tallow
	output = /obj/item/reagent_containers/food/snacks/tallow/red
	craft_time = 1 SECONDS
	subtypes_allowed = TRUE
