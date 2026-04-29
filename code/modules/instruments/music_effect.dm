/obj/effect/temp_visual/music_rogue //color is white by default, set to whatever is needed
	name = "music"
	icon = 'icons/effects/music-note.dmi'
	icon_state = "music_note"
	duration = 15
	plane = GAME_PLANE_UPPER
	layer = ABOVE_ALL_MOB_LAYER

/obj/effect/temp_visual/music_rogue/Initialize(mapload, set_color)
	if(set_color)
		add_atom_colour(set_color, FIXED_COLOUR_PRIORITY)
	. = ..()
	alpha = 180
	pixel_x = base_pixel_x + rand(-12, 12)
	pixel_y = base_pixel_y + rand(-9, 0)

/atom/movable/screen/alert/status_effect/buff/playing_music
	name = "Playing Music"
	desc = "Let the world hear my craft."
	icon_state = "play_music"

/datum/status_effect/buff/playing_music
	id = "play_music"
	alert_type = /atom/movable/screen/alert/status_effect/buff/playing_music
	var/effect_color
	var/datum/stress_event/stress_to_apply
	tick_interval = 10
	duration = 5 SECONDS

/datum/status_effect/buff/playing_music/on_creation(mob/living/new_owner, stress, colour)
	stress_to_apply = stress
	effect_color = colour
	return ..()

/datum/status_effect/buff/playing_music/tick()
	var/obj/effect/temp_visual/music_rogue/M = new /obj/effect/temp_visual/music_rogue(get_turf(owner))
	M.color = effect_color
	for (var/mob/living/carbon/human/H in hearers(7, owner))
		if (!H.client)
			continue
		if(!H.can_hear())
			continue
		H.add_stress(stress_to_apply)

/obj/effect/temp_visual/songs
	name = "songs"
	icon = 'icons/mob/actions/bardsong_anims.dmi'
	duration = 15
	plane = GAME_PLANE_UPPER
	layer = ABOVE_ALL_MOB_LAYER

/obj/effect/temp_visual/songs/Initialize(mapload)
	. = ..()
	alpha = 140
	pixel_x = rand(-18, 18)
	pixel_y = rand(-16, 0)
	var/matrix/m = matrix()
	m.Scale(0.75, 0.75)
	transform = m
