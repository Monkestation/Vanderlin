/datum/quirk/vice
	abstract_type = /datum/quirk/vice
	quirk_category = QUIRK_VICE

/datum/quirk/vice/addiction
	abstract_type = /datum/quirk/vice/addiction
	var/next_sate = 0
	var/sated = TRUE
	var/time = 5 MINUTES
	var/debuff = /datum/status_effect/debuff/addiction
	var/needsate_text
	var/sated_text = "That's much better..."
	var/unsate_time

/datum/quirk/vice/addiction/on_spawn()
	next_sate = world.time + rand(10 MINUTES, 20 MINUTES)
	return ..()

/datum/quirk/vice/addiction/on_life(mob/living/user)
	if(!ishuman(user))
		return
	var/mob/living/carbon/human/H = user
	// Skip for certain antags
	if(H.mind?.antag_datums)
		for(var/datum/antagonist/D in H.mind.antag_datums)
			if(istype(D, /datum/antagonist/vampire) || istype(D, /datum/antagonist/werewolf) || istype(D, /datum/antagonist/skeleton) || istype(D, /datum/antagonist/zombie))
				return
	var/oldsated = sated
	if(oldsated && next_sate && world.time > next_sate)
		sated = FALSE
	if(sated != oldsated)
		unsate_time = world.time
		if(needsate_text)
			to_chat(user, span_boldwarning("[needsate_text]"))
	if(!sated)
		switch(world.time - unsate_time)
			if(0 to 5 MINUTES)
				H.add_stress(/datum/stress_event/vice1)
				H.remove_stress(/datum/stress_event/vice2)
				H.remove_stress(/datum/stress_event/vice3)
			if(5 MINUTES to 15 MINUTES)
				H.add_stress(/datum/stress_event/vice2)
				H.remove_stress(/datum/stress_event/vice1)
				H.remove_stress(/datum/stress_event/vice3)
			if(15 MINUTES to INFINITY)
				H.add_stress(/datum/stress_event/vice3)
				H.remove_stress(/datum/stress_event/vice1)
				H.remove_stress(/datum/stress_event/vice2)
		if(debuff)
			H.apply_status_effect(debuff)

/mob/living/proc/sate_addiction(datum/quirk/vice/addiction/specific_vice)
	return

/mob/living/carbon/human/sate_addiction(datum/quirk/vice/addiction/specific_vice)
	specific_vice = get_quirk(specific_vice)
	if(!specific_vice || !istype(specific_vice))
		return

	remove_stress(list(/datum/stress_event/vice1, /datum/stress_event/vice2, /datum/stress_event/vice3))

	if(!specific_vice.sated)
		to_chat(src, span_blue(specific_vice.sated_text))

	specific_vice.sated = TRUE
	specific_vice.next_sate = world.time + specific_vice.time + rand(-1 MINUTES, 1 MINUTES)

	if(specific_vice.debuff)
		remove_status_effect(specific_vice.debuff)

/datum/quirk/vice/addiction/alcoholic
	name = "Drunkard"
	desc = "Drinking alcohol is my favorite thing."
	point_value = 2
	time = 30 MINUTES
	debuff = /datum/status_effect/debuff/addiction/alcoholic
	needsate_text = "Time for a drink."

/datum/quirk/vice/addiction/alcoholic/on_examined(mob/user, list/P, list/examine_contents)
	if(HAS_TRAIT(user, TRAIT_RECOGNIZE_ADDICTS))
		LAZYADDASSOCLIST(examine_contents, EXAMINE_SECT_PREGEAR, SPAN_GOD_BAOTHA("Drinker..."))

/datum/quirk/vice/addiction/smoker
	name = "Smoker"
	desc = "I need to smoke something to take the edge off."
	point_value = 3
	time = 30 MINUTES
	debuff = /datum/status_effect/debuff/addiction/smoker
	needsate_text = "Time for a flavorful smoke."

