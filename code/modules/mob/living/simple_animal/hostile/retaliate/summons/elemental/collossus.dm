/mob/living/simple_animal/hostile/retaliate/elemental/collossus
	icon = 'icons/mob/summonable/64x64.dmi'
	name = "earthen colossus"
	icon_state = "collossus"
	icon_living = "collossus"
	icon_dead = "vvd"
	summon_primer = "You are a colossus, a massive elemental. Elementals such as yourself are immeasurably old. Now you've been pulled from your home into a new world, that is decidedly less peaceful then your carefully guarded plane. How you react to these events, only time can tell."
	tier = 4
	gender = MALE
	emote_hear = null
	emote_see = null
	speak_chance = 1
	see_in_dark = 6
	move_to_delay = 16
	base_intents = list(/datum/intent/simple/elementalt2_unarmed)
	butcher_results = list()
	faction = list("elemental")
	mob_biotypes = MOB_ORGANIC|MOB_BEAST
	health = 1500
	maxHealth = 1500
	melee_damage_lower = 40
	melee_damage_upper = 70
	vision_range = 7
	aggro_vision_range = 9
	environment_smash = ENVIRONMENT_SMASH_NONE
	simple_detect_bonus = 20
	retreat_distance = 0
	minimum_distance = 0
	food_type = list()
	ranged = TRUE
	projectiletype = /obj/projectile/earthenchunk
	footstep_type = FOOTSTEP_MOB_BAREFOOT
	pooptype = null
	ranged = TRUE
	simple_detect_bonus = 20
	deaggroprob = 0
	defprob = 40
	defdrain = 10
	del_on_deaggro = 44 SECONDS
	retreat_health = 0.3

	attack_sound = list('sound/combat/hits/onstone/wallhit.ogg')
	SET_BASE_PIXEL(-32, 0)
	dodgetime = 0
	aggressive = 1

	base_constitution = 20
	base_endurance = 20
	base_strength = 16
	base_speed = 3

	ai_controller = /datum/ai_controller/collossus

	del_on_death = TRUE

/mob/living/simple_animal/hostile/retaliate/elemental/collossus/Initialize()
	. = ..()
	AddComponent(/datum/component/ai_aggro_system)

/mob/living/simple_animal/hostile/retaliate/elemental/collossus/death(gibbed)
	var/turf/deathspot = get_turf(src)
	new /obj/item/natural/elementalrelic(deathspot)
	spill_embedded_objects()
	return ..()

/obj/projectile/earthenchunk
	name = "Elemental Chunk"
	icon_state = "rock"
	damage = 30
	damage_type = BRUTE
	flag = "magic"
	range = 10
	speed = 16 //higher is slower

/obj/effect/temp_visual/stomp
	icon = 'icons/effects/effects.dmi'
	icon_state = "phaseout"
	light_outer_range = 2
	duration = 5
	layer = ABOVE_ALL_MOB_LAYER //this doesnt render above mobs? it really should

/obj/projectile/earthenchunk/on_hit(target)
	. = ..()
	var/list/spawnLists = list(/mob/living/simple_animal/hostile/retaliate/elemental/crawler,/mob/living/simple_animal/hostile/retaliate/elemental/crawler, /mob/living/simple_animal/hostile/retaliate/elemental/crawler)
	var/reinforcement_count = 3
	if(prob(20))
		src.visible_message(span_notice("[src] breaks apart, scattering minor elementals about!"))
		while(reinforcement_count > 0)
			var/list/turflist = list()
			for(var/turf/t in RANGE_TURFS(1, src))
				turflist += t

			var/turf/picked = pick(turflist)


			var/spawnTypes = pick_n_take(spawnLists)
			new spawnTypes(picked)
			reinforcement_count--
			continue

	qdel(src)
