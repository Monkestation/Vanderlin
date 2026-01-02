/datum/action/cooldown/spell/undirected/song
	var/song_tier = 1
	spell_type = SPELL_STAMINA

	sound = list('sound/magic/buffrollaccent.ogg')
	button_icon = 'icons/mob/actions/bardsongs.dmi'
	button_icon_state = "dirge_t1_base"
	background_icon_state = "dirge_t1_base"
	background_icon = 'icons/mob/actions/bardsongs.dmi'
	spell_cost = 60
	charge_time = 1
	cooldown_time = 2 MINUTES
	associated_skill = /datum/skill/misc/music

/datum/status_effect/buff/playing_dirge
	id = "play_dirge"
	alert_type = /atom/movable/screen/alert/status_effect/buff/playing_dirge
	var/effect_color
	var/datum/status_effect/debuff/debuff_to_apply
	var/pulse = 0
	var/ticks_to_apply = 10
	duration = -1
	var/obj/effect/temp_visual/songs/effect = /obj/effect/temp_visual/songs/inspiration_dirget1


/atom/movable/screen/alert/status_effect/buff/playing_dirge
	name = "Playing Dirge"
	desc = "Terrorizing the world with my craft."
	icon_state = "buff"


/datum/status_effect/buff/playing_dirge/tick()
	var/mob/living/carbon/human/O = owner
	if(!O.inspiration)
		return
	pulse += 1
	new effect(get_turf(owner))
	if (pulse >= ticks_to_apply)
		pulse = 0
		O.adjust_energy(-25)
		for (var/mob/living/carbon/human/H in hearers(10, owner))
			if(!O.in_audience(H))
				H.apply_status_effect(debuff_to_apply)


/datum/status_effect/buff/playing_melody
	id = "play_melody"
	alert_type = /atom/movable/screen/alert/status_effect/buff/playing_melody
	var/effect_color
	var/datum/status_effect/buff/buff_to_apply
	var/pulse = 0
	var/ticks_to_apply = 10
	duration = -1
	var/obj/effect/temp_visual/songs/effect = /obj/effect/temp_visual/songs/inspiration_melodyt1


/atom/movable/screen/alert/status_effect/buff/playing_melody
	name = "Playing Melody"
	desc = "Healing the world with my craft."
	icon_state = "buff"


/datum/status_effect/buff/playing_melody/tick()
	var/mob/living/carbon/human/O = owner
	if(!O.inspiration)
		return
	new effect(get_turf(owner))
	pulse += 1
	if (pulse >= ticks_to_apply)
		pulse = 0
		O.adjust_energy(-10)
		for (var/mob/living/carbon/human/H in hearers(10, owner))
			if(O.in_audience(H))
				H.apply_status_effect(buff_to_apply)
