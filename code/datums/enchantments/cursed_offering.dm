/datum/enchantment/cursed_offering
	enchantment_name = "Cursed Offering"
	examine_text = "This smells divine, I am tempted to eat it."

	essence_recipe = list(
		/datum/thaumaturgical_essence/poison = 10,
		/datum/thaumaturgical_essence/death = 10,
	)
	required_type = list(
		/obj/item/natural/stone,
		/obj/item/reagent_containers/food,
		/obj/item/coin
	)

/datum/enchantment/cursed_offering/register_triggers(atom/item)
	. = ..()
	registered_signals += COMSIG_ITEM_EATEN
	RegisterSignal(item, COMSIG_ITEM_EATEN, PROC_REF(on_eat))

/datum/enchantment/cursed_offering/proc/on_eat(obj/item/source, mob/living/eater)
	if(!eater)
		return
	to_chat(eater, span_boldwarning("I feel death coming."))
	eater.reagents.add_reagent(/datum/reagent/toxin/fentanyl, 12)
