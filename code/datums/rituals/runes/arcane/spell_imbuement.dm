/obj/effect/decal/cleanable/ritual_rune/arcyne/spellobject_imbue
	name = "arcyne imbuing seal"
	desc = "A sigil of binding. Place a spell object and invoke your knowledge to seal a spell within."
	icon = 'icons/effects/160x160.dmi'
	icon_state = "imbuement"
	tier = 2
	runesize = 2
	SET_BASE_PIXEL(-64, -64)
	pixel_z = 0
	invocation = "Keth'avar sul'dorath imn!"
	can_be_scribed = TRUE
	color = "#2F7BBE"

	/// The spellobject placed on the rune
	var/obj/item/arcyne_spellobject/staged_object = null
	/// The spell focus placed on the rune
	var/obj/item/spell_focus/staged_focus = null
	/// TRUE while the animation plays
	var/animating = FALSE

/obj/effect/decal/cleanable/ritual_rune/arcyne/spellobject_imbue/attack_hand(mob/living/user)
	if(animating)
		to_chat(user, span_notice("The seal is already working..."))
		return
	if(!user.get_active_held_item())
		if(staged_object && staged_focus)
			try_invoke(user)
		else
			var/missing = list()
			if(!staged_object) missing += "a spell object"
			if(!staged_focus)  missing += "a spell focus"
			to_chat(user, span_hierophant_warning("The seal needs [english_list(missing)] to proceed."))
		return

/obj/effect/decal/cleanable/ritual_rune/arcyne/spellobject_imbue/attackby(obj/item/W, mob/user, list/modifiers)
	if(animating)
		to_chat(user, span_notice("The seal is already working..."))
		return
	if(istype(W, /obj/item/arcyne_spellobject))
		if(staged_object)
			to_chat(user, span_notice("A spell object is already placed here."))
			return
		user.temporarilyRemoveItemFromInventory(W)
		W.forceMove(get_turf(src))
		W.anchored = TRUE
		staged_object = W
		animate(W, pixel_x = -16, pixel_y = 0, time = 0.5 SECONDS, flags = ANIMATION_END_NOW)
		to_chat(user, span_cultsmall("The [W.name] settles onto the seal..."))
		playsound(src, 'sound/magic/glass.ogg', 60, TRUE)
		return
	if(istype(W, /obj/item/spell_focus))
		if(staged_focus)
			to_chat(user, span_notice("A spell focus is already placed here."))
			return
		user.temporarilyRemoveItemFromInventory(W)
		W.forceMove(get_turf(src))
		W.anchored = TRUE
		staged_focus = W
		animate(W, pixel_x = 16, pixel_y = 0, time = 0.5 SECONDS, flags = ANIMATION_END_NOW)
		to_chat(user, span_cultsmall("The [W.name] settles onto the seal..."))
		playsound(src, 'sound/magic/glass.ogg', 60, TRUE)
		return
	return ..()

/obj/effect/decal/cleanable/ritual_rune/arcyne/spellobject_imbue/proc/try_invoke(mob/living/user)
	if(GET_MOB_SKILL_VALUE(user, /datum/attribute/skill/magic/arcane) <= SKILL_LEVEL_NONE)
		to_chat(user, span_warning("You aren't able to invoke these symbols."))
		return
	if(rune_in_use)
		to_chat(user, span_notice("The seal is already active."))
		return
	rune_in_use = TRUE
	animating = TRUE

	user.say(invocation, language = /datum/language/common, ignore_spam = TRUE, forced = "cult invocation")
	playsound(src, 'sound/magic/cosmic_expansion.ogg', 60, TRUE)
	SpinAnimation(speed = 1.5 SECONDS, loops = 1, clockwise = TRUE, segments = 6, parallel = TRUE)

	INVOKE_ASYNC(src, PROC_REF(run_imbue_animation), user)

/obj/effect/decal/cleanable/ritual_rune/arcyne/spellobject_imbue/proc/run_imbue_animation(mob/living/user)
	animate(staged_focus,
		pixel_x = 0, pixel_y = 0,
		alpha = 0,
		transform = matrix() * 0.2,
		time = 1.5 SECONDS,
		flags = ANIMATION_END_NOW
	)
	sleep(1.5 SECONDS)

	var/success = staged_object.imbue_spell(
		user,
		staged_focus.stored_spell_type,
		staged_focus.spell_tier,
		staged_focus.grant_charges
	)

	if(success)
		qdel(staged_focus)
		staged_focus = null
		animate(staged_object,
			transform = matrix() * 1.3,
			time = 0.3 SECONDS,
			flags = ANIMATION_END_NOW
		)
		sleep(0.3 SECONDS)
		animate(staged_object,
			transform = matrix(),
			time = 0.3 SECONDS,
			flags = ANIMATION_END_NOW
		)
		sleep(0.3 SECONDS)
		playsound(src, 'sound/magic/blink.ogg', 80, TRUE)
	else
		for(var/i in 1 to 3)
			animate(staged_object, pixel_x = -4, time = 0.1 SECONDS, flags = ANIMATION_END_NOW)
			sleep(0.1 SECONDS)
			animate(staged_object, pixel_x = 4, time = 0.1 SECONDS, flags = ANIMATION_END_NOW)
			sleep(0.1 SECONDS)
		animate(staged_object, pixel_x = 0, time = 0.1 SECONDS, flags = ANIMATION_END_NOW)
		sleep(0.1 SECONDS)

	staged_object.anchored = FALSE
	animate(staged_object, pixel_x = 0, pixel_y = 0, time = 0.4 SECONDS, flags = ANIMATION_END_NOW)
	staged_object = null
	if(staged_focus)
		staged_focus.anchored = FALSE
		staged_focus.alpha = 255
		staged_focus = null

	animating = FALSE
	rune_in_use = FALSE
	do_invoke_glow()

/obj/effect/decal/cleanable/ritual_rune/arcyne/spellobject_imbue/proc/abort_imbue()
	if(staged_focus && !QDELETED(staged_focus))
		staged_focus.anchored = FALSE
		animate(staged_focus, pixel_x = 0, pixel_y = 0, time = 0.5 SECONDS, flags = ANIMATION_END_NOW)
	if(staged_object && !QDELETED(staged_object))
		staged_object.anchored = FALSE
		animate(staged_object, pixel_x = 0, pixel_y = 0, time = 0.5 SECONDS, flags = ANIMATION_END_NOW)
	staged_focus = null
	staged_object = null
	animating = FALSE
	rune_in_use = FALSE

/obj/effect/decal/cleanable/ritual_rune/arcyne/spellobject_imbue/Destroy()
	abort_imbue()
	return ..()
