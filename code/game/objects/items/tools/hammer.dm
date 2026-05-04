/obj/item/weapon/hammer
	name = "hammer"
	desc = ""
	icon_state = "hammer"
	icon = 'icons/roguetown/weapons/tools.dmi'
	mob_overlay_icon = 'icons/roguetown/onmob/onmob.dmi'
	force = DAMAGE_HAMMER
	usesound = list('sound/items/bsmith1.ogg','sound/items/bsmith2.ogg','sound/items/bsmith3.ogg','sound/items/bsmith4.ogg')
	possible_item_intents = list(MACE_STRIKE, MACE_SMASH)
	max_integrity = INTEGRITY_STRONG
	sharpness = IS_BLUNT
	wlength = 10
	slot_flags = ITEM_SLOT_HIP
	w_class = WEIGHT_CLASS_NORMAL
	associated_skill = /datum/attribute/skill/combat/axesmaces
	melting_material = /datum/material/iron
	melt_amount = 75

	grid_width = 32
	grid_height = 64
	item_weight = 1.24 KILOGRAMS
	var/no_spark = FALSE	//for hammers that shouldn't make sparks on impact

/obj/structure
	var/hammer_repair

/obj/item/weapon/hammer/attack_atom(atom/attacked_atom, mob/living/user)
	if(!isobj(attacked_atom))
		return ..()
	if(!isliving(user) || !user.mind || user.cmode)
		return ..()
	var/datum/mind/blacksmith_mind = user.mind
	var/repair_percent = 0.05 // 5% Repairing per hammer smack
	/// Repairing is MUCH better with an anvil!
	if(locate(/obj/machinery/anvil) in attacked_atom.loc)
		repair_percent *= 1.5
	if(HAS_TRAIT(attacked_atom, TRAIT_NEEDS_QUENCH))
		repair_percent *= 1.5

	if(isbodypart(attacked_atom))
		. = TRUE
		var/obj/item/bodypart/attacked_prosthetic = attacked_atom
		if(!attacked_prosthetic.anvilrepair)
			return
		if(!attacked_atom.ontable() && !istype(attacked_atom.loc, /obj/machinery/anvil))
			to_chat(user, span_warning("I should put [attacked_atom] on a table or an anvil first."))
			return
		if(attacked_prosthetic.get_integrity() >= attacked_prosthetic.max_integrity && attacked_prosthetic.brute_dam == 0 && attacked_prosthetic.burn_dam == 0 && attacked_prosthetic.wounds == null && attacked_prosthetic.bodypart_disabled == BODYPART_NOT_DISABLED) //A mouthful
			to_chat(user, span_warning("There is nothing to further repair on [attacked_prosthetic]."))
			return

		if(GET_MOB_SKILL_VALUE_OLD(user, attacked_prosthetic.anvilrepair) <= 0)
			if(prob(30))
				repair_percent = 0.01
			else
				repair_percent = 0
		else
			repair_percent *= GET_MOB_SKILL_VALUE_OLD(user, attacked_prosthetic.anvilrepair)

		playsound(src,'sound/items/bsmith3.ogg', 100, FALSE)
		if(repair_percent)
			var/amt2raise = floor(GET_MOB_ATTRIBUTE_VALUE(user, STAT_INTELLIGENCE) * 0.25)
			attacked_prosthetic.repair_damage(attacked_prosthetic.max_integrity * repair_percent)
			attacked_prosthetic.brute_dam = max(attacked_prosthetic.brute_dam - 10, 0)
			attacked_prosthetic.burn_dam = max(attacked_prosthetic.burn_dam - 10, 0)
			if(repair_percent == 0.01) // If an inexperienced repair attempt has been successful
				to_chat(user, span_warning("You fumble your way into slightly repairing [attacked_prosthetic]."))
			else
				user.visible_message(span_info("[user] repairs [attacked_prosthetic]!"))
				attacked_prosthetic.wounds = null //You need actual skill to do this
				attacked_prosthetic.bodypart_disabled = BODYPART_NOT_DISABLED
			blacksmith_mind.add_sleep_experience(attacked_prosthetic.anvilrepair, amt2raise)
		else
			user.visible_message(span_warning("[user] fumbles trying to repair [attacked_prosthetic]!"))
			attacked_prosthetic.take_damage(attacked_prosthetic.max_integrity * 0.1, BRUTE, "blunt")
		return

	if(isitem(attacked_atom))
		. = TRUE
		var/obj/item/attacked_item = attacked_atom
		if(!attacked_item.anvilrepair || !attacked_item.max_integrity)
			to_chat(user, span_warning("[attacked_item] cannot be repaired."))
			return

		if(!attacked_item.ontable() && !istype(attacked_atom.loc, /obj/machinery/anvil))
			to_chat(user, span_warning("I should put [attacked_item] on a table or an anvil first."))
			return

		var/skill_value = GET_MOB_SKILL_VALUE(user, attacked_item.anvilrepair) // 0-60 range typically
		var/was_broken = attacked_item.obj_broken

		if(!was_broken && attacked_item.get_integrity() >= attacked_item.max_integrity)
			to_chat(user, span_warning("There is nothing to further repair on [attacked_item]."))
			return

		if(skill_value <= 0)
			if(prob(30))
				repair_percent = 0.01
				to_chat(user, span_warning("You are just barely able to repair this..."))
			else
				repair_percent = 0
				if(!was_broken)
					attacked_item.take_damage(attacked_item.max_integrity * 0.1, BRUTE, "blunt")
					user.visible_message(span_warning("[user] damages [attacked_item] further!"))
		else
			repair_percent *= GET_MOB_SKILL_VALUE_OLD(user, attacked_item.anvilrepair)

		// If the armor was fully broken, penalize max_integrity based on skill
		// At skill 60 (master): ~5% max_integrity loss
		// At skill 30 (middling): ~35% max_integrity loss
		// At skill 1 (novice): ~64% max_integrity loss
		// At skill 0: ~65% max_integrity loss
		// At skill -20: ~85% max_integrity loss
		// At skill -60+: ~99% max_integrity loss (clamped)
		attacked_item.repair_damage(attacked_item.max_integrity * repair_percent)
		if(was_broken)
			var/integrity_penalty
			integrity_penalty = 0.65 - ((skill_value / SKILL_MASTER) * 0.60)
			integrity_penalty = clamp(integrity_penalty, 0.05, 0.99)

			var/integrity_loss = round(attacked_item.max_integrity * integrity_penalty)
			attacked_item.atom_fix()
			attacked_item.modify_max_integrity(max(1, attacked_item.max_integrity - integrity_loss), FALSE)

			to_chat(user, span_warning("I manage to repair [attacked_item], but its integrity has been permanently damaged."))
		else if(repair_percent)
			user.visible_message(span_info("[user] repairs [attacked_item]!"))

		var/amt2raise = floor(GET_MOB_ATTRIBUTE_VALUE(user, STAT_INTELLIGENCE) * 0.25)
		if(!repair_percent)
			amt2raise *= 0.25
		blacksmith_mind.add_sleep_experience(attacked_item.anvilrepair, amt2raise)
		playsound(src, 'sound/items/bsmithfail.ogg', 40, FALSE)
		return

	if(isstructure(attacked_atom))
		. = TRUE
		var/obj/structure/attacked_structure = attacked_atom
		if(!attacked_structure.hammer_repair || !attacked_structure.max_integrity || attacked_structure.obj_broken)
			to_chat(user, span_warning("[attacked_structure] cannot be repaired any further."))
			return
		if(GET_MOB_SKILL_VALUE_OLD(user, attacked_structure.hammer_repair) <= 0)
			to_chat(user, span_warning("I don't know how to repair this.."))
			return
		var/amt2raise = floor(GET_MOB_ATTRIBUTE_VALUE(user, STAT_INTELLIGENCE) * 0.25)
		repair_percent *= GET_MOB_SKILL_VALUE_OLD(user, attacked_structure.hammer_repair)
		attacked_structure.repair_damage(attacked_structure.max_integrity * repair_percent)
		blacksmith_mind.add_sleep_experience(attacked_structure.hammer_repair, amt2raise)
		playsound(src,'sound/items/bsmithfail.ogg', 100, FALSE)
		user.visible_message(span_info("[user] repairs [attacked_structure]!"))
		return

	return ..()

