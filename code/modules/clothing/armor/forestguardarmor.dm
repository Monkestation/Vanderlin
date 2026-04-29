/obj/item/clothing/armor/leather/advanced/forrester
	slot_flags = ITEM_SLOT_ARMOR
	name = "forrester's armour"
	desc = "Armour worn by the veterans of the Goblin War, who presently serve in the forest guard. \nThe soft, cloth linings make it easy to repair with a needle."
	icon = 'icons/roguetown/clothing/special/forest_guard.dmi'
	mob_overlay_icon = 'icons/roguetown/clothing/special/onmob/forest_guard.dmi'
	icon_state = "foresthide"
	prevent_crits = ALL_EXCEPT_STAB
	sewrepair = /datum/attribute/skill/craft/tanning/patching
	salvage_amount = 1
	salvage_result = /obj/item/natural/hide/cured
	dyeable = TRUE

/obj/item/clothing/armor/leather/advanced/forrester/masterwork
	name = "masterwork forrester's armor"
	desc = "Armour worn by few, those that live to hunt, to battle. \nThe soft, cloth linings with masterfully tanned leather make it easy to repair with a needle."
	max_integrity = INTEGRITY_STRONG + 200
	prevent_crits = ALL_EXCEPT_STAB
	armor = list("blunt" = 100, "slash" = 70, "stab" = 40, "piercing" = 10, "fire" = 0, "acid" = 0)

/obj/item/clothing/armor/leather/advanced/forrester/masterwork/Initialize()
	. = ..()
	filters += filter(type="drop_shadow", x=0, y=0, size=0.5, offset=1, color=rgb(218, 165, 32))


/obj/item/clothing/cloak/forrestercloak
	name = "forrester's cloak"
	desc = "A cloak worn by the forest guards."
	icon = 'icons/roguetown/clothing/special/forest_guard.dmi'
	mob_overlay_icon = 'icons/roguetown/clothing/special/onmob/forest_guard.dmi'
	icon_state = "forestcloak"
	alternate_worn_layer = CLOAK_BEHIND_LAYER
	slot_flags = ITEM_SLOT_BACK_R|ITEM_SLOT_CLOAK
	sleeved = 'icons/roguetown/clothing/special/onmob/forest_guard.dmi'
	sleevetype = "shirt"
	nodismemsleeves = TRUE
	inhand_mod = TRUE
	sewrepair = /datum/attribute/skill/craft/tanning/patching
	salvage_amount = 1
	salvage_result = /obj/item/natural/hide/cured
	dyeable = TRUE

/obj/item/clothing/cloak/forrestercloak/snow
	icon_state = "snowcloak"

/obj/item/clothing/cloak/forrestercloak/Initialize(mapload, ...)
	. = ..()
	AddComponent(/datum/component/storage/concrete/grid/cloak)

/obj/item/clothing/cloak/wardencloak
	name = "warden's cloak"
	desc = "A cloak worn by the veteran warden of the Forest Guard."
	icon = 'icons/roguetown/clothing/special/forest_guard.dmi'
	mob_overlay_icon = 'icons/roguetown/clothing/special/onmob/forest_guard.dmi'
	icon_state = "wardencloak"
	alternate_worn_layer = CLOAK_BEHIND_LAYER
	slot_flags = ITEM_SLOT_BACK_R|ITEM_SLOT_CLOAK
	sleeved = 'icons/roguetown/clothing/special/onmob/forest_guard.dmi'
	sleevetype = "shirt"
	nodismemsleeves = TRUE

/obj/item/clothing/cloak/wardencloak/Initialize(mapload, ...)
	. = ..()
	AddComponent(/datum/component/storage/concrete/grid/cloak)

/obj/item/clothing/head/helmet/visored/warden
	name = "wardens's helmet"
	desc = "A strange helmet adorned with antlers worn by the warden of the forest."
	icon = 'icons/roguetown/clothing/special/forest_guard.dmi'
	mob_overlay_icon = 'icons/roguetown/clothing/special/onmob/forest_guard.dmi'
	mob_overlay_icon = 'icons/roguetown/clothing/special/onmob/warden_64x64.dmi'
	worn_x_dimension = 64
	worn_y_dimension = 64
	icon_state = "wardenhelm"
	item_weight = 3.25 KILOGRAMS

/obj/item/clothing/head/helmet/medium
	abstract_type = /obj/item/clothing/head/helmet/medium

/obj/item/clothing/head/helmet/medium/decorated	// template
	name = "a template"
	mob_overlay_icon = 'icons/roguetown/clothing/onmob/head.dmi'
	bloody_icon = 'icons/effects/blood.dmi'
	bloody_icon_state = "helmetblood"
	flags_inv = HIDEEARS|HIDEHAIR|HIDEFACIALHAIR|HIDEFACE
	flags_cover = HEADCOVERSEYES | HEADCOVERSMOUTH
	sellprice = VALUE_IRON_HELMET
	var/picked = FALSE

	prevent_crits = ALL_EXCEPT_STAB
	abstract_type = /obj/item/clothing/head/helmet/medium/decorated

/obj/item/clothing/head/helmet/medium/decorated/skullmet
	name = "skullmet"
	desc = "A crude helmet constructed with the skull of various beasts of Dendor."
	icon = 'icons/roguetown/clothing/special/forest_guard.dmi'
	mob_overlay_icon = 'icons/roguetown/clothing/special/onmob/forest_guard.dmi'
	icon_state = "skullmet_volf"
	item_weight = 1.45 KILOGRAMS

/obj/item/clothing/head/helmet/medium/decorated/skullmet/attack_hand_secondary(mob/user, list/modifiers)
	. = ..()
	if(. == SECONDARY_ATTACK_CANCEL_ATTACK_CHAIN)
		return
	if(!picked)
		var/list/icons = SKULLMET_ICONS
		var/choice = input(user, "Choose a helmet design.", "Helmet designs") as anything in icons
		var/playerchoice = icons[choice]
		picked = TRUE
		icon_state = playerchoice
		item_state = playerchoice
		if(loc == user && ishuman(user))
			var/mob/living/carbon/H = user
			H.update_inv_head()
		return SECONDARY_ATTACK_CANCEL_ATTACK_CHAIN

/obj/item/clothing/head/helmet/medium/decorated/rousskullmet
	name = "rous skullmet"
	desc = "A crude helmet constructed with the skull of a rous, typically used by the problem children sent to the Foresters."
	icon = 'icons/roguetown/clothing/special/forest_guard.dmi'
	mob_overlay_icon = 'icons/roguetown/clothing/special/onmob/forest_guard.dmi'
	icon_state = "skullmet_ruffian"
	item_weight = 1.45 KILOGRAMS
