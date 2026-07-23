/****************************************************
				BLOOD SYSTEM
****************************************************/

/mob/living/proc/handle_blood()
	if(!CAN_HAVE_BLOOD(src)) //cryosleep or husked people do not pump the blood.
		bleed_rate = 0
		adjustOxyLoss(1.6)
		return

	bleed_rate = min(get_bleed_rate(), 10)
	var/cached_blood_volume = get_blood_volume()

	if(cached_blood_volume < BLOOD_VOLUME_NORMAL && blood_volume && !bleed_rate)
		adjust_blood_volume(0.5, maximum = BLOOD_VOLUME_SAFE_MAXIMUM)

	//Effects of bloodloss
	if(!HAS_TRAIT(src, TRAIT_BLOODLOSS_IMMUNE) && stat != DEAD)
		switch(cached_blood_volume)
			if(BLOOD_VOLUME_OKAY to BLOOD_VOLUME_SAFE)
				if(prob(3))
					to_chat(src, span_warning("I feel dizzy."))
				remove_status_effect(/datum/status_effect/debuff/bleedingworse)
				remove_status_effect(/datum/status_effect/debuff/bleedingworst)
				apply_status_effect(/datum/status_effect/debuff/bleeding)
			if(BLOOD_VOLUME_BAD to BLOOD_VOLUME_OKAY)
				if(prob(3))
					set_eye_blur_if_lower(12 SECONDS)
					to_chat(src, span_warning("I feel faint."))
				remove_status_effect(/datum/status_effect/debuff/bleeding)
				remove_status_effect(/datum/status_effect/debuff/bleedingworst)
				apply_status_effect(/datum/status_effect/debuff/bleedingworse)
			if(0 to BLOOD_VOLUME_BAD)
				if(prob(3))
					set_eye_blur_if_lower(12 SECONDS)
					to_chat(src, span_warning("I feel faint."))
				if(prob(3) && stat < UNCONSCIOUS)
					Unconscious(rand(5 SECONDS,10 SECONDS))
					to_chat(src, span_warning("I feel drained."))
				remove_status_effect(/datum/status_effect/debuff/bleedingworse)
				remove_status_effect(/datum/status_effect/debuff/bleeding)
				apply_status_effect(/datum/status_effect/debuff/bleedingworst)
		if(cached_blood_volume <= BLOOD_VOLUME_BAD)
			adjustOxyLoss(2)
			if(cached_blood_volume <= BLOOD_VOLUME_SURVIVE)
				adjustOxyLoss(4)
	else
		remove_status_effect(/datum/status_effect/debuff/bleeding)
		remove_status_effect(/datum/status_effect/debuff/bleedingworse)
		remove_status_effect(/datum/status_effect/debuff/bleedingworst)

	if(bleed_rate)
		bleed(bleed_rate)

	if(cached_blood_volume in -INFINITY to BLOOD_VOLUME_SURVIVE)
		adjustOxyLoss(1.6)

// Takes care blood loss and regeneration
/mob/living/carbon/handle_blood()
	return // we handle this in our organs now

/mob/living/proc/get_bleed_rate()
	if(!CAN_HAVE_BLOOD(src))
		return 0
	var/bleed_rate = 0
	for(var/datum/wound/wound as anything in get_wounds())
		bleed_rate += wound.bleed_rate
	for(var/obj/item/embedded as anything in simple_embedded_objects)
		bleed_rate += embedded.embedding?.embedded_bloodloss
	return bleed_rate

/mob/living/carbon/get_bleed_rate()
	if(!CAN_HAVE_BLOOD(src))
		return 0
	var/bleed_rate = 0
	for(var/obj/item/bodypart/bodypart as anything in bodyparts)
		bleed_rate += bodypart.get_bleed_rate()
	return bleed_rate

/// Returns the reagent type this mob has for blood
/mob/living/proc/get_blood_reagent()
	if (!can_bleed())
		return

	var/datum/blood_type/blood_type = get_blood_type()
	return blood_type?.reagent_type

/// Check if a mob can bleed, and possibly if they're capable of leaving decals on turfs/mobs/items
/mob/living/proc/can_bleed(bleed_flag = NONE)
	if (!CAN_HAVE_BLOOD(src))
		return BLEED_NONE

	if(!iscarbon(src) && HAS_TRAIT(src, TRAIT_SIMPLE_WOUNDS))
		return BLEED_SPLATTER

	if(!iscarbon(src))
		return BLEED_NONE

	if (!bleed_flag)
		return BLEED_SPLATTER

	var/datum/blood_type/blood_type = get_blood_type()
	if (!blood_type)
		return BLEED_NONE

	// if (blood_type.blood_flags & bleed_flag)
	// 	return BLEED_SPLATTER

	// if (blood_type.blood_flags & BLOOD_ADD_DNA)
	// 	return BLEED_ADD_DNA

	return BLEED_NONE


