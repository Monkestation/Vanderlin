/obj/item/bodypart
	/// List of /datum/wound instances affecting this bodypart
	var/list/datum/wound/wounds
	/// List of items embedded in this bodypart
	var/list/obj/item/embedded_objects = list()
	/// Bandage, if this ever hard dels thats fucking dumb lol
	var/obj/item/natural/cloth/bandage
	///are we able to bleed?
	var/bleeds = TRUE

/// Checks if we have any embedded objects whatsoever
/obj/item/bodypart/proc/has_embedded_objects()
	return length(embedded_objects)

/// Checks if we have an embedded object of a specific type
/obj/item/bodypart/proc/has_embedded_object(path, specific = FALSE)
	if(!path)
		return
	for(var/obj/item/embedder as anything in embedded_objects)
		if((specific && embedder.type != path) || !istype(embedder, path))
			continue
		return embedder

/// Checks if an object is embedded in us
/obj/item/bodypart/proc/is_object_embedded(obj/item/embedder)
	if(!embedder)
		return FALSE
	return (embedder in embedded_objects)

/// Returns all wounds on this limb that can be sewn
/obj/item/bodypart/proc/get_sewable_wounds()
	var/list/woundies = list()
	for(var/datum/wound/wound as anything in wounds)
		if(!wound.can_sew)
			continue
		woundies += wound
	return woundies

/// Returns the first wound of the specified type on this bodypart
/obj/item/bodypart/proc/has_wound(path, specific = FALSE)
	if(!path)
		return
	if(!specific)
		return locate(path) in wounds
	for(var/datum/wound/wound as anything in wounds)
		if((wound.type != path))
			continue
		return wound

/// Like [has_wound] but returns all wounds
/obj/item/bodypart/proc/get_all_wounds_type(path, specific = FALSE)
	if(!path)
		return
	var/list/returned_wounds = list()
	for(var/datum/wound/wound as anything in wounds)
		if(specific && wound.type != path)
			continue
		else if(istype(wound, path))
			returned_wounds += wound

	return returned_wounds

/// Heals wounds on this bodypart by the specified amount
/obj/item/bodypart/proc/heal_wounds(heal_amount, datum/source, forced = FALSE)
	if(!length(wounds))
		return FALSE
	var/healed_any = FALSE
	for(var/datum/wound/wound as anything in wounds)
		if(heal_amount <= 0)
			continue
		var/amount_healed = wound.heal_wound(heal_amount, source, forced)
		heal_amount -= amount_healed
		healed_any = TRUE
	return healed_any

/// Adds a wound to this bodypart, applying any necessary effects
/obj/item/bodypart/proc/add_wound(datum/wound/wound, silent = FALSE, crit_message = FALSE, forced = FALSE)
	if(!wound || !owner)
		return
	if(!forced && (owner.status_flags & GODMODE))
		return
	if(ispath(wound, /datum/wound))
		var/datum/wound/primordial_wound = GLOB.primordial_wounds[wound]
		if(!primordial_wound.can_apply_to_bodypart(src))
			return
		wound = new wound()
	else if(!istype(wound))
		return
	else if(!wound.can_apply_to_bodypart(src))
		qdel(wound)
		return
	if(!wound.apply_to_bodypart(src, silent, crit_message))
		qdel(wound)
		return
	if(owner && COOLDOWN_FINISHED(owner, adrenaline_burst))
		COOLDOWN_START(owner, adrenaline_burst, 45 SECONDS)
		owner.reagents?.add_reagent(/datum/reagent/adrenaline, 12)
	return wound

/// Removes a wound from this bodypart, removing any associated effects
/obj/item/bodypart/proc/remove_wound(datum/wound/wound)
	if(ispath(wound))
		wound = has_wound(wound)
	if(!istype(wound))
		return FALSE
	. = wound.remove_from_bodypart()
	if(.)
		qdel(wound)

/// Check to see if we can apply a bleeding wound on this bodypart
/obj/item/bodypart/proc/can_bloody_wound()
	if(skeletonized)
		return FALSE
	if(!is_organic_limb())
		return FALSE
	if(NOBLOOD in owner?.dna?.species?.species_traits)
		return FALSE
	return TRUE

