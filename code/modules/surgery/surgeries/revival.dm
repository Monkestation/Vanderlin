/datum/surgery/revival
	name = "Revive"
	category = "Pestran"
	steps = list(
		/datum/surgery_step/incise,
		/datum/surgery_step/clamp,
		/datum/surgery_step/retract,
		/datum/surgery_step/saw,
		/datum/surgery_step/infuse_lux,
		/datum/surgery_step/cauterize
	)
	target_mobtypes = list(/mob/living/carbon/human, /mob/living/carbon/monkey)
	possible_locs = list(BODY_ZONE_CHEST)

/datum/surgery_step/infuse_lux
	name = "Infuse Lux"
	implements = list(
		/obj/item/reagent_containers/lux = 80,
		/obj/item/reagent_containers/lux_tainted = 50,
	)
	target_mobtypes = list(/mob/living/carbon/human, /mob/living/carbon/monkey)
	time = 10 SECONDS
	surgery_flags = SURGERY_BLOODY | SURGERY_INCISED | SURGERY_CLAMPED | SURGERY_RETRACTED | SURGERY_BROKEN
	skill_min = SKILL_LEVEL_EXPERT
	skill_median = SKILL_LEVEL_MASTER
	preop_sound = 'sound/surgery/organ2.ogg'
	success_sound = 'sound/surgery/organ1.ogg'
	var/tainted_lux = FALSE
	var/tainted_mob = FALSE

/datum/surgery_step/infuse_lux/validate_target(mob/user, mob/living/target, target_zone, datum/intent/intent)
	. = ..()
	if(target.stat < DEAD)
		to_chat(user, span_notice("They're not dead!"))
		return FALSE
	if(target.mob_biotypes & MOB_UNDEAD)
		to_chat(user, span_notice("You cannot infuse life into the undead! The rot must be cured first."))
		return FALSE
	if(HAS_TRAIT(target, TRAIT_NECRA_CURSE))
		to_chat(user, span_warning("Necra holds tight to this one."))
		return FALSE
	if(target.get_lux_tainted_status())
		tainted_mob = TRUE

/datum/surgery_step/infuse_lux/preop(mob/user, mob/living/target, target_zone, obj/item/tool, datum/intent/intent)
	if(istype(tool, /obj/item/reagent_containers/lux_tainted))
		tainted_lux = TRUE
	if(tainted_mob && !tainted_lux)
		to_chat(user, "They can only receive tainted lux!")
		return FALSE
	display_results(user, target,
		span_notice("I begin to infuse [target]'s heart with [tool.name]."),
		span_notice("[user] begins to work [tool.name] into [target]'s heart."),
		span_notice("[user] begins to something into [target]'s innards..."),
	)
	return TRUE

/datum/surgery_step/infuse_lux/success(mob/user, mob/living/target, target_zone, obj/item/tool, datum/intent/intent)
	if(!target.revive(full_heal = FALSE))
		to_chat(user, span_warning("Nothing happens."))
		return FALSE
	if(tainted_lux && !tainted_mob)
		if(prob(50))
			display_results(user, target,
				span_danger("You succeed in restarting [target]'s heart, but the [tool.name] has corrupted their being!"),
				span_danger("[target]'s heart is clouded with a dark, sinister energy from the [tool.name]."),
			)
			target.apply_status_effect(/datum/status_effect/debuff/corrupted_by_tainted_lux)
	display_results(user, target,
		span_notice("You succeed in restarting [target]'s heart with the infusion of [tool.name]."),
		span_notice("[user] works [tool.name] into [target]'s heart."),
		span_notice("[user] works something into [target]'s innards..."),
	)
	target.blood_volume += BLOOD_VOLUME_SURVIVE
	target.reagents.add_reagent(/datum/reagent/medicine/atropine, 3)
	var/mob/living/carbon/spirit/underworld_spirit = target.get_spirit()
	if(underworld_spirit)
		var/mob/dead/observer/ghost = underworld_spirit.ghostize()
		qdel(underworld_spirit)
		ghost.mind.transfer_to(target, TRUE)
	target.grab_ghost(force = TRUE) // even suicides
	target.emote("breathgasp")
	target.update_body()
	target.visible_message(span_notice("[target] is dragged back from Necra's hold!"), span_green("I awake from the void."))
	qdel(tool)
	target.remove_status_effect(/datum/status_effect/debuff/lux_drained)
	target.remove_status_effect(/datum/status_effect/debuff/flaw_lux_taken)
	record_round_statistic(STATS_LUX_REVIVALS)
	return TRUE

/datum/surgery_step/infuse_lux/failure(mob/user, mob/living/target, target_zone, obj/item/tool, datum/intent/intent, success_prob)
	display_results(user, target, span_warning("I screwed up!"),
		span_warning("[user] screws up!"),
		span_notice("[user] works the [tool.name] into [target]'s innards."), TRUE)
	return TRUE
