/datum/attribute_modifier/lobotomy
	id = "Lobotomy"
	attribute_list = list(STAT_INTELLIGENCE = -3)

/datum/attribute_modifier/lobotomite
	id = "Super Lobotomy"
	attribute_list = list(STAT_INTELLIGENCE = -5)

/obj/item/organ/brain
	name = "brain"
	desc = ""
	icon_state = "brain"
	throw_speed = 1
	throw_range = 5
	layer = ABOVE_MOB_LAYER
	zone = BODY_ZONE_PRECISE_SKULL
	slot = ORGAN_SLOT_BRAIN
	unique_slot = ORGAN_SLOT_BRAIN
	organ_efficiency = list(ORGAN_SLOT_BRAIN = 100)
	organ_flags = ORGAN_VITAL
	attack_verb = list("attacked", "slapped", "whacked")

	maxHealth = BRAIN_DAMAGE_DEATH
	healing_factor = BRAIN_DAMAGE_DEATH/200
	low_threshold = BRAIN_DAMAGE_DEATH * 0.25
	high_threshold = BRAIN_DAMAGE_DEATH * 0.75

	// the volume shouldn't worry you, the chest is full of organs - also getting shot in the heart sucks
	organ_volume = 0.5
	max_blood_storage = 100
	current_blood = 100
	blood_req = 5
	oxygen_req = 5
	nutriment_req = 3
	hydration_req = 1.5

	/// This is stuff
	var/damage_threshold_value = BRAIN_DAMAGE_DEATH/10

	var/suicided = FALSE
	var/mob/living/brain/brainmob = null
	var/brain_death = FALSE //if the brainmob was intentionally killed by attacking the brain after removal, or by severe braindamage
	var/decoy_override = FALSE	//if it's a fake brain with no brainmob assigned. Feedback messages will be faked as if it does have a brainmob. See changelings & dullahans.
	//two variables necessary for calculating whether we get a brain trauma or not
	var/damage_delta = 0

	var/list/datum/brain_trauma/traumas = list()

/obj/item/organ/brain/Insert(mob/living/carbon/C, special = FALSE, drop_if_replaced = FALSE, new_zone = null, no_id_transfer = FALSE)
	. = ..()

	name = "brain"

	if(brainmob)
		if(brainmob.mind)
			brainmob.mind.transfer_to(C)
		else
			C.key = brainmob.key

		QDEL_NULL(brainmob)

	for(var/datum/brain_trauma/BT as anything in traumas)
		BT.owner = owner
		BT.on_gain()

	//Update the body's icon so it doesnt appear debrained anymore
	C.update_body()

/obj/item/organ/brain/Remove(mob/living/carbon/C, special = 0, no_id_transfer = FALSE)
	. = ..()
	for(var/datum/brain_trauma/BT as anything in traumas)
		BT.on_lose(TRUE)
		BT.owner = null

	if((!gc_destroyed || (owner && !owner.gc_destroyed)) && !no_id_transfer)
		transfer_identity(C)
	C.update_body()


/obj/item/organ/brain/handle_blood(delta_time, times_fired)
	var/effective_blood_oxygenation = GET_EFFECTIVE_BLOOD_VOL(owner.get_blood_oxygenation(), owner.total_blood_req)
	var/arterial_efficiency = get_slot_efficiency(ORGAN_SLOT_ARTERY)
	var/in_bleedout = owner.in_bleedout()
	if(arterial_efficiency && !is_failing())
		// Arteries get an extra flat 5 blood regen
		current_blood = min(current_blood + 5 * (0.5 * delta_time) * (arterial_efficiency/ORGAN_OPTIMAL_EFFICIENCY), max_blood_storage)
		return
	if(!blood_req)
		return
	if(!in_bleedout && (effective_blood_oxygenation >= BLOOD_VOLUME_SAFE))
		current_blood = min(current_blood + (blood_req * (0.5 * delta_time)), max_blood_storage)
		return
	if(in_bleedout)
		current_blood = max(current_blood - (blood_req * (0.5 * delta_time)), 0)
	else
		current_blood = max(current_blood - (blood_req * ((BLOOD_VOLUME_NORMAL-effective_blood_oxygenation)/BLOOD_VOLUME_NORMAL) * (0.5 * delta_time)), 0)
	// When all blood is lost, take blood from blood vessels
	if(!current_blood)
		var/obj/item/organ/artery
		var/obj/item/bodypart/parent = owner.get_bodypart(current_zone)
		for(var/thing in shuffle(parent?.getorganslotlist(ORGAN_SLOT_ARTERY)))
			var/obj/item/organ/candidate = thing
			if(candidate.current_blood && (candidate.get_slot_efficiency(ORGAN_SLOT_ARTERY) >= ORGAN_FAILING_EFFICIENCY))
				artery = candidate
				break
		if(artery?.current_blood)
			var/prev_blood = artery.current_blood
			artery.current_blood = max(artery.current_blood - (blood_req * 0.5 * delta_time), 0)
			current_blood = max(prev_blood - artery.current_blood, 0)
		//Don't apply damage, this is handled by the organ process datum, if necessary

