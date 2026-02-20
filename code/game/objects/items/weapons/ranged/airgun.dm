/obj/item/gun/ballistic/revolver/grenadelauncher/airgun
	name = "airgun"
	desc = "A complex masterwork of engineering that propells projectiles via pressurized steam. \
	There are countless pipes, cogs, and other confusing gizmos, all combined with a body of brass, steel and leather."
	icon = 'icons/roguetown/weapons/airgun.dmi'
	icon_state = "airgun"
	force = DAMAGE_MACE-5
	can_parry = TRUE
	wdefense = BAD_PARRY
	wbalance = EASY_TO_DODGE
	wlength = WLENGTH_LONG
	possible_item_intents = list(MACE_SMASH)
	gripped_intents = list(/datum/intent/shoot/airgun, /datum/intent/arc/airgun)
	mag_type = /obj/item/ammo_box/magazine/internal/shot/airgun

	slot_flags = ITEM_SLOT_BACK
	w_class = WEIGHT_CLASS_HUGE
	bigboy = TRUE
	sellprice = 250
	SET_BASE_PIXEL(-16, -16)
	inhand_x_dimension = 64
	inhand_y_dimension = 64
	cartridge_wording = "bullet"
	fire_sound = 'sound/foley/industrial/pneumaticpop.ogg'
	load_sound = 'sound/foley/industrial/loadin.ogg'
	equip_sound = 'sound/foley/gun_equip.ogg'
	pickup_sound = 'sound/foley/gun_equip.ogg'
	drop_sound = 'sound/foley/gun_drop.ogg'
	dropshrink = 0.7
	var/pressure_to_use = 1
	var/maximum_pressure = 3 //the max pressure we can set the gun to
	var/cranked = FALSE
	var/steam_lever = FALSE
	var/loading_chamber = FALSE

/obj/item/gun/ballistic/revolver/grenadelauncher/airgun/apply_components()
	AddComponent(/datum/component/steam_storage, 800, 0, "airgun")
	AddComponent(/datum/component/two_handed, force_unwielded = force, force_wielded = force_wielded, wield_callback = CALLBACK(src, PROC_REF(on_wield)), unwield_callback = CALLBACK(src, PROC_REF(on_unwield)))

/obj/item/ammo_box/magazine/internal/shot/airgun
	ammo_type = /obj/item/ammo_casing/caseless/bullet
	caliber = "musketball"
	max_ammo = 1
	start_empty = TRUE

/datum/intent/shoot/airgun
	chargedrain = 0 //no drain to aim

/datum/intent/shoot/airgun/get_chargetime()
	var/mob/living/master = get_master_mob()
	if(master && chargetime)
		var/newtime = chargetime
		//skill block
		newtime = newtime + 18
		newtime = newtime - (master.get_skill_level(/datum/skill/craft/engineering, TRUE) * 3)
		//per block
		newtime = newtime + 20
		newtime = newtime - (master.STAPER)
		if(newtime > 0)
			return newtime
		else
			return 0.1
	return chargetime

/datum/intent/arc/airgun
	chargetime = 1
	chargedrain = 0 //no drain to aim

/datum/intent/arc/airgun/get_chargetime()
	var/mob/living/master = get_master_mob()
	if(master && chargetime)
		var/newtime = chargetime
		//skill block
		newtime = newtime + 18
		newtime = newtime - (master.get_skill_level(/datum/skill/craft/engineering, TRUE) * 3)
		//per block
		newtime = newtime + 20
		newtime = newtime - (master.STAPER)
		if(newtime > 0)
			return newtime
		else
			return 1
	return chargetime

/obj/item/gun/ballistic/revolver/grenadelauncher/airgun/examine(mob/user)
	. = ..()
	desc = initial(desc)
	desc += "\n" + ("The steam lever is [steam_lever ? "raised, enabling" : "lowered, disabling"] the flow of steam.")
	desc += "\n" + ("The spring is [cranked ? "under tension" : "relaxed"].")
	desc += "\n" + ("The loading chamber is [loading_chamber ? "open" : "closed"].")
	switch(pressure_to_use)
		if(1)
			desc += "\n" + ("The pressure gauge arrow is positioned to the far left.")
		if(2)
			desc += "\n" + ("The pressure gauge arrow is positioned in the middle.")
		if(3)
			desc += "\n" + ("The pressure gauge arrow is positioned to the far right.")
	return ..()

/obj/item/gun/ballistic/revolver/grenadelauncher/airgun/shoot_with_empty_chamber(mob/user)
		to_chat(user, span_warning("[src] has nothing to fire!"))

