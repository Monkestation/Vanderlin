/mob/dead/observer/verb/ghost_upward()
	set name = "Ghost Up"
	set category = "Spirit"

	if(!isobserver(usr))
		return

	ghost_up()

/mob/dead/observer/verb/ghost_downward()
	set name = "Ghost Down"
	set category = "Spirit"

	if(!isobserver(usr))
		return

	ghost_down()


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

	if(ishuman(src))
		var/mob/living/carbon/human/dead_hum = src
		if(dead_hum.buried && dead_hum.funeral)
			dead_hum.returntolobby()
			return TRUE

	var/turf/spawn_loc = pick(GLOB.underworldspiritspawns)
	var/mob/living/carbon/spirit/live_spirit = new /mob/living/carbon/spirit(spawn_loc)
	live_spirit.livingname = real_name
	live_spirit.ckey = ckey
	ADD_TRAIT(live_spirit, TRAIT_PACIFISM, TRAIT_GENERIC)
	live_spirit.set_patron(client.prefs.selected_patron)
	SSdeath_arena.add_fighter(live_spirit, mind?.last_death)

	if(HAS_TRAIT(mind?.current, TRAIT_BURIED_COIN_GIVEN))
		live_spirit.paid = TRUE
		to_chat(client, span_biginfo("Necra has guaranteed your passage to the next life. Your toll has been already paid."))

	var/area/underworld/underworld = get_area(spawn_loc)
	underworld.Entered(live_spirit, null)

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
