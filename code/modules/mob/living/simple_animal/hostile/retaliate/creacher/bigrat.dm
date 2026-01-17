/mob/living/simple_animal/hostile/retaliate/bigrat
	icon = 'icons/roguetown/mob/monster/bigrat.dmi'
	name = "rous"
	desc = "A Rodent Of Unusual Size. Some suspect the malice of the Cursed Star causes them to mutate."
	icon_state = "rat"
	icon_living = "rat"
	icon_dead = "rat1"
	SET_BASE_PIXEL(-16, -8)

	faction = list(FACTION_RATS)
	emote_hear = list("squeaks.")
	emote_see = list("cleans its nose.")
	move_to_delay = 5
	vision_range = 2
	aggro_vision_range = 2

	botched_butcher_results = list(/obj/item/reagent_containers/food/snacks/meat/mince/beef = 1)
	butcher_results = list(/obj/item/reagent_containers/food/snacks/meat/mince/beef = 1,
						/obj/item/natural/fur/rous = 1,/obj/item/alch/bone = 2)
	perfect_butcher_results = list(/obj/item/reagent_containers/food/snacks/meat/steak = 1,
						/obj/item/alch/sinew = 1,
						/obj/item/natural/fur/rous = 1, /obj/item/alch/bone = 4)
	head_butcher = /obj/item/natural/head/rous

	health = ROUS_HEALTH
	maxHealth = ROUS_HEALTH
	food_type = list(/obj/item/reagent_containers/food/snacks,
					/obj/item/bodypart,
					/obj/item/organ)

	base_intents = list(/datum/intent/simple/bite)
	attack_sound = 'sound/combat/wooshes/punch/punchwoosh (2).ogg'
	melee_damage_lower = 12
	melee_damage_upper = 14

	base_constitution = 3
	base_strength = 3
	base_speed = 6

	retreat_distance = 0
	minimum_distance = 0
	deaggroprob = 0
	defprob = 40
	defdrain = 5
	retreat_health = 0.3
	aggressive = TRUE
	stat_attack = UNCONSCIOUS
	remains_type = /obj/effect/decal/remains/bigrat
	body_eater = TRUE



	ai_controller = /datum/ai_controller/big_rat

	food_type = list(
		/obj/item/reagent_containers/food/snacks/cheddarslice,
		/obj/item/reagent_containers/food/snacks/cheese_wedge,
		/obj/item/reagent_containers/food/snacks/cheddar,
		/obj/item/reagent_containers/food/snacks/cheese,
	)
	tame_chance = 25
	bonus_tame_chance = 15

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

/obj/effect/decal/remains/bigrat
	name = "remains"
	gender = PLURAL
	icon_state = "ratbones"
	icon = 'icons/roguetown/mob/monster/bigrat.dmi'
	SET_BASE_PIXEL(-16, -8)

/mob/living/simple_animal/hostile/retaliate/bigrat/Initialize()
	AddComponent(/datum/component/obeys_commands, pet_commands) // here due to signal overridings from pet commands
	. = ..()

	gender = MALE
	if(prob(33))
		gender = FEMALE
	if(gender == FEMALE)
		icon_state = "Frat"
		icon_living = "Frat"
		icon_dead = "Frat1"
	update_appearance(UPDATE_OVERLAYS)

	AddElement(/datum/element/ai_flee_while_injured, 0.75, retreat_health)


/mob/living/simple_animal/hostile/retaliate/bigrat/death(gibbed)
	..()
	update_appearance(UPDATE_OVERLAYS)

/mob/living/simple_animal/hostile/retaliate/bigrat/update_overlays()
	. = ..()
	if(stat == DEAD)
		return
	. += emissive_appearance(icon, "bigrat-eyes")

/mob/living/simple_animal/hostile/retaliate/bigrat/get_sound(input)
	switch(input)
		if("aggro")
			return pick('sound/vo/mobs/rat/aggro (1).ogg','sound/vo/mobs/rat/aggro (2).ogg','sound/vo/mobs/rat/aggro (3).ogg')
		if("pain")
			return pick('sound/vo/mobs/rat/pain (1).ogg','sound/vo/mobs/rat/pain (2).ogg','sound/vo/mobs/rat/pain (3).ogg')
		if("death")
			return pick('sound/vo/mobs/rat/death (1).ogg','sound/vo/mobs/rat/death (2).ogg')
		if("idle")
			return pick('sound/vo/mobs/rat/rat_life.ogg','sound/vo/mobs/rat/rat_life2.ogg','sound/vo/mobs/rat/rat_life3.ogg')

/mob/living/simple_animal/hostile/retaliate/bigrat/taunted(mob/user)
	emote("aggro")
	return

/mob/living/simple_animal/hostile/retaliate/bigrat/simple_limb_hit(zone)
	return ..()

