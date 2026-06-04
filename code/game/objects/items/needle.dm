/obj/item/needle
	name = "needle"
	desc = "A firm needle affixed with a simple thread, Pestra's most favored tool."
	icon_state = "needle"
	icon = 'icons/roguetown/items/misc.dmi'
	w_class = WEIGHT_CLASS_TINY
	force = 0
	throwforce = 0
	resistance_flags = FLAMMABLE
	slot_flags = ITEM_SLOT_MOUTH
	max_integrity = 20
	anvilrepair = /datum/attribute/skill/craft/blacksmithing
	melting_material = /datum/material/iron
	melt_amount = 20
	tool_behaviour = TOOL_SUTURE
	item_weight = 5 GRAMS

	grid_width = 32
	grid_height = 32
	/// Amount of uses left
	var/stringamt = 24
	var/maxstring = 24
	/// If this needle is infinite
	var/infinite = FALSE
	/// If this needle can be used to repair items
	var/can_repair = TRUE

/obj/item/needle/examine()
	. = ..()
	if(!infinite)
		if(stringamt > 0)
			. += span_bold("It has [stringamt] uses left.")
		else
			. += span_bold("It has no uses left.")
	else
		. += span_bold("Can be used indefinitely.")

/obj/item/needle/Initialize()
	. = ..()
	update_appearance(UPDATE_OVERLAYS)

/obj/item/needle/update_overlays()
	. = ..()
	if(stringamt <= 0)
		return
	. += "[icon_state]string"

/obj/item/needle/use(used)
	if(infinite)
		return TRUE
	if(used > stringamt)
		return FALSE
	stringamt = stringamt - used

	return TRUE

/obj/item/needle/interact_with_atom(atom/interacting_with, mob/living/user, list/modifiers)
	if(isliving(interacting_with))
		if(sew_wounds(interacting_with, user))
			return ITEM_INTERACT_SUCCESS
		return ITEM_INTERACT_BLOCKING

	if(isitem(interacting_with))
		if(sew_item(interacting_with, user))
			return ITEM_INTERACT_SUCCESS

/obj/item/needle/item_interaction(mob/living/user, obj/item/tool, list/modifiers)
	if(!istype(tool, /obj/item/natural/fibers))
		return NONE

	if(maxstring - stringamt < 5)
		to_chat(user, span_warning("Not enough room for more thread!"))
		return ITEM_INTERACT_BLOCKING

	to_chat(user, "I begin threading the needle with additional fibers...")
	if(do_after(user, 6 SECONDS - GET_MOB_SKILL_VALUE_OLD(user, /datum/attribute/skill/misc/sewing), tool))
		stringamt += 5
		to_chat(user, "I replenish the needle's thread!")
		qdel(tool)
		update_appearance(UPDATE_OVERLAYS)
	return ITEM_INTERACT_SUCCESS

