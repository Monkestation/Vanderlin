/obj/item/proc/can_trigger_gun(mob/living/user)
	if(!user.can_use_guns(src))
		return FALSE
	return TRUE

///Subtype for any kind of ballistic gun
///This has a shitload of vars on it, and I'm sorry for that, but it does make making new subtypes really easy
/obj/item/gun/ballistic
	abstract_type = /obj/item/gun/ballistic
	name = "projectile gun"
	desc = ""
	icon_state = "pistol"
	w_class = WEIGHT_CLASS_NORMAL

	///sound when inserting magazine
	var/load_sound = 'sound/blank.ogg'
	///sound when inserting an empty magazine
	var/load_empty_sound = 'sound/blank.ogg'
	///volume of loading sound
	var/load_sound_volume = 40
	///whether loading sound should vary
	var/load_sound_vary = TRUE
	///sound of racking
	var/rack_sound = 'sound/blank.ogg'
	///volume of racking
	var/rack_sound_volume = 60
	///whether racking sound should vary
	var/rack_sound_vary = TRUE
	///sound of when the bolt is locked back manually
	var/lock_back_sound = 'sound/blank.ogg'
	///volume of lock back
	var/lock_back_sound_volume = 60
	///whether lock back varies
	var/lock_back_sound_vary = TRUE
	///Sound of ejecting a magazine
	var/eject_sound = 'sound/blank.ogg'
	///sound of ejecting an empty magazine
	var/eject_empty_sound = 'sound/blank.ogg'
	///volume of ejecting a magazine
	var/eject_sound_volume = 40
	///whether eject sound should vary
	var/eject_sound_vary = TRUE
	///sound of dropping the bolt or releasing a slide
	var/bolt_drop_sound = 'sound/blank.ogg'
	///volume of bolt drop/slide release
	var/bolt_drop_sound_volume = 60
	///empty alarm sound (if enabled)
	var/empty_alarm_sound = 'sound/blank.ogg'
	///empty alarm volume sound
	var/empty_alarm_volume = 70
	///whether empty alarm sound varies
	var/empty_alarm_vary = TRUE

	/// What type (includes subtypes) of magazine will this gun accept being put into it
	var/obj/item/ammo_box/magazine/accepted_magazine_type = /obj/item/ammo_box/magazine/internal/crossbow
	///Whether the gun will spawn loaded with a magazine
	var/spawn_with_magazine = TRUE
	/// Change this if the gun should spawn with a different magazine type to what accepted_magazine_type defines. Will create errors if not a type or subtype of accepted magazine.
	var/obj/item/ammo_box/magazine/spawn_magazine_type
	///Whether the sprite has a visible magazine or not
	var/mag_display = FALSE
	///Whether the sprite has a visible ammo display or not
	var/mag_display_ammo = FALSE
	///Whether the sprite has a visible indicator for being empty or not.
	var/empty_indicator = FALSE
	///Whether the gun alarms when empty or not.
	var/empty_alarm = FALSE
	///Whether the gun supports multiple special mag types
	var/special_mags = FALSE

	/**
	* The bolt type controls how the gun functions, and what iconstates you'll need to represent those functions.
	* BOLT_TYPE_STANDARD - The Slide doesn't lock back.  Clicking on it will only cycle the bolt.  Only 1 sprite.
	* BOLT_TYPE_OPEN - Same as standard, but it fires directly from the magazine - No need to rack.  Doesn't hold the bullet when you drop the mag.
	* BOLT_TYPE_LOCKING - This is most handguns and bolt action rifles.  The bolt will lock back when it's empty.  You need yourgun_bolt and yourgun_bolt_locked icon states.
	* BOLT_TYPE_NO_BOLT - This is shotguns and revolvers.  clicking will dump out all the bullets in the gun, spent or not.
	* see combat.dm defines for bolt types: BOLT_TYPE_STANDARD; BOLT_TYPE_LOCKING; BOLT_TYPE_OPEN; BOLT_TYPE_NO_BOLT
	**/
	var/bolt_type = BOLT_TYPE_STANDARD
	///Used for locking bolt and open bolt guns. Set a bit differently for the two but prevents firing when true for both.
	var/bolt_locked = FALSE
	///Whether the gun has to be racked each shot or not.
	var/semi_auto = TRUE
	///Actual magazine currently contained within the gun
	var/obj/item/ammo_box/magazine/magazine
	///whether the gun ejects the chambered casing
	var/casing_ejector = TRUE
	///Whether the gun has an internal magazine or a detatchable one. Overridden by BOLT_TYPE_NO_BOLT.
	var/internal_magazine = FALSE
	///Phrasing of the bolt in examine and notification messages; ex: bolt, slide, etc.
	var/bolt_wording = "bolt"
	///Phrasing of the magazine in examine and notification messages; ex: magazine, box, etx
	var/magazine_wording = "magazine"
	///Phrasing of the cartridge in examine and notification messages; ex: bullet, shell, dart, etc.
	var/cartridge_wording = "bullet"
	///length between individual racks
	var/rack_delay = 5
	///time of the most recent rack, used for cooldown purposes
	var/recent_rack = 0
	///Whether the gun can be tacloaded by slapping a fresh magazine directly on it
	var/tac_reloads = TRUE
	///Whether we need to hold the gun to load it. FALSE means we can load it literally anywhere. Important for weapons like bows.
	var/must_hold_to_load = FALSE
	/// Check if you are able to see if a weapon has a bullet loaded in or not.
	var/hidden_chambered = FALSE
	var/verbage = "load"

