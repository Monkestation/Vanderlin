/obj/item/clothing/head/helmet/nasal
	name = "nasal helmet"
	desc = "A steel nasal helmet, usually worn by the guards of any respectable fief."
	icon_state = "nasal"
	sellprice = VALUE_STEEL_SMALL_ITEM
	smeltresult = /obj/item/ingot/iron
	body_parts_covered = COVERAGE_NASAL
	max_integrity = INTEGRITY_STRONGEST
	item_weight = 2.3 KILOGRAMS

//................ Gallowglass ............... //

/obj/item/clothing/head/helmet/gallowglass
	name = "gallowglass helmet"
	desc = "Worn by proud fighters of remote clans."
	icon_state = "gallowglass"
	sellprice = VALUE_STEEL_SMALL_ITEM
	smeltresult = /obj/item/ingot/steel_slag
	max_integrity = INTEGRITY_STRONGEST
	item_weight = 2.5 KILOGRAMS

//................ Coppergate ............... //
/obj/item/clothing/head/helmet/coppergate
	name = "coppergate helmet"
	desc = "A typical style of helmet worn by Sea Elf pirates, this helmet comes with metal flaps that protects the cheeks."
	icon_state = "coppergate"
	sellprice = VALUE_STEEL_SMALL_ITEM
	smeltresult = /obj/item/ingot/steel_slag
	body_parts_covered = COVERAGE_NASAL
	max_integrity = INTEGRITY_STRONGEST
	item_weight = 3.12 KILOGRAMS

//................ Decorative Coppergate ............... //
/obj/item/clothing/head/helmet/decorativecoppergate
	name = "decorative coppergate helmet"
	desc = "Worn by proud Sea Elf clan leaders this decorative helmet design signifies wealth and authority."
	icon_state = "decorative_coppergate"
	sellprice = VALUE_STEEL_SMALL_ITEM+BONUS_VALUE_MODEST
	smeltresult = /obj/item/ingot/steel_slag
	body_parts_covered = COVERAGE_NASAL
	max_integrity = INTEGRITY_STRONGEST
	item_weight = 3.12 KILOGRAMS

//................ Skull Cap ............... //
/obj/item/clothing/head/helmet/skullcap
	name = "skull cap"
	desc = "A humble iron helmet. The most standard and antiquated protection for one's head from harm."
	icon_state = "skullcap"
	sellprice = VALUE_CHEAP_IRON_HELMET
	smeltresult = null
	melting_material = /datum/material/iron
	melt_amount = 75
	max_integrity = INTEGRITY_STRONG
	item_weight = 2.5 KILOGRAMS

//............... Grenzelhoft Plume Hat ............... // - worn over a skullcap
/obj/item/clothing/head/helmet/skullcap/grenzelhoft
	name = "grenzelhoft plume hat"
	desc = "Slaying foul creachers or fair maidens: Grenzelhoft stands. A stylish hat concealing an iron skullcap."
	icon_state = "grenzelhat"
	item_state = "grenzelhat"
	sleeved = 'icons/roguetown/clothing/onmob/helpers/stonekeep_merc.dmi'
	detail_tag = "_detail"
	detail_color = CLOTHING_RED_OCHRE
	dynamic_hair_suffix = ""
	colorgrenz = TRUE
	sellprice = VALUE_FANCY_HAT

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
	item_weight = 2.5 KILOGRAMS

//................ Winged Cap ............... //
/obj/item/clothing/head/helmet/winged
	name = "winged cap"
	icon_state = "wingedcap"
	mob_overlay_icon = 'icons/roguetown/clothing/onmob/64x64/head.dmi'
	worn_x_dimension = 64
	worn_y_dimension = 64
	bloody_icon = 'icons/effects/blood64x64.dmi'
	bloody_icon_state = "helmetblood_big"
	item_weight = 2.5 KILOGRAMS

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
	sellprice = VALUE_CHEAP_STEEL_HELMET
	max_integrity = INTEGRITY_STRONGEST
	smeltresult = null
	melting_material = /datum/material/steel
	melt_amount = 50
	body_parts_covered = COVERAGE_HEAD
	item_weight = 2.2 KILOGRAMS

/obj/item/clothing/head/helmet/kettle/jingasa
	name = "jingasa"
	desc = "A steel-reinforced conical hat with a decorative rim of fabric. It protects the head and ears as much as it shields the eyes from the sun."
	icon_state = "kazengunmedhelm"
	item_state = "kazengunmedhelm"
	detail_tag = "_detail"
	detail_color = "#FFFFFF"
	mob_overlay_icon = 'icons/roguetown/clothing/onmob/head.dmi'
	flags_inv = HIDEEARS|HIDEHAIR
	worn_x_dimension = 32
	worn_y_dimension = 32

