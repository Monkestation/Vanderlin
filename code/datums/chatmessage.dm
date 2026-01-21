///Base layer of chat elements
#define CHAT_LAYER 1
///Highest possible layer of chat elements
#define CHAT_LAYER_MAX 2
/// Maximum precision of float before rounding errors occur (in this context)
#define CHAT_LAYER_Z_STEP 0.0001
/// The number of z-layer 'slices' usable by the chat message layering
#define CHAT_LAYER_MAX_Z (CHAT_LAYER_MAX - CHAT_LAYER) / CHAT_LAYER_Z_STEP

#define CHAT_SPELLING_DELAY_WITH_EXCLAIMED_MULTIPLIER (CHAT_SPELLING_DELAY - 0.0003 SECONDS * (EXCLAIMED_MULTIPLER - 1))

#define EXCLAIMED_MULTIPLER (exclaimed ? 3 : 1)

#define BLIP_TONE_FEMININE list(42000, 46000)
#define BLIP_TONE_DEFAULT list(28000, 34000)
#define BLIP_TONE_MASCULINE list(16000, 24000)

#define TOOT_COOLDOWN 1.5 SECONDS

/**
 * # Chat Message Overlay
 *
 * Datum for generating a message overlay on the map
 */
/datum/chatmessage
	/// The visual element of the chat messsage
	var/image/message
	/// The location in which the message is appearing
	var/atom/message_loc
	/// The client who heard this message
	var/client/owned_by
	/// Contains the scheduled destruction time
	var/scheduled_destruction
	/// Contains the approximate amount of lines for height decay
	var/approx_lines
	/// if we finished typing up all our letters.
	var/finished_typing = FALSE
	var/font_size = 8
	var/tgt_color
	var/list/_extra_classes
	var/text
	var/list/remaining_strings
	var/current_string = ""
	var/premature_end = FALSE
	var/exclaimed = FALSE
	var/list/blip_tone = BLIP_TONE_DEFAULT
	var/source_shake = FALSE
	var/last_toot_time

/**
 * Constructs a chat message overlay
 *
 * Arguments:
 * * text - The text content of the overlay
 * * target - The target atom to display the overlay at
 * * owner - The mob that owns this overlay, only this mob will be able to view it
 * * extra_classes - Extra classes to apply to the span that holds the text
 * * lifespan - The lifespan of the message in deciseconds
 */
/datum/chatmessage/New(text, atom/target, mob/owner, datum/language/language, list/extra_classes = list(), lifespan = CHAT_MESSAGE_LIFESPAN)
	. = ..()
	if (!istype(target))
		CRASH("Invalid target given for chatmessage")
	if(QDELETED(owner) || !istype(owner) || !owner.client)
		stack_trace("/datum/chatmessage created with [isnull(owner) ? "null" : "invalid"] mob owner")
		qdel(src)
		return

	if(extra_classes.Find("emote"))
		font_size = 7
		tgt_color = "#adadad"

	if(ishuman(owner))
		var/mob/living/carbon/human/human_owner = owner
		switch(human_owner.voice_type)
			if(VOICE_TYPE_MASC)
				blip_tone = BLIP_TONE_MASCULINE
			if(VOICE_TYPE_FEM)
				blip_tone = BLIP_TONE_FEMININE

	_extra_classes = extra_classes.Copy()

	src.text = text

	remaining_strings = split_text_preserving_html(src.text)

	if((length(text) > 1) && ((text[length(text)] == "!") && (text[length(text) - 1] == "!")))
		exclaimed = TRUE

	// We dim italicized text to make it more distinguishable from regular text
	tgt_color = extra_classes.Find("italics") ? target.chat_color_darkened : target.chat_color

	INVOKE_ASYNC(src, PROC_REF(generate_image), text, target, owner, language, extra_classes, lifespan)


/datum/chatmessage/Destroy()
	if (owned_by)
		if (owned_by.seen_messages)
			LAZYREMOVEASSOC(owned_by.seen_messages, message_loc, src)
		owned_by.images.Remove(message)
	owned_by = null
	message_loc = null
	message = null
	return ..()

