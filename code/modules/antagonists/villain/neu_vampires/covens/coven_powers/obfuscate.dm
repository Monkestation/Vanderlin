#define COMBAT_COOLDOWN_LENGTH 45 SECONDS
#define REVEAL_COOLDOWN_LENGTH 15 SECONDS
#define MASK_DURATION 5 MINUTES

/datum/coven/obfuscate
	name = "Obfuscate"
	desc = "Makes you less noticeable for living and un-living beings."
	icon_state = "obfuscate"
	power_type = /datum/coven_power/obfuscate
	experience_multiplier = 1.5

/datum/coven_power/obfuscate
	name = "Obfuscate power name"
	desc = "Obfuscate power description"

	duration_length = 30 SECONDS
	cooldown_length = 15 SECONDS
	check_flags = COVEN_CHECK_CAPABLE
	/// Can this power be activated with witnesses?
	var/must_be_alone = FALSE

	var/static/list/aggressive_signals = list(
		COMSIG_MOB_ATTACK_HAND,
		COMSIG_ATOM_HITBY,
		COMSIG_ATOM_ATTACK_HAND,
		COMSIG_ATOM_ATTACKBY,
	)
	grouped_powers = list(
		/datum/coven_power/obfuscate/cloak_of_shadows,
		/datum/coven_power/obfuscate/unseen_presence,
		/datum/coven_power/obfuscate/mask_of_a_thousand_faces,
		/datum/coven_power/obfuscate/vanish_from_the_minds_eye,
		/datum/coven_power/obfuscate/cloak_the_gathering
	)

/datum/coven_power/obfuscate/pre_activation_checks()
	if(must_be_alone && length(owner.CheckEyewitness(owner)))
		to_chat(owner, span_warning("You cannot use [src] while you're being observed!"))
		return FALSE
	return ..()

/datum/coven_power/obfuscate/proc/on_combat_signal(datum/source)
	SIGNAL_HANDLER

	to_chat(owner, span_danger("Your Obfuscate falls away as you reveal yourself!"))
	try_deactivate(direct = TRUE)

	deltimer(cooldown_timer)
	cooldown_timer = addtimer(CALLBACK(src, PROC_REF(cooldown_expire)), COMBAT_COOLDOWN_LENGTH, TIMER_STOPPABLE)


//CLOAK OF SHADOWS - Basic stealth, broken by movement
/datum/coven_power/obfuscate/cloak_of_shadows
	name = "Cloak of Shadows"
	desc = "Meld into the shadows and stay unnoticed so long as you draw no attention. Broken by any movement."
	level = 1

	vitae_cost = 25
	toggled = TRUE
	violates_masquerade = TRUE

/datum/coven_power/obfuscate/cloak_of_shadows/activate()
	. = ..()
	RegisterSignal(owner, aggressive_signals, PROC_REF(on_combat_signal), override = TRUE)
	RegisterSignal(owner, COMSIG_MOVABLE_MOVED, PROC_REF(handle_move))

	owner.alpha = 10

/datum/coven_power/obfuscate/cloak_of_shadows/deactivate()
	. = ..()
	UnregisterSignal(owner, aggressive_signals)
	UnregisterSignal(owner, COMSIG_MOVABLE_MOVED)

	owner.alpha = 255

/datum/coven_power/obfuscate/cloak_of_shadows/proc/handle_move(datum/source, atom/moving_thing, dir)
	SIGNAL_HANDLER

	to_chat(owner, span_danger("Your [src] falls away as you move from your position!"))
	try_deactivate(direct = TRUE)

	deltimer(cooldown_timer)
	cooldown_timer = addtimer(CALLBACK(src, PROC_REF(cooldown_expire)), REVEAL_COOLDOWN_LENGTH, TIMER_STOPPABLE)

//UNSEEN PRESENCE - Can move while stealthed, but only walking speed
/datum/coven_power/obfuscate/unseen_presence
	name = "Unseen Presence"
	desc = "Move among the crowds without ever being noticed. Achieve invisibility while walking."
	level = 2

	vitae_cost = 10
	duration_length = 3 SECONDS
	toggled = TRUE
	must_be_alone = TRUE


/datum/coven_power/obfuscate/unseen_presence/activate()
	. = ..()
	ADD_TRAIT(owner, TRAIT_SILENT_FOOTSTEPS, VAMPIRE_TRAIT)
	RegisterSignal(owner, aggressive_signals, PROC_REF(on_combat_signal), override = TRUE)
	RegisterSignal(owner, COMSIG_MOVABLE_MOVED, PROC_REF(handle_move))

	owner.alpha = 10

