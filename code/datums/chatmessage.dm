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
	var/tgt_color = null
	var/list/_extra_classes
	var/text
	var/list/remaining_strings
	var/current_string = ""
	var/list/revealed_tokens = list()
	var/list/letter_images = list()
	var/list/open_html_tags = list()
	var/list/letter_line_numbers = list()
	var/list/token_pixel_offsets = list()
	var/list/token_line_numbers = list()
	var/list/token_line_width_after = list()
	var/list/layout_line_widths = list()
	var/list/dropped_space_tokens = list()
	var/list/token_width_cache = list()
	var/next_letter_layer = CHAT_LAYER
	var/current_line_number = 0
	var/current_line_width = 0
	var/current_string_index = 0
	var/end_timer = TIMER_ID_NULL
	var/premature_end = FALSE
	var/is_retiring = FALSE
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
			if(VOICE_TYPE_MASC, VOICE_TYPE_MASC_FOP)
				blip_tone = BLIP_TONE_MASCULINE
			if(VOICE_TYPE_FEM, VOICE_TYPE_FEM_DAINTY, VOICE_TYPE_FEM_HAUGHTY)
				blip_tone = BLIP_TONE_FEMININE

	_extra_classes = extra_classes.Copy()

	src.text = text

	remaining_strings = split_text_preserving_html(src.text)

	if((length(text) > 1) && ((text[length(text)] == "!") && (text[length(text) - 1] == "!")))
		exclaimed = TRUE

	INVOKE_ASYNC(src, PROC_REF(generate_image), text, target, owner, language, extra_classes, lifespan)


/datum/chatmessage/Destroy()
	if (owned_by)
		if (owned_by.seen_messages)
			LAZYREMOVEASSOC(owned_by.seen_messages, message_loc, src)
		owned_by.images.Remove(message)
		for(var/image/letter_image as anything in letter_images)
			owned_by.images.Remove(letter_image)
	owned_by = null
	message_loc = null
	message = null
	letter_images = null
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

	RegisterSignal(owned_by, COMSIG_QDELETING, PROC_REF(on_parent_qdel))
	RegisterSignal(owner, COMSIG_MOB_APPLY_DAMAGE, PROC_REF(on_parent_take_damage))

	// Clip message
	var/maxlen = owned_by.prefs.read_preference(/datum/preference/numeric/max_chat_length)
	text = clip_text_preserving_html(text, maxlen)

	// Calculate target color if not already present
	if(ishuman(target))
		var/mob/living/carbon/human/H = target
		if(H.voice_color && (target.chat_color != H.voice_color))
			target.chat_color = "#[H.voice_color]" // Preferences santitises this
			target.chat_color_darkened = target.chat_color
			target.chat_color_name = target.name

	if(!target.chat_color)
		target.chat_color = colorize_string(target.name)
		target.chat_color_darkened = colorize_string(target.name, 0.85, 0.85)
		target.chat_color_name = target.name

	if(target.voicecolor_override)
		target.chat_color = "#[target.voicecolor_override]"
		target.chat_color_darkened = target.chat_color

	if(!tgt_color) // False when using emotes
		// We dim italicized text to make it more distinguishable from regular text
		tgt_color = extra_classes.Find("italics") ? target.chat_color_darkened : target.chat_color

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
	remaining_strings = list()
	if(length(prefixes))
		remaining_strings += prefixes.Join("&nbsp;")
	remaining_strings += split_text_preserving_html(text)

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

	var/datum/callback/our_callback = CALLBACK(src, PROC_REF(finish_image_generation), mheight, target, owner, complete_text, lifespan, TRUE)
	SSrunechat.message_queue += our_callback

