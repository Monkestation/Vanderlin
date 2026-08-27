/mob/living/carbon/human/proc/do_splint(obj/item/splint/splint, mob/living/carbon/target)
	var/obj/item/bodypart/limb = target.get_bodypart(check_zone(zone_selected))
	if(!limb)
		to_chat(src, span_warning("[target] is missing that limb!"))
		return FALSE
	if(limb.splinted)
		to_chat(src, span_warning("[target]'s [limb.name] is already splinted!"))
		return FALSE
	var/splint_type = FALSE
	for(var/datum/wound/wound as anything in limb.wounds)
		if(!wound.splint_suppression)
			continue
		splint_type = TRUE
		break
	if(!splint_type)
		to_chat(src, span_warning("There's nothing broken in [target]'s [limb.name]!"))
		return FALSE

	visible_message(span_notice("[src] starts splinting [target]'s [limb.name]..."), \
		span_notice("I start splinting [target == src ? "my" : "[target]'s"] [limb.name]..."), \
		vision_distance = COMBAT_MESSAGE_RANGE)

	if(!do_after(src, 5 SECONDS, target))
		return FALSE
	if(limb.splinted)
		return FALSE

	log_combat(src, target, "splinted")
	return limb.apply_splint(splint, src)

/mob/living/carbon/human/proc/do_remove_splint(obj/item/bodypart/limb)
	if(!limb?.splinted)
		to_chat(src, span_warning("There's no splint there!"))
		return FALSE
	var/mob/living/carbon/target = limb.owner
	if(!target)
		return FALSE

	visible_message(span_notice("[src] starts removing the splint on [target == src ? "[src]'s" : "[target]'s"] [limb.name]..."), \
		span_notice("I start removing the splint on [target == src ? "my" : "[target]'s"] [limb.name]..."), \
		vision_distance = COMBAT_MESSAGE_RANGE)

	if(!do_after(src, 4 SECONDS, target))
		return FALSE
	if(!limb.splinted || limb.owner != target)
		return FALSE

	log_combat(src, target, "removed a splint from")
	return limb.remove_splint(src)

/obj/item/splint
	name = "improvised splint"
	desc = "A stick and some wrapping. Doesn't fix a break, just stops it grinding when you move."
	icon = 'icons/roguetown/items/surgery.dmi'
	icon_state = "splint"
	w_class = WEIGHT_CLASS_SMALL
	grid_width = 32
	grid_height = 32
	var/wound_healing = 0.5
	///how much damage we need to take until we break
	var/break_threshold = SPLINT_BREAK_THRESHOLD

/obj/item/splint/interact_with_atom(atom/interacting_with, mob/living/carbon/human/user, list/modifiers)
	if(ishuman(interacting_with))
		var/mob/living/carbon/human/human = interacting_with
		if(user.do_splint(src, human))
			return ITEM_INTERACT_SUCCESS
		return ITEM_INTERACT_BLOCKING
	return NONE
