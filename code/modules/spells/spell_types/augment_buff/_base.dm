/datum/action/cooldown/spell/augment_buff
	button_icon = 'icons/mob/actions/spells/mage_augmentation.dmi'
	sound = 'sound/magic/haste.ogg'

	click_to_activate = TRUE
	cast_range = SPELL_RANGE_GROUND
	self_cast_possible = TRUE

	spell_cost = 25
	required_technique = TECHNIQUE_ALTERATION

	invocation_type = INVOCATION_SHOUT
	invocation = "FIX ME!"

	charge_required = TRUE
	charge_time = CHARGETIME_MINOR
	charge_slowdown = CHARGING_SLOWDOWN_SMALL
	charge_sound = 'sound/magic/charging.ogg'
	cooldown_time = 90 SECONDS

	spell_impact_intensity = SPELL_IMPACT_NONE

	spell_requirements = SPELL_REQUIRES_NO_ANTIMAGIC | SPELL_REQUIRES_HUMAN | SPELL_REQUIRES_SAME_Z

	var/self_cast_cooldown_multiplier = 1
	var/other_cast_cooldown_reduction = 0.25
	/// TRUE only while resolving a self-targeted cast, so the cooldown hook knows to apply the penalty.
	var/tmp/empowering_self = FALSE

/datum/action/cooldown/spell/augment_buff/before_cast(atom/cast_on)
	empowering_self = (cast_on == owner)
	return ..()

/datum/action/cooldown/spell/augment_buff/after_cast(atom/cast_on)
	. = ..()
	var/used_multi = empowering_self ? self_cast_cooldown_multiplier : 1 - other_cast_cooldown_reduction
	StartCooldown(cooldown_time * used_multi)
	empowering_self = FALSE
