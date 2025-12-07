/datum/action/cooldown/spell/undirected/barbrage
	name = "Rage"
	desc = "Enter a state of martial fervor, increasing offensive capabilities at the cost of making yourself vulnerable."
	button_icon_state = "bcry"
	sound = 'sound/magic/barbroar.ogg'

	antimagic_flags = NONE

	associated_skill = /datum/skill/combat/unarmed
	associated_stat = STATKEY_STR

	charge_required = FALSE
	has_visual_effects = FALSE
	cooldown_time = 1 MINUTES
	spell_type = SPELL_STAMINA
	spell_cost = 10

/datum/action/cooldown/spell/undirected/barbrage/is_valid_target(atom/cast_on)
	. = ..()
	if(!.)
		return
	return isliving(owner)

/datum/action/cooldown/spell/undirected/barbrage/cast(mob/living/cast_on)
	. = ..()
	cast_on.emote("rage", forced = TRUE)
	cast_on.apply_status_effect(/datum/status_effect/buff/barbrage)
