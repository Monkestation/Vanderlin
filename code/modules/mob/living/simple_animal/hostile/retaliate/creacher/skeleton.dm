/mob/living/simple_animal/hostile/skeleton
	name = "Skeleton"
	desc = ""
	icon = 'icons/roguetown/mob/monster/skeletons.dmi'
	icon_state = "skeleton"
	icon_living = "skeleton"
	icon_dead = "skeleton_dead"
	gender = MALE
	mob_biotypes = MOB_ORGANIC|MOB_HUMANOID|MOB_UNDEAD
	robust_searching = 1
	move_to_delay = 3
	base_constitution = 9
	base_strength = 9
	base_speed = 8
	maxHealth = 100
	health = 100
	harm_intent_damage = 10
	melee_damage_lower = 10
	melee_damage_upper = 25
	vision_range = 7
	aggro_vision_range = 9
	retreat_distance = 0
	minimum_distance = 0
	limb_destroyer = 1
	base_intents = list(/datum/intent/simple/claw/skeleton_unarmed)
	attack_verb_continuous = "hacks"
	attack_verb_simple = "hack"
	attack_sound = 'sound/blank.ogg'
	canparry = TRUE
	d_intent = INTENT_PARRY
	defprob = 50
	defdrain = 20
	speak_emote = list("grunts")
	loot = list(/obj/item/alch/bone,	/obj/item/alch/bone, /obj/item/alch/bone,	/obj/item/skull)
	faction = list(FACTION_UNDEAD)
	footstep_type = FOOTSTEP_MOB_BAREFOOT
	del_on_death = TRUE

	ai_controller = /datum/ai_controller/orc

/mob/living/simple_animal/hostile/skeleton/Initialize(mapload, mob/user, cabal_affine)
	. = ..()
	AddComponent(/datum/component/ai_aggro_system)

/mob/living/simple_animal/hostile/skeleton/axe
	name = "Skeleton"
	desc = ""
	icon = 'icons/roguetown/mob/monster/skeletons.dmi'
	base_intents = list(/datum/intent/simple/axe)
	icon_state = "skeleton_axe"
	icon_living = "skeleton_axe"
	icon_dead = ""
	loot = list(/obj/item/alch/bone,	/obj/item/alch/bone, /obj/item/alch/bone,	/obj/item/weapon/polearm/halberd/bardiche/woodcutter, /obj/item/skull)

/mob/living/simple_animal/hostile/skeleton/spear
	name = "Skeleton"
	desc = ""
	icon = 'icons/roguetown/mob/monster/skeletons.dmi'
	base_intents = list(/datum/intent/simple/spear)
	icon_state = "skeleton_spear"
	icon_living = "skeleton_spear"
	icon_dead = ""
	attack_sound = 'sound/foley/pierce.ogg'
	loot = list(/obj/item/alch/bone,	/obj/item/alch/bone, /obj/item/alch/bone,	/obj/item/weapon/polearm/spear, /obj/item/skull)

/mob/living/simple_animal/hostile/skeleton/guard
	name = "Skeleton"
	desc = ""
	icon = 'icons/roguetown/mob/monster/skeletons.dmi'
	base_intents = list(/datum/intent/simple/axe)
	icon_state = "skeleton_guard"
	icon_living = "skeleton_guard"
	icon_dead = ""
	loot = list(/obj/item/alch/bone,	/obj/item/alch/bone, /obj/item/alch/bone,	/obj/item/weapon/sword/iron, /obj/item/skull)
	maxHealth = 200
	health = 200