/datum/chatmessage/proc/finish_image_generation(mheight, atom/target, mob/owner, complete_text, lifespan, async_spelling = FALSE)
	if(!owned_by || QDELETED(owned_by))
		return qdel(src)

	if(!target || QDELETED(target))
		return qdel(src)

	approx_lines = max(1, mheight / CHAT_MESSAGE_APPROX_LHEIGHT)
	message_loc = isturf(target) ? target : get_atom_on_turf(target)

	if(HAS_TRAIT(message_loc, TRAIT_SHAKY_SPEECH))
		source_shake = TRUE

	// Move older messages up and fade them out as this message appears.
	if (owned_by.seen_messages)
		for(var/datum/chatmessage/m as anything in owned_by.seen_messages[message_loc])
			m.end_for_new_message(mheight)

	// Build message image
	message = image(loc = message_loc, layer = CHAT_LAYER)
	message.plane = RUNECHAT_PLANE
	message.appearance_flags = APPEARANCE_UI_IGNORE_ALPHA | KEEP_APART
	message.alpha = 0
	message.pixel_y = owner.bound_height * 0.95
	message.maptext_width = CHAT_MESSAGE_WIDTH
	message.maptext_height = mheight
	message.maptext_x = (CHAT_MESSAGE_WIDTH - owner.bound_width) * -0.5
	prepare_letter_layout()

	// View the message
	LAZYADDASSOCLIST(owned_by.seen_messages, message_loc, src)
	owned_by.images |= message
	animate(message, alpha = 150, time = CHAT_MESSAGE_SPAWN_TIME)

	// Prepare for destruction
	scheduled_destruction = world.time + (lifespan - CHAT_MESSAGE_EOL_FADE)

	if(async_spelling)
		INVOKE_ASYNC(src, PROC_REF(spelling_loop))
	else
		spelling_loop()

/datum/chatmessage/proc/turn_to_styled(string)
	return {"<span style='font-size:[font_size]pt;font-family:"Pterra";color:[tgt_color];text-shadow:0 0 5px #000,0 0 5px #000,0 0 5px #000,0 0 5px #000;' class='center maptext [_extra_classes != null ? _extra_classes.Join(" ") : ""]'>[string]</span>"} //AAAAAAAAAAAAAAA

/datum/chatmessage/proc/clip_text_preserving_html(text, max_length)
	var/list/tokens = split_text_preserving_html(text)
	var/list/result = list()
	var/list/open_tags = list()
	var/visible_characters = 0

	for(var/token in tokens)
		if(findtext(token, "<") == 1 && findtext(token, ">"))
			result += token
			var/tag_end = findtext(token, ">")
			if(findtext(token, "</") == 1)
				var/closing_name = copytext(token, 3, tag_end)
				var/closing_space = findtext(closing_name, " ")
				if(closing_space)
					closing_name = copytext(closing_name, 1, closing_space)
				for(var/index = length(open_tags), index > 0, index--)
					if(open_tags[index] == closing_name)
						open_tags.Cut(index, index + 1)
						break
			else if(!findtext(token, "/>") && !findtext(token, "<br") && !findtext(token, "<hr"))
				var/opening_name = copytext(token, 2, tag_end)
				var/opening_space = findtext(opening_name, " ")
				if(opening_space)
					opening_name = copytext(opening_name, 1, opening_space)
				open_tags += opening_name
			continue

		if(visible_characters >= max_length)
			result += "..."
			break

		result += token
		visible_characters++

	for(var/index = length(open_tags), index > 0, index--)
		result += "</[open_tags[index]]>"

	return result.Join()

/datum/chatmessage/proc/split_text_preserving_html(text) // this proc was AI-generated by deepseek
	var/list/result = list()
	var/current_pos = 1
	var/text_length = length(text)
	var/static/regex/html_entity = regex(@"^&(#([0-9]+|[xX][0-9A-Fa-f]+)|[A-Za-z][A-Za-z0-9]*);$")

	while(current_pos <= text_length)
		// Check if we're at the start of an HTML entity
		if(copytext(text, current_pos, current_pos + 1) == "&")
			var/entity_end = findtext(text, ";", current_pos)
			if(entity_end && (entity_end - current_pos <= 33))
				var/entity = copytext(text, current_pos, entity_end + 1)
				if(html_entity.Find(entity))
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
	for(var/string_index in 1 to length(remaining_strings))
		var/letter = remaining_strings[string_index]
		current_string_index = string_index
		if(premature_end)
			return
		var/extra_delay = spelling_extra_delays(letter)
		if(skip_spelling)
			animate_letter_into_existence(letter, direction, FALSE)
			if(isnull(extra_delay))
				extra_delay = 0
			delay += CHAT_SPELLING_DELAY_WITH_EXCLAIMED_MULTIPLIER + extra_delay + 0.15 SECONDS
			continue

		if(isnull(extra_delay))
			animate_letter_into_existence(letter, direction, FALSE)
			continue

		var/letter_delay = CHAT_SPELLING_DELAY_WITH_EXCLAIMED_MULTIPLIER + extra_delay
		animate_letter_into_existence(letter, direction, !extra_delay, letter_delay)
		direction *= -1
		delay += letter_delay

	if(QDELETED(src) || premature_end)
		return

	current_string_index = 0
	finished_typing = TRUE
	if(!QDELETED(message))
		end_timer = addtimer(CALLBACK(src, PROC_REF(end_of_life)), delay + 2 SECONDS)

