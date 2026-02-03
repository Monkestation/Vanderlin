/datum/surgery/lux_restore
	name = "Restore Lux"

	steps = list(
		/datum/surgery_step/incise,
		/datum/surgery_step/clamp,
		/datum/surgery_step/retract,
		/datum/surgery_step/bestow_lux,
		/datum/surgery_step/cauterize
	)

	possible_locs = list(BODY_ZONE_CHEST)

	skill_min = SKILL_LEVEL_EXPERT
	skill_median = SKILL_LEVEL_MASTER

/datum/surgery_step/bestow_lux
	name = "Infuse Lux"

	implements = list(
		/obj/item/reagent_containers/lux = 100,
		/obj/item/reagent_containers/lux_tainted = 50,
	)

	time = 10 SECONDS

	preop_sound = 'sound/surgery/organ2.ogg'
	success_sound = 'sound/surgery/organ1.ogg'

	var/tainted_lux = FALSE
	var/tainted_mob = FALSE

/datum/surgery_step/bestow_lux/preop(mob/user, mob/living/target, target_zone, obj/item/tool, datum/intent/intent)
	if(target.get_lux_tainted_status())
		tainted_mob = TRUE

	if(istype(tool, /obj/item/reagent_containers/lux_tainted))
		tainted_lux = TRUE

	if(tainted_mob && !tainted_lux)
		to_chat(user, "They can only receive tainted lux!")
		return SURGERY_STEP_FAIL

	display_results(
		user,
		target,
		span_notice("I begin to implant [tool] into [target]..."),
		span_notice("[user] begins to work [tool] into [target]'s heart."),
		span_notice("[user] begins to work something into [target]'s innards."),
	)

	return TRUE

/datum/surgery_step/bestow_lux/success(mob/user, mob/living/target, target_zone, obj/item/tool, datum/intent/intent)
	if(tainted_lux && !tainted_mob)
		display_results(
			user,
			target,
			span_danger("You succeed in infusing [tool] into [target]'s heart, but their body struggles under its power!"),
			span_danger("[target]'s heart writhes with dark, twisted energy... the [tool] has left its mark on them."),
		)
		target.apply_status_effect(/datum/status_effect/debuff/corrupted_by_tainted_lux)

		if(target.get_lux_status() == LUX_NO_LUX)
			target.apply_status_effect(/datum/status_effect/debuff/received_tainted_lux)
		else
			target.apply_status_effect(/datum/status_effect/debuff/tainted_lux)

	display_results(
		user,
		target,
		span_notice("You succeed in integrating [tool] into [target]'s heart."),
		span_notice("[user] works the [tool] into [target]'s heart."),
		span_notice("[user] works something into [target]'s innards."),
	)

	qdel(tool)

	target.emote("breathgasp")
	target.adjust_jitter(100 SECONDS)

	if(target.get_lux_status() == LUX_NO_LUX)
		target.apply_status_effect(/datum/status_effect/buff/received_lux)
	else
		target.remove_status_effect(/datum/status_effect/debuff/lux_drained)
		target.remove_status_effect(/datum/status_effect/debuff/flaw_lux_taken)

	return TRUE

/datum/surgery_step/bestow_lux/failure(mob/user, mob/living/target, target_zone, obj/item/tool, datum/intent/intent, success_prob)
	display_results(
		user,
		target,
		span_danger("I work the [tool] into [target]'s heart, but nothing happens!"),
		span_danger("[user] works [tool] into [target]'s heart. But nothing happens!"),
		span_danger("[user] works something into [target]'s innards. But nothing happens!"),
	)

	return FALSE
