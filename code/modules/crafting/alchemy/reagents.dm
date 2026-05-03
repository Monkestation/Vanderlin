//Potions
/datum/reagent/medicine/healthpot
	name = "Health Potion"
	description = "Gradually regenerates all types of damage."
	reagent_state = LIQUID
	color = "#ff0000"
	taste_description = "lifeblood"
	scent_description = "metal"
	metabolization_rate = REAGENTS_METABOLISM
	alpha = 173

/datum/reagent/medicine/healthpot/on_bodypart_absorb(obj/item/bodypart/bodypart, mob/living/carbon/M, amount_to_transfer)
	for(var/datum/injury/injury in bodypart.injuries)
		if(injury.damage_type == WOUND_DIVINE)
			continue
		injury.heal_damage(1)

/datum/reagent/consumable/healthpot/on_mob_metabolize(mob/living/L)
	. = ..()
	L.add_chem_effect(CE_BLOODRESTORE, 5, "[type]")
	L.add_chem_effect(CE_STABLE, 1, "[type]")

/datum/reagent/consumable/healthpot/on_mob_end_metabolize(mob/living/L)
	. = ..()
	L.remove_chem_effect(CE_BLOODRESTORE, "[type]")
	L.remove_chem_effect(CE_STABLE, "[type]")

/datum/reagent/medicine/healthpot/on_mob_life(mob/living/carbon/M, efficiency)
	if(volume >= 60)
		M.remove_reagent(/datum/reagent/medicine/healthpot, 2) //No overhealing.
	var/list/wCount = M.get_wounds()
	if(wCount.len > 0)
		M.heal_wounds(3 * efficiency) //at a motabalism of .5 U a tick this translates to 120WHP healing with 20 U Most wounds are unsewn 15-100. This is powerful on single wounds but rapidly weakens at multi wounds.
	if(volume > 0.99)
		M.adjustBruteLoss(-1.75*REM * efficiency, 0)
		M.adjustFireLoss(-1.75*REM * efficiency, 0)
		M.adjustOxyLoss(-1.25 * efficiency, 0)
		M.adjustCloneLoss(-1.75*REM * efficiency, 0)
	..()

/datum/reagent/medicine/stronghealth
	name = "Strong Health Potion"
	description = "Quickly regenerates all types of damage."
	color = "#820000be"
	taste_description = "rich lifeblood"
	scent_description = "metal"
	metabolization_rate = REAGENTS_METABOLISM * 3

/datum/reagent/medicine/healthpot/on_bodypart_absorb(obj/item/bodypart/bodypart, mob/living/carbon/M, amount_to_transfer)
	for(var/datum/injury/injury in bodypart.injuries)
		if(injury.damage_type == WOUND_DIVINE)
			continue
		injury.heal_damage(2)
	for(var/datum/wound/wound in bodypart.wounds)
		wound.heal_wound(2)

/datum/reagent/consumable/stronghealth/on_mob_metabolize(mob/living/L)
	. = ..()
	L.add_chem_effect(CE_BLOODRESTORE, 30, "[type]")
	L.add_chem_effect(CE_STABLE, 1, "[type]")
	L.add_chem_effect(CE_BRAIN_REGEN, 1, "[type]")

/datum/reagent/consumable/stronghealth/on_mob_end_metabolize(mob/living/L)
	. = ..()
	L.remove_chem_effect(CE_BLOODRESTORE, "[type]")
	L.remove_chem_effect(CE_STABLE, "[type]")
	L.remove_chem_effect(CE_BRAIN_REGEN, "[type]")

/datum/reagent/medicine/stronghealth/on_mob_life(mob/living/carbon/M, efficiency)
	if(volume >= 60)
		M.remove_reagent(/datum/reagent/medicine/stronghealth, 2) //No overhealing.
	M.heal_wounds(6 * efficiency) //at a motabalism of .5 U a tick this translates to 240WHP healing with 20 U Most wounds are unsewn 15-100.
	if(volume > 0.99)
		M.adjustBruteLoss(-7*REM * efficiency, 0)
		M.adjustFireLoss(-7*REM * efficiency, 0)
		M.adjustOxyLoss(-5 * efficiency, 0)
		M.adjustCloneLoss(-7*REM * efficiency, 0)
	..()
	. = 1

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

