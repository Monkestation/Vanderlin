/datum/action/cooldown/spell/undirected/call_to_hunt
	name = "Call to Hunt"
	desc = "Grants you and all allies nearby a buff to their strength, endurance, and constitution."
	button_icon_state = "dendor"
	sound = 'sound/magic/timestop.ogg'

	spell_type = SPELL_MIRACLE
	antimagic_flags = MAGIC_RESISTANCE_HOLY
	associated_skill = /datum/attribute/skill/magic/holy
	invocation = "FOR THE HUNT!"
	invocation_type = INVOCATION_SHOUT

	charge_required = FALSE
	cooldown_time = 5 MINUTES
	spell_cost = 40

/datum/action/cooldown/spell/undirected/call_to_hunt/cast(atom/cast_on)
	. = ..()
	for(var/mob/living/carbon/target in viewers(3, get_turf(owner)))
		if(istype(target.patron, /datum/patron/alternate/great_hunt))
			target.apply_status_effect(/datum/status_effect/buff/call_to_hunt)
