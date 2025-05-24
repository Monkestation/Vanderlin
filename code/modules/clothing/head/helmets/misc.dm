/obj/item/clothing/head/helmet/nasal
	name = "nasal helmet"
	desc = "A steel nasal helmet, usually worn by the guards of any respectable fief."
	icon_state = "nasal"
	sellprice = VALUE_CHEAP_IRON_HELMET

	body_parts_covered = COVERAGE_NASAL
	max_integrity = INTEGRITY_STANDARD
	item_weight = 5.5 * IRON_MULTIPLIER

//................ Skull Cap ............... //
/obj/item/clothing/head/helmet/skullcap
	name = "skull cap"
	desc = "A humble iron helmet. The most standard and antiquated protection for one's head from harm."
	icon_state = "skullcap"
	sellprice = VALUE_CHEAP_IRON_HELMET

	max_integrity = INTEGRITY_POOR
	item_weight = 5.5 * IRON_MULTIPLIER

//............... Grenzelhoft Plume Hat ............... // - worn over a skullcap
/obj/item/clothing/head/helmet/skullcap/grenzelhoft
	name = "grenzelhoft plume hat"
	desc = "Slaying foul creachers or fair maidens: Grenzelhoft stands."
	icon_state = "grenzelhat"
	item_state = "grenzelhat"
	sleeved = 'icons/roguetown/clothing/onmob/helpers/stonekeep_merc.dmi'
	detail_tag = "_detail"
	dynamic_hair_suffix = ""
	colorgrenz = TRUE
	sellprice = VALUE_FANCY_HAT

/obj/item/clothing/head/helmet/skullcap/grenzelhoft/update_icon()
	cut_overlays()
	if(get_detail_tag())
		var/mutable_appearance/pic = mutable_appearance(icon(icon, "[icon_state][detail_tag]"))
		pic.appearance_flags = RESET_COLOR
		if(get_detail_color())
			pic.color = get_detail_color()
		add_overlay(pic)

//................ Cultist Hood ............... //
/obj/item/clothing/head/helmet/skullcap/cult
	name = "ominous hood"
	desc = "It echoes with ominous laughter. Worn over a skullcap"
	icon_state = "warlockhood"
	dynamic_hair_suffix = ""
	flags_inv = HIDEEARS|HIDEFACE|HIDEHAIR|HIDEFACIALHAIR

	body_parts_covered = NECK|HAIR|EARS|HEAD


//................ Horned Cap ............... //
/obj/item/clothing/head/helmet/horned
	name = "horned cap"
	desc = "A crude horned cap usually worn by brute barbarians to invoke fear unto their enemies."
	icon_state = "hornedcap"
	sellprice = VALUE_CHEAP_IRON_HELMET
	item_weight = 5.5 * IRON_MULTIPLIER

//................ Winged Cap ............... //
/obj/item/clothing/head/helmet/winged
	name = "winged cap"
	icon_state = "wingedcap"
	mob_overlay_icon = 'icons/roguetown/clothing/onmob/64x64/head.dmi'
	worn_x_dimension = 64
	worn_y_dimension = 64
	bloody_icon = 'icons/effects/blood64x64.dmi'
	bloody_icon_state = "helmetblood_big"
	item_weight = 5.5 * IRON_MULTIPLIER

//................ Kettle Helmet ............... //
/obj/item/clothing/head/helmet/kettle
	name = "kettle helmet"
	desc = "A lightweight steel helmet generally worn by crossbowmen and garrison archers."
	mob_overlay_icon = 'icons/roguetown/clothing/onmob/64x64/head.dmi'
	icon_state = "kettle"
	bloody_icon = 'icons/effects/blood64x64.dmi'
	bloody_icon_state = "helmetblood_big"
	worn_x_dimension = 64
	worn_y_dimension = 64
	flags_inv = HIDEEARS
	sellprice = VALUE_CHEAP_IRON_HELMET

	body_parts_covered = COVERAGE_HEAD
	item_weight = 5.5 * IRON_MULTIPLIER

