GLOBAL_LIST_INIT(name2reagent, build_name2reagent())

/proc/build_name2reagent()
	. = list()
	for (var/t in subtypesof(/datum/reagent))
		var/datum/reagent/R = t
		if (length(initial(R.name)))
			.[ckey(initial(R.name))] = t

//Various reagents
//Toxin & acid reagents
//Hydroponics stuff

/datum/reagent
	var/name = "Reagent"
	var/description = ""
	var/specific_heat = SPECIFIC_HEAT_DEFAULT		//J/(K*mol)
	var/taste_description = ""
	var/scent_description = ""
	var/taste_mult = 1 //how this taste compares to others. Higher values means it is more noticable
	var/glass_name = "glass of ...what?" // use for specialty drinks.
	var/glass_desc = ""
	var/glass_icon_state = null // Otherwise just sets the icon to a normal glass with the mixture of the reagents in the glass.
	var/shot_glass_icon_state = null
	var/datum/reagents/holder = null
	var/reagent_state = LIQUID
	var/list/data
	var/current_cycle = 0
	var/volume = 0									//pretend this is moles
	var/color = "#000000" // rgb: 0, 0, 0
	var/random_reagent_color = FALSE
	var/alpha = 255
	var/can_synth = TRUE // can this reagent be synthesized? (for example: odysseus syringe gun)
	var/metabolization_rate = REAGENTS_METABOLISM //how fast the reagent is metabolized by the mob
	var/overrides_metab = 0
	var/overdose_threshold = 0
	var/addiction_threshold = 0
	var/addiction_stage = 0
	var/overdosed = 0 // You fucked up and this is now triggering its overdose effects, purge that shit quick.
	var/self_consuming = FALSE
	var/reagent_weight = 1 //affects how far it travels when sprayed
	var/metabolizing = FALSE
	var/harmful = FALSE //is it bad for you? Currently only used for borghypo. C2s and Toxins have it TRUE by default.
	var/evaporates = TRUE
	///How much fire power does the liquid have, for burning on simulated liquids. Not enough fire power/unit of entire mixture may result in no fire
	var/liquid_fire_power = 0
	///How fast does the liquid burn on simulated turfs, if it does
	var/liquid_fire_burnrate = 0
	///Whether a fire from this requires oxygen in the atmosphere
	var/fire_needs_oxygen = TRUE
	///The opacity of the chems used to determine the alpha of liquid turfs
	var/opacity = 175
	///The rate of evaporation in units per call
	var/evaporation_rate = 2
	/// do we have a turf exposure (used to prevent liquids doing un-needed processes)
	var/turf_exposure = FALSE
	/// are we slippery?
	var/slippery = TRUE
	///do we glow?
	var/glows = FALSE
	/// Quality of the reagent (1-4, where 4 is highest quality)
	var/recipe_quality = 1
	/// Base quality for newly created reagents of this type
	var/base_quality = 1

/datum/reagent/Destroy() // This should only be called by the holder, so it's already handled clearing its references
	. = ..()
	holder = null

/datum/reagent/proc/reaction_mob(mob/living/M, method=TOUCH, reac_volume, show_message = 1, touch_protection = 0)
	if(!istype(M))
		return 0
	if(method & VAPOR) //smoke, foam, spray
		if(M.reagents)
			var/modifier = CLAMP((1 - touch_protection), 0, 1)
			var/amount = round(reac_volume*modifier, 0.1)

			var/quality_modifier = get_quality_metabolization_modifier()
			amount = amount * quality_modifier

			if(amount >= 0.5)
				// Create new reagent with same quality
				var/datum/reagent/new_reagent = new type()
				new_reagent.recipe_quality = recipe_quality
				new_reagent.data = list("quality" = recipe_quality, "volume" = amount)
				M.reagents.add_reagent(type, amount, new_reagent.data)
	return 1

/datum/reagent/proc/add_data(data_name, data_value)
	LAZYADDASSOC(data, data_name, data_value)

/datum/reagent/proc/reaction_obj(obj/O, volume)
	return

/datum/reagent/proc/evaporate(turf/exposed_turf, reac_volume)
	return

/datum/reagent/proc/reaction_turf(turf/T, volume)
	return

/datum/reagent/proc/on_bodypart_absorb(obj/item/bodypart, mob/living/carbon/M, amount_to_transfer)
	SHOULD_CALL_PARENT(FALSE)
	on_mob_life(M)

/datum/reagent/proc/on_mob_life(mob/living/carbon/M)
	current_cycle++
	if(holder)
		var/adjusted_metabolization_rate = metabolization_rate
		if(istype(src, /datum/reagent/consumable/ethanol) && has_world_trait(/datum/world_trait/baotha_revelry))
			adjusted_metabolization_rate = adjusted_metabolization_rate * (is_ascendant(BAOTHA) ? 0.33 : 0.5)

		// Apply quality modifier to metabolization
		var/quality_modifier = get_quality_metabolization_modifier()
		adjusted_metabolization_rate = adjusted_metabolization_rate / quality_modifier // Higher quality lasts longer

		holder.remove_reagent(type, adjusted_metabolization_rate) //By default it slowly disappears.
		if(M.client)
			if(!istype(src, /datum/reagent/drug) && reagent_state == LIQUID)
				record_featured_object_stat(FEATURED_STATS_DRINKS, name, adjusted_metabolization_rate)
			if(istype(src, /datum/reagent/consumable/ethanol))
				record_featured_stat(FEATURED_STATS_ALCOHOLICS, M, adjusted_metabolization_rate)
				record_round_statistic(STATS_ALCOHOL_CONSUMED, adjusted_metabolization_rate)
			if(istype(src, /datum/reagent/water))
				record_round_statistic(STATS_WATER_CONSUMED, adjusted_metabolization_rate)
	return TRUE