/obj/item/clothing/head/helmet/kettle/iron
	name = "iron kettle helmet"
	desc = "A lightweight iron helmet generally worn by crossbowmen and garrison archers."
	icon_state = "ikettle"
	item_state = "ikettle"
	sellprice = VALUE_CHEAP_IRON_HELMET
	armor = ARMOR_SCALE
	max_integrity = INTEGRITY_STRONG
	item_weight = 2.2 KILOGRAMS
	smeltresult = null
	melting_material = /datum/material/iron
	melt_amount = 50

/obj/item/clothing/head/helmet/kettle/aalloy
	name = "decrepit kettle helmet"
	desc = "A frayed, bronze helmet which protects the top and sides of the head. Atop a resurrected levyman's scalp, it's a sign that forces-most-foul are soon to besiege; and atop a fleshless ballistaeman's skull, it's a sign that you should probably duck."
	icon_state = "ancientkettle"
	mob_overlay_icon = 'icons/roguetown/clothing/onmob/head.dmi'
	body_parts_covered = HEAD|HAIR|EARS
	material_category = ARMOR_MAT_PLATE
	anvilrepair = null
	worn_x_dimension = 32
	worn_y_dimension = 32

//................ Kettle Helmet (Slitted)............... //
/obj/item/clothing/head/helmet/kettle/slit
	name = "slitted kettle helmet"
	desc = "A lightweight steel helmet generally worn by crossbowmen and garrison archers. This one has eyeslits for the paranoid."
	icon_state = "slitkettle"
	flags_cover = HEADCOVERSEYES
	body_parts_covered = HEAD|HAIR|EARS|EYES

/obj/item/clothing/head/helmet/kettle/slit/iron
	name = "iron slitted kettle helmet"
	desc = "A lightweight iron helmet generally worn by crossbowmen and garrison archers. This one has eyeslits for the paranoid."
	icon_state = "islitkettle"
	item_state = "islitkettle"
	sellprice = VALUE_CHEAP_IRON_HELMET
	armor = ARMOR_SCALE
	max_integrity = INTEGRITY_STRONG
	item_weight = 2.2 KILOGRAMS
	smeltresult = /obj/item/ingot/iron
	melting_material = /datum/material/iron

//................ Iron Pot Helmet ............... //
/obj/item/clothing/head/helmet/ironpot
	name = "pot helmet"
	desc = "Simple iron helmet with a noseguard, designs like those are outdated but they are simple to make in big numbers."
	icon_state = "ironpot"
	flags_inv = HIDEEARS
	sellprice = VALUE_IRON_HELMET
	body_parts_covered = COVERAGE_HEAD_NOSE
	item_weight = 2.85 KILOGRAMS

/obj/item/clothing/head/helmet/ironpot/lakkariancap
	name = "embellished crowned cap"
	desc = "A crimson red iron cap decorated with gold trims and embellishments."
	icon_state = "lakkaricap"
	item_state = "lakkaricap"
	sellprice = 50
	flags_inv = null
	armor = ARMOR_SCALE
	anvilrepair = /datum/attribute/skill/craft/armor_repair
	body_parts_covered = COVERAGE_HEAD
	max_integrity = INTEGRITY_STRONG
	item_weight = 1.4 KILOGRAMS

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
	item_weight = 3.25 KILOGRAMS

//............... Battle Nun ........................... (unique kit for the role, iron coif mechanically.)
/obj/item/clothing/head/helmet/battlenun
	name = "veil over coif"
	desc = "A gleaming coif of iron metal half-hidden by a black veil."
	icon_state = "battlenun"
	dynamic_hair_suffix = ""	// this hides all hair
	flags_inv = HIDEEARS|HIDEHAIR
	equip_sound = 'sound/foley/equip/cloak_equip.ogg'
	pickup_sound = 'sound/foley/equip/cloak_take_off.ogg'
	break_sound = 'sound/foley/cloth_rip.ogg'
	blocksound = CHAINHIT
	resistance_flags = FIRE_PROOF

	armor = ARMOR_MAILLE_IRON
	body_parts_covered = NECK|HAIR|EARS|HEAD
	prevent_crits = ALL_EXCEPT_BLUNT
	item_weight = 1.56 KILOGRAMS

/obj/item/clothing/head/helmet/battlenun/steel
	name = "veil over coif"
	desc = "A gleaming coif of steel metal half-hidden by a black veil."
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
	item_weight = 1.56 KILOGRAMS


