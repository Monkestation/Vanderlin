/obj/item/clothing/armor/gambeson
	slot_flags = ITEM_SLOT_ARMOR|ITEM_SLOT_SHIRT
	name = "gambeson"
	desc = "Thick quilted cloth in layers, good on its own or worn below metal as padding."
	icon_state = "gambeson"
	resistance_flags = FLAMMABLE
	blocksound = SOFTUNDERHIT
	blade_dulling = DULLING_BASHCHOP
	equip_sound = 'sound/foley/equip/cloak_equip.ogg'
	pickup_sound = 'sound/foley/equip/cloak_take_off.ogg'
	break_sound = 'sound/foley/cloth_rip.ogg'
	drop_sound = 'sound/foley/dropsound/cloth_drop.ogg'
	sewrepair = TRUE
//	nodismemsleeves = FALSE gambesson being ripped by hand to bandages makes no sense. OTOH it can go into shirt slot asnd its kinda fun so maybe?
	r_sleeve_status = SLEEVE_NOMOD
	l_sleeve_status = SLEEVE_NOMOD
	sellprice = VALUE_GAMBESSON

	armor_class = AC_LIGHT
	armor = ARMOR_PADDED
	body_parts_covered = COVERAGE_FULL
	prevent_crits = ALL_EXCEPT_CHOP_AND_STAB

/obj/item/clothing/armor/gambeson/light
	name = "light gambeson"
	desc = "Thin and the maker skimped on the padding, typically worn by the peasantry to give some protection against cold for the whole body."
	icon_state = "gambesonl"
	color = CLOTHING_LINEN
	sellprice = VALUE_LIGHT_GAMBESSON

	armor = ARMOR_PADDED_BAD
	prevent_crits = MINOR_CRITICALS

/obj/item/clothing/armor/gambeson/light/steppe
	name = "steppe robes"
	desc = "Loose wind resistant robes worn by nomads of the steppes, designed for comfort and protection in harsh climates."
	icon_state = "chargah"

/obj/item/clothing/armor/gambeson/light/colored
	misc_flags = CRAFTING_TEST_EXCLUDE

/obj/item/clothing/armor/gambeson/light/colored/black
	color = CLOTHING_SOOT_BLACK

/obj/item/clothing/armor/gambeson/heavy
	name = "padded gambeson"
	desc = "Thick, padded, this will help a little even against arrows. A wise man carried steel as well, but it will do in a pinch."
	icon_state = "gambesonp"
	sellprice = VALUE_HEAVY_GAMBESSON

	armor = ARMOR_PADDED_GOOD

/obj/item/clothing/armor/gambeson/heavy/colored
	misc_flags = CRAFTING_TEST_EXCLUDE

/obj/item/clothing/armor/gambeson/heavy/colored/dark
	color = CLOTHING_DARK_INK

/obj/item/clothing/armor/gambeson/heavy/lakkarijupon
	name = "robed jupon"
	desc = "A thick, quilted jupon with an iron heart protector. It's great for the southern desert's heat and northern tundra's cold."
	icon_state = "lakkarijupon"
	max_integrity = INTEGRITY_STRONG
	r_sleeve_status = SLEEVE_NORMAL
	l_sleeve_status = SLEEVE_NORMAL
	sewrepair = TRUE

	armor = ARMOR_PADDED_GOOD

/obj/item/clothing/armor/gambeson/apothecary
	name = "apothecary overcoat"
	desc = "An armoured overcoat that can take a few hits. Men have lost their lives for less."
	icon_state = "apothover"
	item_state = "apothover"

	armor = ARMOR_PADDED_GOOD

/obj/item/clothing/armor/gambeson/steward
	name = "steward tailcoat"
	desc = "A thick, pristine leather tailcoat adorned with polished bronze buttons."
	sleeved = 'icons/roguetown/clothing/special/onmob/steward.dmi'
	icon_state = "stewardtailcoat"
	item_state = "stewardtailcoat"
	armor = ARMOR_PADDED_GOOD
	icon = 'icons/roguetown/clothing/special/steward.dmi'
	mob_overlay_icon = 'icons/roguetown/clothing/special/onmob/steward.dmi'

