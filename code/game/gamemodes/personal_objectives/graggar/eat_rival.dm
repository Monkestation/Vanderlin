/datum/objective/personal/eat_rival_heart
	name = "Eat Rival's Heart"
	category = "Graggar's Contestant"
	triumph_count = 4
	immediate_effects = list("You will feel stressed until the culling ends (+1 Stress)", "Gained an ability to rip hearts out of corpses", "Gained an ability to locate your rival's heart")
	rewards = list("4 Triumphs", "Graggar grows stronger", "Overwhelming Power (+3 to all stats)", "Pride of Victory (-2 Stress)")
	var/rival_name
	var/rival_job

/datum/objective/personal/eat_rival_heart/New(text, datum/mind/owner, rival_name, rival_job)
	. = ..()
	src.rival_name = rival_name
	src.rival_job = rival_job

/datum/objective/personal/eat_rival_heart/on_creation(rival_name, rival_job)
	. = ..()
	if(owner?.current)
		owner.current.add_stress(/datum/stress_event/graggar_culling_unfinished)
		owner.current.add_spell(/datum/action/cooldown/spell/extract_heart)
		owner.current.add_spell(/datum/action/cooldown/spell/undirected/seek_rival)
		RegisterSignal(owner.current, COMSIG_ORGAN_CONSUMED, PROC_REF(on_organ_consumed))
	update_explanation_text()

/datum/objective/personal/eat_rival_heart/Destroy()
	if(owner?.current)
		UnregisterSignal(owner.current, COMSIG_ORGAN_CONSUMED)
	return ..()

/datum/objective/personal/eat_rival_heart/proc/on_organ_consumed(datum/source, organ_type, obj/item/organ/organ_inside)
	SIGNAL_HANDLER
	if(completed || !organ_inside)
		return

	for(var/datum/culling_duel/D in GLOB.graggar_cullings)
		var/obj/item/organ/heart/d_challenger_heart = D.challenger_heart?.resolve()
		var/obj/item/organ/heart/d_target_heart = D.target_heart?.resolve()
		var/mob/living/carbon/human/challenger = D.challenger?.resolve()
		var/mob/living/carbon/human/target = D.target?.resolve()

		if(organ_inside == d_target_heart && owner.current == challenger)
			D.finish_culling(winner = owner.current, loser = target)
			complete_objective()
		else if(organ_inside == d_challenger_heart && owner.current == target)
			D.finish_culling(winner = owner.current, loser = challenger)
			complete_objective()

/datum/objective/personal/eat_rival_heart/complete_objective(escalatation_type = ESCALATION_INTERVENTION_ONLY)
	. = ..()
	to_chat(owner.current, span_greentext("You have proven your strength to Graggar by consuming your rival's heart! Your rival's power is now YOURS!"))
	adjust_storyteller_influence(GRAGGAR, 40)
	UnregisterSignal(owner.current, COMSIG_ORGAN_CONSUMED)

/datum/objective/personal/eat_rival_heart/reward_owner()
	. = ..()
	owner.current.add_stress(/datum/stress_event/graggar_culling_finished)
	owner.current.adjust_stat_modifier(STATMOD_GRAGGAR_CULLING, STATKEY_STR, 3)
	owner.current.adjust_stat_modifier(STATMOD_GRAGGAR_CULLING, STATKEY_END, 3)
	owner.current.adjust_stat_modifier(STATMOD_GRAGGAR_CULLING, STATKEY_CON, 3)
	owner.current.adjust_stat_modifier(STATMOD_GRAGGAR_CULLING, STATKEY_PER, 3)
	owner.current.adjust_stat_modifier(STATMOD_GRAGGAR_CULLING, STATKEY_INT, 3)
	owner.current.adjust_stat_modifier(STATMOD_GRAGGAR_CULLING, STATKEY_SPD, 3)
	owner.current.adjust_stat_modifier(STATMOD_GRAGGAR_CULLING, STATKEY_LCK, 3)
	owner.current.playsound_local(owner.current, 'sound/misc/gods/graggar_omen.ogg', 100)

/datum/objective/personal/eat_rival_heart/update_explanation_text()
	explanation_text = "Prove that you are not weak to Graggar by eating the heart of [rival_name], the [rival_job]! Eat them before they eat YOU!"