//................ Sallet ............... //
/obj/item/clothing/head/helmet/sallet
	name = "sallet"
	icon_state = "sallet"
	desc = "A simple steel helmet with no attachments. Helps protect the ears."
	flags_inv = HIDEEARS
	smeltresult = /obj/item/ingot/steel_slag
	sellprice = VALUE_STEEL_HELMET
	armor =  ARMOR_PLATE
	body_parts_covered = COVERAGE_HEAD
	max_integrity = INTEGRITY_STRONG
	item_weight = 3.1 KILOGRAMS

/obj/item/clothing/head/helmet/sallet/beastskull
	name = "beast skull"
	desc = "The skull of a horned beast, carved and fashioned into a helmet. An steel skull cap has been inserted on the inside."
	icon_state = "marauder_head"
	body_parts_covered = HEAD|EARS|HAIR
	max_integrity = INTEGRITY_STRONG + 50
	smeltresult = /obj/item/ingot/steel_slag
	mob_overlay_icon = 'icons/roguetown/clothing/onmob/64x64/head.dmi'
	worn_x_dimension = 64
	worn_y_dimension = 64
	bloody_icon = 'icons/effects/blood64x64.dmi'
	max_integrity = INTEGRITY_STRONG
	item_weight = 3.5 KILOGRAMS

/obj/item/clothing/head/helmet/sallet/iron
	name = "iron sallet"
	icon_state = "isallet"
	item_state = "isallet"
	desc = "A simple iron helmet with no attachments. Helps protect the ears."
	smeltresult = /obj/item/ingot/iron
	sellprice = VALUE_IRON_HELMET
	armor =  ARMOR_PLATE_BAD
	max_integrity = INTEGRITY_STRONG
	item_weight = 3.1 KILOGRAMS

/obj/item/clothing/head/helmet/sallet/iron/banded
	name = "banded iron helmet"
	desc = "A menacing horned half-face iron helmet worn primarily by mercenaries hailing from an unaligned conflict-ridden enclave near the borders of Ossland. \
	A helmet of this kind was notoriously worn by an unknown person said to kill the last Great Drakyn inhabiting the mountains of Hammerhold."
	max_integrity = ARMOR_INT_HELMET_HEAVY_IRON
	armor_class = AC_MEDIUM
	flags_inv = HIDEEARS|HIDEFACE
	flags_cover = HEADCOVERSEYES
	body_parts_covered = HEAD|EARS|HAIR|NOSE|EYES
	block2add = FOV_BEHIND
	icon_state = "ibandedhelm"
	item_state = "ibandedhelm"


//................ Elf Sallet ............... //
/obj/item/clothing/head/helmet/sallet/elven	// blackoak merc helmet
	desc = "A steel helmet with a thin gold plating designed for Elven woodland guardians."
	icon_state = "bascinet_novisor"
	color = COLOR_ASSEMBLY_GOLD
	sellprice = VALUE_STEEL_HELMET+BONUS_VALUE_MODEST

//	icon_state = "elven_barbute_winged"
//	item_state = "elven_barbute_winged"

//................ Zalad Kulah Khud ............... //
/obj/item/clothing/head/helmet/sallet/zalad // Unique Zaladin merc kit
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
	smeltresult = /obj/item/ingot/steel_slag
	sellprice = VALUE_STEEL_HELMET

	body_parts_covered = COVERAGE_HEAD
	max_integrity = INTEGRITY_STRONG
	item_weight = 3.25 KILOGRAMS

/obj/item/clothing/head/helmet/bascinet/steppe
	name = "steppe bascinet"
	icon_state = "shishak"
	desc = "A flat decorated steel bascinet with a spike at the top end."
	flags_inv = HIDEEARS|HIDEHAIR
	body_parts_covered = HEAD_NECK // built in coif

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
	smeltresult = /obj/item/ingot/steel_slag
	sellprice = VALUE_STEEL_HELMET+BONUS_VALUE_TINY
	armor = ARMOR_PLATE
	body_parts_covered = FULL_HEAD
	max_integrity = INTEGRITY_STRONG
	prevent_crits = ALL_CRITICAL_HITS
	abstract_type = /obj/item/clothing/head/helmet/visored
	var/raise_state = "_raised"

/obj/item/clothing/head/helmet/visored/AdjustClothes(mob/user)
	if(loc == user)
		playsound(user, "sound/items/visor.ogg", 100, TRUE, -1)
		if(adjustable == CAN_CADJUST)
			adjustable = CADJUSTED
			icon_state = "[initial(icon_state)][raise_state]"
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

