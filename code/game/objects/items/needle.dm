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
	stringamt = stringamt - used
	update_appearance(UPDATE_OVERLAYS)
//	if(stringamt <= 0)
//		qdel(src)

/obj/item/needle/attack(mob/living/M, mob/user, list/modifiers)
	sew_wounds(M, user)

/obj/item/needle/attackby(obj/item/I, mob/user, list/modifiers)
	if(istype(I, /obj/item/natural/fibers))
		if(maxstring - stringamt < 5)
			to_chat(user, span_warning("Not enough room for more thread!"))
			return
		else
			to_chat(user, "I begin threading the needle with additional fibers...")
			if(do_after(user, 6 SECONDS - GET_MOB_SKILL_VALUE_OLD(user, /datum/attribute/skill/misc/sewing), I))
				stringamt += 5
				to_chat(user, "I replenish the needle's thread!")
				qdel(I)
				update_appearance(UPDATE_OVERLAYS)
			return
	return ..()

/obj/item/needle/pre_attack(atom/A, mob/living/user, list/modifiers)
	if(isitem(A))
		var/obj/item/I = A
		if(!(I.obj_flags & CAN_BE_HIT) && !istype(A, /obj/item/storage))
			return ..()
		if(!I.ontable() || !I.sewrepair)
			return ..()
		if(!I.uses_integrity)
			to_chat(user, span_warning("[I] can't be repaired!"))
			return ..()
		if(stringamt < 1)
			to_chat(user, span_warning("[src] has no thread left!"))
			return TRUE
		if(!can_repair)
			to_chat(user, span_warning("[src] cannot be used to repair [A]!"))
			return TRUE

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

		if(!I.obj_broken && I.get_integrity() >= I.max_integrity)
			to_chat(user, span_warning("There is nothing to further repair on [I]."))
			return ..()

		var/repair_percent = 0.025
		if(skill_level <= 0)
			if(prob(30))
				repair_percent = 0.01
				to_chat(user, span_warning("You are just barely able to repair this..."))
			else
				repair_percent = 0
		else
			repair_percent *= skill_level

		if((armor_value == 0 && skill_level < 10) || (armor_value > 0 && skill_level < 20))
			to_chat(user, span_warning("I should probably not be doing this..."))

		playsound(src, 'sound/foley/sewflesh.ogg', 100, TRUE, -2)
		var/sewtime = (6 SECONDS - skill_level)
		if(!do_after(user, sewtime, I))
			return TRUE

		var/was_broken = I.obj_broken
		if(was_broken)
			var/integrity_penalty = 0.65 - ((skill_level / SKILL_MASTER) * 0.60)
			integrity_penalty = clamp(integrity_penalty, 0.05, 0.99)
			var/integrity_loss = round(I.max_integrity * integrity_penalty)
			I.max_integrity = max(1, I.max_integrity - integrity_loss)
			I.obj_broken = FALSE
			I.repair_damage(max(I.max_integrity * repair_percent, 10))
			to_chat(user, span_warning("You patch [I] back together, but the damage has left its mark, it will never be quite as strong as it once was."))
			if(skill_level < SKILL_MIDDLING)
				to_chat(user, span_warning("Your inexperience made things worse. The repair is rough."))
		else
			if(repair_percent)
				user.visible_message(span_info("[user] patches up [I]!"))
				I.repair_damage(I.max_integrity * repair_percent)
			else
				I.take_damage(I.max_integrity * 0.1, BRUTE, "slash")
				user.visible_message(span_warning("[user] damages [I] further!"))
				playsound(src, 'sound/foley/cloth_rip.ogg', 50, TRUE)

		if(prob(10 * (7 - skill_level)))
			use(1)
		var/amt2raise = GET_MOB_ATTRIBUTE_VALUE(user, STAT_INTELLIGENCE) * 0.25
		if(repair_percent <= 0)
			amt2raise *= 0.25
		user.mind.add_sleep_experience(I.sewrepair, amt2raise)
		return TRUE
	return ..()
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

	if(affecting.get_incision(FALSE))
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
			if(doctor.diceroll(GET_MOB_SKILL_VALUE(doctor, /datum/attribute/skill/misc/medicine)-1, context = DICE_CONTEXT_PHYSICAL) <= DICE_FAILURE)
				to_chat(doctor, span_warning("My hand slips!"))
				return FALSE
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
	var/list/sewable = affecting.get_sewable_wounds()
	if(!length(sewable))
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
