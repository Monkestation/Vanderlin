/datum/mana_pool/mana_battery
	amount = 0

/datum/mana_pool/mana_battery/can_transfer(datum/mana_pool/target_pool)
	if (QDELETED(target_pool.parent))
		return FALSE
	var/obj/item/mana_battery/battery = parent

	if (battery.loc == target_pool.parent.loc)
		return TRUE

	if (get_dist(battery, target_pool.parent) > battery.max_allowed_transfer_distance)
		return FALSE
	return ..()

/obj/item/mana_battery
	name = "generic mana battery"
	has_initial_mana_pool = TRUE
	var/max_allowed_transfer_distance = MANA_BATTERY_MAX_TRANSFER_DISTANCE

/obj/item/mana_battery/get_initial_mana_pool_type()
	return /datum/mana_pool/mana_battery/mana_crystal

// when we hit ourself with left click, we draw mana FROM the battery.
/obj/item/mana_battery/attack_self(mob/user, list/modifiers)
	. = ..()

	if (.)
		return TRUE

	if (!user.mana_pool)
		return FALSE

	var/already_transferring = (user in mana_pool.transferring_to)
	if (already_transferring)
		mana_pool.stop_transfer(user.mana_pool)
	else
		if(!user.is_holding(src))
			return
		var/mana_to_draw = input(user, "How much mana do you want to draw from the battery? Soft Cap (You will lose mana when above this!): [user.mana_pool.get_softcap()]", "Draw Mana") as num
		mana_to_draw = CLAMP(mana_to_draw, mana_pool.maximum_mana_capacity, 0)
		if(!mana_to_draw || QDELETED(user) || QDELETED(src) || !user.is_holding(src))
			return
		var/drawn_mana = mana_to_draw
		to_chat(user, "drawing mana....")
		mana_pool.transfer_specific_mana(user.mana_pool, drawn_mana, decrement_budget = TRUE)

// when we hit ourself with right click, however, we send mana TO the battery.
/obj/item/mana_battery/attack_hand_secondary(mob/user, list/modifiers)
	. = ..()
	if(. == SECONDARY_ATTACK_CANCEL_ATTACK_CHAIN)
		return
	if(!user.mana_pool)
		return SECONDARY_ATTACK_CALL_NORMAL
	var/already_transferring = (user in mana_pool.transferring_to)
	if(already_transferring)
		user.mana_pool.stop_transfer(mana_pool)
		return SECONDARY_ATTACK_CANCEL_ATTACK_CHAIN
	if(!user.is_holding(src))
		return SECONDARY_ATTACK_CANCEL_ATTACK_CHAIN
	var/mana_to_send = input(user, "How much mana do you want to send to the battery? Max Capacity: [mana_pool.maximum_mana_capacity]", "Send Mana") as num
	mana_to_send = CLAMP(mana_to_send, mana_pool.maximum_mana_capacity, 0)
	if(!mana_to_send || QDELETED(user) || QDELETED(src) || !user.is_holding(src))
		return SECONDARY_ATTACK_CANCEL_ATTACK_CHAIN
	var/sent_mana = mana_to_send
	to_chat(user, "sending mana....")
	user.mana_pool.transfer_specific_mana(mana_pool, sent_mana, decrement_budget = TRUE)
	return SECONDARY_ATTACK_CANCEL_ATTACK_CHAIN

/obj/item/mana_battery/mana_crystal
	name = MAGIC_MATERIAL_NAME + " crystal"
	desc = "Crystalized mana." //placeholder desc
	icon = 'icons/obj/crystals.dmi' //placeholder

// Do not use, basetype
/datum/mana_pool/mana_battery/mana_crystal

	maximum_mana_capacity = MANA_CRYSTAL_BASE_MANA_CAPACITY
	softcap = MANA_CRYSTAL_BASE_MANA_CAPACITY

	exponential_decay_divisor = MANA_CRYSTAL_BASE_DECAY_DIVISOR

	max_donation_rate_per_second = BASE_MANA_CRYSTAL_DONATION_RATE

/datum/mana_pool/mana_battery/mana_crystal/New(atom/parent, amount)
	. = ..()
	amount = maximum_mana_capacity

/obj/item/mana_battery/mana_crystal/standard
	name = "stabilized primordial quartz crystal"
	desc = "A stabilized Primordial Quartz Crystal, one of the few objects capable of stably storing mana without binding."
	icon_state = "standard"

/obj/item/mana_battery/mana_crystal/standard/attackby(obj/item/I, mob/living/user, list/modifiers)
	. = ..()
	if(!istype(I, /obj/item/weapon/knife))
		return

	user.visible_message(span_notice("[user] starts to chop up [src]!"), span_notice("You start to chop up [src]!"))
	if(!do_after(user, 3 SECONDS, src))
		return
	new /obj/item/mana_battery/mana_crystal/small (get_turf(src))
	new /obj/item/mana_battery/mana_crystal/small (get_turf(src))
	visible_message(span_notice("Mana flows freely into the newly created crystals!"))
	qdel(src)

/obj/item/mana_battery/mana_crystal/standard/get_initial_mana_pool_type()
	return /datum/mana_pool/mana_battery/mana_crystal/standard

/datum/mana_pool/mana_battery/mana_crystal/standard // basically, just, bog standard, none of the variables need to be changed