/// Returns the total bleed rate on this bodypart
/obj/item/bodypart/proc/get_bleed_rate()
	if(NOBLOOD in owner?.dna?.species?.species_traits)
		return 0
	if(!bleeds)
		return 0
	var/bleed_rate = 0
	if(bandage && !GET_ATOM_BLOOD_DNA_LENGTH(bandage))
		return 0
	for(var/datum/wound/wound as anything in wounds)
		bleed_rate += (wound.bleed_rate * owner.dna.species.bleed_mod)

	for(var/datum/injury/injury as anything in injuries)
		if(injury.is_bleeding())
			bleed_rate += injury.get_bleed_rate()

	for(var/obj/item/embedded as anything in embedded_objects)
		if(!embedded.embedding.embedded_bloodloss)
			continue
		bleed_rate += embedded.embedding.embedded_bloodloss
	if(bandage)
		bleed_rate *= bandage?.bandage_effectiveness
	for(var/obj/item/grabbing/grab in grabbedby)
		bleed_rate *= grab.bleed_suppressing
	bleed_rate = max(round(bleed_rate, 0.1), 0)
	var/surgery_flags = get_surgery_flags()
	if(surgery_flags & SURGERY_CLAMPED)
		bleed_rate = min(bleed_rate, 0.5)
	switch(burn_dam/max_damage)
		if(0.75 to INFINITY)
			bleed_rate += 5
	return bleed_rate

/// Called in two cases, as an override to an attack after IE apply_damage on a zone. Or After an attack to return a wound.
/obj/item/bodypart/proc/bodypart_attacked_by(bclass, dam, mob/living/user, zone_precise, silent = FALSE, crit_message = FALSE, list/modifiers = list(), incoming_germ, organ_bonus, pre_applied = FALSE)
	if(!bclass || !dam || !owner || (owner.status_flags & GODMODE))
		return
	dam *= damage_multiplier
	if(dam < 5)
		if(CEILING(dam, 1) < 5)
			return
		dam = CEILING(dam, 1)

	var/do_crit = (modifiers[CRIT_MOD_CHANCE] <= -100) ? FALSE : TRUE
	if(do_crit && ishuman(owner))
		var/mob/living/carbon/human/human_owner = owner
		if(human_owner.check_crit_armor(zone_precise, bclass))
			do_crit = FALSE

	if(user)
		if(user.stat_roll(STAT_FORTUNE, 2, 10))
			dam += 10
		if(ispath(user.rmb_intent?.type, /datum/rmb_intent/weak))
			do_crit = FALSE

	var/wounding_type = WOUND_NONE
	if(isnum(bclass))
		wounding_type = bclass
	else
		switch(bclass)
			if(BCLASS_BLUNT, BCLASS_SMASH, BCLASS_PUNCH)
				wounding_type = WOUND_BLUNT
			if(BCLASS_DRILL, BCLASS_PICK, BCLASS_PIERCE, BCLASS_SHOT)
				wounding_type = WOUND_PIERCE
			if(BCLASS_CUT, BCLASS_CHOP)
				wounding_type = WOUND_SLASH
			if(BCLASS_STAB)
				wounding_type = WOUND_PIERCE
			if(BCLASS_TWIST)
				wounding_type = WOUND_BLUNT
			if(BCLASS_BITE)
				wounding_type = WOUND_BITE
			if(BCLASS_BURN)
				wounding_type = WOUND_BURN
			if(BCLASS_LASHING)
				wounding_type = WOUND_LASH

	if(wounding_type == WOUND_NONE)
		return

	if((zone_precise in list(BODY_ZONE_PRECISE_L_EYE, BODY_ZONE_PRECISE_L_EYE)) && wounding_type == WOUND_PIERCE)
		organ_bonus = CANT_ORGAN

	if(organ_bonus != CANT_ORGAN)
		damage_internal_organs(wounding_type, dam, organ_bonus, 0, wound_messages = TRUE)

	for(var/datum/injury/iter_injury as anything in injuries)
		iter_injury.receive_damage(dam, 0, wounding_type)

	var/datum/injury/injury = create_injury(wounding_type, dam)
	//if(!istype(injury))
		//stack_trace("spec_attacked_by failed to create injury with [dam] damage and [wounding_type] wounding type!")

	if(incoming_germ && injury)
		injury.adjust_germ_level(incoming_germ * 0.1)

	update_damages()

	/*
	for(var/datum/wound/iter_wound as anything in wounds)
		iter_wound.receive_damage(wounding_type, dam, 0)
	*/

	if(do_crit)
		var/crit_attempt = try_crit(bclass, dam, user, zone_precise, silent, crit_message, modifiers)
		if(crit_attempt)
			return crit_attempt

