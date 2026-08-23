#define SONG_DEBUFF_FILTER "song_debuff_glow"

/datum/status_effect/debuff/song
	var/outline_colour = "#CC3333" // Red outline for all song debuffs

/datum/status_effect/debuff/song/on_apply()
	. = ..()
	var/filter = owner.get_filter(SONG_DEBUFF_FILTER)
	if(!filter)
		owner.add_filter(SONG_DEBUFF_FILTER, 2, list("type" = "outline", "color" = outline_colour, "alpha" = 40, "size" = 1))

/datum/status_effect/debuff/song/on_remove()
	. = ..()
	// Only remove filter if no other song debuffs remain
	var/has_other_song_debuff = FALSE
	for(var/datum/status_effect/debuff/song/S in owner.status_effects)
		if(S != src)
			has_other_song_debuff = TRUE
			break
	if(!has_other_song_debuff)
		owner.remove_filter(SONG_DEBUFF_FILTER)

/datum/action/cooldown/spell/undirected/song
	abstract_type = /datum/action/cooldown/spell/undirected/song
	button_icon = 'icons/mob/actions/bardsongs.dmi'
	button_icon_state = "dirge_t1_base"
	sound = 'sound/magic/buffrollaccent.ogg'
	invocation = "plays a song."
	invocation_self_message = "you play a song."

	click_to_activate = FALSE
	self_cast_possible = TRUE

	spell_type = SPELL_STAMINA
	spell_cost = SONG_ACTIVATION_COST

	charge_required = FALSE
	cooldown_time = 30 SECONDS

	invocation_type = INVOCATION_EMOTE

	spell_requirements = SPELL_REQUIRES_HUMAN
	associated_skill = /datum/attribute/skill/misc/music

	var/datum/status_effect/song_effect = null

/// Check if user is holding an instrument in either hand
/datum/action/cooldown/spell/undirected/song/proc/has_instrument(mob/living/carbon/human/user)
	for(var/obj/item/held in user.held_items)
		if(istype(held, /obj/item/instrument))
			return TRUE
	return FALSE

/datum/action/cooldown/spell/undirected/song/can_cast_spell(feedback = TRUE)
	. = ..()
	if(!.)
		return FALSE
	if(!ishuman(owner))
		return FALSE
	var/mob/living/carbon/human/H = owner
	if(!has_instrument(H))
		if(feedback)
			to_chat(H, span_warning("I need an instrument in hand to perform!"))
		return FALSE
	return TRUE

/datum/action/cooldown/spell/undirected/song/cast(atom/cast_on)
	. = ..()
	var/mob/living/carbon/human/H = owner

	// Toggle off if already playing this exact song
	if(song_effect)
		for(var/datum/status_effect/existing in H.status_effects)
			if(existing.type == song_effect)
				H.remove_status_effect(existing)
				to_chat(H, span_warning("I stop my song."))
				return TRUE

	// Clear any existing song and its applied effects before starting a new one
	for(var/datum/status_effect/buff/playing_melody/melodies in H.status_effects)
		H.remove_status_effect(melodies)
	for(var/datum/status_effect/buff/playing_dirge/dirges in H.status_effects)
		H.remove_status_effect(dirges)
	// Explicitly clean up lingering song buffs/debuffs from the old song
	if(H.inspiration)
		for(var/mob/living/carbon/human/guy in H.inspiration.audience)
			for(var/datum/status_effect/buff/song/old_buff in guy.status_effects)
				guy.remove_status_effect(old_buff)
		for(var/mob/living/carbon/human/enemy in hearers(10, H))
			for(var/datum/status_effect/debuff/song/old_debuff in enemy.status_effects)
				enemy.remove_status_effect(old_debuff)
	// Apply new song - on_apply will immediately grant effects
	H.apply_status_effect(song_effect)
	return TRUE

/// Shared proc to check instrument and cancel song if not held. Returns FALSE if song should stop.
/proc/song_check_instrument(mob/living/carbon/human/owner)
	if(!owner || !owner.inspiration)
		return FALSE
	for(var/obj/item/held in owner.held_items)
		if(istype(held, /obj/item/instrument))
			return TRUE
	// No instrument - cancel song and clean up audience buffs
	for(var/datum/status_effect/buff/playing_melody/melodies in owner.status_effects)
		owner.remove_status_effect(melodies)
	for(var/datum/status_effect/buff/playing_dirge/dirges in owner.status_effects)
		owner.remove_status_effect(dirges)
	for(var/mob/living/carbon/human/guy in owner.inspiration.audience)
		for(var/datum/status_effect/buff/song/song2remove in guy.status_effects)
			guy.remove_status_effect(song2remove)
	to_chat(owner, span_warning("I lost my instrument - my song fades."))
	return FALSE

/datum/status_effect/buff/playing_dirge
	id = "play_dirge"
	alert_type = /atom/movable/screen/alert/status_effect/buff/playing_dirge
	var/effect_color
	var/datum/status_effect/debuff/debuff_to_apply // Applied by T1 (lesser) bards, or as default if no full variant
	var/datum/status_effect/debuff/debuff_to_apply_full // Applied by T2 (full) bards. If null, uses debuff_to_apply for all tiers
	var/pulse = 0
	var/ticks_to_apply = SONG_SUSTAIN_TICKS
	duration = -1
	var/obj/effect/temp_visual/songs/effect = /obj/effect/temp_visual/songs/inspiration_dirget1
	var/energytodrain = SONG_SUSTAIN_COST


