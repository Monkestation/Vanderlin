/datum/reagent/consumable/milk
	name = "Milk"
	description = "An opaque white liquid produced by the mammary glands of mammals."
	color = "#DFDFDF" // rgb: 223, 223, 223
	taste_description = "milk"
	glass_icon_state = "glass_white"
	glass_name = "glass of milk"
	glass_desc = ""

/datum/reagent/consumable/milk/on_mob_life(mob/living/carbon/M)
	if(M.getBruteLoss() && prob(20))
		M.heal_bodypart_damage(1,0, 0)
		. = 1
	if(ishuman(M))
		var/mob/living/carbon/human/H = M
		if(!HAS_TRAIT(H, TRAIT_NOHUNGER))
			H.adjust_hydration(10)
		if(H.blood_volume < BLOOD_VOLUME_NORMAL)
			H.blood_volume = min(H.blood_volume+15, BLOOD_VOLUME_NORMAL)
	..()


/datum/reagent/consumable/coffee
	name = "Coffee"
	description = "Coffee is a brewed drink prepared from roasted seeds, commonly called coffee beans, of the coffee plant."
	color = "#482000" // rgb: 72, 32, 0
	nutriment_factor = 0
	overdose_threshold = 80
	taste_description = "bitterness"
	glass_icon_state = "glass_brown"
	glass_name = "glass of coffee"
	glass_desc = ""

/datum/reagent/consumable/coffee/overdose_process(mob/living/M)
	M.adjust_jitter(5 SECONDS)
	..()

/datum/reagent/consumable/coffee/on_mob_life(mob/living/carbon/M)
	M.adjust_drowsiness(-10 SECONDS)
	M.adjust_drowsiness(-6 SECONDS)
	M.AdjustSleeping(-4 SECONDS)
	M.adjust_bodytemperature(2, 0, BODYTEMP_NORMAL)
	..()
	. = 1

/datum/reagent/consumable/ice
	name = "Ice"
	description = "Frozen water, your dentist wouldn't like you chewing this."
	reagent_state = SOLID
	color = "#619494" // rgb: 97, 148, 148
	taste_description = "ice"
	glass_icon_state = "iceglass"
	glass_name = "glass of ice"
	glass_desc = ""

/datum/reagent/consumable/ice/on_mob_life(mob/living/carbon/M)
	M.adjust_bodytemperature(-2 * TEMPERATURE_DAMAGE_COEFFICIENT, BODYTEMP_NORMAL)
	..()

/datum/reagent/consumable/golden_calendula_tea
	name = "Golden Calendula Tea"
	description = "A refreshing tea, great to soothe wounds and relieve fatigue."
	color = "#b38e17"

/datum/reagent/consumable/golden_calendula_tea/on_mob_life(mob/living/carbon/M)
	if(!HAS_TRAIT(M,TRAIT_NOSTAMINA))
		M.adjust_stamina(-0.5, internal_regen = FALSE)
	if(M.blood_volume < BLOOD_VOLUME_NORMAL)
		M.blood_volume = min(M.blood_volume+5, BLOOD_VOLUME_MAXIMUM)
	var/list/wCount = M.get_wounds()
	if(wCount.len > 0)
		M.heal_wounds(1) //at a motabalism of .5 U a tick this translates to 120WHP healing with 20 U Most wounds are unsewn 15-100. This is powerful on single wounds but rapidly weakens at multi wounds.
	if(volume > 0.99)
		M.adjustBruteLoss(-0.75*REM, 0)
		M.adjustFireLoss(-0.75*REM, 0)
		M.adjustOxyLoss(-0.25, 0)
		M.adjustOrganLoss(ORGAN_SLOT_BRAIN, -1*REM)
		M.adjustCloneLoss(-0.75*REM, 0)
	..()

/datum/reagent/consumable/soothing_valerian_tea
	name = "Soothing Valerin Tea"
	description = "A refreshing tea, great to ease fatigue and relieve stress."
	color = "#3b9146"
	quality = DRINK_FANTASTIC

/datum/reagent/consumable/soothing_valerian_tea/on_mob_life(mob/living/carbon/M)
	if(!HAS_TRAIT(M,TRAIT_NOSTAMINA))
		M.adjust_stamina(-0.3, internal_regen = FALSE)
	..()

/datum/reagent/consumable/caffeine
	name = "Caffeine"
	description = "Why are you seeing this?"
	hydration_factor = 5
	overdose_threshold = 60

/datum/reagent/consumable/caffeine/on_mob_life(mob/living/carbon/M)
	. = ..()
	M.adjust_stamina(-5)
	M.apply_status_effect(/datum/status_effect/buff/vigor)

/datum/reagent/consumable/caffeine/overdose_process(mob/living/carbon/M)
	. = ..()
	M.adjust_jitter(4 SECONDS)
	if(prob(5))
		M.heart_attack()

/datum/reagent/consumable/caffeine/coffee
	name = "Coffee"
	description = "Coffee beans brewed into a hot drink. With a hint of bitterness. Rejuvenating."
	reagent_state = LIQUID
	color = "#482000"
	taste_description = "caramelized bitterness" // coffee has so many flavors I am going for one
	metabolization_rate = REAGENTS_METABOLISM
	alpha = 173
	quality = DRINK_GOOD

/datum/reagent/consumable/caffeine/tea
	name = "Exotic Tea"
	description = "Tea leaves brewed into a hot drink. Slight hint of bitterness. Smooth."
	reagent_state = LIQUID
	color = "#508141" // Deeper green to make it look better
	taste_description = "smooth grassiness" // Yeah, uh.
	metabolization_rate = REAGENTS_METABOLISM
	alpha = 173
	quality = DRINK_GOOD
