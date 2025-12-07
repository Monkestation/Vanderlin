/mob/living/simple_animal/hostile/retaliate/saiga
	icon = 'icons/roguetown/mob/monster/saiga.dmi'
	name = "saiga"
	desc = "Proud beasts of burden, war mounts, and symbols of luxury alike. Especially sacred to the steppe people of the Northeast Regions."
	icon_state = "saiga"
	icon_living = "saiga"
	icon_dead = "saiga_dead"
	icon_gib = "saiga_gib"
	SET_BASE_PIXEL(-8, 0)

	animal_species = /mob/living/simple_animal/hostile/retaliate/saigabuck
	faction = list("saiga")
	gender = FEMALE
	footstep_type = FOOTSTEP_MOB_SHOE
	emote_see = list("looks around.", "chews some leaves.")
	move_to_delay = 8

	botched_butcher_results = list(/obj/item/reagent_containers/food/snacks/meat/steak = 1,
						/obj/item/natural/hide = 1,
						/obj/item/alch/bone = 1)
	butcher_results = list(/obj/item/reagent_containers/food/snacks/meat/steak = 3,
						/obj/item/reagent_containers/food/snacks/fat = 1,
						/obj/item/natural/hide = 2,
						/obj/item/alch/sinew = 2,
						/obj/item/alch/bone = 1)
	perfect_butcher_results = list(/obj/item/reagent_containers/food/snacks/meat/steak = 4,
						/obj/item/reagent_containers/food/snacks/fat = 1,
						/obj/item/natural/hide = 4,
						/obj/item/alch/sinew = 2,
						/obj/item/alch/bone = 1)
	head_butcher = /obj/item/natural/head/saiga

	health = FEMALE_SAIGA_HEALTH
	maxHealth = FEMALE_SAIGA_HEALTH
	food_type = list(/obj/item/reagent_containers/food/snacks/produce/grain/wheat,
					/obj/item/reagent_containers/food/snacks/produce/grain/oat,
					/obj/item/reagent_containers/food/snacks/produce/fruit/jacksberry,
					/obj/item/reagent_containers/food/snacks/produce/fruit/apple)
	tame_chance = 25
	bonus_tame_chance = 15
	pooptype = /obj/item/natural/poo/horse

	base_intents = list(/datum/intent/simple/hind_kick)
	attack_sound = list('sound/vo/mobs/saiga/attack (1).ogg','sound/vo/mobs/saiga/attack (2).ogg')
	attack_verb_continuous = "kicks"
	attack_verb_simple = "kick"
	melee_damage_lower = 10
	melee_damage_upper = 20
	retreat_distance = 10
	minimum_distance = 10
	base_speed = 15
	base_constitution = 8
	base_strength = 9
	can_buckle = TRUE
	buckle_lying = FALSE
	can_saddle = TRUE
	aggressive = TRUE
	remains_type = /obj/effect/decal/remains/saiga

	ai_controller = /datum/ai_controller/saiga

	var/can_breed = TRUE

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

/obj/effect/decal/remains/saiga
	name = "remains"
	gender = PLURAL
	icon_state = "skele"
	icon = 'icons/roguetown/mob/monster/saiga.dmi'

/mob/living/simple_animal/hostile/retaliate/saiga/Initialize()
	AddComponent(/datum/component/obeys_commands, pet_commands) // here due to signal overridings from pet commands // due to signal overridings from pet commands
	. = ..()
	AddElement(/datum/element/ai_retaliate)

	ADD_TRAIT(src, TRAIT_IGNOREDAMAGESLOWDOWN, TRAIT_GENERIC)

/mob/living/simple_animal/hostile/retaliate/saiga/update_overlays()
	. = ..()
	if(stat <= DEAD)
		return
	if(ssaddle)
		var/mutable_appearance/saddlet = mutable_appearance(icon, "saddle-f-above", 4.3)
		. += saddlet
		saddlet = mutable_appearance(icon, "saddle-f")
		. += saddlet
	if(has_buckled_mobs())
		var/mutable_appearance/mounted = mutable_appearance(icon, "saiga_mounted", 4.3)
		. += mounted

/mob/living/simple_animal/hostile/retaliate/saiga/tamed(mob/user)
	. = ..()
	deaggroprob = 30
	if(can_buckle)
		AddComponent(/datum/component/riding/saiga)
	if(can_breed)
		AddComponent(\
			/datum/component/breed,\
			list(/mob/living/simple_animal/hostile/retaliate/saiga, /mob/living/simple_animal/hostile/retaliate/saigabuck),\
			3 MINUTES, \
			list(/mob/living/simple_animal/hostile/retaliate/saiga/saigakid = 90, /mob/living/simple_animal/hostile/retaliate/saiga/saigakid/boy = 10),\
			CALLBACK(src, PROC_REF(after_birth)),\
		)

/mob/living/simple_animal/hostile/retaliate/saiga/proc/after_birth(mob/living/simple_animal/hostile/retaliate/cow/cowlet/baby, mob/living/partner)
	return

