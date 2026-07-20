/mob/living/simple_animal/hostile/retaliate/fae/glimmerwing
	icon = 'icons/mob/summonable/32x32.dmi'
	name = "glimmerwing"
	icon_state = "glimmerwing"
	icon_living = "glimmerwing"
	icon_dead = "vvd"
	summon_primer = "You are a glimmerwing, a moderate sized fae. You spend time wandering forests, cursing unweary travellers. Now you've been pulled from your home into a new world, that is decidedly less wild and natural. How you react to these events, only time can tell."
	tier = 2
	gender = MALE
	emote_hear = null
	emote_see = null
	speak_chance = 1
	see_in_dark = 6
	move_to_delay = 6
	base_intents = list(/datum/intent/simple/bite)
	butcher_results = list()
	faction = list("fae")
	mob_biotypes = MOB_ORGANIC|MOB_BEAST
	health = 170
	maxHealth = 170
	melee_damage_lower = 15
	melee_damage_upper = 17
	vision_range = 7
	aggro_vision_range = 9
	environment_smash = ENVIRONMENT_SMASH_NONE
	simple_detect_bonus = 20
	ranged = FALSE
	retreat_distance = 0
	minimum_distance = 0
	food_type = list()
	footstep_type = FOOTSTEP_MOB_BAREFOOT
	pooptype = null
	base_constitution = 7
	base_strength = 9
	base_speed = 15
	simple_detect_bonus = 20
	deaggroprob = 0
	defprob = 40
	defdrain = 10
	del_on_deaggro = 44 SECONDS
	retreat_health = 0.3

	attack_sound = list('sound/foley/plantcross1.ogg','sound/foley/plantcross2.ogg','sound/foley/plantcross3.ogg','sound/foley/plantcross4.ogg')
	dodgetime = 40

	ai_controller = /datum/ai_controller/glimmerwing

	del_on_death = TRUE

/mob/living/simple_animal/hostile/retaliate/fae/glimmerwing/Initialize()
	. = ..()
	AddElement(/datum/element/ai_flee_while_injured, 0.75, retreat_health)
	AddComponent(/datum/component/ai_aggro_system)

/mob/living/simple_animal/hostile/retaliate/fae/glimmerwing/death(gibbed)
	var/turf/deathspot = get_turf(src)
	new /obj/item/natural/iridescentscale(deathspot)
	new /obj/item/natural/iridescentscale(deathspot)
	new /obj/item/natural/iridescentscale(deathspot)
	new /obj/item/natural/iridescentscale(deathspot)
	new /obj/item/natural/fairydust(deathspot)
	new /obj/item/natural/fairydust(deathspot)
	new /obj/item/natural/fairydust(deathspot)
	new /obj/item/natural/fairydust(deathspot)
	spill_embedded_objects()
	return ..()
