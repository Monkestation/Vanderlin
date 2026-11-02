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
	effectedstats = list(STAT_ENDURANCE = -1, STAT_FORTUNE = -1)
	duration = 100

//these legit just exist sow we get unique instances
/datum/status_effect/debuff/addiction/alcoholic
/datum/status_effect/debuff/addiction/smoker
/datum/status_effect/debuff/addiction/junkie
/datum/status_effect/debuff/addiction/pyromaniac
/datum/status_effect/debuff/addiction/kleptomaniac
/datum/status_effect/debuff/addiction/godfearing
/datum/status_effect/debuff/addiction/sadist
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

/datum/quirk/vice/greedy/on_examined(mob/user, list/P, list/examine_contents)
	if(HAS_TRAIT(user, TRAIT_RECOGNIZE_ADDICTS))
		LAZYADDASSOCLIST(examine_contents, EXAMINE_SECT_PREGEAR, SPAN_GOD_BAOTHA("Greed..."))

/datum/quirk/vice/greedy/on_spawn()
	next_mammon_increase = world.time + rand(15 MINUTES, 25 MINUTES)
	last_passed_check = world.time
	return ..()

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
		H.add_stress(/datum/stress_event/para/crowd)

	cnt = 0
	for(var/obj/effect/decal/cleanable/blood/B in view(7, user))
		cnt++
		if(cnt > 3)
			break

	if(cnt > 6)
		H.add_stress(/datum/stress_event/para/blood)

/datum/quirk/vice/paranoid/on_examined(mob/user, list/P, list/examine_contents)
	if(HAS_TRAIT(user, TRAIT_RECOGNIZE_ADDICTS))
		LAZYADDASSOCLIST(examine_contents, EXAMINE_SECT_PREGEAR, SPAN_GOD_BAOTHA("Paranoid..."))

/datum/quirk/vice/clingy
	name = "Clingy"
	desc = "I like being around people, it's just so lively..."
	point_value = 2
	incompatible_quirks = list(
		/datum/quirk/vice/isolationist
	)
	var/last_check = 0

/datum/quirk/vice/clingy/on_examined(mob/user, list/P, list/examine_contents)
	if(HAS_TRAIT(user, TRAIT_RECOGNIZE_ADDICTS))
		LAZYADDASSOCLIST(examine_contents, EXAMINE_SECT_PREGEAR, SPAN_GOD_BAOTHA("Clingy..."))

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

/datum/quirk/vice/isolationist/on_examined(mob/user, list/P, list/examine_contents)
	if(HAS_TRAIT(user, TRAIT_RECOGNIZE_ADDICTS))
		LAZYADDASSOCLIST(examine_contents, EXAMINE_SECT_PREGEAR, SPAN_GOD_BAOTHA("Introvert..."))

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
	traits_to_add = list(TRAIT_FASTSLEEP)
	var/last_unconsciousness = 0
	var/next_sleep = 0
	var/concious_timer = (10 MINUTES)
	var/do_sleep = FALSE
	var/pain_pity_charges = 3
	var/drugged_up = FALSE

/datum/quirk/vice/narcoleptic/on_examined(mob/user, list/P, list/examine_contents)
	if(HAS_TRAIT(user, TRAIT_RECOGNIZE_ADDICTS))
		LAZYADDASSOCLIST(examine_contents, EXAMINE_SECT_PREGEAR, SPAN_GOD_BAOTHA("Sleepy..."))

/datum/quirk/vice/narcoleptic/on_spawn()
	last_unconsciousness = world.time
	concious_timer = rand(7 MINUTES, 15 MINUTES)
	pain_pity_charges = rand(2, 4)
	return ..()

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
			var/pain = H.getShockStage()
			if(pain >= SHOCK_STAGE_2 && pain_pity_charges > 0)
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

/proc/narcolepsy_drug_up(mob/living/living)
	var/datum/quirk/vice/narcoleptic/narco = living.get_quirk(/datum/quirk/vice/narcoleptic)
	if(!narco)
		return
	narco.drugged_up = TRUE

