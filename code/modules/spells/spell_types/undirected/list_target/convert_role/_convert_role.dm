/datum/action/cooldown/spell/undirected/list_target/convert_role
	name = "Recruit Beggar"
	desc = "Recruit someone to your cause."
	button_icon_state = "recruit_bog"
	/// Role given if recruitment is accepted
	var/new_role = "Beggar"
	/// Faction shown to the user in the recruitment prompt
	var/recruitment_faction = "Beggars"
	/// Message the recruiter gives
	var/recruitment_message = "Serve the beggars, %RECRUIT!"
	/// Say message when the recruit accepts
	var/accept_message = "I will serve!"
	/// Say message when the recruit refuses
	var/refuse_message = "I refuse."

/// Get a list of living targets in radius of the center to put in the target list.
/datum/action/cooldown/spell/undirected/list_target/convert_role/get_list_targets(atom/center, conversion_radius = 7)
	var/list/things = list()
	if(conversion_radius)
		for(var/mob/living/carbon/human/nearby_living in get_hearers_in_LOS(conversion_radius, center) - center)
			if(!can_convert(nearby_living))
				continue
			things += nearby_living

	return things

/datum/action/cooldown/spell/undirected/list_target/convert_role/proc/can_convert(mob/living/carbon/human/cast_on)
	if(QDELETED(cast_on))
		return FALSE
	//need a mind
	if(!cast_on.mind)
		return FALSE
	//already recruited
	if(HAS_TRAIT(cast_on, TRAIT_RECRUITED))
		return FALSE
	//need to see their damn face
	if(!cast_on.get_face_name(null))
		return FALSE

	return TRUE

/datum/action/cooldown/spell/undirected/list_target/convert_role/cast(mob/living/carbon/human/cast_on)
	. = ..()
	owner.say(replacetext(recruitment_message, "%RECRUIT", "[cast_on]"), forced = "Convert spell ([src])")

	var/answer = browser_alert(cast_on, "Do you wish to become a [new_role]?", "[recruitment_faction] recruitment.", DEFAULT_INPUT_CONFIRMATIONS)
	if(QDELETED(src) || QDELETED(owner) || QDELETED(cast_on) || !can_cast_spell())
		return
	if(answer != CHOICE_CONFIRM)
		if(refuse_message)
			cast_on.say(refuse_message, forced = "Convert spell ([src])")
		return
	if(accept_message)
		cast_on.say(accept_message, forced = "Convert spell ([src])")
	on_conversion(cast_on)

/datum/action/cooldown/spell/undirected/list_target/convert_role/proc/on_conversion(mob/living/carbon/human/cast_on)
	SHOULD_CALL_PARENT(TRUE)

	ADD_TRAIT(cast_on, TRAIT_RECRUITED, TRAIT_GENERIC)
	cast_on.job = new_role
	var/datum/job/job_real = SSjob.GetJob(new_role)
	if(job_real)
		cast_on.mind?.set_assigned_role(new_role)

	SEND_SIGNAL(SSdcs, COMSIG_GLOBAL_ROLE_CONVERTED, owner, cast_on, new_role)