/obj/item/gun/ballistic/Initialize(mapload)
	. = ..()
	if(!spawn_magazine_type)
		spawn_magazine_type = accepted_magazine_type

	if(!spawn_with_magazine)
		bolt_locked = TRUE
		update_appearance()
		return

	if(!magazine)
		magazine = new spawn_magazine_type(src)
		if(!istype(magazine, accepted_magazine_type))
			CRASH("[src] spawned with a magazine type that isn't allowed by its accepted_magazine_type!")

	if(bolt_type == BOLT_TYPE_STANDARD || internal_magazine) //Internal magazines shouldn't get magazine + 1.
		chamber_round()
	else
		chamber_round(replace_new_round = TRUE)

	update_appearance()

/obj/item/gun/ballistic/Destroy()
	QDEL_NULL(magazine)
	return ..()

/obj/item/gun/ballistic/update_overlays()
	. = ..()
	if(QDELETED(src))
		return

	var/used_state = initial(icon_state)
	if(bolt_type == BOLT_TYPE_LOCKING)
		. += "[used_state]_bolt[bolt_locked ? "_locked" : ""]"

	if(bolt_type == BOLT_TYPE_OPEN && bolt_locked)
		. += "[used_state]_bolt"

	if(!chambered && empty_indicator)
		. += "[used_state]_empty"

	if(!magazine)
		return

	if(!special_mags)
		. += "[used_state]_mag"
		var/capacity_number = 0
		switch(get_ammo() / magazine.max_ammo)
			if(0.2 to 0.39)
				capacity_number = 20
			if(0.4 to 0.59)
				capacity_number = 40
			if(0.6 to 0.79)
				capacity_number = 60
			if(0.8 to 0.99)
				capacity_number = 80
			if(1.0)
				capacity_number = 100
		if(capacity_number)
			. += "[used_state]_mag_[capacity_number]"
		return

	. += "[used_state]_mag_[initial(magazine.icon_state)]"
	if(!magazine.ammo_count())
		. += "[used_state]_mag_empty"

