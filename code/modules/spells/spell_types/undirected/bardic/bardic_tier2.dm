/**
 * Fervorous Fantasia
 */
/datum/action/cooldown/spell/undirected/song/fervor_song
	name = "Fervorous Fantasia"
	desc = "Inspiring them with the rhythm of battle, your audience strike and parry 20% better."
	invocation = "%Strike and fight to the beat of my tune..."
	invocation_type = "shout"
	button_icon_state = "bardsong_t2_base"
	background_icon_state = "bardsong_t2_base"
	spell_cost = 50
	inspiration_effect = /datum/status_effect/inspiration/fervor

/datum/action/cooldown/spell/undirected/song/fervor_song/modify_applied_effect(datum/status_effect/stacking/playing_inspiration/applied_effect)
	. = ..()
	if(!.)
		return
	applied_effect.visual_icon_state = "bardsong_t2_base"

#define FERVOR_FILTER "fervor_glow"

/datum/status_effect/inspiration/fervor
	var/outline_colour ="#f58e2d"
	id = "fervor"
	alert_type = /atom/movable/screen/alert/status_effect/buff/song/fervor
	duration = 30 SECONDS

/datum/status_effect/inspiration/fervor/on_apply()
	. = ..()
	owner.add_filter(FERVOR_FILTER, 2, list("type" = "outline", "color" = outline_colour, "alpha" = 50, "size" = 1))
	to_chat(owner, span_warning("The rhythm of the tune aides me in battle!"))
	ADD_TRAIT(owner, TRAIT_GUIDANCE, TRAIT_STATUS_EFFECT(id))

/datum/status_effect/inspiration/fervor/on_remove()
	. = ..()
	owner.remove_filter(FERVOR_FILTER)
	REMOVE_TRAIT(owner, TRAIT_GUIDANCE, TRAIT_STATUS_EFFECT(id))

/atom/movable/screen/alert/status_effect/buff/song/fervor // spicy guidance
	name = "Musical Fervor"
	desc = "Musical assistance guides my strikes in combat. (+20% chance to land hits, +20% chance to defend)"

#undef FERVOR_FILTER

/**
 * Resting Rhapsody
 */
/datum/action/cooldown/spell/undirected/song/recovery_song
	name = "Resting Rhapsody"
	desc = "Recuperate your allies spirit's with your song! Refills half of your audience's stamina instantly."
	invocation = "%After a long dae, may thy body rest..."
	invocation_type = "shout"
	button_icon_state = "melody_t2_base"
	background_icon_state = "melody_t2_base"
	spell_cost = 50
	song_stack_effect = /datum/status_effect/stacking/playing_inspiration/recovery_song
	inspiration_effect = null

/datum/status_effect/stacking/playing_inspiration/recovery_song
	stack_threshold = 10

/datum/status_effect/stacking/playing_inspiration/recovery_song/find_audience()
	var/mob/living/carbon/human/human_owner = owner
	for (var/mob/living/carbon/human/listener in hearers(range, human_owner))
		if(human_owner.inspiration.check_in_audience(listener))
			listener.adjust_stamina(-listener.maximum_stamina / 2, internal_regen = FALSE)
			to_chat(listener, span_biginfo("I am refreshed by the calming melody of the song!"))

// /datum/action/cooldown/spell/undirected/song/recovery_song/modify_applied_effect(datum/status_effect/stacking/playing_inspiration/applied_effect)
// 	. = ..()
// 	if(!.)
// 		return
// 	applied_effect.visual_icon_state = "melody_t2_base"

// /datum/status_effect/inspiration/recovery
// 	id = "recoverysong"
// 	alert_type = /atom/movable/screen/alert/status_effect/buff/song/recovery
// 	duration = 30 SECONDS

// /datum/status_effect/inspiration/recovery/tick()
// 	owner.adjust_stamina(-2, internal_regen = FALSE)

// /atom/movable/screen/alert/status_effect/buff/song/recovery
// 	name = "Musical Recovery"
// 	desc = "I am refreshed by the calming melody of the song."
// 	icon_state = "buff"

/**
 * Pestilent Pied Piper
 */
/datum/action/cooldown/spell/undirected/song/pestilent_piedpiper
	name = "Pestilent Pied Piper"
	desc = "Play a droning dirge of insect noises inspired by Pestra in the ears of non-audience members. (-1 END -2 CON)"
	button_icon_state = "dirge_t2_base"
	background_icon_state = "dirge_t2_base"
	sound = 'sound/magic/debuffroll.ogg'
	invocation = "%BZZZZ CHIRP-CHIRP TSSSTTT!"
	spell_cost = 50
	song_stack_effect = /datum/status_effect/stacking/playing_inspiration/target_nonaudience
	inspiration_effect = /datum/status_effect/inspiration/pestilentpiper

/datum/action/cooldown/spell/undirected/song/pestilent_piedpiper/modify_applied_effect(datum/status_effect/stacking/playing_inspiration/applied_effect)
	. = ..()
	if(!.)
		return
	applied_effect.visual_icon_state = "dirge_t2_base"
	applied_effect.range = 5

/datum/status_effect/inspiration/pestilentpiper
	id = "pestilentpiper"
	alert_type = /atom/movable/screen/alert/status_effect/debuff/song/pestilentpiper
	duration = 30 SECONDS
	effectedstats = list(STATKEY_END = -1, STATKEY_CON = -2)

/atom/movable/screen/alert/status_effect/debuff/song/pestilentpiper
	name = "Musical Droning!"
	desc = "This droning cacophony is weakening my resolve!"
	icon_state = "debuff"
