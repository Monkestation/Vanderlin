/datum/action/cooldown/spell/undirected/bloodrage
	name = "Bloodrage"
	desc = "Grants you unbound strength for a short while."
	button_icon_state = "bloodrage"
	sound = 'sound/magic/bloodrage.ogg'

	has_visual_effects = FALSE
	spell_type = SPELL_MIRACLE
	antimagic_flags = MAGIC_RESISTANCE_HOLY
	associated_skill = /datum/skill/magic/holy
	invocation = "GRAGGAR!! GRAGGAR!! GRAGGAR!!"
	invocation_type = INVOCATION_SHOUT
	charge_required = FALSE
	cooldown_time = 5 MINUTES
	spell_cost = 80
	var/static/list/purged_effects = list(
		/datum/status_effect/incapacitating/immobilized,
		/datum/status_effect/incapacitating/paralyzed,
		/datum/status_effect/incapacitating/stun,
		/datum/status_effect/incapacitating/knockdown,
	)

/datum/action/cooldown/spell/undirected/bloodrage/is_valid_target(atom/cast_on)
	. = ..()
	if(!.)
		return
	return isliving(cast_on)

/datum/action/cooldown/spell/undirected/bloodrage/before_cast(mob/living/cast_on)
	. = ..()
	if(. & SPELL_CANCEL_CAST)
		return

	if(cast_on.buckled)
		cast_on.buckled.unbuckle_mob(cast_on)

/datum/action/cooldown/spell/undirected/bloodrage/cast(mob/living/cast_on)
	. = ..()
	if(cast_on.resting)
		cast_on.set_resting(FALSE, FALSE)
	cast_on.emote("rage", forced = TRUE)
	for(var/effect in purged_effects)
		cast_on.remove_status_effect(effect)
	cast_on.apply_status_effect(/datum/status_effect/buff/bloodrage)
	cast_on.visible_message(span_danger("[cast_on] rises upward, boiling with immense rage!"))

