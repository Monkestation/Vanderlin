/datum/component/scrying
	var/name = "scrying component"

	var/text_cooldown_fail = "I look into NAME_HERE but only see inky smoke. Maybe I should wait."

	var/vision_duration = 8 SECONDS
	var/cooldown_duration = 30 SECONDS

	/// Whether or not the user of the scrying device needs to personally know the identity of their target.
	var/needs_to_know = TRUE
	/// Whether or not the target needs to be alive
	var/needs_to_live = TRUE

	var/mob/scry_eye/scrying_eye
	var/mob/living/carbon/held_user
	COOLDOWN_DECLARE(scry_cooldown)

/datum/component/scrying/Initialize(obj/item/scrying/parent)
	. = ..()
	text_cooldown_fail = replacetext(text_cooldown_fail, "NAME_HERE", "\the [name]")
	if(!parent)
		return

/datum/component/scrying/proc/activate(mob/living/user)
	if(!pass_extra_checks())
		return FALSE

	if(!COOLDOWN_FINISHED(src, scry_cooldown))
		to_chat(user, span_warning(text_cooldown_fail))
		return FALSE

	var/search_name = tgui_input_text(user, "Who are you looking for?", name)
	if(!search_name)
		return FALSE

	if(!user.mind || (needs_to_know && !user.mind.do_i_know(name = search_name)))
		to_chat(user, span_warning("I don't know anyone by that name."))
		return FALSE

	//check is applied twice to prevent someone from bypassing the cooldown
	if(!COOLDOWN_FINISHED(src, scry_cooldown))
		to_chat(user, span_warning(text_cooldown_fail))
		return FALSE

	var/mob/living/carbon/human/found_target
	for(var/mob/living/carbon/human/human_target as anything in GLOB.human_list)
		if(lowertext(human_target.real_name) == lowertext(search_name))
			var/turf/target_turf = get_turf(human_target)
			if(!target_turf)
				continue
			found_target = human_target
			break

	held_user = user
	if(HAS_TRAIT(found_target, TRAIT_ANTISCRYING))
		to_chat(user, span_warning("I peer into \the [name], but an impenetrable fog shrouds [search_name]."))
		to_chat(found_target, span_warning("My magical shrouding reacted to something."))
		held_user = null
		return

	create_eye()
	if(!scrying_eye)
		remove_eye(TRUE)
		return

	if(needs_to_live && found_target.stat)
		to_chat(user, span_warning("I peer into \the [name], but can't find [search_name]."))
		remove_eye(TRUE)
		return FALSE

	log_game("SCRYING: [user.real_name] ([user.ckey]) has used the [name] to leer at [found_target.real_name] ([found_target.ckey])")

	var/real_cooldown = cooldown_duration + vision_duration
	COOLDOWN_START(src, scry_cooldown, real_cooldown)
	user.visible_message(span_danger("[user] stares into \the [name], [user.p_their()] eyes rolling back into [user.p_their()] head."), span_warning("My eyes roll into the back of my head as I'm lost in the depths of the orb."))
	scrying_eye.orbit(found_target)
	var/target_perception = GET_MOB_ATTRIBUTE_VALUE(found_target, STAT_PERCEPTION)
	if(target_perception >= 15)
		if(found_target.mind)
			if(found_target.mind.do_i_know(name = user.real_name))
				to_chat(found_target, span_warning("I can clearly see the face of [user.real_name] staring at me!"))
				to_chat(user, span_warning("[found_target.real_name] stares back at me!"))
				return TRUE
		to_chat(found_target, span_warning("I can clearly see the face of an unknown [user.gender == FEMALE ? "woman" : "man"] staring at me!"))
		return TRUE
	if(target_perception >= 11)
		to_chat(found_target, span_warning("I feel a pair of unknown eyes on me."))
	return TRUE

/datum/component/scrying/proc/create_eye()
	if(!held_user)
		return FALSE
	scrying_eye = new
	scrying_eye.component = src
	held_user.reset_perspective(scrying_eye)
	held_user.Immobilize(vision_duration)
	held_user.overlay_fullscreen("scrying", /atom/movable/screen/backhudl/obscured)
	addtimer(CALLBACK(src, PROC_REF(remove_eye)), vision_duration)

/datum/component/scrying/proc/remove_eye(early = FALSE)
	if(!held_user)
		return FALSE
	held_user.reset_perspective(held_user)
	held_user.clear_fullscreen("scrying")
	if(early)
		held_user.SetImmobilized(2 SECONDS)
	QDEL_NULL(scrying_eye)
	held_user = null


/datum/component/scrying/proc/pass_extra_checks(mob/living/user)
	return TRUE

/datum/component/scrying/orb
	name = "Scrying Orb"

/datum/component/scrying/orb/pass_extra_checks(mob/living/user)
	if(GET_MOB_SKILL_VALUE_OLD(user, /datum/attribute/skill/magic/arcane) < 1)
		to_chat(human_user, span_warning("I do not know what to do with this..."))
		return FALSE
	return TRUE

