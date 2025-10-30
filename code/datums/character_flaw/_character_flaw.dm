
GLOBAL_LIST_INIT(character_flaws, list(
	"Alcoholic" = /datum/charflaw/addiction/alcoholic,
	"Devout Follower" = /datum/charflaw/addiction/godfearing,
	"Pacifist" = /datum/charflaw/pacifist,
	"Smoker" = /datum/charflaw/addiction/smoker,
	"Junkie" = /datum/charflaw/addiction/junkie,
	"Cyclops (R)" = /datum/charflaw/noeyer,
	"Cyclops (L)" = /datum/charflaw/noeyel,
	"Tongueless" = /datum/charflaw/tongueless,
	"Greedy" = /datum/charflaw/greedy,
	"Narcoleptic" = /datum/charflaw/narcoleptic,
	"Masochist" = /datum/charflaw/masochist,
	"Wooden Arm (R)" = /datum/charflaw/limbloss/arm_r,
	"Wooden Arm (L)" = /datum/charflaw/limbloss/arm_l,
	"Bad Sight" = /datum/charflaw/badsight,
	"Paranoid" = /datum/charflaw/paranoid,
	"Clingy" = /datum/charflaw/clingy,
	"Isolationist" = /datum/charflaw/isolationist,
	"Fire Servant" = /datum/charflaw/addiction/pyromaniac,
	"Thief-Borne" = /datum/charflaw/addiction/kleptomaniac,
	"Hunted" = /datum/charflaw/hunted,
	"Chronic Migraines" = /datum/charflaw/chronic_migraine,
	"Chronic Back Pain" = /datum/charflaw/chronic_back_pain,
	"Old War Wound" = /datum/charflaw/old_war_wound,
	"Chronic Arthritis" = /datum/charflaw/chronic_arthritis,
	"Luxless" = /datum/charflaw/lux_taken,
	"Witless Pixie" = /datum/charflaw/witless_pixie,
	"Random Flaw or No Flaw"=/datum/charflaw/randflaw,
	"Guaranteed No Flaw (3 TRI)"=/datum/charflaw/noflaw,
))

/datum/charflaw
	abstract_type = /datum/charflaw
	/// Fluff name
	var/name
	/// Fluff desc
	var/desc
	/// This flaw is currently disabled and will not process
	var/ephemeral = FALSE
	/// The mob affected by the character flaw
	var/mob/owner
	/// Flaw is exempt from random picks
	var/random_exempt = FALSE

/datum/charflaw/New(mob/new_owner)
	. = ..()
	if(new_owner)
		owner = new_owner
		on_mob_creation(owner)

/datum/charflaw/Destroy()
	on_remove()
	return ..()

/// Applies when the user mob is created without mind
/datum/charflaw/proc/on_mob_creation(mob/user)
	return

/// Aplies after the user mob is fully spawned and has mind
/datum/charflaw/proc/after_spawn(mob/user, client/mob_client)
	return

/// Applies when the flaw is deleted
/datum/charflaw/proc/on_remove()
	return

/mob/proc/get_flaw(flaw_type)
	return

/mob/living/carbon/human/get_flaw(flaw_type)
	if(!flaw_type)
		return
	if(charflaw != flaw_type)
		return
	return charflaw

/datum/charflaw/proc/flaw_on_life(mob/user)
	return

/mob/proc/has_flaw(flaw)
	return

/mob/living/carbon/human/has_flaw(flaw)
	if(!flaw)
		return
	if(istype(charflaw, flaw))
		return TRUE

/// Replaces humans's flaw with a random one excluding no flaw
/mob/living/carbon/human/proc/get_random_flaw()
	var/list/flaws = list()
	for(var/datum/charflaw/flaw as anything in subtypesof(/datum/charflaw))
		if(is_abstract(flaw))
			continue
		if(initial(flaw.random_exempt))
			continue
		flaws += flaw

	set_flaw(pick(flaws))

