
//////////////////////////Poison stuff (Toxins & Acids)///////////////////////

/datum/reagent/toxin
	name = "Toxin"
	description = "A toxic chemical."
	color = "#CF3600" // rgb: 207, 54, 0
	taste_description = "bitterness"
	taste_mult = 1.2
	harmful = TRUE
	var/toxpwr = 1.5
	var/silent_toxin = FALSE //won't produce a pain message when processed by liver/life() if there isn't another non-silent toxin present.

/datum/reagent/toxin/on_mob_life(mob/living/carbon/M, efficiency)
	if(toxpwr)
		M.adjustToxLoss(toxpwr*REM * efficiency, 0)
	return ..()

/datum/reagent/toxin/amatoxin
	name = "Amatoxin"
	description = "A powerful poison derived from certain species of mushroom."
	color = "#792300" // rgb: 121, 35, 0
	toxpwr = 2.5
	taste_description = "mushroom"
	boiling_point = T0C + 120

/datum/reagent/toxin/plasma
	name = "Purple Aetherium"
	description = "A strange liquid, it seems almost... alive."
	taste_description = "bitterness"
	specific_heat = SPECIFIC_HEAT_PLASMA
	taste_mult = 1.5
	color = "#8228A0"
	toxpwr = 3

/datum/reagent/toxin/plasma/reaction_mob(mob/living/M, method=TOUCH, reac_volume)//Splashing people with plasma is stronger than fuel!
	if((method & TOUCH) || (method & VAPOR))
		M.adjust_fire_stacks(reac_volume / 5)
		return
	..()

/datum/reagent/toxin/coffeepowder
	name = "Coffee Grounds"
	description = "Finely ground coffee beans, used to make coffee."
	reagent_state = SOLID
	color = "#5B2E0D" // rgb: 91, 46, 13
	toxpwr = 0.5

/datum/reagent/toxin/teapowder
	name = "Ground Tea Leaves"
	description = "Finely shredded tea leaves, used for making tea."
	reagent_state = SOLID
	color = "#7F8400" // rgb: 127, 132, 0
	toxpwr = 0.1
	taste_description = "green tea"

/datum/reagent/medicine/soporpot
	name = "Soporific Poison"
	description = "Weakens those it enters."
	reagent_state = LIQUID
	color = "#fcefa8"
	taste_description = "drowsyness"
	overdose_threshold = 0
	metabolization_rate = 1 * REAGENTS_METABOLISM
	alpha = 225

/datum/reagent/medicine/soporpot/on_mob_life(mob/living/carbon/M, efficiency)
	M.adjust_confusion(2 SECONDS * efficiency)
	M.adjust_dizzy(2 SECONDS * efficiency)
	M.adjust_energy(-25 * efficiency)
	if(M.stamina > 75)
		M.adjust_drowsiness(4 SECONDS * efficiency)
	else
		M.adjust_stamina(15 * efficiency)
	..()

/datum/reagent/toxin/venom
	name = "Venom"
	description = "An exotic poison extracted from highly toxic fauna. Causes scaling amounts of toxin damage and bruising depending on dosage. Often decays into Histamine."
	reagent_state = LIQUID
	color = "#F0FFF0"
	metabolization_rate = 0.25 * REAGENTS_METABOLISM
	toxpwr = 0

/datum/reagent/toxin/venom/on_mob_life(mob/living/carbon/M, efficiency)
	toxpwr = 0.2*volume * efficiency
	. = 1
	..()

/datum/reagent/toxin/fentanyl
	name = "Fentanyl"
	description = "Fentanyl will inhibit brain function and cause toxin damage before eventually knocking out its victim."
	reagent_state = LIQUID
	color = "#64916E"
	metabolization_rate = 0.5 * REAGENTS_METABOLISM
	toxpwr = 0

/datum/reagent/toxin/fentanyl/on_mob_life(mob/living/carbon/M, efficiency)
	M.adjustOrganLoss(ORGAN_SLOT_BRAIN, 3*REM * efficiency, 150)
	if(M.toxloss <= 60)
		M.adjustToxLoss(1*REM * efficiency, 0)
	if(current_cycle >= 4)
		M.add_stress(/datum/stress_event/narcotic_heavy)
	if(current_cycle >= 18)
		M.Sleeping(40 * efficiency, 0)
	..()
	return TRUE