/datum/component/scrying/eye
	name = "Accursed Eye"
	cooldown_duration = 5 MINUTES

/datum/component/scrying/vampire
	name = "Night's Eye"
	needs_to_know = FALSE
	needs_to_live = FALSE

/datum/component/scrying/telescope
	name = "NOC Device"
	text_cooldown_fail = "I peer into the sky but cannot focus the lens on the face of Noc. Maybe I should wait."

/datum/component/scrying/telescope/pass_extra_checks(mob/living/user)
	var/mob/living/carbon/human/human_user = user
	if(!ishuman(human_user) || !HAS_TRAIT(human_user, TRAIT_VIRGIN))
		to_chat(human_user, span_warning("Noc looks angry with me..."))
		return FALSE
	return TRUE

/datum/component/scrying/mirror
	name = "Black Mirror"
	vision_duration = 4 SECONDS
	needs_to_know = FALSE
	needs_to_live = FALSE
	var/obj/item/inqarticles/bmirror/parent_mirror
	var/mob/stored_target

/datum/component/scrying/mirror/Initialize(obj/item/scrying/parent)
	. = ..()
	parent_mirror = parent
	if(!istype(parent_mirror))
		return INITIALIZE_HINT_QDEL

/datum/component/scrying/mirror/activate(mob/living/user)
	if(!pass_extra_checks())
		message_admins("SCRY DEBUG: EXTRA CHECKS FAIL")
		return FALSE

	if(!COOLDOWN_FINISHED(src, scry_cooldown))
		to_chat(user, span_warning(text_cooldown_fail))
		return FALSE

	var/search_name = stripped_input(user, "Who are you looking for?", name)
	if(!search_name)
		return FALSE

	if(!user.mind)
		to_chat(user, span_warning("I don't know of anyone by that name."))
		return FALSE

	//check is applied twice to prevent someone from bypassing the cooldown
	if(!COOLDOWN_FINISHED(src, scry_cooldown))
		to_chat(user, span_warning(text_cooldown_fail))
		return FALSE

	for(var/mob/living/carbon/human/human_target in GLOB.human_list)
		if(human_target.real_name == search_name)
			var/turf/target_turf = get_turf(human_target)
			if(!target_turf)
				continue
			stored_target = human_target
			break

	held_user = user
	if(HAS_TRAIT(stored_target, TRAIT_ANTISCRYING))
		to_chat(user, span_warning("I peer into \the [name], but an impenetrable fog shrouds [search_name]."))
		to_chat(stored_target, span_warning("My magical shrouding reacted to something."))
		held_user = null
		return

	create_eye()
	if(!scrying_eye)
		remove_eye(TRUE)
		return

	log_game("SCRYING: [user.real_name] ([user.ckey]) has used the [name] to leer at [stored_target.real_name] ([stored_target.ckey])")

	var/real_cooldown = cooldown_duration + vision_duration
	COOLDOWN_START(src, scry_cooldown, real_cooldown)
	user.visible_message(span_danger("[user] stares into \the [name], [user.p_their()] eyes rolling back into [user.p_their()] head."), span_warning("My eyes roll into the back of my head as I'm lost in the depths of the orb."))
	apply_black_eye()
	return TRUE

/datum/component/scrying/mirror/create_eye()
	if(!held_user)
		return FALSE
	scrying_eye = new
	scrying_eye.component = src
	held_user.reset_perspective(scrying_eye)
	held_user.Immobilize(vision_duration)
	held_user.overlay_fullscreen("scrying", /atom/movable/screen/backhudl/obscured)
	playsound(held_user, 'sound/items/blackmirror_use.ogg', 100, FALSE)
	addtimer(CALLBACK(src, PROC_REF(remove_eye)), vision_duration)

/datum/component/scrying/mirror/remove_eye(early = FALSE)
	if(!held_user)
		return FALSE
	held_user.reset_perspective(held_user)
	held_user.clear_fullscreen("scrying")
	playsound(held_user, 'sound/items/blackeye.ogg', 100, FALSE)
	if(early)
		held_user.SetImmobilized(2 SECONDS)
	QDEL_NULL(scrying_eye)
	held_user = null
	if(stored_target)
		stored_target.clear_alert("blackmirror", TRUE)
		stored_target.playsound_local(src, 'sound/items/blackeye.ogg', 40, FALSE)
		stored_target = null
	parent_mirror.donefixating()

/datum/component/scrying/mirror/proc/apply_black_eye()
	scrying_eye.orbit(stored_target)
	parent_mirror.effect = stored_target.throw_alert("blackmirror", /atom/movable/screen/alert/blackmirror, override = TRUE)
	playsound(stored_target, 'sound/items/blackeye_warn.ogg', 100, FALSE)
