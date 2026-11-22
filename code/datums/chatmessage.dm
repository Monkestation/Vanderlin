#define CHAT_LAYER 1
#define CHAT_LAYER_Z_STEP 0.0001

#define CHAT_SPELLING_DELAY_WITH_EXCLAIMED_MULTIPLIER (CHAT_SPELLING_DELAY - 0.0003 SECONDS * (EXCLAIMED_MULTIPLIER - 1))

#define EXCLAIMED_MULTIPLIER (exclaimed ? 3 : 1)

#define BLIP_TONE_FEMININE list(42000, 46000)
#define BLIP_TONE_DEFAULT list(28000, 34000)
#define BLIP_TONE_MASCULINE list(16000, 24000)

#define TOOT_COOLDOWN 1.5 SECONDS


/*
Animated runechat version 3.0:

- A system that allows us to animate every letter in a runechat message individually:
	this is done by making every letter a seperate image, which allows us to control
	every letter seperately, color? you got it. alpha? yes. motion? yessiree.

The pipeline:

	1. Tokenize the text: because we can have html in the text, instead of making each letter a list entry, we introduce a token system.
		A token is a list entry responsible for a single “spelling out” instance. This can be a space, an HTML tag, an icon, or a letter.

	2. Create the container for the images to go onto. This is /image/message, and it gives the text its position and dimensions.
		The tokens are separate images placed at the same location and positioned relative to it;
		they are not literally children of the message image.

	3. Prepare the text: clip it to the player’s chat limit, apply its color and styling, add a language icon if needed
		split it into tokens, and measure its height.
		If the code needs to yield, the message setup is queued so it doesn’t block the Runechat subsystem.

	4. Calculate the layout before spelling starts.
		Measure the tokens, decide which line each one belongs to, account for spaces and HTML,
		wrap words that don’t fit,
		calculate each visible token’s horizontal offset.
		This is why the letters can be separate images but still line up as text.

	5. Start spelling out the tokens in order.
		Spaces and HTML tags still take part in the layout, but they don’t get their own visible letter image.
		Each visible token gets its own image.

	6. Animate each new image into place. Letters fade in and move up slightly; emotes skip the entrance movement.
		Punctuation adds a pause, and exclamation marks can add extra movement.

	7. When the text moves onto a new line, move the existing letters up and keep the newest line at the bottom.
		Remove lines that are too old to stay visible.

	8. When the message is replaced, interrupted, or reaches the end of its life, fade out and remove its images.
		The toot proc is separate from the spelling pipeline; it is preserved for a future feature but isn’t called by the typing loop right now.

		the toot feature is currently impractical because of needed sound system refactors.
*/
/datum/chatmessage
	/// Base image that anchors the message position and dimensions.
	var/image/message
	// this is usually a player but can also be an item or structure if an admin possesses one.
	/// Atom used as the location for the message and its letter images.
	var/atom/message_loc
	/// Client that owns and displays this message.
	var/client/owned_by
	/// Font size used for the message and its letters.
	var/font_size = 8
	/// Color applied to the message text.
	var/tgt_color = null
	/// Additional styling classes applied to the message.
	var/list/_extra_classes
	/// Ordered tokens to reveal, including spaces and markup.
	var/list/remaining_tokens
	/// Tokens that have already been processed for display.
	var/list/revealed_tokens = list()
	/// Individual images used to render visible tokens.
	var/list/letter_images = list()
	/// HTML tags currently active while rendering tokens.
	var/list/open_html_tags = list()
	/// Line number for each letter image.
	var/list/letter_line_numbers = list()
	/// Horizontal pixel offset for each token.
	var/list/token_pixel_offsets = list()
	/// Line number assigned to each token.
	var/list/token_line_numbers = list()
	/// Cumulative line width after each token.
	var/list/token_line_width_after = list()
	/// Measured width of each laid-out line.
	var/list/layout_line_widths = list()
	/// Tokens containing spaces omitted at line breaks.
	var/list/dropped_space_tokens = list()
	/// Cached text-width measurements used during layout.
	var/list/token_width_cache = list()
	/// Layer assigned to the next letter image.
	var/next_letter_layer = CHAT_LAYER
	/// Line currently being revealed, starting at zero.
	var/current_line_number = 0
	/// Cumulative width of the current line in pixels while adding tokens without a prepared layout.
	var/current_line_width = 0
	/// Index of the token currently being revealed; zero for appended text.
	var/current_string_index = 0
	/// Timer for the message's scheduled end.
	var/end_timer = TIMER_ID_NULL
	/// Whether typing was stopped early by damage or replacement.
	var/premature_end = FALSE
	/// Whether the message is already fading out or being deleted.
	var/is_retiring = FALSE
	/// Whether the original message ended with multiple exclamation marks.
	var/exclaimed = FALSE
	/// Sound frequency range selected for the owner's voice.
	var/list/blip_tone = BLIP_TONE_DEFAULT
	/// Whether the speaker should shake as letters are spelled out.
	var/source_shake = FALSE
	/// World time when this message last played a toot.
	var/last_toot_time

