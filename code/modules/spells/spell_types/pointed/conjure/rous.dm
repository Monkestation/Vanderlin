/datum/action/cooldown/spell/conjure/rous
	name = "Call Rous"
	desc = "Calls for your brethren to aid you in battle."
	button_icon_state = "tamebeast"
	self_cast_possible = FALSE

	sound = 'sound/items/dig_shovel.ogg'

	antimagic_flags = NONE
	associated_stat = STATKEY_CON
	spell_type = SPELL_STAMINA
	has_visual_effects = FALSE
	charge_time = 2 SECONDS
	charge_drain = 1
	charge_slowdown = 1.3
	cooldown_time = 3 MINUTES
	spell_cost = 30
	associated_skill = /datum/skill/magic/druidic

	summon_amount = 3
	summon_type = list(/mob/living/simple_animal/hostile/retaliate/bigrat)
	summon_radius = 1
	summon_lifespan = 5 MINUTES

/datum/action/cooldown/spell/conjure/rous/post_summon(atom/summoned_object, atom/cast_on)
	var/mob/living/rous = summoned_object
	rous.befriend(owner)

	if(isliving(cast_on))
		var/mob/living/L = cast_on
		if(L.stat != DEAD)
			rous.ai_controller?.set_blackboard_key(BB_BASIC_MOB_PRIORITY_TARGETS, L)
		return
	for(var/mob/living/L in get_turf(cast_on))
		if(L.stat == DEAD)
			continue
		rous.ai_controller?.set_blackboard_key(BB_BASIC_MOB_PRIORITY_TARGETS, L)
		break
