/datum/surgery/revival
	name = "Revive"
	category = "Pestran"
	steps = list(
		/datum/surgery_step/incise,
		/datum/surgery_step/clamp,
		/datum/surgery_step/retract,
		/datum/surgery_step/saw,
		/datum/surgery_step/infuse_lux,
		/datum/surgery_step/cauterize,
	)
	possible_locs = list(BODY_ZONE_CHEST)
	target_mobtypes = list(/mob/living/carbon/human, /mob/living/carbon/monkey)

	skill_min = SKILL_LEVEL_EXPERT
	skill_median = SKILL_LEVEL_MASTER

/datum/surgery/revival/can_start(mob/user, mob/living/patient, obj/item/tool, feedback = TRUE)
	. = ..()
	if(!.)
		return

	if(patient.stat != DEAD)
		if(feedback)
			patient.balloon_alert(user, "patient is still alive")
		return FALSE

	if(patient.mob_biotypes & MOB_UNDEAD)
		if(feedback)
			patient.balloon_alert(user, "patient defies death")
		return FALSE

	if(HAS_TRAIT(patient, TRAIT_NECRA_CURSE))
		if(feedback)
			patient.balloon_alert(user, "paitent's soul is trapped")
		return FALSE

/datum/surgery_step/infuse_lux
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

/datum/surgery_step/infuse_lux/preop(mob/user, mob/living/target, target_zone, obj/item/tool, datum/intent/intent)
	if(istype(tool, /obj/item/reagent_containers/lux_tainted))
		tainted_lux = TRUE

	if(target.get_lux_tainted_status())
		tainted_mob = TRUE

	if(tainted_mob && !tainted_lux)
		to_chat(user, "They can only receive tainted lux!")
		return

	display_results(user, target,
		span_notice("I begin to infuse [target]'s heart with [tool.name]."),
		span_notice("[user] begins to work [tool.name] into [target]'s heart."),
		span_notice("[user] begins to something into [target]'s innards..."),
	)

/datum/surgery_step/infuse_lux/success(mob/user, mob/living/target, target_zone, obj/item/tool, datum/surgery/surgery, default_display_results = TRUE)
	if(!target.revive(excess_healing = 50))
		return failure(user, target, target_zone, tool, surgery)

	if(tainted_lux && !tainted_mob)
		display_results(user, target,
			span_danger("I succeed in restarting [target]'s heart, but the [tool] has corrupted their being!"),
			span_danger("[target]'s heart is clouded with a dark, sinister energy from the [tool]."),
		)
		target.apply_status_effect(/datum/status_effect/debuff/corrupted_by_tainted_lux)
	else
		display_results(user, target,
			span_notice("I succeed in restarting [target]'s heart with the infusion of [tool]."),
			span_notice("[user] works [tool] into [target]'s heart."),
			span_notice("[user] works something into [target]'s innards."),
		)

	qdel(tool)

	if(target.health > HALFWAYCRITDEATH)
		target.adjustOxyLoss(target.health - HALFWAYCRITDEATH)

	target.reagents.add_reagent(/datum/reagent/medicine/atropine, 3)
	target.grab_ghost(force = TRUE, grab_spirit = TRUE) // even suicides
	target.visible_message(span_notice("[target] is dragged back from Necra's hold!"), span_green("I awake from the void."))

	target.remove_status_effect(/datum/status_effect/debuff/lux_drained)
	target.remove_status_effect(/datum/status_effect/debuff/flaw_lux_taken)
	record_round_statistic(STATS_LUX_REVIVALS)

	return TRUE

/datum/surgery_step/infuse_lux/failure(mob/user, mob/living/target, target_zone, obj/item/tool, datum/surgery/surgery, fail_prob)
	display_results(
		user,
		target,
		span_danger("I work the [tool] into [target]'s heart, but nothing happens!"),
		span_danger("[user] works [tool] into [target]'s heart. But nothing happens!"),
		span_danger("[user] works something into [target]'s innards. But nothing happens!"),
	)

	return FALSE
