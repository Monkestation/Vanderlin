/obj/item/clothing/armor/plate
	name = "steel half-plate"
	desc = "Steel plate armor with shoulder guards. An incomplete, bulky set of excellent armor."
	icon_state = "halfplate"
	anvilrepair = /datum/skill/craft/armorsmithing
	melt_amount = 75
	melting_material = /datum/material/steel
	equip_delay_self = 4 SECONDS
	unequip_delay_self = 4 SECONDS
	equip_sound = 'sound/foley/equip/equip_armor_plate.ogg'
	pickup_sound = "rustle"
	sellprice = VALUE_STEEL_ARMOR
	clothing_flags = CANT_SLEEP_IN
	//Plate doesn't protect a lot against blunt
	armor_class = AC_HEAVY
	armor = ARMOR_PLATE
	body_parts_covered = COVERAGE_ALL_BUT_LEGS //Has shoulder guards, and nothing else to suggest leg protection
	prevent_crits = ALL_EXCEPT_BLUNT
	max_integrity = INTEGRITY_STRONGEST
	stand_speed_reduction = 1.2

/obj/item/clothing/armor/plate/Initialize()
	. = ..()
	AddComponent(/datum/component/item_equipped_movement_rustle, custom_sounds = SFX_PLATE_STEP)

/obj/item/clothing/armor/plate/iron
	name = "iron half-plate"
	desc = "Iron plate armor with shoulder guards. An incomplete, bulky set of good armor."
	icon_state = "ihalfplate"
	item_state = "ihalfplate"
	smeltresult = /obj/item/ingot/iron
	sellprice = VALUE_IRON_ARMOR
	armor = ARMOR_PLATE_BAD
	max_integrity = INTEGRITY_STRONG

/obj/item/clothing/armor/plate/vampire
	name = "ancient plate"
	desc = "An ornate, ceremonial plate of considerable age."
	icon_state = "vplate"

	armor = ARMOR_PLATE_GOOD
	prevent_crits = ALL_CRITICAL_HITS_VAMP

//................ Full Plate Armor ............... //
/obj/item/clothing/armor/plate/full
	name = "plate armor"
	desc = "Full steel plate. Leg protecting tassets, groin cup, armored vambraces."
	icon_state = "plate"
	item_state = "plate"
	equip_delay_self = 8 SECONDS
	unequip_delay_self = 7 SECONDS
	sellprice = VALUE_FULL_PLATE

	armor = ARMOR_PLATE
	body_parts_covered = COVERAGE_FULL
	item_weight = 12 * STEEL_MULTIPLIER

/obj/item/clothing/armor/plate/full/iron
	name = "iron plate armor"
	desc = "Full iron plate. Leg protecting tassets, groin cup, armored vambraces."
	icon_state = "iplate"
	item_state = "iplate"
	sellprice = VALUE_IRON_ARMOR*2
	smeltresult = /obj/item/ingot/iron

	armor = ARMOR_PLATE_BAD
	max_integrity = INTEGRITY_STRONG
	item_weight = 12 * IRON_MULTIPLIER

//................ Rusted Half-plate ............... //
/obj/item/clothing/armor/plate/rust
	name = "rusted half-plate"
	desc = "Old glory, old defeats, most of the rust comes from damp and not the blood of previous wearers, one would hope."
	icon = 'icons/roguetown/clothing/special/rust_armor.dmi'
	mob_overlay_icon = 'icons/roguetown/clothing/special/onmob/rust_armor.dmi'
	sleeved = 'icons/roguetown/clothing/special/onmob/rust_armor.dmi'
	icon_state = "rustplate"
	item_state = "rustplate"
	smeltresult = /obj/item/ingot/iron
	sellprice = VALUE_IRON_ARMOR/2
	armor = ARMOR_PLATE_BAD
	max_integrity = INTEGRITY_STANDARD
	item_weight = 12 * IRON_MULTIPLIER


/obj/item/clothing/armor/plate/blkknight
	name = "blacksteel plate"
	desc = "A chestplate forged from blacksteel with shoulder guards, combining strength and agility."
	body_parts_covered = COVERAGE_ALL_BUT_LEGS
	armor_class = AC_MEDIUM
	icon_state = "bkarmor"
	icon = 'icons/roguetown/clothing/special/blkknight.dmi'
	mob_overlay_icon = 'icons/roguetown/clothing/special/onmob/blkknight.dmi'
	sleeved = 'icons/roguetown/clothing/special/onmob/blkknight.dmi'
	anvilrepair = /datum/skill/craft/blacksmithing
	smeltresult = /obj/item/ingot/blacksteel
	item_weight = 12 * BLACKSTEEL_MULTIPLIER
	sellprice = VALUE_SILVER_ITEM * 6
	stand_speed_reduction = 1.05

//................ Deccorated Half-plate ............... //

/obj/item/clothing/armor/plate/decorated
	name = "decorated halfplate"
	desc = "A halfplate decorated with a gold ornament on the chestplate. A status symbol that doesn't lose out on practicality. "
	icon_state = "halfplate_decorated"
	icon = 'icons/roguetown/clothing/special/decorated_armor.dmi'
	mob_overlay_icon = 'icons/roguetown/clothing/special/onmob/decorated_armor.dmi'
	sleeved = 'icons/roguetown/clothing/special/onmob/decorated_armor.dmi'
	sellprice = VALUE_LUXURY_THING

