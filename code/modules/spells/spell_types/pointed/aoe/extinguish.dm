/datum/action/cooldown/spell/aoe/extinguish
	name = "Extinguish Flames"
	desc = "Extinguish any flames around you."
	button_icon_state = "light"
	sound = 'sound/magic/soulsteal.ogg'
	spell_type = SPELL_MANA
	antimagic_flags = MAGIC_RESISTANCE
	associated_skill = /datum/attribute/skill/magic/arcane/water
	invocation = "Adurna risa!"
	invocation_type = INVOCATION_SHOUT
	charge_required = TRUE
	charge_time = 5 SECONDS
	cooldown_time = 45 SECONDS
	spell_cost = 20
	aoe_radius = 4
	required_form = FORM_WATER
	required_technique = TECHNIQUE_ALTERATION

/datum/action/cooldown/spell/aoe/extinguish/is_valid_target(atom/cast_on)
	return isatom(cast_on)

/datum/action/cooldown/spell/aoe/extinguish/before_cast(atom/cast_on)
	. = ..()
	if(. & SPELL_CANCEL_CAST)
		return
	aoe_radius = initial(aoe_radius) + GET_MOB_SKILL_VALUE_OLD(owner, associated_skill)

/datum/action/cooldown/spell/aoe/extinguish/cast_on_thing_in_aoe(atom/victim, atom/caster)
	if(ismob(victim))
		var/mob/living/carbon/M = victim
		M.ExtinguishMob()
	else
		victim.extinguish()