/datum/chatmessage/New(text, atom/target, mob/owner, datum/language/language, list/extra_classes = list())
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

	if((length(text) > 1) && ((text[length(text)] == "!") && (text[length(text) - 1] == "!")))
		exclaimed = TRUE

	INVOKE_ASYNC(src, PROC_REF(prepare_message_content), text, target, owner, language, extra_classes)

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

/datum/chatmessage/proc/prepare_message_content(text, atom/target, mob/owner, datum/language/language, list/extra_classes)
	var/static/list/language_icons
	owned_by = owner.client

	RegisterSignal(owned_by, COMSIG_QDELETING, PROC_REF(on_parent_qdel))
	RegisterSignal(owner, COMSIG_MOB_APPLY_DAMAGE, PROC_REF(on_parent_take_damage))

	var/maxlen = owned_by.prefs.read_preference(/datum/preference/numeric/max_chat_length)
	var/list/message_tokens = split_text_preserving_html(text, maxlen)
	text = message_tokens.Join()

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

	if(!tgt_color)
		tgt_color = extra_classes.Find("italics") ? target.chat_color_darkened : target.chat_color

	var/static/regex/url_scheme = new(@"[A-Za-z][A-Za-z0-9+-\.]*:\/\/", "g")
	var/unprocessed_text = text
	text = replacetext(text, url_scheme, "")
	if(text != unprocessed_text)
		message_tokens = split_text_preserving_html(text)

	var/static/regex/whitespace = new(@"^\s*$")
	if (whitespace.Find(text))
		qdel(src)
		return

	if (!ismob(target))
		extra_classes |= "small"

	var/list/prefixes

	var/datum/language/language_instance = GLOB.language_datum_instances[language]
	if (language_instance?.display_icon(owner))
		var/icon/language_icon = LAZYACCESS(language_icons, language)
		if (isnull(language_icon))
			language_icon = icon(language_instance.icon, icon_state = language_instance.icon_state)
			language_icon.Scale(9, 9)
			LAZYSET(language_icons, language, language_icon)
		LAZYADD(prefixes, "\icon[language_icon]")

	remaining_tokens = list()
	if(length(prefixes))
		remaining_tokens += split_text_preserving_html(prefixes.Join("&nbsp;"))
	remaining_tokens += message_tokens

	text = "[prefixes?.Join("&nbsp;")][text]"

	var/complete_text = turn_to_styled(text)

	var/mheight
	WXH_TO_HEIGHT(owned_by.MeasureText(complete_text, null, CHAT_MESSAGE_WIDTH), mheight)
	if(!VERB_SHOULD_YIELD)
		return create_message_overlay(mheight, target, owner)

	var/datum/callback/our_callback = CALLBACK(src, PROC_REF(create_message_overlay), mheight, target, owner, TRUE)
	SSrunechat.message_queue += our_callback

