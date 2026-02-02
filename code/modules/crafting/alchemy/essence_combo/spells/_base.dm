/datum/essence_combo/spell
	abstract_type = /datum/essence_combo/spell
	var/list/granted_spells = list() // List of spell type paths

/datum/essence_combo/spell/validate_combo()
	if(!length(granted_spells))
		stack_trace("Spell combo [type] has no granted spells!")

/datum/essence_combo/spell/apply_effects(obj/item/clothing/gloves/essence_gauntlet/gauntlet, mob/user)
	if(!isliving(user))
		return

	var/mob/living/living_user = user

	for(var/datum/action/spell_type as anything in granted_spells)
		var/datum/action/cooldown/spell/spell = new spell_type
		spell.spell_type = SPELL_ESSENCE
		spell.link_to(gauntlet)
		spell.Grant(living_user)

/datum/essence_combo/spell/remove_effects(obj/item/clothing/gloves/essence_gauntlet/gauntlet, mob/user)
	// Spell removal is handled by the gauntlet's remove_essence_spells proc
	return
