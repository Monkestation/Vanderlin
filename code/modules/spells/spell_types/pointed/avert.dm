//Ported from Azure Peak made by Ephemeralis ?

// Turn this into a continuous spell type?
/datum/action/cooldown/spell/avert
	name = "Borrowed Time"
	desc = "Shield someone from the Undermaiden's gaze, preventing them from slipping into death for as long as your faith and fatigue may muster."
	button_icon_state = "borrowtime"
	sound = 'sound/magic/churn.ogg'
	charge_sound = 'sound/magic/holycharging.ogg'
	has_visual_effects = FALSE

	cast_range = 1
	spell_type = SPELL_MIRACLE
	antimagic_flags = MAGIC_RESISTANCE_HOLY
	associated_skill = /datum/skill/magic/holy
	required_items = list(/obj/item/clothing/neck/psycross/silver/necra)

	invocation = "Undermaiden avert your gaze!"
	invocation_type = INVOCATION_SHOUT

	charge_required = FALSE
	cooldown_time = 3 MINUTES

	var/static/list/near_death_lines = list(
		"A haze begins to envelop me, but then suddenly recedes, as if warded back by some great light...",
		"A terrible weight bears down upon me, as if the wyrld itself were crushing me with its heft...",
		"The sound of a placid river drifts into hearing, followed by the ominous toll of a ferryman's bell...",
		"Some vast, immeasurably distant figure looms beyond my perception - I feel it, more than I see. It waits. It watches.",
	)

/datum/action/cooldown/spell/avert/is_valid_target(atom/cast_on)
	. = ..()
	if(!.)
		return FALSE
	return isliving(cast_on)

/datum/action/cooldown/spell/avert/before_cast(mob/living/cast_on)
	. = ..()
	if(. & SPELL_CANCEL_CAST)
		return

	if(cast_on.stat == DEAD)
		to_chat(owner, span_warning("This one has fallen to the underworld..."))
		reset_spell_cooldown()
		return . | SPELL_CANCEL_CAST

/datum/action/cooldown/spell/avert/cast(mob/living/cast_on)
	. = ..()

	owner.visible_message(
		span_notice("Whispering motes gently bead from [owner]'s fingers as [owner.p_they()] place a hand near [cast_on], scriptures of the Undermaiden spilling from their lips..."),
		span_notice("I stand beside [cast_on] and utter the hallowed words of Aeon's Intercession, staying Her grasp for just a little while longer..."),
	)

	to_chat(owner, span_small("I must remain still and at [cast_on]'s side..."))
	to_chat(cast_on, span_warning("An odd sensation blossoms in my chest, cold and unknown..."))

	ADD_TRAIT(cast_on, TRAIT_NODEATH, "avert_spell")

	var/tickspeed = 3 SECONDS + (5 * owner.get_skill_level(associated_skill))

	while(do_after(owner, tickspeed, cast_on))
		cast_on.adjustOxyLoss(-10)
		cast_on.blood_volume = max((BLOOD_VOLUME_SURVIVE * 1.5), cast_on.blood_volume)

		if(prob(5) && cast_on.health <= 5)
			to_chat(cast_on, span_small(pick(near_death_lines)))

		if(!check_cost(10, feedback = FALSE))
			to_chat(owner, span_warning("My devotion runs dry, the intercession fades from my lips!"))
			break

		invoke_cost(10, re_run = TRUE)

	REMOVE_TRAIT(cast_on, TRAIT_NODEATH, "avert_spell")