/datum/reagent/medicine/rosawater/on_mob_life(mob/living/carbon/M, efficiency)
	. = ..()
	if (M.mob_biotypes & MOB_BEAST)
		M.adjustFireLoss(0.5*REM * efficiency)
	else
		M.adjustBruteLoss(-0.1*REM * efficiency)
		M.adjustFireLoss(-0.1*REM * efficiency)
		M.adjustOxyLoss(-0.1 * efficiency, 0)
		var/list/our_wounds = M.get_wounds()
		if (LAZYLEN(our_wounds))
			var/upd = M.heal_wounds(1 * efficiency)
			if (upd)
				M.update_damage_overlays()

/datum/reagent/medicine/gender_potion
	name = "Gender Potion"
	description = "Change the user's gender."
	reagent_state = LIQUID
	color = "#FF33FF"
	taste_description = "raw sweetness"
	scent_description = "flower nectar"
	metabolization_rate = REAGENTS_METABOLISM * 5
	alpha = 173

/datum/reagent/medicine/gender_potion/on_mob_life(mob/living/carbon/M, efficiency)
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
	..()

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

/datum/reagent/medicine/manapot/on_mob_life(mob/living/carbon/M, efficiency)
	M.mana_pool.adjust_mana(4 * efficiency)
	..()

/datum/reagent/medicine/manapot/weak
	name = "Weak Mana Potion"

/datum/reagent/medicine/manapot/weak/on_mob_life(mob/living/carbon/M, efficiency)
	M.mana_pool.adjust_mana(2 * efficiency)
	..()

/datum/reagent/medicine/strongmana
	name = "Strong Mana Potion"
	description = "Rapidly regenerates energy."
	color = "#0000ff"
	taste_description = "raw power"
	scent_description = "dry air"
	metabolization_rate = REAGENTS_METABOLISM * 3

/datum/reagent/medicine/strongmana/on_mob_life(mob/living/carbon/M, efficiency)
	M.mana_pool.adjust_mana(8 * efficiency)
	..()


/datum/reagent/medicine/stampot
	name = "Stamina Potion"
	description = "Gradually regenerates stamina."
	reagent_state = LIQUID
	color = "#129c00"
	taste_description = "sweet tea"
	scent_description = "grass"
	metabolization_rate = REAGENTS_METABOLISM
	alpha = 173

/datum/reagent/medicine/stampot/on_mob_life(mob/living/carbon/M, efficiency)
	if(!HAS_TRAIT(M,TRAIT_NOSTAMINA))
		M.adjust_stamina(-1.5 * efficiency, internal_regen = FALSE)
	..()

/datum/reagent/medicine/strongstam
	name = "Strong Stamina Potion"
	description = "Rapidly regenerates stamina."
	color = "#13df00"
	taste_description = "sparkly static"
	scent_description = "grass"
	metabolization_rate = REAGENTS_METABOLISM * 3

/datum/reagent/medicine/strongstam/on_mob_life(mob/living/carbon/M, efficiency)
	if(!HAS_TRAIT(M,TRAIT_NOSTAMINA))
		M.adjust_stamina(-6 * efficiency, internal_regen = FALSE)
	..()

/datum/reagent/medicine/antidote
	name = "Poison Antidote"
	description = "Heals damage induced by toxins and poisons."
	reagent_state = LIQUID
	color = "#00ff00"
	taste_description = "sickly sweet"
	scent_description = "rotten cheese"
	metabolization_rate = REAGENTS_METABOLISM

/datum/reagent/medicine/antidote/on_mob_life(mob/living/carbon/M, efficiency)
	if(volume > 0.99)
		M.adjustToxLoss(-4 * efficiency, 0)
	..()
	. = 1

/datum/reagent/medicine/diseasecure
	name = "Disease Cure"
	description = "Quickly heals damage induced by toxins and poisons."
	reagent_state = LIQUID
	color = "#004200"
	taste_description = "dirt"
	scent_description = "saiga droppings"
	metabolization_rate = REAGENTS_METABOLISM * 3

