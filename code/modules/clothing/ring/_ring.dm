/obj/item/clothing/ring
	name = "ring"
	desc = ""
	w_class = WEIGHT_CLASS_TINY
	icon = 'icons/roguetown/clothing/rings.dmi'
	mob_overlay_icon = 'icons/roguetown/clothing/onmob/rings.dmi'
	sleeved = 'icons/roguetown/clothing/onmob/rings.dmi'
	sleevetype = "shirt"
	icon_state = ""
	slot_flags = ITEM_SLOT_RING
	resistance_flags = FIRE_PROOF | ACID_PROOF
	dropshrink = 0.8
	item_weight = 0.5
	abstract_type = /obj/item/clothing/ring
	wetable = FALSE

/obj/item/clothing/ring/proc/can_identify(user)
	return IsAdminGhost(user) || get_dist(user, src) < 2

/obj/item/clothing/ring/get_examine_name(mob/user, use_article)
	if(!can_identify(user))
		return "a <b>ring</b>"
	return ..()

/obj/item/clothing/ring/get_examine_desc(mob/user)
	if(can_identify(user))
		return ..()

/obj/item/clothing/ring/get_over_text_content(mob/user)
	if(!can_identify(user))
		return "ring"
	return ..()
