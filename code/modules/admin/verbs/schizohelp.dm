GLOBAL_LIST_EMPTY_TYPED(schizohelps, /datum/schizohelp)
GLOBAL_LIST_EMPTY(schizo_names)
GLOBAL_LIST_EMPTY(voice_names)

/mob
	COOLDOWN_DECLARE(schizohelp_cooldown)

/mob/proc/schizohelp(msg as text, ask_again = FALSE, client/voice_again, datum/schizohelp/schizo_again)
	if(!msg)
		return
	msg = copytext(sanitize(msg), 1, MAX_MESSAGE_LEN)
	if(!msg)
		return

	if(client?.prefs?.muted & MUTE_MEDITATE)
		to_chat(src, span_notice("You have been muted from mentor help."))
		return

	if(ask_again)
		log_game("([key || "NO KEY"]) mentorhelped ASK AGAIN: [msg]")
		for(var/client/admin in GLOB.admins)
			if(!(admin.prefs.chat_toggles & CHAT_PRAYER))
				continue
			to_chat(admin, span_admin_log("<i>[schizo_again.rng_name] ([key || "NO KEY"]) [ADMIN_FLW(src)] [ADMIN_SM(src)] meditates asks again...</i>\n<b>[msg]</b>"))

		to_chat(src, span_notice("[mentor_block("<i>You meditate again...</i>\n<b>[msg]</b>")]"))
		var/message = span_notice("<i>[schizo_again.rng_name] meditates again and asks you directly...</i>\n<b>[msg]</b>")
		var/answer_button = span_notice("(<a href='byond://?src=[voice_again];schizohelp=[REF(schizo_again)];ask_again=1'>ANSWER</a>)")
		to_chat(voice_again, mentor_block("[message]  [answer_button]"))

		var/sound/used = sound('sound/misc/notice (2).ogg')
		used.pitch *= 0.5
		SEND_SOUND(voice_again, used)

	else
		to_chat(src, span_notice("[mentor_block("<i>You meditate...</i>\n<b>[msg]</b>")]"))
		var/datum/schizohelp/ticket = new(src)
		var/display_name = get_schizo_name()
		ticket.rng_name = display_name
		var/message = span_notice("<i>[display_name] meditates...</i>\n<b>[msg]</b>")
		var/message_admins = span_notice("<i>[display_name] ([key || "NO KEY"]) [ADMIN_FLW(src)] [ADMIN_SM(src)] meditates...</i>\n<b>[msg]</b>")
		log_game("([key || "NO KEY"]) mentorhelped: [msg]")

		for(var/client/voice in ((GLOB.clients - client) - GLOB.admins))
			if(!(voice.prefs.toggles & SCHIZO_VOICE))
				continue
			var/answer_button = span_notice("(<a href='byond://?src=[voice];schizohelp=[REF(ticket)];'>ANSWER</a>)")
			to_chat(voice, mentor_block("[message]  [answer_button]"))


			var/sound/used = sound('sound/misc/notice (2).ogg')
			used.pitch *= 0.5
			SEND_SOUND(voice, used)

		for(var/client/admin in (GLOB.admins - client))
			if(!(admin.prefs.chat_toggles & CHAT_PRAYER))
				continue
			var/added_text = span_notice("(<A href='?_src_=holder;[HrefToken()];mute=[ckey];mute_type=[MUTE_MEDITATE]'><span class='adminsay'>MUTE</span></a>)")
			var/answer_button = span_notice("(<a href='byond://?src=[admin];schizohelp=[REF(ticket)];'>ANSWER</a>)")
			to_chat(admin,  mentor_block("[message_admins] [added_text] [answer_button]"))
		COOLDOWN_START(src, schizohelp_cooldown, 1 MINUTES)