/**
 * Calls qdel on the chatmessage when its parent is deleted, used to register qdel signal
 */
/datum/chatmessage/proc/on_parent_qdel()
	SIGNAL_HANDLER

	qdel(src)

/datum/chatmessage/proc/on_parent_take_damage(datum/source, damage, damagetype, def_zone)
	SIGNAL_HANDLER
	if(QDELETED(source))
		return

	if(damage < 4)
		return

	premature_end_of_life()

/**
 * Generates a chat message image representation
 *
 * Arguments:
 * * text - The text content of the overlay
 * * target - The target atom to display the overlay at
 * * owner - The mob that owns this overlay, only this mob will be able to view it
 * * extra_classes - Extra classes to apply to the span that holds the text
 * * lifespan - The lifespan of the message in deciseconds
 */
/datum/chatmessage/proc/generate_image(text, atom/target, mob/owner, datum/language/language, list/extra_classes, lifespan)
	/// Cached icons to show what language the user is speaking
	var/static/list/language_icons
	// Register client who owns this message
	owned_by = owner.client
	RegisterSignal(owned_by, COMSIG_PARENT_QDELETING, PROC_REF(on_parent_qdel))
	RegisterSignal(owner, COMSIG_MOB_APPLY_DAMGE, PROC_REF(on_parent_take_damage))

	// Clip message
	var/maxlen = owned_by.prefs.max_chat_length
	if (length_char(text) > maxlen)
		text = copytext_char(text, 1, maxlen + 1) + "..." // BYOND index moment

	// Calculate target color if not already present
	if(ishuman(target))
		var/mob/living/carbon/human/H = target
		if(H.voice_color && (target.chat_color != H.voice_color))
			target.chat_color = "#[H.voice_color]"
			target.chat_color_darkened = target.chat_color
			target.chat_color_name = target.name
	if(!target.chat_color)
		target.chat_color = colorize_string(target.name)
		target.chat_color_darkened = colorize_string(target.name, 0.85, 0.85)
		target.chat_color_name = target.name
	if(target.voicecolor_override)
		target.chat_color = "#[target.voicecolor_override]"
		target.chat_color_darkened = target.chat_color

	// Get rid of any URL schemes that might cause BYOND to automatically wrap something in an anchor tag
	var/static/regex/url_scheme = new(@"[A-Za-z][A-Za-z0-9+-\.]*:\/\/", "g")
	text = replacetext(text, url_scheme, "")

	// Reject whitespace
	var/static/regex/whitespace = new(@"^\s*$")
	if (whitespace.Find(text))
		qdel(src)
		return

	// Non mobs speakers can be small
	if (!ismob(target))
		extra_classes |= "small"

	var/list/prefixes

	// Append language icon if the language uses one
	var/datum/language/language_instance = GLOB.language_datum_instances[language]
	if (language_instance?.display_icon(owner))
		var/icon/language_icon = LAZYACCESS(language_icons, language)
		if (isnull(language_icon))
			language_icon = icon(language_instance.icon, icon_state = language_instance.icon_state)
			language_icon.Scale(9, 9)
			LAZYSET(language_icons, language, language_icon)
		LAZYADD(prefixes, "\icon[language_icon]")

	src.text = "[prefixes?.Join("&nbsp;")][text]"
	remaining_strings = list(prefixes?.Join("&nbsp;")) + remaining_strings

	// Approximate text height
	// Note we have to replace HTML encoded metacharacters otherwise MeasureText will return a zero height
	// BYOND Bug #2563917
	// Construct text
	var/static/regex/html_metachars = new(@"&[A-Za-z]{1,7};", "g")
	var/complete_text = turn_to_styled(src.text)

	var/mheight
	WXH_TO_HEIGHT(owned_by.MeasureText(complete_text, null, CHAT_MESSAGE_WIDTH), mheight)
	if(!VERB_SHOULD_YIELD)
		return finish_image_generation(mheight, target, owner, complete_text, lifespan)
	var/datum/callback/our_callback = CALLBACK(src, PROC_REF(finish_image_generation), mheight, target, owner, complete_text, lifespan)
	SSrunechat.message_queue += our_callback