/datum/reagent/toxin/killersice
	name = "killersice"
	description = "killersice"
	reagent_state = LIQUID
	color = "#FFFFFF"
	metabolization_rate = 0.01
	toxpwr = 0

/datum/reagent/toxin/killersice/on_mob_life(mob/living/carbon/M, efficiency)
	//testing("Someone was poisoned") // This is too gold to remove
	if(volume > 0.95)
		M.adjustToxLoss(10 * efficiency, 0)
	return ..()

/datum/reagent/toxin/bad_food
	name = "Bad Food"
	description = "The result of some abomination of cookery, food so bad it's toxic."
	reagent_state = LIQUID
	color = "#d6d6d8"
	metabolization_rate = 0.25 * REAGENTS_METABOLISM
	toxpwr = 0.25
	taste_description = "bad cooking"


/datum/reagent/toxin/amanitin
	name = "Amanitin"
	description = "A very powerful delayed toxin. Upon full metabolization, a massive amount of toxin damage will be dealt depending on how long it has been in the victim's bloodstream."
	silent_toxin = TRUE
	reagent_state = LIQUID
	color = "#FFFFFF"
	toxpwr = 0
	metabolization_rate = 0.5 * REAGENTS_METABOLISM

/datum/reagent/toxin/amanitin/on_mob_delete(mob/living/M)
	var/toxdamage = current_cycle*3*REM
	M.log_message("has taken [toxdamage] toxin damage from amanitin toxin", LOG_ATTACK)
	M.adjustToxLoss(toxdamage)
	..()

//ACID


/datum/reagent/toxin/acid
	name = "Sulphuric acid"
	description = "A strong mineral acid with the molecular formula H2SO4."
	color = "#00FF32"
	toxpwr = 1
	var/acidpwr = 10 //the amount of protection removed from the armour
	taste_description = "acid"
	self_consuming = TRUE

/datum/reagent/toxin/acid/reaction_mob(mob/living/carbon/C, method=TOUCH, reac_volume)
	if(!istype(C))
		return
	reac_volume = round(reac_volume,0.1)
	if(method & INGEST)
		C.adjustBruteLoss(min(6*toxpwr, reac_volume * toxpwr), damage_type = WOUND_INTERNAL_BRUISE)
		return
	if(method & INJECT)
		C.adjustBruteLoss(1.5 * min(6*toxpwr, reac_volume * toxpwr), damage_type = WOUND_INTERNAL_BRUISE)
		return
	C.acid_act(acidpwr, reac_volume)

	if(method & TOUCH)
		C.try_skin_burn(reac_volume)

/datum/reagent/toxin/acid/reaction_obj(obj/O, reac_volume)
	if(ismob(O.loc)) //handled in human acid_act()
		return
	reac_volume = round(reac_volume,0.1)
	O.acid_act(acidpwr, reac_volume)

/datum/reagent/toxin/acid/reaction_turf(turf/T, reac_volume)
	if (!istype(T))
		return
	reac_volume = round(reac_volume,0.1)
	T.acid_act(acidpwr, reac_volume)

/datum/reagent/toxin/manabloom_juice
	name = "Manabloom Juice"
	description = "A potent mana regeneration extract, it however has the issue of stopping your body's ability to naturally disperse mana."
	glows = TRUE
	color = "#6eb9e4"
	taste_description = "flowers"
	metabolization_rate = 0.1 //this shit will kill you

/datum/reagent/toxin/manabloom_juice/on_mob_metabolize(mob/living/L)
	. = ..()
	if(!L.mana_pool)
		return

	L.mana_pool.halt_mana_disperse("manabloom")

/datum/reagent/toxin/manabloom_juice/on_mob_life(mob/living/carbon/M, efficiency)
	. = ..()
	if(!M.mana_pool)
		return
	M.mana_pool.adjust_mana(volume * efficiency)

/datum/reagent/toxin/manabloom_juice/on_mob_end_metabolize(mob/living/L)
	. = ..()
	if(!L.mana_pool)
		return

	L.mana_pool.restore_mana_disperse("manabloom")


/datum/reagent/toxin/spidervenom_paralytic
	name = "Aragn Essence"
	description = "A strong neurotoxin that makes muscles stiffen up and spasm."
	silent_toxin = TRUE
	reagent_state = SOLID
	color = "#99005e"
	toxpwr = 0
	taste_description = "raspberry"
	metabolization_rate = 0.01
	var/venom_resistance

