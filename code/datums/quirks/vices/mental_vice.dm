/proc/get_mammons_in_atom(atom/movable/movable)
	var/static/list/coins_types = typecacheof(/obj/item/coin)
	var/mammons = 0
	if(coins_types[movable.type])
		var/obj/item/coin/coin = movable
		mammons += coin.quantity * coin.sellprice
	for(var/atom/movable/content in movable.contents)
		mammons += get_mammons_in_atom(content)
	return mammons

/datum/status_effect/debuff/addiction
	id = "addiction"
	alert_type = /atom/movable/screen/alert/status_effect/debuff/addiction
	effectedstats = list(STATKEY_END = -1, STATKEY_LCK = -1)
	duration = 100

//these legit just exist sow we get unique instances
/datum/status_effect/debuff/addiction/alcoholic
/datum/status_effect/debuff/addiction/smoker
/datum/status_effect/debuff/addiction/junkie
/datum/status_effect/debuff/addiction/pyromaniac
/datum/status_effect/debuff/addiction/kleptomaniac
/datum/status_effect/debuff/addiction/godfearing
/datum/status_effect/debuff/addiction/maniac
/datum/status_effect/debuff/addiction/greedy

/atom/movable/screen/alert/status_effect/debuff/addiction
	name = "Addiction"
	desc = ""
	icon_state = "debuff"

/datum/quirk/vice/greedy
	name = "Greedy"
	desc = "I can't get enough of mammons, I need more and more!"
	point_value = 4
	var/last_checked_mammons = 0
	var/required_mammons = 0
	var/next_mammon_increase = 0
	var/last_passed_check = 0
	var/first_tick = FALSE
	var/extra_increment_value = 0

/datum/quirk/vice/greedy/on_spawn()
	next_mammon_increase = world.time + rand(15 MINUTES, 25 MINUTES)
	last_passed_check = world.time

/datum/quirk/vice/greedy/on_life(mob/living/user)
	if(!ishuman(user))
		return
	var/mob/living/carbon/human/H = user

	if(!first_tick)
		var/starting_mammons = get_mammons_in_atom(H)
		required_mammons = round(starting_mammons * 0.7)
		extra_increment_value = round(starting_mammons * 0.15)
		first_tick = TRUE
		return

	if(world.time >= next_mammon_increase)
		if(last_passed_check + (50 MINUTES) < world.time)
			required_mammons -= rand(10, 20)
			to_chat(H, span_blue("Maybe a little less mammons is enough..."))
		else
			required_mammons += rand(25, 35) + extra_increment_value
		required_mammons = min(required_mammons, 250)
		next_mammon_increase = world.time + rand(35 MINUTES, 40 MINUTES)
		var/current_mammons = get_mammons_in_atom(H)
		if(current_mammons >= required_mammons)
			to_chat(H, span_blue("I'm quite happy with the amount of mammons I have..."))
		else
			to_chat(H, span_boldwarning("I need more mammons, what I have is not enough..."))
		last_checked_mammons = current_mammons

	var/new_mammon_amount = get_mammons_in_atom(H)
	var/ascending = (new_mammon_amount > last_checked_mammons)
	var/do_update_msg = TRUE

	if(new_mammon_amount >= required_mammons)
		if(H.has_stress_type(/datum/stress_event/vice))
			to_chat(H, span_blue("[new_mammon_amount] mammons... That's more like it.."))
		H.remove_stress(/datum/stress_event/vice)
		H.remove_status_effect(/datum/status_effect/debuff/addiction/greedy)
		last_passed_check = world.time
		do_update_msg = FALSE
	else
		H.add_stress(/datum/stress_event/vice)
		H.apply_status_effect(/datum/status_effect/debuff/addiction/greedy)

	if(new_mammon_amount == last_checked_mammons)
		do_update_msg = FALSE

	if(do_update_msg)
		if(ascending)
			to_chat(H, span_warning("Only [new_mammon_amount] mammons.. I need more..."))
		else
			to_chat(H, span_boldwarning("No! My precious mammons..."))

	last_checked_mammons = new_mammon_amount

/datum/quirk/vice/paranoid
	name = "Paranoid"
	desc = "I'm even more anxious than most towners. I'm extra paranoid of other species, the price of higher intelligence."
	point_value = 3
	var/last_check = 0

