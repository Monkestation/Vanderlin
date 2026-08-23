/datum/action/cooldown/spell/undirected/song/furtive_fortissimo
	name = "Furtive Fortissimo"
	desc = "With cat like tread, apply light steps to audience members."
	button_icon_state = "bardsong_t1_base"
	invocation = "plays a sneaky, playful tune. The world draws closer to listen, in on the joke."
	invocation_self_message = "you play a sneaky, playful tune. The world draws closer to listen, in on the joke."
	song_effect = /datum/status_effect/buff/playing_melody/furtive_fortissimo

/datum/status_effect/buff/playing_melody/furtive_fortissimo
	effect = /obj/effect/temp_visual/songs/inspiration_bardsongt1
	buff_to_apply = /datum/status_effect/buff/song/furtive_fortissimo

/atom/movable/screen/alert/status_effect/buff/song/furtive_fortissimo
	name = "Furtive Fortissimo"
	desc = "With cat like tread, the sneaking song begins."
	icon_state = "buff"

/datum/status_effect/buff/song/furtive_fortissimo
	id = "furtivefortissimo"
	alert_type = /atom/movable/screen/alert/status_effect/buff/song/furtive_fortissimo
	duration = 15 SECONDS

/datum/status_effect/buff/song/furtive_fortissimo/on_apply()
	. = ..()
	to_chat(owner, span_warning("Tall grass and twigs move out of my way, making my path clear. I feel as if I can roam without being ambushed."))
	ADD_TRAIT(owner, TRAIT_LIGHT_STEP, id)

/datum/status_effect/buff/song/furtive_fortissimo/on_remove()
	. = ..()
	to_chat(owner, span_warning("The playful tune ends. I will have to be careful of ambushes, now."))
	REMOVE_TRAIT(owner, TRAIT_LIGHT_STEP, id)