/obj/item/organ/brain/get_mechanics_examine(mob/user)
	. = ..()

	if(owner)
		. += "Use a hemostat to perform a lobotomy on this brain."

/obj/item/organ/brain/handle_organ_attack(obj/item/tool, mob/living/user, params)
	if(owner && DOING_INTERACTION_WITH_TARGET(user, owner))
		return TRUE
	else if(DOING_INTERACTION_WITH_TARGET(user, src))
		return TRUE
	if(owner && CHECK_BITFIELD(organ_flags, ORGAN_CUT_AWAY))
		for(var/thing in attaching_items)
			if(istype(tool, thing))
				handle_attaching_item(tool, user, params)
				return TRUE
	for(var/thing in healing_items)
		if(istype(tool, thing))
			handle_healing_item(tool, user, params)
			return TRUE
	for(var/thing in healing_tools)
		if(tool.tool_behaviour == thing)
			handle_healing_item(tool, user, params)
			return TRUE
	// LOBOTOMITE
	if(owner && (tool.tool_behaviour == TOOL_HEMOSTAT))
		handle_lobotomy(tool, user, params)
		return TRUE
	if(owner && (tool.sharpness == IS_SHARP || tool.tool_behaviour == TOOL_SCALPEL) && !CHECK_BITFIELD(organ_flags, ORGAN_CUT_AWAY))
		handle_cutting_away(tool, user, params)
		return TRUE
	if(tool.tool_behaviour == TOOL_CAUTERY)
		handle_burning_rot(tool, user, params)
		return TRUE

/obj/item/organ/brain/handle_healing_item(obj/item/tool, mob/living/user, params)
	var/obj/item/natural/stack = tool
	if(organ_flags & (ORGAN_DESTROYED|ORGAN_DEAD))
		to_chat(user, span_warning("\The [src] is damaged beyond the point of no return."))
		return
	if(!damage && !length(traumas))
		to_chat(user, span_notice("\The [src] is in pristine quality already."))
		return
	user.visible_message(span_notice("<b>[user]</b> starts healing \the [src]..."), \
					span_notice("I start healing \the [src]..."), \
					vision_distance = COMBAT_MESSAGE_RANGE)

	var/time = 5 SECONDS
	time *= (SKILL_MIDDLING/max(GET_MOB_SKILL_VALUE(user, /datum/attribute/skill/misc/medicine), 1))

	if(owner)
		//owner.custom_pain("OH GOD! There are needles inside my [src]!", 30, FALSE, owner.get_bodypart(current_zone))
		if(!do_after(user, time, owner))
			to_chat(user, span_warning("I must stand still!"))
			return
	else
		if(!do_after(user, time, src))
			to_chat(user, span_warning("I must stand still!"))
			return
	if(istype(stack))
		if(!stack.use(2))
			to_chat(user, span_warning("I don't have enough to heal \the [src]!"))
			return
	user.visible_message(span_notice("<b>[user]</b> healing \the [src]."), \
						span_notice("I heal \the [src]."))
	applyOrganDamage(-min(maxHealth/2, 50))
	cure_all_traumas(TRAUMA_RESILIENCE_SURGERY)


