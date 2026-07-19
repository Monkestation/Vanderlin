//Potions
/datum/reagent/medicine/healthpot
	name = "Health Potion"
	description = "Gradually regenerates all types of damage."
	reagent_state = LIQUID
	color = "#ff0000"
	taste_description = "lifeblood"
	scent_description = "metal"
	alpha = 173
	liver_chemical = FALSE
	price_per_unit = 0.5

/datum/reagent/medicine/healthpot/on_mob_metabolize(mob/living/L)
	. = ..()
	L.add_chem_effect(CE_BLOODRESTORE, 3, "[type]")
	L.add_chem_effect(CE_STABLE, 1, "[type]")

/datum/reagent/medicine/healthpot/on_mob_end_metabolize(mob/living/L)
	. = ..()
	L.remove_chem_effect(CE_BLOODRESTORE, "[type]")
	L.remove_chem_effect(CE_STABLE, "[type]")

/datum/reagent/medicine/healthpot/on_mob_life(mob/living/carbon/M, efficiency, seconds_per_tick)
	. = ..()

	if(volume < 0.99)
		return

	if(volume >= 60)
		M.remove_reagent(/datum/reagent/medicine/healthpot, 2) //No overhealing.

	M.adjust_blood_volume(1.2 * REAGENTS_MODIFIER, maximum = BLOOD_VOLUME_NORMAL)
	M.heal_wounds(0.6 * REAGENTS_MODIFIER)
	M.adjustOxyLoss(-0.25 * REAGENTS_MODIFIER, FALSE)
	M.adjustCloneLoss(-0.6 * REAGENTS_MODIFIER, FALSE)
	M.adjustBruteLoss(-0.8 * REAGENTS_MODIFIER, FALSE, required_status = BODYPART_ORGANIC)
	M.adjustFireLoss(-0.8 * REAGENTS_MODIFIER, TRUE, required_status = BODYPART_ORGANIC)

	return TRUE

/datum/reagent/medicine/healthpot/on_bodypart_absorb(mob/living/carbon/affected_mob, obj/item/bodypart/affected_bodypart, amount_to_transfer, seconds_per_tick)
	. = ..()

	if(affected_bodypart.heal_damage(0.5 * REM * seconds_per_tick, 0.5 * REM * seconds_per_tick, TRUE, required_status = BODYPART_ORGANIC))
		affected_mob.update_damage_overlays()

/datum/reagent/medicine/stronghealth
	name = "Strong Health Potion"
	description = "Quickly regenerates all types of damage."
	color = "#820000be"
	taste_description = "rich lifeblood"
	scent_description = "metal"
	metabolization_rate = REAGENTS_METABOLISM * 2
	liver_chemical = FALSE
	price_per_unit = 3

/datum/reagent/medicine/stronghealth/on_mob_metabolize(mob/living/L)
	. = ..()
	L.add_chem_effect(CE_BLOODRESTORE, 5, "[type]")
	L.add_chem_effect(CE_STABLE, 1, "[type]")
	L.add_chem_effect(CE_BRAIN_REGEN, 1, "[type]")

/datum/reagent/medicine/stronghealth/on_mob_end_metabolize(mob/living/L)
	. = ..()
	L.remove_chem_effect(CE_BLOODRESTORE, "[type]")
	L.remove_chem_effect(CE_STABLE, "[type]")
	L.remove_chem_effect(CE_BRAIN_REGEN, "[type]")

/datum/reagent/medicine/stronghealth/on_mob_life(mob/living/carbon/M, efficiency, seconds_per_tick)
	. = ..()

	if(volume < 0.99)
		return

	if(volume >= 60)
		M.remove_reagent(/datum/reagent/medicine/stronghealth, 2) //No overhealing.

	M.adjust_blood_volume(2 * REAGENTS_MODIFIER, maximum = BLOOD_VOLUME_NORMAL)
	M.heal_wounds(1.2 * REAGENTS_MODIFIER) //at a motabalism of .5 U a tick this translates to 240WHP healing with 20 U Most wounds are unsewn 15-100.
	M.adjustOxyLoss(-1 * REAGENTS_MODIFIER, FALSE)
	M.adjustCloneLoss(-2.5 * REAGENTS_MODIFIER, FALSE)
	M.adjustBruteLoss(-3.5 * REAGENTS_MODIFIER, FALSE, required_status = BODYPART_ORGANIC)
	M.adjustFireLoss(-3.5 * REAGENTS_MODIFIER, TRUE, required_status = BODYPART_ORGANIC)

	return TRUE

