/datum/action/cooldown/spell/undirected/list_target/grant_nobility
	name = "Grant Nobility"
	desc = "Make someone a noble, or strip them of their nobility."
	button_icon_state = "recruit_titlegrant"

	spell_type = NONE
	cooldown_time = 4 MINUTES
	target_radius = 3

/datum/action/cooldown/spell/undirected/list_target/grant_nobility/get_list_targets(atom/center, target_radius)
	var/list/things = list()
	if(target_radius)
		for(var/mob/living/carbon/human/H in view(target_radius, center))
			if(QDELETED(H))
				return FALSE
			if(!H.mind || H.stat != CONSCIOUS)
				return FALSE
			if(!H.get_face_name(null))
				return FALSE
			things += H

	return things

/datum/action/cooldown/spell/undirected/list_target/grant_nobility/before_cast(mob/living/carbon/human/cast_on)
	. = ..()
	if(. & SPELL_CANCEL_CAST)
		return

	if(HAS_TRAIT(cast_on, TRAIT_NOBLE_POWER))
		var/answer = browser_alert(owner, "[cast_on] already has nobility, strip it?", "[name]", DEFAULT_INPUT_CONFIRMATIONS)
		if(QDELETED(src) || QDELETED(owner) || QDELETED(cast_on) || !can_cast_spell())
			return . | SPELL_CANCEL_CAST
		if(answer == CHOICE_CONFIRM)
			owner.say("I HEREBY STRIP YOU, [uppertext(cast_on.name)], OF NOBILITY!")
			REMOVE_TRAIT(cast_on, TRAIT_NOBLE_POWER, TRAIT_GENERIC)
		else
			reset_spell_cooldown()
		return . | SPELL_CANCEL_CAST

/datum/action/cooldown/spell/undirected/list_target/grant_nobility/cast(mob/living/carbon/human/cast_on)
	. = ..()
	owner.say("I HEREBY GRANT YOU, [uppertext(cast_on.name)], NOBILITY!")
	ADD_TRAIT(cast_on, TRAIT_NOBLE_POWER, TRAIT_GENERIC)
