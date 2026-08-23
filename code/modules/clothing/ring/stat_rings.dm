
//Anything above +1 that bestows positive traits or has no downsides should be restricted to higher-tier dungeons and loot pools.
//Anything below that - either a +1, or anything that comes with a negative trait or malus - should be acceptable for lower-tier dungeons and loot pools.
//These rings shouldn't be craftable under any circumstance, unless it involves combining multiple rings or rare components. Don't add recipes unless you absolutely know what you're doing.

/datum/attribute_modifier/statgemerald
	id = "Ring of Swiftness"
	attribute_list = list(
		STAT_SPEED = 1,
		STAT_FORTUNE = 1,
	)

/obj/item/clothing/ring/statgemerald
	name = "ring of swiftness"
	desc = "A gemerald ring, glimmering with verdant brilliance. The closer your hand drifts to it, the stronger that the wind howls."
	icon_state = "g_newring_emerald"
	sellprice = 222
	var/active_item

/obj/item/clothing/ring/statgemerald/equipped(mob/living/user, slot)
	. = ..()
	if(active_item)
		return
	else if(slot == ITEM_SLOT_RING)
		active_item = TRUE
		to_chat(user, span_green("'..the way of lyfe, bountiful but fleeting..'"))
		user.attributes?.add_attribute_modifier(/datum/attribute_modifier/statgemerald)
	return

/obj/item/clothing/ring/statgemerald/dropped(mob/living/user)
	..()
	if(active_item)
		to_chat(user, span_green("'..but without an end to the journey, what would become of lyfe's meaning?'"))
		user.attributes?.remove_attribute_modifier(/datum/attribute_modifier/statgemerald)
		active_item = FALSE
	return

/datum/attribute_modifier/statonyx
	id = "Ring of Vitality"
	attribute_list = list(
		STAT_CONSTITUTION = 1,
		STAT_ENDURANCE = 1,
	)

/obj/item/clothing/ring/statonyx
	name = "ring of vitality"
	desc = "An onyx ring, shining with violet determination. The closer your hand drifts to it, the faster your heart pounds."
	icon_state = "g_newring_quartz"
	sellprice = 222
	var/active_item

/obj/item/clothing/ring/statonyx/equipped(mob/living/user, slot)
	. = ..()
	if(active_item)
		return
	else if(slot == ITEM_SLOT_RING)
		active_item = TRUE
		to_chat(user, span_purple("'..the way of blood, shed from you in vain..'"))
		user.attributes?.add_attribute_modifier(/datum/attribute_modifier/statonyx)
	return

/obj/item/clothing/ring/statonyx/dropped(mob/living/user)
	..()
	if(active_item)
		to_chat(user, span_purple("'..but if you don't stand for those who cannot, who will?'"))
		user.attributes?.remove_attribute_modifier(/datum/attribute_modifier/statonyx)
		active_item = FALSE
	return

/datum/attribute_modifier/statamythortz
	id = "Ring of Wisdom"
	attribute_list = list(
		STAT_INTELLIGENCE = 1,
		STAT_PERCEPTION = 1,
	)

/obj/item/clothing/ring/statamythortz
	name = "ring of wisdom"
	desc = "A saffira ring, crackling with azuric fascination. The closer your hand drifts to it, the clearer your mind becomes."
	icon_state = "g_newring_sapphire"
	sellprice = 222
	var/active_item

/obj/item/clothing/ring/statamythortz/equipped(mob/living/user, slot)
	. = ..()
	if(active_item)
		return
	else if(slot == ITEM_SLOT_RING)
		active_item = TRUE
		to_chat(user, span_rose("'..the way of knowledge, cursing its pursuers with inzanity..'"))
		user.attributes?.add_attribute_modifier(/datum/attribute_modifier/statamythortz)
	return

/obj/item/clothing/ring/statamythortz/dropped(mob/living/user)
	..()
	if(active_item)
		to_chat(user, span_rose("'..but if we root ourselves in the thoughtless, how else will we progress?'"))
		user.attributes?.remove_attribute_modifier(/datum/attribute_modifier/statamythortz)
		active_item = FALSE
	return

/datum/attribute_modifier/statrontz
	id = "Ring of Courage"
	attribute_list = list(
		STAT_STRENGTH = 1,
	)

/obj/item/clothing/ring/statrontz
	name = "ring of courage"
	desc = "A rontz ring, radiating with crimson authority. The closer your hand drifts to it, the tighter your knuckles curl."
	icon_state = "g_newring_ruby"
	sellprice = 222
	var/active_item