/datum/reagent/medicine/diseasecure/on_bodypart_absorb(obj/item/bodypart/BP, mob/living/carbon/M, amount_to_transfer)
	BP.disinfect_limb(20 MINUTES)
	for(var/datum/injury/injury in BP.injuries)
		injury.adjust_germ_level(-30)
	BP.adjust_germ_level(-30)

/datum/reagent/medicine/diseasecure/on_mob_metabolize(mob/living/L)
	. = ..()
	L.add_chem_effect(CE_ANTIBIOTIC, 40, "[type]")

/datum/reagent/medicine/diseasecure/on_mob_end_metabolize(mob/living/L)
	. = ..()
	L.remove_chem_effect(CE_ANTIBIOTIC, "[type]")

/datum/reagent/medicine/diseasecure/on_mob_life(mob/living/carbon/M, efficiency)
	if(volume > 0.99)
		M.adjustToxLoss(-16 * efficiency, 0)
	..()
	. = 1

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

/datum/reagent/buff/strength/on_mob_life(mob/living/carbon/M, efficiency)
	if(M.has_status_effect(/datum/status_effect/buff/alch/strengthpot))
		return ..()
	if(M.has_reagent(/datum/reagent/buff/strength, 4))
		M.apply_status_effect(/datum/status_effect/buff/alch/strengthpot)
		M.remove_reagent(/datum/reagent/buff/strength, M.reagents.get_reagent_amount(/datum/reagent/buff/strength))
	return ..()

/datum/reagent/buff/perception
	name = "Perception"
	color = "#ffff00"
	taste_description = "cat urine"
	scent_description = "urine"

/datum/reagent/buff/perception/on_mob_life(mob/living/carbon/M, efficiency)
	if(M.has_status_effect(/datum/status_effect/buff/alch/perceptionpot))
		return ..()
	if(M.has_reagent((/datum/reagent/buff/perception), 4))
		M.apply_status_effect(/datum/status_effect/buff/alch/perceptionpot)
		M.remove_reagent(/datum/reagent/buff/perception, M.reagents.get_reagent_amount(/datum/reagent/buff/perception))
	return ..()

/datum/reagent/buff/intelligence
	name = "Intelligence"
	color = "#438127"
	taste_description = "bog water"
	scent_description = "moss"

/datum/reagent/buff/intelligence/on_mob_life(mob/living/carbon/M, efficiency)
	if(M.has_status_effect(/datum/status_effect/buff/alch/intelligencepot))
		return ..()
	if(M.has_reagent((/datum/reagent/buff/intelligence), 4))
		M.apply_status_effect(/datum/status_effect/buff/alch/intelligencepot)
		M.remove_reagent(/datum/reagent/buff/intelligence, M.reagents.get_reagent_amount(/datum/reagent/buff/intelligence))
	return ..()

/datum/reagent/buff/constitution
	name = "Constitution"
	color = "#130604"
	taste_description = "acidic bile"
	scent_description = "petrichor"

/datum/reagent/buff/constitution/on_mob_life(mob/living/carbon/M, efficiency)
	if(M.has_status_effect(/datum/status_effect/buff/alch/constitutionpot))
		return ..()
	if(M.has_reagent((/datum/reagent/buff/constitution), 4))
		M.apply_status_effect(/datum/status_effect/buff/alch/constitutionpot)
		M.remove_reagent(/datum/reagent/buff/constitution, M.reagents.get_reagent_amount(/datum/reagent/buff/constitution))
	return ..()

/datum/reagent/buff/endurance
	name = "Endurance"
	color = "#ffff00"
	taste_description = "gote urine"
	scent_description = "urine"

/datum/reagent/buff/endurance/on_mob_life(mob/living/carbon/M, efficiency)
	if(M.has_status_effect(/datum/status_effect/buff/alch/endurancepot))
		return ..()
	if(M.has_reagent((/datum/reagent/buff/endurance), 4))
		M.apply_status_effect(/datum/status_effect/buff/alch/endurancepot)
		M.remove_reagent(/datum/reagent/buff/endurance, M.reagents.get_reagent_amount(/datum/reagent/buff/endurance))
	return ..()