/datum/chatmessage/proc/create_message_overlay(mheight, atom/target, mob/owner, async_spelling = FALSE)
	if(!owned_by || QDELETED(owned_by))
		return qdel(src)

	if(!target || QDELETED(target))
		return qdel(src)

	message_loc = isturf(target) ? target : get_atom_on_turf(target)

	if(HAS_TRAIT(message_loc, TRAIT_SHAKY_SPEECH))
		source_shake = TRUE

	if (owned_by.seen_messages)
		for(var/datum/chatmessage/m as anything in owned_by.seen_messages[message_loc])
			m.end_for_new_message(mheight)

	message = image(loc = message_loc, layer = CHAT_LAYER)
	message.plane = RUNECHAT_PLANE
	message.appearance_flags = APPEARANCE_UI_IGNORE_ALPHA | KEEP_APART
	message.alpha = 0
	message.pixel_y = owner.bound_height * 0.95
	message.maptext_width = CHAT_MESSAGE_WIDTH
	message.maptext_height = mheight
	message.maptext_x = (CHAT_MESSAGE_WIDTH - owner.bound_width) * -0.5
	prepare_letter_layout()

	LAZYADDASSOCLIST(owned_by.seen_messages, message_loc, src)
	owned_by.images |= message
	animate(message, alpha = 150, time = CHAT_MESSAGE_SPAWN_TIME)

	if(async_spelling)
		INVOKE_ASYNC(src, PROC_REF(spelling_loop))
	else
		spelling_loop()

/datum/chatmessage/proc/turn_to_styled(string)
	var/extra_font_style = _extra_classes.Find("god_zizo") ? "font-weight:bold;" : ""
	return {"<span style='font-size:[font_size]pt;font-family:"Pterra";color:[tgt_color];text-shadow:0 0 5px #000,0 0 5px #000,0 0 5px #000,0 0 5px #000;[extra_font_style]' class='center maptext [_extra_classes != null ? _extra_classes.Join(" ") : ""]'>[string]</span>"}

/datum/chatmessage/proc/split_text_preserving_html(text, max_length = null)
	var/list/result = list()
	var/list/open_tags = list()
	var/current_pos = 1
	var/text_length = length_char(text)
	var/visible_characters = 0
	var/static/regex/html_entity = regex(@"^&(#([0-9]+|[xX][0-9A-Fa-f]+)|[A-Za-z][A-Za-z0-9]*);$")

	while(current_pos <= text_length)
		var/current_character = copytext_char(text, current_pos, current_pos + 1)
		var/token
		if(current_character == "&")
			var/entity_end = findtext_char(text, ";", current_pos)
			if(entity_end && (entity_end - current_pos <= 33))
				var/entity = copytext_char(text, current_pos, entity_end + 1)
				if(html_entity.Find(entity))
					token = entity
					current_pos = entity_end + 1
				else
					token = current_character
					current_pos++
			else
				token = current_character
				current_pos++
		else if(current_character == "<")
			var/entity_end = findtext_char(text, ">", current_pos)
			if(entity_end)
				token = copytext_char(text, current_pos, entity_end + 1)
				current_pos = entity_end + 1
			else
				token = current_character
				current_pos++
		else
			token = current_character
			current_pos++

		if(!isnull(max_length) && findtext(token, "<") == 1 && findtext(token, ">") && !is_runechat_icon_token(token))
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

		if(!isnull(max_length) && visible_characters >= max_length)
			result += "."
			result += "."
			result += "."
			break

		result += token
		if(!isnull(max_length))
			visible_characters++

	for(var/index = length(open_tags), index > 0, index--)
		result += "</[open_tags[index]]>"

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
	for(var/string_index in 1 to length(remaining_tokens))
		var/letter = remaining_tokens[string_index]
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
	if(!QDELETED(message))
		end_timer = addtimer(CALLBACK(src, PROC_REF(end_of_life)), delay + 2 SECONDS)

