/// Spell that allows the caster to send a message to anyone they know. Can be sent Anonymously, but recipient can bypass it with high enough perception
/datum/action/cooldown/spell/undirected/message
	name = "Message"
	desc = "Latch onto the mind of one who is familiar to you, whispering a message into their head."
	button_icon_state = "message"

	point_cost = 1

	charge_required = FALSE
	spell_cost = 30
	cooldown_time = 1 MINUTES
	spell_flags = SPELL_RITUOS

	/// Ref to cliented mob we are sending to
	var/datum/weakref/recipient_ref
	/// Message to send
	var/message
	/// If we try to hide our identity
	var/anonymous = FALSE

/datum/action/cooldown/spell/undirected/message/Destroy(force)
	recipient_ref = null
	return ..()

/datum/action/cooldown/spell/undirected/message/can_cast_spell(feedback = TRUE)
	. = ..()
	if(!.)
		return FALSE
	if(!owner.mind)
		return FALSE
	if(!ishuman(owner))
		return FALSE

	return TRUE

/datum/action/cooldown/spell/undirected/message/before_cast(atom/cast_on)
	. = ..()
	if(. & SPELL_CANCEL_CAST)
		return
	if(!LAZYLEN(owner.mind?.known_people))
		to_chat(owner, span_warning("I don't know anyone!"))
		return . | SPELL_CANCEL_CAST
	var/recipient = tgui_input_text(owner, "Who are you trying to contact?", "BEYOND THE VEIL", encode=FALSE)
	if(QDELETED(src) || QDELETED(cast_on) || !can_cast_spell())
		return . | SPELL_CANCEL_CAST
	if(!recipient)
		reset_cooldown()
		return . | SPELL_CANCEL_CAST
	if(!owner.mind?.do_i_know(name = recipient))
		to_chat(owner, span_warning("I don't know anyone by that name."))
		return . | SPELL_CANCEL_CAST
	for(var/client/C as anything in GLOB.clients)
		var/mob/M = C.mob
		if(QDELETED(M))
			continue
		if(M.real_name == recipient)
			recipient_ref = WEAKREF(M)
			break
	if(!recipient_ref)
		to_chat(owner, span_warning("I seek a mental connection, but can't find [recipient]."))
		return . | SPELL_CANCEL_CAST
	message = tgui_input_text(owner, "You make a connecton, what are you trying to say?", "BEYOND THE VEIL", max_length = 150)
	if(QDELETED(src) || QDELETED(cast_on) || !can_cast_spell())
		return . | SPELL_CANCEL_CAST
	if(!message)
		reset_cooldown()
		return . | SPELL_CANCEL_CAST
	var/answer = tgui_alert(owner, "Send anonymously?", "BEYOND THE VEIL", DEFAULT_INPUT_CHOICES)
	if(QDELETED(src) || QDELETED(cast_on) || !can_cast_spell())
		return . | SPELL_CANCEL_CAST
	if(answer == CHOICE_CONFIRM)
		anonymous = TRUE

/datum/action/cooldown/spell/undirected/message/cast(atom/cast_on)
	. = ..()
	var/mob/living/recipient = recipient_ref.resolve()
	owner.log_message("[key_name(owner)] sent a spell message to [key_name(recipient)]; message: [message]", LOG_GAME)
	if(QDELETED(recipient))
		return
	if(!recipient.mind)
		return
	if(recipient.mind?.do_i_know(name = owner.real_name)) // No point being anonymous if the recipient doesnt even know your voice in the first place
		if(!anonymous)
			to_chat(recipient, "Arcyne whispers fill the back of my head, resolving into <span class='bold'>[owner]</span>'s voice: <font color=#7246ff>[message]</font>")
			return
		else if(GET_MOB_ATTRIBUTE_VALUE(recipient, STAT_PERCEPTION) >= 15)
			to_chat(recipient, "Arcyne whispers fill the back of my head, and <span class='warning'>although attempts were made to hide it, you can still discern that it is </span><span class='bold'>[owner]</span>'s voice... <font color=#7246ff>[message]</font>")
			return
	to_chat(recipient, "Arcyne whispers fill the back of my head, resolving into an unknown [owner.gender == FEMALE ? "woman" : "man"]'s voice: <font color=#7246ff>[message]</font>")



