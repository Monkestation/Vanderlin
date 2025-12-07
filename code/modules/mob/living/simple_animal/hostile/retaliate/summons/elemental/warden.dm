
/mob/living/simple_animal/hostile/retaliate/elemental/warden
	icon = 'icons/mob/summonable/32x32.dmi'
	name = "earthen Warden"
	icon_state = "warden"
	icon_living = "warden"
	icon_dead = "vvd"
	summon_primer = "You are a warden, a moderate elemental. Elementals such as yourself guard your plane from intrusion zealously. Now you've been pulled from your home into a new world, that is decidedly less peaceful then your carefully guarded plane. How you react to these events, only time can tell."
	tier = 2
	gender = MALE
	emote_hear = null
	emote_see = null
	speak_chance = 1
	see_in_dark = 6
	move_to_delay = 12
	base_intents = list(/datum/intent/simple/elemental_unarmed)
	butcher_results = list()
	faction = list("elemental")
	mob_biotypes = MOB_ORGANIC|MOB_BEAST
	health = 240
	maxHealth = 240
	melee_damage_lower = 15
	melee_damage_upper = 17
	vision_range = 7
	aggro_vision_range = 9
	environment_smash = ENVIRONMENT_SMASH_STRUCTURES
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

	rapid = TRUE
	attack_sound = list('sound/combat/hits/onstone/wallhit.ogg')
	dodgetime = 30
	aggressive = 1

	base_constitution = 15
	base_endurance = 15
	base_strength = 10
	base_speed = 6

	ai_controller = /datum/ai_controller/warden

	del_on_death = TRUE

/mob/living/simple_animal/hostile/retaliate/elemental/warden/Initialize()
	. = ..()
	AddComponent(/datum/component/ai_aggro_system)

/mob/living/simple_animal/hostile/retaliate/elemental/warden/death(gibbed)
	var/turf/deathspot = get_turf(src)
	new /obj/item/natural/elementalshard(deathspot)
	new /obj/item/natural/elementalshard(deathspot)
	new /obj/item/natural/elementalshard(deathspot)
	new /obj/item/natural/elementalshard(deathspot)
	new /obj/item/natural/elementalmote(deathspot)
	new /obj/item/natural/elementalmote(deathspot)
	new /obj/item/natural/elementalmote(deathspot)
	new /obj/item/natural/elementalmote(deathspot)
	spill_embedded_objects()
	return ..()