/obj/item/gun/ballistic/after_firing(atom/target, mob/living/user, empty_chamber = TRUE, from_firing = TRUE, chamber_next_round = TRUE)
	// Experience gain
	if(!from_firing)
		return

	var/boon = user.get_learning_boon(associated_skill)
	var/amt2raise = GET_MOB_ATTRIBUTE_VALUE(user, STAT_INTELLIGENCE) / 2
	user.adjust_experience(associated_skill, amt2raise * boon, FALSE)

	// Rechambering cycle
	if(!semi_auto)
		return

	var/obj/item/ammo_casing/casing = chambered //Find chambered round
	if(istype(casing)) //there's a chambered round
		if(QDELING(casing))
			stack_trace("Trying to move a qdeleted casing of type [casing.type]!")
			clear_chambered()
		else if(casing_ejector || !from_firing)
			casing.forceMove(drop_location()) //Eject casing onto ground.
			if(!QDELETED(casing))
				casing.bounce_away(TRUE)
		else if(empty_chamber)
			clear_chambered()

	if(chamber_next_round && (magazine?.max_ammo > 1))
		chamber_round()

///Used to chamber a new round and eject the old one
/obj/item/gun/ballistic/proc/chamber_round(spin_cylinder, replace_new_round)
	if(chambered || !magazine)
		return

	if(!magazine.ammo_count())
		return

	chambered = (bolt_type == BOLT_TYPE_OPEN && !bolt_locked) || bolt_type == BOLT_TYPE_NO_BOLT ? magazine.get_and_shuffle_round() : magazine.get_round()
	if (bolt_type != BOLT_TYPE_OPEN && !(internal_magazine && bolt_type == BOLT_TYPE_NO_BOLT))
		chambered.forceMove(src)
	else
		RegisterSignal(chambered, COMSIG_MOVABLE_MOVED, PROC_REF(clear_chambered))

	if(replace_new_round)
		magazine.give_round(new chambered.type)

/obj/item/gun/ballistic/proc/clear_chambered(datum/source)
	SIGNAL_HANDLER
	UnregisterSignal(chambered, COMSIG_MOVABLE_MOVED)
	chambered = null

///updates a bunch of racking related stuff and also handles the sound effects and the like
/obj/item/gun/ballistic/proc/rack(mob/living/user)
	if(bolt_type == BOLT_TYPE_NO_BOLT) //If there's no bolt, nothing to rack
		return

	if(bolt_type == BOLT_TYPE_OPEN)
		if(!bolt_locked) //If it's an open bolt, racking again would do nothing
			if (user)
				balloon_alert(user, "[bolt_wording] already cocked!")
			return
		bolt_locked = FALSE

	if(user)
		balloon_alert(user, "[bolt_wording] racked")

	// bad code
	after_firing(user = user, empty_chamber = !chambered, from_firing = FALSE)
	if(bolt_type == BOLT_TYPE_LOCKING && !chambered)
		bolt_locked = TRUE
		playsound(src, lock_back_sound, lock_back_sound_volume, lock_back_sound_vary)
	else
		playsound(src, rack_sound, rack_sound_volume, rack_sound_vary)

	update_appearance()

///Drops the bolt from a locked position
/obj/item/gun/ballistic/proc/drop_bolt(mob/user = null)
	playsound(src, bolt_drop_sound, bolt_drop_sound_volume, FALSE)
	if(user)
		balloon_alert(user, "[bolt_wording] dropped")

	chamber_round()
	bolt_locked = FALSE
	update_appearance()

///Handles all the logic needed for magazine insertion
/obj/item/gun/ballistic/proc/insert_magazine(mob/user, obj/item/ammo_box/magazine/AM, display_message = TRUE)
	if(!istype(AM, accepted_magazine_type))
		balloon_alert(user, "[AM.name] doesn't fit!")
		return FALSE

	if(!user.transferItemToLoc(AM, src))
		to_chat(user, span_warning("You cannot seem to get [src] out of your hands!"))
		return FALSE

	magazine = AM
	if(display_message)
		balloon_alert(user, "[magazine_wording] loaded")

	if(magazine.ammo_count())
		playsound(src, load_sound, load_sound_volume, load_sound_vary)
	else
		playsound(src, load_empty_sound, load_sound_volume, load_sound_vary)

	if(bolt_type == BOLT_TYPE_OPEN && !bolt_locked)
		chamber_round()

	update_appearance()

	return TRUE

