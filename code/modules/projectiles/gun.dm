
#define DUALWIELD_PENALTY_EXTRA_MULTIPLIER 1.4

/obj/item/gun
	name = "gun"
	desc = ""
	icon = 'icons/obj/guns/projectile.dmi'
	icon_state = "detective"
	item_state = "gun"
	flags_1 =  CONDUCT_1
	slot_flags = ITEM_SLOT_HIP
	w_class = WEIGHT_CLASS_NORMAL
	possible_item_intents = list(INTENT_GENERIC, RANGED_FIRE)
	throwforce = 5
	throw_speed = 1
	throw_range = 5
	force = 5
	item_flags = NEEDS_PERMIT
	attack_verb = list("struck", "hit", "bashed")

	var/fire_sound = 'sound/blank.ogg'
	var/vary_fire_sound = TRUE
	var/fire_sound_volume = 50
	var/dry_fire_sound = 'sound/blank.ogg'
	var/recoil = 0						//boom boom shake the room
	var/clumsy_check = TRUE
	var/obj/item/ammo_casing/chambered = null
	trigger_guard = TRIGGER_GUARD_NORMAL	//trigger guard on the weapon, hulks can't fire them with their big meaty fingers

	var/spread = 0						//Spread induced by the gun itself.
	var/randomspread = 1				//Set to 0 for shotguns. This is used for weapons that don't fire all their bullets at once.

	var/ammo_x_offset = 0 //used for positioning ammo count overlay on sprite
	var/ammo_y_offset = 0
	var/flight_x_offset = 0
	var/flight_y_offset = 0

	var/automatic = 0 //can gun use it, 0 is no, anything above 0 is the delay between clicks in ds
	var/pb_knockback = 0

/obj/item/gun/Initialize()
	. = ..()
	AddElement(/datum/element/update_icon_updates_onmob)

/obj/item/gun/Destroy()
	if(chambered) //Not all guns are chambered (EMP'ed energy guns etc)
		QDEL_NULL(chambered)
	return ..()

/obj/item/gun/handle_atom_del(atom/A)
	if(A == chambered)
		chambered = null
		update_appearance()
	return ..()

//called after the gun has successfully fired its chambered ammo.
/obj/item/gun/proc/process_chamber()
	return FALSE

//check if there's enough ammo/energy/whatever to shoot one time
//i.e if clicking would make it shoot
/obj/item/gun/proc/can_shoot()
	return TRUE

/obj/item/gun/proc/shoot_with_empty_chamber(mob/living/user as mob|obj)
	to_chat(user, "<span class='danger'>*click*</span>")
	playsound(src, dry_fire_sound, 30, TRUE)


/obj/item/gun/proc/shoot_live_shot(mob/living/user as mob|obj, pointblank = 0, mob/pbtarget = null, message = 1)
	if(recoil)
		shake_camera(user, recoil + 1, recoil)

	playsound(user, fire_sound, fire_sound_volume, vary_fire_sound)
	if(message)
		user.visible_message("<span class='danger'>[user] shoots [src]!</span>", \
						"<span class='danger'>I shoot [src]!</span>", \
						COMBAT_MESSAGE_RANGE)

/obj/item/gun/afterattack(atom/target, mob/living/user, proximity_flag, list/modifiers)
	. = ..()
	if(!target)
		return
	if(!user?.used_intent.tranged) //melee attack
		return
	if(proximity_flag) //It's adjacent, is the user, or is on the user's person
		if(target in user.contents) //can't shoot stuff inside us.
			return
		if(!ismob(target)) //melee attack
			return
		if(target == user && user.zone_selected != BODY_ZONE_PRECISE_MOUTH) //so we can't shoot ourselves (unless mouth selected)
			return

	if(istype(user))//Check if the user can use the gun, if the user isn't alive(turrets) assume it can.
		var/mob/living/L = user
		if(!can_trigger_gun(L))
			return