/datum/coven_power/obfuscate/unseen_presence/deactivate()
	. = ..()
	REMOVE_TRAIT(owner, TRAIT_SILENT_FOOTSTEPS, VAMPIRE_TRAIT)
	UnregisterSignal(owner, aggressive_signals)
	UnregisterSignal(owner, COMSIG_MOVABLE_MOVED)

	owner.alpha = 255

/datum/coven_power/obfuscate/unseen_presence/proc/handle_move(datum/source, atom/moving_thing, dir)
	SIGNAL_HANDLER

	if (owner.m_intent != MOVE_INTENT_WALK)
		to_chat(owner, span_danger("Your [src] falls away as you move too quickly!"))
		try_deactivate(direct = TRUE)

		deltimer(cooldown_timer)
		cooldown_timer = addtimer(CALLBACK(src, PROC_REF(cooldown_expire)), REVEAL_COOLDOWN_LENGTH, TIMER_STOPPABLE)

//MASK OF A THOUSAND FACES - Disguise system instead of invisibility
/datum/coven_power/obfuscate/mask_of_a_thousand_faces
	name = "Mask of a Thousand Faces"
	desc = "Be noticed, but incorrectly. Assume the appearance of others for a limited time."
	level = 3

	vitae_cost = 50

	var/mask_timer

	var/datum/dna/old_dna
	var/old_hair
	var/old_hair_color
	var/old_eye_color
	var/old_second_color
	var/old_facial_hair
	var/old_facial_hair_color
	var/old_gender
	var/old_voice
	var/transformed = FALSE
	var/old_honorary
	var/old_honorary_s
	var/mob/living/carbon/human/current_target

// this shit isnt even remotely good, we need a better system  for transferring identities and storing them than this
// not fixing it now though!
/datum/coven_power/obfuscate/mask_of_a_thousand_faces/proc/store_original_appearance(mob/living/carbon/human/user)
	var/mob/living/carbon/human/transformer = owner

	var/datum/bodypart_feature/hair/feature = transformer.get_bodypart_feature_of_slot(BODYPART_FEATURE_HAIR)
	var/datum/bodypart_feature/hair/facial = transformer.get_bodypart_feature_of_slot(BODYPART_FEATURE_FACIAL_HAIR)
	old_dna = transformer.dna
	old_hair = feature?.accessory_type
	old_hair_color = transformer.get_hair_color()
	old_eye_color = transformer.get_eye_color(RIGHT_SIDE)
	old_second_color = transformer.get_eye_color(LEFT_SIDE)
	old_facial_hair_color = transformer.get_facial_hair_color()
	old_facial_hair = facial?.accessory_type
	old_gender = transformer.gender
	old_honorary = transformer.honorary
	old_honorary_s = transformer.honorary_suffix


/datum/coven_power/obfuscate/mask_of_a_thousand_faces/activate()
	. = ..()

	var/list/potential_targets = list()
	for(var/mob/living/carbon/human/target in oviewers(7, owner))
		if(target.client && target.stat < DEAD)
			potential_targets[target.real_name] = target

	if(!length(potential_targets))
		to_chat(owner, span_warning("There are no suitable targets nearby to mimic!"))
		return FALSE

	var/chosen_name = input(owner, "Choose someone to mimic:", "Mask of a Thousand Faces") as null|anything in potential_targets
	if(!chosen_name)
		return FALSE

	var/mob/living/carbon/human/target = potential_targets[chosen_name]
	if(!target || get_dist(owner, target) > 7)
		to_chat(owner, span_warning("Your target is no longer in range!"))
		return FALSE

	RegisterSignal(owner, aggressive_signals, PROC_REF(on_combat_signal), override = TRUE)

	// Store original appearance and copy target's
	store_original_appearance(owner)
	transform_into_target(target, owner)

	to_chat(owner, span_notice("You assume the appearance of [target.real_name]."))

