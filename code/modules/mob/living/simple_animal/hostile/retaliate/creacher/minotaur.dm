/mob/living/simple_animal/hostile/retaliate/minotaur
	icon = 'icons/mob/newminotaur.dmi'
	name = "Minotaur"
	icon_state = "MinotaurMale"
	icon_living = "MinotaurMale"
	icon_dead = "MinotaurMale_dead"
	gender = MALE
	emote_hear = null
	emote_see = null
	speak_chance = 1
	see_in_dark = 10
	move_to_delay = 3
	base_intents = list(/datum/intent/simple/minotaur_unarmed)
	butcher_results = list(/obj/item/reagent_containers/food/snacks/meat/steak = 10,
						/obj/item/natural/hide = 10, /obj/item/natural/bundle/bone/full = 2)
	faction = list("caves")
	mob_biotypes = MOB_ORGANIC|MOB_BEAST
	health = 1500
	maxHealth = 1500
	melee_damage_lower = 55
	melee_damage_upper = 80
	vision_range = 3
	aggro_vision_range = 8
	environment_smash = ENVIRONMENT_SMASH_STRUCTURES
	obj_damage = 1
	retreat_distance = 0
	minimum_distance = 0
	food_type = list(/obj/item/reagent_containers/food/snacks/meat, /obj/item/bodypart, /obj/item/organ)
	footstep_type = FOOTSTEP_MOB_HEAVY
	pooptype = null
	base_constitution = 19
	base_strength = 16
	base_speed = 5
	deaggroprob = 0
	defprob = 40
	defdrain = 10
	retreat_health = 0

	attack_sound = list('sound/combat/wooshes/blunt/wooshhuge (1).ogg','sound/combat/wooshes/blunt/wooshhuge (2).ogg','sound/combat/wooshes/blunt/wooshhuge (3).ogg')
	dodgetime = 50
	aggressive = 1
//	stat_attack = UNCONSCIOUS

	ai_controller = /datum/ai_controller/minotaur
	dendor_taming_chance = DENDOR_TAME_PROB_NONE


/mob/living/simple_animal/hostile/retaliate/minotaur/Initialize()
	. = ..()
	AddComponent(/datum/component/ai_aggro_system)

/mob/living/simple_animal/hostile/retaliate/minotaur/female
	icon_state = "MinotaurFem"
	icon_living = "MinotaurFem"
	icon_dead = "MinotaurFem_dead"

/mob/living/simple_animal/hostile/retaliate/minotaur/axe
	icon_state = "MinotaurMale_Axe"
	icon_living = "MinotaurMale_Axe"
	icon_dead = "MinotaurMale_dead"
	base_intents = list(/datum/intent/simple/minotaur_axe)
	melee_damage_lower = 65
	melee_damage_upper = 85
	loot = list(/obj/item/weapon/greataxe/steel/doublehead)

/mob/living/simple_animal/hostile/retaliate/minotaur/axe/female
	icon_state = "MinotaurFem_Axe"
	icon_living = "MinotaurFem_Axe"
	icon_dead = "MinotaurFem_dead"

/mob/living/simple_animal/hostile/retaliate/minotaur/taunted(mob/user)
	emote("aggro")
	return

/mob/living/simple_animal/hostile/retaliate/minotaur/get_sound(input)
	switch(input)
		if("aggro")
			return pick('sound/vo/mobs/minotaur/minoroar.ogg','sound/vo/mobs/minotaur/minoroar2.ogg','sound/vo/mobs/minotaur/minoroar3.ogg','sound/vo/mobs/minotaur/minoroar4.ogg')
		if("pain")
			return pick('sound/vo/mobs/minotaur/minopain.ogg', 'sound/vo/mobs/minotaur/minopain2.ogg')
		if("death")
			return pick('sound/vo/mobs/minotaur/minodie.ogg', 'sound/vo/mobs/minotaur/minodie2.ogg')
		if("idle")
			return pick('sound/vo/mobs/minotaur/minoidle.ogg', 'sound/vo/mobs/minotaur/minoidle2.ogg')


/mob/living/simple_animal/hostile/retaliate/minotaur/simple_limb_hit(zone)
	if(!zone)
		return ""
	switch(zone)
		if(BODY_ZONE_PRECISE_R_EYE)
			return "head"
		if(BODY_ZONE_PRECISE_L_EYE)
			return "head"
		if(BODY_ZONE_PRECISE_NOSE)
			return "nose"
		if(BODY_ZONE_PRECISE_MOUTH)
			return "mouth"
		if(BODY_ZONE_PRECISE_SKULL)
			return "head"
		if(BODY_ZONE_PRECISE_EARS)
			return "head"
		if(BODY_ZONE_PRECISE_NECK)
			return "neck"
		if(BODY_ZONE_PRECISE_L_HAND)
			return "foreleg"
		if(BODY_ZONE_PRECISE_R_HAND)
			return "foreleg"
		if(BODY_ZONE_PRECISE_L_FOOT)
			return "leg"
		if(BODY_ZONE_PRECISE_R_FOOT)
			return "leg"
		if(BODY_ZONE_PRECISE_STOMACH)
			return "stomach"
		if(BODY_ZONE_PRECISE_GROIN)
			return "tail"
		if(BODY_ZONE_HEAD)
			return "head"
		if(BODY_ZONE_R_LEG)
			return "leg"
		if(BODY_ZONE_L_LEG)
			return "leg"
		if(BODY_ZONE_R_ARM)
			return "foreleg"
		if(BODY_ZONE_L_ARM)
			return "foreleg"
	return ..()

