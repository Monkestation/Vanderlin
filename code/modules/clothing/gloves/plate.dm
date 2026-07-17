
/obj/item/clothing/gloves/plate
	name = "plate gauntlets"
	desc = "Plated gauntlets made out of steel. Offers the best protection against melee attacks."
	icon_state = "gauntlets"
	blocksound = PLATEHIT
	equip_delay_self = 25
	unequip_delay_self = 25
	body_parts_covered = ARMS|HANDS
	blade_dulling = DULLING_BASH
	equip_sound = 'sound/foley/equip/equip_armor_plate.ogg'
	pickup_sound = "rustle"
	break_sound = 'sound/foley/breaksound.ogg'
	drop_sound = 'sound/foley/dropsound/armor_drop.ogg'
	anvilrepair = /datum/attribute/skill/craft/armor_repair
	sewrepair = null
	smeltresult = /obj/item/ingot/iron //no 1 to 1 conversion

	armor_class = AC_HEAVY
	armor = ARMOR_PLATE
	prevent_crits = ALL_EXCEPT_STAB
	max_integrity = INTEGRITY_STRONGEST

	grid_width = 64
	grid_height = 32
	item_weight = 1.65 KILOGRAMS

	material_category = ARMOR_MAT_PLATE

/obj/item/clothing/gloves/plate/iron
	name = "iron plate gauntlets"
	desc = "Plated gauntlets made out of iron. Offers good protection against melee attacks."
	icon_state = "igauntlets"
	sellprice = VALUE_IRON_ARMOR/2
	armor = ARMOR_PLATE_BAD
	max_integrity = INTEGRITY_STRONG

/obj/item/clothing/gloves/plate/iron/banded
	name = "banded iron gauntlets"
	desc = "A pair of leather gloves layered under a fur wrap with an iron plate hastily tightened together on both ends. It's primarily worn in the cold north, where armor has to sometimes be cobbled together due to logistical shortages."
	icon_state = "bandedgloves"
	item_state = "bandedgloves"

/obj/item/clothing/gloves/plate/rust
	name = "rusted riveted gauntlets"
	desc = "Riveted gauntlets made out of iron. They're covered in rust.. at least the glove liner is good still."
	icon = 'icons/roguetown/clothing/special/rust_armor.dmi'
	mob_overlay_icon = 'icons/roguetown/clothing/special/onmob/rust_armor.dmi'
	sleeved = 'icons/roguetown/clothing/special/onmob/rust_armor.dmi'
	icon_state = "rustgloves"
	item_state = "rustgloves"
	smeltresult = /obj/item/ingot/iron
	sellprice = VALUE_IRON_ARMOR/2
	armor = ARMOR_PLATE_BAD
	max_integrity = INTEGRITY_STANDARD

/obj/item/clothing/gloves/plate/blk
	name = "blacksteel gauntlets"
	desc = "Gauntlets of blacksteel, offering unmatched protection for the hands."
	icon_state = "bkgloves"
	icon = 'icons/roguetown/clothing/special/blkknight.dmi'
	mob_overlay_icon = 'icons/roguetown/clothing/special/onmob/blkknight.dmi'
	sleeved = 'icons/roguetown/clothing/special/onmob/blkknight.dmi'
	anvilrepair = /datum/attribute/skill/craft/blacksmithing
	smeltresult = /obj/item/ingot/blacksteel
	armor_class = AC_MEDIUM
	armor = ARMOR_PLATE_GOOD
	item_weight = 1.65 KILOGRAMS
	sellprice = VALUE_SILVER_ITEM * 2

/obj/item/clothing/gloves/plate/silver
	name = "silver gauntlets"
	desc = "Finely forged gauntlets made out of silver."
	icon_state = "silvergloves"
	armor = ARMOR_PLATE_SILVER
	smeltresult = /obj/item/ingot/silver
	item_weight = 2.94 KILOGRAMS
	sellprice = VALUE_SILVER_ITEM

