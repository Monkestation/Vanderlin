///List of ckeys that have seen a blurb of a given key.
GLOBAL_LIST_EMPTY(blurb_witnesses)

//Based on code ported from Nebula. https://github.com/NebulaSS13/Nebula/pull/357

/**Shows a ticker reading out the given text on a client's screen.
targets = mob or list of mobs to show it to.
duration = how long it lingers after it finishes ticking.
message = the message to display. Due to using maptext it isn't very flexible format-wise. 11px font, up to 480 pixels per line.
Use \n for line breaks. Single-character HTML tags (<b>, <i>, <u> etc.) are handled correctly but others display strangely.
Note that maptext can display text macros in strange ways, ex. \improper showing as "ÿ". Lines containing only spaces,
including ones only containing "\improper ", don't display.
scroll_down = by default each line pushes the previous line upwards - this tells it to start high and scroll down.
Ticks on \n - does not autodetect line breaks in long strings.
screen_position = screen loc for the bottom-left corner of the blurb.
text_alignment = "right", "left", or "center"
text_color = colour of the text.
blurb_key = a key used for specific blurb types so they are not shown repeatedly. Ex. someone who joins as CLF repeatedly only seeing the mission blurb the first time.
ignore_key = used to skip key checks. Ex. a USCM ERT member shouldn't see the normal USCM drop message,
but should see their own spawn message even if the player already dropped as USCM.**/
/proc/show_blurb(list/mob/targets, duration = 3 SECONDS, message, fade_time = 0.5 SECONDS, scroll_down, screen_position = "LEFT+0:16,BOTTOM+1:16",\
	text_alignment = "left", text_color = "#FFFFFF", outline_color = "#000000", blurb_key, ignore_key = FALSE, speed = 0.5)
	set waitfor = FALSE
	if(!islist(targets))
		targets = list(targets)
	if(!length(targets))
		return

	var/style = "font-family: 'Fixedsys'; font-size: 6px; text-align: [text_alignment]; color: [text_color]; -dm-text-outline: 1 [outline_color];"
	var/list/linebreaks = list() //Due to singular /'s making text disappear for a moment and for counting lines.

	var/linebreak = findtext(message, "\n")
	while(linebreak)
		linebreak++ //Otherwise it picks up the character immediately before the linebreak.
		linebreaks += linebreak
		linebreak = findtext(message, "\n", linebreak)

	var/list/html_tags = list()
	var/static/html_locate_regex = regex("<.*>")
	var/tag_position = findtext(message, html_locate_regex)
	var/reading_tag = TRUE
	while(tag_position)
		if(reading_tag)
			if(message[tag_position] == ">")
				reading_tag = FALSE
				html_tags += tag_position
			else
				html_tags += tag_position
			tag_position++
		else
			tag_position = findtext(message, html_locate_regex, tag_position)
			reading_tag = TRUE

	var/atom/movable/screen/text/T = new()
	T.screen_loc = screen_position
	// screen_loc = "CENTER, CENTER" results in list(240, 240)"
	var/list/offsets = screen_loc_to_offset(T.screen_loc, world.view)
	T.maptext_height -= offsets[2]
	switch(text_alignment)
		if("center")
			var/closest_edge = min(offsets[1], 480 - offsets[1])
			T.maptext_width = closest_edge * 2
			T.maptext_x = -(T.maptext_width * 0.5 - 16) //Centering the textbox.
		if("right")
			T.maptext_width = offsets[1]
			T.maptext_x = -(T.maptext_width - 32) //Aligning the textbox with the right edge of the screen object.
		if("left")
			T.maptext_width -= offsets[1]

	if(scroll_down)
		T.maptext_y = length(linebreaks) * 14

	for(var/mob/M as anything in targets)
		if(blurb_key)
			if(!ignore_key && (M.key in GLOB.blurb_witnesses[blurb_key]))
				continue
			GLOB.blurb_witnesses[blurb_key] |= M.key
		M.client?.screen += T

	for(var/i in 1 to length(message) + 1)
		if(i in linebreaks)
			if(scroll_down)
				T.maptext_y -= 14 //Move the object to keep lines in the same place.
			continue
		if(i in html_tags)
			continue
		T.maptext = MAPTEXT("<span style=\"[style]\">[copytext(message, 1, i)]</span>")
		if(speed)
			sleep(speed)

	addtimer(CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(fade_blurb), targets, T, fade_time), duration)

/proc/fade_blurb(list/mob/targets, obj/T, fade_time = 0.5 SECONDS)
	animate(T, alpha = 0, time = fade_time)
	sleep(fade_time)
	for(var/mob/M as anything in targets)
		M.client?.screen -= T
	qdel(T)

/proc/show_blurb_all(duration = 3 SECONDS, message, fade_time = 0.5 SECONDS, scroll_down, screen_position = "LEFT+0:16,BOTTOM+1:16",\
	text_alignment = "left", text_color = "#FFFFFF", blurb_key, ignore_key = FALSE, speed = 0.5)
	show_blurb(GLOB.player_list, duration, message, fade_time, scroll_down, screen_position, text_alignment, text_color, blurb_key, ignore_key, speed)