/obj/item/gun/ballistic/revolver/grenadelauncher/airgun/attackby(obj/item/A, mob/user, params)
	if((istype(A, /obj/item/ammo_box) || istype(A, /obj/item/ammo_casing)))
		if(!(user.is_holding(src)))
			to_chat(user, span_warning("I need to hold \the [src] to load it!"))
			return
		if(!(loading_chamber))
			to_chat(user, span_warning("The loading chamber isn't open!"))
			return
		if(steam_lever)
			to_chat(user, span_warning("I almost scald myself with the boiling hot steam!"))
			return
	. = ..()

/obj/item/gun/ballistic/revolver/grenadelauncher/airgun/attack_self(mob/living/user, params)
	if(SEND_SIGNAL(src, COMSIG_ITEM_ATTACK_SELF, user) & COMPONENT_CANCEL_ATTACK_CHAIN)
		return TRUE

/obj/item/gun/ballistic/revolver/grenadelauncher/airgun/attack_hand(mob/user)
	if(user.is_holding(src))
		if(!(loading_chamber))
			to_chat(user, span_warning("The chamber isn't open to unload [src]!"))
			return
		if(steam_lever)
			to_chat(user, span_warning("I almost scald myself with the boiling hot steam!"))
			return
		var/num_unloaded = 0
		for(var/obj/item/ammo_casing/CB in get_ammo_list(FALSE, TRUE))
			CB.forceMove(drop_location())
			CB.bounce_away(FALSE, NONE)
			num_unloaded++
		if(num_unloaded)
			to_chat(user, span_notice("I remove [(num_unloaded == 1) ? "the" : "[num_unloaded]"] [cartridge_wording]\s from [src]."))
			playsound(src, 'sound/foley/industrial/loadout.ogg', 100, FALSE)
			update_appearance(UPDATE_ICON)
		else
			to_chat(user, span_warning("[src] is empty!"))
		return
	. = ..()

/obj/item/gun/ballistic/revolver/grenadelauncher/airgun/attack_hand_secondary(mob/user, params)
	. = ..()
	if(. == SECONDARY_ATTACK_CANCEL_ATTACK_CHAIN)
		return
	if(!user.is_holding(src))
		to_chat(user, span_warning("I need to hold [src] to access the controls!"))
		return SECONDARY_ATTACK_CANCEL_ATTACK_CHAIN
	if(user.get_skill_level(/datum/skill/craft/engineering) <= 1)//requires average engineering
		to_chat(user, span_warning("I can't make a sense of all these knobs and levers!"))
		return SECONDARY_ATTACK_CANCEL_ATTACK_CHAIN
	var/choice = browser_input_list(user, "An incomprehensible mass of knobs and levers", "[src]", list("Increase Pressure", "Decrease Pressure", "Loading Chamber", "Hand Crank", "Steam Lever", "Cancel"), "Cancel")
	if(!choice || choice == "cancel")
		return
	var/use_time = 4 //how much time the player needs to crank a knob, pull a lever, etc. in seconds
	use_time = use_time - (user.get_skill_level(/datum/skill/craft/engineering, TRUE) / 2)
	switch(choice)
		if("Increase Pressure")
			if(pressure_to_use < maximum_pressure)
				to_chat(user, span_info("I begin to turn the knob clockwise..."))
				if(do_after(user, use_time SECONDS, src))
					to_chat(user, span_info("I turn the knob clockwise, increasing the pressure for the airgun to use."))
					pressure_to_use++
					playsound(src, 'sound/foley/industrial/pneumaticpress.ogg', 100, FALSE)
			else
				to_chat(user, span_warning("I try to turn the knob clockwise, but that's as far as it will go."))
		if("Decrease Pressure")
			if(pressure_to_use > 1)
				to_chat(user, span_info("I begin to turn the knob counter-clockwise..."))
				if(do_after(user, use_time SECONDS, src))
					to_chat(user, span_info("I turn the knob counter-clockwise, decreasing the pressure for the airgun to use."))
					pressure_to_use--
					playsound(src, 'sound/foley/industrial/pneumaticpress.ogg', 100, FALSE)
			else
				to_chat(user, span_warning("I try to turn the knob counter-clockwise, but that's as far as it will go."))
		if("Loading Chamber")
			if(loading_chamber)
				to_chat(user, span_info("I begin to close the loading chamber..."))
				if(do_after(user, use_time SECONDS, src))
					to_chat(user, span_info("I close the loading chamber."))
					playsound(src, 'sound/foley/industrial/toggle.ogg', 100, FALSE)
					loading_chamber = FALSE
			else
				to_chat(user, span_info("I begin to open the loading chamber..."))
				if(do_after(user, use_time SECONDS, src))
					to_chat(user, span_info("I open the loading chamber."))
					playsound(src, 'sound/foley/industrial/toggle.ogg', 100, FALSE)
					loading_chamber = TRUE
		if("Hand Crank")
			if(cranked)
				to_chat(user, span_info("I begin to turn the crank counter-clockwise..."))
				if(do_after(user, use_time SECONDS, src))
					to_chat(user, span_info("I turn the crank counter-clockwise, decompressing the spring."))
					playsound(src, 'sound/foley/winding.ogg', 100, FALSE)
					cranked = FALSE
			else
				to_chat(user, span_info("I begin to turn the crank clockwise..."))
				if(do_after(user, use_time SECONDS, src))
					to_chat(user, span_info("I turn the crank clockwise, compressing the spring."))
					playsound(src, 'sound/foley/winding.ogg', 100, FALSE)
					cranked = TRUE
		if("Steam Lever")
			if(steam_lever)
				to_chat(user, span_info("I begin to pull the steam lever down..."))
				if(do_after(user, use_time SECONDS, src))
					to_chat(user, span_info("I pull the steam lever down, disabling the flow of steam."))
					playsound(src, 'sound/foley/lock.ogg', 100, FALSE)
					steam_lever = FALSE
			else
				to_chat(user, span_info("I begin to pull the steam lever up..."))
				if(do_after(user, use_time SECONDS, src))
					to_chat(user, span_info("I pull the steam lever up, enabling the flow of steam."))
					playsound(src, 'sound/foley/lock.ogg', 100, FALSE)
					steam_lever = TRUE
	update_appearance(UPDATE_ICON_STATE)
	return SECONDARY_ATTACK_CANCEL_ATTACK_CHAIN

