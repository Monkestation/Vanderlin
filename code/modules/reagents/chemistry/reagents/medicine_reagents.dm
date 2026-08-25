/datum/reagent/medicine
	name = "Medicine"
	taste_description = "bitterness"
	random_reagent_color = TRUE
	overdose_threshold = 0

/datum/reagent/medicine/atropine
	name = "Atropine"
	description = "If a patient is in critical condition, rapidly heals all damage types as well as regulating oxygen in the body. Excellent for stabilizing wounded patients, and said to neutralize blood-activated internal explosives found amongst clandestine black op agents."
	reagent_state = LIQUID
	color = "#1D3535" //slightly more blue, like epinephrine
	random_reagent_color = FALSE
	metabolization_rate = 0.25 * REAGENTS_METABOLISM
	overdose_threshold = 35

/datum/reagent/medicine/atropine/on_mob_metabolize(mob/living/affected_mob)
	. = ..()
	if(!iscarbon(affected_mob))
		return
	var/mob/living/carbon/carbon_mob = affected_mob
	var/numbing = min(50, CEILING(carbon_mob.getShock(FALSE)/2, 1))
	carbon_mob.add_chem_effect(CE_PAINKILLER, numbing, "[type]")
	carbon_mob.add_chem_effect(CE_STABLE, 1, "[type]")
	carbon_mob.add_chem_effect(CE_ORGAN_REGEN, 1, "[type]")
	carbon_mob.add_chem_effect(CE_BRAIN_REGEN, 1, "[type]")
	carbon_mob.add_chem_effect(CE_OXYGENATED, 1, "[type]")

/datum/reagent/medicine/atropine/on_mob_end_metabolize(mob/living/affected_mob)
	. = ..()
	affected_mob.remove_chem_effect(CE_PAINKILLER, "[type]")
	affected_mob.remove_chem_effect(CE_STABLE, "[type]")
	affected_mob.remove_chem_effect(CE_ORGAN_REGEN, "[type] ")
	affected_mob.remove_chem_effect(CE_BRAIN_REGEN, "[type]")
	affected_mob.remove_chem_effect(CE_OXYGENATED, "[type]")

/datum/reagent/medicine/atropine/on_mob_life(mob/living/carbon/affected_mob, efficiency, seconds_per_tick)
	. = ..()

	if(HAS_TRAIT(affected_mob, TRAIT_CRITICAL_CONDITION))
		affected_mob.adjustToxLoss(-1 * REAGENTS_MODIFIER , FALSE)
		affected_mob.adjustBruteLoss(-1 * REAGENTS_MODIFIER, FALSE)
		affected_mob.adjustFireLoss(-1 * REAGENTS_MODIFIER, FALSE)
		affected_mob.adjustOxyLoss(-2.5 * REAGENTS_MODIFIER, FALSE)
		. = TRUE

	var/obj/item/organ/lungs/affected_lungs = affected_mob.getorganslot(ORGAN_SLOT_LUNGS)
	if(affected_lungs)
		affected_mob.losebreath = 0

	if(SPT_PROB(5, seconds_per_tick))
		affected_mob.set_dizzy(2 SECONDS * REAGENTS_MODIFIER)
		affected_mob.adjust_jitter(2 SECONDS * REAGENTS_MODIFIER)

/datum/reagent/medicine/atropine/overdose_process(mob/living/affected_mob, efficiency, seconds_per_tick)
	. = ..()

	affected_mob.adjustToxLoss(0.25 * REAGENTS_MODIFIER)
	affected_mob.set_dizzy(1 SECONDS * REAGENTS_MODIFIER)
	affected_mob.adjust_jitter(1 SECONDS * REAGENTS_MODIFIER)

	return TRUE

/datum/reagent/medicine/ashwarden_brew
	name = "Ashwarden Brew"
	description = "A foul-smelling dark brew used by those who venture near volcanic vents. It coats the lungs and airways in a protective lattice, specifically reversing fire and chemical burn damage."
	reagent_state = LIQUID
	color = "#3D1C02"
	taste_description = "volcanic sulfur and char"
	scent_description = "sulphurous fumes"
	metabolization_rate = REAGENTS_METABOLISM

