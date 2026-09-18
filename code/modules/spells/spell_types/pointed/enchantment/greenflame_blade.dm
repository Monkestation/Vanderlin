/datum/action/cooldown/spell/enchantment/green_flame
	name = "Green-Flame Blade"
	desc = "Enchant a weapon with searing flames."
	button_icon_state = "enchant_weapon"

	charge_required = FALSE
	spell_cost = 30
	spell_flags = SPELL_RITUOS
	enchantment = SEARING_BLADE_ENCHANT

	required_form = FORM_FIRE


/datum/action/cooldown/spell/enchantment/green_flame/crimson_blade
	name = "Imbue Fire"
	spell_type = SPELL_STAMINA
	spell_flags = SPELL_UNETCHABLE
	required_form = null
	associated_skill = /datum/attribute/skill/misc/athletics