/mob/living/carbon/human/proc/set_flaw(datum/charflaw/flaw, after_spawn = TRUE)
	if(!flaw)
		return

	if(charflaw)
		QDEL_NULL(charflaw)

	charflaw = new flaw(src)

	if(after_spawn)
		charflaw.after_spawn(src)

/datum/charflaw/randflaw
	name = "Random Flaw"
	desc = "Chooses a random flaw (50% chance for no flaw)"
	random_exempt = TRUE

/datum/charflaw/randflaw/after_spawn(mob/user)
	. = ..()
	if(!ishuman(user))
		return
	var/mob/living/carbon/human/H = user
	if(prob(50))
		H.get_random_flaw()
	else
		H.set_flaw(/datum/charflaw/eznoflaw)

/datum/charflaw/eznoflaw
	name = "No Flaw"
	desc = "I'm a normal person, how rare!"
	random_exempt = TRUE

/datum/charflaw/noflaw
	name = "No Flaw (3 TRI)"
	desc = "I'm a normal person, how rare! (Consumes 3 triumphs or randomizes)"
	random_exempt = TRUE

/datum/charflaw/noflaw/after_spawn(mob/user, client/mob_client)
	. = ..()
	if(!ishuman(user))
		return
	var/mob/living/carbon/human/H = user
	var/triumphs = get_triumph_amount(mob_client.ckey)
	if(triumphs >= 3)
		adjust_triumphs(mob_client.ckey, -3)
		H.set_flaw(/datum/charflaw/eznoflaw)
		return
	H.get_random_flaw()

/datum/charflaw/badsight
	name = "Bad Eyesight"
	desc = "I need spectacles to see normally from my years spent reading books."

/datum/charflaw/badsight/after_spawn(mob/user)
	. = ..()
	user.adjust_skillrank(/datum/skill/misc/reading, 1, TRUE)

/datum/charflaw/badsight/flaw_on_life(mob/user)
	if(!ishuman(user))
		return
	var/mob/living/carbon/human/H = user
	if(H.wear_mask)
		if(isclothing(H.wear_mask))
			if(istype(H.wear_mask, /obj/item/clothing/face/spectacles))
				var/obj/item/I = H.wear_mask
				if(!I.obj_broken)
					return
	H.blur_eyes(2)
	H.apply_status_effect(/datum/status_effect/debuff/badvision)

/datum/status_effect/debuff/badvision
	id = "badvision"
	alert_type = null
	effectedstats = list(STATKEY_PER = -20, STATKEY_SPD = -5, STATKEY_LCK = -20)
	duration = 100

/datum/charflaw/badsight/after_spawn(mob/user)
	. = ..()
	if(!ishuman(user))
		return
	var/mob/living/carbon/human/H = user
	if(H.wear_mask)
		var/type = H.wear_mask.type
		QDEL_NULL(H.wear_mask)
		H.put_in_hands(new type(get_turf(H)))
	H.equip_to_slot_or_del(new /obj/item/clothing/face/spectacles(H), ITEM_SLOT_MASK)

/datum/charflaw/paranoid
	name = "Paranoid"
	desc = "I'm even more anxious than most towners. I'm extra paranoid of other species, the price of higher intelligence."
	var/last_check = 0

/datum/charflaw/paranoid/flaw_on_life(mob/user)
	if(world.time < last_check + 10 SECONDS)
		return
	if(!user)
		return
	last_check = world.time
	var/cnt = 0
	for(var/mob/living/carbon/human/L in hearers(7, user))
		if(L == src)
			continue
		if(L.stat)
			continue
		if(L.dna?.species)
			if(ishuman(user))
				var/mob/living/carbon/human/H = user
				if(L.dna.species.id != H.dna.species.id)
					cnt++
		if(cnt > 2)
			break
	var/mob/living/carbon/P = user
	if(cnt > 2)
		P.add_stress(/datum/stress_event/paracrowd)
	cnt = 0
	for(var/obj/effect/decal/cleanable/blood/B in view(7, user))
		cnt++
		if(cnt > 3)
			break
	if(cnt > 6)
		P.add_stress(/datum/stress_event/parablood)

