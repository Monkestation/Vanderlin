/obj/item/bodypart
	/// List of /datum/wound instances affecting this bodypart
	var/list/datum/wound/wounds
	/// List of items embedded in this bodypart
	var/list/obj/item/embedded_objects = list()
	/// Bandage, if this ever hard dels thats fucking dumb lol
	var/obj/item/natural/cloth/bandage

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
/obj/item/bodypart/proc/heal_wounds(heal_amount)
	if(!length(wounds))
		return FALSE
	var/healed_any = FALSE
	for(var/datum/wound/wound as anything in wounds)
		if(heal_amount <= 0)
			continue
		var/amount_healed = wound.heal_wound(heal_amount)
		heal_amount -= amount_healed
		healed_any = TRUE
	return healed_any

/// Adds a wound to this bodypart, applying any necessary effects
/obj/item/bodypart/proc/add_wound(datum/wound/wound, silent = FALSE, crit_message = FALSE)
	if(!wound || !owner || (owner.status_flags & GODMODE))
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
	var/bleed_rate = 0
	if(bandage && !GET_ATOM_BLOOD_DNA_LENGTH(bandage))
		return 0
	for(var/datum/wound/wound as anything in wounds)
		bleed_rate += (wound.bleed_rate * owner.dna.species.bleed_mod)
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

/// Called after a bodypart is attacked so that wounds and critical effects can be applied
/obj/item/bodypart/proc/bodypart_attacked_by(bclass, dam, mob/living/user, zone_precise, silent = FALSE, crit_message = FALSE, reduce_crit = 0)
	if(!bclass || !dam || !owner || (owner.status_flags & GODMODE))
		return FALSE

	if(dam < 5)
		return

	var/do_crit = TRUE

	if(ishuman(owner))
		var/mob/living/carbon/human/human_owner = owner
		if(human_owner.check_crit_armor(zone_precise, bclass))
			do_crit = FALSE

	if(user)
		if(user.stat_roll(STATKEY_LCK, 2, 10))
			dam += 10
		if(ispath(user.rmb_intent?.type, /datum/rmb_intent/weak))
			do_crit = FALSE

	if(do_crit)
		var/crit_attempt = try_crit(bclass, dam, user, zone_precise, silent, crit_message, reduce_crit)
		if(crit_attempt)
			return crit_attempt

	return manage_dynamic_wound(bclass, dam)

/// Add or upgrade a dynamic wound, returns the wound if added or upgraded
/obj/item/bodypart/proc/manage_dynamic_wound(bclass, damage)
	var/datum/wound/wound_type

	for(var/type in GLOB.primordial_wounds)
		// :(
		if(!ispath(type, /datum/wound/dynamic))
			continue
		var/datum/wound/dynamic/dynwound = GLOB.primordial_wounds[type]
		if(!length(dynwound.associated_bclasses))
			continue
		if(bclass in dynwound.associated_bclasses)
			wound_type = dynwound.type
			break

	if(!wound_type)
		return

	var/datum/wound/dynamic/changed_wound
	// We do this to get the first unsewn dynamic wound
	for(var/datum/wound/wound as anything in get_all_wounds_type(wound_type))
		if(wound.is_sewn()) // Sewn dynamic wounds are DONE because im LAZY no wound re-opening
			continue
		changed_wound = wound

	if(!changed_wound)
		changed_wound = add_wound(wound_type)

	changed_wound?.upgrade(bclass, damage)

	return changed_wound

