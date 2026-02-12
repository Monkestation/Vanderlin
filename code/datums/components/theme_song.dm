/datum/component/theme_music
	var/music_enabled = FALSE
	var/datum/looping_sound/theme_song/combat_music_loop
	var/custom_music_track = null
	var/last_music_change = 0
	var/curthemefile = 'sound/music/cmode/antag/combat_maniac.ogg'

/datum/component/theme_music/Initialize()
	if(!ismob(parent))
		return COMPONENT_INCOMPATIBLE
	var/mob/M = parent

	combat_music_loop = new /datum/looping_sound/theme_song(M, FALSE)
	add_verb(M, /mob/proc/toggle_custom_music)
	add_verb(M, /mob/proc/set_custom_music)

	RegisterSignal(M, COMSIG_LIVING_DEATH, PROC_REF(on_death))

/datum/component/theme_music/Destroy(force)
	var/mob/M = parent
	remove_verb(M, /mob/proc/toggle_custom_music)
	remove_verb(M, /mob/proc/set_custom_music)

	if(combat_music_loop)
		combat_music_loop.stop()
		QDEL_NULL(combat_music_loop)

	return ..()

/datum/component/theme_music/proc/on_death(mob/source)
	SIGNAL_HANDLER
	stop_music()

/datum/component/theme_music/proc/toggle_music()
	music_enabled = !music_enabled
	if(music_enabled)
		combat_music_loop.start()
		to_chat(parent, span_notice("Theme Active"))
	else
		combat_music_loop.stop()
		to_chat(parent, span_notice("Theme disabled."))

/datum/component/theme_music/proc/stop_music()
	music_enabled = FALSE
	if(combat_music_loop)
		combat_music_loop.stop()

/datum/component/theme_music/proc/upload_custom_music()
	var/mob/M = parent
	if(music_enabled)
		to_chat(parent, span_warning("Turn off your theme song before changing it."))
		return

	if(last_music_change)
		if(world.time < last_music_change + 3 MINUTES)
			to_chat(parent, span_warning("Can't set a new theme song yet."))
			return

	var/infile = input(parent, "Choose a custom OGG file for your theme song", src) as null|file
	if(!infile)
		return

	var/filename = SANITIZE_FILENAME("[infile]")
	var/file_ext = lowertext(copytext(filename, -4))
	var/file_size = length(infile)

	if(file_ext != ".ogg")
		to_chat(parent, span_warning("The file must be an OGG."))
		return
	if(file_size > 6485760) // 6MB limit
		to_chat(parent, span_warning("The file is too large. Maximum size is 6 MB."))
		return

	fcopy(infile, "data/jukeboxUploads/[M.ckey]/[filename]")
	custom_music_track = file("data/jukeboxUploads/[M.ckey]/[filename]")

	last_music_change = world.time
	curthemefile = custom_music_track

	combat_music_loop.mid_sounds = list(curthemefile)
	combat_music_loop.cursound = null
	M.cmode_music = curthemefile
	to_chat(parent, span_notice("Done, check your combat mode music and/or theme song."))


/datum/looping_sound/theme_song
	mid_sounds = list()
	mid_length = 240 SECONDS
	volume = 100
	falloff_exponent = 5
	extra_range = 6
	channel = CHANNEL_IMSICK
	persistent_loop = TRUE


/mob/proc/toggle_custom_music()
	set name = "Toggle Theme Music"
	set category = "IC.Music"

	var/datum/component/theme_music/theme = src.GetComponent(/datum/component/theme_music)
	if(theme)
		theme.toggle_music()
	else
		remove_verb(src, /mob/proc/toggle_custom_music)
		to_chat(src, span_notice("You are not supposed to have this, Report the bug."))

/mob/proc/set_custom_music()
	set name = "Set Custom Music"
	set category = "IC.Music"

	var/datum/component/theme_music/theme = src.GetComponent(/datum/component/theme_music)
	if(theme)
		theme.upload_custom_music()
	else
		remove_verb(src, /mob/proc/set_custom_music)
		to_chat(src, span_notice("You are not supposed to have this, Report the bug."))
