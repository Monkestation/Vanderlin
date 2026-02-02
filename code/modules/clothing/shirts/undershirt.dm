/obj/item/clothing/shirt/undershirt
	name = "shirt"
	desc = ""
	icon_state = "undershirt"
	item_state = "undershirt"
	r_sleeve_status = SLEEVE_NORMAL
	l_sleeve_status = SLEEVE_NORMAL
	body_parts_covered = CHEST|ARMS|VITALS

/obj/item/clothing/shirt/undershirt/priest
	name = "undervestments"
	desc = ""
	icon_state = "priestunder"
	sleeved = 'icons/roguetown/clothing/onmob/helpers/sleeves_shirts.dmi'

/obj/item/clothing/shirt/undershirt/colored
	misc_flags = CRAFTING_TEST_EXCLUDE

/obj/item/clothing/shirt/undershirt/colored/uncolored
	color = CLOTHING_LINEN

/obj/item/clothing/shirt/undershirt/colored/black
	color = CLOTHING_SOOT_BLACK

/obj/item/clothing/shirt/undershirt/colored/lord
	desc = ""
	color = CLOTHING_BERRY_BLUE

/obj/item/clothing/shirt/undershirt/colored/blue
	color = CLOTHING_SKY_BLUE

/obj/item/clothing/shirt/undershirt/colored/red
	color = CLOTHING_RED_OCHRE

/obj/item/clothing/shirt/undershirt/colored/purple
	color = CLOTHING_PLUM_PURPLE

/obj/item/clothing/shirt/undershirt/colored/green
	color = CLOTHING_FOREST_GREEN

/obj/item/clothing/shirt/undershirt/colored/guard
	color = CLOTHING_PLUM_PURPLE
	uses_lord_coloring = LORD_PRIMARY

/obj/item/clothing/shirt/undershirt/colored/guardsecond
	color = CLOTHING_BLOOD_RED
	uses_lord_coloring = LORD_SECONDARY

/obj/item/clothing/shirt/undershirt/colored/random/Initialize()
	color = pick_assoc(GLOB.peasant_dyes)
	return ..()

/obj/item/clothing/shirt/undershirt/puritan
	name = "formal silks"
	icon_state = "puritan_shirt"
	allowed_race = SPECIES_BASE_BODY
	salvage_result = /obj/item/natural/silk

/obj/item/clothing/shirt/undershirt/artificer
	name = "heartfeltian suit"
	desc = "Typical fashion of the best Heartfelt engineers."
	icon_state = "artishirt"

/obj/item/clothing/shirt/undershirt/lowcut
	name = "low cut tunic"
	desc = "A tunic exposing much of the shoulders and neck. Shoulders?! How scandalous..."
	icon_state = "lowcut"

/obj/item/clothing/shirt/undershirt/fancy
	name = "fancy tunic"
	desc = "A button-down shirt woven from fine silks with a decorated front and cuffs."
	icon_state = "fancyshirt"
	icon = 'icons/roguetown/clothing/special/hand.dmi'
	sleeved = 'icons/roguetown/clothing/special/onmob/hand.dmi'
	mob_overlay_icon = 'icons/roguetown/clothing/special/onmob/hand.dmi'

/obj/item/clothing/shirt/undershirt/sailor
	icon_state = "sailorblues"

/obj/item/clothing/shirt/undershirt/sailor/red
	icon_state = "sailorreds"

/obj/item/clothing/shirt/undershirt/colored/vagrant
	r_sleeve_status = SLEEVE_TORN
	body_parts_covered = CHEST|ARM_LEFT|VITALS
	torn_sleeve_number = 1

/obj/item/clothing/shirt/undershirt/colored/vagrant/Initialize()
	color = pick(CLOTHING_MUD_BROWN, CLOTHING_OLD_LEATHER, CLOTHING_SPRING_GREEN, CLOTHING_BARK_BROWN, CLOTHING_CANVAS	)
	if(prob(50))
		r_sleeve_status = SLEEVE_NORMAL
		l_sleeve_status = SLEEVE_TORN
		body_parts_covered = CHEST|ARM_RIGHT|VITALS
	return ..()

/obj/item/clothing/shirt/undershirt/webs

	name = "webbed shirt"
	desc = "Exotic silk finely woven into.. this? Might as well be wearing a spiderweb."
	icon_state = "webs"
	item_state = "webs"
	r_sleeve_status = SLEEVE_NORMAL
	l_sleeve_status = SLEEVE_NORMAL
	body_parts_covered = CHEST|ARMS|VITALS
	color = null
	salvage_amount = 1
	salvage_result = /obj/item/natural/silk

/obj/item/clothing/shirt/undershirt/sash
	slot_flags = ITEM_SLOT_ARMOR|ITEM_SLOT_CLOAK
	name = "cloth sash"
	desc = "A simple cloth sash."
	icon_state = "sash"
	color = CLOTHING_LINEN

/obj/item/clothing/shirt/undershirt/sash/colored
	misc_flags = CRAFTING_TEST_EXCLUDE

/obj/item/clothing/shirt/undershirt/sash/colored/white
	color = CLOTHING_CHALK_WHITE

/obj/item/clothing/shirt/undershirt/sash/colored/blue
	color = CLOTHING_BERRY_BLUE

/obj/item/clothing/shirt/undershirt/sash/colored/mageblue
	color = CLOTHING_MAGE_BLUE

/obj/item/clothing/shirt/undershirt/sash/colored/green
	color = CLOTHING_SPRING_GREEN

/obj/item/clothing/shirt/undershirt/sash/colored/random/Initialize()
	color = pick(CLOTHING_CHALK_WHITE, CLOTHING_ROYAL_RED, CLOTHING_LINEN, CLOTHING_MAGE_ORANGE, CLOTHING_ROYAL_TEAL, CLOTHING_SWAMPWEED)
	return ..()

/obj/item/clothing/shirt/undershirt/formal
	name = "formal shirt"
	desc = "A comfortable yet functional dress shirt often worn by the staff of a noble household."
	icon_state = "butlershirt"
	sleeved = 'icons/roguetown/clothing/onmob/helpers/sleeves_maids.dmi'

/obj/item/clothing/shirt/undershirt/courtphysician
	name = "sanguine vest"
	desc = "A silk vest, perhaps it will make it another dae without being bloodied."
	icon_state = "docvest"
	item_state = "docvest"
	icon = 'icons/roguetown/clothing/courtphys.dmi'
	sleeved = 'icons/roguetown/clothing/onmob/helpers/sleeves_courtphys.dmi'
	mob_overlay_icon = 'icons/roguetown/clothing/onmob/courtphys.dmi'
	detail_tag = "_detail"
	uses_lord_coloring = LORD_PRIMARY

/obj/item/clothing/shirt/undershirt/courtphysician/female
	name = "sanguine blouse"
	desc = "A silk blouse, elegant, but it does you no good in surgery."
	icon_state = "docblouse"
	item_state = "docblouse"
	icon = 'icons/roguetown/clothing/courtphys.dmi'
	sleeved = 'icons/roguetown/clothing/onmob/helpers/sleeves_courtphys.dmi'
	mob_overlay_icon = 'icons/roguetown/clothing/onmob/courtphys.dmi'
	detail_tag = "_detail"
	uses_lord_coloring = LORD_PRIMARY