/datum/reagent/proc/on_transfer(atom/A, method=TOUCH, trans_volume) //Called after a reagent is transfered
	if(iscarbon(A))
		SEND_SIGNAL(A, COMSIG_CARBON_REAGENT_ADD, src, trans_volume, method)
	return

/datum/reagent/proc/set_quality(new_quality)
	recipe_quality = CLAMP(new_quality, 1, 4)
	if(!data)
		data = list()
	data["quality"] = recipe_quality
	return recipe_quality

/datum/reagent/proc/get_recipe_quality_desc()
	switch(recipe_quality)
		if(1)
			return "poor quality"
		if(2)
			return "standard quality"
		if(3)
			return "high quality"
		if(4)
			return "premium quality"
		else
			return "unknown quality"

// Called when this reagent is first added to a mob
/datum/reagent/proc/on_mob_add(mob/living/L)
	return

// Called when this reagent is removed while inside a mob
/datum/reagent/proc/on_mob_delete(mob/living/L)
	return

// Called when this reagent first starts being metabolized by a liver
/datum/reagent/proc/on_mob_metabolize(mob/living/L)
	return

/// Called when this liquid is aerated (sprinklers vents and pumps for now)
/datum/reagent/proc/on_aeration(volume, turf/turf)
	return

// Called when this reagent stops being metabolized by a liver
/datum/reagent/proc/on_mob_end_metabolize(mob/living/L)
	return

/datum/reagent/proc/on_move(mob/M)
	return

// Called after add_reagents creates a new reagent.
/datum/reagent/proc/on_new(list/incoming_data)
	if(incoming_data && incoming_data["quality"])
		recipe_quality = incoming_data["quality"]
	else
		recipe_quality = base_quality
	recipe_quality = CLAMP(recipe_quality, 1, 4)

	if(!data)
		data = list()
	data["quality"] = recipe_quality
	for(var/data_item in incoming_data)
		if(data_item == "quality") //special handling for this
			continue
		data[data_item] = incoming_data[data_item]
	if("custom_name" in data)
		name = data["custom_name"]
	if("custom_scent" in data)
		scent_description = data["custom_scent"]
	if("custom_tastes" in data)
		taste_description = data["custom_tastes"]
	return

// Called when two reagents of the same are mixing.
/datum/reagent/proc/on_merge(list/incoming_data, other_volume)
	SHOULD_CALL_PARENT(TRUE)
	if(!length(incoming_data))
		return
	if("quality" in incoming_data)
		var/other_quality = incoming_data["quality"]

		var/total_volume = volume + other_volume
		var/weighted_average = ((recipe_quality * volume) + (other_quality * other_volume)) / total_volume
		recipe_quality = floor(weighted_average)

		recipe_quality = CLAMP(recipe_quality, 1, 4)

		if(!data)
			data = list()
		data["quality"] = recipe_quality
	for(var/data_item in incoming_data)
		if(data_item == "quality") //special handling for this
			continue
		data[data_item] = incoming_data[data_item]
	if("custom_name" in data)
		name = data["custom_name"]
	if("custom_scent" in data)
		scent_description = data["custom_scent"]
	if("custom_tastes" in data)
		taste_description = data["custom_tastes"]
	return

/datum/reagent/proc/get_quality_metabolization_modifier()
	switch(recipe_quality)
		if(1)
			return 0.8 // Poor quality metabolizes 20% slower (less effective)
		if(2)
			return 1.0 // Standard quality - no modifier
		if(3)
			return 1.15 // High quality - 15% more effective
		if(4)
			return 1.3 // Premium quality - 30% more effective
		else
			return 1.0

/datum/reagent/proc/on_update(atom/A)
	return

//called on expose_temperature
/datum/reagent/proc/on_temp_change(chem_temp)
	return
// Called when the reagent container is hit by an explosion
/datum/reagent/proc/on_ex_act(severity)
	return

// Called if the reagent has passed the overdose threshold and is set to be triggering overdose effects
/datum/reagent/proc/overdose_process(mob/living/M)
	return

/datum/reagent/proc/overdose_start(mob/living/M)
	to_chat(M, "<span class='danger'>I feel like I took too much of [name]!</span>")
	M.add_stress(/datum/stress_event/overdose)

/datum/reagent/proc/addiction_act_stage1(mob/living/M)
	M.add_stress(/datum/stress_event/withdrawal_light)
	if(prob(30))
		to_chat(M, "<span class='notice'>I feel like having some [name] right about now.</span>")

/datum/reagent/proc/addiction_act_stage2(mob/living/M)
	M.add_stress(/datum/stress_event/withdrawal_medium)
	if(prob(30))
		to_chat(M, "<span class='notice'>I feel like you need [name]. You just can't get enough.</span>")

/datum/reagent/proc/addiction_act_stage3(mob/living/M)
	M.add_stress(/datum/stress_event/withdrawal_severe)
	if(prob(30))
		to_chat(M, "<span class='danger'>I have an intense craving for [name].</span>")

/datum/reagent/proc/addiction_act_stage4(mob/living/M)
	M.add_stress(/datum/stress_event/withdrawal_critical)
	if(prob(30))
		to_chat(M, "<span class='boldannounce'>You're not feeling good at all! You really need some [name].</span>")

/datum/reagent/proc/add_to_member(obj/effect/abstract/liquid_turf/adder)
	return

/datum/reagent/proc/remove_from_member(obj/effect/abstract/liquid_turf/remover)
	return

/proc/pretty_string_from_reagent_list(list/reagent_list)
	//Convert reagent list to a printable string for logging etc
	var/list/rs = list()
	for (var/datum/reagent/R in reagent_list)
		rs += "[R.name], [R.volume]"

	return rs.Join(" | ")
