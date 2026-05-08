///How confused a carbon must be before they will vomit
#define BEYBLADE_PUKE_THRESHOLD (30 SECONDS)
///How must nutrition is lost when a carbon pukes
#define BEYBLADE_PUKE_NUTRIENT_LOSS 60
///How often a carbon becomes penalized
#define BEYBLADE_DIZZINESS_PROBABILITY 20
///How long the screenshake lasts
#define BEYBLADE_DIZZINESS_DURATION (20 SECONDS)
///How much confusion a carbon gets every time they are penalized
#define BEYBLADE_CONFUSION_INCREMENT (10 SECONDS)
///A max for how much confusion a carbon will be for beyblading
#define BEYBLADE_CONFUSION_LIMIT (40 SECONDS)

//The code execution of the emote datum is located at code/datums/emotes.dm
/mob/proc/emote(act, type_override = NONE, message = null, intentional = FALSE, force_silence = FALSE, forced = FALSE, targeted = FALSE)
	var/original_act = act
	var/param = message
	var/custom_param = findchar(act, " ")
	if(custom_param)
		param = copytext(act, custom_param + length(act[custom_param]))
		act = copytext(act, 1, custom_param)

	act = LOWER_TEXT(act)
	var/list/key_emotes = GLOB.emote_list[act]

	if(!length(key_emotes))
		// if(intentional && !force_silence)
		// 	to_chat(src, span_notice("'[act]' emote does not exist. Say *help for a list."))
		// return FALSE
		key_emotes = GLOB.emote_list["me"]
		param = original_act
	var/silenced = FALSE
	for(var/datum/emote/emote in key_emotes)
		if(!emote.check_cooldown(src, intentional))
			silenced = TRUE
			continue
		if(!forced && !emote.can_run_emote(src, TRUE, intentional, param))
			continue
		if(SEND_SIGNAL(src, COMSIG_MOB_PRE_EMOTED, emote.key, param, type_override, intentional, emote) & COMPONENT_CANT_EMOTE)
			silenced = TRUE
			continue
		emote.run_emote(src, param, type_override, intentional, targeted)
		SEND_SIGNAL(src, COMSIG_MOB_EMOTE, emote, act, type_override, message, intentional)
		SEND_SIGNAL(src, COMSIG_MOB_EMOTED(emote.key))
		return TRUE
	if(intentional && !silenced && !force_silence)
		to_chat(src, span_notice("Unusable emote '[act]'. Say *help for a list."))
	return FALSE

/**
 * For handling emote cooldown, return true to allow the emote to happen.
 *
 * Arguments:
 * * user - Person that is trying to send the emote.
 * * intentional - Bool that says whether the emote was forced (FALSE) or not (TRUE).
 *
 * Returns FALSE if the cooldown is not over, TRUE if the cooldown is over.
 */
/datum/emote/proc/check_cooldown(mob/user, intentional)
	if(SEND_SIGNAL(user, COMSIG_MOB_EMOTE_COOLDOWN_CHECK, src.key, intentional) & COMPONENT_EMOTE_COOLDOWN_BYPASS)
		intentional = FALSE

	if(!intentional)
		return TRUE

	if(user.emotes_used && !ignore_mute_time && user.emotes_used["mute_time"] > world.time)
		return FALSE

	if(user.emotes_used && user.emotes_used[src] + cooldown > world.time)
		var/datum/emote/default_emote = /datum/emote
		if(cooldown > initial(default_emote.cooldown)) // only worry about longer-than-normal emotes
			to_chat(user, span_danger("I must wait another [DisplayTimeText(user.emotes_used[src] - world.time + cooldown)] before using that emote."))
		return FALSE

	if(!user.emotes_used)
		user.emotes_used = list()
	user.emotes_used["mute_time"] = world.time + mute_time
	user.emotes_used[src] = world.time
	return TRUE

/atom/movable/proc/send_speech_emote(message, range = 7, obj/source = src, bubble_type, list/spans, datum/language/message_language = null, list/message_mods = list(), original_message)
	var/rendered = compose_message(src, message_language, message, null, spans, message_mods)
	for(var/atom/movable/AM as anything in get_hearers_in_view(range, source))
		AM.Hear(rendered, src, message_language, message, null, spans, message_mods, original_message)

/datum/emote/help
	key = "help"
	mob_type_ignore_stat_typecache = list(/mob/dead/observer)
	ignore_mute_time = TRUE
	mute_time = 0

/datum/emote/help/run_emote(mob/user, params, type_override, intentional, targeted)
	. = ..()
	var/list/keys = list()
	var/list/message = list("Available emotes, you can use them with say [span_bold("\"*emote\"")]: \n")
	message += span_smallnoticeital("Note - highlighted emotes play a sound \n\n")

	for(var/key in GLOB.emote_list)
		for(var/datum/emote/emote_action in GLOB.emote_list[key])
			if(emote_action.key in keys)
				continue
			if(emote_action.can_run_emote(user, status_check = FALSE , intentional = TRUE))
				keys += emote_action.key

	keys = sortList(keys)

	// the span formatting will mess up sorting so need to do it afterwards
	for(var/i in 1 to keys.len)
		for(var/datum/emote/emote_action in GLOB.emote_list[keys[i]])
			if(emote_action.get_sound(user) && emote_action.should_play_sound(user, intentional = TRUE))
				keys[i] = span_boldnotice(keys[i])

	message += keys.Join(", ")
	message += "."
	message = message.Join("")
	to_chat(user, boxed_message(message))

/datum/emote/spin
	key = "spin"
	key_third_person = "spins"
	restraint_check = TRUE
	mob_type_allowed_typecache = list(/mob/living, /mob/dead/observer)
	mob_type_ignore_stat_typecache = list(/mob/dead/observer)
	cooldown = 5 SECONDS

/mob/living/carbon/human/verb/emote_spin()
	set name = "Spin"
	set category = "Emotes.Silent"
	emote("spin", intentional = TRUE)

/datum/emote/spin/can_run_emote(mob/living/carbon/user, status_check = TRUE , intentional)
	. = ..()
	if(user.IsImmobilized())
		return FALSE

/datum/emote/spin/run_emote(mob/living/carbon/user, params, type_override, intentional, targeted)
	. = ..()
	if(!.)
		return
	user.spin(4, 1)
	user.Immobilize(5)

	if(!iscarbon(user))
		return

	if(user.get_timed_status_effect_duration(/datum/status_effect/confusion) > BEYBLADE_PUKE_THRESHOLD)
		user.vomit(BEYBLADE_PUKE_NUTRIENT_LOSS, distance = 0)
		return

	if(prob(BEYBLADE_DIZZINESS_PROBABILITY))
		to_chat(user, span_warning("You feel woozy from spinning."))
		user.set_dizzy_if_lower(BEYBLADE_DIZZINESS_DURATION)
		user.adjust_confusion_up_to(BEYBLADE_CONFUSION_INCREMENT, BEYBLADE_CONFUSION_LIMIT)

#undef BEYBLADE_PUKE_THRESHOLD
#undef BEYBLADE_PUKE_NUTRIENT_LOSS
#undef BEYBLADE_DIZZINESS_PROBABILITY
#undef BEYBLADE_DIZZINESS_DURATION
#undef BEYBLADE_CONFUSION_INCREMENT
#undef BEYBLADE_CONFUSION_LIMIT