/datum/charflaw/isolationist
	name = "Isolationist"
	desc = "I don't like being near people. They might be trying to do something to me..."
	var/last_check = 0

/datum/charflaw/isolationist/flaw_on_life(mob/user)
	. = ..()
	if(world.time < last_check + 10 SECONDS)
		return
	if(!user)
		return
	last_check = world.time
	var/cnt = 0
	for(var/mob/living/carbon/human/L in hearers(7, user))
		if(L == src)
			continue
		if(L.stat)
			continue
		if(L.dna.species)
			cnt++
		if(cnt > 2)
			break
	var/mob/living/carbon/P = user
	if(cnt > 2)
		P.add_stress(/datum/stress_event/crowd)

/datum/charflaw/clingy
	name = "Clingy"
	desc = "I like being around people, it's just so lively..."
	var/last_check = 0

/datum/charflaw/clingy/flaw_on_life(mob/user)
	. = ..()
	if(world.time < last_check + 10 SECONDS)
		return
	if(!user)
		return
	last_check = world.time
	var/cnt = 0
	for(var/mob/living/carbon/human/L in hearers(7, user))
		if(L == src)
			continue
		if(L.stat)
			continue
		if(L.dna.species)
			cnt++
		if(cnt > 2)
			break
	var/mob/living/carbon/P = user
	if(cnt < 2)
		P.add_stress(/datum/stress_event/nopeople)

/datum/charflaw/noeyer
	name = "Cyclops (R)"
	desc = "I lost my right eye long ago. But it made me great at noticing things."

/datum/charflaw/noeyer/after_spawn(mob/user)
	. = ..()
	if(!ishuman(user))
		return
	var/mob/living/carbon/human/H = user
	if(H.wear_mask)
		var/type = H.wear_mask.type
		QDEL_NULL(H.wear_mask)
		H.put_in_hands(new type(get_turf(H)))
	H.equip_to_slot_or_del(new /obj/item/clothing/face/eyepatch(H), ITEM_SLOT_MASK)

	var/obj/item/bodypart/head/head = H.get_bodypart(BODY_ZONE_HEAD)
	head?.add_wound(/datum/wound/facial/eyes/right/permanent)
	H.update_fov_angles()

/datum/charflaw/noeyel
	name = "Cyclops (L)"
	desc = "I lost my left eye long ago. But it made me great at noticing things."

/datum/charflaw/noeyel/after_spawn(mob/user)
	. = ..()
	if(!ishuman(user))
		return
	var/mob/living/carbon/human/H = user
	if(H.wear_mask)
		var/type = H.wear_mask.type
		QDEL_NULL(H.wear_mask)
		H.put_in_hands(new type(get_turf(H)))
	H.equip_to_slot_or_del(new /obj/item/clothing/face/eyepatch/left(H), ITEM_SLOT_MASK)

	var/obj/item/bodypart/head/head = H.get_bodypart(BODY_ZONE_HEAD)
	head?.add_wound(/datum/wound/facial/eyes/left/permanent)
	H.update_fov_angles()

/datum/charflaw/noeyerandom
	name = "Cyclops (Random)"
	desc = "I lost my eye long ago. But it made me great at noticing things."

/datum/charflaw/noeyerandom/after_spawn(mob/user)
	. = ..()
	if(ishuman(user))
		var/mob/living/carbon/human/H = user
		if(prob(50))
			H.set_flaw(/datum/charflaw/noeyel)
		else
			H.set_flaw(/datum/charflaw/noeyer)

/datum/charflaw/tongueless
	name = "Tongueless"
	desc = "I said one word too many to a noble, they cut out my tongue.\n\
	(Being mute is not an excuse to forego roleplay. Use of custom emotes is recommended.)"