/obj/item/weapon/hammer/getonmobprop(tag)
	. = ..()
	if(tag)
		switch(tag)
			if("gen")
				return list("shrink" = 0.6,"sx" = -9,"sy" = 1,"nx" = 12,"ny" = 1,"wx" = -8,"wy" = 1,"ex" = 6,"ey" = 0,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0,"nturn" = 0,"sturn" = 0,"wturn" = 0,"eturn" = 0,"nflip" = 0,"sflip" = 8,"wflip" = 8,"eflip" = 0)
			if("onbelt")
				return list("shrink" = 0.3,"sx" = -2,"sy" = -5,"nx" = 4,"ny" = -5,"wx" = 0,"wy" = -5,"ex" = 2,"ey" = -5,"nturn" = 0,"sturn" = 0,"wturn" = 0,"eturn" = 0,"nflip" = 0,"sflip" = 0,"wflip" = 0,"eflip" = 0,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0)

// --------- IRON HAMMER -----------
/obj/item/weapon/hammer/iron
	icon_state = "hammer"
	experimental_onhip = FALSE
	experimental_onback = FALSE

// --------- STEEL HAMMER -----------
/obj/item/weapon/hammer/steel
	name = "claw hammer"
	icon_state = "hammer_s"
	experimental_onhip = FALSE
	experimental_onback = FALSE
	toolspeed = 0.8
	melt_amount = 50
	melting_material = /datum/material/steel

