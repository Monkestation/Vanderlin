/datum/action/cooldown/spell/enhanced_mimicry
	name = "Enhanced Mimicry"
	desc = "Takes on the complete appearance and mannerisms of your target."
	button_icon_state = "invisibility"
	sound = 'sound/misc/stings/generic.ogg'
	cast_range = 1

	associated_skill = /datum/skill/magic/arcane
	attunements = list(
		/datum/attunement/dark = 0.3,
		/datum/attunement/polymorph = 1.0,
	)

	charge_time = 3 SECONDS
	charge_drain = 1
	cooldown_time = 4 MINUTES
	spell_cost = 15

	var/datum/weakref/dna_ref
	var/old_hair
	var/old_hair_color
	var/old_eye_color
	var/old_facial_hair
	var/old_facial_hair_color
	var/old_gender
	var/old_voice
	var/transformed = FALSE

	var/transformation_stability = 100 // Decreases over time

/datum/action/cooldown/spell/enhanced_mimicry/Grant(mob/grant_to)
	. = ..()
	if(!ishuman(grant_to))
		qdel(src)
		return
	store_original_appearance()

/datum/action/cooldown/spell/enhanced_mimicry/proc/store_original_appearance()
	var/mob/living/carbon/human/transformer = owner

	var/datum/bodypart_feature/hair/feature = transformer.get_bodypart_feature_of_slot(BODYPART_FEATURE_HAIR)
	var/datum/bodypart_feature/hair/facial = transformer.get_bodypart_feature_of_slot(BODYPART_FEATURE_FACIAL_HAIR)
	dna_ref = WEAKREF(transformer.dna)
	old_hair = feature?.accessory_type
	old_hair_color = transformer.get_hair_color()
	old_eye_color = transformer.get_eye_color()
	old_facial_hair_color = transformer.get_facial_hair_color()
	old_facial_hair = facial?.accessory_type
	old_gender = transformer.gender

/datum/action/cooldown/spell/enhanced_mimicry/is_valid_target(atom/cast_on)
	. = ..()
	if(!.)
		return FALSE
	return ishuman(cast_on)

/datum/action/cooldown/spell/enhanced_mimicry/cast(mob/living/carbon/human/cast_on)
	. = ..()
	if(transformed)
		return_to_normal()
		return
	to_chat(owner, span_notice("You begin studying [cast_on]'s appearance and mannerisms..."))

	if(do_after(owner, 30 SECONDS, cast_on))
		transform_into_target(cast_on)

/datum/action/cooldown/spell/enhanced_mimicry/proc/transform_into_target(mob/living/carbon/human/target)
	var/mob/living/carbon/human/transformer = owner

	transformer.visible_message(span_warning("[transformer]'s form begins to shift and change!"))

	if(!do_after(transformer, 50 SECONDS, transformer))
		return

	// Complete transformation
	target.dna.transfer_identity(transformer)
	transformer.reset_limb_fingerprints()
	transformer.updateappearance(mutcolor_update = TRUE)
	transformer.real_name = target.dna.real_name
	transformer.name = target.get_visible_name()
	transformer.gender = target.gender

	// Copy physical features with high accuracy
	var/datum/bodypart_feature/hair/target_feature = target.get_bodypart_feature_of_slot(BODYPART_FEATURE_HAIR)
	var/datum/bodypart_feature/hair/target_facial = target.get_bodypart_feature_of_slot(BODYPART_FEATURE_FACIAL_HAIR)

	var/obj/item/organ/eyes/eyes = transformer.getorganslot(ORGAN_SLOT_EYES)
	eyes.eye_color = target.get_eye_color()
	transformer.set_hair_color(target.get_hair_color(), FALSE)
	transformer.set_hair_style(target_feature?.accessory_type, FALSE)
	transformer.set_facial_hair_color(target.get_facial_hair_color(), FALSE)
	transformer.set_facial_hair_style(target_facial?.accessory_type, FALSE)

	transformer.updateappearance(mutcolor_update = TRUE)
	transformed = TRUE
	transformation_stability = 100

	to_chat(transformer, span_notice("You have successfully taken on the appearance of [target.real_name]."))

	// Start stability decay
	addtimer(CALLBACK(src, PROC_REF(decay_transformation)), 60 SECONDS)

/datum/action/cooldown/spell/enhanced_mimicry/proc/decay_transformation()
	if(!transformed)
		return

	transformation_stability -= rand(5, 15)

	if(transformation_stability <= 0)
		to_chat(owner, span_warning("Your disguise is failing! You must return to normal or reinforce it!"))
		return_to_normal(owner)
		return

	if(transformation_stability <= 30)
		to_chat(owner, span_warning("Your disguise feels unstable..."))

	// Continue decay
	addtimer(CALLBACK(src, PROC_REF(decay_transformation), owner), 60 SECONDS)

/datum/action/cooldown/spell/enhanced_mimicry/proc/return_to_normal()
	if(!transformed)
		return

	var/mob/living/carbon/human/transformer = owner

	transformer.visible_message(span_notice("[transformer]'s form begins to revert to its original state."))
	transformer.Immobilize(30)

	if(!do_after(transformer, 50 SECONDS, transformer))
		return

	var/datum/dna/old_dna = dna_ref.resolve()
	old_dna.transfer_identity(transformer)
	transformer.reset_limb_fingerprints()
	transformer.real_name = old_dna.real_name
	transformer.name = transformer.get_visible_name()
	transformer.gender = old_gender

	var/obj/item/organ/eyes/eyes = transformer.getorganslot(ORGAN_SLOT_EYES)
	eyes.eye_color = old_eye_color
	transformer.set_facial_hair_color(old_facial_hair_color, FALSE)
	transformer.set_facial_hair_style(old_facial_hair, FALSE)
	transformer.set_hair_color(old_hair_color, FALSE)
	transformer.set_hair_style(old_hair, FALSE)

	transformer.updateappearance(mutcolor_update = TRUE)
	transformed = FALSE
	transformation_stability = 100