/datum/chatmessage/proc/finish_image_generation(mheight, atom/target, mob/owner, complete_text, lifespan)
	if(!owned_by || QDELETED(owned_by))
		return qdel(src)
	if(!target || QDELETED(target))
		return qdel(src)
	approx_lines = max(1, mheight / CHAT_MESSAGE_APPROX_LHEIGHT)
	message_loc = isturf(target) ? target : get_atom_on_turf(target)

	if(HAS_TRAIT(message_loc, TRAIT_SHAKY_SPEECH))
		source_shake = TRUE

	// Translate any existing messages upwards, apply exponential decay factors to timers
	if (owned_by.seen_messages)
//		var/idx = 1
//		var/combined_height = approx_lines
		for(var/datum/chatmessage/m as anything in owned_by.seen_messages[message_loc])

//			animate(m.message, pixel_y = m.message.pixel_y + mheight, time = CHAT_MESSAGE_SPAWN_TIME)
//			combined_height += m.approx_lines
//			var/sched_remaining = m.scheduled_destruction - world.time
//			if (sched_remaining > CHAT_MESSAGE_SPAWN_TIME)
//				var/remaining_time = (sched_remaining) * (CHAT_MESSAGE_EXP_DECAY ** idx++) * (CHAT_MESSAGE_HEIGHT_DECAY ** combined_height)
//				m.scheduled_destruction = world.time + remaining_time
//				addtimer(CALLBACK(m, PROC_REF(end_of_life)), remaining_time, TIMER_UNIQUE|TIMER_OVERRIDE)
			qdel(m)

	// Build message image
	message = image(loc = message_loc, layer = CHAT_LAYER)
	message.plane = RUNECHAT_PLANE
	message.appearance_flags = APPEARANCE_UI_IGNORE_ALPHA | KEEP_APART
	message.alpha = 0
	message.pixel_y = owner.bound_height * 0.95
	message.maptext_width = CHAT_MESSAGE_WIDTH
	message.maptext_height = mheight
	message.maptext_x = (CHAT_MESSAGE_WIDTH - owner.bound_width) * -0.5

	// View the message
	LAZYADDASSOCLIST(owned_by.seen_messages, message_loc, src)
	owned_by.images |= message
	animate(message, alpha = 150, time = CHAT_MESSAGE_SPAWN_TIME)

	// Prepare for destruction
	scheduled_destruction = world.time + (lifespan - CHAT_MESSAGE_EOL_FADE)

	INVOKE_ASYNC(src, PROC_REF(spelling_loop))

/datum/chatmessage/proc/turn_to_styled(string)
	return {"<span style='font-size:[font_size]pt;font-family:"Pterra";color:[tgt_color];text-shadow:0 0 5px #000,0 0 5px #000,0 0 5px #000,0 0 5px #000;' class='center maptext [_extra_classes != null ? _extra_classes.Join(" ") : ""]' style='color: [tgt_color]'>[string]</span>"} //AAAAAAAAAAAAAAA

/datum/chatmessage/proc/split_text_preserving_html(text) // this proc was AI-generated by deepseek
	var/list/result = list()
	var/current_pos = 1
	var/text_length = length(text)

	while(current_pos <= text_length)
		// Check if we're at the start of an HTML entity
		if(copytext(text, current_pos, current_pos + 1) == "&")
			var/entity_end = findtext(text, ";", current_pos)
			if(entity_end)
				// Found a complete entity, add it as one unit
				var/entity = copytext(text, current_pos, entity_end + 1)
				result += entity
				current_pos = entity_end + 1
				continue
		else if(copytext(text, current_pos, current_pos + 1) == "<")
			var/entity_end = findtext(text, ">", current_pos)
			if(entity_end)
				// Found a complete entity, add it as one unit
				var/entity = copytext(text, current_pos, entity_end + 1)
				result += entity
				current_pos = entity_end + 1
				continue
		else if(copytext(text, current_pos, current_pos + 1) == "�") // Should handle UTF-8 multi-byte characters
			var/offset = 1
			var/failed = FALSE
			var/entity
			while(current_pos + offset <= text_length)
				var/test_char = copytext(text, current_pos, current_pos + offset + 1)
				if(!findtext(test_char, "�")) // Valid character found
					entity = test_char
					break
				offset++
				if(offset > 4) // UTF-8 max 4 bytes
					failed = TRUE
					break
			if(!failed)
				result += entity
				current_pos += offset + 1
				continue

		// Not an entity, add single character
		result += copytext(text, current_pos, current_pos + 1)
		current_pos++

	return result