/datum/charflaw/tongueless/on_mob_creation(mob/user)
	. = ..()
	if(!ishuman(user))
		return
	var/mob/living/carbon/human/H = user
	var/obj/item/bodypart/head/head = H.get_bodypart(BODY_ZONE_HEAD)
	head?.add_wound(/datum/wound/facial/tongue/permanent)

/datum/charflaw/hunted
	name = "Hunted"
	desc = "Something in my past has made me a target. I'm always looking over my shoulder.	\
	\nTHIS IS A DIFFICULT FLAW, YOU WILL BE HUNTED AND HAVE ASSASINATION ATTEMPTS MADE AGAINST YOU WITHOUT ANY ESCALATION. \
	EXPECT A MORE DIFFICULT EXPERIENCE. PLAY AT YOUR OWN RISK."
	var/logged = FALSE

/datum/charflaw/hunted/flaw_on_life(mob/user)
	if(!ishuman(user))
		return
	var/mob/living/carbon/human/H = user
	if(logged == FALSE)
		if(H.name) // If you don't check this, the log entry wont have a name as flaw_on_life is checked at least once before the name is set.
			log_hunted("[H.ckey] playing as [H.name] had the hunted flaw by vice.")
			logged = TRUE


/datum/charflaw/greedy
	name = "Greedy"
	desc = "I can't get enough of mammons, I need more and more!"
	var/last_checked_mammons = 0
	var/required_mammons = 0
	var/next_mammon_increase = 0
	var/last_passed_check = 0
	var/first_tick = FALSE
	var/extra_increment_value = 0

/datum/charflaw/greedy/on_mob_creation(mob/user)
	next_mammon_increase = world.time + rand(15 MINUTES, 25 MINUTES)
	last_passed_check = world.time

/datum/charflaw/greedy/flaw_on_life(mob/user)
	if(!first_tick)
		determine_starting_mammons(user)
		first_tick = TRUE
		return
	if(world.time >= next_mammon_increase)
		mammon_increase(user)
	mammon_check(user)

/datum/charflaw/greedy/proc/determine_starting_mammons(mob/living/carbon/human/user)
	var/starting_mammons = get_mammons_in_atom(user)
	required_mammons = round(starting_mammons * 0.7)
	extra_increment_value = round(starting_mammons * 0.15)

/datum/charflaw/greedy/proc/mammon_increase(mob/living/carbon/human/user)
	if(last_passed_check + (50 MINUTES) < world.time) //If we spend a REALLY long time without being able to satisfy, then pity downgrade
		required_mammons -= rand(10, 20)
		to_chat(user, span_blue("Maybe a little less mammons is enough..."))
	else
		required_mammons += rand(25, 35) + extra_increment_value
	required_mammons = min(required_mammons, 250) //Cap at 250 coins maximum
	next_mammon_increase = world.time + rand(35 MINUTES, 40 MINUTES)
	var/current_mammons = get_mammons_in_atom(user)
	if(current_mammons >= required_mammons)
		to_chat(user, span_blue("I'm quite happy with the amount of mammons I have..."))
	else
		to_chat(user, span_boldwarning("I need more mammons, what I have is not enough..."))

	last_checked_mammons = current_mammons

/datum/charflaw/greedy/proc/mammon_check(mob/living/carbon/human/user)
	var/new_mammon_amount = get_mammons_in_atom(user)
	var/ascending = (new_mammon_amount > last_checked_mammons)

	var/do_update_msg = TRUE
	if(new_mammon_amount >= required_mammons)
		// Feel better
		if(user.has_stress_type(/datum/stress_event/vice))
			to_chat(user, span_blue("[new_mammon_amount] mammons... That's more like it.."))
		user.remove_stress(/datum/stress_event/vice)
		user.remove_status_effect(/datum/status_effect/debuff/addiction)
		last_passed_check = world.time
		do_update_msg = FALSE
	else
		// Feel bad
		user.add_stress(/datum/stress_event/vice)
		user.apply_status_effect(/datum/status_effect/debuff/addiction)

	if(new_mammon_amount == last_checked_mammons)
		do_update_msg = FALSE

	if(do_update_msg)
		if(ascending)
			to_chat(user, span_warning("Only [new_mammon_amount] mammons.. I need more..."))
		else
			to_chat(user, span_boldwarning("No! My precious mammons..."))

	last_checked_mammons = new_mammon_amount