//................ Kettle Helmet (Slitted)............... //
/obj/item/clothing/head/helmet/kettle/slit
	name = "kettle helmet"
	desc = "A lightweight steel helmet generally worn by crossbowmen and garrison archers. This one has eyeslits for the paranoid."
	icon_state = "slitkettle"
	flags_cover = HEADCOVERSEYES
	body_parts_covered = HEAD|HAIR|EARS|EYES


//................ Iron Pot Helmet ............... //
/obj/item/clothing/head/helmet/ironpot
	name = "pot helmet"
	desc = "Simple iron helmet with a noseguard, designs like those are outdated but they are simple to make in big numbers."
	icon_state = "ironpot"
	flags_inv = HIDEEARS
	sellprice = VALUE_IRON_HELMET

	body_parts_covered = COVERAGE_HEAD_NOSE
	item_weight = 5.5 * IRON_MULTIPLIER


//................ Copper Lamellar Cap ............... //
/obj/item/clothing/head/helmet/coppercap
	name = "lamellar cap"
	desc = "A heavy lamellar cap made out of copper, a primitive material with an effective design to keep the head safe"
	icon_state = "lamellar"
	flags_inv = HIDEEARS
	smeltresult = /obj/item/ingot/copper
	sellprice = VALUE_LEATHER_HELMET // until copper/new mats properly finished and integrated this is a stopgap

	armor = ARMOR_PADDED_GOOD
	body_parts_covered = COVERAGE_HEAD
	prevent_crits = ONLY_VITAL_ORGANS
	max_integrity = INTEGRITY_POOR
	item_weight = 5.5 * COPPER_MULTIPLIER

//............... Battle Nun ........................... (unique kit for the role, iron coif mechanically.)
/obj/item/clothing/head/helmet/battlenun
	name = "veil over coif"
	desc = "A gleaming coif of metal half-hidden by a black veil."
	icon_state = "battlenun"
	dynamic_hair_suffix = ""	// this hides all hair
	flags_inv = HIDEEARS|HIDEHAIR
	equip_sound = 'sound/foley/equip/cloak_equip.ogg'
	pickup_sound = 'sound/foley/equip/cloak_take_off.ogg'
	break_sound = 'sound/foley/cloth_rip.ogg'
	blocksound = CHAINHIT
	resistance_flags = FIRE_PROOF

	armor = ARMOR_MAILLE
	body_parts_covered = NECK|HAIR|EARS|HEAD
	prevent_crits = ALL_EXCEPT_BLUNT
	item_weight = 9 * IRON_MULTIPLIER


/*-------------\
| Steel Helmet |
\-------------*/

//................ Sallet ............... //
/obj/item/clothing/head/helmet/sallet
	name = "sallet"
	icon_state = "sallet"
	desc = "A simple steel helmet with no attachments. Helps protect the ears."
	flags_inv = HIDEEARS
	smeltresult = /obj/item/ingot/steel
	sellprice = VALUE_STEEL_HELMET

	armor =  ARMOR_PLATE
	body_parts_covered = COVERAGE_HEAD
	max_integrity = INTEGRITY_STRONG
	item_weight = 9 * STEEL_MULTIPLIER

//................ Elf Sallet ............... //
/obj/item/clothing/head/helmet/sallet/elven	// blackoak merc helmet
	desc = "A steel helmet with a thin gold plating designed for Elven woodland guardians."
	icon_state = "bascinet_novisor"
	color = COLOR_ASSEMBLY_GOLD
	sellprice = VALUE_STEEL_HELMET+BONUS_VALUE_MODEST

//	icon_state = "elven_barbute_winged"
//	item_state = "elven_barbute_winged"

//................ Zybantine Kulah Khud ............... //
/obj/item/clothing/head/helmet/sallet/zybantine // Unique Zybantu merc kit
	name = "kulah khud"
	desc = "Known as devil masks amongst the Western Kingdoms, these serve part decorative headpiece, part protective helmet."
	mob_overlay_icon = 'icons/roguetown/clothing/onmob/64x64/head.dmi'
	icon_state = "iranian"
	worn_x_dimension = 64
	worn_y_dimension = 64
	bloody_icon = 'icons/effects/blood64x64.dmi'
	bloody_icon_state = "helmetblood_big"

