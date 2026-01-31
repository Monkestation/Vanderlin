/datum/component/riding/direbear/Initialize()
	. = ..()
	set_riding_offsets(RIDING_OFFSET_ALL, list(TEXT_NORTH = list(16, 14), TEXT_SOUTH = list(12, 8), TEXT_EAST = list(7, 12), TEXT_WEST = list(14, 12)))
	set_vehicle_dir_layer(SOUTH, OBJ_LAYER)
	set_vehicle_dir_layer(NORTH, OBJ_LAYER)
	set_vehicle_dir_layer(EAST, OBJ_LAYER)
	set_vehicle_dir_layer(WEST, OBJ_LAYER)

/datum/status_effect/debuff/staggered
	id = "staggered"
	alert_type = /atom/movable/screen/alert/status_effect/debuff/staggered
	effectedstats = list(STATKEY_PER = -2, STATKEY_SPD = -2, STATKEY_CON = -2)
	duration = 10 SECONDS

/atom/movable/screen/alert/status_effect/debuff/staggered
	name = "Staggered"
	desc = "You've been smacked by something big. The force of impact has left you staggered."
	icon_state = "dazed"

/datum/status_effect/debuff/staggered/on_apply()
		. = ..()
		var/mob/living/carbon/C = owner
		C.add_movespeed_modifier(MOVESPEED_ID_DAMAGE_SLOWDOWN, multiplicative_slowdown = 1.5)

/datum/status_effect/debuff/staggered/on_remove()
	. = ..()
	if(iscarbon(owner))
		var/mob/living/carbon/C = owner
		C.remove_movespeed_modifier(MOVESPEED_ID_DAMAGE_SLOWDOWN)

/datum/action/cooldown/mob_cooldown/bear_swipe
	name = "bear swipe"
	button_icon = 'icons/effects/effects.dmi'
	button_icon_state = "explosion"
	desc = "Swipes at someone with a huge paw"
	cooldown_time = 10 SECONDS
	var/cast_time = 1 SECONDS
	var/def_zone = BODY_ZONE_CHEST
	var/range = 2
	var/swipe_damage = 40

/datum/action/cooldown/mob_cooldown/bear_swipe/Activate(atom/target)
	var/dist = get_dist(owner, target)
	if(can_see(owner, target, range) && dist < range && dist <= 1) //can see, in range and adjacent
		owner.visible_message(span_boldwarning("[owner] rears up to swipe at [target]!"))
		addtimer(CALLBACK(src, PROC_REF(do_swipe), target), cast_time)
		StartCooldown()
	return TRUE

/datum/action/cooldown/mob_cooldown/bear_swipe/proc/do_swipe(atom/target, mob/living/L)
	var/dist = get_dist(owner, target)
	if(can_see(owner, target, range) && dist < range && dist <= 1)
		playsound(owner, 'sound/combat/shieldraise.ogg', 100)
		if(ismob(target))
			var/mob/living/victim = target
			def_zone = pick(BODY_ZONE_L_LEG, BODY_ZONE_R_LEG, BODY_ZONE_CHEST, BODY_ZONE_HEAD, BODY_ZONE_L_ARM, BODY_ZONE_R_ARM)
			victim.apply_damage(swipe_damage, BRUTE, def_zone, victim.run_armor_check(def_zone, "stab", damage = swipe_damage))
			victim.apply_status_effect(/datum/status_effect/debuff/staggered)
			var/turf/target_turf = get_turf(target)
			new /obj/effect/temp_visual/paw_swipe(target_turf)
			to_chat(target, span_userdanger("You're hit by a powerful swipe!"))
			playsound(target, 'sound/combat/hits/punch/punch (1).ogg', 100, TRUE)
	else
		owner.visible_message(span_alert("[owner] roars in frustration as you distance yourself from its swipe."))
	return

/obj/effect/temp_visual/paw_swipe
	icon = 'icons/effects/effects.dmi'
	icon_state = "claw"
	name = "bear paw"
	desc = "It's huge!"
	layer = FLY_LAYER
	plane = GAME_PLANE_UPPER
	randomdir = FALSE

