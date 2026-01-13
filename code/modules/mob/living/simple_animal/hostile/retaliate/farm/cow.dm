
/mob/living/simple_animal/hostile/retaliate/cow
	icon = 'icons/roguetown/mob/monster/cow.dmi'
	name = "moo-beast"
	desc = "The grail of many farmers. Commonfolk associate the motherly sow with Eora, and the raging bull with Ravox."
	icon_state = "cow"
	icon_living = "cow"
	icon_dead = "cow_dead"
	icon_gib = "cow_gib"

	animal_species = /mob/living/simple_animal/hostile/retaliate/bull
	faction = list("cows")
	gender = FEMALE
	footstep_type = FOOTSTEP_MOB_SHOE
	emote_hear = list("brays.")
	emote_see = list("shakes its head.", "chews her cud.")

	botched_butcher_results = list(/obj/item/reagent_containers/food/snacks/meat/steak = 4,
						/obj/item/natural/hide = 1,
						/obj/item/alch/sinew = 1,
						/obj/item/alch/bone = 1)
	butcher_results = list(/obj/item/reagent_containers/food/snacks/meat/steak = 6,
						/obj/item/natural/hide = 2,
						/obj/item/alch/sinew = 2,
						/obj/item/alch/bone = 1)
	perfect_butcher_results = list(/obj/item/reagent_containers/food/snacks/meat/steak = 8,
						/obj/item/natural/hide = 3,
						/obj/item/alch/sinew = 2,
						/obj/item/alch/bone = 1)

	health = FEMALE_MOOBEAST_HEALTH
	maxHealth = FEMALE_MOOBEAST_HEALTH
	food_type = list(/obj/item/reagent_containers/food/snacks/produce/grain/wheat,
					/obj/item/reagent_containers/food/snacks/produce/grain/oat,
					/obj/item/reagent_containers/food/snacks/produce/vegetable/turnip,
					/obj/item/reagent_containers/food/snacks/produce/vegetable/cabbage)
	pooptype = /obj/item/natural/poo/cow
	tame_chance = 25
	bonus_tame_chance = 15

	base_intents = list(/datum/intent/simple/headbutt)
	attack_verb_continuous = "stomps"
	attack_verb_simple = "stomps"
	melee_damage_lower = 10
	melee_damage_upper = 12
	base_speed = 4
	base_constitution = 4
	base_strength = 4
	remains_type = /obj/effect/decal/remains/cow
	happy_funtime_mob = TRUE



	ai_controller = /datum/ai_controller/basic_controller/cow
	var/can_breed = TRUE
	var/can_tip = TRUE

/mob/living/simple_animal/hostile/retaliate/cow/Initialize()
	. = ..()
	if(can_tip)
		AddComponent(/datum/component/tippable, \
			0.5 SECONDS, \
			0.5 SECONDS, \
			rand(25 SECONDS, 50 SECONDS), \
			null,\
			CALLBACK(src, PROC_REF(after_cow_tipped)),\
			CALLBACK(src, PROC_REF(after_cow_untipped)),\
		)

	if(can_breed)
		AddComponent(\
			/datum/component/breed,\
			list(/mob/living/simple_animal/hostile/retaliate/cow, /mob/living/simple_animal/hostile/retaliate/bull),\
			3 MINUTES,\
			list(/mob/living/simple_animal/hostile/retaliate/cow/cowlet = 90, /mob/living/simple_animal/hostile/retaliate/cow/cowlet/bullet = 10),\
			CALLBACK(src, PROC_REF(after_birth)),\
		)
	udder_component()

///wrapper for the udder component addition so you can have uniquely uddered cow subtypes
/mob/living/simple_animal/hostile/retaliate/cow/proc/udder_component()
	AddComponent(/datum/component/udder)

/obj/effect/decal/remains/cow
	name = "remains"
	gender = PLURAL
	icon_state = "skele"
	icon = 'icons/roguetown/mob/monster/cow.dmi'