//................ Bascinet ............... //
/obj/item/clothing/head/helmet/bascinet
	name = "bascinet"
	icon_state = "bascinet_novisor"
	desc = "A simple steel bascinet without a visor. Makes up for what it lacks in protection in visibility."
	flags_inv = HIDEEARS
	smeltresult = /obj/item/ingot/steel
	sellprice = VALUE_STEEL_HELMET

	body_parts_covered = COVERAGE_HEAD
	max_integrity = INTEGRITY_STRONG
	item_weight = 6 * STEEL_MULTIPLIER




//......................................................................................................
/*----------------\
| Visored helmets |
\----------------*/

/obj/item/clothing/head/helmet/visored
	name = "parent visored helmet"
	desc = "If you're reading this, someone forgot to set an item description or spawned the wrong item. Yell at them."
	flags_inv = HIDEEARS|HIDEFACE|HIDEHAIR
	equip_sound = 'sound/foley/equip/equip_armor_plate.ogg'
	adjustable = CAN_CADJUST
	flags_cover = HEADCOVERSEYES | HEADCOVERSMOUTH
	block2add = FOV_BEHIND
	equip_delay_self = 3 SECONDS
	unequip_delay_self = 3 SECONDS
	smeltresult = /obj/item/ingot/steel // All visored helmets are made of steel
	sellprice = VALUE_STEEL_HELMET+BONUS_VALUE_TINY

	armor = ARMOR_PLATE
	body_parts_covered = FULL_HEAD
	max_integrity = INTEGRITY_STRONG
	prevent_crits = ALL_CRITICAL_HITS

/obj/item/clothing/head/helmet/visored/AdjustClothes(mob/user)
	if(loc == user)
		playsound(user, "sound/items/visor.ogg", 100, TRUE, -1)
		if(adjustable == CAN_CADJUST)
			adjustable = CADJUSTED
			icon_state = "[initial(icon_state)]_raised"
			body_parts_covered = COVERAGE_HEAD
			flags_inv = HIDEEARS
			flags_cover = null
			prevent_crits = list(BCLASS_CUT, BCLASS_CHOP, BCLASS_BLUNT) // Vulnerable to eye stabbing while visor is open
			block2add = null
			if(ishuman(user))
				var/mob/living/carbon/H = user
				H.update_inv_head()
		else if(adjustable == CADJUSTED)
			ResetAdjust(user)
			if(user)
				if(ishuman(user))
					var/mob/living/carbon/H = user
					H.update_inv_head()
		user.update_fov_angles()
	else // Failsafe.
		to_chat(user, "<span class='warning'>Wear the helmet on your head to open and close the visor.</span>")
		return

//............... Visored Sallet ............... //
/obj/item/clothing/head/helmet/visored/sallet
	name = "visored sallet"
	desc = "A steel helmet offering good overall protection. Its visor can be flipped over for higher visibility at the cost of eye protection."
	icon_state = "sallet_visor"
	item_weight = 6 * STEEL_MULTIPLIER

//............... Hounskull ............... //
/obj/item/clothing/head/helmet/visored/hounskull
	name = "hounskull" // "Pigface" is a modern term, hounskull is a c.1400 term.
	desc = "A bascinet with a mounted pivot to protect the face by deflecting blows on its conical surface, \
			highly favored by knights of great renown. Its visor can be flipped over for higher visibility \
			at the cost of eye protection."
	icon_state = "hounskull"
	emote_environment = 3

	armor = ARMOR_PLATE_GOOD
	item_weight = 7 * STEEL_MULTIPLIER

//............... Knights Helmet ............... //
/obj/item/clothing/head/helmet/visored/knight
	name = "knights helmet"
	desc = "A lightweight armet that protects dreams of chivalrous friendship, fair maidens to rescue, and glorious deeds of combat. Its visor can be flipped over for higher visibility at the cost of eye protection."
	mob_overlay_icon = 'icons/roguetown/clothing/onmob/64x64/head.dmi'
	icon_state = "knight"
	bloody_icon = 'icons/effects/blood64x64.dmi'
	bloody_icon_state = "helmetblood_big"
	worn_x_dimension = 64
	worn_y_dimension = 64

	emote_environment = 3
	item_weight = 5.6 * STEEL_MULTIPLIER

