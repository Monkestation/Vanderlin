/mob/living/simple_animal/hostile/retaliate/hound
	icon = 'icons/roguetown/mob/greyhound.dmi'
	name = "hound"
	desc = "Loyal beasts, tamed cousins of the common volfs, there is hardly a better friend to have with you in the wild, or lying next to you by a warm fire."
	icon_state = "hh"
	icon_living = "hh"
	icon_dead = "hhd"

	speak_emote = list("barks", "whines")
	emote_hear = list("barks.", "growls.")
	emote_see = list("back goes stiff, head pointing.", "sniffs around.")
	see_in_dark = 9
	move_to_delay = 2
	vision_range = 9
	aggro_vision_range = 9

	botched_butcher_results = list(
		/obj/item/reagent_containers/food/snacks/meat/steak = 1,
		/obj/item/natural/fur/volf = 1,
		/obj/item/alch/bone = 1,
	)
	butcher_results = list(
		/obj/item/reagent_containers/food/snacks/meat/steak = 2,
		/obj/item/natural/hide = 1,
		/obj/item/natural/fur/volf = 2,
		/obj/item/alch/sinew = 2,
		/obj/item/alch/bone = 1,
	)
	perfect_butcher_results = list(
		/obj/item/reagent_containers/food/snacks/meat/steak = 2,
		/obj/item/reagent_containers/food/snacks/meat/ribs = 1,
		/obj/item/natural/hide = 2,
		/obj/item/natural/fur/volf = 3,
		/obj/item/alch/sinew = 2,
		/obj/item/alch/bone = 2,
	)

	indexed = TRUE
	health = VOLF_HEALTH + 180
	maxHealth = VOLF_HEALTH + 180
	food_type = list(/obj/item/reagent_containers/food/snacks/meat,
					/obj/item/bodypart,
					/obj/item/organ)

	base_intents = list(/datum/intent/simple/bite)
	attack_sound = list('sound/vo/mobs/vw/attack (1).ogg','sound/vo/mobs/vw/attack (2).ogg','sound/vo/mobs/vw/attack (3).ogg','sound/vo/mobs/vw/attack (4).ogg')
	melee_damage_lower = 15
	melee_damage_upper = 20

	base_constitution = 8
	base_strength = 7
	base_speed = 13

	simple_detect_bonus = 20
	retreat_distance = 0
	minimum_distance = 0
	deaggroprob = 0
	defprob = 35
	defdrain = 5
	del_on_deaggro = FALSE
	retreat_health = 0.4

	dodgetime = 17
	stat_attack = UNCONSCIOUS
	remains_type = /obj/effect/decal/remains/hound
	body_eater = TRUE

	///this mob was updated to new ai

	living_flags = MOVES_ON_ITS_OWN|CAN_BE_FIREMANNED

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

/obj/effect/decal/remains/hound
	name = "loyal remains"
	gender = PLURAL
	icon_state = "bones"
	icon = 'icons/roguetown/mob/greyhound.dmi'

/mob/living/simple_animal/hostile/retaliate/hound/Initialize()
	AddComponent(/datum/component/obeys_commands, pet_commands) // here due to signal overridings from pet commands // due to signal overridings from pet commands
	. = ..()
	AddComponent(/datum/component/ai_aggro_system)
	AddElement(/datum/element/ai_flee_while_injured, 0.75, retreat_health)

	var/color = pick("grey", "black", "white")
	icon_state = "hound_[color]"
	icon_living = "hound_[color]"
	icon_dead = "hound_[color]_dead"

	gender = MALE
	if(prob(33))
		gender = FEMALE
	ADD_TRAIT(src, TRAIT_CRITICAL_WEAKNESS, TRAIT_GENERIC)

/mob/living/simple_animal/hostile/retaliate/hound/get_sound(input)
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

/mob/living/simple_animal/hostile/retaliate/hound/taunted(mob/user)
	emote("aggro")
