/mob/living/simple_animal/hostile/retaliate/lampreywolf
	icon = 'icons/roguetown/mob/monster/lamprey_volf.dmi'
	name = "luperey" // lupe like dog
	desc = ""
	icon_state = "lampreyvolf1"
	icon_living = "lampreyvolf1"
	icon_dead = "lampreyvolf1_dead"
	SET_BASE_PIXEL(-4, 0)

	faction = list(FACTION_SEA)
	emote_hear = null
	emote_see = null
	see_in_dark = 9
	move_to_delay = 2
	vision_range = 9
	aggro_vision_range = 9

	botched_butcher_results = list(/obj/item/reagent_containers/food/snacks/meat/steak = 1,
						/obj/item/alch/bone = 1)
	butcher_results = list(/obj/item/reagent_containers/food/snacks/meat/steak = 2,
						/obj/item/natural/hide = 1,
						/obj/item/alch/sinew = 2,
						/obj/item/alch/bone = 1)
	perfect_butcher_results = list(/obj/item/reagent_containers/food/snacks/meat/steak = 2,
						/obj/item/natural/hide = 2,
						/obj/item/alch/sinew = 2,
						/obj/item/alch/bone = 2)
	head_butcher = /obj/item/natural/head/volf

	health = 110
	maxHealth = 110
	gender = MALE
	var/is_pack_alpha = FALSE
	animal_species = /mob/living/simple_animal/hostile/retaliate/lampreywolf/alpha
	footstep_type = FOOTSTEP_MOB_SLIME

	food_type = list(/obj/item/reagent_containers/food/snacks/blood_dough)
	food_max = BLOOD_VOLUME_SURVIVE * 1.5 // these guys can't drink nearly as much blood on their own as a single dire leech

	base_intents = list(/datum/intent/simple/bite/lampreywolf)
	possible_rmb_intents = list(/datum/rmb_intent/simple/blood_leech)
	attack_sound = list('sound/vo/mobs/vw/attack (1).ogg','sound/vo/mobs/vw/attack (2).ogg','sound/vo/mobs/vw/attack (3).ogg','sound/vo/mobs/vw/attack (4).ogg')

	// pack tactics, steal blood and get out of there
	melee_damage_lower = 5
	melee_damage_upper = 10
	melee_attack_cooldown = 2 SECONDS
	retreat_health = 0.3

	base_constitution = 8
	base_strength = 8
	base_speed = 12

	simple_detect_bonus = 20
	deaggroprob = 0
	defprob = 35
	defdrain = 5
	del_on_deaggro = 999 SECONDS

	//these change when tamed
	can_buckle = FALSE
	buckle_lying = FALSE
	can_saddle = FALSE

	dodgetime = 17
	aggressive = 1
	stat_attack = UNCONSCIOUS

	ai_controller = /datum/ai_controller/lampreywolf
	var/static/list/pet_commands = list(
		/datum/pet_command/fish,
		/datum/pet_command/idle,
		/datum/pet_command/free,
		/datum/pet_command/good_boy,
		/datum/pet_command/follow,
		/datum/pet_command/attack/leech_blood,
		/datum/pet_command/attack/give_blood,
		/datum/pet_command/attack,
		/datum/pet_command/fetch,
		/datum/pet_command/protect_owner,
		/datum/pet_command/aggressive,
		/datum/pet_command/calm,
	)

/mob/living/simple_animal/hostile/retaliate/lampreywolf/Initialize()
	AddComponent(/datum/component/obeys_commands, pet_commands) // here due to signal overridings from pet commands // due to signal overridings from pet commands
	. = ..()
	RegisterSignal(src, COMSIG_HOSTILE_PRE_ATTACKINGTARGET, PROC_REF(on_pre_attack))
	AddComponent(/datum/component/ai_aggro_system)
	AddElement(/datum/element/ai_flee_while_injured, 0.75, retreat_health)
	AddElement(/datum/element/ai_retaliate)

	var/datum/component/generic_mob_hunger/hunger = GetComponent(/datum/component/generic_mob_hunger)
	if(hunger)
		hunger.hunger_drain = 4
		if(!tame)
			SEND_SIGNAL(src, COMSIG_MOB_DRAIN_HUNGER, -50) // start hungrier


	ADD_TRAIT(src, TRAIT_GOOD_SWIM, ROUNDSTART_TRAIT)
	if(is_pack_alpha)
		ADD_TRAIT(src, TRAIT_IGNOREDAMAGESLOWDOWN, ROUNDSTART_TRAIT)
	else
		if(prob(50))
			gender = FEMALE
			icon_living = "lampreyvolf2"
			icon_state = icon_living

	update_appearance(UPDATE_OVERLAYS)

/mob/living/simple_animal/hostile/retaliate/lampreywolf/Destroy()
	UnregisterSignal(src, COMSIG_HOSTILE_PRE_ATTACKINGTARGET)
	return ..()

//do our rmb intent out of combat. Scuffed? Absolutely. Alternatives? A pain in the ass.
/mob/living/simple_animal/hostile/retaliate/lampreywolf/proc/on_pre_attack(datum/source, atom/target)
	if(!cmode && rmb_intent)
		rmb_intent.special_attack(src, target)
		return COMPONENT_HOSTILE_NO_PREATTACK

