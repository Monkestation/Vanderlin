/****************************************************
				BLOOD SYSTEM
****************************************************/

/mob/living/proc/suppress_bloodloss(amount)
	if(bleedsuppress)
		return
	else
		bleedsuppress = TRUE
		addtimer(CALLBACK(src, PROC_REF(resume_bleeding)), amount)

/mob/living/proc/resume_bleeding()
	bleedsuppress = 0
	if(stat != DEAD && bleed_rate)
		to_chat(src, span_warning("The blood soaks through my bandage."))

/mob/living/carbon/monkey/handle_blood()
	if(HAS_TRAIT(src, TRAIT_HUSK)) //cryosleep or husked people do not pump the blood.
		return
	//Blood regeneration if there is some space
	if(blood_volume < BLOOD_VOLUME_NORMAL && !bleed_rate)
		blood_volume += 0.1 // regenerate blood VERY slowly
		if((blood_volume < BLOOD_VOLUME_OKAY) && !HAS_TRAIT(src, TRAIT_BLOODLOSS_IMMUNE))
			adjustOxyLoss(round((BLOOD_VOLUME_NORMAL - blood_volume) * 0.02, 1))

/mob/living/proc/handle_blood()
	if(HAS_TRAIT(src, TRAIT_HUSK)) //cryosleep or husked people do not pump the blood.
		return
	blood_volume = min(blood_volume, BLOOD_VOLUME_MAXIMUM)

	bleed_rate = min(get_bleed_rate(), 10)

	if(blood_volume < BLOOD_VOLUME_NORMAL && blood_volume && !bleed_rate)
		blood_volume = min(blood_volume+0.5, BLOOD_VOLUME_MAXIMUM)

	//Effects of bloodloss
	if(!HAS_TRAIT(src, TRAIT_BLOODLOSS_IMMUNE) && stat != DEAD)
		switch(blood_volume)
			if(BLOOD_VOLUME_OKAY to BLOOD_VOLUME_SAFE)
				if(prob(3))
					to_chat(src, span_warning("I feel dizzy."))
				remove_status_effect(/datum/status_effect/debuff/bleedingworse)
				remove_status_effect(/datum/status_effect/debuff/bleedingworst)
				apply_status_effect(/datum/status_effect/debuff/bleeding)
			if(BLOOD_VOLUME_BAD to BLOOD_VOLUME_OKAY)
				if(prob(3))
					set_eye_blur_if_lower(12 SECONDS)
					to_chat(src, span_warning("I feel faint."))
				remove_status_effect(/datum/status_effect/debuff/bleeding)
				remove_status_effect(/datum/status_effect/debuff/bleedingworst)
				apply_status_effect(/datum/status_effect/debuff/bleedingworse)
			if(0 to BLOOD_VOLUME_BAD)
				if(prob(3))
					set_eye_blur_if_lower(12 SECONDS)
					to_chat(src, span_warning("I feel faint."))
				if(prob(3) && stat < UNCONSCIOUS)
					Unconscious(rand(5 SECONDS,10 SECONDS))
					to_chat(src, span_warning("I feel drained."))
				remove_status_effect(/datum/status_effect/debuff/bleedingworse)
				remove_status_effect(/datum/status_effect/debuff/bleeding)
				apply_status_effect(/datum/status_effect/debuff/bleedingworst)
		if(blood_volume <= BLOOD_VOLUME_BAD)
			adjustOxyLoss(2)
			if(blood_volume <= BLOOD_VOLUME_SURVIVE)
				adjustOxyLoss(4)
	else
		remove_status_effect(/datum/status_effect/debuff/bleeding)
		remove_status_effect(/datum/status_effect/debuff/bleedingworse)
		remove_status_effect(/datum/status_effect/debuff/bleedingworst)

	if(bleed_rate)
		bleed(bleed_rate)

	//if(blood_volume in -INFINITY to BLOOD_VOLUME_SURVIVE)
		//adjustOxyLoss(1.6)

