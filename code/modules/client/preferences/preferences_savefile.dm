//This is the lowest supported version, anything below this is completely obsolete and the entire savefile will be wiped.
#define SAVEFILE_VERSION_MIN 18

//This is the current version, anything below this will attempt to update (if it's not obsolete)
//	You do not need to raise this if you are adding new values that have sane defaults.
//	Only raise this value when changing the meaning/format/name/layout of an existing value
//	where you would want the updater procs below to run
#define SAVEFILE_VERSION_MAX 32

/*
SAVEFILE UPDATING/VERSIONING - 'Simplified', or rather, more coder-friendly ~Carn
	This proc checks if the current directory of the savefile S needs updating
	It is to be used by the load_character and load_preferences procs.
	(S.cd=="/" is preferences, S.cd=="/character[integer]" is a character slot, etc)

	if the current directory's version is below SAVEFILE_VERSION_MIN it will simply wipe everything in that directory
	(if we're at root "/" then it'll just wipe the entire savefile, for instance.)

	if its version is below SAVEFILE_VERSION_MAX but above the minimum, it will load data but later call the
	respective update_preferences() or update_character() proc.
	Those procs allow coders to specify format changes so users do not lose their setups and have to redo them again.

	Failing all that, the standard sanity checks are performed. They simply check the data is suitable, reverting to
	initial() values if necessary.
*/
/datum/preferences/proc/savefile_needs_update(savefile/S)
	var/savefile_version
	S["version"] >> savefile_version

	if(savefile_version < SAVEFILE_VERSION_MIN)
		S.dir.Cut()
		return -2

	if(savefile_version < SAVEFILE_VERSION_MAX)
		return savefile_version

	return -1

//should these procs get fairly long
//just increase SAVEFILE_VERSION_MIN so it's not as far behind
//SAVEFILE_VERSION_MAX and then delete any obsolete if clauses
//from these procs.
//This only really meant to avoid annoying frequent players
//if your savefile is 3 months out of date, then 'tough shit'.

/datum/preferences/proc/update_preferences(current_version, savefile/S)
	if(current_version < 29)
		key_bindings = (hotkeys) ? deepCopyList(GLOB.hotkey_keybinding_list_by_key) : deepCopyList(GLOB.classic_keybinding_list_by_key)
		parent.update_movement_keys()
		to_chat(parent, "<span class='danger'>Empty keybindings, setting default to [hotkeys ? "Hotkey" : "Classic"] mode</span>")

/datum/preferences/proc/update_character(current_version, savefile/S)
	if(current_version < 22)
		job_preferences = list() //It loaded null from nonexistant savefile field.

		//Can't use SSjob here since this happens right away on login
		for(var/datum/job/J as anything in subtypesof(/datum/job))
			var/new_value
			if(new_value)
				job_preferences[initial(J.title)] = new_value

	if(current_version < 24)
		if (!(underwear in GLOB.underwear_list))
			underwear = "Nude"

	if(current_version < 25)
		randomise = list(RANDOM_UNDERWEAR = TRUE, RANDOM_UNDERWEAR_COLOR = TRUE, RANDOM_UNDERSHIRT = TRUE, RANDOM_SKIN_TONE = TRUE, RANDOM_EYE_COLOR = TRUE)
		if(S["name_is_always_random"] == 1)
			randomise[RANDOM_NAME] = TRUE
		if(S["body_is_always_random"] == 1)
			randomise[RANDOM_BODY] = TRUE
		if(S["species_is_always_random"] == 1)
			randomise[RANDOM_SPECIES] = TRUE

	if(current_version < 30)
		S["voice_color"] >> voice_color

	// Restructuring of skin tones and culture addition
	if(current_version < 31)
		var/datum/culture/culture = S["culture"]
		if(!culture)
			culture = /datum/culture/universal/ambiguous
			WRITE_FILE(S["culture"], culture)

		var/list/assoc_skins = pref_species.get_skin_list()
		// If current skin tone matches one of the current list, we are fine
		for(var/skin in assoc_skins)
			if(skin_tone != assoc_skins[skin]) // otherwise its gambling time
				skin_tone = pick_assoc(assoc_skins)
				break

	if(current_version < 32)
		var/species_name = S["species"]
		for(var/species_id in GLOB.species_list)
			var/datum/species/species_type = GLOB.species_list[species_id]
			if(species_type::name == species_name)
				pref_species = new species_type()
				WRITE_FILE(S["species"], pref_species.id)