/mob/living/simple_animal/hostile/retaliate/cow/get_sound(input)
	switch(input)
		if("aggro")
			return pick('sound/vo/mobs/cow/aggro (1).ogg','sound/vo/mobs/cow/aggro (2).ogg','sound/vo/mobs/cow/aggro (3).ogg')
		if("pain")
			return pick('sound/vo/mobs/cow/pain (1).ogg','sound/vo/mobs/cow/pain (2).ogg')
		if("death")
			return pick('sound/vo/mobs/cow/death (1).ogg','sound/vo/mobs/cow/death (2).ogg')
		if("idle")
			return pick('sound/vo/mobs/cow/idle (1).ogg','sound/vo/mobs/cow/idle (2).ogg','sound/vo/mobs/cow/idle (3).ogg','sound/vo/mobs/cow/idle (4).ogg','sound/vo/mobs/cow/idle (5).ogg')

/mob/living/simple_animal/hostile/retaliate/cow/proc/after_birth(mob/living/simple_animal/hostile/retaliate/cow/cowlet/baby, mob/living/partner)
	return

/mob/living/simple_animal/hostile/retaliate/cow/simple_limb_hit(zone)
	switch(zone)
		if(BODY_ZONE_PRECISE_NOSE, BODY_ZONE_PRECISE_MOUTH)
			return "snout"
	return ..()

/*
 * Proc called via callback after the cow is tipped by the tippable component.
 * Begins a timer for us pleading for help.
 *
 * tipper - the mob who tipped us
 */
/mob/living/simple_animal/hostile/retaliate/cow/proc/after_cow_tipped(mob/living/carbon/tipper)
	icon_state = "[initial(icon_state)]_tip"
	addtimer(CALLBACK(src, PROC_REF(set_tip_react_blackboard), tipper), rand(5 SECONDS, 8 SECONDS))

/mob/living/simple_animal/hostile/retaliate/cow/proc/after_cow_untipped(mob/living/carbon/tipper)
	icon_state = initial(icon_state)

/*
 * We've been waiting long enough, we're going to tell our AI to begin pleading.
 *
 * tipper - the mob who originally tipped us
 */
/mob/living/simple_animal/hostile/retaliate/cow/proc/set_tip_react_blackboard(mob/living/carbon/tipper)
	if(!ai_controller)
		return
	ai_controller.set_blackboard_key(BB_BASIC_MOB_TIP_REACTING, TRUE)
	ai_controller.set_blackboard_key(BB_BASIC_MOB_TIPPER, tipper)

/mob/living/simple_animal/hostile/retaliate/bull
	icon = 'icons/roguetown/mob/monster/cow.dmi'
	name = "moo-beast bull"
	desc = "Rambunctious as the war-saint himself, a depiction of the moo-beast bull looms on the standard of the Valorian city-state called Andalvia."
	icon_state = "bull"
	icon_living = "bull"
	icon_dead = "bull_dead"
	icon_gib = "bull_gib"

	faction = list("cows")
	footstep_type = FOOTSTEP_MOB_SHOE
	emote_hear = list("chews.")
	emote_see = list("shakes his head.", "chews his cud.")

	botched_butcher_results = list(/obj/item/reagent_containers/food/snacks/meat/steak = 4,
						/obj/item/alch/sinew = 1,
						/obj/item/alch/bone = 1)
	butcher_results = list(/obj/item/reagent_containers/food/snacks/meat/steak = 7,
						/obj/item/natural/hide = 3,
						/obj/item/alch/sinew = 2,
						/obj/item/alch/bone = 1)
	perfect_butcher_results = list(/obj/item/reagent_containers/food/snacks/meat/steak = 9,
						/obj/item/natural/hide = 4,
						/obj/item/alch/sinew = 2,
						/obj/item/alch/bone = 1)

	health = MALE_MOOBEAST_HEALTH
	maxHealth = MALE_MOOBEAST_HEALTH
	food_type = list(/obj/item/reagent_containers/food/snacks/produce/grain/wheat,
					/obj/item/reagent_containers/food/snacks/produce/grain/oat,
					/obj/item/reagent_containers/food/snacks/produce/vegetable/turnip,
					/obj/item/reagent_containers/food/snacks/produce/vegetable/cabbage)
	pooptype = /obj/item/natural/poo/cow

	base_intents = list(/datum/intent/simple/headbutt)
	attack_verb_continuous = "gores"
	attack_verb_simple = "gores"
	melee_damage_lower = 25
	melee_damage_upper = 45
	retreat_distance = 0
	minimum_distance = 0
	base_constitution = 20
	base_strength = 12
	base_speed = 2
	remains_type = /obj/effect/decal/remains/cow
	happy_funtime_mob = TRUE
	ai_controller = /datum/ai_controller/basic_controller/cow