/mob/living/simple_animal/hostile/retaliate/direbear	//This way don't need new unqiue AI controller. Wolves are modular anyway.
	icon = 'icons/roguetown/mob/monster/direbear.dmi'
	name = "direbear"
	icon_state = "direbear"
	icon_living = "direbear"
	icon_dead = "direbear_dead"
	pixel_x = -16
	ambushable = FALSE
	base_intents = list(/datum/intent/simple/bite/bear)
	botched_butcher_results = list(/obj/item/reagent_containers/food/snacks/meat/steak = 1,
									/obj/item/natural/hide = 1,
									/obj/item/natural/fur/direbear = 1)
	butcher_results = list(/obj/item/reagent_containers/food/snacks/meat/steak = 2,
									/obj/item/natural/hide = 2,
									/obj/item/natural/fur/direbear = 1,
									/obj/item/alch/sinew = 2,
									/obj/item/alch/bone = 1,
									/obj/item/alch/viscera = 2)
	perfect_butcher_results = list(/obj/item/reagent_containers/food/snacks/meat/steak = 3,
									/obj/item/natural/hide = 3,
									/obj/item/natural/fur/direbear = 2,
									/obj/item/alch/sinew = 2,
									/obj/item/alch/bone = 1,
									/obj/item/alch/viscera = 2,
									/obj/item/natural/head/direbear = 1)
	faction = list("bears")		//This mf will kill undead - swapped to its own faction, doesn't trigger ambushes
	mob_biotypes = MOB_ORGANIC|MOB_BEAST
	melee_damage_lower = 50		// Ey, bo-bo!
	melee_damage_upper = 60		// We're gonna take his pick-in-ick basket!
	vision_range = 6
	aggro_vision_range = 8
	environment_smash = ENVIRONMENT_SMASH_STRUCTURES // silly furniture won't stop our boy
	footstep_type = FOOTSTEP_MOB_BAREFOOT
	pooptype = null
	health = 500	//volf is 120, saigabuck is 400
	maxHealth = 500
	food_type = list(/obj/item/reagent_containers/food/snacks,
				/obj/item/bodypart, 	//Woe be upon ye
				/obj/item/organ, 		//Woe be upon ye
				/obj/effect/decal/remains,
				)
	base_constitution = 12
	base_strength= 13
	base_speed = 9
	simple_detect_bonus = 40	//No sneaking by our boy..
	deaggroprob = 0
	defprob = 40
	del_on_deaggro = FALSE //we dont despawn, our boy chills
	remains_type = /obj/effect/decal/remains/bear
	attack_sound = list('sound/vo/mobs/direbear/direbear_attack1.wav','sound/vo/mobs/direbear/direbear_attack2.wav','sound/vo/mobs/direbear/direbear_attack3.wav')
	dodgetime = 30
	aggressive = 1
	stat_attack = UNCONSCIOUS	//You falling unconcious won't save you, little one..
	ai_controller = /datum/ai_controller/direbear
	can_buckle = TRUE

/mob/living/simple_animal/hostile/retaliate/direbear/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/ai_aggro_system)

/mob/living/simple_animal/hostile/retaliate/direbear/tamed(mob/user)
	. = ..()
	if(can_buckle)
		AddComponent(/datum/component/riding/direbear)

/mob/living/simple_animal/hostile/retaliate/direbear/get_sound(input)
	switch(input)
		if("aggro")
			return pick('sound/vo/mobs/direbear/direbear_attack1.wav')	//Placeholder till we get more sounds
		if("pain")
			return pick('sound/vo/mobs/direbear/direbear_death1.wav')	//Placeholder till we get more sounds
		if("death")
			return pick('sound/vo/mobs/direbear/direbear_death1.wav', 'sound/vo/mobs/direbear/direbear_death2.wav')

/obj/effect/decal/remains/bear
	name = "remains"
	gender = PLURAL
	icon_state = "bones"
	icon = 'icons/roguetown/mob/monster/direbear.dmi'

/datum/intent/simple/bite/bear
	clickcd = (CLICK_CD_MELEE * 1.2)	//Slightly slower than wolfs by .1

/mob/living/simple_animal/hostile/retaliate/direbear/Initialize(mapload)
	. = ..()
	var/datum/action/cooldown/mob_cooldown/bear_swipe/swipe = new(src)
	swipe.Grant(src)
	ai_controller.set_blackboard_key(BB_TARGETED_ACTION, swipe)
