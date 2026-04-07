/**
 * A file for muzzle loading powder gun parents
 *
 * This would include:
 * * Matchlocks
 * * Flintlocks
 * * Wheellocks
 *
 * Operation
 *
 * Flint-lock
 * Powder -> Ball -> Ramrod -> Cock -> Fire
 *
 * Wheel-lock
 * Uncock -> Wind -> Powder -> Ball -> Ramrod -> Cock -> Fire
 */

/// A powder, muzzle loaded firearm that requires cocking and ramming. Essentially a flintlock in operation.
/obj/item/gun/ballistic/powder
	abstract_type = /obj/item/gun/ballistic/powder
	name = "muzzle loader"

	load_sound = 'sound/foley/nockarrow.ogg'
	fire_sound = 'sound/combat/Ranged/muskshoot.ogg'
	equip_sound = 'sound/foley/gun_equip.ogg'
	pickup_sound = 'sound/foley/gun_equip.ogg'
	drop_sound = 'sound/foley/gun_drop.ogg'
	bolt_type = BOLT_TYPE_NO_BOLT
	internal_magazine = TRUE
	trigger_guard = TRIGGER_GUARD_ALLOW_ALL
	cartridge_wording = "ball"
	accepted_magazine_type = /obj/item/ammo_box/magazine/internal/barrel
	spawn_magazine_type = /obj/item/ammo_box/magazine/internal/barrel/empty
	empty_indicator = FALSE

	// Muzzle loaders require a ramrod to function
	/// Type of ramrod to insert on init
	var/ramrod_type = /obj/item/ramrod
	/// The ramrod if it's currently attached to the gun
	var/obj/item/ramrod/ramrod = null
	/// Base time to ram down the bullet
	var/ram_time = 5.5 SECONDS
	/// Whether the ball has been rammed in
	var/bullet_rammed = FALSE
	/// Amount of blast powder required for a basic shot
	/// Ideally a mulitple of 5 so you can actually hit it with containers
	var/powder_required = 5
	/// Delay before firing after pulling trigger (Find a way to move this up and not sleep)
	var/trigger_delay = 0.5 SECONDS
	// Currently there is no "matchlock" or similar weapons, change this var if that happens
	/// If the striker is cocked into the firing position
	var/cocked = FALSE

/obj/item/gun/ballistic/powder/Initialize(mapload)
	if(ramrod_type)
		ramrod = new ramrod_type(src)
	create_reagents(20)
	return ..()

/obj/item/gun/ballistic/powder/Destroy(force)
	if(!QDELETED(ramrod))
		QDEL_NULL(ramrod)
	return ..()

/obj/item/gun/ballistic/powder/Exited(atom/movable/exited, atom/newLoc)
	. = ..()
	if(exited == ramrod)
		ramrod = null

/obj/item/gun/ballistic/powder/clear_chambered(datum/source)
	. = ..()
	bullet_rammed = FALSE

/obj/item/gun/ballistic/powder/examine(mob/user)
	. = ..()

	if(!isnull(ramrod))
		. += span_info("The ramrod is seated.")

	if(cocked)
		. += span_warning("The striker is in firing position.")

	if(item_flags & IN_STORAGE)
		return

	if(item_flags & IN_INVENTORY && !user.is_holding(src))
		return
	else if(get_dist(user, src) > 1)
		return

	if(chambered)
		var/rammed_message = bullet_rammed ? "rammed down" : "loose in the barrel and can be removed"
		. += span_info("\The [chambered] is [rammed_message].")
		. += span_info("If there is powder in the barrel, \the [chambered] is covering it.")
		return

	if(!reagents?.total_volume)
		return

	var/powder_amount = reagents.get_reagent_amount(/datum/reagent/blastpowder)
	if(!powder_amount)
		. += span_warning("Whatever is in the barrel, it's not powder.")
		return

	var/extra_string = "loaded"
	if(powder_amount > powder_required)
		extra_string += span_boldwarning("over-loaded")
	else if (powder_amount < powder_required)
		extra_string += span_warning("under-loaded")

	. += span_notice("The barrel is [extra_string] with powder.")

/obj/item/gun/ballistic/powder/update_icon_state()
	. = ..()
	icon_state = "[base_icon_state][cocked ? "_cocked" : ""][!isnull(ramrod) ? "_ramrod" : ""]"