/datum/reagent/buff/speed
	name = "Speed"
	color = "#ffff00"
	taste_description = "raw egg yolk"
	scent_description = "sweat"

/datum/reagent/buff/speed/on_mob_life(mob/living/carbon/M, efficiency)
	if(M.has_status_effect(/datum/status_effect/buff/alch/speedpot))
		return ..()
	if(M.has_reagent((/datum/reagent/buff/speed), 4))
		M.apply_status_effect(/datum/status_effect/buff/alch/speedpot)
		M.remove_reagent(/datum/reagent/buff/speed, M.reagents.get_reagent_amount(/datum/reagent/buff/speed))
	return ..()

/datum/reagent/buff/fortune
	name = "Fortune"
	color = "#ffff00"
	taste_description = "sweet urine"
	scent_description = "urine"

/datum/reagent/buff/fortune/on_mob_life(mob/living/carbon/M, efficiency)
	if(M.has_status_effect(/datum/status_effect/buff/alch/fortunepot))
		return ..()
	if(M.has_reagent((/datum/reagent/buff/fortune), 4))
		M.apply_status_effect(/datum/status_effect/buff/alch/fortunepot)
		M.remove_reagent(/datum/reagent/buff/fortune, M.reagents.get_reagent_amount(/datum/reagent/buff/fortune))
	return ..()


//Poisons
/* Tested this quite a bit. Heres the deal. Metabolism REAGENTS_SLOW_METABOLISM is 0.1 and needs to be that so poison isnt too fast working but
still is dangerous. Toxloss of 3 at metabolism 0.1 puts you in dying early stage then stops for reference of these values.
A dose of ingested potion is defined as 5u, projectile deliver at most 2u, you already do damage with projectile, a bolt can only feasible hold a tiny amount of poison, so much easier to deliver than ingested and so on.
If you want to expand on poisons theres tons of fun effects TG chemistry has that could be added, randomzied damage values for more unpredictable poison, add trait based resists instead of the clunky race check etc.*/

/datum/reagent/berrypoison	// Weaker poison, balanced to make you wish for death and incapacitate but not kill
	name = "Berry Poison"
	description = ""
	reagent_state = LIQUID
	color = "#47b2e0"
	random_reagent_color = TRUE
	taste_description = "bitterness"
	scent_description = "charcoal"
	metabolization_rate = REAGENTS_SLOW_METABOLISM
	var/naus = 3
	var/tox = 2

/datum/reagent/berrypoison/on_mob_life(mob/living/carbon/M, efficiency)
	if(volume > 0.09)
		if(HAS_TRAIT(M, TRAIT_POISON_RESILIENCE))
			M.add_nausea((tox/3) * efficiency)
			M.adjustToxLoss((tox/4) * efficiency)
		else
			M.add_nausea(naus * efficiency)
			M.adjustToxLoss(tox * efficiency)
	return ..()

/datum/reagent/berrypoison/shroom
	name = "Mushroom Poison"
	color = "#5647e0"
	taste_description = "acidity"
	scent_description = "acrid earthiness"
	naus = 5
	tox = 2.5


/datum/reagent/strongpoison		// Strong poison, meant to be somewhat difficult to produce using alchemy or spawned with select antags. Designed to kill in one full dose (5u) better drink antidote fast
	name = "Doom Poison"
	description = ""
	reagent_state = LIQUID
	color = "#1a1616"
	random_reagent_color = TRUE
	taste_description = "burning"
	scent_description = "charcoal"
	metabolization_rate = REAGENTS_SLOW_METABOLISM

/datum/reagent/strongpoison/on_mob_life(mob/living/carbon/M, efficiency)
	if(volume > 0.09)
		if(HAS_TRAIT(M, TRAIT_POISON_RESILIENCE))
			M.add_nausea(1 * efficiency)
			M.adjustToxLoss(2.3 * efficiency)  // will put you just above dying crit treshold
		else
			M.add_nausea(6 * efficiency) //So a poison bolt (2u) will eventually cause puking at least once
			M.adjustToxLoss(4.5 * efficiency) // just enough so 5u will kill you dead with no help
	return ..()