/datum/quirk/vice/paranoid/on_life(mob/living/user)
	if(world.time < last_check + 10 SECONDS)
		return
	if(!ishuman(user))
		return

	last_check = world.time
	var/mob/living/carbon/human/H = user
	var/cnt = 0

	for(var/mob/living/carbon/human/L in hearers(7, user))
		if(L == user)
			continue
		if(L.stat)
			continue
		if(L.dna?.species && H.dna?.species)
			if(L.dna.species.id != H.dna.species.id)
				cnt++
		if(cnt > 2)
			break

	if(cnt > 2)
		H.add_stress(/datum/stress_event/paracrowd)

	cnt = 0
	for(var/obj/effect/decal/cleanable/blood/B in view(7, user))
		cnt++
		if(cnt > 3)
			break

	if(cnt > 6)
		H.add_stress(/datum/stress_event/parablood)

/datum/quirk/vice/clingy
	name = "Clingy"
	desc = "I like being around people, it's just so lively..."
	point_value = 2
	incompatible_quirks = list(
		/datum/quirk/vice/isolationist
	)
	var/last_check = 0

/datum/quirk/vice/clingy/on_life(mob/living/user)
	if(world.time < last_check + 10 SECONDS)
		return
	if(!user)
		return

	last_check = world.time
	var/cnt = 0

	for(var/mob/living/carbon/human/L in hearers(7, user))
		if(L == user)
			continue
		if(L.stat)
			continue
		if(L.dna?.species)
			cnt++
		if(cnt > 2)
			break

	if(cnt < 2)
		var/mob/living/carbon/P = user
		P.add_stress(/datum/stress_event/nopeople)

/datum/quirk/vice/isolationist
	name = "Isolationist"
	desc = "I don't like being near people. They might be trying to do something to me..."
	point_value = 2
	incompatible_quirks = list(
		/datum/quirk/vice/clingy
	)
	var/last_check = 0

/datum/quirk/vice/isolationist/on_life(mob/living/user)
	if(world.time < last_check + 10 SECONDS)
		return
	if(!user)
		return

	last_check = world.time
	var/cnt = 0

	for(var/mob/living/carbon/human/L in hearers(7, user))
		if(L == user)
			continue
		if(L.stat)
			continue
		if(L.dna?.species)
			cnt++
		if(cnt > 2)
			break

	if(cnt > 2)
		var/mob/living/carbon/P = user
		P.add_stress(/datum/stress_event/crowd)

/datum/quirk/vice/narcoleptic
	name = "Narcoleptic"
	desc = "I get drowsy during the day and tend to fall asleep suddenly, but I can sleep easier if I want to, and moon dust can help me stay awake."
	point_value = 4
	var/last_unconsciousness = 0
	var/next_sleep = 0
	var/concious_timer = (10 MINUTES)
	var/do_sleep = FALSE
	var/pain_pity_charges = 3
	var/drugged_up = FALSE

/datum/quirk/vice/narcoleptic/on_spawn()
	ADD_TRAIT(owner, TRAIT_FASTSLEEP, "[type]")
	last_unconsciousness = world.time
	concious_timer = rand(7 MINUTES, 15 MINUTES)
	pain_pity_charges = rand(2, 4)

/datum/quirk/vice/narcoleptic/on_life(mob/living/user)
	if(!ishuman(user))
		return
	var/mob/living/carbon/human/H = user

	if(H.stat != CONSCIOUS)
		do_sleep = FALSE
		last_unconsciousness = world.time
		concious_timer = rand(7 MINUTES, 15 MINUTES)
		pain_pity_charges = rand(2, 4)
		return

	if(do_sleep)
		if(next_sleep <= world.time)
			var/pain = H.get_complex_pain()
			if(pain >= 40 && pain_pity_charges > 0)
				pain_pity_charges--
				concious_timer = rand(1 MINUTES, 2 MINUTES)
				to_chat(H, span_warning("The pain keeps me awake..."))
			else
				if(prob(40) || drugged_up)
					drugged_up = FALSE
					concious_timer = rand(4 MINUTES, 6 MINUTES)
					to_chat(H, span_info("The feeling has passed."))
				else
					concious_timer = rand(7 MINUTES, 15 MINUTES)
					to_chat(H, span_boldwarning("I can't keep my eyes open any longer..."))
					H.Sleeping(rand(30 SECONDS, 50 SECONDS))
					H.visible_message(span_warning("[H] suddenly collapses!"))
			do_sleep = FALSE
			last_unconsciousness = world.time
	else
		if(last_unconsciousness + concious_timer < world.time)
			drugged_up = FALSE
			to_chat(H, span_blue("I'm getting drowsy..."))
			H.emote("yawn", forced = TRUE)
			next_sleep = world.time + rand(7 SECONDS, 11 SECONDS)
			do_sleep = TRUE

/datum/quirk/vice/narcoleptic/on_remove()
	if(owner)
		REMOVE_TRAIT(owner, TRAIT_FASTSLEEP, "[type]")