// Takes care blood loss and regeneration
/mob/living/carbon/handle_blood()
	if(HAS_TRAIT(src, TRAIT_HUSK)) //cryosleep or husked people do not pump the blood.
		return
	var/bleed_rate = get_bleed_rate()
	var/sigreturn = SEND_SIGNAL(src, COMSIG_CARBON_ON_HANDLE_BLOOD, bleed_rate)
	if(sigreturn & HANDLE_BLOOD_HANDLED)
		return
	blood_volume = min(blood_volume, BLOOD_VOLUME_MAXIMUM)
	if(dna?.species)
		if(NOBLOOD in dna.species.species_traits)
			blood_volume = BLOOD_VOLUME_NORMAL
			remove_stress(/datum/stress_event/bleeding)
			remove_status_effect(/datum/status_effect/debuff/bleeding)
			remove_status_effect(/datum/status_effect/debuff/bleedingworse)
			remove_status_effect(/datum/status_effect/debuff/bleedingworst)
			REMOVE_TRAIT(src, TRAIT_KNOCKEDOUT, BLOODLOSS_TRAIT)
			return

	//Blood regeneration if there is some space
	if(!(sigreturn & HANDLE_BLOOD_NO_NUTRITION_DRAIN))
		if(blood_volume < BLOOD_VOLUME_NORMAL && blood_volume && !bleed_rate)
			blood_volume = min(BLOOD_VOLUME_NORMAL, blood_volume + 0.5)

	//Effects of bloodloss
	if(!(sigreturn & HANDLE_BLOOD_NO_EFFECTS))
		if(!HAS_TRAIT(src, TRAIT_BLOODLOSS_IMMUNE))
			switch(blood_volume)
				if(BLOOD_VOLUME_OKAY to BLOOD_VOLUME_SAFE)
					if(prob(3))
						to_chat(src, span_warning("I feel dizzy."))
					remove_status_effect(/datum/status_effect/debuff/bleedingworse)
					remove_status_effect(/datum/status_effect/debuff/bleedingworst)
					apply_status_effect(/datum/status_effect/debuff/bleeding)
				if(BLOOD_VOLUME_BAD to BLOOD_VOLUME_OKAY)
					if(prob(3))
						set_eye_blur_if_lower(6 SECONDS)
						to_chat(src, span_warning("I feel faint."))
					remove_status_effect(/datum/status_effect/debuff/bleeding)
					remove_status_effect(/datum/status_effect/debuff/bleedingworst)
					apply_status_effect(/datum/status_effect/debuff/bleedingworse)
				if(0 to BLOOD_VOLUME_BAD)
					if(prob(3))
						set_eye_blur_if_lower(12 SECONDS)
						to_chat(src, span_warning("I feel faint."))
					if(prob(3) && stat < UNCONSCIOUS)
						Unconscious(rand(5 SECONDS,10 SECONDS))
						to_chat(src, span_warning("I feel drained."))
					remove_status_effect(/datum/status_effect/debuff/bleedingworse)
					remove_status_effect(/datum/status_effect/debuff/bleeding)
					apply_status_effect(/datum/status_effect/debuff/bleedingworst)
			if(blood_volume <= BLOOD_VOLUME_BAD)
				adjustOxyLoss(2)
			if(blood_volume <= BLOOD_VOLUME_SURVIVE)
				adjustOxyLoss(4)
				ADD_TRAIT(src, TRAIT_KNOCKEDOUT, BLOODLOSS_TRAIT)
			else
				REMOVE_TRAIT(src, TRAIT_KNOCKEDOUT, BLOODLOSS_TRAIT)
		else
			remove_status_effect(/datum/status_effect/debuff/bleeding)
			remove_status_effect(/datum/status_effect/debuff/bleedingworse)
			remove_status_effect(/datum/status_effect/debuff/bleedingworst)
			REMOVE_TRAIT(src, TRAIT_KNOCKEDOUT, BLOODLOSS_TRAIT)

	//Bleeding out
	if(bleed_rate)
		for(var/obj/item/bodypart/bodypart as anything in bodyparts)
			bodypart.try_bandage_expire()
		bleed(bleed_rate)
		add_stress(/datum/stress_event/bleeding)
	else
		remove_stress(/datum/stress_event/bleeding)