/mob/living/simple_animal/hostile/skeleton/bow
	name = "Skeleton"
	desc = ""
	icon = 'icons/roguetown/mob/monster/skeletons.dmi'
	icon_state = "skeleton_bow"
	icon_living = "skeleton_bow"
	icon_dead = ""
	projectiletype = /obj/projectile/bullet/reusable/arrow/ancient
	projectilesound = 'sound/combat/Ranged/flatbow-shot-01.ogg'
	ranged = 1
	retreat_distance = 2
	minimum_distance = 5
	ranged_cooldown_time = 60
	loot = list(
		/obj/item/alch/bone,
		/obj/item/alch/bone,
		/obj/item/alch/bone,
		/obj/item/skull,
		/obj/item/gun/ballistic/bow,
		/obj/item/ammo_casing/caseless/arrow,
		/obj/item/ammo_casing/caseless/arrow,
		/obj/item/ammo_casing/caseless/arrow
	)

	ai_controller = /datum/ai_controller/orc_ranged

/mob/living/simple_animal/hostile/skeleton/get_sound(input)
	switch(input)
		if("aggro")
			return pick('sound/vo/mobs/skel/skeleton_rage (1).ogg','sound/vo/mobs/skel/skeleton_rage (2).ogg','sound/vo/mobs/skel/skeleton_rage (3).ogg')
		if("pain")
			return pick('sound/vo/mobs/skel/skeleton_pain (1).ogg','sound/vo/mobs/skel/skeleton_pain (2).ogg','sound/vo/mobs/skel/skeleton_pain (3).ogg', 'sound/vo/mobs/skel/skeleton_pain (4).ogg', 'sound/vo/mobs/skel/skeleton_pain (5).ogg')
		if("death")
			return pick('sound/vo/mobs/skel/skeleton_death (1).ogg','sound/vo/mobs/skel/skeleton_death (2).ogg','sound/vo/mobs/skel/skeleton_death (3).ogg','sound/vo/mobs/skel/skeleton_death (4).ogg','sound/vo/mobs/skel/skeleton_death (5).ogg')
		if("idle")
			return pick('sound/vo/mobs/skel/skeleton_idle (1).ogg','sound/vo/mobs/skel/skeleton_idle (2).ogg','sound/vo/mobs/skel/skeleton_idle (3).ogg')


/mob/living/simple_animal/hostile/skeleton/Initialize(mapload, mob/user, cabal_affine = FALSE)
	. = ..()
	if(user)
		friends += user.name
		if (cabal_affine)
			faction |= FACTION_CABAL

/mob/living/simple_animal/hostile/skeleton/Life()
	. = ..()
	if(!target)
		if(prob(60))
			emote(pick("idle"), TRUE)

/mob/living/simple_animal/hostile/skeleton/taunted(mob/user)
	emote("aggro")
	return

/mob/living/simple_animal/hostile/skeleton/proc/can_control(mob/user)
	if(!(user.mind?.has_antag_datum(/datum/antagonist/lich)))
		return FALSE
	if (!(user.name in friends))
		return FALSE

	return TRUE


/mob/living/simple_animal/hostile/skeleton/get_blood_dna_list() //We do not want skeletons bleeding.
//Could be a more global bitflag or something, but it's only relevant for this subtype.
	return null

/datum/intent/simple/claw/skeleton_unarmed
	attack_verb = list("claws", "strikes", "punches")
	blade_class = BCLASS_CHOP
	animname = "cut"
	hitsound = list('sound/combat/hits/bladed/genchop (1).ogg', 'sound/combat/hits/bladed/genchop (2).ogg', 'sound/combat/hits/bladed/genchop (3).ogg')
	chargetime = 2
	penfactor = 5
	swingdelay = 8

/obj/item/skull
	name = "skull"
	desc = "A skull"
	icon = 'icons/roguetown/mob/monster/skeletons.dmi'
	icon_state = "skull"
	w_class = WEIGHT_CLASS_SMALL

/obj/projectile/bullet/reusable/arrow/ancient
	damage = 10
	damage_type = BRUTE
	armor_penetration = 25
	icon = 'icons/roguetown/weapons/ammo.dmi'
	icon_state = "arrow_proj"
	ammo_type = /obj/item/ammo_casing/caseless/arrow
	range = 15
	hitsound = 'sound/combat/hits/hi_arrow2.ogg'
	embedchance = 100
	woundclass = BCLASS_STAB
	flag =  "piercing"
	speed = 2
