
/datum/reagent/meth_precursor
	name = "Methamphetamine Precursor"
	description = "A volatile chemical intermediate. Smells awful. Probably shouldn't drink it."
	reagent_state = LIQUID
	color = "#C8E8FA"
	taste_description = "burning chemicals"
	harmful = TRUE
	boiling_point = T0C + 140

/datum/reagent/drug/methamphetamine
	name = "Methamphetamine"
	description = "Reduces stun times by about 300%, speeds the user up, and allows the user to quickly recover stamina while dealing a small amount of Brain damage. If overdosed the subject will move randomly, laugh randomly, drop items and suffer from Toxin and Brain damage. If addicted the subject will constantly jitter and drool, before becoming dizzy and losing motor control and eventually suffer heavy toxin damage."
	reagent_state = LIQUID
	color = "#78C8FA" //best case scenario is the "default", gets muddled depending on purity
	overdose_threshold = 20
	metabolization_rate = 0.75 * REAGENTS_METABOLISM

/datum/reagent/drug/methamphetamine/on_mob_metabolize(mob/living/L)
	..()
	L.add_movespeed_modifier("meth", TRUE, multiplicative_slowdown = -0.65)
	L.add_chem_effect(CE_ENERGETIC, 2, "[type]")

/datum/reagent/drug/methamphetamine/on_mob_end_metabolize(mob/living/L)
	L.remove_movespeed_modifier("meth")
	L.remove_chem_effect(CE_ENERGETIC, "[type]")
	..()

/datum/reagent/drug/methamphetamine/on_mob_life(mob/living/carbon/affected_mob, efficiency)
	. = ..()
	var/high_message = pick("You feel hyper.", "You feel like you need to go faster.", "You feel like you can run the world.")
	if(prob(2.5))
		to_chat(affected_mob, span_notice("[high_message]"))
	affected_mob.AdjustStun(-40 * REM * efficiency)
	affected_mob.AdjustKnockdown(-40 * REM * efficiency)
	affected_mob.AdjustUnconscious(-40 * REM * efficiency)
	affected_mob.AdjustParalyzed(-40 * REM * efficiency)
	affected_mob.AdjustImmobilized(-40 * REM * efficiency)
	affected_mob.set_jitter_if_lower(4 SECONDS * REM * efficiency)
	if(overdosed) // MONKESTATION EDIT: Makes Unknown Methamphetamine Isomer actually safe. "safe" is false by default.
		affected_mob.adjustOrganLoss(ORGAN_SLOT_BRAIN, rand(1, 4) * REM * efficiency)
	if(prob(2.5))
		affected_mob.emote(pick("twitch", "shiver"))
	..()
	. = TRUE

/datum/reagent/drug/methamphetamine/overdose_process(mob/living/affected_mob)
	if(!HAS_TRAIT(affected_mob, TRAIT_IMMOBILIZED) && !ismovable(affected_mob.loc))
		for(var/i in 1 to round(4 * REM, 1))
			step(affected_mob, pick(GLOB.cardinals))
	if(prob(10))
		affected_mob.emote("laugh")
	if(prob(18))
		affected_mob.visible_message(span_danger("[affected_mob]'s hands flip out and flail everywhere!"))
		affected_mob.drop_all_held_items()
	..()
	affected_mob.adjustToxLoss(1 * REM, FALSE)
	affected_mob.adjustOrganLoss(ORGAN_SLOT_BRAIN, (rand(5, 10) / 10) * REM)
	. = TRUE

/datum/reagent/drug/phlogiston_elasticum
	name = "Phlogiston Elasticum"
	description = "An unstable alchemical suspension infused with volatile air-aspected essence. It fills the body with kinetic potential, causing the imbiber to rebound and spring with unnatural force. Excess causes chaotic motion, uncontrolled spasms, and degradation of the mind and body."
	reagent_state = LIQUID
	color = "#7FE0FF"
	metabolization_rate = 0.75 * REAGENTS_METABOLISM