//	if(flag)
//		if(user.zone_selected == BODY_ZONE_PRECISE_MOUTH)
//			handle_suicide(user, target, modifiers)
//			return

	if(!can_shoot()) //Just because you can pull the trigger doesn't mean it can shoot.
		shoot_with_empty_chamber(user)
		return

	return process_fire(target, user, TRUE, modifiers, null, 0)


/obj/item/gun/proc/recharge_newshot()
	return


/obj/item/gun/proc/process_fire(atom/target, mob/living/user, message = TRUE, list/modifiers, zone_override, bonus_spread = 0)
	if(user)
		SEND_SIGNAL(user, COMSIG_MOB_FIRED_GUN, src, target, modifiers, zone_override)

	SEND_SIGNAL(src, COMSIG_GUN_FIRED, user, target, modifiers, zone_override)

	add_fingerprint(user)

	var/sprd = 0
	var/randomized_gun_spread = 0
	if(spread)
		randomized_gun_spread =	rand(0,spread)
	var/randomized_bonus_spread = rand(0, bonus_spread)

	if(chambered)
		if(HAS_TRAIT(user, TRAIT_PACIFISM)) // If the user has the pacifist trait, then they won't be able to fire [src] if the round chambered inside of [src] is lethal.
			if(chambered.harmful) // Is the bullet chambered harmful?
				to_chat(user, "<span class='warning'>[src] is lethally chambered! You don't want to risk harming anyone...</span>")
				return
		sprd = round((rand() - 0.5) * DUALWIELD_PENALTY_EXTRA_MULTIPLIER * (randomized_gun_spread + randomized_bonus_spread))
		before_firing(target,user)
		if(!chambered.fire_casing(target, user, modifiers, , FALSE, zone_override, sprd, src))
			shoot_with_empty_chamber(user)
			return
		else
			shoot_live_shot(user, 0, target, message)
	else
		shoot_with_empty_chamber(user)
		return
	process_chamber()
	update_appearance()

	if(user)
		user.update_inv_hands()
	SSblackbox.record_feedback("tally", "gun_fired", 1, type)
	return TRUE


/obj/item/gun/attackby(obj/item/I, mob/user, list/modifiers)
	if(!user.used_intent.tranged)
		return ..()
	else
		return ..()

/obj/item/gun/proc/handle_suicide(mob/living/carbon/human/user, mob/living/carbon/human/target, list/modifiers, bypass_timer)
	if(!ishuman(user) || !ishuman(target))
		return

	if(user == target)
		target.visible_message("<span class='warning'>[user] sticks [src] in [user.p_their()] mouth, ready to pull the trigger...</span>", \
			"<span class='danger'>I stick [src] in your mouth, ready to pull the trigger...</span>")
	else
		target.visible_message("<span class='warning'>[user] points [src] at [target]'s head, ready to pull the trigger...</span>", \
			"<span class='danger'>[user] points [src] at your head, ready to pull the trigger...</span>")

	if(!bypass_timer && (!do_after(user, 12 SECONDS, target) || user.zone_selected != BODY_ZONE_PRECISE_MOUTH))
		if(user)
			if(user == target)
				user.visible_message("<span class='notice'>[user] decided not to shoot.</span>")
			else if(target && target.Adjacent(user))
				target.visible_message("<span class='notice'>[user] has decided to spare [target]</span>", "<span class='notice'>[user] has decided to spare your life!</span>")
		return

	target.visible_message("<span class='warning'>[user] pulls the trigger!</span>", "<span class='danger'>[(user == target) ? "You pull" : "[user] pulls"] the trigger!</span>")

	if(chambered && chambered.BB)
		chambered.BB.damage *= 5

	process_fire(target, user, TRUE, modifiers, BODY_ZONE_HEAD)

//Happens before the actual projectile creation
/obj/item/gun/proc/before_firing(atom/target,mob/user)
	return

/obj/item/gun/get_examine_string(mob/user, thats = FALSE)
	return "[thats? "That's ":""]<b>[get_examine_name(user)]</b>"

#undef DUALWIELD_PENALTY_EXTRA_MULTIPLIER