/obj/item/gun/ballistic/revolver/grenadelauncher/airgun/process_fire(atom/target, mob/living/user, message = TRUE, params = null, zone_override = "", bonus_spread = 0)
	if(!SEND_SIGNAL(user, COMSIG_ATOM_PROXY_STEAM_USE, src, pressure_to_use * 100, "airgun", FALSE, TRUE))
		to_chat(user, span_warning("Fires a sad gust of air."))
		return FALSE
	if(user.client)
		if(user.client.chargedprog >= 100)
			spread = 0
		else
			spread = 150 - (150 * (user.client.chargedprog / 100))
	else
		spread = 0
	if(!(cranked) || !(steam_lever) || (loading_chamber))
		to_chat(user, span_warning("[src] refuses to fire!"))
		playsound(src, 'sound/foley/industrial/pneumatichiss.ogg', 100, FALSE)
		return FALSE
	for(var/obj/item/ammo_casing/CB in get_ammo_list(FALSE, TRUE))
		var/obj/projectile/BB = CB.BB
		if(user.client.chargedprog >= 100)
			BB.accuracy += 15 //better accuracy for fully aiming
		if(user.STAPER > 8)
			BB.accuracy += (user.STAPER - 8) * 4 //each point of perception above 8 increases standard accuracy by 4.
			BB.bonus_accuracy += (user.STAPER - 8) //Also, increases bonus accuracy by 1, which cannot fall off due to distance.

		//fixed boost is intended
		if(user.STAPER > 10)
			BB.damage *= 1.1

		BB.damage *= ((1 + pressure_to_use) / 3) //2/3rds damage at pressure 1, normal at pressure 2, 4/3rds at pressure 3

		if(user.STAPER > 10)
			BB.accuracy += (user.STAPER - 10) * 2 //each point of perception above 10 increases standard accuracy by 2.
			BB.bonus_accuracy += (user.STAPER - 10) //Also, increases bonus accuracy by 1, which cannot fall off due to distance.
		BB.bonus_accuracy += (user.get_skill_level(/datum/skill/craft/engineering, TRUE) * 4) //+4 accuracy per level. Bonus accuracy will not drop-off.
	SEND_SIGNAL(src, COMSIG_ATOM_STEAM_USE, pressure_to_use * 100, "airgun")
	. = ..()
	cranked = FALSE
	var/modifier = 1.25/(spread+1)
	var/boon = user.get_learning_boon(/datum/skill/craft/engineering)
	var/amt2raise = user.STAINT/2
	user.adjust_experience(/datum/skill/craft/engineering, amt2raise * boon * modifier, FALSE)

/obj/item/gun/ballistic/revolver/grenadelauncher/airgun/prefilled/Initialize()
	. = ..()
	SEND_SIGNAL(src, COMSIG_ATOM_STEAM_INCREASE, 800, "airgun")