/obj/item/clothing/head/helmet/visored/examine(mob/user)
	. = ..()
	. += span_notice("This helmet has a visor that can be raised and lowered. Interact with it while wearing it to adjust the visor, offering better protection at the cost of visibility.")

//............... Black Knight Helmet ............... //

/obj/item/clothing/head/helmet/visored/blkknight
	name = "blacksteel helmet"
	desc = "A helmet black as nite. Instills fear upon those that gaze upon it."
	icon_state = "bkhelm_visor"
	icon = 'icons/roguetown/clothing/special/blkknight.dmi'
	mob_overlay_icon = 'icons/roguetown/clothing/special/onmob/blkknight.dmi'
	armor_class = AC_MEDIUM
	armor = ARMOR_PLATE_GOOD
	item_weight = 6.4 KILOGRAMS
	sellprice = VALUE_SILVER_ITEM * 2

//............... Visored Sallet ............... //
/obj/item/clothing/head/helmet/visored/sallet
	name = "visored sallet"
	desc = "A steel helmet offering good overall protection. Its visor can be flipped over for higher visibility at the cost of eye protection."
	icon_state = "sallet_visor"
	item_weight = 3.25 KILOGRAMS

/obj/item/clothing/head/helmet/visored/sallet/iron
	name = "visored iron sallet"
	desc = "An iron helmet offering good overall protection. Its visor can be flipped over for higher visibility at the cost of eye protection."
	icon_state = "isallet_visor"
	item_state = "isallet_visor"
	item_weight = 3.25 KILOGRAMS
	smeltresult = /obj/item/ingot/iron
	sellprice = VALUE_IRON_HELMET+BONUS_VALUE_TINY
	armor = ARMOR_PLATE_BAD
	max_integrity = INTEGRITY_STRONG

//............... Bellow Sallet ............... //
/obj/item/clothing/head/helmet/visored/bellow
	name = "bellow sallet"
	desc = "An unorthodox approach of sallet design that includes a full face cover with holes for easier breathing."
	icon_state = "sallet_bellow"
	item_weight = 4.5 KILOGRAMS

//............... Hounskull ............... //
/obj/item/clothing/head/helmet/visored/hounskull
	name = "hounskull" // "Pigface" is a modern term, hounskull is a c.1400 term.
	desc = "A bascinet with a mounted pivot to protect the face by deflecting blows on its conical surface, \
			highly favored by knights of great renown. Its visor can be flipped over for higher visibility \
			at the cost of eye protection."
	icon_state = "hounskull"
	emote_environment = 3

	armor = ARMOR_PLATE_GOOD
	item_weight = 4.45 KILOGRAMS

//............... Knights Helmet ............... //
/obj/item/clothing/head/helmet/visored/knight
	name = "knights helmet"
	desc = "A lightweight steel armet that protects dreams of chivalrous friendship, fair maidens to rescue, and glorious deeds of combat. Its visor can be flipped over for higher visibility at the cost of eye protection."
	mob_overlay_icon = 'icons/roguetown/clothing/onmob/64x64/head.dmi'
	icon_state = "knight"
	bloody_icon = 'icons/effects/blood64x64.dmi'
	bloody_icon_state = "helmetblood_big"
	worn_x_dimension = 64
	worn_y_dimension = 64

	emote_environment = 3
	item_weight = 4.45 KILOGRAMS

/obj/item/clothing/head/helmet/visored/knight/owl
	name = "strigidae armet"
	desc = "An armet of distinct bird like design with a pronounced beak. \
		Close to the teachings of the moon himself, it shields the curious gaze of the one wearing it. \
		This one used to be in the hands of a pale elf and may be fitted with a great plume atop, to bear heraldic colors."
	icon_state = "armetowl"
	raise_state = "_t"

/obj/item/clothing/head/helmet/visored/knight/aalloy
	name = "decrepit bascinet"
	desc = "A chipped greathelm of frayed bronze. The fittings squeal with nauseous annoyance, whenever you move to lift its half-rusted visor up and down. Add a feather to show the colors of your family or allegiance."
	icon_state = "ancientknight"
	item_state = "ancientknight"
	max_integrity = ARMOR_INT_HELMET_HEAVY_DECREPIT
	material_category = ARMOR_MAT_PLATE
	anvilrepair = null
	worn_x_dimension = 64
	worn_y_dimension = 64
	mob_overlay_icon = 'icons/roguetown/clothing/onmob/64x64/head.dmi' //Uses the new 'greatplume + orle' system. If this glitches out, I made sure to include a fully-prepared 32x32 version - with details - in head.dmi.
	bloody_icon = 'icons/effects/blood64x64.dmi'
	raise_state = "_t"