/datum/reagent/medicine/ashwarden_brew/on_mob_life(mob/living/carbon/M, efficiency, seconds_per_tick)
	. = ..()

	if(volume > 0.99)
		M.adjustFireLoss(-2.5 * REAGENTS_MODIFIER)
		M.adjustToxLoss(-0.2 * REAGENTS_MODIFIER)

	if(SPT_PROB(5, seconds_per_tick))
		M.add_nausea(0.4 * REAGENTS_MODIFIER)

	M.adjustOrganLoss(ORGAN_SLOT_LUNGS, -0.4 * REAGENTS_MODIFIER)

	return TRUE

/datum/reagent/medicine/thornmorrow_tincture
	name = "Thornmorrow Tincture"
	description = "Extracted from thornmorrow briar, a plant that repairs itself. Extremely slow to act, but uniquely persistent it remains in the bloodstream long after most medicines have faded, offering gradual healing over a prolonged period."
	reagent_state = LIQUID
	color = "#228B22"
	taste_description = "thorny bitterness"
	scent_description = "briars and undergrowth"
	metabolization_rate = REAGENTS_METABOLISM * 0.2  // Very slow metabolization

/datum/reagent/medicine/thornmorrow_tincture/on_mob_life(mob/living/carbon/M, efficiency, seconds_per_tick)
	. = ..()

	if(volume > 0.99)
		M.adjustBruteLoss(-0.5 * REAGENTS_MODIFIER, 0)
		M.adjustFireLoss(-0.5 * REAGENTS_MODIFIER, 0)
		M.adjustToxLoss(-0.1 * REAGENTS_MODIFIER, 0)
		M.heal_wounds(0.2 * REAGENTS_MODIFIER)
		return TRUE

/datum/reagent/medicine/soulweave_distillate
	name = "Soulweave Distillate"
	description = "A luminescent distillate refined from life-essence concentrate and essence of cycle. Said to weave the threads of a damaged soul back together it reverses organ and brain damage simultaneously while stabilizing the critically injured."
	reagent_state = LIQUID
	color = "#E0BBE4"
	taste_description = "floral bitterness and light"
	scent_description = "sunrise petals"
	metabolization_rate = REAGENTS_METABOLISM * 1.5

/datum/reagent/medicine/soulweave_distillate/on_mob_metabolize(mob/living/L)
	. = ..()
	L.add_chem_effect(CE_BRAIN_REGEN, 1, "[type]")
	L.add_chem_effect(CE_ORGAN_REGEN, 1, "[type]")
	L.add_chem_effect(CE_STABLE, 1, "[type]")
	L.add_chem_effect(CE_BLOODRESTORE, 5, "[type]")

/datum/reagent/medicine/soulweave_distillate/on_mob_end_metabolize(mob/living/L)
	. = ..()
	L.remove_chem_effect(CE_BRAIN_REGEN, "[type]")
	L.remove_chem_effect(CE_ORGAN_REGEN, "[type]")
	L.remove_chem_effect(CE_STABLE, "[type]")
	L.remove_chem_effect(CE_BLOODRESTORE, "[type]")

/datum/reagent/medicine/soulweave_distillate/on_mob_life(mob/living/carbon/M, efficiency, seconds_per_tick)
	. = ..()

	if(volume > 0.99)
		M.adjustOrganLoss(ORGAN_SLOT_BRAIN, -2 * REAGENTS_MODIFIER, 150)

/datum/reagent/medicine/coldvein_compress
	name = "Coldvein Compress"
	description = "A supercooled liquid suspension that numbs and anesthetizes damaged tissue on contact. Dramatically reduces pain and slows the progression of burn injury when applied directly."
	reagent_state = LIQUID
	color = "#ADD8E6"
	taste_description = "biting cold and numbness"
	scent_description = "winter air"
	metabolization_rate = REAGENTS_METABOLISM