/obj/item/clothing/gloves/plate/silver/Initialize(mapload)
	. = ..()
	enchant(/datum/enchantment/silver)

	//............... Evil Gloves ............... //

/obj/item/clothing/gloves/plate/zizo
	name = "darksteel gauntlets"
	desc = "darksteel plate gauntlets. Called forth from the edge of what should be known. In Her name."
	icon_state = "zizogauntlets"
	icon = 'icons/roguetown/clothing/special/evilarmor.dmi'
	mob_overlay_icon = 'icons/roguetown/clothing/special/onmob/evilarmor.dmi'
	sleeved = 'icons/roguetown/clothing/special/onmob/evilarmor.dmi'
	sellprice = 0 // Incredibly evil Zizoid armor, this should be burnt, nobody wants this

/obj/item/clothing/gloves/plate/matthios
	name = "gilded gauntlets"
	desc = "Shimmering plate gauntlets. Many riches have been taken with these, and just as many lives."
	icon_state = "matthiosgloves"
	icon = 'icons/roguetown/clothing/special/evilarmor.dmi'
	mob_overlay_icon = 'icons/roguetown/clothing/special/onmob/evilarmor.dmi'
	sleeved = 'icons/roguetown/clothing/special/onmob/evilarmor.dmi'
	sellprice = 0 // See above comment

/obj/item/clothing/gloves/plate/graggar
	name = "vicious gauntlets"
	desc = "Plate gauntlets that reek of death. Many lives have been taken with these."
	icon_state = "graggarplategloves"
	icon = 'icons/roguetown/clothing/special/evilarmor.dmi'
	mob_overlay_icon = 'icons/roguetown/clothing/special/onmob/evilarmor.dmi'
	sleeved = 'icons/roguetown/clothing/special/onmob/evilarmor.dmi'
	sellprice = 0 // See above comment

/obj/item/clothing/gloves/plate/graggar/heavy
	name = "vicious plated gauntlets"
	desc = "Steel plated gauntlets overlaid by an ornamental imagery of fractured bone and entrails. The violet smears; a tether to the life that once was - and now, a stinging reminder of what could've been."
	icon_state = "graggarplategloves_heavy"
	sleeved = 'icons/roguetown/clothing/onmob/gloves.dmi'
	icon = 'icons/roguetown/clothing/gloves.dmi'
	mob_overlay_icon = 'icons/roguetown/clothing/onmob/gloves.dmi'

//............... Gronnic gloves ............... //
/obj/item/clothing/gloves/plate/iron/gronn
	name = "osslandic iron gauntlets"
	desc = "Tough iron gauntlets, simple and protective in design. A single punch is said to leave a dozen bruises."
	icon_state = "gronnplategloves"
	icon = 'icons/roguetown/clothing/special/gronn.dmi'
	mob_overlay_icon = 'icons/roguetown/clothing/special/onmob/gronn.dmi'
	sleeved = 'icons/roguetown/clothing/special/onmob/gronn.dmi'

/obj/item/clothing/gloves/plate/kote
	name = "jjajeungna gauntlets"
	desc = "A set of reinforced Blackmeadow gauntlets. Difficult to do much other than fight in, but not entirely arresting."
	icon_state = "kazengungauntlets"
	item_state = "kazengungauntlets"
	body_parts_covered = HANDS|ARMS
	detail_tag = "_detail"
	detail_color = CLOTHING_ASH_GREY

/obj/item/clothing/gloves/plate/kote/attack_hand_secondary(mob/user, list/modifiers)
	. = ..()
	var/choice = tgui_input_list(user, "Choose a color.", "Uniform colors", GLOB.noble_dyes)
	if(!choice)
		return
	detail_color = GLOB.noble_dyes[choice]
	update_appearance(UPDATE_ICON)

//............... Cadwyn gloves ............... //
/obj/item/clothing/gloves/plate/cadwyn
	name = "cadwyn gauntlets"
	desc = "Metal gauntlets wrapped in the chains the Order is named for. Let no bite or claw reach you."
	icon_state = "cadwyngauntlets"
