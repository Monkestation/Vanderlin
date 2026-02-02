/mob/living/simple_animal/hostile/retaliate/leylinelycan/Initialize(mapload, obj/structure/portal)
	. = ..()
	AddComponent(/datum/component/ai_aggro_system)
	ai_controller.set_blackboard_key(BB_LEYLINE_SOURCE, portal)
	ADD_TRAIT(src, TRAIT_NOBREATH, TRAIT_GENERIC)
	ADD_TRAIT(src, TRAIT_TOXIMMUNE, TRAIT_GENERIC)

/mob/living/simple_animal/hostile/retaliate/leylinelycan
	icon = 'icons/mob/summonable/32x32.dmi'
	name = "Leyline Lycan"
	desc = "A creature made of leyline energy. It is highly territorial and guards its home leyline jealously."
	icon_state = "leycreature"
	icon_living = "leycreature"
	icon_dead = "leycreature"

	faction = list("leyline")
	emote_hear = null
	emote_see = null
	see_in_dark = 9
	move_to_delay = 1
	vision_range = 9
	aggro_vision_range = 9

	butcher_results = list()
	animal_type = /datum/blood_type/lycan

	health = 240
	maxHealth = 240
	food_max = 0
	food_type = list()

	base_intents = list(/datum/intent/simple/bite)
	attack_sound = list('sound/vo/mobs/vw/attack (1).ogg','sound/vo/mobs/vw/attack (2).ogg','sound/vo/mobs/vw/attack (3).ogg','sound/vo/mobs/vw/attack (4).ogg')
	melee_damage_lower = 20
	melee_damage_upper = 30

	base_constitution = 7
	base_strength = 8
	base_speed = 15

	simple_detect_bonus = 20
	retreat_distance = 0
	minimum_distance = 0
	deaggroprob = 0
	defprob = 35
	defdrain = 5
	retreat_health = 0.4

	dodgetime = 30
	aggressive = 1
	body_eater = FALSE

	ai_controller = /datum/ai_controller/lycan
	dendor_taming_chance = DENDOR_TAME_PROB_NONE
	del_on_death = TRUE

/mob/living/simple_animal/hostile/retaliate/leylinelycan/simple_add_wound(datum/wound/wound, silent = FALSE, crit_message = FALSE)	//No wounding the lycan.
	return

/mob/living/simple_animal/hostile/retaliate/leylinelycan/death(gibbed)
	var/obj/structure/leyline/source = ai_controller.blackboard[BB_LEYLINE_SOURCE]
	source?.guardian = null
	var/turf/deathspot = get_turf(src)
	new /obj/item/natural/leyline(deathspot)
	spill_embedded_objects()
	return ..()

/obj/effect/temp_visual/lycan
	icon = 'icons/effects/effects.dmi'
	icon_state = "rift"
	duration = 3