/datum/charflaw/narcoleptic
	name = "Narcoleptic"
	desc = "I get drowsy during the day and tend to fall asleep suddenly, but I can sleep easier if I want to, and moon dust can help me stay awake."
	var/last_unconsciousness = 0
	var/next_sleep = 0
	var/concious_timer = (10 MINUTES)
	var/do_sleep = FALSE
	var/pain_pity_charges = 3
	var/drugged_up = FALSE

/datum/charflaw/narcoleptic/on_mob_creation(mob/user)
	ADD_TRAIT(user, TRAIT_FASTSLEEP, "[type]")
	reset_timer()

/datum/charflaw/narcoleptic/proc/reset_timer()
	do_sleep = FALSE
	last_unconsciousness = world.time
	concious_timer = rand(7 MINUTES, 15 MINUTES)
	pain_pity_charges = rand(2,4)

/datum/charflaw/narcoleptic/flaw_on_life(mob/living/carbon/human/user)
	if(user.stat != CONSCIOUS)
		reset_timer()
		return
	if(do_sleep)
		if(next_sleep <= world.time)
			var/pain = user.get_complex_pain()
			if(pain >= 40 && pain_pity_charges > 0)
				pain_pity_charges--
				concious_timer = rand(1 MINUTES, 2 MINUTES)
				to_chat(user, span_warning("The pain keeps me awake..."))
			else
				if(prob(40) || drugged_up)
					drugged_up = FALSE
					concious_timer = rand(4 MINUTES, 6 MINUTES)
					to_chat(user, span_info("The feeling has passed."))
				else
					concious_timer = rand(7 MINUTES, 15 MINUTES)
					to_chat(user, span_boldwarning("I can't keep my eyes open any longer..."))
					user.Sleeping(rand(30 SECONDS, 50 SECONDS))
					user.visible_message(span_warning("[user] suddenly collapses!"))
			do_sleep = FALSE
			last_unconsciousness = world.time
	else
		// Been conscious for ~10 minutes (whatever is the conscious timer)
		if(last_unconsciousness + concious_timer < world.time)
			drugged_up = FALSE
			to_chat(user, span_blue("I'm getting drowsy..."))
			user.emote("yawn", forced = TRUE)
			next_sleep = world.time + rand(7 SECONDS, 11 SECONDS)
			do_sleep = TRUE

/proc/narcolepsy_drug_up(mob/living/living)
	var/datum/charflaw/narcoleptic/narco = living.get_flaw(/datum/charflaw/narcoleptic)
	if(!narco)
		return
	narco.drugged_up = TRUE

#define MASO_THRESHOLD_ONE 1
#define MASO_THRESHOLD_TWO 2
#define MASO_THRESHOLD_THREE 3
#define MASO_THRESHOLD_FOUR 4

/datum/charflaw/masochist
	name = "Masochist"
	desc = "I love the feeling of pain, so much I can't get enough of it."
	var/next_paincrave = 0
	var/last_pain_threshold = NONE

/datum/charflaw/masochist/on_mob_creation(mob/living/carbon/human/user)
	next_paincrave = world.time + rand(15 MINUTES, 25 MINUTES)

