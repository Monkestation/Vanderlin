
/mob/living/simple_animal/hostile/retaliate/infernal/imp
	icon = 'icons/mob/summonable/32x32.dmi'
	name = "infernal imp"
	icon_state = "imp"
	icon_living = "imp"
	icon_dead = "vvd"
	gender = MALE
	emote_hear = null
	emote_see = null
	speak_chance = 1
	see_in_dark = 6
	move_to_delay = 3
	base_intents = list(/datum/intent/unarmed/claw)
	butcher_results = list()
	faction = list("infernal")
	mob_biotypes = MOB_ORGANIC|MOB_BEAST
	health = 70
	maxHealth = 70
	melee_damage_lower = 15
	melee_damage_upper = 17
	vision_range = 7
	aggro_vision_range = 9
	environment_smash = ENVIRONMENT_SMASH_NONE
	simple_detect_bonus = 20
	projectiletype = /obj/projectile/magic/firebolt
	retreat_distance = 4
	minimum_distance = 3
	food_type = list()
	footstep_type = FOOTSTEP_MOB_BAREFOOT
	pooptype = null
	base_constitution = 7
	base_strength = 6
	base_speed = 12
	simple_detect_bonus = 20
	deaggroprob = 0
	defprob = 40
	defdrain = 10
	del_on_deaggro = 44 SECONDS
	retreat_health = 0.3

	attack_sound = list('sound/combat/hits/bladed/smallslash (1).ogg')
	attack_verb_continuous = "claws"
	attack_verb_simple = "claw"
	dodgetime = 30

	ai_controller = /datum/ai_controller/imp

	del_on_death = TRUE

/obj/projectile/magic/firebolt
	name = "ball of fire"
	icon_state = "fireball"
	damage = 20
	damage_type = BURN
	nodamage = FALSE
	armor_penetration = 0
	flag = "magic"
	hitsound = 'sound/blank.ogg'

/mob/living/simple_animal/hostile/retaliate/infernal/imp/Initialize()
	. = ..()
	AddComponent(/datum/component/ai_aggro_system)

/mob/living/simple_animal/hostile/retaliate/infernal/imp/death(gibbed)
	var/turf/deathspot = get_turf(src)
	for(var/i in 1 to 6)
		new /obj/item/natural/infernalash(deathspot)
	return ..()

/mob/living/simple_animal/hostile/retaliate/infernal/imp/taunted(mob/user)
	emote("aggro")
	return