/datum/chatmessage/proc/animate_letter_into_existence(string, direction = 1, audible = TRUE, reveal_delay = 0)
	var/list/new_images = _add_string(string, direction, audible)
	var/spawn_offset = get_letter_spawn_offset()
	for(var/image/letter_image as anything in new_images)
		owned_by.images |= letter_image
		var/spawn_pixel_y = letter_image.pixel_y
		var/target_pixel_y = spawn_pixel_y - spawn_offset

		// begins with 0 alpha, fades into existence on a spot above their designated position
		animate(
			letter_image,
			alpha = 255,
			pixel_y = spawn_pixel_y,
			time = CHAT_MESSAGE_LETTER_FADE_TIME,
			easing = LINEAR_EASING,
		)
		// moves down to their designated spot after fading in.
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

		if(findtext(token, "<") == 1 && findtext(token, ">") && !is_runechat_icon_token(token))
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
	var/token_count = length(remaining_tokens)
	var/has_html_markup = FALSE
	for(var/slot_index in 1 to token_count)
		token_widths += 0
		line_break_tokens += 0
		token_pixel_offsets += 0
		token_line_numbers += 0
		token_line_width_after += 0
		layout_line_widths += 0
		dropped_space_tokens += 0
		var/token = remaining_tokens[slot_index]
		if(findtext(token, "<") == 1 && findtext(token, ">"))
			has_html_markup = TRUE
	layout_line_widths += 0

	var/use_cached_plain_layout = FALSE
	if(!has_html_markup)
		use_cached_plain_layout = prepare_cached_plain_widths(token_widths, line_break_tokens)

	if(has_html_markup)
		for(var/token_index in 1 to token_count)
			var/measure_token = remaining_tokens[token_index]
			if(is_runechat_icon_token(measure_token))
				token_widths[token_index] = measure_token_width(measure_token, layout_open_tags)
				measure_run = ""
				measure_run_width = 0
				continue

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
	else if(!use_cached_plain_layout)
		for(var/token_index in 1 to token_count)
			token_widths[token_index] = 0
			line_break_tokens[token_index] = FALSE

		var/token_index = 1
		var/previous_run = ""
		while(token_index <= token_count)
			var/measure_token = remaining_tokens[token_index]
			if(measure_token == @"\n" || measure_token == @"\r")
				line_break_tokens[token_index] = TRUE
				previous_run = ""
				token_index++
				continue

			if(measure_token == " ")
				var/space_prefix_width = measure_token_width(previous_run + measure_token, layout_open_tags)
				var/previous_run_width = length(previous_run) ? measure_token_width(previous_run, layout_open_tags) : 0
				var/space_width = space_prefix_width - previous_run_width
				if(space_width <= 0)
					space_width = measure_token_width(measure_token, layout_open_tags)
				token_widths[token_index] = space_width
				previous_run = ""
				token_index++
				continue

			var/run_end = token_index
			var/run_text = ""
			while(run_end <= token_count && remaining_tokens[run_end] != " " && remaining_tokens[run_end] != @"\n" && remaining_tokens[run_end] != @"\r")
				run_text += remaining_tokens[run_end]
				run_end++

			var/run_width = measure_token_width(run_text, layout_open_tags, null)
			var/fallback_width = max(1, round(font_size * 0.6))
			if(run_width < CHAT_MESSAGE_WIDTH && (length(run_text) == 1 || run_width != fallback_width))
				token_widths[token_index] = run_width
			else
				measure_run = ""
				measure_run_width = 0
				for(var/run_token_index in token_index to (run_end - 1))
					var/run_token = remaining_tokens[run_token_index]
					var/prefix_width = measure_token_width(measure_run + run_token, layout_open_tags)
					var/character_width = prefix_width - measure_run_width
					if(character_width <= 0)
						character_width = measure_token_width(run_token, layout_open_tags)
						measure_run_width += character_width
					else
						measure_run_width = prefix_width
					token_widths[run_token_index] = character_width
					measure_run += run_token

			previous_run = run_text
			token_index = run_end

	var/current_layout_line = 0
	var/current_layout_width = 0
	var/layout_index = 1
	while(layout_index <= token_count)
		var/layout_token = remaining_tokens[layout_index]
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
			while(lookahead <= token_count && !line_break_tokens[lookahead] && remaining_tokens[lookahead] != " ")
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
		while(word_end <= token_count && !line_break_tokens[word_end] && remaining_tokens[word_end] != " ")
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

	if(use_cached_plain_layout)
		var/position_index = 1
		while(position_index <= token_count)
			var/position_line = token_line_numbers[position_index]
			var/line_start_index = position_index
			while(position_index <= token_count && token_line_numbers[position_index] == position_line)
				position_index++
			var/line_end_index = position_index - 1
			var/line_markup = ""
			var/current_line_offset = 0
			var/has_preserved_space = FALSE
			var/pending_space_width = 0

			for(var/position_token_index in line_start_index to line_end_index)
				var/position_token = remaining_tokens[position_token_index]
				if(position_token == @"\n" || position_token == @"\r" || dropped_space_tokens[position_token_index])
					token_line_width_after[position_token_index] = current_line_offset
					continue

				if(position_token == " ")
					if(!has_preserved_space)
						pending_space_width = token_widths[position_token_index]
						has_preserved_space = TRUE
					token_line_width_after[position_token_index] = current_line_offset
					continue

				token_pixel_offsets[position_token_index] = current_line_offset + pending_space_width
				current_line_offset += pending_space_width + token_widths[position_token_index]
				if(has_preserved_space)
					line_markup += " "
				line_markup += position_token
				has_preserved_space = FALSE
				pending_space_width = 0
				token_line_width_after[position_token_index] = current_line_offset

			var/line_width = measure_layout_width(line_markup, list())
			layout_line_widths[position_line + 1] = line_width
			var/centered_line_offset = (CHAT_MESSAGE_WIDTH - line_width) * 0.5
			for(var/offset_token_index in line_start_index to line_end_index)
				token_pixel_offsets[offset_token_index] += centered_line_offset
	else
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
				var/position_token = remaining_tokens[position_token_index]
				if(findtext(position_token, "<") == 1 && findtext(position_token, ">") && !is_runechat_icon_token(position_token))
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

