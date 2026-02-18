/mob/living/simple_animal/hostile/retaliate/fae/sprite
	icon = 'icons/mob/summonable/32x32.dmi'
	name = "sprite"
	icon_state = "sprite"
	icon_living = "sprite"
	icon_dead = "vvd"
	summon_primer = "You are a sprite, a small fae. You spend time wandering the wilds. Now you've been pulled from your home into a new world, that is decidedly less wild and natural. How you react to these events, only time can tell."
	tier = 1
	gender = FEMALE
	emote_hear = null
	emote_see = null
	speak_chance = 1
	see_in_dark = 6
	move_to_delay = 3
	base_intents = list(/datum/intent/unarmed/claw)
	butcher_results = list()
	faction = list("fae")
	mob_biotypes = MOB_ORGANIC|MOB_BEAST
	health = 50
	maxHealth = 50
	ranged = FALSE
	melee_damage_lower = 10
	melee_damage_upper = 20
	vision_range = 8
	aggro_vision_range = 11
	environment_smash = ENVIRONMENT_SMASH_NONE
	simple_detect_bonus = 20
	retreat_distance = 3
	minimum_distance = 0
	food_type = list()
	footstep_type = FOOTSTEP_MOB_BAREFOOT
	pooptype = null
	base_endurance = 6
	base_constitution = 6
	base_strength = 2
	base_speed = 17
	simple_detect_bonus = 20
	deaggroprob = 0
	defprob = 40
	defdrain = 10
	del_on_deaggro = 44 SECONDS
	retreat_health = 0.3

	attack_sound = list('sound/foley/plantcross1.ogg','sound/foley/plantcross2.ogg','sound/foley/plantcross3.ogg','sound/foley/plantcross4.ogg')
	attack_verb_continuous = "jabs"
	attack_verb_simple = "jab"
	dodgetime = 60
	aggressive = 1

	ai_controller = /datum/ai_controller/sprite

	del_on_death = TRUE

/mob/living/simple_animal/hostile/retaliate/fae/sprite/Initialize()
	. = ..()
	AddElement(/datum/element/ai_flee_while_injured, 0.75, retreat_health)
	AddComponent(/datum/component/ai_aggro_system)

/mob/living/simple_animal/hostile/retaliate/fae/sprite/death(gibbed)
	var/turf/deathspot = get_turf(src)
	for(var/i in 1 to 6)
		new /obj/item/natural/fairydust(deathspot)
	return ..()
