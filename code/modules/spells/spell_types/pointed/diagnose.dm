/datum/action/cooldown/spell/diagnose
	name = "Secular Diagnosis"
	desc = "Check the wounds of the target."
	button_icon_state = "diagnose"
	sound = 'sound/magic/diagnose.ogg'
	has_visual_effects = FALSE

	cast_range = 2
	associated_skill = /datum/attribute/skill/misc/medicine
	charge_required = FALSE
	cooldown_time = 10 SECONDS
	spell_cost = 0

/datum/action/cooldown/spell/diagnose/is_valid_target(atom/cast_on)
	. = ..()
	if(!.)
		return FALSE
	return ishuman(cast_on)

/datum/action/cooldown/spell/diagnose/cast(mob/living/carbon/human/cast_on)
	. = ..()
	cast_on.check_for_injuries(owner, additional = TRUE)

/datum/action/cooldown/spell/diagnose/holy
	name = "Diagnosis"

	cast_range = 4
	spell_type = SPELL_MIRACLE
	antimagic_flags = MAGIC_RESISTANCE_HOLY
	associated_skill = /datum/attribute/skill/magic/holy

	cooldown_time = 5 SECONDS
	spell_cost = 5