/// Prepares per-token advances from a cached ASCII glyph-pair table when exact word widths agree.
/datum/chatmessage/proc/prepare_cached_plain_widths(list/token_widths, list/line_break_tokens)
	var/token_count = length(remaining_tokens)
	var/previous_token
	for(var/token_index in 1 to token_count)
		var/token = remaining_tokens[token_index]
		if(token == @"\n" || token == @"\r")
			previous_token = null
			continue
		if(token == " ")
			if(previous_token == " ")
				return FALSE
			previous_token = token
			continue
		if(length(token) != 1)
			return FALSE
		var/ascii_character = text2ascii(token)
		if(ascii_character < 32 || ascii_character > 126 || token in list("<", ">", "&"))
			return FALSE
		previous_token = token

	var/token_index = 1
	var/previous_run = ""
	while(token_index <= token_count)
		var/token = remaining_tokens[token_index]
		if(token == @"\n" || token == @"\r")
			line_break_tokens[token_index] = TRUE
			previous_run = ""
			token_index++
			continue

		if(token == " ")
			var/space_prefix_width = measure_token_width(previous_run + token, list())
			var/previous_run_width = length(previous_run) ? measure_token_width(previous_run, list()) : 0
			var/space_width = space_prefix_width - previous_run_width
			if(space_width <= 0)
				space_width = measure_token_width(token, list())
			token_widths[token_index] = space_width
			previous_run = ""
			token_index++
			continue

		var/run_end = token_index
		var/run_text = ""
		while(run_end <= token_count && remaining_tokens[run_end] != " " && remaining_tokens[run_end] != @"\n" && remaining_tokens[run_end] != @"\r")
			run_text += remaining_tokens[run_end]
			run_end++

		var/run_width = measure_token_width(run_text, list(), null)
		if(run_width >= CHAT_MESSAGE_WIDTH)
			return FALSE

		var/previous_character
		var/pair_advance_total = 0
		var/run_token_index = token_index
		while(run_token_index < run_end)
			var/run_token = remaining_tokens[run_token_index]
			if(run_token == previous_character)
				var/repeated_advance = get_cached_ascii_advance(run_token, run_token)
				if(isnull(repeated_advance))
					return FALSE
				while(run_token_index < run_end && remaining_tokens[run_token_index] == run_token)
					token_widths[run_token_index] = repeated_advance
					pair_advance_total += repeated_advance
					run_token_index++
				previous_character = run_token
				continue

			var/character_advance = get_cached_ascii_advance(run_token, previous_character)
			if(isnull(character_advance))
				return FALSE
			token_widths[run_token_index] = character_advance
			pair_advance_total += character_advance
			previous_character = run_token
			run_token_index++

		if(pair_advance_total != run_width)
			return FALSE

		previous_run = run_text
		token_index = run_end

	return TRUE