//................ Padded Dress ............... //
/obj/item/clothing/armor/gambeson/heavy/dress
	name = "padded dress"
	desc = "Favored by the female nobility, to maintain both vitality and good taste while out hunting."
	icon_state = "armordress"
	allowed_race = SPECIES_BASE_BODY
	r_sleeve_status = SLEEVE_NORMAL
	l_sleeve_status = SLEEVE_NORMAL
	sellprice = VALUE_PADDED_DRESS

	body_parts_covered = COVERAGE_FULL

/obj/item/clothing/armor/gambeson/heavy/dress/alt
	icon_state = "armordressalt"

//................ Winter Dress ............... //
/obj/item/clothing/armor/gambeson/heavy/winterdress
	name = "winter dress"
	icon = 'icons/roguetown/clothing/shirts_royalty.dmi'
	mob_overlay_icon = 'icons/roguetown/clothing/onmob/shirts_royalty.dmi'
	desc = "A thick, padded, and comfortable dress to maintain both temperature and safety when leaving the keep."
	body_parts_covered = COVERAGE_FULL
	icon_state = "winterdress"
	sleeved = 'icons/roguetown/clothing/onmob/helpers/sleeves_shirts_royalty.dmi'
	boobed = TRUE
	detail_tag = "_detail"
	detail_color = CLOTHING_SOOT_BLACK
	r_sleeve_status = SLEEVE_NORMAL
	l_sleeve_status = SLEEVE_NORMAL
	slot_flags = ITEM_SLOT_ARMOR|ITEM_SLOT_SHIRT
	uses_lord_coloring = LORD_PRIMARY

//................ Arming Jacket ............... //
/obj/item/clothing/armor/gambeson/arming
	name = "arming jacket"
	desc = "Thick quilted cloth, a gambeson for the discerning knight. it is meant to be used under heavier armor."
	icon_state = "arming"
	sellprice = VALUE_GAMBESSON+BONUS_VALUE_MODEST

	body_parts_covered =  COVERAGE_ALL_BUT_LEGS

//................ Stalker Robe ............... //
/obj/item/clothing/armor/gambeson/shadowrobe
	name = "stalker robe"
	desc = "A robe-like gambeson of moth-eaten cloth and cheap purple dye. No self-respecting elf would be seen wearing this."
	mob_overlay_icon = 'icons/roguetown/clothing/newclothes/onmob/onmobdrip.dmi'
	sleeved = 'icons/roguetown/clothing/newclothes/onmob/sleeves_robes.dmi'
	icon_state = "shadowrobe"


//................ Striped Tunic ............... // - Light gambesson type
/obj/item/clothing/armor/gambeson/light/striped
	name = "striped tunic"
	desc = "A common tunic worn by just about anyone. Nothing special, but essential."
	icon_state = "striped"
	sleevetype = null
	sleeved = null
	nodismemsleeves = TRUE

	body_parts_covered = COVERAGE_VEST

/obj/item/clothing/armor/gambeson/light/striped/Initialize()
	color = pick(CLOTHING_SALMON, CLOTHING_BERRY_BLUE, CLOTHING_SPRING_GREEN, CLOTHING_PEAR_YELLOW)
	return ..()

/obj/item/clothing/armor/gambeson/heavy/inq
	name = "inquisitorial leather tunic"
	desc = "The finest leather tunic. Made to ENDURE, Made to Inquire, come heretic or hellfire."
	icon_state = "leathertunic"
	color = null
	prevent_crits = list(BCLASS_CUT, BCLASS_BLUNT, BCLASS_CHOP)
	armor = ARMOR_PADDED
	body_parts_covered = COVERAGE_ALL_BUT_LEGS