/obj/item/reagent_containers/glass/bottle/spidervenom_paralytic
	list_reagents = list(/datum/reagent/toxin/spidervenom_paralytic = 1)
	desc = "An ominous vial, filled with venom of the deadly Aragn spider. Feels hot to the touch."

/datum/reagent/toxin/spidervenom_paralytic/on_mob_metabolize(mob/living/L)
	..()
	venom_resistance += ((GET_MOB_ATTRIBUTE_VALUE(L, STAT_CONSTITUTION) - 10) * 5)
	venom_resistance += ((GET_MOB_ATTRIBUTE_VALUE(L, STAT_ENDURANCE) - 10) * 3)
	venom_resistance += ((GET_MOB_ATTRIBUTE_VALUE(L, STAT_STRENGTH) - 10) * 2)
	venom_resistance += (GET_MOB_ATTRIBUTE_VALUE(L, STAT_FORTUNE))

	if(venom_resistance <= 0)
		venom_resistance = 0
		venom_resistance += (GET_MOB_ATTRIBUTE_VALUE(L, STAT_FORTUNE) * 5)

/datum/reagent/toxin/spidervenom_paralytic/on_mob_end_metabolize(mob/living/L)
	..()

/datum/reagent/toxin/spidervenom_paralytic/on_mob_life(mob/living/carbon/M, efficiency)
	..()
	if(!(current_cycle % 5) && !(prob(venom_resistance / 5)))
		M.Paralyze(50 * efficiency)
	if(current_cycle >= 60 && !(current_cycle % 5) && prob(venom_resistance))
		M.reagents.remove_reagent(/datum/reagent/toxin/spidervenom_paralytic, 100)

/datum/reagent/toxin/spidervenom_inert
	name = "Inert Aragn Essence"
	description = "Without the spider, the venom has weakened. It must be strengthened with a binding catalyst first."
	silent_toxin = TRUE
	reagent_state = SOLID
	color = "#003d99"
	toxpwr = 0
	taste_description = "blueberry"
	metabolization_rate = 10

/obj/item/reagent_containers/spidervenom_inert
	list_reagents = list(/datum/reagent/toxin/spidervenom_inert = 10)
	name = "Pale spider gland"
	desc = "A squishy pale gland, filled to the brim with venom of the deadly Aragn spider. Feels cold to the touch."
	icon = 'icons/obj/webbing.dmi'
	icon_state = "gland"

/datum/reagent/poison/mirelung_brew
	name = "Mirelung Brew"
	description = "A vile lung-coating poison used by swamp brigands. It causes the victim to experience respiratory failure over time, as their airways flood with a thick, viscous film mimicking drowning."
	reagent_state = LIQUID
	color = "#3B5323"
	taste_description = "swamp water and bile"
	scent_description = "stagnant water"
	harmful = TRUE
	metabolization_rate = 0.4 * REAGENTS_METABOLISM

/datum/reagent/poison/mirelung_brew/on_mob_life(mob/living/carbon/M, efficiency)
	M.adjustOxyLoss(4 * efficiency, 0)
	M.adjustToxLoss(1 * REM * efficiency, 0)
	if(current_cycle > 6)
		M.adjust_dizzy(3 SECONDS * efficiency)
	. = ..()

/datum/reagent/poison/heatcramp_oil
	name = "Heatcramp Oil"
	description = "Rendered fat, mixed with capsaicin extract. Induces severe involuntary muscle spasms and cramps on absorption, making coordinated movement extremely difficult without dealing significant direct damage."
	reagent_state = LIQUID
	color = "#FF6347"
	taste_description = "unbearable burning"
	scent_description = "cooking flesh and pepper"
	harmful = TRUE
	metabolization_rate = 0.5 * REAGENTS_METABOLISM

/datum/reagent/poison/heatcramp_oil/reaction_mob(mob/living/M, method, reac_volume, show_message, touch_protection)
	. = ..()
	if((method & TOUCH))
		M.set_jitter(10 SECONDS)

/datum/reagent/poison/heatcramp_oil/on_mob_life(mob/living/carbon/M, efficiency)
	M.adjust_jitter(4 SECONDS * efficiency)
	if(!HAS_TRAIT(M, TRAIT_NOSTAMINA))
		M.adjust_stamina(3 * efficiency)
	M.adjustToxLoss(0.75 * REM * efficiency, 0)
	. = ..()

