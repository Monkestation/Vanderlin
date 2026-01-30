/mob/living/simple_animal/hostile/retaliate/wolf
	icon = 'icons/roguetown/mob/monster/vol.dmi'
	name = "volf"
	desc = "Usually content to leave menfolk alone if well-fed, but something in the wilds turns them hungry, persistent, and vicious."
	icon_state = "vv"
	icon_living = "vv"
	icon_dead = "vvd"
	var/icon_eye_emissive = "vve"

	faction = list(FACTION_ORCS)
	emote_hear = null
	emote_see = null
	see_in_dark = 9
	move_to_delay = 2
	vision_range = 9
	aggro_vision_range = 9

	botched_butcher_results = list(/obj/item/reagent_containers/food/snacks/meat/steak = 1,
						/obj/item/natural/fur/volf = 1,
						/obj/item/alch/bone = 1)
	butcher_results = list(/obj/item/reagent_containers/food/snacks/meat/steak = 2,
						/obj/item/natural/hide = 1,
						/obj/item/natural/fur/volf = 2,
						/obj/item/alch/sinew = 2,
						/obj/item/alch/bone = 1)
	perfect_butcher_results = list(/obj/item/reagent_containers/food/snacks/meat/steak = 2,
						/obj/item/natural/hide = 2,
						/obj/item/natural/fur/volf = 3,
						/obj/item/alch/sinew = 2,
						/obj/item/alch/bone = 2)
	head_butcher = /obj/item/natural/head/volf

	health = VOLF_HEALTH
	maxHealth = VOLF_HEALTH
	food_type = list(/obj/item/reagent_containers/food/snacks/meat,
					/obj/item/bodypart,
					/obj/item/organ)

	base_intents = list(/datum/intent/simple/bite)
	attack_sound = list('sound/vo/mobs/vw/attack (1).ogg','sound/vo/mobs/vw/attack (2).ogg','sound/vo/mobs/vw/attack (3).ogg','sound/vo/mobs/vw/attack (4).ogg')
	melee_damage_lower = 15
	melee_damage_upper = 20

	base_constitution = 6
	base_strength = 6
	base_speed = 12

	simple_detect_bonus = 20
	retreat_distance = 0
	minimum_distance = 0
	deaggroprob = 0
	defprob = 35
	defdrain = 5
	del_on_deaggro = 999 SECONDS
	retreat_health = 0.4

	dodgetime = 17
	aggressive = 1
//	stat_attack = UNCONSCIOUS
	remains_type = /obj/effect/decal/remains/wolf
	body_eater = TRUE

	///this mob was updated to new ai


	ai_controller = /datum/ai_controller/volf
	var/static/list/pet_commands = list(
		/datum/pet_command/fish,
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

/obj/effect/decal/remains/wolf
	name = "remains"
	gender = PLURAL
	icon_state = "bones"
	icon = 'icons/roguetown/mob/monster/vol.dmi'

/mob/living/simple_animal/hostile/retaliate/wolf/Initialize()
	AddComponent(/datum/component/obeys_commands, pet_commands) // here due to signal overridings from pet commands // due to signal overridings from pet commands
	. = ..()
	AddComponent(/datum/component/ai_aggro_system)
	AddElement(/datum/element/ai_flee_while_injured, 0.75, retreat_health)

	gender = MALE
	if(prob(50))
		gender = FEMALE
	ADD_TRAIT(src, TRAIT_CRITICAL_WEAKNESS, TRAIT_GENERIC)
	update_appearance(UPDATE_OVERLAYS)

/mob/living/simple_animal/hostile/retaliate/wolf/death(gibbed)
	..()
	update_appearance(UPDATE_OVERLAYS)

/mob/living/simple_animal/hostile/retaliate/wolf/update_overlays()
	. = ..()
	if(stat == DEAD)
		return
	. += emissive_appearance(icon, icon_eye_emissive)

/mob/living/simple_animal/hostile/retaliate/wolf/get_sound(input)
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

/mob/living/simple_animal/hostile/retaliate/wolf/taunted(mob/user)
	emote("aggro")
	return

/mob/living/simple_animal/hostile/retaliate/wolf/simple_limb_hit(zone)
	return ..()

/mob/living/simple_animal/hostile/retaliate/wolf/cave
	name = "marrov"
	desc = "Also known as 'Gueules-funestes,' a subspecies of volves who delved too deep, twisted by the corrupting forces of the hells into fearsome, merciless monsters."
	icon_state = "marrov"
	icon_living = "marrov"
	icon_dead = "marrovd"
	icon_eye_emissive = "marrove"
	faction = list(FACTION_UNDEAD)

	botched_butcher_results = list(
		/obj/item/natural/fur/volf = 1,
		/obj/item/alch/bone = 1
	)
	butcher_results = list(
		/obj/item/natural/hide = 1,
		/obj/item/natural/fur/volf = 2,
		/obj/item/alch/sinew = 2,
		/obj/item/alch/bone = 1
	)
	perfect_butcher_results = list(
		/obj/item/reagent_containers/food/snacks/meat/steak = 1,
		/obj/item/natural/hide = 2,
		/obj/item/natural/fur/volf = 3,
		/obj/item/alch/sinew = 2,
		/obj/item/alch/bone = 4
	)
	head_butcher = /obj/item/natural/head/volf	// TODO: unique head.

	// You must sacrifice someone/something to tame this. Can't just be an animal.
	food_type = list(
		/obj/item/bodypart,
		/obj/item/organ,
		)

	// These are made to FUCKING KILL YOU.
	melee_damage_lower = 20
	melee_damage_upper = 20
	base_constitution = 9
	base_strength = 8
	base_speed = 15
	move_to_delay = 1
	vision_range = 6	// You can sneak around easier.
	aggro_vision_range = 6
	remains_type = /obj/effect/decal/remains/wolf/marrov

/obj/effect/decal/remains/wolf/marrov
	icon_state = "marrovbones"