/obj/item/clothing/head/helmet/visored/knight/blk
	color = CLOTHING_SOOT_BLACK

/obj/item/clothing/head/helmet/visored/knight/iron
	name = "iron knights helmet"
	desc = "A lightweight iron armet that protects dreams of chivalrous friendship, fair maidens to rescue, and glorious deeds of combat. Its visor can be flipped over for higher visibility at the cost of eye protection."
	icon_state = "iknight"

	item_weight = 4.45 KILOGRAMS
	smeltresult = /obj/item/ingot/iron
	sellprice = VALUE_IRON_HELMET+BONUS_VALUE_TINY

	armor = ARMOR_PLATE_BAD
	max_integrity = INTEGRITY_STRONG


/obj/item/clothing/head/helmet/visored/gold
	name = "golden knight's armet"
	desc = "A resplendant armet, masterfully forged from pure gold. Hexagrammic etchings of a holy sigil line its visor, and its interior is fitted with a besilked arming cap. Even in absolute darkness, the polished surface sparkles with imbued sunlight."
	icon_state = "goldknight"
	armor = ARMOR_HEAD_HELMET_VISOR //Renders its wearer completely invulnerable to damage. The caveat is, however..
	max_integrity = ARMOR_INT_HELMET_HEAVY_IRON // ..is that it's extraordinarily fragile. To note, this is lower than even Decrepit-tier armor.
	armor_class = AC_HEAVY //Ceremonial. Heavy is the head that bares the burden.
	anvilrepair = null
	melting_material = /datum/material/gold
	grid_height = 96 //Prevents 'armorstacking'. That, and it's like.. carrying a golden watermelon.
	grid_width = 96
	sellprice = 200
	worn_x_dimension = 64
	worn_y_dimension = 64
	mob_overlay_icon = 'icons/roguetown/clothing/onmob/64x64/head.dmi'
	bloody_icon = 'icons/effects/blood64x64.dmi'
	raise_state = "_t"
	item_weight = 5.6 KILOGRAMS

/obj/item/clothing/head/helmet/visored/gold/attackby(obj/item/W, mob/living/user, params)
	. = ..()
	if(!istype(W, /obj/item/natural/feather) || detail_tag)
		return
	var/choice = tgui_input_list(user, "Choose a color.", "Uniform colors", GLOB.noble_dyes)
	if(!choice)
		return
	user.visible_message(span_warning("[user] adds [W] to [src]."))
	qdel(W)
	detail_color = GLOB.noble_dyes[choice]
	detail_tag = "_detail"
	update_appearance(UPDATE_ICON)

/obj/item/clothing/head/helmet/visored/gold/king
	name = "royal golden armet"
	desc = "A resplendant armet, masterfully forged from pure gold. Hexagrammic etchings of a holy sigil line its visor, and its interior is fitted with a besilked arming cap. The dorpeled crown atop its brow invokes authority, be it misbegotten or endowed."
	icon_state = "goldknight_crown"
	sellprice = 300


//................. Royal Knight's helmet .............. //
/obj/item/clothing/head/helmet/visored/royalknight
	name = "royal knights helmet"
	desc = "A knightly armet that protects dreams of chivalry, fair maidens to rescue, and glorious feats of melee. Purpose made for the protector of the royal lineage. Its visor can be flipped over for higher visibility at the cost of eye protection."
	icon_state = "knightarmet"
	emote_environment = 3
	item_weight = 4.45 KILOGRAMS

//................. Captain's Helmet .............. //
/obj/item/clothing/head/helmet/visored/captain
	name = "captain's helmet"
	desc = "An elegant barbute, fitted with the gold trim and polished metal of nobility."
	icon = 'icons/roguetown/clothing/special/captain.dmi'
	mob_overlay_icon = 'icons/roguetown/clothing/special/onmob/captain.dmi'
	icon_state = "capbarbute"
	item_weight = 4.45 KILOGRAMS

//................. Town Watch Helmet .............. //

