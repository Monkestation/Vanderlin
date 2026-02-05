
/obj/item/natural
	icon = 'icons/roguetown/items/natural.dmi'
	desc = ""
	w_class = WEIGHT_CLASS_TINY

	grid_width = 32
	grid_height = 32
	var/bundletype = null
	var/quality = SMELTERY_LEVEL_NORMAL // To not ruin blacksmith recipes

/obj/item/natural/attackby(obj/item/W, mob/living/user, list/modifiers)
	if(istype(W, /obj/item/natural/bundle))
		if(item_flags & IN_STORAGE)
			to_chat(user, span_warning("It's hard to find [src] in my bag."))
			return
		var/obj/item/natural/bundle/B = W
		if(istype(src, B.stacktype))
			if(B.amount < B.maxamount)
				B.amount++
				B.update_bundle()
				to_chat(user, span_notice("You add [src] to [W]."))
				qdel(src)
				user.changeNext_move(CLICK_CD_RANGE)
			else
				to_chat(user, span_warning("There's not enough space in [W]."))
			return
	return ..()

/obj/item/natural/pre_attack_secondary(atom/A, mob/living/user, list/modifiers)
	. = ..()
	if(. == SECONDARY_ATTACK_CANCEL_ATTACK_CHAIN)
		return
	if(istype(A, /obj/item/natural))
		if(item_flags & IN_STORAGE)
			to_chat(user, span_warning("It's hard to find [src] in my bag."))
			return SECONDARY_ATTACK_CANCEL_ATTACK_CHAIN
		var/obj/item/natural/B = A
		if(bundletype && bundletype == B.bundletype)
			if(!user.temporarilyRemoveItemFromInventory(src))
				return SECONDARY_ATTACK_CANCEL_ATTACK_CHAIN
			var/obj/item/natural/bundle/N = new bundletype(loc)
			to_chat(user, span_notice("You collect the [N.stackname] into a bundle."))
			qdel(B)
			qdel(src)
			user.put_in_active_hand(N)
			return SECONDARY_ATTACK_CANCEL_ATTACK_CHAIN

/obj/item/natural/bundle
	name = "bundle"
	desc = "You shouldn't be seeing this."
	possible_item_intents = list(/datum/intent/use)
	force = 0
	throwforce = 0
	firefuel = 5 MINUTES
	resistance_flags = FLAMMABLE
	var/firemod = 5 MINUTES
	var/amount = 2
	var/maxamount = 10
	var/icon1 = "fibersroll1"
	var/icon1step = 3
	var/icon2 = "fibersroll2"
	var/icon2step = 6
	var/icon3 = null
	var/stacktype = /obj/item/natural/fibers
	var/stackname = "fibers"
	var/items_per_increase = 5

	var/base_width = 32
	var/base_height = 32

/obj/item/natural/bundle/attackby(obj/item/W, mob/living/user, list/modifiers)
	if(amount <= 0) //how did you manage to do this
		qdel(src)
		return
	if(istype(W, /obj/item/natural/bundle))
		var/obj/item/natural/bundle/B = W
		if(src.stacktype == B.stacktype)
			if(src.amount + B.amount > maxamount)
				amount = (src.amount + B.amount) - maxamount
				B.amount = maxamount
				B.update_bundle()
				to_chat(user, span_warning("There's not enough space in [B]."))
				if(amount == 1)
					var/obj/H = new stacktype(src.loc)
					user.put_in_hands(H)
					qdel(src)
				else
					update_bundle()
			else
				to_chat(user, span_notice("You add [src] to [B]."))
				B.amount += amount
				B.update_bundle()
				qdel(src)
			return
	else if(istype(W, stacktype))
		if(item_flags & IN_STORAGE)
			return
		if(src.amount < src.maxamount)
			to_chat(user, span_notice("You add [W] to [src]."))
			src.amount++
			update_bundle()
			qdel(W)
		else
			to_chat(user, span_warning("There's not enough space in [src]."))
		return
	return ..()

/obj/item/natural/bundle/attack_hand_secondary(mob/user, list/modifiers)
	. = ..()
	if(. == SECONDARY_ATTACK_CANCEL_ATTACK_CHAIN)
		return
	. = SECONDARY_ATTACK_CANCEL_ATTACK_CHAIN
	if(item_flags & IN_STORAGE)
		to_chat(user, span_warning("I can't reach [src]!"))
		return
	if(amount <= 0) //how did you manage to do this
		qdel(src)
		return
	var/mob/living/carbon/human/H = user
	switch(amount)
		if(2)
			if(!user.temporarilyRemoveItemFromInventory(src))
				return
			var/obj/F = new stacktype(get_turf(src))
			var/obj/F2 = new stacktype(get_turf(src))
			H.put_in_hands(F)
			H.put_in_hands(F2)
			qdel(src)
			return
		if(1)
			if(!user.temporarilyRemoveItemFromInventory(src))
				return
			var/obj/F = new stacktype(get_turf(src))
			H.put_in_hands(F)
			qdel(src)
			return
		else
			amount -= 1
			var/obj/F = new stacktype(get_turf(src))
			H.put_in_hands(F)
			to_chat(user, span_notice("You remove \a [F] from [src]."))

	update_bundle()

