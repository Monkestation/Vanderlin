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
	var/numbing = min(50, CEILING(C.getShock(TRUE)/2, 1))
	C.add_chem_effect(CE_BLOODRESTORE, 1, "[type]")
	C.add_chem_effect(CE_PAINKILLER, numbing, "[type]")
	C.add_chem_effect(CE_STABLE, 1, "[type]")
	if(C.undergoing_cardiac_arrest() || C.undergoing_nervous_system_failure())
		C.add_chem_effect(CE_ORGAN_REGEN, 1, "[type]")

/datum/reagent/medicine/atropine/on_mob_end_metabolize(mob/living/L)
	. = ..()
	L.remove_chem_effect(CE_BLOODRESTORE, "[type]")
	L.remove_chem_effect(CE_ORGAN_REGEN, "[type] ")
	L.remove_chem_effect(CE_PAINKILLER, "[type]")
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

/datum/reagent/medicine/ashwarden_brew
	name = "Ashwarden Brew"
	description = "A foul-smelling dark brew used by those who venture near volcanic vents. It coats the lungs and airways in a protective lattice, specifically reversing fire and chemical burn damage."
	reagent_state = LIQUID
	color = "#3D1C02"
	taste_description = "volcanic sulfur and char"
	scent_description = "sulphurous fumes"
	metabolization_rate = REAGENTS_METABOLISM

/datum/reagent/medicine/ashwarden_brew/on_mob_life(mob/living/carbon/M, efficiency)
	if(volume > 0.99)
		M.adjustFireLoss(-5 * REM * efficiency, 0)
		M.adjustToxLoss(-1 * efficiency, 0)
	if(prob(10))
		M.add_nausea(2 * efficiency)
	M.adjustOrganLoss(ORGAN_SLOT_LUNGS, -2 * efficiency)
	. = ..()

/datum/reagent/medicine/thornmorrow_tincture
	name = "Thornmorrow Tincture"
	description = "Extracted from thornmorrow briar, a plant that repairs itself. Extremely slow to act, but uniquely persistent it remains in the bloodstream long after most medicines have faded, offering gradual healing over a prolonged period."
	reagent_state = LIQUID
	color = "#228B22"
	taste_description = "thorny bitterness"
	scent_description = "briars and undergrowth"
	metabolization_rate = REAGENTS_METABOLISM * 0.2  // Very slow metabolization

/datum/reagent/medicine/thornmorrow_tincture/on_mob_life(mob/living/carbon/M, efficiency)
	if(volume > 0.99)
		M.adjustBruteLoss(-1 * REM * efficiency, 0)
		M.adjustFireLoss(-1 * REM * efficiency, 0)
		M.adjustToxLoss(-0.5 * efficiency, 0)
		var/list/wCount = M.get_wounds()
		if(wCount.len > 0)
			M.heal_wounds(1 * efficiency)
	. = ..()

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

/datum/reagent/medicine/soulweave_distillate/on_mob_life(mob/living/carbon/M, efficiency)
	if(volume > 0.99)
		M.adjustOrganLoss(ORGAN_SLOT_BRAIN, -4 * REM * efficiency, 150)
		M.adjustCloneLoss(-2 * REM * efficiency, 0)
	. = ..()

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

/datum/reagent/medicine/coldvein_compress/on_bodypart_absorb(obj/item/bodypart/BP, mob/living/carbon/M, amount_to_transfer)
	for(var/datum/injury/injury in BP.injuries)
		if(injury.damage_type == WOUND_BURN)
			injury.heal_damage(2)

/datum/reagent/medicine/coldvein_compress/on_mob_life(mob/living/carbon/M, efficiency)
	if(volume > 0.99)
		M.adjustFireLoss(-2 * REM * efficiency, 0)
	. = ..()

/datum/reagent/medicine/ichor_of_mending
	name = "Ichor of Mending"
	description = "A viscous golden fluid drawn from the rendered fat of blessed beasts. It seals wounds from the inside, knitting torn flesh together at an unnatural pace but offers nothing against fire or disease."
	reagent_state = LIQUID
	color = "#D4AF37"
	taste_description = "animal fat and sweetness"
	scent_description = "rendered tallow"
	metabolization_rate = REAGENTS_METABOLISM * 0.75

/datum/reagent/medicine/ichor_of_mending/on_mob_life(mob/living/carbon/M, efficiency)
	if(volume > 0.99)
		M.adjustBruteLoss(-3.5 * REM * efficiency, 0)
		var/list/wCount = M.get_wounds()
		if(wCount.len > 0)
			M.heal_wounds(4 * efficiency)
	. = ..()

