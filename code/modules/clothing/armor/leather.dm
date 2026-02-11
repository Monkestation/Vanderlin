/obj/item/clothing/armor/leather
	name = "leather armor"
	desc = "A light armor typically made out of boiled leather. Offers slight protection from most weapons."
	icon_state = "leather"
	resistance_flags = FLAMMABLE
	blade_dulling = DULLING_BASHCHOP
	blocksound = SOFTHIT
	equip_sound = 'sound/foley/equip/cloak_equip.ogg'
	pickup_sound = 'sound/foley/equip/cloak_take_off.ogg'
	break_sound = 'sound/foley/cloth_rip.ogg'
	drop_sound = 'sound/foley/dropsound/cloth_drop.ogg'
	sewrepair = TRUE
	smeltresult = /obj/item/fertilizer/ash
	sellprice = VALUE_LEATHER_ARMOR

	armor_class = AC_LIGHT
	armor = ARMOR_LEATHER_BAD
	body_parts_covered = COVERAGE_TORSO
	prevent_crits = ALL_EXCEPT_CHOP_AND_STAB
	max_integrity = INTEGRITY_STANDARD
	salvage_result = /obj/item/natural/hide/cured
	item_weight = 3.2

//THE ARMOUR VALUES OF ADVANCED AND MASTERWORK ARMOUR ARE INTENDED
//KEEP THIS IN MIND

/obj/item/clothing/armor/leather/advanced
	name = "hardened leather armor"
	desc = "Sturdy, durable, flexible. Will keep you alive."
	max_integrity = INTEGRITY_STANDARD + 50
	body_parts_covered = CHEST|GROIN|VITALS|LEGS|ARMS
	prevent_crits = list(BCLASS_CUT, BCLASS_BLUNT, BCLASS_TWIST)
	armor = list("blunt" = 75, "slash" = 60, "stab" = 30, "piercing" = 10, "fire" = 0, "acid" = 0)

/obj/item/clothing/armor/leather/masterwork
	name = "masterwork leather armor"
	desc = "This leather armor is a craftsmanship marvel. Made with the finest leather. Strong, nimble, reliable."
	max_integrity = INTEGRITY_STANDARD + 100
	prevent_crits = list(BCLASS_CUT, BCLASS_BLUNT, BCLASS_TWIST, BCLASS_CHOP) //we're adding chop here!
	armor = list("blunt" = 100, "slash" = 70, "stab" = 40, "piercing" = 10, "fire" = 0, "acid" = 0)

/obj/item/clothing/armor/leather/masterwork/Initialize()
	. = ..()
	filters += filter(type="drop_shadow", x=0, y=0, size=0.5, offset=1, color=rgb(218, 165, 32))

//................ Hide Armor ............... //
/obj/item/clothing/armor/leather/hide
	name = "hide armor"
	desc = "A leather armor with additional internal padding of creacher fur. Offers slightly higher integrity and comfort."
	icon_state = "hidearmor"
	sellprice = VALUE_LEATHER_ARMOR_FUR

	armor = ARMOR_LEATHER
	salvage_result = /obj/item/natural/hide/cured

/obj/item/clothing/armor/leather/hide/steppe
	name = "steppe hide armor"
	desc = "Worn by riders of the steppe, this leather armor is padded with beast fur for warmth and comfort"
	icon_state = "hatangafur"
	sellprice = VALUE_LEATHER_ARMOR_FUR

	armor = ARMOR_LEATHER_GOOD
	body_parts_covered = COVERAGE_FULL
	max_integrity = INTEGRITY_STRONG
	item_weight = 6.7

//................ Splint Mail ............... //
/obj/item/clothing/armor/leather/splint
	name = "splint armor"
	desc = "The smell of a leather coat, with pieces of recycled metal from old breastplates or cooking utensils riveted to the inside."
	icon_state = "splint"
	sellprice = VALUE_LEATHER_ARMOR_PLUS

	armor = ARMOR_LEATHER_GOOD
	prevent_crits = ALL_EXCEPT_STAB
	max_integrity = INTEGRITY_STRONG
	item_weight = 6.7

