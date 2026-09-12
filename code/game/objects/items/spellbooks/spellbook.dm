/obj/item/spellbook
	icon = 'icons/roguetown/items/books.dmi'
	icon_state = "spellbookbrown_0"
	slot_flags = ITEM_SLOT_HIP
	firefuel = 2 MINUTES
	dropshrink = 0.6
	drop_sound = 'sound/foley/dropsound/book_drop.ogg'
	force = 5
	associated_skill = /datum/attribute/skill/misc/reading
	name = "tome of the arcyne"
	desc = "A crackling, glowing book, filled with runes and symbols that hurt the mind to stare at."
	item_weight = 547 GRAMS
	grid_height = 64
	grid_width = 32

	pickpocket_difficulty = SKILL_RANK_JOURNEYMAN

	/// The mob who owns and originally bound this tome
	var/mob/living/owner = null
	/// Up to two additional mobs allowed to read this tome
	var/list/allowed_readers = list()
	/// Flat quality bonus stored from a crushed gem, consumed on next read
	var/stored_gem = FALSE
	/// Attunement datum stored from the gem used, applied on next read
	var/datum/attunement/stored_attunement
	/// Whether the player has chosen a visual style for this book yet
	var/picked = FALSE
	/// If TRUE, this tome was made from a magic stone rather than a gem and has a reading penalty
	var/born_of_rock = FALSE
	/// Multiplier for spell points gained per read. Higher = better book.
	var/bookquality = 3
	var/datum/spell_mastery/mastery
	/// If set, this book is specialized in one form and gets bonus points + spell buffs for it
	var/themed_form = null
	/// Total innate points this book grants toward its form track on creation
	var/base_form_points = 0
	/// Total innate points this book grants toward the (generic) technique pool on creation
	var/base_technique_points = 0
	/// Cost multiplier for spells of themed_form (below 1 = cheaper)
	var/themed_cost_multiplier = 1
	var/themed_cast_speed_multiplier = 1
	/// Flat magnitude addition for spells of themed_form
	var/themed_magnitude_bonus = 0

	var/list/designlist = list("green", "yellow", "brown")

	var/open = FALSE

/obj/item/spellbook/Initialize()
	. = ..()
	mastery = new /datum/spell_mastery(null, src)
	apply_themed_bonuses()
	RegisterSignal(src, COMSIG_MASTERY_CAST, PROC_REF(compare_magic))
	RegisterSignal(src, COMSIG_MASTERY_CHECK_PARENT, PROC_REF(is_open))
	if(length(designlist) == 1)
		base_icon_state = "spellbook[designlist[1]]"
		update_appearance(UPDATE_ICON_STATE)
		picked = TRUE

/obj/item/spellbook/proc/is_open()
	if(!ismob(loc))
		return COMPONENT_MASTERY_CANCEL
	var/mob/living/liver = loc
	if(owner)
		if(!compare_magic(src, liver, FALSE))
			return COMPONENT_MASTERY_CANCEL
	return !open

/obj/item/spellbook/proc/get_or_make_mastery()
	if(!mastery)
		mastery = new /datum/spell_mastery(null, src)
	return mastery

/obj/item/spellbook/proc/apply_themed_bonuses()
	if(base_form_points > 0)
		if(themed_form)
			var/themed_amount = CEILING(base_form_points * 0.5, 1)
			var/generic_amount = base_form_points - themed_amount
			mastery.adjust_form_mastery_points(themed_amount, FALSE, themed_form)
			if(generic_amount)
				mastery.adjust_form_points(generic_amount)
		else
			mastery.adjust_form_points(base_form_points)

	if(base_technique_points > 0)
		mastery.adjust_technique_points(base_technique_points)

	if(themed_form && (themed_cost_multiplier != 1 || themed_cast_speed_multiplier != 1 || themed_magnitude_bonus != 0))
		AddComponent(/datum/component/spell_modifier, \
			list("[themed_form]" = themed_cost_multiplier), \
			list("[themed_form]" = themed_cast_speed_multiplier), \
			list("[themed_form]" = themed_magnitude_bonus))