/// How often (deciseconds) we re-check the threshold while craving, to catch
/// changes that don't fire the shock signal (blood loss, Endurance buffs expiring).
#define MASO_RECHECK_INTERVAL (10 SECONDS)
/// If the holder is dead when a craving would start, retry after this long.
#define MASO_DEAD_RETRY_DELAY (1 MINUTES)
/// Time between the craving starting and the stress/debuff kicking in. Getting
/// enough pain inside this window satisfies the craving with no penalty at all.
#define MASO_GRACE_PERIOD (3 MINUTES)

/datum/quirk/vice/masochist
	name = "Masochist"
	desc = "I love the feeling of pain, so much I can't get enough of it."
	point_value = 4
	/// Timer that starts the next craving
	var/craving_timer
	/// Timer that periodically re-evaluates pain while craving
	var/recheck_timer
	/// Are we currently craving pain?
	var/craving = FALSE
	/// Timer that applies the penalties if the grace period runs out
	var/grace_timer
	/// Have the stress and debuff been applied for this craving?
	var/penalties_active = FALSE
	/// Last threshold we messaged the holder about
	var/last_pain_threshold = NONE
	/// Absolute world.time of the next craving, kept for anything that reads it
	var/next_paincrave = 0

/datum/quirk/vice/masochist/Destroy()
	cleanup_craving()
	if(craving_timer)
		deltimer(craving_timer)
		craving_timer = null
	return ..()

/datum/quirk/vice/masochist/on_examined(mob/user, list/P, list/examine_contents)
	if(HAS_TRAIT(user, TRAIT_RECOGNIZE_ADDICTS))
		LAZYADDASSOCLIST(examine_contents, EXAMINE_SECT_PREGEAR, SPAN_GOD_BAOTHA("Masochist!"))

/datum/quirk/vice/masochist/on_spawn()
	schedule_craving(rand(1 MINUTES, 1 MINUTES))
	return ..()

/// Schedules the next craving to start in `delay` deciseconds
/datum/quirk/vice/masochist/proc/schedule_craving(delay)
	if(craving_timer)
		deltimer(craving_timer)
	next_paincrave = world.time + delay
	craving_timer = addtimer(CALLBACK(src, PROC_REF(start_craving)), delay, TIMER_STOPPABLE)

/// The craving begins: apply penalties once and start listening for pain changes
/datum/quirk/vice/masochist/proc/start_craving()
	craving_timer = null

	var/mob/living/carbon/human/H = owner
	if(!H)
		return
	// No point craving on a corpse, try again later
	if(H.stat == DEAD)
		schedule_craving(MASO_DEAD_RETRY_DELAY)
		return

	craving = TRUE
	last_pain_threshold = NONE

	// Penalties are delayed: the holder gets a window to satisfy the craving first
	grace_timer = addtimer(CALLBACK(src, PROC_REF(apply_penalties)), MASO_GRACE_PERIOD, TIMER_STOPPABLE)

	RegisterSignal(H, COMSIG_CARBON_SHOCK_UPDATED, PROC_REF(on_shock_updated))
	recheck_timer = addtimer(CALLBACK(src, PROC_REF(recheck)), MASO_RECHECK_INTERVAL, TIMER_STOPPABLE)

	evaluate_pain(H)

/// Pain changed on the holder
/datum/quirk/vice/masochist/proc/on_shock_updated(datum/source, traumatic_shock)
	SIGNAL_HANDLER

	if(!craving)
		return
	evaluate_pain(source)

/// Slow fallback re-check for blood volume and Endurance drift
/datum/quirk/vice/masochist/proc/recheck()
	recheck_timer = null
	if(!craving)
		return

	var/mob/living/carbon/human/H = owner
	if(!H)
		return

	evaluate_pain(H)
	// evaluate_pain() may have satisfied the craving, in which case we must not re-arm
	if(craving)
		recheck_timer = addtimer(CALLBACK(src, PROC_REF(recheck)), MASO_RECHECK_INTERVAL, TIMER_STOPPABLE)

/// Works out the current threshold, messages on changes, and satisfies the craving if high enough
/datum/quirk/vice/masochist/proc/evaluate_pain(mob/living/carbon/human/H)
	if(!craving || !istype(H) || H.stat == DEAD)
		return

	var/current_pain = H.getShock()
	var/bloodloss_factor = 1
	if(CAN_HAVE_BLOOD(H))
		bloodloss_factor = clamp(1.0 - (H.get_blood_volume() / BLOOD_VOLUME_NORMAL), 0.0, 0.5)
	var/endurance_factor = clamp(2 - (GET_MOB_ATTRIBUTE_VALUE(H, STAT_ENDURANCE) / 10), 0.5, 1.5)
	var/new_pain_threshold = get_pain_threshold(current_pain * (1.0 + (bloodloss_factor * 1.4)) * endurance_factor)

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
		satisfy(H)

