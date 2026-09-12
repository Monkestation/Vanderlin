
/datum/action/cooldown/spell/aoe/knock
	name = "Knock"
	desc = "This spell opens nearby doors and closets."
	button_icon_state = "knock"
	click_to_activate = FALSE

	required_form = FORM_AIR
	required_technique = TECHNIQUE_ILLUSION
	required_level = 6

	charge_time = 2 SECONDS
	cooldown_time = 20 SECONDS

	invocation = "AULIE OXIN FIERA"
	invocation_type = INVOCATION_WHISPER
	aoe_radius = 3

/datum/action/cooldown/spell/aoe/knock/get_things_to_cast_on(atom/center)
	return RANGE_TURFS(aoe_radius, center)

/datum/action/cooldown/spell/aoe/knock/cast_on_thing_in_aoe(turf/victim, atom/caster)
	SEND_SIGNAL(victim, COMSIG_ATOM_MAGICALLY_UNLOCKED, src, caster)
