/datum/action/cooldown/spell/undirected/song/recovery_song
	name = "Resting Rhapsody"
	desc = "Recuperate your allies spirit's with your song! Refills stamina over time!"
	song_tier = 2
	invocation = "Thy muscles recuperate, thy limbs refresh!"
	invocation_type = "shout"
	button_icon_state = "melody_t2_base"
	background_icon_state = "melody_t2_base"


/datum/action/cooldown/spell/undirected/song/recovery_song/cast(mob/living/user = usr)
	. = ..()
	if(user.has_status_effect(/datum/status_effect/buff/playing_music))
		for(var/datum/status_effect/buff/playing_melody/melodies in user.status_effects)
			user.remove_status_effect(melodies)
		for(var/datum/status_effect/buff/playing_dirge/dirges in user.status_effects)
			user.remove_status_effect(dirges)
		user.apply_status_effect(/datum/status_effect/buff/playing_melody/recovery)
		return TRUE
	else
		to_chat(user, span_warning("I must be playing something to inspire my audience!"))
		return

/datum/status_effect/buff/playing_melody/recovery
	effect = /obj/effect/temp_visual/songs/inspiration_melodyt2
	buff_to_apply = /datum/status_effect/buff/song/recovery



/atom/movable/screen/alert/status_effect/buff/song/recovery
	name = "Musical Recovery"
	desc = "I am refreshed by the song!"
	icon_state = "buff"

/datum/status_effect/buff/song/recovery
	id = "recoverysong"
	alert_type = /atom/movable/screen/alert/status_effect/buff/song/recovery
	duration = 15 SECONDS

/datum/status_effect/buff/song/recovery/tick()
	owner.adjust_stamina(-5, internal_regen = FALSE)