/datum/reagent/medicine/stronghealth/on_bodypart_absorb(mob/living/carbon/affected_mob, obj/item/bodypart/affected_bodypart, amount_to_transfer, seconds_per_tick)
	. = ..()

	if(affected_bodypart.heal_damage(1.5 * REM * seconds_per_tick, 1.5 * REM * seconds_per_tick, TRUE, required_status = BODYPART_ORGANIC))
		affected_mob.update_damage_overlays()

/datum/reagent/medicine/rosawater
	name = "Rosa Water"
	description = "Steeped rose petals with mild regeneration."
	reagent_state = LIQUID
	color = "#f398b6"
	random_reagent_color = FALSE
	taste_description = "floral"
	scent_description = "rosa"
	metabolization_rate = REAGENTS_METABOLISM
	alpha = 173

/datum/reagent/medicine/rosawater/on_mob_life(mob/living/carbon/M, efficiency, seconds_per_tick)
	. = ..()

	if(M.mob_biotypes & MOB_BEAST)
		M.adjustFireLoss(0.25 * REAGENTS_MODIFIER)
		return

	M.adjustBruteLoss(-0.5 * REAGENTS_MODIFIER)
	M.adjustFireLoss(-0.5 * REAGENTS_MODIFIER)
	M.adjustOxyLoss(-0.02 * REAGENTS_MODIFIER)
	M.heal_wounds(0.2 * REAGENTS_MODIFIER)

	return TRUE

/datum/reagent/medicine/gender_potion
	name = "Gender Potion"
	description = "Change the user's gender."
	reagent_state = LIQUID
	color = "#FF33FF"
	taste_description = "raw sweetness"
	scent_description = "flower nectar"
	metabolization_rate = REAGENTS_METABOLISM * 5
	alpha = 173

/datum/reagent/medicine/gender_potion/on_mob_life(mob/living/carbon/M, efficiency, seconds_per_tick)
	. = ..()
	var/old_gender
	if(!istype(M) || M.stat == DEAD)
		to_chat(M, span_warning("The potion can only be used on living things!"))
		return

	if(M.gender != MALE && M.gender != FEMALE)
		to_chat(M, span_warning("The potion can only be used on gendered things!"))
		return

	if(M.gender == MALE)
		old_gender = MALE
		M.gender = FEMALE
		M.visible_message(span_boldnotice("[M] suddenly looks more feminine!"), span_boldwarning("You suddenly feel more feminine!"))
	else
		old_gender = FEMALE
		M.gender = MALE
		M.visible_message(span_boldnotice("[M] suddenly looks more masculine!"), span_boldwarning("You suddenly feel more masculine!"))

	M.dna?.species?.on_gender_update(M, old_gender)
	M.regenerate_icons()

//Someone please remember to change this to actually do mana at some point?
/datum/reagent/medicine/manapot
	name = "Mana Potion"
	description = "Gradually regenerates energy."
	reagent_state = LIQUID
	color = "#000042"
	taste_description = "sweet mana"
	scent_description = "dry air"
	metabolization_rate = REAGENTS_METABOLISM
	alpha = 173
	price_per_unit = 0.5

/datum/reagent/medicine/manapot/on_mob_life(mob/living/carbon/M, efficiency, seconds_per_tick)
	. = ..()
	M.mana_pool.adjust_mana(0.8 * REAGENTS_MODIFIER)

/datum/reagent/medicine/manapot/weak
	name = "Weak Mana Potion"

/datum/reagent/medicine/manapot/weak/on_mob_life(mob/living/carbon/M, efficiency, seconds_per_tick)
	. = ..()
	M.mana_pool.adjust_mana(0.4 * REAGENTS_MODIFIER)

/datum/reagent/medicine/strongmana
	name = "Strong Mana Potion"
	description = "Rapidly regenerates energy."
	color = "#0000ff"
	taste_description = "raw power"
	scent_description = "dry air"
	metabolization_rate = REAGENTS_METABOLISM * 3
	price_per_unit = 3

