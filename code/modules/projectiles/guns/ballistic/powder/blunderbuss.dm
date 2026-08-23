/obj/item/gun/ballistic/powder/wheellock/blunderbuss
	name = "blunderbuss"
	desc = "An older design of long-barrelled firearm that has been made obsolete by the more modern musket. Due to it's poor machining quality it's unable to fire lead balls without maintaining it shape, \
	as such it fires pellets instead. It has a wide spread and is devastating at close range, but is inaccurate and weak at longer ranges. It still maintains a small niche to this day."
	icon = 'icons/roguetown/weapons/64/guns.dmi'
	icon_state = "blunderbuss"
	base_icon_state = "blunderbuss"
	experimental_inhand = TRUE
	experimental_onback = TRUE
	bigboy = TRUE
	SET_BASE_PIXEL(-16, -16)
	inhand_x_dimension = 64
	inhand_y_dimension = 64
	slot_flags = ITEM_SLOT_BACK
	w_class = WEIGHT_CLASS_BULKY
	max_integrity = 100
	sellprice = 400
	item_weight = 4.5 KILOGRAMS

	possible_item_intents = list(/datum/intent/shoot/musket, /datum/intent/shoot/musket/arc, POLEARM_BASH) //TODO: CHECK THIS
	gripped_intents = list(/datum/intent/shoot/musket, /datum/intent/shoot/musket/arc, POLEARM_BASH)
	force = 10
	can_parry = TRUE
	wdefense = AVERAGE_PARRY
	wlength = WLENGTH_LONG

	accepted_magazine_type = /obj/item/ammo_box/magazine/internal/shotgun
	spawn_magazine_type = /obj/item/ammo_box/magazine/internal/shotgun/empty
	weapon_weight = WEAPON_HEAVY
	recoil = 10
	randomspread = 2
	spread = 2
	projectile_damage_multiplier = 3.5

	ramrod_type = /obj/item/ramrod/blunderbuss
	powder_required = 10
	/// The bayonet if affixed
	var/obj/item/weapon/knife/dagger/bayonet/bayonet = null

/obj/item/gun/ballistic/powder/wheellock/blunderbuss/Initialize(mapload)
	bayonet = new(src)
	possible_item_intents = list(/datum/intent/shoot/musket, /datum/intent/shoot/musket/arc, SPEAR_THRUST)
	gripped_intents = list(/datum/intent/shoot/musket, /datum/intent/shoot/musket/arc, POLEARM_THRUST)
	. = ..()
	AddElement(/datum/element/gun_launches_little_guys, throwing_force = 1, throwing_range = 1)

/obj/item/gun/ballistic/powder/wheellock/blunderbuss/Destroy(force)
	if(!QDELETED(bayonet))
		QDEL_NULL(bayonet)
	return ..()

/obj/item/gun/ballistic/powder/wheellock/blunderbuss/Exited(atom/movable/exited, atom/newLoc)
	. = ..()
	if(exited == bayonet)
		bayonet = null

/obj/item/gun/ballistic/powder/wheellock/blunderbuss/update_icon_state()
	. = ..()
	icon_state = "[base_icon_state][cocked ? "_cocked" : ""][ramrod ? "_ramrod" : ""][bayonet ? "_bayonet" : ""]" // God weeps

// We're going to sacrifice unloading the Blunderbuss so you can wield it. Sorry
/obj/item/gun/ballistic/powder/wheellock/blunderbuss/attack_self(mob/living/user, list/modifiers)
	if(SEND_SIGNAL(src, COMSIG_ITEM_ATTACK_SELF, user, modifiers) & COMPONENT_CANCEL_ATTACK_CHAIN)
		return TRUE

/obj/item/gun/ballistic/powder/wheellock/blunderbuss/attackby(obj/item/attacking_item, mob/living/user, list/modifiers)
	. = ..()
	if(!bayonet && istype(attacking_item, /obj/item/weapon/knife/dagger/bayonet))
		balloon_alert(user, "attached!")
		user.transferItemToLoc(attacking_item, src)
		bayonet = attacking_item
		update_appearance(UPDATE_ICON_STATE)

/obj/item/gun/ballistic/powder/wheellock/blunderbuss/attack_hand_secondary(mob/user, list/modifiers)
	. = ..()
	if(. == SECONDARY_ATTACK_CANCEL_ATTACK_CHAIN)
		return

	if(!bayonet)
		return

	balloon_alert(user, "removed!")
	user.put_in_hands(bayonet)
	possible_item_intents = list(/datum/intent/shoot/musket, /datum/intent/shoot/musket/arc, POLEARM_BASH)
	gripped_intents = list(/datum/intent/shoot/musket, /datum/intent/shoot/musket/arc, POLEARM_BASH)
	user.update_a_intents()
	update_appearance(UPDATE_ICON_STATE)

	return SECONDARY_ATTACK_CANCEL_ATTACK_CHAIN

/obj/item/gun/ballistic/powder/wheellock/blunderbuss/pre_attack(atom/target, mob/living/user, list/modifiers)
	. = ..()
	if(bayonet && user.cmode) // Bayonet acts as a proxy attacker if present
		INVOKE_ASYNC(bayonet, TYPE_PROC_REF(/obj/item, melee_attack_chain), user, target, modifiers - RIGHT_CLICK)
		return TRUE

/obj/item/ramrod/blunderbuss
	name = "blunderbuss ramrod"
	icon_state = "ramrod_musket"
	item_weight = 300 GRAMS

/obj/item/gun/ballistic/powder/wheellock/blunderbuss/getonmobprop(tag)
	. = ..()
	if(tag)
		switch(tag)
			if("gen")
				return list(
					"shrink" = 0.5,
					"sx" = -2,
					"sy" = 0,
					"nx" = 11,
					"ny" = 0,
					"wx" = -4,
					"wy" = -4,
					"ex" = 2,
					"ey" = 0,
					"nturn" = 0,
					"sturn" = 0,
					"wturn" = 0,
					"eturn" = 0,
					"nflip" = 0,
					"sflip" = 0,
					"wflip" = 5,
					"eflip" = 0,
					"northabove" = 0,
					"southabove" = 1,
					"eastabove" = 1,
					"westabove" = 0
				)
			if("wielded")
				return list(
					"shrink" = 0.5,
					"sx" = 0,
					"sy" = -3,
					"nx" = 0,
					"ny" = -2,
					"wx" = -4,
					"wy" = -3,
					"ex" = 4,
					"ey" = -3,
					"nturn" = -45,
					"sturn" = 45,
					"wturn" = 45,
					"eturn" = 45,
					"nflip" = 4,
					"sflip" = 0,
					"wflip" = 5,
					"eflip" = 0,
					"northabove" = 0,
					"southabove" = 1,
					"eastabove" = 1,
				"westabove" = 0
				)
			if("onback")
				return list(
					"shrink" = 0.5,
					"sx" = 1,
					"sy" = -1,
					"nx" = 1,
					"ny" = -1,
					"wx" = -1,
					"wy" = 0,
					"ex" = 1,
					"ey" = -1,
					"nturn" = 0,
					"sturn" = 0,
					"wturn" = 0,
					"eturn" = 0,
					"nflip" = 5,
					"sflip" = 5,
					"wflip" = 5,
					"eflip" = 5,
					"northabove" = 1,
					"southabove" = 0,
					"eastabove" = 0,
					"westabove" = 0
				)
