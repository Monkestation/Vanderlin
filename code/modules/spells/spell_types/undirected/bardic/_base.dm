/datum/action/cooldown/spell/undirected/song
	spell_type = SPELL_STAMINA
	button_icon = 'icons/mob/actions/bardsongs.dmi'
	background_icon = 'icons/mob/actions/bardsongs.dmi'
	has_visual_effects = FALSE
	associated_skill = /datum/skill/misc/music
	experience_modifier = 0.1

	charge_required = FALSE
	invocation = ""
	invocation_type = INVOCATION_SHOUT
	sound = 'sound/magic/buffrollaccent.ogg'
	cooldown_time = 100 SECONDS
	var/datum/status_effect/stacking/playing_inspiration/song_stack_effect = /datum/status_effect/stacking/playing_inspiration
	var/datum/status_effect/inspiration_effect

/datum/action/cooldown/spell/undirected/song/Grant(mob/grant_to)
	if(!ishuman(grant_to))
		return
	. = ..()

/datum/action/cooldown/spell/undirected/song/PreActivate(atom/target)
	if(!owner.has_status_effect(/datum/status_effect/buff/playing_music))
		to_chat(owner, span_warning("You need to be playing music first!"))
		return FALSE
	if(owner.has_status_effect(/datum/status_effect/stacking/playing_inspiration))
		to_chat(owner, span_warning("You're already preparing a melody!"))
		return FALSE
	return ..()

/datum/action/cooldown/spell/undirected/song/cast(atom/cast_on)
	. = ..()
	var/mob/living/living_owner = owner
	modify_applied_effect(living_owner.apply_status_effect(song_stack_effect, null, 1, inspiration_effect))

/datum/action/cooldown/spell/undirected/song/proc/modify_applied_effect(datum/status_effect/stacking/playing_inspiration/applied_effect)
	if(!applied_effect)
		return FALSE
	applied_effect.linked_alert?.name = "Playing [name]"
	applied_effect.linked_alert?.desc = "[desc]"
	applied_effect.finishing_sound = sound
	return TRUE

/datum/status_effect/inspiration
	status_type = STATUS_EFFECT_REFRESH

/datum/status_effect/stacking/playing_inspiration
	id = "play_inspiration" // subtypes must share the same id to block stacking multiple melodies
	alert_type = /atom/movable/screen/alert/status_effect/buff/inspiration
	delay_before_decay = 2
	tick_interval = 5 // 0.5 second ticks
	stack_decay = 2 // decay at twice the speed of buildup (5 seconds max)
	stack_threshold = 20 // by default after 10 seconds
	max_stacks = 20

	var/visual_icon_state
	var/datum/status_effect/inspiration/effect_to_apply
	var/finishing_energy_cost = 20
	var/finishing_sound
	var/range = 7

/datum/status_effect/stacking/playing_inspiration/on_creation(mob/living/new_owner, duration_override, stacks_to_apply, inspiration_effect)
	. = ..()
	effect_to_apply = inspiration_effect

/datum/status_effect/stacking/playing_inspiration/tick()
	if(!can_have_status())
		qdel(src)
		return
	if(owner.has_status_effect(/datum/status_effect/buff/playing_music))
		add_stacks(stack_decay / 2)
		if(stacks % 3)
			var/obj/effect/temp_visual/visual_effect = new /obj/effect/temp_visual/songs(get_turf(owner))
			visual_effect.icon_state = visual_icon_state
	else
		add_stacks(-stack_decay)
		stack_decay_effect()

/datum/status_effect/stacking/playing_inspiration/stacks_consumed_effect()
	. = ..()
	if(finishing_sound)
		playsound(owner, finishing_sound, 50, TRUE)
	var/mob/living/carbon/human/human_owner = owner
	if(!human_owner.inspiration)
		return
	owner.adjust_energy(-finishing_energy_cost)
	find_audience()

/datum/status_effect/stacking/playing_inspiration/proc/find_audience()
	var/mob/living/carbon/human/human_owner = owner
	for (var/mob/living/carbon/human/listener in hearers(range, human_owner))
		if(human_owner.inspiration.check_in_audience(listener))
			listener.apply_status_effect(effect_to_apply)

/atom/movable/screen/alert/status_effect/buff/inspiration
	icon_state = "inspiration"

/datum/status_effect/stacking/playing_inspiration/target_nonaudience

/datum/status_effect/stacking/playing_inspiration/target_nonaudience/find_audience()
	var/mob/living/carbon/human/human_owner = owner
	for (var/mob/living/carbon/human/listener in ohearers(range, human_owner))
		if(human_owner.inspiration.check_in_audience(listener))
			continue
		listener.apply_status_effect(effect_to_apply)

/atom/movable/screen/alert/status_effect/buff/song
	icon_state = "melody"

/atom/movable/screen/alert/status_effect/debuff/song
	icon_state = "dirge"
