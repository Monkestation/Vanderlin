GLOBAL_VAR_INIT(vamp_detection, FALSE)

/datum/round_event_control/antagonist/solo/from_ghosts/daewalker
	name = "The Daewalker"
	tags = list(
		TAG_ASTRATA,
		TAG_BLOOD,
		TAG_COMBAT,
		TAG_WAR,
	)
	antag_datum = /datum/antagonist/vampire/lord/daewalker
	antag_flag = ROLE_VAMPIRE
	shared_occurence_type = null
	minor_roleset = TRUE
	max_occurrences = 1
	allowed_storytellers = DIVINE_STORYTELLERS
	dedicated_storytellers = list(/datum/storyteller/astrata)

	cost = 1
	checks_antag_cap = FALSE
	base_antags = 1
	maximum_antags = 1
	roundstart = FALSE
	earliest_start = 30 MINUTES
	secondary_prob = 0
	prompted_picking = TRUE
	//not actually, see check_enemies proc
	required_enemies = 10

	min_players = 20
	weight = 10
	typepath = /datum/round_event/antagonist/solo/ghost/daewalker
	var/exp_requirements = list(
		EXP_TYPE_LIVING = 1440, // General experience
		EXP_TYPE_CHURCH = 720, // Understanding religious stuff
		EXP_TYPE_INQUISITION = 480, // Heavily involves them
		EXP_TYPE_COMBAT = 720, // Insane stats
	)


/datum/round_event_control/antagonist/solo/from_ghosts/daewalker/check_enemies(return_players = FALSE)
	var/list/suckheads = list()
	var/list/fuckheads = list()
	for(var/datum/mind/M in SSmapping.retainer.vampires)
		if(M.current && M.current.stat < DEAD)
			suckheads |= M.current
	for(var/datum/mind/M in SSmapping.retainer.death_knights)
		if(M.current && M.current.stat < DEAD)
			fuckheads |= M.current
	for(var/datum/clan/rave in GLOB.vampire_clans)
		suckheads |= rave.clan_members
		fuckheads |= rave.non_vampire_members
	// how many living vampires + how many living thralls + how many times they've been seen
	var/attention = length(suckheads) + length(fuckheads) * 0.5 + GLOB.vamp_detection * 0.125
	if(OMEN_SUNSTEAL in GLOB.badomens)
		attention += 5
	if(attention >= required_enemies)
		return return_players ? suckheads|fuckheads : TRUE
	return return_players ? suckheads|fuckheads : FALSE

/datum/round_event_control/antagonist/solo/from_ghosts/daewalker/get_candidates()
	var/list/parent_candidates = ..()
	if(!CONFIG_GET(flag/use_exp_tracking) || !SSdbcore.Connect())
		return parent_candidates

	var/list/candidates = list()
	checking_exp:
		for(var/mob/M in parent_candidates)
			var/client/C = M.client
			if(!C)
				continue
			if(!(check_rights_for(C,R_ADMIN) || (C.prefs.db_flags & DB_FLAG_EXEMPT)))
				for(var/req_type in exp_requirements)
					if(C.calc_exp_type(req_type) < exp_requirements[req_type])
						continue checking_exp
			candidates += M
	return candidates


/datum/round_event/antagonist/solo/ghost/daewalker
	transfer_prefs = FALSE

/datum/round_event/antagonist/solo/ghost/daewalker/announce()
	var/list/suckheads = list()
	for(var/datum/mind/M in SSmapping.retainer.vampires)
		if(M.current)
			suckheads |= M.current
	if(length(suckheads))
		priority_announce("The Daewalker Approaches", SPAN_GOD_ASTRATA("ASTRATA'S WILL"), 'sound/music/daewalkerintro.ogg', players = suckheads)
