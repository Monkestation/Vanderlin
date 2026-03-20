/datum/action/cooldown/spell/undirected/call_to_slaughter
	name = "Call to Slaughter"
	desc = "Grants you and all allies nearby a buff to their strength, endurance, and constitution."
	button_icon_state = "call_to_slaughter"
	sound = 'sound/magic/timestop.ogg'

	spell_type = SPELL_MIRACLE
	antimagic_flags = MAGIC_RESISTANCE_HOLY
	associated_skill = /datum/attribute/skill/magic/holy
	invocation = "LAMBS TO THE SLAUGHTER!"
	invocation_type = INVOCATION_SHOUT

	charge_required = FALSE
	cooldown_time = 5 MINUTES
	spell_cost = 40

/datum/action/cooldown/spell/undirected/call_to_slaughter/cast(atom/cast_on)
	. = ..()
	for(var/mob/living/carbon/target in viewers(3, get_turf(owner)))
		if(istype(target.patron, /datum/patron/inhumen))
			target.apply_status_effect(/datum/status_effect/buff/call_to_slaughter)	//Buffs inhumens
			return
		if(istype(target.patron, /datum/patron/psydon))
			to_chat(target, span_danger("You feel a surge of cold wash over you; leaving your body as quick as it hit.."))	//No effect on Psydonians, Endure.
			return
		if(!owner.faction_check_mob(target))
			continue
		if(target.mob_biotypes & MOB_UNDEAD)
			continue
		target.apply_status_effect(/datum/status_effect/debuff/call_to_slaughter)	//Debuffs non-inhumens/psydonians