/datum/reagent/medicine/coldvein_compress/on_mob_metabolize(mob/living/L)
	. = ..()
	L.add_chem_effect(CE_PAINKILLER, 30, "[type]")

/datum/reagent/medicine/coldvein_compress/on_mob_end_metabolize(mob/living/L)
	. = ..()
	L.remove_chem_effect(CE_PAINKILLER, "[type]")

/datum/reagent/medicine/coldvein_compress/on_bodypart_absorb(mob/living/carbon/affected_mob, obj/item/bodypart/affected_bodypart, amount_to_transfer, seconds_per_tick)
	. = ..()

	if(affected_bodypart.heal_damage(0, 1 * REM * seconds_per_tick, required_status = BODYPART_ORGANIC))
		affected_mob.update_damage_overlays()

/datum/reagent/medicine/coldvein_compress/on_mob_life(mob/living/carbon/M, efficiency, seconds_per_tick)
	. = ..()

	if(volume > 0.99)
		M.adjustFireLoss(-1 * REAGENTS_MODIFIER, 0)

/datum/reagent/medicine/ichor_of_mending
	name = "Ichor of Mending"
	description = "A viscous golden fluid drawn from the rendered fat of blessed beasts. It seals wounds from the inside, knitting torn flesh together at an unnatural pace but offers nothing against fire or disease."
	reagent_state = LIQUID
	color = "#D4AF37"
	taste_description = "animal fat and sweetness"
	scent_description = "rendered tallow"
	metabolization_rate = REAGENTS_METABOLISM * 0.75

/datum/reagent/medicine/ichor_of_mending/on_mob_life(mob/living/carbon/M, efficiency, seconds_per_tick)
	. = ..()

	if(volume > 0.99)
		M.adjustBruteLoss(-1.75 * REAGENTS_MODIFIER)
		M.heal_wounds(0.8 * REAGENTS_MODIFIER)

/datum/reagent/medicine/ichor_of_mending/on_bodypart_absorb(mob/living/carbon/affected_mob, obj/item/bodypart/affected_bodypart, amount_to_transfer, seconds_per_tick)
	. = ..()

	if(affected_bodypart.heal_damage(1.75 * REM * seconds_per_tick, 0, required_status = BODYPART_ORGANIC))
		affected_mob.update_damage_overlays()

/datum/reagent/medicine/ashbinders_salve
	name = "Ashbinder's Salve"
	description = "A charcoal-grey paste made from rendered ash and cooled flame extracts. Specializes in treating burns with remarkable efficacy, though it does nothing for blunt wounds or bleeding."
	reagent_state = LIQUID
	color = "#555555"
	taste_description = "ash and oil"
	scent_description = "cooling embers"
	metabolization_rate = REAGENTS_METABOLISM

/datum/reagent/medicine/ashbinders_salve/on_mob_life(mob/living/carbon/M, efficiency, seconds_per_tick)
	. = ..()

	if(volume > 0.99)
		M.adjustFireLoss(-2 * REAGENTS_MODIFIER, 0)
		return TRUE

/datum/reagent/medicine/ashbinders_salve/on_bodypart_absorb(mob/living/carbon/affected_mob, obj/item/bodypart/affected_bodypart, amount_to_transfer, seconds_per_tick)
	. = ..()

	for(var/datum/injury/injury in affected_bodypart.injuries)
		if(!injury.can_heal())
			continue
		if(!(injury.damage_type & FIRE_WOUND_TYPES))
			continue
		injury.adjust_germ_level(-2 * REM * seconds_per_tick)
		injury.heal_damage(0.6 * REM * seconds_per_tick)

	if(affected_bodypart.post_damage_change())
		affected_mob.update_damage_overlays()

	affected_bodypart.disinfect_limb(6 SECONDS * REM * seconds_per_tick)