/datum/reagent/medicine/ichor_of_mending/on_bodypart_absorb(obj/item/bodypart/BP, mob/living/carbon/M, amount_to_transfer)
	for(var/datum/injury/injury in BP.injuries)
		if(injury.damage_type == WOUND_DIVINE || injury.damage_type == WOUND_BURN)
			continue
		injury.heal_damage(2)

/datum/reagent/medicine/ashbinders_salve
	name = "Ashbinder's Salve"
	description = "A charcoal-grey paste made from rendered ash and cooled flame extracts. Specializes in treating burns with remarkable efficacy, though it does nothing for blunt wounds or bleeding."
	reagent_state = LIQUID
	color = "#555555"
	taste_description = "ash and oil"
	scent_description = "cooling embers"
	metabolization_rate = REAGENTS_METABOLISM

/datum/reagent/medicine/ashbinders_salve/on_mob_life(mob/living/carbon/M, efficiency)
	if(volume > 0.99)
		M.adjustFireLoss(-4 * REM * efficiency, 0)
	. = ..()

/datum/reagent/medicine/ashbinders_salve/on_bodypart_absorb(obj/item/bodypart/BP, mob/living/carbon/M, amount_to_transfer)
	for(var/datum/injury/injury in BP.injuries)
		if(injury.damage_type != WOUND_BURN)
			continue
		injury.heal_damage(3)
		injury.adjust_germ_level(-10)
	BP.disinfect_limb(30 SECONDS)

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

/datum/reagent/medicine/vitalroot_draught/on_mob_life(mob/living/carbon/M, efficiency)
	if(volume > 0.99)
		M.adjustOxyLoss(-6 * efficiency, 0)
		M.adjustOrganLoss(-2 * efficiency, ORGAN_SLOT_LUNGS)
	. = ..()

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

/datum/reagent/medicine/tombsilt_tincture/on_mob_life(mob/living/carbon/M, efficiency)
	if(volume > 0.99)
		M.adjustToxLoss(-5 * efficiency, 0)
		M.adjustCloneLoss(-2 * REM * efficiency, 0)
	. = ..()

/datum/reagent/medicine/mirewort_compress
	name = "Mirewort Compress"
	description = "A pungent brown compress liquid extracted from swamp mirewort. Notorious for smelling of stagnant water, it excels at cleansing infected wounds when applied directly to flesh."
	reagent_state = LIQUID
	color = "#556B2F"
	taste_description = "swamp water and rot"
	scent_description = "stagnant bog"
	metabolization_rate = REAGENTS_METABOLISM * 0.5

/datum/reagent/medicine/mirewort_compress/on_bodypart_absorb(obj/item/bodypart/BP, mob/living/carbon/M, amount_to_transfer)
	for(var/datum/injury/injury in BP.injuries)
		injury.adjust_germ_level(-20)
	BP.disinfect_limb(3 MINUTES)
	BP.adjust_germ_level(-25)

/datum/reagent/medicine/mirewort_compress/on_mob_life(mob/living/carbon/M, efficiency)
	if(volume > 0.99)
		M.adjustToxLoss(1 * efficiency, 0)
	. = ..()

/datum/reagent/medicine/woundwrack_oil
	name = "Woundwrack Oil"
	description = "An oily amber extract from the woundwrack tree's bark. Applied to open wounds, it dramatically accelerates natural clotting and closes lacerations, but does nothing when absorbed internally."
	reagent_state = LIQUID
	color = "#C8860A"
	taste_description = "tree bark and pine"
	scent_description = "resinous amber"
	metabolization_rate = REAGENTS_METABOLISM

/datum/reagent/medicine/woundwrack_oil/on_bodypart_absorb(obj/item/bodypart/BP, mob/living/carbon/M, amount_to_transfer)
	for(var/datum/injury/injury in BP.injuries)
		if(injury.damage_type == WOUND_DIVINE)
			continue
		injury.heal_damage(2)
		injury.salve_injury()
	BP.adjust_germ_level(-10)

/datum/reagent/medicine/woundwrack_oil/on_mob_life(mob/living/carbon/M, efficiency)
	if(volume > 0.99)
		M.adjustBruteLoss(-0.25 * REM * efficiency, 0)
	. = ..()

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

/datum/reagent/medicine/pale_serum/on_mob_life(mob/living/carbon/M, efficiency)
	if(volume > 0.99)
		M.adjustOrganLoss(ORGAN_SLOT_BRAIN, -3 * REM * efficiency, 150)
		M.adjustOrganLoss(ORGAN_SLOT_EYES, -2 * REM * efficiency, 150)
		M.adjustCloneLoss(-1 * REM * efficiency, 0)
	. = ..()

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

