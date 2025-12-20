/datum/action/cooldown/spell/undirected/list_target/vicious_mimicry
	name = "Vicious Mimicry"
	desc = "Speak for target in range."
	button_icon_state = "mimicry"

	spell_type = SPELL_MIRACLE
	antimagic_flags = MAGIC_RESISTANCE_HOLY
	associated_skill = /datum/skill/magic/holy
	required_items = list(/obj/item/clothing/neck/psycross/silver/xylix)

	cooldown_time = 1 MINUTES
	spell_cost = 25

	choose_target_message = "Choose who to speak as."
	target_radius = 6

	var/message

/datum/action/cooldown/spell/undirected/list_target/vicious_mimicry/is_valid_target(atom/cast_on)
	. = ..()
	if(!.)
		return
	return isliving(cast_on)

/datum/action/cooldown/spell/undirected/list_target/vicious_mimicry/before_cast(mob/living/cast_on)
	. = ..()
	if(. & SPELL_CANCEL_CAST)
		return
	message = browser_input_text(owner, "What should they say?", "XYLIX")
	if(QDELETED(src) || QDELETED(owner) || QDELETED(cast_on) || !can_cast_spell())
		return . | SPELL_CANCEL_CAST

	if(!message)
		reset_spell_cooldown()
		return . | SPELL_CANCEL_CAST

/datum/action/cooldown/spell/undirected/list_target/vicious_mimicry/cast(mob/living/cast_on)
	. = ..()
	log_directed_talk(owner, cast_on, message, LOG_SAY, name)
	var/mob/living/L = owner
	var/static/list/bannedwords = list("zizo", "graggar", "matthios", "baotha", "inhumen", "heresy")
	for(var/T in bannedwords)  //astrata smites naughty xylixans
		if(findtext(message, T))
			L.add_stress(/datum/stress_event/psycurselight)
			L.adjust_divine_fire_stacks(6)
			L.IgniteMob()
			return
	to_chat(cast_on, span_userdanger("Your mouth starts to move on its own!"))
	cast_on.say(message, forced = "Vicious Mimicry")
	L.emote("laugh", forced = TRUE)
