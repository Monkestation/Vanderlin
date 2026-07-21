/datum/preference/text/ooc_extra
	savefile_key = "ooc_extra"
	savefile_identifier = PREF_CHARACTER
	category = "character_ooc"
	can_randomize = FALSE
	maximum_value_length = 512
	should_update_preview = FALSE

/datum/preference/text/ooc_extra/apply_to_human(mob/living/carbon/human/H, value, datum/preferences/prefs)
	H.ooc_extra = value

/datum/preference/text/ooc_extra/handle_link(datum/preferences/prefs, mob/user)
	if(!prefs.donator)
		to_chat(user, "This is a donator exclusive feature, your OOC Extra link will be applied but others will only be able to view it if you are a patreon supporter or Twitch Subscriber.")

	to_chat(user, span_notice("Add a link from a suitable host (catbox, etc) to an mp3, mp4, or jpg / png file to have it embed at the bottom of your OOC notes."))
	to_chat(user, span_notice("If the link doesn't show up properly in-game, ensure that it's a direct link that opens properly in a browser."))
	to_chat(user, span_notice("Videos will be shrunk to a ~300x300 square. Keep this in mind."))
	to_chat(user, "<font color = '#d6d6d6'>Leave a single space to delete it from your OOC notes.</font>")
	to_chat(user, "<font color ='red'>Abuse of this will get you banned.</font>")
	var/new_extra_link = input(user, "Input the accessory link (https, hosts: gyazo, discord, lensdump, imgbox, catbox):", "OOC Extra", prefs.read_preference(/datum/preference/text/ooc_extra_link)) as text|null
	if(new_extra_link == null)
		return
	if(new_extra_link == "")
		new_extra_link = null
		prefs.update_menu_data(user)
		return
	if(new_extra_link == " ")	//Single space to delete
		prefs.write_preference(/datum/preference/text/ooc_extra, null)
		prefs.write_preference(/datum/preference/text/ooc_extra_link, null)
		to_chat(user, span_notice("Successfully deleted OOC Extra."))
	var/static/list/valid_extensions = list("jpg", "png", "jpeg", "gif", "mp4", "mp3")
	if(!is_valid_headshot_link(user, new_extra_link, FALSE, valid_extensions))
		new_extra_link = null
		prefs.update_menu_data(user)
		return

	var/list/value_split = splittext(new_extra_link, ".")

	// extension will always be the last entry
	var/extension = value_split[length(value_split)]
	var/info
	if(extension in valid_extensions)
		prefs.write_preference(/datum/preference/text/ooc_extra_link, new_extra_link)
		var/ooc_extra = null
		ooc_extra = "<div align ='center'><center>"
		if(extension == "jpg" || extension == "png" || extension == "jpeg" || extension == "gif")
			ooc_extra += "<br>"
			ooc_extra += "<img src='[prefs.read_preference(/datum/preference/text/ooc_extra_link)]'/>"
			info = "an embedded image."
		else
			switch(extension)
				if("mp4")
					ooc_extra = "<br>"
					ooc_extra += "<video width=["288"] height=["288"] controls=["true"]>"
					ooc_extra += "<source src='[prefs.read_preference(/datum/preference/text/ooc_extra_link)]' type=["video/mp4"]>"
					ooc_extra += "</video>"
					info = "a video."
				if("mp3")
					ooc_extra = "<br>"
					ooc_extra += "<audio controls>"
					ooc_extra += "<source src='[prefs.read_preference(/datum/preference/text/ooc_extra_link)]' type=["audio/mp3"]>"
					ooc_extra += "Your browser does not support the audio element."
					ooc_extra += "</audio>"
					info = "embedded audio."
		ooc_extra += "</center></div>"
		to_chat(user, span_notice("Successfully updated OOC Extra with [info]"))
		log_game("[user] has set their OOC Extra to '[prefs.read_preference(/datum/preference/text/ooc_extra_link)]'.")
		prefs.write_preference(/datum/preference/text/ooc_extra, ooc_extra)