/datum/reagent/medicine/strongmana/on_mob_life(mob/living/carbon/M, efficiency, seconds_per_tick)
	. = ..()
	M.mana_pool.adjust_mana(1.6 * REAGENTS_MODIFIER)

/datum/reagent/medicine/stampot
	name = "Stamina Potion"
	description = "Gradually regenerates stamina."
	reagent_state = LIQUID
	color = "#129c00"
	taste_description = "sweet tea"
	scent_description = "grass"
	metabolization_rate = REAGENTS_METABOLISM
	alpha = 173
	price_per_unit = 0.5

/datum/reagent/medicine/stampot/on_mob_life(mob/living/carbon/M, efficiency, seconds_per_tick)
	. = ..()
	if(!HAS_TRAIT(M, TRAIT_NOSTAMINA))
		M.adjust_stamina(-0.3 * REAGENTS_MODIFIER, internal_regen = FALSE)

/datum/reagent/medicine/strongstam
	name = "Strong Stamina Potion"
	description = "Rapidly regenerates stamina."
	color = "#13df00"
	taste_description = "sparkly static"
	scent_description = "grass"
	metabolization_rate = REAGENTS_METABOLISM * 3
	price_per_unit = 3

/datum/reagent/medicine/strongstam/on_mob_life(mob/living/carbon/M, efficiency, seconds_per_tick)
	. = ..()
	if(!HAS_TRAIT(M,TRAIT_NOSTAMINA))
		M.adjust_stamina(-1.2 * REAGENTS_MODIFIER, internal_regen = FALSE)

/datum/reagent/medicine/antidote
	name = "Poison Antidote"
	description = "Heals damage induced by toxins and poisons."
	reagent_state = LIQUID
	color = "#00ff00"
	taste_description = "sickly sweet"
	scent_description = "rotten cheese"
	metabolization_rate = REAGENTS_METABOLISM

/datum/reagent/medicine/antidote/on_mob_life(mob/living/carbon/M, efficiency, seconds_per_tick)
	. = ..()

	if(volume < 0.99)
		return

	M.adjustToxLoss(-0.8 * REAGENTS_MODIFIER, 0)

	return TRUE

/datum/reagent/medicine/diseasecure
	name = "Disease Cure"
	description = "Quickly heals damage induced by toxins and poisons."
	reagent_state = LIQUID
	color = "#004200"
	taste_description = "dirt"
	scent_description = "saiga droppings"
	metabolization_rate = REAGENTS_METABOLISM * 3

/datum/reagent/medicine/diseasecure/on_mob_metabolize(mob/living/L)
	. = ..()
	L.add_chem_effect(CE_ANTIBIOTIC, 40, "[type]")

/datum/reagent/medicine/diseasecure/on_mob_end_metabolize(mob/living/L)
	. = ..()
	L.remove_chem_effect(CE_ANTIBIOTIC, "[type]")

/datum/reagent/medicine/diseasecure/on_mob_life(mob/living/carbon/M, efficiency, seconds_per_tick)
	. = ..()

	if(volume < 0.99)
		return

	M.adjustToxLoss(-3.2 * REAGENTS_MODIFIER)

	return TRUE

/datum/reagent/medicine/diseasecure/on_bodypart_absorb(mob/living/carbon/affected_mob, obj/item/bodypart/affected_bodypart, amount_to_transfer, seconds_per_tick)
	. = ..()

	affected_bodypart.disinfect_limb(4 MINUTES * REM * seconds_per_tick)

	for(var/datum/injury/injury in affected_bodypart.injuries)
		injury.adjust_germ_level(-6 * REM * seconds_per_tick)

	affected_bodypart.adjust_germ_level(-6 * REM * seconds_per_tick)

//Buff potions
/datum/reagent/buff
	description = ""
	random_reagent_color = TRUE
	reagent_state = LIQUID
	metabolization_rate = REAGENTS_METABOLISM

/datum/reagent/buff/strength
	name = "Strength"
	color = "#ff9000"
	taste_description = "raw meat"
	scent_description = "sour vomit"

