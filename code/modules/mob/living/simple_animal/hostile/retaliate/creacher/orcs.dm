/mob/living/simple_animal/hostile/orc
	name = "Savage Orc"
	desc = ""
	icon = 'icons/roguetown/mob/monster/simple_orcs.dmi'
	icon_state = "savageorc"
	icon_living = "savageorc"
	icon_dead = "savageorc_dead"
	gender = MALE
	mob_biotypes = MOB_ORGANIC|MOB_HUMANOID
	robust_searching = 1
	speak_chance = 5
	move_to_delay = 1
	base_constitution = 9
	base_strength = 14
	base_speed = 13
	maxHealth = 200
	health = 200
	harm_intent_damage = 15
	melee_damage_lower = 25
	melee_damage_upper = 30
	vision_range = 7
	aggro_vision_range = 9
	retreat_distance = 0
	minimum_distance = 0
	limb_destroyer = 1
	base_intents = list(/datum/intent/simple/axe)
	attack_verb_continuous = "hacks"
	attack_verb_simple = "hack"
	attack_sound = 'sound/blank.ogg'
	canparry = TRUE
	d_intent = INTENT_PARRY
	speak_emote = list("grunts")
	speak = list("WAAAGH!", "KRUSH AND KILL!", "Never should have come here!", "Slaughter them all!", "Kill everything!", "Hahaha! Die!")
	loot = list(/obj/effect/mob_spawn/human/orc/corpse/savageorc,
			/obj/item/weapon/axe/boneaxe,
			/obj/effect/decal/cleanable/blood)
	faction = list(FACTION_ORCS)
	footstep_type = FOOTSTEP_MOB_BAREFOOT
	del_on_death = TRUE
	ai_controller = /datum/ai_controller/orc

/mob/living/simple_animal/hostile/orc/Initialize()
	. = ..()
	AddComponent(/datum/component/ai_aggro_system)

/mob/living/simple_animal/hostile/orc/orc2
	icon_state = "savageorc2"
	icon_living = "savageorc2"
	icon_dead = "savageorc2"
	loot = list(/obj/effect/mob_spawn/human/orc/corpse/savageorc2,
			/obj/item/weapon/axe/boneaxe,
			/obj/effect/decal/cleanable/blood)

/mob/living/simple_animal/hostile/orc/orc_marauder
	name = "Orc Marauder"
	icon_state = "orcmarauder"
	icon_living = "orcmarauder"
	icon_dead = "orcmarauder"
	melee_damage_lower = 30
	melee_damage_upper = 35
	armor_penetration = 35
	maxHealth = 200
	health = 200
	loot = list(/obj/effect/mob_spawn/human/orc/corpse/orcmarauder,
			/obj/item/weapon/sword/scimitar/messer,
			/obj/effect/decal/cleanable/blood)

/mob/living/simple_animal/hostile/orc/orc_marauder/spear
	icon_state = "orcmarauder_spear"
	icon_living = "orcmarauder_spear"
	icon_dead = "orcmarauder_spear"
	base_intents = list(/datum/intent/simple/spear)
	loot = list(/obj/effect/mob_spawn/human/orc/corpse/orcmarauder,
			/obj/item/weapon/polearm/spear,
			/obj/effect/decal/cleanable/blood)

/mob/living/simple_animal/hostile/orc/orc_marauder/ravager
	icon_state = "orcravager"
	icon_living = "orcravager"
	icon_dead = "orcravager"
	melee_damage_lower = 40
	melee_damage_upper = 50
	armor_penetration = 40
	maxHealth = 500
	health = 500
	loot = list(/obj/effect/mob_spawn/human/orc/corpse/orcravager,
			/obj/item/weapon/polearm/halberd/bardiche,
			/obj/effect/decal/cleanable/blood)

