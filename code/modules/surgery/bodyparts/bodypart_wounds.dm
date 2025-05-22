/obj/item/bodypart
	/// List of /datum/wound instances affecting this bodypart
	var/list/datum/wound/wounds
	/// List of items embedded in this bodypart
	var/list/obj/item/embedded_objects = list()
	/// Bandage, if this ever hard dels thats fucking dumb lol
	var/obj/item/bandage

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
	for(var/datum/wound/wound as anything in wounds)
		if((specific && wound.type != path) || !istype(wound, path))
			continue
		return wound

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
	if(bandage && !HAS_BLOOD_DNA(bandage))
		return 0
	for(var/datum/wound/wound as anything in wounds)
		bleed_rate += (wound.bleed_rate * owner.dna.species.bleed_mod)
	for(var/obj/item/embedded as anything in embedded_objects)
		if(!embedded.embedding.embedded_bloodloss)
			continue
		bleed_rate += embedded.embedding.embedded_bloodloss
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
/obj/item/bodypart/proc/bodypart_attacked_by(bclass, dam, mob/living/user, zone_precise, silent = FALSE, crit_message = FALSE)
	if(!bclass || !dam || !owner || (owner.status_flags & GODMODE))
		return FALSE
	if(ishuman(owner))
		var/mob/living/carbon/human/human_owner = owner
		if(human_owner.checkcritarmor(zone_precise, bclass))
			return FALSE
	var/do_crit = TRUE
	if(user)
		if(user.stat_roll(STATKEY_LCK,2,10))
			dam += 10
		if(istype(user.rmb_intent, /datum/rmb_intent/weak))
			do_crit = FALSE
	var/added_wound
	switch(bclass) //do stuff but only when we are a blade that adds wounds
		if(BCLASS_SMASH, BCLASS_BLUNT)
			switch(dam)
				if(20 to INFINITY)
					added_wound = /datum/wound/bruise/large
				if(10 to 20)
					added_wound = /datum/wound/bruise
				if(1 to 10)
					added_wound = /datum/wound/bruise/small
		if(BCLASS_CUT, BCLASS_CHOP)
			switch(dam)
				if(20 to INFINITY)
					added_wound = /datum/wound/slash/large
				if(10 to 20)
					added_wound = /datum/wound/slash
				if(1 to 10)
					added_wound = /datum/wound/slash/small
		if(BCLASS_STAB, BCLASS_PICK, BCLASS_SHOT)
			switch(dam)
				if(20 to INFINITY)
					added_wound = /datum/wound/puncture/large
				if(10 to 20)
					added_wound = /datum/wound/puncture
				if(1 to 10)
					added_wound = /datum/wound/puncture/small
		if(BCLASS_LASHING)
			switch(dam)
				if(20 to INFINITY)
					added_wound = /datum/wound/lashing/large
				if(10 to 20)
					added_wound = /datum/wound/lashing
				if(1 to 10)
					added_wound = /datum/wound/lashing/small
		if(BCLASS_BITE)
			switch(dam)
				if(20 to INFINITY)
					added_wound = /datum/wound/bite/large
				if(10 to 20)
					added_wound = /datum/wound/bite
				if(1 to 10)
					added_wound = /datum/wound/bite/small
	if(added_wound)
		added_wound = add_wound(added_wound, silent, crit_message)
	if(do_crit)
		var/crit_attempt = try_crit(bclass, dam, user, zone_precise, silent, crit_message)
		if(crit_attempt)
			return crit_attempt
	return added_wound

