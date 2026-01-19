/**
 * Furtive Fortissimo
 */
/datum/action/cooldown/spell/undirected/song/furtive_fortissimo
	name = "Furtive Fortissimo"
	desc = "Apply a cabbit-like tread (Light Steps) to your audience members."
	invocation = "%Like a cabbit, that leaps lightly underfoot..."
	button_icon_state = "bardsong_t1_base"
	background_icon_state = "bardsong_t1_base"
	spell_cost = 40
	inspiration_effect = /datum/status_effect/inspiration/furtive_fortissimo

/datum/action/cooldown/spell/undirected/song/furtive_fortissimo/modify_applied_effect(datum/status_effect/stacking/playing_inspiration/applied_effect)
	. = ..()
	if(!.)
		return
	applied_effect.visual_icon_state = "bardsong_t1_base"
	applied_effect.stack_threshold = 10

/datum/status_effect/inspiration/furtive_fortissimo
	id = "furtivefortissimo"
	alert_type = /atom/movable/screen/alert/status_effect/buff/song/furtive_fortissimo
	duration = 60 SECONDS

/datum/status_effect/inspiration/furtive_fortissimo/on_apply()
	. = ..()
	to_chat(owner, span_notice("My steps feel lighter than normal."))
	ADD_TRAIT(owner, TRAIT_LIGHT_STEP, TRAIT_STATUS_EFFECT(id))

/datum/status_effect/inspiration/on_remove()
	. = ..()
	REMOVE_TRAIT(owner, TRAIT_LIGHT_STEP, TRAIT_STATUS_EFFECT(id))

/atom/movable/screen/alert/status_effect/buff/song/furtive_fortissimo
	name = "Furtive Fortissimo"
	desc = "The inspiring melody leaves you feeling light-footed."

/**
 * Intellectual Interval
 */
/datum/action/cooldown/spell/undirected/song/intellectual_interval
	name = "Intellectual Interval"
	desc = "A tune for thinkers and craftsmen in your audience. (+3 INT)"
	invocation = "%The pretty moon Noc and mighty hammers of Malum!"
	button_icon_state = "melody_t1_base"
	background_icon_state = "melody_t1_base"
	spell_cost = 40
	inspiration_effect = /datum/status_effect/inspiration/intellectual_interval

/datum/action/cooldown/spell/undirected/song/intellectual_interval/modify_applied_effect(datum/status_effect/stacking/playing_inspiration/applied_effect)
	. = ..()
	if(!.)
		return
	applied_effect.visual_icon_state = "melody_t1_base"

/datum/status_effect/inspiration/intellectual_interval
	id = "intellectualinterval"
	alert_type = /atom/movable/screen/alert/status_effect/buff/song/intellectual_interval
	duration = 60 SECONDS
	effectedstats = list(STATKEY_INT = 3)

/atom/movable/screen/alert/status_effect/buff/song/intellectual_interval
	name = "Intellectual Interval"
	desc = "The tune has intellectually stimulated you."

/**
 * Misfortunate Melody
 */
/datum/action/cooldown/spell/undirected/song/dirge_fortune
	name = "Misfortunate Melody"
	desc = "Play a dirge which inflicts misfortune upon thy foes. -2 LUCK to non-audience members nearby. "
	sound = 'sound/magic/debuffroll.ogg'
	invocation = "%HEAR THY MISFORTUNE! HERE IS THY DOOM!"
	button_icon_state = "dirge_t1_base"
	background_icon_state = "dirge_t1_base"
	song_stack_effect = /datum/status_effect/stacking/playing_inspiration/target_nonaudience
	inspiration_effect = /datum/status_effect/inspiration/dirge_misfortune

/datum/action/cooldown/spell/undirected/song/dirge_fortune/modify_applied_effect(datum/status_effect/stacking/playing_inspiration/applied_effect)
	. = ..()
	if(!.)
		return
	applied_effect.visual_icon_state = "dirge_t1_base"
	applied_effect.range = 5

/datum/status_effect/inspiration/dirge_misfortune
	id = "dirge_misfortune"
	alert_type = /atom/movable/screen/alert/status_effect/debuff/song/dirge_misfortune
	effectedstats = list(STATKEY_LCK = -2)
	duration = 30 SECONDS

/atom/movable/screen/alert/status_effect/debuff/song/dirge_misfortune
	name = "Dirge of Misfortune"
	desc = "The blasted dirge drives me mad, sapping my luck!"
