/datum/enchantment/mana_regeneration
	enchantment_name = "Mana Regeneration"
	examine_text = "Mana flows freely from this object."

	should_process = TRUE
	essence_recipe = list(
		/datum/thaumaturgical_essence/energia = 35,
		/datum/thaumaturgical_essence/cycle = 25
	)
	var/regeneration_rate = 2

/datum/enchantment/mana_regeneration/process()
	if(!enchanted_item)
		STOP_PROCESSING(SSenchantment, src)
		return
	if(!iscarbon(enchanted_item?.loc))
		return
	var/mob/living/carbon/mob = enchanted_item.loc
	mob.safe_adjust_personal_mana(regeneration_rate)
