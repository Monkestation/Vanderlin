/**
 * The humors, vital building blocks of the humen body.
 *
 * Used as a component of diseases to cause different effects or even cure them, if they are balanced.
 */
/datum/humor
	// Fluff
	var/name = ""
	var/special_name = ""
	var/season = ""
	var/element = ""
	/// Ages that are more affected
	var/list/ages = list()
	/// Selection of "Cold" "Dry" "Warm" "Moist" used for temperature/clothes wetness checks
	var/list/temperaments = list()
	/// Associated organ to check
	var/obj/item/organ/associated_organ = null

/// Warm humors are made worse by cold conditions and viceaversa
/// Dry humors are made worse by wet conditions and viceaversa
/datum/humor/proc/temperament_modifier(mob/living/effecting)
	// Below 1 = bad, Above 1 = good
	var/temperature_mod = 1
	var/wetness_mod = 1

	var/temperature = effecting.bodytemperature
	var/difference = temperature - BODYTEMP_NORMAL

	var/number_wet_items = 0

	if(iscarbon(effecting))
		var/mob/living/carbon/carbon_effecting = effecting
		for(var/obj/item/clothing/clothing in carbon_effecting.get_equipped_items())
			var/datum/wet/wet_datum = clothing.wet
			if(!wet_datum)
				continue
			if(wet_datum.water_stacks > 0)
				number_wet_items++

	for(var/temperament in temperaments)
		switch(temperament)
			if(HUMOR_WARM)
				switch(difference)
					if(15 to INFINITY)
						temperature_mod *= 0.7
					if(10 to 15)
						temperature_mod *= 1.2
					if(5 to 10)
						temperature_mod *= 1.5
					if(-15 to -10)
						temperature_mod *= 0.6
					if(-INFINITY to -15)
						temperature_mod *= 0.4

			if(HUMOR_COLD)
				switch(difference)
					if(-INFINITY to -15)
						temperature_mod *= 0.7
					if(-15 to -10)
						temperature_mod *= 1.2
					if(-10 to -5)
						temperature_mod *= 1.5
					if(10 to 15)
						temperature_mod *= 0.6
					if(15 to INFINITY)
						temperature_mod *= 0.4

			if(HUMOR_DRY)
				if(number_wet_items <= 0)
					wetness_mod *= 1.4
				else
					wetness_mod *= (1 / number_wet_items)

			if(HUMOR_WET)
				if(number_wet_items <= 0)
					wetness_mod *= 0.6
				else
					wetness_mod *= 1 + (1 / number_wet_items)

	var/datum/particle_weather/running = SSParticleWeather.runningWeather
	if(running && istype(running, /datum/particle_weather/rain))
		if(running.can_weather(effecting))
			wetness_mod *= 1.5

	var/final_mod = 1 * temperature_mod * (wetness_mod * 0.7)

	return final_mod

/datum/humor/proc/get_humor_modifier(datum/disease/disease, mob/living/effecting)
	// Organs blow right now, no healing, barely any damage/loss effects
	// Needs to be healable before we give dieases for poor health

	var/matching_age = FALSE
	if(ishuman(effecting))
		var/mob/living/carbon/human/human_effecting = effecting
		if(human_effecting.age in ages)
			matching_age = TRUE

	return temperament_modifier(effecting) * (matching_age ? 1.2 : 0.8)

/datum/humor/blood
	name = HUMOR_BLOOD
	special_name = "Blood"
	season = "Spring"
	element = "Air"
	ages = list(AGE_CHILD)
	temperaments = list(HUMOR_WARM, HUMOR_WET)
	associated_organ = /obj/item/organ/liver

// Bloodletting can help cure these diseases, or make them significantly worse.
/datum/humor/blood/get_humor_modifier(datum/disease/disease, mob/living/effecting)
	. = ..()

	if(iscarbon(effecting))
		var/mob/living/carbon/C = effecting
		if(NOBLOOD in C.dna?.species?.species_traits)
			return

	var/base_mod = .

	switch(effecting.blood_volume)
		if(BLOOD_VOLUME_NORMAL to INFINITY)
			base_mod *= 0.9 // No bloodletting? No blessings of pestra
		if(BLOOD_VOLUME_NORMAL to BLOOD_VOLUME_SAFE)
			base_mod *= 1.1
		if(BLOOD_VOLUME_SAFE to BLOOD_VOLUME_OKAY)
			base_mod *= 1.5
		else
			base_mod *= max(0.1, (effecting.blood_volume / effecting::blood_volume))

/datum/humor/yellow_bile
	name = HUMOR_YELLOW_BILE
	special_name = "Yellow Bile"
	season = "Summer"
	element = "Fire"
	ages = list(AGE_ADULT)
	temperaments = list(HUMOR_WARM, HUMOR_DRY)
	associated_organ = /obj/item/organ/stomach // Good enough

/datum/humor/black_bile
	name = HUMOR_BLACK_BILE
	special_name = "Black Bile"
	season = "Autumn"
	element = "Earth"
	ages = list(AGE_ADULT, AGE_MIDDLEAGED)
	temperaments = list(HUMOR_COLD, HUMOR_DRY)
	associated_organ = /obj/item/organ/guts

/datum/humor/phlegm
	name = HUMOR_PHLEGM
	special_name = "Phlegm"
	season = "Winter"
	element = "Water"
	ages = list(AGE_OLD, AGE_IMMORTAL)
	temperaments = list(HUMOR_COLD, HUMOR_WET)
	associated_organ = /obj/item/organ/lungs