/obj/item/bodypart/proc/try_crit(bclass, dam, mob/living/user, zone_precise, silent = FALSE, crit_message = FALSE, list/modifiers = list())
	if(!bclass || isnum(bclass) || !dam || (owner.status_flags & GODMODE))
		return FALSE
	if(dam < 5)
		return FALSE

	var/damage_dividend = get_damage() / max_damage

	// Collect candidate wounds valid for this bodypart zone
	var/list/candidates = list()
	for(var/wound_type in GLOB.primordial_wounds)
		var/datum/wound/primordial = GLOB.primordial_wounds[wound_type]
		if(IS_ABSTRACT(primordial))
			continue
		if(!primordial.can_roll)
			continue
		var/chance = primordial.get_crit_prob(bclass, dam, damage_dividend, user, src, zone_precise, modifiers)
		if(chance <= 0)
			continue
		if(!primordial.can_apply_to_bodypart(src))
			continue
		if(prob(chance))
			candidates += wound_type

	if(!length(candidates))
		return FALSE

	for(var/wound_type in shuffle(candidates))
		var/datum/wound/applied = add_wound(wound_type, silent, crit_message)
		if(applied)
			applied.on_crit_applied(src, user, zone_precise, modifiers)
			if(user?.client)
				record_round_statistic(STATS_CRITS_MADE)
			return applied

	return FALSE

/obj/item/bodypart/chest/try_crit(bclass, dam, mob/living/user, zone_precise, silent, crit_message, list/modifiers)
	if(zone_precise == BODY_ZONE_PRECISE_GROIN && (bclass in CBT_BCLASSES))
		var/cbt_multiplier = (user && HAS_TRAIT(user, TRAIT_NUTCRACKER)) ? 2 : 1
		if(prob(dam * cbt_multiplier))
			owner.emote("groin", TRUE)
			owner.Stun(10)
	return ..()

/obj/item/bodypart/head/try_crit(bclass, dam, mob/living/user, zone_precise, silent, crit_message, list/modifiers)
	var/static/list/knockout_zones = list(BODY_ZONE_PRECISE_NOSE, BODY_ZONE_PRECISE_EARS, BODY_ZONE_PRECISE_SKULL, BODY_ZONE_PRECISE_R_EYE, BODY_ZONE_PRECISE_L_EYE)

	if(!owner.stat && (zone_precise in knockout_zones) && !(bclass in NO_KNOCKOUT_BCLASSES) && (bclass in FRACTURE_BCLASSES))
		var/damage_dividend = get_damage() / max_damage
		var/calc_dam = dam
		if(HAS_TRAIT(src, TRAIT_BRITTLE))
			calc_dam += 20
		if(user && istype(user.rmb_intent, /datum/rmb_intent/strong))
			calc_dam += 10
		var/used = round(damage_dividend * 20 + (calc_dam / 6), 1) + (modifiers[CRIT_MOD_CHANCE] || 0) + (modifiers[CRIT_MOD_KNOCKOUT_CHANCE] || 0)
		if(HAS_TRAIT(src, TRAIT_CRITICAL_RESISTANCE))
			used -= 10
		if(prob(used))
			var/from_behind = user && (owner.dir == REVERSE_DIR(get_dir(owner, user)))
			owner.next_attack_msg += " [span_crit("<b>Critical hit!</b> [owner] is knocked out[from_behind ? " FROM BEHIND" : ""]!")]"
			owner.flash_fullscreen("whiteflash3")
			owner.Unconscious(15 SECONDS + (from_behind * 15 SECONDS))
			if(owner.client)
				winset(owner.client, "outputwindow.output", "max-lines=1")
				winset(owner.client, "outputwindow.output", "max-lines=100")
			return TRUE // short circuit, no wound applied

	return ..() // fall through to generic try_crit

