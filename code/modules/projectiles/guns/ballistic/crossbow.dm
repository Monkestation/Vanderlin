/obj/item/gun/ballistic/bow/cross
	name = "crossbow"
	desc = "A mechanical ranged weapon of simple design, affixed with a stirrup and fired via trigger."
	icon_state = "crossbow"
	base_icon_state = "crossbow"
	possible_item_intents = list(/datum/intent/shoot/crossbow, /datum/intent/arc/crossbow, INTENT_GENERIC)
	slot_flags = ITEM_SLOT_BACK
	w_class = WEIGHT_CLASS_BULKY
	associated_skill = /datum/attribute/skill/combat/crossbows
	item_weight = 2 KILOGRAMS

	cartridge_wording = "bolt"
	accepted_magazine_type = /obj/item/ammo_box/magazine/internal/crossbow
	spawn_magazine_type = /obj/item/ammo_box/magazine/internal/crossbow/empty
	fire_sound = 'sound/combat/Ranged/crossbow-small-shot-02.ogg'

	/// If the string is pulled back
	var/string_pulled = FALSE
	/// Base time to pull back the string
	var/pullback_time = 4 SECONDS
	/// Can move while pulling back the string
	var/pullback_movement = FALSE

/obj/item/gun/ballistic/bow/cross/slur
	name = "slurbow"
	desc = "A lighter weight crossbow with a distinct barrel shroud holding the bolt in place. Light enough to arm by hand. \n\
		They're popular among highwaymen and the patrolling lamplighters of Grenzelhoft."
	icon_state = "slurbow"
	base_icon_state = "slurbow"
	possible_item_intents = list(/datum/intent/shoot/crossbow/slurbow, /datum/intent/arc/crossbow, INTENT_GENERIC)
	slot_flags = ITEM_SLOT_HIP
	w_class = WEIGHT_CLASS_NORMAL
	grid_height = 64
	grid_width = 64
	item_weight = 1.5 KILOGRAMS

	projectile_damage_multiplier = 0.6

	pullback_time = 2 SECONDS

/obj/item/gun/ballistic/bow/cross/getonmobprop(tag)
	. = ..()
	if(tag)
		switch(tag)
			if("gen")
				return list("shrink" = 0.5,"sx" = -4,"sy" = -6,"nx" = 9,"ny" = -6,"wx" = -6,"wy" = -4,"ex" = 4,"ey" = -6,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0,"nturn" = 0,"sturn" = 90,"wturn" = 93,"eturn" = -12,"nflip" = 0,"sflip" = 1,"wflip" = 0,"eflip" = 0)
			if("onbelt")
				return list("shrink" = 0.3,"sx" = -2,"sy" = -5,"nx" = 4,"ny" = -5,"wx" = 0,"wy" = -5,"ex" = 2,"ey" = -5,"nturn" = 0,"sturn" = 0,"wturn" = 0,"eturn" = 0,"nflip" = 0,"sflip" = 0,"wflip" = 0,"eflip" = 0,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0)

/obj/item/gun/ballistic/bow/cross/update_icon_state()
	. = ..()
	icon_state = "[base_icon_state][string_pulled ? "_ready" : ""]"

/obj/item/gun/ballistic/bow/cross/update_overlays()
	. = ..()
	if(!chambered)
		return

	var/obj/item/I = chambered
	I.pixel_x = I.base_pixel_x
	I.pixel_y = I.base_pixel_y
	. += mutable_appearance(I.icon, I.icon_state)

/obj/item/gun/ballistic/bow/cross/attack_self(mob/living/user, list/modifiers)
	if(chambered)
		return ..()

	if(!string_pulled)
		balloon_alert(user, "drawing...")
		var/interaction_flags = pullback_movement ? (IGNORE_USER_LOC_CHANGE|IGNORE_USER_DIR_CHANGE) : NONE
		if(!do_after(user, pullback_time - GET_MOB_ATTRIBUTE_VALUE(user, STAT_STRENGTH), src, interaction_flags))
			return
		playsound(user, 'sound/combat/Ranged/crossbow_medium_reload-01.ogg', 100, FALSE)
		balloon_alert(user, "drawn!")
	else
		balloon_alert(user, "undrawn.")

	string_pulled = !string_pulled

	update_appearance(UPDATE_ICON_STATE)

/obj/item/gun/ballistic/bow/cross/attackby(obj/item/A, mob/user, list/modifiers)
	if(!istype(A, /obj/item/ammo_box) && !istype(A, /obj/item/ammo_casing))
		return

	if(!string_pulled)
		balloon_alert(user, "draw it first!")
		return

	return ..()

/obj/item/gun/ballistic/bow/cross/shoot_with_empty_chamber(mob/living/user)
	if(string_pulled)
		playsound(src, 'sound/combat/Ranged/flatbow-shot-02.ogg', 80)

/obj/item/gun/ballistic/bow/cross/postfire_empty_checks(last_shot_succeeded)
	. = ..()
	if(chambered)
		return
	string_pulled = FALSE
	update_appearance(UPDATE_ICON_STATE)
