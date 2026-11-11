/mob/living/carbon/human/proc/do_apply_tourniquet(obj/item/tourniquet/tourniquet, mob/living/carbon/target)
	var/obj/item/bodypart/limb = target.get_bodypart(check_zone(zone_selected))
	if(!limb)
		to_chat(src, span_warning("[target] is missing that limb!"))
		return FALSE
	var/location_accessible = get_location_accessible(target, zone_selected)
	if(!location_accessible)
		to_chat(src, span_warning("Clothing is in the way!"))
		return FALSE
	if(!(limb.body_zone in TOURNIQUET_LIMBS))
		to_chat(src, span_warning("A tourniquet won't do anything for that!"))
		return FALSE
	if(limb.tourniquet)
		to_chat(src, span_warning("[target]'s [limb.name] already has one on!"))
		return FALSE

	visible_message(span_notice("[src] starts tying [tourniquet] around [target]'s [limb.name]!"), \
		span_notice("I start tying [tourniquet] around [target == src ? "my" : "[target]'s"] [limb.name]..."), \
		vision_distance = COMBAT_MESSAGE_RANGE)

	if(!do_after(src, (target == src ? 6 SECONDS : 4 SECONDS), target))
		return FALSE
	if(limb.tourniquet)
		return FALSE

	log_combat(src, target, "applied a tourniquet to")
	visible_message(span_notice("<b>[src]</b> cinches a tourniquet tight around <b>[target]</b>'s [limb.name]!"), \
		span_notice("I cinch a tourniquet tight around [target == src ? "my" : "[target]'s"] [limb.name]."), \
		vision_distance = COMBAT_MESSAGE_RANGE)

	return limb.apply_tourniquet(tourniquet, src)

/mob/living/carbon/human/proc/do_remove_tourniquet(obj/item/bodypart/limb)
	if(!limb?.tourniquet)
		to_chat(src, span_warning("There's no tourniquet there!"))
		return FALSE
	var/mob/living/carbon/target = limb.owner
	if(!target)
		return FALSE

	visible_message(span_notice("[src] starts loosening the tourniquet on [target == src ? "[src]'s" : "[target]'s"] [limb.name]..."), \
		span_notice("I start loosening the tourniquet on [target == src ? "my" : "[target]'s"] [limb.name]..."), \
		vision_distance = COMBAT_MESSAGE_RANGE)

	if(!do_after(src, 4 SECONDS, target))
		return FALSE
	if(!limb.tourniquet || limb.owner != target)
		return FALSE

	log_combat(src, target, "removed a tourniquet from")
	var/was_sudden = FALSE
	if(limb.get_bleed_rate())
		was_sudden = TRUE
	return limb.remove_tourniquet(src, sudden = was_sudden)

/obj/item/tourniquet
	name = "improvised tourniquet"
	desc = "A strip of cloth twisted tight around a stick. Stops bleeding fast. Stops a lot else too, given time."
	icon = 'icons/roguetown/items/surgery.dmi'
	icon_state = "tourniquet"
	w_class = WEIGHT_CLASS_TINY
	grid_width = 32
	grid_height = 32
	///if this is set its what we apply as a stop to limbs bleeding outright
	var/bleed_mod

/obj/item/tourniquet/interact_with_atom(atom/interacting_with, mob/living/carbon/human/user, list/modifiers)
	if(ishuman(interacting_with))
		var/mob/living/carbon/human/human = interacting_with
		if(user.do_apply_tourniquet(src, human))
			return ITEM_INTERACT_SUCCESS
		return ITEM_INTERACT_BLOCKING
	return NONE