/obj/item/clothing/head/helmet/visored/knight/black
	color = CLOTHING_SOOT_BLACK

//................. Captain's Helmet .............. //
/obj/item/clothing/head/helmet/visored/captain
	name = "captain's helmet"
	desc = "An elegant barbute, fitted with the gold trim and polished metal of nobility."
	icon = 'icons/roguetown/clothing/special/captain.dmi'
	mob_overlay_icon = 'icons/roguetown/clothing/special/onmob/captain.dmi'
	icon_state = "capbarbute"
	item_weight = 13 * STEEL_MULTIPLIER

//................. Town Watch Helmet .............. //
/obj/item/clothing/head/helmet/townwatch
	name = "town watch helmet"
	desc = "An old archaic helmet of a symbol long forgotten."
	icon_state = "guardhelm"

	body_parts_covered = COVERAGE_HEAD_NOSE
	flags_inv = HIDEEARS|HIDEHAIR
	block2add = FOV_BEHIND
	max_integrity = INTEGRITY_STANDARD
	slot_flags = ITEM_SLOT_HEAD | ITEM_SLOT_HIP
	smeltresult = /obj/item/ingot/iron
	sellprice = VALUE_IRON_ARMOR_UNUSUAL
	item_weight = 6 * STEEL_MULTIPLIER

/obj/item/clothing/head/helmet/townwatch/alt
	name = "barred helmet"
	flags_inv = HIDEEARS|HIDEHAIR
	desc = "An old archaic helmet of a symbol long forgotten. The shape resembles the bars of a gate."
	icon_state = "gatehelm"

//................. Zizo Barbute .............. //

/obj/item/clothing/head/helmet/visored/zizo
	name = "darksteel barbute"
	desc = "A darksteel barbute. This one has an adjustable visor. Called forth from the edge of what should be known. In Her name."
	icon_state = "zizobarbute"
	icon = 'icons/roguetown/clothing/special/evilarmor.dmi'
	mob_overlay_icon = 'icons/roguetown/clothing/special/onmob/evilarmor.dmi'
	sellprice = 0 // Incredibly evil Zizoid armor, this should be burnt, nobody wants this
	item_weight = 5 * STEEL_MULTIPLIER

//............... Feldshers Cage ............... //
/obj/item/clothing/head/helmet/feld
	name = "feldsher's cage"
	desc = "To protect me from the maggets and creachers I treat."
	mob_overlay_icon = 'icons/roguetown/clothing/onmob/64x64/head.dmi'
	icon_state = "headcage"
	worn_x_dimension = 64
	worn_y_dimension = 64
	bloody_icon = 'icons/effects/blood64x64.dmi'
	bloody_icon_state = "helmetblood_big"

	body_parts_covered = FULL_HEAD
	prevent_crits = BLUNT_AND_MINOR_CRITS
	item_weight = 5.5 * STEEL_MULTIPLIER

/obj/item/clothing/head/helmet/blacksteel/bucket
	name = "Blacksteel Great Helm"
	desc = "A bucket helmet forged of durable blacksteel. None shall pass.."
	body_parts_covered = FULL_HEAD
	icon = 'icons/roguetown/clothing/special/blkknight.dmi'
	mob_overlay_icon = 'icons/roguetown/clothing/special/onmob/blkknight.dmi'
	icon_state = "bkhelm"
	item_state = "bkhelm"
	flags_inv = HIDEEARS|HIDEFACE
	flags_cover = HEADCOVERSEYES | HEADCOVERSMOUTH
	armor = list("blunt" = 90, "slash" = 100, "stab" = 80,  "piercing" = 100, "fire" = 0, "acid" = 0)
	prevent_crits = list(BCLASS_CUT, BCLASS_STAB, BCLASS_CHOP, BCLASS_BLUNT, BCLASS_SMASH, BCLASS_TWIST, BCLASS_PICK)
	block2add = FOV_RIGHT|FOV_LEFT
	max_integrity = 425
	anvilrepair = /datum/skill/craft/blacksmithing
	smeltresult = /obj/item/ingot/blacksteel
	item_weight = 6 * BLACKSTEEL_MULTIPLIER