/datum/preferences/proc/load_path(ckey,filename="preferences.sav")
	if(!ckey)
		return
	path = "data/player_saves/[copytext(ckey,1,2)]/[ckey]/[filename]"

/datum/preferences/proc/load_preferences()
	if(!path)
		return FALSE
	if(!fexists(path))
		return FALSE

	var/savefile/S = new /savefile(path)
	if(!S)
		return FALSE
	S.cd = "/"
	var/needs_update = savefile_needs_update(S)
	if(needs_update == -2)		//fatal, can't load any data
		return FALSE

	//general preferences
	S["asaycolor"]			>> asaycolor
	S["ooccolor"]			>> ooccolor
	S["oocpronouns"]		>> oocpronouns
	S["admin_ghost_icon"]	>> admin_ghost_icon
	S["ui_theme"]			>> ui_theme
	S["char_theme"]			>> char_theme
	S["lastchangelog"]		>> lastchangelog
	S["UI_style"]			>> UI_style
	S["hotkeys"]			>> hotkeys
	S["showrolls"]			>> showrolls
	S["max_chat_length"]	>> max_chat_length
	S["see_chat_non_mob"] 	>> see_chat_non_mob
	S["tgui_fancy"]			>> tgui_fancy
	S["tgui_lock"]			>> tgui_lock
	S["buttons_locked"]		>> buttons_locked
	S["windowflash"]		>> windowflashing
	S["be_special"] 		>> be_special
	S["triumphs"]			>> triumphs
	S["musicvol"]			>> musicvol
	S["anonymize"]			>> anonymize
	S["crt"]				>> crt
	S["mastervol"]			>> mastervol
	S["lastclass"]			>> lastclass


	S["default_slot"]		>> default_slot
	S["chat_toggles"]		>> chat_toggles
	S["toggles"]			>> toggles
	S["toggles_maptext"]	>> toggles_maptext
	S["ghost_form"]			>> ghost_form
	S["ghost_orbit"]		>> ghost_orbit
	S["ghost_accs"]			>> ghost_accs
	S["ghost_others"]		>> ghost_others
	S["preferred_map"]		>> preferred_map
	S["ignoring"]			>> ignoring
	S["ghost_hud"]			>> ghost_hud
	S["inquisitive_ghost"]	>> inquisitive_ghost
	S["uses_glasses_colour"]>> uses_glasses_colour
	S["clientfps"]			>> clientfps
	S["parallax"]			>> parallax
	S["ambientocclusion"]	>> ambientocclusion
	S["auto_fit_viewport"]	>> auto_fit_viewport
	S["widescreenpref"]	    >> widescreenpref
	S["menuoptions"]		>> menuoptions
	S["enable_tips"]		>> enable_tips
	S["tip_delay"]			>> tip_delay
	S["ui_scale"]			>> ui_scale
	S["multi_char_ready"] >> multi_char_ready

	S["multi_ready_slots"] >> multi_ready_slots
	if(!islist(multi_ready_slots))
		multi_ready_slots = list()

	// Custom hotkeys
	S["key_bindings"]		>> key_bindings

	if(!char_theme)
		char_theme = "grimshart"
	//try to fix any outdated data if necessary
	if(needs_update >= 0)
		update_preferences(needs_update, S)		//needs_update = savefile_version if we need an update (positive integer)

	//Sanitize
	asaycolor = sanitize_ooccolor(sanitize_hexcolor(asaycolor, 6, 1, initial(asaycolor)))
	ooccolor = sanitize_ooccolor(sanitize_hexcolor(ooccolor, 6, 1, initial(ooccolor)))
	lastchangelog = sanitize_text(lastchangelog, initial(lastchangelog))
	UI_style = sanitize_inlist(UI_style, GLOB.available_ui_styles, GLOB.available_ui_styles[1])
	hotkeys = sanitize_integer(hotkeys, 0, 1, initial(hotkeys))
	showrolls = sanitize_integer(showrolls, 0, 1, initial(showrolls))
	max_chat_length = sanitize_integer(max_chat_length, 1, CHAT_MESSAGE_MAX_LENGTH, initial(max_chat_length))
	see_chat_non_mob = sanitize_integer(see_chat_non_mob, 0, 1, initial(see_chat_non_mob))
	tgui_fancy = sanitize_integer(tgui_fancy, 0, 1, initial(tgui_fancy))
	tgui_lock = sanitize_integer(tgui_lock, 0, 1, initial(tgui_lock))
	buttons_locked = sanitize_integer(buttons_locked, 0, 1, initial(buttons_locked))
	windowflashing = sanitize_integer(windowflashing, 0, 1, initial(windowflashing))
	default_slot = sanitize_integer(default_slot, 1, max_save_slots, initial(default_slot))
	toggles = sanitize_integer(toggles, 0, SHORT_REAL_LIMIT, initial(toggles))
	chat_toggles = sanitize_integer(chat_toggles, 0, SHORT_REAL_LIMIT, initial(chat_toggles))
	toggles_maptext = sanitize_integer(toggles_maptext, 0, SHORT_REAL_LIMIT, initial(toggles_maptext))
	clientfps = sanitize_integer(clientfps, 0, 1000, 0)
	parallax = sanitize_integer(parallax, PARALLAX_INSANE, PARALLAX_DISABLE, null)
	ambientocclusion = sanitize_integer(ambientocclusion, 0, 1, initial(ambientocclusion))
	auto_fit_viewport = sanitize_integer(auto_fit_viewport, 0, 1, initial(auto_fit_viewport))
	widescreenpref = sanitize_integer(widescreenpref, 0, 1, initial(widescreenpref))
	ghost_form = sanitize_inlist(ghost_form, GLOB.ghost_forms, initial(ghost_form))
	ghost_orbit = sanitize_inlist(ghost_orbit, GLOB.ghost_orbits, initial(ghost_orbit))
	ghost_accs = sanitize_inlist(ghost_accs, GLOB.ghost_accs_options, GHOST_ACCS_DEFAULT_OPTION)
	ghost_others = sanitize_inlist(ghost_others, GLOB.ghost_others_options, GHOST_OTHERS_DEFAULT_OPTION)
	menuoptions	= SANITIZE_LIST(menuoptions)
	be_special = SANITIZE_LIST(be_special)
	key_bindings = sanitize_islist(key_bindings, list())

	check_new_keybindings()

	//ROGUETOWN
	parallax = PARALLAX_INSANE

	return TRUE