/// How much slower we'll be bleeding for every CON point. 0.1 = 10% slower.
#define CONSTITUTION_BLEEDRATE_MOD 0.03
#define BLOOD_DRIP_RATE_MOD 90 //Greater number means creating blood drips more often while bleeding

/// Makes a blood drop, leaking amt units of blood from the mob
/mob/living/proc/bleed(amount, should_update = TRUE)
	if((status_flags & GODMODE) || !can_bleed())
		return
	if(!get_blood_volume())
		return

	// For each CON above 10, we bleed slower.
	// Consequently, for each CON under 10 we bleed faster.
	var/con_modifier = clamp(1 - ((GET_MOB_ATTRIBUTE_VALUE(src, STAT_CONSTITUTION) - 10) * CONSTITUTION_BLEEDRATE_MOD), 0.1, 2)
	amount *= con_modifier

	var/amount_bled = -adjust_blood_volume(-amount)

	if(client)
		record_featured_stat(FEATURED_STATS_BLEEDERS, src)
	record_round_statistic(STATS_BLOOD_SPILT, amount_bled / 100)

	if(isturf(loc) && prob(sqrt(amount_bled) * BLOOD_DRIP_RATE_MOD))
		add_drip_floor(get_turf(src), amount_bled)

	if(body_position != LYING_DOWN && stat == CONSCIOUS)
		playsound(src, pick('sound/misc/bleed (1).ogg', 'sound/misc/bleed (2).ogg', 'sound/misc/bleed (3).ogg'), 100, FALSE)

	if(should_update)
		updatehealth()
	return TRUE

#undef CONSTITUTION_BLEEDRATE_MOD
#undef BLOOD_DRIP_RATE_MOD

/mob/living/carbon/human/bleed(amount)
	amount *= physiology?.bleed_mod
	return ..()

/mob/living/proc/restore_blood()
	set_blood_volume(default_blood_volume)

/mob/living/carbon/human/restore_blood()
	. = ..()
	bleed_rate = 0

/****************************************************
				BLOOD TRANSFERS
****************************************************/

/// Transfers blood from mob to a container or another mob, preserving all data in it.
/// Returns how much blood was able to be transferred.
/mob/living/proc/transfer_blood_to(atom/movable/receiver, amount, ignore_low_blood = FALSE, ignore_incompatibility = FALSE,)
	var/cached_blood_volume = get_blood_volume()

	if(!cached_blood_volume || !receiver.reagents || amount <= 0)
		return 0

	if(cached_blood_volume < BLOOD_VOLUME_BAD && !ignore_low_blood)
		return 0

	var/datum/blood_type/blood_type = get_blood_type()
	if (!blood_type)
		return 0

	var/blood_reagent = get_blood_reagent()
	var/list/blood_data = get_blood_data()

	// Caps the amount to how much blood we have.
	amount = min(amount, get_blood_volume())

	if (!ignore_low_blood)
		// Caps the amount to how much we can transfer before reaching low blood.
		amount = min(amount, get_blood_volume() - BLOOD_VOLUME_BAD)

	var/mob/living/target = receiver
	if (!isliving(receiver) || target.get_blood_reagent() != blood_reagent)
		// Further caps the amount to how much blood we were able to add to the target.
		amount = receiver.reagents.add_reagent(blood_reagent, amount, blood_data, bodytemperature)
		adjust_blood_volume(-amount)
		return amount

	if(!ignore_incompatibility && !(blood_type.type_key() in target.get_blood_type().compatible_types))
		// Yes, we cap it to the amount of toxin. This is ridiculously niche, but we do it anyway.
		amount = target.reagents.add_reagent(/datum/reagent/toxin, amount * 0.5) * 2
		adjust_blood_volume(-amount)
		return amount

	receiver.reagents.add_reagent(blood_type.reagent_type, amount, blood_data, bodytemperature)

	adjust_blood_volume(-amount)
	return amount

/mob/living/proc/get_blood_data()
	SHOULD_CALL_PARENT(TRUE)
	RETURN_TYPE(/list)

	var/datum/blood_type/blood_type = get_blood_type()
	if (!blood_type || !can_bleed())
		return
	return blood_type.get_blood_data(src)

