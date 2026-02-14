
/datum/antagonist/bandit
	name = "Bandit"
	roundend_category = "Bandits"
	antagpanel_category = "Bandit"
	job_rank = ROLE_BANDIT
	antag_hud_type = ANTAG_HUD_BANDIT
	antag_hud_name = "bandit"
	var/tri_amt
	var/contrib
	antag_flags = FLAG_ANTAG_CAP_IGNORE
	confess_lines = list(
		"FREEDOM!!!",
		"I WILL NOT LIVE IN YOUR WALLS!",
		"I WILL NOT FOLLOW YOUR RULES!",
	)

	innate_traits = list(
		TRAIT_BANDITCAMP,
		TRAIT_SEEPRICES,
		TRAIT_STEELHEARTED,
		TRAIT_VILLAIN,
	)

/datum/antagonist/bandit/examine_friendorfoe(datum/antagonist/examined_datum, mob/examiner, mob/examined)
	if(istype(examined_datum, /datum/antagonist/bandit))
		if(examiner.real_name in GLOB.outlawed_players)
			if(examined.real_name in GLOB.outlawed_players)
				return span_boldnotice("Another free man. My ally.")
			else
				return span_boldnotice("Pardoned free man?! Can I still trust [examined.p_them()]?!")
		else if(examined.real_name in GLOB.outlawed_players)
			return span_boldnotice("Free man still on the run. Fool.")
		else
			return span_boldnotice("Fellow pardoned free man.")

/datum/antagonist/bandit/on_gain()
	owner.special_role = "Bandit"
	owner.current?.purge_combat_knowledge()
	move_to_spawnpoint()
	owner.current.roll_mob_stats()
	forge_objectives()
	. = ..()
	finalize_bandit()
	equip_bandit()
	addtimer(CALLBACK(owner.current, TYPE_PROC_REF(/mob/living/carbon/human, choose_name_popup), "BANDIT"), 5 SECONDS)

/datum/antagonist/bandit/proc/finalize_bandit()
	owner.current.playsound_local(get_turf(owner.current), 'sound/music/traitor.ogg', 80, FALSE, pressure_affected = FALSE)
	var/mob/living/carbon/human/H = owner.current
	H.set_patron(/datum/patron/inhumen/matthios)

/datum/antagonist/bandit/greet()
	to_chat(owner.current, span_alertsyndie("I am a BANDIT!"))
	to_chat(owner.current, span_info("Long ago I did a crime worthy of my bounty being hung on the wall outside of the local inn."))
	owner.announce_objectives()
	..()

/datum/antagonist/bandit/proc/forge_objectives()
	return

/proc/isbandit(mob/living/M)
	return istype(M) && M.mind && M.mind.has_antag_datum(/datum/antagonist/bandit)

/datum/antagonist/bandit/move_to_spawnpoint()
	owner.current.forceMove(pick(GLOB.bandit_starts))

/datum/antagonist/bandit/proc/equip_bandit()

	owner.forget_and_be_forgotten()

	for(var/datum/mind/found_mind in get_minds("Bandit"))
		owner.share_identities(found_mind)

	return TRUE

/datum/antagonist/bandit/roundend_report()
	if(owner?.current)
		var/amt = tri_amt
		var/the_name = owner.name
		if(ishuman(owner.current))
			var/mob/living/carbon/human/H = owner.current
			the_name = H.real_name
		if(!amt)
			to_chat(world, "[the_name] was a bandit.")
		else
			to_chat(world, "[the_name] was a bandit. He stole [amt] triumphs worth of loot.")
	return