/mob/living/proc/get_bleed_rate()
	var/bleed_rate = 0
	for(var/datum/wound/wound as anything in get_wounds())
		bleed_rate += wound.bleed_rate
	for(var/obj/item/embedded as anything in simple_embedded_objects)
		bleed_rate += embedded.embedding?.embedded_bloodloss
	return bleed_rate

/mob/living/carbon/get_bleed_rate()
	if(NOBLOOD in dna?.species?.species_traits)
		return 0
	var/bleed_rate = 0
	for(var/obj/item/bodypart/bodypart as anything in bodyparts)
		bleed_rate += bodypart.get_bleed_rate()
	return bleed_rate

/// How much slower we'll be bleeding for every CON point. 0.1 = 10% slower.
#define CONSTITUTION_BLEEDRATE_MOD 0.03

/// Makes a blood drop, leaking amt units of blood from the mob
/mob/living/proc/bleed(amt)
	if(!iscarbon(src) && !HAS_TRAIT(src, TRAIT_SIMPLE_WOUNDS))
		return
	if(blood_volume <= 0)
		return

	// For each CON above 10, we bleed slower.
	// Consequently, for each CON under 10 we bleed faster.
	var/con_modifier = 1
	var/our_con = STACON
	if(our_con != 10)
		con_modifier = our_con - 10

	amt -= amt * con_modifier * CONSTITUTION_BLEEDRATE_MOD

	blood_volume = max(blood_volume - amt, 0)

	if(client)
		record_featured_stat(FEATURED_STATS_BLEEDERS, src)
	record_round_statistic(STATS_BLOOD_SPILT, amt / 100)

	if(amt > 0.5)
		if(isturf(loc)) // Blood loss still happens in locker, floor stays clean
			add_drip_floor(get_turf(src), amt)

		if(body_position != LYING_DOWN && !stat)
			playsound(get_turf(src), pick('sound/misc/bleed (1).ogg', 'sound/misc/bleed (2).ogg', 'sound/misc/bleed (3).ogg'), 100, FALSE)

	updatehealth()

	return TRUE

#undef CONSTITUTION_BLEEDRATE_MOD

/mob/living/carbon/human/bleed(amt)
	if(NOBLOOD in dna?.species?.species_traits)
		return FALSE
	if(physiology)
		amt *= physiology.bleed_mod
	return ..()

/mob/living/proc/restore_blood()
	blood_volume = initial(blood_volume)

/mob/living/carbon/human/restore_blood()
	blood_volume = BLOOD_VOLUME_NORMAL
	bleed_rate = 0

/****************************************************
				BLOOD TRANSFERS
****************************************************/

//Gets blood from mob to a container or other mob, preserving all data in it.
/mob/living/proc/transfer_blood_to(atom/movable/AM, amount, forced)
	var/datum/blood_type/blood = get_blood_type()
	if(isnull(blood) || !AM.reagents)
		return 0
	if(blood_volume < BLOOD_VOLUME_BAD && !forced)
		return 0

	if(blood_volume < amount)
		amount = blood_volume

	blood_volume -= amount

	AM.reagents.add_reagent(blood.reagent_type, amount, blood.get_blood_data(src), bodytemperature)
	return 1


/mob/living/proc/get_blood_type()
	RETURN_TYPE(/datum/blood_type)
	return GLOB.blood_types[animal_type] || GLOB.blood_types[/datum/blood_type/animal]

/mob/living/proc/get_lux_status()
	var/datum/blood_type/blood = get_blood_type()

	if(has_status_effect(/datum/status_effect/debuff/lux_drained) || has_status_effect(/datum/status_effect/debuff/flaw_lux_taken))//accounts for luxless flaw
		return LUX_DRAINED

	if(has_status_effect(/datum/status_effect/debuff/tainted_lux) || has_status_effect(/datum/status_effect/debuff/received_tainted_lux) || has_status_effect(/datum/status_effect/buff/received_lux))
		return LUX_HAS_LUX

	return blood.contains_lux

/mob/living/proc/get_lux_tainted_status()
	var/datum/blood_type/blood = get_blood_type()
	return blood.tainted_lux

