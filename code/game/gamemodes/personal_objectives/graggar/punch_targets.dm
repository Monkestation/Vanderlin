/datum/objective/personal/punch_women
	name = "Punch Women"
	category = "Graggar's Chosen"
	triumph_count = 2
	rewards = list("2 Triumphs", "Graggar grows stronger", "Graggar blesses you (+2 Strength)")
	var/punches_done = 0
	var/punches_required = 3

/datum/objective/personal/punch_women/on_creation()
	. = ..()
	if(owner?.current)
		RegisterSignal(owner.current, COMSIG_HEAD_PUNCHED, PROC_REF(on_head_punched))
	update_explanation_text()

/datum/objective/personal/punch_women/Destroy()
	if(owner?.current)
		UnregisterSignal(owner.current, COMSIG_HEAD_PUNCHED)
	return ..()

/datum/objective/personal/punch_women/proc/on_head_punched(datum/source, mob/living/carbon/human/woman)
	SIGNAL_HANDLER
	if(completed || !istype(woman) || woman.stat == DEAD ||  woman.gender != FEMALE)
		return

	punches_done++

	if(punches_done < punches_required)
		to_chat(owner.current, span_notice("Woman punched in the face! [punches_required - punches_done] more face punches needed."))

	if(punches_done >= punches_required)
		complete_objective()

/datum/objective/personal/punch_women/complete_objective()
	. = ..()
	to_chat(owner.current, span_greentext("You have dealt enough face punches to satisfy Graggar!"))
	adjust_storyteller_influence(GRAGGAR, 20)
	UnregisterSignal(owner.current, COMSIG_HEAD_PUNCHED)

/datum/objective/personal/punch_women/reward_owner()
	. = ..()
	owner.current.adjust_stat_modifier(STATMOD_GRAGGAR_BLESSING, STATKEY_STR, 2)

/datum/objective/personal/punch_women/update_explanation_text()
	explanation_text = "Punch women [punches_required] time\s in the face to demonstrate your devotion to Graggar!"
