
/obj/item/clothing/wrists/bracers
	name = "plate vambraces"
	desc = "Plate forearm guards that offer superior protection while allowing mobility."
	body_parts_covered = ARMS
	icon_state = "bracers"
	item_state = "bracers"
	armor_class = AC_HEAVY
	armor = ARMOR_PLATE
	prevent_crits = list(BCLASS_LASHING, BCLASS_BITE, BCLASS_CUT, BCLASS_CHOP, BCLASS_BLUNT, BCLASS_TWIST)
	blocksound = PLATEHIT
	resistance_flags = FIRE_PROOF
	anvilrepair = /datum/attribute/skill/craft/armor_repair
	sewrepair = null
	smeltresult = /obj/item/ingot/iron //no 1 to 1 conversion
	max_integrity = INTEGRITY_STRONG
	item_weight = 1.2 KILOGRAMS

/obj/item/clothing/wrists/bracers/naledi
	name = "sojourner's wrappings"
	desc = "Sheared burlap and cloth, meticulously fashioned around the forearms. It provides more freedom of movement than the traditional steel thorns."
	slot_flags = ITEM_SLOT_WRISTS
	body_parts_covered = ARMS
	icon_state = "nocwrappings"
	item_state = "nocwrappings"
	armor_class = AC_LIGHT
	armor = ARMOR_PADDED_GOOD
	blade_dulling = DULLING_BASHCHOP
	color = "#48443B"
	max_integrity = ARMOR_INT_SIDE_STEEL //Heavy leather-tier protection and critical resistances, steel-tier integrity. Integrity boost encourages hand-to-hand parrying. Weaker than the Psydonic Thorns.
	prevent_crits = list(BCLASS_CUT, BCLASS_CHOP, BCLASS_STAB, BCLASS_BLUNT, BCLASS_TWIST)
	blocksound = SOFTHIT
	sewrepair = /datum/attribute/skill/misc/sewing/mending
	dyeable = TRUE
	item_weight = 125 GRAMS

/obj/item/clothing/wrists/bracers/iron
	name = "iron plate vambraces"
	desc = "Plate forearm guards that offer good protection while allowing mobility."
	icon_state = "ibracers"
	item_state = "ibracers"
	armor = ARMOR_MAILLE
	max_integrity = INTEGRITY_STRONG


/obj/item/clothing/wrists/bracers/jackchain
	name = "jack chains"
	desc = "Thin strips of steel attached to small shoulder and elbow plates, worn on the outside of the arms to protect against slashes."
	icon_state = "jackchain"
	item_state = "jackchain"

	armor = ARMOR_MAILLE
	max_integrity = INTEGRITY_STRONGEST
	prevent_crits = CUT_AND_MINOR_CRITS
	smeltresult = /obj/item/fertilizer/ash
	melting_material = /datum/material/steel
	melt_amount = 75

/obj/item/clothing/wrists/bracers/ironjackchain
	name = "iron jack chains"
	desc = "Thin strips of iron and small plates attached to small shoulder and elbow guards, worn on the outside of the arms to protect against slashes, bludgeons and whatever they block."
	icon_state = "ijackchain"
	item_state = "ijackchain"

	armor_class = AC_MEDIUM
	armor = ARMOR_MAILLE
	max_integrity = INTEGRITY_STRONG
	prevent_crits = CUT_AND_MINOR_CRITS
	smeltresult = /obj/item/fertilizer/ash //we avoid melting one piece for one bar
	melting_material = /datum/material/iron // we get one bar per two pieces of the item recovered and smelted
	melt_amount = 75

/obj/item/clothing/wrists/bracers/leather
	name = "leather bracers"
	desc = "Boiled leather bracers typically worn by archers to protect their forearms."
	icon_state = "lbracers"
	item_state = "lbracers"
	armor_class = AC_LIGHT
	armor = list("blunt" = 30, "slash" = 30, "stab" = 30,  "piercing" = 15, "fire" = 0, "acid" = 0)
	prevent_crits = list(BCLASS_LASHING, BCLASS_BITE, BCLASS_CUT)
	resistance_flags = null
	blocksound = SOFTHIT
	smeltresult = /obj/item/fertilizer/ash
	blade_dulling = DULLING_BASHCHOP
	break_sound = 'sound/foley/cloth_rip.ogg'
	drop_sound = 'sound/foley/dropsound/cloth_drop.ogg'
	anvilrepair = null
	sewrepair = /datum/attribute/skill/craft/tanning/patching
	salvage_result = /obj/item/natural/hide/cured
	salvage_amount = 1
	dyeable = TRUE
	salvage_result = null
	max_integrity = INTEGRITY_STANDARD
	item_weight = 650 GRAMS

