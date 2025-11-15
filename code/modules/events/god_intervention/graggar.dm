/// Tracks culling pairings
GLOBAL_LIST_EMPTY(graggar_cullings)

/datum/round_event_control/graggar_culling
	name = "Graggar's Culling"
	track = EVENT_TRACK_INTERVENTION
	typepath = /datum/round_event/graggar_culling
	weight = 8
	earliest_start = 20 MINUTES
	max_occurrences = 1
	min_players = 35
	dedicated_storytellers = list(/datum/storyteller/graggar)
	allowed_storytellers = INHUMEN_STORYTELLERS

	tags = list(
		TAG_GRAGGAR,
	)

/datum/round_event_control/graggar_culling/canSpawnEvent(players_amt, gamemode, fake_check)
	. = ..()
	if(!.)
		return FALSE
	if(GLOB.patron_follower_counts["Graggar"] < 2)
		return FALSE

/datum/round_event/graggar_culling/start()
	var/list/contenders = list()
	for(var/mob/living/carbon/human/human_mob in GLOB.player_list)
		if(!istype(human_mob) || human_mob.stat == DEAD || !human_mob.client)
			continue

		if(!human_mob.patron || !istype(human_mob.patron, /datum/patron/inhumen/graggar))
			continue

		var/obj/item/organ/heart/heart = human_mob.getorganslot(ORGAN_SLOT_HEART)
		if(!heart)
			continue

		contenders += human_mob

	if(length(contenders) < 2)
		return

	// 33% chance for grand culling (multiple pairs) unless ascendant, then it's guaranteed
	var/grand_culling = is_ascendant(GRAGGAR) || prob(33)
	var/max_pairs = grand_culling ? floor(length(contenders) / 2) : 1

	for(var/i in 1 to max_pairs)
		if(length(contenders) < 2)
			break

		var/mob/living/carbon/human/first_chosen = pick_n_take(contenders)
		var/mob/living/carbon/human/second_chosen = pick_n_take(contenders)

		var/datum/culling_duel/new_duel = new(first_chosen, second_chosen)
		GLOB.graggar_cullings += new_duel

		// Notify first chosen
		bordered_message(first_chosen, list(
			span_userdanger("YOU ARE GRAGGAR'S CONTESTANT!"),
			span_red("Weak should feed the strong, that is Graggar's will. Prove that you are not weak by eating the heart of [span_notice(second_chosen.real_name)], the [second_chosen.job] and gain unimaginable power in turn. Fail, and you will be the one eaten."),
		))
		if(grand_culling)
			to_chat(first_chosen, span_notice("Graggar has decreed a GRAND CULLING! Many hearts will feed the strong todae!"))
		first_chosen.playsound_local(first_chosen, 'sound/misc/gods/graggar_omen.ogg', 100)

		var/datum/objective/personal/eat_rival_heart/first_chosen_objective = new(owner = first_chosen.mind, rival_name = second_chosen.real_name, rival_job = second_chosen.job)
		first_chosen.mind.add_personal_objective(first_chosen_objective)
		first_chosen.mind.announce_personal_objectives()

		// Notify second chosen
		bordered_message(second_chosen, list(
			span_userdanger("YOU ARE GRAGGAR'S CONTESTANT!"),
			span_red("Weak should feed the strong, that is Graggar's will. Prove that you are not weak by eating the heart of [span_notice(first_chosen.real_name)], the [first_chosen.job] and gain unimaginable power in turn. Fail, and you will be the one eaten."),
		))
		if(grand_culling)
			to_chat(second_chosen, span_notice("Graggar has decreed a GRAND CULLING! Many hearts will feed the strong todae!"))
		second_chosen.playsound_local(second_chosen, 'sound/misc/gods/graggar_omen.ogg', 100)

		var/datum/objective/personal/eat_rival_heart/second_chosen_objective = new(owner = second_chosen.mind, rival_name = first_chosen.real_name, rival_job = first_chosen.job)
		second_chosen.mind.add_personal_objective(second_chosen_objective)
		second_chosen.mind.announce_personal_objectives()

/datum/culling_duel
	var/datum/weakref/challenger
	var/datum/weakref/target
	var/datum/weakref/challenger_heart
	var/datum/weakref/target_heart

/datum/culling_duel/New(mob/challenger, mob/target)
	. = ..()
	src.challenger = WEAKREF(challenger)
	src.target = WEAKREF(target)
	var/obj/item/organ/heart/c_heart = challenger.getorganslot(ORGAN_SLOT_HEART)
	var/obj/item/organ/heart/t_heart = target.getorganslot(ORGAN_SLOT_HEART)
	src.challenger_heart = WEAKREF(c_heart)
	src.target_heart = WEAKREF(t_heart)
	RegisterSignal(c_heart, COMSIG_PARENT_QDELETING, PROC_REF(handle_challenger_heart_destroyed))
	RegisterSignal(t_heart, COMSIG_PARENT_QDELETING, PROC_REF(handle_target_heart_destroyed))

/datum/culling_duel/Destroy()
	GLOB.graggar_cullings -= src
	var/obj/item/organ/heart/d_challenger_heart = challenger_heart?.resolve()
	var/obj/item/organ/heart/d_target_heart = target_heart?.resolve()
	if(d_challenger_heart)
		UnregisterSignal(d_challenger_heart, COMSIG_PARENT_QDELETING)
	if(d_target_heart)
		UnregisterSignal(d_target_heart, COMSIG_PARENT_QDELETING)
	return ..()

/datum/culling_duel/proc/handle_challenger_heart_destroyed()
	SIGNAL_HANDLER
	var/mob/living/carbon/human/winner = target?.resolve()
	var/mob/living/carbon/human/loser = challenger?.resolve()
	partial_victory(winner, loser)

/datum/culling_duel/proc/handle_target_heart_destroyed()
	SIGNAL_HANDLER
	var/mob/living/carbon/human/winner = challenger?.resolve()
	var/mob/living/carbon/human/loser = target?.resolve()
	partial_victory(winner, loser)

/datum/culling_duel/proc/partial_victory(mob/living/winner, mob/living/loser)
	if(winner)
		winner.add_stress(/datum/stress_event/graggar_culling_finished)
		winner.adjust_triumphs(1)
		adjust_storyteller_influence(GRAGGAR, 20)
		to_chat(winner, span_notice("Your rival's heart has been DESTROYED! While not the glorious consumption Graggar has desired, you have overcome the culling nevertheless."))

	finish_culling(winner, loser)

/datum/culling_duel/proc/finish_culling(mob/living/winner, mob/living/loser)
	if(winner)
		winner.remove_stress(/datum/stress_event/graggar_culling_unfinished)
		winner.remove_spell(/datum/action/cooldown/spell/undirected/seek_rival)

	if(loser)
		loser.remove_stress(/datum/stress_event/graggar_culling_unfinished)
		loser.remove_spell(/datum/action/cooldown/spell/undirected/seek_rival)
		to_chat(loser, span_boldred("You have FAILED Graggar for the LAST TIME!"))
		loser.gib()

	qdel(src)
