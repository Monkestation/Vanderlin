/**
 * ### Enchantment spells
 *
 * Enchant an item or a mob's held item.
 *
 * Interfaces with [/datum/component/enchanted_weapon]
 */
/datum/action/cooldown/spell/enchantment
	cooldown_time = null

	/// Base duration
	var/enchantment_duration = 5 MINUTES
	/// Allows refreshing of enchantment
	var/allows_refresh = TRUE
	/// Enchantment type
	var/enchantment

/datum/action/cooldown/spell/enchantment/New(Target)
	. = ..()
	if(!enchantment)
		stack_trace("enchantment spell [type] created without enchantment")
		qdel(src)

/datum/action/cooldown/spell/enchantment/is_valid_target(atom/cast_on)
	. = ..()
	if(!.)
		return FALSE
	return istype(cast_on, /obj/item/weapon) || isliving(cast_on)

/datum/action/cooldown/spell/enchantment/cast(atom/cast_on)
	. = ..()
	var/obj/item/weapon/enchant_item
	var/mob/holder
	if(istype(cast_on, /obj/item/weapon))
		enchant_item = cast_on
	else if(isliving(cast_on))
		var/mob/living/L = cast_on
		var/obj/item/weapon/held = L.get_active_held_item()
		holder = cast_on
		if(istype(held))
			enchant_item = held
	if(!enchant_item)
		to_chat(owner, span_warning("There is nothing to enchant!"))
		return
	if(spell_type != SPELL_MIRACLE)
		enchantment_duration *= attuned_strength
	enchant_item.AddComponent(/datum/component/enchanted_weapon, enchantment_duration, allows_refresh, associated_skill, 1, enchantment, holder)
	cooldown_time = cooldown_time || enchantment_duration
