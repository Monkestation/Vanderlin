/mob/living/simple_animal/hostile/retaliate/mirespider
	icon = 'icons/mob/mirespider_small.dmi'
	desc = "Said to have originated from the decapitated heads of fallen legionnaires from eons past, grown legs and a voracious appetite, mire crawlers are common pests in many a wetland. Occasionally hunted for their silk."
	name = "mire crawler"
	icon_state = "crawler"
	icon_living = "crawler"
	icon_dead = "crawler_dead"
	mob_biotypes = MOB_ORGANIC|MOB_BEAST
	emote_hear = null
	emote_see = null
	speak_chance = 1
	see_in_dark = 10
	move_to_delay = 3

	faction = list("zombie", "spiders")
	attack_sound = list('sound/vo/mobs/spider/attack (1).ogg','sound/vo/mobs/spider/attack (2).ogg','sound/vo/mobs/spider/attack (3).ogg','sound/vo/mobs/spider/attack (4).ogg')

	base_intents = list(/datum/intent/simple/bite/mirespider)
	botched_butcher_results = list(/obj/item/reagent_containers/food/snacks/meat/steak = 1)
	butcher_results = list(/obj/item/reagent_containers/food/snacks/meat/steak = 1,
						/obj/item/natural/hide = 1,
						/obj/item/natural/silk = 1,
						/obj/item/alch/viscera = 1)
	perfect_butcher_results = list(/obj/item/reagent_containers/food/snacks/meat/steak = 1,
						/obj/item/natural/hide = 1,
						/obj/item/natural/silk = 2,
						/obj/item/alch/viscera = 1)

	health = 80
	maxHealth = 80
	melee_damage_lower = 17
	melee_damage_upper = 26
	vision_range = 10
	aggro_vision_range = 9
	environment_smash = ENVIRONMENT_SMASH_NONE
	retreat_distance = 0
	minimum_distance = 0

	base_constitution = 7
	base_strength = 7
	base_speed = 13
	footstep_type = FOOTSTEP_MOB_BAREFOOT
	defprob = 40
	retreat_health = 0
	ai_controller = /datum/ai_controller/mirespider

/mob/living/simple_animal/hostile/retaliate/mirespider/Initialize()
	. = ..()
	update_icon()
	AddElement(/datum/element/ai_retaliate)
	AddComponent(/datum/component/ai_aggro_system)
	ADD_TRAIT(src, TRAIT_NOPAINSTUN, TRAIT_GENERIC)
	ADD_TRAIT(src, TRAIT_KNEESTINGER_IMMUNITY, INNATE_TRAIT)

	addtimer(CALLBACK(src, PROC_REF(find_lurker_to_follow)), 10)

/mob/living/simple_animal/hostile/retaliate/mirespider/proc/find_lurker_to_follow()
	var/mob/living/simple_animal/hostile/mirespider_lurker/lurker = null
	for(var/mob/living/simple_animal/hostile/mirespider_lurker/L in view(10, src))
	{
		lurker = L
		break
	}

	if(lurker && ai_controller)
		ai_controller.set_blackboard_key(BB_FOLLOW_TARGET, lurker)

/mob/living/simple_animal/hostile/retaliate/mirespider/death(gibbed)
	..()
	update_icon()

/datum/intent/simple/bite/mirespider
	clickcd = CLICK_CD_MELEE * 1.1

/mob/living/simple_animal/hostile/retaliate/mirespider/get_sound(input)
	switch(input)
		if("aggro")
			return pick('sound/vo/mobs/spider/aggro (1).ogg','sound/vo/mobs/spider/aggro (2).ogg','sound/vo/mobs/spider/aggro (3).ogg')
		if("pain")
			return pick('sound/vo/mobs/spider/pain.ogg')
		if("death")
			return pick('sound/vo/mobs/spider/death.ogg')
		if("idle")
			return pick('sound/vo/mobs/spider/idle (1).ogg','sound/vo/mobs/spider/idle (2).ogg','sound/vo/mobs/spider/idle (3).ogg','sound/vo/mobs/spider/idle (4).ogg')