/// Transfers the blood of a mob factoring in the impure reagents in their blood
/// Returns the actual amount of blood transferred
/mob/living/proc/transfer_blood_impurities(datum/reagents/transfer_to, amount, impurity_mult = BLOODLETTING_MULT, mob/transferred_by)
	var/blacklisted_reagents = list(/datum/reagent/steam, /datum/reagent/water, /datum/reagent/blood, /datum/reagent/consumable/nutriment, /datum/reagent/consumable/soup)
	var/blood_purity = 1 // what % of the amt are we actually taking as blood?
	var/cached_blood_volume = get_blood_volume()
	amount = min(amount, transfer_to.maximum_volume - transfer_to.total_volume) // the volume of our transfer
	if(reagents?.total_volume)
		var/impurity_volume = reagents.total_volume
		for(var/reagent_type in blacklisted_reagents)
			impurity_volume -= reagents.get_reagent_amount(reagent_type, FALSE)
		if(impurity_volume > 0)
			blood_purity = cached_blood_volume / (cached_blood_volume + impurity_volume)
			reagents.trans_to(transfer_to, amount * impurity_mult * (1 - blood_purity), transfered_by=transferred_by, ignored_reagents=blacklisted_reagents)
	var/blood_transferred = min(cached_blood_volume, amount * blood_purity)  // how much of the drip is straight up blood, final value
	var/datum/blood_type/blood = get_blood_type()
	var/list/blood_data = blood?.get_blood_data(src)
	var/datum/reagents/holder = new(maximum = blood_transferred)
	// if someone adds kool aid as a blood type then blood_data here might need some work
	holder.add_reagent(blood.reagent_type, blood_transferred, blood_data, no_react = TRUE)
	holder.trans_to(transfer_to, blood_transferred, method = INGEST)
	return blood_transferred


/mob/living/proc/get_blood_type()
	RETURN_TYPE(/datum/blood_type)
	return GLOB.blood_types[animal_type] || GLOB.blood_types[/datum/blood_type/animal]

/mob/living/proc/get_lux_status()
	var/datum/blood_type/blood = get_blood_type()

	if(has_status_effect(/datum/status_effect/debuff/lux_drained) || has_status_effect(/datum/status_effect/debuff/flaw_lux_taken))//accounts for luxless flaw
		return LUX_DRAINED

	if(has_status_effect(/datum/status_effect/debuff/tainted_lux) || has_status_effect(/datum/status_effect/debuff/received_tainted_lux) || has_status_effect(/datum/status_effect/buff/received_lux))
		return LUX_HAS_LUX

	return blood.contains_lux

/mob/living/proc/get_lux_tainted_status()
	if(HAS_TRAIT(src, TRAIT_TAINTED_LUX))
		return TRUE
	var/datum/blood_type/blood = get_blood_type()
	return blood.tainted_lux

/mob/living/carbon/human/get_blood_type()
	RETURN_TYPE(/datum/blood_type)
	if(HAS_TRAIT(src, TRAIT_HUSK) || isnull(dna))
		return null
	if(dna.species.exotic_bloodtype)
		return GLOB.blood_types[dna.species.exotic_bloodtype]
	return GLOB.blood_types[dna.human_blood_type]

// This has more potential uses, and is probably faster than the old proc.
/proc/get_safe_blood(bloodtype)
	. = list()
	if(!bloodtype)
		return

	var/static/list/bloodtypes_safe = list(
		"A-" = list("A-", "O-"),
		"A+" = list("A-", "A+", "O-", "O+"),
		"B-" = list("B-", "O-"),
		"B+" = list("B-", "B+", "O-", "O+"),
		"AB-" = list("A-", "B-", "O-", "AB-"),
		"AB+" = list("A-", "A+", "B-", "B+", "O-", "O+", "AB-", "AB+"),
		"O-" = list("O-"),
		"O+" = list("O-", "O+"),
		"L" = list("L"),
		"U" = list("A-", "A+", "B-", "B+", "O-", "O+", "AB-", "AB+", "L", "U")
	)

	var/safe = bloodtypes_safe[bloodtype]
	if(safe)
		. = safe

//to add a splatter of blood or other mob liquid.
/mob/living/proc/add_splatter_floor(turf/T)
	if(!iscarbon(src))
		return
	var/datum/blood_type/blood = get_blood_type()
	if(isnull(blood))
		return
	if(!T)
		T = get_turf(src)

	if(istype(T, /turf/open/water))
		var/turf/open/water/W = T
		if(!LAZYLEN(W.children))
			W.water_reagent = blood.reagent_type // this is dumb, but it works for now
			W.volume_status = WATER_VOLUME_NORMAL // no infinite vitae glitch
			W.water_volume = MINIMUM_WATER_VOLUME

		return
	var/obj/effect/decal/cleanable/blood/splatter/splatter = new /obj/effect/decal/cleanable/blood/splatter(T, blood.color)

	splatter.transfer_mob_blood_dna(src)
	splatter.update_appearance(UPDATE_ICON_STATE)
	T?.pollute_turf(/datum/pollutant/metallic_scent, 30)
	return TRUE

