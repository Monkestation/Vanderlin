
/mob/living/simple_animal/hostile/retaliate/elemental/crawler
	icon = 'icons/mob/summonable/32x32.dmi'
	name = "earthen crawler"
	summon_primer = "You are a crawler, a small elemental. Elementals such as yourself spend immeasurable time wandering about within your plane. Now you've been pulled from your home into a new world, that is decidedly less peaceful then your carefully guarded plane. How you react to these events, only time can tell."
	icon_state = "crawler"
	icon_living = "crawler"
	tier = 1
	icon_dead = "vvd"
	gender = MALE
	speak_chance = 1
	see_in_dark = 6
	move_to_delay = 8
	base_intents = list(/datum/intent/simple/elemental_unarmed)
	butcher_results = list()
	faction = list("elemental")
	mob_biotypes = MOB_ORGANIC|MOB_BEAST
	health = 120
	maxHealth = 120
	melee_damage_lower = 15
	melee_damage_upper = 17
	vision_range = 8
	aggro_vision_range = 11
	environment_smash = ENVIRONMENT_SMASH_NONE
	simple_detect_bonus = 20
	retreat_distance = 0
	minimum_distance = 0
	food_type = list()
	footstep_type = FOOTSTEP_MOB_BAREFOOT
	pooptype = null
	simple_detect_bonus = 20
	deaggroprob = 0
	defprob = 40
	defdrain = 10
	del_on_deaggro = 44 SECONDS
	retreat_health = 0.3

	attack_sound = list('sound/combat/hits/onstone/wallhit.ogg')
	attack_verb_continuous = "pounds"
	attack_verb_simple = "pounds"
	dodgetime = 0
	aggressive = 1

	base_constitution = 13
	base_endurance = 13
	base_strength = 8
	base_speed = 8

	ai_controller = /datum/ai_controller/crawler

	del_on_death = TRUE

/mob/living/simple_animal/hostile/retaliate/elemental/crawler/Initialize()
	. = ..()
	AddComponent(/datum/component/ai_aggro_system)

/mob/living/simple_animal/hostile/retaliate/elemental/crawler/death(gibbed)
	var/turf/deathspot = get_turf(src)
	for(var/i in 1 to 6)
		new /obj/item/natural/elementalmote(deathspot)
	return ..()