/obj/item/clothing/armor/plate/decorated/corset
	name = "decorated halfplate with corset"
	desc = "A halfplate decorated with a gold ornament on the chestplate and a fine silk corset. More for decoration then actual use."
	icon_state = "halfplate_decorated_corset"

//................ Zizo Armor ...............//

/obj/item/clothing/armor/plate/full/zizo
	name = "darksteel fullplate"
	desc = "Full plate. Called forth from the edge of what should be known. In Her name."
	icon_state = "zizoplate"
	icon = 'icons/roguetown/clothing/special/evilarmor.dmi'
	mob_overlay_icon = 'icons/roguetown/clothing/special/onmob/evilarmor.dmi'
	sleeved = 'icons/roguetown/clothing/special/onmob/evilarmor.dmi'
	sellprice = 0 // Incredibly evil Zizoid armor, this should be burnt, nobody wants this

//................ Matthios Armor ...............//

/obj/item/clothing/armor/plate/full/matthios
	name = "gilded fullplate"
	desc = "Full plate. Tales told of men in armor such as this stealing many riches, or lives."
	icon_state = "matthiosarmor"
	icon = 'icons/roguetown/clothing/special/evilarmor.dmi'
	mob_overlay_icon = 'icons/roguetown/clothing/special/onmob/evilarmor.dmi'
	sleeved = 'icons/roguetown/clothing/special/onmob/evilarmor.dmi'
	sellprice = 0 // See above comment

//.............. Graggar Armor .................//

/obj/item/clothing/armor/plate/full/graggar
	name = "vicious full-plate"
	desc = "A sinister set full plate. Untold violence stirs from within."
	icon_state = "graggarplate"
	icon = 'icons/roguetown/clothing/special/evilarmor.dmi'
	mob_overlay_icon = 'icons/roguetown/clothing/special/onmob/evilarmor.dmi'
	sleeved = 'icons/roguetown/clothing/special/onmob/evilarmor.dmi'
	sellprice = 0 // See above comment

//.............. Silver Armor .................//

/obj/item/clothing/armor/plate/full/silver
	name = "silver fullplate"
	desc = "A finely forged set of full silver plate, with long tassets protecting the legs."
	icon_state = "silverarmor"
	allowed_ages = ALL_AGES_LIST //placeholder until younglings have onmob sprites for this item
	armor = ARMOR_PLATE_SILVER
	smeltresult = /obj/item/ingot/silver
	item_weight = 12 * SILVER_MULTIPLIER
	sellprice = VALUE_SILVER_ITEM * 3

/obj/item/clothing/armor/plate/full/silver/Initialize(mapload)
	. = ..()
	enchant(/datum/enchantment/silver)

/obj/item/clothing/armor/plate/fluted
	name = "fluted half-plate"
	desc = "An ornate steel cuirass, fitted with tassets and pauldrons for additional coverage. This lightweight deviation of 'plate armor' is favored by cuirassiers all across Psydonia, alongside fledging barons who've - up until now - waged their fiercest battles upon a chamberpot."
	icon_state = "ornatehalfplate"

	equip_delay_self = 6 SECONDS
	unequip_delay_self = 6 SECONDS

	max_integrity = ARMOR_INT_CHEST_PLATE_STEEL
	body_parts_covered = COVERAGE_FULL // Less durability than proper plate, more expensive to manufacture, and accurate to the sprite.

/obj/item/clothing/armor/plate/fluted/ornate
	name = "psydonian half-plate"
	desc = "A sturdily made fluted half-plate armour-set, complete with pauldrons and shoulder-guards. \
			Favored by both the Oratorium Throni Vacui and the Order of the Silver Psycross. It smells of the madness of an enduring God."
	icon_state = "ornatehalfplate"

	max_integrity = 400
	melt_amount = 150
	melting_material = /datum/material/silver
	armor = ARMOR_PLATE // overall worse because of the endurance buff //Changed to Plate armor


/obj/item/clothing/armor/plate/fluted/ornate/ordinator
	name = "inquisitorial ordinator's plate"
	desc = "A relic that is said to have survived the early sieges of Grenzelhoft, refurbished and repurposed to slay the arch-enemy in the name of Psydon. <br> A fluted cuirass that has been reinforced with thick padding and an additional shoulder piece. You will endure."
	icon_state = "ordinatorplate"


/datum/status_effect/buff/psydonic_endurance
	id = "psydonic_endurance"
	alert_type = /atom/movable/screen/alert/status_effect/buff/psydonic_endurance
	effectedstats = list(STATKEY_CON = 1,STATKEY_END = 1)

/datum/status_effect/buff/psydonic_endurance/on_apply()
	. = ..()
	if(HAS_TRAIT(owner, TRAIT_MEDIUMARMOR) && !HAS_TRAIT(owner, TRAIT_HEAVYARMOR))
		ADD_TRAIT(owner, TRAIT_HEAVYARMOR, src)

/datum/status_effect/buff/psydonic_endurance/on_remove()
	. = ..()
	REMOVE_TRAIT(owner, TRAIT_HEAVYARMOR, src)

/atom/movable/screen/alert/status_effect/buff/psydonic_endurance
	name = "Psydonic Endurance"
	desc = "I am protected by blessed Psydonian plate armor."
	icon_state = "buff"
