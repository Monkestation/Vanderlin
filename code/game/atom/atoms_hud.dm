/**
 * set every hud image in the given category active so other people with the given hud can see it.
 * Arguments:
 * * hud_category - the index in our active_hud_list corresponding to an image now being shown.
 * * update_huds - if FALSE we will just put the hud_category into active_hud_list without actually updating the atom_hud datums subscribed to it
 * * exclusive_hud - if given a reference to an atom_hud, will just update that hud instead of all global ones attached to that category.
 * This is because some atom_hud subtypes arent supposed to work via global categories, updating normally would affect all of these which we dont want.
 */
/atom/proc/set_hud_image_active(hud_category, update_huds = TRUE, datum/atom_hud/exclusive_hud)
	if(!istext(hud_category) || !hud_list?[hud_category] || active_hud_list?[hud_category])
		return FALSE

	LAZYSET(active_hud_list, hud_category, hud_list[hud_category])

	if(!update_huds)
		return TRUE

	if(exclusive_hud)
		exclusive_hud.add_single_hud_category_on_atom(src, hud_category)
	else
		for(var/datum/atom_hud/hud_to_update as anything in GLOB.huds_by_category[hud_category])
			hud_to_update.add_single_hud_category_on_atom(src, hud_category)

	return TRUE

///sets every hud image in the given category inactive so no one can see it
/atom/proc/set_hud_image_inactive(hud_category, update_huds = TRUE, datum/atom_hud/exclusive_hud)
	if(!istext(hud_category))
		return FALSE

	if(!update_huds)
		LAZYREMOVE(active_hud_list, hud_category)
		return TRUE

	if(exclusive_hud)
		exclusive_hud.remove_single_hud_category_on_atom(src, hud_category)
	else
		for(var/datum/atom_hud/hud_to_update as anything in GLOB.huds_by_category[hud_category])
			hud_to_update.remove_single_hud_category_on_atom(src, hud_category)

	LAZYREMOVE(active_hud_list, hud_category)

	return TRUE

/**
 * Prepare the huds for this atom
 *
 * Goes through hud_possible list and adds the images to the hud_list variable (if not already cached)
 */
/atom/proc/prepare_huds()
	if(hud_list) // I choose to be lenient about people calling this proc more then once
		return

	hud_list = list()
	for(var/hud in hud_possible)
		var/hint = hud_possible[hud]

		if(hint == HUD_LIST_LIST)
			hud_list[hud] = list()

		else
			var/image/I = image('icons/mob/hud.dmi', src, "")
			I.appearance_flags = RESET_COLOR|PIXEL_SCALE|KEEP_APART
			hud_list[hud] = I
		set_hud_image_active(hud, update_huds = FALSE) //by default everything is active. but dont add it to huds to keep control.
