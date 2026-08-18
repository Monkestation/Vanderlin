/datum/round_event_control/antagonist/solo/aspirant
	name = "Aspirant"
	tags = list(
		TAG_ASTRATA,
		TAG_BAOTHA,
		TAG_VILLAIN,
		TAG_CORRUPTION,
	)
	antag_datum = /datum/antagonist/aspirant
	roundstart = FALSE
	can_call_midround = TRUE
	antag_flag = ROLE_ASPIRANT
	shared_occurence_type = SHARED_MINOR_THREAT
	minor_roleset = TRUE

	needed_job = list(
		/datum/job/consort,
		/datum/job/hand,
		/datum/job/prince,
		/datum/job/captain,
		/datum/job/steward,
		/datum/job/magician,
		/datum/job/courtphys,
		/datum/job/archivist,
		/datum/job/minor_noble,
		/datum/job/tomb_warden,
	)

	exclusive_roles = list(
		/datum/job/consort,
		/datum/job/hand,
		/datum/job/prince,
		/datum/job/captain,
		/datum/job/steward,
		/datum/job/magician,
		/datum/job/courtphys,
		/datum/job/archivist,
		/datum/job/tomb_warden,
	)

	restricted_roles = list(
		/datum/job/lord,
	)

	base_antags = 1
	maximum_antags = 1
	min_players = (LOWPOP_THRESHOLD*0.8) * READYUP_AVG
	denominator = (LOWPOP_THRESHOLD*0.8) * READYUP_AVG
	cost = 0.8

	earliest_start = 0 SECONDS
	weight = 0
	max_occurrences = 1

	secondary_prob = 0

	typepath = /datum/round_event/antagonist/solo/aspirant

	/// weakrefs to /datum/noble_faction that have crossed threshold. Purely a firing gate —
	/// does NOT restrict who can become the Aspirant, since the Aspirant starts unaligned
	/// and recruits a house via sway_faction_head after being chosen.
	var/list/pending_factions = list()

/datum/round_event_control/antagonist/solo/aspirant/New()
	. = ..()
	RegisterSignal(SSdcs, COMSIG_NOBLE_FACTION_ASPIRANT_ELIGIBLE, PROC_REF(on_faction_eligible))

/datum/round_event_control/antagonist/solo/aspirant/proc/on_faction_eligible(datum/source, datum/noble_faction/faction)
	SIGNAL_HANDLER
	var/datum/weakref/faction_ref = WEAKREF(faction)
	if(faction_ref in pending_factions)
		return
	pending_factions += faction_ref
	weight = 6

/datum/round_event_control/antagonist/solo/aspirant/valid_for_map()
	if(SSmapping.config.map_name != "Voyage")
		return TRUE
	return FALSE

/datum/round_event_control/antagonist/solo/aspirant/canSpawnEvent(players_amt, gamemode, fake_check)
	if(length(SSmapping.retainer.aspirants)) // already have one this round
		return FALSE
	if(!length(pending_factions))
		return FALSE
	. = ..()

/datum/round_event/antagonist/solo/aspirant

/datum/round_event/antagonist/solo/aspirant/start()
	. = ..()

	if(SSticker.rulermob?.mind)
		SSticker.rulermob.mind.add_antag_datum(/datum/antagonist/aspirant/ruler)
