
/obj/item/natural
	icon = 'icons/roguetown/items/natural.dmi'
	desc = ""
	w_class = WEIGHT_CLASS_TINY

	grid_width = 32
	grid_height = 32
	var/bundletype = null

/obj/item/natural/item_interaction(mob/living/user, obj/item/tool, list/modifiers)
	if(user.cmode)
		return NONE

	if(istype(tool, /obj/item/natural/bundle))
		var/obj/item/natural/bundle/B = tool
		if(!istype(src, B.stacktype))
			return NONE

		if(item_flags & IN_STORAGE)
			user.balloon_alert(user, "can't reach!")
			return ITEM_INTERACT_BLOCKING

		if(B.amount < B.maxamount)
			B.amount++
			B.update_bundle()
			user.balloon_alert(user, "[name] added.")
			qdel(src)
			user.changeNext_move(CLICK_CD_RANGE)
		else
			user.balloon_alert(user, "no space!")

		return ITEM_INTERACT_SUCCESS

	if(istype(tool, /obj/item/natural))
		var/obj/item/natural/natural = tool
		if(!ispath(natural.bundletype, bundletype))
			return NONE

		if(item_flags & IN_STORAGE)
			user.balloon_alert(user, "can't reach!")
			return ITEM_INTERACT_BLOCKING

		var/obj/item/natural/bundle/N = new bundletype(loc)
		user.balloon_alert(user, "[N.stackname] bundled.")
		qdel(natural)
		qdel(src)
		user.put_in_hands(N)

		return ITEM_INTERACT_SUCCESS

/obj/item/natural/item_interaction_secondary(mob/living/user, obj/item/tool, list/modifiers)
	// Interaction happens first and we want to do the collect all behaviour here
	if(istype(tool, /obj/item/natural/bundle))
		return NONE
	return item_interaction(user, tool, modifiers)

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
	var/obj/item/stacktype = /obj/item/natural/fibers
	var/stackname = "fibers"
	var/bundle_verb = "bundle"
	/// For every amount / items_per_increase, increase a storage dimension by 1.
	var/items_per_increase = 5

	var/base_width = 32
	var/base_height = 32

/obj/item/natural/bundle/Initialize(mapload)
	. = ..()
	update_bundle()

/obj/item/natural/bundle/get_carry_weight(atom/carrier)
	. = initial(stacktype.item_weight) * amount

/obj/item/natural/bundle/item_interaction(mob/living/user, obj/item/tool, list/modifiers)
	if(amount <= 0) //how did you manage to do this
		qdel(src)
		return ITEM_INTERACT_SUCCESS

	if(user.cmode)
		return NONE

	if(istype(tool, stacktype))
		if(item_flags & IN_STORAGE)
			return NONE

		if(amount >= maxamount)
			user.balloon_alert(user, "full!")
			return ITEM_INTERACT_BLOCKING

		user.balloon_alert(user, "[tool.name] added.")
		amount++
		qdel(tool)
		return ITEM_INTERACT_SUCCESS

	if(istype(tool, /obj/item/natural/bundle))
		if(item_flags & IN_STORAGE)
			return NONE

		var/obj/item/natural/bundle/B = tool
		if(!ispath(B.stacktype, stacktype))
			return NONE

		if((amount + B.amount) < maxamount)
			user.balloon_alert(user, "[tool.name] added.")
			B.amount += amount
			update_bundle()
			qdel(src)
			return ITEM_INTERACT_SUCCESS

		amount = (amount + B.amount) - maxamount
		B.amount = maxamount
		B.update_bundle()
		user.balloon_alert(user, "not enough space!")

		if(amount == 1)
			var/obj/H = new stacktype(get_turf(src))
			user.put_in_hands(H)
			qdel(src)
		else
			update_bundle()

		return ITEM_INTERACT_SUCCESS

/obj/item/natural/bundle/interact_with_atom_secondary(atom/interacting_with, mob/living/user, list/modifiers)
	if(amount <= 0) //how did you manage to do this
		qdel(src)
		return ITEM_INTERACT_SUCCESS

	if(user.cmode)
		return NONE

	if(ismob(interacting_with))
		return NONE

	if(amount >= maxamount)
		to_chat(user, span_warning("There's not enough space in [src]."))
		return ITEM_INTERACT_BLOCKING

	user.changeNext_move(CLICK_CD_FAST)
	user.visible_message(
		span_notice("[user] begins to gather all the [stackname] in front of them."),
		span_notice("I begin gathering all the [stackname] in front of me..."),
	)

	var/turf/turflocation = get_turf(interacting_with)
	for(var/obj/item/item in turflocation)
		if(amount >= maxamount)
			return ITEM_INTERACT_BLOCKING

		if(!do_after(user, 5 DECISECONDS, src))
			return ITEM_INTERACT_BLOCKING

		if(!istype(item, stacktype) && !istype(item, /obj/item/natural/bundle))
			continue

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

	return ITEM_INTERACT_SUCCESS

