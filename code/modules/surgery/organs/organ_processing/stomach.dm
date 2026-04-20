/datum/organ_process/stomach
	slot = ORGAN_SLOT_STOMACH
	mob_types = list(/mob/living/carbon/human)

/datum/organ_process/stomach/needs_process(mob/living/carbon/owner)
	return (..() && !(NOSTOMACH in owner.dna.species.species_traits))

/datum/organ_process/stomach/handle_process(mob/living/carbon/human/owner, delta_time, times_fired)
	if(!HAS_TRAIT(owner, TRAIT_NOHUNGER))
		handle_nutrition(owner, delta_time, times_fired)
	handle_digestion(owner, delta_time, times_fired)
	owner.dna?.species?.handle_digestion(owner) //for halfling bs
	handle_disgust(owner, delta_time, times_fired)
	return TRUE

/datum/organ_process/stomach/proc/handle_nutrition(mob/living/carbon/human/owner, delta_time, times_fired)
	var/stomach_efficiency = owner.getorganslotefficiency(ORGAN_SLOT_STOMACH)
	//fat fuck friday
	if(HAS_TRAIT_FROM(owner, TRAIT_FAT, OBESITY))
		if(owner.overeatduration < 200 SECONDS)
			to_chat(owner, span_notice("I feel fit again!"))
			REMOVE_TRAIT(owner, TRAIT_FAT, OBESITY)
			owner.remove_movespeed_modifier("obesity")
	else
		if(owner.overeatduration >= 200 SECONDS)
			to_chat(owner, span_danger("I suddenly feel blubbery!"))
			ADD_TRAIT(owner, TRAIT_FAT, OBESITY)
			owner.add_movespeed_modifier("obesity", multiplicative_slowdown = 1.5)

	// nutrition decrease and satiety
	if(owner.nutrition > 0)
		// THEY HUNGER
		var/hunger_rate = owner.total_nutriment_req
		hunger_rate *= optimal_threshold/max(stomach_efficiency, 25)
		// Whether we cap off our satiety or move it towards 0
		if(owner.satiety > MAX_SATIETY)
			owner.satiety = MAX_SATIETY
		else if(owner.satiety > 0)
			owner.satiety -= (0.5 * delta_time)
		else if(owner.satiety < -MAX_SATIETY)
			owner.satiety = -MAX_SATIETY
		else if(owner.satiety < 0)
			owner.satiety += (0.5 * delta_time)
			hunger_rate *= 2
		hunger_rate *= owner.physiology.hunger_mod
		owner.adjust_nutrition(-hunger_rate * (0.5 * delta_time))
	if(owner.hydration > 0)
		var/thirst_rate = owner.total_hydration_req
		thirst_rate *= optimal_threshold/max(stomach_efficiency, 25)
		owner.adjust_hydration(-thirst_rate * (0.5 * delta_time))

	if(owner.nutrition > NUTRITION_LEVEL_FULL)
		if(owner.overeatduration < 20 MINUTES)
			owner.overeatduration = min(owner.overeatduration + (1 SECONDS * delta_time), 20 MINUTES)
	else if(owner.overeatduration > 0)
		owner.overeatduration = max(owner.overeatduration - (2 SECONDS * delta_time), 0)

	switch(owner.nutrition)
		if(NUTRITION_LEVEL_FED to INFINITY)
			owner.remove_status_effect(/datum/status_effect/debuff/hungryt1)
			owner.remove_status_effect(/datum/status_effect/debuff/hungryt2)
			owner.remove_status_effect(/datum/status_effect/debuff/hungryt3)
			owner.remove_status_effect(/datum/status_effect/debuff/hungryt4)
		if(NUTRITION_LEVEL_HUNGRY to NUTRITION_LEVEL_FED)
			owner.apply_status_effect(/datum/status_effect/debuff/hungryt1)
			owner.remove_status_effect(/datum/status_effect/debuff/hungryt2)
			owner.remove_status_effect(/datum/status_effect/debuff/hungryt3)
			owner.remove_status_effect(/datum/status_effect/debuff/hungryt4)
		if(NUTRITION_LEVEL_STARVING to NUTRITION_LEVEL_HUNGRY)
			owner.apply_status_effect(/datum/status_effect/debuff/hungryt2)
			owner.remove_status_effect(/datum/status_effect/debuff/hungryt1)
			owner.remove_status_effect(/datum/status_effect/debuff/hungryt3)
			owner.remove_status_effect(/datum/status_effect/debuff/hungryt4)
		if(0 to NUTRITION_LEVEL_STARVING)
			owner.apply_status_effect(/datum/status_effect/debuff/hungryt3)
			owner.remove_status_effect(/datum/status_effect/debuff/hungryt1)
			owner.remove_status_effect(/datum/status_effect/debuff/hungryt2)
			if(CONFIG_GET(flag/starvation_death))
				owner.apply_status_effect(/datum/status_effect/debuff/hungryt4)
			if(DT_PROB(3, delta_time))
				playsound(owner, pick('sound/vo/hungry1.ogg','sound/vo/hungry2.ogg','sound/vo/hungry3.ogg'), 100, TRUE, -1)

	switch(owner.hydration)
		if(HYDRATION_LEVEL_SMALLTHIRST to INFINITY)
			owner.remove_status_effect(/datum/status_effect/debuff/thirstyt1)
			owner.remove_status_effect(/datum/status_effect/debuff/thirstyt2)
			owner.remove_status_effect(/datum/status_effect/debuff/thirstyt3)
			owner.remove_status_effect(/datum/status_effect/debuff/thirstyt4)
		if(HYDRATION_LEVEL_THIRSTY to HYDRATION_LEVEL_SMALLTHIRST)
			owner.apply_status_effect(/datum/status_effect/debuff/thirstyt1)
			owner.remove_status_effect(/datum/status_effect/debuff/thirstyt2)
			owner.remove_status_effect(/datum/status_effect/debuff/thirstyt3)
			owner.remove_status_effect(/datum/status_effect/debuff/thirstyt4)
		if(HYDRATION_LEVEL_DEHYDRATED to HYDRATION_LEVEL_THIRSTY)
			owner.apply_status_effect(/datum/status_effect/debuff/thirstyt2)
			owner.remove_status_effect(/datum/status_effect/debuff/thirstyt1)
			owner.remove_status_effect(/datum/status_effect/debuff/thirstyt3)
			owner.remove_status_effect(/datum/status_effect/debuff/thirstyt4)
		if(0 to HYDRATION_LEVEL_DEHYDRATED)
			owner.apply_status_effect(/datum/status_effect/debuff/thirstyt3)
			owner.remove_status_effect(/datum/status_effect/debuff/thirstyt1)
			owner.remove_status_effect(/datum/status_effect/debuff/thirstyt2)
			if(CONFIG_GET(flag/dehydration_death))
				owner.apply_status_effect(/datum/status_effect/debuff/thirstyt4)

