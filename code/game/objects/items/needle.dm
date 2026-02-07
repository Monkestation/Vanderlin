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
	anvilrepair = /datum/skill/craft/blacksmithing
	melting_material = /datum/material/iron
	melt_amount = 20
	tool_behaviour = TOOL_SUTURE

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
			if(do_after(user, 6 SECONDS - user.get_skill_level(/datum/skill/misc/sewing, TRUE), I))
				stringamt += 5
				to_chat(user, "I replenish the needle's thread!")
				qdel(I)
				update_appearance(UPDATE_OVERLAYS)
			return
	return ..()

/obj/item/needle/pre_attack(atom/A, mob/living/user, list/modifiers)
	if(isitem(A))
		var/obj/item/I = A
		if(!(I.obj_flags & CAN_BE_HIT) && !istype(A, /obj/item/storage)) // to preserve old attack_obj behavior
			return ..()
		if(!I.ontable() || !I.sewrepair)
			return ..()
		if(!I.uses_integrity || I.obj_broken)
			to_chat(user, span_warning("[I] can't be repaired!"))
			return ..()
		if(I.get_integrity() >= I.max_integrity)
			return ..()
		if(stringamt < 1)
			to_chat(user, span_warning("[src] has no thread left!"))
			return TRUE
		if(!can_repair)
			to_chat(user, span_warning("[src] cannot be used to repair [A]!"))
			return TRUE
		var/armor_value = 0
		var/skill_level = user.get_skill_level(/datum/skill/misc/sewing)
		for(var/key in I.armor.getList()) // Here we are checking if the armor value of the item is 0 so we can know if the item is armor without having to make a snowflake var
			armor_value += I.armor.getRating(key)
		if((armor_value == 0 && skill_level < 1) || (armor_value > 0 && skill_level < 2))
			to_chat(user, span_warning("I should probably not be doing this..."))
		playsound(src, 'sound/foley/sewflesh.ogg', 100, TRUE, -2)
		var/skill_multiplied = (skill_level * 10)
		var/sewtime = (6 SECONDS - skill_multiplied)
		if(!do_after(user, sewtime, I))
			return TRUE
		if((armor_value == 0 && skill_level > 0) || (armor_value > 0 && skill_level > 1)) //If not armor but skill level at least 1 or Armor and skill level at least 2
			user.visible_message(span_info("[user] repairs [I]!"))
			I.repair_damage(skill_multiplied)
			if(prob(10 * (7 - skill_level)))
				use(1)
		else
			if(prob(20 - user.STALUC)) //Unlucky here!
				I.take_damage(150, BRUTE, "slash")
				user.visible_message(span_warning("[user] was extremely unlucky and ruined [I] while futilely trying to repair it!"))
				playsound(src, 'sound/foley/cloth_rip.ogg', 50, TRUE)
			else if(prob(user.STALUC)) //Lucky here!
				I.repair_damage(50)
				playsound(src, 'sound/magic/ahh2.ogg', 50, TRUE)
				user.visible_message(span_info("A miracle! [user] somehow managed to repair [I] while not having a single clue what [user.p_they()] [user.p_were()] doing!"))
			else
				I.take_damage(50, BRUTE, "slash")
				user.visible_message(span_warning("[user] damaged [I] due to a lack of skill!"))
				playsound(src, 'sound/foley/cloth_rip.ogg', 50, TRUE)
			user.mind.add_sleep_experience(/datum/skill/misc/sewing, (user.STAINT) / 2) // Only failing if we have no idea what we're doing
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

	var/list/sewable
	var/obj/item/bodypart/affecting = patient.get_bodypart(check_zone(doctor.zone_selected))
	if(!affecting)
		to_chat(doctor, span_warning("That limb is missing."))
		return FALSE

	if(affecting.bandage)
		to_chat(doctor, span_warning("There is a bandage in the way."))
		return FALSE

	sewable = affecting.get_sewable_wounds()

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

/obj/item/needle/blessed
	name = "blessed needle"
	desc = span_hierophant("A needle blessed by the ordained Pestrans of the Church. A coveted item, for its thread will never end. \n This thread however can only be used to sew wounds.")
	infinite = TRUE
	can_repair = FALSE