/datum/reagent/buff/strength/on_mob_life(mob/living/carbon/M, efficiency, seconds_per_tick)
	. = ..()

	if(volume > 4 && !M.has_status_effect(/datum/status_effect/buff/alch/strengthpot))
		M.apply_status_effect(/datum/status_effect/buff/alch/strengthpot)

	M.remove_reagent(type, volume)

/datum/reagent/buff/perception
	name = "Perception"
	color = "#ffff00"
	taste_description = "cat urine"
	scent_description = "urine"

/datum/reagent/buff/perception/on_mob_life(mob/living/carbon/M, efficiency, seconds_per_tick)
	. = ..()

	if(volume > 4 && !M.has_status_effect(/datum/status_effect/buff/alch/perceptionpot))
		M.apply_status_effect(/datum/status_effect/buff/alch/perceptionpot)

	M.remove_reagent(type, volume)

/datum/reagent/buff/intelligence
	name = "Intelligence"
	color = "#438127"
	taste_description = "bog water"
	scent_description = "moss"

/datum/reagent/buff/intelligence/on_mob_life(mob/living/carbon/M, efficiency, seconds_per_tick)
	if(volume > 4 && !M.has_status_effect(/datum/status_effect/buff/alch/intelligencepot))
		M.apply_status_effect(/datum/status_effect/buff/alch/intelligencepot)

	. = ..()

	M.remove_reagent(type, volume)

/datum/reagent/buff/constitution
	name = "Constitution"
	color = "#130604"
	taste_description = "acidic bile"
	scent_description = "petrichor"

/datum/reagent/buff/constitution/on_mob_life(mob/living/carbon/M, efficiency, seconds_per_tick)
	. = ..()

	if(volume > 4 && !M.has_status_effect(/datum/status_effect/buff/alch/constitutionpot))
		M.apply_status_effect(/datum/status_effect/buff/alch/constitutionpot)

	M.remove_reagent(type, volume)

/datum/reagent/buff/endurance
	name = "Endurance"
	color = "#ffff00"
	taste_description = "gote urine"
	scent_description = "urine"

/datum/reagent/buff/endurance/on_mob_life(mob/living/carbon/M, efficiency, seconds_per_tick)
	. = ..()

	if(volume > 4 && !M.has_status_effect(/datum/status_effect/buff/alch/endurancepot))
		M.apply_status_effect(/datum/status_effect/buff/alch/endurancepot)

	M.remove_reagent(type, volume)

/datum/reagent/buff/speed
	name = "Speed"
	color = "#ffff00"
	taste_description = "raw egg yolk"
	scent_description = "sweat"

/datum/reagent/buff/speed/on_mob_life(mob/living/carbon/M, efficiency, seconds_per_tick)
	. = ..()

	if(volume > 4 && !M.has_status_effect(/datum/status_effect/buff/alch/speedpot))
		M.apply_status_effect(/datum/status_effect/buff/alch/speedpot)

	M.remove_reagent(type, volume)

/datum/reagent/buff/fortune
	name = "Fortune"
	color = "#ffff00"
	taste_description = "sweet urine"
	scent_description = "urine"

/datum/reagent/buff/fortune/on_mob_life(mob/living/carbon/M, efficiency, seconds_per_tick)
	. = ..()

	if(volume > 4 && !M.has_status_effect(/datum/status_effect/buff/alch/fortunepot))
		M.apply_status_effect(/datum/status_effect/buff/alch/fortunepot)

/datum/reagent/berrypoison	// Weaker poison, balanced to make you wish for death and incapacitate but not kill
	name = "Berry Poison"
	description = ""
	reagent_state = LIQUID
	color = "#47b2e0"
	random_reagent_color = TRUE
	taste_description = "bitterness"
	scent_description = "charcoal"
	metabolization_rate = REAGENTS_METABOLISM / 10
	var/naus = 0.6
	var/tox = 0.4

/datum/reagent/berrypoison/on_mob_life(mob/living/carbon/M, efficiency, seconds_per_tick)
	. = ..()

	if(volume < 0.09)
		return

	if(HAS_TRAIT(M, TRAIT_POISON_RESILIENCE))
		M.add_nausea((tox / 3) * REAGENTS_MODIFIER)
		M.adjustToxLoss((tox / 4) * REAGENTS_MODIFIER)
	else
		M.add_nausea(naus * REAGENTS_MODIFIER)
		M.adjustToxLoss(tox * REAGENTS_MODIFIER)

	return TRUE

