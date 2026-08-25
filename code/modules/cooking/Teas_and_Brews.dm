// basic tea, utilises adjusted soup code
/datum/reagent/consumable/tea
	name = "Generic tea"
	description = "If you see this, stop using moondust"
	reagent_state = LIQUID
	color = "#c38553"
	metabolization_rate = 0.3 // 33% of normal metab
	taste_description = "grass"
	taste_mult = 3
	nutriment_factor = 1
	hydration_factor = 1
	quality = 1
	alpha = 153

/datum/reagent/consumable/tea/on_mob_metabolize(mob/living/L)
	. = ..()
	L.add_chem_effect(CE_BLOODRESTORE, 1, "[type]")

/datum/reagent/consumable/tea/on_mob_end_metabolize(mob/living/L)
	. = ..()
	L.remove_chem_effect(CE_BLOODRESTORE, "[type]")

/datum/reagent/consumable/tea/taraxamint
	name = "Taraxacum-Mentha tea"
	description = "If you see this, stop using moondust"
	color = "#acaf01"
	nutriment_factor = 2
	metabolization_rate = REAGENTS_METABOLISM * 0.33 // 33% of normal metab
	taste_description = "relaxing texture, minty aftertaste"
	taste_mult = 3
	quality = 1

/datum/reagent/consumable/tea/taraxamint/on_mob_metabolize(mob/living/L)
	. = ..()
	L.add_chem_effect(CE_STABLE, 1, "[type]")
	L.add_chem_effect(CE_PAINKILLER, 3, "[type]")

/datum/reagent/consumable/tea/taraxamint/on_mob_end_metabolize(mob/living/L)
	. = ..()
	L.remove_chem_effect(CE_STABLE, "[type]")
	L.remove_chem_effect(CE_PAINKILLER, "[type]")

/datum/reagent/consumable/tea/taraxamint/on_mob_life(mob/living/carbon/M, efficiency, seconds_per_tick)
	. = ..()
	if(volume >= 20)
		M.reagents.remove_reagent(/datum/reagent/consumable/tea/taraxamint, 2) //No overhealing.

	M.heal_wounds(0.4 * REAGENTS_MODIFIER)

	if(volume > 0.99)
		M.adjustFireLoss(-0.75 * REAGENTS_MODIFIER, 0)
		M.adjustOrganLoss(ORGAN_SLOT_BRAIN, -1 * REAGENTS_MODIFIER)
		M.adjustToxLoss(-1 * REAGENTS_MODIFIER, 0)

	return TRUE

/datum/reagent/consumable/tea/utricasalvia
	name = "Urtica-Salvia tea"
	description = "If you see this, stop using moondust"
	color = "#451853"
	nutriment_factor = 2
	metabolization_rate = REAGENTS_METABOLISM
	taste_description = "tingling, sour fruits"
	taste_mult = 2
	quality = 3

/datum/reagent/consumable/tea/utricasalvia/on_mob_metabolize(mob/living/L)
	. = ..()
	L.add_chem_effect(CE_BLOODRESTORE, 3, "[type]")
	L.add_chem_effect(CE_ORGAN_REGEN, 1, "[type]")

/datum/reagent/consumable/tea/utricasalvia/on_mob_end_metabolize(mob/living/L)
	. = ..()
	L.remove_chem_effect(CE_BLOODRESTORE, "[type]")
	L.remove_chem_effect(CE_ORGAN_REGEN, "[type]")

/datum/reagent/consumable/tea/utricasalvia/on_mob_life(mob/living/carbon/M, efficiency, seconds_per_tick)
	. = ..()
	if(volume >= 20)
		M.reagents.remove_reagent(/datum/reagent/consumable/tea/utricasalvia)

	M.heal_wounds(2 * REAGENTS_MODIFIER) // 40 woundhealing distributed on all wounds, not too much to balance innate healing below, but works faster
	M.adjustBruteLoss(-1.1 * REAGENTS_MODIFIER, 0)
	M.adjustFireLoss(-1.1 * REAGENTS_MODIFIER, 0)
	return TRUE

/datum/reagent/consumable/tea/badidea
	name = "westleach tar tea"
	description = "If you see this, stop using moondust"
	color = "#490100"
	nutriment_factor = 2
	metabolization_rate = REAGENTS_METABOLISM * 2 // ye be fucked my guy
	taste_description = "HEROIC, amounts of westleach tar"
	taste_mult = 4
	hydration_factor = 0
	quality = 0

/datum/reagent/consumable/tea/badidea/on_mob_metabolize(mob/living/L)
	. = ..()
	L.add_chem_effect(CE_BLOCKAGE, 3, "[type]")
	L.add_chem_effect(CE_BREATHLOSS, 1, "[type]")

