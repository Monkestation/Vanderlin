
/obj/effect/proc_holder/spell/invoked/enhanced_mimicry
	name = "Enhanced Mimicry"
	desc = "Takes on the complete appearance and mannerisms of your target."
	overlay_state = "invisibility"
	releasedrain = 15
	chargedrain = 1
	chargetime = 3 SECONDS
	recharge_time = 200 SECONDS
	range = 1
	warnie = "sydwarning"
	movement_interrupt = FALSE
	sound = 'sound/misc/area.ogg'
	associated_skill = /datum/skill/magic/arcane
	attunements = list(
		/datum/attunement/dark = 0.3,
		/datum/attunement/polymorph = 1.0,
	)
	var/datum/dna/old_dna
	var/old_hair
	var/old_hair_color
	var/old_eye_color
	var/old_facial_hair
	var/old_facial_hair_color
	var/old_gender
	var/old_voice
	var/transformed = FALSE
	var/mob/living/carbon/human/current_target
	var/transformation_stability = 100 // Decreases over time

/obj/effect/proc_holder/spell/invoked/enhanced_mimicry/on_gain(mob/living/carbon/human/user)
	. = ..()
	store_original_appearance(user)

/obj/effect/proc_holder/spell/invoked/enhanced_mimicry/proc/store_original_appearance(mob/living/carbon/human/user)
	var/datum/bodypart_feature/hair/feature = user.get_bodypart_feature_of_slot(BODYPART_FEATURE_HAIR)
	var/datum/bodypart_feature/hair/facial = user.get_bodypart_feature_of_slot(BODYPART_FEATURE_FACIAL_HAIR)
	old_dna = user.dna
	old_hair = feature?.accessory_type
	old_hair_color = user.get_hair_color()
	old_eye_color = user.get_eye_color()
	old_facial_hair_color = user.get_facial_hair_color()
	old_facial_hair = facial?.accessory_type
	old_gender = user.gender

/obj/effect/proc_holder/spell/invoked/enhanced_mimicry/cast(list/targets, mob/living/user)
	if(transformed)
		return_to_normal(user)
		return TRUE

	if(ishuman(targets[1]))
		if(targets[1] == user)
			return FALSE

		current_target = targets[1]
		to_chat(user, span_notice("You begin studying [targets[1]]'s appearance and mannerisms..."))

		if(do_after(user, 30 SECONDS, target = targets[1]))
			transform_into_target(current_target, user)
		return TRUE
	return FALSE

/obj/effect/proc_holder/spell/invoked/enhanced_mimicry/proc/transform_into_target(mob/living/carbon/human/target, mob/living/carbon/human/user)
	visible_message(span_warning("[user]'s form begins to shift and change!"))

	if(!do_after(user, 50 SECONDS, target = user))
		return

	// Complete transformation
	target.dna.transfer_identity(user)
	user.updateappearance(mutcolor_update = TRUE)
	user.real_name = target.dna.real_name
	user.name = target.get_visible_name()
	user.gender = target.gender

	// Copy physical features with high accuracy
	var/datum/bodypart_feature/hair/target_feature = target.get_bodypart_feature_of_slot(BODYPART_FEATURE_HAIR)
	var/datum/bodypart_feature/hair/target_facial = target.get_bodypart_feature_of_slot(BODYPART_FEATURE_FACIAL_HAIR)

	var/obj/item/organ/eyes/eyes = user.getorganslot(ORGAN_SLOT_EYES)
	eyes.eye_color = target.get_eye_color()
	user.set_hair_color(target.get_hair_color(), FALSE)
	user.set_hair_style(target_feature?.accessory_type, FALSE)
	user.set_facial_hair_color(target.get_facial_hair_color(), FALSE)
	user.set_facial_hair_style(target_facial?.accessory_type, FALSE)

	user.updateappearance(mutcolor_update = TRUE)
	transformed = TRUE
	transformation_stability = 100

	to_chat(user, span_notice("You have successfully taken on the appearance of [target.real_name]."))

	// Start stability decay
	addtimer(CALLBACK(src, PROC_REF(decay_transformation), user), 60 SECONDS)

/obj/effect/proc_holder/spell/invoked/enhanced_mimicry/proc/decay_transformation(mob/living/carbon/human/user)
	if(!transformed)
		return

	transformation_stability -= rand(5, 15)

	if(transformation_stability <= 0)
		to_chat(user, span_warning("Your disguise is failing! You must return to normal or reinforce it!"))
		return_to_normal(user)
		return

	if(transformation_stability <= 30)
		to_chat(user, span_warning("Your disguise feels unstable..."))

	// Continue decay
	addtimer(CALLBACK(src, PROC_REF(decay_transformation), user), 60 SECONDS)

/obj/effect/proc_holder/spell/invoked/enhanced_mimicry/proc/return_to_normal(mob/living/carbon/human/user)
	if(!transformed)
		return

	visible_message(span_notice("[user]'s form begins to revert to its original state."))
	user.Immobilize(30)

	if(!do_after(user, 50 SECONDS, target = user))
		return

	old_dna.transfer_identity(user)
	user.real_name = old_dna.real_name
	user.name = user.get_visible_name()
	user.gender = old_gender

	var/obj/item/organ/eyes/eyes = user.getorganslot(ORGAN_SLOT_EYES)
	eyes.eye_color = old_eye_color
	user.set_facial_hair_color(old_facial_hair_color, FALSE)
	user.set_facial_hair_style(old_facial_hair, FALSE)
	user.set_hair_color(old_hair_color, FALSE)
	user.set_hair_style(old_hair, FALSE)

	user.updateappearance(mutcolor_update = TRUE)
	transformed = FALSE
	current_target = null
	transformation_stability = 100
