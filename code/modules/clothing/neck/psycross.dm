
/obj/item/clothing/neck/psycross
	name = "psycross"
	desc = "Let His name be naught but forgot'n."
	icon_state = "psycross_wood"
	//dropshrink = 0.75
	slot_flags = ITEM_SLOT_NECK|ITEM_SLOT_HIP|ITEM_SLOT_WRISTS
	sellprice = 10
	experimental_onhip = TRUE

// INHUMEN PSYCROSSES

/obj/item/clothing/neck/psycross/zizo
	name = "Amulet of Zizo"
	desc = "Through power dominate, through domination rule, through Zizo become the divinity you were always meant to be."
	icon_state = "zcross"
	slot_flags = ITEM_SLOT_NECK|ITEM_SLOT_HIP|ITEM_SLOT_WRISTS
	sellprice = 0
	experimental_onhip = TRUE

// SILVER PSYCROSS START

/obj/item/clothing/neck/psycross/silver
	name = "silver psycross"
	desc = "Let His name be naught but forgot'n. Let the wicked undead burn at my touch."
	icon_state = "psycross_silver"
	resistance_flags = FIRE_PROOF
	sellprice = 50
	smeltresult = /obj/item/ingot/silver

/obj/item/clothing/neck/psycross/silver/Initialize(mapload)
	. = ..()
	enchant(/datum/enchantment/silver)

// PANTHEON SILVER PSYCROSSES START

/obj/item/clothing/neck/psycross/silver/astrata
	name = "amulet of Astrata"
	desc = "Blessed be everything the light of the sun touches, for it is protected by Her grace."
	icon_state = "astrata"
	resistance_flags = FIRE_PROOF

/obj/item/clothing/neck/psycross/silver/noc
	name = "amulet of Noc"
	desc = "Diligence, study, pursuit of truth and wisdom. Let nothing deter you from it."
	icon_state = "noc"
	resistance_flags = FIRE_PROOF

/obj/item/clothing/neck/psycross/silver/dendor
	name = "amulet of Dendor"
	desc = "Nature is a body of which we are but its entrails."
	icon_state = "dendor"
	resistance_flags = FIRE_PROOF

/obj/item/clothing/neck/psycross/silver/abyssor
	name = "amulet of Abyssor"
	desc = "Oceanshaper and guardian of the seas, make them remember his name."
	icon_state = "abyssor"
	resistance_flags = FIRE_PROOF

/obj/item/clothing/neck/psycross/silver/necra
	name = "amulet of Necra"
	desc = "Where, grave, thy victory? I triumph still while the Veiled Lady abides by me."
	icon_state = "necra"
	resistance_flags = FIRE_PROOF

/obj/item/clothing/neck/psycross/silver/ravox
	name = "amulet of Ravox"
	desc = "Struggle. Challenge. And rise to struggle again. That is the sword of he who yet lives to fight again."
	icon_state = "ravox"
	resistance_flags = FIRE_PROOF

/obj/item/clothing/neck/psycross/silver/xylix
	name = "amulet of Xylix"
	desc = "Be not fooled, and be not afraid to."
	icon_state = "xylix"
	resistance_flags = FIRE_PROOF

/obj/item/clothing/neck/psycross/silver/eora
	name = "amulet of Eora"
	desc = "And I love thee because thou art love."
	icon_state = "eora"
	resistance_flags = FIRE_PROOF

/obj/item/clothing/neck/psycross/silver/holy/eora
	name = "Eora's love potion"
	desc = "Eora's blessing is upon thy, use me on someone else and you shall be soulbond."
	icon_state = "eora"
	resistance_flags = FIRE_PROOF

/obj/item/clothing/neck/psycross/silver/holy/eora/attack(mob/living/love_target, mob/user, list/modifiers)
	if(!isliving(love_target) || love_target.stat == DEAD)
		to_chat(user, span_warning("The love potion only works on living things, sicko!"))
		return ..()
	if(user == love_target)
		to_chat(user, span_warning("You can't drink the love potion. What are you, a narcissist?"))
		return ..()
	if(love_target.has_status_effect(/datum/status_effect/in_love))
		to_chat(user, span_warning("[love_target] is already lovestruck!"))
		return ..()

	love_target.visible_message(span_danger("[user] starts to feed [love_target] a love potion!"),
		span_userdanger("[user] starts to feed you a love potion!"))

	if(!do_after(user, 5 SECONDS, love_target))
		return
	to_chat(user, span_notice("You feed [love_target] the love potion!"))
	to_chat(love_target, span_notice("You develop feelings for [user], and anyone [user.p_they()] like[user.p_s()]."))
	love_target.faction |= "[REF(user)]"
	love_target.apply_status_effect(/datum/status_effect/in_love, user)
	qdel(src)

/obj/item/clothing/neck/psycross/silver/pestra
	name = "amulet of Pestra"
	desc = "When pure, alcohol is best used as a cleanser of wounds and a cleanser of the palate."
	icon_state = "pestra"
	resistance_flags = FIRE_PROOF

/obj/item/clothing/neck/psycross/silver/malum
	name = "amulet of Malum"
	desc = "Blessed be our works, made in His name."
	icon_state = "malum"
	resistance_flags = FIRE_PROOF

/obj/item/clothing/neck/psycross/silver/malum/steel
	name = "amulet of Malum"
	desc = "Let the tools that guide thee be thy hands."
	icon_state = "malum_alt"
	resistance_flags = FIRE_PROOF

/obj/item/clothing/neck/psycross/g
	name = "golden psycross"
	desc = "Let His name be naught but forgot'n. Let devotion to Him endure, in heart and in deed, beyond the veil of sight."
	icon_state = "psycross_gold"
	//dropshrink = 0.75
	resistance_flags = FIRE_PROOF
	sellprice = 100
	smeltresult = /obj/item/ingot/gold

/obj/item/clothing/neck/psycross/silver/undivided
	name = "amulet of the ten"
	desc = "The Ten eternal, strength in unity. Stalwart for centuries against the darkness."
	icon_state = "undivided"