/obj/item/clothing/head/helmet/watchmen
	name = "town watchmen helmet"
	desc = "An old helmet of iron, offers great visibility and suits well."
	icon_state = "watchhelm"
	mob_overlay_icon = 'icons/roguetown/clothing/onmob/32x48/head.dmi'
	icon = 'icons/roguetown/clothing/watchmen_item.dmi' // TODO: DUMP INTO APPROPRIATE FILE IF PR WILL BE APROVED
	body_parts_covered = COVERAGE_HEAD
	flags_inv = HIDEEARS|HIDEHAIR
	max_integrity = INTEGRITY_STRONG
	slot_flags = ITEM_SLOT_HEAD | ITEM_SLOT_HIP
	smeltresult = /obj/item/ingot/iron
	sellprice = VALUE_IRON_ARMOR_UNUSUAL
	item_weight = 3.7 KILOGRAMS

/obj/item/clothing/head/helmet/watchmen/lt
	name = "town watch liutenant helmet"
	desc = "An old helmet of iron, offers great visibility and suits well. This one have a feather on top, informing everybody, that wearer is a leader of city watch."
	icon_state = "watchhelm_feather"
	detail_tag = "_detail"
	detail_color = CLOTHING_WHITE
	uses_lord_coloring = LORD_PRIMARY

// It will stay here to make sure nothing breaks
/obj/item/clothing/head/helmet/townwatch
	name = "old watch helmet"
	desc = "An old archaic helmet of a symbol long forgotten."
	icon_state = "guardhelm"

	body_parts_covered = COVERAGE_HEAD_NOSE
	flags_inv = HIDEEARS|HIDEHAIR
	block2add = FOV_BEHIND
	max_integrity = INTEGRITY_STRONG
	slot_flags = ITEM_SLOT_HEAD | ITEM_SLOT_HIP
	smeltresult = /obj/item/ingot/iron
	sellprice = VALUE_IRON_ARMOR_UNUSUAL
	item_weight = 3.2 KILOGRAMS

/obj/item/clothing/head/helmet/townwatch/alt
	icon_state = "gatehelm"

/obj/item/clothing/head/helmet/townwatch/gatemaster
	name = "barred helmet"
	flags_inv = HIDEEARS|HIDEHAIR
	desc = "An old archaic helmet of a symbol long forgotten, now owned by the Gatemaster. The shape resembles the bars of a gate."
	icon = 'icons/roguetown/clothing/special/gatemaster.dmi'
	mob_overlay_icon = 'icons/roguetown/clothing/special/onmob/gatemaster.dmi'
	icon_state = "master_helm"

/obj/item/clothing/head/helmet/townbarbute
	name = "town watchman barbute"
	desc = "An old helmet of iron, it has the colours of your lord, you fight for him."
	icon_state = "watchbuta"

	body_parts_covered = COVERAGE_HEAD_NOSE
	flags_inv = HIDEEARS|HIDEHAIR
	block2add = FOV_BEHIND
	max_integrity = INTEGRITY_STRONG
	slot_flags = ITEM_SLOT_HEAD | ITEM_SLOT_HIP
	smeltresult = /obj/item/ingot/iron
	sellprice = VALUE_IRON_ARMOR_UNUSUAL
	item_weight = 3.7 KILOGRAMS
	detail_tag = "_detail"
	detail_color = CLOTHING_PLUM_PURPLE
	uses_lord_coloring = LORD_PRIMARY
	misc_flags = CRAFTING_TEST_EXCLUDE

/obj/item/clothing/head/helmet/sargebarbute
	name = "elegant barbute"
	desc = "An elaborated helmet of steel, it has the colours of your lord and you are a leader in his defense."
	icon_state = "sargebuta"

	body_parts_covered = COVERAGE_HEAD_NOSE
	flags_inv = HIDEEARS|HIDEHAIR
	block2add = FOV_BEHIND
	max_integrity = INTEGRITY_STRONG//slighly more integrity
	slot_flags = ITEM_SLOT_HEAD | ITEM_SLOT_HIP
	smeltresult = /obj/item/ingot/iron
	sellprice = VALUE_IRON_ARMOR_UNUSUAL
	item_weight = 3.7 KILOGRAMS
	detail_tag = "_detail"
	detail_color = CLOTHING_PLUM_PURPLE
	uses_lord_coloring = LORD_PRIMARY
	misc_flags = CRAFTING_TEST_EXCLUDE

/obj/item/clothing/head/helmet/kettle/slit/atarms
	name = "royal slitted kettle"
	desc = "A lightweight steel helmet decorated for the royal men at arms, wear this piece with pride, triumph for your lord."
	mob_overlay_icon = 'icons/roguetown/clothing/onmob/head.dmi'
	bloody_icon = 'icons/effects/blood.dmi'
	bloody_icon_state = "helmetblood"
	worn_x_dimension = 32
	worn_y_dimension = 32
	icon_state = "atarmslit"
	flags_cover = HEADCOVERSEYES
	body_parts_covered = HEAD|HAIR|EARS|EYES
	detail_tag = "_detail"
	detail_color = CLOTHING_PLUM_PURPLE
	uses_lord_coloring = LORD_PRIMARY
	misc_flags = CRAFTING_TEST_EXCLUDE