/mob/living/simple_animal/hostile/retaliate/saiga/get_sound(input)
	switch(input)
		if("aggro")
			return pick('sound/vo/mobs/saiga/attack (1).ogg','sound/vo/mobs/saiga/attack (2).ogg')
		if("pain")
			return pick('sound/vo/mobs/saiga/pain (1).ogg','sound/vo/mobs/saiga/pain (2).ogg','sound/vo/mobs/saiga/pain (3).ogg')
		if("death")
			return pick('sound/vo/mobs/saiga/death (1).ogg','sound/vo/mobs/saiga/death (2).ogg')
		if("idle")
			return pick('sound/vo/mobs/saiga/idle (1).ogg','sound/vo/mobs/saiga/idle (2).ogg','sound/vo/mobs/saiga/idle (3).ogg','sound/vo/mobs/saiga/idle (4).ogg','sound/vo/mobs/saiga/idle (5).ogg','sound/vo/mobs/saiga/idle (6).ogg','sound/vo/mobs/saiga/idle (7).ogg')


/mob/living/simple_animal/hostile/retaliate/saiga/simple_limb_hit(zone)
	if(!zone)
		return ""
	switch(zone)
		if(BODY_ZONE_PRECISE_R_EYE)
			return "head"
		if(BODY_ZONE_PRECISE_L_EYE)
			return "head"
		if(BODY_ZONE_PRECISE_NOSE)
			return "snout"
		if(BODY_ZONE_PRECISE_MOUTH)
			return "snout"
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

/mob/living/simple_animal/hostile/retaliate/saigabuck
	icon = 'icons/roguetown/mob/monster/saiga.dmi'
	name = "saigabuck"
	icon_state = "buck"
	icon_living = "buck"
	icon_dead = "buck_dead"
	icon_gib = "buck_gib"
	SET_BASE_PIXEL(-8, 0)

	faction = list("saiga")
	footstep_type = FOOTSTEP_MOB_SHOE
	emote_see = list("stares.")
	move_to_delay = 8

	botched_butcher_results = list(/obj/item/reagent_containers/food/snacks/meat/steak = 1,
						/obj/item/reagent_containers/food/snacks/fat = 1,
						/obj/item/natural/hide = 1,
						/obj/item/alch/bone = 1)
	butcher_results = list(/obj/item/reagent_containers/food/snacks/meat/steak = 2,
						/obj/item/reagent_containers/food/snacks/fat = 1,
						/obj/item/natural/hide = 3,
						/obj/item/alch/sinew = 2,
						/obj/item/alch/bone = 1)
	perfect_butcher_results = list(/obj/item/reagent_containers/food/snacks/meat/steak = 3,
						/obj/item/reagent_containers/food/snacks/fat = 1,
						/obj/item/natural/hide = 5,
						/obj/item/alch/sinew = 2,
						/obj/item/alch/bone = 1)
	head_butcher = /obj/item/natural/head/saiga

	health = MALE_SAIGA_HEALTH
	maxHealth = MALE_SAIGA_HEALTH
	food_type = list(/obj/item/reagent_containers/food/snacks/produce/grain/wheat,
					/obj/item/reagent_containers/food/snacks/produce/grain/oat,
					/obj/item/reagent_containers/food/snacks/produce/fruit/jacksberry,
					/obj/item/reagent_containers/food/snacks/produce/fruit/apple)
	pooptype = /obj/item/natural/poo/horse

	gender = MALE
	base_intents = list(/datum/intent/simple/hind_kick)
	attack_sound = list('sound/vo/mobs/saiga/attack (1).ogg','sound/vo/mobs/saiga/attack (2).ogg')
	attack_verb_continuous = "kicks"
	attack_verb_simple = "kick"
	melee_damage_lower = 15
	melee_damage_upper = 20
	environment_smash = ENVIRONMENT_SMASH_NONE
	retreat_distance = 0
	minimum_distance = 0
	retreat_health = 0.3
	base_constitution = 15
	base_strength = 11
	base_speed = 12

	can_buckle = TRUE
	buckle_lying = 0
	can_saddle = TRUE
	tame_chance = 25
	bonus_tame_chance = 15
	aggressive = TRUE
	remains_type = /obj/effect/decal/remains/saiga

	ai_controller = /datum/ai_controller/saiga

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

/mob/living/simple_animal/hostile/retaliate/saigabuck/Initialize()
	AddComponent(/datum/component/obeys_commands, pet_commands) // here due to signal overridings from pet commands // due to signal overridings from pet commands
	. = ..()
	AddElement(/datum/element/ai_retaliate)

	ADD_TRAIT(src, TRAIT_IGNOREDAMAGESLOWDOWN, TRAIT_GENERIC)

	AddComponent(\
		/datum/component/breed,\
		can_breed_with = list(/mob/living/simple_animal/hostile/retaliate/saiga, /mob/living/simple_animal/hostile/retaliate/saigabuck),\
		breed_timer = 2 MINUTES\
	)