/datum/organ_process/stomach/proc/handle_digestion(mob/living/carbon/human/owner, delta_time, times_fired)
	var/stomachal_efficiency = owner.getorganslotefficiency(ORGAN_SLOT_STOMACH)
	var/list/stomachs = owner.getorganslotlist(ORGAN_SLOT_STOMACH)

	for(var/obj/item/organ/stomach/stomach as anything in stomachs)
		for(var/chunk in stomach.reagents.reagent_list)
			var/datum/reagent/bit = chunk

			if(bit.metabolization_rate <= 0)
				continue

			var/amount_min = max(bit.metabolization_rate, STOMACH_METABOLISM_CONSTANT)
			var/amount_max = bit.volume
			var/this_stomach_efficiency = stomach.get_slot_efficiency(ORGAN_SLOT_STOMACH)
			var/amount = min((round(stomach.metabolism_efficiency * (this_stomach_efficiency/optimal_threshold) * amount_max, 0.05) + amount_min) * delta_time, amount_max)
			if(amount <= 0)
				continue

			stomach.reagents.trans_id_to(owner, bit.type, amount=amount)

	for(var/obj/item/organ/stomach/stomach as anything in stomachs)
		if(!stomach.is_bruised() && !stomach.is_failing())
			continue

		var/datum/reagent/nutri = locate(/datum/reagent/consumable/nutriment) in stomach.reagents.reagent_list
		if(!nutri)
			continue

		if(stomach.damage < stomach.high_threshold)
			if(DT_PROB(0.025 * stomachal_efficiency * (nutri.volume ** 2), delta_time))
				owner.vomit(stomachal_efficiency)
				to_chat(owner, span_warning("My [stomach.name] reels in pain as you're incapable of holding down all that food!"))
				return
		else
			if(DT_PROB(0.1 * stomachal_efficiency * (nutri.volume ** 2), delta_time))
				owner.vomit(stomachal_efficiency)
				to_chat(owner, span_warning("My [stomach.name] reels in pain as you're incapable of holding down all that food!"))
				return

/datum/organ_process/stomach/proc/handle_disgust(mob/living/carbon/human/owner, delta_time, times_fired)
	var/combined_disgust_metabolism = 0
	for(var/thing in owner.getorganslotlist(ORGAN_SLOT_STOMACH))
		var/obj/item/organ/stomach/stomach = thing
		combined_disgust_metabolism += stomach.disgust_metabolism

	if(owner.disgust)
		var/pukeprob = 5 + (0.05 * owner.disgust)
		if(owner.disgust >= DISGUST_LEVEL_GROSS)
			if(DT_PROB(10, delta_time))
				owner.stuttering += 1
				owner.adjust_confusion(4 SECONDS)
			if(DT_PROB(10, delta_time) && !owner.stat)
				to_chat(owner, span_warning("I feel kind of iffy..."))
			owner.adjust_jitter(-6 SECONDS)
		if(owner.disgust >= DISGUST_LEVEL_VERYGROSS)
			if(DT_PROB(pukeprob, delta_time))
				owner.adjust_confusion(5 SECONDS)
				owner.stuttering += 1
				owner.vomit(10, 0, 1, 0, 1, 0)
			owner.set_dizzy(10 SECONDS)
		if(owner.disgust >= DISGUST_LEVEL_DISGUSTED)
			if(DT_PROB(25, delta_time))
				owner.set_eye_blur_if_lower(6 SECONDS)
		owner.adjust_disgust(-0.5 * combined_disgust_metabolism * delta_time)

	switch(owner.disgust)
		if(0 to DISGUST_LEVEL_GROSS)
			owner.clear_alert("disgust")
			owner.remove_stress(/datum/stress_event/disgust)
		if(DISGUST_LEVEL_GROSS to DISGUST_LEVEL_VERYGROSS)
			owner.throw_alert("disgust", /atom/movable/screen/alert/gross)
			owner.add_stress(/datum/stress_event/gross)
		if(DISGUST_LEVEL_VERYGROSS to DISGUST_LEVEL_DISGUSTED)
			owner.throw_alert("disgust", /atom/movable/screen/alert/verygross)
			owner.add_stress(/datum/stress_event/verygross)
		if(DISGUST_LEVEL_DISGUSTED to INFINITY)
			owner.throw_alert("disgust", /atom/movable/screen/alert/disgusted)
			owner.add_stress(/datum/stress_event/disgusted)
