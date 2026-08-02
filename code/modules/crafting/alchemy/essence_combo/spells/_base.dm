/datum/essence_combo/spell
	abstract_type = /datum/essence_combo/spell
	/// Spell type paths to grant when this combo is active.
	var/list/granted_spells = list()

/datum/essence_combo/spell/validate()
	ASSERT(length(granted_spells) > 0)

/datum/essence_combo/spell/apply(obj/item/clothing/gloves/essence_gauntlet/gauntlet, mob/living/user)
	for(var/spell_type in granted_spells)
		var/datum/action/cooldown/spell/spell = new spell_type()
		spell.spell_type = SPELL_ESSENCE
		spell.link_to(gauntlet)
		spell.Grant(user)
