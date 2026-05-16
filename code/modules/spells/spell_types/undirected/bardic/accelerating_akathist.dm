/datum/action/cooldown/spell/undirected/song/accelakathist
	name = "Accelerating Akathist"
	desc = "Accelerate your allies with your bardic song!"
	button_icon_state = "bardsong_t3_base"
	invocation = "plays a blisteringly fast series of notes!"
	invocation_self_message = "you play a blisteringly fast series of notes!"
	song_effect = /datum/status_effect/buff/playing_melody/accelakathist

/datum/status_effect/buff/playing_melody/accelakathist
	effect = /obj/effect/temp_visual/songs/inspiration_bardsongt3
	buff_to_apply = /datum/status_effect/buff/song/accelakathist
	buff_to_apply_full = /datum/status_effect/buff/song/accelakathist/full

/atom/movable/screen/alert/status_effect/buff/song/accelakathist
	name = "Accelerating Akathist"
	desc = "I can feel the rhythm!"
	icon_state = "buff"

#define ACCELAKATHIST_FILTER "akathist_glow"

/datum/status_effect/buff/song/accelakathist
	var/outline_colour = "#F0E68C"
	id = "Accelakathist"
	alert_type = /atom/movable/screen/alert/status_effect/buff/song/accelakathist
	effectedstats = list(STATKEY_SPD = BARD_STAT_LESSER)
	duration = 15 SECONDS

/datum/status_effect/buff/song/accelakathist/full
	effectedstats = list(STATKEY_SPD = BARD_STAT_FULL)

/datum/status_effect/buff/song/accelakathist/on_apply()
	. = ..()
	var/filter = owner.get_filter(ACCELAKATHIST_FILTER)
	if (!filter)
		owner.add_filter(ACCELAKATHIST_FILTER, 2, list("type" = "outline", "color" = outline_colour, "alpha" = 25, "size" = 1))
	to_chat(owner, span_warning("I am being invited to dance! My heart pounds in my ears as my movements quicken!"))

/datum/status_effect/buff/song/accelakathist/on_remove()
	. = ..()
	owner.remove_filter(ACCELAKATHIST_FILTER)
	to_chat(owner, span_warning("The song ends, and my heartbeat slows back down to a more moderate tempo."))

#undef ACCELAKATHIST_FILTER

/datum/status_effect/buff/song/accelakathist/nextmove_modifier()
	return 0.85
