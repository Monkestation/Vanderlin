/datum/action/cooldown/spell/undirected/song/enervating_elegy
	name = "Enervating Elegy"
	desc = "Play a draining elegy that saps the energy of your enemies. Drains blue from non-audience members nearby."
	button_icon_state = "dirge_t2_base"
	sound = 'sound/magic/debuffroll.ogg'
	invocation = "plays a mournful, droning elegy. The will to fight seems to drain from the air."
	invocation_self_message = "you play a mournful, droning elegy. The will to fight seems to drain from the air."
	song_effect = /datum/status_effect/buff/playing_dirge/enervating_elegy

/datum/status_effect/buff/playing_dirge/enervating_elegy
	effect = /obj/effect/temp_visual/songs/inspiration_dirget2
	debuff_to_apply = /datum/status_effect/debuff/song/enervating_elegy
	debuff_to_apply_full = /datum/status_effect/debuff/song/enervating_elegy/full

/atom/movable/screen/alert/status_effect/debuff/song/enervating_elegy
	name = "Enervating Elegy"
	desc = "This droning music saps my will to fight. I can feel my energy draining away."
	icon_state = "debuff"

// Uses a status effect so multiple bards don't stack/nuke - refreshes duration instead
/datum/status_effect/debuff/song/enervating_elegy
	id = "enervating_elegy"
	alert_type = /atom/movable/screen/alert/status_effect/debuff/song/enervating_elegy
	duration = 15 SECONDS
	var/drain_amount = 4 // Blue drained per tick (lesser bard, 66%)

/datum/status_effect/debuff/song/enervating_elegy/full
	drain_amount = 6 // Blue drained per tick (full bard, 100%)

/datum/status_effect/debuff/song/enervating_elegy/tick()
	owner.adjust_stamina(drain_amount)
