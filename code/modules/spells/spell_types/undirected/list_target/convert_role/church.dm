/datum/action/cooldown/spell/undirected/list_target/convert_role/church
	name = "Recruit Church Nerd"
	var/allow_centrist = FALSE

/datum/action/cooldown/spell/undirected/list_target/convert_role/church/cast(mob/living/carbon/human/cast_on)
	// Patron-specific checks happen here, AFTER priest picks the target
	var/mob/living/living_owner = owner

	if(cast_on.cleric)
		to_chat(owner, span_info("[cast_on.real_name] already serves their god(s)."))
		return

	if(!cast_on.patron)
		to_chat(owner, span_info("The Ten glare upon you in confusion. CHILD, [cast_on.real_name] has no form of faith."))
		return

	if(cast_on.patron.type in ALL_PROFANE_PATRONS)
		to_chat(owner, span_danger("The Ten glare upon you in fury. CHILD, [cast_on.real_name] serves the Inhumen, do not disgrace Our name."))
		living_owner.adjust_divine_fire_stacks(50) // Half of the damage that you get if you say a profane word, hurts alot.
		living_owner.IgniteMob()
		return // Stop the recruitment entirely

	if(istype(cast_on.patron, /datum/patron/psydon))
		to_chat(owner, span_info("The Ten glare upon you in sadness. CHILD, [cast_on.real_name] serves Psydon, he is dead, nobody can answer these prayers."))
		return // Stop recruitment

	if(!allow_centrist && istype(cast_on.patron, /datum/patron/divine/centrist))
		to_chat(owner, span_info("The Ten glare upon you in stubbornness. [cast_on.real_name] worships The Ten equally. They can serve only one."))
		return // Stop recruitment

	if(!(cast_on.patron.type in ALL_TEMPLE_PATRONS))
		to_chat(owner, span_danger("The Ten glare upon you in anger. CHILD, [cast_on.real_name] does not worship Our divinity. They are undeserving of Our grace."))
		return // Stop recruitment

	return ..()

/datum/action/cooldown/spell/undirected/list_target/convert_role/church/templar
	name = "Recruit Templar"
	button_icon_state = "recruit_templar"

	new_role = "Templar"
	recruitment_faction = "Church"
	recruitment_message = "Serve the Ten, %RECRUIT!"
	accept_message = "FOR THE TEN!"
	refuse_message = "I refuse."

/datum/action/cooldown/spell/undirected/list_target/convert_role/church/templar/on_conversion(mob/living/carbon/human/cast_on)
	. = ..()
	var/holder = cast_on.patron?.devotion_holder
	if(holder)
		var/datum/devotion/devotion = new holder()
		devotion.make_templar()
		devotion.grant_to(cast_on)


/datum/action/cooldown/spell/undirected/list_target/convert_role/church/acolyte
	name = "Recruit Acolyte"
	button_icon_state = "recruit_acolyte"

	new_role = "Acolyte"
	recruitment_faction = "Church"
	recruitment_message = "Serve the Ten, %RECRUIT!"
	accept_message = "FOR THE TEN!"
	refuse_message = "I refuse."

/datum/action/cooldown/spell/undirected/list_target/convert_role/church/acolyte/on_conversion(mob/living/carbon/human/cast_on)
	. = ..()
	var/holder = cast_on.patron?.devotion_holder
	if(holder)
		var/datum/devotion/devotion = new holder()
		devotion.make_acolyte()
		devotion.grant_to(cast_on)

/datum/action/cooldown/spell/undirected/list_target/convert_role/church/churchling
	name = "Recruit Churchling"
	button_icon_state = "recruit_acolyte"

	new_role = "Churchling"
	recruitment_faction = "Church"
	recruitment_message = "Serve the Ten, %RECRUIT!"
	accept_message = "FOR THE TEN!"
	refuse_message = "I refuse."

	allow_centrist = TRUE

/datum/action/cooldown/spell/undirected/list_target/convert_role/church/churchling/on_conversion(mob/living/carbon/human/cast_on)
	. = ..()
	var/holder = cast_on.patron?.devotion_holder
	if(holder)
		var/datum/devotion/devotion = new holder()
		devotion.make_churchling()
		devotion.grant_to(cast_on)

/datum/action/cooldown/spell/undirected/list_target/convert_role/church/churchling/can_convert(mob/living/carbon/human/cast_on)
	if(QDELETED(cast_on))
		return FALSE
	//need a mind
	if(!cast_on.mind)
		return FALSE
	//only orphans who aren't apprentices
	if(istype(cast_on.mind.assigned_role, /datum/job/orphan) && cast_on.is_apprentice())
		to_chat(owner, span_info("You cannot recruit a child already in an apprenticeship."))
		return FALSE
	if(cast_on.age != AGE_CHILD)
		return FALSE
	//need to see their damn face
	if(!cast_on.get_face_name(null))
		return FALSE
	return TRUE