/datum/reagent/medicine/vitalroot_draught
	name = "Vitalroot Draught"
	description = "Brewed from roots that grow only near ley-line confluences. It floods the blood with restorative energy, rapidly closing oxygen deprivation and restoring breath to the suffocating it cannot address wounds or toxins."
	reagent_state = LIQUID
	color = "#4CAF50"
	taste_description = "bitter roots"
	scent_description = "deep earth and mineral water"
	metabolization_rate = REAGENTS_METABOLISM
	boiling_point = T0C + 130

/datum/reagent/medicine/vitalroot_draught/on_mob_metabolize(mob/living/L)
	. = ..()
	L.add_chem_effect(CE_OXYGENATED, 1, "[type]")
	L.add_chem_effect(CE_BLOODRESTORE, 8, "[type]")

/datum/reagent/medicine/vitalroot_draught/on_mob_end_metabolize(mob/living/L)
	. = ..()
	L.remove_chem_effect(CE_OXYGENATED, "[type]")
	L.remove_chem_effect(CE_BLOODRESTORE, "[type]")

/datum/reagent/medicine/vitalroot_draught/on_mob_life(mob/living/carbon/M, efficiency, seconds_per_tick)
	. = ..()

	if(volume > 0.99)
		M.adjustOxyLoss(-1.2 * REAGENTS_MODIFIER, 0)
		M.adjustOrganLoss(-0.4 * REAGENTS_MODIFIER, ORGAN_SLOT_LUNGS)
		return TRUE

/datum/reagent/medicine/tombsilt_tincture
	name = "Tombsilt Tincture"
	description = "Ground grave-dust suspended in spirit vinegar. Morbid in origin, remarkable in function: it arrests necrotic and toxin damage with cold precision, but does nothing for physical injury."
	reagent_state = LIQUID
	color = "#8B7355"
	taste_description = "dry dust and sharp vinegar"
	scent_description = "old earth and spirits"
	metabolization_rate = REAGENTS_METABOLISM

/datum/reagent/medicine/tombsilt_tincture/on_mob_metabolize(mob/living/L)
	. = ..()
	L.add_chem_effect(CE_ANTIBIOTIC, 15, "[type]")

/datum/reagent/medicine/tombsilt_tincture/on_mob_end_metabolize(mob/living/L)
	. = ..()
	L.remove_chem_effect(CE_ANTIBIOTIC, "[type]")

/datum/reagent/medicine/tombsilt_tincture/on_mob_life(mob/living/carbon/M, efficiency, seconds_per_tick)
	. = ..()
	if(volume > 0.99)
		M.adjustToxLoss(-1 * REAGENTS_MODIFIER, 0)
		M.adjustCloneLoss(-1 * REAGENTS_MODIFIER, 0)
		return TRUE

/datum/reagent/medicine/mirewort_compress
	name = "Mirewort Compress"
	description = "A pungent brown compress liquid extracted from swamp mirewort. Notorious for smelling of stagnant water, it excels at cleansing infected wounds when applied directly to flesh."
	reagent_state = LIQUID
	color = "#556B2F"
	taste_description = "swamp water and rot"
	scent_description = "stagnant bog"
	metabolization_rate = REAGENTS_METABOLISM * 0.5

/datum/reagent/medicine/mirewort_compress/on_bodypart_absorb(mob/living/carbon/affected_mob, obj/item/bodypart/affected_bodypart, amount_to_transfer, seconds_per_tick)
	. = ..()

	for(var/datum/injury/injury in affected_bodypart.injuries)
		injury.adjust_germ_level(-4 * REM * seconds_per_tick)

	affected_bodypart.disinfect_limb(0.6 MINUTES * REM * seconds_per_tick)
	affected_bodypart.adjust_germ_level(-5 * REM * seconds_per_tick)

/datum/reagent/medicine/mirewort_compress/on_mob_life(mob/living/carbon/M, efficiency, seconds_per_tick)
	. = ..()

	if(volume > 0.99)
		M.adjustToxLoss(0.2 * REAGENTS_MODIFIER, 0)