/// Behemoth of a proc used to apply a wound after a bodypart is damaged in an attack
/obj/item/bodypart/proc/try_crit(bclass, dam, mob/living/user, zone_precise, silent = FALSE, crit_message = FALSE)
	if(!bclass || !dam || (owner.status_flags & GODMODE))
		return FALSE
	var/list/attempted_wounds = list()
	var/used
	var/total_dam = get_damage()
	var/damage_dividend = (total_dam / max_damage)
	if(user && dam)
		if(user.stat_roll(STATKEY_LCK,2,10))
			dam += 10
	var/crit_classes = list()
	if(bclass in GLOB.dislocation_bclasses)
		crit_classes += "dislocation"
	if(bclass in GLOB.fracture_bclasses)
		crit_classes += "fracture"
	if(bclass in GLOB.artery_bclasses)
		crit_classes += "artery"
	if(bclass in GLOB.whipping_bclasses)
		crit_classes += "scarring"

	switch(pick(crit_classes))
		if("dislocation")
			if(user && istype(user.rmb_intent, /datum/rmb_intent/strong))
				dam += 10
			used = round(damage_dividend * 20 + (dam / 6), 1)
			if(prob(used))
				if(HAS_TRAIT(src, TRAIT_BRITTLE))
					attempted_wounds += /datum/wound/fracture
				else
					attempted_wounds += /datum/wound/dislocation
		if("fracture")
			if(user && istype(user.rmb_intent, /datum/rmb_intent/strong))
				dam += 10
			if(HAS_TRAIT(src, TRAIT_BRITTLE))
				dam += 10
			used = round(damage_dividend * 20 + (dam / 6), 1)
			if(prob(used))
				attempted_wounds += /datum/wound/dislocation
				attempted_wounds += /datum/wound/fracture
		if("artery")
			if(user)
				if((bclass in GLOB.artery_strong_bclasses) && istype(user.rmb_intent, /datum/rmb_intent/strong))
					dam += 10
				else if(istype(user.rmb_intent, /datum/rmb_intent/aimed))
					dam += 10
			used = round(damage_dividend * 20 + (dam / 6), 1)
			if(prob(used))
				attempted_wounds += /datum/wound/artery
		if("scarring")
			if(user && istype(user.rmb_intent, /datum/rmb_intent/strong))
				dam += 10
			used = round(damage_dividend * 20 + (dam / 6), 1)
			if(prob(used))
				attempted_wounds += /datum/wound/scarring

	for(var/wound_type in shuffle(attempted_wounds))
		var/datum/wound/applied = add_wound(wound_type, silent, crit_message)
		if(applied)
			if(user?.client)
				GLOB.vanderlin_round_stats[STATS_CRITS_MADE]++
			return applied
	return FALSE

/obj/item/bodypart/chest/try_crit(bclass, dam, mob/living/user, zone_precise, silent = FALSE, crit_message = FALSE)
	if(!bclass || !dam || (owner.status_flags & GODMODE))
		return FALSE
	var/list/attempted_wounds = list()
	var/used
	var/total_dam = get_damage()
	var/damage_dividend = (total_dam / max_damage)
	var/resistance = HAS_TRAIT(owner, TRAIT_CRITICAL_RESISTANCE)
	if(user && dam)
		if(user.stat_roll(STATKEY_LCK,2,10))
			dam += 10
	var/crit_classes = list()
	if(bclass in GLOB.cbt_classes)
		crit_classes += "cbt"
	if(bclass in GLOB.fracture_bclasses)
		crit_classes += "fracture"
	if(bclass in GLOB.artery_bclasses)
		crit_classes += "artery"
	if(bclass in GLOB.whipping_bclasses)
		crit_classes += "scarring"

	switch(pick(crit_classes))
		if("cbt")
			if(zone_precise == BODY_ZONE_PRECISE_GROIN)
				var/cbt_multiplier = 1
				if(user && HAS_TRAIT(user, TRAIT_NUTCRACKER))
					cbt_multiplier = 2
				if(!resistance && prob(round(dam/5) * cbt_multiplier))
					attempted_wounds += /datum/wound/cbt
				if(prob(dam * cbt_multiplier))
					owner.emote("groin", TRUE)
					owner.Stun(10)
		if("fracture")
			if(zone_precise != BODY_ZONE_PRECISE_STOMACH)
				if(user && istype(user.rmb_intent, /datum/rmb_intent/strong))
					dam += 10
				if(HAS_TRAIT(src, TRAIT_BRITTLE))
					dam += 10
				used = round(damage_dividend * 20 + (dam / 6), 1)
				var/fracture_type = /datum/wound/fracture/chest
				if(zone_precise == BODY_ZONE_PRECISE_GROIN)
					fracture_type = /datum/wound/fracture/groin
				if(prob(used))
					attempted_wounds += fracture_type
		if("artery")
			if(user && (bclass in GLOB.artery_strong_bclasses) && istype(user.rmb_intent, /datum/rmb_intent/strong))
				dam += 10
			else if(user && istype(user.rmb_intent, /datum/rmb_intent/aimed))
				dam += 10
			used = round(damage_dividend * 20 + (dam / 6), 1)
			if(prob(used))
				if((zone_precise == BODY_ZONE_PRECISE_STOMACH) && !resistance)
					attempted_wounds += /datum/wound/slash/disembowel
				if(owner.has_wound(/datum/wound/fracture/chest) || (bclass in GLOB.artery_heart_bclasses))
					attempted_wounds += /datum/wound/artery/chest
				else
					attempted_wounds += /datum/wound/artery
		if("scarring")
			if(user && istype(user.rmb_intent, /datum/rmb_intent/strong))
				dam += 10
			used = round(damage_dividend * 20 + (dam / 6), 1)
			if(prob(used))
				attempted_wounds += /datum/wound/scarring

	for(var/wound_type in shuffle(attempted_wounds))
		var/datum/wound/applied = add_wound(wound_type, silent, crit_message)
		if(applied)
			if(user?.client)
				GLOB.vanderlin_round_stats[STATS_CRITS_MADE]++
			return applied
	return FALSE

