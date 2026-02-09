/obj/item/phantom_ear
	name = "Phantom Ear"
	desc = "A spectral facsimile of an ear."
	var/chat_icon = 'icons/Phantom_Ear_Icon.dmi'
	var/chat_icon_state = "sparkly_ear_icon"
	icon = 'icons/roguetown/misc/phantomear.dmi'
	icon_state = "ear_ring"
	invisibility = INVISIBILITY_LEYLINES
	w_class = WEIGHT_CLASS_TINY
	var/hear_radius = 2
	var/muted = FALSE
	var/datum/weakref/linked_living

/obj/item/phantom_ear/Initialize()
	. = ..()
	ADD_TRAIT(src, TRAIT_RUNECHAT_HIDDEN, TRAIT_GENERIC)
	become_hearing_sensitive()

/obj/item/phantom_ear/proc/setup(mob/living/user)
	if(!istype(user))
		return
	linked_living = WEAKREF(user)

/obj/item/phantom_ear/Destroy()
	lose_hearing_sensitivity()
	linked_living = null
	return ..()

/obj/item/phantom_ear/proc/hurt_caster()
	var/mob/living/linked = linked_living?.resolve()
	if(linked)
		linked.add_stress(/datum/stress_event/ear_crushed)
		linked.emote("painscream")
		linked.Immobilize(10)
		linked.Knockdown(10)
		linked.apply_damage(15, BRUTE, "head")

/obj/item/phantom_ear/proc/reset_visibility()
	if(!isturf(loc))
		return
	invisibility = initial(invisibility)

/obj/item/phantom_ear/proc/timed_delete()
	if(QDELETED(src))
		return
	src.visible_message(span_warning("The [src] escapes this world's grasp!"))
	if(linked_living)
		to_chat(linked_living.resolve(), span_warning("I feel a tension release, my phantom ear has safely escaped!"))
	qdel(src)

/obj/item/phantom_ear/attack_hand(mob/user)
	. = ..()
	user.visible_message(span_warning("[user] thrusts [user.p_their()] hand into the air and clenches tightly, as a pale ear materializes in its grasp!"))
	playsound(src, 'sound/vo/mobs/rat/rat_life.ogg', 100, FALSE, -1)
	name = "Phantom Ear"
	desc = "A spectral facsimile of an ear that squirms in your hand."
	icon_state = "round_round_ear"
	hear_radius = 0
	invisibility = NONE
	if(linked_living)
		to_chat(linked_living.resolve(), span_warning("I feel a strange tightness in the side of my head."))
	addtimer(CALLBACK(src, PROC_REF(timed_delete)), 2 MINUTES)

/obj/item/phantom_ear/attack_self(mob/user, list/modifiers)
	if(user != linked_living?.resolve())
		user.visible_message(span_boldwarning("[user] crushed the [src] in [user.p_their()] hand!"))
		playsound(src, 'sound/vo/mobs/rat/rat_death.ogg', 100, FALSE, -1)
		if(linked_living)
			hurt_caster()
			to_chat(linked_living.resolve(), span_boldwarning("I feel a splitting pain in the side of my head, my phantom ear has been crushed!"))
	else
		to_chat(user, span_warning("I discretely palm the ear and dispel it."))
	qdel(src)

/obj/item/phantom_ear/throw_impact(atom/hit_atom, datum/thrownthing/throwingdatum)
	. = ..()
	src.visible_message(span_warning("The [src] shatters against the [hit_atom]!"))
	playsound(src, 'sound/magic/glass.ogg', 100, FALSE, -1)
	if(linked_living)
		hurt_caster()
		to_chat(linked_living.resolve(), span_boldwarning("I feel a hundred needles pierce the side of my head, my phantom ear has been shattered!"))
	qdel(src)

/obj/item/phantom_ear/Hear(message, atom/movable/speaker, message_language, raw_message, radio_freq, list/spans, list/message_mods = list())
	var/mob/owner = linked_living?.resolve()
	if(QDELETED(owner))
		qdel(src)
		return
	if(speaker == owner)
		if(findtext(raw_message, "deafen") && !muted)
			to_chat(owner, span_notice("The voices in your head subside."))
			muted = TRUE
			return
		else if(findtext(raw_message, "listen") && muted)
			to_chat(owner, span_notice("You are bombarded again with the voices of the world."))
			muted = FALSE
			return
	if(speaker == src)
		return
	if(get_dist(speaker.loc, loc) > hear_radius)
		return
	if(muted)
		return
	if(!message || !linked_living)
		return
	to_chat(owner, "<img src='\ref[chat_icon]?state=[chat_icon_state]'/>" + " [message]")
	if(!isliving(speaker))
		return
	var/mob/living/living_speaker = speaker
	var/perception = living_speaker.STAPER
	if(invisibility && !living_speaker.is_blind() && living_speaker != owner && perception > 13)
		if(!prob(20 + ((perception - 14) * 5)))
			return
		to_chat(living_speaker, span_warning("We're not alone, the walls have ears..."))
		name = "Ghostly Aura"
		desc = "You feel a strange presence watching you..."
		invisibility = NONE
		addtimer(CALLBACK(src, PROC_REF(reset_visibility)), 5 SECONDS)
