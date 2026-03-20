
/obj/item/gun/ballistic/revolver/grenadelauncher/blowgun
	name = "blowgun"
	desc = "A primitive tool used for hunting. To use most accurately, hold your breath for a moment before releasing."
	icon = 'icons/roguetown/weapons/32/bows.dmi'
	icon_state = "blowgun"
	possible_item_intents = list(/datum/intent/shoot/blowgun, /datum/intent/arc/blowgun, INTENT_GENERIC)
	accepted_magazine_type = /obj/item/ammo_box/magazine/internal/blowgun
	slot_flags = ITEM_SLOT_HIP
	w_class = WEIGHT_CLASS_NORMAL
	randomspread = 0
	spread = 0
	can_parry = FALSE
	force = 6
	var/cocked = FALSE
	cartridge_wording = "dart"
	fire_sound = 'sound/combat/Ranged/blowgun_shot.ogg'

/obj/item/gun/ballistic/revolver/grenadelauncher/blowgun/getonmobprop(tag)
	. = ..()
	if(tag)
		switch(tag)
			if("gen")
				return list("shrink" = 0.5,"sx" = -4,"sy" = -6,"nx" = 9,"ny" = -6,"wx" = -6,"wy" = -4,"ex" = 4,"ey" = -6,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0,"nturn" = 0,"sturn" = 90,"wturn" = 93,"eturn" = -12,"nflip" = 0,"sflip" = 1,"wflip" = 0,"eflip" = 0)
			if("onbelt")
				return list("shrink" = 0.3,"sx" = -2,"sy" = -5,"nx" = 4,"ny" = -5,"wx" = 0,"wy" = -5,"ex" = 2,"ey" = -5,"nturn" = 0,"sturn" = 0,"wturn" = 0,"eturn" = 0,"nflip" = 0,"sflip" = 0,"wflip" = 0,"eflip" = 0,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0)

/obj/item/gun/ballistic/revolver/grenadelauncher/blowgun/shoot_with_empty_chamber()
	return

/obj/item/gun/ballistic/revolver/grenadelauncher/blowgun/process_fire(atom/target, mob/living/user, message = TRUE, list/modifiers, zone_override, bonus_spread = 0)
	if(user.usable_hands < 1)
		return FALSE
	if(user.client)
		if(user.client.chargedprog >= 100)
			spread = 0
		else
			spread = 150 - (150 * (user.client.chargedprog / 100))
	else
		spread = 0
	for(var/obj/item/ammo_casing/CB in get_ammo_list(FALSE, TRUE))
		var/obj/projectile/loaded_projectile = CB.loaded_projectile
		if(user.client.chargedprog < 100)
			loaded_projectile.damage = loaded_projectile.damage - (loaded_projectile.damage * (user.client.chargedprog / 100))
			loaded_projectile.embedchance = 5
		else
			loaded_projectile.damage = loaded_projectile.damage
			loaded_projectile.embedchance = 100
			loaded_projectile.accuracy += 15 //fully aiming blow makes your accuracy better.

		var/perception = GET_MOB_ATTRIBUTE_VALUE(user, STAT_PERCEPTION)
		if(perception > 8)
			loaded_projectile.accuracy += (perception - 8) * 4 //each point of perception above 8 increases standard accuracy by 4.
			loaded_projectile.bonus_accuracy += (perception - 8) //Also, increases bonus accuracy by 1, which cannot fall off due to distance.
		if(perception > 10) // Every point over 10 END adds 10% damage
			loaded_projectile.damage *= (perception / 10)
		loaded_projectile.damage *= damfactor // Apply blow's inherent damage multiplier regardless of PER
		loaded_projectile.bonus_accuracy += (GET_MOB_SKILL_VALUE_OLD(user, /datum/attribute/skill/combat/bows) * 5) //+5 accuracy per level in bows. Bonus accuracy will not drop-off.
	. = ..()
	if(.)
		if(istype(user) && user.mind)
			var/modifier = 1.25/(spread+1)
			var/boon = user.get_learning_boon(/datum/attribute/skill/combat/bows)
			var/amt2raise = GET_MOB_ATTRIBUTE_VALUE(user, STAT_INTELLIGENCE)/2
			user.adjust_experience(/datum/attribute/skill/combat/bows, amt2raise * boon * modifier, FALSE)

/obj/item/gun/ballistic/revolver/grenadelauncher/blowgun/update_overlays()
	. = ..()
	if(chambered)
		var/obj/item/I = chambered
		I.pixel_x = I.base_pixel_x
		I.pixel_y = I.base_pixel_y
		. += new /mutable_appearance(I)

/obj/item/ammo_box/magazine/internal/blowgun
	ammo_type = /obj/item/ammo_casing/caseless/dart
	caliber = "dart"
	max_ammo = 1
	start_empty = TRUE