/// Craving fulfilled: remove penalties, stop listening, schedule the next one
/datum/quirk/vice/masochist/proc/satisfy(mob/living/carbon/human/H)
	cleanup_craving() // also removes the penalties if they were applied
	schedule_craving(rand(35 MINUTES, 45 MINUTES))

/// The grace period ran out without the craving being satisfied
/datum/quirk/vice/masochist/proc/apply_penalties()
	grace_timer = null
	if(!craving || penalties_active)
		return

	var/mob/living/carbon/human/H = owner
	if(!H)
		return

	penalties_active = TRUE
	H.add_stress(/datum/stress_event/vice)
	H.apply_status_effect(/datum/status_effect/debuff/addiction)
	to_chat(H, span_warning("The craving gnaws at me..."))

/// Tears down everything the craving set up (signals, recheck timer, flags)
/datum/quirk/vice/masochist/proc/cleanup_craving()
	craving = FALSE
	last_pain_threshold = NONE
	if(recheck_timer)
		deltimer(recheck_timer)
		recheck_timer = null
	if(grace_timer)
		deltimer(grace_timer)
		grace_timer = null
	var/mob/living/carbon/human/H = owner
	if(istype(H) && !QDELETED(H))
		UnregisterSignal(H, COMSIG_CARBON_SHOCK_UPDATED)
		if(penalties_active)
			H.remove_stress(/datum/stress_event/vice)
			H.remove_status_effect(/datum/status_effect/debuff/addiction)
	penalties_active = FALSE

/datum/quirk/vice/masochist/proc/get_pain_threshold(pain_amt)
	switch(pain_amt)
		if(-INFINITY to SHOCK_STAGE_1)
			return MASO_THRESHOLD_ONE
		if(SHOCK_STAGE_1 + 1 to SHOCK_STAGE_2)
			return MASO_THRESHOLD_TWO
		if(SHOCK_STAGE_2 + 1 to SHOCK_STAGE_3)
			return MASO_THRESHOLD_THREE
		if(SHOCK_STAGE_3 + 1 to INFINITY)
			return MASO_THRESHOLD_FOUR

#undef MASO_RECHECK_INTERVAL
#undef MASO_DEAD_RETRY_DELAY
#undef MASO_GRACE_PERIOD

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
			BP.limb_flags |= BODYPART_CHRONIC_ARTHRITIS
			BP.update_chronic()

	to_chat(H, span_warning("Your joints feel stiff and painful - a reminder of your chronic arthritis."))
	return ..()

/datum/quirk/vice/chronic_back_pain
	name = "Chronic Back Pain"
	desc = "Years of wear and tear have left you with persistent lower back pain that affects your mobility."
	point_value = 3

/datum/quirk/vice/chronic_back_pain/on_spawn()
	if(!ishuman(owner))
		return
	var/mob/living/carbon/human/H = owner
	var/obj/item/bodypart/BP = H.get_bodypart(BODY_ZONE_CHEST)
	BP?.limb_flags |= pick(BODYPART_CHRONIC_FRACTURE, BODYPART_CHRONIC_SCAR)
	BP?.update_chronic()
	to_chat(H, span_warning("Your lower back aches with familiar, persistent pain."))
	return ..()

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

	if(length(major_parts))
		for(var/rand in 1 to rand(1, 2))
			var/obj/item/bodypart/wounded = pick(major_parts)
			var/list/remove_one = list(BODYPART_CHRONIC_FRACTURE, BODYPART_CHRONIC_SCAR, BODYPART_CHRONIC_NERVE_DAMAGE)
			pick_n_take(remove_one)
			for(var/i in remove_one)
				wounded.limb_flags |= i
			wounded.update_chronic()
			var/wound_location = wounded.name
			var/wound_desc = pick("shrapnel wound", "arrow wound", "deep scar", "poorly healed fracture")
			to_chat(H, span_warning("You feel the familiar ache of your old [wound_desc] in your [wound_location]."))
	return ..()
