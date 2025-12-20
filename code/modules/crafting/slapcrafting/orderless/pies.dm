///this in theory should be better then the old system pies are funky as they don't create a new type at the end.
/datum/orderless_slapcraft/food/pie
	abstract_type = /datum/orderless_slapcraft/food/pie
	category = "Pies"

	finishing_item = /obj/item/reagent_containers/food/snacks/piedough
	starting_item = /obj/item/reagent_containers/food/snacks/foodbase/piebottom
	related_skill = /datum/skill/craft/cooking
	skill_xp_gained = 20
	action_time = 5 SECONDS

	var/overlay_state = ""
	var/fill_states = 3

/datum/orderless_slapcraft/food/pie/step_process(mob/user, obj/item/attacking_item)
	. = ..()
	hosted_source.name = "unfinished [name]"
	var/total_number = 0
	for(var/type in requirements)
		total_number |= requirements[type]

	hosted_source.cut_overlays()
	var/mutable_appearance/fill_state = mutable_appearance(hosted_source.icon, "[overlay_state][max(1, fill_states - total_number)]")
	hosted_source.add_overlay(fill_state)

/datum/orderless_slapcraft/food/pie/fish
	name = "Unbaked Fish Pie"
	requirements = list(
		/obj/item/reagent_containers/food/snacks/meat/mince/fish = 2,
		list(
			/obj/item/reagent_containers/food/snacks/meat/mince/fish,
			/obj/item/reagent_containers/food/snacks/veg/potato_sliced) = 1)
	overlay_state = "fill_fish"
	output_item = /obj/item/reagent_containers/food/snacks/raw_pie/fish

/datum/orderless_slapcraft/food/pie/pot
	name = "Unbaked Pot Pie"
	requirements = list(
		list(
			/obj/item/reagent_containers/food/snacks/cheese_wedge,
			/obj/item/reagent_containers/food/snacks/cheese,
			/obj/item/reagent_containers/food/snacks/butterslice,
			/obj/item/reagent_containers/food/snacks/egg) = 1,
		list(
			/obj/item/reagent_containers/food/snacks/veg/onion_sliced,
			/obj/item/reagent_containers/food/snacks/veg/potato_sliced,
			/obj/item/reagent_containers/food/snacks/veg/turnip_sliced,
			/obj/item/reagent_containers/food/snacks/veg/cabbage_sliced,
			/obj/item/reagent_containers/food/snacks/roastseeds) = 1,
		list(
			/obj/item/reagent_containers/food/snacks/meat/mince/poultry,
			/obj/item/reagent_containers/food/snacks/meat/mince/beef,
			/obj/item/reagent_containers/food/snacks/meat/mince/fish,
			/obj/item/reagent_containers/food/snacks/fat) = 1
	)
	overlay_state = "fill_pot"
	output_item = /obj/item/reagent_containers/food/snacks/raw_pie/pot_pie

/datum/orderless_slapcraft/food/pie/apple
	name = "Unbaked Apple Pie"
	requirements = list(
		/obj/item/reagent_containers/food/snacks/produce/fruit/apple = 3
	)
	overlay_state = "fill_apple"
	output_item = /obj/item/reagent_containers/food/snacks/raw_pie/apple

/datum/orderless_slapcraft/food/pie/pear
	name = "Unbaked Pear Pie"
	requirements = list(
		/obj/item/reagent_containers/food/snacks/produce/fruit/pear = 3
	)
	overlay_state = "fill_pear"
	output_item = /obj/item/reagent_containers/food/snacks/raw_pie/pear

/datum/orderless_slapcraft/food/pie/berry
	name = "Unbaked Berry Pie"
	requirements = list(
		list(
			/obj/item/reagent_containers/food/snacks/produce/fruit/jacksberry/poison,
			/obj/item/reagent_containers/food/snacks/produce/fruit/jacksberry) = 3
	)
	overlay_state = "fill_berry"
	output_item = /obj/item/reagent_containers/food/snacks/raw_pie/berry

