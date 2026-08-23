/datum/action/cooldown/spell/undirected/song/intellectual_interval
	name = "Intellectual Interval"
	desc = "A song for thinkers that sharpens the mind. Grants INT to audience members."
	invocation = "plays a stimulating tune."
	invocation_self_message = "you play a stimulating tune."
	button_icon_state = "melody_t1_base"
	song_effect = /datum/status_effect/buff/playing_melody/intellectual_interval

/datum/status_effect/buff/playing_melody/intellectual_interval
	effect = /obj/effect/temp_visual/songs/inspiration_melodyt1
	buff_to_apply = /datum/status_effect/buff/song/intellectual_interval
	buff_to_apply_full = /datum/status_effect/buff/song/intellectual_interval/full

/atom/movable/screen/alert/status_effect/buff/song/intellectual_interval
	name = "Intellectual Interval"
	desc = "This song is soft and clinical. My mind feels clearer, given room to think."
	icon_state = "buff"

/datum/status_effect/buff/song/intellectual_interval
	id = "Intellectual Interval"
	alert_type = /atom/movable/screen/alert/status_effect/buff/song/intellectual_interval
	duration = 15 SECONDS
	effectedstats = list(STATKEY_INT = BARD_STAT_LESSER)

/datum/status_effect/buff/song/intellectual_interval/full
	effectedstats = list(STATKEY_INT = BARD_STAT_FULL)
