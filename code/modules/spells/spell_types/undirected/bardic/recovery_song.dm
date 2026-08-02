/datum/action/cooldown/spell/undirected/song/recovery_song
	name = "Resting Rhapsody"
	desc = "Recuperate your allies' spirits with your song! Refills stamina over time!"
	button_icon_state = "melody_t2_base"
	invocation = "plays a gentle-yet-refreshing tune. The nearby air clears."
	invocation_self_message = "you play a gentle-yet-refreshing tune. The nearby air clears."
	song_effect = /datum/status_effect/buff/playing_melody/recovery

/datum/status_effect/buff/playing_melody/recovery
	effect = /obj/effect/temp_visual/songs/inspiration_melodyt2
	buff_to_apply = /datum/status_effect/buff/song/recovery
	buff_to_apply_full = /datum/status_effect/buff/song/recovery/full

/atom/movable/screen/alert/status_effect/buff/song/recovery
	name = "Musical Recovery"
	desc = "I breathe deeply. This melody refreshes me - I could run for hours."
	icon_state = "buff"

/datum/status_effect/buff/song/recovery
	id = "recoverysong"
	alert_type = /atom/movable/screen/alert/status_effect/buff/song/recovery
	duration = 15 SECONDS
	var/stamina_recovery = -4 // Lesser bard (66% of 6)

/datum/status_effect/buff/song/recovery/full
	stamina_recovery = -6 // Full bard (100%)

/datum/status_effect/buff/song/recovery/tick()
	owner.adjust_stamina(stamina_recovery)
