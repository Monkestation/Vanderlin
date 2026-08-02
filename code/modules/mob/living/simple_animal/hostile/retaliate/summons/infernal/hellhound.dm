
/mob/living/simple_animal/hostile/retaliate/infernal/hellhound
	icon = 'icons/mob/summonable/32x32.dmi'
	name = "hell hound"
	icon_state = "hellhound"
	icon_living = "hellhound"
	icon_dead = "vvd"
	summon_primer = "You are a hellhound, a moderate sized canine made of heat and flame. You spend time in the infernal plane hunting and incinerating things to your hearts content. Now you've been pulled from your home into a new world, that is decidedly lacking in fire. How you react to these events, only time can tell."
	tier = 2
	gender = MALE
	emote_hear = null
	emote_see = null
	speak_chance = 1
	see_in_dark = 6
	move_to_delay = 3
	base_intents = list(/datum/intent/simple/bite)
	butcher_results = list()
	faction = list("infernal")
	mob_biotypes = MOB_ORGANIC|MOB_BEAST
	health = 170
	maxHealth = 170
	melee_damage_lower = 15
	melee_damage_upper = 17
	vision_range = 7
	aggro_vision_range = 9
	environment_smash = ENVIRONMENT_SMASH_NONE
	simple_detect_bonus = 20
	ranged = TRUE
	projectiletype = /obj/projectile/magic/firebolt
	retreat_distance = 4
	minimum_distance = 3
	food_type = list()
	footstep_type = FOOTSTEP_MOB_BAREFOOT
	pooptype = null
	base_constitution = 7
	base_strength = 9
	base_speed = 13
	simple_detect_bonus = 20
	deaggroprob = 0
	defprob = 40
	defdrain = 10
	del_on_deaggro = 44 SECONDS
	retreat_health = 0.3

	attack_sound = list('sound/vo/mobs/vw/attack (1).ogg','sound/vo/mobs/vw/attack (2).ogg','sound/vo/mobs/vw/attack (3).ogg','sound/vo/mobs/vw/attack (4).ogg')
	dodgetime = 30

	ai_controller = /datum/ai_controller/hellhound

	del_on_death = TRUE

/mob/living/simple_animal/hostile/retaliate/infernal/hellhound/Initialize()
	. = ..()
	AddComponent(/datum/component/ai_aggro_system)

/mob/living/simple_animal/hostile/retaliate/infernal/hellhound/death(gibbed)
	var/turf/deathspot = get_turf(src)
	new /obj/item/natural/hellhoundfang(deathspot)
	new /obj/item/natural/hellhoundfang(deathspot)
	new /obj/item/natural/hellhoundfang(deathspot)
	new /obj/item/natural/hellhoundfang(deathspot)
	new /obj/item/natural/infernalash(deathspot)
	new /obj/item/natural/infernalash(deathspot)
	new /obj/item/natural/infernalash(deathspot)
	spill_embedded_objects()
	return ..()
