/datum/reagent/blood
	// vitae is not the actual amount of vitae in the blood, it's a multiplier for how much vitae is in each unit of blood.
	data = list("donor"=null,"blood_DNA"=null,"blood_type"=null,"resistances"=null,"trace_chem"=null,"mind"=null,"ckey"=null,"gender"=null,"real_name"=null,"cloneable"=null,"factions"=null,"quirks"=null,"preferences"=null, "vitae"=0)
	name = "Blood"
	color = COLOR_BLOOD
	metabolization_rate = 20 //SUPER fast
	taste_description = "iron"
	taste_mult = 1.3
	glass_icon_state = "glass_red"
	glass_name = "glass of tomato juice"
	glass_desc = ""
	shot_glass_icon_state = "shotglassred"
	var/toxicity = 0.7 // how toxic will this be to digest to people who cannot drink it

/datum/reagent/blood/tiefling
	name = "Tiefling Blood"
	glows = TRUE
	toxicity = 0 // yum

/datum/reagent/blood/putrid
	name = "Putrid Blood"
	color = "#94463b"
	taste_description = "rot"
	taste_mult = 1.8
	toxicity = 3

/datum/reagent/blood/on_transfer(atom/A, method=TOUCH, trans_volume)
	if(!ismob(A))
		data["preferences"] &= ~(BLOOD_PREFERENCE_LIVING|BLOOD_PREFERENCE_SLEEPING)
	. = ..()

/datum/reagent/blood/reaction_mob(mob/living/L, method=TOUCH, reac_volume)
	. = ..()
	if(method & TOUCH)
		L.adjust_germ_level(GERM_PER_UNIT_BLOOD * reac_volume * 0.1)

	if(!(. && method & (INJECT|INGEST)))
		return
	SEND_SIGNAL(L, COMSIG_HANDLE_INFUSION, data["blood_type"], reac_volume)
	var/datum/dna/L_dna = L.has_dna()
	var/drinking_self = L_dna?.unique_enzymes && L_dna.unique_enzymes == data["blood_DNA"]
	//if the dna matches, you're drinking your own blood freak.
	if(!drinking_self && L.clan && data["vitae"] > 0)
		var/vitae = L.clan.handle_bloodsuck(L, data["preferences"], reac_volume * data["vitae"])
		L.adjust_bloodpool(vitae)
		L.adjust_hydration(vitae * 0.1)

	var/mob/living/carbon/C = L
	if(istype(C) && (NOBLOOD in C.dna?.species?.species_traits))
		return
	//if it's non-toxic, drink up, otherwise, you need the blooddrinker trait and it has to be a blood you're compatible with or you need to be a nasty eater
	if(method & INJECT)
		var/modifier = 1 //TODO: Borbop ~ Once we get a proper transfusion system this will become unneeded basically means instead of 5 units we inject 100 units which is 4 injections to suriving level. This is 100% blood duping but like... its this or 80 syringes of blood to get someone restarted
		if(L.stat >= DEAD)
			modifier = 20
		if(L.blood_volume <= BLOOD_VOLUME_MAXIMUM)
			L.adjust_bloodvolume(round(reac_volume, 0.1) * modifier)
		return
	if(method & INGEST)
		if(!drinking_self && (toxicity <= 0 || (HAS_TRAIT(L, TRAIT_BLOODDRINKER) || HAS_TRAIT(L, TRAIT_NASTY_EATER))))
			if(!HAS_TRAIT(L, TRAIT_NOHUNGER))
				L.adjust_hydration(reac_volume * 0.2)
			if(L.blood_volume < BLOOD_VOLUME_NORMAL)
				L.adjust_bloodvolume(reac_volume * 0.2)
			return
		var/tox = toxicity * reac_volume
		if(HAS_TRAIT(L, TRAIT_POISON_RESILIENCE))
			tox *= 0.5
		L.adjustToxLoss(tox)
		C.add_nausea(tox * 2)

/datum/reagent/blood/on_merge(list/mix_data, other_volume)
	. = ..()
	data["vitae"] = (data["vitae"] * volume + (mix_data?["vitae"] || 0) * other_volume) / (volume + other_volume) // weighted average of both vitae
	data["preferences"] |= mix_data?["preferences"] // i have no idea how to effectively deal with this issue, this is gonna get weird sometimes.
	if(mix_data && data["blood_DNA"] != mix_data["blood_DNA"])
		data["cloneable"] = 0 //On mix, consider the genetic sampling unviable for pod cloning if the DNA sample doesn't match.
	return 1

/datum/reagent/blood/reaction_turf(turf/T, reac_volume)//splash the blood all over the place
	if(!istype(T))
		return
	if(reac_volume < 3)
		return
	var/obj/effect/decal/cleanable/blood/B = locate() in T //find some blood here
	if(!B)
		B = new(T)
	if(data["blood_DNA"])
		B.add_blood_DNA(list(data["blood_DNA"] = data["blood_type"]))

