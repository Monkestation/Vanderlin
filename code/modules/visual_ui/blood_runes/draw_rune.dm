
/obj/abstract/visual_ui_element/hoverable/rune_word
	icon = 'icons/visual_ui/runes/32x32.dmi'
	icon_state = "rune_back"
	layer = VISUAL_UI_BUTTON
	element_flags = MINDUI_FLAG_HOVERINFO
	var/word = ""
	var/image/word_overlay

/obj/abstract/visual_ui_element/hoverable/rune_word/appear()
	. = ..()
	if (word && !mouse_opacity)
		mouse_opacity = MOUSE_OPACITY_ICON
		flick("rune_appear", src)

/obj/abstract/visual_ui_element/hoverable/rune_word/proc/get_word_order()
	var/datum/visual_ui/bloodcult_runes/P = parent
	if(word && P.queued_rune)
		var/datum/rune_word/instance_1 = initial(P.queued_rune.word1)
		if (initial(instance_1.english) == word)
			return 1
		var/datum/rune_word/instance_2 = initial(P.queued_rune.word2)
		if (initial(instance_2.english) == word)
			return 2
		var/datum/rune_word/instance_3 = initial(P.queued_rune.word3)
		if (initial(instance_3.english) == word)
			return 3
	return 0

/obj/abstract/visual_ui_element/hoverable/rune_word/hide()
	if (mouse_opacity)
		mouse_opacity = MOUSE_OPACITY_TRANSPARENT
		overlays.len = 0
		if (word_overlay)
			animate(word_overlay, alpha = 0, time = 2)
			overlays += word_overlay
		icon_state = "blank"
		if (word)
			flick("rune_hide", src)
	spawn(10)
		..()

/obj/abstract/visual_ui_element/hoverable/rune_word/Click()
	var/mob/M = get_user()
	if (M)
		write_rune(word, M)
		if (get_word_order() == 3 && icon_state == "rune_1")
			var/datum/visual_ui/bloodcult_runes/P = parent
			P.queued_rune = null
		parent.display()

/proc/write_rune(word_to_draw, mob/living/user)
	if (user.incapacitated())
		return

	var/muted = user.occult_muted()
	if (muted)
		to_chat(user, span_danger("You find yourself unable to focus your mind on the words of Nar-Sie.") )
		return

	if(!istype(user.loc, /turf))
		to_chat(user, span_warning("You do not have enough space to write a proper rune.") )
		return

	var/turf/T = get_turf(user)
	var/obj/effect/blood_rune/rune = locate() in T

	if(rune)
		if (rune.invisibility == INVISIBILITY_OBSERVER)
			to_chat(user, span_warning("You can feel the presence of a concealed rune here. You have to reveal it before you can add more words to it.") )
			return
		else if (rune.word1 && rune.word2 && rune.word3)
			to_chat(user, span_warning("You cannot add more than 3 words to a rune.") )
			return

	var/datum/rune_word/word = GLOB.rune_words[word_to_draw]
	var/list/rune_blood_data = use_available_blood(user, 1, feedback = TRUE)
	if (rune_blood_data[BLOODCOST_RESULT] == BLOODCOST_FAILURE)
		return

	if(rune)
		user.visible_message(span_warning("\The [user] chants and paints more symbols on the floor.") , \
				span_warning("You add another word to the rune.") , \
				span_warning("You hear chanting.") )
	else
		user.visible_message(span_warning("\The [user] begins to chant and paint symbols on the floor.") , \
				span_warning("You begin drawing a rune on the floor.") , \
				span_warning("You hear some chanting.") )

	if(!user.has_taboo(TATTOO_SILENT))
		user.whisper("...[word.rune]...")

	if(rune)
		if(rune.word1 && rune.word2 && rune.word3)
			to_chat(user, span_warning("You cannot add more than 3 words to a rune.") )
			return
	write_rune_word(get_turf(user), word, rune_blood_data["blood"], caster = user)

/obj/abstract/visual_ui_element/hoverable/rune_word/UpdateIcon(appear = FALSE)
	overlays.len = 0

	if (hovering)
		overlays += "select"

	if (word)
		icon_state = "rune_back"

		var/datum/visual_ui/bloodcult_runes/P = parent
		if(P.queued_rune)
			var/mob/user = get_user()
			var/turf/T = get_turf(user)
			var/obj/effect/blood_rune/rune = locate() in T

			if(!rune || !rune.word1)
				icon_state = "rune_[get_word_order()]"
			else if (rune.word1.type == initial(P.queued_rune.word1))
				if(!rune.word2)
					icon_state = "rune_[max(0, get_word_order() - 1)]"
				else if (rune.word2.type == initial(P.queued_rune.word2))
					if (!rune.word3)
						icon_state = "rune_[max(0, get_word_order() - 2)]"

		var/blood_color = COLOR_BLOOD
		var/mob/living/L = get_user()
		var/datum/blood_type/blood = L.get_blood_type()
		blood_color = blood?.color || COLOR_BLOOD
		var/datum/rune_word/W = GLOB.rune_words[word]
		word_overlay = image('icons/deityrunes.dmi', src, word)
		var/image/rune_tear = image('icons/deityrunes.dmi', src, "[word]-tear")
		word_overlay.color = blood_color
		rune_tear.color = "black"
		word_overlay.overlays += rune_tear
		word_overlay.pixel_x = W.offset_x
		word_overlay.pixel_y = W.offset_y
		if (appear)
			word_overlay.alpha = 0
			animate(word_overlay, alpha = 255, time = 5)
		overlays += word_overlay

/obj/abstract/visual_ui_element/hoverable/rune_word/start_hovering(location, control, params)
	hovering = TRUE
	UpdateIcon()

