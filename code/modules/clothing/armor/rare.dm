/obj/item/clothing/armor/rare
	name = "rare armor template"
	icon = 'icons/roguetown/clothing/Racial_Armour.dmi'
	mob_overlay_icon = 'icons/roguetown/clothing/onmob/onmob_racial.dmi'
	sleeved = 'icons/roguetown/clothing/onmob/onmob_racial.dmi'
	sleevetype = null
	anvilrepair = /datum/skill/craft/armorsmithing
	melt_amount = 75
	melting_material = /datum/material/steel
	equip_delay_self = 4 SECONDS
	unequip_delay_self = 4 SECONDS
	sellprice = VALUE_SNOWFLAKE_STEEL
	clothing_flags = CANT_SLEEP_IN

	armor_class = AC_HEAVY
	armor = ARMOR_PLATE_GOOD
	body_parts_covered = COVERAGE_ALL_BUT_LEGS
	prevent_crits = ALL_EXCEPT_BLUNT
	max_integrity = INTEGRITY_STRONGEST
	abstract_type = /obj/item/clothing/armor/rare

/obj/item/clothing/armor/rare/Initialize()
	. = ..()
	AddComponent(/datum/component/squeak, list('sound/foley/footsteps/armor/fullplate (1).ogg',\
												'sound/foley/footsteps/armor/fullplate (2).ogg',\
												'sound/foley/footsteps/armor/fullplate (3).ogg'), 80, falloff_exponent = 20)

/obj/item/clothing/armor/rare/elfplate
	name = "dark elf plate"
	desc = "A fine suit of sleek, moulded dark elf metal. Its interlocking nature and light weight allow for increased maneuverability."
	icon_state = "elfchest"
	allowed_race = RACES_PLAYER_ELF_ALL
	equip_delay_self = 2 SECONDS
	unequip_delay_self = 2 SECONDS

	armor_class = AC_MEDIUM // Elven craft, also a cuirass
	body_parts_covered = COVERAGE_VEST
	item_weight = 12 * STEEL_MULTIPLIER

/obj/item/clothing/armor/rare/elfplate/welfplate
	name = "elvish plate"
	desc = "A suit of steel interwoven, through honed elven technique, with hardened bark plates."
	icon_state = "welfchest"
	item_weight = 12 * STEEL_MULTIPLIER

/obj/item/clothing/armor/rare/dwarfplate
	name = "dwarvish plate"
	desc = "Plate armor made out of the sturdiest, finest dwarvish metal armor. It's as heavy and durable as it gets."
	icon_state = "dwarfchest"
	allowed_race = list(SPEC_ID_DWARF)
	item_weight = 12 * STEEL_MULTIPLIER
	stand_speed_reduction = 1.2

/obj/item/clothing/armor/rare/grenzelplate
	name = "grenzelhoftian plate regalia"
	desc = "Engraved on this masterwork of humen metallurgy lies \"Thrice Fingered, Thrice Betrayed, Thrice Pronged\" alongside the symbol of Psydon in its neck guard. No one is certain what the third betrayal is meant to signify, yet Samantha's poetry is clear."
	icon_state = "human_swordchest"
	allowed_race = list(SPEC_ID_HUMEN, SPEC_ID_AASIMAR)
	allowed_sex = list(MALE)
	item_weight = 12 * STEEL_MULTIPLIER
	stand_speed_reduction = 1.2

/obj/item/clothing/armor/rare/zaladplate
	name = "kataphractoe scaleskin"
	desc = "Steel scales woven into armor with miniscule threads of adamantine, \
			ensuring the wearer optimal defence with forgiving breathability. \
			The sigil of the Zaladin Kataphractoe is embezeled at the throat guard."
	icon_state = "human_spearchest"
	allowed_race = list(SPEC_ID_HUMEN)
	allowed_sex = list(MALE)
	item_weight = 12 * STEEL_MULTIPLIER

// Aasimar hoplite armor, a very rare armor indeed
/obj/item/clothing/armor/rare/hoplite
	name = "ancient plate armor"
	desc = "A battered set of bronze plate armor. Intricate runes and carvings once adorned the pieces, but most have faded with age."
	icon = 'icons/roguetown/clothing/armor.dmi'
	mob_overlay_icon = 'icons/roguetown/clothing/onmob/armor.dmi'
	sleeved = 'icons/roguetown/clothing/onmob/helpers/sleeves_armor.dmi'
	icon_state = "aasimarplate"
	allowed_race = list(SPEC_ID_AASIMAR)
	smeltresult = /obj/item/ingot/bronze
	sellprice = VALUE_SNOWFLAKE_STEEL+BONUS_VALUE_MODEST // It has great value to historical collectors
	stand_speed_reduction = 1.2

	body_parts_covered = COVERAGE_ALL_BUT_ARMS
	item_weight = 7 * STEEL_MULTIPLIER