//to add splatters of blood onto nearby walls. When provided a certain force amount, also increases the range at which blood can appear on the walls.
//spill_amount also increases the amount of times to try and spill more blood; Particularly to give better feedback to dismembering something.
/mob/living/proc/add_splatter_wall(force = 0, spill_amount = 1, splatter_direction = 1)
	if(force <= 0) //If the force doesn't do enough damage then dont do anything.
		return
	if(!iscarbon(src) && !HAS_TRAIT(src, TRAIT_SIMPLE_WOUNDS))
		return

	var/obj/effect/decal/cleanable/blood/wallsplatter/our_splatter = new(loc, force)
	var/turf/targ = get_ranged_target_turf(src, splatter_direction, force)
	our_splatter.fly_towards(targ, force)

/mob/living/proc/add_drip_floor(turf/T, amt)
	if(!iscarbon(src))
		if(!HAS_TRAIT(src, TRAIT_SIMPLE_WOUNDS))
			return
	var/datum/blood_type/blood = get_blood_type()
	if(isnull(blood))
		return
	if(!T)
		T = get_turf(src)

	if(amt > 3)
		if(istype(T, /turf/open/water))
			var/turf/open/water/W = T
			W.water_reagent = blood.reagent_type // this is dumb, but it works for now
			W.volume_status = WATER_VOLUME_NORMAL // no infinite vitae glitch
			W.water_volume_maximum = MINIMUM_WATER_VOLUME
			W.water_volume = MINIMUM_WATER_VOLUME
			return

	playsound(src, 'sound/misc/bleed (3).ogg', 100, FALSE)

	var/obj/item/reagent_containers/container = locate(/obj/item/reagent_containers) in T
	if(container && container.is_open_container() && container.reagents.total_volume < container.reagents.maximum_volume)
		amt = amt - transfer_blood_impurities(container.reagents, amt, BLOODLETTING_MULT, src,  list(/datum/reagent/steam, /datum/reagent/water, /datum/reagent/blood, /datum/reagent/consumable/nutriment, /datum/reagent/consumable/soup))

	if(amt > 0.5)
		var/obj/effect/decal/cleanable/blood/puddle/P = locate() in T
		if(P)
			P.blood_vol += amt
			P.transfer_mob_blood_dna(src)
			P.update_appearance(UPDATE_ICON_STATE)
		else
			var/obj/effect/decal/cleanable/blood/drip/D = locate() in T
			if(D)
				D.blood_vol += amt
				D.drips++
				D.transfer_mob_blood_dna(src)
				D.update_appearance(UPDATE_ICON_STATE)
			else
				var/obj/effect/decal/cleanable/blood/drip/splatter = new /obj/effect/decal/cleanable/blood/drip(T, blood.color)
				splatter.transfer_mob_blood_dna(src)
				splatter.update_appearance(UPDATE_ICON_STATE)
	return TRUE

/mob/living/carbon/human/add_splatter_floor(turf/T, amt)
	if(CAN_HAVE_BLOOD(src))
		. = ..()

/mob/living/carbon/human/add_splatter_floor(turf/T, small_drip)
	if(CAN_HAVE_BLOOD(src))
		. = ..()

/// Returns whether this mob can have blood.
/// Use the CAN_HAVE_BLOOD(mob) macro instead, this is used to update the cached value.
/mob/living/proc/can_have_blood()
	return default_blood_volume > 0

/mob/living/carbon/can_have_blood()
	return !HAS_TRAIT(src, TRAIT_NOBLOOD)

/// Returns the blood volume of the mob.
/// Apply modifiers when reading blood volume for oxyloss damage, HUDs and analyzers.
/// Don't apply modifiers when using blood itself, like in spells and reagent transfers.
/mob/living/proc/get_blood_volume(apply_modifiers = FALSE)
	return CAN_HAVE_BLOOD(src) ? blood_volume : 0 // Overriding blood setting code can cause blood_volume to be non-zero even when a mob shouldn't have blood.