/// The open and closed states share identical mob prop data, so we return
/// one table regardless of open state.
/obj/item/spellbook/getonmobprop(tag)
	. = ..()
	if(!tag)
		return
	switch(tag)
		if("gen")
			return list(
				"shrink" = 0.4,
				"sx" = -2, "sy" = -3,
				"nx" = 10, "ny" = -2,
				"wx" = 1,  "wy" = -3,
				"ex" = 5,  "ey" = -3,
				"northabove" = 0, "southabove" = 1,
				"eastabove" = 1,  "westabove" = 0,
				"nturn" = 0, "sturn" = 0, "wturn" = 0, "eturn" = 0,
				"nflip" = 0, "sflip" = 0, "wflip" = 0, "eflip" = 0
			)
		if("onbelt")
			return list(
				"shrink" = 0.3,
				"sx" = -2, "sy" = -5,
				"nx" = 4,  "ny" = -5,
				"wx" = 0,  "wy" = -5,
				"ex" = 2,  "ey" = -5,
				"nturn" = 0, "sturn" = 0, "wturn" = 0, "eturn" = 0,
				"nflip" = 0, "sflip" = 0, "wflip" = 0, "eflip" = 0,
				"northabove" = 0, "southabove" = 1,
				"eastabove" = 1,  "westabove" = 0
			)

/obj/item/spellbook/update_icon_state()
	. = ..()
	icon_state = "[base_icon_state]_[open]"

/obj/item/spellbook/attack_self(mob/user, list/modifiers)
	if(!open)
		attack_hand_secondary(user, modifiers)
		return
	if(!compare_magic(src, user))
		return
	if(SEND_SIGNAL(src, COMSIG_ITEM_ATTACK_SELF, user, modifiers) & COMPONENT_CANCEL_ATTACK_CHAIN)
		return TRUE
	. = ..()

/obj/item/spellbook/attack_self_secondary(mob/user, list/modifiers)
	. = ..()
	if(. == SECONDARY_ATTACK_CANCEL_ATTACK_CHAIN)
		return
	attack_hand_secondary(user, modifiers)
	return SECONDARY_ATTACK_CANCEL_ATTACK_CHAIN

/obj/item/spellbook/attack_hand_secondary(mob/user, list/modifiers)
	if(!picked)
		var/the_time = world.time
		var/design = tgui_input_list(user, "Select a design.", "Spellbook Design", designlist)
		if(!design || world.time > (the_time + 30 SECONDS))
			return
		base_icon_state = "spellbook[design]"
		update_appearance(UPDATE_ICON_STATE)
		picked = TRUE
		return
	if(ishuman(loc))
		if(!(src in user.get_active_held_items()))
			return
	if(owner == null)
		owner = user
	attempt_open(user)

/obj/item/spellbook/proc/attempt_open(mob/user)
	if(!compare_magic(src, user))
		return
	if(!open)
		slot_flags &= ~ITEM_SLOT_HIP
		open = TRUE
		playsound(src, 'sound/items/book_open.ogg', 100, FALSE, -1)
		if(ismob(loc) && !HAS_TRAIT(loc, TRAIT_SORCERER) && !HAS_TRAIT(loc, TRAIT_BLOOD_SORCERER))
			SEND_SIGNAL(src, COMSIG_MASTERY_ADD_SPELLS, user)
	else
		slot_flags |= ITEM_SLOT_HIP
		open = FALSE
		playsound(src, 'sound/items/book_close.ogg', 100, FALSE, -1)
		if(ismob(loc))
			SEND_SIGNAL(src, COMSIG_MASTERY_REMOVE_SPELLS, user)
	update_appearance(UPDATE_ICON_STATE)
	user.update_inv_hands()

