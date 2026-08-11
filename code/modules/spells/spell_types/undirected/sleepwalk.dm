/datum/action/cooldown/spell/undirected/sleepwalk
	name = "Sleepwalk"
	desc = "Implant the idea into the heads of others that you don't exist."
	sound = 'sound/misc/stings/generic.ogg'
	associated_skill = /datum/attribute/skill/misc/sneaking
	has_visual_effects = FALSE

	charge_time = 1 SECONDS
	cooldown_time = 10 SECONDS
	spell_cost = 2
	spell_flags = SPELL_STAMINA


/datum/action/cooldown/spell/undirected/sleepwalk/cast(atom/cast_on)
	. = ..()
	if(!isliving(owner))
		return
	var/mob/living/L = owner
	if(L.has_status_effect(/datum/status_effect/dwsleepwalk))
		L.remove_status_effect(/datum/status_effect/dwsleepwalk) // YOU'RE SUPPOSED TO TURN THEM CORPOREAL AGAIN TOO YOU STUPID FUCK
		return
	else
		L.visible_message(
			span_warning("[target] becomes fuzzier, and harder to focus on."),
			span_notice("You start to become incorporeal!")
		)
		animate(L, alpha = 0, time = 5 SECONDS, easing = EASE_OUT)
		L.apply_status_effect(/datum/status_effect/dwsleepwalk, INFINITY)



//===== Time for shit yoinked from the invisibility code. Lol, lmao

/datum/status_effect/dwsleepwalk
	id = "sleepwalk"
	status_type = STATUS_EFFECT_REFRESH
	duration = INFINITY
	on_remove_on_mob_delete = TRUE
	alert_type = /atom/movable/screen/alert/status_effect/dwsleepwalk
	effectedstats = list(STAT_SPEED = -2)

/datum/status_effect/dwsleepwalk/on_apply()
	. = ..()
	//ADD_TRAIT(owner, TRAIT_IMPERCEPTIBLE, id)

	// don't show a message to other people if we're sneaking
	var/viewing_message = owner.rogue_sneaking ? null : span_warning("[owner] becomes hard to focus on.")
	owner.visible_message( \
		viewing_message, \
		span_notice("I become incorporeal.") \
	)
	animate(owner, alpha = 150, time = 3 SECONDS, easing = EASE_IN)

/datum/status_effect/dwsleepwalk/on_remove()
	if(QDELETED(owner))
		return

	. = ..()
	//REMOVE_TRAIT(owner, TRAIT_IMPERCEPTIBLE, id)
	animate(owner, alpha = 255, time = 3 SECONDS, easing = EASE_IN) // this is absolute shit and definitely not working right but fuck it
	owner.update_sneak_invis()
	if(owner.rogue_sneaking)
		to_chat(owner, span_notice("I'm right here, and they can't see me. They're convinced I'm not here."))
	else
		owner.visible_message( \
			span_warning("[owner] comes into focus."), \
			span_warning("I become corporeal again.") \
		)

/* ------------------- */

/atom/movable/screen/alert/status_effect/dwsleepwalk
	name = "Sleepwalking"
	desc = span_info("I'm diving into the minds of others, \
		making it harder to believe that I'm truly here, infront of their eyes.")
	icon_state = "buff" //pick an empty one on purpose, cause we're invisible