///Handles all the logic of magazine ejection, if tac_load is set that magazine will be tacloaded in the place of the old eject
/obj/item/gun/ballistic/proc/eject_magazine(mob/user, display_message = TRUE, obj/item/ammo_box/magazine/tac_load = null)
	if(bolt_type == BOLT_TYPE_OPEN)
		chambered = null
	if (magazine.ammo_count())
		playsound(src, load_sound, load_sound_volume, load_sound_vary)
	else
		playsound(src, load_empty_sound, load_sound_volume, load_sound_vary)
	magazine.forceMove(drop_location())
	var/obj/item/ammo_box/magazine/old_mag = magazine
	if (tac_load)
		if (insert_magazine(user, tac_load, FALSE))
			balloon_alert(user, "[magazine_wording] swapped")
		else
			to_chat(user, "<span class='warning'>I dropped the old [magazine_wording], but the new one doesn't fit. How embarrassing.</span>")
			magazine = null
	else
		magazine = null
	user.put_in_hands(old_mag)
	old_mag.update_appearance()
	if (display_message)
		balloon_alert(user, "[magazine_wording] unloaded")
	update_appearance()

/obj/item/gun/ballistic/can_shoot(mob/living/user)
	return chambered

/obj/item/gun/ballistic/attackby(obj/item/A, mob/user, list/modifiers)
	. = ..()
	if(.)
		return
	if(!internal_magazine && istype(A, /obj/item/ammo_box/magazine))
		if(!magazine)
			insert_magazine(user, A)
			return

		if(tac_reloads)
			eject_magazine(user, FALSE, A)
			return

		balloon_alert(user, "already loaded!")
		return

	if(isammocasing(A) || istype(A, /obj/item/ammo_box))
		if(bolt_type == BOLT_TYPE_NO_BOLT || internal_magazine)
			if(chambered && !chambered.loaded_projectile)
				chambered.forceMove(drop_location())
				if(length(magazine?.stored_ammo) && chambered != magazine.stored_ammo[1])
					magazine.stored_ammo -= chambered
				chambered = null
			var/num_loaded = magazine.try_load(user, A, silent = TRUE)
			if(num_loaded)
				balloon_alert(user, "[num_loaded] [cartridge_wording]\s loaded")
				playsound(src, load_sound, load_sound_volume, load_sound_vary)
				if (chambered == null && bolt_type == BOLT_TYPE_NO_BOLT)
					chamber_round()
				A.update_appearance()
				update_appearance()
			return

	user.update_inv_hands()
	return FALSE

/obj/item/gun/ballistic/AltClick(mob/user, list/modifiers)
	if (unique_reskin && !current_skin && user.can_perform_action(src, FORBID_TELEKINESIS_REACH))
		reskin_obj(user)
		return

///Prefire empty checks for the bolt drop
/obj/item/gun/ballistic/proc/prefire_empty_checks()
	if (!chambered && !get_ammo())
		if (bolt_type == BOLT_TYPE_OPEN && !bolt_locked)
			bolt_locked = TRUE
			playsound(src, bolt_drop_sound, bolt_drop_sound_volume)
			update_appearance()

///postfire empty checks for bolt locking and sound alarms
/obj/item/gun/ballistic/proc/postfire_empty_checks(last_shot_succeeded)
	if (!chambered && !get_ammo())
		if (empty_alarm && last_shot_succeeded)
			playsound(src, empty_alarm_sound, empty_alarm_volume, empty_alarm_vary)
			update_appearance()
		if (last_shot_succeeded && bolt_type == BOLT_TYPE_LOCKING)
			bolt_locked = TRUE
			update_appearance()

/obj/item/gun/ballistic/afterattack(atom/target, mob/living/user, proximity_flag, list/modifiers)
	prefire_empty_checks()
	. = ..() //The gun actually firing
	postfire_empty_checks(.)