/datum/chatmessage/proc/add_string(string = "", direction = 1, audible = TRUE)
	if(QDELETED(src))
		return
	if(premature_end)
		return

	return animate_letter_into_existence(string, direction, audible)

/datum/chatmessage/proc/animate_letter_into_existence(string, direction = 1, audible = TRUE, reveal_delay = 0)
	var/list/new_images = _add_string(string, direction, audible)
	var/spawn_offset = get_letter_spawn_offset()
	for(var/image/letter_image as anything in new_images)
		owned_by.images |= letter_image
		var/spawn_pixel_y = letter_image.pixel_y
		var/target_pixel_y = spawn_pixel_y - spawn_offset
		animate(
			letter_image,
			alpha = 255,
			pixel_y = spawn_pixel_y,
			time = CHAT_MESSAGE_LETTER_FADE_TIME,
			easing = LINEAR_EASING,
		)
		if(spawn_offset)
			animate(
				pixel_y = target_pixel_y,
				time = CHAT_MESSAGE_LETTER_MOVE_TIME,
				easing = SINE_EASING | EASE_OUT,
			)
	if(length(new_images) && (audible || exclaimed) && !_extra_classes.Find("emote"))
		do_shift(direction, new_images)
	if(reveal_delay)
		sleep(reveal_delay)
	return new_images

/datum/chatmessage/proc/get_letter_spawn_offset()
	if(_extra_classes.Find("emote"))
		return 0
	return CHAT_MESSAGE_LETTER_SPAWN_RISE

/datum/chatmessage/proc/_add_string(string = "", direction = 1, audible = TRUE)
	if(isnull(string) || !length(string))
		return

	var/list/added_images = list()
	var/list/tokens
	if(findtext(string, "\\icon") == 1)
		tokens = list(string)
	else
		tokens = split_text_preserving_html(string)
	for(var/token in tokens)
		current_string += token
		revealed_tokens += token
		var/target_token_index = length(revealed_tokens)
		if(current_string_index && target_token_index <= length(token_line_numbers))
			while(current_line_number < token_line_numbers[target_token_index])
				start_new_line(CHAT_MESSAGE_APPROX_LHEIGHT)
			current_line_width = token_line_width_after[target_token_index]
		else if(findtext(token, "<") != 1 && token != @"\n" && token != @"\r")
			if(token == " ")
				current_line_width += measure_token_width(token, open_html_tags)
			else
				var/token_width = measure_token_width(token, open_html_tags)
				if(token == "&nbsp;")
					current_line_width += token_width
				else
					if(current_line_width && current_line_width + token_width > CHAT_MESSAGE_WIDTH)
						start_new_line(CHAT_MESSAGE_APPROX_LHEIGHT)
						current_line_width = 0
					while(length(layout_line_widths) < current_line_number + 1)
						layout_line_widths += 0
					var/current_layout_width = layout_line_widths[current_line_number + 1]
					if(isnull(current_layout_width))
						current_layout_width = 0
					current_layout_width = max(current_layout_width, current_line_width + token_width)
					while(length(token_pixel_offsets) < target_token_index)
						token_pixel_offsets += 0
					while(length(token_line_numbers) < target_token_index)
						token_line_numbers += 0
					while(length(token_line_width_after) < target_token_index)
						token_line_width_after += 0
					token_pixel_offsets[target_token_index] = (CHAT_MESSAGE_WIDTH - current_layout_width) * 0.5 + current_line_width
					token_line_numbers[target_token_index] = current_line_number
					current_line_width += token_width
					layout_line_widths[current_line_number + 1] = max(current_layout_width, current_line_width)
					token_line_width_after[target_token_index] = current_line_width

		if(findtext(token, "<") == 1 && findtext(token, ">"))
			if(findtext(token, "<br") == 1)
				continue
			else if(findtext(token, "</") == 1)
				close_html_tag(token)
			else if(!findtext(token, "/>"))
				open_html_tags += token
			continue

		if(token == @"\n" || token == @"\r" || token == " " || token == "&nbsp;")
			continue

		var/image/letter_image = create_letter_image(target_token_index, token)
		if(letter_image)
			added_images += letter_image

	return added_images

