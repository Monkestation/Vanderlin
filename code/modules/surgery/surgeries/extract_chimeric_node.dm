/datum/surgery/extract_chimeric_node
	name = "Extract Humors"
	category = "Pestran"
	heretical = TRUE

	steps = list(
		/datum/surgery_step/incise,
		/datum/surgery_step/clamp,
		/datum/surgery_step/retract,
		/datum/surgery_step/saw,
		/datum/surgery_step/extract_chimeric_node,
		/datum/surgery_step/cauterize
	)
	possible_locs = list(BODY_ZONE_CHEST)

	target_mobtypes = list(/mob/living/carbon/human, /mob/living/simple_animal)

/datum/surgery_step/extract_chimeric_node
	name = "Extract Humors"

	implements = list(
		TOOL_SCALPEL = 80,
		TOOL_SHARP = 60,
		/obj/item/kitchen/spoon = 40
	)

	time = 10 SECONDS

	preop_sound = 'sound/surgery/organ2.ogg'
	success_sound = 'sound/surgery/organ1.ogg'

/datum/surgery_step/extract_chimeric_node/preop(mob/user, mob/living/target, target_zone, obj/item/tool, datum/intent/intent)
	if(HAS_TRAIT(target, TRAIT_NODE_EXTRACTED))
		to_chat(user, span_warning("[target] has no humors to extract!"))
		return SURGERY_STEP_FAIL

	if(!istype(target.buckled, /obj/structure/meathook))
		to_chat(user, span_warning("[target] must be secured to a meathook for this procedure!"))
		return SURGERY_STEP_FAIL

	display_results(
		user,
		target,
		span_notice("I begin to carefully extract chimeric tissue from [target]'s organs..."),
		span_warning("[user] begins to chimeric tissue from [target]'s innards."),
		span_warning("[user] begins to extract something from [target]'s innards."),
	)

/datum/surgery_step/extract_chimeric_node/success(mob/user, mob/living/target, target_zone, obj/item/tool, datum/intent/intent)
	target.emote("painscream")

	display_results(
		user,
		target,
		span_notice("You successfully extract chimeric tissue from [target], forming it into a node."),
		span_warning("[user] extracts chimeric tissue from [target]'s body."),
		span_warning("[user] extracts something grotesque from [target]'s body."),
	)

	var/amount = rand(1, 3)
	for(var/i = 1 to amount)
		target.create_chimeric_node()

	target.adjustBruteLoss(30)
	target.adjustOxyLoss(30)
	target.emote("gasp", forced = TRUE)

	ADD_TRAIT(target, TRAIT_NODE_EXTRACTED, "surgery")

	record_featured_stat(FEATURED_STATS_CRIMINALS, user)

	return TRUE

/datum/surgery_step/extract_chimeric_node/failure(mob/user, mob/living/target, target_zone, obj/item/tool, datum/intent/intent)
	display_results(
		user,
		target,
		span_warning("I botch the extraction, causing severe damage!"),
		span_warning("[user] makes a mistake during the extraction!"),
		span_warning("[user] makes a mistake!")
	)

	target.adjustBruteLoss(50)
	target.emote("painscream", forced = TRUE)

	return FALSE
