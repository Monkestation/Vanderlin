/datum/reagent/medicine
	name = "Medicine"
	taste_description = "bitterness"
	random_reagent_color = TRUE
	overdose_threshold = 0

/datum/reagent/medicine/on_mob_life(mob/living/carbon/M, efficiency)
	current_cycle++
	. = ..()

/datum/reagent/medicine/atropine
	name = "Atropine"
	description = "If a patient is in critical condition, rapidly heals all damage types as well as regulating oxygen in the body. Excellent for stabilizing wounded patients, and said to neutralize blood-activated internal explosives found amongst clandestine black op agents."
	reagent_state = LIQUID
	color = "#1D3535" //slightly more blue, like epinephrine
	random_reagent_color = FALSE
	metabolization_rate = 0.25 * REAGENTS_METABOLISM
	overdose_threshold = 35

/datum/reagent/medicine/atropine/on_mob_metabolize(mob/living/L)
	. = ..()
	if(!iscarbon(L))
		return
	var/mob/living/carbon/C = L
	//var/numbing = min(50, CEILING(C.getShock(TRUE)/2, 1))
	C.add_chem_effect(CE_BLOODRESTORE, 1, "[type]")
	//C.add_chem_effect(CE_PAINKILLER, numbing, "[type]")
	C.add_chem_effect(CE_STABLE, 1, "[type]")
	if(C.undergoing_cardiac_arrest() || C.undergoing_nervous_system_failure())
		C.add_chem_effect(CE_ORGAN_REGEN, 1, "[type]")

/datum/reagent/medicine/atropine/on_mob_end_metabolize(mob/living/L)
	. = ..()
	L.remove_chem_effect(CE_BLOODRESTORE, "[type]")
	L.remove_chem_effect(CE_ORGAN_REGEN, "[type] ")
	//L.remove_chem_effect(CE_PAINKILLER, "[type]")
	L.remove_chem_effect(CE_TOXIN, "[type]")
	L.remove_chem_effect(CE_BLOCKAGE, "[type]")
	L.remove_chem_effect(CE_STABLE, "[type]")

/datum/reagent/medicine/atropine/on_mob_life(mob/living/carbon/affected_mob, efficiency)
	if(affected_mob.health <= affected_mob.crit_threshold)
		affected_mob.adjustToxLoss(-2 * REM * efficiency , FALSE)
		affected_mob.adjustBruteLoss(-2* REM * efficiency, FALSE)
		affected_mob.adjustFireLoss(-2 * REM * efficiency, FALSE)
		affected_mob.adjustOxyLoss(-5 * REM * efficiency, FALSE)
		. = TRUE
	if(prob(10))
		affected_mob.set_dizzy(10 SECONDS * efficiency)
		affected_mob.adjust_jitter(10 SECONDS * efficiency)
	..()

/datum/reagent/medicine/atropine/overdose_process(mob/living/affected_mob)
	affected_mob.adjustToxLoss(0.5 * REM, FALSE)
	. = TRUE
	affected_mob.set_dizzy(2 SECONDS * REM)
	affected_mob.adjust_jitter(2 SECONDS * REM)
	..()
