/obj/item/organ/item_interaction(mob/living/user, obj/item/tool, list/modifiers)
	if(user.cmode)
		return NONE

	if(handle_organ_attack(tool, user, modifiers))
		return ITEM_INTERACT_SUCCESS

/obj/item/organ/get_mechanics_examine(mob/user)
	. = ..()

	if(owner && CHECK_BITFIELD(organ_flags, ORGAN_CUT_AWAY))
		for(var/atom/thing as anything in attaching_items)
			. += "Use [initial(thing.name)] to reattach this organ to [owner]."

	for(var/atom/thing as anything in healing_items)
		. += "Use [initial(thing.name)] to heal this organ."

	for(var/thing in healing_tools)
		. += "Use a [thing] to heal this organ."

	if(owner && !CHECK_BITFIELD(organ_flags, ORGAN_CUT_AWAY))
		. += "Use a sharp item or scalpel to sever this organ from [owner]."

	if(germ_level)
		. += "Use a cautery to burn the miasma from this organ."

/obj/item/organ/proc/handle_organ_attack(obj/item/tool, mob/living/user, list/modifiers)
	if(owner && DOING_INTERACTION_WITH_TARGET(user, owner))
		return TRUE
	else if(DOING_INTERACTION_WITH_TARGET(user, src))
		return TRUE

	if(owner && CHECK_BITFIELD(organ_flags, ORGAN_CUT_AWAY))
		for(var/thing in attaching_items)
			if(istype(tool, thing))
				return handle_attaching_item(tool, user, modifiers)

	for(var/thing in healing_items)
		if(istype(tool, thing))
			return handle_healing_item(tool, user, modifiers)

	for(var/thing in healing_tools)
		if(tool.tool_behaviour == thing)
			return handle_healing_item(tool, user, modifiers)

	if(owner && (tool.sharpness == IS_SHARP || tool.tool_behaviour == TOOL_SCALPEL) && !CHECK_BITFIELD(organ_flags, ORGAN_CUT_AWAY))
		return handle_cutting_away(tool, user, modifiers)

	if(tool.tool_behaviour == TOOL_CAUTERY)
		return handle_burning_rot(tool, user, modifiers)

/obj/item/organ/proc/handle_attaching_item(obj/item/tool, mob/living/user, list/modifiers)
	var/obj/item/natural/stack = tool
	user.visible_message(
		span_notice("<b>[user]</b> starts attaching \the [name] on [owner]..."), \
		span_notice("I start attaching \the [name] on [owner]..."), \
		vision_distance = COMBAT_MESSAGE_RANGE
	)

	var/time = 3 SECONDS
	time *= (SKILL_MIDDLING / max(GET_MOB_SKILL_VALUE(user, /datum/attribute/skill/misc/medicine), 1))

	owner.custom_pain("OH GOD! There is something ripping me from inside!", 30, FALSE, owner.get_bodypart(current_zone))
	if(!do_after(user, time, owner))
		to_chat(user, span_warning("I must stand still!"))
		return FALSE

	if(istype(stack) && !stack.use(2))
		to_chat(user, span_warning("I don't have enough to attach \the [src]!"))
		return FALSE

	user.visible_message(span_notice("<b>[user]</b> attaches \the [src] safely on \the <b>[owner]</b>."), \
						span_notice("I attach \the [src] safely on \the <b>[owner]</b>."))
	organ_flags &= ~ORGAN_CUT_AWAY

	return TRUE

/obj/item/organ/proc/handle_healing_item(obj/item/tool, mob/living/user, list/modifiers)

	/*
	if(organ_flags & (ORGAN_DESTROYED|ORGAN_NECROTIC))
		to_chat(user, span_warning("\The [src] is damaged beyond the point of no return."))
		return
	*/

	if(!damage && !(organ_flags & ORGAN_DESTROYED))
		to_chat(user, span_notice("\The [name] is in pristine quality already."))
		return FALSE

	if(istype(tool, /obj/item/natural/bundle))
		var/obj/item/natural/bundle/bundle = tool
		if(!bundle.use(2))
			to_chat(user, span_warning("I don't have enough to heal \the [name]!"))
			return

	user.visible_message(
		span_notice("[user] starts healing \the [name]..."), \
		span_notice("I start healing \the [name]..."), \
		vision_distance = COMBAT_MESSAGE_RANGE
	)


	var/time = 5 SECONDS
	time *= (SKILL_MIDDLING / max(GET_MOB_SKILL_VALUE(user, /datum/attribute/skill/misc/medicine), 1))

	if(owner)
		owner.custom_pain("OH GOD! There are needles inside my [src]!", 30, FALSE, owner.get_bodypart(current_zone))
		if(!do_after(user, time, owner))
			to_chat(user, span_warning("I must stand still!"))
			return FALSE
	else
		if(!do_after(user, time, src))
			to_chat(user, span_warning("I must stand still!"))
			return FALSE

	user.visible_message(
		span_notice("[user] healing \the [name]."), \
		span_notice("I heal \the [name].")
	)

	applyOrganDamage(-min(maxHealth / 2, 50))

	if(organ_flags & ORGAN_DESTROYED)
		organ_flags &= ~ORGAN_DESTROYED //I am having pity on people here at this point I won't force you to get new organs unless they fully necrose.
		scar_organ(10, 60)

	return TRUE

/obj/item/organ/proc/handle_cutting_away(obj/item/tool, mob/living/user, list/modifiers)
	user.visible_message(
		span_warning("[user] starts severing \the [name] from [owner]..."), \
		span_notice("I start severing \the [name] from [owner]..."), \
		vision_distance = COMBAT_MESSAGE_RANGE
	)

	owner.custom_pain("OH GOD! My [src] is being STABBED!", 30, FALSE, owner.get_bodypart(current_zone))

	var/time = 6 SECONDS
	time *= (SKILL_MIDDLING / max(GET_MOB_SKILL_VALUE(user, /datum/attribute/skill/misc/medicine), 1))

	if(!do_after(user, time, owner))
		to_chat(user, span_warning("I must stand still!"))
		return FALSE

	user.visible_message(
		span_notice("[user] severs \the [name] away."), \
		span_notice("I sever \the [name] away."), \
		vision_distance = COMBAT_MESSAGE_RANGE
	)

	organ_flags |= ORGAN_CUT_AWAY

	return TRUE

/obj/item/organ/proc/handle_burning_rot(obj/item/tool, mob/living/user, list/modifiers)
	user.visible_message(
		span_notice("[user] starts burning rot from \the [name]..."), \
		span_notice("I start burning rot from \the [name]..."), \
		vision_distance = COMBAT_MESSAGE_RANGE
	)

	if(!germ_level)
		to_chat(user, span_notice("\The [name] is free of miasma."))
		return FALSE

	owner.custom_pain("OH GOD! My [src] is being STABBED!", 30, FALSE, owner.get_bodypart(current_zone))

	var/time = 6 SECONDS
	time *= (SKILL_MIDDLING / max(GET_MOB_SKILL_VALUE(user, /datum/attribute/skill/misc/medicine), 1))

	if(!do_after(user, time, owner))
		to_chat(user, span_warning("I must stand still!"))
		return FALSE

	user.visible_message(
		span_notice("[user] burn the rot away from \the [name]."), \
		span_notice("I burn the rot away from \the [name]."), \
		vision_distance = COMBAT_MESSAGE_RANGE
	)

	set_germ_level(0)

	return TRUE