/obj/item/natural/bundle/examine(mob/user)
	. = ..()
	. += span_notice("There are [amount] [stackname] in this bundle.")

/obj/item/natural/bundle/pre_attack_secondary(atom/A, mob/living/user, list/modifiers)
	. = ..()
	if(. == SECONDARY_ATTACK_CANCEL_ATTACK_CHAIN)
		return
	. = SECONDARY_ATTACK_CANCEL_ATTACK_CHAIN
	if(amount <= 0) //how did you manage to do this
		qdel(src)
		return
	if(ismob(A))
		return SECONDARY_ATTACK_CALL_NORMAL
	user.changeNext_move(CLICK_CD_MELEE)
	if(amount >= maxamount)
		to_chat(user, span_warning("There's not enough space in [src]."))
		return TRUE
	user.visible_message("[user] begins to gather all the [stackname] in front of them.", "I begin gathering all the [stackname] in front of me...")
	var/turf/turflocation = get_turf(A)
	for(var/obj/item/item in turflocation)
		if(amount >= maxamount)
			break
		if(!istype(item, stacktype) && !istype(item, /obj/item/natural/bundle))
			continue
		if(!do_after(user, 5 DECISECONDS, src))
			break
		if(item.loc != turflocation)
			continue
		if(istype(item, stacktype))
			amount++
			qdel(item)
		else if(istype(item, /obj/item/natural/bundle))
			var/obj/item/natural/bundle/B = item
			if(B.stacktype == stacktype)
				if(amount + B.amount > maxamount)
					B.amount = (amount + B.amount) - maxamount
					amount = maxamount
					if(B.amount == 1)
						new B.stacktype(B.loc)
						qdel(B)
					else
						B.update_bundle()
				else
					amount += B.amount
					qdel(B)
		update_bundle()

/obj/item/natural/bundle/proc/update_bundle()
	if(firefuel != 0)
		firefuel = firemod * amount
	if((amount <= icon1step) && (icon1 != null))
		icon_state = icon1
	else if((icon1step < amount <= icon2step) && (icon2 != null))
		icon_state = icon2
	else
		if(icon3 != null)
			icon_state = icon3
	var/increases = FLOOR(amount / items_per_increase, 1)

	var/height = FALSE
	grid_height = base_height
	grid_width = base_width
	for(var/i = 1 to increases)
		if(height)
			height = FALSE
			grid_height += 32
		else
			height = TRUE
			grid_width += 32
	if(item_flags & IN_STORAGE)
		var/obj/item/location = loc
		var/datum/component/storage/storage = location.GetComponent(/datum/component/storage)

		storage.update_item(src)
		storage.orient2hud()

/obj/item/natural/infernalash//T1 mage summon loot
	name = "infernal ash"
	icon_state = "infernalash"
	desc = "Ash burnt and burnt once again. Smells of brimstone and hellfire. Still has embers within."
	resistance_flags = FIRE_PROOF
	w_class = WEIGHT_CLASS_SMALL
	sellprice = 20
	attunement_values = list(
		/datum/attunement/fire = 0.05,
		/datum/attunement/blood = -0.1,
		/datum/attunement/death = 0.05,
		/datum/attunement/life = -0.05,
	)

/obj/item/natural/hellhoundfang//T2 mage summon loot
	name = "hellhound fang"
	icon_state = "hellhound_fang"
	desc = "A sharp fang that glows bright red, no matter how long it's left to cool."
	resistance_flags = FIRE_PROOF
	w_class = WEIGHT_CLASS_SMALL
	sellprice = 20
	attunement_values = list(
		/datum/attunement/fire = 0.1,
		/datum/attunement/blood = -0.1,

		/datum/attunement/death = 0.05,
		/datum/attunement/life = -0.05,
	)

/obj/item/natural/moltencore// T3 mage summon loot
	name = "molten core"
	icon_state = "wessence"
	desc = "A molten orb of rock and magick. It gives off waves of magical heat and energy."
	resistance_flags = FIRE_PROOF
	w_class = WEIGHT_CLASS_SMALL
	sellprice = 20
	attunement_values = list(
		/datum/attunement/fire = 0.15,
		/datum/attunement/blood = -0.1,

		/datum/attunement/death = 0.1,
		/datum/attunement/life = -0.1,
	)

/obj/item/natural/abyssalflame//T4 mage summon loot
	name = "abyssal flame"
	icon_state = "abyssalflame"
	desc = "A flickering, black flame contained in a crystal; the heart of an archfiend. Or, at least, what passes for one. It pulses with dense thrums of magick."
	resistance_flags = FIRE_PROOF
	w_class = WEIGHT_CLASS_SMALL
	sellprice = 20
	attunement_values = list(
		/datum/attunement/fire = 0.2,
		/datum/attunement/blood = -0.1,

		/datum/attunement/death = 0.15,
		/datum/attunement/life = -0.15,
	)

