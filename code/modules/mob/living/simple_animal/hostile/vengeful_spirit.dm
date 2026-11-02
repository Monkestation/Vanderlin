/mob/living/simple_animal/hostile/spirit_vengeance
	name = "rancor spirit"
	desc = "Death is no end, but a fascinating new beginning."
	icon = 'icons/mob/spirit_vengeance.dmi'
	icon_state = "spirit_vengeance"
	icon_living = "spirit_vengeance"
	gender = MALE
	mob_biotypes = MOB_HUMANOID
	robust_searching = 1
	move_to_delay = 3
	base_constitution = 9
	base_strength = 9
	base_speed = 14
	maxHealth = 50
	health = 50
	harm_intent_damage = 5
	melee_damage_lower = 5
	melee_damage_upper = 7
	vision_range = 7
	aggro_vision_range = 9
	retreat_distance = 0
	minimum_distance = 0
	limb_destroyer = 1
	base_intents = list(/datum/intent/simple/bite)
	attack_verb_continuous = "hacks"
	attack_verb_simple = "hack"
	attack_sound = 'sound/blank.ogg'
	canparry = TRUE
	d_intent = INTENT_DODGE
	defprob = 20
	speak_emote = list("growls")
	footstep_type = null
	del_on_death = TRUE
	ai_controller = /datum/ai_controller/spirit_vengeance

/mob/living/simple_animal/hostile/spirit_vengeance/get_sound(input)
	switch(input)
		if("laugh")
			return pick('sound/vo/mobs/ghost/laugh (1).ogg','sound/vo/mobs/ghost/laugh (2).ogg','sound/vo/mobs/ghost/laugh (3).ogg','sound/vo/mobs/ghost/laugh (4).ogg','sound/vo/mobs/ghost/laugh (5).ogg','sound/vo/mobs/ghost/laugh (6).ogg')
		if("moan")
			return pick('sound/vo/mobs/ghost/moan (1).ogg','sound/vo/mobs/ghost/laugh (2).ogg','sound/vo/mobs/ghost/laugh (3).ogg')
		if("death")
			return 'sound/vo/mobs/ghost/death.ogg'
		if("whisper")
			return pick('sound/vo/mobs/ghost/whisper (1).ogg','sound/vo/mobs/ghost/whisper (2).ogg','sound/vo/mobs/ghost/whisper (3).ogg')
		if("aggro")
			return pick('sound/vo/mobs/ghost/aggro (1).ogg','sound/vo/mobs/ghost/aggro (2).ogg','sound/vo/mobs/ghost/aggro (3).ogg','sound/vo/mobs/ghost/aggro (4).ogg','sound/vo/mobs/ghost/aggro (5).ogg','sound/vo/mobs/ghost/aggro (6).ogg')

/mob/living/simple_animal/hostile/spirit_vengeance/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/ai_aggro_system)
	addtimer(CALLBACK(src, TYPE_PROC_REF(/mob/living/simple_animal, death), TRUE), 30 SECONDS)
