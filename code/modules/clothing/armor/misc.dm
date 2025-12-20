//..................................................................................................................................
/*---------------\
|			 	 |
|  Light Armor	 |
|			 	 |
\---------------*/

/*-------------\
| Padded Armor |	- Cloth based
\-------------*/
//................ Corset.................... //
/obj/item/clothing/armor/corset
	slot_flags = ITEM_SLOT_ARMOR|ITEM_SLOT_SHIRT
	name = "corset"
	desc = "A leather binding to constrict one's figure... and lungs."
	icon_state = "corset"
	armor = ARMOR_PADDED
	body_parts_covered = COVERAGE_VEST

//................ Amazon chainkini ............... //
/obj/item/clothing/armor/amazon_chainkini
	name = "amazonian armor"
	desc = "Fur skirt and maille chest holder, typically worn by warrior women of the isle of Issa."
	icon_state = "chainkini"
	item_state = "chainkini"
	allowed_sex = list(FEMALE)
	sewrepair = TRUE
	smeltresult = /obj/item/ingot/iron
	sellprice = VALUE_IRON_ARMOR_UNUSUAL
	// It looks better without these
	flags_inv = HIDEUNDIES
	armor_class = AC_LIGHT
	armor = ARMOR_LEATHER_GOOD
	body_parts_covered = COVERAGE_TORSO
	prevent_crits = ALL_EXCEPT_BLUNT
	item_weight = 7 * IRON_MULTIPLIER
	min_cold_protection_temperature = 5 //this is like fur but also its a fucking bikini like???

//................ Brigandine ............... //
/obj/item/clothing/armor/brigandine
	name = "brigandine"
	desc = "A coat with plates concealed inside an exterior fabric. Protects the user from melee impacts and also ranged attacks to an extent."
	icon_state = "brigandine"
	blocksound = SOFTHIT
	equip_delay_self = 4 SECONDS
	unequip_delay_self = 4 SECONDS
	anvilrepair = /datum/skill/craft/armorsmithing
	melt_amount = 75
	melting_material = /datum/material/steel
	sellprice = VALUE_BRIGANDINE
	clothing_flags = CANT_SLEEP_IN

	armor_class = AC_HEAVY
	armor = ARMOR_BRIGANDINE
	body_parts_covered = COVERAGE_ALL_BUT_LEGS
	max_integrity = INTEGRITY_STRONGEST
	prevent_crits = ALL_EXCEPT_BLUNT
	item_weight = 3.2 * IRON_MULTIPLIER
	stand_speed_reduction = 1.15

/obj/item/clothing/armor/brigandine/Initialize()
	. = ..()
	AddComponent(/datum/component/item_equipped_movement_rustle, custom_sounds = SFX_PLATE_COAT_STEP)

//................ Abyssal Robe ............... //
/obj/item/clothing/armor/brigandine/abyssor // This is only a brigandine subtype for balance reasons, it should be a cuirass variant.
	name = "abyssal robe"
	desc = "A bronze cuirass, its surface etched with swirling wave motifs. Beneath the armor hangs a flowing robe of deep blue cloth, reminiscent of the sea's endless depths. Salt has dulled its shine, but it still carries the dignity of those who serve Abyssor."
	icon_state = "abyssal_robe"
	item_state = "abyssal_robe"
	smeltresult = /obj/item/ingot/bronze

/obj/item/clothing/armor/brigandine/abyssor/Initialize()
	. = ..()
	AddComponent(/datum/component/item_equipped_movement_rustle, custom_sounds = SFX_PLATE_COAT_STEP)


/obj/item/clothing/armor/brigandine/captain
	name = "captain's brigandine"
	desc = "A coat with plates specifically tailored and forged for the captain of Vanderlin."
	icon_state = "capplate"
	icon = 'icons/roguetown/clothing/special/captain.dmi'
	mob_overlay_icon = 'icons/roguetown/clothing/special/onmob/captain.dmi'
	sleeved = 'icons/roguetown/clothing/special/onmob/captain.dmi'
	detail_tag = "_detail"
	detail_color = CLOTHING_BERRY_BLUE
	blocksound = SOFTHIT
	equip_delay_self = 4 SECONDS
	unequip_delay_self = 4 SECONDS
	anvilrepair = /datum/skill/craft/armorsmithing
	melt_amount = 75
	melting_material = /datum/material/steel
	sellprice = VALUE_BRIGANDINE
	clothing_flags = CANT_SLEEP_IN
	armor_class = AC_HEAVY
	armor = ARMOR_PLATE_BAD
	body_parts_covered = COVERAGE_ALL_BUT_LEGS
	max_integrity = INTEGRITY_STRONGEST
	prevent_crits = ALL_EXCEPT_BLUNT
	item_weight = 7 * STEEL_MULTIPLIER
	uses_lord_coloring = LORD_PRIMARY
	stand_speed_reduction = 1.15

/obj/item/clothing/armor/brigandine/captain/Initialize()
	. = ..()
	AddComponent(/datum/component/item_equipped_movement_rustle, custom_sounds = SFX_PLATE_COAT_STEP)

//................ Coat of Plate ............... //
/obj/item/clothing/armor/brigandine/coatplates
	name = "coat of plates"
	desc = "A Zalad leather coat with steel scales woven with miniscule threads of adamantine, \
			ensuring the wearer an optimal defence with forgiving breathability and mobility."
	icon_state = "coat_of_plates"
	blocksound = PLATEHIT
	sellprice = VALUE_SNOWFLAKE_STEEL
	armor = ARMOR_PLATE_BAD
	// add armor plate bad from defines
	stand_speed_reduction = 1.05

	max_integrity = INTEGRITY_STRONG

/obj/item/clothing/shirt/vampire
	slot_flags = ITEM_SLOT_SHIRT|ITEM_SLOT_ARMOR
	name = "regal silks"
	desc = ""
	body_parts_covered = CHEST|GROIN|LEGS|VITALS
	prevent_crits = list(BCLASS_BITE, BCLASS_TWIST)
	icon_state = "vrobe"
	item_state = "vrobe"
	r_sleeve_status = SLEEVE_NORMAL
	l_sleeve_status = SLEEVE_NORMAL


/obj/item/clothing/armor/brigandine/light
	slot_flags = ITEM_SLOT_ARMOR
	name = "lightweight brigandine"
	desc = "A light riveted coat with plates concealed inside an exterior fabric. Susceptible to daggers being shoved into your ribs."
	icon_state = "light_brigandine"
	blocksound = SOFTHIT
	body_parts_covered = COVERAGE_TORSO
	armor = ARMOR_LEATHER_STUDDED
	max_integrity = ARMOR_INT_CHEST_PLATE_BRIGANDINE
	smeltresult = /obj/item/ingot/iron
	equip_delay_self = 40
	armor_class = AC_LIGHT//steel version of the studded leather armor now
	w_class = WEIGHT_CLASS_BULKY