// --------- MALLET -----------
/obj/item/weapon/hammer/wood
	name = "wooden mallet"
	desc = "A wooden mallet is an artificer's second-best friend! But it may also come in handy to a smith..."
	icon_state = "hammer_w"
	force = DAMAGE_HAMMER - 5
	dropshrink = 0.9
	experimental_onhip = FALSE
	experimental_onback = FALSE
	smeltresult = /obj/item/fertilizer/ash
	max_integrity = INTEGRITY_WORST
	toolspeed = 1.2
	no_spark = TRUE
	item_weight = 654 GRAMS

/obj/item/weapon/hammer/wood/getonmobprop(tag)
	. = ..()
	if(tag)
		switch(tag)
			if("gen")
				return list("shrink" = 0.5,"sx" = -9,"sy" = 1,"nx" = 12,"ny" = 1,"wx" = -8,"wy" = 1,"ex" = 6,"ey" = 0,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0,"nturn" = 0,"sturn" = 0,"wturn" = 0,"eturn" = 0,"nflip" = 0,"sflip" = 8,"wflip" = 8,"eflip" = 0)
			if("onbelt")
				return list("shrink" = 0.3,"sx" = -2,"sy" = -5,"nx" = 4,"ny" = -5,"wx" = 0,"wy" = -5,"ex" = 2,"ey" = -5,"nturn" = 0,"sturn" = 0,"wturn" = 0,"eturn" = 0,"nflip" = 0,"sflip" = 0,"wflip" = 0,"eflip" = 0,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0)

/obj/item/weapon/hammer/copper
	name = "copper hammer"
	desc = "A simple and rough copper hammer."
	icon_state = "chammer"
	icon = 'icons/roguetown/weapons/tools.dmi'
	force = DAMAGE_HAMMER - 2
	max_integrity = INTEGRITY_POOR
	melting_material = /datum/material/copper
	toolspeed = 1.1
	no_spark = TRUE
	item_weight = 1.12 KILOGRAMS

/obj/item/weapon/hammer/sledgehammer
	name = "sledgehammer"
	desc = "It's almost asking to be put to work."
	icon = 'icons/roguetown/weapons/32/clubs.dmi'
	icon_state = "sledgehammer"
	force_wielded = DAMAGE_HAMMER_WIELD + 5
	possible_item_intents = list(MACE_STRIKE)
	gripped_intents = list(MACE_HVYSTRIKE, MACE_HVYSMASH)
	wbalance = EASY_TO_DODGE // Heavy
	minstr = 8

	gripsprite = TRUE
	slot_flags = ITEM_SLOT_HIP|ITEM_SLOT_BACK
	melt_amount = 100
	grid_width = null
	grid_height = null
	item_weight = 7.4 KILOGRAMS