/obj/item/bodypart/head/try_crit(bclass, dam, mob/living/user, zone_precise, silent = FALSE, crit_message = FALSE)
	var/static/list/eyestab_zones = list(BODY_ZONE_PRECISE_R_EYE, BODY_ZONE_PRECISE_L_EYE)
	var/static/list/tonguestab_zones = list(BODY_ZONE_PRECISE_MOUTH)
	var/static/list/nosestab_zones = list(BODY_ZONE_PRECISE_NOSE)
	var/static/list/earstab_zones = list(BODY_ZONE_PRECISE_EARS)
	var/static/list/knockout_zones = list(BODY_ZONE_HEAD, BODY_ZONE_PRECISE_SKULL, BODY_ZONE_PRECISE_R_EYE, BODY_ZONE_PRECISE_L_EYE, BODY_ZONE_PRECISE_MOUTH)
	var/list/attempted_wounds = list()
	var/used
	var/total_dam = get_damage()
	var/damage_dividend = (total_dam / max_damage)
	var/resistance = HAS_TRAIT(owner, TRAIT_CRITICAL_RESISTANCE)
	var/from_behind = FALSE
	if(user && (owner.dir == turn(get_dir(owner,user), 180)))
		from_behind = TRUE
	if(user && dam)
		if(user.stat_roll(STATKEY_LCK,2,10))
			dam += 10
	var/crit_classes = list()
	if(bclass in GLOB.dislocation_bclasses)
		crit_classes += "dislocation"
	if(bclass in GLOB.fracture_bclasses)
		crit_classes += "fracture"
	if(bclass in GLOB.artery_bclasses)
		crit_classes += "artery"

	if(!length(crit_classes))
		return FALSE
	switch(pick(crit_classes))
		if("dislocation")
			if(damage_dividend >= 1)
				used = round(damage_dividend * 20 + (dam / 6), 1)
				if(prob(used))
					if(HAS_TRAIT(src, TRAIT_BRITTLE))
						attempted_wounds += /datum/wound/fracture/neck
					else
						attempted_wounds += /datum/wound/dislocation/neck
		if("fracture")
			if(HAS_TRAIT(src, TRAIT_BRITTLE))
				dam += 20
			if(user && istype(user.rmb_intent, /datum/rmb_intent/strong))
				dam += 10
			used = round(damage_dividend * 20 + (dam / 6), 1)
			if(!owner.stat && (zone_precise in knockout_zones) && (bclass != BCLASS_CHOP) && prob(used))
				owner.next_attack_msg += " <span class='crit'><b>Critical hit!</b> [owner] is knocked out[from_behind ? " FROM BEHIND" : ""]!</span>"
				owner.flash_fullscreen("whiteflash3")
				owner.Unconscious(30 SECONDS + (from_behind * 60 SECONDS))
				if(owner.client)
					winset(owner.client, "outputwindow.output", "max-lines=1")
					winset(owner.client, "outputwindow.output", "max-lines=100")
			var/dislocation_type
			var/fracture_type = /datum/wound/fracture/head
			var/necessary_damage = 0.9
			if(resistance)
				fracture_type = /datum/wound/fracture
			else if(zone_precise == BODY_ZONE_PRECISE_SKULL)
				fracture_type = /datum/wound/fracture/head/brain
				necessary_damage = 0.95
				used += 5
			else if(zone_precise == BODY_ZONE_PRECISE_EARS)
				fracture_type = /datum/wound/fracture/head/ears
			else if(zone_precise == BODY_ZONE_PRECISE_R_EYE || zone_precise == BODY_ZONE_PRECISE_L_EYE)
				fracture_type = /datum/wound/fracture/head/eyes
				necessary_damage = 0.8
			else if(zone_precise == BODY_ZONE_PRECISE_NOSE)
				fracture_type = /datum/wound/fracture/head/nose
				necessary_damage = 0.7
			else if(zone_precise == BODY_ZONE_PRECISE_MOUTH)
				fracture_type = /datum/wound/fracture/mouth
				necessary_damage = 0.7
			else if(zone_precise == BODY_ZONE_PRECISE_NECK)
				fracture_type = /datum/wound/fracture/neck
				dislocation_type = /datum/wound/dislocation/neck
				necessary_damage = 0.95
			if(prob(used) && (damage_dividend >= necessary_damage))
				if(dislocation_type)
					attempted_wounds += dislocation_type
				attempted_wounds += fracture_type
		if("artery")
			if(user)
				if(bclass == BCLASS_CHOP && istype(user.rmb_intent, /datum/rmb_intent/strong))
					dam += 10
				else
					if(istype(user.rmb_intent, /datum/rmb_intent/aimed))
						dam += 10
			used = round(damage_dividend * 20 + (dam / 6), 1)
			if(prob(used))
				var/artery_type = /datum/wound/artery
				if(zone_precise == BODY_ZONE_PRECISE_NECK)
					artery_type = /datum/wound/artery/neck
				attempted_wounds += artery_type
				if((bclass in GLOB.stab_bclasses) && !resistance)
					if(zone_precise in earstab_zones)
						var/obj/item/organ/ears/my_ears = owner.getorganslot(ORGAN_SLOT_EARS)
						if(!my_ears || has_wound(/datum/wound/facial/ears))
							attempted_wounds += /datum/wound/fracture/head/ears
						else
							attempted_wounds += /datum/wound/facial/ears
					else if(zone_precise in eyestab_zones)
						var/obj/item/organ/my_eyes = owner.getorganslot(ORGAN_SLOT_EYES)
						if(!my_eyes || (has_wound(/datum/wound/facial/eyes/left) && has_wound(/datum/wound/facial/eyes/right)))
							attempted_wounds += /datum/wound/fracture/head/eyes
						else if(my_eyes)
							if(zone_precise == BODY_ZONE_PRECISE_R_EYE)
								attempted_wounds += /datum/wound/facial/eyes/right
							else if(zone_precise == BODY_ZONE_PRECISE_L_EYE)
								attempted_wounds += /datum/wound/facial/eyes/left
					else if(zone_precise in tonguestab_zones)
						var/obj/item/organ/tongue/tongue_up_my_asshole = owner.getorganslot(ORGAN_SLOT_TONGUE)
						if(!tongue_up_my_asshole || has_wound(/datum/wound/facial/tongue))
							attempted_wounds += /datum/wound/fracture/mouth
						else
							attempted_wounds += /datum/wound/facial/tongue
					else if(zone_precise in nosestab_zones)
						if(has_wound(/datum/wound/facial/disfigurement/nose))
							attempted_wounds +=/datum/wound/fracture/head/nose
						else
							attempted_wounds += /datum/wound/facial/disfigurement/nose
					else if(zone_precise in knockout_zones)
						attempted_wounds += /datum/wound/fracture/head/brain

	for(var/wound_type in shuffle(attempted_wounds))
		var/datum/wound/applied = add_wound(wound_type, silent, crit_message)
		if(applied)
			if(user?.client)
				GLOB.vanderlin_round_stats[STATS_CRITS_MADE]++
			return applied
	return FALSE