/obj/item/gun/ballistic/powder/attackby(obj/item/attacking_item, mob/living/user, list/modifiers)
	. = ..()
	if(istype(attacking_item, /obj/item/ramrod))
		do_ram(attacking_item, user)
		return

	if(isreagentcontainer(attacking_item))
		if(reagents.holder_full())
			balloon_alert(user, "full!")
			return
		var/obj/item/reagent_containers/container = attacking_item
		if(!container.reagents?.total_volume)
			balloon_alert(user, "empty!")
			return
		var/transfer_amount = container.amount_per_transfer_from_this
		// The unskilled can fill it but will over/under fill
		if(GET_MOB_SKILL_VALUE(user, /datum/attribute/skill/combat/firearms) < 10)
			transfer_amount += rand(-2, 5)
		playsound(src, 'sound/foley/gunpowder_fill.ogg', 80)
		container.reagents.trans_to(src, transfer_amount)

/obj/item/gun/ballistic/powder/proc/do_ram(obj/item/ramrod/rod, mob/living/user)
	if(!istype(rod))
		return

	var/skill = GET_MOB_SKILL_VALUE(user, /datum/attribute/skill/combat/firearms)
	if(skill < 10)
		balloon_alert(user, "don't know how!")
		return

	if(!chambered)
		balloon_alert(user, "nothing to ram!")
		return

	if(!reagents.get_reagent_amount(/datum/reagent/blastpowder))
		balloon_alert(user, "no powder!")
		return

	if(bullet_rammed)
		return

	var/real_ram_time = ram_time - ((skill / 60) * (0.75 * ram_time))
	if(!do_after(user, real_ram_time, src))
		return

	balloon_alert(user, "rammed!")
	playsound(src, 'sound/foley/nockarrow.ogg', 100, FALSE)
	bullet_rammed = TRUE

/obj/item/gun/ballistic/powder/attackby_secondary(obj/item/attacking_item, mob/living/user, list/modifiers)
	. = ..()
	if(. == SECONDARY_ATTACK_CANCEL_ATTACK_CHAIN)
		return

	if(!istype(attacking_item, /obj/item/ramrod))
		return

	if(!isnull(ramrod))
		return SECONDARY_ATTACK_CANCEL_ATTACK_CHAIN

	if(user.transferItemToLoc(attacking_item, src))
		ramrod = attacking_item
		update_appearance(UPDATE_ICON)

	return SECONDARY_ATTACK_CANCEL_ATTACK_CHAIN

/obj/item/gun/ballistic/powder/attack_self(mob/living/user, list/modifiers)
	if(bullet_rammed) // If you rammed it down you have to fire
		balloon_alert(user, "it's stuck!")
		return

	return ..()

/obj/item/gun/ballistic/powder/attack_self_secondary(mob/user, list/modifiers)
	. = ..()
	if(. == SECONDARY_ATTACK_CANCEL_ATTACK_CHAIN)
		return

	if(!user.is_holding(src))
		balloon_alert(user, "must hold!")
		return SECONDARY_ATTACK_CANCEL_ATTACK_CHAIN

	if(cocked)
		balloon_alert(user, "uncocked")
	else
		balloon_alert(user, "cocked!")

	cocked = !cocked
	update_appearance(UPDATE_ICON)
	return SECONDARY_ATTACK_CANCEL_ATTACK_CHAIN

/obj/item/gun/ballistic/powder/MiddleClick(mob/living/user, list/modifiers)
	. = ..()
	if(!istype(user) || !Adjacent(user))
		return

	if(isnull(ramrod))
		return

	if(!user.put_in_hands(ramrod))
		balloon_alert(user, "can't remove!")
		return

	ramrod = null
	update_appearance(UPDATE_ICON)

/obj/item/gun/ballistic/powder/can_shoot(mob/living/user)
	return (..() && cocked)

/obj/item/gun/ballistic/powder/shoot_with_empty_chamber(mob/living/user)
	if(cocked)
		playsound(src, 'sound/combat/Ranged/flint_click.ogg', 50)

/obj/item/gun/ballistic/powder/before_firing(atom/target, mob/user)
	. = ..()
	if(trigger_delay) // Sleeps process_fire which is ehhhh
		playsound(src, 'sound/combat/Ranged/flint_click.ogg', 50)
		sleep(trigger_delay)

