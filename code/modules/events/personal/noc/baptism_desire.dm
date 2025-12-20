/datum/round_event_control/noc_baptism
	name = "Mana Baptism"
	track = EVENT_TRACK_PERSONAL
	typepath = /datum/round_event/noc_baptism
	weight = 7
	earliest_start = 10 MINUTES
	max_occurrences = 1
	min_players = 35

	tags = list(
		TAG_NOC,
		TAG_MAGICAL,
	)

/datum/round_event_control/noc_baptism/canSpawnEvent(players_amt, gamemode, fake_check)
	. = ..()
	if(!.)
		return FALSE

	if(!length(GLOB.mana_fountains) || SSmapping.config.map_name == "Vanderlin")
		return FALSE

	for(var/mob/living/carbon/human/H in GLOB.player_list)
		if(!istype(H) || H.stat == DEAD || !H.client)
			continue
		if(!H.patron || !istype(H.patron, /datum/patron/divine/noc))
			continue
		if(!H.is_noble())
			continue
		if(H.mana_pool && H.mana_pool.intrinsic_recharge_sources == NONE)
			return TRUE
	return FALSE

/datum/round_event/noc_baptism/start()
	if(!length(GLOB.mana_fountains) || SSmapping.config.map_name == "Vanderlin")
		return

	var/list/valid_targets = list()

	for(var/mob/living/carbon/human/human_mob in GLOB.player_list)
		if(!istype(human_mob) || human_mob.stat == DEAD || !human_mob.client)
			continue
		if(!human_mob.patron || !istype(human_mob.patron, /datum/patron/divine/noc))
			continue
		if(!human_mob.is_noble())
			continue
		if(human_mob.mana_pool && human_mob.mana_pool.intrinsic_recharge_sources == NONE)
			valid_targets += human_mob

	if(!length(valid_targets))
		return

	var/mob/living/carbon/human/chosen_one = pick(valid_targets)

	var/datum/objective/personal/baptism/new_objective = new(owner = chosen_one.mind)
	chosen_one.mind.add_personal_objective(new_objective)

	bordered_message(chosen_one, list(
		span_userdanger("YOU ARE NOC'S CHOSEN!"),
		span_notice("Noc demands that you learn the ways of the arcyne! Seek baptism in the mana fountain to earn Noc's favor!"),
	))
	chosen_one.playsound_local(chosen_one, 'sound/ambience/noises/mystical (4).ogg', 100)

	chosen_one.mind.announce_personal_objectives()
