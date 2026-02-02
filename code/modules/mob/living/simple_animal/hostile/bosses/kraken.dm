/mob/living/simple_animal/hostile/retaliate/swamp_kraken
	icon = 'icons/roguetown/mob/monster/kraken.dmi'
	name = "swamp kraken"
	desc = "An ancient horror from the deepest swamps. Its tentacles writhe with malevolent purpose."
	icon_state = "Gilbert"
	icon_living = "Gilbert"
	icon_dead = ""
	pixel_x = -85
	pixel_y = -32
	mob_biotypes = MOB_ORGANIC|MOB_BEAST
	speak_emote = list("gurgles", "bubbles")
	emote_hear = list("gurgles wetly", "makes bubbling sounds")
	emote_see = list("writhes its tentacles", "churns the water")

	health = 1500
	maxHealth = 1500
	melee_damage_lower = 30
	melee_damage_upper = 45
	base_intents = list(/datum/intent/simple/bite/kraken)

	base_constitution = 18
	base_strength = 16
	base_speed = 7
	vision_range = 10
	aggro_vision_range = 12
	environment_smash = ENVIRONMENT_SMASH_STRUCTURES

	faction = list("kraken")
	aggressive = TRUE
	stat_attack = UNCONSCIOUS
	deaggroprob = 0
	del_on_deaggro = FALSE
	retreat_distance = 0
	minimum_distance = 0

	defprob = 50
	dodgetime = 40

	footstep_type = FOOTSTEP_MOB_HEAVY

	butcher_results = list(
		/obj/item/reagent_containers/food/snacks/meat/steak = 5,
		/obj/item/natural/hide = 3,
		/obj/item/alch/sinew = 4,
		/obj/item/alch/bone = 2,
		/obj/item/alch/viscera = 4
	)
	perfect_butcher_results = list(
		/obj/item/reagent_containers/food/snacks/meat/steak = 8,
		/obj/item/natural/hide = 5,
		/obj/item/alch/sinew = 6,
		/obj/item/alch/bone = 3,
		/obj/item/alch/viscera = 6,
	)

	//attack_sound = list('sound/vo/mobs/kraken/kraken_attack1.ogg')

	ai_controller = /datum/ai_controller/swamp_kraken

	var/max_tentacles = 6
	var/list/active_tentacles = list()
	var/enraged = FALSE
	var/enrage_threshold = 0.5

/mob/living/simple_animal/hostile/retaliate/swamp_kraken/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/ai_aggro_system)
	ADD_TRAIT(src, TRAIT_IMMOBILIZED, INNATE_TRAIT)

	var/datum/action/cooldown/mob_cooldown/kraken_summon_tentacles/summon = new(src)
	summon.Grant(src)
	ai_controller.set_blackboard_key(BB_KRAKEN_SUMMON, summon)

	var/datum/action/cooldown/mob_cooldown/kraken_ink_cloud/ink = new(src)
	ink.Grant(src)
	ai_controller.set_blackboard_key(BB_KRAKEN_INK, ink)

	var/datum/action/cooldown/mob_cooldown/kraken_whirlpool/whirlpool = new(src)
	whirlpool.Grant(src)
	ai_controller.set_blackboard_key(BB_KRAKEN_WHIRLPOOL, whirlpool)

/mob/living/simple_animal/hostile/retaliate/swamp_kraken/adjustHealth(amount, updating_health = TRUE, forced = FALSE)
	. = ..()
	if(!enraged && (health / maxHealth) <= enrage_threshold)
		enrage()

/mob/living/simple_animal/hostile/retaliate/swamp_kraken/proc/enrage()
	enraged = TRUE
	visible_message(span_boldwarning("[src] lets out a horrifying screech! Its movements become more frenzied!"))
	melee_damage_lower = 45
	melee_damage_upper = 60
	max_tentacles = 8

/mob/living/simple_animal/hostile/retaliate/swamp_kraken/proc/summon_tentacles()
	var/tentacles_to_spawn = enraged ? 2 : 1

	for(var/i in 1 to tentacles_to_spawn)
		if(length(active_tentacles) >= max_tentacles)
			break

		var/turf/spawn_turf = get_random_nearby_turf(src, 5)
		if(!spawn_turf)
			continue

		var/static/list/spawn_types = list(
			/mob/living/simple_animal/hostile/kraken_tentacle,
			/mob/living/simple_animal/hostile/kraken_tentacle/grabber,
			/mob/living/simple_animal/hostile/kraken_tentacle/spitter
		)
		var/tentacle_type = pick(spawn_types)

		new /obj/effect/temp_visual/tentacle_emergence(spawn_turf)
		playsound(spawn_turf, 'sound/effects/splash.ogg', 70, TRUE)

		addtimer(CALLBACK(src, PROC_REF(spawn_tentacle), tentacle_type, spawn_turf), 1 SECONDS)