/// Embeds an object in this bodypart
/obj/item/bodypart/proc/add_embedded_object(obj/item/embedder, silent = FALSE, crit_message = FALSE)
	if(!embedder || !can_embed(embedder))
		return FALSE
	if(owner && ((owner.status_flags & GODMODE) || HAS_TRAIT(owner, TRAIT_PIERCEIMMUNE)))
		return FALSE
	if(istype(embedder, /obj/item/natural/worms/leech))
		GLOB.vanderlin_round_stats[STATS_LEECHES_EMBEDDED]++
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
			SEND_SIGNAL(owner, COMSIG_CLEAR_MOOD_EVENT, "embedded")
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
	if(!bandage)
		return FALSE
	var/bandage_effectiveness = 0.5
	if(istype(bandage, /obj/item/natural/cloth))
		var/obj/item/natural/cloth/cloth = bandage
		bandage_effectiveness = cloth.bandage_effectiveness
	var/highest_bleed_rate = 0
	for(var/datum/wound/wound as anything in wounds)
		if(wound.bleed_rate < highest_bleed_rate)
			continue
		highest_bleed_rate = wound.bleed_rate
	for(var/obj/item/embedded as anything in embedded_objects)
		if(!embedded.embedding.embedded_bloodloss)
			continue
		if(embedded.embedding.embedded_bloodloss < highest_bleed_rate)
			continue
		highest_bleed_rate = embedded.embedding.embedded_bloodloss
	highest_bleed_rate = round(highest_bleed_rate, 0.1)
	if(bandage_effectiveness < highest_bleed_rate)
		return bandage_expire()
	return FALSE

/obj/item/bodypart/proc/bandage_expire()
	if(!owner)
		return FALSE
	if(!bandage)
		return FALSE
	if(owner.stat != DEAD)
		to_chat(owner, "<span class='warning'>Blood soaks through the bandage on my [name].</span>")
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