/obj/item/needle/proc/sew_item(obj/item/I, mob/living/user)
	if(!(I.obj_flags & CAN_BE_HIT) && !istype(I, /obj/item/storage)) // to preserve old attack_obj behavior
		return FALSE

	if(!I.ontable() || !I.sewrepair)
		return FALSE

	if(!I.uses_integrity || I.obj_broken)
		to_chat(user, span_warning("[I] can't be repaired!"))
		return FALSE

	if(I.get_integrity() >= I.max_integrity)
		return FALSE

	if(stringamt < 1)
		to_chat(user, span_warning("[src] has no thread left!"))
		return FALSE

	if(!can_repair)
		to_chat(user, span_warning("[src] cannot be used to repair [I]!"))
		return FALSE

	var/armor_value = 0
	var/skill_level = GET_MOB_SKILL_VALUE(user, I.sewrepair)
	for(var/key in I.armor.getList())
		armor_value += I.armor.getRating(key)

	if(!I.obj_broken && I.get_integrity() >= I.max_integrity && (I.max_integrity != initial(I.max_integrity)))
		if(!I.salvage_result)
			to_chat(user, span_warning("[I] can't be melded with a needle."))
			return TRUE

		if(I.integrity_restores >= 3)
			to_chat(user, span_warning("[I] has been melded too many times. The fabric won't take any more material."))
			return TRUE

		var/obj/item/patch = locate(I.salvage_result) in range(1, I.loc)
		if(!patch)
			to_chat(user, span_warning("You need [initial(I.salvage_result:name)] nearby to meld [I]."))
			return TRUE

		if(skill_level <= 0)
			to_chat(user, span_warning("You don't know enough to meld [I]."))
			return TRUE

		playsound(src, 'sound/foley/sewflesh.ogg', 100, TRUE, -2)
		var/sewtime = (6 SECONDS - skill_level)
		if(!do_after(user, sewtime, I))
			return TRUE

		var/restores_done = I.integrity_restores
		var/base_restore = (skill_level / SKILL_MASTER) * 0.20
		var/diminish_factor = max(0.1, 1.0 - (restores_done * 0.30))
		var/restore_amount = round(I.max_integrity * base_restore * diminish_factor)

		if(restore_amount <= 0)
			to_chat(user, span_warning("[I] won't take any more material."))
			return TRUE

		I.max_integrity += restore_amount
		I.integrity_restores++
		qdel(patch)

		user.visible_message(span_info("[user] melds new material into [I], restoring some of its integrity."))
		if(restores_done >= 2)
			to_chat(user, span_warning("The fabric is taking the new material less readily now. Further melding will be less effective."))

		var/amt2raise = GET_MOB_ATTRIBUTE_VALUE(user, STAT_INTELLIGENCE) * 0.25
		user.mind.add_sleep_experience(I.sewrepair, amt2raise)
		return TRUE

	return FALSE