/datum/reagent/medicine/woundwrack_oil
	name = "Woundwrack Oil"
	description = "An oily amber extract from the woundwrack tree's bark. Applied to open wounds, it dramatically accelerates natural clotting and closes lacerations, but does nothing when absorbed internally."
	reagent_state = LIQUID
	color = "#C8860A"
	taste_description = "tree bark and pine"
	scent_description = "resinous amber"
	metabolization_rate = REAGENTS_METABOLISM

/datum/reagent/medicine/woundwrack_oil/on_bodypart_absorb(mob/living/carbon/affected_mob, obj/item/bodypart/affected_bodypart, amount_to_transfer, seconds_per_tick)
	. = ..()

	for(var/datum/injury/injury in affected_bodypart.injuries)
		if(!injury.can_heal())
			continue
		injury.salve_injury()
		injury.heal_damage(0.4 * REM * seconds_per_tick)

	if(affected_bodypart.post_damage_change())
		affected_mob.update_damage_overlays()

	affected_bodypart.adjust_germ_level(-2 * REM * seconds_per_tick)

/datum/reagent/medicine/woundwrack_oil/on_mob_life(mob/living/carbon/M, efficiency, seconds_per_tick)
	. = ..()

	if(volume > 0.99)
		M.adjustBruteLoss(-0.125 * REAGENTS_MODIFIER, 0)

/datum/reagent/medicine/pale_serum
	name = "Pale Serum"
	description = "A milky-white concoction refined through careful reduction of bone marrow and purified water. Uniquely restores organ function and brain matter, but offers little for surface wounds."
	reagent_state = LIQUID
	color = "#F5F5F0"
	taste_description = "mineral and chalk"
	scent_description = "clean sterility"
	metabolization_rate = REAGENTS_METABOLISM * 0.75
	boiling_point = T0C + 150

/datum/reagent/medicine/pale_serum/on_mob_metabolize(mob/living/L)
	. = ..()
	L.add_chem_effect(CE_BRAIN_REGEN, 1, "[type]")
	L.add_chem_effect(CE_ORGAN_REGEN, 1, "[type]")

/datum/reagent/medicine/pale_serum/on_mob_end_metabolize(mob/living/L)
	. = ..()
	L.remove_chem_effect(CE_BRAIN_REGEN, "[type]")
	L.remove_chem_effect(CE_ORGAN_REGEN, "[type]")

/datum/reagent/medicine/pale_serum/on_mob_life(mob/living/carbon/M, efficiency, seconds_per_tick)
	. = ..()

	if(volume > 0.99)
		M.adjustOrganLoss(ORGAN_SLOT_BRAIN, -1.5 * REAGENTS_MODIFIER, 150)
		M.adjustOrganLoss(ORGAN_SLOT_EYES, -1 * REAGENTS_MODIFIER, 150)

/datum/reagent/medicine/spiritwood_elixir
	name = "Spiritwood Elixir"
	description = "Brewed from the heartwood of a spiritwood tree, fallen naturally. The elixir shares a brief connection with the life-force of the tree, dramatically accelerating wound closure while the link holds."
	reagent_state = LIQUID
	color = "#8FBC8F"
	taste_description = "bark and sap"
	scent_description = "ancient forest"
	metabolization_rate = REAGENTS_METABOLISM * 2

/datum/reagent/medicine/spiritwood_elixir/on_mob_metabolize(mob/living/L)
	. = ..()
	L.add_chem_effect(CE_STABLE, 1, "[type]")
	L.add_chem_effect(CE_BLOODRESTORE, 10, "[type]")
	L.add_chem_effect(CE_SHRINKING, 2, "[type]")
	L.update_effect_scaling()

/datum/reagent/medicine/spiritwood_elixir/on_mob_end_metabolize(mob/living/L)
	. = ..()
	L.remove_chem_effect(CE_STABLE, "[type]")
	L.remove_chem_effect(CE_BLOODRESTORE, "[type]")
	L.remove_chem_effect(CE_SHRINKING, "[type]")
	L.update_effect_scaling()