/datum/coven_power/obfuscate/mask_of_a_thousand_faces/proc/transform_into_target(mob/living/carbon/human/target, mob/living/carbon/human/user)
	// Complete transformation
	target.dna.transfer_identity(user)
	user.updateappearance(mutcolor_update = TRUE)
	user.real_name = target.dna.real_name
	user.name = target.get_visible_name()
	user.gender = target.gender
	user.honorary = target.honorary
	user.honorary_suffix = target.honorary_suffix


	// Copy physical features with high accuracy
	var/datum/bodypart_feature/hair/target_feature = target.get_bodypart_feature_of_slot(BODYPART_FEATURE_HAIR)
	var/datum/bodypart_feature/hair/target_facial = target.get_bodypart_feature_of_slot(BODYPART_FEATURE_FACIAL_HAIR)

	var/obj/item/organ/eyes/right_eye = LAZYACCESS(target.eye_organs, 2)
	var/obj/item/organ/eyes/left_eye = LAZYACCESS(target.eye_organs, 1)
	if(right_eye || left_eye)
		user.set_eye_color(
			right_eye?.eye_color || "#FFFFFF",
			left_eye?.eye_color || right_eye?.eye_color || "#FFFFFF"
		)

	user.set_hair_color(target.get_hair_color(), FALSE)
	user.set_hair_style(target_feature?.accessory_type, FALSE)
	user.set_facial_hair_color(target.get_facial_hair_color(), FALSE)
	user.set_facial_hair_style(target_facial?.accessory_type, FALSE)

	user.updateappearance(mutcolor_update = TRUE)
	transformed = TRUE

/datum/coven_power/obfuscate/mask_of_a_thousand_faces/deactivate()
	. = ..()
	UnregisterSignal(owner, aggressive_signals)

	deltimer(mask_timer)
	return_to_normal(owner)
	to_chat(owner, span_warning("Your disguise begins to fade..."))

/datum/coven_power/obfuscate/mask_of_a_thousand_faces/proc/return_to_normal(mob/living/carbon/human/user)
	if(!transformed)
		return

	owner.visible_message(span_notice("[owner]'s form begins to revert to its original state."))
	user.Immobilize(1.5 SECONDS)

	old_dna.transfer_identity(user)
	user.real_name = old_dna.real_name
	user.name = user.get_visible_name()
	user.gender = old_gender
	user.honorary = old_honorary
	user.honorary_suffix = old_honorary_s



	user.set_eye_color(old_eye_color, old_second_color, FALSE)
	user.set_facial_hair_color(old_facial_hair_color, FALSE)
	user.set_facial_hair_style(old_facial_hair, FALSE)
	user.set_hair_color(old_hair_color, FALSE)
	user.set_hair_style(old_hair, FALSE)

	user.updateappearance(mutcolor_update = TRUE)
	transformed = FALSE
	current_target = null
	return TRUE

//VANISH FROM THE MIND'S EYE - Instant stealth activation + memory wipe
/datum/coven_power/obfuscate/vanish_from_the_minds_eye
	name = "Vanish from the Mind's Eye"
	desc = "Disappear from plain view instantly, and wipe your presence from the last 30 seconds of memory."
	level = 4
	cooldown_length = 5 MINUTES
	duration_length = 30 SECONDS

	vitae_cost = 150

/datum/coven_power/obfuscate/vanish_from_the_minds_eye/activate()
	. = ..()
	ADD_TRAIT(owner, TRAIT_SILENT_FOOTSTEPS, VAMPIRE_TRAIT)
	RegisterSignal(owner, aggressive_signals, PROC_REF(on_combat_signal), override = TRUE)
	RegisterSignal(owner, COMSIG_MOVABLE_MOVED, PROC_REF(handle_move))
	owner.playsound_local(owner, 'sound/magic/PSY.ogg', 200)
	owner.alpha = 10

	// Memory wipe effect - make nearby people forget they saw you
	for(var/mob/living/carbon/human/viewer in viewers(DEFAULT_MESSAGE_RANGE, owner))
		viewer.playsound_local(viewer, 'sound/magic/PSY.ogg', 200)
		if(!viewer.affects_masquerade(FALSE))
			continue
		if(HAS_TRAIT(viewer, TRAIT_COVEN_RESISTANT) || viewer.can_block_magic(MAGIC_RESISTANCE_MIND, 1))
			to_chat(viewer, span_boldannounce("You resist [src]'s hypnosis!"))
			found_ping(viewer, owner.client, "trap")
			log_combat(owner, viewer, "used [name] on", addition = "and FAILED")
			continue

		bordered_message(viewer, list(
			"<h1>[span_hypnophrase("<center>FORGET</center>")]</h1>",
			span_mind_control("<center>You have forgotten the last 30 seconds of your memory.</center>")
		))
		log_combat(owner, viewer, "used [name] on", addition = "and SUCCEEDED. Their memories from the last 30 seconds are wiped.")
		if(viewer.cmode)
			viewer.toggle_cmode()
		viewer.flash_fullscreen("blackflash")
		viewer.set_eyes_closed(TRUE)
		found_ping(viewer, owner.client, "hidden", 10 SECONDS)
		addtimer(CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(to_chat), viewer, span_hypnophrase("Wait... what was I doing?")), 3 SECONDS)

