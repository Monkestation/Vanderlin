//We do a bit of trolling
/datum/enchantment/blessed_offering
	enchantment_name = "Blessed Offering"
	examine_text = "This smells divine, I am tempted to eat it."

	essence_recipe = list(
		/datum/thaumaturgical_essence/life = 30,
		/datum/thaumaturgical_essence/water = 30,
	)
	required_type = list(
		/obj/item/natural/stone,
		/obj/item/reagent_containers/food,
		/obj/item/coin
	)

/datum/enchantment/blessed_offering/register_triggers(atom/item)
	. = ..()
	registered_signals += COMSIG_ITEM_EATEN
	RegisterSignal(item, COMSIG_ITEM_EATEN, PROC_REF(on_eat))

/datum/enchantment/blessed_offering/proc/on_eat(obj/item/source, mob/living/eater)
	if(!eater)
		return
	to_chat(eater, span_boldwarning("I feel life flowing through me."))
	eater.reagents.add_reagent(/datum/reagent/medicine/atropine, 4)
	eater.reagents.add_reagent(/datum/reagent/soap, 4) //tastes like soap
	eater.reagents.add_reagent(/datum/reagent/adrenaline, 5)
	eater.reagents.add_reagent(/datum/reagent/medicine/healthpot, 3)