/// Generate a consistent but unique voice name for the round
/mob/proc/get_voice_name()
	// Already assigned? just return it
	if(GLOB.voice_names[real_name || src.name])
		return GLOB.voice_names[real_name || src.name]

	var/static/list/possible_adjectives = list(
		"Steady",
		"Calm",
		"Reasoned",
		"Patient",
		"Thoughtful",
		"Balanced",
		"Quiet",
		"Kind",
		"Careful",
		"Wise",
		"Measured",
		"Gentle",
		"Honest",
		"Clear",
		"Faithful"
	)

	var/static/list/possible_nouns = list(
		"Guide",
		"Companion",
		"Friend",
		"Sage",
		"Watcher",
		"Helper",
		"Advisor",
		"Guardian",
		"Teacher",
		"Seeker",
		"Listener",
		"Protector",
		"Witness",
		"Partner",
		"Ally"
	)

	var/static/fumbling_seed = text2num(GLOB.rogue_round_id)
	var/md5_num = text2num(md5(real_name || src.name))

	var/name
	var/tries = 0
	while(TRUE)
		var/adjective = possible_adjectives[(md5_num + tries) % length(possible_adjectives) + 1]
		var/noun = possible_nouns[(round(md5_num * noise_hash(md5_num, fumbling_seed)) + tries) % length(possible_nouns) + 1]
		name = "[adjective] [noun]"
		// Check if already used
		if(!(name in GLOB.voice_names))
			break
		tries++
		if(tries > (length(possible_adjectives) * length(possible_nouns)))
			// Ran out of unique names
			name = "Nameless [tries]"
			break
	GLOB.voice_names[real_name || src.name] = name
	GLOB.voice_names[name] = TRUE // mark the name itself as taken

	return name


/// Generate a consistent but unique schizo name for the round
/mob/proc/get_schizo_name()
	// Already assigned? just return it
	if(GLOB.schizo_names[real_name || src.name])
		return GLOB.schizo_names[real_name || src.name]

	var/static/list/possible_adjectives = list(
		"Indecisive",
		"Doubtful",
		"Confused",
		"Hysteric",
		"Unstable",
		"Unsure",
		"Unsettled",
		"Paranoid",
		"Delirious",
		"Frantic",
		"Disoriented",
		"Forgetful",
		"Shaken",
		"Anxious",
		"Erratic"
	)

	var/static/list/possible_nouns = list(
		"Fool",
		"Madman",
		"Nimrod",
		"Lunatic",
		"Imbecile",
		"Simpleton",
		"Clown",
		"Jester",
		"Idiot",
		"Dunce",
		"Babbler",
		"Mumbler",
		"Derelict",
		"Wanderer",
		"Lost One"
	)

	var/static/fumbling_seed = text2num(GLOB.rogue_round_id)
	var/md5_num = text2num(md5(real_name || src.name))

	var/name
	var/tries = 0
	while(TRUE)
		var/adjective = possible_adjectives[(md5_num + tries) % length(possible_adjectives) + 1]
		var/noun = possible_nouns[(round(md5_num * noise_hash(md5_num, fumbling_seed)) + tries) % length(possible_nouns) + 1]
		name = "[adjective] [noun]"
		// Check if already used
		if(!(name in GLOB.schizo_names))
			break
		tries++
		if(tries > (length(possible_adjectives) * length(possible_nouns)))
			// Ran out of unique names
			name = "Nameless [tries]"
			break
	GLOB.schizo_names[real_name || src.name] = name
	GLOB.schizo_names[name] = TRUE // mark the name itself as taken

	return name

/client/proc/answer_schizohelp(datum/schizohelp/schizo, ask_again = FALSE)
	if(QDELETED(schizo) && schizo.locked && !ask_again)
		to_chat(src, span_warning("This meditation can no longer be answered..."))
		return
	var/mob/schizo_mob = schizo.owner?.resolve()
	if(!schizo_mob)
		return
	if(schizo_mob == mob)
		to_chat(src, span_warning("I can't answer my own meditation!"))
		return
	if(schizo.answers[key] && !ask_again)
		to_chat(src, span_warning("I have already answered this meditation!"))
		return

	var/answer = browser_input_text(src, "Answer their meditations...", "THE VOICE", multiline = TRUE)
	if(!answer || QDELETED(schizo))
		return
	update_mentor_stat(src.ckey, "answered", 1 , src)
	schizo.answer_schizo(answer, mob, ask_again)

