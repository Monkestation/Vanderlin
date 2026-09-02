/datum/action/cooldown/spell/dark_whispers

	name = "Dark Whispers"
	desc = "Manipulate the blood of your target, conveying a message."
	button_icon_state = "encode_thought"
	sound = 'sound/magic/PSY.ogg'
	check_flags = AB_CHECK_CONSCIOUS

	associated_skill = /datum/attribute/skill/magic/blood
	spell_type = SPELL_BLOOD
	spell_flags = SPELL_UNETCHABLE
	required_form = FORM_BLOOD
	heretical_spell = TRUE
	antimagic_flags = MAGIC_RESISTANCE_BLOOD

	charge_required = FALSE
	cooldown_time = 10 SECONDS
	spell_cost = 0
	spell_flags = SPELL_UNETCHABLE
	var/message

/datum/action/cooldown/spell/dark_whispers/is_valid_target(atom/cast_on)
	. = ..()
	if(!.)
		return FALSE
	if(!isliving(cast_on))
		return FALSE
	var/mob/living/living_target = cast_on
	if(living_target.stat == DEAD || !living_target.mind)
		to_chat(owner, span_warning("You cannot speak to the dead or mindless."))
		return FALSE
	return TRUE

/datum/action/cooldown/spell/dark_whispers/before_cast(atom/cast_on)
	. = ..()
	if(. & SPELL_CANCEL_CAST)
		return
	if(QDELETED(src) || QDELETED(owner) || QDELETED(cast_on) || !can_cast_spell())
		return . | SPELL_CANCEL_CAST

/datum/action/cooldown/spell/dark_whispers/cast(mob/living/cast_on)
	. = ..()
	message = tgui_input_text(owner, "What thought do you wish to weave to [cast_on]?", "[src]")

	if(!message)
		reset_spell_cooldown()
		return

	handle_message(cast_on)

/datum/action/cooldown/spell/dark_whispers/proc/handle_message(mob/living/cast_on)
	to_chat(owner, "I impress a message upon [cast_on]'s blood!")
	log_directed_talk(owner, cast_on, message, LOG_SAY, name)
	cast_on.playsound_local(cast_on, sound, 100, TRUE)
	to_chat(cast_on, "[span_bloody("Something deep within you seems to speak into your mind: </span><font color=#ff4646>\"[message]...\"</font>")]")
