/mob/living/simple_animal/hostile/retaliate/troll
	name = "troll"
	desc = "Elven legends say these monsters were servants of Dendor tasked to guard his realm; nowadays, they are sometimes found in the company of orcs."
	icon = 'icons/mob/creacher/trolls/troll.dmi'
	icon_state = "troll"
	icon_living = "troll"
	icon_dead = "troll_dead"
	SET_BASE_PIXEL(-16, 0)

	faction = list(FACTION_ORCS)
	footstep_type = FOOTSTEP_MOB_HEAVY
	emote_hear = null
	emote_see = null
	verb_say = "groans"
	verb_ask = "grunts"
	verb_exclaim = "roars"
	verb_yell = "roars"

	see_in_dark = 10
	move_to_delay = 7
	vision_range = 6
	aggro_vision_range = 6

	animal_type = /datum/blood_type/troll

	botched_butcher_results = list(/obj/item/reagent_containers/food/snacks/meat/strange = 1, \
						/obj/item/natural/hide = 1)
	butcher_results = list(/obj/item/reagent_containers/food/snacks/meat/strange = 1,
						/obj/item/natural/hide = 2, \
						/obj/item/alch/horn = 1)
	perfect_butcher_results = list(/obj/item/reagent_containers/food/snacks/meat/strange= 2, \
						/obj/item/natural/hide = 3, \
						/obj/item/alch/horn = 2)
	head_butcher = /obj/item/natural/head/troll

	health = TROLL_HEALTH
	maxHealth = TROLL_HEALTH
	food_type = list(
					/obj/item/bodypart,
					/obj/item/organ)

	base_intents = list(/datum/intent/unarmed/claw, /datum/intent/simple/bigbite)
	attack_sound = list('sound/combat/wooshes/blunt/wooshhuge (1).ogg','sound/combat/wooshes/blunt/wooshhuge (2).ogg','sound/combat/wooshes/blunt/wooshhuge (3).ogg')
	melee_damage_lower = 40
	melee_damage_upper = 60
	environment_smash = ENVIRONMENT_SMASH_STRUCTURES

	base_constitution = 16
	base_strength = 16
	base_speed = 2
	base_endurance = 17

	retreat_distance = 0
	minimum_distance = 0
	deaggroprob = 0
	defprob = 20
	defdrain = 15
	del_on_deaggro = 99 SECONDS
	retreat_health = 0
	food_max = 250

	dodgetime = 50
	aggressive = TRUE
	dendor_taming_chance = DENDOR_TAME_PROB_HIGH

	remains_type = /obj/effect/decal/remains/troll

	ai_controller = /datum/ai_controller/troll


	var/range = 9

/mob/living/simple_animal/hostile/retaliate/troll/slaved
	ai_controller = /datum/ai_controller/summon

/mob/living/simple_animal/hostile/retaliate/troll/slaved/Initialize()
	. = ..()
	var/static/list/pet_commands = list(
				/datum/pet_command/idle,
				/datum/pet_command/free,
				/datum/pet_command/follow,
				/datum/pet_command/attack,
				/datum/pet_command/protect_owner,
				/datum/pet_command/aggressive,
				/datum/pet_command/calm,
			)
	AddComponent(/datum/component/obeys_commands, pet_commands)

/mob/living/simple_animal/hostile/retaliate/troll/Initialize()
	. = ..()
	AddComponent(/datum/component/ai_aggro_system, 10 , range)
	ADD_TRAIT(src, TRAIT_ACID_IMMUNE, TRAIT_GENERIC)

/mob/living/simple_animal/hostile/retaliate/troll/get_sound(input)
	switch(input)
		if("aggro")
			return pick('sound/vo/mobs/troll/aggro1.ogg','sound/vo/mobs/troll/aggro2.ogg')
		if("pain")
			return pick('sound/vo/mobs/troll/pain1.ogg','sound/vo/mobs/troll/pain2.ogg')
		if("death")
			return pick('sound/vo/mobs/troll/death.ogg')
		if("idle")
			return pick('sound/vo/mobs/troll/idle1.ogg','sound/vo/mobs/troll/idle2.ogg')
		if("cidle")
			return pick('sound/vo/mobs/troll/cidle1.ogg','sound/vo/mobs/troll/aggro2.ogg')