/datum/reagent/berrypoison/shroom
	name = "Mushroom Poison"
	color = "#5647e0"
	taste_description = "acidity"
	scent_description = "acrid earthiness"
	naus = 1
	tox = 0.5

/datum/reagent/strongpoison		// Strong poison, meant to be somewhat difficult to produce using alchemy or spawned with select antags. Designed to kill in one full dose (5u) better drink antidote fast
	name = "Doom Poison"
	description = ""
	reagent_state = LIQUID
	color = "#1a1616"
	random_reagent_color = TRUE
	taste_description = "burning"
	scent_description = "charcoal"
	metabolization_rate = REAGENTS_METABOLISM / 10

/datum/reagent/strongpoison/on_mob_life(mob/living/carbon/M, efficiency, seconds_per_tick)
	. = ..()

	if(volume < 0.09)
		return

	if(HAS_TRAIT(M, TRAIT_POISON_RESILIENCE))
		M.add_nausea(0.2 * REAGENTS_MODIFIER)
		M.adjustToxLoss(0.46 * REAGENTS_MODIFIER)  // will put you just above dying crit treshold
	else
		M.add_nausea(1.2 * REAGENTS_MODIFIER) //So a poison bolt (2u) will eventually cause puking at least once
		M.adjustToxLoss(0.9 * REAGENTS_MODIFIER) // just enough so 5u will kill you dead with no help

	return TRUE

/datum/reagent/organpoison
	name = "Organ Poison"
	description = ""
	reagent_state = LIQUID
	color = "#2c1818"
	random_reagent_color = TRUE
	taste_description = "sour meat"
	scent_description = "metal"
	metabolization_rate = REAGENTS_METABOLISM / 10
	var/list/cannibalism_pool = ALL_RACES_LIST

/datum/reagent/organpoison/on_mob_life(mob/living/carbon/M, efficiency, seconds_per_tick)
	. = ..()

	if(!(M.dna?.species?.id in cannibalism_pool))
		return

	if(HAS_TRAIT(M, TRAIT_NOHUNGER))
		return

	if(!HAS_TRAIT(M, TRAIT_NASTY_EATER) && !HAS_TRAIT(M, TRAIT_ORGAN_EATER))
		M.add_nausea(2 * (1 - GET_MOB_ATTRIBUTE_VALUE(M, STAT_CONSTITUTION) / 20) * REAGENTS_MODIFIER)
		M.adjustToxLoss(0.1 * REAGENTS_MODIFIER)

	. = TRUE

	if(!ishuman(M) || ishalforc(M))
		return

	var/mob/living/carbon/human/graggar_lover = M
	var/obj/item/organ/heart/H = graggar_lover.getorganslot(ORGAN_SLOT_HEART)
	if(!istype(H))
		return

	H.graggometer += seconds_per_tick

	switch(H.graggometer)
		if(15 to 30)
			to_chat(graggar_lover, span_warning("Feel... strange..."))
		if(45 to 50)
			to_chat(graggar_lover, span_bloody("Flesh...bone..."))
		if(50 to 59)
			if(SPT_PROB(15, seconds_per_tick))
				to_chat(graggar_lover, span_bloody("More... More..."))
			var/obj/item/bodypart/bp = graggar_lover.get_bodypart()
			bp?.add_pain(4 * REAGENTS_MODIFIER)
			bp?.bodypart_attacked_by(BCLASS_BLUNT, 2.4 * REAGENTS_MODIFIER, null, BODY_ZONE_CHEST, crit_message = FALSE, modifiers = list(CRIT_MOD_CHANCE = -10))
			M.do_jitter_animation(20 * REAGENTS_MODIFIER)
		if(60 to INFINITY)
			M.do_jitter_animation(30 * REAGENTS_MODIFIER)
			M.adjust_jitter(4 SECONDS * REAGENTS_MODIFIER)
			graggar_lover.Paralyze(2 SECONDS * REAGENTS_MODIFIER, TRUE)
			graggar_lover.unequip_everything()
			var/datum/dna/dna_cache = new()
			graggar_lover.dna.copy_dna(dna_cache)
			var/species = /datum/species/halforc
			//if(ishalforc(M)) // when this works it can be used
			//	species = /datum/species/orc
			//else if(iskobold(M))
			//	species = /datum/species/goblin
			graggar_lover.set_species(species)
			if(ishalforc(graggar_lover))
				dna_cache.transfer_identity(graggar_lover, FALSE)
			graggar_lover.real_name = dna_cache.real_name
			graggar_lover.bloody_hands++
			graggar_lover.update_inv_gloves()
			playsound(graggar_lover, pick('sound/combat/gib (1).ogg','sound/combat/gib (2).ogg'), 100, FALSE, 3)
			graggar_lover.spawn_gibs(TRUE)
			graggar_lover.emote("agony")
			graggar_lover.visible_message(span_danger("[graggar_lover]'s skin bursts!"), span_userdanger("MY SKIN BURSTS!!"))
			INVOKE_ASYNC(graggar_lover, TYPE_PROC_REF(/mob/living/carbon/human, graggar_baptize))
			H.graggometer = 0