/datum/intent/simple/minotaur_unarmed
	name = "minotaur unarmed"
	icon_state = "instrike"
	attack_verb = list("punches", "strikes", "kicks", "steps on", "crushes", "bites")
	animname = "blank22"
	blade_class = BCLASS_CUT
	hitsound = "smallslash"
	chargetime = 0
	penfactor = 5
	swingdelay = 3
	candodge = TRUE
	canparry = TRUE
	item_damage_type = "stab"

/datum/intent/simple/minotaur_axe
	name = "minotaur axe"
	icon_state = "instrike"
	attack_verb = list("hacks at", "slashes", "chops", "steps on", "crushes", "bites")
	animname = "blank22"
	blade_class = BCLASS_CUT
	hitsound = "genchop"
	chargetime = 20
	penfactor = 10
	swingdelay = 3
	candodge = TRUE
	canparry = TRUE
	item_damage_type = "stab"

/obj/effect/temp_visual/minotaur_rage
	icon = 'icons/effects/effects.dmi'
	icon_state = "anger"
	duration = 15
	randomdir = FALSE
	layer = ABOVE_MOB_LAYER

/obj/effect/temp_visual/minotaur_charge
	icon = 'icons/effects/effects.dmi'
	icon_state = "impact_m"
	duration = 5
	randomdir = FALSE

/obj/effect/temp_visual/minotaur_impact
	icon = 'icons/effects/effects.dmi'
	icon_state = "impact_dust"
	duration = 10

/obj/effect/temp_visual/minotaur_magic
	icon = 'icons/effects/effects.dmi'
	icon_state = "shield-old"
	duration = 10
	randomdir = FALSE
	layer = ABOVE_MOB_LAYER

/obj/effect/temp_visual/minotaur_slam
	icon = 'icons/effects/effects.dmi'
	icon_state = "pulse2"
	duration = 15
	randomdir = FALSE
	layer = BELOW_MOB_LAYER

/obj/effect/temp_visual/minotaur_fury_zone
	name = "fiery zone"
	desc = "A patch of ground that's about to erupt in flames!"
	icon = 'icons/effects/fire.dmi'
	icon_state = "fire_small"
	layer = BELOW_MOB_LAYER
	light_outer_range = 2
	light_color = LIGHT_COLOR_FIRE
	duration = 4 SECONDS
	var/damage_per_tick = 5
	var/knockdown_time = 0.5 SECONDS
	var/warned = FALSE
	var/active = FALSE

/obj/effect/temp_visual/minotaur_fury_zone/Initialize(mapload)
	. = ..()
	alpha = 150
	color = "#ffff00" // Yellow warning color
	transform = matrix() * 0.5 // Start small
	animate(src, alpha = 200, color = "#ff5500", transform = matrix(), time = 1 SECONDS)
	addtimer(CALLBACK(src, PROC_REF(activate)), 1.5 SECONDS)
	playsound(get_turf(src), 'sound/misc/bamf.ogg', 25, TRUE)

/obj/effect/temp_visual/minotaur_fury_zone/proc/activate()
	active = TRUE
	color = "#ff0000" // Red active color
	alpha = 230
	icon_state = "fire"
	playsound(get_turf(src), 'sound/misc/bamf.ogg', 50, TRUE)

	START_PROCESSING(SSobj, src)

	var/datum/effect_system/spark_spread/sparks = new
	sparks.set_up(3, 0, get_turf(src))
	sparks.start()

	animate(src, alpha = 255, time = 1 SECONDS)
	animate(src, alpha = 50, time = duration - 1 SECONDS)

/obj/effect/temp_visual/minotaur_fury_zone/Destroy()
	STOP_PROCESSING(SSobj, src)
	return ..()

/obj/effect/temp_visual/minotaur_fury_zone/process()
	if(!active)
		return

	for(var/mob/living/L in get_turf(src))
		if(L.faction.Find("caves"))
			continue

		L.adjustFireLoss(damage_per_tick)

		if(!warned && prob(50))
			to_chat(L, "<span class='danger'>The flames sear your flesh!</span>")
			warned = TRUE

		if(knockdown_time > 0 && prob(20))
			L.Knockdown(knockdown_time)

/obj/effect/temp_visual/minotaur_fury_zone/strong
	name = "raging inferno"
	desc = "A violent eruption of magical flames!"
	icon_state = "fire"
	light_outer_range = 3
	light_color = "#FF3300"
	duration = 5 SECONDS
	damage_per_tick = 8
	knockdown_time = 1 SECONDS

/obj/effect/temp_visual/minotaur_fury_zone/strong/Initialize(mapload)
	. = ..()
	transform = matrix() * 1.5