/proc/narcolepsy_drug_up(mob/living/living)
	var/datum/quirk/vice/narcoleptic/narco = living.get_quirk(/datum/quirk/vice/narcoleptic)
	if(!narco)
		return
	narco.drugged_up = TRUE

/datum/quirk/vice/masochist
	name = "Masochist"
	desc = "I love the feeling of pain, so much I can't get enough of it."
	point_value = 4
	var/next_paincrave = 0
	var/last_pain_threshold = NONE

/datum/quirk/vice/masochist/on_spawn()
	next_paincrave = world.time + rand(15 MINUTES, 25 MINUTES)

/datum/quirk/vice/masochist/on_life(mob/living/user)
	if(!ishuman(user))
		return
	var/mob/living/carbon/human/H = user

	if(next_paincrave > world.time)
		last_pain_threshold = NONE
		return

	H.add_stress(/datum/stress_event/vice)
	H.apply_status_effect(/datum/status_effect/debuff/addiction)

	var/current_pain = H.get_complex_pain()
	var/bloodloss_factor = clamp(1.0 - (H.blood_volume / BLOOD_VOLUME_NORMAL), 0.0, 0.5)
	var/new_pain_threshold = get_pain_threshold(current_pain * (1.0 + (bloodloss_factor * 1.4)) * clamp(2 - (H.STAEND / 10), 0.5, 1.5))

	if(last_pain_threshold == NONE)
		to_chat(H, span_boldwarning("I could really use some pain right now..."))
	else if(new_pain_threshold != last_pain_threshold)
		var/ascending = (new_pain_threshold > last_pain_threshold)
		switch(new_pain_threshold)
			if(MASO_THRESHOLD_ONE)
				to_chat(H, span_warning("The pain is gone..."))
			if(MASO_THRESHOLD_TWO)
				if(ascending)
					to_chat(H, span_blue("Yes, more pain!"))
				else
					to_chat(H, span_warning("No, my pain!"))
			if(MASO_THRESHOLD_THREE)
				to_chat(H, span_blue("More, I love it!"))

	last_pain_threshold = new_pain_threshold
	if(new_pain_threshold == MASO_THRESHOLD_FOUR)
		to_chat(H, span_blue("<b>That's more like it...</b>"))
		next_paincrave = world.time + rand(35 MINUTES, 45 MINUTES)
		H.remove_stress(/datum/stress_event/vice)
		H.remove_status_effect(/datum/status_effect/debuff/addiction)

/datum/quirk/vice/masochist/proc/get_pain_threshold(pain_amt)
	switch(pain_amt)
		if(-INFINITY to 25)
			return MASO_THRESHOLD_ONE
		if(25 to 50)
			return MASO_THRESHOLD_TWO
		if(50 to 95)
			return MASO_THRESHOLD_THREE
		if(95 to INFINITY)
			return MASO_THRESHOLD_FOUR

// Chronic Pain Vices
/datum/quirk/vice/chronic_arthritis
	name = "Chronic Arthritis"
	desc = "Your joints ache constantly, causing periodic pain flares and reduced mobility."
	point_value = 3

/datum/quirk/vice/chronic_arthritis/on_spawn()
	if(!ishuman(owner))
		return
	var/mob/living/carbon/human/H = owner
	var/list/joint_parts = list()
	for(var/obj/item/bodypart/BP in H.bodyparts)
		if(BP.body_zone in list(BODY_ZONE_L_ARM, BODY_ZONE_R_ARM, BODY_ZONE_L_LEG, BODY_ZONE_R_LEG))
			joint_parts += BP

	if(joint_parts.len)
		var/affected_parts = min(rand(1, 3), joint_parts.len)
		for(var/i = 1 to affected_parts)
			var/obj/item/bodypart/BP = pick_n_take(joint_parts)
			BP.chronic_pain = rand(10, 20)
			BP.chronic_pain_type = CHRONIC_ARTHRITIS

	to_chat(H, span_warning("Your joints feel stiff and painful - a reminder of your chronic arthritis."))

/datum/quirk/vice/chronic_arthritis/on_life(mob/living/user)
	if(!ishuman(user))
		return
	var/mob/living/carbon/human/H = user

	if(prob(2))
		var/list/arthritic_parts = list()
		for(var/obj/item/bodypart/BP in H.bodyparts)
			if(BP.chronic_pain_type == CHRONIC_ARTHRITIS)
				arthritic_parts += BP

		if(arthritic_parts.len)
			var/obj/item/bodypart/affected = pick(arthritic_parts)
			affected.lingering_pain += rand(7.5, 12.5)
			var/pain_msg = pick("Your [affected.name] throbs with arthritic pain!",
							   "A sharp ache shoots through your [affected.name]!",
							   "Your [affected.name] feels stiff and painful!")
			to_chat(H, span_warning(pain_msg))

	if(prob(1) && H.loc)
		if(SSParticleWeather.runningWeather && SSParticleWeather.runningWeather.can_weather(H))
			for(var/obj/item/bodypart/BP in H.bodyparts)
				if(BP.chronic_pain_type == CHRONIC_ARTHRITIS && prob(30))
					BP.lingering_pain += rand(5, 10)
					to_chat(H, span_warning("The weather makes your arthritis act up."))
					break