/datum/quirk/vice/addiction/smoker/on_examined(mob/user, list/P, list/examine_contents)
	if(HAS_TRAIT(user, TRAIT_RECOGNIZE_ADDICTS))
		LAZYADDASSOCLIST(examine_contents, EXAMINE_SECT_PREGEAR, SPAN_GOD_BAOTHA("Smoker..."))

/datum/quirk/vice/addiction/junkie
	name = "Junkie"
	desc = "I need a real high to take the pain of this rotten world away."
	point_value = 3
	time = 50 MINUTES
	debuff = /datum/status_effect/debuff/addiction/junkie
	needsate_text = "Time to reach a new high."

/datum/quirk/vice/addiction/junkie/on_examined(mob/user, list/P, list/examine_contents)
	if(HAS_TRAIT(user, TRAIT_RECOGNIZE_ADDICTS))
		LAZYADDASSOCLIST(examine_contents, EXAMINE_SECT_PREGEAR, SPAN_GOD_BAOTHA("Narco..."))

/datum/quirk/vice/addiction/pyromaniac
	name = "Fire Servant"
	desc = "The warmth from seeing something turn to ash is so much fun!"
	point_value = 3
	time = 10 MINUTES
	debuff = /datum/status_effect/debuff/addiction/pyromaniac
	needsate_text = "I need to see something turn to ash, or be on fire. Anything!"

/datum/quirk/vice/addiction/pyromaniac/on_examined(mob/user, list/P, list/examine_contents)
	if(HAS_TRAIT(user, TRAIT_RECOGNIZE_ADDICTS))
		LAZYADDASSOCLIST(examine_contents, EXAMINE_SECT_PREGEAR, SPAN_GOD_BAOTHA("Pyro!"))

/datum/quirk/vice/addiction/kleptomaniac
	name = "Thief-Borne"
	desc = "As a child, I had to rely on thievery to survive. Despite my circumstances changing, I just can't break old habits."
	point_value = 4
	time = 30 MINUTES
	debuff = /datum/status_effect/debuff/addiction/kleptomaniac
	needsate_text = "I need to STEAL something! I'll die if I don't!"

/datum/quirk/vice/addiction/kleptomaniac/on_examined(mob/user, list/P, list/examine_contents)
	if(HAS_TRAIT(user, TRAIT_RECOGNIZE_ADDICTS))
		LAZYADDASSOCLIST(examine_contents, EXAMINE_SECT_PREGEAR, SPAN_GOD_BAOTHA("Klepto..."))

/datum/quirk/vice/addiction/godfearing
	name = "Devout Follower"
	desc = "I need to pray to my Patron regularly, and I'm sure my prayers stand out to the gods more!"
	point_value = 1
	time = 40 MINUTES
	debuff = /datum/status_effect/debuff/addiction/godfearing
	needsate_text = "Time to pray."

/datum/quirk/vice/addiction/godfearing/on_spawn()
	. = ..()
	RegisterSignal(owner, COMSIG_EMOTE_PRAY, PROC_REF(on_owner_pray))

/datum/quirk/vice/addiction/godfearing/on_remove()
	. = ..()
	UnregisterSignal(owner, COMSIG_EMOTE_PRAY)

/datum/quirk/vice/addiction/godfearing/proc/on_owner_pray(datum/source, prayer)
	SIGNAL_HANDLER
	var/datum/patron/owner_patron = owner.patron

	if(owner_patron.hear_prayer(owner, prayer))
		owner.sate_addiction(src.type)

/datum/quirk/vice/addiction/sadist
	name = "Sadist"
	desc = "Those worms call me a monster... I just like seeing limbs fly and blood drip. Is there something so BAD about that?"
	random_exempt = TRUE
	time = 40 MINUTES
	point_value = 2
	debuff = /datum/status_effect/debuff/addiction/sadist
	needsate_text = "Where's all the blood?"

/datum/quirk/vice/addiction/sadist/on_examined(mob/user, list/P, list/examine_contents)
	if(HAS_TRAIT(user, TRAIT_RECOGNIZE_ADDICTS))
		LAZYADDASSOCLIST(examine_contents, EXAMINE_SECT_PREGEAR, SPAN_GOD_BAOTHA("Sadist..."))
