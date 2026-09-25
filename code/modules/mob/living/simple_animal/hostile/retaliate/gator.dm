/mob/living/simple_animal/hostile/retaliate/gator
	name = "gator"
	desc = "Vicious and patient creachers; tales have been told of passersby being grabbed and dragged underwater, never to be seen again."
	icon = 'icons/mob/gator.dmi'
	icon_state = "gator"
	icon_living = "gator"
	icon_dead = "gator-dead"
	SET_BASE_PIXEL(-32, 1)

	move_to_delay = 12
	vision_range = 5
	aggro_vision_range = 5

	// One of these daes, they'll drop Gator leather
	botched_butcher_results = list(/obj/item/reagent_containers/food/snacks/meat/mince/beef = 1)
	butcher_results = list(/obj/item/reagent_containers/food/snacks/meat/mince/beef = 1,
						/obj/item/alch/bone = 2)
	perfect_butcher_results = list(/obj/item/reagent_containers/food/snacks/meat/steak = 1,
						/obj/item/alch/sinew = 1,
						/obj/item/alch/bone = 4)

	health = 220
	maxHealth = 220
	food_type = list(/obj/item/bodypart,
					/obj/item/organ,
					/obj/item/reagent_containers/food/snacks/meat)
	tame_chance = 100

	base_intents = list(/datum/intent/simple/bigbite)
	attack_sound = list('sound/vo/mobs/gator/gatorattack1.ogg', 'sound/vo/mobs/gator/gatorattack2.ogg')
	melee_damage_lower = 25
	melee_damage_upper = 37

	base_constitution = 10
	base_strength = 16
	base_speed = 2
	base_endurance = 20

	retreat_distance = 0
	minimum_distance = 0
	deaggroprob = 0
	defprob = 35
	defdrain = 5
	retreat_health = 0.2

	stat_attack = UNCONSCIOUS
	body_eater = TRUE
	can_buckle = TRUE

	ai_controller = /datum/ai_controller/gator
	dendor_taming_chance = DENDOR_TAME_PROB_HIGH


	var/static/list/pet_commands = list(
		/datum/pet_command/idle,
		/datum/pet_command/free,
		/datum/pet_command/good_boy,
		/datum/pet_command/follow,
		/datum/pet_command/attack,
		/datum/pet_command/fetch,
		/datum/pet_command/play_dead,
		/datum/pet_command/protect_owner,
		/datum/pet_command/aggressive,
		/datum/pet_command/calm,
	)

/mob/living/simple_animal/hostile/retaliate/gator/Initialize()
	AddComponent(/datum/component/obeys_commands, pet_commands) // here due to signal overridings from pet commands
	. = ..()
	gender = MALE
	if(prob(33))
		gender = FEMALE
	update_appearance(UPDATE_OVERLAYS)
	add_traits(list(TRAIT_NODROWN, TRAIT_SWIMMER), INNATE_TRAIT)

/mob/living/simple_animal/hostile/retaliate/gator/tamed(mob/user)
	. = ..()
	if(.) // was already tamed
		return
	if(can_buckle)
		AddElement(/datum/element/ridable, /datum/component/riding/creature/gator)

/mob/living/simple_animal/hostile/retaliate/gator/death(gibbed)
	..()
	update_appearance(UPDATE_OVERLAYS)

/mob/living/simple_animal/hostile/retaliate/gator/update_overlays()
	. = ..()
	if(stat == DEAD)
		return
	. += emissive_appearance(icon, "gator-eyes")

/mob/living/simple_animal/hostile/retaliate/gator/get_sound(input)
	switch(input)
		if("aggro")
			return pick('sound/vo/mobs/gator/gatoraggro1.ogg','sound/vo/mobs/gator/gatoraggro2.ogg','sound/vo/mobs/gator/gatoraggro3.ogg','sound/vo/mobs/gator/gatoraggro4.ogg')
		if("pain")
			return pick('sound/vo/mobs/gator/gatorpain.ogg')
		if("death")
			return pick('sound/vo/mobs/gator/gatordeath.ogg')
		if("idle")
			return pick('sound/vo/mobs/gator/gatoridle1.ogg')

/mob/living/simple_animal/hostile/retaliate/gator/simple_limb_hit(zone)
	switch(zone)
		if(BODY_ZONE_PRECISE_NOSE)
			return "snout"
	return ..()

/mob/living/simple_animal/hostile/retaliate/gator/corpse_gator
	name = "Fog Gator"
	desc = "Motes of Zizite magicks flit through the air around this massive reptile. An ordinary beast no longer, Daftmarsh folklore recounts its tendency to drag the living under the depths, so that they may return in sodden undeath."

	move_to_delay = 8
	vision_range = 9
	aggro_vision_range = 9

	botched_butcher_results = list(/obj/item/reagent_containers/food/snacks/meat/mince/beef = 2,
								/obj/item/reagent_containers/food/snacks/rotten/meat = 5)
	butcher_results = list(/obj/item/reagent_containers/food/snacks/meat/mince/beef = 3,
						/obj/item/reagent_containers/food/snacks/rotten/meat = 7,
						/obj/item/natural/voidstone = 1,
						/obj/item/alch/bone = 6)
	perfect_butcher_results = list(/obj/item/reagent_containers/food/snacks/meat/steak = 2,
						/obj/item/reagent_containers/food/snacks/rotten/meat = 9,
						/obj/item/alch/sinew = 3,
						/obj/item/natural/voidstone = 2,
						/obj/item/alch/bone = 9)
	head_butcher = /obj/item/natural/head/corpse_gator

	health = 2102
	maxHealth = 2102
	tame_chance = 1 //So you're saying there's a chance?

	mob_biotypes = MOB_ORGANIC|MOB_UNDEAD
	base_intents = list(/datum/intent/simple/bigbite)
	attack_sound = list('sound/vo/mobs/gator/gatorattack1.ogg', 'sound/vo/mobs/gator/gatorattack2.ogg')
	melee_damage_lower = 26
	melee_damage_upper = 48

	base_strength = 18
	base_perception = 12
	base_intelligence = 7 //oh no
	base_constitution = 15
	base_endurance = 20
	base_speed = 13
	base_fortune = 9

	defprob = 40
	defdrain = 10
	retreat_health = 0

	minbodytemp = 0

	can_buckle = FALSE
	footstep_type = FOOTSTEP_MOB_HEAVY
	faction = list(FACTION_UNDEAD)

	ai_controller = /datum/ai_controller/gator/corpse_gator
	dendor_taming_chance = DENDOR_TAME_PROB_NONE

/mob/living/simple_animal/hostile/retaliate/gator/corpse_gator/Initialize()
	. = ..()
	ADD_TRAIT(src, TRAIT_NOBREATH, TRAIT_GENERIC)
	ADD_TRAIT(src, TRAIT_TOXIMMUNE, TRAIT_GENERIC)

/mob/living/simple_animal/hostile/retaliate/corpse_gator/proc/TailSwipe(mob/victim)
	var/mob/living/target = victim
	src.visible_message(span_notice("[src] slams [target] with it's tail, knocking them to the floor!"))
	target.Paralyze(2)
	target.apply_damage(20, BRUTE)
	shake_camera(target, 2, 1)