/datum/reagent/medicine/spiritwood_elixir/on_mob_life(mob/living/carbon/M, efficiency, seconds_per_tick)
	. = ..()

	if(volume > 0.99)
		M.adjustBruteLoss(-1.25 * REAGENTS_MODIFIER, 0)
		M.adjustFireLoss(-1.25 * REAGENTS_MODIFIER, 0)
		M.heal_wounds(1 * REAGENTS_MODIFIER)
		return TRUE

/datum/reagent/medicine/marrowbrew
	name = "Marrowbrew"
	description = "Boiled marrow of large beasts, reduced and clarified. Slowly heals all damage types from the inside out, not remarkable at any one thing, but comprehensive."
	reagent_state = LIQUID
	color = "#FFFACD"
	taste_description = "rich fat and meat"
	scent_description = "bone broth"
	metabolization_rate = REAGENTS_METABOLISM * 0.5

/datum/reagent/medicine/marrowbrew/on_mob_metabolize(mob/living/L)
	. = ..()
	L.add_chem_effect(CE_BLOODRESTORE, 3, "[type]")
	L.add_chem_effect(CE_ENERGETIC, 4, "[type]")

/datum/reagent/medicine/marrowbrew/on_mob_end_metabolize(mob/living/L)
	. = ..()
	L.remove_chem_effect(CE_BLOODRESTORE, "[type]")
	L.remove_chem_effect(CE_ENERGETIC, "[type]")

/datum/reagent/medicine/marrowbrew/on_mob_life(mob/living/carbon/M, efficiency, seconds_per_tick)
	. = ..()

	if(volume > 0.99)
		M.adjustBruteLoss(-0.375 * REAGENTS_MODIFIER, 0)
		M.adjustFireLoss(-0.375 * REAGENTS_MODIFIER, 0)
		M.adjustToxLoss(-0.1 * REAGENTS_MODIFIER, 0)
		M.adjustOxyLoss(-0.1 * REAGENTS_MODIFIER, 0)
		return TRUE

/datum/reagent/medicine/mindclear_tonic
	name = "Mindclear Tonic"
	description = "A sharp-smelling blue tonic derived from aquifer mosses and dissolved crystal powder. It rapidly reverses brain damage and clears narcotic haze, but does nothing for the body."
	reagent_state = LIQUID
	color = "#00CED1"
	taste_description = "cold mint and ozone"
	scent_description = "crisp water and crystal"
	metabolization_rate = REAGENTS_METABOLISM * 1.5

/datum/reagent/medicine/mindclear_tonic/on_mob_metabolize(mob/living/L)
	. = ..()
	L.add_chem_effect(CE_BRAIN_REGEN, 1, "[type]")

/datum/reagent/medicine/mindclear_tonic/on_mob_end_metabolize(mob/living/L)
	. = ..()
	L.remove_chem_effect(CE_BRAIN_REGEN, "[type]")

/datum/reagent/medicine/mindclear_tonic/on_mob_life(mob/living/carbon/M, efficiency, seconds_per_tick)
	. = ..()

	if(volume > 0.99)
		M.adjustOrganLoss(ORGAN_SLOT_BRAIN, -2.5 * REAGENTS_MODIFIER, 150)
		M.adjust_confusion(-0.4 SECONDS * REAGENTS_MODIFIER)
		M.adjust_dizzy(-0.4 SECONDS * REAGENTS_MODIFIER)

/datum/reagent/medicine/witchknit_paste
	name = "Witchknit Paste"
	description = "A thick paste mixed by tradition-bound hedgewives. Applied externally, it rapidly closes lacerations and sets broken flesh, named for the legend that it was first made from witch-hair and spider gland."
	reagent_state = LIQUID
	color = "#C0C0C0"
	taste_description = "bitter chalk and herbs"
	scent_description = "dust and old herbs"
	metabolization_rate = REAGENTS_METABOLISM