/obj/item/organ/brain/proc/handle_lobotomy(obj/item/tool, mob/living/user, params)
	user.visible_message(span_notice("<b>[user]</b> starts lobotomizing \the [src]..."), \
					span_notice("I start lobotomizing \the [src]..."), \
					vision_distance = COMBAT_MESSAGE_RANGE)
	//owner.custom_pain("OH GOD! My [src] is being SLASHED IN TWAIN!", 30, FALSE, owner.get_bodypart(current_zone))

	var/time = 10 SECONDS
	time *= (SKILL_MIDDLING/max(GET_MOB_SKILL_VALUE(user, /datum/attribute/skill/misc/medicine), 1))

	if(!do_after(user, time, owner))
		to_chat(user, span_warning("I must stand still!"))
		return TRUE
	user.visible_message(span_notice("<b>[user]</b> lobotomizes \the [src]."), \
					span_notice("I lobotomize \the [src]."), \
					vision_distance = COMBAT_MESSAGE_RANGE)
	switch(owner.diceroll(GET_MOB_ATTRIBUTE_VALUE(owner, STAT_ENDURANCE), context = DICE_CONTEXT_MENTAL))
		// Cure all traumas, no penalties
		if(DICE_CRIT_SUCCESS)
			cure_all_traumas(TRAUMA_RESILIENCE_LOBOTOMY)
		// Cure all traumas, but gain a mild one
		if(DICE_SUCCESS)
			cure_all_traumas(TRAUMA_RESILIENCE_LOBOTOMY)
			gain_trauma_type(BRAIN_TRAUMA_MILD, TRAUMA_RESILIENCE_SURGERY)
		// Cure nothing, lose intelligence, go fuck yourself
		if(DICE_FAILURE)
			owner.attributes.add_attribute_modifier(/datum/attribute_modifier/lobotomy, TRUE)
		// Cure nothing, lose intelligence, gain another brain trauma, go fuck yourself
		if(DICE_CRIT_FAILURE)
			owner.attributes.add_attribute_modifier(/datum/attribute_modifier/lobotomite, TRUE)
			gain_trauma_type(BRAIN_TRAUMA_SEVERE, TRAUMA_RESILIENCE_LOBOTOMY)
	return TRUE

/obj/item/organ/brain/prepare_eat(mob/living/carbon/human/H)
	if(HAS_TRAIT(H, TRAIT_ROTMAN))//braaaaaains... otherwise, too important to eat.
		return ..()
	return FALSE

/obj/item/organ/brain/proc/transfer_identity(mob/living/L)
	if(brainmob || decoy_override)
		return
	if(!L.mind)
		return
	brainmob = new(src)
	brainmob.name = L.real_name
	brainmob.real_name = L.real_name
	brainmob.timeofhostdeath = L.timeofdeath
	brainmob.set_suicide(HAS_TRAIT(src, TRAIT_SUICIDED))
	if(L.has_dna())
		var/mob/living/carbon/C = L
		if(!brainmob.stored_dna)
			brainmob.stored_dna = new /datum/dna/stored(brainmob)
		C.dna.copy_dna(brainmob.stored_dna)
	if(L.mind?.current)
		L.mind.transfer_to(brainmob)

/obj/item/organ/brain/examine(mob/user)
	. = ..()

	if(suicided)
		. += "<span class='info'>It's started turning slightly grey. They must not have been able to handle the stress of it all.</span>"
	else if(brainmob)
		if(brainmob.get_ghost(FALSE, TRUE))
			if(brain_death || brainmob.health <= HEALTH_THRESHOLD_DEAD)
				. += "<span class='info'>It's lifeless and severely damaged.</span>"
			else if(organ_flags & ORGAN_FAILING)
				. += "<span class='info'>It seems to still have a bit of energy within it, but it's rather damaged... You may be able to restore it with some <b>mannitol</b>.</span>"
			else
				. += "<span class='info'>I can feel the small spark of life still left in this one.</span>"
		else if(organ_flags & ORGAN_FAILING)
			. += "<span class='info'>It seems particularly lifeless and is rather damaged... You may be able to restore it with some <b>mannitol</b> incase it becomes functional again later.</span>"
		else
			. += "<span class='info'>This one seems particularly lifeless. Perhaps it will regain some of its luster later.</span>"
	else
		if(decoy_override)
			if(organ_flags & ORGAN_FAILING)
				. += "<span class='info'>It seems particularly lifeless and is rather damaged... You may be able to restore it with some <b>mannitol</b> incase it becomes functional again later.</span>"
			else
				. += "<span class='info'>This one seems particularly lifeless. Perhaps it will regain some of its luster later.</span>"
		else
			. += "<span class='info'>This one is completely devoid of life.</span>"

