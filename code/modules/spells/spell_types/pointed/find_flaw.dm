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

	if(cast_on.charflaw && !istype(cast_on.charflaw, /datum/charflaw/noflaw) && !istype(cast_on.charflaw, /datum/charflaw/eznoflaw))
		to_chat(owner, span_green("You discover [cast_on]'s flaw: <b>[cast_on.charflaw.name]</b>!"))
		SEND_SIGNAL(owner, COMSIG_FLAW_FOUND, cast_on.charflaw, cast_on)
		return

	to_chat(owner, span_warning("\The [cast_on] has no flaws! How could this be?!"))
