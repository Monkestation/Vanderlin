/datum/component/vine_spreader
	var/cooldown_time = 10 SECONDS
	var/last_vine_time = 0

/datum/component/vine_spreader/RegisterWithParent()
	. = ..()
	RegisterSignal(parent, COMSIG_MOVABLE_MOVED, PROC_REF(try_spread_vines))

/datum/component/vine_spreader/proc/try_spread_vines(mob/living/source, atom/target)
	if(world.time < last_vine_time + cooldown_time)
		return
	if(source.stat == DEAD)
		return

	target.visible_message(span_boldwarning("Vines spread out from [source]!"))
	for(var/turf/turf as anything in RANGE_TURFS(2, source.loc))
		new /obj/structure/vine(turf)

	last_vine_time = world.time


/mob/living/simple_animal/hostile/retaliate/fae/dryad	//Make this cause giant vine tangled messes
	icon = 'icons/mob/summonable/32x64.dmi'
	name = "dryad"
	icon_state = "dryad"
	icon_living = "dryad"
	icon_dead = "vvd"
	summon_primer = "You are a dryad, a large sized fae. You spend time tending to forests, guarding sacred ground from trespassers. Now you've been pulled from your home into a new world, that is decidedly less wild and natural. How you react to these events, only time can tell."
	tier = 3
	gender = MALE
	emote_hear = null
	emote_see = null
	speak_chance = 1
	see_in_dark = 6
	move_to_delay = 12
	base_intents = list(/datum/intent/simple/elementalt2_unarmed)
	butcher_results = list()
	faction = list("fae", FACTION_PLANTS)
	mob_biotypes = MOB_ORGANIC|MOB_BEAST
	health = 650
	maxHealth = 650
	melee_damage_lower = 20
	melee_damage_upper = 30
	vision_range = 7
	aggro_vision_range = 9
	environment_smash = ENVIRONMENT_SMASH_STRUCTURES
	simple_detect_bonus = 20
	retreat_distance = 0
	minimum_distance = 0
	food_type = list()
	footstep_type = FOOTSTEP_MOB_BAREFOOT
	pooptype = null
	base_constitution = 18
	base_constitution = 18
	base_strength = 14
	base_speed = 4
	simple_detect_bonus = 20
	deaggroprob = 0
	defprob = 40
	defdrain = 10
	del_on_deaggro = 44 SECONDS
	retreat_health = 0.3

	attack_sound = list('sound/foley/plantcross1.ogg','sound/foley/plantcross2.ogg','sound/foley/plantcross3.ogg','sound/foley/plantcross4.ogg')
	dodgetime = 30
	aggressive = 1
//	stat_attack = UNCONSCIOUS
	ranged = FALSE

	ai_controller = /datum/ai_controller/basic_controller/dryad

	del_on_death = TRUE

/mob/living/simple_animal/hostile/retaliate/fae/dryad/Initialize()
	. = ..()
	AddComponent(/datum/component/ai_aggro_system)
	AddComponent(/datum/component/vine_spreader)

/mob/living/simple_animal/hostile/retaliate/fae/dryad/simple_add_wound(datum/wound/wound, silent = FALSE, crit_message = FALSE)	//no wounding the watcher
	return

/mob/living/simple_animal/hostile/retaliate/fae/dryad/death(gibbed)
	var/turf/deathspot = get_turf(src)
	new /obj/item/natural/melded/t1(deathspot)
	new /obj/item/natural/iridescentscale(deathspot)
	new /obj/item/natural/iridescentscale(deathspot)
	new /obj/item/natural/heartwoodcore(deathspot)
	new /obj/item/natural/heartwoodcore(deathspot)
	new /obj/item/natural/fairydust(deathspot)
	new /obj/item/natural/fairydust(deathspot)
	spill_embedded_objects()
	return ..()