/datum/reagent/poison/blinding_spore
	name = "Blinding Spore"
	description = "Powder from the eyeblight mushroom. Contact with skin or mucous membranes induces temporary blindness and severe eye irritation. Not lethal, but profoundly incapacitating in a fight."
	reagent_state = SOLID
	color = "#F5DEB3"
	taste_description = "choking dust"
	scent_description = "dry fungal spores"
	harmful = TRUE

/datum/reagent/poison/blinding_spore/reaction_mob(mob/living/M, method, reac_volume, show_message, touch_protection)
	. = ..()
	if((method & TOUCH) || (method & VAPOR))
		if(reac_volume >= 3)
			M.adjust_eye_blur(5)
			M.adjust_dizzy(15 SECONDS)
			if(show_message)
				M.visible_message(span_danger("[M] staggers, clutching at their eyes!"), span_userdanger("Your eyes burn and your vision whites out!"))

/datum/reagent/poison/blinding_spore/on_mob_life(mob/living/carbon/M, efficiency)
	M.set_eye_blur_if_lower(4 * efficiency)
	M.adjust_dizzy(2 SECONDS * efficiency)
	M.adjustToxLoss(0.5 * REM * efficiency, 0)
	. = ..()

/datum/reagent/poison/soulbane_ichor
	name = "Soulbane Ichor"
	description = "Black fluid extracted from the remains of a creature that died twice. It is profoundly hostile to the living, dealing damage across all categories simultaneously while interfering with natural healing. Extremely dangerous."
	reagent_state = LIQUID
	color = "#0D0D0D"
	taste_description = "oblivion"
	scent_description = "nothing and death"
	harmful = TRUE
	metabolization_rate = 0.5 * REAGENTS_METABOLISM

/datum/reagent/poison/soulbane_ichor/on_mob_metabolize(mob/living/L)
	. = ..()
	L.add_chem_effect(CE_PULSE, -1, "[type]")
	L.add_chem_effect(CE_BLOODRESTORE, - 2, "[type]")

/datum/reagent/poison/soulbane_ichor/on_mob_metabolize(mob/living/L)
	. = ..()
	L.remove_chem_effect(CE_PULSE, "[type]")
	L.remove_chem_effect(CE_BLOODRESTORE, "[type]")

/datum/reagent/poison/soulbane_ichor/on_mob_life(mob/living/carbon/M, efficiency)
	M.adjustBruteLoss(2 * REM * efficiency, 0)
	M.adjustFireLoss(2 * REM * efficiency, 0)
	M.adjustToxLoss(3 * REM * efficiency, 0)
	M.adjustOxyLoss(1.5 * efficiency, 0)
	. = ..()

/datum/reagent/poison/ironblight
	name = "Ironblight"
	description = "A black liquid that corrodes metal and is devastating against armored targets. Against living flesh it deals modest brute damage, but against those wearing metal armor its vapors eat through joints and fastenings particularly useful against knights."
	reagent_state = LIQUID
	color = "#1C1C1C"
	taste_description = "sharp metal"
	scent_description = "acid and rust"
	harmful = TRUE

/datum/reagent/poison/ironblight/reaction_mob(mob/living/M, method, reac_volume, show_message, touch_protection)
	. = ..()
	if((method & TOUCH) || (method & VAPOR))
		M.adjustBruteLoss(reac_volume * 0.5, 0, damage_type = BCLASS_BLUNT)
		for(var/obj/item/clothing/clothes in get_all_worn_items(M))
			if(!clothes.smeltresult && !clothes.melting_material)
				continue
			if(!ispath(clothes.smeltresult, /obj/item/ingot))
				continue
			clothes.take_damage(reac_volume * 0.25)

/datum/reagent/poison/ironblight/on_mob_life(mob/living/carbon/M, efficiency)
	M.adjustBruteLoss(1.5 * REM * efficiency, 0)
	M.adjustToxLoss(1 * REM * efficiency, 0)
	. = ..()