/mob/living/carbon/human/proc/graggar_baptize()
	var/answer = tgui_alert(src, "Kneel before Graggar?", "BAPTIZE", DEFAULT_INPUT_CHOICES, 10 SECONDS)
	if(!answer || QDELETED(src))
		return

	if(answer != CHOICE_YES)
		to_chat(src, span_bloody("You reject Graggar's offer of power. The Beast recedes, your stomach growls..."))
		return

	set_patron(/datum/patron/inhumen/graggar)
	to_chat(src, SPAN_GOD_GRAGGAR("The Beast's teeth close around your heart! Devour! Conquer! Graggar!"))

/datum/reagent/organpoison/human
	name = "Humen Organ Poison"
	cannibalism_pool = SPECIES_CANNIBAL_MEN

/datum/reagent/organpoison/kobold
	name = "Kobold Organ Poison"
	cannibalism_pool = SPECIES_CANNIBALISM_KOBOLD

/datum/reagent/stampoison
	name = "Stamina Poison"
	description = ""
	reagent_state = LIQUID
	color = "#083b1c"
	random_reagent_color = TRUE
	taste_description = "lint"
	scent_description = "dust"
	metabolization_rate = REAGENTS_METABOLISM * 0.3

/datum/reagent/stampoison/on_mob_life(mob/living/carbon/M, efficiency, seconds_per_tick)
	. = ..()
	if(!HAS_TRAIT(M,TRAIT_NOSTAMINA))
		if(HAS_TRAIT(M, TRAIT_POISON_RESILIENCE))
			M.adjust_stamina(0.15 * REAGENTS_MODIFIER)
		else
			M.adjust_stamina(0.45 * REAGENTS_MODIFIER) //Slowly leech stamina

/datum/reagent/strongstampoison
	name = "Strong Stamina Poison"
	description = ""
	reagent_state = LIQUID
	color = "#041d0e"
	random_reagent_color = TRUE
	taste_description = "frozen air"
	scent_description = "freezing dust"
	metabolization_rate = REAGENTS_METABOLISM * 0.9

/datum/reagent/strongstampoison/on_mob_life(mob/living/carbon/M, efficiency, seconds_per_tick)
	. = ..()
	if(!HAS_TRAIT(M,TRAIT_NOSTAMINA))
		if(HAS_TRAIT(M, TRAIT_POISON_RESILIENCE))
			M.adjust_stamina(0.9 * REAGENTS_MODIFIER)
		else
			M.adjust_stamina(1.8 * REAGENTS_MODIFIER) //Slowly leech stamina

//a combination of strong stamina and doom poison
//THIS SHOULDN'T BE SPAWNABLE, LEAVE IT CRAFT ONLY
//If you do think this should be spawnable, make it spawn in INCREDIBLY small amounts
//reminder this is incredibly potent, the poison to out poison anyone, this the shit that killed Psydon
/datum/reagent/dreaddeath
	name = "Dread Death"
	description = "A terribly potent poison."
	reagent_state = LIQUID
	color = "#0e0004"
	random_reagent_color = TRUE
	taste_description = "the end"
	scent_description = "nothing"
	metabolization_rate = REAGENTS_METABOLISM * 0.5

