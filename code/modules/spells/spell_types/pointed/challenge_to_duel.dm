/datum/action/cooldown/spell/ravox_challenge
	name = "Challenge to Duel"
	button_icon_state = "call_to_arms"
	self_cast_possible = FALSE
	has_visual_effects = FALSE

	antimagic_flags = NONE
	charge_required = FALSE
	cooldown_time = 15 SECONDS

/datum/action/cooldown/spell/ravox_challenge/is_valid_target(atom/cast_on)
	. = ..()
	if(!.)
		return FALSE
	return ishuman(cast_on)

/datum/action/cooldown/spell/ravox_challenge/cast(mob/living/carbon/human/duelist)
	. = ..()

	var/challenge_message = "[owner] challenges you to an honor duel! Do you accept?"
	owner.visible_message(span_notice("[owner] challenges [duelist] to an honor duel!"), span_notice("You challenge [duelist] to a duel!"))
	var/answer = browser_alert(duelist, challenge_message, "Duel Challenge", DEFAULT_INPUT_CHOICES)
	if(QDELETED(src) || QDELETED(owner) || QDELETED(duelist))
		return FALSE
	if(answer != CHOICE_YES)
		to_chat(owner, span_warning("[duelist] has refused your challenge!"))
		duelist.visible_message(
			span_warning("[duelist] refuses [owner]'s duel challenge."),
			span_warning("You refuse [owner]'s challenge."),
		)
		return FALSE

	owner.visible_message(span_notice("[owner] and [duelist] prepare for an honor duel!"), span_notice("The duel begins!"))
	to_chat(owner, span_notice("The duel begins! Combat ends at unconsciousness or when a fighter yields (RMB on Combat Mode button)."))
	owner.playsound_local(owner, 'sound/magic/inspire_02.ogg', 100)

	to_chat(duelist, span_notice("The duel begins! Combat ends at unconsciousness or when a fighter yields (RMB on Combat Mode button)."))
	duelist.playsound_local(duelist, 'sound/magic/inspire_02.ogg', 100)

	new /datum/duel(owner, duelist, target)