/// Embeds an object in this bodypart
/obj/item/bodypart/proc/add_embedded_object(obj/item/embedder, silent = FALSE, crit_message = FALSE)
	if(!embedder || !embedder.can_embed())
		return FALSE
	if(owner && ((owner.status_flags & GODMODE) || HAS_TRAIT(owner, TRAIT_PIERCEIMMUNE)))
		return FALSE
	if(istype(embedder, /obj/item/natural/worms/leech))
		record_round_statistic(STATS_LEECHES_EMBEDDED)
	LAZYADD(embedded_objects, embedder)
	embedder.is_embedded = TRUE
	embedder.forceMove(src)
	embedder.embedded(owner, src)

	var/static/list/clamping_behaviors = list(
		TOOL_HEMOSTAT,
		TOOL_WIRECUTTER,
		TOOL_IMPROVISED_HEMOSTAT,
	)

	if((embedder.tool_behaviour in clamping_behaviors))
		clamp_limb()

	if(owner)
		embedder.add_mob_blood(owner)
		if(!silent)
			owner.emote("embed")
			playsound(owner, 'sound/combat/newstuck.ogg', 100, vary = TRUE)
		if(crit_message)
			owner.next_attack_msg += " <span class='userdanger'>[embedder] runs through [owner]'s [src.name]!</span>"
		if(can_be_disabled)
			update_disabled()
	return TRUE

/// Removes an embedded object from this bodypart
/obj/item/bodypart/proc/remove_embedded_object(obj/item/embedder)
	if(!embedder)
		return FALSE
	if(ispath(embedder))
		embedder = has_embedded_object(embedder)
	if(!istype(embedder) || !is_object_embedded(embedder))
		return FALSE
	LAZYREMOVE(embedded_objects, embedder)
	embedder.is_embedded = FALSE
	embedder.unembedded(owner)

	var/static/list/clamping_behaviors = list(
		TOOL_HEMOSTAT,
		TOOL_WIRECUTTER,
		TOOL_IMPROVISED_HEMOSTAT,
	)

	if((embedder.tool_behaviour in clamping_behaviors))
		unclamp_limb()

	if(!QDELETED(embedder))
		var/drop_location = owner?.drop_location() || drop_location()
		if(drop_location)
			embedder.forceMove(drop_location)
		else
			qdel(embedder)
	if(owner)
		if(!owner.has_embedded_objects())
			owner.clear_alert("embeddedobject")
			owner.remove_stress(/datum/stress_event/embedded)
		if(can_be_disabled)
			update_disabled()
	return TRUE

/obj/item/bodypart/proc/try_bandage(obj/item/new_bandage)
	if(!new_bandage)
		return FALSE
	bandage = new_bandage
	bandage_limb()
	new_bandage.forceMove(src)
	return TRUE

/obj/item/bodypart/proc/try_bandage_expire()
	var/bleed_rate = get_bleed_rate()
	if(!bandage)
		return FALSE
	if(!bleed_rate)
		return FALSE

	var/bandage_health = 1
	if(istype(bandage, /obj/item/natural/cloth))
		var/obj/item/natural/cloth/cloth = bandage

		if(cloth.reagents && cloth.reagents.total_volume > 0)
			if(owner && owner.reagents)
				for(var/datum/reagent/R in cloth.reagents.reagent_list)
					var/amount_to_transfer = min(R.volume, R.metabolization_rate)
					if(amount_to_transfer > 0)

						R.on_bodypart_absorb(src, owner, amount_to_transfer)
						cloth.reagents.remove_reagent(R.type, amount_to_transfer)

		if(owner)
			owner.transfer_blood_to(cloth, bleed_rate * 0.25)

		cloth.bandage_health -= bleed_rate
		bandage_health = cloth.bandage_health

	if(bandage_health <= 0)
		return bandage_expire()
	return FALSE

