/datum/action/cooldown/spell/undirected/song/intellectual_interval
	name = "Intellectual Interval"
	desc = "A song for thinkers, +3 INT"
	song_tier = 1
	button_icon_state = "melody_t1_base"
	background_icon_state = "melody_t1_base"


/datum/action/cooldown/spell/undirected/song/intellectual_interval/cast(mob/living/user = usr)
	. = ..()
	if(user.has_status_effect(/datum/status_effect/buff/playing_music))
		for(var/datum/status_effect/buff/playing_melody/melodies in user.status_effects)
			user.remove_status_effect(melodies)
		for(var/datum/status_effect/buff/playing_dirge/dirges in user.status_effects)
			user.remove_status_effect(dirges)
		user.apply_status_effect(/datum/status_effect/buff/playing_melody/intellectual_interval)
		return TRUE
	else
		to_chat(user, span_warning("I must be playing something to inspire my audience!"))
		return

/datum/status_effect/buff/playing_melody/intellectual_interval
	effect = /obj/effect/temp_visual/songs/inspiration_melodyt1
	buff_to_apply = /datum/status_effect/buff/song/intellectual_interval


/atom/movable/screen/alert/status_effect/buff/song/intellectual_interval
	name = "Intellectual Interval"
	desc = "This tune is intellectually stimulating."
	icon_state = "buff"


/datum/status_effect/buff/song/intellectual_interval
	id = "intellectualinterval"
	alert_type = /atom/movable/screen/alert/status_effect/buff/song/intellectual_interval
	duration = 15 SECONDS
	effectedstats = list(STATKEY_INT = 3)
