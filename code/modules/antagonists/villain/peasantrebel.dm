//How often to check for promotion possibility
#define INGAME_ROLE_HEAD_UPDATE_PERIOD 300

/datum/antagonist/prebel
	name = "Peasant Rebel"
	roundend_category = "Peasant Rebels"
	antagpanel_category = "Peasant Rebellion"
	job_rank = ROLE_PREBEL
	antag_hud_type = ANTAG_HUD_REV
	antag_hud_name = "rev"
	show_in_roundend = FALSE
	isgoodguy = TRUE // Previous townies, still should get buffs, make chaos.
	confess_lines = list(
		"VIVA!",
		"DEATH TO THE NOBLES!",
		"STICK IT TO THE MAN!",
		"NO GODS, NO MASTERS!",
	)
	increase_votepwr = FALSE
	var/datum/team/prebels/rev_team

/datum/antagonist/prebel/examine_friendorfoe(datum/antagonist/examined_datum, mob/examiner, mob/examined)
	if(istype(examined_datum, /datum/antagonist/prebel/head))
		return "<span class='boldnotice'>A revolution leader.</span>"
	if(istype(examined_datum, /datum/antagonist/prebel))
		return "<span class='boldnotice'>My ally in revolt against the pigs.</span>"

/datum/antagonist/prebel/on_gain()
	. = ..()
	owner.special_role = ROLE_PREBEL
	var/mob/living/carbon/human/H = owner.current
	H.cmode_music = 'sound/music/cmode/antag/CombatSausageMaker.ogg'
	H.add_stress(/datum/stress_event/prebel)
	ADD_TRAIT(H, TRAIT_VILLAIN, TRAIT_GENERIC)
	create_objectives()
	owner.current.log_message("has been converted to the revolution!", LOG_ATTACK, color="red")

/datum/antagonist/prebel/on_removal()
	remove_objectives()
	. = ..()

/datum/antagonist/prebel/greet()
	to_chat(owner, "<span class='danger'>I am a peasant rebel! It's time for a change in leadership for this town.</span>")
	if(rev_team)
		rev_team.update_objectives()
	owner.announce_objectives()
	..()

/datum/antagonist/prebel/can_be_owned(datum/mind/new_owner)
	. = ..()
	if(.)
		if(new_owner.assigned_role.title in GLOB.noble_positions)
			return FALSE
		if(new_owner.assigned_role.title in GLOB.garrison_positions)
			return FALSE
		if(new_owner.unconvertable)
			return FALSE
		if(new_owner.current && HAS_TRAIT(new_owner.current, TRAIT_MINDSHIELD))
			return FALSE


/datum/antagonist/prebel/create_team(datum/team/prebels/new_team)
	if(!new_team)
		//For now only one revolution at a time
		for(var/datum/antagonist/prebel/head/H in GLOB.antagonists)
			if(!H.owner)
				continue
			if(H.rev_team)
				rev_team = H.rev_team
				return
		rev_team = new /datum/team/prebels()
		rev_team.update_objectives()
		return
	if(!istype(new_team))
		stack_trace("Wrong team type passed to [type] initialization.")
	rev_team = new_team

/datum/antagonist/prebel/get_team()
	return rev_team

/datum/antagonist/prebel/proc/create_objectives()
	if(get_team())
		objectives |= rev_team.objectives

/datum/antagonist/prebel/proc/remove_objectives()
	if(get_team())
		objectives -= rev_team.objectives

/datum/antagonist/prebel/head
	name = "Head Rebel"
	antag_hud_type = ANTAG_HUD_REV
	antag_hud_name = "rev_head"
	increase_votepwr = TRUE

/datum/antagonist/prebel/head/on_gain()
	. = ..()
	owner.current.add_spell(/datum/action/cooldown/spell/undirected/convert_rebel, source = src)

/datum/antagonist/prebel/head/on_removal()
	. = ..()
	owner.current.remove_spells(source = src)

/datum/antagonist/prebel/proc/can_be_converted(mob/living/candidate)
	if(!candidate.mind)
		return FALSE
	if(!can_be_owned(candidate.mind))
		return FALSE
	if(candidate.mind.assigned_role.title in GLOB.noble_positions)
		return FALSE
	if(candidate.mind.assigned_role.title in GLOB.garrison_positions)
		return FALSE
	var/mob/living/carbon/C = candidate //Check to see if the potential rev is implanted
	if(!istype(C)) //Can't convert simple animals
		return FALSE
	return TRUE

