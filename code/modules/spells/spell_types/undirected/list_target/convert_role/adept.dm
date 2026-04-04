/datum/action/cooldown/spell/undirected/list_target/convert_role/adept
	name = "Recruit Adept"
	button_icon_state = "recruit_guard"
	new_role = "Adept"
	recruitment_faction = "Inquisition"
	recruitment_message = "You will serve Psydon's will, %RECRUIT!"
	accept_message = "F-fine just don't kill me!"
	refuse_message = "I FOLLOW MY GOD INTO DEATH!!!"

/datum/action/cooldown/spell/undirected/list_target/convert_role/adept/cast(mob/living/carbon/human/cast_on)
	//Can't convert devoted faithfuls
	if(cast_on.has_quirk(/datum/quirk/vice/godfearing))
		cast_on.say("I FOLLOW MY GOD INTO DEATH!!!")
		return
	..()
	if(HAS_TRAIT(cast_on, TRAIT_RECRUITED))
		cast_on.add_traits(alist(TRAIT_INQUISITION, TRAIT_KNOW_INQUISITION_DOORS))
		if(cast_on.mind.has_antag_datum(/datum/antagonist/assassin)) //assassins cannot change their faith
			to_chat(cast_on, span_boldnotice("My creed must not be abandoned. I will use this as an opportunity."))
			return
		var/alert
		if(cast_on.mind.has_antag_datum(/datum/antagonist/vampire)) //SOUL
			alert = tgui_alert(cast_on, "Eating my wings to make me tame", "Bird of Hermes is my name", list("PSYDON ENDURES!", "I still cling to the ways of old"))
		else
			alert = tgui_alert(cast_on, "Will you embrace the faith of your captors?", "BAPTISM", list("PSYDON ENDURES!", "I still cling to the ways of old"))
		if(alert != "I still cling to the ways of old")
			cast_on.set_patron(/datum/patron/psydon)
			to_chat(cast_on, span_boldnotice("A new chapter begins. Show your zeal. Endure."))
		else
			to_chat(cast_on, span_boldnotice("I lie to have my life spared. I hope they won't find out I'm a snake in the grass."))
	return TRUE
