
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

/datum/reagent/toxin/plasma
	name = "Plasma"
	description = "Plasma in its liquid form."
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
		C.adjustBruteLoss(min(6*toxpwr, reac_volume * toxpwr))
		return
	if(method & INJECT)
		C.adjustBruteLoss(1.5 * min(6*toxpwr, reac_volume * toxpwr))
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