/datum/quirk/vice/chronic_back_pain
	name = "Chronic Back Pain"
	desc = "Years of wear and tear have left you with persistent lower back pain that affects your mobility."
	point_value = 3

/datum/quirk/vice/chronic_back_pain/on_spawn()
	if(!ishuman(owner))
		return
	var/mob/living/carbon/human/H = owner
	for(var/obj/item/bodypart/BP in H.bodyparts)
		if(BP.body_zone == BODY_ZONE_CHEST)
			BP.chronic_pain = rand(20, 32.5)
			BP.chronic_pain_type = pick(CHRONIC_OLD_FRACTURE, CHRONIC_SCAR_TISSUE)
			break
	to_chat(H, span_warning("Your lower back aches with familiar, persistent pain."))

/datum/quirk/vice/chronic_back_pain/on_life(mob/living/user)
	if(!ishuman(user))
		return
	var/mob/living/carbon/human/H = user

	if(H.m_intent == MOVE_INTENT_RUN && prob(5))
		for(var/obj/item/bodypart/BP in H.bodyparts)
			if(BP.body_zone == BODY_ZONE_CHEST)
				BP.lingering_pain += rand(3, 5)
				to_chat(H, span_warning("Running aggravates your chronic back pain!"))
				break

	if(prob(2))
		var/encumbrance = H.get_encumbrance()
		if(encumbrance >= 0.5)
			for(var/obj/item/bodypart/BP in H.bodyparts)
				if(BP.body_zone == BODY_ZONE_CHEST)
					var/pain_amount = rand(8, 15)
					if(encumbrance >= 0.8)
						pain_amount = rand(15, 25)
						to_chat(H, span_warning("Your heavy gear puts severe strain on your already painful back!"))
					else
						to_chat(H, span_warning("The weight of your equipment aggravates your chronic back pain!"))
					BP.lingering_pain += pain_amount
					break

/datum/quirk/vice/old_war_wound
	name = "Old War Wound"
	desc = "An old injury from your past still haunts you, causing chronic pain and occasional flare-ups."
	point_value = 5

/datum/quirk/vice/old_war_wound/on_spawn()
	if(!ishuman(owner))
		return
	var/mob/living/carbon/human/H = owner
	var/list/major_parts = list()
	for(var/obj/item/bodypart/BP in H.bodyparts)
		if(BP.body_zone in list(BODY_ZONE_CHEST, BODY_ZONE_L_ARM, BODY_ZONE_R_ARM, BODY_ZONE_L_LEG, BODY_ZONE_R_LEG))
			major_parts += BP

	if(major_parts.len)
		var/obj/item/bodypart/wounded = pick(major_parts)
		wounded.chronic_pain = rand(10, 17.5)
		wounded.chronic_pain_type = pick(CHRONIC_OLD_FRACTURE, CHRONIC_SCAR_TISSUE, CHRONIC_NERVE_DAMAGE)
		wounded.brute_dam += rand(3, 8)
		var/wound_location = wounded.name
		var/wound_desc = pick("shrapnel wound", "arrow wound", "deep scar", "poorly healed fracture")
		to_chat(H, span_warning("You feel the familiar ache of your old [wound_desc] in your [wound_location]."))

/datum/quirk/vice/old_war_wound/on_life(mob/living/user)
	if(!ishuman(user))
		return

	var/mob/living/carbon/human/H = user

	// Stress-triggered pain flares
	if(H.health < (H.maxHealth * 0.7) || H.get_stress_amount() > 10)
		if(prob(3))
			for(var/obj/item/bodypart/BP in H.bodyparts)
				if(BP.chronic_pain > 30)
					BP.lingering_pain += rand(5, 6)
					to_chat(H, span_warning("Your old war wound flares up from the stress!"))
					break

	// Random phantom pain
	if(prob(1.5))
		for(var/obj/item/bodypart/BP in H.bodyparts)
			if(BP.chronic_pain > 0)
				BP.lingering_pain += rand(5, 10)
				var/pain_type = pick("sharp", "throbbing", "burning", "aching")
				to_chat(H, span_warning("A [pain_type] pain shoots through your old wound."))
				break