/datum/charflaw/masochist/flaw_on_life(mob/living/carbon/human/user)
	if(next_paincrave > world.time)
		last_pain_threshold = NONE
		return
	user.add_stress(/datum/stress_event/vice)
	user.apply_status_effect(/datum/status_effect/debuff/addiction)
	var/current_pain = user.get_complex_pain()
	// Bloodloss makes the pain count as extra large to allow people to bloodlet themselves with cutting weapons to satisfy vice
	var/bloodloss_factor = clamp(1.0 - (user.blood_volume / BLOOD_VOLUME_NORMAL), 0.0, 0.5)
	var/new_pain_threshold = get_pain_threshold(current_pain * (1.0 + (bloodloss_factor * 1.4)) * clamp(2 - (user.STAEND / 10), 0.5, 1.5)) // Bloodloss factor goes up to 50%, and then counts at 140% value of that
	if(last_pain_threshold == NONE)
		to_chat(user, span_boldwarning("I could really use some pain right now..."))
	else if (new_pain_threshold != last_pain_threshold)
		var/ascending = (new_pain_threshold > last_pain_threshold)
		switch(new_pain_threshold)
			if(MASO_THRESHOLD_ONE)
				to_chat(user, span_warning("The pain is gone..."))
			if(MASO_THRESHOLD_TWO)
				if(ascending)
					to_chat(user, span_blue("Yes, more pain!"))
				else
					to_chat(user, span_warning("No, my pain!"))
			if(MASO_THRESHOLD_THREE)
				to_chat(user, span_blue("More, I love it!"))

	last_pain_threshold = new_pain_threshold
	if(new_pain_threshold == MASO_THRESHOLD_FOUR)
		to_chat(user, span_blue("<b>That's more like it...</b>"))
		next_paincrave = world.time + rand(35 MINUTES, 45 MINUTES)
		user.remove_stress(/datum/stress_event/vice)
		user.remove_status_effect(/datum/status_effect/debuff/addiction)


/datum/charflaw/masochist/proc/get_pain_threshold(pain_amt)
	switch(pain_amt)
		if(-INFINITY to 25)
			return MASO_THRESHOLD_ONE
		if(25 to 50)
			return MASO_THRESHOLD_TWO
		if(50 to 95)
			return MASO_THRESHOLD_THREE
		if(95 to INFINITY)
			return MASO_THRESHOLD_FOUR

/proc/get_mammons_in_atom(atom/movable/movable)
	var/static/list/coins_types = typecacheof(/obj/item/coin)
	var/mammons = 0
	if(coins_types[movable.type])
		var/obj/item/coin/coin = movable
		mammons += coin.quantity * coin.sellprice
	for(var/atom/movable/content in movable.contents)
		mammons += get_mammons_in_atom(content)
	return mammons

/datum/charflaw/pacifist
	name = "Pacifist"
	desc = "I don't want to harm other living beings!"

/datum/charflaw/pacifist/after_spawn(mob/user, force = FALSE)
	var/mob/living/carbon/human/human_user = user
	if(!force && ((human_user.mind in GLOB.pre_setup_antags) || human_user.mind.has_antag_datum(/datum/antagonist)))
		human_user.get_random_flaw()
		human_user?.charflaw.after_spawn(human_user)
	else
		. = ..()
		ADD_TRAIT(user, TRAIT_PACIFISM, "[type]")

/datum/charflaw/pacifist/on_remove()
	. = ..()
	REMOVE_TRAIT(owner, TRAIT_PACIFISM, "[type]")

/datum/charflaw/chronic_arthritis
	name = "Chronic Arthritis"
	desc = "Your joints ache constantly, causing periodic pain flares and reduced mobility."

/datum/charflaw/chronic_arthritis/on_mob_creation(mob/user)
	if(ishuman(user))
		var/mob/living/carbon/human/H = user
		// Apply arthritis to random joints (hands, feet, arms, legs)
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

		to_chat(user, span_warning("Your joints feel stiff and painful - a reminder of your chronic arthritis."))

/datum/charflaw/chronic_arthritis/flaw_on_life(mob/user)
	if(!ishuman(user))
		return

	var/mob/living/carbon/human/H = user

	// Periodic pain flares
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

	// Weather sensitivity
	if(prob(1) && H.loc)
		if(SSParticleWeather.runningWeather && SSParticleWeather.runningWeather.can_weather(H))
			for(var/obj/item/bodypart/BP in H.bodyparts)
				if(BP.chronic_pain_type == CHRONIC_ARTHRITIS && prob(30))
					BP.lingering_pain += rand(5, 10)
					to_chat(H, span_warning("The weather makes your arthritis act up."))
					break

