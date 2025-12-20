/datum/objective/personal/inhumen_scorn
	name = "Scorn Inhumen"
	category = "Astrata's Chosen"
	triumph_count = 2
	rewards = list("2 Triumphs", "Astrata grows stronger", "Ability to silence inhumen")
	var/spits_done = 0
	var/spits_required = 1

/datum/objective/personal/inhumen_scorn/on_creation()
	. = ..()
	if(owner?.current)
		RegisterSignal(owner.current, COMSIG_SPAT_ON, PROC_REF(on_spit))
	update_explanation_text()

/datum/objective/personal/inhumen_scorn/Destroy()
	if(owner?.current)
		UnregisterSignal(owner.current, COMSIG_SPAT_ON)
	return ..()

/datum/objective/personal/inhumen_scorn/proc/on_spit(datum/source, mob/living/carbon/human/target)
	SIGNAL_HANDLER
	if(completed || !istype(target) || target.stat == DEAD || (target.dna?.species.id in RACES_PLAYER_NONHERETICAL))
		return

	spits_done++

	if(spits_done < spits_required)
		to_chat(owner.current, span_notice("Inhumen scorned! Scorn [spits_required - spits_done] more to complete the objective!"))
	else
		complete_objective()

/datum/objective/personal/inhumen_scorn/complete_objective()
	. = ..()
	to_chat(owner.current, span_greentext("You have scorned enough inhumen and completed Astrata's objective!"))
	adjust_storyteller_influence(ASTRATA, 20)
	UnregisterSignal(owner.current, COMSIG_SPAT_ON)

/datum/objective/personal/inhumen_scorn/reward_owner()
	. = ..()
	owner.current.add_spell(/datum/action/cooldown/spell/silence_inhumen, source = src)

/datum/objective/personal/inhumen_scorn/update_explanation_text()
	explanation_text = "Spit on [spits_required] inhumen to gain Astrata's approval!"
