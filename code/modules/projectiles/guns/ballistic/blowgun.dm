
/obj/item/gun/ballistic/blowgun
	name = "blowgun"
	desc = "A primitive tool used for hunting. To use most accurately, hold your breath for a moment before releasing."
	icon = 'icons/roguetown/weapons/32/bows.dmi'
	icon_state = "blowgun"
	possible_item_intents = list(/datum/intent/shoot/blowgun, /datum/intent/arc/blowgun, INTENT_GENERIC)
	item_weight = 200 GRAMS

	accepted_magazine_type = /obj/item/ammo_box/magazine/internal/blowgun
	spawn_magazine_type = /obj/item/ammo_box/magazine/internal/blowgun/empty
	bolt_type = BOLT_TYPE_NO_BOLT
	internal_magazine = TRUE
	trigger_guard = TRIGGER_GUARD_ALLOW_ALL
	must_hold_to_load = TRUE
	fire_sound = 'sound/combat/Ranged/blowgun_shot.ogg'
	cartridge_wording = "dart"

/obj/item/gun/ballistic/blowgun/getonmobprop(tag)
	. = ..()
	if(tag)
		switch(tag)
			if("gen")
				return list("shrink" = 0.5,"sx" = -4,"sy" = -6,"nx" = 9,"ny" = -6,"wx" = -6,"wy" = -4,"ex" = 4,"ey" = -6,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0,"nturn" = 0,"sturn" = 90,"wturn" = 93,"eturn" = -12,"nflip" = 0,"sflip" = 1,"wflip" = 0,"eflip" = 0)
			if("onbelt")
				return list("shrink" = 0.3,"sx" = -2,"sy" = -5,"nx" = 4,"ny" = -5,"wx" = 0,"wy" = -5,"ex" = 2,"ey" = -5,"nturn" = 0,"sturn" = 0,"wturn" = 0,"eturn" = 0,"nflip" = 0,"sflip" = 0,"wflip" = 0,"eflip" = 0,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0)

/obj/item/gun/ballistic/blowgun/update_overlays()
	. = ..()
	if(chambered)
		var/obj/item/I = chambered
		I.pixel_x = I.base_pixel_x
		I.pixel_y = I.base_pixel_y
		. += mutable_appearance(I.icon, I.icon_state, layer - 0.01)

/obj/item/gun/ballistic/blowgun/attack_self(mob/user)
	if(!chambered)
		balloon_alert(user, "no [cartridge_wording]!")
		return

	user.put_in_hands(chambered)
	chambered = magazine.get_round()
	update_appearance()

/obj/item/gun/ballistic/blowgun/chamber_round(spin_cylinder, replace_new_round)
	if(chambered || !magazine)
		return
	chambered = magazine.get_round()
	RegisterSignal(chambered, COMSIG_MOVABLE_MOVED, PROC_REF(clear_chambered))
	update_appearance()

/obj/item/gun/ballistic/blowgun/shoot_with_empty_chamber()
	return

/obj/item/gun/ballistic/blowgun/modify_projectile(mob/living/user, atom/target, obj/projectile/modified)
	. = ..()
	if(user.client.chargedprog < 100)
		modified.damage *= (user.client.chargedprog / 100)
		modified.embedchance = 5
	else
		modified.embedchance = 100
		modified.accuracy += 15 //fully aiming blow makes your accuracy better.

	var/perception = GET_MOB_ATTRIBUTE_VALUE(user, STAT_PERCEPTION)
	if(perception > 8)
		modified.accuracy += (perception - 8) * 4 //each point of perception above 8 increases standard accuracy by 4.
		modified.bonus_accuracy += (perception - 8) //Also, increases bonus accuracy by 1, which cannot fall off due to distance.
		if(perception > 10) // Every point over 10 END adds 10% damage
			modified.damage *= (perception / 10)