//................ Leather Vest ............... //	- has no sleeves.  - can be worn in armor OR shirt slot
/obj/item/clothing/armor/leather/vest
	slot_flags = ITEM_SLOT_ARMOR|ITEM_SLOT_SHIRT
	name = "leather vest"
	desc = "Obviously no sleeves, won't really protect much but it's at least padded enough to be an armor, and can be worn against the skin snugly."
	icon_state = "vest"
	color = CLOTHING_BARK_BROWN
	blade_dulling = DULLING_BASHCHOP
	blocksound = SOFTHIT
	sewrepair = TRUE
	sleevetype = null
	sleeved = null

	armor = ARMOR_LEATHER_BAD
	body_parts_covered = COVERAGE_VEST
	prevent_crits = CUT_AND_MINOR_CRITS
	salvage_result = /obj/item/natural/hide/cured
	item_weight = 2.2

/obj/item/clothing/armor/leather/vest/colored
	misc_flags = CRAFTING_TEST_EXCLUDE

/obj/item/clothing/armor/leather/vest/colored/random/Initialize()
	color = pick(CLOTHING_SOOT_BLACK, CLOTHING_BARK_BROWN, CLOTHING_FOREST_GREEN)
	return ..()

//................ Butchers Vest ............... //
/obj/item/clothing/armor/leather/vest/colored/butcher
	name = "butchers vest"
	icon_state = "leathervest"
	color = "#d69c87" // custom coloring
	item_weight = 1.8

//................ Other Vests ............... //
/obj/item/clothing/armor/leather/vest/colored/butler
	color = CLOTHING_BLOOD_RED
	uses_lord_coloring = LORD_PRIMARY

/obj/item/clothing/armor/leather/vest/colored/black
	color = CLOTHING_SOOT_BLACK

/obj/item/clothing/armor/leather/vest/colored/innkeep // repath to correct padded vest some day
	name = "padded vest"
	desc = "Dyed green, belongs to the owner of the Drunken Saiga inn."
	icon_state = "striped"
	color = "#638b45"

/obj/item/clothing/armor/leather/vest/winterjacket
	name = "winter jacket"
	desc = "The most elegant of furs and vivid of royal dyes combined together into a most classy jacket."
	icon_state = "winterjacket"
	detail_tag = "_detail"
	color = CLOTHING_WHITE
	detail_color = CLOTHING_DARK_INK
	uses_lord_coloring = LORD_PRIMARY

//................ Jacket ............... //	- Has a small storage space
/obj/item/clothing/armor/leather/jacket
	name = "tanned jacket"
	icon_state = "leatherjacketo"
	desc = "A heavy leather jacket with wooden buttons, favored by workers who can afford it."

	body_parts_covered = COVERAGE_SHIRT
	item_weight = 2.2
	pocket_storage_component_path = /datum/component/storage/concrete/grid/cloak

/obj/item/clothing/armor/leather/jacket/dropped(mob/living/carbon/human/user)
	..()
	var/datum/component/storage/STR = GetComponent(/datum/component/storage)
	if(STR)
		var/list/things = STR.contents()
		for(var/obj/item/I in things)
			STR.remove_from_storage(I, get_turf(src))

/obj/item/clothing/armor/leather/jacket/artijacket
	name = "artificer jacket"
	icon_state = "artijacket"
	desc = "A thick leather jacket adorned with fur and cog decals. The height of Heartfelt fashion."

/obj/item/clothing/armor/leather/jacket/artijacket/porter
	name = "leather jacket"
	desc = "A thick leather jacket adorned with fur."
	misc_flags = CRAFTING_TEST_EXCLUDE

/obj/item/clothing/armor/leather/jacket/gatemaster_jacket
	name = "gatemaster's coat"
	desc = "A thick cloth padded coat specialty made for the gatemaster."
	icon = 'icons/roguetown/clothing/special/gatemaster.dmi'
	mob_overlay_icon = 'icons/roguetown/clothing/special/onmob/gatemaster.dmi'
	icon_state = "master_coat"
	blocksound = SOFTHIT
	slot_flags = ITEM_SLOT_ARMOR
	armor = ARMOR_MAILLE_IRON
	body_parts_covered = COVERAGE_ALL_BUT_LEGS
	salvage_result = /obj/item/natural/cloth

/obj/item/clothing/armor/leather/jacket/gatemaster_jacket/armored
	name = "gatemaster's coat"
	desc = "A thick cloth padded coat specialty made for the gatemaster."
	icon_state = "master_coat_cuirass"
	blocksound = PLATEHIT
	armor = ARMOR_MAILLE_GOOD