/datum/reagent/organpoison
	name = "Organ Poison"
	description = ""
	reagent_state = LIQUID
	color = "#2c1818"
	random_reagent_color = TRUE
	taste_description = "sour meat"
	scent_description = "metal"
	metabolization_rate = REAGENTS_SLOW_METABOLISM
	var/list/cannibalism_pool = ALL_RACES_LIST

/datum/reagent/organpoison/on_mob_life(mob/living/carbon/M, efficiency)
	if(!(M.dna?.species?.id in cannibalism_pool))
		return ..()
	if(HAS_TRAIT(M, TRAIT_NOHUNGER))
		return ..()
	if(!HAS_TRAIT(M, TRAIT_NASTY_EATER) && !HAS_TRAIT(M, TRAIT_ORGAN_EATER))
		M.add_nausea(10 * (1 - GET_MOB_ATTRIBUTE_VALUE(M, STAT_CONSTITUTION) / 20) * efficiency)
		M.adjustToxLoss(0.5 * efficiency)
	if(ishuman(M) && !ishalforc(M))
		var/mob/living/carbon/human/graggar_lover = M
		var/obj/item/organ/heart/H = graggar_lover.getorganslot(ORGAN_SLOT_HEART)
		if(istype(H))
			H.graggometer++
			switch(H.graggometer)
				if(15, 30)
					to_chat(graggar_lover, span_warning("Feel... strange..."))
				if(45)
					to_chat(graggar_lover, span_bloody("Flesh...bone..."))
				if(50 to 59)
					if(prob(30))
						to_chat(graggar_lover, span_bloody("More... More..."))
					var/obj/item/bodypart/bp = graggar_lover.get_bodypart()
					bp?.add_pain(10 * efficiency)
					bp?.bodypart_attacked_by(BCLASS_BLUNT, 12 * efficiency, null, BODY_ZONE_CHEST, crit_message = FALSE, modifiers = list(CRIT_MOD_CHANCE = -10))
					M.do_jitter_animation(100 * efficiency)
				if(60)
					M.do_jitter_animation(150 * efficiency)
					M.adjust_jitter(20 SECONDS * efficiency)
					graggar_lover.Paralyze(10 SECONDS * efficiency, TRUE)
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
					playsound(get_turf(graggar_lover), pick('sound/combat/gib (1).ogg','sound/combat/gib (2).ogg'), 100, FALSE, 3)
					graggar_lover.spawn_gibs(TRUE)
					graggar_lover.emote("agony")
					graggar_lover.visible_message(span_danger("[graggar_lover]'s skin bursts!"), span_userdanger("MY SKIN BURSTS!!"))
					INVOKE_ASYNC(graggar_lover, TYPE_PROC_REF(/mob/living/carbon/human, graggar_baptize))
					H.graggometer = 0
	return ..()

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
	metabolization_rate = REAGENTS_SLOW_METABOLISM * 3

/datum/reagent/stampoison/on_mob_life(mob/living/carbon/M, efficiency)
	if(!HAS_TRAIT(M,TRAIT_NOSTAMINA))
		if(HAS_TRAIT(M, TRAIT_POISON_RESILIENCE))
			M.adjust_stamina(0.75 * efficiency)
		else
			M.adjust_stamina(2.25 * efficiency) //Slowly leech stamina
	return ..()

/datum/reagent/strongstampoison
	name = "Strong Stamina Poison"
	description = ""
	reagent_state = LIQUID
	color = "#041d0e"
	random_reagent_color = TRUE
	taste_description = "frozen air"
	scent_description = "freezing dust"
	metabolization_rate = REAGENTS_SLOW_METABOLISM * 9

/datum/reagent/strongstampoison/on_mob_life(mob/living/carbon/M, efficiency)
	if(!HAS_TRAIT(M,TRAIT_NOSTAMINA))
		if(HAS_TRAIT(M, TRAIT_POISON_RESILIENCE))
			M.adjust_stamina(4.5 * efficiency)
		else
			M.adjust_stamina(9 * efficiency) //Rapidly leech stamina
	return ..()

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
	metabolization_rate = REAGENTS_SLOW_METABOLISM * 5