/obj/item/natural/bundle/attack_hand_secondary(mob/user, list/modifiers)
	. = ..()
	if(. == SECONDARY_ATTACK_CANCEL_ATTACK_CHAIN)
		return

	. = SECONDARY_ATTACK_CANCEL_ATTACK_CHAIN
	if(item_flags & IN_STORAGE)
		user.balloon_alert(user, "can't reach!")
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
			user.balloon_alert(user, "I remove \a [F].")

	update_bundle()

/obj/item/natural/bundle/examine(mob/user)
	. = ..()
	. += span_notice("There are [amount] [stackname] in this [bundle_verb].")

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

	if(!items_per_increase)
		return

	var/increases = FLOOR(amount / items_per_increase, 1)

	var/dimension = FALSE
	grid_height = base_height
	grid_width = base_width
	for(var/i = 1 to increases)
		if(dimension)
			grid_height += 32
		else
			grid_width += 32
		dimension = !dimension
	if(item_flags & IN_STORAGE)
		var/obj/item/location = loc
		var/datum/component/storage/storage = location.GetComponent(/datum/component/storage)

		storage.update_item(src)
		storage.orient2hud()

/obj/item/natural/clod
	name = "generic clod"
	desc = "A handful of nothing."
	icon_state = "clod1"
	dropshrink = 0
	throwforce = 0
	w_class = WEIGHT_CLASS_TINY
	var/pile = null
	var/clod_type = null

/obj/item/natural/clod/item_interaction(mob/living/user, obj/item/tool, list/modifiers)
	if(!istype(tool, /obj/item/weapon/shovel))
		return NONE

	if(item_flags & IN_STORAGE)
		return NONE

	if(!istype(user.used_intent, /datum/intent/shovelscoop))
		return NONE

	var/obj/item/weapon/shovel/S = tool
	if(S.heldclod)
		return ITEM_INTERACT_BLOCKING

	playsound(src,'sound/items/dig_shovel.ogg', 100, TRUE)

	forceMove(S)
	S.heldclod = src
	tool.update_appearance(UPDATE_ICON_STATE)
	return ITEM_INTERACT_SUCCESS

/obj/item/natural/clod/attack_self(mob/living/user, params)
	user.visible_message("<span class='warning'>[user] scatters [src].</span>")
	qdel(src)

/obj/structure/fluff/clodpile
	name = "mystery pile"
	desc = "There is no telling what this is or why it exists. In fact, it shouldn't."
	icon = 'icons/roguetown/items/natural.dmi'
	icon_state = "clodpile"
	var/dirtamt = 5
	climbable = FALSE
	density = FALSE
	climb_offset = 10
	var/dirt_type = null

/obj/structure/fluff/clodpile/Initialize()
	. = ..()
	dir = pick(GLOB.cardinals)

/obj/structure/fluff/clodpile/item_interaction(mob/living/user, obj/item/tool, list/modifiers)
	if(!istype(tool, /obj/item/weapon/shovel))
		return NONE

	if(!istype(user.used_intent, /datum/intent/shovelscoop))
		return NONE

	var/obj/item/weapon/shovel/S = tool

	if(!S.heldclod)
		playsound(src,'sound/items/dig_shovel.ogg', 100, TRUE)
		var/obj/item/J = new dirt_type(S)
		S.heldclod = J
		S.update_appearance(UPDATE_ICON_STATE)
		dirtamt--
		if(dirtamt <= 0)
			qdel(src)
	else
		playsound(src,'sound/items/empty_shovel.ogg', 100, TRUE)
		var/obj/item/I = S.heldclod
		S.heldclod = null
		qdel(I)
		S.update_appearance(UPDATE_ICON_STATE)
		dirtamt++
		if(dirtamt > 5)
			dirtamt = 5

	return ITEM_INTERACT_SUCCESS

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
	item_weight = 30 GRAMS

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
	item_weight = 40 GRAMS

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
	item_weight = 80 GRAMS

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
	item_weight = 50 GRAMS

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
	item_flags = OBTAINED_DATA
	obtained_from = list(list("Killing a Sylph", /mob/living/simple_animal/hostile/retaliate/fae/sylph))
	item_weight = 10 GRAMS

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
	item_flags = OBTAINED_DATA
	obtained_from = list(list("Killing a Sylph", /mob/living/simple_animal/hostile/retaliate/fae/sylph))
	item_weight = 15 GRAMS

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
	item_flags = OBTAINED_DATA
	obtained_from = list(list("Killing a Sylph", /mob/living/simple_animal/hostile/retaliate/fae/sylph))
	item_weight = 60 GRAMS

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
	item_flags = OBTAINED_DATA
	obtained_from = list(list("Killing a Sylph", /mob/living/simple_animal/hostile/retaliate/fae/sylph))
	item_weight = 40 GRAMS

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
	item_weight = 20 GRAMS

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
	item_weight = 30 GRAMS

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
	item_weight = 25 GRAMS

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
	item_weight = 35 GRAMS

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
	item_weight = 60 GRAMS