/datum/reagent/consumable/tea/badidea/on_mob_end_metabolize(mob/living/L)
	. = ..()
	L.remove_chem_effect(CE_BLOCKAGE, "[type]")
	L.remove_chem_effect(CE_BREATHLOSS, "[type]")

/datum/reagent/consumable/tea/badidea/on_mob_life(mob/living/carbon/M, efficiency, seconds_per_tick)
	. = ..()
	if(volume > 5)
		if(HAS_TRAIT(M, TRAIT_POISON_RESILIENCE))
			M.add_nausea(1 * REAGENTS_MODIFIER)
			M.adjustToxLoss(0.5 * REAGENTS_MODIFIER)
		else
			M.add_nausea(2 * REAGENTS_MODIFIER) // You didn't think it was a good idea, did you?
			M.adjustToxLoss(2 * REAGENTS_MODIFIER)
	return TRUE

/datum/reagent/consumable/tea/fourtwenty
	name = "swampweed brew"
	description = "If you see this, stop using moondust"
	color = "#04750a"
	nutriment_factor = 2
	metabolization_rate = 1
	taste_description = "dirt, colors, future"
	taste_mult = 3
	hydration_factor = 2
	quality = 1

/datum/reagent/consumable/tea/fourtwenty/on_mob_metabolize(mob/living/L)
	. = ..()
	L.add_chem_effect(CE_PULSE, 1, "[type]")
	L.add_chem_effect(CE_ENERGETIC, 3, "[type]")

/datum/reagent/consumable/tea/fourtwenty/on_mob_end_metabolize(mob/living/L)
	. = ..()
	L.remove_chem_effect(CE_PULSE, "[type]")
	L.remove_chem_effect(CE_ENERGETIC, "[type]")

/datum/reagent/consumable/tea/fourtwenty/on_mob_life(mob/living/carbon/M, efficiency, seconds_per_tick)
	. = ..()
	if(volume > 10)
		M.reagents.add_reagent(/datum/reagent/drug/space_drugs, 2 * REAGENTS_MODIFIER)

/datum/reagent/consumable/tea/manabloom
	name = "Manabloom tea"
	description = "If you see this, stop using moondust"
	color = "#5986b1"
	nutriment_factor = 2
	metabolization_rate = 0.2 // 20% of normal metab
	taste_description = "stinging, floral tones. Did it just cast something in your mouth?..."
	taste_mult = 2
	hydration_factor = 2

/datum/reagent/consumable/tea/manabloom/on_mob_life(mob/living/carbon/M, efficiency, seconds_per_tick)
	. = ..()

	if(volume >= 20)
		M.reagents.remove_reagent(/datum/reagent/consumable/tea/manabloom, 2) //No powerchuging for you, mage lad.
		M.add_nausea(1 * REAGENTS_MODIFIER)
		to_chat(M, "<span class='danger'>It feels as if someone just conjured fireball in my stomach!</span>")

	if(volume > 0.99)
		M.mana_pool.adjust_mana(0.05 * REAGENTS_MODIFIER)

/datum/reagent/consumable/tea/compot
	name = "Compot"
	description = "If you see this, stop using moondust"
	color = "#b38838"
	metabolization_rate = 0.2 // 20% of normal metab
	taste_description = "strong berry taste, it's very sweet"
	taste_mult = 4
	hydration_factor = 6 //a hydrating, nutritious and convinient drink made of raisins
	nutriment_factor = 4
	quality = 3

/datum/reagent/consumable/tea/tiefbloodtea
	name = "Tiefling Blood Tea"
	description = "If you see this, stop using moondust"
	color = "#bd201b"
	metabolization_rate = 0.6 // 60% of normal metab
	taste_description = "something delightfully sweet, with a smoky aftertaste"
	taste_mult = 4
	nutriment_factor = 2
	quality = 4

/datum/reagent/consumable/tea/tiefbloodtea/on_mob_metabolize(mob/living/L)
	. = ..()
	L.add_chem_effect(CE_STABLE, 1, "[type]")
	L.add_chem_effect(CE_BLOODRESTORE, 3, "[type]")

/datum/reagent/consumable/tea/tiefbloodtea/on_mob_end_metabolize(mob/living/L)
	. = ..()
	L.remove_chem_effect(CE_STABLE, "[type]")
	L.remove_chem_effect(CE_BLOODRESTORE, "[type]")

/datum/reagent/consumable/tea/waddle
	name = "Waddle tea"
	color = "#b57232"
	metabolization_rate = 0.5
	taste_description = "slightly earthy, with a meaty aftertaste"
	taste_mult = 3
	nutriment_factor = 3
	quality = 1