/mob/living/simple_animal/hostile/retaliate/swamp_kraken/proc/spawn_tentacle(tentacle_type, turf/spawn_turf)
	var/mob/living/simple_animal/hostile/kraken_tentacle/tentacle = new tentacle_type(spawn_turf)
	tentacle.parent_kraken = src
	active_tentacles += tentacle
	RegisterSignal(tentacle, COMSIG_PARENT_QDELETING, PROC_REF(on_tentacle_death))

/mob/living/simple_animal/hostile/retaliate/swamp_kraken/proc/on_tentacle_death(datum/source)
	SIGNAL_HANDLER
	active_tentacles -= source

/mob/living/simple_animal/hostile/retaliate/swamp_kraken/proc/get_random_nearby_turf(atom/center, range)
	var/list/possible_turfs = list()

	var/list/bad_turfs = list()
	for(var/atom/movable/movable as anything in active_tentacles)
		bad_turfs |= get_turf(movable)

	for(var/turf/T in view(range, center))
		if(get_dist(T, center) < 3)
			continue
		if(T in bad_turfs)
			continue
		if(!T.density)
			possible_turfs += T


	if(length(possible_turfs))
		return pick(possible_turfs)
	return null

/mob/living/simple_animal/hostile/retaliate/swamp_kraken/death(gibbed)
	. = ..()
	for(var/mob/living/simple_animal/hostile/kraken_tentacle/tentacle in active_tentacles)
		tentacle.death()

/datum/action/cooldown/mob_cooldown/kraken_summon_tentacles
	name = "Summon Tentacles"
	button_icon = 'icons/effects/effects.dmi'
	button_icon_state = "tentacle_icon"
	desc = "Summon tentacles from the depths to attack enemies."
	cooldown_time = 15 SECONDS

/datum/action/cooldown/mob_cooldown/kraken_summon_tentacles/Activate(atom/target)
	var/mob/living/simple_animal/hostile/retaliate/swamp_kraken/kraken = owner
	if(!istype(kraken))
		return FALSE

	kraken.visible_message(span_boldwarning("[kraken] churns the water violently!"))
	kraken.summon_tentacles()
	StartCooldown()
	return TRUE

/datum/action/cooldown/mob_cooldown/kraken_ink_cloud
	name = "Ink Cloud"
	button_icon = 'icons/effects/effects.dmi'
	button_icon_state = "smoke"
	desc = "Release a cloud of blinding ink."
	cooldown_time = 25 SECONDS
	var/cloud_range = 3

/datum/action/cooldown/mob_cooldown/kraken_ink_cloud/Activate(atom/target)
	owner.visible_message(span_boldwarning("[owner] releases a thick cloud of ink!"))

	var/datum/effect_system/smoke_spread/bad/smoke = new
	smoke.set_up(cloud_range, get_turf(owner))
	smoke.start()

	for(var/mob/living/L in view(cloud_range, owner))
		if(L == owner || L.faction == owner.faction)
			continue
		L.adjust_temp_blindness(6 SECONDS)
		to_chat(L, span_danger("The ink stings your eyes!"))

	StartCooldown()
	return TRUE

/datum/action/cooldown/mob_cooldown/kraken_whirlpool
	name = "Whirlpool"
	button_icon = 'icons/effects/effects.dmi'
	button_icon_state = "lightning"
	desc = "Create a whirlpool that pulls enemies inward."
	cooldown_time = 35 SECONDS
	var/whirlpool_range = 5

/datum/action/cooldown/mob_cooldown/kraken_whirlpool/Activate(atom/target)
	owner.visible_message(span_boldwarning("[owner] creates a massive whirlpool!"))

	var/obj/effect/whirlpool/W = new(get_step_towards(target, owner))
	W.creator = owner
	W.duration = 5 SECONDS

	StartCooldown()
	return TRUE

/mob/living/simple_animal/hostile/kraken_tentacle
	icon = 'icons/roguetown/mob/monster/kraken.dmi'
	name = "kraken tentacle"
	desc = "A writhing tentacle of the swamp kraken. It moves with disturbing intelligence."
	icon_state = "gilbert_lh"
	icon_living = "gilbert_lh"
	icon_dead = "gilbert_lh"
	pixel_x = -85
	pixel_y = -50

	health = 200
	maxHealth = 200
	melee_damage_lower = 20
	melee_damage_upper = 30
	base_intents = list(/datum/intent/simple/claw)

	faction = list("kraken")
	stat_attack = UNCONSCIOUS

	vision_range = 8
	aggro_vision_range = 10

	base_constitution = 10
	base_strength = 12
	base_speed = 10

	defprob = 30
	dodgetime = 20

	ai_controller = /datum/ai_controller/kraken_tentacle

	var/mob/living/simple_animal/hostile/retaliate/swamp_kraken/parent_kraken

/mob/living/simple_animal/hostile/kraken_tentacle/Initialize(mapload)
	. = ..()
	if(prob(50))
		icon_state = "gilbert_rh"

	ADD_TRAIT(src, TRAIT_IMMOBILIZED, INNATE_TRAIT)
	AddComponent(/datum/component/ai_aggro_system)