/datum/chatmessage/proc/close_html_tag(tag, list/tags_to_close = null)
	if(isnull(tags_to_close))
		tags_to_close = open_html_tags

	var/tag_name_end = findtext(tag, ">")
	var/tag_name = copytext(tag, 3, tag_name_end)
	var/tag_name_space = findtext(tag_name, " ")
	if(tag_name_space)
		tag_name = copytext(tag_name, 1, tag_name_space)

	for(var/index = length(tags_to_close), index > 0, index--)
		var/open_tag = tags_to_close[index]
		var/open_tag_end = findtext(open_tag, ">")
		var/open_tag_name = copytext(open_tag, 2, open_tag_end)
		var/open_tag_space = findtext(open_tag_name, " ")
		if(open_tag_space)
			open_tag_name = copytext(open_tag_name, 1, open_tag_space)
		if(open_tag_name == tag_name)
			tags_to_close.Cut(index, index + 1)
			return

/datum/chatmessage/proc/start_new_line(line_height)
	current_line_number++
	for(var/image/letter_image as anything in letter_images)
		letter_image.pixel_y += line_height

	if(current_line_number < CHAT_MESSAGE_VISIBLE_LINES)
		return

	var/oldest_visible_line = current_line_number - CHAT_MESSAGE_VISIBLE_LINES + 1

	for(var/image/letter_image as anything in letter_images.Copy())
		var/line_number = letter_line_numbers[letter_image]
		if(line_number < oldest_visible_line)
			owned_by.images.Remove(letter_image)
			letter_images.Remove(letter_image)
			letter_line_numbers.Remove(letter_image)