/datum/reagent/blood/reaction_obj(obj/O, volume)
	. = ..()
	if(!.)
		O.adjust_germ_level(GERM_PER_UNIT_BLOOD * volume)

/datum/reagent/blood/fuel
	name = "Oil"
	color = "#1C1C1C"
	taste_description = "gross metal"
	glass_desc = ""
	toxicity = 3

/datum/reagent/fuel/reaction_mob(mob/living/M, method=TOUCH, reac_volume)//Splashing people with welding fuel to make them easy to ignite!
	if((method & TOUCH) || (method & VAPOR))
		M.adjust_fire_stacks(reac_volume / 10)
		return
	..()

/datum/reagent/blood/fuel/add_to_member(obj/effect/abstract/liquid_turf/adder)
	. = ..()
	if(!adder.GetComponent(/datum/component/slippery))
		adder.AddComponent(/datum/component/slippery, 50)

/datum/reagent/blood/fuel/remove_from_member(obj/effect/abstract/liquid_turf/remover)
	. = ..()
	var/datum/component/slipComp = remover.GetComponent(/datum/component/slippery)
	slipComp?.Destroy()

/datum/reagent/water
	name = "Water"
	description = "An ubiquitous chemical substance that is composed of hydrogen and oxygen."
	color = "#6a9295c6"
	taste_description = "water"
	var/cooling_temperature = 2
	glass_icon_state = "glass_clear"
	glass_name = "glass of water"
	glass_desc = ""
	shot_glass_icon_state = "shotglassclear"
	var/hydration = 12
	var/sanitization = SANITIZATION_PER_UNIT_WATER
	alpha = 100
	taste_mult = 0.1

/datum/chemical_reaction/grosswaterify
	name = "grosswater"
	id = /datum/reagent/water/gross
	results = list(/datum/reagent/water/gross = 2)
	required_reagents = list(/datum/reagent/water/gross = 1, /datum/reagent/water = 1)

/datum/reagent/water/on_mob_metabolize(mob/living/L)
	. = ..()
	L.add_chem_effect(CE_BLOODRESTORE, 0.1, "[type]")

/datum/reagent/water/on_mob_end_metabolize(mob/living/L)
	. = ..()
	L.remove_chem_effect(CE_BLOODRESTORE, "[type]")

/datum/reagent/water/on_mob_life(mob/living/carbon/M, efficiency)
	if(ishuman(M))
		var/mob/living/carbon/human/H = M
		if(!HAS_TRAIT(H, TRAIT_NOHUNGER))
			H.adjust_hydration(hydration * efficiency)
	..()

/datum/reagent/water/gross
	taste_description = "lead"
	color = "#98934bc6"
	sanitization = -SANITIZATION_PER_UNIT_WATER

/datum/reagent/water/gross/on_bodypart_absorb(obj/item/bodypart/BP, mob/living/carbon/M, amount_to_transfer)
	BP.undisinfect_limb()
	for(var/datum/injury/injury in BP.injuries)
		injury.adjust_germ_level(SANITIZATION_PER_UNIT_WATER)

/datum/reagent/water/gross/on_aeration(volume, turf/turf)
	turf.pollute_turf(/datum/pollutant/rot/sewage, volume * 3)

/datum/reagent/water/gross/on_mob_life(mob/living/carbon/M, efficiency)
	..()
	if(HAS_TRAIT(M, TRAIT_NASTY_EATER)) // lets orcs and goblins drink bogwater
		return
	M.adjustToxLoss(1 * efficiency)
	M.add_nausea(12 * efficiency) //Over 8 units will cause puking


/*
 *	Water reaction to turf
 */

/turf/open
	var/water_level = 0
	var/last_water_update
	var/max_water = 500

/turf/open/proc/add_water(amt)
	if(!amt)
		return
	var/shouldupdate = FALSE
	if(water_level <= 0)
		if(amt > 0)
			shouldupdate = TRUE
	var/newwater = water_level + amt
	if(newwater >= max_water)
		water_level = max_water
	else
		water_level = newwater
	water_level = round(water_level)
	if(water_level > 0)
		START_PROCESSING(SSwaterlevel, src)
	if(shouldupdate)
		update_water()

	if(amt > 101)
		for(var/obj/effect/decal/cleanable/blood/target in src)
			qdel(target)

	return TRUE

/turf/open/proc/update_water()
	return TRUE

/datum/reagent/water/reaction_turf(turf/open/T, reac_volume)
	if(!istype(T))
		return
	if(reac_volume >= 5)
		T.add_water(reac_volume * 3) //nuprocet)

	for(var/atom/movable/thing as anything in T.contents)
		if(ismob(thing))
			var/mob/M = thing
			reaction_mob(M, reac_volume)
		else if(isobj(thing))
			var/obj/O = thing
			reaction_obj(O, reac_volume)
/*
 *	Water reaction to an object
 */

