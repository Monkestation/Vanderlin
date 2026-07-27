
/obj/item/rope
	name = "rope"
	desc = "A series of threads intertwined to create a firm rope for binding, hanging and other jobs."
	gender = PLURAL
	icon = 'icons/roguetown/items/misc.dmi'
	icon_state = "rope"
	slot_flags = ITEM_SLOT_HIP|ITEM_SLOT_WRISTS|ITEM_SLOT_NECK|ITEM_SLOT_BELT
	throwforce = 3
	w_class = WEIGHT_CLASS_SMALL
	throw_speed = 1
	throw_range = 5
	breakouttime = 10 SECONDS
	slipouttime = 30 SECONDS
	possible_item_intents = list(/datum/intent/tie)
	firefuel = 5 MINUTES
	drop_sound = 'sound/foley/dropsound/cloth_drop.ogg'
	grid_height = 64
	grid_width = 32
	item_weight = 300 GRAMS
	var/legcuff_multiplicative_slowdown = 3

/obj/item/rope/mob_can_equip(mob/living/M, mob/living/equipper, slot, disable_warning, bypass_equip_delay_self)
	. = ..()
	if(.)
		if((slot & ITEM_SLOT_BELT) && !equipper)
			if(!do_after(M, 1.5 SECONDS, src))
				return FALSE

/obj/item/rope/equipped(mob/living/carbon/human/user, slot)
	. = ..()
	if(slot & ITEM_SLOT_BELT)
		user.temporarilyRemoveItemFromInventory(src)
		user.equip_to_slot_if_possible(new /obj/item/storage/belt/leather/rope(get_turf(user)), ITEM_SLOT_BELT)
		qdel(src)

/datum/intent/tie
	name = "tie"
	icon_state = "intie"
	chargetime = 0
	noaa = TRUE
	candodge = FALSE
	canparry = FALSE
	misscost = 0

/obj/item/rope/Destroy()
	if(iscarbon(loc))
		var/mob/living/carbon/M = loc
		if(M.handcuffed == src)
			M.set_handcuffed(null)
			M.update_handcuffed()
			if(M.buckled && M.buckled.buckle_requires_restraints)
				M.buckled.unbuckle_mob(M)
		if(M.legcuffed == src)
			M.legcuffed = null
			M.update_inv_legcuffed()
			M.remove_movespeed_modifier(MOVESPEED_ID_LEGCUFF_SLOWDOWN, TRUE)
	return ..()

/obj/item/rope/attack(mob/living/carbon/C, mob/living/user, list/modifiers)
	if(user.used_intent.type != /datum/intent/tie)
		..()
		return

	if(!istype(C))
		return

	var/surrender_mod = 1
	if(C.surrendering || HAS_TRAIT(C, TRAIT_BAGGED))
		surrender_mod = 0.5
	if(user.aimheight >= 5)
		if(!C.handcuffed)
			if(C.num_hands)
				C.visible_message(span_warning("[user] is trying to tie [C]'s arms with [src.name]!"), \
									span_danger("[user] is trying to tie my arms with [src.name]!"))
				if(do_after(user, 6 SECONDS * (surrender_mod), C) && C.num_hands)
					apply_cuffs(C, user, leg = FALSE)
					C.visible_message(span_warning("[user] ties [C]' arms with [src.name]."), \
										span_danger("[user] ties my arms up with [src.name]."))
					SSblackbox.record_feedback("tally", "handcuffs", 1, type)
					user.adjust_experience(/datum/attribute/skill/craft/traps, GET_MOB_ATTRIBUTE_VALUE(C, STAT_INTELLIGENCE), FALSE)
					log_combat(user, C, "handcuffed")
				else
					to_chat(user, span_warning("I fail to tie up [C]'s arms!</span>"))
			else
				to_chat(user, span_warning("[C] is missing two or one arms."))
	else
		if(!C.legcuffed)
			if(C.num_legs)
				C.visible_message(span_warning("[user] is trying to tie [C]'s legs with [src.name]!"), \
									span_danger("[user] is trying to tie my legs with [src.name]!"))
				if(do_after(user, 6 SECONDS * (C.surrendering ? 0.5 : 1), C) && C.num_legs)
					apply_cuffs(C, user, leg = TRUE)
					C.visible_message(span_warning("[user] ties [C]' legs with [src.name]."), \
										span_danger("[user] ties my legs up with [src.name]."))
					SSblackbox.record_feedback("tally", "legcuffs", 1, type)
					user.adjust_experience(/datum/attribute/skill/craft/traps, GET_MOB_ATTRIBUTE_VALUE(C, STAT_INTELLIGENCE), FALSE)
					log_combat(user, C, "legcuffed")
				else
					to_chat(user, span_warning("I fail to tie up [C]'s legs!</span>"))
			else
				to_chat(user, span_warning("[C] is missing two or one legs."))