/datum/chatmessage/proc/prepare_letter_layout()
	token_pixel_offsets = list()
	token_line_numbers = list()
	token_line_width_after = list()
	layout_line_widths = list()
	dropped_space_tokens = list()
	token_width_cache = list()

	var/list/token_widths = list()
	var/list/line_break_tokens = list()
	var/list/layout_open_tags = list()
	var/measure_run = ""
	var/measure_run_width = 0
	var/token_count = length(remaining_strings)
	for(var/slot_index in 1 to token_count)
		token_widths += 0
		line_break_tokens += 0
		token_pixel_offsets += 0
		token_line_numbers += 0
		token_line_width_after += 0
		layout_line_widths += 0
		dropped_space_tokens += 0
	layout_line_widths += 0

	for(var/token_index in 1 to token_count)
		var/measure_token = remaining_strings[token_index]
		if(findtext(measure_token, "<") == 1 && findtext(measure_token, ">"))
			measure_run = ""
			measure_run_width = 0
			if(findtext(measure_token, "<br") == 1 || findtext(measure_token, "<hr") == 1)
				line_break_tokens[token_index] = TRUE
			else if(findtext(measure_token, "</") == 1)
				close_html_tag(measure_token, layout_open_tags)
			else if(!findtext(measure_token, "/>"))
				layout_open_tags += measure_token
			token_widths[token_index] = 0
			continue

		if(measure_token == @"\n" || measure_token == @"\r")
			line_break_tokens[token_index] = TRUE
			token_widths[token_index] = 0
			measure_run = ""
			measure_run_width = 0
			continue

		if(measure_token == " ")
			var/space_prefix_width = measure_token_width(measure_run + measure_token, layout_open_tags)
			var/space_width = space_prefix_width - measure_run_width
			if(space_width <= 0)
				space_width = measure_token_width(measure_token, layout_open_tags)
			token_widths[token_index] = space_width
			measure_run = ""
			measure_run_width = 0
			continue

		var/prefix_width = measure_token_width(measure_run + measure_token, layout_open_tags)
		var/character_width = prefix_width - measure_run_width
		if(character_width <= 0)
			character_width = measure_token_width(measure_token, layout_open_tags)
			measure_run_width += character_width
		else
			measure_run_width = prefix_width
		token_widths[token_index] = character_width
		measure_run += measure_token

	var/current_layout_line = 0
	var/current_layout_width = 0
	var/layout_index = 1
	while(layout_index <= token_count)
		var/layout_token = remaining_strings[layout_index]
		if(line_break_tokens[layout_index])
			token_line_numbers[layout_index] = current_layout_line
			token_line_width_after[layout_index] = current_layout_width
			layout_line_widths[current_layout_line + 1] = current_layout_width
			current_layout_line++
			current_layout_width = 0
			layout_index++
			continue

		if(layout_token == " ")
			var/space_width = token_widths[layout_index]
			var/next_word_width = 0
			var/lookahead = layout_index + 1
			while(lookahead <= token_count && !line_break_tokens[lookahead] && remaining_strings[lookahead] != " ")
				next_word_width += token_widths[lookahead]
				lookahead++

			if(current_layout_width && current_layout_width + space_width + next_word_width > CHAT_MESSAGE_WIDTH)
				token_line_numbers[layout_index] = current_layout_line
				token_line_width_after[layout_index] = current_layout_width
				layout_line_widths[current_layout_line + 1] = current_layout_width
				token_widths[layout_index] = 0
				dropped_space_tokens[layout_index] = TRUE
				current_layout_line++
				current_layout_width = 0
				layout_index++
				continue

			if(!current_layout_width)
				token_widths[layout_index] = 0
				dropped_space_tokens[layout_index] = TRUE
			token_line_numbers[layout_index] = current_layout_line
			current_layout_width += token_widths[layout_index]
			token_line_width_after[layout_index] = current_layout_width
			layout_index++
			continue

		var/word_end = layout_index
		var/word_width = 0
		while(word_end <= token_count && !line_break_tokens[word_end] && remaining_strings[word_end] != " ")
			word_width += token_widths[word_end]
			word_end++

		if(current_layout_width && current_layout_width + word_width > CHAT_MESSAGE_WIDTH)
			layout_line_widths[current_layout_line + 1] = current_layout_width
			current_layout_line++
			current_layout_width = 0

		for(var/word_index in layout_index to (word_end - 1))
			var/character_width = token_widths[word_index]
			if(word_width > CHAT_MESSAGE_WIDTH && current_layout_width && current_layout_width + character_width > CHAT_MESSAGE_WIDTH)
				layout_line_widths[current_layout_line + 1] = current_layout_width
				current_layout_line++
				current_layout_width = 0
			token_line_numbers[word_index] = current_layout_line
			current_layout_width += character_width
			token_line_width_after[word_index] = current_layout_width

		layout_index = word_end

	layout_line_widths[current_layout_line + 1] = current_layout_width

	var/list/position_open_tags = list()
	var/position_index = 1
	while(position_index <= token_count)
		var/position_line = token_line_numbers[position_index]
		var/line_start_index = position_index
		while(position_index <= token_count && token_line_numbers[position_index] == position_line)
			position_index++
		var/line_end_index = position_index - 1
		var/line_markup = position_open_tags.Join()
		var/has_preserved_space = FALSE
		var/pending_space_width = 0

		for(var/position_token_index in line_start_index to line_end_index)
			var/position_token = remaining_strings[position_token_index]
			if(findtext(position_token, "<") == 1 && findtext(position_token, ">"))
				if(findtext(position_token, "<br") == 1 || findtext(position_token, "<hr") == 1)
					continue
				line_markup += position_token
				if(findtext(position_token, "</") == 1)
					close_html_tag(position_token, position_open_tags)
				else if(!findtext(position_token, "/>"))
					position_open_tags += position_token
				token_line_width_after[position_token_index] = measure_layout_width(line_markup, position_open_tags)
				continue

			if(position_token == @"\n" || position_token == @"\r" || dropped_space_tokens[position_token_index])
				token_line_width_after[position_token_index] = measure_layout_width(line_markup, position_open_tags)
				continue

			if(position_token == " " || position_token == "&nbsp;")
				if(!has_preserved_space)
					pending_space_width = measure_token_width(position_token, position_open_tags)
					has_preserved_space = TRUE
				else if(position_token == "&nbsp;")
					pending_space_width += measure_token_width(position_token, position_open_tags)
				token_line_width_after[position_token_index] = measure_layout_width(line_markup, position_open_tags)
				continue

			var/prefix_width = measure_layout_width(line_markup, position_open_tags)
			token_pixel_offsets[position_token_index] = prefix_width + pending_space_width
			if(has_preserved_space)
				line_markup += " "
			line_markup += position_token
			has_preserved_space = FALSE
			pending_space_width = 0
			token_line_width_after[position_token_index] = measure_layout_width(line_markup, position_open_tags)

		var/line_width = measure_layout_width(line_markup, position_open_tags)
		if(!line_width)
			line_width = layout_line_widths[position_line + 1]
		layout_line_widths[position_line + 1] = line_width
		var/centered_line_offset = (CHAT_MESSAGE_WIDTH - line_width) * 0.5

		for(var/offset_token_index in line_start_index to line_end_index)
			token_pixel_offsets[offset_token_index] += centered_line_offset