/mob/living/carbon/human/get_blood_type()
	RETURN_TYPE(/datum/blood_type)
	if(HAS_TRAIT(src, TRAIT_HUSK) || isnull(dna))
		return null
	if(dna.species.exotic_bloodtype)
		return GLOB.blood_types[dna.species.exotic_bloodtype]
	return GLOB.blood_types[dna.human_blood_type]

// This has more potential uses, and is probably faster than the old proc.
/proc/get_safe_blood(bloodtype)
	. = list()
	if(!bloodtype)
		return

	var/static/list/bloodtypes_safe = list(
		"A-" = list("A-", "O-"),
		"A+" = list("A-", "A+", "O-", "O+"),
		"B-" = list("B-", "O-"),
		"B+" = list("B-", "B+", "O-", "O+"),
		"AB-" = list("A-", "B-", "O-", "AB-"),
		"AB+" = list("A-", "A+", "B-", "B+", "O-", "O+", "AB-", "AB+"),
		"O-" = list("O-"),
		"O+" = list("O-", "O+"),
		"L" = list("L"),
		"U" = list("A-", "A+", "B-", "B+", "O-", "O+", "AB-", "AB+", "L", "U")
	)

	var/safe = bloodtypes_safe[bloodtype]
	if(safe)
		. = safe

//to add a splatter of blood or other mob liquid.
/mob/living/proc/add_splatter_floor(turf/T)
	if(!iscarbon(src))
		if(!HAS_TRAIT(src, TRAIT_SIMPLE_WOUNDS))
			return
	var/datum/blood_type/blood = get_blood_type()
	if(isnull(blood))
		return
	if(!T)
		T = get_turf(src)

	if(istype(T, /turf/open/water))
		var/turf/open/water/W = T
		if(!LAZYLEN(W.children))
			W.water_reagent = blood.reagent_type // this is dumb, but it works for now
			W.mapped = FALSE // no infinite vitae glitch
			W.water_volume = 10

		return
	var/obj/effect/decal/cleanable/blood/splatter/splatter = new /obj/effect/decal/cleanable/blood/splatter(T)

	splatter.transfer_mob_blood_dna(src)
	splatter.update_appearance(UPDATE_ICON_STATE)
	T?.pollute_turf(/datum/pollutant/metallic_scent, 30)

/mob/living/proc/add_drip_floor(turf/T, amt)
	if(!iscarbon(src))
		if(!HAS_TRAIT(src, TRAIT_SIMPLE_WOUNDS))
			return
	var/datum/blood_type/blood = get_blood_type()
	if(isnull(blood))
		return
	if(!T)
		T = get_turf(src)

	if(amt > 3)
		if(istype(T, /turf/open/water))
			var/turf/open/water/W = T
			W.water_reagent = blood.reagent_type // this is dumb, but it works for now
			W.mapped = FALSE // no infinite vitae glitch
			W.water_maximum = 10
			W.water_volume = 10
			return
	var/obj/item/reagent_containers/container = locate(/obj/item/reagent_containers) in T
	playsound(get_turf(src), 'sound/misc/bleed (3).ogg', 100, FALSE)
	if(container && container.is_open_container() && container.reagents.total_volume < container.reagents.maximum_volume)
		var/datum/blood_type/type = get_blood_type()
		container.reagents.add_reagent(initial(type.reagent_type), 5, data = type.get_blood_data(src))
	else
		var/obj/effect/decal/cleanable/blood/puddle/P = locate() in T
		if(P)
			P.blood_vol += amt
			P.transfer_mob_blood_dna(src)
			P.update_appearance(UPDATE_ICON_STATE)
		else
			var/obj/effect/decal/cleanable/blood/drip/D = locate() in T
			if(D)
				D.blood_vol += amt
				D.drips++
				D.transfer_mob_blood_dna(src)
				D.update_appearance(UPDATE_ICON_STATE)
			else
				var/obj/effect/decal/cleanable/blood/drip/splatter = new /obj/effect/decal/cleanable/blood/drip(T)
				splatter.transfer_mob_blood_dna(src)
				splatter.update_appearance(UPDATE_ICON_STATE)

/mob/living/carbon/human/add_splatter_floor(turf/T, small_drip)
	if(!(NOBLOOD in dna.species.species_traits))
		..()
