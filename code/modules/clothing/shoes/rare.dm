/obj/item/clothing/shoes/boots/rare
	icon_state = "elfshoes"
	icon = 'icons/roguetown/clothing/Racial_Armour.dmi'
	mob_overlay_icon = 'icons/roguetown/clothing/onmob/onmob_racial.dmi'
	sleeved = 'icons/roguetown/clothing/onmob/onmob_racial.dmi'
	sleevetype = null
	resistance_flags = FIRE_PROOF // All of these are plated
	prevent_crits = list(BCLASS_LASHING, BCLASS_BITE, BCLASS_TWIST, BCLASS_CUT, BCLASS_CHOP, BCLASS_BLUNT, BCLASS_STAB)
	pickup_sound = "rustle"
	equip_sound = 'sound/foley/equip/equip_armor_plate.ogg'
	drop_sound = 'sound/foley/dropsound/armor_drop.ogg'
	break_sound = 'sound/foley/breaksound.ogg'
	anvilrepair = /datum/skill/craft/armorsmithing
	melt_amount = 75
	melting_material = /datum/material/steel
	armor = list("blunt" = 100, "slash" = 100, "stab" = 100,  "piercing" = 100, "fire" = 0, "acid" = 0)
	clothing_flags = CANT_SLEEP_IN
	sellprice = 30
	max_integrity = INTEGRITY_STRONGEST
	abstract_type = /obj/item/clothing/shoes/boots/rare

/obj/item/clothing/shoes/boots/rare/elfplate
	name = "dark elvish plated boots"
	desc = "Bizarrely shaped boots of exquisite dark elven craftsmanship, forged from steel alloyed in ways unbeknownst to every other species."
	body_parts_covered = FEET
	icon_state = "elfshoes"
	item_state = "elfshoes"
	allowed_race = RACES_PLAYER_ELF_ALL
	color = null
	blocksound = PLATEHIT
	item_weight = 7 * STEEL_MULTIPLIER

/obj/item/clothing/shoes/boots/rare/elfplate/welfplate
	name = "elvish plated boots"
	desc = "Bizarrely shaped boots of exquisite elven craftsmanship, forged from steel alloyed in ways unbeknownst to every other species."
	icon_state = "welfshoes"
	item_state = "welfshoes"

/obj/item/clothing/shoes/boots/rare/elfplate/welfplate
	name = "elvish plated boots"
	icon_state = "welfshoes"
	item_state = "welfshoes"

/obj/item/clothing/shoes/boots/rare/dwarfplate
	name = "decorated dwarven plate boots"
	allowed_race = list(SPEC_ID_DWARF)
	allowed_sex = list(MALE, FEMALE)
	desc = "Laced with golden bands, these dwarven plated boots glitter with glory as they are used to kick enemy's shins."
	body_parts_covered = FEET|LEGS
	icon_state = "dwarfshoe"
	item_state = "dwarfshoe"
	color = null
	blocksound = PLATEHIT
	item_weight = 7 * STEEL_MULTIPLIER

/obj/item/clothing/shoes/boots/rare/grenzelplate
	name = "grenzelhoft \"Elvenbane\" sabatons"
	allowed_race = list(SPEC_ID_HUMEN, SPEC_ID_AASIMAR)
	allowed_sex = list(MALE)
	desc = "The sabatons that march to the tune of a glorious nation. It is said that the boots \
			are gilded with the tears of once native elves of the Grenzeholft lands, \
			eradicated via humen conquest."
	body_parts_covered = FEET|LEGS
	icon_state = "human_swordshoes"
	item_state = "human_swordshoes"
	color = null
	blocksound = PLATEHIT
	item_weight = 7 * STEEL_MULTIPLIER

/obj/item/clothing/shoes/boots/rare/zaladplate
	name = "Zaladin segmented plate boots"
	allowed_race = list(SPEC_ID_HUMEN)
	allowed_sex = list(MALE)
	desc = "The segmented plate boots are a recent alteration to the Zaladin Elite, \
			many old warriors decorate their own by tieing ribbons and other knick-knacks \
			as a homage to the colorful socks they wore in simpler times."
	body_parts_covered = FEET|LEGS
	icon_state = "human_spearshoe"
	item_state = "human_spearshoe"
	color = null
	blocksound = PLATEHIT
	item_weight = 7 * STEEL_MULTIPLIER