/// Behemoth of a proc used to apply a wound after a bodypart is damaged in an attack
/obj/item/bodypart/proc/try_crit(bclass, dam, mob/living/user, zone_precise, silent = FALSE, crit_message = FALSE, reduce_crit = 0)
	if(!bclass || !dam || (owner.status_flags & GODMODE))
		return FALSE

	if(dam < 5)
		return FALSE

	var/list/crit_classes
	if(bclass in GLOB.dislocation_bclasses)
		LAZYADD(crit_classes, "dislocation")
	if(bclass in GLOB.fracture_bclasses)
		LAZYADD(crit_classes, "fracture")
	if(bclass in GLOB.artery_bclasses)
		LAZYADD(crit_classes, "artery")
	if(bclass in GLOB.whipping_bclasses)
		LAZYADD(crit_classes, "scarring")

	if(!crit_classes)
		return FALSE

	if(user?.stat_roll(STATKEY_LCK, 2, 10))
		dam += 10

	var/used
	used -= reduce_crit
	var/damage_dividend = (get_damage() / max_damage)
	var/list/attempted_wounds
	switch(pick(crit_classes))
		if("dislocation")
			if(damage_dividend < 0.4)
				return
			if(user && istype(user.rmb_intent, /datum/rmb_intent/strong))
				dam += 10
			used = round(damage_dividend * 20 + (dam / 6), 1)
			if(HAS_TRAIT(src, TRAIT_CRITICAL_RESISTANCE))
				used -= 10
			if(prob(used))
				if(HAS_TRAIT(src, TRAIT_BRITTLE))
					LAZYADD(attempted_wounds, /datum/wound/fracture)
				else
					LAZYADD(attempted_wounds, /datum/wound/dislocation)
		if("fracture")
			if(damage_dividend < 0.3)
				return
			if(user && istype(user.rmb_intent, /datum/rmb_intent/strong))
				dam += 10
			if(HAS_TRAIT(src, TRAIT_BRITTLE))
				dam += 10
			used = round(damage_dividend * 20 + (dam / 6), 1)
			if(HAS_TRAIT(src, TRAIT_CRITICAL_RESISTANCE))
				used -= 10
			if(prob(used))
				if(damage_dividend >= 0.6)
					LAZYADD(attempted_wounds, /datum/wound/fracture)
				else
					LAZYADD(attempted_wounds, /datum/wound/dislocation)
		if("artery")
			if(user)
				if((bclass in GLOB.artery_strong_bclasses) && istype(user.rmb_intent, /datum/rmb_intent/strong))
					dam += 10
				else if(istype(user.rmb_intent, /datum/rmb_intent/aimed))
					dam += 10
			used = round(damage_dividend * 20 + (dam / 6), 1)
			if(HAS_TRAIT(src, TRAIT_CRITICAL_RESISTANCE))
				used -= 10
			if(prob(used))
				LAZYADD(attempted_wounds, /datum/wound/artery)
		if("scarring")
			if(user && istype(user.rmb_intent, /datum/rmb_intent/strong))
				dam += 10
			used = round(damage_dividend * 20 + (dam / 6), 1)
			if(HAS_TRAIT(src, TRAIT_CRITICAL_RESISTANCE))
				used -= 10
			if(prob(used))
				LAZYADD(attempted_wounds, /datum/wound/scarring)

	if(!attempted_wounds)
		return FALSE

	for(var/wound_type in shuffle(attempted_wounds))
		var/datum/wound/applied = add_wound(wound_type, silent, crit_message)
		if(applied)
			if(user?.client)
				record_round_statistic(STATS_CRITS_MADE)
			return applied
	return FALSE