//FAIRY
/obj/item/natural/fairydust	//T1 mage summon loot
	name = "fairy dust"
	icon_state = "fairy_dust"
	desc = "A glittering powder from a fae sprite."
	resistance_flags = FIRE_PROOF
	w_class = WEIGHT_CLASS_SMALL
	sellprice = 20

	attunement_values = list(
		/datum/attunement/earth = 0.05,
		/datum/attunement/electric = -0.1,

		/datum/attunement/life = 0.05,
		/datum/attunement/death = -0.05,
	)

/obj/item/natural/iridescentscale	//T2 mage summon loot
	name = "iridescent scales"
	icon_state = "iridescent_scale"
	desc = "Tiny, colorful scales from a glimmerwing, they shine with inate magic"
	resistance_flags = FIRE_PROOF
	w_class = WEIGHT_CLASS_SMALL
	sellprice = 20

	attunement_values = list(
		/datum/attunement/earth = 0.1,
		/datum/attunement/electric = -0.1,

		/datum/attunement/life = 0.1,
		/datum/attunement/death = -0.1,
	)

/obj/item/natural/heartwoodcore	//T3 mage summon loot
	name = "heartwood core"
	icon_state = "heartwood_core"
	desc = "A piece of enchanted wood imbued with the dryad’s essence. Merely holding it transports one's mind to ancient times."
	resistance_flags = FIRE_PROOF
	w_class = WEIGHT_CLASS_SMALL
	sellprice = 20
	attunement_values = list(
		/datum/attunement/earth = 0.15,
		/datum/attunement/electric = -0.1,

		/datum/attunement/life = 0.1,
		/datum/attunement/death = -0.1,
	)

/obj/item/natural/sylvanessence	//T4 mage summon loot
	name = "sylvan essence"
	icon_state = "sylvanessence"
	desc = "A swirling, multicolored liquid with emitting a dizzying array of lights."
	resistance_flags = FIRE_PROOF
	w_class = WEIGHT_CLASS_SMALL
	sellprice = 20
	attunement_values = list(
		/datum/attunement/earth = 0.2,
		/datum/attunement/electric = -0.1,

		/datum/attunement/life = 0.15,
		/datum/attunement/death = -0.15,
	)

//ELEMENTAL
/obj/item/natural/elementalmote
	name = "elemental mote"
	icon_state = "mote"
	desc = "A mystical essence imbued with the power of Dendor. Merely holding it transports one's mind to ancient times."
	resistance_flags = FIRE_PROOF
	w_class = WEIGHT_CLASS_SMALL
	sellprice = 20

	attunement_values = list(
		/datum/attunement/electric = 0.05,
		/datum/attunement/ice = 0.05,
		/datum/attunement/blood = 0.05,
		/datum/attunement/aeromancy = 0.05,

		/datum/attunement/earth = -0.1,
	)

/obj/item/natural/elementalshard
	name = "elemental shard"
	icon_state = "shard"
	desc = "A mystical essence imbued with the power of Dendor. Merely holding it transports one's mind to ancient times."
	resistance_flags = FIRE_PROOF
	w_class = WEIGHT_CLASS_SMALL
	sellprice = 20

	attunement_values = list(
		/datum/attunement/electric = 0.1,
		/datum/attunement/ice = 0.1,
		/datum/attunement/blood = 0.1,
		/datum/attunement/aeromancy = 0.1,

		/datum/attunement/earth = -0.2,
	)

/obj/item/natural/elementalfragment
	name = "elemental fragment"
	icon_state = "fragment"
	desc = "A mystical essence imbued with the power of Dendor. Merely holding it transports one's mind to ancient times."
	resistance_flags = FIRE_PROOF
	w_class = WEIGHT_CLASS_SMALL
	sellprice = 20

	attunement_values = list(
		/datum/attunement/electric = 0.1,
		/datum/attunement/ice = 0.1,
		/datum/attunement/blood = 0.1,
		/datum/attunement/aeromancy = 0.1,

		/datum/attunement/earth = -0.15,
	)

/obj/item/natural/elementalrelic
	name = "elemental relic"
	icon_state = "relic"
	desc = "A mystical essence imbued with the power of Dendor. Merely holding it transports one's mind to ancient times."
	resistance_flags = FIRE_PROOF
	w_class = WEIGHT_CLASS_SMALL
	sellprice = 20

	attunement_values = list(
		/datum/attunement/electric = 0.1,
		/datum/attunement/ice = 0.1,
		/datum/attunement/blood = 0.1,
		/datum/attunement/aeromancy = 0.1,

		/datum/attunement/earth = -0.1,
	)

//Nullmagic
/obj/item/natural/voidstone
	name = "voidstone"
	icon_state = "voidstone"
	desc = "An incredibly rare substance torn from creatures immune to magick. This material forsakes Noc's gifts."
	resistance_flags = FIRE_PROOF
	w_class = WEIGHT_CLASS_SMALL
	sellprice = 20

	attunement_values = list(
		/datum/attunement/arcyne = 0.2,
		/datum/attunement/time = 0.2,
		/datum/attunement/polymorph = 0.2,
		/datum/attunement/dark = 0.2,
		/datum/attunement/illusion = 0.2,
	)
