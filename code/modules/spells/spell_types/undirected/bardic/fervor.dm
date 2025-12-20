/datum/action/cooldown/spell/undirected/song/fervor_song
	name = "Fervorous Fantasia"
	desc = "Inspire the rhythm of battle, your allies strike and parry 20% better!"
	song_tier = 2
	invocation = "To my tune, strike and move thy feet!"
	invocation_type = "shout"
	button_icon_state = "bardsong_t2_base"
	background_icon_state = "bardsong_t2_base"


/datum/action/cooldown/spell/undirected/song/fervor_song/cast(mob/living/user = usr)
	. = ..()
	if(user.has_status_effect(/datum/status_effect/buff/playing_music))
		for(var/datum/status_effect/buff/playing_melody/melodies in user.status_effects)
			user.remove_status_effect(melodies)
		for(var/datum/status_effect/buff/playing_dirge/dirges in user.status_effects)
			user.remove_status_effect(dirges)
		user.apply_status_effect(/datum/status_effect/buff/playing_melody/fervor)
		return TRUE
	else
		to_chat(user, span_warning("I must be playing something to inspire my audience!"))
		return

/datum/status_effect/buff/playing_melody/fervor
	effect = /obj/effect/temp_visual/songs/inspiration_bardsongt2
	buff_to_apply = /datum/status_effect/buff/song/fervor


#define FERVOR_FILTER "fervor_glow"

/atom/movable/screen/alert/status_effect/buff/song/fervor // spicy guidance
	name = "Musical Fervor"
	desc = "Musical assistance guides my hands. (+20% chance to bypass parry / dodge, +20% chance to parry / dodge)"
	icon_state = "buff"

/datum/status_effect/buff/song/fervor
	var/outline_colour ="#f58e2d"
	id = "fervor"
	alert_type = /atom/movable/screen/alert/status_effect/buff/song/fervor
	duration = 15 SECONDS

/datum/status_effect/buff/song/fervor/on_apply()
	. = ..()
	var/filter = owner.get_filter(FERVOR_FILTER)
	if (!filter)
		owner.add_filter(FERVOR_FILTER, 2, list("type" = "outline", "color" = outline_colour, "alpha" = 50, "size" = 1))
	to_chat(owner, span_warning("The tune aides me in battle."))
	ADD_TRAIT(owner, TRAIT_GUIDANCE, MAGIC_TRAIT)

/datum/status_effect/buff/song/fervor/on_remove()
	. = ..()
	to_chat(owner, span_warning("My feeble mind muddies my warcraft once more."))
	owner.remove_filter(FERVOR_FILTER)
	REMOVE_TRAIT(owner, TRAIT_GUIDANCE, MAGIC_TRAIT)


#undef FERVOR_FILTER