/datum/coven_power/obfuscate/vanish_from_the_minds_eye/deactivate()
	. = ..()
	REMOVE_TRAIT(owner, TRAIT_SILENT_FOOTSTEPS, VAMPIRE_TRAIT)
	UnregisterSignal(owner, aggressive_signals)
	UnregisterSignal(owner, COMSIG_MOVABLE_MOVED)

	owner.alpha = 255

/datum/coven_power/obfuscate/vanish_from_the_minds_eye/proc/handle_move(datum/source, atom/moving_thing, dir)
	SIGNAL_HANDLER

	if (owner.m_intent != MOVE_INTENT_WALK)
		to_chat(owner, span_danger("Your [src] falls away as you move too quickly!"))
		try_deactivate(direct = TRUE)

		deltimer(cooldown_timer)
		cooldown_timer = addtimer(CALLBACK(src, PROC_REF(cooldown_expire)), REVEAL_COOLDOWN_LENGTH, TIMER_STOPPABLE)

//CLOAK THE GATHERING - Group stealth for multiple people
/datum/coven_power/obfuscate/cloak_the_gathering
	name = "Cloak the Gathering"
	desc = "Hide yourself and others in a small area. All nearby allies become invisible."
	level = 5

	vitae_cost = 150
	toggled = TRUE

	var/list/cloaked_mobs = list()
	violates_masquerade = TRUE


/datum/coven_power/obfuscate/cloak_the_gathering/activate()
	. = ..()
	RegisterSignal(owner, aggressive_signals, PROC_REF(on_combat_signal), override = TRUE)
	RegisterSignal(owner, COMSIG_MOVABLE_MOVED, PROC_REF(handle_move))

	owner.alpha = 10
	cloaked_mobs = list(owner)

	// Cloak nearby allies
	for(var/mob/living/target in oviewers(3, owner))
		if(target.client && target.stat < UNCONSCIOUS)
			// Add faction/ally checks here as appropriate
			ADD_TRAIT(target, TRAIT_SILENT_FOOTSTEPS, VAMPIRE_TRAIT)
			target.alpha = 10
			cloaked_mobs += target
			to_chat(target, span_notice("You feel a supernatural veil fall over you..."))
			RegisterSignal(target, aggressive_signals, PROC_REF(on_ally_combat_signal), override = TRUE)

	to_chat(owner, span_notice("You extend your cloak to [length(cloaked_mobs) - 1] nearby allies."))

/datum/coven_power/obfuscate/cloak_the_gathering/deactivate()
	. = ..()
	UnregisterSignal(owner, aggressive_signals)
	UnregisterSignal(owner, COMSIG_MOVABLE_MOVED)

	// Restore visibility to all cloaked mobs
	for(var/mob/living/target in cloaked_mobs)
		REMOVE_TRAIT(target, TRAIT_SILENT_FOOTSTEPS, VAMPIRE_TRAIT)
		target.alpha = 255
		UnregisterSignal(target, aggressive_signals)
		if(target != owner)
			to_chat(target, span_warning("The supernatural veil fades away..."))

	cloaked_mobs.Cut()

/datum/coven_power/obfuscate/cloak_the_gathering/proc/handle_move(datum/source, atom/moving_thing, dir)
	SIGNAL_HANDLER

	to_chat(owner, span_danger("Your [src] falls away as you move from your position!"))
	try_deactivate(direct = TRUE)

	deltimer(cooldown_timer)
	cooldown_timer = addtimer(CALLBACK(src, PROC_REF(cooldown_expire)), REVEAL_COOLDOWN_LENGTH, TIMER_STOPPABLE)

/datum/coven_power/obfuscate/cloak_the_gathering/proc/on_ally_combat_signal(datum/source)
	SIGNAL_HANDLER

	var/mob/living/ally = source
	to_chat(ally, span_danger("Your actions break the supernatural veil!"))

	// Remove this ally from the cloak
	ally.alpha = 255
	UnregisterSignal(ally, aggressive_signals)
	cloaked_mobs -= ally

#undef COMBAT_COOLDOWN_LENGTH
#undef REVEAL_COOLDOWN_LENGTH
#undef MASK_DURATION
