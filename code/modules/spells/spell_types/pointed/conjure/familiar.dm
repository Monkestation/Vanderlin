/datum/action/cooldown/spell/conjure/familiar
	name = "Find Familiar"
	desc = "Summons a temporary spectral volf to aid you."
	button_icon_state = "zad"
	self_cast_possible = FALSE

	point_cost = 3

	sound = 'sound/magic/whiteflame.ogg'

	invocation = "B'ST FR'ND!"
	invocation_type = INVOCATION_SHOUT

	charge_time = 2 SECONDS
	charge_drain = 1
	charge_slowdown = 1.3
	cooldown_time = 6 MINUTES
	spell_cost = 30
	spell_flags = SPELL_RITUOS
	summon_type = list(/mob/living/simple_animal/hostile/retaliate/wolf/familiar)
	summon_radius = 0
	summon_lifespan = 5 MINUTES

	attunements = list(
		/datum/attunement/arcyne = 0.4,
	)

/datum/action/cooldown/spell/conjure/familiar/post_summon(atom/summoned_object, atom/cast_on)
	var/mob/living/wolf = summoned_object
	wolf.befriend(owner)

	if(isliving(cast_on))
		var/mob/living/L = cast_on
		if(L.stat != DEAD)
			wolf.ai_controller?.set_blackboard_key(BB_BASIC_MOB_PRIORITY_TARGETS, L)
		return
	for(var/mob/living/L in get_turf(cast_on))
		if(L.stat == DEAD)
			continue
		wolf.ai_controller?.set_blackboard_key(BB_BASIC_MOB_PRIORITY_TARGETS, L)
		break