/datum/preferences/proc/save_preferences()
	if(!path)
		return FALSE
	var/savefile/S = new /savefile(path)
	if(!S)
		return FALSE
	S.cd = "/"

	parallax = PARALLAX_INSANE

	WRITE_FILE(S["version"] , SAVEFILE_VERSION_MAX)		//updates (or failing that the sanity checks) will ensure data is not invalid at load. Assume up-to-date

	//general preferences
	WRITE_FILE(S["asaycolor"], asaycolor)
	WRITE_FILE(S["triumphs"], triumphs)
	WRITE_FILE(S["musicvol"], musicvol)
	WRITE_FILE(S["anonymize"], anonymize)
	WRITE_FILE(S["admin_ghost_icon"], admin_ghost_icon)
	WRITE_FILE(S["ui_theme"], ui_theme)
	WRITE_FILE(S["char_theme"], char_theme)
	WRITE_FILE(S["crt"], crt)
	WRITE_FILE(S["lastclass"], lastclass)
	WRITE_FILE(S["mastervol"], mastervol)
	WRITE_FILE(S["ooccolor"], ooccolor)
	WRITE_FILE(S["lastchangelog"], lastchangelog)
	WRITE_FILE(S["UI_style"], UI_style)
	WRITE_FILE(S["hotkeys"], hotkeys)
	WRITE_FILE(S["showrolls"], showrolls)
	WRITE_FILE(S["max_chat_length"], max_chat_length)
	WRITE_FILE(S["see_chat_non_mob"], see_chat_non_mob)
	WRITE_FILE(S["tgui_fancy"], tgui_fancy)
	WRITE_FILE(S["tgui_lock"], tgui_lock)
	WRITE_FILE(S["buttons_locked"], buttons_locked)
	WRITE_FILE(S["windowflash"], windowflashing)
	WRITE_FILE(S["be_special"], be_special)
	WRITE_FILE(S["default_slot"], default_slot)
	WRITE_FILE(S["toggles"], toggles)
	WRITE_FILE(S["chat_toggles"], chat_toggles)
	WRITE_FILE(S["toggles_maptext"], toggles_maptext)
	WRITE_FILE(S["ghost_form"], ghost_form)
	WRITE_FILE(S["ghost_orbit"], ghost_orbit)
	WRITE_FILE(S["ghost_accs"], ghost_accs)
	WRITE_FILE(S["ghost_others"], ghost_others)
	WRITE_FILE(S["preferred_map"], preferred_map)
	WRITE_FILE(S["oocpronouns"], oocpronouns)
	WRITE_FILE(S["ignoring"], ignoring)
	WRITE_FILE(S["ghost_hud"], ghost_hud)
	WRITE_FILE(S["inquisitive_ghost"], inquisitive_ghost)
	WRITE_FILE(S["uses_glasses_colour"], uses_glasses_colour)
	WRITE_FILE(S["clientfps"], clientfps)
	WRITE_FILE(S["parallax"], parallax)
	WRITE_FILE(S["ambientocclusion"], ambientocclusion)
	WRITE_FILE(S["auto_fit_viewport"], auto_fit_viewport)
	WRITE_FILE(S["widescreenpref"], widescreenpref)
	WRITE_FILE(S["menuoptions"], menuoptions)
	WRITE_FILE(S["enable_tips"], enable_tips)
	WRITE_FILE(S["tip_delay"], tip_delay)
	WRITE_FILE(S["ui_scale"], ui_scale)
	WRITE_FILE(S["key_bindings"], key_bindings)
	WRITE_FILE(S["multi_char_ready"], multi_char_ready)
	WRITE_FILE(S["multi_ready_slots"], multi_ready_slots)
	return TRUE