/datum/reagent/dreaddeath/on_mob_life(mob/living/carbon/M, efficiency, seconds_per_tick)
	. = ..()

	if(!HAS_TRAIT(M,TRAIT_NOSTAMINA))
		if(HAS_TRAIT(M, TRAIT_POISON_RESILIENCE))
			M.adjust_stamina(1 * REAGENTS_MODIFIER)
		else
			M.adjust_stamina(2 * REAGENTS_MODIFIER)

	if(HAS_TRAIT(M, TRAIT_POISON_RESILIENCE))
		M.adjustToxLoss(0.6 * REAGENTS_MODIFIER)
	else
		M.adjustToxLoss(1.2 * REAGENTS_MODIFIER)

	if(HAS_TRAIT(M, TRAIT_POISON_RESILIENCE))
		M.adjustOxyLoss(0.2 * REAGENTS_MODIFIER)
	else
		M.adjustOxyLoss(0.4 * REAGENTS_MODIFIER)

	return TRUE

/datum/reagent/killersice
	name = "Killer's Ice"
	description = ""
	reagent_state = LIQUID
	color = "#c8c9e9"
	taste_description = "cold needles"
	scent_description = "freezing dust"
	metabolization_rate = REAGENTS_METABOLISM / 10

/datum/reagent/killersice/on_mob_life(mob/living/carbon/M, efficiency, seconds_per_tick)
	. = ..()

	if(!HAS_TRAIT(M, TRAIT_NASTY_EATER) && !HAS_TRAIT(M, TRAIT_ORGAN_EATER))
		M.adjustToxLoss(1 * REAGENTS_MODIFIER)

	return TRUE

/datum/reagent/drowsbane
	name = "Drowsbane"
	description = ""
	reagent_state = LIQUID
	color = "#810e0e"
	taste_description = "each tastebud individually burning to a crisp"
	scent_description = "brimstone"
	metabolization_rate = REAGENTS_METABOLISM / 10
	var/tox = 0.2
	var/oxy = 1

/datum/reagent/drowsbane/on_mob_life(mob/living/carbon/M, efficiency, seconds_per_tick)
	. = ..()

	if(volume <  0.09)
		return

	if(istiefling(M))
		M.adjustBruteLoss(-0.2 * REAGENTS_MODIFIER)
		M.adjustFireLoss(-0.2 * REAGENTS_MODIFIER)
		if(volume >= 25)
			M.remove_reagent(/datum/reagent/drowsbane, 1 * REAGENTS_MODIFIER) //Incase you eat like, five drowsbane clusters to get infinite healing.
		if(SPT_PROB(5, seconds_per_tick))
			to_chat(M, span_notice("Something inside me burns, it's rejuvenating!"))
	else if(isdarkelf(M) || ishalfdrow(M))
		M.adjustToxLoss(tox * REAGENTS_MODIFIER)
		M.adjustOxyLoss(oxy * REAGENTS_MODIFIER) //For dark elves this should be lethal if you take 5u or more. Don't eat spicy food. Relatively harmless in lower amounts because it heals itself.
		if(SPT_PROB(5, seconds_per_tick))
			M.adjust_eye_blur(0.8 SECONDS * REAGENTS_MODIFIER)
			to_chat(M, span_warning("My eyes water..."))
			M.emote("cough")
		if(SPT_PROB(5, seconds_per_tick))
			M.emote("gasp")
			to_chat(M, span_warning("My throat feels like it's on fire!"))
	else
		M.adjustOxyLoss((oxy / 2) * REAGENTS_MODIFIER) //This should mean 10u puts you right on the edge of crit
		if(SPT_PROB(5, seconds_per_tick))
			to_chat(M, span_warning("My tongue feels like its on fire!"))
		if(volume > 5)
			if(SPT_PROB(5, seconds_per_tick))
				M.adjust_eye_blur(0.8 SECONDS * REAGENTS_MODIFIER)
				to_chat(M, span_warning("My eyes water..."))
				M.emote("cough")
			if(SPT_PROB(5, seconds_per_tick))
				M.emote("gasp")
				to_chat(M, span_warning("My throat feels like it's on fire!"))
		if(SPT_PROB(2.5, seconds_per_tick))
			to_chat(M, span_warning("My tongue feels like its on fire!"))