/obj/item/organ/brain/attack(mob/living/carbon/C, mob/user, list/modifiers)
	if(!istype(C))
		return ..()

	add_fingerprint(user)

	if(user.zone_selected != BODY_ZONE_HEAD)
		return ..()

	var/target_has_brain = C.getorgan(/obj/item/organ/brain)

	if(!target_has_brain && C.is_eyes_covered())
		to_chat(user, "<span class='warning'>You're going to need to remove [C.p_their()] head cover first!</span>")
		return

	if(!target_has_brain)
		if(!C.get_bodypart(BODY_ZONE_HEAD) || !user.temporarilyRemoveItemFromInventory(src))
			return
		var/msg = "[C] has [src] inserted into [C.p_their()] head by [user]."
		if(C == user)
			msg = "[user] inserts [src] into [user.p_their()] head!"

		C.visible_message("<span class='danger'>[msg]</span>",
						"<span class='danger'>[msg]</span>")

		if(C != user)
			to_chat(C, "<span class='notice'>[user] inserts [src] into your head.</span>")
			to_chat(user, "<span class='notice'>I insert [src] into [C]'s head.</span>")
		else
			to_chat(user, "<span class='notice'>I insert [src] into your head.</span>")

		Insert(C)
	else
		..()

/obj/item/organ/brain/Destroy()
	if(brainmob)
		QDEL_NULL(brainmob)
	QDEL_LIST(traumas)
	return ..()

/obj/item/organ/brain/can_heal(delta_time, times_fired)
    . = TRUE
    if(!owner)
        return FALSE
    if(healing_factor <= 0)
        return FALSE
    if(is_dead())
        return FALSE
    if(current_blood <= 0)
        return FALSE
    if(owner.undergoing_cardiac_arrest())
        return FALSE
    var/effective_blood_oxygenation = GET_EFFECTIVE_BLOOD_VOL(owner.get_blood_oxygenation(), owner.total_blood_req)
    if(effective_blood_oxygenation < BLOOD_VOLUME_SAFE)
        return FALSE
    // if stable and not too damaged we can heal
    if(!past_damage_threshold(3) && owner.get_chem_effect(CE_STABLE))
        return TRUE
    // else, we only naturally regen to basically get rounded
    if(!(damage % damage_threshold_value) || owner.get_chem_effect(CE_BRAIN_REGEN))
        return FALSE

/obj/item/organ/brain/proc/past_damage_threshold(threshold)
	return (get_current_damage_threshold() > threshold)

/obj/item/organ/brain/proc/get_current_damage_threshold()
	return FLOOR(damage / damage_threshold_value, 1)

/obj/item/organ/brain/check_damage_thresholds(mob/M)
	. = ..()
	// if we're not more injured than before, return without gambling for a trauma
	if(damage <= prev_damage)
		return
	var/damage_delta = damage - prev_damage
	// Safeguard to prevent traumas from low damage
	if((damage_delta >= TRAUMA_ROLL_THRESHOLD) && (damage >= BRAIN_DAMAGE_MILD))
		var/is_boosted = FALSE
		var/intelligence_modifier = (owner ? -(GET_MOB_ATTRIBUTE_VALUE(owner, STAT_INTELLIGENCE)-ATTRIBUTE_MIDDLING) : 0)
		if(damage >= BRAIN_DAMAGE_SEVERE)
			// Base chance is the hit damage, plus intelligence mod; for every point of damage past the threshold the chance is increased by 1%
			if(prob((damage_delta+intelligence_modifier) * (1 + max(0, (damage - BRAIN_DAMAGE_SEVERE)/100))))
				if(prob(20 + (is_boosted * 30) - (intelligence_modifier * 2)))
					gain_trauma_type(BRAIN_TRAUMA_SPECIAL, is_boosted ? TRAUMA_RESILIENCE_SURGERY : null, natural_gain = TRUE)
				else
					gain_trauma_type(BRAIN_TRAUMA_SEVERE, natural_gain = TRUE)
		else
			// Base chance is the hit damage, plus intelligence mod; for every point of damage past the threshold the chance is increased by 1%
			if(prob((damage_delta+intelligence_modifier) * (1 + max(0, (damage - BRAIN_DAMAGE_MILD)/100))))
				gain_trauma_type(BRAIN_TRAUMA_MILD, natural_gain = TRUE)
	if(owner)
		if(damage >= BRAIN_DAMAGE_DEATH && prev_damage < BRAIN_DAMAGE_DEATH && (organ_flags & ORGAN_VITAL))
			owner.death()
			return
		var/brain_message
		if(prev_damage < BRAIN_DAMAGE_MILD && damage >= BRAIN_DAMAGE_MILD)
			brain_message = span_warning("I feel lightheaded.")
		else if(prev_damage < BRAIN_DAMAGE_SEVERE && damage >= BRAIN_DAMAGE_SEVERE)
			brain_message = span_warning("I feel less in control of my thoughts.")
		else if(prev_damage < (BRAIN_DAMAGE_DEATH - 20) && damage >= (BRAIN_DAMAGE_DEATH - 20) && damage < BRAIN_DAMAGE_DEATH)
			brain_message = span_warning("I can feel my mind flickering on and off...")
		if(.)
			. += "\n[brain_message]"
		else
			return brain_message