/mob/living/simple_animal/hostile/kraken_tentacle/death(gibbed)
	. = ..()
	new /obj/effect/temp_visual/tentacle_death(get_turf(src))
	parent_kraken.active_tentacles -= src
	parent_kraken = null
	qdel(src)

/mob/living/simple_animal/hostile/kraken_tentacle/grabber
	name = "grasping tentacle"
	desc = "This tentacle seems focused on grabbing and restraining prey."
	health = 180
	maxHealth = 180

	ai_controller = /datum/ai_controller/kraken_tentacle/grabber

/mob/living/simple_animal/hostile/kraken_tentacle/grabber/Initialize(mapload)
	. = ..()
	var/datum/action/cooldown/mob_cooldown/tentacle_grab/grab = new(src)
	grab.Grant(src)
	ai_controller.set_blackboard_key(BB_TARGETED_ACTION, grab)

/datum/action/cooldown/mob_cooldown/tentacle_grab
	name = "Constrict"
	button_icon = 'icons/effects/effects.dmi'
	button_icon_state = "grabbing"
	desc = "Grab and constrict a target, dealing damage over time."
	cooldown_time = 12 SECONDS
	var/constrict_damage = 15
	var/constrict_duration = 4 SECONDS

/datum/action/cooldown/mob_cooldown/tentacle_grab/Activate(atom/target)
	if(!isliving(target))
		return FALSE

	var/mob/living/victim = target
	var/dist = get_dist(owner, victim)

	if(dist > 2)
		return FALSE

	owner.visible_message(span_boldwarning("[owner] wraps around [victim], constricting tightly!"))
	victim.Immobilize(constrict_duration)
	victim.adjustOxyLoss(constrict_damage)
	victim.apply_damage(constrict_damage, BRUTE, "chest")

	new /obj/effect/temp_visual/tentacle_wrap(get_turf(victim))

	to_chat(victim, span_userdanger("The tentacle crushes you!"))

	StartCooldown()
	return TRUE

/mob/living/simple_animal/hostile/kraken_tentacle/spitter
	name = "spitting tentacle"
	desc = "This tentacle drips with corrosive venom. Keep your distance!"

	health = 150
	maxHealth = 150
	melee_damage_lower = 15
	melee_damage_upper = 20

	ranged = TRUE
	retreat_distance = 3
	minimum_distance = 2

	ai_controller = /datum/ai_controller/kraken_tentacle/spitter

/mob/living/simple_animal/hostile/kraken_tentacle/spitter/Initialize(mapload)
	. = ..()
	var/datum/action/cooldown/mob_cooldown/tentacle_spit_acid/spit = new(src)
	spit.Grant(src)
	ai_controller.set_blackboard_key(BB_TARGETED_ACTION, spit)

/datum/action/cooldown/mob_cooldown/tentacle_spit_acid
    name = "Acid Spit"
    button_icon = 'icons/effects/effects.dmi'
    button_icon_state = "acid"
    desc = "Spit corrosive acid at a target."
    cooldown_time = 8 SECONDS
    var/projectile_type = /obj/projectile/tentacle_acid

/datum/action/cooldown/mob_cooldown/tentacle_spit_acid/Activate(atom/target)
    if(!isliving(target))
        return FALSE

    var/turf/start_turf = get_turf(owner)
    if(!start_turf)
        return FALSE

    owner.visible_message(span_boldwarning("[owner] spits a glob of acid at [target]!"))

    var/obj/projectile/tentacle_acid/proj = new projectile_type(start_turf)
    proj.firer = owner
    proj.fired_from = start_turf
    proj.preparePixelProjectile(target, owner)
    proj.fire()

    StartCooldown()
    return TRUE

/obj/projectile/tentacle_acid
    name = "acid glob"
    icon_state = "acid_splash"
    damage = 20
    damage_type = BURN
    range = 6
    speed = 2

/obj/effect/temp_visual/tentacle_emergence
	icon = 'icons/effects/effects.dmi'
	icon_state = "jet_plume"
	duration = 1 SECONDS

/obj/effect/temp_visual/tentacle_death
	icon = 'icons/effects/effects.dmi'
	icon_state = "tentacle_sink"
	duration = 2 SECONDS

/obj/effect/temp_visual/tentacle_wrap
	icon = 'icons/effects/effects.dmi'
	icon_state = "tentacle_constrict"
	duration = 0.5 SECONDS

/obj/effect/temp_visual/acid_projectile
	icon = 'icons/obj/projectiles.dmi'
	icon_state = "acid_splash"
	duration = 1 SECONDS

/obj/effect/temp_visual/acid_splash
	icon = 'icons/effects/effects.dmi'
	icon_state = "acid_pop"
	duration = 1 SECONDS

/datum/intent/simple/bite/kraken
	clickcd = (CLICK_CD_MELEE * 1.5)
