/obj/item/storage/belt
	name = ""
	desc = ""

	w_class = WEIGHT_CLASS_NORMAL

	icon = 'icons/roguetown/clothing/belts.dmi'
	mob_overlay_icon = 'icons/roguetown/clothing/onmob/belts.dmi'
	icon_state = ""
	item_state = ""
	bloody_icon_state = "bodyblood"

	slot_flags = ITEM_SLOT_BELT
	attack_verb = list("whips", "lashes")

	max_integrity = 300
	equip_sound = 'sound/blank.ogg'

	sewrepair = /datum/attribute/skill/craft/tanning/patching
	dyeable = TRUE
	fiber_salvage = TRUE
	salvage_amount = 1
	salvage_result = /obj/item/natural/hide/cured
	component_type = /datum/component/storage/concrete/grid/belt
	item_weight = 250 GRAMS

/obj/item/storage/belt/suicide_act(mob/living/carbon/user)
	user.visible_message("<span class='suicide'>[user] begins belting [user.p_them()]self with \the [src]! It looks like [user.p_theyre()] trying to commit suicide!</span>")
	return BRUTELOSS
