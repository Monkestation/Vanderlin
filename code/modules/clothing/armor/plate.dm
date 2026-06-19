/obj/item/clothing/armor/plate
	name = "steel half-plate"
	desc = "Steel plate armor with shoulder guards. An incomplete, bulky set of excellent armor."
	icon_state = "halfplate"
	anvilrepair = /datum/attribute/skill/craft/armor_repair
	smeltresult = /obj/item/ingot/steel_slag
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
	item_weight = 9 KILOGRAMS

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

/obj/item/clothing/armor/plate/iron/banded
	name = "banded iron armor"
	desc = "An iron chestplate, pauldrons and tassets worn over a fur vest and padded with heavy leathers. It's primarily worn in the cold north, where armor has to sometimes be cobbled together due to logistical shortages. It leaves the stomach exposed for maneuverability."
	max_integrity = ARMOR_INT_CHEST_PLATE_IRON + 25
	icon_state = "ibandedarmor"
	item_state = "ibandedarmor"
	armor_class = AC_HEAVY
	body_parts_covered = CHEST | ARMS | LEGS | GROIN

/obj/item/clothing/armor/heartfelt
	slot_flags = ITEM_SLOT_ARMOR
	name = "coat of armor"
	desc = "A lordly coat of armor."
	body_parts_covered = COVERAGE_ALL_BUT_LEGS
	icon_state = "heartfelt"
	item_state = "heartfelt"
	armor = ARMOR_PLATE
	allowed_sex = list(MALE, FEMALE)
	nodismemsleeves = TRUE
	blocking_behavior = null
	max_integrity = ARMOR_INT_CHEST_PLATE_STEEL
	anvilrepair = /datum/attribute/skill/craft/armor_repair
	melting_material = /datum/material/steel
	melt_amount = 375
	armor_class = AC_HEAVY

/obj/item/clothing/armor/heartfelt/hand
	slot_flags = ITEM_SLOT_ARMOR
	name = "coat of armor"
	desc = "A lordly coat of armor."
	body_parts_covered = COVERAGE_ALL_BUT_LEGS
	icon_state = "heartfelt_hand"
	item_state = "heartfelt_hand"

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
	item_weight = 17 KILOGRAMS


/obj/item/clothing/armor/plate/full/samsibsa
	name = "samsibsa scaleplate"
	desc = "A heavy set of armour worn by the kouken of distant Blackmeadow. As opposed to the plate armour utilized by most of Psydonia and the West, samsiba-cheolpan is made of thirty-four rows of composite scales, each an ultra-thin sheet of blacksteel gilded over steel. </br> It is an extremely common practice to engrave characters onto individual plates - such as LUCK, HONOR, or HEAVEN."
	icon_state = "kazengunheavy"
	item_state = "kazengunheavy"
	detail_tag = "_detail"
	color = null
	detail_color = CLOTHING_WHITE
	max_integrity = ARMOR_INT_CHEST_PLATE_STEEL - 50 //slightly worse
	detail_tag = "_detail"

/obj/item/clothing/armor/plate/full/samsibsa/attack_hand_secondary(mob/user, list/modifiers)
	. = ..()
	var/choice = tgui_input_list(user, "Choose a color.", "Uniform colors", GLOB.noble_dyes)
	if(!choice)
		return
	detail_color = GLOB.noble_dyes[choice]
	update_appearance(UPDATE_ICON)

/obj/item/clothing/armor/plate/full/iron
	name = "iron plate armor"
	desc = "Full iron plate. Leg protecting tassets, groin cup, armored vambraces."
	icon_state = "iplate"
	item_state = "iplate"
	sellprice = VALUE_IRON_ARMOR*2
	smeltresult = /obj/item/ingot/iron

	armor = ARMOR_PLATE_BAD
	max_integrity = INTEGRITY_STRONG
	item_weight = 17 KILOGRAMS

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
	item_weight = 8.75 KILOGRAMS

/obj/item/clothing/armor/plate/silver
	slot_flags = ITEM_SLOT_ARMOR
	name = "templar's half-plate"
	desc = "Noc's holy silver, one fifth. Steel, three fifths. Chosen Material, one fifth. The armor of the Templar, protector and warrior of the Ten's Faithful."
	body_parts_covered = COVERAGE_TORSO
	icon_state = "silverhalfplate"
	item_state = "silverhalfplate"
	armor = ARMOR_PLATE
	max_integrity = ARMOR_INT_CHEST_PLATE_STEEL
	allowed_sex = list(MALE, FEMALE)
	melting_material = /datum/material/steel
	melt_amount = 275
	armor_class = AC_MEDIUM