/datum/reagent/medicine/witchknit_paste/on_bodypart_absorb(mob/living/carbon/affected_mob, obj/item/bodypart/affected_bodypart, amount_to_transfer, seconds_per_tick)
	. = ..()

	for(var/datum/injury/injury in affected_bodypart.injuries)
		if(!injury.can_heal())
			continue
		injury.salve_injury()
		injury.heal_damage(0.3 * REM * seconds_per_tick)

	if(affected_bodypart.post_damage_change())
		affected_mob.update_damage_overlays()

	affected_bodypart.adjust_germ_level(-3 * REM * seconds_per_tick)

/datum/reagent/medicine/witchknit_paste/on_mob_life(mob/living/carbon/M, efficiency, seconds_per_tick)
	. = ..()

	if(volume > 0.99)
		M.adjustBruteLoss(-0.5 * REAGENTS_MODIFIER)

/datum/reagent/medicine/fever_oil
	name = "Fever Oil"
	description = "A hot amber oil that creates a controlled fever response in the imbiber. The elevated temperature rapidly purges disease and clears infection, though the process is uncomfortable."
	reagent_state = LIQUID
	color = "#FF4500"
	taste_description = "scorching pepper and oil"
	scent_description = "burning spice"
	metabolization_rate = REAGENTS_METABOLISM

/datum/reagent/medicine/fever_oil/on_mob_metabolize(mob/living/L)
	. = ..()
	L.add_chem_effect(CE_ANTIBIOTIC, 30, "[type]")

/datum/reagent/medicine/fever_oil/on_mob_end_metabolize(mob/living/L)
	. = ..()
	L.remove_chem_effect(CE_ANTIBIOTIC, "[type]")

/datum/reagent/medicine/fever_oil/on_mob_life(mob/living/carbon/M, efficiency, seconds_per_tick)
	. = ..()

	if(volume > 0.99)
		M.adjustToxLoss(-0.6 * REAGENTS_MODIFIER, 0)

	if(SPT_PROB(12.5, seconds_per_tick))
		M.adjust_dizzy(0.4 SECONDS * REAGENTS_MODIFIER)
		M.set_jitter(3 SECONDS)

/datum/reagent/medicine/stonevein_broth
	name = "Stonevein Broth"
	description = "A dense mineral broth reduced from ore-laced spring water. Strengthens the body's resistance to physical trauma by thickening the skin and dense-packing superficial tissue."
	reagent_state = LIQUID
	color = "#A0A0A0"
	taste_description = "mineral brine"
	scent_description = "wet stone"
	metabolization_rate = REAGENTS_METABOLISM * 0.75

/datum/reagent/medicine/stonevein_broth/on_mob_life(mob/living/carbon/M, efficiency, seconds_per_tick)
	. = ..()

	if(volume > 0.99)
		M.adjustBruteLoss(-0.4 * REAGENTS_MODIFIER)
		M.heal_wounds(0.4 * REAGENTS_MODIFIER)
		return TRUE

/datum/reagent/medicine/sunpetal_decoction
	name = "Sunpetal Decoction"
	description = "A warm golden brew from sun-dried petals of the highbloom flower. It soothes toxins and infections with gentle persistence, useful for recovery, poor for emergencies."
	reagent_state = LIQUID
	color = "#FFD700"
	taste_description = "floral sweetness"
	scent_description = "dried summer flowers"
	metabolization_rate = REAGENTS_METABOLISM * 0.5

/datum/reagent/medicine/sunpetal_decoction/on_mob_metabolize(mob/living/L)
	. = ..()
	L.add_chem_effect(CE_ANTIBIOTIC, 10, "[type]")

/datum/reagent/medicine/sunpetal_decoction/on_mob_end_metabolize(mob/living/L)
	. = ..()
	L.remove_chem_effect(CE_ANTIBIOTIC, "[type]")

/datum/reagent/medicine/sunpetal_decoction/on_mob_life(mob/living/carbon/M, efficiency, seconds_per_tick)
	. = ..()

	if(volume > 0.99)
		M.adjustToxLoss(-0.4 * REAGENTS_MODIFIER, 0)
		M.adjustBruteLoss(-0.25 * REAGENTS_MODIFIER, 0)
		return TRUE