/*----------\
|Ingredients|
\----------*/
/datum/reagent/undeadash
	name = "Spectral Powder"
	description = ""
	reagent_state = SOLID
	color = "#330066"
	taste_description = "tombstones"
	scent_description = "dust"
	metabolization_rate = 0.1

/datum/reagent/toxin/fyritiusnectar
	name = "fyritius nectar"
	description = "oh no"
	reagent_state = LIQUID
	color = "#ffc400"
	metabolization_rate = 0.5
	boiling_point = T0C + 95

/datum/reagent/toxin/fyritiusnectar/on_mob_life(mob/living/carbon/M, efficiency, seconds_per_tick)
	. = ..()

	if(volume > 0.49)
		return

	if(!SPT_PROB(17, seconds_per_tick))
		return

	M.add_nausea(1.8 * REAGENTS_MODIFIER)
	M.adjustFireLoss(0.4 * REAGENTS_MODIFIER)
	M.adjust_fire_stacks(0.2 * REAGENTS_MODIFIER)
	M.IgniteMob()

	return TRUE

// "Second wind" reagent generated when someone suffers a wound. Epinephrine, adrenaline, and stimulants are all already taken so here we are
/datum/reagent/adrenaline
	name = "Adrenaline"
	description = "Adrenaline is a hormone used as a drug to treat cardiac arrest and other cardiac dysrhythmias resulting in diminished or absent cardiac output."
	taste_description = "rush"
	reagent_state = LIQUID
	metabolization_rate = 0.5 * REAGENTS_METABOLISM
	color = "#c8a5dc"
	self_consuming = TRUE

/datum/reagent/adrenaline/on_mob_metabolize(mob/living/L)
	. = ..()
	L.add_chem_effect(CE_BLOODRESTORE, 1, "[type]")
	L.add_chem_effect(CE_STIMULANT, 1, "[type]")
	L.add_chem_effect(CE_PULSE, 1, "[type]")
	L.add_chem_effect(CE_PAINKILLER, min(3*holder.get_reagent_amount(/datum/reagent/adrenaline), 10), "[type]")

/datum/reagent/adrenaline/on_mob_end_metabolize(mob/living/carbon/M)
	. = ..()
	M.remove_chem_effect(CE_BLOODRESTORE, "[type]")
	M.remove_chem_effect(CE_STIMULANT, "[type]")
	M.remove_chem_effect(CE_PULSE, "[type]")
	M.remove_chem_effect(CE_PAINKILLER, "[type]")


//Naturally synthesized painkiller, similar to epinephrine
/datum/reagent/medicine/endorphin
	name = "Endorphin"
	description = "Endorphins are chemically similar to morphine, but naturally synthesized by the human body. \
				They are typically produced as a bodily response to pain, but can also be produced under favorable circumstances. \
				Overdosing will cause drowsyness and jitteriness."
	reagent_state = LIQUID
	color = "#ff799679"
	metabolization_rate = 0.5 * REAGENTS_METABOLISM
	overdose_threshold = 30
	taste_description = "euphoria"

/datum/reagent/medicine/endorphin/on_mob_metabolize(mob/living/carbon/M)
	. = ..()
	M.add_chem_effect(CE_PAINKILLER, 20, "[type]")

/datum/reagent/medicine/endorphin/on_mob_end_metabolize(mob/living/carbon/M)
	. = ..()
	M.remove_chem_effect(CE_PAINKILLER, "[type]")

/datum/reagent/medicine/endorphin/overdose_start(mob/living/M)
	to_chat(M, span_userdanger("I feel EUPHORIC!"))

/datum/reagent/medicine/endorphin/overdose_process(mob/living/M, efficiency, seconds_per_tick)
	. = ..()
	if(SPT_PROB(22, seconds_per_tick))
		M.adjust_drowsiness(1 * REAGENTS_MODIFIER)
	if(SPT_PROB(10, seconds_per_tick))
		M.adjust_disgust(1 * REAGENTS_MODIFIER)
	M.adjust_jitter(0.2 SECONDS * REAGENTS_MODIFIER)
