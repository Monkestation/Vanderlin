//The idea for Primordials is that they are conjurable companions for arcyne types. They should cost essentia to conjure, and will follow the command minion order spell.
//Three differant types, air water and fire. Potential for unique effects/attacks for all three. Perhaps delineate between speed health and damage.
//Might also be worth looking into a spell to adjust their 'modes' from melee to ranged, or a command for special abilities.
/datum/intent/simple/claw/primordial
	name = "claw"
	icon_state = "instrike"
	attack_verb = list("claws", "pecks")
	animname = "blank22"
	blade_class = BCLASS_CUT
	hitsound = "smallslash"
	chargetime = 0
	penfactor = 0
	candodge = TRUE
	canparry = TRUE
	miss_text = "slash the air"
	item_damage_type = "slash"
	clickcd = 12

/mob/living/simple_animal/hostile/retaliate/primordial
	icon = 'icons/mob/primordial.dmi'
	del_on_death = TRUE
	faction = list()
	var/ability_cooldown = 30 SECONDS
	COOLDOWN_DECLARE(next_ability_use)
	COOLDOWN_DECLARE(next_heal_time)

/mob/living/simple_animal/hostile/retaliate/primordial/Initialize(mapload, mob/user)
	if(user)
		if(user?.mind?.current)
			summoner = user.mind.current.real_name
		else
			summoner = user.name
	ADD_TRAIT(src, TRAIT_NOMOOD, INNATE_TRAIT)
	ADD_TRAIT(src, TRAIT_NOHUNGER, INNATE_TRAIT)
	ADD_TRAIT(src, TRAIT_TOXIMMUNE, INNATE_TRAIT)
	ADD_TRAIT(src, TRAIT_BLOODLOSS_IMMUNE, INNATE_TRAIT)
	ADD_TRAIT(src, TRAIT_NOFIRE, INNATE_TRAIT)
	ADD_TRAIT(src, TRAIT_BASHDOORS, INNATE_TRAIT)
	ADD_TRAIT(src, TRAIT_NOPAIN, INNATE_TRAIT)
	ADD_TRAIT(src, TRAIT_CRITICAL_RESISTANCE, INNATE_TRAIT)
	ADD_TRAIT(src, TRAIT_STRONGBITE, INNATE_TRAIT)
	ADD_TRAIT(src, TRAIT_NOFALLDAMAGE1, INNATE_TRAIT)
	ADD_TRAIT(src, TRAIT_BREADY, INNATE_TRAIT)

	. = ..()
	src.adjust_skill_level(/datum/attribute/skill/combat/unarmed, 30, TRUE)
	AddComponent(/datum/component/ai_aggro_system)
	if(user?.mind?.current)
		befriend(user)
	RegisterSignal(src, COMSIG_AI_BLACKBOARD_KEY_CLEARED(BB_BASIC_MOB_CURRENT_TARGET), PROC_REF(pet_passive))

/mob/living/simple_animal/hostile/retaliate/primordial/death()
	..()
	spill_embedded_objects()

/mob/living/simple_animal/hostile/retaliate/primordial/proc/pet_passive()
	pet_passive = TRUE

/mob/living/simple_animal/hostile/retaliate/primordial/proc/ability(turf/target_location, mob/living/user)
	return

/mob/living/simple_animal/hostile/retaliate/primordial/get_pilot_ability()
	return /datum/action/cooldown/spell/primordial_special

/datum/action/cooldown/spell/primordial_special
	button_icon = 'icons/mob/actions/spells/mage_conjure.dmi'
	button_icon_state = "primordial_mark"
	name = "Elemental Surge"
	desc = "Unleash your elemental vessel's innate power at a spot within reach - a flame primordial breathes a searing cone, a water primordial churns a whirlpool, an air primordial hurls a gale."
	sound = null

	click_to_activate = TRUE
	cast_range = 6
	self_cast_possible = FALSE

	charge_required = FALSE
	spell_cost = 0

	cooldown_time = 30 SECONDS
	spell_tier = 3

	spell_impact_intensity = SPELL_IMPACT_NONE
	invocation_type = INVOCATION_NONE
	spell_requirements = SPELL_REQUIRES_SAME_Z

/datum/action/cooldown/spell/primordial_special/cast(atom/cast_on)
	. = ..()
	var/mob/living/simple_animal/hostile/retaliate/primordial/P = owner
	if(!istype(P))
		return FALSE
	var/turf/T = get_turf(cast_on)
	if(!T)
		return FALSE
	if(!COOLDOWN_FINISHED(P, next_ability_use))
		P.balloon_alert(P, "not ready yet!")
		return FALSE
	P.ability(T, P)
	return TRUE

