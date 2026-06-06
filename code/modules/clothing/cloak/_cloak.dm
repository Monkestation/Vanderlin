/obj/item/clothing/cloak
	name = "cloak"
	icon = 'icons/roguetown/clothing/cloaks.dmi'
	mob_overlay_icon = 'icons/roguetown/clothing/onmob/cloaks.dmi'
	slot_flags = ITEM_SLOT_CLOAK
	desc = "A simple cloak covering the body."
	edelay_type = 1
	equip_delay_self = 10
	equip_sound = 'sound/foley/equip/cloak_equip.ogg'
	pickup_sound = 'sound/foley/equip/cloak_take_off.ogg'
	bloody_icon_state = "bodyblood"
	sewrepair = /datum/attribute/skill/misc/sewing/mending
	salvage_result = /obj/item/natural/cloth
	dyeable = TRUE
	anvilrepair = null
	abstract_type = /obj/item/clothing/cloak
	smeltresult = /obj/item/fertilizer/ash

	grid_width = 64
	grid_height = 64
	item_weight = 350 GRAMS
