/mob/proc/sate_addiction()
	return

/mob/living/carbon/human/sate_addiction()
	if(istype(charflaw, /datum/charflaw/addiction))
		var/datum/charflaw/addiction/A = charflaw
		remove_stress(list(/datum/stressevent/vice1,/datum/stressevent/vice2,/datum/stressevent/vice3))
		if(!A.sated)
			to_chat(src, span_blue(A.sated_text))
		A.sated = TRUE
		A.time = initial(A.time) //reset roundstart sate offset to standard
		A.next_sate = world.time + A.time
		// remove_stress(/datum/stressevent/vice)
		if(A.debuff)
			remove_status_effect(A.debuff)

/datum/charflaw/addiction
	var/next_sate = 0
	var/sated = TRUE
	var/time = 5 MINUTES
//	var/debuff = /datum/status_effect/debuff/addiction
	var/debuff = /datum/status_effect/debuff/addiction
	var/needsate_text
	var/sated_text = "That's much better..."
	var/unsate_time


/datum/charflaw/addiction/New()
	..()
	time = rand(6 MINUTES, 30 MINUTES)
	next_sate = world.time + time

/datum/charflaw/addiction/flaw_on_life(mob/user)
	if(!ishuman(user))
		return
	if(user.mind?.antag_datums)
		for(var/datum/antagonist/D in user.mind?.antag_datums)
			if(istype(D, /datum/antagonist/vampire) || istype(D, /datum/antagonist/werewolf) || istype(D, /datum/antagonist/skeleton) || istype(D, /datum/antagonist/zombie))
				return
	var/mob/living/carbon/human/H = user
	var/oldsated = sated
	if(oldsated)
		if(next_sate)
			if(world.time > next_sate)
				sated = FALSE
	if(sated != oldsated)
		unsate_time = world.time
		if(needsate_text)
			to_chat(user, span_boldwarning("[needsate_text]"))
	if(!sated)
		var/mob/living/carbon/V = user

		switch(world.time - unsate_time)
			if(0 to 5 MINUTES)
				V.add_stress(/datum/stressevent/vice1)
				V.remove_stress(/datum/stressevent/vice2)
				V.remove_stress(/datum/stressevent/vice3)
			if(5 MINUTES to 15 MINUTES)
				V.add_stress(/datum/stressevent/vice2)
				V.remove_stress(/datum/stressevent/vice1)
				V.remove_stress(/datum/stressevent/vice3)
			if(15 MINUTES to INFINITY)
				V.add_stress(/datum/stressevent/vice3)
				V.remove_stress(/datum/stressevent/vice1)
				V.remove_stress(/datum/stressevent/vice2)
		if(debuff)
			H.apply_status_effect(debuff)



/datum/status_effect/debuff/addiction
	id = "addiction"
	alert_type = /atom/movable/screen/alert/status_effect/debuff/addiction
	effectedstats = list(STATKEY_END = -1, STATKEY_LCK = -1)
	duration = 100


/atom/movable/screen/alert/status_effect/debuff/addiction
	name = "Addiction"
	desc = ""
	icon_state = "debuff"


/// ALCOHOLIC

/datum/charflaw/addiction/alcoholic
	name = "Alcoholic"
	desc = "Drinking alcohol is my favorite thing."
	time = 40 MINUTES
	needsate_text = "Time for a drink."

/// PYROMANIAC

/datum/charflaw/addiction/pyromaniac // from tf2?
	name = "Servant of Fire"
	desc = "The warmth and just seeing something turn to ash is so much fun!"
	time = 10 MINUTES
	needsate_text = "I need to see something turn to ash, or be on fire. Anything!"

/// KLEPTOMANIAC

/datum/charflaw/addiction/kleptomaniac
	name = "Thief-borne"
	desc = "As a child I had to rely on theft to survive. Whether that changed or not, I just can't get over it."
	time = 30 MINUTES
	needsate_text = "I need to STEAL something! I'll die if I don't!"

/// PAIN FREEK

/datum/charflaw/addiction/masochist
	name = "Pain Freek"
	desc = "They call me a freek, but it just feels so good..."
	time = 25 MINUTES
	needsate_text = "I need to feel good... punch me in the face!"

/// LOVES SEEING VISCERA OR SOME SHIT

/datum/charflaw/addiction/maniac // this will probably NOT be used as an actual flaw
	name = "Maniac"
	desc = "The worms call me the maniac... I just like seeing limbs fly and blood drip, is there something so BAD about that?"
	time = 40 MINUTES // we dont wanna contribute to fragging
	needsate_text = "Where's all the blood?"

/// JUNKIE

/datum/charflaw/addiction/junkie
	name = "Junkie"
	desc = "I need a real high to take the pain of this rotten world away."
	time = 50 MINUTES
	needsate_text = "Time to reach a new high."

/// Smoker

/datum/charflaw/addiction/smoker
	name = "Smoker"
	desc = "I need to smoke something to take the edge off."
	time = 40 MINUTES
	needsate_text = "Time for a flavorful smoke."

/// GOD-FEARING

/datum/charflaw/addiction/godfearing
	name = "Devout Follower"
	desc = "I need to pray to my Patron, their blessings are stronger."
	time = 40 MINUTES
	needsate_text = "Time to pray."
