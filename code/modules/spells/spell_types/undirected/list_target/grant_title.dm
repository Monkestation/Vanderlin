/datum/action/cooldown/spell/undirected/list_target/grant_title
	name = "Grant Title"
	desc = "Grant someone a title of honor... Or shame."
	button_icon_state = "recruit_titlegrant"

	spell_type = NONE
	cooldown_time = 4 MINUTES
	target_radius = 3

	var/title

/datum/action/cooldown/spell/undirected/list_target/grant_title/get_list_targets(atom/center, target_radius)
	var/list/things = list()
	if(target_radius)
		for(var/mob/living/carbon/human/target_mob in view(target_radius, center))
			if(QDELETED(target_mob))
				continue
			if(!target_mob.mind || target_mob.stat != CONSCIOUS)
				continue
			if(!target_mob.get_face_name(null))
				continue
			if(isautomaton(target_mob))
				continue
			things += target_mob

	return things

/datum/action/cooldown/spell/undirected/list_target/grant_title/before_cast(mob/living/carbon/human/cast_on)
	. = ..()
	if(. & SPELL_CANCEL_CAST)
		return

	var/prev_title = GLOB.lord_titles[cast_on.real_name]
	if(prev_title)
		var/answer = tgui_alert(owner, "[cast_on] already has a title, strip it?", "[name]", DEFAULT_INPUT_CONFIRMATIONS)
		if(QDELETED(src) || QDELETED(owner) || QDELETED(cast_on) || !can_cast_spell())
			return . | SPELL_CANCEL_CAST
		if(answer == CHOICE_CONFIRM)
			owner.say("I HEREBY STRIP YOU, [uppertext(cast_on.name)], OF THE TITLE OF [uppertext(prev_title)]!")
			GLOB.lord_titles -= cast_on.real_name
		else
			reset_spell_cooldown()
		return . | SPELL_CANCEL_CAST

	title = browser_input_text(owner, "What title do you wish to grant?", "[name]", max_length = 42)
	if(QDELETED(src) || QDELETED(owner) || QDELETED(cast_on) || !can_cast_spell())
		return . | SPELL_CANCEL_CAST

	if(!title)
		reset_spell_cooldown()
		return . | SPELL_CANCEL_CAST

/datum/action/cooldown/spell/undirected/list_target/grant_title/cast(mob/living/carbon/human/cast_on)
	. = ..()
	owner.say("I HEREBY GRANT YOU, [uppertext(cast_on.name)], THE TITLE OF [uppertext(title)]!")
	GLOB.lord_titles[cast_on.real_name] = title
