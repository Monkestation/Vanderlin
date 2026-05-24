/datum/action/cooldown/spell/undirected/song/rejuvenation_song
	name = "Healing Hymn"
	desc = "Recuperate your allies' bodies with your song! Refills health slowly over time!"
	button_icon_state = "melody_t3_base"
	invocation = "plays a beautiful, stirring song. The world around them becomes more vivid."
	invocation_self_message = "you play a beautiful, stirring song. The world around them becomes more vivid."
	song_effect = /datum/status_effect/buff/playing_melody/rejuvenation

/datum/status_effect/buff/playing_melody/rejuvenation
	effect = /obj/effect/temp_visual/songs/inspiration_melodyt3
	buff_to_apply = /datum/status_effect/buff/healing/rejuvenationsong
	buff_to_apply_full = /datum/status_effect/buff/healing/rejuvenationsong/full

/datum/status_effect/buff/healing/rejuvenationsong
	id = "healingrejuvesong"
	alert_type = /atom/movable/screen/alert/status_effect/buff/healing
	duration = 15 SECONDS
	healing_on_tick = 0.6 // Lesser bard (66%)
	outline_colour = "#c92f2f"
	effect_color = "#660759"

/datum/status_effect/buff/healing/rejuvenationsong/full
	healing_on_tick = 1 // Full bard (100%)
