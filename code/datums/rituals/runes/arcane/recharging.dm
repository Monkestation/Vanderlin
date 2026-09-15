/obj/effect/decal/cleanable/ritual_rune/arcyne/recharge
	name = "arcyne recharging matrix"
	desc = "A tight, coiling sigil that hungers to feed dormant pages."
	icon = 'icons/effects/160x160.dmi'
	icon_state = "portal"
	tier = 1
	runesize = 1
	SET_BASE_PIXEL(-64, -64)
	pixel_z = 0
	invocation = "Veth'kael sar'un renai!"
	can_be_scribed = TRUE
	color = "#2F9BBE"

	/// Mana cost to invok
	var/mana_cost = 70
	/// Minimum arcane skill required to invoke this rune at all
	var/required_skill = SKILL_LEVEL_NONE
	/// The spellbook currently staged on the rune, if any
	var/obj/item/staged_book = null
	/// TRUE while the animation is playing; blocks all interaction
	var/animating = FALSE

/obj/effect/decal/cleanable/ritual_rune/arcyne/recharge/Destroy()
	abort_ritual()
	return ..()

/obj/effect/decal/cleanable/ritual_rune/arcyne/recharge/attack_hand(mob/living/user)
	if(animating)
		to_chat(user, span_notice("The rune is already working..."))
		return

	if(user.get_active_held_item())
		return
	if(staged_book)
		try_invoke(user)
		return
	return ..()

/obj/effect/decal/cleanable/ritual_rune/arcyne/recharge/attack_hand_secondary(mob/living/user, list/modifiers)
	if(animating)
		to_chat(user, span_notice("The rune is already working..."))
		return
	if(!staged_book)
		return ..()
	abort_ritual()
	to_chat(user, span_cultsmall("The book clatters free from the rune."))
	playsound(src, 'sound/magic/glass.ogg', 40, TRUE)

/obj/effect/decal/cleanable/ritual_rune/arcyne/recharge/item_interaction(mob/living/user, obj/item/tool, list/modifiers)
	if(user.cmode)
		return NONE

	if(tool.item_flags & ABSTRACT || HAS_TRAIT(tool, TRAIT_NODROP))
		return NONE

	if(animating)
		to_chat(user, span_notice("The rune is already working..."))
		return ITEM_INTERACT_BLOCKING

	if(!istype(tool, /obj/item/spellbook))
		to_chat(user, span_hierophant_warning("Only a spellbook can be placed here."))
		return ITEM_INTERACT_BLOCKING

	if(staged_book)
		to_chat(user, span_notice("There's already a book placed on the rune."))
		return ITEM_INTERACT_BLOCKING

	user.temporarilyRemoveItemFromInventory(tool)
	tool.forceMove(get_turf(src))
	tool.anchored = TRUE
	staged_book = tool
	animate(tool, pixel_x = 0, pixel_y = 0, time = 0.7 SECONDS, flags = ANIMATION_END_NOW)

	to_chat(user, span_cultsmall("The book settles onto the rune, spine humming faintly..."))
	playsound(src, 'sound/magic/glass.ogg', 60, TRUE)
	return ITEM_INTERACT_SUCCESS

/obj/effect/decal/cleanable/ritual_rune/arcyne/recharge/proc/try_invoke(mob/living/user)
	if(GET_MOB_SKILL_VALUE(user, /datum/attribute/skill/magic/arcane) <= SKILL_LEVEL_NONE)
		to_chat(user, span_warning("You aren't able to invoke these symbols."))
		return
	if(rune_in_use)
		to_chat(user, span_notice("The rune is already active."))
		return
	rune_in_use = TRUE
	animating = TRUE

	var/skill_level = GET_MOB_SKILL_VALUE(user, /datum/attribute/skill/magic/arcane)
	if(skill_level < required_skill)
		to_chat(user, span_hierophant_warning("My arcyne is not refined enough to complete this working..."))
		abort_ritual()
		return
	if(user.mana_pool.amount < mana_cost)
		to_chat(user, span_hierophant_warning("My mana is lacking..."))
		abort_ritual()
		return
	user.mana_pool.adjust_mana(-mana_cost)

	user.say(invocation, language = /datum/language/common, ignore_spam = TRUE, forced = "cult invocation")
	playsound(src, 'sound/magic/cosmic_expansion.ogg', 60, TRUE)
	SpinAnimation(
		speed = 1.5 SECONDS,
		loops = 10,
		clockwise = TRUE,
		segments = 6,
		parallel = TRUE
	)

	INVOKE_ASYNC(src, PROC_REF(run_recharge_animation), user)

/obj/effect/decal/cleanable/ritual_rune/arcyne/recharge/proc/run_recharge_animation(mob/living/user)
	var/obj/item/spellbook/book = staged_book

	// pulse the book brighter as it charges
	for(var/i = 1 to 10)
		animate(book, transform = matrix() * 1.15, time = 0.8 SECONDS, flags = ANIMATION_END_NOW)
		sleep(0.8 SECONDS)
		animate(book, transform = matrix(), time = 0.6 SECONDS, flags = ANIMATION_END_NOW)
		sleep(0.6 SECONDS)

	playsound(src, 'sound/magic/blink.ogg', 80, TRUE)

	var/datum/spell_mastery/mastery = book.mastery
	if(mastery)
		mastery.reset_spellbook_charges(book)
		to_chat(user, span_hierophant_warning("The book's pages flare, charges restored."))
	else
		to_chat(user, span_warning("...nothing happens. The book seems inert."))

	book.anchored = FALSE
	staged_book = null

	if(user.put_in_hands(book))
		to_chat(user, span_cultsmall("The book leaps back into my grip."))

	animating = FALSE
	rune_in_use = FALSE

	user.mind.add_sleep_experience(/datum/attribute/skill/magic/arcane, (GET_MOB_ATTRIBUTE_VALUE(user, STAT_INTELLIGENCE) * 2) + required_skill, FALSE)

	do_invoke_glow()

/obj/effect/decal/cleanable/ritual_rune/arcyne/recharge/proc/abort_ritual()
	if(!QDELETED(staged_book))
		staged_book.anchored = FALSE
		animate(staged_book, pixel_x = 0, pixel_y = 0, time = 0.5 SECONDS, flags = ANIMATION_END_NOW)
	staged_book = null
	animating = FALSE
	rune_in_use = FALSE