/datum/chatmessage/proc/spelling_extra_delays(character)
	if(character in CHAT_SPELLING_EXCEPTIONS)
		return null

	return CHAT_SPELLING_PUNCTUATION[character] ? CHAT_SPELLING_PUNCTUATION[character] : 0

/datum/chatmessage/proc/spelling_loop()
	if(QDELETED(src))
		return

	var/delay = CHAT_SPELLING_DELAY_WITH_EXCLAIMED_MULTIPLIER
	var/direction = 1

	var/skip_spelling = FALSE
	if(isliving(message_loc))
		var/mobs_around = 0
		for(var/mob/living/seer in oview(message_loc))
			if(seer.client)
				mobs_around++
		if(mobs_around > 4)
			skip_spelling = TRUE
	for(var/letter as anything in remaining_strings)
		if(premature_end)
			return
		var/extra_delay = spelling_extra_delays(letter)
		if(skip_spelling || isnull(extra_delay))
			current_string += letter
			if(skip_spelling) // this is dogshit code quality btw
				extra_delay += 0.15 SECONDS
				delay += CHAT_SPELLING_DELAY_WITH_EXCLAIMED_MULTIPLIER + extra_delay
			continue

		add_string(letter, direction, (extra_delay ? FALSE : TRUE))
		direction *= -1
		sleep(CHAT_SPELLING_DELAY_WITH_EXCLAIMED_MULTIPLIER + extra_delay)
		delay += CHAT_SPELLING_DELAY_WITH_EXCLAIMED_MULTIPLIER + extra_delay

	if(skip_spelling)
		add_string()

	if(!QDELETED(message))
		animate(
			message,
			time = CHAT_SPELLING_DELAY_WITH_EXCLAIMED_MULTIPLIER,
			pixel_w = 0,
			pixel_z = 0,
		)

		addtimer(CALLBACK(src, PROC_REF(end_of_life)), delay + 2 SECONDS)

/datum/chatmessage/proc/add_string(string = "", direction = 1, audible = TRUE)
	if(QDELETED(src))
		return
	if(premature_end)
		return

	_add_string(arglist(args))

/datum/chatmessage/proc/_add_string(string = "", direction = 1, audible = TRUE)
	current_string += string
	message.maptext = MAPTEXT(turn_to_styled(current_string))
	if(audible && !_extra_classes.Find("emote"))
		/*
		play_toot()
		*/ // it's kinda dogshit rn
		do_shift(direction)

/datum/chatmessage/proc/play_toot()
	if(world.time < last_toot_time + TOOT_COOLDOWN)
		return

	last_toot_time = world.time

	playsound(message_loc, 'sound/effects/chat_toots/toot1.ogg', 30, frequency = rand(blip_tone[1], blip_tone[2]))