/datum/orderless_slapcraft/food/pie/berry/step_process(mob/user, obj/item/attacking_item)
	. = ..()
	if(istype(attacking_item, /obj/item/reagent_containers/food/snacks/produce/fruit/jacksberry/poison))
		output_item = /obj/item/reagent_containers/food/snacks/raw_pie/berry/poison

/datum/orderless_slapcraft/food/pie/meat
	name = "Unbaked Meat Pie"
	requirements = list(
		/obj/item/reagent_containers/food/snacks/meat/mince/beef = 2,
		list(
			/obj/item/reagent_containers/food/snacks/meat/mince/beef,
			/obj/item/reagent_containers/food/snacks/egg) = 1)
	overlay_state = "fill_meat"
	output_item = /obj/item/reagent_containers/food/snacks/raw_pie/meat

/// Tarts
/datum/orderless_slapcraft/food/tart
	abstract_type = /datum/orderless_slapcraft/food/tart
	category = "Tarts"
	finishing_item = /obj/item/reagent_containers/food/snacks/sugar
	starting_item = /obj/item/reagent_containers/food/snacks/foodbase/tartcrust
	related_skill = /datum/skill/craft/cooking
	skill_xp_gained = 20
	action_time = 5 SECONDS
	var/overlay_state = ""
	var/fill_states = 3

/datum/orderless_slapcraft/food/tart/step_process(mob/user, obj/item/attacking_item)
	. = ..()
	hosted_source.name = "unfinished [name]"
	var/total_number = 0
	for(var/type in requirements)
		total_number |= requirements[type]

	hosted_source.cut_overlays()
	var/mutable_appearance/fill_state = mutable_appearance(hosted_source.icon, "[overlay_state][max(1, fill_states - total_number)]")
	hosted_source.add_overlay(fill_state)
	if(istype(hosted_source, /obj/item/reagent_containers/food/snacks/raw_tart))
		hosted_source.update_appearance(UPDATE_OVERLAYS)


/datum/orderless_slapcraft/food/tart/avocado
	name = "Unbaked Avocado Tart"
	requirements = list(
		/obj/item/reagent_containers/food/snacks/produce/fruit/avocado = 3
	)
	output_item = /obj/item/reagent_containers/food/snacks/raw_tart/avocado

/datum/orderless_slapcraft/food/tart/mango
	name = "Unbaked Mangga Tart"
	requirements = list(
		/obj/item/reagent_containers/food/snacks/produce/fruit/mango = 3
	)
	output_item = /obj/item/reagent_containers/food/snacks/raw_tart/mango

/datum/orderless_slapcraft/food/tart/mangosteen
	name = "Unbaked Mangosteen Tart"
	requirements = list(
		/obj/item/reagent_containers/food/snacks/produce/fruit/mangosteen = 3
	)
	output_item = /obj/item/reagent_containers/food/snacks/raw_tart/mangosteen

/datum/orderless_slapcraft/food/tart/pineapple
	name = "Unbaked Ananas Tart"
	requirements = list(
		/obj/item/reagent_containers/food/snacks/produce/fruit/pineapple = 1,
		/obj/item/reagent_containers/food/snacks/fruit/pineapple_slice = 2,
	)
	output_item = /obj/item/reagent_containers/food/snacks/raw_tart/pineapple

/datum/orderless_slapcraft/food/tart/dragonfruit
	name = "Unbaked Piyata Tart"
	requirements = list(
		/obj/item/reagent_containers/food/snacks/produce/fruit/dragonfruit = 3
	)
	output_item = /obj/item/reagent_containers/food/snacks/raw_tart/dragonfruit

/datum/orderless_slapcraft/food/pie/borowiki
	name = "unbaked borowiki pie"
	requirements = list(/obj/item/reagent_containers/food/snacks/produce/mushroom/borowiki = 3
		)
	overlay_state = "fill_pot"
	output_item = /obj/item/reagent_containers/food/snacks/raw_pie/borowiki
