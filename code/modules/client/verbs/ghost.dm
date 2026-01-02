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

/client/proc/descend()
	set name = "Journey to the Underworld"
	set category = "Spirit"

	var/answer = browser_alert(src, "Begin the long walk in the Underworld to your judgement?", "JUDGEMENT", DEFAULT_INPUT_CHOICES)
	if(!answer || QDELETED(src) || QDELETED(mob))
		return
	if(answer == CHOICE_NO)
		to_chat(src, span_warning("You have second thoughts."))
		return
	if((mob.has_flaw(/datum/charflaw/hunted) || HAS_TRAIT(mob, TRAIT_ZIZOID_HUNTED)) && !MOBTIMER_FINISHED(mob, MT_LASTDIED, 60 SECONDS))
		to_chat(src, span_warning("Graggar's influence is currently preventing me from fleeing to the Underworld!"))
		return
	var/datum/mind/mind = mob.mind
	// Check if the player's job is hiv+
	var/datum/job/target_job = mind?.assigned_role
	if(target_job)
		if(target_job.job_reopens_slots_on_death)
			target_job.adjust_current_positions(-1)
		if(target_job.same_job_respawn_delay)
			// Store the current time for the player
			GLOB.job_respawn_delays[src.ckey] = world.time + target_job.same_job_respawn_delay
	if(ishuman(mind?.current))
		var/mob/living/carbon/human/D = mind?.current
		if(D && D.buried && D.funeral)
			mob.returntolobby()
			return
	if(!length(GLOB.underworldspiritspawns)) //That cant be good.
		to_chat(src, span_danger("You are dead. Blood is fuel. Hell is somehow full. Alert an admin, as something is very wrong!"))
		return
	var/turf/spawn_loc = pick(GLOB.underworldspiritspawns)
	var/mob/living/carbon/spirit/O = new /mob/living/carbon/spirit(spawn_loc)
	O.livingname = mob.real_name
	O.ckey = ckey
	ADD_TRAIT(O, TRAIT_PACIFISM, TRAIT_GENERIC)
	O.set_patron(prefs.selected_patron)
	SSdeath_arena.add_fighter(O, mind?.last_death)

	if(HAS_TRAIT(mind?.current, TRAIT_BURIED_COIN_GIVEN))
		O.paid = TRUE
		to_chat(src, span_biginfo("Necra has guaranteed your passage to the next life. Your toll has been already paid."))

	var/area/underworld/underworld = get_area(spawn_loc)
	underworld.Entered(O, null)
	verbs -= /client/proc/descend