/mob/living/simple_animal/hostile/retaliate/mirespider/taunted(mob/user)
	emote("aggro")
	return

/mob/living/simple_animal/hostile/retaliate/mirespider/simple_limb_hit(zone)
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

/mob/living/simple_animal/hostile/mirespider_lurker
	icon = 'icons/mob/mirespider_big.dmi'
	desc = "An unusually large and dangerous mire crawler, these lumbering creatures tend to find smaller specimens gravitating to them for safety - or perhaps simply to hunt more efficiently."
	name = "mire lurker"
	icon_state = "lurker"
	icon_living = "lurker"
	icon_dead = "lurker_dead"

	faction = list("zombie", "spiders")
	attack_sound = list('sound/vo/mobs/spider/attack (1).ogg','sound/vo/mobs/spider/attack (2).ogg','sound/vo/mobs/spider/attack (3).ogg','sound/vo/mobs/spider/attack (4).ogg')

	base_intents = list(/datum/intent/simple/bite/mirespider_lurker)
	botched_butcher_results = list(/obj/item/reagent_containers/food/snacks/meat/steak = 2,
						/obj/item/natural/hide = 2,
						/obj/item/natural/silk = 1,
						/obj/item/alch/viscera = 1)
	butcher_results = list(/obj/item/reagent_containers/food/snacks/meat/steak = 4,
						/obj/item/natural/hide = 3,
						/obj/item/natural/silk = 3,
						/obj/item/alch/viscera = 4)
	perfect_butcher_results = list(/obj/item/reagent_containers/food/snacks/meat/steak = 4,
						/obj/item/natural/hide = 4,
						/obj/item/natural/silk = 5, // You killed the mire lurker. You get all the figgy pudding . . .
						/obj/item/alch/viscera = 4)

	health = 200
	maxHealth = 200
	melee_damage_lower = 35
	melee_damage_upper = 70

	base_constitution = 9
	base_strength = 9
	base_speed = 14
	// These things will crit. Slow attacks, devestating consequences.
	base_perception = 15
	pixel_x = -4

	ai_controller = /datum/ai_controller/mirespider_lurker
	projectiletype = /obj/projectile/bullet/spider

	ranged = 1
	minimum_distance = 1
	ranged_cooldown_time = 100
	var/list/mob/living/simple_animal/hostile/retaliate/mirespider/followers = list()

/mob/living/simple_animal/hostile/mirespider_lurker/mushroom
	icon = 'icons/mob/mirespider_shroom.dmi'
	desc = "While recognizable as a mire lurker, this specimen appears to suffer a gigantic \
	fungal growth over its rear end. It reeks of the smell of mold, and tar-like secretions \
	drip from its mandibles. Something here is horribly wrong."
	name = "mire lurker?"
	icon_state = "mushroom"
	icon_living = "mushroom"
	icon_dead = "mushroom_dead"
	health = 400
	maxHealth = 400
	pixel_x = -8

	projectiletype = /obj/projectile/bullet/spider_shroom
	botched_butcher_results = list(/obj/item/reagent_containers/food/snacks/meat/steak = 2,
						/obj/item/natural/hide = 2,
						/obj/item/natural/silk = 1,
						/obj/item/reagent_containers/powder/ozium = 1,
						/obj/item/alch/viscera = 1)
	butcher_results = list(/obj/item/reagent_containers/food/snacks/meat/steak = 4,
						/obj/item/natural/hide = 3,
						/obj/item/natural/silk = 3,
						/obj/item/reagent_containers/powder/ozium = 2,
						/obj/item/alch/viscera = 4)
	perfect_butcher_results = list(/obj/item/reagent_containers/food/snacks/meat/steak = 4,
						/obj/item/natural/hide = 4,
						/obj/item/natural/silk = 5, // You killed the mire lurker. You get all the figgy pudding . . .
						/obj/item/reagent_containers/powder/ozium = 2,
						/obj/item/reagent_containers/powder/moondust = 1,
						/obj/item/alch/viscera = 4)

