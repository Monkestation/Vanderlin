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

	/// The perception stat required to see the face of your scry-er.
	var/perception_face = 15
	/// The perception stat to sense being scryed.
	var/perception_sense = 11

	COOLDOWN_DECLARE(scry_cooldown)

/datum/component/scrying/Initialize(new_view_duration, new_cooldown_duration, need_knowledge, need_alive, cooldown_text_override, new_face_perception, new_sense_perception)
	. = ..()
	if(!isitem(parent) && !isstructure(parent))
		return COMPONENT_INCOMPATIBLE

	if(new_view_duration)
		vision_duration = new_view_duration
	if(new_cooldown_duration)
		cooldown_duration = new_cooldown_duration
	if(!isnull(need_knowledge))
		needs_to_know = need_knowledge
	if(!isnull(need_alive))
		needs_to_live = need_alive
	if(cooldown_text_override)
		text_cooldown_fail = cooldown_text_override
	if(new_face_perception)
		perception_face = new_face_perception
	if(new_sense_perception)
		perception_sense = new_sense_perception

	var/obj/parent_obj = parent
	name = parent_obj.name
	text_cooldown_fail = replacetext(text_cooldown_fail, "NAME_HERE", "\the [name]")

/datum/component/scrying/RegisterWithParent()
	if(isitem(parent))
		RegisterSignal(parent, COMSIG_ITEM_ATTACK_SELF, PROC_REF(activate))
		return
	if(isstructure(parent))
		RegisterSignal(parent, COMSIG_ATOM_ATTACK_HAND, PROC_REF(activate))
		return

/datum/component/scrying/UnregisterFromParent()
	if(isitem(parent))
		UnregisterSignal(parent, COMSIG_ITEM_ATTACK_SELF)
		return
	if(isstructure(parent))
		UnregisterSignal(parent, COMSIG_ATOM_ATTACK_HAND)
		return

/datum/component/scrying/Destroy(force)
	QDEL_NULL(scrying_eye)
	held_user = null
	return ..()

/datum/component/scrying/proc/activate(datum/source, mob/living/user)
	var/obj/parent_obj = parent
	if(!parent_obj.pass_scrying_checks(user))
		return FALSE

	if(!COOLDOWN_FINISHED(src, scry_cooldown))
		to_chat(user, span_warning(text_cooldown_fail))
		return FALSE

	var/search_name = tgui_input_text(user, "Who are you looking for?", name, timeout = 10 SECONDS)

	//check is applied twice to prevent someone from bypassing the cooldown
	if(!COOLDOWN_FINISHED(src, scry_cooldown))
		to_chat(user, span_warning(text_cooldown_fail))
		return FALSE

	if(!search_name)
		return FALSE

	if(!user.mind || (needs_to_know && !user.mind.do_i_know(name = search_name)))
		to_chat(user, span_warning("I don't know anyone by that name."))
		return FALSE

	var/mob/living/carbon/human/found_target
	for(var/mob/living/carbon/human/human_target as anything in GLOB.human_list)
		if(LOWER_TEXT(human_target.real_name) == LOWER_TEXT(search_name))
			var/turf/target_turf = get_turf(human_target)
			if(!target_turf)
				continue
			found_target = human_target
			break

	if(!found_target)
		return

	if(HAS_TRAIT(found_target, TRAIT_ANTISCRYING))
		to_chat(user, span_warning("I peer into \the [name], but an impenetrable fog shrouds [search_name]."))
		to_chat(found_target, span_warning("My magical shrouding reacted to something."))
		return

	if(needs_to_live && found_target.stat)
		to_chat(user, span_warning("I peer into \the [name], but can't find [search_name]."))
		return FALSE

	held_user = user
	create_eye()
	if(!scrying_eye)
		remove_eye(TRUE)
		return

	log_game("SCRYING: [user.real_name] ([user.ckey]) has used the [name] to scry [found_target.real_name] ([found_target.ckey])")

	var/real_cooldown = cooldown_duration + vision_duration
	COOLDOWN_START(src, scry_cooldown, real_cooldown)
	user.visible_message(span_danger("[user] stares into \the [name], [user.p_their()] eyes rolling back into [user.p_their()] head."), span_warning("My eyes roll into the back of my head as I'm lost in the depths of \the [name]."))
	scrying_eye.orbit(found_target)
	var/target_perception = GET_MOB_ATTRIBUTE_VALUE(found_target, STAT_PERCEPTION)
	if(target_perception >= perception_face)
		if(found_target.mind)
			if(found_target.mind.do_i_know(name = user.real_name))
				to_chat(found_target, span_warning("I can clearly see the face of [user.real_name] staring at me!"))
				to_chat(user, span_warning("[found_target.real_name] stares back at me!"))
				return TRUE
		to_chat(found_target, span_warning("I can clearly see the face of an unknown [user.gender == FEMALE ? "woman" : "man"] staring at me!"))
		return TRUE
	if(target_perception >= perception_sense)
		to_chat(found_target, span_warning("I feel a pair of unknown eyes on me."))
	return TRUE

/datum/component/scrying/proc/create_eye()
	if(!held_user)
		return FALSE
	scrying_eye = new
	scrying_eye.user_mob = held_user
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

/datum/component/scrying/mirror
	name = "Black Mirror"
	vision_duration = 6 SECONDS
	needs_to_know = FALSE
	needs_to_live = FALSE
	var/obj/item/inqarticles/bmirror/parent_mirror
	var/mob/stored_target
	var/atom/movable/screen/alert/blackmirror/effect

/datum/component/scrying/mirror/Initialize(new_view_duration, new_cooldown_duration, need_knowledge, need_alive, cooldown_text_override)
	. = ..()
	parent_mirror = parent
	if(!istype(parent_mirror))
		return INITIALIZE_HINT_QDEL

/datum/component/scrying/mirror/Destroy(force)
	parent_mirror = null
	stored_target = null
	QDEL_NULL(effect)
	. = ..()

/datum/component/scrying/mirror/activate(mob/living/user)
	var/obj/parent_obj = parent
	if(!parent_obj.pass_scrying_checks(user))
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
	scrying_eye.user_mob = held_user
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
	effect = null

/datum/component/scrying/mirror/proc/apply_black_eye()
	scrying_eye.orbit(stored_target)
	effect = stored_target.throw_alert("blackmirror", /atom/movable/screen/alert/blackmirror, override = TRUE)
	effect.source = parent_mirror
	playsound(stored_target, 'sound/items/blackeye_warn.ogg', 100, FALSE)
