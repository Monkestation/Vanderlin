/datum/reagent/blood
	data = list("donor"=null,"blood_DNA"=null,"blood_type"=null,"resistances"=null,"trace_chem"=null,"mind"=null,"ckey"=null,"gender"=null,"real_name"=null,"cloneable"=null,"factions"=null,"quirks"=null)
	name = "Blood"
	color = "#C80000" // rgb: 200, 0, 0
	metabolization_rate = 5 //fast rate so it disappears fast.
	taste_description = "iron"
	taste_mult = 1.3
	glass_icon_state = "glass_red"
	glass_name = "glass of tomato juice"
	glass_desc = ""
	shot_glass_icon_state = "shotglassred"

/datum/reagent/blood/tiefling
	name = "Tiefling Blood"
	glows = TRUE

/datum/reagent/blood/reaction_mob(mob/living/L, method=TOUCH, reac_volume)
	if(iscarbon(L))
		var/mob/living/carbon/C = L
		var/datum/blood_type/blood = L.get_blood_type()
		if(blood?.reagent_type == type && (method == INJECT || (method == INGEST && C.dna && C.dna.species && (DRINKSBLOOD in C.dna.species.species_traits))))
			if(!(data["blood_type"] in blood.compatible_types))
				C.reagents.add_reagent(/datum/reagent/toxin, reac_volume * 0.5)
			else
				C.blood_volume = min(C.blood_volume + round(reac_volume, 0.1), BLOOD_VOLUME_MAXIMUM)

	if((method == INGEST) && L.clan)
		L.adjust_bloodpool(reac_volume)
		L.clan.handle_bloodsuck(BLOOD_PREFERENCE_FANCY)
	if(method == INJECT)
		SEND_SIGNAL(L, COMSIG_HANDLE_INFUSION, data["blood_type"], reac_volume)


/datum/reagent/blood/on_merge(list/mix_data)
	. = ..()
	if(data && mix_data)
		if(data["blood_DNA"] != mix_data["blood_DNA"])
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

/datum/reagent/blood/green
	color = "#05af01"

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
	alpha = 100
	taste_mult = 0.1

/datum/chemical_reaction/grosswaterify
	name = "grosswater"
	id = /datum/reagent/water/gross
	results = list(/datum/reagent/water/gross = 2)
	required_reagents = list(/datum/reagent/water/gross = 1, /datum/reagent/water = 1)


/datum/reagent/water/on_mob_life(mob/living/carbon/M)
	if(ishuman(M))
		var/mob/living/carbon/human/H = M
		if(!HAS_TRAIT(H, TRAIT_NOHUNGER))
			H.adjust_hydration(hydration)
		if(M.blood_volume < BLOOD_VOLUME_NORMAL)
			M.blood_volume = min(M.blood_volume+10, BLOOD_VOLUME_NORMAL)
	..()

/datum/reagent/water/gross
	taste_description = "lead"
	color = "#98934bc6"

/datum/reagent/water/gross/on_aeration(volume, turf/turf)
	turf.pollute_turf(/datum/pollutant/rot/sewage, volume * 3)

/datum/reagent/water/gross/reaction_mob(mob/living/L, method=TOUCH, reac_volume)
	if(method == INGEST) // Make sure you DRANK the toxic water before giving damage
		..()

/datum/reagent/water/gross/on_mob_life(mob/living/carbon/M)
	..()
	if(HAS_TRAIT(M, TRAIT_NASTY_EATER )) // lets orcs and goblins drink bogwater
		return
	M.adjustToxLoss(1)
	M.add_nausea(12) //Over 8 units will cause puking


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
/*
 *	Water reaction to a mob
 */

/datum/reagent/water/reaction_mob(mob/living/M, method=TOUCH, reac_volume)//Splashing people with water can help put them out!
	if(!istype(M))
		return
	if(method == TOUCH)
		var/turf/turf_check = get_turf(M)
		if(!istype(turf_check, /turf/open/water))
			M.adjust_fire_stacks(-(reac_volume / 10))
			M.SoakMob(FULL_BODY)
	return ..()


