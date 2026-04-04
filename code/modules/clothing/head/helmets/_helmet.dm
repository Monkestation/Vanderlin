/obj/item/clothing/head/helmet
	equip_sound = 'sound/foley/equip/equip_armor.ogg'
	drop_sound = 'sound/foley/dropsound/armor_drop.ogg'
	break_sound = 'sound/foley/breaksound.ogg'
	pickup_sound = 'sound/foley/dropsound/cloth_drop.ogg'
	blocksound = PLATEHIT
	resistance_flags = FIRE_PROOF
	anvilrepair = /datum/attribute/skill/craft/armor_repair
	sewrepair = null
	smeltresult = /obj/item/ingot/iron
	sellprice = VALUE_IRON_ITEM
	clothing_flags = CANT_SLEEP_IN

	armor = ARMOR_PLATE_BAD
	max_integrity = INTEGRITY_POOR //Looked like it was defaulting to integrity_worst from head.dm which gave some helmets the same durability has hats.
	body_parts_covered = COVERAGE_SKULL
	prevent_crits = ALL_EXCEPT_STAB

	grid_height = 64
	grid_width = 64
	abstract_type = /obj/item/clothing/head/helmet

	material_category = ARMOR_MAT_PLATE