/obj/abstract/visual_ui_element/hoverable/rune_word/stop_hovering()
	hovering = FALSE
	UpdateIcon()

////////////////////////////////////////////////////////////////////
//																  //
//					BLOODCULT - RUNE WRITING					  //
//																  //
////////////////////////////////////////////////////////////////////

/datum/visual_ui/bloodcult_runes
	uniqueID = "Bloodcult Runes"
	element_types_to_spawn = list(
		/obj/abstract/visual_ui_element/hoverable/rune_close,
		/obj/abstract/visual_ui_element/hoverable/rune_word/rune_travel,
		/obj/abstract/visual_ui_element/hoverable/rune_word/rune_blood,
		/obj/abstract/visual_ui_element/hoverable/rune_word/rune_join,
		/obj/abstract/visual_ui_element/hoverable/rune_word/rune_hell,
		/obj/abstract/visual_ui_element/hoverable/rune_word/rune_destroy,
		/obj/abstract/visual_ui_element/hoverable/rune_word/rune_technology,
		/obj/abstract/visual_ui_element/hoverable/rune_word/rune_self,
		/obj/abstract/visual_ui_element/hoverable/rune_word/rune_see,
		/obj/abstract/visual_ui_element/hoverable/rune_word/rune_other,
		/obj/abstract/visual_ui_element/hoverable/rune_word/rune_hide,
		)
	display_with_parent = FALSE
	offset_layer = VISUAL_UI_GROUP_D
	never_move = TRUE
	var/datum/rune_spell/queued_rune = null

/datum/visual_ui/bloodcult_runes/display()
	..()
	if(queued_rune)
		var/mob/user = get_user()
		var/turf/T = get_turf(user)
		var/obj/effect/blood_rune/rune = locate() in T
		if(rune)
			if (rune.word1 && rune.word1.type != initial(queued_rune.word1))
				to_chat(user, span_warning("This rune's first word conflicts with the [initial(queued_rune.name)] rune's syntax.") )
			else if (rune.word2 && rune.word2.type != initial(queued_rune.word2))
				to_chat(user, span_warning("This rune's second word conflicts with the [initial(queued_rune.name)] rune's syntax.") )
			else if (rune.word3)
				to_chat(user, span_warning("You cannot add more than 3 words to a rune.") )

//------------------------------------------------------------

/obj/abstract/visual_ui_element/hoverable/rune_close
	name = "Hide Interface"
	icon = 'icons/visual_ui/runes/32x32.dmi'
	icon_state = "return"
	layer = VISUAL_UI_BUTTON

/obj/abstract/visual_ui_element/hoverable/rune_close/start_hovering(location, control, params)
	hovering = TRUE
	UpdateIcon()

/obj/abstract/visual_ui_element/hoverable/rune_close/stop_hovering()
	hovering = FALSE
	UpdateIcon()

/obj/abstract/visual_ui_element/hoverable/rune_close/Click()
	parent.hide()
	var/datum/visual_ui/bloodcult_runes/P = parent
	P.queued_rune = null

/obj/abstract/visual_ui_element/hoverable/rune_close/UpdateIcon()
	overlays.len = 0
	if (hovering)
		overlays += "select"

//------------------------------------------------------------

/obj/abstract/visual_ui_element/hoverable/rune_word/rune_travel
	name = "Travel"
	word = "travel"
	offset_x = -61
	offset_y = 19

//------------------------------------------------------------

/obj/abstract/visual_ui_element/hoverable/rune_word/rune_blood
	name = "Blood"
	word = "blood"
	offset_x = -37
	offset_y = 52

//------------------------------------------------------------

/obj/abstract/visual_ui_element/hoverable/rune_word/rune_join
	name = "Join"
	word = "join"
	offset_x = 0
	offset_y = 64

//------------------------------------------------------------

/obj/abstract/visual_ui_element/hoverable/rune_word/rune_hell
	name = "Hell"
	word = "hell"
	offset_x = 37
	offset_y = 52

//------------------------------------------------------------

/obj/abstract/visual_ui_element/hoverable/rune_word/rune_destroy
	name = "Destroy"
	word = "destroy"
	offset_x = 61
	offset_y = 19

//------------------------------------------------------------

/obj/abstract/visual_ui_element/hoverable/rune_word/rune_technology
	name = "Technology"
	word = "technology"
	offset_x = 61
	offset_y = -19

//------------------------------------------------------------

/obj/abstract/visual_ui_element/hoverable/rune_word/rune_self
	name = "Self"
	word = "self"
	offset_x = 37
	offset_y = -52

//------------------------------------------------------------

/obj/abstract/visual_ui_element/hoverable/rune_word/rune_see
	name = "See"
	word = "see"
	offset_x = 0
	offset_y = -64

//------------------------------------------------------------

/obj/abstract/visual_ui_element/hoverable/rune_word/rune_other
	name = "Other"
	word = "other"
	offset_x = -37
	offset_y = -52

//------------------------------------------------------------

/obj/abstract/visual_ui_element/hoverable/rune_word/rune_hide
	name = "Hide"
	word = "hide"
	offset_x = -61
	offset_y = -19

//------------------------------------------------------------


//example: add_zero_before_and_after(3.14, 3, 5) = "003.14000"
/proc/add_zero_before_and_after(_string, beforeZeroes, afterZeroes)
	var/string = "[_string]"
	var/dot_pos = findtext(string, ".")
	if (dot_pos)
		dot_pos--
		while (dot_pos < beforeZeroes)
			string = "0[string]"
			dot_pos++
		while (length(string) < (beforeZeroes+afterZeroes+1))
			string = "[string]0"
	else
		while (length(string) < beforeZeroes)
			string = "0[string]"
		string = "[string]."
		while (length(string) < (beforeZeroes+afterZeroes+1))
			string = "[string]0"
	return string