//................ Sea Jacket ............... //
/obj/item/clothing/armor/leather/jacket/sea
	slot_flags = ITEM_SLOT_ARMOR
	name = "sea jacket"
	desc = "A sturdy jacket worn by daring seafarers. The leather it's made from has been tanned by the salt of Abyssor's seas."
	icon_state = "sailorvest"
	sleevetype = "shirt"

	armor = ARMOR_LEATHER
	body_parts_covered = COVERAGE_VEST

//................ Silk Coat ............... //
/obj/item/clothing/armor/leather/jacket/silk_coat
	name = "silk coat"
	desc = "An expertly padded coat made from the finest silks. Long may live the nobility that dons it."
	icon_state = "bliaut"
	sleevetype = "shirt"
	sellprice = VALUE_LEATHER_ARMOR_LORD

	body_parts_covered = COVERAGE_ALL_BUT_ARMS
	prevent_crits = CUT_AND_MINOR_CRITS

/obj/item/clothing/armor/leather/jacket/silk_coat/Initialize()
	color = pick(CLOTHING_PLUM_PURPLE, CLOTHING_WHITE, CLOTHING_BLOOD_RED)
	return ..()

//................ Silk Jacket ............... //
/obj/item/clothing/armor/leather/jacket/apothecary
	name = "silk jacket"
	icon_state = "nightman"
	desc = "Displaying wealth while keeping your guts safe from blades with thick leather pads underneath."
	sellprice = VALUE_LEATHER_ARMOR_LORD

	body_parts_covered = COVERAGE_SHIRT

//................ Silk Jacket ............... //

/obj/item/clothing/armor/leather/jacket/tailcoat
	name = "tailcoat"
	desc = "A finely-sewn tailcoat often worn by those on the brink of the upper echelons of Astratan caste."
	icon_state = "butlercoat"
	item_state = "butlercoat"
	detail_tag = "_detail"
	sleeved = 'icons/roguetown/clothing/onmob/helpers/sleeves_maids.dmi'
	detail_color = CLOTHING_DARK_INK
	slot_flags = ITEM_SLOT_ARMOR
	armor = ARMOR_PADDED
	allowed_ages = ALL_AGES_LIST

/obj/item/clothing/armor/leather/jacket/tailcoat/lord
	misc_flags = CRAFTING_TEST_EXCLUDE
	uses_lord_coloring = LORD_SECONDARY

//................ Hand´s Coat ............... //
/obj/item/clothing/armor/leather/jacket/hand
	name = "noble coat"
	icon_state = "handcoat"
	desc = "A quality silken coat, discretely lined with a thin metal plate on the inside to protect its affluent wearer."
	sellprice = VALUE_LEATHER_ARMOR_LORD

	body_parts_covered = COVERAGE_ALL_BUT_ARMS

/obj/item/clothing/armor/leather/jacket/handjacket
	name = "noble jacket"
	icon_state = "handcoat"
	icon = 'icons/roguetown/clothing/special/hand.dmi'
	mob_overlay_icon = 'icons/roguetown/clothing/special/onmob/hand.dmi'
	sleeved = 'icons/roguetown/clothing/special/onmob/hand.dmi'
	detail_tag = "_detail"
	detail_color = CLOTHING_BERRY_BLUE
	body_parts_covered = COVERAGE_SHIRT
	uses_lord_coloring = LORD_PRIMARY

/obj/item/clothing/armor/leather/jacket/courtphysician
	name = "sanguine coat"
	desc = "A padded coat made of a leather, perhaps this may keep the bloodstains away."
	icon_state = "doccoat"
	item_state = "doccoat"
	icon = 'icons/roguetown/clothing/courtphys.dmi'
	sleeved = 'icons/roguetown/clothing/onmob/helpers/sleeves_courtphys.dmi'
	mob_overlay_icon = 'icons/roguetown/clothing/onmob/courtphys.dmi'
	detail_tag = "_detail"
	boobed = FALSE
	uses_lord_coloring = LORD_PRIMARY
	alternate_worn_layer = 19

/obj/item/clothing/armor/leather/jacket/courtphysician/female
	name = "sanguine jacket"
	desc = "An elegant jacket made of silk and padded with leather on the inside. It would be a shame to dirty this, but it is inevitable."
	icon_state = "docjacket"
	item_state = "docjacket"
	icon = 'icons/roguetown/clothing/courtphys.dmi'
	sleeved = 'icons/roguetown/clothing/onmob/helpers/sleeves_courtphys.dmi'
	mob_overlay_icon = 'icons/roguetown/clothing/onmob/courtphys.dmi'
	detail_tag = "_detail"
	boobed = FALSE
	uses_lord_coloring = LORD_PRIMARY
	alternate_worn_layer = 19

