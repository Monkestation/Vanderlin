/datum/action/cooldown/spell/undirected/list_target/encode_thoughts
	name = "Encode Thoughts"
	desc = "Latch onto the mind of one who is nearby, weaving a particular thought into their mind."
	button_icon_state = null
	sound = 'sound/magic/whiteflame.ogg'

	point_cost = 1
	attunements = list(
		/datum/attunement/dark = 0.5,
	)

	cooldown_time = 25 SECONDS
	spell_cost = 25

	choose_target_message = "Choose who to invade the mind of."
	target_radius = 6
	spell_flags = SPELL_RITUOS
	var/message

/datum/action/cooldown/spell/undirected/list_target/encode_thoughts/before_cast(atom/cast_on)
	. = ..()
	if(. & SPELL_CANCEL_CAST)
		return
	message = browser_input_text(owner, "What thought do you wish to weave to [cast_on]?", "[src]")
	if(QDELETED(src) || QDELETED(owner) || QDELETED(cast_on) || !can_cast_spell())
		return . | SPELL_CANCEL_CAST

	if(!message)
		reset_spell_cooldown()
		return . | SPELL_CANCEL_CAST

/datum/action/cooldown/spell/undirected/list_target/encode_thoughts/cast(mob/living/cast_on)
	. = ..()
	log_directed_talk(owner, cast_on, message, LOG_SAY, name)

	to_chat(owner, "I pluck the strings of [cast_on]'s mind!")
	to_chat(cast_on, "Your mind thinks to itself: </span><font color=#7246ff>\"[message]...\"</font>")

/datum/action/cooldown/spell/undirected/list_target/encode_thoughts/vampire
	name = "Vampiric Manipulation"
	sound = 'sound/magic/PSY.ogg'
	point_cost = 0
	spell_type = SPELL_BLOOD
	spell_flags = NONE