/// Returns a cached advance for an ASCII glyph, or for its pair with the previous glyph.
/datum/chatmessage/proc/get_cached_ascii_advance(character, previous_character)
	var/static/list/advance_cache = list()
	var/static/list/cache_order = list()
	var/cache_profile = "[font_size]|[_extra_classes != null ? _extra_classes.Join() : ""]"
	var/cache_key = isnull(previous_character) ? "[cache_profile]|glyph|[character]" : "[cache_profile]|pair|[previous_character][character]"
	var/cached_advance = advance_cache[cache_key]
	if(!isnull(cached_advance))
		return cached_advance

	var/advance
	if(isnull(previous_character))
		advance = measure_token_width(character, list(), null)
	else
		var/previous_width = get_cached_ascii_advance(previous_character)
		if(isnull(previous_width))
			return null
		var/pair_width = measure_token_width("[previous_character][character]", list(), null)
		advance = pair_width - previous_width
	if(advance <= 0)
		return null

	if(length(cache_order) >= 8192)
		var/expired_key = cache_order[1]
		cache_order.Cut(1, 2)
		advance_cache.Remove(expired_key)
	advance_cache[cache_key] = advance
	cache_order += cache_key
	return advance

/datum/chatmessage/proc/measure_layout_width(text, list/active_html_tags)
	if(!length(text))
		return 0

	var/cache_key = "layout|[active_html_tags.Join()]|[text]"
	var/cached_width = token_width_cache[cache_key]
	if(!isnull(cached_width))
		return cached_width

	var/extra_font_style = _extra_classes.Find("god_zizo") ? "font-weight:bold;" : ""
	var/measurement_text = {"<span style='font-size:[font_size]pt;font-family:"Pterra";-dm-text-outline:1px #0005;[extra_font_style]' class='[_extra_classes != null ? _extra_classes.Join(" ") : ""]'>[text]"}
	for(var/index = length(active_html_tags), index > 0; index--)
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

/datum/chatmessage/proc/is_runechat_icon_token(token)
	return findtext(uppertext(token), "<IMG CLASS=ICON") == 1