/datum/reagent/drug/phlogiston_elasticum/on_mob_metabolize(mob/living/L)
	. = ..()
	L.add_chem_effect(CE_BOUNCY, 4, "[type]")

/datum/reagent/drug/phlogiston_elasticum/on_mob_end_metabolize(mob/living/L)
	. = ..()
	L.remove_chem_effect(CE_BOUNCY, 4)

/datum/reagent/drug/gravitum_elixir
	name = "Gravitum Elixir"
	description = "A heavy alchemical distillate that saturates the body with excess essence of Earth. The imbiber swells in size and mass, movements becoming slower but more forceful. Prolonged exposure causes uncontrolled growth, sluggish reflexes, and structural stress as the body struggles to support its own weight."
	reagent_state = LIQUID
	color = "#5FA8FF"
	metabolization_rate = 0.75 * REAGENTS_METABOLISM

/datum/reagent/drug/gravitum_elixir/on_mob_metabolize(mob/living/L)
	. = ..()
	L.add_chem_effect(CE_ENLARGING, 4, "[type]")
	L.update_effect_scaling()

/datum/reagent/drug/gravitum_elixir/on_mob_end_metabolize(mob/living/L)
	. = ..()
	L.remove_chem_effect(CE_ENLARGING, "[type]")
	L.update_effect_scaling()

/datum/reagent/drug/subtilum_tincture
	name = "Subtilum Tincture"
	description = "A rare alchemical tincture that refines and compresses the body’s physical essence. The imbiber shrinks in size, becoming light and agile but physically fragile. Excess causes severe instability, dizziness, and progressive loss of bodily cohesion."
	reagent_state = LIQUID
	color = "#BFEFFF"
	metabolization_rate = 0.75 * REAGENTS_METABOLISM

/datum/reagent/drug/subtilum_tincture/on_mob_metabolize(mob/living/L)
	. = ..()
	L.add_chem_effect(CE_SHRINKING, 4, "[type]")
	L.update_effect_scaling()

/datum/reagent/drug/subtilum_tincture/on_mob_end_metabolize(mob/living/L)
	. = ..()
	L.remove_chem_effect(CE_SHRINKING, 4)
	L.update_effect_scaling()

/datum/reagent/sal_petris
	name = "Sal Petris"
	description = "An alchemical salt that arrests flesh into lifeless stone. In sufficient quantity, the imbiber stiffens and calcifies, their body held rigid as marble for a time."
	color = "#929292"
	metabolization_rate = 10 * REAGENTS_METABOLISM
	taste_description = "rocks"

	/// Less than this and it wont petrify
	var/min_volume_to_pretrify = 3
	/// So 1u of exposure is 5 seconds of statue time
	var/reagent_to_time_conversion = 5 SECONDS

/datum/reagent/sal_petris/reaction_mob(mob/living/M, method, reac_volume, show_message, touch_protection)
	. = ..()
	if(reac_volume < min_volume_to_pretrify)
		return

	M.Stun(4 SECONDS)
	M.petrify(reac_volume * reagent_to_time_conversion)

/datum/reagent/cryzaline_suspension
	name = "Crysaline Suspension"
	description = "A supercooled alchemical suspension that rapidly crystallizes moisture on contact. Each exposure deepens the frost, layering rime upon the body until it violently ruptures."
	reagent_state = LIQUID
	color = "#88BFFF"
	metabolization_rate = 0.5 * REAGENTS_METABOLISM
	taste_description = "biting cold"

	/// Minimum volume before frost begins to take hold
	var/min_volume_to_affect = 5
	/// How much reagent volume converts into frost stacks
	var/reagent_to_stack_conversion = 0.2

/datum/reagent/cryzaline_suspension/reaction_mob(mob/living/M, method, reac_volume, show_message, touch_protection)
	. = ..()

	if(reac_volume < min_volume_to_affect)
		return

	var/stacks = max(1, round(reac_volume * reagent_to_stack_conversion))
	apply_frost_stack(M, stacks)
