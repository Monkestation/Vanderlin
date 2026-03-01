/datum/action/cooldown/spell/undirected/call_to_arms
	name = "Call to Arms"
	desc = "Grants you and all allies nearby a buff to their strength, endurance, and constitution."
	button_icon_state = "call_to_arms"
	sound = 'sound/magic/timestop.ogg'

	spell_type = SPELL_MIRACLE
	antimagic_flags = MAGIC_RESISTANCE_HOLY
	associated_skill = /datum/skill/magic/holy
	required_items = list(/obj/item/clothing/neck/psycross/silver/divine/ravox)

	invocation = "MAY THE FIGHT BE BLOODY!"
	invocation_type = INVOCATION_SHOUT

	charge_required = FALSE
	cooldown_time = 5 MINUTES
	spell_cost = 40

/datum/action/cooldown/spell/undirected/call_to_arms/cast(atom/cast_on)
	. = ..()
	for(var/mob/living/carbon/target in viewers(3, get_turf(owner)))
		if(!owner.faction_check_mob(target))
			continue
		if(!target.mind?.isactuallygood())
			continue
		if(target.mob_biotypes & MOB_UNDEAD)
			continue
		target.apply_status_effect(/datum/status_effect/buff/call_to_arms)
