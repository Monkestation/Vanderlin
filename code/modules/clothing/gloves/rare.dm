/obj/item/clothing/gloves/rare
	icon = 'icons/roguetown/clothing/Racial_Armour.dmi'
	mob_overlay_icon = 'icons/roguetown/clothing/onmob/onmob_racial.dmi'
	sleeved = 'icons/roguetown/clothing/onmob/onmob_racial.dmi'
	equip_sound = 'sound/foley/equip/equip_armor_plate.ogg'
	pickup_sound = "rustle"
	break_sound = 'sound/foley/breaksound.ogg'
	drop_sound = 'sound/foley/dropsound/armor_drop.ogg'
	sleevetype = null
	blocksound = PLATEHIT
	body_parts_covered = HANDS
	blade_dulling = DULLING_BASH
	sewrepair = FALSE
	anvilrepair = /datum/skill/craft/armorsmithing
	melt_amount = 75
	melting_material = /datum/material/steel

	armor_class = AC_HEAVY
	armor = ARMOR_PLATE_GOOD
	max_integrity = INTEGRITY_STRONGEST
	prevent_crits = ALL_CRITICAL_HITS
	abstract_type = /obj/item/clothing/gloves/rare

/obj/item/clothing/gloves/rare/elfplate
	name = "dark elf plate gauntlets"
	desc = "Plate gauntlets of mystic dark elven alloy, lightweight yet incredibly protective. Typically worn by elite bladesingers."
	icon_state = "elfhand"
	allowed_race = RACES_PLAYER_ELF_ALL
	item_weight = 7 * STEEL_MULTIPLIER

/obj/item/clothing/gloves/rare/elfplate/welfplate
	name = "elvish plate gauntlets"
	desc = "Plate gauntlets of mystic elven alloy, lightweight yet incredibly protective. Typically worn by elite bladesingers."
	icon_state = "welfhand"
	item_weight = 7 * STEEL_MULTIPLIER

/obj/item/clothing/gloves/rare/dwarfplate
	name = "dwarvish plate gauntlets"
	desc = "Plated gauntlets of masterwork dwarven smithing, the pinnacle of protection for one's hands."
	icon_state = "dwarfhand"
	allowed_race = list(SPEC_ID_DWARF)
	allowed_sex = list(MALE, FEMALE)
	item_weight = 7 * STEEL_MULTIPLIER

/obj/item/clothing/gloves/rare/grenzelplate
	name = "grenzelhoftian plate gauntlets"
	desc = "Battling the Zaladins led to the exchange of military ideas. The Grenzelhoft adopted refined chain and plate armaments to better allow their knights unmatchable resilience against the enemies of their Empire."
	icon_state = "human_swordhand"
	allowed_race = list(SPEC_ID_HUMEN, SPEC_ID_AASIMAR)
	allowed_sex = list(MALE)
	item_weight = 7 * STEEL_MULTIPLIER

/obj/item/clothing/gloves/rare/zaladplate
	name = "kataphractoe claw gauntlets"
	desc = "Interwoven beautifully with layers of silk, chain and plate, these gauntlets grant unmatched coverage while allowing maximum mobility. Both useful to the Zaladin's ever-growing slave-empire."
	icon_state = "human_spearhand"
	allowed_race = list(SPEC_ID_HUMEN)
	allowed_sex = list(MALE)
	item_weight = 6 * STEEL_MULTIPLIER
