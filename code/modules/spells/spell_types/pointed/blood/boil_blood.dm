/datum/action/cooldown/spell/boil_blood
	name = "Boil Blood"
	desc = "Boil the blood of the target, damage modified by blood volume."
	button_icon_state = "presence"
	sound = 'sound/magic/enter_blood.ogg'

	associated_skill = /datum/attribute/skill/magic/blood
	spell_type = SPELL_BLOOD
	required_form = FORM_BLOOD
	required_technique = TECHNIQUE_DESTRUCTION
	heretical_spell = TRUE
	antimagic_flags = MAGIC_RESISTANCE_BLOOD

	invocation_type = INVOCATION_SHOUT
	invocation = "Caedis ferveo!!"
	self_cast_possible = FALSE

	charge_time = 2 SECONDS
	cooldown_time = 1 MINUTES
	spell_cost = 100
	/// Min constitution to resist spell.
	var/constitution_level = 13
	var/base_damage_full = 25
	var/base_damage_resisted = 7.5

/datum/action/cooldown/spell/boil_blood/is_valid_target(atom/cast_on)
	. = ..()
	if(!.)
		return FALSE
	if(!isliving(cast_on))
		return FALSE
	var/mob/living/target = cast_on
	return target.get_blood_volume()

/datum/action/cooldown/spell/boil_blood/cast(mob/living/cast_on)
	. = ..()
	/// Any blood volume over 600 (50%) will result in full damage.
	var/blood_multiplier = cast_on.get_blood_volume() / 200
	var/damage_value_full = min(base_damage_full * blood_multiplier, 75)
	var/damage_value_resisted = min(base_damage_resisted * blood_multiplier, 22.5)
	if(GET_MOB_ATTRIBUTE_VALUE(cast_on, STAT_CONSTITUTION) >= constitution_level)
		cast_on.adjustFireLoss(damage_value_resisted)
		to_chat(cast_on, span_userdanger("Your blood reacts to hostile powers, but your constitution resists!"))
	else
		cast_on.adjustFireLoss(damage_value_full)
		to_chat(cast_on, span_userdanger("Your blood reacts to hostile powers, it feels like its boiling!"))