/datum/reagent/poison/quietdeath
	name = "Quietdeath"
	description = "A slow, tasteless, colorless poison beloved of conspirators and the patient. It provides no warning to the victim, metabolizing silently over hours before delivering a sudden catastrophic organ shutdown."
	reagent_state = LIQUID
	color = "#FFFAFA"
	taste_description = "nothing"
	scent_description = "nothing"
	harmful = TRUE
	metabolization_rate = 0.1 * REAGENTS_METABOLISM
	boiling_point = T0C + 100

/datum/reagent/poison/quietdeath/on_mob_life(mob/living/carbon/M, efficiency)
	// Silent until it detonates
	if(current_cycle < 20)
		return .()
	M.adjustToxLoss(current_cycle * 0.3 * REM * efficiency, 0)
	M.adjustOrganLoss(ORGAN_SLOT_BRAIN, 1 * REM * efficiency, 150)
	. = ..()

/datum/reagent/poison/quietdeath/on_mob_delete(mob/living/M)
	if(current_cycle >= 10)
		M.adjustToxLoss(current_cycle * 0.5)
	. = ..()

/datum/reagent/poison/mirrorwaste
	name = "Mirrorwaste"
	description = "A reflective silvery fluid left over from failed scrying rituals. It does nothing to normal flesh. But against creatures sustained by magic or undeath, it disrupts their essential coherence, dealing significant damage."
	reagent_state = LIQUID
	color = "#C0C0C0"
	taste_description = "metallic nothing"
	scent_description = "still air"
	harmful = TRUE
	boiling_point = T0C + 120

/datum/reagent/poison/mirrorwaste/reaction_mob(mob/living/M, method, reac_volume, show_message, touch_protection)
	. = ..()
	if(M.mob_biotypes & MOB_UNDEAD)
		M.adjustBruteLoss(reac_volume * 1.5, 0, damage_type = BCLASS_LASHING)
		M.adjustFireLoss(reac_volume * 1.5, 0)
		if(show_message)
			M.visible_message(span_danger("[M] writhes as the silvery liquid disrupts their form!"), span_userdanger("The liquid tears at your very existence!"))

/datum/reagent/poison/mirrorwaste/on_mob_life(mob/living/carbon/M, efficiency)
	if(M.mob_biotypes & MOB_UNDEAD)
		M.adjustBruteLoss(4 * REM * efficiency, 0)
		M.adjustToxLoss(3 * REM * efficiency, 0)
	else
		// Minor toxic reaction in normal creatures
		M.adjustToxLoss(0.5 * REM * efficiency, 0)
	. = ..()

/datum/reagent/poison/hexblood_poison
	name = "Hexblood Poison"
	description = "Brewed from cursed blood and wychwood ash. It seeps into wounds on contact, rapidly delivering trauma as it inflames tissue and causes internal hemorrhage. Popular with assassins."
	reagent_state = LIQUID
	color = "#8B0000"
	taste_description = "iron and char"
	scent_description = "burnt copper"
	harmful = TRUE
	metabolization_rate = 0.75 * REAGENTS_METABOLISM

/datum/reagent/poison/hexblood_poison/reaction_mob(mob/living/M, method, reac_volume, show_message, touch_protection)
	. = ..()
	if((method & TOUCH) || (method & VAPOR))
		var/mob/living/carbon/carbon = M
		if(istype(carbon))
			if(!length(carbon.all_injuries))
				return
			for(var/datum/injury/injury as anything in carbon.all_injuries)
				injury.open_injury(reac_volume * 0.25)
				injury.adjust_germ_level(reac_volume)
		else
			M.adjustBruteLoss(reac_volume * 3, 0)

/datum/reagent/poison/rotwater
	name = "Rotwater"
	description = "Contaminated water drawn from a corpse-pit. Drinking it introduces rapidly multiplying bacteria into the bloodstream. It poisons slowly at first, then accelerates the infection compounds upon itself over time."
	reagent_state = LIQUID
	color = "#5D4037"
	taste_description = "fetid water"
	scent_description = "rot and swamp"
	harmful = TRUE
	metabolization_rate = 0.5 * REAGENTS_METABOLISM

/datum/reagent/poison/rotwater/on_mob_metabolize(mob/living/L)
	. = ..()
	L.add_chem_effect(CE_ANTIBIOTIC, -10, "[type]")
	ADD_TRAIT(L, TRAIT_IMMUNITY_CRIPPLED, "[type]")