/mob/living/simple_animal/hostile/retaliate/primordial/fire
	name = "flame primordial"
	desc = "Billowing heat strikes your face and threatens to singe your eyebrows! \
	It may be wise not to touch it."
	icon_state = "primordial_fire"
	icon_living = "primordial_fire"
	icon_dead = ""
	mob_biotypes = MOB_ORGANIC|MOB_BEAST
	emote_hear = null
	emote_see = null
	see_in_dark = 10
	move_to_delay = 3

	base_intents = list(/datum/intent/simple/claw/primordial)
	health = 525
	maxHealth = 525
	melee_damage_lower = 30
	melee_damage_upper = 40
	vision_range = 10
	aggro_vision_range = 9
	environment_smash = ENVIRONMENT_SMASH_NONE
	retreat_distance = 0
	minimum_distance = 0
	ranged = 1
	ranged_cooldown_time = 4 SECONDS
	projectiletype = /obj/projectile/magic/spitfire/primordial
	projectilesound = 'sound/magic/whiteflame.ogg'
	base_constitution = 10
	base_strength = 10
	base_speed = 13
	footstep_type = FOOTSTEP_MOB_BAREFOOT
	defprob = 30
	retreat_health = 0
	ai_controller = /datum/ai_controller/flame_primordial

/mob/living/simple_animal/hostile/retaliate/primordial/fire/ability(turf/target_location, mob/living/user)
	if(!target_location)
		return FALSE
	visible_message(span_danger("[src] inhales, heat gathering about its form!"))
	addtimer(CALLBACK(src, PROC_REF(do_fire_cone), target_location), 1 SECONDS)
	return TRUE

/mob/living/simple_animal/hostile/retaliate/primordial/fire/proc/do_fire_cone(turf/target_location)
	if(QDELETED(src) || stat == DEAD || !target_location)
		return
	var/range = 3
	var/angle = 60

	var/dx = target_location.x - src.x
	var/dy = target_location.y - src.y

	var/dir_angle = ATAN2(dy, dx)

	visible_message(span_danger("[src] exhales a cone of searing fire!"))

	for(var/turf/T in view(range, src))
		var/tx = T.x - src.x
		var/ty = T.y - src.y
		var/mag = sqrt(tx*tx + ty*ty)
		if(mag == 0)
			continue

		tx /= mag
		ty /= mag

		var/angle_to_turf = ATAN2(ty, tx)
		var/delta = abs(dir_angle - angle_to_turf)
		if(delta > 180)
			delta = 360 - delta

		if(delta <= angle/2)
			new /obj/effect/curtain_fire(T, 5 SECONDS)

/mob/living/simple_animal/hostile/retaliate/primordial/water
	name = "water primordial"
	desc = "A torrential flood, magically animated and bound to service. It seems \
	to draw moisture from the ground it traverses."
	icon_state = "primordial_water"
	icon_living = "primordial_water"
	icon_dead = ""
	mob_biotypes = MOB_ORGANIC|MOB_BEAST
	emote_hear = null
	emote_see = null
	speak_chance = 1
	see_in_dark = 10
	move_to_delay = 3

	attack_sound = list('sound/misc/undertow.ogg')

	base_intents = list(/datum/intent/simple/claw/primordial)

	health = 650
	maxHealth = 650
	melee_damage_lower = 30
	melee_damage_upper = 35
	vision_range = 10
	aggro_vision_range = 9
	environment_smash = ENVIRONMENT_SMASH_NONE
	retreat_distance = 0
	minimum_distance = 0
	ranged = 1
	ranged_cooldown_time = 4 SECONDS
	projectiletype = /obj/projectile/magic/frost_shard/primordial
	projectilesound = 'sound/spellbooks/icicle.ogg'

	base_constitution = 10
	base_strength = 10
	base_speed = 8
	footstep_type = FOOTSTEP_MOB_BAREFOOT
	defprob = 20
	retreat_health = 0

	ai_controller = /datum/ai_controller/water_primordial

/mob/living/simple_animal/hostile/retaliate/primordial/water/ability(turf/target_location, mob/living/user)
	if(!target_location)
		return FALSE
	visible_message(span_danger("[src] gathers the waters into a churning knot!"))
	addtimer(CALLBACK(src, PROC_REF(do_whirlpool), target_location), 1 SECONDS)
	return TRUE

/mob/living/simple_animal/hostile/retaliate/primordial/water/proc/do_whirlpool(turf/target_location)
	if(QDELETED(src) || stat == DEAD || !target_location)
		return
	visible_message(span_danger("[src] unleashes a spiralling wave of floodwaters!"))
	new /obj/effect/primordial_pool(target_location)

/obj/effect/primordial_pool
	name = "floodwave"
	desc = "A swirling wavepool churns violently."
	icon_state = "blueshatter2"
	anchored = TRUE
	density = FALSE
	var/list/turf_data = list()
	var/duration = 15 SECONDS

/obj/effect/primordial_pool/Initialize(mapload, turf/center)
	. = ..()
	if(!center)
		center = get_turf(src)

	// Build a 3x3 block around the center
	var/list/affected = block(
		locate(center.x - 1, center.y - 1, center.z),
		locate(center.x + 1, center.y + 1, center.z)
	)

	for(var/turf/T as anything in affected)
		turf_data[T] = T.type
		var/turf_path

		switch(get_dir(center, T))
			if(0)
				turf_path = /turf/open/water/ocean
			if(NORTH, NORTHWEST)
				turf_path = /turf/open/water/river/flow
			if(SOUTH, SOUTHEAST)
				turf_path = /turf/open/water/river/flow/north
			if(EAST, NORTHEAST)
				turf_path = /turf/open/water/river/flow/west
			if(WEST, SOUTHWEST)
				turf_path = /turf/open/water/river/flow/east

		if(turf_path)
			T.ChangeTurf(turf_path, flags = CHANGETURF_IGNORE_AIR)

	QDEL_IN(src, duration)

