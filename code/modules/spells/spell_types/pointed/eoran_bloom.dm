/datum/action/cooldown/spell/eoran_bloom
	name = "Eoran Bloom"
	desc = "Grows an Eoran bud on the target."
	button_icon_state = "pflower"
	sound = 'sound/magic/magnet.ogg'

	spell_type = SPELL_MIRACLE
	antimagic_flags = MAGIC_RESISTANCE_HOLY
	associated_skill = /datum/skill/magic/holy
	required_items = list(/obj/item/clothing/neck/psycross/silver/eora)

	invocation = "Be at peace with Eora."
	invocation_type = INVOCATION_SHOUT

	cast_range = 3

	charge_time = 3 SECONDS
	cooldown_time = 60 SECONDS
	spell_cost = 65

/datum/action/cooldown/spell/eoran_bloom/cast(atom/cast_on)
	. = ..()
	var/mob/living/carbon/human/to_pacify
	if(isopenturf(cast_on))
		for(var/mob/living/carbon/human/H in cast_on)
			to_pacify = H
			break
	else if(ishuman(cast_on))
		to_pacify = cast_on

	if(!to_pacify)
		var/turf/spawn_on = get_turf(cast_on)
		if(!spawn_on.density)
			new /obj/item/clothing/head/peaceflower(cast_on)
		else
			to_chat(owner, span_warning("The targeted location is blocked. The flowers of Eora refuse to bloom."))
		return

	if(to_pacify.get_item_by_slot(ITEM_SLOT_HEAD))
		to_chat(owner, span_warning("The target's head is covered. The flowers of Eora need an open space to bloom."))
		return

	var/obj/item/clothing/head/peaceflower/F = new(get_turf(to_pacify))
	to_pacify.equip_to_slot_if_possible(F, ITEM_SLOT_HEAD, TRUE, TRUE)
	to_chat(to_pacify, span_info("<b style='color:pink'>A flower of Eora blooms on my head, I feel at peace.</b>"))

/obj/item/clothing/head/peaceflower
	name = "eoran bud"
	desc = "A flower of gentle petals, associated with Eora or Necra. Usually adorned as a headdress or laid at graves as a symbol of love or peace."
	icon = 'icons/roguetown/items/produce.dmi'
	mob_overlay_icon = 'icons/roguetown/clothing/onmob/head_items.dmi'
	icon_state = "peaceflower"
	item_state = "peaceflower"
	dropshrink = 0.9
	slot_flags = ITEM_SLOT_HEAD
	body_parts_covered = NONE
	dynamic_hair_suffix = ""
	force = 0
	throwforce = 0
	w_class = WEIGHT_CLASS_TINY
	throw_speed = 1
	throw_range = 3

/obj/item/clothing/head/peaceflower/equipped(mob/living/carbon/human/user, slot)
	. = ..()
	if(slot & ITEM_SLOT_HEAD)
		RegisterSignal(user, COMSIG_MOB_UNEQUIPPED_ITEM, PROC_REF(item_removed))
		ADD_TRAIT(user, TRAIT_PACIFISM, "peaceflower_[REF(src)]")
		user.add_stress(/datum/stress_event/eora)

/obj/item/clothing/head/peaceflower/proc/item_removed(mob/living/carbon/wearer, obj/item/dropped_item)
	SIGNAL_HANDLER
	if(dropped_item != src)
		return
	UnregisterSignal(wearer, COMSIG_MOB_UNEQUIPPED_ITEM)
	REMOVE_TRAIT(wearer, TRAIT_PACIFISM, "peaceflower_[REF(src)]")
	wearer.remove_stress(/datum/stress_event/eora)

/obj/item/clothing/head/peaceflower/proc/peace_check(mob/living/user)
	// return true if we should be unequippable, return false if not
	if(iscarbon(user))
		var/mob/living/carbon/C = user
		if(src == C.head)
			to_chat(user, span_warning("<b style='color:pink'>I need some time to distance myself from peace.</b>"))
			if(do_after(user, 4 SECONDS))
				return FALSE
			return TRUE
	return FALSE

/obj/item/clothing/head/peaceflower/MouseDrop(atom/over_object)
	if(!peace_check(usr))
		return ..()

/obj/item/clothing/head/peaceflower/attack_hand(mob/user)
	if(!peace_check(user))
		return ..()

//Putting this here for now until we have a better place. Ook wants this to inject drugs eventually. I guess this is decent for now.
/obj/item/clothing/head/corruptflower
	name = "baothan bud"
	desc = "A flower of dark petals and sharp thorns, associated with Baotha. It is said that these allow their wearer to better commune with their goddess."
	icon = 'icons/roguetown/items/produce.dmi'
	mob_overlay_icon = 'icons/roguetown/clothing/onmob/head_items.dmi'
	icon_state = "corruptflower"
	item_state = "corruptflower"
	dropshrink = 0.9
	slot_flags = ITEM_SLOT_HEAD
	body_parts_covered = NONE
	dynamic_hair_suffix = ""
	force = 0
	throwforce = 0
	w_class = WEIGHT_CLASS_TINY
	throw_speed = 1
	throw_range = 3

/obj/item/clothing/head/corruptflower/equipped(mob/living/carbon/human/user, slot)
	. = ..()
	if(slot & ITEM_SLOT_HEAD)
		RegisterSignal(user, COMSIG_MOB_UNEQUIPPED_ITEM, PROC_REF(item_removed))
		ADD_TRAIT(user, TRAIT_CRACKHEAD, "corruptflower_[REF(src)]")
		user.add_curse(/datum/curse/baotha)
		to_chat(user, span_userdanger("FUCK YES. Party on!</b>"))

/obj/item/clothing/head/corruptflower/proc/item_removed(mob/living/carbon/human/wearer, obj/item/dropped_item)
	SIGNAL_HANDLER
	if(dropped_item != src)
		return
	UnregisterSignal(wearer, COMSIG_MOB_UNEQUIPPED_ITEM)
	wearer.remove_curse(/datum/curse/baotha)
	if(wearer.patron != /datum/patron/inhumen/baotha)
		REMOVE_TRAIT(wearer, TRAIT_CRACKHEAD, "corruptflower_[REF(src)]")

/obj/item/clothing/head/corruptflower/proc/cursed_check(mob/living/user)
	// return true if we should be unequippable, return false if not
	if(iscarbon(user))
		var/mob/living/carbon/C = user
		if(src == C.head)
			to_chat(user, span_userdanger("Curse? What curse!? I feel great! Why would I ever want sobriety?"))
			return TRUE
	return FALSE

/obj/item/clothing/head/corruptflower/attack_hand(mob/user)
	if(!cursed_check(usr))
		return ..()

/obj/item/clothing/head/corruptflower/MouseDrop(atom/over_object)
	if(!cursed_check(usr))
		return ..()
