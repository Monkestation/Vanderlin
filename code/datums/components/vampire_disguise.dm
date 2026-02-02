/datum/component/vampire_disguise
	/// Current disguise state
	var/disguised = FALSE
	/// Cached appearance for disguise
	var/cache_skin
	var/cache_eyes
	var/cache_eye_secondary
	var/cache_hetero
	var/cache_hair
	/// Transform cooldown
	COOLDOWN_DECLARE(transform_cooldown)
	/// Bloodpool cost per life tick while disguised
	var/disguise_upkeep = 0
	/// Minimum bloodpool required to maintain disguise
	var/min_bloodpool = 50

/datum/component/vampire_disguise/Initialize(upkeep = 0, min_blood = 50)
	if(!ishuman(parent))
		return COMPONENT_INCOMPATIBLE

	disguise_upkeep = upkeep
	min_bloodpool = min_blood

	var/mob/living/carbon/human/H = parent
	cache_original_appearance(H)

	RegisterSignal(parent, COMSIG_HUMAN_LIFE, PROC_REF(handle_disguise_upkeep))
	RegisterSignal(parent, COMSIG_DISGUISE_STATUS, PROC_REF(disguise_status))

/datum/component/vampire_disguise/proc/cache_original_appearance(mob/living/carbon/human/H)
	cache_skin = H.skin_tone
	var/obj/item/organ/eyes/eyes = H.getorganslot(ORGAN_SLOT_EYES)
	cache_eyes = eyes.eye_color
	cache_eye_secondary = eyes.second_color
	cache_hetero = FALSE

	cache_hair = H.get_hair_color()

/datum/component/vampire_disguise/proc/handle_disguise_upkeep(mob/living/carbon/human/source)
	SIGNAL_HANDLER

	if(!disguised)
		return

	// Check if we have enough blood to maintain disguise
	if(source.bloodpool < disguise_upkeep)
		to_chat(source, span_warning("My disguise fails as I run out of blood!"))
		remove_disguise(source)
		return

	// Drain bloodpool
	source.adjust_bloodpool(-disguise_upkeep)

/datum/component/vampire_disguise/proc/apply_disguise(mob/living/carbon/human/H)
	if(disguised)
		return FALSE

	if(!COOLDOWN_FINISHED(src, transform_cooldown))
		to_chat(H, span_warning("I must wait before transforming again."))
		return FALSE

	if(H.bloodpool < min_bloodpool)
		to_chat(H, span_warning("I don't have enough blood to maintain a disguise."))
		return FALSE

	disguised = TRUE
	COOLDOWN_START(src, transform_cooldown, 5 SECONDS)

	// Restore human appearance
	H.skin_tone = cache_skin
	H.set_hair_color(cache_hair, FALSE)
	H.set_facial_hair_color(cache_hair, FALSE)

	var/obj/item/organ/eyes/eyes = H.getorganslot(ORGAN_SLOT_EYES)
	if(eyes)
		H.set_eye_color(cache_eye_secondary, cache_eye_secondary, FALSE)


	H.update_organ_colors()
	H.update_body()
	H.update_body_parts(redraw = TRUE)

	to_chat(H, span_notice("I assume a mortal guise."))
	return TRUE

/datum/component/vampire_disguise/proc/remove_disguise(mob/living/carbon/human/H)
	if(!disguised)
		return FALSE

	disguised = FALSE
	COOLDOWN_START(src, transform_cooldown, 5 SECONDS)

	// Apply vampire appearance - get it from clan
	if(H.clan && istype(H.clan, /datum/clan))
		var/datum/clan/vclan = H.clan
		vclan.apply_vampire_look(H)

	to_chat(H, span_warning("My true nature is revealed!"))
	return TRUE

/datum/component/vampire_disguise/proc/force_undisguise(mob/living/carbon/human/H)
	if(!disguised)
		return FALSE

	remove_disguise(H)
	to_chat(H, span_danger("My disguise is forcibly broken!"))
	return TRUE

/datum/component/vampire_disguise/proc/disguise_status()
	return disguised
