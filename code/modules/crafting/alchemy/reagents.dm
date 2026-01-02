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

/datum/reagent/medicine/healthpot/on_mob_life(mob/living/carbon/M)
	if(volume >= 60)
		M.reagents.remove_reagent(/datum/reagent/medicine/healthpot, 2) //No overhealing.
	if(M.blood_volume < BLOOD_VOLUME_NORMAL)
		M.blood_volume = min(M.blood_volume+20, BLOOD_VOLUME_MAXIMUM)
	var/list/wCount = M.get_wounds()
	if(wCount.len > 0)
		M.heal_wounds(3) //at a motabalism of .5 U a tick this translates to 120WHP healing with 20 U Most wounds are unsewn 15-100. This is powerful on single wounds but rapidly weakens at multi wounds.
	if(volume > 0.99)
		M.adjustBruteLoss(-1.75*REM, 0)
		M.adjustFireLoss(-1.75*REM, 0)
		M.adjustOxyLoss(-1.25, 0)
		M.adjustCloneLoss(-1.75*REM, 0)
	if(istype(M, /mob/living/carbon/human/species/werewolf))
		var/mob/living/carbon/human/human = M
		var/obj/item/clothing/werewolf_armor = human.skin_armor
		if(werewolf_armor)
			werewolf_armor.repair_damage(werewolf_armor.max_integrity * 0.01)
	..()

/datum/reagent/medicine/stronghealth
	name = "Strong Health Potion"
	description = "Quickly regenerates all types of damage."
	color = "#820000be"
	taste_description = "rich lifeblood"
	scent_description = "metal"
	metabolization_rate = REAGENTS_METABOLISM * 3

/datum/reagent/medicine/stronghealth/on_mob_life(mob/living/carbon/M)
	if(volume >= 60)
		M.reagents.remove_reagent(/datum/reagent/medicine/stronghealth, 2) //No overhealing.
	if(M.blood_volume < BLOOD_VOLUME_NORMAL)
		M.blood_volume = min(M.blood_volume+80, BLOOD_VOLUME_MAXIMUM)
	else
		//can overfill you with blood, but at a slower rate
		M.blood_volume = min(M.blood_volume+10, BLOOD_VOLUME_MAXIMUM)
	M.heal_wounds(6) //at a motabalism of .5 U a tick this translates to 240WHP healing with 20 U Most wounds are unsewn 15-100.
	if(volume > 0.99)
		M.adjustBruteLoss(-7*REM, 0)
		M.adjustFireLoss(-7*REM, 0)
		M.adjustOxyLoss(-5, 0)
		M.adjustCloneLoss(-7*REM, 0)
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

/datum/reagent/medicine/rosawater/on_mob_life(mob/living/carbon/M)
	. = ..()
	if (M.mob_biotypes & MOB_BEAST)
		M.adjustFireLoss(0.5*REM)
	else
		M.adjustBruteLoss(-0.1*REM)
		M.adjustFireLoss(-0.1*REM)
		M.adjustOxyLoss(-0.1, 0)
		var/list/our_wounds = M.get_wounds()
		if (LAZYLEN(our_wounds))
			var/upd = M.heal_wounds(1)
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

/datum/reagent/medicine/gender_potion/on_mob_life(mob/living/carbon/M)
	if(!istype(M) || M.stat == DEAD)
		to_chat(M, span_warning("The potion can only be used on living things!"))
		return
	if(M.gender != MALE && M.gender != FEMALE)
		to_chat(M, span_warning("The potion can only be used on gendered things!"))
		return
	if(M.gender == MALE)
		M.gender = FEMALE
		M.visible_message(span_boldnotice("[M] suddenly looks more feminine!"), span_boldwarning("You suddenly feel more feminine!"))
	else
		M.gender = MALE
		M.visible_message(span_boldnotice("[M] suddenly looks more masculine!"), span_boldwarning("You suddenly feel more masculine!"))
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

/datum/reagent/medicine/manapot/on_mob_life(mob/living/carbon/M)
	M.mana_pool.adjust_mana(4)
	..()

/datum/reagent/medicine/manapot/weak
	name = "Weak Mana Potion"

/datum/reagent/medicine/manapot/weak/on_mob_life(mob/living/carbon/M)
	M.mana_pool.adjust_mana(2)
	..()

/datum/reagent/medicine/strongmana
	name = "Strong Mana Potion"
	description = "Rapidly regenerates energy."
	color = "#0000ff"
	taste_description = "raw power"
	scent_description = "dry air"
	metabolization_rate = REAGENTS_METABOLISM * 3

/datum/reagent/medicine/strongmana/on_mob_life(mob/living/carbon/M)
	M.mana_pool.adjust_mana(8)
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

/datum/reagent/medicine/stampot/on_mob_life(mob/living/carbon/M)
	if(!HAS_TRAIT(M,TRAIT_NOSTAMINA))
		M.adjust_stamina(-1.5, internal_regen = FALSE)
	..()

