/datum/action/cooldown/spell/conjure_summon/raise_lesser_undead
	name = "Raise Lesser Undead"
	desc = "Summons a temporary skeleton to aid you."
	button_icon_state = "animate"
	button_icon = 'icons/mob/actions/roguespells.dmi'
	sound = 'sound/magic/magnet.ogg'

	invocation = "SERVE ME!"
	invocation_type = INVOCATION_SHOUT

	charge_time = 2 SECONDS
	charge_drain = 1
	charge_slowdown = 1.3
	cooldown_time = 6 MINUTES
	spell_cost = 70

	spell_type = SPELL_MIRACLE
	antimagic_flags = MAGIC_RESISTANCE_HOLY
	associated_skill = /datum/attribute/skill/magic/holy

	self_cast_possible = FALSE

	summon_noun = "skeleton"
	max_summons = 1
	summons_per_cast = 1

	var/summon_lifespan = 5 MINUTES
	var/cabal_affine = FALSE

/datum/action/cooldown/spell/conjure_summon/raise_lesser_undead/spawn_summon(turf/T, mob/living/user)
	var/skeleton_type = pick_skeleton_type()
	var/mob/living/simple_animal/hostile/skeleton/skeleton = new skeleton_type(T)

	skeleton.befriend(user)
	if(cabal_affine)
		skeleton.add_faction(FACTION_CABAL)
	if(summon_lifespan)
		QDEL_IN(skeleton, summon_lifespan)

	assign_priority_target(skeleton, T)
	return skeleton

/datum/action/cooldown/spell/conjure_summon/raise_lesser_undead/proc/pick_skeleton_type()
	var/skeleton_roll = rand(1, 100)
	switch(skeleton_roll)
		if(1 to 20)
			return /mob/living/simple_animal/hostile/skeleton/axe
		if(21 to 40)
			return /mob/living/simple_animal/hostile/skeleton/spear
		if(41 to 60)
			return /mob/living/simple_animal/hostile/skeleton/guard
		if(61 to 80)
			return /mob/living/simple_animal/hostile/skeleton/bow
	return /mob/living/simple_animal/hostile/skeleton

/datum/action/cooldown/spell/conjure_summon/raise_lesser_undead/proc/assign_priority_target(mob/living/skeleton, turf/T)
	for(var/mob/living/L in T)
		if(L.stat == DEAD)
			continue
		skeleton.ai_controller?.set_blackboard_key(BB_BASIC_MOB_PRIORITY_TARGETS, L)
		break

/datum/action/cooldown/spell/conjure_summon/raise_lesser_undead/necromancer
	name = "Lesser Necromancy"
	spell_type = SPELL_MANA
	antimagic_flags = MAGIC_RESISTANCE
	associated_skill = /datum/attribute/skill/magic/arcane
	cabal_affine = TRUE
	cooldown_time = 30 SECONDS
	summon_lifespan = 1 MINUTES

/datum/action/cooldown/spell/conjure_summon/raise_lesser_undead/spectral
	name = "Summon Spectral Skeleton"
	desc = "Summons a temporary spectral skeleton to aid you."
	spell_type = SPELL_MANA
	antimagic_flags = MAGIC_RESISTANCE
	associated_skill = /datum/attribute/skill/magic/arcane
	cooldown_time = 30 SECONDS
	summon_lifespan = 1 MINUTES

	required_form = FORM_DEATH
	required_technique = TECHNIQUE_SUMMONING
	required_level = 2

/datum/action/cooldown/spell/conjure_summon/raise_lesser_undead/spectral/pick_skeleton_type()
	var/skeleton_roll = rand(1, 100)
	switch(skeleton_roll)
		if(1 to 20)
			return /mob/living/simple_animal/hostile/skeleton/axe/spectral
		if(21 to 40)
			return /mob/living/simple_animal/hostile/skeleton/spear/spectral
		if(41 to 60)
			return /mob/living/simple_animal/hostile/skeleton/guard/spectral
		if(61 to 80)
			return /mob/living/simple_animal/hostile/skeleton/bow/spectral
	return /mob/living/simple_animal/hostile/skeleton/spectral
