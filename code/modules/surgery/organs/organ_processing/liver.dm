#define HAS_SILENT_TOXIN 0  //don't provide a feedback message if this is the only toxin present
#define HAS_NO_TOXIN     1
#define HAS_PAINFUL_TOXIN 2

/datum/organ_process/liver
	slot = ORGAN_SLOT_LIVER
	processes_dead = TRUE

/datum/organ_process/liver/needs_process(mob/living/carbon/owner)
	return (..() && !HAS_TRAIT(owner, TRAIT_NOMETABOLISM))

/datum/organ_process/liver/handle_process(mob/living/carbon/owner, delta_time, times_fired)
	var/liver_efficiency = owner.getorganslotefficiency(ORGAN_SLOT_LIVER)
	if(owner.stat == DEAD)
		for(var/reagent in owner.reagents.reagent_list)
			var/datum/reagent/R = reagent
			R.on_mob_dead(owner, delta_time)
		return TRUE

	var/obj/item/organ/liver/liver = owner.getorganslot(ORGAN_SLOT_LIVER)
	if(!liver)
		return

	var/provide_pain_message = HAS_NO_TOXIN

	if(liver.filterToxins && !HAS_TRAIT(owner, TRAIT_TOXINLOVER))
		var/obj/belly = owner.getorganslot(ORGAN_SLOT_STOMACH)
		for(var/datum/reagent/toxin/T in owner.reagents.reagent_list)
			var/thisamount = owner.reagents.get_reagent_amount(T.type)
			if(belly)
				thisamount += belly.reagents.get_reagent_amount(T.type)
			if(thisamount && thisamount <= liver.toxTolerance * (liver_efficiency * 0.01))
				owner.reagents.remove_reagent(T.type, 1 * delta_time)
			else
				liver.applyOrganDamage(thisamount * liver.toxLethality * delta_time)
				if(provide_pain_message != HAS_PAINFUL_TOXIN)
					provide_pain_message = T.silent_toxin ? HAS_SILENT_TOXIN : HAS_PAINFUL_TOXIN

	owner.reagents.metabolize(owner, can_overdose = TRUE, efficiency = liver_efficiency)

	if(provide_pain_message == HAS_PAINFUL_TOXIN && liver.damage > 10 && DT_PROB(liver.damage / 3, delta_time))
		to_chat(owner, "<span class='warning'>I feel a dull pain in my abdomen.</span>")

	if(liver.damage > liver.maxHealth)
		liver.setOrganDamage(liver.maxHealth)

	return TRUE

#undef HAS_SILENT_TOXIN
#undef HAS_NO_TOXIN
#undef HAS_PAINFUL_TOXIN
