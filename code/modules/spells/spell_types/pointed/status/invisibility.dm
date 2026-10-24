/datum/action/cooldown/spell/status/invisibility
	name = "Noc's Invisibility"
	desc = "Hide the target from eyes, for a time."
	button_icon_state = "invisibility"
	sound = 'sound/misc/stings/generic.ogg'

	cast_range = 3
	spell_type = SPELL_DIVINE_MIRACLE
	antimagic_flags = MAGIC_RESISTANCE_HOLY
	spell_flags = SPELL_DEVIL_BLOCKED
	associated_skill = /datum/attribute/skill/magic/holy
	required_items = list(/obj/item/clothing/neck/psycross/silver/divine/noc)

	charge_required = FALSE
	cooldown_time = 2 MINUTES
	spell_cost = 60

	status_effect = /datum/status_effect/invisibility

/datum/action/cooldown/spell/status/invisibility/arcyne
	name = "Invisibility"
	spell_type = SPELL_MANA
	antimagic_flags = MAGIC_RESISTANCE
	required_items = list()

	required_form = FORM_ARCANE
	associated_skill = /datum/attribute/skill/magic/arcane/arcyne
	required_technique = TECHNIQUE_ILLUSION
	required_level = 4
	learnable = FALSE