/obj/effect/primordial_pool/Destroy()
	// Restore saved turfs
	for(var/turf/T as anything in turf_data)
		T?.ChangeTurf(turf_data[T], flags = CHANGETURF_IGNORE_AIR)
	turf_data.Cut()
	return ..()

/mob/living/simple_animal/hostile/retaliate/primordial/air
	name = "air primordial"
	desc = "Storm-winds whip at the air wherever this creature travels! \
	It is scarcely even easy to keep one's footing while close."
	icon_state = "primordial_air"
	icon_living = "primordial_air"
	icon_dead = ""
	mob_biotypes = MOB_ORGANIC|MOB_BEAST
	emote_hear = null
	emote_see = null
	speak_chance = 1
	see_in_dark = 10
	move_to_delay = 3

	attack_sound = list('sound/combat/wooshes/bladed/wooshmed (1).ogg','sound/combat/wooshes/bladed/wooshmed (2).ogg','sound/combat/wooshes/bladed/wooshmed (3).ogg')

	base_intents = list(/datum/intent/simple/claw/primordial)

	health = 450
	maxHealth = 450
	melee_damage_lower = 35
	melee_damage_upper = 45
	vision_range = 10
	aggro_vision_range = 9
	environment_smash = ENVIRONMENT_SMASH_NONE
	retreat_distance = 0
	minimum_distance = 0
	ranged = 1
	ranged_cooldown_time = 4 SECONDS
	projectiletype = /obj/projectile/magic/greater_arcyne_bolt/primordial
	projectilesound = 'sound/magic/vlightning.ogg'


	base_constitution = 10
	base_strength = 10
	base_speed = 13
	footstep_type = FOOTSTEP_MOB_BAREFOOT
	defprob = 40
	retreat_health = 0

	ai_controller = /datum/ai_controller/air_primordial

/mob/living/simple_animal/hostile/retaliate/primordial/air/ability(turf/target_location, mob/living/user)
	if(!target_location)
		return FALSE
	visible_message(span_danger("[src] draws a whirl of stormwinds about itself!"))
	addtimer(CALLBACK(src, PROC_REF(do_gust), target_location), 1 SECONDS)
	return TRUE

/mob/living/simple_animal/hostile/retaliate/primordial/air/proc/do_gust(turf/target_location)
	if(QDELETED(src) || stat == DEAD || !target_location)
		return

	var/turf/center = get_turf(src)
	if(!center)
		return

	var/dir_to_target = get_dir(center, target_location)
	if(!dir_to_target)
		return

	visible_message(span_danger("[src] exhales a violent gust of wind!"))
	playsound(src, 'sound/weather/rain/wind_6.ogg', 100, TRUE)

	var/turf/current = get_step(center, dir_to_target)
	var/left_dir = turn(dir_to_target, 90)
	var/right_dir = turn(dir_to_target, -90)
	var/delay = 3

	for(var/i in 1 to 3)
		if(!current)
			break

		var/list/turf/row = list(
			current,
			get_step(current, left_dir),
			get_step(current, right_dir)
		)

		var/stagger = (i - 1) * delay
		if(stagger == 0)
			process_gust_row(row, dir_to_target)
		else
			addtimer(CALLBACK(src, PROC_REF(process_gust_row), row, dir_to_target), stagger)

		current = get_step(current, dir_to_target)

/mob/living/simple_animal/hostile/retaliate/primordial/air/proc/process_gust_row(list/turf/row, dir_to_target)
	if(QDELETED(src) || stat == DEAD)
		return

	for(var/turf/T as anything in row)
		if(!T)
			continue

		new /obj/effect/temp_visual/gust(T, dir_to_target)

		for(var/mob/living/L in T)
			if(L == src)
				continue
			knockback(L, dir_to_target, 8)


/mob/living/simple_animal/hostile/retaliate/primordial/air/proc/knockback(mob/living/L, dir, distance)
	if(!L || !isturf(L.loc))
		return
	var/turf/target_turf = get_ranged_target_turf(L, dir, distance)
	if(!target_turf)
		return
	L.throw_at(target_turf, 7, 4)

/obj/effect/temp_visual/gust
	icon = 'icons/effects/effects.dmi'
	icon_state = "kick"
	layer = ABOVE_MOB_LAYER
	anchored = TRUE
	duration = 8

/obj/projectile/magic/spitfire/primordial
	name = "primordial flame"
	damage = 20
	arcshot = TRUE

/obj/projectile/magic/frost_shard/primordial
	name = "primordial frost shard"
	damage = 18
	arcshot = TRUE

/obj/projectile/magic/greater_arcyne_bolt/primordial
	name = "primordial gale"
	damage = 27
	arcshot = TRUE