/datum/chatmessage/proc/measure_token_width(token, list/active_html_tags, max_width = CHAT_MESSAGE_WIDTH)
	if(findtext(token, "\\icon") == 1 || is_runechat_icon_token(token))
		return 9

	var/cache_width = isnull(max_width) ? "natural" : "[max_width]"
	var/cache_key = "[cache_width]|[active_html_tags.Join()]|[token]"
	var/cached_width = token_width_cache[cache_key]
	if(!isnull(cached_width))
		return cached_width

	var/extra_font_style = _extra_classes.Find("god_zizo") ? "font-weight:bold;" : ""
	var/measurement_text = {"<span style='font-size:[font_size]pt;font-family:"Pterra";[extra_font_style]' class='[_extra_classes != null ? _extra_classes.Join(" ") : ""]'>[active_html_tags.Join()][token]"}
	for(var/index = length(active_html_tags), index > 0, index--)
		var/open_tag = active_html_tags[index]
		var/tag_end = findtext(open_tag, ">")
		var/tag_name = copytext(open_tag, 2, tag_end)
		var/tag_space = findtext(tag_name, " ")
		if(tag_space)
			tag_name = copytext(tag_name, 1, tag_space)
		measurement_text += "</[tag_name]>"
	measurement_text += "</span>"

	var/measurement
	if(isnull(max_width))
		measurement = owned_by.MeasureText(measurement_text, null)
	else
		measurement = owned_by.MeasureText(measurement_text, null, max_width)
	var/width_end = findtext(measurement, "x")
	var/token_width = width_end ? text2num(copytext(measurement, 1, width_end)) : 0
	if(token_width > 0 && (isnull(max_width) || token_width < max_width))
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

	var/extra_font_style = _extra_classes.Find("god_zizo") ? "font-weight:bold;" : ""
	return {"<span style='font-size:[font_size]pt;font-family:"Pterra";color:[tgt_color];-dm-text-outline: 1px #0005;[extra_font_style]' class='maptext [_extra_classes != null ? _extra_classes.Join(" ") : ""]'>[render_text]</span>"}

/datum/chatmessage/proc/end_for_new_message(rise_height)
	if(QDELETED(src) || is_retiring)
		return

	is_retiring = TRUE
	premature_end = TRUE
	if(end_timer != TIMER_ID_NULL)
		deltimer(end_timer)
		end_timer = TIMER_ID_NULL

	current_string_index = 0
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
			pixel_w = ((exclaimed_multiplier - 1) + rand(exclaimed_multiplier - 1, exclaimed_multiplier + (exclaimed ? 0 : 2))) * pick(-1, 1),
			pixel_z = (exclaimed_multiplier + rand((exclaimed_multiplier - 1 + (exclaimed ? 0 : 2)) * direction, 1 * (direction ? direction : 1) * exclaimed_multiplier)),
			transform = message_loc.transform.Turn(rand(2 * exclaimed_multiplier, 4 * (exclaimed_multiplier - 0.5) * direction)),
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
	var/delay = rand(10, 20) * 0.01 SECONDS

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

/mob/proc/create_chat_message(atom/movable/speaker, datum/language/message_language, raw_message, list/spans)
	if(HAS_TRAIT(speaker, TRAIT_RUNECHAT_HIDDEN))
		return
	spans = spans?.Copy()

	var/atom/movable/originalSpeaker = speaker
	if (istype(speaker, /atom/movable/virtualspeaker))
		var/atom/movable/virtualspeaker/v = speaker
		speaker = v.source
		spans |= "virtual-speaker"

	if (originalSpeaker != src && speaker == src)
		return

	var/text
	if(spans?.Find("emote"))
		text = raw_message
	else
		text = lang_treat(speaker, message_language, raw_message, spans, null, TRUE)

	new /datum/chatmessage(text, speaker, src, message_language, spans)

#undef CHAT_LAYER
#undef CHAT_LAYER_Z_STEP
#undef CHAT_SPELLING_DELAY_WITH_EXCLAIMED_MULTIPLIER
#undef EXCLAIMED_MULTIPLIER
#undef BLIP_TONE_DEFAULT
#undef BLIP_TONE_FEMININE
#undef BLIP_TONE_MASCULINE
#undef TOOT_COOLDOWN
