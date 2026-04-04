// Atropa Concentrate (deadly poison)
/datum/container_craft/cooking/herbal_tea/atropa_concentrate
	name = "Atropa Death Draught"
	created_reagent = /datum/reagent/poison/herbal/atropa_concentrate
	water_conversion = 1
	reagent_requirements = list(
		/datum/reagent/poison/herbal/weak_atropa = 20,
	)
	requirements = list(
		/obj/item/alch/herb/atropa = 2,
		/obj/item/alch/herb/matricaria = 1
	)
	output_amount = 20 // Small amount of concentrated poison
	crafting_time = 15 SECONDS
	finished_smell = /datum/pollutant/food/bitter
	complete_message = "The draught reeks of death and malice..."

// Swamp Miasma (area poison)
/datum/container_craft/cooking/herbal_tea/swamp_miasma
	name = "Swamp Miasma"
	created_reagent = /datum/reagent/poison/herbal/swamp_miasma
	water_conversion = 1
	requirements = list(
		/obj/item/alch/swampdust = 2,
		/obj/item/alch/herb/paris = 1
	)
	output_amount = 30
	crafting_time = 8 SECONDS
	finished_smell = /datum/pollutant/food/bitter
	complete_message = "Noxious vapors rise from the mixture..."


/datum/container_craft/cooking/herbal_tea/tranq
	name = "Liquid tranquility"
	created_reagent = /datum/reagent/poison/herbal/tranq
	water_conversion = 1
	reagent_requirements = list(
		/datum/reagent/medicine/herbal/valeriana_draught = 20,
	)
	requirements = list(
		/obj/item/alch/herb/paris = 1,
		/obj/item/alch/herb/valeriana = 1,
		/obj/item/alch/herb/mentha = 1
	)
	output_amount = 20 // Small amount of concentrated poison
	crafting_time = 15 SECONDS
	finished_smell = /datum/pollutant/food/bitter
	complete_message = "The draught reeks of death and malice..."

	/datum/container_craft/cooking/herbal_tea/acid
	name = "Flamekiss liqeur"
	created_reagent = /datum/reagent/poison/herbal/acid
	water_conversion = 1
	reagent_requirements = list(
		/datum/reagent/drowsbane = 10,
	)
	requirements = list(
		/obj/item/reagent_containers/food/snacks/produce/fyritius = 3,
	)
	output_amount = 20 // Small amount of concentrated poison
	crafting_time = 15 SECONDS
	finished_smell = /datum/pollutant/food/bitter
	complete_message = "The draught reeks of death and malice..."

