/datum/action/cooldown/spell/conjure_summon/vengeful_spirits
	name = "Avenging Spirits"
	desc = "Summon temporary rancorous spirits to tear at an opponent!"
	button_icon = 'icons/mob/actions/spells/necramiracles.dmi'
	button_icon_state = "vengeful_spirit"
	sound = 'sound/magic/magnet.ogg'

	click_to_activate = TRUE
	cast_range = 7

	spell_cost = 50
	required_form = FORM_DEATH

	invocation = "Awaken, rancor!!"
	invocation_type = INVOCATION_SHOUT

	charge_required = TRUE
	charge_time = CHARGETIME_HEAVY
	charge_slowdown = CHARGING_SLOWDOWN_HEAVY
	charge_sound = 'sound/magic/charging.ogg'
	cooldown_time = 90 SECONDS

	spell_impact_intensity = SPELL_IMPACT_NONE
	spell_requirements = SPELL_REQUIRES_NO_ANTIMAGIC | SPELL_REQUIRES_HUMAN | SPELL_REQUIRES_SAME_Z

	max_summons = 3
	summons_per_cast = 3
	summon_noun = "spirit"
	recoil_energy_floor = 200
	recoil_severity = CONJURE_RECOIL_LIGHT

/datum/action/cooldown/spell/conjure_summon/vengeful_spirits/cast(atom/cast_on)
	if(!isliving(cast_on))
		to_chat(owner, span_warning("There is nothing here worth turning my spirits' rancor upon."))
		return FALSE
	return ..()

// Spirits erupt around the caster, not on the target's tile
/datum/action/cooldown/spell/conjure_summon/vengeful_spirits/validate_cast_location(atom/cast_on, mob/living/user)
	return TRUE

/datum/action/cooldown/spell/conjure_summon/vengeful_spirits/get_summon_turf(mob/living/user, atom/cast_on, index)
	var/perpendicular = (user.dir == SOUTH || user.dir == NORTH) ? EAST : NORTH
	var/opposite = (user.dir == SOUTH || user.dir == NORTH) ? WEST : SOUTH
	switch(index)
		if(2)
			return get_step(user, perpendicular)
		if(3)
			return get_step(user, opposite)
	return get_turf(user)

/datum/action/cooldown/spell/conjure_summon/vengeful_spirits/spawn_summon(turf/T, mob/living/user)
	return new /mob/living/simple_animal/hostile/spirit_vengeance(T, user)

/datum/action/cooldown/spell/conjure_summon/vengeful_spirits/on_summon_complete(mob/living/user, atom/cast_on, list/summoned_mobs)
	var/mob/living/target = cast_on
	for(var/mob/living/simple_animal/hostile/spirit_vengeance/spirit in summoned_mobs)
		spirit.ai_controller?.set_blackboard_key(BB_BASIC_MOB_CURRENT_TARGET, target)
