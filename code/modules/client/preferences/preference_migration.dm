/// Migrate flat player preferences from old raw savefile data
/// into the new preference datum format.
/// `save_data` is the assoc list at the savefile root ("/").
/datum/preferences/proc/migrate_player_flat_to_preference(list/save_data)
	if (!islist(save_data))
		return

	#define TRY_MIGRATE_PREF(type, old_key) \
		preference_migrate_field(GLOB.preference_entries[type], save_data[old_key])

	TRY_MIGRATE_PREF(/datum/preference/choiced/ui_theme, "ui_theme")
	TRY_MIGRATE_PREF(/datum/preference/choiced/UI_style, "UI_style")
	TRY_MIGRATE_PREF(/datum/preference/choiced/char_theme, "char_theme")
	TRY_MIGRATE_PREF(/datum/preference/numeric/ui_scale, "ui_scale")
	TRY_MIGRATE_PREF(/datum/preference/choiced/scaling_method, "scaling_method")
	TRY_MIGRATE_PREF(/datum/preference/numeric/pixel_size, "pixel_size")
	TRY_MIGRATE_PREF(/datum/preference/toggle/tgui_fancy, "tgui_fancy")
	TRY_MIGRATE_PREF(/datum/preference/toggle/tgui_lock, "tgui_lock")
	TRY_MIGRATE_PREF(/datum/preference/toggle/buttons_locked, "buttons_locked")
	TRY_MIGRATE_PREF(/datum/preference/toggle/crt, "crt")
	TRY_MIGRATE_PREF(/datum/preference/toggle/auto_fit_viewport, "auto_fit_viewport")
	TRY_MIGRATE_PREF(/datum/preference/toggle/widescreenpref, "widescreenpref")
	TRY_MIGRATE_PREF(/datum/preference/toggle/windowflashing, "windowflash") // note old key
	TRY_MIGRATE_PREF(/datum/preference/toggle/ambientocclusion,"ambientocclusion")

	TRY_MIGRATE_PREF(/datum/preference/toggle/hotkeys, "hotkeys")
	TRY_MIGRATE_PREF(/datum/preference/toggle/showrolls, "showrolls")
	TRY_MIGRATE_PREF(/datum/preference/toggle/see_chat_non_mob, "see_chat_non_mob")
	TRY_MIGRATE_PREF(/datum/preference/toggle/anonymize, "anonymize")
	TRY_MIGRATE_PREF(/datum/preference/numeric/max_chat_length, "max_chat_length")
	TRY_MIGRATE_PREF(/datum/preference/color/ooccolor, "ooccolor")
	TRY_MIGRATE_PREF(/datum/preference/color/asaycolor, "asaycolor")
	TRY_MIGRATE_PREF(/datum/preference/text/oocpronouns, "oocpronouns")

	TRY_MIGRATE_PREF(/datum/preference/numeric/musicvol, "musicvol")
	TRY_MIGRATE_PREF(/datum/preference/numeric/mastervol, "mastervol")

	TRY_MIGRATE_PREF(/datum/preference/numeric/clientfps, "clientfps")

	TRY_MIGRATE_PREF(/datum/preference/choiced/ghost_form, "ghost_form")
	TRY_MIGRATE_PREF(/datum/preference/choiced/ghost_orbit, "ghost_orbit")
	TRY_MIGRATE_PREF(/datum/preference/choiced/ghost_accs, "ghost_accs")
	TRY_MIGRATE_PREF(/datum/preference/choiced/ghost_others, "ghost_others")
	TRY_MIGRATE_PREF(/datum/preference/toggle/ghost_hud, "ghost_hud")
	TRY_MIGRATE_PREF(/datum/preference/toggle/inquisitive_ghost, "inquisitive_ghost")

	TRY_MIGRATE_PREF(/datum/preference/toggle/enable_tips, "enable_tips")
	TRY_MIGRATE_PREF(/datum/preference/numeric/tip_delay, "tip_delay")
	TRY_MIGRATE_PREF(/datum/preference/toggle/multi_char_ready, "multi_char_ready")

	TRY_MIGRATE_PREF(/datum/preference/bitwise/toggles, "toggles")
	TRY_MIGRATE_PREF(/datum/preference/bitwise/chat_toggles, "chat_toggles")
	TRY_MIGRATE_PREF(/datum/preference/bitwise/toggles_maptext, "toggles_maptext")
	TRY_MIGRATE_PREF(/datum/preference/bitwise/toggles_gameplay, "toggles_gameplay")

	#undef TRY_MIGRATE_PREF

