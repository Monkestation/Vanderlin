/obj/item/clothing/cloak/lordcloak
	name = "lordly cloak"
	desc = "Ermine trimmed, handed down."
	color = null
	icon_state = "lord_cloak"
	item_state = "lord_cloak"
	alternate_worn_layer = CLOAK_BEHIND_LAYER
	slot_flags = ITEM_SLOT_BACK_R|ITEM_SLOT_CLOAK
	boobed = TRUE
	sleeved = 'icons/roguetown/clothing/onmob/cloaks.dmi'
	sleevetype = "shirt"
	nodismemsleeves = TRUE
	inhand_mod = TRUE
	allowed_race = SPECIES_BASE_BODY
	detail_tag = "_det"
	detail_color = CLOTHING_PLUM_PURPLE
	uses_lord_coloring = LORD_PRIMARY

/obj/item/clothing/cloak/lordcloak/Initialize(mapload, ...)
	. = ..()
	create_storage(type = /datum/storage/cloak/lord)

/obj/item/clothing/cloak/lordcloak/dropped(mob/user, silent)
	. = ..()
	atom_storage?.remove_all(get_turf(src))

/obj/item/clothing/cloak/lordcloak/ladycloak
	name = "ladylike shortcloak"
	desc = "Ermine trimmed, handed down."
	color = null
	icon_state = "shortcloak"
	item_state = "shortcloak"
	alternate_worn_layer = CLOAK_BEHIND_LAYER
	slot_flags = ITEM_SLOT_BACK_R|ITEM_SLOT_CLOAK
	boobed = TRUE
	sleeved = 'icons/roguetown/clothing/onmob/cloaks.dmi'
	sleevetype = "shirt"
	nodismemsleeves = TRUE
	detail_tag = "_detail"
	detail_color = CLOTHING_SOOT_BLACK