/mob/living/simple_animal/hostile/retaliate/troll/Life()
	..()
	if(fire_stacks + divine_fire_stacks <= 0)
		adjustHealth(-rand(20,35))

/mob/living/simple_animal/hostile/retaliate/troll/simple_limb_hit(zone)
	if(!zone)
		return ""
	switch(zone)
		if(BODY_ZONE_PRECISE_R_EYE)
			return "head"
		if(BODY_ZONE_PRECISE_L_EYE)
			return "head"
		if(BODY_ZONE_PRECISE_NOSE)
			return "nose"
		if(BODY_ZONE_PRECISE_MOUTH)
			return "mouth"
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
		if(BODY_ZONE_PRECISE_GROIN)
			return "tail"
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

/mob/living/simple_animal/hostile/retaliate/troll/proc/hide()
	flick("troll_hiding", src)
	sleep(1 SECONDS)
	icon_state = "troll_hide"

/mob/living/simple_animal/hostile/retaliate/troll/proc/ambush()
	flick("troll_ambush", src)
	sleep(1 SECONDS)
	icon_state = initial(icon_state)

/obj/effect/decal/remains/troll
	icon_state = "troll_dead"

/mob/living/simple_animal/hostile/retaliate/troll/after_creation()
	. = ..()
	var/obj/item/organ/eyes/eyes = src.getorganslot(ORGAN_SLOT_EYES)
	if(eyes)
		eyes.Remove(src, TRUE)
		QDEL_NULL(eyes)
	eyes = new /obj/item/organ/eyes/night_vision/nightmare
	eyes.Insert(src)

/mob/living/simple_animal/hostile/retaliate/troll/quiet
	footstep_type = FOOTSTEP_MOB_BAREFOOT

/mob/living/simple_animal/hostile/retaliate/troll/quiet/get_sound(input)
	switch(input)
		if("aggro")
			return pick('sound/vo/mobs/troll/aggro1.ogg','sound/vo/mobs/troll/aggro2.ogg')
		if("pain")
			return pick('sound/vo/mobs/troll/pain1.ogg','sound/vo/mobs/troll/pain2.ogg')
		if("death")
			return pick('sound/vo/mobs/troll/death.ogg')

/mob/living/simple_animal/hostile/retaliate/troll/bog
	name = "bog troll"
	ai_controller = /datum/ai_controller/bog_troll

	health = BOGTROLL_HEALTH
	maxHealth = BOGTROLL_HEALTH
	food_type = list(/obj/item/reagent_containers/food/snacks/meat,
					/obj/item/bodypart,
					/obj/item/organ)

	base_intents = list(/datum/intent/simple/headbutt, /datum/intent/simple/bigbite)
	melee_damage_lower = 30
	melee_damage_upper = 50

	defprob = 25
	defdrain = 13
	range = 3

/mob/living/simple_animal/hostile/retaliate/troll/cave
	name = "cave troll"
	desc = "Dwarven tales of giants and trolls often contain these creatures, for the fear of mining into one runs deep."
	icon = 'icons/mob/creacher/trolls/troll_cave.dmi'
	health = CAVETROLL_HEALTH
	maxHealth = CAVETROLL_HEALTH
	ai_controller = /datum/ai_controller/troll/cave

	botched_butcher_results = list(/obj/item/reagent_containers/food/snacks/meat/strange = 1, \
						/obj/item/natural/hide = 1, \
						/obj/item/natural/rock/mana_crystal = 1)
	butcher_results = list(/obj/item/reagent_containers/food/snacks/meat/strange = 1, \
						/obj/item/natural/hide = 2, \
						/obj/item/alch/horn = 1, \
						/obj/item/natural/rock/mana_crystal = 2)
	perfect_butcher_results = list(/obj/item/reagent_containers/food/snacks/meat/strange= 2, \
						/obj/item/natural/hide = 3, \
						/obj/item/alch/horn = 2, \
						/obj/item/natural/rock/mana_crystal = 3)
	head_butcher = /obj/item/natural/head/troll/cave

	dendor_taming_chance = DENDOR_TAME_PROB_LOW
	defprob = 15

	//stone chucking ability
	var/datum/action/cooldown/spell/stone_throw/throwing_stone

/mob/living/simple_animal/hostile/retaliate/troll/cave/Initialize()
	. = ..()
	throwing_stone = new
	throwing_stone.Grant(src)
	ai_controller.set_blackboard_key(BB_TARGETED_ACTION, throwing_stone)