/datum/reagent/medicine/nervebind_extract
	name = "Nervebind Extract"
	description = "Derived from a rare deep-root fungus that colonizes nervous tissue. Potently numbs pain and prevents trauma shock, at the cost of making the imbiber slightly sluggish."
	reagent_state = LIQUID
	color = "#9370DB"
	taste_description = "numbing bitterness"
	scent_description = "damp fungus"
	metabolization_rate = REAGENTS_METABOLISM

/datum/reagent/medicine/nervebind_extract/on_mob_metabolize(mob/living/L)
	. = ..()
	L.add_chem_effect(CE_PAINKILLER, 80, "[type]")
	L.add_chem_effect(CE_STABLE, 1, "[type]")

/datum/reagent/medicine/nervebind_extract/on_mob_end_metabolize(mob/living/L)
	. = ..()
	L.remove_chem_effect(CE_PAINKILLER, "[type]")
	L.remove_chem_effect(CE_STABLE, "[type]")

/datum/reagent/medicine/nervebind_extract/on_mob_life(mob/living/carbon/M, efficiency, seconds_per_tick)
	. = ..()

	if(SPT_PROB(12.5, seconds_per_tick))
		M.adjust_jitter(0.4 SECONDS * REAGENTS_MODIFIER)

/datum/reagent/medicine/bloodelder_wine
	name = "Bloodelder Wine"
	description = "A deep crimson wine fermented from bloodelder berries over many months. Steadily restores blood volume at an exceptional rate, but has a mildly intoxicating effect that clouds perception."
	reagent_state = LIQUID
	color = "#8B0000"
	taste_description = "dark berries and iron"
	scent_description = "fermented fruit and copper"
	metabolization_rate = REAGENTS_METABOLISM

/datum/reagent/medicine/bloodelder_wine/on_mob_metabolize(mob/living/L)
	. = ..()
	L.add_chem_effect(CE_BLOODRESTORE, 15, "[type]")
	L.add_chem_effect(CE_PULSE, 1, "[type]")

/datum/reagent/medicine/bloodelder_wine/on_mob_end_metabolize(mob/living/L)
	. = ..()
	L.remove_chem_effect(CE_BLOODRESTORE, "[type]")
	L.remove_chem_effect(CE_PULSE, "[type]")

/datum/reagent/medicine/bloodelder_wine/on_mob_life(mob/living/carbon/M, efficiency, seconds_per_tick)
	. = ..()

	if(SPT_PROB(10, REAGENTS_MODIFIER))
		M.adjust_dizzy(0.6 SECONDS * REAGENTS_MODIFIER)

	M.adjustOrganLoss(ORGAN_SLOT_HEART, -0.4 * REAGENTS_MODIFIER)

/datum/reagent/medicine/crystalline_lymph
	name = "Crystalline Lymph"
	description = "A shimmering fluid distilled from the crystallized runoff of magical formations. It stabilizes the critically wounded, preventing death from progressing while the body catches up a stopgap, not a cure."
	reagent_state = LIQUID
	color = "#B0E0E6"
	taste_description = "still water and static"
	scent_description = "ionized air"
	metabolization_rate = REAGENTS_METABOLISM * 2

/datum/reagent/medicine/crystalline_lymph/on_mob_metabolize(mob/living/L)
	. = ..()
	L.add_chem_effect(CE_STABLE, 1, "[type]")
	L.add_chem_effect(CE_OXYGENATED, 1, "[type]")
	L.add_chem_effect(CE_ENLARGING, 3, "[type]")
	L.update_effect_scaling()

/datum/reagent/medicine/crystalline_lymph/on_mob_end_metabolize(mob/living/L)
	. = ..()
	L.remove_chem_effect(CE_STABLE, "[type]")
	L.remove_chem_effect(CE_OXYGENATED, "[type]")
	L.remove_chem_effect(CE_ENLARGING, "[type]")
	L.update_effect_scaling()