/datum/preferences/proc/_load_species(S)
	var/species_type = GLOB.species_list[S["species"]]
	if(!species_type)
		species_type = /datum/species/human/northern
	pref_species = new species_type()

/datum/preferences/proc/_load_loadouts(S)
	for(var/i in 1 to 3)
		S["loadout[i]"]	>> vars["loadout[i]"]
	validate_loadouts()

/datum/preferences/proc/validate_loadouts()
	if(!parent.patreon.has_access(ACCESS_ASSISTANT_RANK) && !parent.twitch.has_access(ACCESS_TWITCH_SUB_TIER_1))
		loadout1 = null
		loadout2 = null
		loadout3 = null
		return FALSE

	for(var/i in 1 to 3)
		if(!(vars["loadout[i]"] in GLOB.loadout_items)) // bite me
			vars["loadout[i]"] = null

/datum/preferences/proc/_load_culinary_preferences(S)
	var/list/loaded_culinary_preferences
	S["culinary_preferences"] >> loaded_culinary_preferences
	if(loaded_culinary_preferences)
		culinary_preferences = loaded_culinary_preferences
		validate_culinary_preferences()
	else
		reset_culinary_preferences()

/datum/preferences/proc/_load_appearence(S)
	S["real_name"] >> real_name
	S["gender"] >> gender
	S["domhand"] >> domhand
	S["age"] >> age
	S["eye_color"] >> eye_color
	S["voice_color"] >> voice_color
	S["skin_tone"] >> skin_tone
	S["culture"] >> culture
	S["underwear"] >> underwear
	S["accessory"] >> accessory
	S["detail"] >> detail
	S["randomise"] >> randomise
	S["family"] >> family
	S["gender_choice"] >> gender_choice
	S["setspouse"] >> setspouse
	S["selected_accent"] >> selected_accent

	// We load our list, but override everything to FALSE to stop a "tainted" save from making it random again.
	randomise[RANDOM_BODY] = FALSE
	randomise[RANDOM_BODY_ANTAG] = FALSE
	randomise[RANDOM_UNDERWEAR] = FALSE
	randomise[RANDOM_SKIN_TONE] = FALSE
	randomise[RANDOM_EYE_COLOR] = FALSE