/obj/item/mana_battery/mana_crystal/small
	name = "small primordial quartz crystal"
	desc = "A miniaturized Primordial Quartz Crystal, formed using the run-off of cutting larger ones. Able to hold mana still, although not as much as a proper formation."
	icon_state = "small"
	w_class = WEIGHT_CLASS_SMALL

/obj/item/mana_battery/mana_crystal/small/get_initial_mana_pool_type()
	return /datum/mana_pool/mana_battery/mana_crystal/small

/obj/item/mana_battery/mana_crystal/cut
	name = "cut primordial quartz crystal"
	desc = "A cut and shaped Primordial Quartz Crystal, using a standardized square cut. It lacks power until it is slotted into a proper amulet."
	icon_state = "cut"
	w_class = WEIGHT_CLASS_SMALL

/obj/item/mana_battery/mana_crystal/cut/get_initial_mana_pool_type()
	return /datum/mana_pool/mana_battery/mana_crystal/small

/datum/mana_pool/mana_battery/mana_crystal/small
	// half the size of the normal crystal
	maximum_mana_capacity = (MANA_CRYSTAL_BASE_MANA_CAPACITY / 2)
	softcap = (MANA_CRYSTAL_BASE_MANA_CAPACITY / 2)

/datum/mana_pool/mana_star
	// a special type of mana battery that regenerates passively- but cannot be given mana
	maximum_mana_capacity = 400 // 400 by default
	softcap = 400
	amount = 0
	ethereal_recharge_rate = 2 // forgot this was a thing LMFAO

/obj/item/clothing/neck/mana_star
	name = "primordial quartz amulet"
	desc = "A cut Primordial Quartz Crystal placed within a gilded amulet. It naturally draws and fixes mana for your use."
	has_initial_mana_pool = TRUE
	icon = 'icons/obj/crystals.dmi'
	icon_state = "amulet"

/obj/item/clothing/neck/mana_star/Initialize()
	. = ..()
	enchant(/datum/enchantment/mana_regeneration)
	enchant(/datum/enchantment/mana_capacity)

/obj/item/clothing/neck/mana_star/get_initial_mana_pool_type()
	return /datum/mana_pool/mana_star

/obj/item/clothing/neck/mana_star/attack_self(mob/user, list/modifiers) // you can only draw by default.
	. = ..()

	if (.)
		return TRUE

	if (!user.mana_pool)
		return FALSE

	var/already_transferring = (user in mana_pool.transferring_to)
	if (already_transferring)
		mana_pool.stop_transfer(user.mana_pool)
	else
		if(!user.is_holding(src))
			return
		var/mana_to_draw = input(user, "How much mana do you want to draw from the battery? Soft Cap (You will lose mana when above this!): [user.mana_pool.get_softcap()]", "Draw Mana") as num|null
		mana_to_draw = CLAMP(mana_to_draw, mana_pool.maximum_mana_capacity, 0)
		if(!mana_to_draw || QDELETED(user) || QDELETED(src) || !user.is_holding(src))
			return
		var/drawn_mana = mana_to_draw
		to_chat(user, "drawing mana....")
		mana_pool.transfer_specific_mana(user.mana_pool, drawn_mana, decrement_budget = TRUE)

/obj/item/mana_battery/mana_crystal/small/focus //really only exists for debug.
	name = "focused small primordial quartz crystal"
	desc = "A Primordial Quartz Crystal entwined in gold and arcyne meld. You can draw mana from this while casting."
	icon_state = "foci"

/obj/item/mana_battery/mana_crystal/small/focus/get_initial_mana_pool_type()
	return /datum/mana_pool/mana_battery/mana_crystal/small/focus

/obj/item/mana_battery/mana_crystal/small/focus/examine(mob/user)
	. = ..()
	if(mana_pool.network_attunement)
		var/datum/attunement/attunement = mana_pool.network_attunement
		. += span_blue("It is attuned to [initial(attunement.name)]")

/obj/item/mana_battery/mana_crystal/small/focus/attackby(obj/item/I, mob/living/user, list/modifiers)
	. = ..()
	if(!istype(I, /obj/item/gem))
		return

	var/obj/item/gem/gem = I
	if(!gem.attuned)
		return
	user.visible_message(span_notice("[user] starts to attune [src]."), span_notice("You start to attune [src]."))
	if(!do_after(user, 3 SECONDS, src))
		return
	mana_pool.network_attunement = gem.attuned

/obj/item/mana_battery/mana_crystal/small/focus/Initialize(mapload)
	. = ..()
	ADD_TRAIT(src, TRAIT_POOL_AVAILABLE_FOR_CAST, INNATE_TRAIT)

/datum/mana_pool/mana_battery/mana_crystal/small/focus
	intrinsic_recharge_sources = MANA_ALL_LEYLINES | MANA_ALL_PYLONS

/datum/mana_pool/mana_pylon
	// a special type of mana battery that regenerates passively- but cannot be given mana
	maximum_mana_capacity = 400 // 400 by default
	softcap = 400
	amount = 0
	ethereal_recharge_rate = 0
	intrinsic_recharge_sources = MANA_ALL_LEYLINES

/datum/mana_pool/mana_fountain
	maximum_mana_capacity = 1000
	softcap = 1000
	amount = 400
	ethereal_recharge_rate = 0.2
	intrinsic_recharge_sources = MANA_ALL_PYLONS
	draws_beams = TRUE
