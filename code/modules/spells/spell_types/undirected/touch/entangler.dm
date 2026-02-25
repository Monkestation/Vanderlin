/datum/action/cooldown/spell/undirected/touch/entangler
	name = "Hand of Dendor"
	desc = "Invoke a hand which will create living vines and grant protection."
	button_icon_state = "entangle"
	sound = 'sound/items/dig_shovel.ogg'

	spell_type = SPELL_MIRACLE
	associated_skill = /datum/skill/magic/holy
	required_items = list(/obj/item/clothing/neck/psycross/silver/divine/dendor)
	attunements = list(
		/datum/attunement/earth = 0.5,
	)

	cooldown_time = 5 MINUTES
	spell_cost = 15

	charges = 3

/datum/action/cooldown/spell/undirected/touch/entangler/create_hand(mob/living/carbon/cast_on)
	. = ..()
	if(!.)
		return
	// Permanent for now
	ADD_TRAIT(cast_on, TRAIT_ENTANGLER_IMMUNE, MAGIC_TRAIT)

/datum/action/cooldown/spell/undirected/touch/entangler/cast_on_hand_hit(obj/item/melee/touch_attack/hand, atom/victim, mob/living/carbon/caster, list/modifiers)
	. = ..()
	if(isliving(victim))
		try_mark(victim)
		return FALSE // no cooldown for marking
	var/turf/to_grow = get_turf(victim)
	if(to_grow.is_blocked_turf(TRUE))
		to_chat(caster, span_warning("The blessing of the tree father can not reach here."))
		return FALSE
	for(var/obj/structure/flora/grass/tangler/real in to_grow)
		to_chat(caster, span_warning("The soil may only be blessed once."))
		return FALSE

	new /obj/structure/flora/grass/tangler/real(to_grow)

	return TRUE

/datum/action/cooldown/spell/undirected/touch/entangler/proc/try_mark(mob/living/victim)
	var/has_trait = HAS_TRAIT_FROM(victim, TRAIT_ENTANGLER_IMMUNE, MAGIC_TRAIT)
	var/action = has_trait ? "removing" : "adding"
	owner.visible_message("[owner] presses their thumb on [victim]'s forehead and begins [action] Dendor's mark.")
	if(!do_after(owner, 5 SECONDS, victim))
		return
	if(has_trait)
		playsound(owner, 'sound/magic/swap.ogg', 55, TRUE)
		owner.visible_message(
			span_warning("[owner] removes the mark from [victim]'s forehead."),
			span_warning("I remove the mark from [victim]'s forehead."),
		)
		to_chat(victim, span_userdanger("The vines have forsaken you."))
		REMOVE_TRAIT(victim, TRAIT_ENTANGLER_IMMUNE, MAGIC_TRAIT)
		return
	playsound(owner, 'sound/magic/ahh2.ogg', 55, TRUE)
	owner.visible_message(
		span_nicegreen("[owner] marks [victim]'s forehead."),
		span_nicegreen("I mark [victim]'s forehead."),
	)
	to_chat(victim, span_nicegreen("You are a child of the vines."))
	ADD_TRAIT(victim, TRAIT_ENTANGLER_IMMUNE, MAGIC_TRAIT)