/mob/living/carbon/get_blood_volume(apply_modifiers = FALSE)
	if (!CAN_HAVE_BLOOD(src))
		return 0 // Overriding blood setting code can cause blood_volume to be non-zero even when a mob shouldn't have blood.
	if (!apply_modifiers)
		return blood_volume // Default behavior, returns the real blood volume.
	if (status_flags & GODMODE)
		return default_blood_volume // Makes TRAIT_GODMODE grant immunity to the effects of bleeding. (oxyloss, passing out, etc.)

	var/amount = blood_volume

	/*
	// For simple multipliers, like a blood worm in a mob.
	for (var/source in blood_volume_modifiers)
		amount *= blood_volume_modifiers[source]

	// Handled here instead of in the saline reagent datum, because this way the modification order is consistent.
	// E.g. if you have an effect that modifies blood volume over the dilution cap, then saline should do nothing.
	var/datum/reagent/medicine/salglu_solution/saline = reagents?.has_reagent(/datum/reagent/medicine/salglu_solution)
	if (saline && amount < saline.dilution_cap)
		var/datum/blood_type/blood_type = get_bloodtype()
		if (blood_type?.restoration_chem == saline.required_restoration_chem)
			amount = min(amount + saline.volume * saline.dilution_per_unit, BLOOD_VOLUME_NORMAL)
	*/

	return amount

/// Sets the base blood volume of the mob, returns the blood volume of the mob after.
/mob/living/proc/set_blood_volume(amount, minimum = 0, maximum = BLOOD_VOLUME_MAXIMUM, cached_blood_volume = null)
	if (!isnum(cached_blood_volume))
		cached_blood_volume = get_blood_volume()

	if (!CAN_HAVE_BLOOD(src) && amount != 0)
		return cached_blood_volume

	// Don't return early even if "amount == cached_blood_volume", because we don't know if minimum or maximum would change it anyway.
	// Putting this here because I made that mistake and it led to a bug.

	blood_volume = clamp(amount, minimum, maximum)

	var/updated_blood_volume = get_blood_volume()

	if (cached_blood_volume != updated_blood_volume)
		QUEUE_BLOOD_UPDATE(src)

	return updated_blood_volume

/// Adjusts the base blood volume of the mob and returns the change.
/// Increases in blood volume give a positive return value and vice versa.
/// Maximum only applies on positive amounts and vice versa.
/mob/living/proc/adjust_blood_volume(amount, minimum = 0, maximum = BLOOD_VOLUME_MAXIMUM)
	if (!CAN_HAVE_BLOOD(src) || amount == 0)
		return 0

	var/cached_blood_volume = get_blood_volume()

	if (amount < 0)
		if (cached_blood_volume <= minimum)
			// Already at or below the minimum, don't decrease further.
			return 0
		// Decreases shouldn't jump the pre-existing value to the maximum.
		maximum = INFINITY
	else
		if (cached_blood_volume >= maximum)
			// Already at or above the maximum, don't increase further.
			return 0
		// Increases shouldn't jump the pre-existing value to the minimum.
		minimum = -INFINITY

	var/updated_blood_volume = set_blood_volume(cached_blood_volume + amount, minimum = minimum, maximum = maximum, cached_blood_volume = cached_blood_volume)
	return updated_blood_volume - cached_blood_volume

/// Updates effects that rely on whether the mob can have blood.
/mob/living/proc/update_blood_status()
	var/had_blood = CAN_HAVE_BLOOD(src)
	var/has_blood = can_have_blood()

	// Must not return early on first init for mobs that can have blood. (otherwise they will miss being added to the blood hud)
	if (had_blood == has_blood)
		return

	var/old_blood_volume = get_blood_volume()

	// Must be sent before living flags are updated.
	SEND_SIGNAL(src, COMSIG_LIVING_PRE_UPDATE_BLOOD_STATUS, had_blood, has_blood, old_blood_volume)

	living_flags = has_blood ? (living_flags | LIVING_CAN_HAVE_BLOOD) : (living_flags & ~LIVING_CAN_HAVE_BLOOD)

	set_blood_volume(has_blood ? default_blood_volume : 0)

	var/new_blood_volume = get_blood_volume()

	// Must be sent after living flags are updated.
	SEND_SIGNAL(src, COMSIG_LIVING_UPDATE_BLOOD_STATUS, had_blood, has_blood, old_blood_volume, new_blood_volume)

	/*
	var/datum/atom_hud/data/human/blood/blood_hud = GLOB.huds[DATA_HUD_BLOOD]

	if (has_blood)
		blood_hud.add_atom_to_hud(src)
	else
		blood_hud.remove_atom_from_hud(src)
	*/

	update_blood_effects()

/// Updates effects that rely on blood volume or status, like blood HUDs.
/mob/living/proc/update_blood_effects()
	living_flags &= ~BLOOD_UPDATE_QUEUED
	// blood_hud_set_status()