/datum/chatmessage/proc/measure_layout_width(text, list/active_html_tags)
	if(!length(text))
		return 0

	var/cache_key = "layout|[active_html_tags.Join()]|[text]"
	var/cached_width = token_width_cache[cache_key]
	if(!isnull(cached_width))
		return cached_width

	var/measurement_text = {"<span style='font-size:[font_size]pt;font-family:"Pterra";-dm-text-outline:1px #0005;' class='[_extra_classes != null ? _extra_classes.Join(" ") : ""]'>[text]"}
	for(var/index = length(active_html_tags), index > 0, index--)
		var/open_tag = active_html_tags[index]
		var/tag_end = findtext(open_tag, ">")
		var/tag_name = copytext(open_tag, 2, tag_end)
		var/tag_space = findtext(tag_name, " ")
		if(tag_space)
			tag_name = copytext(tag_name, 1, tag_space)
		measurement_text += "</[tag_name]>"
	measurement_text += "</span>"

	var/measurement = owned_by.MeasureText(measurement_text, null)
	var/width_end = findtext(measurement, "x")
	var/layout_width = width_end ? text2num(copytext(measurement, 1, width_end)) : 0
	token_width_cache[cache_key] = layout_width
	return layout_width

/datum/chatmessage/proc/measure_token_width(token, list/active_html_tags)
	if(findtext(token, "\\icon") == 1)
		return 9

	var/cache_key = "[active_html_tags.Join()]|[token]"
	var/cached_width = token_width_cache[cache_key]
	if(!isnull(cached_width))
		return cached_width

	var/measurement_text = {"<span style='font-size:[font_size]pt;font-family:"Pterra";' class='[_extra_classes != null ? _extra_classes.Join(" ") : ""]'>[active_html_tags.Join()][token]"}
	for(var/index = length(active_html_tags), index > 0, index--)
		var/open_tag = active_html_tags[index]
		var/tag_end = findtext(open_tag, ">")
		var/tag_name = copytext(open_tag, 2, tag_end)
		var/tag_space = findtext(tag_name, " ")
		if(tag_space)
			tag_name = copytext(tag_name, 1, tag_space)
		measurement_text += "</[tag_name]>"
	measurement_text += "</span>"

	var/measurement = owned_by.MeasureText(measurement_text, null, CHAT_MESSAGE_WIDTH)
	var/width_end = findtext(measurement, "x")
	var/token_width = width_end ? text2num(copytext(measurement, 1, width_end)) : 0
	if(token_width > 0 && token_width < CHAT_MESSAGE_WIDTH)
		token_width_cache[cache_key] = token_width
	else if(token == " ")
		token_width_cache[cache_key] = 3
	else
		token_width_cache[cache_key] = max(1, round(font_size * 0.6))
	return token_width_cache[cache_key]

/datum/chatmessage/proc/create_letter_image(target_token_index, token)
	next_letter_layer += CHAT_LAYER_Z_STEP
	var/image/letter_image = image(loc = message_loc, layer = next_letter_layer)
	letter_image.alpha = 0
	letter_image.plane = RUNECHAT_PLANE
	letter_image.appearance_flags = APPEARANCE_UI | KEEP_APART
	letter_image.pixel_y = message.pixel_y + get_letter_spawn_offset()
	letter_image.pixel_x = 0
	letter_image.maptext = get_letter_maptext(token, open_html_tags)
	letter_image.maptext_height = message.maptext_height
	letter_image.maptext_width = CHAT_MESSAGE_WIDTH
	letter_image.maptext_x = message.maptext_x + token_pixel_offsets[target_token_index]

	letter_images += letter_image
	letter_line_numbers[letter_image] = current_line_number

	return letter_image

