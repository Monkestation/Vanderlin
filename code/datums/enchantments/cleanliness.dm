/datum/enchantment/eternal_clean
	enchantment_name = "Eternal Cleanliness"
	examine_text = "This item seems to be in a constant state of scrubbing."

	should_process = TRUE
	essence_recipe = list(
		/datum/thaumaturgical_essence/water = 35,
		/datum/thaumaturgical_essence/cycle = 25
	)

/datum/enchantment/eternal_clean/process()
	if(!enchanted_item)
		STOP_PROCESSING(SSenchantment, src)
		return
	enchanted_item?.wash(CLEAN_SCRUB)