/datum/reagent/medicine/spiritwood_elixir/on_mob_life(mob/living/carbon/M, efficiency)
	if(volume > 0.99)
		M.adjustBruteLoss(-2.5 * REM * efficiency, 0)
		M.adjustFireLoss(-2.5 * REM * efficiency, 0)
		var/list/wCount = M.get_wounds()
		if(wCount.len > 0)
			M.heal_wounds(5 * efficiency)
	. = ..()

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

/datum/reagent/medicine/marrowbrew/on_mob_life(mob/living/carbon/M, efficiency)
	if(volume > 0.99)
		M.adjustBruteLoss(-0.75 * REM * efficiency, 0)
		M.adjustFireLoss(-0.75 * REM * efficiency, 0)
		M.adjustToxLoss(-0.5 * efficiency, 0)
		M.adjustOxyLoss(-0.5 * efficiency, 0)
	. = ..()

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

/datum/reagent/medicine/mindclear_tonic/on_mob_life(mob/living/carbon/M, efficiency)
	if(volume > 0.99)
		M.adjustOrganLoss(ORGAN_SLOT_BRAIN, -5 * REM * efficiency, 150)
		M.adjust_confusion(-2 SECONDS * efficiency)
		M.adjust_dizzy(-2 SECONDS * efficiency)
	. = ..()

/datum/reagent/medicine/witchknit_paste
	name = "Witchknit Paste"
	description = "A thick paste mixed by tradition-bound hedgewives. Applied externally, it rapidly closes lacerations and sets broken flesh, named for the legend that it was first made from witch-hair and spider gland."
	reagent_state = LIQUID
	color = "#C0C0C0"
	taste_description = "bitter chalk and herbs"
	scent_description = "dust and old herbs"
	metabolization_rate = REAGENTS_METABOLISM

/datum/reagent/medicine/witchknit_paste/on_bodypart_absorb(obj/item/bodypart/BP, mob/living/carbon/M, amount_to_transfer)
	for(var/datum/injury/injury in BP.injuries)
		if(injury.damage_type == WOUND_DIVINE)
			continue
		injury.heal_damage(1.5)
		injury.salve_injury()
	BP.adjust_germ_level(-15)

/datum/reagent/medicine/witchknit_paste/on_mob_life(mob/living/carbon/M, efficiency)
	if(volume > 0.99)
		M.adjustBruteLoss(-1 * REM * efficiency, 0)
	. = ..()

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

/datum/reagent/medicine/fever_oil/on_mob_life(mob/living/carbon/M, efficiency)
	if(volume > 0.99)
		M.adjustToxLoss(-3 * efficiency, 0)
	if(prob(25))
		M.adjust_dizzy(2 SECONDS * efficiency)
		M.set_jitter(3 SECONDS)
	. = ..()

/datum/reagent/medicine/stonevein_broth
	name = "Stonevein Broth"
	description = "A dense mineral broth reduced from ore-laced spring water. Strengthens the body's resistance to physical trauma by thickening the skin and dense-packing superficial tissue."
	reagent_state = LIQUID
	color = "#A0A0A0"
	taste_description = "mineral brine"
	scent_description = "wet stone"
	metabolization_rate = REAGENTS_METABOLISM * 0.75

/datum/reagent/medicine/stonevein_broth/on_mob_life(mob/living/carbon/M, efficiency)
	if(volume > 0.99)
		M.adjustBruteLoss(-2 * REM * efficiency, 0)
		M.adjustCloneLoss(-1.5 * REM * efficiency, 0)
		var/list/wCount = M.get_wounds()
		if(wCount.len > 0)
			M.heal_wounds(2 * efficiency)
	. = ..()

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

/datum/reagent/medicine/sunpetal_decoction/on_mob_life(mob/living/carbon/M, efficiency)
	if(volume > 0.99)
		M.adjustToxLoss(-2 * efficiency, 0)
		M.adjustBruteLoss(-0.5 * REM * efficiency, 0)
	. = ..()

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

/datum/reagent/medicine/nervebind_extract/on_mob_life(mob/living/carbon/M, efficiency)
	if(prob(15 * efficiency))
		M.adjust_jitter(2 SECONDS * efficiency)
	. = ..()

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

/datum/reagent/medicine/bloodelder_wine/on_mob_life(mob/living/carbon/M, efficiency)
	if(prob(20))
		M.adjust_dizzy(3 SECONDS * efficiency)
	M.adjustOrganLoss(ORGAN_SLOT_HEART, -2 * efficiency)
	. = ..()

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