/obj/item/spellbook/proc/compare_magic(datum/source, mob/user, recoil = TRUE)
	if(!(user in allowed_readers) && user != owner)
		var/magic_compare = GET_MOB_SKILL_VALUE(user, /datum/attribute/skill/magic/arcane)
		var/owners_magic = GET_MOB_SKILL_VALUE(owner, /datum/attribute/skill/magic/arcane)
		if(owners_magic > magic_compare)
			if(recoil)
				check_reader_and_recoil(src, user)
			return FALSE
	return TRUE

/// Punishes anyone casting a spell sourced from this book who isn't the owner or an
/// allowed reader. Does not prevent the cast - only recoil()s them.
/obj/item/spellbook/proc/check_reader_and_recoil(datum/source, mob/living/cast_on)
	SIGNAL_HANDLER
	var/mob/living/user = loc
	if(!istype(user))
		return
	if(!user)
		return
	if(user == owner)
		return
	if(user in allowed_readers)
		return
	addtimer(CALLBACK(src, PROC_REF(recoil), user), 0.1 SECONDS)

/obj/item/spellbook/interact_with_atom(atom/interacting_with, mob/living/user, list/modifiers)
	if(!isliving(interacting_with))
		return NONE

	var/mob/living/target = interacting_with
	if(target.stat == DEAD)
		target.visible_message(span_danger("[user] smacks [target]'s lifeless corpse with [src]."))
		playsound(src, "punch", 25, TRUE, -1)
		return

	if(user == target)
		to_chat(user, span_warning("I'm already chained to this tome!"))
		return

	target.visible_message(
		span_danger("[user] beats [target] over the head with [src]!"),
		span_danger("[user] beats [target] over the head with [src]!")
	)

	if(length(allowed_readers) > 2 || (target in allowed_readers))
		to_chat(user, span_smallnotice("I can't chain [target.p_them()] to my tome..."))
		return

	allowed_readers += target

	playsound(src, "punch", 25, TRUE, -1)

/obj/item/spellbook/proc/recoil(mob/user)
	user.visible_message(span_warning("[src] shoots out a spark of angry, arcyne energy at [user]!"))
	var/mob/living/gamer = user
	gamer.electrocute_act(5, src)

/obj/item/spellbook/horrible
	name = "poorly made tome of the arcyne"
	desc = "A poorly made book, it barely glows with arcyne and has only small notes on arcyne symbols."
	bookquality = 1
	sellprice = 15

/obj/item/spellbook/mid
	name = "beginners tome of the arcyne"
	desc = "An obviously handcrafted book, it glows occasionally with arcyne and has a meager amount of notes on arcyne symbols."
	bookquality = 2
	sellprice = 30

/obj/item/spellbook/apprentice
	name = "apprentice tome of the arcyne"
	desc = "A carefully made book, faintly glowing with arcyne and half filled with notes and theory on arcyne symbols."
	bookquality = 3
	sellprice = 75

/obj/item/spellbook/adept
	name = "adept tome of the arcyne"
	desc = "A well-made book, it shines moderately with arcyne light. It has been filled with notes of varying degrees on the arcyne."
	bookquality = 4
	sellprice = 150

/obj/item/spellbook/expert
	name = "expert tome of the arcyne"
	desc = "A well cared for book, shining brightly with arcyne. It has many runes and arcyne symbols scribed within, with detailed notes."
	bookquality = 6
	sellprice = 200

/obj/item/spellbook/master
	name = "masterful tome of the arcyne"
	desc = "A crackling, glowing book, filled with advanced arcyne runes and symbols that hurt the mind to stare at. A true master of the arcyne has left their mark behind."
	bookquality = 8
	sellprice = 250
	pickpocket_difficulty = SKILL_RANK_EXPERT

/obj/item/spellbook/legendary
	name = "legendary tome of the arcyne"
	desc = "An incredible book that gives off glowing arcyne motes, it is filled with runes and arcyne theories that is hard for even masters of arcyne to understand. The arcyne script glows and practically whispers from the page..."
	bookquality = 12
	sellprice = 400
	pickpocket_difficulty = SKILL_RANK_MASTER
