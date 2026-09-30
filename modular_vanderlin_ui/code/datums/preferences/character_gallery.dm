/datum/preference/list_type/character_gallery
	savefile_key = "character_gallery"
	savefile_identifier = PREF_CHARACTER
	category = "character_ooc"

/datum/preference/list_type/character_gallery/apply_to_human(mob/living/carbon/human/H, value, datum/preferences/prefs)
	H.character_gallery = value

/datum/preference/list_type/character_gallery/handle_link(datum/preferences/prefs, mob/user)
	var/list/current = prefs.read_preference(/datum/preference/list_type/character_gallery)
	if(!current)
		current = list()
	var/choice = tgui_alert(user, "Character Gallery - what would you like to do?", "Gallery", list("Add Image", "Remove Image", "Cancel"))
	if(choice == "Add Image")
		if(length(current) >= 5)
			to_chat(user, span_warning("Gallery is full (maximum 5 images). Remove one first."))
			return
		var/new_link = input(user, "Input image link (https, hosts: gyazo, lensdump, imgbox, catbox):", "Add Gallery Image") as text|null
		if(!new_link)
			return
		if(!is_valid_headshot_link(user, new_link, FALSE))
			return
		current += new_link
		prefs.write_preference(/datum/preference/list_type/character_gallery, current)
		to_chat(user, span_notice("Image added to gallery."))
	else if(choice == "Remove Image")
		if(!length(current))
			to_chat(user, span_warning("Gallery is empty."))
			return
		var/to_remove = input(user, "Select image to remove:", "Remove Gallery Image") as null|anything in current
		if(!to_remove)
			return
		current -= to_remove
		prefs.write_preference(/datum/preference/list_type/character_gallery, current)
		to_chat(user, span_notice("Image removed from gallery."))