/obj/item/rope/proc/apply_cuffs(mob/living/carbon/target, mob/user, leg = FALSE)
	if(!leg)
		if(target.handcuffed)
			return

		if(user && !user.temporarilyRemoveItemFromInventory(src) )
			return

		var/obj/item/cuffs = src

		cuffs.forceMove(target)
		target.set_handcuffed(cuffs)

		target.update_handcuffed()
		return TRUE
	else
		if(target.legcuffed)
			return

		if(user && !user.temporarilyRemoveItemFromInventory(src))
			return

		var/obj/item/cuffs = src

		cuffs.forceMove(target)
		target.legcuffed = cuffs

		target.add_movespeed_modifier(MOVESPEED_ID_LEGCUFF_SLOWDOWN, multiplicative_slowdown = legcuff_multiplicative_slowdown)

		target.update_inv_legcuffed()
		return TRUE

/obj/item/rope/chain
	name = "chain"
	desc = "Metal chains designed to interlock and apply the harshest confinement on the villainous."
	icon = 'icons/roguetown/items/misc.dmi'
	icon_state = "chain"
	slot_flags = ITEM_SLOT_HIP|ITEM_SLOT_WRISTS
	force = DAMAGE_WHIP - 10
	throwforce = DAMAGE_WHIP - 15
	wdefense = MEDIOCRE_PARRY
	possible_item_intents = list(/datum/intent/tie, WHIP_LASH)
	blade_dulling = DULLING_BASHCHOP
	slot_flags = ITEM_SLOT_HIP|ITEM_SLOT_WRISTS
	parrysound = list('sound/combat/parry/parrygen.ogg')
	swingsound = WHIPWOOSH
	w_class = WEIGHT_CLASS_SMALL
	associated_skill = /datum/attribute/skill/combat/whipsflails
	throw_speed = 1
	throw_range = 3
	breakouttime = 30 SECONDS
	slipouttime = 1 MINUTES
	melting_material = /datum/material/iron
	melt_amount = 40
	firefuel = null
	item_weight = 1.2 KILOGRAMS
	drop_sound = 'sound/foley/dropsound/chain_drop.ogg'

/obj/item/rope/net
	name = "rope net"
	desc = "A rope mesh of designed to slow a person down."
	icon = 'icons/roguetown/items/misc.dmi'
	icon_state = "net"
	slot_flags = ITEM_SLOT_HIP|ITEM_SLOT_WRISTS
	w_class = WEIGHT_CLASS_SMALL
	icon_state = "net"
	throw_speed = 1.5
	breakouttime = 3.5 SECONDS //easy to apply, easy to break out of
	gender = NEUTER
	var/knockdown = 2 SECONDS
	legcuff_multiplicative_slowdown = 2
	item_weight = 500 GRAMS

/obj/item/rope/net/throw_at(atom/target, range, speed, mob/thrower, spin=1, diagonals_first = 0, datum/callback/callback, force, gentle = FALSE)
	. = ..()
	if(.)
		playsound(src,'sound/combat/wooshes/flail_swing.ogg', 75, TRUE)

/obj/item/rope/net/throw_impact(atom/hit_atom, datum/thrownthing/throwingdatum)
	if(..() || !iscarbon(hit_atom))//if it gets caught or the target can't be cuffed,
		return//abort
	var/mob/thrower = throwingdatum.get_thrower()
	if(prob(100 * (GET_MOB_SKILL_VALUE_OLD(thrower, /datum/attribute/skill/craft/traps) || 1) / 3))
		ensnare(hit_atom)

/obj/item/rope/net/proc/ensnare(mob/living/carbon/C)
	if(C.num_legs >= 2 && apply_cuffs(C, leg = TRUE))
		C.visible_message(span_danger("[src] ensnares [C]!"), span_userdanger("[src] entraps you!!"))
		SSblackbox.record_feedback("tally", "handcuffs", 1, type)
		C.apply_status_effect(/datum/status_effect/debuff/netted)
		playsound(src, 'sound/combat/hits/nodmg (2).ogg', 100, TRUE)
		if((C.m_intent = MOVE_INTENT_RUN || HAS_TRAIT(C, TRAIT_STUMBLE)) && C.body_position == STANDING_UP && C.sprinted_tiles > 0)
			C.Knockdown(knockdown)

/obj/item/rope/net/dropped(mob/living/carbon/user, silent)
	. = ..()
	if(istype(user) && user.legcuffed == src)
		user.remove_status_effect(/datum/status_effect/debuff/netted)

// Failsafe in case the item somehow ends up being destroyed
/obj/item/rope/net/Destroy()
	if(iscarbon(loc))
		var/mob/living/carbon/M = loc
		if(M.legcuffed == src)
			M.remove_status_effect(/datum/status_effect/debuff/netted)
	return ..()
