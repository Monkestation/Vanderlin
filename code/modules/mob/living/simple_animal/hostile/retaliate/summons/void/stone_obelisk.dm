/mob/living/simple_animal/hostile/retaliate/voidstoneobelisk/Initialize()
	. = ..()
	AddComponent(/datum/component/ai_aggro_system)
	beam = new
	beam.Grant(src)
	ai_controller.set_blackboard_key(BB_TARGETED_ACTION, beam)

	ADD_TRAIT(src,TRAIT_NOFIRE, "[type]")
	ADD_TRAIT(src, TRAIT_NOBREATH, TRAIT_GENERIC)
	ADD_TRAIT(src, TRAIT_ANTIMAGIC, TRAIT_GENERIC)
	ADD_TRAIT(src, TRAIT_TOXIMMUNE, TRAIT_GENERIC)
	ADD_TRAIT(src, TRAIT_NOPAINSTUN, TRAIT_GENERIC)
	ADD_TRAIT(src, TRAIT_SHOCKIMMUNE, TRAIT_GENERIC)

/mob/living/simple_animal/hostile/retaliate/voidstoneobelisk/simple_add_wound(datum/wound/wound, silent = FALSE, crit_message = FALSE)	//no wounding the obelisk
	return

/mob/living/simple_animal/hostile/retaliate/voidstoneobelisk
	icon = 'icons/mob/summonable/32x32.dmi'
	name = "voidstone obelisk"
	desc = "A construct from another age. It is marked by glowing sigils, and its material seems to absorb magic!"
	icon_state = "obelisk-combined"
	icon_living = "obelisk-combined"
	icon_dead = "obelisk-combined"
	summon_primer = "You are ancient. A construct built in an age before men, a time of dragons. Your builders don't seem to be around anymore, and time has past with you in standby. How you respond, is up to you."
	tier = 3

	faction = list("aberrant")
	emote_hear = null
	emote_see = null
	speed = 5
	see_in_dark = 9
	move_to_delay = 12
	vision_range = 9
	aggro_vision_range = 9
	is_flying_animal = TRUE

	butcher_results = list()

	health = 750
	maxHealth = 750
	food_type = null

	base_intents = list(/datum/intent/simple/slam)
	attack_sound = list('sound/combat/hits/onstone/wallhit.ogg')
	melee_damage_lower = 30
	melee_damage_upper = 30
	base_endurance = 20
	base_constitution = 20
	base_strength = 12
	base_speed = 8

	simple_detect_bonus = 60
	retreat_distance = 0
	minimum_distance = 0
	deaggroprob = 0
	defprob = 35
	defdrain = 5
	retreat_health = 0.2

	dodgetime = 17
	aggressive = 1
	food_max = 0

	ai_controller = /datum/ai_controller/void_obelisk
	dendor_taming_chance = DENDOR_TAME_PROB_NONE
	del_on_death = TRUE

	var/datum/action/cooldown/mob_cooldown/voidblast/beam

/datum/intent/simple/slam
	name = "slam"
	icon_state = "instrike"
	attack_verb = list("slam", "rams")
	animname = "blank22"
	blade_class = BCLASS_BLUNT
	hitsound = 'sound/combat/hits/onstone/wallhit.ogg'
	chargetime = 0
	penfactor = 20
	swingdelay = 0
	candodge = TRUE
	canparry = TRUE
	item_damage_type = "blunt"

/mob/living/simple_animal/hostile/retaliate/voidstoneobelisk/death(gibbed)
	var/turf/deathspot = get_turf(src)
	new /obj/item/natural/voidstone(deathspot)
	new /obj/item/natural/artifact(deathspot)
	return ..()

/mob/living/simple_animal/hostile/retaliate/voidstoneobelisk/Destroy()
	QDEL_NULL(beam)
	return ..()

/mob/living/simple_animal/hostile/retaliate/voidstoneobelisk/RangedAttack(atom/target, list/modifiers)
	beam.Activate(target = target)

/mob/living/simple_animal/hostile/retaliate/voidstoneobelisk/get_sound(input)
	switch(input)
		if("aggro")
			return pick('sound/vo/mobs/vobelisk/construct.ogg')

/// Segments of the actual beam, these hurt if you stand in them
/obj/effect/obeliskbeam
	name = "aberrant beam"
	icon = 'icons/effects/effects.dmi'
	icon_state = "obeliskbeam_mid"
	layer = ABOVE_MOB_LAYER
	plane = GAME_PLANE_UPPER
	mouse_opacity = MOUSE_OPACITY_TRANSPARENT
	light_color = "#008080"
	light_power = 4
	light_outer_range = 3
	/// Who made us?
	var/datum/weakref/creator

/obj/effect/obeliskbeam/Initialize(mapload)
	. = ..()
	START_PROCESSING(SSfastprocess, src)

/obj/effect/obeliskbeam/Destroy()
	STOP_PROCESSING(SSfastprocess, src)
	return ..()

/obj/effect/obeliskbeam/process()
	var/atom/ignore = creator?.resolve()
	for(var/mob/living/hit_mob in get_turf(src))
		if(hit_mob == ignore)
			continue
		damage(hit_mob)

/// Hurt the passed mob
/obj/effect/obeliskbeam/proc/damage(mob/living/hit_mob)
	hit_mob.apply_damage(damage = 15, damagetype = BURN)
	to_chat(hit_mob, span_danger("You're damaged by [src]!"))

/// Ignore damage dealt to this mob
/obj/effect/obeliskbeam/proc/assign_creator(mob/living/maker)
	creator = WEAKREF(maker)

/// Disappear
/obj/effect/obeliskbeam/proc/disperse()
	animate(src, time = 0.5 SECONDS, alpha = 0)
	QDEL_IN(src, 0.5 SECONDS)