/obj/item/gun/ballistic/powder/modify_projectile(mob/living/user, atom/target, obj/projectile/modified)
	. = ..()

	if(user.client?.chargedprog >= 100)
		modified.accuracy += 15 //better accuracy for fully aiming

	var/perception = GET_MOB_ATTRIBUTE_VALUE(user, STAT_PERCEPTION)
	if(perception > 8)
		modified.accuracy += (perception - 8) * 4 //each point of perception above 8 increases standard accuracy by 4.
		modified.bonus_accuracy += (perception - 8) //Also, increases bonus accuracy by 1, which cannot fall off due to distance.

	modified.bonus_accuracy += (GET_MOB_SKILL_VALUE_OLD(user, /datum/attribute/skill/combat/firearms) * 3) //+3 accuracy per level in firearms

	if(!bullet_rammed)
		modified.range = 5
		modified.damage *= 0.3
		modified.speed *= 2
		return

	var/powder = reagents.get_reagent_amount(/datum/reagent/blastpowder)
	var/filled_percent = powder / powder_required
	if(filled_percent > 1) // Over
		take_damage(15 * filled_percent)
		modified.damage *= 1 + (filled_percent / (1 + filled_percent))
		modified.speed /= min(2, filled_percent)
	else if(filled_percent < 1) // Under
		modified.damage /= max(0.3, filled_percent)
		modified.speed *= max(0.5, filled_percent)

/obj/item/gun/ballistic/powder/shoot_live_shot(mob/living/user, pointblank, mob/pbtarget, message)
	. = ..()

	for(var/mob/living/living in get_hearers_in_range(3, src))
		living.playsound_local(get_turf(user), 'sound/foley/tinnitus.ogg', 60, FALSE) // muh realism or something

	new /obj/effect/particle_effect/smoke(get_step(user, user.dir))

	for(var/mob/M as anything in GLOB.player_list)
		if(get_dist(M, user) > world.view)
			continue

		if(!is_in_zweb(M.z, z))
			continue

		var/turf/M_turf = get_turf(M)
		if(M_turf)
			M.playsound_local(M_turf, fire_sound, 100, 1, get_rand_frequency())

/obj/item/gun/ballistic/powder/postfire_empty_checks(last_shot_succeeded)
	. = ..()
	if(last_shot_succeeded)
		reagents.remove_all(reagents.total_volume)
	cocked = FALSE
	update_appearance(UPDATE_ICON)

/obj/item/ramrod
	name = "ramrod"
	desc = "A rod designed to ram things down gun barrels."
	icon = 'icons/roguetown/items/misc.dmi'
	icon_state = "ramrod"
	item_weight = 150 GRAMS

/// A wheel-lock gun that requires winding, cocking and ramming
/obj/item/gun/ballistic/powder/wheellock
	abstract_type = /obj/item/gun/ballistic/powder/wheellock
	name = "wheelock gun"

	/// Base winding time
	var/winding_time = 3.5 SECONDS
	/// The wheel-lock is wound up and ready to fire
	var/wound = FALSE

/obj/item/gun/ballistic/powder/wheellock/examine(mob/user)
	. = ..()
	if(wound)
		. += span_info("The wheel is wound.")

/obj/item/gun/ballistic/powder/wheellock/attack_hand_secondary(mob/user, list/modifiers)
	. = ..()
	if(. == SECONDARY_ATTACK_CANCEL_ATTACK_CHAIN)
		return

	var/skill = GET_MOB_SKILL_VALUE(user, /datum/attribute/skill/combat/firearms)
	if(skill < 10)
		balloon_alert(user, "don't know how!")
		return SECONDARY_ATTACK_CANCEL_ATTACK_CHAIN

	if(!user.is_holding(src))
		balloon_alert(user, "must hold!")
		return SECONDARY_ATTACK_CANCEL_ATTACK_CHAIN

	if(cocked)
		balloon_alert(user, "uncock first!")
		return SECONDARY_ATTACK_CANCEL_ATTACK_CHAIN

	if(wound)
		balloon_alert(user, "unwound.")
	else
		var/true_winding_time = winding_time - ((skill / 60) * (0.75 * winding_time)) // Up to 75% Decrease
		if(!do_after(user, true_winding_time, src))
			return
		playsound(src, 'sound/foley/winding.ogg', 80)
		balloon_alert(user, "wound!")

	wound = !wound
	update_appearance(UPDATE_ICON)
	return SECONDARY_ATTACK_CANCEL_ATTACK_CHAIN

/obj/item/gun/ballistic/powder/wheellock/can_shoot(mob/living/user)
	return (..() && wound)

/obj/item/gun/ballistic/powder/wheellock/postfire_empty_checks(last_shot_succeeded)
	wound = FALSE
	return ..()
