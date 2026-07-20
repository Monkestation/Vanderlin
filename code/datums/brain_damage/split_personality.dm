#define OWNER 0
#define STRANGER 1

/datum/brain_trauma/severe/split_personality
	name = "Split Personality"
	desc = "Patient's brain is split into two personalities, which randomly switch control of the body."
	scan_desc = ""
	gain_text = span_warning("I feel like my mind was split in two.")
	lose_text = span_notice("I feel alone again.")
	var/current_controller = OWNER
	var/initialized = FALSE //to prevent personalities deleting themselves while we wait for ghosts
	var/mob/living/split_personality/stranger_backseat //there's two so they can swap without overwriting
	var/mob/living/split_personality/owner_backseat
	///The role to display when polling ghost
	var/poll_role = "split personality"
	///How long do we give ghosts to respond?
	var/poll_time = 20 SECONDS

/datum/brain_trauma/severe/split_personality/on_gain()
	var/mob/living/brain_owner = owner
	if(brain_owner.stat == DEAD || !brain_owner.client || istype(brain_owner, /mob/living/carbon/human/species/skeleton/death_arena) || HAS_TRAIT(brain_owner, TRAIT_NO_SPLIT_PERSONALITY)) //No use assigning people to a corpse or braindead
		return FALSE
	. = ..()
	make_backseats()

#ifdef UNIT_TESTS
	return // There's no ghosts in the unit test
#endif

	get_ghost()

/datum/brain_trauma/severe/split_personality/proc/make_backseats()
	stranger_backseat = new(owner, src)
	var/datum/action/personality_commune/stranger_spell = new(src)
	stranger_spell.Grant(stranger_backseat)

	owner_backseat = new(owner, src)
	var/datum/action/personality_commune/owner_spell = new(src)
	owner_spell.Grant(owner_backseat)

/datum/brain_trauma/severe/split_personality/proc/get_ghost()
	var/list/mob/dead/observer/candidates = pollCandidatesForMob("Do you want to play as [owner]'s split personality?", poll_role, null, null, poll_time, stranger_backseat, POLL_IGNORE_SPLITPERSONALITY)
	if(!length(candidates))
		qdel(src)
		return

	var/mob/dead/observer/ghost = pick(candidates)
	stranger_backseat.PossessByPlayer(ghost.key)
	log_game("[key_name(stranger_backseat)] became [key_name(owner)]'s split personality.")
	message_admins("[ADMIN_LOOKUPFLW(stranger_backseat)] became [ADMIN_LOOKUPFLW(owner)]'s split personality.")

/datum/brain_trauma/severe/split_personality/on_life()
	if(owner.stat == DEAD)
		if(current_controller != OWNER)
			switch_personalities(TRUE)
		qdel(src)
	else if(prob(3))
		switch_personalities()

	return ..()

/datum/brain_trauma/severe/split_personality/on_lose()
	if(current_controller != OWNER) //it would be funny to cure a guy only to be left with the other personality, but it seems too cruel
		switch_personalities(TRUE)
	QDEL_NULL(stranger_backseat)
	QDEL_NULL(owner_backseat)

	return ..()

/datum/brain_trauma/severe/split_personality/proc/switch_personalities(reset_to_owner = FALSE)
	if(QDELETED(owner) || QDELETED(stranger_backseat) || QDELETED(owner_backseat))
		return

	var/mob/living/split_personality/current_backseat
	var/mob/living/split_personality/new_backseat
	if(current_controller == STRANGER || reset_to_owner)
		current_backseat = owner_backseat
		new_backseat = stranger_backseat
	else
		current_backseat = stranger_backseat
		new_backseat = owner_backseat

	if(!current_backseat.client) //Make sure we never switch to a logged off mob.
		return

	current_backseat.log_message("assumed control of [key_name(owner)] due to [src]. (Original owner: [current_controller == OWNER ? owner.key : current_backseat.key])", LOG_GAME)
	to_chat(owner, span_userdanger("I feel my control being taken away... my other personality is in charge now!"))
	to_chat(current_backseat, span_userdanger("I manage to take control of my body!"))

	//Body to backseat

	var/h2b_id = owner.computer_id
	var/h2b_ip= owner.lastKnownIP
	owner.computer_id = null
	owner.lastKnownIP = null

	new_backseat.ckey = owner.ckey

	new_backseat.name = owner.name

	if(owner.mind)
		new_backseat.mind = owner.mind

	if(!new_backseat.computer_id)
		new_backseat.computer_id = h2b_id

	if(!new_backseat.lastKnownIP)
		new_backseat.lastKnownIP = h2b_ip

	if(reset_to_owner && new_backseat.mind)
		new_backseat.ghostize(FALSE)

	//Backseat to body

	var/s2h_id = current_backseat.computer_id
	var/s2h_ip= current_backseat.lastKnownIP
	current_backseat.computer_id = null
	current_backseat.lastKnownIP = null

	owner.ckey = current_backseat.ckey
	owner.mind = current_backseat.mind

	if(!owner.computer_id)
		owner.computer_id = s2h_id

	if(!owner.lastKnownIP)
		owner.lastKnownIP = s2h_ip

	current_controller = !current_controller

/mob/living/split_personality
	name = "split personality"
	real_name = "unknown conscience"
	var/mob/living/carbon/body
	var/datum/brain_trauma/severe/split_personality/trauma

/mob/living/split_personality/Initialize(mapload, _trauma)
	if(iscarbon(loc))
		body = loc
		name = body.real_name
		real_name = body.real_name
		trauma = _trauma
	return ..()

/mob/living/split_personality/Life()
	if(QDELETED(body))
		qdel(src) //in case trauma deletion doesn't already do it

	if((body.stat == DEAD && trauma.owner_backseat == src))
		trauma.switch_personalities()
		qdel(trauma)

	//if one of the two ghosts, the other one stays permanently
	if(!body.client && trauma.initialized)
		trauma.switch_personalities()
		qdel(trauma)

	return ..()

/mob/living/split_personality/Login()
	. = ..()
	if(!. || !client)
		return FALSE
	to_chat(src, span_notice("As a split personality, you cannot do anything but observe. However, you will eventually gain control of the body, switching places with the current personality."))
	to_chat(src, span_boldwarning("Do not commit suicide or put the body in a deadly position. Behave like you care about it as much as the owner."))

/mob/living/split_personality/say(message, bubble_type, list/spans, sanitize, datum/language/language, ignore_spam, forced)
	SHOULD_CALL_PARENT(FALSE)

	to_chat(src, span_warning("I cannot speak, my other self is controlling my body!"))

	return FALSE

/mob/living/split_personality/emote(act, type_override = NONE, message = null, intentional = FALSE, force_silence = FALSE, forced = FALSE)
	return FALSE

#undef OWNER
#undef STRANGER