/obj/item/gun/ballistic/attack_hand(mob/user)
	if(!internal_magazine && loc == user && user.is_holding(src) && magazine)
		eject_magazine(user)
		return
	return ..()

/obj/item/gun/ballistic/attack_self(mob/living/user, list/modifiers)
	if(!internal_magazine && magazine)
		if(!magazine.ammo_count())
			eject_magazine(user)
			return

	if(bolt_type == BOLT_TYPE_NO_BOLT)
		unload_ammo(user)
		return

	if(bolt_type == BOLT_TYPE_LOCKING && bolt_locked)
		drop_bolt(user)
		return

	if(recent_rack > world.time)
		return

	recent_rack = world.time + rack_delay
	rack(user)

/obj/item/gun/ballistic/proc/unload_ammo(mob/living/user, forced = FALSE)
	var/num_unloaded = 0
	for(var/obj/item/ammo_casing/casing as anything in get_ammo_list(FALSE))
		casing.forceMove(drop_location())
		casing.bounce_away(FALSE, NONE)
		num_unloaded++

	if(!num_unloaded)
		if(!forced)
			balloon_alert(user, "it's empty!")
		return

	if(!forced)
		balloon_alert(user, "[num_unloaded] [cartridge_wording]\s unloaded")

	playsound(user, eject_sound, eject_sound_volume, eject_sound_vary)
	update_appearance()

///Gets the number of bullets in the gun
/obj/item/gun/ballistic/proc/get_ammo(countchambered = TRUE)
	var/boolets = 0 //mature var names for mature people
	if (chambered && countchambered)
		boolets++
	if (magazine)
		boolets += magazine.ammo_count()
	return boolets

///gets a list of every bullet in the gun
/obj/item/gun/ballistic/proc/get_ammo_list(countchambered = TRUE, drop_all = FALSE)
	var/list/rounds = list()
	if(chambered && countchambered)
		rounds.Add(chambered)
		if(drop_all)
			chambered = null
	rounds.Add(magazine.ammo_list(drop_all))
	return rounds

#define BRAINS_BLOWN_THROW_RANGE 3
#define BRAINS_BLOWN_THROW_SPEED 1
/obj/item/gun/ballistic/suicide_act(mob/user)
	var/obj/item/organ/brain/B = user.getorganslot(ORGAN_SLOT_BRAIN)
	if (B && chambered && chambered.loaded_projectile && can_trigger_gun(user) && !chambered.loaded_projectile.nodamage)
		user.visible_message("<span class='suicide'>[user] is putting the barrel of [src] in [user.p_their()] mouth. It looks like [user.p_theyre()] trying to commit suicide!</span>")
		sleep(25)
		if(user.is_holding(src))
			var/turf/T = get_turf(user)
			process_fire(user, user, FALSE, null, BODY_ZONE_HEAD)
			user.visible_message("<span class='suicide'>[user] blows [user.p_their()] brain[user.p_s()] out with [src]!</span>")
			var/turf/target = get_ranged_target_turf(user, turn(user.dir, 180), BRAINS_BLOWN_THROW_RANGE)
			B.Remove(user)
			B.forceMove(T)
			var/datum/callback/gibspawner = CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(spawn_atom_to_turf), /obj/effect/gibspawner/generic, B, 1, FALSE, user)
			B.throw_at(target, BRAINS_BLOWN_THROW_RANGE, BRAINS_BLOWN_THROW_SPEED, callback=gibspawner)
			return(BRUTELOSS)
		else
			user.visible_message("<span class='suicide'>[user] panics and starts choking to death!</span>")
			return(OXYLOSS)
	else
		user.visible_message("<span class='suicide'>[user] is pretending to blow [user.p_their()] brain[user.p_s()] out with [src]! It looks like [user.p_theyre()] trying to commit suicide!</b></span>")
		playsound(src, dry_fire_sound, 30, TRUE)
		return (OXYLOSS)
#undef BRAINS_BLOWN_THROW_SPEED
#undef BRAINS_BLOWN_THROW_RANGE
