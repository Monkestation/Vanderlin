/datum/action/cooldown/spell/undirected/list_target/convert_role/adept
	name = "Recruit Adept"
	button_icon_state = "recruit_guard"
	new_role = "Adept"
	recruitment_faction = "Inquisition"
	recruitment_message = "You will serve Psydon's will, %RECRUIT!"
	accept_message = "F-fine just don't kill me!"
	refuse_message = "I FOLLOW MY GOD INTO DEATH!!!"

/datum/action/cooldown/spell/undirected/list_target/convert_role/adept/cast(mob/living/carbon/human/cast_on)
	. = ..()
	if(!.)
		return
	//Can't convert devoted faithfuls
	if(cast_on.has_flaw(/datum/charflaw/addiction/godfearing))
		cast_on.say("I FOLLOW MY GOD INTO DEATH!!!")
		return FALSE
	return TRUE