/datum/reagent/water/reaction_obj(obj/O, reac_volume)
	O.extinguish()
	O.acid_level = 0

	O.adjust_germ_level(-reac_volume * sanitization)
	if(istype(O, /obj/item/bin))
		var/obj/item/bin/RB = O
		if(!RB.kover)
			if(RB.reagents)
				RB.reagents.add_reagent(src.type, reac_volume)
	else if(istype(O, /obj/item/reagent_containers))
		var/obj/item/reagent_containers/RB = O
		if(RB.reagents)
			RB.reagents.add_reagent(src.type, reac_volume)
	else if(istype(O, /obj/item/natural/cloth))
		O.wash(CLEAN_WASH)
	else if(istype(O, /obj/item/clothing))
		var/obj/item/clothing/O_clothing = O
		if(O_clothing.wetable)
			if(!holder.has_reagent(/datum/reagent/water/gross))
				O_clothing.wet.add_water(20, dirty = FALSE)
			else
				O_clothing.wet.add_water(20, dirty = TRUE)
/*
 *	Water reaction to a mob
 */

/datum/reagent/water/reaction_mob(mob/living/M, method=TOUCH, reac_volume)//Splashing people with water can help put them out!
	if(!istype(M))
		return
	if(method & TOUCH)
		var/turf/turf_check = get_turf(M)
		if(!istype(turf_check, /turf/open/water))
			M.adjust_fire_stacks(-(reac_volume / 10))
			M.SoakMob(FULL_BODY)
		M.adjust_germ_level(-reac_volume * sanitization * 0.1)
	return ..()


/datum/reagent/mercury
	name = "Mercury"
	description = "A curious metal that's a liquid at room temperature. Neurodegenerative and very bad for the mind."
	color = "#484848" // rgb: 72, 72, 72A
	taste_mult = 0 // apparently tasteless.

/datum/reagent/mercury/on_mob_life(mob/living/carbon/M, efficiency)
	if(!HAS_TRAIT(M, TRAIT_IMMOBILIZED))
		step(M, pick(GLOB.cardinals))
	if(prob(5))
		M.emote(pick("twitch","drool","moan"))
	M.adjustOrganLoss(ORGAN_SLOT_BRAIN * efficiency, 1)
	..()

/datum/reagent/yuck
	name = "Rot"
	description = "A mixture of various colors of fluid. Induces vomiting."
	glass_name = "glass of ...yuck!"
	glass_desc = ""
	color = "#545000"
	taste_description = "rot"
	taste_mult = 4
	can_synth = FALSE
	metabolization_rate = REAGENTS_METABOLISM * 0.3

/datum/reagent/yuck/on_mob_life(mob/living/carbon/C, efficiency)
	if(HAS_TRAIT(C, TRAIT_NOHUNGER) || HAS_TRAIT(C, TRAIT_NASTY_EATER) || HAS_TRAIT(C, TRAIT_ROT_EATER)) //they can't puke
		return ..()
	C.add_nausea(HAS_TRAIT(C, TRAIT_DEADNOSE) ? 2.5 * efficiency : 5 * efficiency)
	return ..()

/datum/reagent/ash
	name = "Ash"
	description = "Supposedly phoenixes rise from these, but you've never seen it."
	reagent_state = LIQUID
	color = "#515151"
	taste_description = "ash"

/datum/reagent/soap
	name = "Soap"
	description = "A combination of ash and animal fats used for cleaning."
	color = "#cbb165"
	alpha = 180
	taste_description = "soapy grease"
	metabolization_rate = 0.5
	glass_icon_state = "glass_clear"
	glass_name = "glass"
	evaporation_rate = 2
	shot_glass_icon_state = "shotglassclear"
	alpha = 100
	taste_mult = 2 // yuck!

/datum/reagent/soap/on_mob_life(mob/living/carbon/M, efficiency)
	..()
	if(ishuman(M))
		M.add_stress(/datum/stress_event/mouthsoap)

/datum/reagent/soap/add_to_member(obj/effect/abstract/liquid_turf/adder)
	. = ..()
	if(!adder.GetComponent(/datum/component/slippery))
		adder.AddComponent(/datum/component/slippery, 30)

/datum/reagent/soap/remove_from_member(obj/effect/abstract/liquid_turf/remover)
	. = ..()
	var/datum/component/slipComp = remover.GetComponent(/datum/component/slippery)
	slipComp?.Destroy()

/datum/reagent/sate
	name = "SATE"
	color = "#e46363"
	glows = TRUE

/datum/reagent/sate/on_mob_add(mob/living/L)
	. = ..()
	ADD_TRAIT(L, TRAIT_SATE, type)

/datum/reagent/sate/on_mob_delete(mob/living/L)
	. = ..()
	REMOVE_TRAIT(L, TRAIT_SATE, type)

/datum/reagent/devour
	name = "DEVOUR"
	color = "#61e639"
	glows = TRUE
	overdose_threshold = 11

/datum/reagent/devour/on_mob_life(mob/living/carbon/M, efficiency)
	. = ..()
	SEND_SIGNAL(M, COMSIG_DEVOUR_OVERDRIVE)

/datum/reagent/devour/overdose_process(mob/living/M)
	. = ..()