/datum/reagent/medicine/strongstam
	name = "Strong Stamina Potion"
	description = "Rapidly regenerates stamina."
	color = "#13df00"
	taste_description = "sparkly static"
	scent_description = "grass"
	metabolization_rate = REAGENTS_METABOLISM * 3

/datum/reagent/medicine/strongstam/on_mob_life(mob/living/carbon/M)
	if(!HAS_TRAIT(M,TRAIT_NOSTAMINA))
		M.adjust_stamina(-6, internal_regen = FALSE)
	..()

/datum/reagent/medicine/antidote
	name = "Poison Antidote"
	description = "Heals damage induced by toxins and poisons."
	reagent_state = LIQUID
	color = "#00ff00"
	taste_description = "sickly sweet"
	scent_description = "rotten cheese"
	metabolization_rate = REAGENTS_METABOLISM

/datum/reagent/medicine/antidote/on_mob_life(mob/living/carbon/M)
	if(volume > 0.99)
		M.adjustToxLoss(-4, 0)
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

/datum/reagent/medicine/diseasecure/on_mob_life(mob/living/carbon/M)
	if(volume > 0.99)
		M.adjustToxLoss(-16, 0)
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

/datum/reagent/buff/strength/on_mob_add(mob/living/carbon/M)
	if(M.has_status_effect(/datum/status_effect/buff/alch/strengthpot))
		return ..()
	if(M.reagents.has_reagent(/datum/reagent/buff/strength, 4))
		M.apply_status_effect(/datum/status_effect/buff/alch/strengthpot)
		M.reagents.remove_reagent(/datum/reagent/buff/strength, M.reagents.get_reagent_amount(/datum/reagent/buff/strength))
	return ..()

/datum/reagent/buff/perception
	name = "Perception"
	color = "#ffff00"
	taste_description = "cat urine"
	scent_description = "urine"

/datum/reagent/buff/perception/on_mob_life(mob/living/carbon/M)
	if(M.has_status_effect(/datum/status_effect/buff/alch/perceptionpot))
		return ..()
	if(M.reagents.has_reagent((/datum/reagent/buff/perception), 4))
		M.apply_status_effect(/datum/status_effect/buff/alch/perceptionpot)
		M.reagents.remove_reagent(/datum/reagent/buff/perception, M.reagents.get_reagent_amount(/datum/reagent/buff/perception))
	return ..()

/datum/reagent/buff/intelligence
	name = "Intelligence"
	color = "#438127"
	taste_description = "bog water"
	scent_description = "moss"

/datum/reagent/buff/intelligence/on_mob_life(mob/living/carbon/M)
	if(M.has_status_effect(/datum/status_effect/buff/alch/intelligencepot))
		return ..()
	if(M.reagents.has_reagent((/datum/reagent/buff/intelligence), 4))
		M.apply_status_effect(/datum/status_effect/buff/alch/intelligencepot)
		M.reagents.remove_reagent(/datum/reagent/buff/intelligence, M.reagents.get_reagent_amount(/datum/reagent/buff/intelligence))
	return ..()

/datum/reagent/buff/constitution
	name = "Constitution"
	color = "#130604"
	taste_description = "acidic bile"
	scent_description = "petrichor"

/datum/reagent/buff/constitution/on_mob_life(mob/living/carbon/M)
	if(M.has_status_effect(/datum/status_effect/buff/alch/constitutionpot))
		return ..()
	if(M.reagents.has_reagent((/datum/reagent/buff/constitution), 4))
		M.apply_status_effect(/datum/status_effect/buff/alch/constitutionpot)
		M.reagents.remove_reagent(/datum/reagent/buff/constitution, M.reagents.get_reagent_amount(/datum/reagent/buff/constitution))
	return ..()

/datum/reagent/buff/endurance
	name = "Endurance"
	color = "#ffff00"
	taste_description = "gote urine"
	scent_description = "urine"

/datum/reagent/buff/endurance/on_mob_life(mob/living/carbon/M)
	if(M.has_status_effect(/datum/status_effect/buff/alch/endurancepot))
		return ..()
	if(M.reagents.has_reagent((/datum/reagent/buff/endurance), 4))
		M.apply_status_effect(/datum/status_effect/buff/alch/endurancepot)
		M.reagents.remove_reagent(/datum/reagent/buff/endurance, M.reagents.get_reagent_amount(/datum/reagent/buff/endurance))
	return ..()

/datum/reagent/buff/speed
	name = "Speed"
	color = "#ffff00"
	taste_description = "raw egg yolk"
	scent_description = "sweat"

/datum/reagent/buff/speed/on_mob_life(mob/living/carbon/M)
	if(M.has_status_effect(/datum/status_effect/buff/alch/speedpot))
		return ..()
	if(M.reagents.has_reagent((/datum/reagent/buff/speed), 4))
		M.apply_status_effect(/datum/status_effect/buff/alch/speedpot)
		M.reagents.remove_reagent(/datum/reagent/buff/speed, M.reagents.get_reagent_amount(/datum/reagent/buff/speed))
	return ..()