//................. Zizo Barbute .............. //

/obj/item/clothing/head/helmet/visored/zizo
	name = "darksteel barbute"
	desc = "A darksteel barbute. This one has an adjustable visor. Called forth from the edge of what should be known. In Her name."
	icon_state = "zizobarbute"
	icon = 'icons/roguetown/clothing/special/evilarmor.dmi'
	mob_overlay_icon = 'icons/roguetown/clothing/special/onmob/evilarmor.dmi'
	sellprice = 0 // Incredibly evil Zizoid armor, this should be burnt, nobody wants this
	item_weight = 3.7 KILOGRAMS

//................. Silver Bascinet .............. //

/obj/item/clothing/head/helmet/visored/silver
	name = "silver bascinet"
	desc = "A finely forged silver bascinet, with adjustable visor to protect the face."
	icon_state = "silverbascinet"
	mob_overlay_icon = 'icons/roguetown/clothing/onmob/64x64/head.dmi'
	smeltresult = /obj/item/ingot/silver
	allowed_ages = ALL_AGES_LIST //placeholder until younglings have onmob sprites for this item
	armor = ARMOR_PLATE_SILVER
	sellprice = VALUE_SILVER_ARMOR
	item_weight = 6 KILOGRAMS
	worn_x_dimension = 64
	worn_y_dimension = 64

/obj/item/clothing/head/helmet/visored/silver/Initialize(mapload)
	. = ..()
	enchant(/datum/enchantment/silver)

/obj/item/clothing/head/helmet/visored/silver/armet
	name = "silver armet"
	desc = "A finely forged silver armet, with adjustable visor to protect the face."
	icon_state = "silverarmet"

/obj/item/clothing/head/helmet/visored/silver/armet/Initialize(mapload)
	. = ..()
	enchant(/datum/enchantment/silver)

//............... Feldshers Cage ............... //
/obj/item/clothing/head/helmet/feld
	name = "feldsher's cage"
	desc = "To protect me from the maggots and creachers I treat."
	mob_overlay_icon = 'icons/roguetown/clothing/onmob/64x64/head.dmi'
	icon_state = "headcage"
	worn_x_dimension = 64
	worn_y_dimension = 64
	bloody_icon = 'icons/effects/blood64x64.dmi'
	bloody_icon_state = "helmetblood_big"

	body_parts_covered = FULL_HEAD
	prevent_crits = BLUNT_AND_MINOR_CRITS
	item_weight = 1.3 KILOGRAMS

/obj/item/clothing/head/helmet/blacksteel
	abstract_type = /obj/item/clothing/head/helmet/blacksteel

/obj/item/clothing/head/helmet/blacksteel/bucket
	name = "Blacksteel Great Helm"
	desc = "A bucket helmet forged of durable blacksteel. None shall pass.."
	body_parts_covered = FULL_HEAD
	icon = 'icons/roguetown/clothing/special/blkknight.dmi'
	mob_overlay_icon = 'icons/roguetown/clothing/special/onmob/blkknight.dmi'
	icon_state = "bkhelm_visor"
	item_state = "bkhelm_visor"
	flags_inv = HIDEEARS|HIDEFACE
	flags_cover = HEADCOVERSEYES | HEADCOVERSMOUTH
	armor = list("blunt" = 90, "slash" = 100, "stab" = 80,  "piercing" = 100, "fire" = 0, "acid" = 0)
	prevent_crits = list(BCLASS_CUT, BCLASS_STAB, BCLASS_CHOP, BCLASS_BLUNT, BCLASS_SMASH, BCLASS_TWIST, BCLASS_PICK)
	block2add = FOV_RIGHT|FOV_LEFT
	max_integrity = 425
	anvilrepair = /datum/attribute/skill/craft/blacksmithing
	smeltresult = /obj/item/ingot/blacksteel
	item_weight = 4.5 KILOGRAMS