/obj/item/clothing/armor/plate/blkknight
	name = "blacksteel plate"
	desc = "A chestplate forged from blacksteel with shoulder guards, combining strength and agility."
	body_parts_covered = COVERAGE_ALL_BUT_LEGS
	armor_class = AC_MEDIUM
	icon_state = "bkarmor"
	icon = 'icons/roguetown/clothing/special/blkknight.dmi'
	mob_overlay_icon = 'icons/roguetown/clothing/special/onmob/blkknight.dmi'
	sleeved = 'icons/roguetown/clothing/special/onmob/blkknight.dmi'
	anvilrepair = /datum/attribute/skill/craft/blacksmithing
	smeltresult = /obj/item/ingot/blacksteel
	item_weight = 20.45 KILOGRAMS
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

/datum/attribute_modifier/full_bronze
	id = "Bronze Plate"
	attribute_list = list(
		STAT_CONSTITUTION = 1,
		STAT_SPEED = -1,
	)

/obj/item/clothing/armor/plate/full/bronze
	name = "bronze panoplic armor"
	desc = "What can only be described as an 'armored robe'; thick bronze plates, layered atop one-another and interlinked with strappings \
	to form an assembly of segmented plate armor. While overwhelmingly heavy and cumbersome, it is certain to weather any storm poised its way. \
	</br>Scholars oft-describe this suit as a 'panoply', purpose-made for the physiques of Psydonia's earliest Aasimari."
	icon_state = "bronzeplate"
	item_state = "bronzeplate"
	armor = ARMOR_PLATE_BAD
	max_integrity = ARMOR_INT_CHEST_MEDIUM_IRON + 100
	armor_class = AC_HEAVY
	melt_amount = 275
	melting_material = /datum/material/bronze
	var/bronzeplatecumbersome = FALSE

/obj/item/clothing/armor/plate/full/bronze/equipped(mob/living/carbon/human/user, slot)
	. = ..()
	if(slot == SLOT_ARMOR)
		to_chat(user, span_suicide("The panoply clatters into place, and I feel my shoulders slouch beneath its weight - yet even now, I feel sturdier than ever before.."))
		user.attributes?.add_attribute_modifier(/datum/attribute_modifier/full_bronze)
		bronzeplatecumbersome = TRUE
	return

/obj/item/clothing/armor/plate/full/bronze/dropped(mob/living/carbon/human/user)
	. = ..()
	if(bronzeplatecumbersome == TRUE)
		to_chat(user, span_hypnophrase("..and with a sigh of relief, the panoply's weight no longer burdens my shoulders."))
		user.attributes?.remove_attribute_modifier(/datum/attribute_modifier/full_bronze)
		bronzeplatecumbersome = FALSE
	return

/obj/item/clothing/armor/plate/full/bronze/get_mechanics_examine(mob/user)
	. = ..()
	. += span_info("Even with the necessary training, this suit of armor is difficult to maneuver in. Wearing the armor will slightly fortify your Constitution, at the cost of further reducing your Speed.")

/obj/item/clothing/armor/plate/full/bronze/alt
	name = "bronze panoplic assembly"
	icon_state = "bronzeplatealt"
	item_state = "bronzeplatealt"
	body_parts_covered = CHEST | VITALS | LEGS
	max_integrity = ARMOR_INT_CHEST_MEDIUM_IRON //Halfplate analogue. Still heavy as hell.


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
	item_weight = 22 KILOGRAMS
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
	effectedstats = list(STAT_CONSTITUTION = 1,STAT_ENDURANCE = 1)

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

//.............. Gronn Armor Sets .................//
/obj/item/clothing/armor/plate/iron/gronn
	name = "osslandic iron plate"
	desc = "A suit of solid iron plate, adorned with tassets and roundels. \
			The hunters of Ossland rarely used plate, but when they did, \
			it is said that they were after the most dangerous of prey: their enemies."
	icon = 'icons/roguetown/clothing/special/gronn.dmi'
	mob_overlay_icon = 'icons/roguetown/clothing/special/onmob/gronn.dmi'
	icon_state = "gronnplate"
	item_state = "gronnplate"
	boobed = FALSE
	body_parts_covered = COVERAGE_ALL_BUT_LEGS
	max_integrity = ARMOR_INT_CHEST_PLATE_STEEL
	smeltresult = /obj/item/ingot/iron