/mob/living/simple_animal/hostile/mirespider_lurker/Initialize()
	. = ..()
	ADD_TRAIT(src, TRAIT_NOPAINSTUN, TRAIT_GENERIC)
	ADD_TRAIT(src, TRAIT_KNEESTINGER_IMMUNITY, INNATE_TRAIT)
	AddComponent(/datum/component/ai_aggro_system)
	// I'll replace this with something better later. Stopgap for now to make killing them more than just a nuisance.

/mob/living/simple_animal/hostile/mirespider_lurker/death(gibbed)
	..()
	if(prob(40))
		new /obj/item/reagent_containers/food/snacks/spiderhoney(loc)
	if(prob(10))
		new /obj/item/gem/violet(loc)
	update_icon()

/datum/intent/simple/bite/mirespider_lurker
	clickcd = CLICK_CD_MELEE * 1.1

/mob/living/simple_animal/hostile/mirespider_lurker/proc/add_follower(mob/living/simple_animal/hostile/retaliate/mirespider)
	if (!(mirespider in followers))
		followers += mirespider

/mob/living/simple_animal/hostile/mirespider_lurker/proc/clear_followers_if_any()
	if (!followers || !length(followers))
		return

	for (var/mob/living/simple_animal/hostile/retaliate/mirespider/follower in followers)
		follower.ai_controller.clear_blackboard_key(BB_FOLLOW_TARGET)
		follower.ai_controller.clear_blackboard_key(BB_TRAVEL_DESTINATION)
		follower.ai_controller.clear_blackboard_key(BB_BASIC_MOB_CURRENT_TARGET)
		follower.ai_controller.clear_blackboard_key(BB_BASIC_MOB_RETALIATE_LIST)
		follower.ai_controller.CancelActions()
	followers.Cut()

/mob/living/simple_animal/hostile/mirespider_paralytic
	icon = 'icons/mob/mirespider_small.dmi'
	name = "aragn"
	desc = "A gigantic species of spider accompanied always by a strong sulphuric stench. Its fangs carry \
	a dangerous paralytic; a danger for the common traveller, and an opportunity to any aspiring poisoner."
	icon_state = "aragn"
	icon_living = "aragn"
	icon_dead = "aragn_dead"

	faction = list("zombie", "spiders")
	attack_sound = list('sound/vo/mobs/spider/attack (1).ogg','sound/vo/mobs/spider/attack (2).ogg','sound/vo/mobs/spider/attack (3).ogg','sound/vo/mobs/spider/attack (4).ogg')

	base_intents = list(/datum/intent/simple/bite/mirespider_paralytic)
	botched_butcher_results = list(/obj/item/reagent_containers/food/snacks/meat/steak = 1,
						/obj/item/natural/silk = 1,
						/obj/item/alch/viscera = 1)
	butcher_results = list(/obj/item/reagent_containers/food/snacks/meat/steak = 2,
						/obj/item/natural/hide = 1,
						/obj/item/natural/silk = 1,
						/obj/item/alch/viscera = 1,
						/obj/item/reagent_containers/spidervenom_inert = 1)
	perfect_butcher_results = list(/obj/item/reagent_containers/food/snacks/meat/steak = 2,
						/obj/item/natural/hide = 1,
						/obj/item/natural/silk = 1,
						/obj/item/alch/viscera = 1,
						/obj/item/reagent_containers/spidervenom_inert = 2)

	health = 140
	maxHealth = 140
	melee_damage_lower = 21
	melee_damage_upper = 42

	base_constitution = 9
	base_strength = 9
	base_speed = 12
	base_perception = 7

	ai_controller = /datum/ai_controller/mirespider_paralytic

/mob/living/simple_animal/hostile/mirespider_paralytic/Initialize()
	. = ..()
	AddComponent(/datum/component/ai_aggro_system)

/datum/intent/simple/bite/mirespider_paralytic
	clickcd = CLICK_CD_MELEE * 1.1

