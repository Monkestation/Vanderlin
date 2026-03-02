/datum/action/cooldown/spell/enchantment/holy_flame
	name = "Imbue Holy Fire"
	desc = "Enchant a weapon with divine flames."
	button_icon_state = "enchant_weapon"

	enchantment_duration = 5 MINUTES
	attunements = list(
		/datum/attunement/fire = 0.3,
	)

	charge_required = FALSE
	spell_cost = 30
	spell_flags = SPELL_RITUOS
	enchantment = DIVINE_FIRE_ENCHANT
	spell_type = SPELL_MIRACLE
	associated_skill = /datum/skill/magic/holy
	required_items = list(/obj/item/clothing/neck/psycross/silver/divine)

/datum/action/cooldown/spell/enchantment/holy_flame/is_valid_target(atom/cast_on)
	var/obj/item/weapon/enchant_item
	if(istype(cast_on, /obj/item/weapon))
		enchant_item = cast_on
	else if(isliving(cast_on))
		var/mob/living/living_mob = cast_on
		var/obj/item/weapon/held = living_mob.get_active_held_item()
		if(istype(held))
			enchant_item = held

	if(!enchant_item)
		to_chat(owner, span_warning("There is nothing to enchant!"))
		return FALSE

	if(enchant_item.GetComponent(/datum/component/martyrweapon))
		to_chat(owner, span_warning("You cannot imbue such a powerful weapon with any more divine power!"))
		return FALSE

	return TRUE
