/mob/dead/observer/verb/ghost_upward()
	set name = "Ghost Up"
	set category = "Spirit"

	if(!isobserver(usr))
		return
	up()

/mob/dead/observer/verb/ghost_downward()
	set name = "Ghost Down"
	set category = "Spirit"

	if(!isobserver(usr))
		return
	down()

/mob/verb/descend_to_underworld()
	set name = "Journey to the Underworld"
	set category = "IC"

	if(can_enter_underworld())
		enter_underworld()

/mob/dead/observer/verb/dead_to_underworld()
	set name = "Journey to the Underworld"
	set category = "Spirit"

	if(can_enter_underworld())
		enter_underworld()

/mob/proc/enter_underworld()
	// Check if the player's job is hiv+
	var/datum/job/target_job = mind?.assigned_role
	if(target_job)
		if(target_job.job_reopens_slots_on_death)
			target_job.adjust_current_positions(-1)
		if(target_job.same_job_respawn_delay)
			// Store the current time for the player
			GLOB.job_respawn_delays[src.ckey] = world.time + target_job.same_job_respawn_delay

	var/mob/living/carbon/human/dead_hum
	var/has_coin = FALSE // We check here since we will be moving them to a spirit, if this is TRUE, they had a coin in their mouth and have payment for toll
	if(!QDELETED(mind.current))
		if(ishuman(mind.current))
			dead_hum = mind.current // We use this later since we will give a prompt, and we dont want the rest of the code to sleep
		if(HAS_TRAIT(mind.current, TRAIT_BURIED_COIN_GIVEN))
			has_coin = TRUE

	var/turf/spawn_loc = pick(GLOB.underworldspiritspawns)
	var/mob/living/carbon/spirit/live_spirit = new /mob/living/carbon/spirit(spawn_loc)
	live_spirit.livingname = real_name
	live_spirit.ckey = ckey
	ADD_TRAIT(live_spirit, TRAIT_PACIFISM, TRAIT_GENERIC)

	live_spirit.set_patron(live_spirit.client.prefs.selected_patron)

	if(has_coin)
		live_spirit.paid = TRUE
		to_chat(live_spirit.client, span_biginfo("Necra has guaranteed your passage to the next life. Your toll has been already paid."))
	else
		SSdeath_arena.add_fighter(live_spirit, mind?.last_death)

	var/area/underworld/underworld = get_area(spawn_loc)
	underworld.Entered(live_spirit, null)

	// If ghost was human, allow them to pick last words if they did not before.
	if(dead_hum)
		if(!dead_hum.funeral && !dead_hum.final_words)
			var/final_words = tgui_input_text(live_spirit, "Any final words you want to have imparted if your old body ever finds rest? (DO NOT USE THIS TO STATE WHO ATTACKED YOU)", "Final Words (Optional)", max_length=75)
			if(final_words)
				dead_hum.final_words = final_words
				log_say("[src] put [final_words] for their final words.")

/mob/proc/can_enter_underworld()
	if(stat < DEAD && !mind.has_antag_datum(/datum/antagonist/zombie))
		to_chat(src, span_danger("You are not dead!"))
		return FALSE

	if(!length(GLOB.underworldspiritspawns)) //That cant be good.
		to_chat(src, span_danger("You are dead. Blood is fuel. Hell is somehow full. Alert an admin, as something is very wrong!"))
		return FALSE

	if(isliving(src))
		var/mob/living/live_one = src
		if(live_one.has_quirk(/datum/quirk/vice/hardcore))
			SEND_SIGNAL(live_one, COMSIG_LIVING_TRY_ENTER_AFTERLIFE)
			return FALSE

		if((live_one.has_quirk(/datum/quirk/vice/hunted) || HAS_TRAIT(src, TRAIT_ZIZOID_HUNTED)) && !MOBTIMER_FINISHED(src, MT_LASTDIED, 60 SECONDS))
			to_chat(src, span_warning("Graggar's influence is currently preventing me from fleeing to the Underworld!"))
			return FALSE

	var/answer = tgui_alert(src, "Begin the long walk in the Underworld to your judgement?", "JUDGEMENT", DEFAULT_INPUT_CHOICES)
	if(!answer || QDELETED(src))
		return FALSE
	if(answer == CHOICE_NO)
		to_chat(src, span_warning("You have second thoughts."))
		return FALSE

	return TRUE