/obj/item/needle/proc/sew_wounds(mob/living/carbon/target, mob/living/user)
	if(!istype(user) || !istype(target))
		return FALSE
	if(stringamt < 1)
		to_chat(user, span_warning("The needle has no thread left!"))
		return FALSE
	var/mob/living/doctor = user
	var/mob/living/carbon/patient = target
	if(!get_location_accessible(patient, check_zone(doctor.zone_selected)))
		to_chat(doctor, span_warning("Something is in the way."))
		return FALSE
	var/obj/item/bodypart/affecting = patient.get_bodypart(check_zone(doctor.zone_selected))
	if(!affecting)
		to_chat(doctor, span_warning("That limb is missing."))
		return FALSE
	if(affecting.bandage)
		to_chat(doctor, span_warning("There is a bandage in the way."))
		return FALSE

	if(affecting.get_cut())
		if(affecting.is_artery_torn())
			var/time = 5 SECONDS
			time *= (ATTRIBUTE_MIDDLING/max(GET_MOB_ATTRIBUTE_VALUE(doctor, STAT_PERCEPTION), 1))
			playsound(patient, 'sound/foley/sewflesh.ogg', 100, TRUE, -2)
			if(!do_after(doctor, time, patient))
				to_chat(doctor, span_warning("I must stand still!"))
				return FALSE
			if(stringamt < 1)
				to_chat(doctor, span_warning("The needle has no thread left!"))
				return FALSE
			var/amt2raise = GET_MOB_ATTRIBUTE_VALUE(doctor, STAT_INTELLIGENCE)
			if(doctor.diceroll(GET_MOB_SKILL_VALUE(doctor, /datum/attribute/skill/misc/medicine)-1, context = DICE_CONTEXT_PHYSICAL) <= DICE_FAILURE)
				to_chat(doctor, span_warning("My hand slips!"))
				user.adjust_experience(/datum/attribute/skill/misc/medicine, amt2raise * 0.2 * doctor.get_learning_boon(/datum/attribute/skill/misc/medicine))
				return FALSE
			user.adjust_experience(/datum/attribute/skill/misc/medicine, amt2raise * doctor.get_learning_boon(/datum/attribute/skill/misc/medicine))
			doctor.visible_message(
				span_green("<b>[doctor]</b> sutures <b>[patient]</b>'s [affecting.name] arteries with \the [src]."),
				span_green("I suture <b>[patient]</b>'s [affecting.name] arteries with \the [src].")
			)
			use(1)
			for(var/obj/item/organ/artery in affecting.getorganslotlist(ORGAN_SLOT_ARTERY))
				if(artery.damage)
					artery.applyOrganDamage(-min(artery.maxHealth/2, 50))
					return TRUE
			return TRUE

	var/injury_healed = FALSE
	for(var/thing in affecting.injuries)
		var/datum/injury/injury = thing
		if(!(injury.damage_type in list(WOUND_SLASH, WOUND_PIERCE, WOUND_BITE)))
			continue
		var/time = 2 SECONDS + (injury.damage * 0.5)
		time *= min(time * 1.5, (ATTRIBUTE_MIDDLING/max(GET_MOB_ATTRIBUTE_VALUE(user, STAT_PERCEPTION), 1)))
		playsound(target, 'sound/foley/sewflesh.ogg', 65, FALSE)
		if(!do_after(user, time, target))
			to_chat(user, span_warning("I must stand still!"))
			return
		if(!use(1))
			to_chat(user, span_warning("All used up..."))
			return
		injury.suture_injury()
		if((injury.damage_per_injury() <= injury.autoheal_cutoff))
			continue
		injury.heal_damage(10)
		var/amt2raise = GET_MOB_ATTRIBUTE_VALUE(doctor, STAT_INTELLIGENCE)
		user.adjust_experience(/datum/attribute/skill/misc/medicine, amt2raise * doctor.get_learning_boon(/datum/attribute/skill/misc/medicine))
		affecting.update_damages()
		if(affecting.update_bodypart_damage_state())
			target.update_damage_overlays()
		if(injury.damage_per_injury() > injury.autoheal_cutoff)
			user.visible_message(span_green("<b>[user]</b> partially stitches \a [injury.get_desc()] on <b>[target]</b>'s [affecting.name] with \the [src]."), \
								span_green("I partially stitch \a [injury.get_desc()] on \the [affecting.name] with \the [src]."))
		else
			user.visible_message(span_green("<b>[user]</b> stitches \a [injury.get_desc()] shut on <b>[target]</b>'s [affecting.name] with \the [src]."), \
								span_green("I stitch \a [injury.get_desc()] shut on \the [affecting.name] with \the [src]."))
		injury_healed = TRUE

	var/list/sewable = affecting.get_sewable_wounds()
	if(!length(sewable))
		if(!injury_healed)
			to_chat(doctor, span_warning("There aren't any wounds to be sewn."))
		return FALSE
	var/datum/wound/target_wound
	if(length(sewable) > 1)
		target_wound = browser_input_list(doctor, "Which wound?", "WOUND CRAFT", sewable)
	else
		target_wound = sewable[1]
	if(!target_wound || QDELETED(target_wound) || QDELETED(src) || QDELETED(doctor) || QDELETED(user))
		return FALSE
	if(!target_wound.do_sewing_step(doctor, src))
		return FALSE
	return TRUE

/obj/item/needle/thorn
	name = "needle"
	icon_state = "thornneedle"
	desc = "This rough needle can be used to sew cloth and wounds."
	stringamt = 8
	maxstring = 8
	anvilrepair = null
	melting_material = null
	item_weight = 3 GRAMS

/obj/item/needle/blessed
	name = "blessed needle"
	desc = span_hierophant("A needle blessed by the ordained Pestrans of the Church. A coveted item, for its thread will never end. \n This thread however can only be used to sew wounds.")
	infinite = TRUE
	can_repair = FALSE
	item_weight = 5 GRAMS
