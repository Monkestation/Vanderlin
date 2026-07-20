/////////
// Copy of the mob I did on Stalker 13, more-or-less. Same function here. Refluffed and changed slightly. - Carl
/////////
/mob/living/simple_animal/hostile/retaliate/poltergeist
	name = "poltergeist"
	icon = 'icons/roguetown/mob/monster/poltergeist.dmi'
	icon_state = "polter0"
	icon_living = "polter0"
	icon_dead = "polter_initial"
	gender = PLURAL
	emote_hear = null
	emote_see = null
	speak_chance = 1
	see_in_dark = 6
	move_to_delay = 5
	base_intents = list(/datum/intent/simple/claw)
	faction = list("poltergeist")
	mob_biotypes = MOB_UNDEAD
	health = 80//Low health because it's impossible to be hit as is. Use Churn Undead to get rid of a haunting.
	maxHealth = 80
	melee_damage_lower = 5
	melee_damage_upper = 10
	vision_range = 7
	aggro_vision_range = 9
	environment_smash = ENVIRONMENT_SMASH_STRUCTURES
	retreat_distance = 6
	minimum_distance = 4
	base_constitution = 5
	base_strength = 5
	base_speed = 20
	deaggroprob = 0
	defprob = 95
	defdrain = 10
	dodgetime = 30
	damage_coeff = list(BRUTE = 0, BURN = 0, TOX = 0, CLONE = 0, STAMINA = 0, OXY = 0)

	ai_controller = /datum/ai_controller/polter

/mob/living/simple_animal/hostile/retaliate/poltergeist/Initialize()
	. = ..()
	addtimer(CALLBACK(src, PROC_REF(flicker)), rand(9, 33))

/mob/living/simple_animal/hostile/retaliate/poltergeist/proc/flicker()
	flick("polter1", src)
	addtimer(CALLBACK(src, PROC_REF(flicker)), rand(9, 33))

/mob/living/simple_animal/hostile/retaliate/poltergeist/death()
	..()
	gib()

/mob/living/simple_animal/hostile/retaliate/poltergeist/get_sound(input)
	switch(input)
		if("aggro")
			return pick('sound/vo/mobs/poltergeist/polter_damage0.ogg','sound/vo/mobs/poltergeist/polter_damage1.ogg','sound/vo/mobs/poltergeist/polter_damage2.ogg')
		if("pain")
			return pick('sound/vo/mobs/poltergeist/polter_damage0.ogg','sound/vo/mobs/poltergeist/polter_damage1.ogg','sound/vo/mobs/poltergeist/polter_damage2.ogg')
		if("death")
			return pick('sound/vo/mobs/poltergeist/polter_damage0.ogg','sound/vo/mobs/poltergeist/polter_damage1.ogg','sound/vo/mobs/poltergeist/polter_damage2.ogg')
		if("idle")
			return pick('sound/vo/mobs/poltergeist/polter_idle.ogg')
		if("cidle")
			return pick('sound/vo/mobs/poltergeist/polter_idle.ogg')
