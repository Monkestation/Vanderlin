/datum/action/cooldown/spell/undirected/song/resolute_refrain
	name = "Resolute Refrain"
	desc = "A steadying melody that bolsters your allies' constitution."
	button_icon_state = "melody_t1_base"
	invocation = "plays a bolstering tune. The nearby air hardens."
	invocation_self_message = "you play a bolstering tune. The nearby air hardens."
	song_effect = /datum/status_effect/buff/playing_melody/resolute_refrain

/datum/status_effect/buff/playing_melody/resolute_refrain
	effect = /obj/effect/temp_visual/songs/inspiration_melodyt1
	buff_to_apply = /datum/status_effect/buff/song/resolute_refrain
	buff_to_apply_full = /datum/status_effect/buff/song/resolute_refrain/full

/atom/movable/screen/alert/status_effect/buff/song/resolute_refrain
	name = "Resolute Refrain"
	desc = "This steady melody hardens my resolve. I feel tougher, more resilient."
	icon_state = "buff"

/datum/status_effect/buff/song/resolute_refrain
	id = "Resolute Refrain"
	alert_type = /atom/movable/screen/alert/status_effect/buff/song/resolute_refrain
	duration = 15 SECONDS
	effectedstats = list(STATKEY_CON = BARD_STAT_LESSER)

/datum/status_effect/buff/song/resolute_refrain/full
	effectedstats = list(STATKEY_CON = BARD_STAT_FULL)