/datum/preferences/proc/load_character(slot)
	if(!path)
		return FALSE
	if(!fexists(path))
		return FALSE
	var/savefile/S = new /savefile(path)
	if(!S)
		return FALSE
	S.cd = "/"
	if(!slot)
		slot = default_slot
	slot = sanitize_integer(slot, 1, max_save_slots, initial(default_slot))
	if(slot != default_slot)
		default_slot = slot
		WRITE_FILE(S["default_slot"] , slot)

	S.cd = "/character[slot]"
	var/needs_update = savefile_needs_update(S)
	if(needs_update == -2)		//fatal, can't load any data
		return FALSE

	//Species
	_load_species(S)

	_load_loadouts(S)

	_load_culinary_preferences(S)

	//Character
	_load_appearence(S)

	load_quirks(S)

	if(!culture)
		culture = src::culture

	var/patron_typepath
	S["selected_patron"] >> patron_typepath
	if(patron_typepath)
		selected_patron = GLOB.patron_list[patron_typepath]

	if(!selected_patron) //failsafe
		selected_patron = GLOB.patron_list[default_patron]

	//Custom names
	for(var/custom_name_id in GLOB.preferences_custom_names)
		var/savefile_slot_name = custom_name_id + "_name" //TODO remove this
		S[savefile_slot_name] >> custom_names[custom_name_id]

	//Jobs
	S["joblessrole"] >> joblessrole

	//Load prefs
	S["job_preferences"] >> job_preferences

	//Load headshot link
	S["headshot_link"]			>> headshot_link
	if(!is_valid_headshot_link(null, headshot_link, TRUE))
		headshot_link = null

	S["pronouns"] >> pronouns
	S["voice_type"] >> voice_type

	//Load flavor text
	S["flavortext"] >> flavortext
	S["flavortext_display"]	>> flavortext_display
	S["ooc_notes"] >> ooc_notes
	S["ooc_notes_display"] >> ooc_notes_display
	S["ooc_extra"] >> ooc_extra
	S["ooc_extra_link"] >> ooc_extra_link

	//try to fix any outdated data if necessary
	if(needs_update >= 0)
		update_character(needs_update, S)		//needs_update == savefile_version if we need an update (positive integer)

	//Sanitize

	real_name = reject_bad_name(real_name)
	gender = sanitize_gender(gender)
	if(!real_name)
		real_name = random_unique_name(gender)

	for(var/custom_name_id in GLOB.preferences_custom_names)
		var/namedata = GLOB.preferences_custom_names[custom_name_id]
		custom_names[custom_name_id] = reject_bad_name(custom_names[custom_name_id],namedata["allow_numbers"])
		if(!custom_names[custom_name_id])
			custom_names[custom_name_id] = get_default_name(custom_name_id)

	randomise = SANITIZE_LIST(randomise)

	age = sanitize_inlist(age, pref_species.possible_ages)
	eye_color = sanitize_hexcolor(eye_color, 3, 0)
	voice_color = voice_color
	pronouns = sanitize_text(pronouns, THEY_THEM)
	voice_type = sanitize_text(voice_type, VOICE_TYPE_MASC)
	skin_tone = skin_tone
	family = family
	gender_choice = gender_choice
	setspouse = setspouse
	selected_accent ||= ACCENT_DEFAULT

	S["body_markings"] >> body_markings
	body_markings = SANITIZE_LIST(body_markings)

	validate_body_markings()

	S["descriptor_entries"] >> descriptor_entries
	descriptor_entries = SANITIZE_LIST(descriptor_entries)
	S["custom_descriptors"] >> custom_descriptors
	custom_descriptors = SANITIZE_LIST(custom_descriptors)

	validate_descriptors()

	joblessrole	= sanitize_integer(joblessrole, 1, 3, initial(joblessrole))

	//Validate job prefs
	for(var/j in job_preferences)
		if(job_preferences[j] != JP_LOW && job_preferences[j] != JP_MEDIUM && job_preferences[j] != JP_HIGH)
			job_preferences -= j

	S["customizer_entries"] >> customizer_entries
	validate_customizer_entries()

	return TRUE

