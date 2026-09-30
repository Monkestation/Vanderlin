/datum/preference/toggle/permadeath
	savefile_key = "permadeath"
	savefile_identifier = PREF_CHARACTER
	category = "character"
	default_value = FALSE

/datum/preference/toggle/permadeath/apply_to_human(mob/living/carbon/human/H, value, datum/preferences/prefs)
	H.permadeath_enabled = value

/datum/preference/toggle/permadeath/handle_link(datum/preferences/prefs, mob/user)
	var/current = prefs.read_preference(/datum/preference/toggle/permadeath)
	var/confirm = tgui_alert(user, "[current ? "Disable" : "Enable"] permadeath for this character? If enabled, this character can NEVER be revived by any means once dead.", "Permadeath", list("Yes", "No"))
	if(confirm != "Yes")
		return
	prefs.write_preference(/datum/preference/toggle/permadeath, !current)
	to_chat(user, span_boldwarning("Permadeath is now [!current ? "ENABLED" : "disabled"]."))