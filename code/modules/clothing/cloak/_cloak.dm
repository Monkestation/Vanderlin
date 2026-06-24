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

	/// Does it have internal storage? If so it will create a component below.
	var/has_storage = FALSE
	/// Similar function to pocket_storage_component_path but rather than always loading it's conditional.
	var/datum/component/storage/storage_component_path = /datum/component/storage/concrete/grid/cloak

/obj/item/clothing/cloak/Initialize(mapload, ...)
	. = ..()
	if(has_storage && storage_component_path)
		AddComponent(storage_component_path)

/obj/item/clothing/cloak/dropped(mob/living/carbon/human/user)
	..()
	if(QDELETED(src))
		return
	var/datum/component/storage/storage_comp = GetComponent(/datum/component/storage)
	if(storage_comp)
		var/list/things = storage_comp.contents()
		for(var/obj/item/I in things)
			storage_comp.remove_from_storage(I, get_turf(src))
