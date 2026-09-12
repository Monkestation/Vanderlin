/datum/action/cooldown/spell/empower_weapon
	name = "Empower Weapon"
	desc = "Channel all accumulated momentum into your next strike, empowering it to bypass parry and dodge. Works with both weapons and unarmed attacks. \
		Requires 5+ momentum. Burns ALL momentum."
	button_icon = 'icons/mob/actions/spells/spellblade.dmi'
	button_icon_state = "empower_weapon"
	sound = 'sound/magic/antimagic.ogg'

	required_form = FORM_ARCANE
	required_technique = TECHNIQUE_IMBUE

	spell_cost = 0

	invocation = null
	invocation_type = INVOCATION_NONE

	charge_required = FALSE
	cooldown_time = 30 SECONDS

	spell_impact_intensity = SPELL_IMPACT_NONE
	spell_requirements = SPELL_REQUIRES_NO_ANTIMAGIC | SPELL_REQUIRES_HUMAN | SPELL_REQUIRES_SAME_Z

	var/min_momentum = 5

/datum/action/cooldown/spell/empower_weapon/can_cast_spell(feedback = TRUE)
	. = ..()
	if(!.)
		return FALSE
	if(!ishuman(owner))
		return FALSE
	var/mob/living/carbon/human/H = owner
	var/datum/status_effect/buff/arcyne_momentum/M = H.has_status_effect(/datum/status_effect/buff/arcyne_momentum)
	if(!M || M.stacks < min_momentum)
		return FALSE
	return TRUE

/datum/action/cooldown/spell/empower_weapon/cast(atom/cast_on)
	. = ..()
	var/mob/living/carbon/human/H = owner
	if(!istype(H))
		return FALSE

	var/datum/status_effect/buff/arcyne_momentum/M = H.has_status_effect(/datum/status_effect/buff/arcyne_momentum)
	if(!M || M.stacks < min_momentum)
		to_chat(H, span_warning("I need at least [min_momentum] momentum to empower my weapon!"))
		return FALSE

	if(H.has_status_effect(/datum/status_effect/buff/empowered_strike))
		to_chat(H, span_warning("My weapon is already empowered!"))
		return FALSE

	var/stacks_burned = M.stacks
	M.consume_stacks(stacks_burned)

	H.apply_status_effect(/datum/status_effect/buff/empowered_strike)
	playsound(get_turf(H), 'sound/magic/antimagic.ogg', 60, TRUE)
	H.visible_message(
		span_danger("[H]'s weapon flares with a violent red glow!"),
		span_notice("I channel [stacks_burned] momentum into my weapon. The next strike will not be denied."))

	return TRUE