/datum/schizohelp
	/// Guy who made this schizohelp "ticket"
	var/datum/weakref/owner
	/// Answers we got so far, indexed by client key
	var/list/answers = list()
	/// How many answers we can get at maximum
	var/max_answers = 3
	/// How much time we have to be answered
	var/timeout = 5 MINUTES
	///For like,dislikes.
	var/list/voted = list()
	///Voice Name
	var/list/voice_names = list()
	///Schizo Name
	var/rng_name
	/// Becomes TRUE when max answers is reached
	var/locked = FALSE
	/// Timer before the ticket is deleted
	var/delete_timer = 2 MINUTES
	/// For the decay to prevent it from being deleted
	var/asked_again = FALSE

/datum/schizohelp/New(mob/owner)
	. = ..()
	if(!owner)
		stack_trace("shizohelp created without an owner!")
		qdel(src)
		return
	RegisterSignal(owner, COMSIG_PARENT_QDELETING, PROC_REF(owner_qdeleted))
	GLOB.schizohelps += src
	src.owner = WEAKREF(owner)
	if(timeout)
		addtimer(CALLBACK(src, PROC_REF(decay)), timeout)

/datum/schizohelp/Destroy(force)
	owner = null
	answers = null
	GLOB.schizohelps -= src
	return ..()

/datum/schizohelp/proc/owner_qdeleted(mob/source)
	if(QDELETED(src))
		return
	var/mob/schizo = owner.resolve()
	if(schizo)
		UnregisterSignal(schizo, COMSIG_PARENT_QDELETING)
	qdel(src)

/datum/schizohelp/proc/decay()
	if(asked_again)
		addtimer(CALLBACK(src, PROC_REF(decay)), 3 MINUTES)
		asked_again = FALSE
		return
	if(!length(answers))
		var/mob/schizo = owner.resolve()
		if(!QDELETED(schizo))
			to_chat(schizo, mentor_block("[span_notice("<i><b>My meditation goes unanswered...</b></i>")]"))
			SEND_SOUND(schizo, 'sound/misc/notice.ogg')

	qdel(src)

/datum/schizohelp/proc/answer_schizo(answer, mob/voice, ask_again = FALSE)
	if(QDELETED(src) || !voice.client)
		return
	var/mob/schizo = owner.resolve()
	if(!schizo)
		qdel(src)
		return

	var/buttons = span_notice(
	"(<a href='byond://?src=[REF(src)];like=[REF(voice)]'>LIKE</a>) \
	(<a href='byond://?src=[REF(src)];dislike=[REF(voice)]'>DISLIKE</a>) \
	(<a href='byond://?src=[REF(src)];ask_again=[REF(src)];voice=[REF(voice)]'>ASK AGAIN</a>)")

	var/voice_ckey = voice.client.ckey
	if(!voice_names[voice_ckey])
		voice_names[voice_ckey] = voice.get_voice_name()

	to_chat(schizo, mentor_block("[span_notice("<i>I hear the Voice of a [voice_names[voice_ckey]] in my head...</i>\n<b>[answer]</b>")] [buttons]"))
	var/sound/used = sound('sound/misc/notice (2).ogg')
	used.pitch *= 1.5
	SEND_SOUND(schizo, used)
	for(var/client/admin in GLOB.admins)
		if(!(admin.prefs.chat_toggles & CHAT_PRAYER))
			continue
		to_chat(admin, span_admin_log(
			"[voice] ([voice.key || "NO KEY"]) [ADMIN_FLW(voice)] [ADMIN_SM(voice)] \
			answered [schizo] ([schizo.key || "NO KEY"])'s [ADMIN_FLW(schizo)] [ADMIN_SM(schizo)] Mentor Help: [answer]"))

	answers[voice.key] = answer

	log_game("([voice.key || "NO KEY"]) answered ([schizo.key || "NO KEY"])'s Mentor Help: [answer]")

	if(length(answers) >= max_answers && !ask_again && !locked)
		locked = TRUE
		to_chat(schizo, span_notice("<i>The voices grow silent... I must meditate another time if i wish for more guidance or I could ASK AGAIN one of the voices...</i>"))
		addtimer(CALLBACK(src, PROC_REF(decay)), delete_timer)
