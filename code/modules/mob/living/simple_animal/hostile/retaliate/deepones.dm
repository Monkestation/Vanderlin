/mob/living/simple_animal/hostile/deepone
	name = "Deep One"
	desc = ""
	icon = 'icons/roguetown/mob/monster/fishman.dmi'
	icon_state = "deep1"
	icon_living = "deep1"
	icon_dead = "deep1_d"
	gender = MALE
	mob_biotypes = MOB_ORGANIC|MOB_HUMANOID
	robust_searching = 1
	move_to_delay = 3
	base_constitution = 11
	base_strength = 13
	base_speed = 9
	maxHealth = DEEPONE_HEALTH
	butcher_results = list(/obj/item/reagent_containers/food/snacks/meat = 5, /obj/item/alch/viscera = 2)
	health = DEEPONE_HEALTH
	harm_intent_damage = 20
	melee_damage_lower = 10
	melee_damage_upper = 25
	vision_range = 7
	aggro_vision_range = 9
	retreat_distance = 0
	minimum_distance = 0
	limb_destroyer = 0
	base_intents = list(/datum/intent/simple/claw/deepone_unarmed)
	attack_verb_continuous = "slashes"
	attack_verb_simple = "slash"
	attack_sound = 'sound/combat/wooshes/punch/punchwoosh (1).ogg'
	canparry = TRUE
	d_intent = INTENT_DODGE
	defprob = 50
	defdrain = 20
	speak_emote = list("burbles")
	faction = list("deepone")
	footstep_type = FOOTSTEP_MOB_BAREFOOT
	animal_type = /datum/blood_type/human/triton



	ai_controller = /datum/ai_controller/deepone

/mob/living/simple_animal/hostile/deepone/Initialize()
	. = ..()
	add_traits(list(TRAIT_NODROWN, TRAIT_SWIMMER), INNATE_TRAIT)

/mob/living/simple_animal/hostile/deepone/arm
	name = "Deep One"
	desc = ""
	icon = 'icons/roguetown/mob/monster/fishman.dmi'
	icon_state = "deep1_arm"
	health = DEEPONE_HEALTH * 1.4
	harm_intent_damage = 25
	melee_damage_lower = 15
	melee_damage_upper = 30
	limb_destroyer = 1
	attack_verb_continuous = "mauls"
	attack_verb_simple = "maul"

/mob/living/simple_animal/hostile/deepone/spit
	name = "Deep One"
	desc = ""
	icon = 'icons/roguetown/mob/monster/fishman.dmi'
	icon_state = "deep1_spit"
	icon_living = "deep1_spit"
	icon_dead = "deep1_d"
	projectiletype = /obj/projectile/bullet/reusable/deepone
	projectilesound = 'sound/combat/wooshes/punch/punchwoosh (1).ogg'
	ranged = 1
	retreat_distance = 2
	minimum_distance = 5
	ranged_cooldown_time = 40
	ai_controller = /datum/ai_controller/deepone_ranged

/mob/living/simple_animal/hostile/deepone/wiz
	name = "Deep One Devout"
	desc = ""
	icon = 'icons/roguetown/mob/monster/fishman.dmi'
	icon_state = "deep1_wiz"
	icon_living = "deep1_wiz"
	icon_dead = "deep1_d"
	projectiletype = /obj/projectile/magic
	projectilesound = 'sound/magic/fireball.ogg'
	ranged = 1
	retreat_distance = 2
	minimum_distance = 5
	ranged_cooldown_time = 70
	ai_controller = /datum/ai_controller/deepone_ranged
	var/allowed_projectile_types = list(/obj/projectile/magic/frostbolt, /obj/projectile/magic/energy/rogue3, /obj/projectile/magic/repel)

/mob/living/simple_animal/hostile/deepone/wiz/boss
	wander = FALSE
/mob/living/simple_animal/hostile/deepone/spit/boss
	wander = FALSE
/mob/living/simple_animal/hostile/deepone/arm/boss
	wander = FALSE
/mob/living/simple_animal/hostile/deepone/boss
	wander = FALSE
/datum/intent/simple/claw/deepone_unarmed
	attack_verb = list("claws", "strikes")
	blade_class = BCLASS_CHOP
	animname = "cut"
	hitsound = 'sound/combat/hits/bladed/smallslash (1).ogg'
	clickcd = DEEPONE_ATTACK_SPEED
	penfactor = 5
	chargetime = 2
/datum/intent/simple/claw/deepone_boss
	attack_verb = list("smashes", "slams")
	blade_class = BCLASS_CHOP
	animname = "cut"
	hitsound = 'sound/combat/hits/blunt/metalblunt (1).ogg'
	clickcd = DEEPONE_ATTACK_SPEED
	penfactor = 5
	chargetime = 2

/mob/living/simple_animal/hostile/deepone/elite
	name = "Deep One Elite"
	desc = "A more powerful servant of the deep, glowing with eldritch energy."
	melee_damage_lower = 30
	melee_damage_upper = 40
	maxHealth = 200
	health = 200
	SET_BASE_PIXEL(-16, 0)

/mob/living/simple_animal/hostile/deepone/elite/Initialize()
	. = ..()
	add_filter("elite_glow", 2, outline_filter(1, "#3366FF"))

/mob/living/simple_animal/hostile/deepone/elite/boss
	faction = list("deepone")
