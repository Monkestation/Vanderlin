/mob/living/simple_animal/hostile/retaliate/mole
	name = "lesser brown mole"
	desc = "Usually lurking underground, they sometimes grow to impossible sizes and come to the surface to satiate a strange, newfound hunger for flesh."
	icon = 'icons/roguetown/mob/monster/mole.dmi'
	icon_state = "mole"
	icon_living = "mole"
	icon_dead = "mole_dead"

	faction = list(FACTION_ORCS)
	emote_hear = null
	emote_see = null
	move_to_delay = 7
	vision_range = 7
	aggro_vision_range = 9

	botched_butcher_results = list(/obj/item/reagent_containers/food/snacks/meat/steak = 1,
						/obj/item/natural/hide = 1,
						/obj/item/natural/fur/mole = 1,
						/obj/item/alch/sinew = 1,
						/obj/item/alch/bone = 1)
	butcher_results = list(/obj/item/reagent_containers/food/snacks/meat/steak = 2,
						/obj/item/natural/hide = 2,
						/obj/item/natural/fur/mole = 2,
						/obj/item/alch/sinew = 2,
						/obj/item/alch/bone = 1)
	perfect_butcher_results = list(/obj/item/reagent_containers/food/snacks/meat/steak = 3,
						/obj/item/natural/hide = 2,
						/obj/item/natural/fur/mole = 3,
						/obj/item/alch/sinew = 2,
						/obj/item/alch/bone = 1)
	head_butcher = /obj/item/natural/head/mole

	health = MOLE_HEALTH
	maxHealth = MOLE_HEALTH
	food_type = list(/obj/item/reagent_containers/food/snacks/meat,
					/obj/item/bodypart,
					/obj/item/organ)
	tame_chance = 15
	bonus_tame_chance = 15

	base_intents = list(/datum/intent/simple/claw)
	attack_sound = list('sound/vo/mobs/mole/MoleAttack1.ogg','sound/vo/mobs/mole/MoleAttack2.ogg')
	melee_damage_lower = 20
	melee_damage_upper = 25

	base_constitution = 8
	base_strength = 12
	base_speed = 3
	base_endurance = 10

	can_buckle = TRUE
	can_saddle = FALSE

	retreat_distance = 0
	minimum_distance = 0
	deaggroprob = 0
	defprob = 30
	defdrain = 10
	del_on_deaggro = 60 SECONDS
	retreat_health = 0.4


	dodgetime = 20
	aggressive = TRUE

	dendor_taming_chance = DENDOR_TAME_PROB_HIGH
//	stat_attack = UNCONSCIOUS
	remains_type = /obj/effect/decal/remains/mole
	body_eater = TRUE

	ai_controller = /datum/ai_controller/mole

/obj/effect/decal/remains/mole
	name = "remains"
	gender = PLURAL
	icon_state = "mole_bones"
	icon = 'icons/roguetown/mob/monster/mole.dmi'

/mob/living/simple_animal/hostile/retaliate/mole/Initialize()
	. = ..()
	gender = MALE
	if(prob(33))
		gender = FEMALE
	update_appearance(UPDATE_OVERLAYS)
	AddElement(/datum/element/ai_flee_while_injured, 0.75, retreat_health)
	if(tame)
		tamed(owner)
	ADD_TRAIT(src, TRAIT_IGNOREDAMAGESLOWDOWN, TRAIT_GENERIC)

/mob/living/simple_animal/hostile/retaliate/mole/tamed(mob/user)
	. = ..()
	deaggroprob = 30
	if(can_buckle)
		AddComponent(/datum/component/riding/mole)

/mob/living/simple_animal/hostile/retaliate/mole/update_overlays()
	. = ..()
	if(stat != DEAD)
		if(has_buckled_mobs())
			var/mutable_appearance/mounted = mutable_appearance(icon, "mole_mounted", 4.3)
			. += mounted

/mob/living/simple_animal/hostile/retaliate/mole/death(gibbed)
	..()
	update_appearance(UPDATE_OVERLAYS)

/mob/living/simple_animal/hostile/retaliate/mole/get_sound(input)//my media player does not work please add new .ogg
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

/mob/living/simple_animal/hostile/retaliate/mole/taunted(mob/user)
	emote("aggro")

/mob/living/simple_animal/hostile/retaliate/mole/simple_limb_hit(zone)
	return ..()

/mob/living/simple_animal/hostile/retaliate/mole/briars
	name = "Moss Crawler Mole"
	desc = "One of many miracles of Dendor, they hide in deep forests only able to be summoned by wise briars who dedicate themselves to call for spirits of forest in time of need"
	icon = 'icons/roguetown/mob/monster/mole.dmi'
	icon_state = "mole_briars"
	icon_living = "mole_briars"
	icon_dead = "mole_dead_briars"
	base_strength = 16
	base_constitution = 18
	food_type = list (/obj/item/bait/forestdelight)
	tame_chance = 25
	bonus_tame_chance = 15
