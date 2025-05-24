
/datum/repeatable_crafting_recipe/cooking/biscuit_berry
	name = "Unbaked Raisan Biscuit"

	requirements = list(
		/obj/item/reagent_containers/food/snacks/raisins = 1,
		/obj/item/reagent_containers/food/snacks/butterdough_slice = 1,
	)
	attacked_atom = /obj/item/reagent_containers/food/snacks/butterdough_slice
	starting_atom = /obj/item/reagent_containers/food/snacks/raisins
	output = /obj/item/reagent_containers/food/snacks/foodbase/biscuit_raw
	uses_attacked_atom = TRUE
	required_table = TRUE
	craft_time = 6 SECONDS
	crafting_sound = 'sound/foley/dropsound/food_drop.ogg'
	crafting_message = "Adding berries to the dough..."
	extra_chance = 100

/datum/repeatable_crafting_recipe/cooking/biscuit_berry/create_outputs(list/to_delete, mob/user)
	var/output_path = output
	if(user.get_skill_level(/datum/skill/craft/cooking) >= 2)
		output_path =  /obj/item/reagent_containers/food/snacks/foodbase/biscuit_raw/good
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


/datum/repeatable_crafting_recipe/cooking/cheesebun
	name = "Raw Gote Cheesebun"
	requirements = list(
		/obj/item/reagent_containers/food/snacks/dough_slice = 1,
		/obj/item/reagent_containers/food/snacks/cheese/gote = 1,
	)
	starting_atom = /obj/item/reagent_containers/food/snacks/cheese/gote
	attacked_atom = /obj/item/reagent_containers/food/snacks/dough_slice
	output = /obj/item/reagent_containers/food/snacks/foodbase/cheesebun_raw
	uses_attacked_atom = TRUE
	required_table = TRUE
	craft_time = 5 SECONDS
	crafting_sound = 'sound/foley/kneading_alt.ogg'
	crafting_message = "Adding fresh gote cheese..."
	extra_chance = 100

/datum/repeatable_crafting_recipe/cooking/cheesebun_wedge
	name = "Raw Wedge Cheesebun"
	requirements = list(
		/obj/item/reagent_containers/food/snacks/dough_slice = 1,
		/obj/item/reagent_containers/food/snacks/cheese_wedge = 1,
	)
	starting_atom = /obj/item/reagent_containers/food/snacks/cheese_wedge
	attacked_atom = /obj/item/reagent_containers/food/snacks/dough_slice
	output = /obj/item/reagent_containers/food/snacks/foodbase/cheesebun_raw
	uses_attacked_atom = TRUE
	required_table = TRUE
	craft_time = 5 SECONDS
	crafting_sound = 'sound/foley/kneading_alt.ogg'
	crafting_message = "Adding cheese..."
	extra_chance = 100

/datum/repeatable_crafting_recipe/cooking/cheesebun_fresh
	name = "Raw Fresh Cheesebun"
	requirements = list(
		/obj/item/reagent_containers/food/snacks/dough_slice = 1,
		/obj/item/reagent_containers/food/snacks/cheese = 1,
	)
	starting_atom = /obj/item/reagent_containers/food/snacks/cheese
	attacked_atom = /obj/item/reagent_containers/food/snacks/dough_slice
	output = /obj/item/reagent_containers/food/snacks/foodbase/cheesebun_raw
	uses_attacked_atom = TRUE
	required_table = TRUE
	craft_time = 5 SECONDS
	crafting_sound = 'sound/foley/kneading_alt.ogg'
	crafting_message = "Adding fresh cheese..."
	extra_chance = 100


/datum/repeatable_crafting_recipe/cooking/grenzelbun
	name = "Grenzel Bun"

	requirements = list(
		/obj/item/reagent_containers/food/snacks/cooked/sausage = 1,
		/obj/item/reagent_containers/food/snacks/bun = 1,
	)
	attacked_atom = /obj/item/reagent_containers/food/snacks/bun
	starting_atom = /obj/item/reagent_containers/food/snacks/cooked/sausage
	output = /obj/item/reagent_containers/food/snacks/grenzelbun
	uses_attacked_atom = TRUE
	craft_time = 6 SECONDS
	crafting_sound = 'sound/foley/dropsound/gen_drop.ogg'
	extra_chance = 100

/datum/repeatable_crafting_recipe/cooking/grenzelbun_alt
	hides_from_books = TRUE
	name = "Grenzel Bun"

	requirements = list(
		/obj/item/reagent_containers/food/snacks/cooked/sausage = 1,
		/obj/item/reagent_containers/food/snacks/bun = 1,
	)
	starting_atom = /obj/item/reagent_containers/food/snacks/bun
	attacked_atom  = /obj/item/reagent_containers/food/snacks/cooked/sausage
	output = /obj/item/reagent_containers/food/snacks/grenzelbun
	uses_attacked_atom = TRUE
	craft_time = 6 SECONDS
	crafting_sound = 'sound/foley/dropsound/gen_drop.ogg'
	extra_chance = 100
