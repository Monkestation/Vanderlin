/obj/item/ammo_casing
	name = "bullet casing"
	desc = "A bullet casing."
	icon = 'icons/roguetown/weapons/ammo.dmi'
	icon_state = "s-casing"
	flags_1 = CONDUCT_1
	slot_flags = ITEM_SLOT_HIP
	throwforce = 0
	w_class = WEIGHT_CLASS_TINY

	/// What sound should play when this ammo is fired
	var/fire_sound = null
	/// Which kind of guns it can be loaded into
	var/caliber = null
	/// The bullet type to create when Initalized
	var/projectile_type = null
	/// The loaded projectile in this ammo casing
	var/obj/projectile/loaded_projectile = null
	/// Pellets for spreadshot
	var/pellets = 1
	/// Variance for inaccuracy fundamental to the casing
	var/variance = 0
	/// Randomspread for automatics
	var/randomspread = 0
	/// Delay for energy weapons
	var/delay = 0
	/// Override this to make your gun have a faster fire rate, in tenths of a second. 4 is the default gun cooldown.
	var/click_cooldown_override = 0
	/// The visual effect appearing when the ammo is fired.
	var/firing_effect_type = /obj/effect/temp_visual/dir_setting/firing_effect
	/// Pacifism check for boolet, set to FALSE if bullet is non-lethal
	var/harmful = TRUE

/obj/item/ammo_casing/spent
	name = "spent bullet casing"
	loaded_projectile = null

/obj/item/ammo_casing/Initialize()
	. = ..()
	if(projectile_type)
		loaded_projectile = new projectile_type(src)
	pixel_x = base_pixel_x + rand(-10, 10)
	pixel_y = base_pixel_y + rand(-10, 10)
	setDir(pick(GLOB.alldirs))

/obj/item/ammo_casing/Destroy()
	if(istype(loaded_projectile))
		QDEL_NULL(loaded_projectile)
	return ..()

//proc to magically refill a casing with a new projectile
/obj/item/ammo_casing/proc/newshot() //For energy weapons, syringe gun, shotgun shells and wands (!).
	if(!loaded_projectile)
		loaded_projectile = new projectile_type(src, src)

/obj/item/ammo_casing/attackby(obj/item/I, mob/user, list/modifiers)
	if(!istype(I, /obj/item/ammo_box))
		return ..()

	if(!isturf(loc))
		return

	var/obj/item/ammo_box/box = I

	var/boolets = 0
	for(var/obj/item/ammo_casing/bullet in loc)
		if(length(box.stored_ammo) >= box.max_ammo)
			break
		if(bullet.loaded_projectile)
			if(box.give_round(bullet, 0))
				boolets++
		else
			continue
	if (boolets > 0)
		box.update_appearance()
		to_chat(user, span_notice("I collect [boolets] shell\s. [box] now contains [length(box.stored_ammo)] shell\s."))
	else
		to_chat(user, span_warning("I fail to collect anything!"))

/obj/item/ammo_casing/throw_impact(atom/hit_atom, datum/thrownthing/throwingdatum)
	bounce_away(FALSE, NONE)
	return ..()

/obj/item/ammo_casing/proc/bounce_away(still_warm = FALSE, bounce_delay = 3)
	SpinAnimation(10, 1)
	var/turf/T = get_turf(src)
	if(still_warm && T && T.bullet_sizzle)
		addtimer(CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(playsound), src, 'sound/blank.ogg', 20, 1), bounce_delay) //If the turf is made of water and the shell casing is still hot, make a sizzling sound when it's ejected.
	else if(T && T.bullet_bounce_sound)
		addtimer(CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(playsound), src, T.bullet_bounce_sound, 20, 1), bounce_delay) //Soft / non-solid turfs that shouldn't make a sound when a shell casing is ejected over them.