/datum/chatmessage/proc/get_letter_maptext(token, list/active_html_tags)
	var/render_text = active_html_tags.Join() + token
	for(var/close_index = length(active_html_tags), close_index > 0, close_index--)
		var/open_tag = active_html_tags[close_index]
		var/tag_end = findtext(open_tag, ">")
		var/tag_name = copytext(open_tag, 2, tag_end)
		var/tag_space = findtext(tag_name, " ")
		if(tag_space)
			tag_name = copytext(tag_name, 1, tag_space)
		render_text += "</[tag_name]>"

	return {"<span style='font-size:[font_size]pt;font-family:"Pterra";color:[tgt_color];-dm-text-outline: 1px #0005;' class='maptext [_extra_classes != null ? _extra_classes.Join(" ") : ""]'>[render_text]</span>"}

/datum/chatmessage/proc/end_for_new_message(rise_height)
	if(QDELETED(src) || is_retiring)
		return

	is_retiring = TRUE
	premature_end = TRUE
	if(end_timer != TIMER_ID_NULL)
		deltimer(end_timer)
		end_timer = TIMER_ID_NULL

	current_string_index = 0
	finished_typing = TRUE
	if(!ends_with_ellipsis())
		var/list/ellipsis_images = _add_string("...", 1, FALSE)
		for(var/image/ellipsis_image as anything in ellipsis_images)
			ellipsis_image.pixel_y -= get_letter_spawn_offset()
			ellipsis_image.alpha = 255
			owned_by.images |= ellipsis_image

	for(var/image/letter_image as anything in letter_images)
		animate(
			letter_image,
			pixel_y = letter_image.pixel_y + max(rise_height, CHAT_MESSAGE_APPROX_LHEIGHT),
			alpha = 0,
			time = CHAT_MESSAGE_REPLACED_FADE,
			flags = ANIMATION_PARALLEL,
		)

	QDEL_IN(src, CHAT_MESSAGE_REPLACED_FADE)

/datum/chatmessage/proc/ends_with_ellipsis()
	var/period_count = 0
	for(var/index = length(revealed_tokens), index > 0, index--)
		var/token = revealed_tokens[index]
		if(findtext(token, "<") == 1 && findtext(token, ">"))
			continue
		if(token == ".")
			period_count++
			if(period_count == 3)
				return TRUE
			continue
		if(token == " " || token == "&nbsp;")
			continue
		return FALSE

	return FALSE

/datum/chatmessage/proc/play_toot()
	if(world.time < last_toot_time + TOOT_COOLDOWN)
		return

	last_toot_time = world.time

	playsound(message_loc, 'sound/effects/chat_toots/toot1.ogg', 30, frequency = rand(blip_tone[1], blip_tone[2]))

/datum/chatmessage/proc/do_shift(direction, list/images_to_shift)
	var/exclaimed_multiplier = exclaimed ? 3 : 1

	if(exclaimed && !_extra_classes.Find("emote"))
		for(var/image/letter_image as anything in images_to_shift)
			animate(
				letter_image,
				time = rand(5, 12) * 0.01 SECONDS,
				pixel_w = rand(-6, 6),
				pixel_z = rand(-6, 6),
				easing = ELASTIC_EASING,
			)
			animate(
				time = rand(5, 12) * 0.01 SECONDS,
				pixel_w = rand(-6, 6),
				pixel_z = rand(-6, 6),
				easing = ELASTIC_EASING,
			)
			animate(
				time = rand(5, 12) * 0.01 SECONDS,
				pixel_w = rand(-6, 6),
				pixel_z = rand(-6, 6),
				easing = ELASTIC_EASING,
			)
			animate(
				time = rand(5, 12) * 0.01 SECONDS,
				pixel_w = 0,
				pixel_z = 0,
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
	current_string_index = 0
	animate_letter_into_existence(pick(CHAT_GLORF_LIST), 1, FALSE)
	var/delay = rand(10, 20) * 0.01 SECONDS // yes, I'm dividing by 100 and then using the SECONDS define which multiplies by 10, deal with it. ^_^

	for(var/image/letter_image as anything in letter_images)
		animate(
			letter_image,
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
	if(QDELETED(src) || is_retiring)
		return
	end_timer = TIMER_ID_NULL
	is_retiring = TRUE
	for(var/image/letter_image as anything in letter_images)
		animate(letter_image, alpha = 0, pixel_z = -14, alpha = 0, time = fadetime, flags = ANIMATION_PARALLEL)

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
