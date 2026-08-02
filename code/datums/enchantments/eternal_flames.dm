/datum/enchantment/eternal_flames
	enchantment_name = "Eternal Flames"
	examine_text = "This item seems to be in a constant superheated state."

	should_process = TRUE
	essence_recipe = list(
		/datum/thaumaturgical_essence/fire = 35,
		/datum/thaumaturgical_essence/cycle = 25
	)

/datum/enchantment/eternal_flames/process()
	if(!enchanted_item)
		STOP_PROCESSING(SSenchantment, src)
		return
	enchanted_item.reagents?.expose_temperature(900, 0.1)
	for(var/obj/item/item as anything in enchanted_item.contents)
		item.reagents?.expose_temperature(900, 0.1)