/mob/living/simple_animal/hostile/retaliate/saigabuck/update_overlays()
	. = ..()
	if(stat <= DEAD)
		return
	if(ssaddle)
		var/mutable_appearance/saddlet = mutable_appearance(icon, "saddle-above", 4.3)
		. += saddlet
		saddlet = mutable_appearance(icon, "saddle")
		. += saddlet
	if(has_buckled_mobs())
		var/mutable_appearance/mounted = mutable_appearance(icon, "saiga_mounted", 4.3)
		. += mounted

/mob/living/simple_animal/hostile/retaliate/saigabuck/get_sound(input)
	switch(input)
		if("aggro")
			return pick('sound/vo/mobs/saiga/attack (1).ogg','sound/vo/mobs/saiga/attack (2).ogg')
		if("pain")
			return pick('sound/vo/mobs/saiga/pain (1).ogg','sound/vo/mobs/saiga/pain (2).ogg','sound/vo/mobs/saiga/pain (3).ogg')
		if("death")
			return pick('sound/vo/mobs/saiga/death (1).ogg','sound/vo/mobs/saiga/death (2).ogg')
		if("idle")
			return pick('sound/vo/mobs/saiga/idle (1).ogg','sound/vo/mobs/saiga/idle (2).ogg','sound/vo/mobs/saiga/idle (3).ogg','sound/vo/mobs/saiga/idle (4).ogg','sound/vo/mobs/saiga/idle (5).ogg','sound/vo/mobs/saiga/idle (6).ogg','sound/vo/mobs/saiga/idle (7).ogg')

/mob/living/simple_animal/hostile/retaliate/saigabuck/taunted(mob/user)
	emote("aggro")

/mob/living/simple_animal/hostile/retaliate/saigabuck/tamed(mob/user)
	. = ..()
	deaggroprob = 20
	if(can_buckle)
		AddComponent(/datum/component/riding/saiga)

/mob/living/simple_animal/hostile/retaliate/saigabuck/simple_limb_hit(zone)
	if(!zone)
		return ""
	switch(zone)
		if(BODY_ZONE_PRECISE_R_EYE)
			return "head"
		if(BODY_ZONE_PRECISE_L_EYE)
			return "head"
		if(BODY_ZONE_PRECISE_NOSE)
			return "snout"
		if(BODY_ZONE_PRECISE_MOUTH)
			return "snout"
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


/mob/living/simple_animal/hostile/retaliate/saiga/saigakid
	icon = 'icons/roguetown/mob/monster/saiga.dmi'
	name = "saiga"
	icon_state = "saigakid"
	icon_living = "saigakid"
	icon_dead = "saigakid_dead"
	icon_gib = "saigakid_gib"

	animal_species = null
	gender = FEMALE
	pass_flags = PASSMOB
	mob_size = MOB_SIZE_SMALL

	botched_butcher_results = list(/obj/item/reagent_containers/food/snacks/meat/mince/beef = 1)
	butcher_results = list(/obj/item/reagent_containers/food/snacks/meat/steak = 1)
	perfect_butcher_results = list(/obj/item/reagent_containers/food/snacks/meat/steak = 1,
								/obj/item/natural/hide = 1)

	health = CALF_HEALTH
	maxHealth = CALF_HEALTH

	base_intents = list(/datum/intent/simple/hind_kick)
	melee_damage_lower = 1
	melee_damage_upper = 6

	base_constitution = 5
	base_strength = 5
	base_speed = 5
	defprob = 50
	SET_BASE_PIXEL(-16, 0)
	adult_growth = /mob/living/simple_animal/hostile/retaliate/saiga
	tame = TRUE
	can_buckle = FALSE
	aggressive = TRUE

	can_breed = FALSE

	ai_controller = /datum/ai_controller/saiga_kid

/mob/living/simple_animal/hostile/retaliate/saiga/saigakid/boy
	icon_state = "saigaboy"
	icon_living = "saigaboy"
	icon_dead = "saigaboy_dead"
	icon_gib = "saigaboy_gib"

	gender = MALE

	health = CALF_HEALTH
	maxHealth = CALF_HEALTH

	adult_growth = /mob/living/simple_animal/hostile/retaliate/saigabuck

/mob/living/simple_animal/hostile/retaliate/saiga/tame
	tame = TRUE

/mob/living/simple_animal/hostile/retaliate/saigabuck/tame
	tame = TRUE

/mob/living/simple_animal/hostile/retaliate/saigabuck/tame/saddled/Initialize()
	. = ..()
	var/obj/item/natural/saddle/S = new(src)
	ssaddle = S
	update_appearance(UPDATE_OVERLAYS)

/mob/living/simple_animal/hostile/retaliate/saiga/tame/saddled/Initialize()
	. = ..()
	var/obj/item/natural/saddle/S = new(src)
	ssaddle = S
	update_appearance(UPDATE_OVERLAYS)
