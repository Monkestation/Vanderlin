/obj/item/gun/ballistic/airgun
	name = "airgun"
	desc = "A complex masterwork of engineering that propells projectiles via pressurized steam. \
		There are countless pipes, cogs, and other confusing gizmos, all combined with a body of brass, steel and leather."
	icon = 'icons/roguetown/weapons/airgun.dmi'
	icon_state = "airgun"
	slot_flags = ITEM_SLOT_BACK
	w_class = WEIGHT_CLASS_HUGE
	bigboy = TRUE
	SET_BASE_PIXEL(-16, -16)
	inhand_x_dimension = 64
	inhand_y_dimension = 64
	sellprice = 250
	dropshrink = 0.7
	item_weight = 7 KILOGRAMS
	equip_sound = 'sound/foley/gun_equip.ogg'
	pickup_sound = 'sound/foley/gun_equip.ogg'
	drop_sound = 'sound/foley/gun_drop.ogg'

	possible_item_intents = list(/datum/intent/shoot/airgun, /datum/intent/arc/airgun, MACE_SMASH)
	force = DAMAGE_MACE-5
	can_parry = TRUE
	wdefense = BAD_PARRY
	wbalance = EASY_TO_DODGE
	wlength = WLENGTH_LONG

	accepted_magazine_type = /obj/item/ammo_box/magazine/internal/barrel
	spawn_magazine_type = /obj/item/ammo_box/magazine/internal/barrel/empty
	weapon_weight = WEAPON_HEAVY
	bolt_type = BOLT_TYPE_NO_BOLT
	internal_magazine = TRUE
	trigger_guard = TRIGGER_GUARD_ALLOW_ALL
	cartridge_wording = "bullet"
	fire_sound = 'sound/foley/industrial/pneumaticpop.ogg'
	load_sound = 'sound/foley/industrial/loadin.ogg'

	var/pressure_to_use = 1
	var/maximum_pressure = 3 //the max pressure we can set the gun to
	var/cranked = FALSE
	var/steam_lever = FALSE
	var/loading_chamber = FALSE

	COOLDOWN_DECLARE(hiss_cooldown)

/obj/item/gun/ballistic/airgun/prefilled/Initialize(mapload)
	. = ..()
	SEND_SIGNAL(src, COMSIG_ATOM_STEAM_INCREASE, 800, "airgun")

/obj/item/gun/ballistic/airgun/apply_components()
	AddComponent(/datum/component/steam_storage, 800, 0, "airgun")

/obj/item/gun/ballistic/airgun/examine(mob/user)
	. = ..()
	. += "The steam lever is [steam_lever ? "raised, enabling" : "lowered, disabling"] the flow of steam."
	. += "The spring is [cranked ? "under tension" : "relaxed"]."
	. += "The loading chamber is [loading_chamber ? "open" : "closed"]."
	switch(pressure_to_use)
		if(1)
			. += "The pressure gauge arrow is positioned to the far left."
		if(2)
			. += "The pressure gauge arrow is positioned in the middle."
		if(3)
			. += "The pressure gauge arrow is positioned to the far right."

/obj/item/gun/ballistic/airgun/shoot_with_empty_chamber(mob/user)
	if(!COOLDOWN_FINISHED(src, hiss_cooldown))
		return
	playsound(src, 'sound/foley/industrial/pneumatichiss.ogg', 60)
	COOLDOWN_START(src, hiss_cooldown, 2 SECONDS)

/obj/item/gun/ballistic/airgun/attackby(obj/item/A, mob/user, list/modifiers)
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
	return ..()

/obj/item/gun/ballistic/airgun/attack_self(mob/living/user, list/modifiers)
	if(!loading_chamber)
		to_chat(user, span_warning("The chamber isn't open to unload [src]!"))
		return

	if(steam_lever)
		to_chat(user, span_warning("I almost scald myself with the boiling hot steam!"))
		return

	return ..()

/obj/item/gun/ballistic/airgun/attack_hand_secondary(mob/user, list/modifiers)
	. = ..()
	if(. == SECONDARY_ATTACK_CANCEL_ATTACK_CHAIN)
		return

	if(GET_MOB_SKILL_VALUE_OLD(user, /datum/attribute/skill/craft/engineering) <= 1)//requires average engineering
		to_chat(user, span_warning("I can't make a sense of all these knobs and levers!"))
		return SECONDARY_ATTACK_CANCEL_ATTACK_CHAIN

	if(!user.is_holding(src))
		to_chat(user, span_warning("I need to hold [src] to access the controls!"))
		return SECONDARY_ATTACK_CANCEL_ATTACK_CHAIN

	var/choice = browser_input_list(user, "An incomprehensible mass of knobs and levers", "[src]", list("Increase Pressure", "Decrease Pressure", "Loading Chamber", "Hand Crank", "Steam Lever", "Cancel"), "Cancel")
	if(!choice || choice == "cancel")
		return SECONDARY_ATTACK_CANCEL_ATTACK_CHAIN

	var/use_time = 4 //how much time the player needs to crank a knob, pull a lever, etc. in seconds
	use_time = use_time - (GET_MOB_SKILL_VALUE_OLD(user, /datum/attribute/skill/craft/engineering) / 2)
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

/obj/item/gun/ballistic/airgun/can_shoot(mob/living/user)
	return (..() && cranked && steam_lever && !loading_chamber)

/obj/item/gun/ballistic/airgun/modify_projectile(mob/living/user, atom/target, obj/projectile/modified)
	. = ..()

	if(user.client?.chargedprog >= 100)
		modified.accuracy += 15 //better accuracy for fully aiming

	var/perception = GET_MOB_ATTRIBUTE_VALUE(user, STAT_PERCEPTION)
	if(perception > 8)
		modified.accuracy += (perception - 10) * 2
		modified.bonus_accuracy += (perception - 10)

	//fixed boost is intended
	if(perception > 10)
		modified.damage *= 1.1

	modified.damage *= ((1 + pressure_to_use) / 3) //2/3rds damage at pressure 1, normal at pressure 2, 4/3rds at pressure 3
	modified.bonus_accuracy += (GET_MOB_SKILL_VALUE_OLD(user, /datum/attribute/skill/craft/engineering) * 4)

/obj/item/gun/ballistic/airgun/after_firing(atom/target, mob/living/user, empty_chamber, from_firing, chamber_next_round)
	. = ..()
	SEND_SIGNAL(src, COMSIG_ATOM_STEAM_USE, pressure_to_use * 100, "airgun")

/obj/item/gun/ballistic/airgun/postfire_empty_checks(last_shot_succeeded)
	. = ..()
	cranked = FALSE