/obj/item/organ/brain/applyOrganDamage(amount, maximum = maxHealth, silent = FALSE)
	if(!amount) //Micro-optimization.
		return
	if(maximum < damage)
		damage = maximum
	if(damage < 0 && owner?.get_chem_effect(CE_BRAIN_REGEN))
		damage *= 2
	prev_damage = damage
	damage = clamp(damage + amount, 0, maximum)
	var/mess = check_damage_thresholds(owner)
	if(owner)
		if(mess && !silent)
			to_chat(owner, mess)
		if(organ_flags & ORGAN_LIMB_SUPPORTER)
			var/obj/item/bodypart/affected = owner.get_bodypart(current_zone)
			affected?.update_limb_efficiency()
		if(amount >= 10)
			var/damage_side_effect = CEILING(amount/2, 1)
			if(damage_side_effect >= 1)
				//owner.flash_pain(damage_side_effect*4)
				owner.adjust_eye_blur(damage_side_effect)
				owner.adjust_confusion(damage_side_effect)
				switch(rand(1,3))
					if(1)
						owner.stuttering += damage_side_effect
					if(2)
						owner.slurring += damage_side_effect
					if(3)
						owner.cultslurring += damage_side_effect
				owner.CombatKnockdown(damage_side_effect*2, damage_side_effect, (damage_side_effect >= 5 ? damage_side_effect : null), damage_side_effect >= 5)
		if(!is_failing())
			REMOVE_TRAIT(owner, TRAIT_KNOCKEDOUT, CRIT_HEALTH_TRAIT)
	if(damage >= 60)
		owner.add_stress(/datum/stress_event/brain_damage)
	else
		owner.remove_stress(/datum/stress_event/brain_damage)

////////////////////////////////////TRAUMAS////////////////////////////////////////

/obj/item/organ/brain/proc/has_trauma_type(brain_trauma_type = /datum/brain_trauma, resilience = TRAUMA_RESILIENCE_ABSOLUTE)
	for(var/datum/brain_trauma/BT as anything in traumas)
		if(istype(BT, brain_trauma_type) && (BT.resilience <= resilience))
			return BT

/obj/item/organ/brain/proc/get_traumas_type(brain_trauma_type = /datum/brain_trauma, resilience = TRAUMA_RESILIENCE_ABSOLUTE)
	. = list()
	for(var/datum/brain_trauma/BT as anything in traumas)
		if(istype(BT, brain_trauma_type) && (BT.resilience <= resilience))
			. += BT

