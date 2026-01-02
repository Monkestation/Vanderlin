/datum/action/cooldown/spell/undirected/tragedy
	name = "Tragedia"
	desc = "Remind someone in low spirits that it could be much worse."
	button_icon_state = "tragedy"
	has_visual_effects = FALSE
	antimagic_flags = NONE

	invocation_type = INVOCATION_SHOUT
	invocation = "Death will be laughing in the end."

	spell_type = NONE
	associated_skill = null
	associated_stat = STATKEY_INT

	charge_required = FALSE
	sound = null

	charge_required = FALSE
	cooldown_time = 1 MINUTES
	var/message

/datum/action/cooldown/spell/undirected/tragedy/before_cast(atom/cast_on)
	. = ..()
	if(. & SPELL_CANCEL_CAST)
		return
	message = browser_input_text(owner, "Say something sad!", "XLYIX")
	if(QDELETED(src) || QDELETED(cast_on) || !can_cast_spell())
		return . | SPELL_CANCEL_CAST
	if(!message)
		reset_cooldown()
		return . | SPELL_CANCEL_CAST

	invocation = message

/datum/action/cooldown/spell/undirected/tragedy/cast(atom/cast_on)
	. = ..()
	for(var/mob/living/carbon/C in get_hearers_in_view(DEFAULT_MESSAGE_RANGE, owner) - owner)
		if(C.stat > CONSCIOUS)
			continue
		if(C.stress < STRESS_NEUTRAL)
			continue
		addtimer(CALLBACK(src, PROC_REF(reaction), C), rand(2 SECONDS, 2.5 SECONDS))

/datum/action/cooldown/spell/undirected/tragedy/proc/reaction(mob/living/carbon/cast_on)
	cast_on.add_stress(/datum/stress_event/tragedy)
	cast_on.emote(pick("sigh", "hmm", "cry"), forced = TRUE)
