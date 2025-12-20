
/obj/item/clothing/pants/chainlegs
	name = "chain chausses"
	desc = "Chain mail chausses made of exquisite steel rings boasting superior protection."
	gender = PLURAL
	icon_state = "chain_legs"
	item_state = "chain_legs"
	sewrepair = FALSE
	resistance_flags = FIRE_PROOF
	blocksound = CHAINHIT
	equip_delay_self = 25
	unequip_delay_self = 25
	var/do_sound = FALSE
	equip_sound = 'sound/foley/equip/equip_armor_chain.ogg'
	drop_sound = 'sound/foley/dropsound/chain_drop.ogg'
	pickup_sound = "rustle"
	break_sound = 'sound/foley/breaksound.ogg'
	anvilrepair = /datum/skill/craft/armorsmithing
	melt_amount = 75
	melting_material = /datum/material/steel
	r_sleeve_status = SLEEVE_NOMOD
	l_sleeve_status = SLEEVE_NOMOD

	armor_class = AC_MEDIUM
	armor = ARMOR_MAILLE
	max_integrity = INTEGRITY_STRONGEST
	prevent_crits = ALL_EXCEPT_BLUNT
	item_weight = 6 * STEEL_MULTIPLIER

/obj/item/clothing/pants/chainlegs/Initialize()
	. = ..()
	AddComponent(/datum/component/item_equipped_movement_rustle)

/obj/item/clothing/pants/chainlegs/iron
	icon_state = "ichain_legs"
	name = "iron chain chausses"
	desc = "Chain mail chausses made of iron rings woven together, offering protection against cuts and stabs."
	smeltresult = /obj/item/ingot/iron
	armor = ARMOR_MAILLE_IRON
	max_integrity = INTEGRITY_STRONG
	item_weight = 6 * IRON_MULTIPLIER

/obj/item/clothing/pants/chainlegs/kilt
	name = "steel chain kilt"
	desc = "Interlinked metal rings that drape down all the way to the ankles."
	icon = 'icons/roguetown/clothing/special/pants_metal.dmi'
	mob_overlay_icon = 'icons/roguetown/clothing/special/onmob/pants_metal.dmi'
	sleeved = 'icons/roguetown/clothing/special/onmob/pants_metal.dmi'
	icon_state = "chainkilt"
	item_state = "chainkilt"

/obj/item/clothing/pants/chainlegs/kilt/iron
	name = "iron chain kilt"
	desc = "Interlinked metal rings that drape down all the way to the ankles."
	icon_state = "ichainkilt"
	item_state = "ichainkilt"
	smeltresult = /obj/item/ingot/iron
	armor = ARMOR_MAILLE_IRON
	max_integrity = INTEGRITY_STRONG