/// Migrate flat character preferences from old raw savefile data
/// into the new preference datum format.
/// `save_data` is the assoc list at "/character[N]".
/datum/preferences/proc/migrate_character_flat_to_preference(list/save_data)
	if (!islist(save_data))
		return

	#define TRY_MIGRATE_PREF(type, old_key) \
		preference_migrate_field(GLOB.preference_entries[type], save_data[old_key])

	TRY_MIGRATE_PREF(/datum/preference/text/real_name, "real_name")
	TRY_MIGRATE_PREF(/datum/preference/choiced/gender, "gender")
	TRY_MIGRATE_PREF(/datum/preference/choiced/pronouns, "pronouns")
	TRY_MIGRATE_PREF(/datum/preference/choiced/voice_type, "voice_type")
	TRY_MIGRATE_PREF(/datum/preference/choiced/age, "age")
	TRY_MIGRATE_PREF(/datum/preference/choiced/domhand, "domhand")
	TRY_MIGRATE_PREF(/datum/preference/choiced/selected_accent,"selected_accent")
	TRY_MIGRATE_PREF(/datum/preference/text/family, "family")
	TRY_MIGRATE_PREF(/datum/preference/text/setspouse, "setspouse")
	TRY_MIGRATE_PREF(/datum/preference/choiced/gender_choice, "gender_choice")

	TRY_MIGRATE_PREF(/datum/preference/choiced/species, "species")
	TRY_MIGRATE_PREF(/datum/preference/choiced/patron, "selected_patron")
	TRY_MIGRATE_PREF(/datum/preference/choiced/culture, "culture")

	TRY_MIGRATE_PREF(/datum/preference/choiced/skin_tone, "skin_tone")
	TRY_MIGRATE_PREF(/datum/preference/color/voice_color, "voice_color")
	TRY_MIGRATE_PREF(/datum/preference/color/detail_color, "detail_color")
	TRY_MIGRATE_PREF(/datum/preference/color/underwear_color,"underwear_color")

	TRY_MIGRATE_PREF(/datum/preference/choiced/underwear, "underwear")
	TRY_MIGRATE_PREF(/datum/preference/choiced/undershirt, "undershirt")
	TRY_MIGRATE_PREF(/datum/preference/choiced/accessory, "accessory")
	TRY_MIGRATE_PREF(/datum/preference/choiced/detail, "detail")
	TRY_MIGRATE_PREF(/datum/preference/choiced/socks, "socks")

	TRY_MIGRATE_PREF(/datum/preference/text/flavortext, "flavortext")
	TRY_MIGRATE_PREF(/datum/preference/text/flavortext_display,"flavortext_display")
	TRY_MIGRATE_PREF(/datum/preference/text/ooc_notes, "ooc_notes")
	TRY_MIGRATE_PREF(/datum/preference/text/ooc_notes_display, "ooc_notes_display")
	TRY_MIGRATE_PREF(/datum/preference/text/ooc_extra, "ooc_extra")
	TRY_MIGRATE_PREF(/datum/preference/text/ooc_extra_link, "ooc_extra_link")
	TRY_MIGRATE_PREF(/datum/preference/text/headshot_link, "headshot_link")

	TRY_MIGRATE_PREF(/datum/preference/choiced/joblessrole, "joblessrole")

	#undef TRY_MIGRATE_PREF

/// Attempt to deserialise `raw_value` through `pref` and store the
/// result in preference_cache. On null input or validation failure does
/// nothing, read_preference() will produce a clean default later.
/datum/preferences/proc/preference_migrate_field(datum/preference/pref, raw_value)
	if (isnull(pref))
		return // type not registered, skip silently

	if (isnull(raw_value))
		return // field absent in old savefile, let default kick in

	var/typed = pref.deserialize(raw_value, src)
	if (isnull(typed))
		return // bad value (e.g. corrupt hex colour), use default

	if (!pref.is_valid(typed, src))
		return // failed validation, use default

	// save_character() will flush everything to disk after migration.
	preference_cache[pref.type] = typed
