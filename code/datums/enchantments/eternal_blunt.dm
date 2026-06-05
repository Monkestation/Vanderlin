/datum/enchantment/eternal_blunt
	enchantment_name = "The Eternal Blunt"
	examine_text = "Fucked up and evil, your blunt will outlive your mortal flesh."

	should_process = TRUE
	essence_recipe = list(
		/datum/thaumaturgical_essence/life = 200,
		/datum/thaumaturgical_essence/cycle = 100
	)
	required_type = list(/obj/item/clothing/face/cigarette)
	var/list/initial_reagents = list()


/datum/enchantment/eternal_blunt/register_triggers(atom/item)
	. = ..()
	if(enchanted_item)
		for(var/datum/reagent/reagents as anything in enchanted_item.reagents.reagent_list)
			initial_reagents |= reagents.type
			initial_reagents[reagents.type] = reagents.volume

/datum/enchantment/eternal_blunt/process()
	if(!enchanted_item)
		STOP_PROCESSING(SSenchantment, src)
		return
	for(var/reagent_type in initial_reagents)
		var/target_volume = initial_reagents[reagent_type]
		var/datum/reagent/existing = enchanted_item.reagents.reagent_list[reagent_type]
		var/current_volume = existing ? existing.volume : 0
		var/deficit = target_volume - current_volume
		if(deficit > 0)
			enchanted_item.reagents.add_reagent(reagent_type, deficit)
