//Mimic mob but updated.
/mob/living/simple_animal/hostile/retaliate/mimic
	name = "chest"
	icon = 'icons/roguetown/mob/monster/mimic.dmi'
	icon_state = "mimicopen"
	icon_living = "mimicopen"
	icon_dead = "mimicdead"

	speed = 0
	maxHealth = 450
	health = 450
	gender = NEUTER
	mob_biotypes = NONE
	base_intents = list(/datum/intent/simple/bite)
	butcher_results = list(/obj/item/reagent_containers/food/snacks/meat/steak = 2)
	retreat_distance = 0
	minimum_distance = 0
	aggro_vision_range = 2
	see_in_dark = 6

	damage_coeff = list(BRUTE = 1, BURN = 0, TOX = 0, CLONE = 0, STAMINA = 0, OXY = 0)
	harm_intent_damage = 5
	melee_damage_lower = 24
	melee_damage_upper = 32
	attack_verb_continuous = "bites"
	attack_verb_simple = "bite"
	attack_sound = list('sound/vo/mobs/mimic/mimic_attack1.ogg',
						'sound/vo/mobs/mimic/mimic_attack2.ogg',
						'sound/vo/mobs/mimic/mimic_attack3.ogg')
	emote_taunt = list("howls")
	speak_emote = list("clatters")

	faction = list("mimic", "hostile")
	wander = 0
	stat_attack = UNCONSCIOUS

	food_type = list(/obj/item/reagent_containers/food/snacks/meat, /obj/item/bodypart, /obj/item/organ)

	pooptype = null

	base_constitution = 6
	base_strength = 6
	base_speed = 5

	ai_controller = /datum/ai_controller/mimic
	dendor_taming_chance = DENDOR_TAME_PROB_NONE


/mob/living/simple_animal/hostile/retaliate/mimic/Initialize(mapload)
	. = ..()
	if(mapload)//load objects into chest.
		for(var/obj/item/I in loc)
			I.forceMove(src)
	icon_state = "mimic"
	AddComponent(/datum/component/anti_magic, TRUE, TRUE, TRUE, null, null, FALSE)

/mob/living/simple_animal/hostile/retaliate/mimic/death()
	icon_state = "[initial(icon_state)]dead"
	// Drop loot onto tile.
	for(var/obj/O in src)
		O.forceMove(loc)
	..()

/mob/living/simple_animal/hostile/retaliate/mimic/get_sound(input)
	switch(input)
		if("death")
			return pick('sound/vo/mobs/mimic/mimic_death.ogg')

/mob/living/simple_animal/hostile/retaliate/mimic/simple_limb_hit(zone)
	return ..()

//////
// Landmark
//////

/obj/effect/landmark/chest_or_mimic/Initialize()
	..()
	var/C = pick(/obj/structure/closet/crate/chest,
				/mob/living/simple_animal/hostile/retaliate/mimic)
	new C(loc)
	return INITIALIZE_HINT_QDEL
