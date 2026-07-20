/datum/enchantment/pestra_gift
	enchantment_name = "Pestra's Blessing"
	examine_text = "A surgical implement worthy of Pestra."
	enchantment_color = "#036e23"
	essence_recipe = list(
		/datum/thaumaturgical_essence/life = 30,
		/datum/thaumaturgical_essence/death = 10
	)
	required_type = list(/obj/item/weapon/surgery)

/datum/enchantment/pestra_gift/register_triggers(atom/item)
	. = ..()
	registered_signals += COMSIG_ITEM_DROPPED
	RegisterSignal(item, COMSIG_ITEM_DROPPED, PROC_REF(on_drop))
	registered_signals += COMSIG_ITEM_PICKUP
	RegisterSignal(item, COMSIG_ITEM_PICKUP, PROC_REF(on_equipped))
	registered_signals += COMSIG_ITEM_NOW_ACTIVE
	RegisterSignal(item, COMSIG_ITEM_NOW_ACTIVE, PROC_REF(on_active))
	registered_signals += COMSIG_ITEM_NOLONGER_ACTIVE
	RegisterSignal(item, COMSIG_ITEM_NOLONGER_ACTIVE, PROC_REF(on_lose_active))

/datum/enchantment/pestra_gift/proc/on_equipped(obj/item/i, mob/living/user)
	if(i != user.get_active_held_item())
		return
	on_active(i, user)

/datum/enchantment/pestra_gift/proc/on_drop(obj/item/i, mob/living/user)
	on_lose_active(i, user)

/datum/enchantment/pestra_gift/proc/on_lose_active(obj/item/i, mob/living/user)
	user.attributes?.remove_attribute_modifier(/datum/attribute_modifier/pestra_gift)

/datum/enchantment/pestra_gift/proc/on_active(obj/item/i, mob/living/user)
	user.attributes?.add_attribute_modifier(/datum/attribute_modifier/pestra_gift)




