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

/datum/action/cooldown/spell/undirected/list_target/convert_role/adept/on_conversion(mob/living/carbon/human/cast_on)
	..()
	cast_on.add_traits(list(TRAIT_INQUISITION, TRAIT_KNOW_INQUISITION_DOORS))
	GLOB.inquisition.add_member_to_school(cast_on, "Order of the Venatari", -10, "Recruited adept")
	add_verb(cast_on, /mob/living/carbon/human/proc/torture_victim)
	add_verb(cast_on, /mob/living/carbon/human/proc/faith_test)
	add_verb(cast_on, /mob/living/carbon/human/proc/view_inquisition)

	if(cast_on.mind.has_antag_datum(/datum/antagonist/bandit)) //ex-bandits cannot just metagame their old buddies through disguise and vice-versa
		cast_on.mind.remove_antag_datum(/datum/antagonist/bandit)

	if(cast_on.mind.has_antag_datum(/datum/antagonist/assassin) || cast_on.mind.has_antag_datum(/datum/antagonist/zizocultist) || cast_on.mind.has_antag_datum(/datum/antagonist/maniac))
	//graggar/zizo cultist cannot be converted
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