/datum/chatmessage/proc/do_shift(direction)
	var/exclaimed_multiplier = exclaimed ? 3 : 1

	if(!_extra_classes.Find("emote"))
		animate(
			message,
			time = CHAT_SPELLING_DELAY_WITH_EXCLAIMED_MULTIPLIER,
			pixel_w = ((exclaimed_multiplier - 1) + rand(0, (exclaimed_multiplier - 1))) * pick(-1, 1),
			pixel_z = ((exclaimed_multiplier - 1) + rand((exclaimed_multiplier - 1) * direction, (exclaimed_multiplier - 1) * (direction ? direction : 1) * (exclaimed_multiplier - 1))),
			easing = ELASTIC_EASING,
		)

	if(source_shake)
		var/old_transform = message_loc.transform
		var/old_pixel_w = message_loc.pixel_w
		var/old_pixel_z = message_loc.pixel_z
		animate(
			message_loc,
			time = CHAT_SPELLING_DELAY_WITH_EXCLAIMED_MULTIPLIER + 0.3 - (exclaimed ? 0 : 0.1),
			pixel_w = ((exclaimed_multiplier - 1) + rand(exclaimed_multiplier - 1, exclaimed_multiplier + (exclaimed ? 0 : 3))) * pick(-1, 1),
			pixel_z = (exclaimed_multiplier + rand((exclaimed_multiplier - 1 + (exclaimed ? 0 : 3)) * direction, 1 * (direction ? direction : 1) * exclaimed_multiplier)),
			transform = message_loc.transform.Turn(rand(2 * exclaimed_multiplier, 6 * (exclaimed_multiplier - 0.5) * direction)),
			easing = ELASTIC_EASING,
		)
		animate(
			time = 0,
			pixel_z = old_pixel_z,
			pixel_w = old_pixel_w,
			transform = old_transform,
		)

/datum/chatmessage/proc/premature_end_of_life()
	SIGNAL_HANDLER
	if(QDELETED(message))
		return

	premature_end = TRUE
	_add_string(pick(CHAT_GLORF_LIST))
	var/delay = rand(10, 20) * 0.01 SECONDS // yes, I'm dividing by 100 and then using the SECONDS define which multiplies by 10, deal with it. ^_^

	var/matrix/new_transform = matrix(message.transform)
	new_transform.Turn((5 + rand(5, 15)) * pick(1, -1))
	animate(
		message,
		time = delay,
		pixel_z = 0,
		pixel_w = 0,
		color = "#ad3c23",
		flags = ANIMATION_PARALLEL
		)

	addtimer(CALLBACK(src, PROC_REF(end_of_life)), delay + 0.1 SECONDS)

/**
 * Applies final animations to overlay CHAT_MESSAGE_EOL_FADE deciseconds prior to message deletion
 */
/datum/chatmessage/proc/end_of_life(fadetime = CHAT_MESSAGE_EOL_FADE)
	if(QDELETED(src))
		return
	animate(message, alpha = 0, pixel_z = -14, alpha = 0, time = fadetime, flags = ANIMATION_PARALLEL)

	if(QDELETED(src))
		return

	QDEL_IN(src, fadetime)

/**
 * Creates a message overlay at a defined location for a given speaker
 *
 * Arguments:
 * * speaker - The atom who is saying this message
 * * message_language - The language that the message is said in
 * * raw_message - The text content of the message
 * * spans - Additional classes to be added to the message
 */
/mob/proc/create_chat_message(atom/movable/speaker, datum/language/message_language, raw_message, list/spans)
	if(HAS_TRAIT(speaker, TRAIT_RUNECHAT_HIDDEN))
		return
	// Ensure the list we are using, if present, is a copy so we don't modify the list provided to us
	spans = spans?.Copy()

	// Check for virtual speakers (aka hearing a message through a radio)
	var/atom/movable/originalSpeaker = speaker
	if (istype(speaker, /atom/movable/virtualspeaker))
		var/atom/movable/virtualspeaker/v = speaker
		speaker = v.source
		spans |= "virtual-speaker"

	// Ignore virtual speaker (most often radio messages) from ourself
	if (originalSpeaker != src && speaker == src)
		return

	var/text
	if(spans?.Find("emote"))
		text = raw_message
	else
		text = lang_treat(speaker, message_language, raw_message, spans, null, TRUE)

	// Display visual above source
	new /datum/chatmessage(text, speaker, src, message_language, spans)

#undef CHAT_LAYER
#undef CHAT_LAYER_MAX
#undef CHAT_LAYER_Z_STEP
#undef CHAT_LAYER_MAX_Z
#undef CHAT_SPELLING_DELAY_WITH_EXCLAIMED_MULTIPLIER
#undef EXCLAIMED_MULTIPLER
#undef BLIP_TONE_DEFAULT
#undef BLIP_TONE_FEMININE
#undef BLIP_TONE_MASCULINE
#undef TOOT_COOLDOWN