/mob/living/simple_animal/hostile/mirespider_paralytic/AttackingTarget()
	. = ..()
	if(. && isliving(target))
		var/mob/living/L = target
		if(L.reagents && prob(50))
			L.reagents.add_reagent(/datum/reagent/toxin/spidervenom_paralytic, 5)

/obj/random/spider
	icon = 'icons/mob/mirespider_small.dmi'
	name = "random spider spawner"
	desc = "YOU SHOULD NOT BE SEEING THIS, GO YELL AT KETRAI."
	icon_state = "crawler"

/obj/random/spider/Initialize()
	. = ..()
	spawn_random_spider_at(loc)
	qdel(src)

/obj/random/spider/proc/spawn_random_spider_at(turf/T)
	var/newspider = list(/mob/living/simple_animal/hostile/mirespider_paralytic = 10, /mob/living/simple_animal/hostile/retaliate/mirespider = 90)
	var/spider_to_spawn = pickweight(newspider)
	new spider_to_spawn(get_turf(src))
	qdel(src)

/mob/living/simple_animal/hostile/retaliate/mirespider/angry
	faction = list("mad", "zombie")

/mob/living/simple_animal/hostile/mirespider_paralytic/angry
	faction = list("mad", "zombie")

/mob/living/simple_animal/hostile/mirespider_lurker/angry
	faction = list("mad", "zombie")

/obj/projectile/bullet/spider
	name = "web glob"
	damage = 10
	damage_type = BRUTE
	icon = 'icons/obj/webbing.dmi'
	icon_state = "webglob"
	range = 15
	hitsound = 'sound/combat/hits/hi_arrow2.ogg'
	embedchance = 0
	//Will not cause wounds.
	woundclass = null
	flag = "piercing"
	speed = 2 // I guess slower to be slightly more forgiving to players since they're otherwise aimbots

/obj/projectile/bullet/spider_shroom
	name = "web glob"
	damage = 10
	damage_type = BRUTE
	icon = 'icons/obj/webbing.dmi'
	icon_state = "webglob"
	range = 15
	hitsound = 'sound/combat/hits/hi_arrow2.ogg'
	embedchance = 0
	//Will not cause wounds.
	woundclass = null
	flag = "piercing"
	speed = 2

/obj/projectile/bullet/spider/on_hit(target)
	. = ..()
	if(ismob(target))
		var/mob/living/M = target
		//M.apply_status_effect(/datum/status_effect/debuff/vulnerable)
		M.Immobilize(15)
	var/turf/T
	if(isturf(target))
		T = target
	else
		T = get_turf(target)
	var/web = locate(/obj/structure/spider/stickyweb/mirespider) in T.contents
	if(!(web in T.contents))
		new /obj/structure/spider/stickyweb/mirespider(T)

/obj/projectile/bullet/spider_shroom/on_hit(target)
	. = ..()
	if(ismob(target))
		var/mob/living/M = target
		//M.apply_status_effect(/datum/status_effect/debuff/vulnerable)
		M.apply_status_effect(/datum/status_effect/buff/druqks)
	var/turf/T
	if(isturf(target))
		T = target
	else
		T = get_turf(target)
	var/web = locate(/obj/structure/spider/stickyweb/mirespider) in T.contents
	if(!(web in T.contents))
		new /obj/structure/spider/stickyweb/mirespider(T)

//Mirespider webs are thinner and will not stop projectiles or obstruct movement as often.
/obj/structure/spider/stickyweb/mirespider
	opacity = 0
	pass_flags = LETPASSTHROW
	debris = null

/obj/structure/spider/stickyweb/mirespider/CanPass(atom/movable/mover, turf/target)
	. = ..()
	if(isliving(mover))
		if(prob(25) && !HAS_TRAIT(mover, TRAIT_WEBWALK))
			to_chat(mover, "<span class='danger'>I get stuck in \the [src] for a moment.</span>")
			return FALSE
	else if(istype(mover, /obj/projectile))
		return prob(85)
	return TRUE
