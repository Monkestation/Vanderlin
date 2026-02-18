///How confused a carbon must be before they will not vomit
#define BEYBLADE_PUKE_THRESHOLD (0 SECONDS)
///How must nutrition is lost when a carbon pukes
#define BEYBLADE_PUKE_NUTRIENT_LOSS 60
///How often a carbon becomes penalized
#define BEYBLADE_DIZZINESS_PROBABILITY 20
///How long the screenshake lasts
#define BEYBLADE_DIZZINESS_DURATION (10 SECONDS)
///How much confusion a carbon gets every time they are penalized
#define BEYBLADE_CONFUSION_INCREMENT (5 SECONDS)
///A max for how much confusion a carbon will be for beyblading
#define BEYBLADE_CONFUSION_LIMIT (20 SECONDS)

//The code execution of the emote datum is located at code/datums/emotes.dm
/mob/proc/emote(act, m_type = null, message = null, intentional = FALSE, forced = FALSE, targetted = FALSE, custom_me = FALSE)
	var/oldact = act
	act = lowertext(act)
	var/param = message
	var/custom_param = findchar(act, " ")
//	if(custom_param)
//		param = copytext(act, custom_param + 1, length(act) + 1)
//		act = copytext(act, 1, custom_param)

	if(intentional || !forced)
		if(custom_me)
			if(world.time < next_me_emote)
				return
		else
			if(world.time < next_emote)
				return

	var/list/key_emotes = GLOB.emote_list[act]
	var/mute_time = 0
	if(!length(key_emotes) || custom_param)
		if(intentional)
			#ifdef USES_PQ
			if(client)
				if(get_playerquality(client.ckey) <= -10)
					to_chat(src, "<span class='warning'>Unrecognized emote.</span>")
					return
				#endif
			var/list/custom_emote = GLOB.emote_list["me"]
			for(var/datum/emote/P in custom_emote)
				mute_time = P.mute_time
				P.run_emote(src, oldact, m_type, intentional, targetted)
				break
	else
		for(var/datum/emote/P in key_emotes)
			mute_time = P.mute_time
			if(P.run_emote(src, param, m_type, intentional, targetted))
				break

	if(custom_me)
		next_me_emote = world.time + mute_time
	else
		next_emote = world.time + mute_time

/atom/movable/proc/send_speech_emote(message, range = 7, obj/source = src, bubble_type, list/spans, datum/language/message_language = null, list/message_mods = list(), original_message)
	var/rendered = compose_message(src, message_language, message, null, spans, message_mods)
	for(var/atom/movable/AM as anything in get_hearers_in_view(range, source))
		AM.Hear(rendered, src, message_language, message, null, spans, message_mods, original_message)

/datum/emote/spin
	key = "spin"
	key_third_person = "spins"
	restraint_check = TRUE
	mob_type_allowed_typecache = list(/mob/living, /mob/dead/observer)
	mob_type_ignore_stat_typecache = list(/mob/dead/observer)
	mute_time = 5 SECONDS

/mob/living/carbon/human/verb/emote_spin()
	set name = "Spin"
	set category = "Emotes.Silent"
	emote("spin", intentional = TRUE)

/datum/emote/spin/can_run_emote(mob/living/carbon/user, status_check = TRUE , intentional)
	. = ..()
	if(!iscarbon(user))
		return FALSE
	if(user.IsImmobilized())
		return FALSE

/datum/emote/spin/run_emote(mob/living/carbon/user, params ,  type_override, intentional)
	. = ..()
	if(.)
		user.spin(4, 1)
		user.Immobilize(5)

		if(user.get_timed_status_effect_duration(/datum/status_effect/confusion) > BEYBLADE_PUKE_THRESHOLD)
			user.vomit(BEYBLADE_PUKE_NUTRIENT_LOSS, distance = 0)
			return

		if(prob(BEYBLADE_DIZZINESS_PROBABILITY))
			to_chat(user, span_warning("You feel woozy from spinning."))
			user.set_dizzy_if_lower(BEYBLADE_DIZZINESS_DURATION)
			user.adjust_confusion_up_to(BEYBLADE_CONFUSION_INCREMENT, BEYBLADE_CONFUSION_LIMIT)

		// if(iscyborg(user) && user.has_buckled_mobs())
		// 	var/mob/living/silicon/robot/R = user
		// 	var/datum/component/riding/riding_datum = R.GetComponent(/datum/component/riding)
		// 	if(riding_datum)
		// 		for(var/mob/M in R.buckled_mobs)
		// 			riding_datum.force_dismount(M)
		// 	else
		// 		R.unbuckle_all_mobs()

#undef BEYBLADE_PUKE_THRESHOLD
#undef BEYBLADE_PUKE_NUTRIENT_LOSS
#undef BEYBLADE_DIZZINESS_PROBABILITY
#undef BEYBLADE_DIZZINESS_DURATION
#undef BEYBLADE_CONFUSION_INCREMENT
#undef BEYBLADE_CONFUSION_LIMIT