/obj/item/clothing/head/helmet/blacksteel/psythorns
	name = "crown of psydonian thorns"
	desc = "Thorns fashioned from pliable yet durable blacksteel - woven and interlinked, fashioned to be worn upon the head."
	body_parts_covered = HAIR | HEAD
	icon_state = "psybarbs"
	item_state = "psybarbs"
	prevent_crits = list(BCLASS_CUT, BCLASS_STAB, BCLASS_CHOP, BCLASS_BLUNT, BCLASS_SMASH, BCLASS_TWIST, BCLASS_PICK)
	blocksound = PLATEHIT
	resistance_flags = FIRE_PROOF
	anvilrepair = /datum/attribute/skill/craft/armor_repair
	sewrepair = null
	icon = 'icons/roguetown/clothing/wrists.dmi'
	mob_overlay_icon = 'icons/roguetown/clothing/onmob/head.dmi'
	alternate_worn_layer  = 8.9 //On top of helmet
	slot_flags = ITEM_SLOT_HEAD|ITEM_SLOT_MASK
	item_weight = 2.4 KILOGRAMS

/obj/item/clothing/head/helmet/blacksteel/psythorns/attack_self(mob/living/user)
	. = ..()
	user.visible_message(span_warning("[user] starts to reshape the [src]."))
	if(do_after(user, 4 SECONDS))
		var/obj/item/clothing/wrists/bracers/psythorns/P = new /obj/item/clothing/wrists/bracers/psythorns(get_turf(src.loc))
		if(user.is_holding(src))
			user.dropItemToGround(src)
			user.put_in_hands(P)
		var/obj/item/bodypart/arm = user.get_active_hand()
		arm?.bodypart_attacked_by(BCLASS_CUT, 25, modifiers = list(CRIT_MOD_CHANCE = CANT_CRIT))
		qdel(src)
	else
		user.visible_message(span_warning("[user] stops reshaping [src]."))
		return

/obj/item/clothing/head/helmet/bronze
	name = "bronze illyriahelm"
	desc = "A helmet of bronze, older-in-design than you could possibly imagine. Mounted to its crest is a decorative sigil that has \
	sparked scholarly debates for the better part of a millennium; is it a star, a vortex, or the Sun? </br>A notch behind the sigil \
	allows for the joint mounting of a plume. Nock a feather into it to show off your alliegence's colors."
	max_integrity = ARMOR_INT_HELMET_IRON - 25 //Close, but no cigar.
	material_category = ARMOR_MAT_PLATE
	body_parts_covered = HEAD|HAIR|EARS
	icon_state = "bronzehelmet"
	item_state = "bronzehelmet"
	worn_x_dimension = 64
	worn_y_dimension = 64
	mob_overlay_icon = 'icons/roguetown/clothing/onmob/64x64/head.dmi'
	bloody_icon = 'icons/effects/blood64x64.dmi'
	melting_material = /datum/material/bronze

/obj/item/clothing/head/helmet/bronze/attackby(obj/item/W, mob/living/user, params)
	. = ..()
	if(!istype(W, /obj/item/natural/feather) || detail_tag)
		return
	var/choice = tgui_input_list(user, "Choose a color.", "Uniform colors", GLOB.noble_dyes)
	if(!choice)
		return
	user.visible_message(span_warning("[user] adds [W] to [src]."))
	qdel(W)
	detail_color = GLOB.noble_dyes[choice]
	detail_tag = "_detail"
	update_appearance(UPDATE_ICON)

/obj/item/clothing/head/helmet/bronzegladiator
	name = "bronze murmillo"
	desc = "A bronze helmet that veils the wearer's face behind a perforated visor; a distant ancestor to both the sallet and sayovard, \
	providing excellent coverage while ensuring one doesn't suffocate on their own adrenal huffs. </br>Out of all actorial labors, none surpass \
	the reenactment of Ravox's duel against Graggar atop Ur-Syon's ruins - mythologized not as a tentacled star, but as a towering doppelganger-champion; \
	sculpted by the followers of evil to be the inverse to all who stood for justice and chivalry."
	icon_state = "bronzemurmillo"
	item_state = "bronzemurmillo"
	max_integrity = ARMOR_INT_HELMET_IRON - 100
	armor_class = AC_LIGHT
	material_category = ARMOR_MAT_PLATE
	body_parts_covered = FULL_HEAD

	melting_material = /datum/material/bronze

/obj/item/clothing/head/helmet/bronzegladiator/attackby(obj/item/W, mob/living/user, params)
	. = ..()
	if(!istype(W, /obj/item/natural/cloth) || detail_tag)
		return
	var/choice = tgui_input_list(user, "Choose a color.", "Uniform colors", GLOB.noble_dyes)
	if(!choice)
		return
	user.visible_message(span_warning("[user] adds [W] to [src]."))
	qdel(W)
	detail_color = GLOB.noble_dyes[choice]
	detail_tag = "_detail"
	update_appearance(UPDATE_ICON)