/datum/action/cooldown/spell/undirected/convert_rebel
	name = "RECRUIT REBELS"
	desc = "!"

	antimagic_flags = NONE

	charge_required = FALSE
	cooldown_time = 25 SECONDS

/datum/action/cooldown/spell/undirected/convert_rebel/cast(atom/cast_on)
	. = ..()
	if(!owner.mind.has_antag_datum(/datum/antagonist/prebel))
		return
	var/inputty = browser_input_text(cast_on, "Make a speech", "REVOLUTON!")
	if(inputty)
		owner.say(inputty, forced = "Revolution ([name])")
		var/datum/antagonist/prebel/PR = owner.mind.has_antag_datum(/datum/antagonist/prebel)
		for(var/mob/living/carbon/human/rebel in get_hearers_in_view(6, owner))
			addtimer(CALLBACK(rebel, TYPE_PROC_REF(/mob/living/carbon/human, rev_ask), owner, PR, inputty), 1)

/mob/living/carbon/human/proc/rev_ask(mob/living/carbon/human/guy,datum/antagonist/prebel/mind_datum,offer)
	if(!guy || !mind_datum || !offer)
		return
	if(!mind)
		return
	if(!client)
		return
	if(mind.special_role)
		return
	if(MOBTIMER_EXISTS(src, MT_REBELOFFER))
		return

	var/datum/team/prebels/RT = mind_datum.rev_team
	var/shittime = world.time
	playsound_local(src, 'sound/misc/rebel.ogg', 100, FALSE)
	var/garbaggio = alert(src, "[offer]","Rebellion", "Yes", "No")
	if(world.time > shittime + 35 SECONDS)
		to_chat(src,"<span class='danger'>Too late.</span>")
		return

	MOBTIMER_SET(src, MT_REBELOFFER)

	if(garbaggio == "Yes")
		if(mind_datum.add_revolutionary(mind))
			RT.offers2join += "<span class='info'><B>[real_name]</B> <span class='blue'>ACCEPTED</span> [guy.real_name]: \"[offer]\"</span>"
			to_chat(guy,"<span class='blue'>[src] joins the revolution.</span>")
	else
		to_chat(src,"<span class='danger'>I reject the offer.</span>")
		to_chat(guy,"<span class='danger'>[src] rejects the offer.</span>")
		RT.offers2join += "<span class='info'><B>[real_name]</B> <span class='red'>REJECTED</span> [guy.real_name]: \"[offer]\"</span>"

/datum/antagonist/prebel/proc/add_revolutionary(datum/mind/rev_mind)
	if(!can_be_converted(rev_mind.current))
		return FALSE
	rev_mind.add_antag_datum(/datum/antagonist/prebel,rev_team)
	return TRUE

/datum/team/prebels
	name = "\improper Peasant Rebellion"
	member_name = "rebel"
	var/list/offers2join = list()

/datum/objective/prebel
	name = "Rebellion"
	explanation_text = "Put a rebel on the throne with the crown and make a new decree."
	team_explanation_text = "Put a rebel on the throne with the crown and make a new decree."

/datum/team/prebels/New(starting_members)
	. = ..()
	add_objective(new /datum/objective/prebel)

/datum/team/prebels/proc/update_objectives(initial = FALSE)
	if(!(locate(/datum/objective/prebel) in objectives))
		var/datum/objective/prebel/preb = new
		preb.team = src
		objectives += preb
	for(var/datum/mind/M in members)
		var/datum/antagonist/prebel/R = M.has_antag_datum(/datum/antagonist/prebel)
		if(!R)
			R = M.has_antag_datum(/datum/antagonist/prebel/head)
		R.objectives |= objectives

	addtimer(CALLBACK(src,PROC_REF(update_objectives)),INGAME_ROLE_HEAD_UPDATE_PERIOD,TIMER_UNIQUE)

/datum/team/prebels/roundend_success()
	for(var/datum/mind/M in members)
		if(considered_alive(M))
			M.adjust_triumphs(5)

#undef INGAME_ROLE_HEAD_UPDATE_PERIOD