/obj/item/weapon/hammer/sledgehammer/getonmobprop(tag)
	. = ..()
	if(tag)
		switch(tag)
			if("gen")
				return list("shrink" = 0.6,"sx" = -9,"sy" = 1,"nx" = 12,"ny" = 1,"wx" = -8,"wy" = 1,"ex" = 6,"ey" = 0,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0,"nturn" = 0,"sturn" = 0,"wturn" = 0,"eturn" = 0,"nflip" = 0,"sflip" = 8,"wflip" = 8,"eflip" = 0)
			if("wielded")
				return list("shrink" = 0.6,"sx" = 3,"sy" = 4,"nx" = -1,"ny" = 4,"wx" = -8,"wy" = 3,"ex" = 7,"ey" = 0,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0,"nturn" = 0,"sturn" = 0,"wturn" = 0,"eturn" = 15,"nflip" = 8,"sflip" = 0,"wflip" = 8,"eflip" = 0)
			if("onbelt")
				return list("shrink" = 0.3,"sx" = -2,"sy" = -5,"nx" = 4,"ny" = -5,"wx" = 0,"wy" = -5,"ex" = 2,"ey" = -5,"nturn" = 0,"sturn" = 0,"wturn" = 0,"eturn" = 0,"nflip" = 0,"sflip" = 0,"wflip" = 0,"eflip" = 0,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0)

/obj/item/weapon/hammer/sledgehammer/war
	name = "steel sledgehammer"
	desc = "A heavy steel sledgehammer, a weapon designed to make knights run in fear, the best option for a common soldier against a knight."
	icon = 'icons/roguetown/weapons/32/clubs.dmi'
	icon_state = "warbonker"
	force = DAMAGE_HAMMER + 5
	force_wielded = DAMAGE_HAMMER_WIELD + 10
	max_integrity = INTEGRITY_STRONGEST
	melting_material = /datum/material/steel
	toolspeed = 1.5 //it's for crushing skulls not nails
	item_weight = 8.4 KILOGRAMS

/obj/item/weapon/hammer/sledgehammer/war/malum
	name = "forgefiend"
	desc = "This hammer's creation took a riddle in its own making. A great sacrifice for perfect quality"
	icon = 'icons/roguetown/weapons/64/patron.dmi'
	icon_state = "malumhammer"
	force = DAMAGE_MACE
	force_wielded = DAMAGE_HEAVYCLUB_WIELD
	wdefense = GOOD_PARRY
	wbalance = DODGE_CHANCE_NORMAL
	max_integrity = INTEGRITY_STRONGEST * 1.2
	minstr = 10

	pixel_y = -16
	pixel_x = -16
	inhand_x_dimension = 64
	inhand_y_dimension = 64
	bigboy = TRUE
	gripsprite = TRUE
	wlength = WLENGTH_LONG
	w_class = WEIGHT_CLASS_HUGE
	slot_flags = ITEM_SLOT_BACK
	melt_amount = 150
	sellprice = 1	//breaking bad cash pallet dot jpg

/obj/item/weapon/hammer/sledgehammer/war/malum/getonmobprop(tag)
	. = ..()
	if(tag)
		switch(tag)
			if("gen")
				return list("shrink" = 0.6,"sx" = -7,"sy" = 2,"nx" = 7,"ny" = 3,"wx" = -2,"wy" = 1,"ex" = 1,"ey" = 1,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0,"nturn" = -38,"sturn" = 37,"wturn" = 30,"eturn" = -30,"nflip" = 0,"sflip" = 8,"wflip" = 8,"eflip" = 0)
			if("wielded")
				return list("shrink" = 0.6,"sx" = 5,"sy" = -3,"nx" = -5,"ny" = -2,"wx" = -5,"wy" = -1,"ex" = 3,"ey" = -2,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0,"nturn" = 7,"sturn" = -7,"wturn" = 16,"eturn" = -22,"nflip" = 8,"sflip" = 0,"wflip" = 8,"eflip" = 0)
			if("onbelt")
				return list("shrink" = 0.3,"sx" = -2,"sy" = -5,"nx" = 4,"ny" = -5,"wx" = 0,"wy" = -5,"ex" = 2,"ey" = -5,"nturn" = 0,"sturn" = 0,"wturn" = 0,"eturn" = 0,"nflip" = 0,"sflip" = 0,"wflip" = 0,"eflip" = 0,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0)