//THE ARMOUR VALUES OF ADVANCED AND MASTERWORK BRACERS ARE INTENDED
//KEEP THIS IN MIND
//...why the hell do they exist anyways, we got advanced/masterwork gloves.

/obj/item/clothing/wrists/bracers/leather/advanced
	name = "hardened leather bracers"
	desc = "Hardened leather braces that will keep your wrists safe from bludgeoning."
	armor = list("blunt" = 60, "slash" = 40, "stab" = 20, "piercing" = 0, "fire" = 0, "acid" = 0)
	prevent_crits = ALL_EXCEPT_CHOP_AND_STAB
	max_integrity = INTEGRITY_STANDARD + 50

/obj/item/clothing/wrists/bracers/leather/masterwork
	name = "masterwork leather bracers"
	desc = "These bracers are a craftsmanship marvel. Made with the finest leather. Strong, nimble, reliable."
	armor = list("blunt" = 80, "slash" = 60, "stab" = 40, "piercing" = 0, "fire" = 0, "acid" = 0)
	prevent_crits = ALL_EXCEPT_STAB
	max_integrity = INTEGRITY_STANDARD + 100

/obj/item/clothing/wrists/bracers/leather/masterwork/Initialize()
	. = ..()
	filters += filter(type="drop_shadow", x=0, y=0, size=0.5, offset=1, color=rgb(218, 165, 32))

/obj/item/clothing/wrists/bracers/leather/scabbard
	name = "leather bracers"
	desc = "Discretion had always been the better part of valour, and nobody understands that better than the one holding an ace up their sleeve."
	sellprice = 40
	icon = 'icons/roguetown/clothing/special/hand.dmi'
	icon_state = "bracersheath"

/obj/item/clothing/wrists/bracers/leather/scabbard/Initialize()
	. = ..()
	ADD_TRAIT(src, TRAIT_HARD_TO_STEAL, TRAIT_GENERIC)
	AddElement(/datum/element/update_icon_updates_onmob, slot_flags|ITEM_SLOT_HANDS)
	AddComponent(/datum/component/storage/concrete/scabbard/knife)

/obj/item/clothing/wrists/bracers/psythorns
	name = "psydonian thorns"
	desc = "Thorns fashioned from pliable yet durable blacksteel - woven and interlinked, fashioned to be wrapped around the wrists."
	body_parts_covered = ARMS
	icon_state = "psybarbs"
	item_state = "psybarbs"
	armor_class = AC_MEDIUM
	armor = list("blunt" = 80, "slash" = 100, "stab" = 90, "piercing" = 80, "fire" = 0, "acid" = 0)
	prevent_crits = list(BCLASS_CUT, BCLASS_STAB, BCLASS_CHOP, BCLASS_BLUNT, BCLASS_SMASH, BCLASS_TWIST, BCLASS_PICK)
	blocksound = PLATEHIT
	resistance_flags = FIRE_PROOF
	max_integrity = 400
	anvilrepair = /datum/attribute/skill/craft/armor_repair
	sewrepair = null
	alternate_worn_layer = WRISTS_LAYER
	item_weight = 1.6 KILOGRAMS

/obj/item/clothing/wrists/bracers/psythorns/equipped(mob/user, slot)
	. = ..()
	user.update_inv_wrists()
	user.update_inv_gloves()
	user.update_inv_armor()
	user.update_inv_shirt()

/obj/item/clothing/wrists/bracers/psythorns/attack_self(mob/living/user)
	. = ..()
	user.visible_message(span_warning("[user] starts to reshape the [src]."))
	if(do_after(user, 4 SECONDS))
		var/obj/item/clothing/head/helmet/blacksteel/psythorns/P = new /obj/item/clothing/head/helmet/blacksteel/psythorns(get_turf(src.loc))
		if(user.is_holding(src))
			user.dropItemToGround(src)
			user.put_in_hands(P)
		var/obj/item/bodypart/arm = user.get_active_hand()
		arm?.bodypart_attacked_by(BCLASS_CUT, 25)
		qdel(src)
	else
		user.visible_message(span_warning("[user] stops reshaping [src]."))
		return
