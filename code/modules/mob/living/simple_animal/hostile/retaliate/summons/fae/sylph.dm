/mob/living/simple_animal/hostile/retaliate/fae/sylph/simple_add_wound(datum/wound/wound, silent = FALSE, crit_message = FALSE)	//no wounding the fiend
	return

/mob/living/simple_animal/hostile/retaliate/fae/sylph
	icon = 'icons/mob/summonable/32x32.dmi'
	name = "sylph"
	icon_state = "sylph"
	icon_living = "sylph"
	icon_dead = "vvd"
	tier = 4
	gender = MALE
	emote_hear = null
	emote_see = null
	speak_chance = 1
	see_in_dark = 6
	move_to_delay = 3
	base_intents = list(/datum/intent/simple/bite)
	butcher_results = list()
	faction = list("fae")
	mob_biotypes = MOB_ORGANIC|MOB_BEAST
	health = 700
	maxHealth = 700
	melee_damage_lower = 20
	melee_damage_upper = 30
	vision_range = 7
	aggro_vision_range = 9
	environment_smash = ENVIRONMENT_SMASH_NONE
	simple_detect_bonus = 20
	retreat_distance = 4
	minimum_distance = 4
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

	attack_sound = list('sound/foley/plantcross1.ogg','sound/foley/plantcross2.ogg','sound/foley/plantcross3.ogg','sound/foley/plantcross4.ogg')
	dodgetime = 40
	aggressive = 1
	ranged = TRUE
	rapid = 3
	projectiletype = /obj/projectile/magic/frostbolt/greater
	ranged_message = "throws icy magick"

	ai_controller = /datum/ai_controller/sylph

	del_on_death = TRUE

/mob/living/simple_animal/hostile/retaliate/fae/sylph/Initialize()
	. = ..()
	AddElement(/datum/element/ai_flee_while_injured, 0.75, retreat_health)
	AddComponent(/datum/component/ai_aggro_system)

/obj/projectile/magic/frostbolt/greater
	name = "greater frostbolt"
	damage = 25
	range = 6
	speed = 6 //higher is slower

/mob/living/simple_animal/hostile/retaliate/fae/sylph/death(gibbed)
	var/turf/deathspot = get_turf(src)
	new /obj/item/natural/sylvanessence(deathspot)
	new /obj/item/natural/fairydust(deathspot)
	new /obj/item/natural/fairydust(deathspot)
	new /obj/item/natural/melded/t2(deathspot)
	new /obj/item/natural/iridescentscale(deathspot)
	new /obj/item/natural/heartwoodcore(deathspot)
	new /obj/item/natural/fairydust(deathspot)
	new /obj/item/natural/fairydust(deathspot)
	spill_embedded_objects()
	return ..()