/datum/charflaw/old_war_wound
	name = "Old War Wound"
	desc = "An old injury from your past still haunts you, causing chronic pain and occasional flare-ups."

/datum/charflaw/old_war_wound/on_mob_creation(mob/user)
	if(ishuman(user))
		var/mob/living/carbon/human/H = user
		// Pick a random major bodypart for the old wound
		var/list/major_parts = list()
		for(var/obj/item/bodypart/BP in H.bodyparts)
			if(BP.body_zone in list(BODY_ZONE_CHEST, BODY_ZONE_L_ARM, BODY_ZONE_R_ARM, BODY_ZONE_L_LEG, BODY_ZONE_R_LEG))
				major_parts += BP

		if(major_parts.len)
			var/obj/item/bodypart/wounded = pick(major_parts)
			wounded.chronic_pain = rand(10, 17.5)
			wounded.chronic_pain_type = pick(CHRONIC_OLD_FRACTURE, CHRONIC_SCAR_TISSUE, CHRONIC_NERVE_DAMAGE)
			wounded.brute_dam += rand(3, 8) // Some permanent damage

			var/wound_location = wounded.name
			var/wound_desc = pick("shrapnel wound", "old arrow wound", "deep scar", "poorly healed fracture")
			to_chat(user, span_warning("You feel the familiar ache of your old [wound_desc] in your [wound_location]."))

/datum/charflaw/old_war_wound/flaw_on_life(mob/user)
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

/datum/charflaw/chronic_migraine
	name = "Chronic Migraines"
	desc = "You suffer from frequent, debilitating headaches that can strike without warning."

/datum/charflaw/chronic_migraine/on_mob_creation(mob/user)
	if(ishuman(user))
		var/mob/living/carbon/human/H = user
		// Apply chronic pain to head
		for(var/obj/item/bodypart/BP in H.bodyparts)
			if(BP.body_zone == BODY_ZONE_HEAD)
				BP.chronic_pain = rand(17.5, 27.5)
				BP.chronic_pain_type = CHRONIC_NERVE_DAMAGE
				break

		to_chat(user, span_warning("You feel the familiar pressure building behind your eyes."))

/datum/charflaw/chronic_migraine/flaw_on_life(mob/user)
	if(!ishuman(user))
		return

	var/mob/living/carbon/human/H = user

	// Migraine attacks
	if(prob(2))
		for(var/obj/item/bodypart/BP in H.bodyparts)
			if(BP.body_zone == BODY_ZONE_HEAD)
				BP.lingering_pain += rand(25, 40)
				break

		// Severe migraine effects
		if(prob(30)) // 30% chance of severe episode
			H.blur_eyes(rand(3, 6))
			to_chat(H, span_boldwarning("A severe migraine strikes! Your vision blurs and your head pounds!"))
		else
			to_chat(H, span_warning("A migraine headache begins to build."))

	// Light sensitivity during migraines
	if(prob(1))
		var/obj/item/bodypart/head = null
		for(var/obj/item/bodypart/BP in H.bodyparts)
			if(BP.body_zone == BODY_ZONE_HEAD)
				head = BP
				break

		if(head && head.lingering_pain > 20)
			if(H.loc && H.loc.luminosity > 2)
				head.lingering_pain += rand(5, 10)
				to_chat(H, span_warning("The flickering flames make your migraine worse!"))

/datum/charflaw/chronic_back_pain
	name = "Chronic Back Pain"
	desc = "Years of wear and tear have left you with persistent lower back pain that affects your mobility."