/obj/item/bodypart/proc/bandage_expire()
	if(!owner)
		return FALSE
	if(!bandage)
		return FALSE
	if(owner.stat != DEAD)
		to_chat(owner, span_warning("Blood soaks through the bandage on my [name]."))
		bandage.bandage_effectiveness = 1
	return bandage.add_mob_blood(owner)

/obj/item/bodypart/proc/remove_bandage()
	if(!bandage)
		return FALSE
	var/drop_location = owner?.drop_location() || drop_location()
	if(drop_location)
		bandage.forceMove(drop_location)
	else
		qdel(bandage)
	bandage = null
	unbandage_limb()
	owner?.update_damage_overlays()
	return TRUE

/// Applies a temporary paralysis effect to this bodypart
/obj/item/bodypart/proc/temporary_crit_paralysis(duration = 60 SECONDS, brittle = TRUE)
	if(!can_be_disabled)
		return
	if(HAS_TRAIT(src, TRAIT_BRITTLE))
		return FALSE
	ADD_TRAIT(src, TRAIT_PARALYSIS, CRIT_TRAIT)
	if(brittle)
		ADD_TRAIT(src, TRAIT_BRITTLE, CRIT_TRAIT)
	addtimer(CALLBACK(src, PROC_REF(remove_crit_paralysis)), duration)
	if(owner)
		update_disabled()
	return TRUE

/// Removes the temporary paralysis effect from this bodypart
/obj/item/bodypart/proc/remove_crit_paralysis()
	REMOVE_TRAIT(src, TRAIT_PARALYSIS, CRIT_TRAIT)
	REMOVE_TRAIT(src, TRAIT_BRITTLE, CRIT_TRAIT)
	if(owner)
		update_disabled()
	return TRUE

/// Returns surgery flags applicable to this bodypart
/obj/item/bodypart/proc/get_surgery_flags()
	var/returned_flags = NONE
	if(can_bloody_wound())
		returned_flags |= SURGERY_BLOODY

	for(var/datum/injury/slash/slash in injuries)
		if(slash.is_bandaged() || slash.current_stage > slash.max_bleeding_stage) // Shit's unusable
			continue
		returned_flags |= SURGERY_INCISED
		break
	var/static/list/retracting_behaviors = list(
		TOOL_RETRACTOR,
		TOOL_CROWBAR,
		TOOL_IMPROVISED_RETRACTOR,
	)
	var/static/list/clamping_behaviors = list(
		TOOL_HEMOSTAT,
		TOOL_WIRECUTTER,
		TOOL_IMPROVISED_HEMOSTAT,
	)
	for(var/obj/item/embedded as anything in embedded_objects)
		if((embedded.tool_behaviour in retracting_behaviors) || embedded.embedding?.retract_limbs)
			returned_flags |= SURGERY_RETRACTED
		if((embedded.tool_behaviour in clamping_behaviors) || embedded.embedding?.clamp_limbs)
			returned_flags |= SURGERY_CLAMPED
	if(has_wound(/datum/wound/dislocation))
		returned_flags |= SURGERY_DISLOCATED
	if(has_wound(/datum/wound/fracture))
		returned_flags |= SURGERY_BROKEN
	if(skeletonized)
		returned_flags |= SURGERY_INCISED //ehh... we have access to whatever organ is there
	return returned_flags

/obj/item/bodypart/proc/is_retracted()
	var/static/list/retracting_behaviors = list(
		TOOL_RETRACTOR,
		TOOL_CROWBAR,
		TOOL_IMPROVISED_RETRACTOR,
	)

	for(var/obj/item/embedded as anything in embedded_objects)
		if((embedded.tool_behaviour in retracting_behaviors) || embedded.embedding?.retract_limbs)
			return TRUE
	return FALSE
