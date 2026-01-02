/datum/action/cooldown/spell/silence_inhumen
	name = "Silence Inhumen"
	button_icon_state = "bcry"
	sound = null
	self_cast_possible = FALSE
	has_visual_effects = FALSE

	invocation = "SILENCE, INHUMEN!"
	invocation_type = INVOCATION_SHOUT

	antimagic_flags = NONE
	charge_required = FALSE
	cooldown_time = 45 SECONDS

/datum/action/cooldown/spell/silence_inhumen/is_valid_target(atom/cast_on)
	. = ..()
	if(!.)
		return FALSE
	return ishuman(cast_on)

/datum/action/cooldown/spell/silence_inhumen/before_cast(mob/living/carbon/human/cast_on)
	. = ..()
	if(. & SPELL_CANCEL_CAST)
		return

	if(cast_on.dna?.species.id in RACES_PLAYER_NONHERETICAL)
		to_chat(owner, span_warning("[cast_on] is not a profane inhumen!"))
		reset_spell_cooldown()
		return . | SPELL_CANCEL_CAST

/datum/action/cooldown/spell/silence_inhumen/cast(mob/living/carbon/human/cast_on)
	. = ..()

	playsound(owner, 'sound/magic/invoke_general.ogg', 25, TRUE)
	cast_on.face_atom(owner)
	cast_on.do_alert_effect()
	if(prob(50))
		cast_on.emote("gasp")
	cast_on.set_silence(15 SECONDS)