/atom/movable/screen/alert/status_effect/buff/playing_dirge
	name = "Playing Dirge"
	desc = "Terrorizing the world with my craft."
	icon_state = "buff"


/datum/status_effect/buff/playing_dirge/tick()
	var/mob/living/carbon/human/O = owner
	if(!song_check_instrument(O))
		return
	pulse += 1
	new effect(get_turf(owner))
	// Spawn telltale notes on debuffed enemies every tick (2s) for visibility
	for(var/mob/living/carbon/human/H in hearers(10, O))
		if(!O.in_audience(H))
			for(var/datum/status_effect/debuff/song/S in H.status_effects)
				new /obj/effect/temp_visual/song_telltale/debuff(get_turf(H))
				break // One note per target per tick
	if (pulse >= ticks_to_apply)
		pulse = 0
		O.adjust_stamina(energytodrain)
		apply_song_effects(O)

/// Apply debuff to all non-audience in range. Separated so on_apply can call it too.
/datum/status_effect/buff/playing_dirge/proc/apply_song_effects(mob/living/carbon/human/O)
	var/debuff = debuff_to_apply
	if(debuff_to_apply_full && O.inspiration.level >= BARD_T2)
		debuff = debuff_to_apply_full
	var/base_range = 3
	base_range += GET_MOB_SKILL_VALUE(owner, /datum/attribute/skill/misc/music) * 0.1

	for (var/mob/living/carbon/human/H in hearers(FLOOR(base_range, 1), O))
		if(!O.in_audience(H))
			H.apply_status_effect(debuff)

/datum/status_effect/buff/playing_dirge/on_apply()
	. = ..()
	// Apply effects immediately on song start, don't wait for first full pulse cycle
	var/mob/living/carbon/human/O = owner
	if(O?.inspiration)
		apply_song_effects(O)

/datum/status_effect/buff/playing_dirge/on_remove()
	. = ..()
	// Clean up debuffs on enemies when song stops
	if(!ishuman(owner))
		return
	var/mob/living/carbon/human/O = owner
	if(!O.inspiration)
		return
	for(var/mob/living/carbon/human/H in hearers(10, O))
		for(var/datum/status_effect/debuff/song/song2remove in H.status_effects)
			H.remove_status_effect(song2remove)


/datum/status_effect/buff/playing_melody
	id = "play_melody"
	alert_type = /atom/movable/screen/alert/status_effect/buff/playing_melody
	var/effect_color
	var/datum/status_effect/buff/buff_to_apply // Applied by T1 (lesser) bards, or as default if no full variant
	var/datum/status_effect/buff/buff_to_apply_full // Applied by T2 (full) bards. If null, uses buff_to_apply for all tiers
	var/pulse = 0
	var/ticks_to_apply = SONG_SUSTAIN_TICKS
	duration = -1
	var/obj/effect/temp_visual/songs/effect = /obj/effect/temp_visual/songs/inspiration_melodyt1
	var/energytodrain = SONG_SUSTAIN_COST

/atom/movable/screen/alert/status_effect/buff/playing_melody
	name = "Playing Melody"
	desc = "Healing the world with my craft."
	icon_state = "buff"

/datum/status_effect/buff/playing_melody/tick()
	var/mob/living/carbon/human/O = owner
	if(!song_check_instrument(O))
		return
	new effect(get_turf(owner))
	var/base_range = 3
	base_range += GET_MOB_SKILL_VALUE(owner, /datum/attribute/skill/misc/music) * 0.2

	for(var/mob/living/carbon/human/H in hearers(FLOOR(base_range, 1), O))
		if(O.in_audience(H))
			for(var/datum/status_effect/buff/song/S in H.status_effects)
				new /obj/effect/temp_visual/song_telltale/buff(get_turf(H))
				break // One note per target per tick
	pulse += 1
	if (pulse >= ticks_to_apply)
		pulse = 0
		O.adjust_stamina(energytodrain)
		apply_song_effects(O)

/// Apply buff to all audience in range. Separated so on_apply can call it too.
/datum/status_effect/buff/playing_melody/proc/apply_song_effects(mob/living/carbon/human/O)
	var/buff = buff_to_apply
	if(buff_to_apply_full && O.inspiration.level >= BARD_T2)
		buff = buff_to_apply_full
	for (var/mob/living/carbon/human/H in hearers(10, O))
		if(O.in_audience(H))
			H.apply_status_effect(buff)

/datum/status_effect/buff/playing_melody/on_apply()
	. = ..()
	// Apply effects immediately on song start, don't wait for first full pulse cycle
	var/mob/living/carbon/human/O = owner
	if(O?.inspiration)
		apply_song_effects(O)

/datum/status_effect/buff/playing_melody/on_remove()
	. = ..()
	// Clean up buffs on audience when song stops
	if(!ishuman(owner))
		return
	var/mob/living/carbon/human/O = owner
	if(!O.inspiration)
		return
	for(var/mob/living/carbon/human/guy in O.inspiration.audience)
		for(var/datum/status_effect/buff/song/song2remove in guy.status_effects)
			guy.remove_status_effect(song2remove)

#undef SONG_DEBUFF_FILTER