/datum/preferences/proc/save_character()
	if(!path)
		return FALSE
	var/savefile/S = new /savefile(path)
	if(!S)
		return FALSE
	S.cd = "/character[default_slot]"

	WRITE_FILE(S["version"], SAVEFILE_VERSION_MAX)	//load_character will sanitize any bad data, so assume up-to-date.)

	//Character
	WRITE_FILE(S["real_name"], real_name)
	WRITE_FILE(S["gender"], gender)
	WRITE_FILE(S["domhand"], domhand)
	WRITE_FILE(S["age"], age)
	WRITE_FILE(S["eye_color"], eye_color)
	WRITE_FILE(S["voice_color"], voice_color)
	WRITE_FILE(S["skin_tone"], skin_tone)
	WRITE_FILE(S["culture"], culture)
	WRITE_FILE(S["underwear"], underwear)
	WRITE_FILE(S["underwear_color"], underwear_color)
	WRITE_FILE(S["undershirt"], undershirt)
	WRITE_FILE(S["accessory"], accessory)
	WRITE_FILE(S["detail"], detail)
	WRITE_FILE(S["socks"], socks)
	WRITE_FILE(S["randomise"], randomise)
	WRITE_FILE(S["pronouns"], pronouns)
	WRITE_FILE(S["voice_type"], voice_type)
	WRITE_FILE(S["species"], pref_species.id)
	WRITE_FILE(S["loadout1"], loadout1)
	WRITE_FILE(S["loadout2"], loadout2)
	WRITE_FILE(S["loadout3"], loadout3)
	WRITE_FILE(S["culinary_preferences"], culinary_preferences)
	WRITE_FILE(S["family"], family)
	WRITE_FILE(S["gender_choice"], gender_choice)
	WRITE_FILE(S["setspouse"], setspouse)
	WRITE_FILE(S["selected_accent"], selected_accent)

	//Custom names
	for(var/custom_name_id in GLOB.preferences_custom_names)
		var/savefile_slot_name = custom_name_id + "_name" //TODO remove this
		WRITE_FILE(S[savefile_slot_name],custom_names[custom_name_id])

	//Jobs
	WRITE_FILE(S["joblessrole"], joblessrole)
	//Write prefs
	WRITE_FILE(S["job_preferences"], job_preferences)

	//Patron
	WRITE_FILE(S["selected_patron"], selected_patron.type)

	// Organs
	WRITE_FILE(S["customizer_entries"], customizer_entries)
	// Body markings
	WRITE_FILE(S["body_markings"], body_markings)
	// headshot link
	WRITE_FILE(S["headshot_link"], headshot_link)
	// flavor text
	WRITE_FILE(S["flavortext"], html_decode(flavortext))
	WRITE_FILE(S["flavortext_display"], flavortext_display)
	WRITE_FILE(S["ooc_notes"], html_decode(ooc_notes))
	WRITE_FILE(S["ooc_notes_display"], ooc_notes_display)
	WRITE_FILE(S["ooc_extra"], ooc_extra)
	WRITE_FILE(S["ooc_extra_link"],	ooc_extra_link)
	// Descriptor entries
	WRITE_FILE(S["descriptor_entries"], descriptor_entries)
	WRITE_FILE(S["custom_descriptors"], custom_descriptors)

	save_quirks(S)
	return TRUE

#undef SAVEFILE_VERSION_MAX
#undef SAVEFILE_VERSION_MIN

#ifdef TESTING
//DEBUG
//Some crude tools for testing savefiles
//path is the savefile path
/client/verb/savefile_export(path as text)
	set hidden = TRUE
	var/savefile/S = new /savefile(path)
	S.ExportText("/",file("[path].txt"))

//path is the savefile path
/client/verb/savefile_import(path as text)
	set hidden = TRUE
	var/savefile/S = new /savefile(path)
	S.ImportText("/",file("[path].txt"))

#endif

/datum/preferences/proc/check_new_keybindings()
	var/list/keybind_names = list()
	var/list/used_keys = list()
	for(var/key in key_bindings)
		keybind_names |= key_bindings[key]
		used_keys |= key

	if(!length(GLOB.hotkey_keybinding_list_by_key))
		init_keybindings()
	for(var/key in GLOB.hotkey_keybinding_list_by_key)
		var/list/key_name = GLOB.hotkey_keybinding_list_by_key[key]
		if(!length(key_name))
			continue
		if(!(key_name[1] in keybind_names))
			if(key in used_keys)
				preference_message_list |= span_bold("[key_name[1]] is unbound and the default key is in use, please set the keybind yourself!")
				continue
			key_bindings |= key
			key_bindings[key] = GLOB.hotkey_keybinding_list_by_key[key]