/mob/living/simple_animal/hostile/retaliate/lampreywolf/AttackingTarget(mob/living/passed_target)
	. = ..()
	var/mob/living/L = target
	if(. && istype(target) && L.blood_volume > 0 && SEND_SIGNAL(src, COMSIG_MOB_RETURN_HUNGER) < 100)
		var/blood_taken = drinksomeblood(L, L.get_bodypart(zone_selected), 50, FALSE)
		if(iscarbon(target))
			var/mob/living/carbon/C = target
			if(C.dna?.species && (NOBLOOD in C.dna.species.species_traits))
				return
			drinksomeblood(C, zone_selected)
		else
			L.blood_volume -= blood_taken
			L.handle_blood()
			playsound(loc, 'sound/misc/drink_blood.ogg', 100, FALSE, -4)
		SEND_SIGNAL(src, COMSIG_MOB_ADJUST_HUNGER, blood_taken) // chance of minor overflow but it's negligible

/mob/living/simple_animal/hostile/retaliate/lampreywolf/death(gibbed)
	..()
	update_appearance(UPDATE_OVERLAYS)

/mob/living/simple_animal/hostile/retaliate/lampreywolf/update_overlays()
	. = ..()
	if(stat == DEAD)
		return
	if(ssaddle)
		var/mutable_appearance/saddlet = mutable_appearance(icon, "lampreyvolf_saddle_above", 4.3)
		. += saddlet
		saddlet = mutable_appearance(icon, "lampreyvolf_saddle")
		. += saddlet
	if(has_buckled_mobs())
		var/mutable_appearance/mounted = mutable_appearance(icon, "[icon_living]_mounted", 4.3)
		. += mounted

/mob/living/simple_animal/hostile/retaliate/lampreywolf/tamed(mob/user)
	. = ..()
	deaggroprob = 30
	can_buckle = TRUE
	can_saddle = TRUE
	AddComponent(/datum/component/riding/lampreywolf)

/mob/living/simple_animal/hostile/retaliate/lampreywolf/get_sound(input)
	switch(input)
		if("aggro")
			return pick('sound/vo/mobs/vw/aggro (1).ogg','sound/vo/mobs/vw/aggro (2).ogg')
		if("pain")
			return pick('sound/vo/mobs/vw/pain (1).ogg','sound/vo/mobs/vw/pain (2).ogg','sound/vo/mobs/vw/pain (3).ogg')
		if("death")
			return pick('sound/vo/mobs/vw/death (1).ogg','sound/vo/mobs/vw/death (2).ogg','sound/vo/mobs/vw/death (3).ogg','sound/vo/mobs/vw/death (4).ogg','sound/vo/mobs/vw/death (5).ogg')
		if("idle")
			return pick('sound/vo/mobs/vw/idle (1).ogg','sound/vo/mobs/vw/idle (2).ogg','sound/vo/mobs/vw/idle (3).ogg','sound/vo/mobs/vw/idle (4).ogg')
		if("cidle")
			return pick('sound/vo/mobs/vw/bark (1).ogg','sound/vo/mobs/vw/bark (2).ogg','sound/vo/mobs/vw/bark (3).ogg','sound/vo/mobs/vw/bark (4).ogg','sound/vo/mobs/vw/bark (5).ogg','sound/vo/mobs/vw/bark (6).ogg','sound/vo/mobs/vw/bark (7).ogg')

/mob/living/simple_animal/hostile/retaliate/lampreywolf/taunted(mob/user)
	emote("aggro")
	return

/mob/living/simple_animal/hostile/retaliate/lampreywolf/simple_limb_hit(zone)
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


/mob/living/simple_animal/hostile/retaliate/lampreywolf/alpha
	name = "alpha luperey"
	desc = ""
	icon_state = "lampreyvolf3"
	icon_living = "lampreyvolf3"
	icon_dead = "lampreyvolf3_dead"

	is_pack_alpha = TRUE

	melee_damage_lower = 10
	melee_damage_upper = 20
	retreat_distance = 3
	retreat_health = 0.2

	defprob = 50

	health = 125
	maxHealth = 125
	food_max = BLOOD_VOLUME_BAD

	base_constitution = 10
	base_strength = 10
	base_speed = 14


/mob/living/simple_animal/hostile/retaliate/lampreywolf/tame
	tame = TRUE

/mob/living/simple_animal/hostile/retaliate/lampreywolf/tame/saddled/Initialize()
	. = ..()
	var/obj/item/natural/saddle/S = new(src)
	ssaddle = S
	update_appearance(UPDATE_OVERLAYS)

/mob/living/simple_animal/hostile/retaliate/lampreywolf/alpha/tame
	tame = TRUE

/mob/living/simple_animal/hostile/retaliate/lampreywolf/alpha/tame/saddled/Initialize()
	. = ..()
	var/obj/item/natural/saddle/S = new(src)
	ssaddle = S
	update_appearance(UPDATE_OVERLAYS)


/datum/intent/simple/bite/lampreywolf
	penfactor = 5
	blade_class = BCLASS_STAB
