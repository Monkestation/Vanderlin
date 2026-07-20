/datum/action/cooldown/spell/conjure/will_of_woods
	name = "Will of the Woods"
	desc = "Summon the aid of the woods."
	button_icon_state = "tamebeast"
	sound = 'sound/magic/timestop.ogg'
	self_cast_possible = FALSE

	spell_type = SPELL_MIRACLE
	antimagic_flags = MAGIC_RESISTANCE_HOLY
	associated_skill = /datum/attribute/skill/magic/holy
	invocation = "Fear the wrath of the woods!!!"
	invocation_type = INVOCATION_SHOUT

	charge_time = 2 SECONDS
	charge_drain = 1
	charge_slowdown = 1.3
	cooldown_time = 5 MINUTES
	spell_cost = 40

	summon_amount = 3
	summon_type = list(/mob/living/simple_animal/hostile/retaliate/bigrat)
	summon_radius = 2
	summon_lifespan = 5 MINUTES

/datum/action/cooldown/spell/conjure/will_of_woods/before_cast(atom/cast_on)
	. = ..()
	if(. & SPELL_CANCEL_CAST)
		return
	randomize_summons(cast_on)


/datum/action/cooldown/spell/conjure/will_of_woods/post_summon(atom/summoned_object, atom/cast_on)
	var/mob/living/spawned_mob = summoned_object
	for(var/mob/living/carbon/target in viewers(7, get_turf(cast_on)))
		if(target.has_status_effect(/datum/status_effect/buff/call_to_hunt))
			spawned_mob.befriend(target)

	if(isliving(cast_on))
		var/mob/living/L = cast_on
		if(L.stat != DEAD)
			spawned_mob.ai_controller?.set_blackboard_key(BB_BASIC_MOB_PRIORITY_TARGETS, L)
		return
	for(var/mob/living/L in get_turf(cast_on))
		if(L.stat == DEAD)
			continue
		spawned_mob.ai_controller?.set_blackboard_key(BB_BASIC_MOB_PRIORITY_TARGETS, L)
		break


/datum/action/cooldown/spell/conjure/will_of_woods/proc/randomize_summons(atom/cast_on)
	var/summon_set = rand(1,14)
	var/area/target_area = get_area(cast_on)
	if(target_area.area_flags & BOGGY_AREA)
		switch(summon_set)
			if(1 to 4)
				summon_amount = 4
				summon_type = list(/mob/living/simple_animal/hostile/retaliate/bigrat)
				summon_radius = 2
			if(5 to 8)
				summon_amount = 3
				summon_type = list(/mob/living/simple_animal/hostile/retaliate/spider)
				summon_radius = 1
			if(9 to 11)
				summon_amount = 3
				summon_type = list(/mob/living/simple_animal/hostile/retaliate/mirespider)
				summon_radius = 1
			if(12, 13)
				summon_amount = 3
				summon_type = list(/mob/living/simple_animal/hostile/retaliate/mirespider, /mob/living/simple_animal/hostile/mirespider_paralytic)
				summon_radius = 1
			if(14 to INFINITY)
				summon_amount = 1
				summon_type = list(/mob/living/simple_animal/hostile/retaliate/troll/bog/slaved)
				summon_radius = 0

	else
		switch(summon_set)
			if(1 to 5)
				summon_amount = 3
				summon_type = list(/mob/living/simple_animal/hostile/retaliate/wolf)
				summon_radius = 1
			if(6 to 8)
				summon_amount = 3
				summon_type = list(/mob/living/simple_animal/hostile/retaliate/raccoon)
				summon_radius = 1
			if(9 to 11)
				summon_amount = 2
				summon_type = list(/mob/living/simple_animal/hostile/retaliate/mole)
				summon_radius = 1
			if(12,13)
				summon_amount = 5
				summon_type = list(/mob/living/simple_animal/hostile/retaliate/wolf)
				summon_radius = 2
			if(14 to INFINITY)
				summon_amount = 1
				summon_type = list(/mob/living/simple_animal/hostile/retaliate/troll/slaved, /mob/living/simple_animal/hostile/retaliate/troll/axe/slaved)
				summon_radius = 0