/datum/reagent/buff/fortune
	name = "Fortune"
	color = "#ffff00"
	taste_description = "sweet urine"
	scent_description = "urine"

/datum/reagent/buff/fortune/on_mob_life(mob/living/carbon/M)
	if(M.has_status_effect(/datum/status_effect/buff/alch/fortunepot))
		return ..()
	if(M.reagents.has_reagent((/datum/reagent/buff/fortune), 4))
		M.apply_status_effect(/datum/status_effect/buff/alch/fortunepot)
		M.reagents.remove_reagent(/datum/reagent/buff/fortune, M.reagents.get_reagent_amount(/datum/reagent/buff/fortune))
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

/datum/reagent/berrypoison/on_mob_life(mob/living/carbon/M)
	if(volume > 0.09)
		if(HAS_TRAIT(M, TRAIT_POISON_RESILIENCE))
			M.add_nausea(1)
			M.adjustToxLoss(0.5)
		else
			M.add_nausea(3) // so one berry or one dose (one clunk of extracted poison, 5u) will make you really sick and a hair away from crit.
			M.adjustToxLoss(2)
	return ..()


/datum/reagent/strongpoison		// Strong poison, meant to be somewhat difficult to produce using alchemy or spawned with select antags. Designed to kill in one full dose (5u) better drink antidote fast
	name = "Doom Poison"
	description = ""
	reagent_state = LIQUID
	color = "#1a1616"
	random_reagent_color = TRUE
	taste_description = "burning"
	scent_description = "charcoal"
	metabolization_rate = REAGENTS_SLOW_METABOLISM

/datum/reagent/strongpoison/on_mob_life(mob/living/carbon/M)
	if(volume > 0.09)
		if(HAS_TRAIT(M, TRAIT_POISON_RESILIENCE))
			M.add_nausea(1)
			M.adjustToxLoss(2.3)  // will put you just above dying crit treshold
		else
			M.add_nausea(6) //So a poison bolt (2u) will eventually cause puking at least once
			M.adjustToxLoss(4.5) // just enough so 5u will kill you dead with no help
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

/datum/reagent/organpoison/on_mob_life(mob/living/carbon/M)
	if(!HAS_TRAIT(M, TRAIT_NASTY_EATER) && !HAS_TRAIT(M, TRAIT_ORGAN_EATER))
		M.add_nausea(9)
		M.adjustToxLoss(2)
	else
		//it does nothing, so we can just remove it
		M.reagents.remove_reagent(/datum/reagent/organpoison, 1)
	return ..()

/datum/reagent/stampoison
	name = "Stamina Poison"
	description = ""
	reagent_state = LIQUID
	color = "#083b1c"
	random_reagent_color = TRUE
	taste_description = "lint"
	scent_description = "dust"
	metabolization_rate = REAGENTS_SLOW_METABOLISM * 3

/datum/reagent/stampoison/on_mob_life(mob/living/carbon/M)
	if(!HAS_TRAIT(M,TRAIT_NOSTAMINA))
		if(HAS_TRAIT(M, TRAIT_POISON_RESILIENCE))
			M.adjust_stamina(0.75)
		else
			M.adjust_stamina(2.25) //Slowly leech stamina
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

/datum/reagent/strongstampoison/on_mob_life(mob/living/carbon/M)
	if(!HAS_TRAIT(M,TRAIT_NOSTAMINA))
		if(HAS_TRAIT(M, TRAIT_POISON_RESILIENCE))
			M.adjust_stamina(4.5)
		else
			M.adjust_stamina(9) //Rapidly leech stamina
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

/datum/reagent/dreaddeath/on_mob_life(mob/living/carbon/M)
	if(!HAS_TRAIT(M,TRAIT_NOSTAMINA))
		if(HAS_TRAIT(M, TRAIT_POISON_RESILIENCE))
			M.adjust_stamina(5)
		else
			M.adjust_stamina(10)
	if(HAS_TRAIT(M, TRAIT_POISON_RESILIENCE))
		M.adjustToxLoss(3)
	else
		M.adjustToxLoss(6)
	return ..()

/datum/reagent/killersice
	name = "Killer's Ice"
	description = ""
	reagent_state = LIQUID
	color = "#c8c9e9"
	taste_description = "cold needles"
	scent_description = "freezing dust"
	metabolization_rate = REAGENTS_SLOW_METABOLISM

/datum/reagent/killersice/on_mob_life(mob/living/carbon/M)
	if(!HAS_TRAIT(M, TRAIT_NASTY_EATER) && !HAS_TRAIT(M, TRAIT_ORGAN_EATER))
		M.adjustToxLoss(5)
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

/datum/reagent/toxin/fyritiusnectar/on_mob_life(mob/living/carbon/M)
	if(volume > 0.49 && prob(33))
		M.add_nausea(9)
		M.adjustFireLoss(2, 0)
		M.adjust_fire_stacks(1)
		M.IgniteMob()
	return ..()

