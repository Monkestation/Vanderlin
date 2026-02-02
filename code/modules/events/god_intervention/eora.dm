/datum/round_event_control/eora_matchmaking
	name = "Eora's Matchmaking"
	track = EVENT_TRACK_INTERVENTION
	typepath = /datum/round_event/eora_matchmaking
	weight = 8
	earliest_start = 15 MINUTES
	max_occurrences = 1
	min_players = 30
	dedicated_storytellers = list(/datum/storyteller/eora)
	allowed_storytellers = DIVINE_STORYTELLERS

	tags = list(
		TAG_EORA,
	)

/datum/round_event/eora_matchmaking/start()
	var/list/eligible_males = list()
	var/list/eligible_females = list()

	for(var/mob/living/carbon/human/human_mob in GLOB.player_list)
		if(!istype(human_mob) || human_mob.stat == DEAD || !human_mob.client)
			continue

		// Must worship the Ten, clergy is excluded
		if(!human_mob.patron || !istype(human_mob.patron, /datum/patron/divine) || (human_mob.mind?.assigned_role.title in GLOB.church_positions))
			continue

		// Exclude married and children
		if(human_mob.IsWedded() || human_mob.age == AGE_CHILD)
			continue

		// Exclude parents using new family system
		if(human_mob.family_member_datum)
			var/datum/family_member/member = human_mob.family_member_datum
			if(member.children.len > 0)
				continue

		// Add to appropriate gender list
		if(human_mob.gender == MALE)
			eligible_males += human_mob
		else
			eligible_females += human_mob

	if(!length(eligible_males) || !length(eligible_females))
		return

	eligible_males = shuffle(eligible_males)
	eligible_females = shuffle(eligible_females)

	var/list/selected_pairs = list()
	var/max_number = is_ascendant(EORA) ? 6 : 3
	var/max_pairs = min(max_number, eligible_males.len, eligible_females.len)

	for(var/i in 1 to max_pairs)
		var/found_pair = FALSE

		for(var/mob/living/carbon/human/male in eligible_males)
			for(var/mob/living/carbon/human/female in eligible_females)
				if(male.family_datum != female.family_datum)
					selected_pairs += list(list(male, female))
					eligible_males -= male
					eligible_females -= female
					found_pair = TRUE
					break

			if(found_pair)
				break

		if(!found_pair)
			break

	for(var/pair in selected_pairs)
		var/mob/living/carbon/human/male = pair[1]
		var/mob/living/carbon/human/female = pair[2]

		bordered_message(male, list(
			span_userdanger("YOU ARE EORA'S LOVEBIRD!"),
			span_rose("Eora's voice whispers in your heart - you feel an irresistible urge to finally get married..."),
			span_rose("You can choose anyone you fancy to fulfill this desire, but the name of [span_notice("[female.real_name]")], the [female.job] seems to get your heart racing for some reason..."),
		))
		male.playsound_local(male, 'sound/vo/female/gen/giggle (1).ogg', 100)

		var/datum/objective/personal/marry/male_marry_objective = new(owner = male.mind, lovebird_name = female.real_name, lovebird_job = female.job)
		male.mind.add_personal_objective(male_marry_objective)
		male.mind.announce_personal_objectives()

		bordered_message(female, list(
			span_userdanger("YOU ARE EORA'S LOVEBIRD!"),
			span_rose("Eora's voice whispers in your heart - you feel an irresistible urge to finally get married..."),
			span_rose("You can choose anyone you fancy to fulfill this desire, but the name of [span_notice("[male.real_name]")], the [male.job] seems to get your heart racing for some reason..."),
		))
		female.playsound_local(female, 'sound/vo/female/gen/giggle (1).ogg', 100)

		var/datum/objective/personal/marry/female_marry_objective = new(owner = female.mind, lovebird_name = male.real_name, lovebird_job = male.job)
		female.mind.add_personal_objective(female_marry_objective)
		female.mind.announce_personal_objectives()