/datum/charflaw/chronic_back_pain/on_mob_creation(mob/user)
	if(ishuman(user))
		var/mob/living/carbon/human/H = user
		// Apply chronic pain to chest/torso area
		for(var/obj/item/bodypart/BP in H.bodyparts)
			if(BP.body_zone == BODY_ZONE_CHEST)
				BP.chronic_pain = rand(20, 32.5)
				BP.chronic_pain_type = pick(CHRONIC_OLD_FRACTURE, CHRONIC_SCAR_TISSUE)
				break

		to_chat(user, span_warning("Your lower back aches with familiar, persistent pain."))

/datum/charflaw/chronic_back_pain/flaw_on_life(mob/user)
	if(!ishuman(user))
		return

	var/mob/living/carbon/human/H = user

	// Movement-triggered pain
	if(H.m_intent == MOVE_INTENT_RUN && prob(5))
		for(var/obj/item/bodypart/BP in H.bodyparts)
			if(BP.body_zone == BODY_ZONE_CHEST)
				BP.lingering_pain += rand(3, 5)
				to_chat(H, span_warning("Running aggravates your chronic back pain!"))
				break

	// Lifting/exertion pain
	if(prob(2))
		var/encumbrance = H.get_encumbrance()
		if(encumbrance >= 0.5) // Moderate encumbrance threshold
			for(var/obj/item/bodypart/BP in H.bodyparts)
				if(BP.body_zone == BODY_ZONE_CHEST)
					var/pain_amount = rand(8, 15)
					if(encumbrance >= 0.8) // Heavy encumbrance
						pain_amount = rand(15, 25)
						to_chat(H, span_warning("Your heavy gear puts severe strain on your already painful back!"))
					else
						to_chat(H, span_warning("The weight of your equipment aggravates your chronic back pain!"))
					BP.lingering_pain += pain_amount
					break

/datum/charflaw/lux_taken
	name = "Lux-less"
	desc = "Through some grand misfortune, or heroic sacrifice- you have given up your link to Psydon, and with it- your soul. A putrid, horrid thing, you cosign yourself to an eternity of nil after death. Perhaps you are fine with this. \
	\n\n EXPECT A DIFFICULT, MECHANICALLY UNFAIR EXPERIENCE. \n Rakshari, Hollowkin and Kobolds do not apply, given they already have no lux. "

/datum/charflaw/lux_taken/after_spawn(mob/user)
	if(!ishuman(user))
		return

	var/mob/living/carbon/human/H = user

	// If they don't have lux randomize them
	if(H.dna?.species?.id in RACES_PLAYER_LUXLESS)
		H.get_random_flaw()
		return
	H.apply_status_effect(/datum/status_effect/debuff/flaw_lux_taken)

/datum/charflaw/witless_pixie
	name = "Witless Pixie"
	desc = "By some cruel twist of fate, you have been born a dainty-minded, dim-witted klutz. Yours is a life of constant misdirection, confusion and general incompetence. \
	\nIt is no small blessing your dazzling looks make up for this, sometimes. \n\nSometimes... they do you no favours at all."

/datum/charflaw/witless_pixie/on_mob_creation(mob/user)
	if(!ishuman(user))
		return
	var/mob/living/L = user

	L.adjust_stat_modifier("[REF(src)]", STATKEY_INT, rand(-2, -5)) //this would probably make the average manorc a vegetable

/datum/charflaw/witless_pixie/after_spawn(mob/user)
	if(!ishuman(user))
		return

	//solves edgecases with inbred princes and eoran hand-holders. Yes, you can be an ugly Eoran templar. You are not safe.
	REMOVE_TRAIT(user, TRAIT_BEAUTIFUL, TRAIT_GENERIC)
	REMOVE_TRAIT(user, TRAIT_UGLY, TRAIT_GENERIC)
	REMOVE_TRAIT(user, TRAIT_FISHFACE, TRAIT_GENERIC)

	if(prob(50))
		ADD_TRAIT(user, TRAIT_BEAUTIFUL, TRAIT_GENERIC)
	else if(prob(30))
		ADD_TRAIT(user, TRAIT_UGLY, TRAIT_GENERIC)