/mob/living/simple_animal/hostile/orc/spear
	icon_state = "savageorc_spear"
	icon_living = "savageorc_spear"
	icon_dead = "savageorc_spear"
	base_intents = list(/datum/intent/simple/spear)
	melee_damage_lower = 30
	melee_damage_upper = 30
	armor_penetration = 35
	attack_verb_continuous = list("stabs", "slashes", "skewers")
	attack_verb_simple = "stab"
	attack_sound = 'sound/blank.ogg'
	loot = list(/obj/effect/mob_spawn/human/orc/corpse/savageorc,
			/obj/item/weapon/polearm/spear/bonespear,
			/obj/effect/decal/cleanable/blood)
	footstep_type = FOOTSTEP_MOB_BAREFOOT

/mob/living/simple_animal/hostile/orc/spear2
	icon_state = "savageorc_spear2"
	icon_living = "savageorc_spear2"
	icon_dead = "savageorc_spear2"
	loot = list(/obj/effect/mob_spawn/human/orc/corpse/savageorc2,
			/obj/item/weapon/polearm/spear/bonespear,
			/obj/effect/decal/cleanable/blood)

/mob/living/simple_animal/hostile/orc/get_sound(input)
	switch(input)
		if("aggro")
			return pick('sound/vo/mobs/simple_orcs/orc_yell.ogg','sound/vo/mobs/simple_orcs/orc_yell2.ogg','sound/vo/mobs/simple_orcs/orc_yell3.ogg', 'sound/vo/mobs/simple_orcs/orc_yell4.ogg')
		if("pain")
			return pick('sound/vo/mobs/simple_orcs/orc_pain.ogg','sound/vo/mobs/simple_orcs/orc_pain2.ogg','sound/vo/mobs/simple_orcs/orc_pain3.ogg', 'sound/vo/mobs/simple_orcs/orc_pain4.ogg')
		if("death")
			return pick('sound/vo/mobs/simple_orcs/orc_death.ogg','sound/vo/mobs/simple_orcs/orc_death2.ogg','sound/vo/mobs/simple_orcs/orc_death3.ogg','sound/vo/mobs/simple_orcs/orc_death4.ogg','sound/vo/mobs/simple_orcs/orc_death5.ogg',
			'sound/vo/mobs/simple_orcs/orc_death6.ogg')
		if("idle")
			return pick('sound/vo/mobs/simple_orcs/orc_idle.ogg','sound/vo/mobs/simple_orcs/orc_idle2.ogg','sound/vo/mobs/simple_orcs/orc_idle3.ogg','sound/vo/mobs/simple_orcs/orc_idle4.ogg')

/mob/living/simple_animal/hostile/orc/Life()
	. = ..()
	if(!target)
		if(prob(3))
			emote(pick("idle"), TRUE)

/mob/living/simple_animal/hostile/orc/taunted(mob/user)
	emote("aggro")
	return

/mob/living/simple_animal/hostile/orc/simple_limb_hit(zone)
	return ..()

/obj/projectile/bullet/reusable/arrow/orc
	damage = 20
	damage_type = BRUTE
	armor_penetration = 40
	icon = 'icons/roguetown/weapons/ammo.dmi'
	icon_state = "arrow_proj"
	ammo_type = /obj/item/ammo_casing/caseless/arrow
	range = 15
	hitsound = 'sound/combat/hits/hi_arrow2.ogg'
	embedchance = 100
	woundclass = BCLASS_STAB
	flag =  "piercing"
	speed = 0.2

/mob/living/simple_animal/hostile/orc/ranged
	name = "savage orc archer"
	desc = ""
	icon_state = "orcbow"
	icon_living = "orcbow"
	icon_dead = "orcbow"
	projectiletype = /obj/projectile/bullet/reusable/arrow/orc
	projectilesound = 'sound/combat/Ranged/flatbow-shot-01.ogg'
	ranged = 1
	retreat_distance = 2
	minimum_distance = 5
	ranged_cooldown_time = 60
	loot = list(/obj/effect/mob_spawn/human/orc/corpse/savageorc2,
			/obj/item/gun/ballistic/revolver/grenadelauncher/bow,
			/obj/item/ammo_casing/caseless/arrow = 3,
			/obj/effect/decal/cleanable/blood)
	maxHealth = 100
	health = 100
	ai_controller = /datum/ai_controller/orc_ranged