/mob/living/simple_animal/hostile/retaliate/troll/cave/ambush
	ai_controller = /datum/ai_controller/troll/ambush
	range = 3

/mob/living/simple_animal/hostile/retaliate/troll/axe
	name = "Troll Skull-Splitter"
	desc = "This one seems smarter than the rest... And its axe could cut a man in two."
	icon = 'icons/mob/creacher/trolls/troll_axe.dmi'
	perfect_butcher_results = list(/obj/item/reagent_containers/food/snacks/meat/strange = 2, \
					/obj/item/natural/hide = 3, \
					/obj/item/alch/horn = 2)
	head_butcher = /obj/item/natural/head/troll/axe
	dendor_taming_chance = DENDOR_TAME_PROB_LOW
	base_intents = list(/datum/intent/simple/troll_axe)
	attack_sound = list('sound/combat/wooshes/blunt/wooshhuge (1).ogg','sound/combat/wooshes/blunt/wooshhuge (2).ogg','sound/combat/wooshes/blunt/wooshhuge (3).ogg')
	loot = list(/obj/item/weapon/axe/iron/troll)
	deathmessage = "As the creacher tumbles, it falls upon its axe, snapping the handle."

/datum/intent/simple/troll_axe
	name = "troll axe"
	icon_state = "instrike"
	attack_verb = list("hacks at", "slashes", "chops", "crushes")
	animname = "blank22"
	hitsound = "genchop"
	blade_class = BCLASS_CHOP
	chargetime = 20
	penfactor = 10
	swingdelay = 3
	candodge = TRUE
	canparry = TRUE
	item_damage_type = "slash"

// You know I had to. Hostile, killer cabbit. Strong. Fast. But not as durable.
// The most foul, cruel and bad tempered feline-rodent you ever set eyes on.
/mob/living/simple_animal/hostile/retaliate/troll/caerbannog
	name = "cabbit of the Cairne Bog"
	desc = "That's no ordinary cabbit..."
	icon = 'icons/roguetown/mob/cabbit.dmi'
	icon_state = "cabbit_evil"
	icon_living = "cabbit_evil"
	icon_dead = "cabbit_evil_dead"
	speak = list("HISSS", "GHRHRHRHL")
	speak_emote = list("squeaks")
	emote_hear = list("raises its ears.", "hisses.")
	emote_see = list("turns his head around.", "stands with its hindlegs in guard.")
	health = 160
	maxHealth = 160
	move_to_delay = 3 // FAST.
	attack_sound = list('sound/vo/mobs/rat/aggro (1).ogg', 'sound/vo/mobs/rat/aggro (2).ogg', 'sound/vo/mobs/rat/aggro (3).ogg')
	base_constitution = 5
	base_strength = 5
	base_speed = 10
	base_endurance = 5
	remains_type = /obj/effect/decal/remains/cabbit
	melee_damage_lower = 20
	melee_damage_upper = 40
	footstep_type = FOOTSTEP_MOB_BAREFOOT
	botched_butcher_results = list(/obj/item/reagent_containers/food/snacks/meat/steak = 1)
	butcher_results = list(/obj/item/reagent_containers/food/snacks/meat/steak = 1, \
							/obj/item/alch/sinew = 1, \
							/obj/item/alch/bone = 1)
	perfect_butcher_results = list(/obj/item/reagent_containers/food/snacks/meat/steak = 1, \
							/obj/item/alch/sinew = 2, \
							/obj/item/alch/bone = 1, \
							/obj/item/natural/fur/cabbit = 1)
	head_butcher = null

/mob/living/simple_animal/hostile/retaliate/troll/caerbannog/get_sound(input)
	switch(input)
		if("aggro")
			return pick('sound/vo/mobs/rabbit/rabbit_alert.ogg')
		if("pain")
			return pick('sound/vo/mobs/rabbit/rabbit_pain1.ogg', 'sound/vo/mobs/rabbit/rabbit_pain2.ogg')
		if("death")
			return pick('sound/vo/mobs/rabbit/rabbit_death.ogg')

/obj/effect/decal/remains/cabbit
	name = "remains"
	gender = PLURAL
	icon = 'icons/roguetown/mob/cabbit.dmi'
	icon_state = "cabbit_remains"
