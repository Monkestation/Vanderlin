/datum/objective/personal/ravox_duel
	name = "Honor Duels"
	category = "Ravox's Chosen"
	triumph_count = 3
	immediate_effects = list("Gained an ability to challenge others")
	rewards = list("3 Triumphs", "Ravox grows stronger", "Ravox blesses you (+1 Strength)")
	var/duels_won = 0
	var/duels_required = 1

/datum/objective/personal/ravox_duel/on_creation()
	. = ..()
	if(owner?.current)
		var/datum/action/cooldown/spell/ravox_challenge/challenge_spell = new(src)
		challenge_spell.Grant(owner.current)
	update_explanation_text()

/datum/objective/personal/ravox_duel/proc/on_duel_won()
	duels_won++
	if(duels_won >= duels_required && !completed)
		complete_objective()

/datum/objective/personal/ravox_duel/complete_objective()
	. = ..()
	to_chat(owner.current, span_greentext("You have proven your worth in combat! Ravox is pleased!"))
	adjust_storyteller_influence(RAVOX, 20)

/datum/objective/personal/ravox_duel/reward_owner()
	. = ..()
	owner.current.adjust_stat_modifier(STATMOD_RAVOX_BLESSING, STATKEY_STR, 1)

/datum/objective/personal/ravox_duel/update_explanation_text()
	explanation_text = "Win [duels_required] duel\s with honor against other warriors to prove your might!"

/datum/duel
	var/ongoing = TRUE
	var/datum/weakref/challenger
	var/datum/weakref/challenged
	var/datum/weakref/objective

/datum/duel/New(mob/living/carbon/human/challenger, mob/living/carbon/human/challenged, datum/objective/personal/ravox_duel/listener)
	src.challenger = WEAKREF(challenger)
	src.challenged = WEAKREF(challenged)
	objective = WEAKREF(listener)

	addtimer(CALLBACK(src, PROC_REF(end_duel)), 8 MINUTES, TIMER_DELETE_ME)
	addtimer(CALLBACK(src, PROC_REF(check_duel)), 4 SECONDS, TIMER_UNIQUE|TIMER_OVERRIDE)

/datum/duel/Destroy(force, ...)
	challenger = null
	challenged = null
	return ..()

/datum/duel/proc/check_duel()
	if(QDELETED(src) || !ongoing)
		return
	var/mob/living/carbon/human/challenger_mob = challenger.resolve()
	var/mob/living/carbon/human/challenged_mob = challenged.resolve()
	if(QDELETED(challenger_mob) || QDELETED(challenged_mob))
		qdel(src)

	if(challenger_mob.surrendering || challenger_mob.incapacitated(IGNORE_GRAB))
		challenged_mob.visible_message(span_notice("[challenged_mob] defeats [challenger_mob] in the honor duel!"))
		finish_duel(challenger_mob, challenged_mob)
		return
	else if(challenged_mob.surrendering || challenged_mob.incapacitated(IGNORE_GRAB))
		challenger_mob.visible_message(span_notice("[challenger_mob] defeats [challenged_mob] in the honor duel!"))
		finish_duel(challenged_mob, challenger_mob)
		return

	addtimer(CALLBACK(src, PROC_REF(check_duel)), 4 SECONDS, TIMER_UNIQUE|TIMER_OVERRIDE)

/datum/duel/proc/end_duel()
	if(QDELETED(src) || !ongoing)
		return
	ongoing = FALSE
	var/mob/living/carbon/human/challenger_mob = challenger.resolve()
	if(challenger_mob)
		to_chat(challenger_mob, span_notice("The duel has gone on too long and is declared a draw!"))
	var/mob/living/carbon/human/challenged_mob = challenged.resolve()
	if(challenged_mob)
		to_chat(challenged_mob, span_notice("The duel has gone on too long and is declared a draw!"))

	qdel(src)

/datum/duel/proc/finish_duel(mob/living/loser, mob/living/winner)
	if(QDELETED(src) || !ongoing)
		return
	ongoing = FALSE

	to_chat(loser, span_red("You have lost the duel of honor!"))
	to_chat(winner, span_green("You have won the duel of honor!"))

	if(objective)
		var/datum/objective/personal/ravox_duel/ravox = objective.resolve()
		if(ravox?.owner == winner.mind)
			ravox.on_duel_won()

	qdel(src)