/datum/reagent/mercury
	name = "Mercury"
	description = "A curious metal that's a liquid at room temperature. Neurodegenerative and very bad for the mind."
	color = "#484848" // rgb: 72, 72, 72A
	taste_mult = 0 // apparently tasteless.

/datum/reagent/mercury/on_mob_life(mob/living/carbon/M)
	if(!HAS_TRAIT(M, TRAIT_IMMOBILIZED))
		step(M, pick(GLOB.cardinals))
	if(prob(5))
		M.emote(pick("twitch","drool","moan"))
	M.adjustOrganLoss(ORGAN_SLOT_BRAIN, 1)
	..()

/// Improvised reagent that induces vomiting. Created by dipping a dead mouse in welder fluid.
/datum/reagent/yuck
	name = "Organic Slurry"
	description = "A mixture of various colors of fluid. Induces vomiting."
	glass_name = "glass of ...yuck!"
	glass_desc = ""
	color = "#545000"
	taste_description = "insides"
	taste_mult = 4
	can_synth = FALSE
	metabolization_rate = 0.4 * REAGENTS_METABOLISM
	var/yuck_cycle = 0 //! The `current_cycle` when puking starts.

/datum/reagent/yuck/on_mob_add(mob/living/L)
	if(HAS_TRAIT(src, TRAIT_NOHUNGER)) //they can't puke
		holder.del_reagent(type)

#define YUCK_PUKE_CYCLES 3 		// every X cycle is a puke
#define YUCK_PUKES_TO_STUN 3 	// hit this amount of pukes in a row to start stunning
/datum/reagent/yuck/on_mob_life(mob/living/carbon/C)
	if(!yuck_cycle)
		if(prob(8))
			var/dread = pick("Something is moving in my stomach...", \
				"A wet growl echoes from my stomach...", \
				"For a moment you feel like my surroundings are moving, but it's my stomach...")
			to_chat(C, "<span class='danger'>[dread]</span>")
			yuck_cycle = current_cycle
	else
		var/yuck_cycles = current_cycle - yuck_cycle
		if(yuck_cycles % YUCK_PUKE_CYCLES == 0)
			if(yuck_cycles >= YUCK_PUKE_CYCLES * YUCK_PUKES_TO_STUN)
				holder.remove_reagent(type, 5)
			C.vomit(rand(14, 26), stun = yuck_cycles >= YUCK_PUKE_CYCLES * YUCK_PUKES_TO_STUN)
	if(holder)
		return ..()
#undef YUCK_PUKE_CYCLES
#undef YUCK_PUKES_TO_STUN

/datum/reagent/yuck/on_mob_end_metabolize(mob/living/L)
	yuck_cycle = 0 // reset vomiting
	return ..()

/datum/reagent/yuck/on_transfer(atom/A, method=TOUCH, trans_volume)
	if(method == INGEST || !iscarbon(A))
		return ..()

	A.reagents.remove_reagent(type, trans_volume)
	A.reagents.add_reagent(/datum/reagent/fuel, trans_volume * 0.75)
	A.reagents.add_reagent(/datum/reagent/water, trans_volume * 0.25)

	return ..()


/datum/reagent/fuel
	name = "Lighter fuel"
	description = "Lighter fluids."
	color = "#660000" // rgb: 102, 0, 0
	taste_description = "gross metal"
	glass_icon_state = "dr_gibb_glass"
	glass_name = "glass of lighter fuel"
	glass_desc = ""

/datum/reagent/fuel/reaction_mob(mob/living/M, method=TOUCH, reac_volume)//Splashing people with welding fuel to make them easy to ignite!
	if(method == TOUCH || method == VAPOR)
		M.adjust_fire_stacks(reac_volume / 10)
		return
	..()

/datum/reagent/fuel/on_mob_life(mob/living/carbon/M)
	M.adjustToxLoss(1, 0)
	..()
	return TRUE

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

/datum/reagent/soap/on_mob_life(mob/living/carbon/M)
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

/datum/reagent/devour/on_mob_life(mob/living/carbon/M)
	. = ..()
	SEND_SIGNAL(M, COMSIG_DEVOUR_OVERDRIVE)

/datum/reagent/devour/overdose_process(mob/living/M)
	. = ..()