/obj/item/clothing/armor/leather/jacket/leathercoat
	name = "leather coat"
	desc = "A tan and purple leather coat."
	icon_state = "leathercoat"
	icon = 'icons/roguetown/clothing/leathercoat.dmi'
	mob_overlay_icon = 'icons/roguetown/clothing/onmob/leathercoat.dmi'
	sleeved = 'icons/roguetown/clothing/onmob/leathercoat.dmi'
	boobed = TRUE
	armor = ARMOR_LEATHER
	body_parts_covered = COVERAGE_ALL_BUT_LEGS

/obj/item/clothing/armor/leather/jacket/leathercoat/confessor
	name = "confessional coat"
	desc = "A sturdy raincoat draped atop of a tightly-fastened boiled leather cuirass. The Ordo Venatari trainees often fashion little pieces of memorabilia and stitch it into the lower pockets of the coat to remind the confessors that their cause is virtuous, and that they mustn’t lose sight of what matters."
	icon_state = "confessorcoat"
	item_state = "confessorcoat"
	icon = 'icons/roguetown/clothing/armor.dmi'
	mob_overlay_icon = 'icons/roguetown/clothing/onmob/armor.dmi'
	body_parts_covered = COVERAGE_FULL
	sleeved = 'icons/roguetown/clothing/onmob/helpers/sleeves_armor.dmi'
	armor = ARMOR_LEATHER
	prevent_crits = list(BCLASS_CUT, BCLASS_STAB, BCLASS_BLUNT, BCLASS_CHOP, BCLASS_SMASH)
	max_integrity = 250

/obj/item/clothing/armor/leather/jacket/leathercoat/black
	name = "black leather coat"
	desc = "A black and purple leather coat."
	icon_state = "bleathercoat"
	icon = 'icons/roguetown/clothing/leathercoat.dmi'
	mob_overlay_icon = 'icons/roguetown/clothing/onmob/leathercoat.dmi'
	sleeved = 'icons/roguetown/clothing/onmob/leathercoat.dmi'
	boobed = TRUE
	armor = ARMOR_LEATHER
	body_parts_covered = COVERAGE_ALL_BUT_LEGS

/obj/item/clothing/armor/leather/jacket/leathercoat/duelcoat
	name = "black leather coat"
	desc = "A stylish coat worn by the Duelists of Valoria. Light and flexible, it doesn't impede the complex movements they are known for, Seems to be well-padded."
	icon_state = "bwleathercoat"
	boobed = TRUE
	armor = ARMOR_LEATHER_GOOD
	body_parts_covered = COVERAGE_ALL_BUT_LEGS
	prevent_crits = list(BCLASS_CUT, BCLASS_TWIST, BCLASS_STAB)

/obj/item/clothing/armor/leather/jacket/leathercoat/renegade
	name = "renegade's coat"
	desc = "An insulated leather coat with capelets. It protects you well from the elements, a useful thing for those who like to wait in ambush."
	icon_state = "renegadecoat"

/obj/item/clothing/armor/leather/jacket/leathercoat/colored
	misc_flags = CRAFTING_TEST_EXCLUDE

/obj/item/clothing/armor/leather/jacket/leathercoat/colored/wretchrenegade
	name = "renegade's coat"
	desc = "An insulated leather coat with capelets. It protects you well from the elements, a useful thing for those who like to wait in ambush."
	color = CLOTHING_ASH_GREY

/obj/item/clothing/armor/leather/studded/psyaltrist
	name = "cuir-bouilli armor"
	desc = "Treated, water-boiled and composite-layered leather armor of fine Grenzelhoftian make."
	icon_state = "cuirbouilli"
	item_state = "cuirbouilli"

/obj/item/clothing/armor/leather/heavy
	name = "hardened leather armor"
	desc = "A heavy steerhide jerkin with enough body to stand on its own. It forms a stiff, protective mantle \
	for its wearer, shielding from blows and weather alike."
	icon_state = "roguearmor_belt"
	item_state = "roguearmor_belt"
	armor = ARMOR_LEATHER_GOOD
	prevent_crits = list(BCLASS_CUT, BCLASS_STAB, BCLASS_BLUNT, BCLASS_CHOP, BCLASS_SMASH)
	max_integrity = ARMOR_INT_CHEST_LIGHT_MASTER
	sellprice = 20