/datum/reagent/dreaddeath/on_mob_life(mob/living/carbon/M, efficiency)
	if(!HAS_TRAIT(M,TRAIT_NOSTAMINA))
		if(HAS_TRAIT(M, TRAIT_POISON_RESILIENCE))
			M.adjust_stamina(5 * efficiency)
		else
			M.adjust_stamina(10 * efficiency)
	if(HAS_TRAIT(M, TRAIT_POISON_RESILIENCE))
		M.adjustToxLoss(3 * efficiency)
	else
		M.adjustToxLoss(6 * efficiency)
	if(HAS_TRAIT(M, TRAIT_POISON_RESILIENCE))
		M.adjustOxyLoss(1 * efficiency)
	else
		M.adjustOxyLoss(2 * efficiency)
	return ..()

/datum/reagent/killersice
	name = "Killer's Ice"
	description = ""
	reagent_state = LIQUID
	color = "#c8c9e9"
	taste_description = "cold needles"
	scent_description = "freezing dust"
	metabolization_rate = REAGENTS_SLOW_METABOLISM

/datum/reagent/killersice/on_mob_life(mob/living/carbon/M, efficiency)
	if(!HAS_TRAIT(M, TRAIT_NASTY_EATER) && !HAS_TRAIT(M, TRAIT_ORGAN_EATER))
		M.adjustToxLoss(5 * efficiency)
	return ..()

/datum/reagent/drowsbane
	name = "Drowsbane"
	description = ""
	reagent_state = LIQUID
	color = "#810e0e"
	taste_description = "each tastebud individually burning to a crisp"
	scent_description = "brimstone"
	metabolization_rate = REAGENTS_SLOW_METABOLISM
	var/tox = 1
	var/oxy = 5

/datum/reagent/drowsbane/on_mob_life(mob/living/carbon/M, efficiency)
	if(volume > 0.09)
		if(istiefling(M))
			M.adjustBruteLoss(-1*REM * efficiency)
			M.adjustFireLoss(-1*REM * efficiency)
			if(volume >= 25)
				M.remove_reagent(/datum/reagent/drowsbane, 5 * efficiency) //Incase you eat like, five drowsbane clusters to get infinite healing.
			if(prob(10))
				to_chat(M, span_notice("Something inside me burns, it's rejuvenating!"))
		if(isdarkelf(M) || ishalfdrow(M))
			M.adjustToxLoss(tox * efficiency)
			M.adjustOxyLoss(oxy * efficiency) //For dark elves this should be lethal if you take 5u or more. Don't eat spicy food. Relatively harmless in lower amounts because it heals itself.
			if(prob(10))
				M.adjust_eye_blur(4 SECONDS * efficiency)
				to_chat(M, span_warning("My eyes water..."))
				M.emote("cough")
			if(prob(10))
				M.emote("gasp")
				to_chat(M, span_warning("My throat feels like it's on fire!"))
		else
			M.adjustOxyLoss((oxy/2) * efficiency) //This should mean 10u puts you right on the edge of crit
			if(prob(10))
				to_chat(M, span_warning("My tongue feels like its on fire!"))
			if(volume > 5)
				if(prob(10))
					M.adjust_eye_blur(4 SECONDS * efficiency)
					to_chat(M, span_warning("My eyes water..."))
					M.emote("cough")
				if(prob(10))
					M.emote("gasp")
					to_chat(M, span_warning("My throat feels like it's on fire!"))
			if(prob(5))
				to_chat(M, span_warning("My tongue feels like its on fire!"))
	return ..()

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

/datum/reagent/toxin/fyritiusnectar/on_mob_life(mob/living/carbon/M, efficiency)
	if(volume > 0.49 && prob(33))
		M.add_nausea(9 * efficiency)
		M.adjustFireLoss(2 * efficiency, 0)
		M.adjust_fire_stacks(1 * efficiency)
		M.IgniteMob()
	return ..()

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

/datum/reagent/medicine/endorphin/overdose_process(mob/living/M, delta_time, times_fired)
	. = ..()
	if(DT_PROB(40, delta_time))
		M.adjust_drowsiness(5)
	if(DT_PROB(20, delta_time))
		M.adjust_disgust(5)
	M.adjust_jitter(3)
