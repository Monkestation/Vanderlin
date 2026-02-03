
/mob/living/simple_animal/hostile/retaliate/infernal/watcher
	icon = 'icons/mob/summonable/32x32.dmi'
	name = "infernal watcher"
	icon_state = "watcher"
	icon_living = "watcher"
	summon_primer = "You are an infernal watcher, a creature of lava and rock. You have watched over the chaos of the infernal plane long enough that it has been pointless to keep count."
	tier = 3
	icon_dead = "vvd"
	gender = MALE
	emote_hear = null
	emote_see = null
	speak_chance = 1
	see_in_dark = 6
	move_to_delay = 5
	base_intents = list(/datum/intent/simple/bite)
	butcher_results = list()
	faction = list("infernal")
	mob_biotypes = MOB_ORGANIC|MOB_BEAST
	health = 600
	maxHealth = 600
	melee_damage_lower = 20
	melee_damage_upper = 30
	vision_range = 7
	aggro_vision_range = 9
	environment_smash = ENVIRONMENT_SMASH_NONE
	simple_detect_bonus = 20
	retreat_distance = 4
	minimum_distance = 3
	food_type = list()
	footstep_type = FOOTSTEP_MOB_BAREFOOT
	pooptype = null
	base_constitution = 13
	base_strength = 12
	base_speed = 8
	simple_detect_bonus = 20
	deaggroprob = 0
	defprob = 40
	defdrain = 10
	del_on_deaggro = 44 SECONDS
	retreat_health = 0.3

	attack_sound = list('sound/misc/lava_death.ogg')
	dodgetime = 30
	aggressive = 1
//	stat_attack = UNCONSCIOUS
	ranged = TRUE
	ranged_cooldown = 40
	projectiletype = /obj/projectile/magic/firebolt
	ranged_message = "stares"

	ai_controller = /datum/ai_controller/watcher

	del_on_death = TRUE

/mob/living/simple_animal/hostile/retaliate/infernal/watcher/Initialize()
	. = ..()
	AddComponent(/datum/component/ai_aggro_system)

/mob/living/simple_animal/hostile/retaliate/infernal/watcher/simple_add_wound(datum/wound/wound, silent = FALSE, crit_message = FALSE)	//no wounding the watcher
	return

/mob/living/simple_animal/hostile/retaliate/infernal/watcher/death(gibbed)
	var/turf/deathspot = get_turf(src)
	new /obj/item/natural/moltencore(deathspot)
	new /obj/item/natural/moltencore(deathspot)
	new /obj/item/natural/hellhoundfang(deathspot)
	new /obj/item/natural/hellhoundfang(deathspot)
	new /obj/item/natural/infernalash(deathspot)
	new /obj/item/natural/infernalash(deathspot)
	new /obj/item/natural/melded/t1(deathspot)
	spill_embedded_objects()
	return ..()

/mob/living/simple_animal/hostile/retaliate/infernal/watcher/AttackingTarget(mob/living/passed_target)
	visible_message(span_danger("[src] emits a burst of flames from its core!"))
	for(var/t in RANGE_TURFS(1, src))
		new /obj/effect/hotspot(t)
	return ..()