/datum/reagent/poison/rotwater/on_mob_end_metabolize(mob/living/L)
	. = ..()
	L.remove_chem_effect(CE_ANTIBIOTIC, "[type]")
	REMOVE_TRAIT(L, TRAIT_IMMUNITY_CRIPPLED, "[type]")

/datum/reagent/poison/rotwater/reaction_mob(mob/living/M, method, reac_volume, show_message, touch_protection)
	. = ..()
	if((method & TOUCH) || (method & VAPOR))
		var/mob/living/carbon/carbon = M
		if(istype(carbon))
			if(!length(carbon.all_injuries))
				return
			for(var/datum/injury/injury as anything in carbon.all_injuries)
				if(injury.damage_type == WOUND_DIVINE)
					continue
				injury.adjust_germ_level(reac_volume * 4)

/datum/reagent/poison/rotwater/on_mob_life(mob/living/carbon/M, efficiency)
	var/compound_rate = min(0.5 + (current_cycle * 0.15), 4)
	M.adjustToxLoss(compound_rate * REM * efficiency, 0)
	M.add_nausea(1 * efficiency)
	if(current_cycle > 8)
		M.add_chem_effect(CE_ANTIBIOTIC, -5, "[type]")
	. = ..()

/datum/reagent/poison/gloomvenom
	name = "Gloomvenom"
	description = "Distilled from the glands of gloom-spiders that dwell in lightless caverns. Unlike common venoms it acts on the mind rather than the body, inducing escalating confusion and disorientation before finally causing paralytic toxin buildup."
	reagent_state = LIQUID
	color = "#4A235A"
	taste_description = "musty sweetness"
	scent_description = "damp caves"
	harmful = TRUE
	metabolization_rate = 0.3 * REAGENTS_METABOLISM
	boiling_point = T0C + 110

/datum/reagent/poison/gloomvenom/on_mob_life(mob/living/carbon/M, efficiency)
	M.adjust_confusion(4 SECONDS * efficiency)
	M.adjust_dizzy(3 SECONDS * efficiency)
	if(current_cycle > 5)
		M.adjustOrganLoss(ORGAN_SLOT_BRAIN, 1.5 * REM * efficiency, 150)
	if(current_cycle > 10)
		M.adjustToxLoss(1.5 * REM * efficiency, 0)
	. = ..()

/datum/reagent/poison/ashfall_dust
	name = "Ashfall Dust"
	description = "Powdered remains of a creature scorched by magical fire. Suspended in air or splashed across flesh, the fine particles ignite on contact with warmth, inflicting persistent burn injury. Its touch lingers."
	reagent_state = SOLID
	color = "#696969"
	taste_description = "choking ash"
	scent_description = "burning hair and char"
	harmful = TRUE

/datum/reagent/poison/ashfall_dust/reaction_mob(mob/living/M, method, reac_volume, show_message, touch_protection)
	. = ..()
	if((method & TOUCH) || (method & VAPOR))
		M.adjust_fire_stacks(reac_volume * 0.5)
		M.adjustFireLoss(reac_volume, 0)

/datum/reagent/poison/ashfall_dust/on_mob_life(mob/living/carbon/M, efficiency)
	M.adjustFireLoss(2 * REM * efficiency, 0)
	. = ..()

/datum/reagent/poison/blistergall
	name = "Blistergall"
	description = "A caustic secretion harvested from acid-slugs that nest near hot springs. On contact with flesh it erupts into suppurating blisters, causing severe burn damage. Internal ingestion causes intense toxic damage."
	reagent_state = LIQUID
	color = "#ADFF2F"
	taste_description = "burning acid"
	scent_description = "acidic rot"
	harmful = TRUE

/datum/reagent/poison/blistergall/reaction_mob(mob/living/M, method, reac_volume, show_message, touch_protection)
	. = ..()
	if((method & TOUCH) || (method & VAPOR))
		M.adjustFireLoss(reac_volume * 1.5, 0)
		if(show_message)
			M.visible_message(span_danger("[M]'s skin erupts in blistering welts!"), span_userdanger("Your skin erupts in boiling blisters!"))

/datum/reagent/poison/blistergall/on_mob_life(mob/living/carbon/M, efficiency)
	M.adjustFireLoss(3 * REM * efficiency, 0)
	M.adjustToxLoss(2 * REM * efficiency, 0)
	. = ..()
