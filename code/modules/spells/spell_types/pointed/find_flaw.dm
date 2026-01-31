/datum/action/cooldown/spell/find_flaw
	name = "Find Flaw"
	button_icon_state = "tragedy"
	sound = null
	self_cast_possible = FALSE
	has_visual_effects = FALSE

	antimagic_flags = NONE
	charge_required = FALSE
	cooldown_time = 30 SECONDS

/datum/action/cooldown/spell/find_flaw/is_valid_target(atom/cast_on)
	. = ..()
	if(!.)
		return FALSE
	return ishuman(cast_on)

/datum/action/cooldown/spell/find_flaw/cast(mob/living/carbon/human/cast_on)
	. = ..()
	if(cast_on.stat == DEAD)
		to_chat(owner, span_warning("This one's biggest flaw is being dead."))
		return FALSE

	if(length(cast_on.quirks))

		to_chat(owner, span_green("You discover [cast_on]'s flaws:"))
		for(var/datum/quirk/vice/vice in cast_on.quirks)
			to_chat(owner, span_green("<b>[vice.name]</b>"))
			SEND_SIGNAL(owner, COMSIG_FLAW_FOUND, vice, cast_on)
		return

	to_chat(owner, span_warning("\The [cast_on] has no flaws! How could this be?!"))