/obj/item/bodypart/chest/try_crit(bclass, dam, mob/living/user, zone_precise, silent = FALSE, crit_message = FALSE)
	if(!bclass || !dam || (owner.status_flags & GODMODE))
		return FALSE

	if(dam < 5)
		return FALSE

	var/list/crit_classes
	if(bclass in GLOB.cbt_classes)
		LAZYADD(crit_classes, "cbt")
	if(bclass in GLOB.fracture_bclasses)
		LAZYADD(crit_classes, "fracture")
	if(bclass in GLOB.artery_bclasses)
		LAZYADD(crit_classes, "artery")
	if(bclass in GLOB.whipping_bclasses)
		LAZYADD(crit_classes, "scarring")

	if(!crit_classes)
		return FALSE

	if(user?.stat_roll(STATKEY_LCK,2,10))
		dam += 10

	var/used
	var/damage_dividend = (get_damage() / max_damage)
	var/resistance = HAS_TRAIT(owner, TRAIT_CRITICAL_RESISTANCE)
	var/list/attempted_wounds
	switch(pick(crit_classes))
		if("cbt")
			if(zone_precise == BODY_ZONE_PRECISE_GROIN)
				var/cbt_multiplier = 1
				if(user && HAS_TRAIT(user, TRAIT_NUTCRACKER))
					cbt_multiplier = 2
				if(!resistance && prob(round(dam/5) * cbt_multiplier))
					LAZYADD(attempted_wounds, /datum/wound/cbt)
				if(prob(dam * cbt_multiplier))
					owner.emote("groin", TRUE)
					owner.Stun(10)
		if("fracture")
			if(zone_precise != BODY_ZONE_PRECISE_STOMACH)
				if(damage_dividend < 0.4)
					return
				if(user && istype(user.rmb_intent, /datum/rmb_intent/strong))
					dam += 10
				if(HAS_TRAIT(src, TRAIT_BRITTLE))
					dam += 10
				used = round(damage_dividend * 20 + (dam / 6), 1)
				if(HAS_TRAIT(src, TRAIT_CRITICAL_RESISTANCE))
					used -= 10
				var/fracture_type = /datum/wound/fracture/chest
				if(zone_precise == BODY_ZONE_PRECISE_GROIN)
					if(damage_dividend >= 0.7) // Lower body paralysis
						fracture_type = /datum/wound/fracture/groin
				if(prob(used))
					LAZYADD(attempted_wounds, fracture_type)
		if("artery")
			if(user && (bclass in GLOB.artery_strong_bclasses) && istype(user.rmb_intent, /datum/rmb_intent/strong))
				dam += 10
			else if(user && istype(user.rmb_intent, /datum/rmb_intent/aimed))
				dam += 10
			used = round(damage_dividend * 20 + (dam / 6), 1)
			if(HAS_TRAIT(src, TRAIT_CRITICAL_RESISTANCE))
				used -= 10
			if(prob(used))
				if((zone_precise == BODY_ZONE_PRECISE_STOMACH) && !resistance)
					LAZYADD(attempted_wounds, /datum/wound/slash/disembowel)
				if(owner.has_wound(/datum/wound/fracture/chest) || (bclass in GLOB.artery_heart_bclasses))
					LAZYADD(attempted_wounds, /datum/wound/artery/chest)
				else
					LAZYADD(attempted_wounds, /datum/wound/artery)
		if("scarring")
			if(user && istype(user.rmb_intent, /datum/rmb_intent/strong))
				dam += 10
			used = round(damage_dividend * 20 + (dam / 6), 1)
			if(HAS_TRAIT(src, TRAIT_CRITICAL_RESISTANCE))
				used -= 10
			if(prob(used))
				LAZYADD(attempted_wounds, /datum/wound/scarring)

	if(!attempted_wounds)
		return FALSE

	for(var/wound_type in shuffle(attempted_wounds))
		var/datum/wound/applied = add_wound(wound_type, silent, crit_message)
		if(applied)
			if(user?.client)
				record_round_statistic(STATS_CRITS_MADE)
			return applied
	return FALSE

