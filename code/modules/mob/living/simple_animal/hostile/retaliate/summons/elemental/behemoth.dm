
/mob/living/simple_animal/hostile/retaliate/elemental/behemoth
	icon = 'icons/mob/summonable/32x64.dmi'
	name = "earthen behemoth"
	summon_primer = "You are an behemoth, a large elemental. Elementals such as yourself often lead groups of wardens in defending your plane. Now you've been pulled from your home into a new world, that is decidedly less peaceful then your carefully guarded plane. How you react to these events, only time can tell."
	icon_state = "behemoth"
	icon_living = "behemoth"
	tier = 3
	icon_dead = "vvd"
	gender = MALE
	emote_hear = null
	emote_see = null
	speak_chance = 1
	see_in_dark = 6
	move_to_delay = 15
	base_intents = list(/datum/intent/simple/elementalt2_unarmed)
	butcher_results = list()
	faction = list("elemental")
	mob_biotypes = MOB_ORGANIC|MOB_BEAST
	health = 800
	maxHealth = 800
	melee_damage_lower = 55
	melee_damage_upper = 80
	vision_range = 7
	aggro_vision_range = 9
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
	dodgetime = 30
	aggressive = 1

	base_constitution = 17
	base_endurance = 17
	base_strength = 13
	base_speed = 5

	ai_controller = /datum/ai_controller/behemoth

	del_on_death = TRUE

/mob/living/simple_animal/hostile/retaliate/elemental/behemoth/Initialize()
	. = ..()
	AddComponent(/datum/component/ai_aggro_system)

/mob/living/simple_animal/hostile/retaliate/elemental/behemoth/death(gibbed)
	var/turf/deathspot = get_turf(src)
	new /obj/item/natural/melded/t1(deathspot)
	new /obj/item/natural/elementalfragment(deathspot)
	new /obj/item/natural/elementalfragment(deathspot)
	new /obj/item/natural/elementalshard(deathspot)
	new /obj/item/natural/elementalshard(deathspot)
	new /obj/item/natural/elementalmote(deathspot)
	new /obj/item/natural/elementalmote(deathspot)
	spill_embedded_objects()
	return ..()

/obj/effect/temp_visual/marker
	icon = 'icons/effects/effects.dmi'
	icon_state = "trap"
	light_outer_range = 2
	duration = 1.5 SECONDS
	layer = ABOVE_ALL_MOB_LAYER //this doesnt render above mobs? it really should

/datum/intent/simple/elementalt2_unarmed
	name = "elemental unarmed"
	icon_state = "instrike"
	attack_verb = list("punches", "strikes", "kicks", "steps on", "crushes")
	animname = "blank22"
	blade_class = BCLASS_SMASH
	hitsound = null
	chargetime = 0
	penfactor = 15
	swingdelay = 3
	candodge = TRUE
