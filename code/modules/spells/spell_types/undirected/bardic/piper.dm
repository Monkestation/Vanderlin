/datum/action/cooldown/spell/undirected/song/pestilent_piedpiper
	name = "Pestilent Pied Piper"
	desc = "Play a dirge inspired by Pestra. Leaving the droning of insects in their ears! (-1 WIL -2 CON non-audience members)"
	button_icon_state = "dirge_t2_base"
	background_icon_state = "dirge_t2_base"
	song_tier = 2
	invocation = "A festering performance!"
	invocation_type = "shout"
	sound = list('sound/magic/debuffroll.ogg')


/datum/action/cooldown/spell/undirected/song/pestilent_piedpiper/cast(mob/living/user = usr)
	. = ..()
	if(user.has_status_effect(/datum/status_effect/buff/playing_music))
		for(var/datum/status_effect/buff/playing_melody/melodies in user.status_effects)
			user.remove_status_effect(melodies)
		for(var/datum/status_effect/buff/playing_dirge/dirges in user.status_effects)
			user.remove_status_effect(dirges)
		user.apply_status_effect(/datum/status_effect/buff/playing_dirge/pestilent_piedpiper)
		return TRUE
	else
		to_chat(user, span_warning("I must be playing something to inspire my audience!"))
		return

/datum/status_effect/buff/playing_dirge/pestilent_piedpiper
	effect = /obj/effect/temp_visual/songs/inspiration_dirget2
	debuff_to_apply = /datum/status_effect/debuff/song/pestilentpiper


/atom/movable/screen/alert/status_effect/debuff/song/pestilentpiper
	name = "Musical Droning!"
	desc = "I am weakened by the song!"
	icon_state = "debuff"

/datum/status_effect/debuff/song/pestilentpiper
	id = "pestilentpiper"
	alert_type = /atom/movable/screen/alert/status_effect/debuff/song/pestilentpiper
	duration = 15 SECONDS
	effectedstats = list(STATKEY_END = -1, STATKEY_CON = -2)