/obj/item/organ/brain/proc/can_gain_trauma(datum/brain_trauma/trauma, resilience, natural_gain = FALSE)
	if(!ispath(trauma))
		trauma = trauma.type

	if(!initial(trauma.can_gain))
		return FALSE

	if(!resilience)
		resilience = initial(trauma.resilience)

	var/resilience_tier_count = 0
	for(var/datum/brain_trauma/existing_trauma as anything in traumas)
		if(istype(existing_trauma, trauma))
			return FALSE
		if(resilience == existing_trauma.resilience)
			resilience_tier_count++

	var/max_traumas
	switch(resilience)
		if(TRAUMA_RESILIENCE_BASIC)
			max_traumas = TRAUMA_LIMIT_BASIC
		if(TRAUMA_RESILIENCE_SURGERY)
			max_traumas = TRAUMA_LIMIT_SURGERY
		if(TRAUMA_RESILIENCE_WOUND)
			max_traumas = TRAUMA_LIMIT_WOUND
		if(TRAUMA_RESILIENCE_LOBOTOMY)
			max_traumas = TRAUMA_LIMIT_LOBOTOMY
		if(TRAUMA_RESILIENCE_MAGIC)
			max_traumas = TRAUMA_LIMIT_MAGIC
		if(TRAUMA_RESILIENCE_ABSOLUTE)
			max_traumas = TRAUMA_LIMIT_ABSOLUTE

	if(natural_gain && resilience_tier_count >= max_traumas)
		return FALSE

	return TRUE

/obj/item/organ/brain/proc/gain_trauma(datum/brain_trauma/trauma, resilience, ...)
	var/list/arguments = list()
	if(args.len > 2)
		arguments = args.Copy(3)
	. = brain_gain_trauma(trauma, resilience, arguments)

/obj/item/organ/brain/proc/brain_gain_trauma(datum/brain_trauma/trauma, resilience, list/arguments)
	if(!can_gain_trauma(trauma, resilience))
		return

	var/datum/brain_trauma/actual_trauma
	if(ispath(trauma))
		if(!LAZYLEN(arguments))
			actual_trauma = new trauma()
		else
			actual_trauma = new trauma(arglist(arguments))
	else
		actual_trauma = trauma

	if(actual_trauma.brain) //we don't accept used traumas here
		stack_trace("gain_trauma was given an already active trauma.")
		return

	traumas += actual_trauma
	actual_trauma.brain = src
	if(owner)
		actual_trauma.owner = owner
		actual_trauma.on_gain()
	if(resilience)
		actual_trauma.resilience = resilience
	. = actual_trauma
	SSblackbox.record_feedback("tally", "traumas", 1, actual_trauma.type)

/**
 * Completely randomly give a brain trauma from the selected type subtypes these should be defines
 * from [_DEFINES/mob.dm]
 *
 * Arguments
 * * brain_trauma_type - Type to poll for subtypes
 * * resilience - How hard the trauma is to remove
 * * natural_gain - Counts towards trauma limit
 * * force_split_personality - Ignore split personality preference, though you should just use gain_trauma if you want to give it
 */
/obj/item/organ/brain/proc/gain_trauma_type(brain_trauma_type = /datum/brain_trauma, resilience = NONE, natural_gain = FALSE, force_split_personality = FALSE)
	var/list/datum/brain_trauma/possible_traumas = list()
	for(var/datum/brain_trauma/brain_trauma as anything in subtypesof(brain_trauma_type))
		if(IS_ABSTRACT(brain_trauma))
			continue
		if(!initial(brain_trauma.random_gain))
			continue
		if(ispath(brain_trauma, /datum/brain_trauma/severe/split_personality))
			if(!force_split_personality && owner?.client.prefs.toggles_gameplay & DISABLE_SPLIT_PERSONALITY)
				continue
		if(can_gain_trauma(brain_trauma, resilience, natural_gain))
			possible_traumas += brain_trauma

	if(!length(possible_traumas))
		return

	var/trauma_type = pick(possible_traumas)
	return gain_trauma(trauma_type, resilience)

/obj/item/organ/brain/proc/cure_trauma_type(brain_trauma_type = /datum/brain_trauma, resilience = TRAUMA_RESILIENCE_BASIC)
	var/list/traumas = get_traumas_type(brain_trauma_type, resilience)
	if(length(traumas))
		qdel(pick(traumas))

/obj/item/organ/brain/proc/cure_all_traumas(resilience = TRAUMA_RESILIENCE_BASIC)
	var/list/traumas = get_traumas_type(resilience = resilience)
	for(var/X in traumas)
		qdel(X)

/obj/item/organ/brain/alien
	name = "alien brain"
	desc = ""
	icon_state = "brain-x"

/obj/item/organ/brain/smooth
	icon_state = "brain-smooth"