/obj/item/bodypart/head/try_crit(bclass, dam, mob/living/user, zone_precise, silent = FALSE, crit_message = FALSE)
	var/static/list/eyestab_zones = list(BODY_ZONE_PRECISE_R_EYE, BODY_ZONE_PRECISE_L_EYE)
	var/static/list/tonguestab_zones = list(BODY_ZONE_PRECISE_MOUTH)
	var/static/list/nosestab_zones = list(BODY_ZONE_PRECISE_NOSE)
	var/static/list/earstab_zones = list(BODY_ZONE_PRECISE_EARS)
	var/static/list/knockout_zones = list(BODY_ZONE_PRECISE_NOSE, BODY_ZONE_PRECISE_EARS, BODY_ZONE_PRECISE_SKULL, BODY_ZONE_PRECISE_R_EYE, BODY_ZONE_PRECISE_L_EYE, BODY_ZONE_PRECISE_MOUTH)

	if(dam < 5)
		return FALSE

	var/list/crit_classes
	if(bclass in GLOB.dislocation_bclasses)
		LAZYADD(crit_classes, "dislocation")
	if(bclass in GLOB.fracture_bclasses)
		LAZYADD(crit_classes, "fracture")
	if(bclass in GLOB.artery_bclasses)
		LAZYADD(crit_classes, "artery")

	if(!crit_classes)
		return FALSE

	if(user?.stat_roll(STATKEY_LCK, 2, 10))
		dam += 10

	var/from_behind = FALSE
	if(user)
		if((owner.dir == REVERSE_DIR(get_dir(owner, user))))
			from_behind = TRUE

	var/used
	var/damage_dividend = (get_damage() / max_damage)
	var/resistance = HAS_TRAIT(owner, TRAIT_CRITICAL_RESISTANCE)
	var/list/attempted_wounds
	switch(pick(crit_classes))
		if("dislocation")
			if(damage_dividend >= 1)
				used = round(damage_dividend * 20 + (dam / 6), 1)
				if(HAS_TRAIT(src, TRAIT_CRITICAL_RESISTANCE))
					used -= 10
				if(prob(used))
					if(HAS_TRAIT(src, TRAIT_BRITTLE))
						LAZYADD(attempted_wounds, /datum/wound/fracture/neck)
					else
						LAZYADD(attempted_wounds, /datum/wound/dislocation/neck)
		if("fracture")
			if(HAS_TRAIT(src, TRAIT_BRITTLE))
				dam += 20
			if(user && istype(user.rmb_intent, /datum/rmb_intent/strong))
				dam += 10
			used = round(damage_dividend * 20 + (dam / 6), 1)
			if(HAS_TRAIT(src, TRAIT_CRITICAL_RESISTANCE))
				used -= 10
			if(!owner.stat && (zone_precise in knockout_zones) && !(bclass in GLOB.no_knockout_bclasses) && prob(used))
				owner.next_attack_msg += " [span_crit("<b>Critical hit!</b> [owner] is knocked out[from_behind ? " FROM BEHIND" : ""]!")]"
				owner.flash_fullscreen("whiteflash3")
				owner.Unconscious(15 SECONDS + (from_behind * 15 SECONDS))
				if(owner.client)
					winset(owner.client, "outputwindow.output", "max-lines=1")
					winset(owner.client, "outputwindow.output", "max-lines=100")
				return
			var/dislocation_type
			var/fracture_type = /datum/wound/fracture/head
			var/necessary_damage = 0.95
			if(resistance)
				fracture_type = /datum/wound/fracture
			else if(zone_precise == BODY_ZONE_PRECISE_SKULL)
				fracture_type = /datum/wound/fracture/head/brain
			else if(zone_precise == BODY_ZONE_PRECISE_EARS)
				fracture_type = /datum/wound/fracture/head/ears
			else if(zone_precise == BODY_ZONE_PRECISE_R_EYE || zone_precise == BODY_ZONE_PRECISE_L_EYE)
				fracture_type = /datum/wound/fracture/head/eyes
				necessary_damage = 0.9
			else if(zone_precise == BODY_ZONE_PRECISE_NOSE)
				fracture_type = /datum/wound/fracture/head/nose
				necessary_damage = 0.7
			else if(zone_precise == BODY_ZONE_PRECISE_MOUTH)
				fracture_type = /datum/wound/fracture/mouth
				necessary_damage = 0.7
			else if(zone_precise == BODY_ZONE_PRECISE_NECK)
				fracture_type = /datum/wound/fracture/neck
				dislocation_type = /datum/wound/dislocation/neck
			if(prob(used) && (damage_dividend >= necessary_damage))
				if(dislocation_type)
					LAZYADD(attempted_wounds, dislocation_type)
				LAZYADD(attempted_wounds, fracture_type)
		if("artery")
			if(user)
				if(bclass == BCLASS_CHOP && istype(user.rmb_intent, /datum/rmb_intent/strong))
					dam += 10
				else
					if(istype(user.rmb_intent, /datum/rmb_intent/aimed))
						dam += 10
			used = round(damage_dividend * 20 + (dam / 6), 1)
			if(HAS_TRAIT(src, TRAIT_CRITICAL_RESISTANCE))
				used -= 10
			if(prob(used))
				var/artery_type = /datum/wound/artery
				if(zone_precise == BODY_ZONE_PRECISE_NECK)
					artery_type = /datum/wound/artery/neck
				LAZYADD(attempted_wounds, artery_type)
				if((bclass in GLOB.stab_bclasses) && !resistance)
					if(zone_precise in earstab_zones)
						var/obj/item/organ/ears/my_ears = owner.getorganslot(ORGAN_SLOT_EARS)
						if(!my_ears || has_wound(/datum/wound/facial/ears))
							LAZYADD(attempted_wounds, /datum/wound/fracture/head/ears)
						else
							LAZYADD(attempted_wounds, /datum/wound/facial/ears)
					else if(zone_precise in eyestab_zones)
						var/obj/item/organ/my_eyes = owner.getorganslot(ORGAN_SLOT_EYES)
						if(!my_eyes || (has_wound(/datum/wound/facial/eyes/left) && has_wound(/datum/wound/facial/eyes/right)))
							LAZYADD(attempted_wounds, /datum/wound/fracture/head/eyes)
						else if(my_eyes)
							if(zone_precise == BODY_ZONE_PRECISE_R_EYE)
								LAZYADD(attempted_wounds, /datum/wound/facial/eyes/right)
							else if(zone_precise == BODY_ZONE_PRECISE_L_EYE)
								LAZYADD(attempted_wounds, /datum/wound/facial/eyes/left)
					else if(zone_precise in tonguestab_zones)
						var/obj/item/organ/tongue/tongue_up_my_asshole = owner.getorganslot(ORGAN_SLOT_TONGUE)
						if(!tongue_up_my_asshole || has_wound(/datum/wound/facial/tongue))
							LAZYADD(attempted_wounds, /datum/wound/fracture/mouth)
						else
							LAZYADD(attempted_wounds, /datum/wound/facial/tongue)
					else if(zone_precise in nosestab_zones)
						if(has_wound(/datum/wound/facial/disfigurement/nose))
							LAZYADD(attempted_wounds, /datum/wound/fracture/head/nose)
						else
							LAZYADD(attempted_wounds, /datum/wound/facial/disfigurement/nose)
					else if(zone_precise in knockout_zones)
						LAZYADD(attempted_wounds, /datum/wound/fracture/head/brain)

	if(!attempted_wounds)
		return FALSE

	for(var/wound_type in shuffle(attempted_wounds))
		var/datum/wound/applied = add_wound(wound_type, silent, crit_message)
		if(applied)
			if(user?.client)
				record_round_statistic(STATS_CRITS_MADE)
			return applied
	return FALSE

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
	for(var/datum/wound/slash/incision/incision in wounds)
		if(incision.is_sewn())
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
	for(var/datum/wound/puncture/drilling/drilling in wounds)
		if(drilling.is_sewn())
			continue
		returned_flags |= SURGERY_DRILLED
	if(skeletonized)
		returned_flags |= SURGERY_INCISED | SURGERY_RETRACTED | SURGERY_DRILLED //ehh... we have access to whatever organ is there
	return returned_flags
