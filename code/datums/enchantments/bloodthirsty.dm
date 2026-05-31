/datum/enchantment/bloodmend
	enchantment_name = "Bloodmending"
	examine_text = "You can feel an aura of hunger eminating from this."
	enchantment_color = "#830000"
	essence_recipe = list(
		/datum/thaumaturgical_essence/life = 20,
		/datum/thaumaturgical_essence/chaos = 10,
	)
	should_process = TRUE
	required_type = list(/obj/item/clothing)

/datum/enchantment/bloodmend/process(delta_time)
	if(!enchanted_item)
		STOP_PROCESSING(SSenchantment, src)
		return
	if(!iscarbon(enchanted_item?.loc))
		return
	if(enchanted_item.get_integrity() >= enchanted_item.max_integrity)
		return
	var/mob/living/carbon/carbon = enchanted_item.loc
	if(NOBLOOD in carbon.dna?.species.species_traits)
		return

	var/bleeding_bite = FALSE
	for(var/datum/injury/injury in carbon.all_injuries)
		if(injury.damage_type != WOUND_BITE)
			continue
		if(!injury.get_bleed_rate())
			continue
		bleeding_bite = TRUE
		break

	if(!bleeding_bite)
		var/obj/item/bodypart/bodypart
		var/obj/item/clothing/clothing = enchanted_item
		if(enchanted_item in carbon.get_active_held_items())
			if(enchanted_item == carbon.get_active_held_item())
				bodypart = carbon.get_active_hand()
			else
				bodypart = LAZYACCESS(carbon.hand_bodyparts, carbon.get_inactive_hand_index())
		else
			bodypart = carbon.get_bodypart(slot2body_zone(clothing.slot_flags))

		bodypart?.bodypart_attacked_by(BCLASS_BITE, 20, modifiers = list(CRIT_MOD_CHANCE = -100))

	var/missing_integrity = enchanted_item.max_integrity - enchanted_item.get_integrity()
	carbon.adjust_bloodvolume(-missing_integrity * 0.5)
	enchanted_item.update_integrity(enchanted_item.max_integrity)
	playsound(enchanted_item,'sound/items/weapons/bite.ogg', 45, TRUE, -1)
	to_chat(carbon, span_danger("[enchanted_item] gnaws at you!"))
