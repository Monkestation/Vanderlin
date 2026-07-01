#define OPERATION_NEW_NAME "chosen_name"

/datum/surgery_operation/limb/plastic_surgery
	name = "Facial Reconstruction"
	desc = "Reshape a patient's face to fix disfigurement or make them a new person."

	implements = list(
		TOOL_SCALPEL = 1,
		/obj/item/weapon/knife = 1.6
	)

	time = 6.4 SECONDS

	skill_min = SKILL_LEVEL_APPRENTICE
	skill_median = SKILL_LEVEL_EXPERT

	operation_flags = OPERATION_NOTABLE

	preop_sound = 'sound/surgery/scalpel1.ogg'
	success_sound = 'sound/surgery/scalpel2.ogg'

	all_surgery_states_required = SURGERY_SKIN_OPEN

/datum/surgery_operation/limb/plastic_surgery/get_default_radial_image()
	return image(/obj/item/weapon/surgery/scalpel)

/datum/surgery_operation/limb/plastic_surgery/all_required_strings()
	return list("operate on head (target head)") + ..()

/datum/surgery_operation/limb/plastic_surgery/state_check(obj/item/bodypart/limb)
	return limb.body_zone == BODY_ZONE_HEAD

/datum/surgery_operation/limb/plastic_surgery/pre_preop(obj/item/bodypart/limb, mob/living/surgeon, tool, list/operation_args)
	if(limb.has_wound(/datum/wound/facial/disfigurement))
		return TRUE

	var/mob/living/patient = limb.owner

	var/datum/species/species
	if(ishuman(patient))
		var/mob/living/carbon/human/human_target = patient
		species = human_target?.dna?.species

	if(!species)
		return FALSE

	var/list/names = list("Custom")
	for(var/i in 1 to 10)
		names += species.random_name(patient.gender, TRUE)

	var/choice = tgui_input_list(surgeon, "New name to assign", "Facial Reconstruction", names)

	if(choice == "Custom")
		choice = tgui_input_text(surgeon, "New name to assign", "Facial Reconstruction", patient.name, max_length = MAX_NAME_LEN)

	if(!choice)
		return FALSE

	operation_args[OPERATION_NEW_NAME] = choice
	return !!operation_args[OPERATION_NEW_NAME]

/datum/surgery_operation/limb/plastic_surgery/on_preop(obj/item/bodypart/limb, mob/living/surgeon, tool, list/operation_args)
	display_results(
		surgeon,
		limb.owner,
		span_notice("I begin to alter [limb.owner]'s appearance..."),
		span_notice("[surgeon] begins to alter [limb.owner]'s appearance."),
		span_notice("[surgeon] begins to make an incision in [limb.owner]'s face."),
	)
	display_pain(limb.owner, "I feel a slicing pain across your face!")

/datum/surgery_operation/limb/plastic_surgery/on_success(obj/item/bodypart/limb, mob/living/surgeon, tool, list/operation_args)
	if(!istype(limb))
		CRASH("Plastic surgery finished on a non-head limb [limb]!")

	if(limb.has_wound(/datum/wound/facial/disfigurement))
		limb.remove_wound(/datum/wound/facial/disfigurement)
		display_results(
			surgeon,
			limb.owner,
			span_notice("I successfully restore [limb.owner]'s appearance."),
			span_notice("[surgeon] successfully restores [limb.owner]'s appearance!"),
			span_notice("[surgeon] finishes the operation on [limb.owner]'s face."),
		)
		display_pain(limb.owner, "The pain fades, my face feels normal again!")
		return

	var/oldname = limb.owner.real_name
	limb.owner.real_name = operation_args[OPERATION_NEW_NAME]

	display_results(
		surgeon,
		limb.owner,
		span_notice("You alter [oldname]'s appearance completely, [limb.owner.p_they()] is now [operation_args[OPERATION_NEW_NAME]]."),
		span_notice("[surgeon] alters [oldname]'s appearance completely, [limb.owner.p_they()] is now [operation_args[OPERATION_NEW_NAME]]!"),
		span_notice("[surgeon] finishes the operation on [limb.owner ? "[limb.owner]'s face." : limb]."),
	)
	display_pain(limb.owner, "The pain fades, my face feels new and unfamiliar!")

/datum/surgery_operation/limb/plastic_surgery/on_failure(obj/item/bodypart/limb, mob/living/surgeon, obj/item/tool, list/operation_args)
	display_results(
		surgeon,
		limb.owner,
		span_warning("I screw up, leaving [limb.owner]'s appearance disfigured!"),
		span_warning("[surgeon] screws up, disfiguring [limb.owner]'s appearance!"),
		span_notice("[surgeon] finishes the operation on [limb.owner]'s face.")
	)
	display_pain(limb.owner, "My face feels horribly scarred and deformed!")

	limb.add_wound(/datum/wound/facial/disfigurement)
	limb.owner.emote("scream")

#undef OPERATION_NEW_NAME
