/datum/action/cooldown/spell/undirected/fart
	name = "Fart"
	desc = "Unleash a vile sound."
	button_icon_state = "orison"

	antimagic_flags = NONE

	spell_type = NONE

	charge_required = FALSE
	sound = null
	has_visual_effects = FALSE

	cooldown_time = 1 MINUTES

/datum/action/cooldown/spell/undirected/fart/cast(atom/cast_on)
	. = ..()
	var/fard = pick('sound/vo/fart1.ogg', 'sound/vo/fart2.ogg', 'sound/vo/fart3.ogg')
	owner.emote("me", 1, "grits their teeth and farts!", intentional = TRUE)
	owner.adjust_hygiene(rand(-1, -10))
	addtimer(CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(playsound), get_turf(owner), fard, 100), 1 SECONDS)