/mob/living/simple_animal/hostile/retaliate/bull/Initialize()
	. = ..()

	AddComponent(\
		/datum/component/breed,\
		can_breed_with = list(/mob/living/simple_animal/hostile/retaliate/cow, /mob/living/simple_animal/hostile/retaliate/bull),\
		breed_timer = 2 MINUTES\
	)

/mob/living/simple_animal/hostile/retaliate/bull/get_sound(input)
	switch(input)
		if("aggro")
			return pick('sound/vo/mobs/cow/aggro (1).ogg','sound/vo/mobs/cow/aggro (2).ogg','sound/vo/mobs/cow/aggro (3).ogg')
		if("pain")
			return pick('sound/vo/mobs/cow/pain (1).ogg','sound/vo/mobs/cow/pain (2).ogg')
		if("death")
			return pick('sound/vo/mobs/cow/death (1).ogg','sound/vo/mobs/cow/death (2).ogg')
		if("idle")
			return pick('sound/vo/mobs/cow/idle (1).ogg','sound/vo/mobs/cow/idle (2).ogg','sound/vo/mobs/cow/idle (3).ogg','sound/vo/mobs/cow/idle (4).ogg','sound/vo/mobs/cow/idle (5).ogg')

/mob/living/simple_animal/hostile/retaliate/bull/taunted(mob/user)
	emote("aggro")
	return

/mob/living/simple_animal/hostile/retaliate/bull/simple_limb_hit(zone)
	switch(zone)
		if(BODY_ZONE_PRECISE_NOSE, BODY_ZONE_PRECISE_MOUTH)
			return "snout"
	return ..()

/mob/living/simple_animal/hostile/retaliate/cow/cowlet
	name = "calf"
	desc = "So cute!"
	icon_state = "cowlet"
	icon_living = "cowlet"
	icon_dead = "cowlet_dead"
	icon_gib = "cowlet_gib"

	animal_species = null
	mob_size = MOB_SIZE_SMALL
	pass_flags = PASSMOB

	botched_butcher_results = list(/obj/item/reagent_containers/food/snacks/meat/mince/beef = 1)
	butcher_results = list(/obj/item/reagent_containers/food/snacks/meat/steak = 1)
	perfect_butcher_results = list(/obj/item/reagent_containers/food/snacks/meat/steak = 1,
								/obj/item/natural/hide = 1)

	health = CALF_HEALTH
	maxHealth = CALF_HEALTH

	base_intents = list(/datum/intent/simple/headbutt)
	melee_damage_lower = 1
	melee_damage_upper = 6
	base_constitution = 5
	base_strength = 5
	base_speed = 5
	defprob = 50
	adult_growth = /mob/living/simple_animal/hostile/retaliate/cow

	ai_controller = /datum/ai_controller/basic_controller/cow/baby
	can_breed = FALSE
	can_tip = FALSE

/mob/living/simple_animal/hostile/retaliate/cow/cowlet/udder_component()
	return

/mob/living/simple_animal/hostile/retaliate/cow/cowlet/bullet
	desc = "So cute! Be careful of those horns, though."
	icon_state = "bullet"
	icon_living = "bullet"
	icon_dead = "bullet_dead"
	icon_gib = "bullet_gib"

	gender = MALE

	adult_growth = /mob/living/simple_animal/hostile/retaliate/bull
