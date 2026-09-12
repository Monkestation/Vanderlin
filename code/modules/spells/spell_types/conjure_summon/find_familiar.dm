/datum/action/cooldown/spell/conjure_summon/familiar
	name = "Find Familiar"
	desc = "Summons a temporary spectral wolf to aid you."
	button_icon = 'icons/mob/actions/roguespells.dmi'
	button_icon_state = "zad"
	sound = 'sound/magic/whiteflame.ogg'

	invocation = "B'ST FR'ND!"
	invocation_type = INVOCATION_SHOUT

	charge_time = 2 SECONDS
	charge_drain = 1
	charge_slowdown = 1.3
	cooldown_time = 6 MINUTES
	spell_cost = 30
	spell_flags = SPELL_RITUOS

	required_form = FORM_ARCANE
	required_technique = TECHNIQUE_SUMMONING

	self_cast_possible = FALSE

	summon_noun = "wolf"
	max_summons = 1
	summons_per_cast = 1

	var/summon_lifespan = 5 MINUTES

/datum/action/cooldown/spell/conjure_summon/familiar/spawn_summon(turf/T, mob/living/user)
	var/mob/living/simple_animal/hostile/retaliate/wolf/familiar/wolf = new(T)

	wolf.befriend(user)
	if(summon_lifespan)
		QDEL_IN(wolf, summon_lifespan)

	for(var/mob/living/L in T)
		if(L.stat == DEAD)
			continue
		wolf.ai_controller?.set_blackboard_key(BB_BASIC_MOB_PRIORITY_TARGETS, L)
		break

	return wolf