/obj/item/clothing/ring/statrontz/equipped(mob/living/user, slot)
	. = ..()
	if(active_item)
		return
	else if(slot == ITEM_SLOT_RING)
		active_item = TRUE
		to_chat(user, span_red("'..the way of death, indiscriminate and total..'"))
		user.attributes?.add_attribute_modifier(/datum/attribute_modifier/statrontz)
	return

/obj/item/clothing/ring/statrontz/dropped(mob/living/user)
	..()
	if(active_item)
		to_chat(user, span_red("'..but without violence, what would stop evil from triumphing?'"))
		user.attributes?.remove_attribute_modifier(/datum/attribute_modifier/statrontz)
		active_item = FALSE
	return

/datum/attribute_modifier/statdorpel
	id = "Ring of Omnipotence"
	attribute_list = list(
		STAT_STRENGTH = 1,
		STAT_CONSTITUTION = 1,
		STAT_ENDURANCE = 1,
		STAT_SPEED = 1,
		STAT_INTELLIGENCE = 1,
		STAT_PERCEPTION = 1,
		STAT_FORTUNE = 1,
	)

/obj/item/clothing/ring/statdorpel
	name = "ring of omnipotence"
	desc = "A dorpel ring, glowing with resplendent beauty. The closer your hand drifts to it, the more that your fears melt away."
	icon_state = "newmulticolor"
	smeltresult = /obj/item/riddleofsteel
	sellprice = 777
	var/active_item

/obj/item/clothing/ring/statdorpel/Initialize(mapload)
	. = ..()
	enchant(/datum/enchantment/silver)

/obj/item/clothing/ring/statdorpel/equipped(mob/living/user, slot)
	. = ..()
	if(active_item)
		return
	else if(slot == ITEM_SLOT_RING)
		active_item = TRUE
		to_chat(user, span_blue("'..the way of hope, unbreakable and unifying..'"))
		user.attributes?.add_attribute_modifier(/datum/attribute_modifier/statdorpel)
		user.add_chem_effect(CE_ENERGETIC, 5, "[type]")
	return

/obj/item/clothing/ring/statdorpel/dropped(mob/living/user)
	..()
	if(active_item)
		to_chat(user, span_blue("'..I know that kindness exists, for I am kind..' </br>'..I know hope exists, for I have hope..' </br>'..and I know love exists, for I love.'"))
		user.attributes?.remove_attribute_modifier(/datum/attribute_modifier/statdorpel)
		user.remove_chem_effect(CE_ENERGETIC, "[type]")
		active_item = FALSE
	return

/datum/attribute_modifier/dragon_ring
	id = "Dragon Ring"
	attribute_list = list(
		STAT_STRENGTH = 2,
		STAT_CONSTITUTION = 2,
		STAT_ENDURANCE = 2,
	)

/obj/item/clothing/ring/dragon_ring
	name = "dragonstone ring"
	icon_state = "dragonring" //Should be safe for vampyres to wear, as the ring itself isn't made of silver. If they've suffered enough to make this ring, they should be able to wear it.
	desc = "A gilded blacksteel ring with a drake's head, sculpted from silver. Perched within its sockets is a blortz and saffira - each, crackling with the reflection of a raging fire."
	melting_material = /datum/material/draconic
	melt_amount = 100
	sellprice = 666
	var/active_item

/obj/item/clothing/ring/dragon_ring/equipped(mob/living/user, slot)
	. = ..()
	if(active_item)
		return
	else if(slot == ITEM_SLOT_RING)
		active_item = TRUE
		to_chat(user, span_suicide("Draconic fire courses through my veins! I feel powerful!"))
		user.attributes?.add_attribute_modifier(/datum/attribute_modifier/dragon_ring)
		update_icon()
	return

/obj/item/clothing/ring/dragon_ring/dropped(mob/living/user)
	..()
	if(active_item)
		to_chat(user, span_suicide("A chilling sensation courses through my body, and the ring's heat remains oh-so-alluring.. </br>..yet, one must wonder.. could such fiery strength withstand a forge's heat?"))
		user.attributes?.remove_attribute_modifier(/datum/attribute_modifier/dragon_ring)
		active_item = FALSE
		update_icon()
	return

/obj/item/clothing/ring/dragon_ring/update_icon()
	..()
	if(active_item)
		icon_state = "factive"
	else
		icon_state = "dragonring"
