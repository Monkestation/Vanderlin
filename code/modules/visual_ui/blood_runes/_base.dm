GLOBAL_LIST_INIT(blood_communion, list())
////////////////////////////////////////////////////////////////////
//																  //
//					BLOODCULT - CULTIST							  //
//																  //
////////////////////////////////////////////////////////////////////

/datum/visual_ui/bloodcult_cultist
	uniqueID = "Cultist"
	sub_uis_to_spawn = list(
		/datum/visual_ui/bloodcult_cultist_panel,
		)
	display_with_parent = TRUE
	y = "BOTTOM"


////////////////////////////////////////////////////////////////////
//																  //
//					BLOODCULT - RUNEDRAW						  //
//																  //
////////////////////////////////////////////////////////////////////

/datum/visual_ui/bloodcult_cultist_panel
	uniqueID = "Cultist Panel"
	element_types_to_spawn = list(
		/obj/abstract/visual_ui_element/hoverable/draw_runes_manual,
		/obj/abstract/visual_ui_element/hoverable/draw_runes_guided,
		/obj/abstract/visual_ui_element/hoverable/erase_runes,
//		/obj/abstract/visual_ui_element/hoverable/movable/cultist,
		)
	sub_uis_to_spawn = list(
		/datum/visual_ui/bloodcult_runes,
		)
	display_with_parent = TRUE
	offset_layer = VISUAL_UI_GROUP_C
	y = "BOTTOM"

//------------------------------------------------------------

/obj/abstract/visual_ui_element/hoverable/draw_runes_manual
	name = "Trace Runes Manually"
	desc = "(1 BLOOD PER WORD) Use available blood to write down words. Three words form a rune."
	icon = 'icons/visual_ui/runes/32x32.dmi'
	icon_state = "rune_manual"
	layer = VISUAL_UI_BUTTON
	offset_x = 111
	offset_y = 39
	mouse_opacity = 1

/obj/abstract/visual_ui_element/hoverable/draw_runes_manual/Click()
	flick("rune_manual-click", src)
	var/mob/M = get_user()
	if (M)
		M.display_ui("Bloodcult Runes")

//------------------------------------------------------------

/obj/abstract/visual_ui_element/hoverable/draw_runes_guided
	name = "Trace Rune with a Guide"
	desc = "(1 BLOOD PER WORD) Use available blood to write down words. Three words form a rune. Access a list of the well known runes."
	icon = 'icons/visual_ui/runes/32x32.dmi'
	icon_state = "rune_guide"
	layer = VISUAL_UI_BUTTON
	offset_x = 111
	offset_y = 39
	mouse_opacity = 1

/obj/abstract/visual_ui_element/hoverable/draw_runes_guided/Click()
	if (!hover_state)
		return
	flick("rune_guide-click", src)
	var/mob/M = get_user()
	if (M)
		var/list/available_runes = list()
		var/i = 1
		for(var/datum/rune_spell/instance as anything in subtypesof(/datum/rune_spell))
			if (initial(instance.secret))
				continue
			available_runes.Add("[initial(instance.name)] - \Roman[i]")
			available_runes["[initial(instance.name)] - \Roman[i]"] = instance
			i++
		var/spell_name = input(M, "Remember how to trace a given rune.", "Trace Rune with a Guide", null) as null|anything in available_runes

		if (spell_name)
			for(var/datum/visual_ui/bloodcult_runes/BR in parent.subUIs)
				BR.queued_rune = available_runes[spell_name]

				M.display_ui("Bloodcult Runes")
				break

//------------------------------------------------------------

/obj/abstract/visual_ui_element/hoverable/erase_runes
	name = "Erase Rune"
	desc = "Remove the last word written of the rune you're standing above."
	icon = 'icons/visual_ui/runes/16x32.dmi'
	icon_state = "rune_erase"
	layer = VISUAL_UI_BUTTON
	offset_x = 95
	offset_y = 39
	mouse_opacity = 1

/obj/abstract/visual_ui_element/hoverable/erase_runes/Click()
	flick("rune_erase-click", src)
	var/mob/M = get_user()
	if (M)
		erase_rune(M)

/proc/erase_rune(mob/living/user )
	if (!istype(user))
		return

	if (user.incapacitated())
		return

	var/turf/T = get_turf(user)
	var/obj/effect/blood_rune/rune = locate() in T

	if (rune && rune.invisibility == INVISIBILITY_OBSERVER)
		to_chat(user, span_warning("You can feel the presence of a concealed rune here, you have to reveal it before you can erase words from it.") )
		return

	var/removed_word = erase_rune_word(get_turf(user))
	if (removed_word)
		to_chat(user, span_notice("You retrace your steps, carefully undoing the lines of the [removed_word] rune.") )
	else
		to_chat(user, span_warning("There aren't any rune words left to erase.") )

//------------------------------------------------------------
/*
/obj/abstract/visual_ui_element/hoverable/movable/cultist
	name = "Move Interface (Click and Drag)"
	icon = 'icons/visual_ui/runes/16x32.dmi'
	icon_state = "rune_move"
	layer = VISUAL_UI_BUTTON
	offset_x = 143
	offset_y = 39
	mouse_opacity = 1

	move_whole_ui = TRUE

	const_offset_y = -32
	const_offset_x = -256
*/
