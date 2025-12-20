/mob/living/carbon/human/species/skeleton
	name = "skeleton"
	icon = 'icons/roguetown/mob/monster/skeletons.dmi'
	icon_state = MAP_SWITCH("", "skeleton")
	race = /datum/species/human/northern
	gender = MALE
	bodyparts = list(/obj/item/bodypart/chest, /obj/item/bodypart/head, /obj/item/bodypart/l_arm,
					/obj/item/bodypart/r_arm, /obj/item/bodypart/r_leg, /obj/item/bodypart/l_leg)
	faction = list(FACTION_UNDEAD)
	var/skel_outfit = /datum/outfit/npc/skeleton
	ambushable = FALSE
	rot_type = null
	base_intents = list(INTENT_HELP, INTENT_DISARM, INTENT_GRAB, /datum/intent/unarmed/claw)
	a_intent = INTENT_HELP
	possible_mmb_intents = list(INTENT_STEAL, INTENT_JUMP, INTENT_KICK, INTENT_BITE)
	possible_rmb_intents = list(/datum/rmb_intent/feint, /datum/rmb_intent/aimed, /datum/rmb_intent/strong, /datum/rmb_intent/weak)
	stand_attempts = 4
	cmode_music = 'sound/music/cmode/antag/combatskeleton.ogg'
	var/should_have_aggro = TRUE

/mob/living/carbon/human/species/skeleton/npc/no_equipment
	skel_outfit = null

/mob/living/carbon/human/species/skeleton/no_equipment
	skel_outfit = null

/mob/living/carbon/human/species/skeleton/npc
	ai_controller = /datum/ai_controller/human_npc
	simpmob_attack = 40
	simpmob_defend = 0
	wander = TRUE
	attack_speed = -10

/mob/living/carbon/human/species/skeleton/Initialize()
	. = ..()
	if(ai_controller && should_have_aggro)
		AddComponent(/datum/component/ai_aggro_system)
	addtimer(CALLBACK(src, PROC_REF(after_creation)), 1 SECONDS)

/mob/living/carbon/human/species/skeleton/after_creation()
	..()
	name = "skeleton"
	real_name = "skeleton"
	underwear = "Nude"
	mob_biotypes = MOB_UNDEAD
	faction = list(FACTION_UNDEAD)
	var/turf/turf = get_turf(src)
	if(SSterrain_generation.get_island_at_location(turf))
		faction |= "islander"
	if(charflaw)
		QDEL_NULL(charflaw)
	if(dna?.species)
		dna.species.species_traits |= NOBLOOD
		dna.species.soundpack_m = new /datum/voicepack/skeleton()
		dna.species.soundpack_f = new /datum/voicepack/skeleton()
		var/obj/item/bodypart/head/headdy = get_bodypart("head")
		if(headdy)
			headdy.icon = 'icons/roguetown/mob/monster/skeletons.dmi'
			headdy.icon_state = "skull"
			headdy.headprice = rand(5,15)
			headdy.sellprice = rand(5,15)
	for(var/obj/item/bodypart/B as anything in bodyparts)
		B.skeletonize(FALSE)
	grant_undead_eyes()
	update_body()
	ADD_TRAIT(src, TRAIT_NOMOOD, TRAIT_GENERIC)
	ADD_TRAIT(src, TRAIT_NOHUNGER, TRAIT_GENERIC)
	ADD_TRAIT(src, TRAIT_NOBREATH, TRAIT_GENERIC)
	ADD_TRAIT(src, TRAIT_NOHYGIENE, TRAIT_GENERIC)
	ADD_TRAIT(src, TRAIT_NOPAIN, TRAIT_GENERIC)
	ADD_TRAIT(src, TRAIT_NOSLEEP, TRAIT_GENERIC)
	ADD_TRAIT(src, TRAIT_EASYDISMEMBER, TRAIT_GENERIC)
	ADD_TRAIT(src, TRAIT_TOXIMMUNE, TRAIT_GENERIC)
	ADD_TRAIT(src, TRAIT_LIMBATTACHMENT, TRAIT_GENERIC)
	ADD_TRAIT(src, TRAIT_CRITICAL_WEAKNESS, TRAIT_GENERIC)
	if(skel_outfit)
		var/datum/outfit/OU = new skel_outfit
		if(OU)
			equipOutfit(OU)

/datum/outfit/npc/skeleton/random/pre_equip(mob/living/carbon/human/H)
	..()
	H.base_strength = 6
	H.base_speed = 10
	H.base_constitution = 8
	H.base_endurance = 8
	H.base_intelligence = 1
	H.recalculate_stats(FALSE)

/datum/outfit/greater_skeleton/pre_equip(mob/living/carbon/human/H) //equipped onto Summon Greater Undead player skeletons only after the mind is added
	..()
	wrists = /obj/item/clothing/wrists/bracers/leather
	armor = /obj/item/clothing/armor/chainmail/iron
	shirt = /obj/item/clothing/shirt/undershirt/colored/vagrant
	pants = /obj/item/clothing/pants/chainlegs/iron
	head = /obj/item/clothing/head/helmet/leather
	shoes = /obj/item/clothing/shoes/boots

	H.base_strength = rand(14,16)
	H.base_speed = 8
	H.base_constitution = 9
	H.base_endurance = 15
	H.base_intelligence = 1
	H.recalculate_stats(FALSE)

	//light labor skills for skeleton manual labor and some warrior-adventurer skills, equipment is still bad probably
	H.adjust_skillrank(/datum/skill/craft/carpentry, 1, TRUE)
	H.adjust_skillrank(/datum/skill/craft/masonry, 1, TRUE)
	H.adjust_skillrank(/datum/skill/craft/crafting, 1, TRUE)
	H.adjust_skillrank(/datum/skill/misc/sewing, 1, TRUE)

	H.adjust_skillrank(/datum/skill/combat/polearms, 3, TRUE)
	H.adjust_skillrank(/datum/skill/combat/axesmaces, 3, TRUE)
	H.adjust_skillrank(/datum/skill/combat/wrestling, 2, TRUE)
	H.adjust_skillrank(/datum/skill/combat/unarmed, 2, TRUE)
	H.adjust_skillrank(/datum/skill/misc/athletics, 4, TRUE)
	H.adjust_skillrank(/datum/skill/combat/swords, 3, TRUE)
	H.adjust_skillrank(/datum/skill/combat/shields, 2, TRUE)
	H.adjust_skillrank(/datum/skill/combat/knives, 3, TRUE)
	H.adjust_skillrank(/datum/skill/misc/climbing, 2, TRUE)

	H.set_patron(/datum/patron/inhumen/zizo)
	ADD_TRAIT(H, TRAIT_HEAVYARMOR, TRAIT_GENERIC)

	H.possible_rmb_intents = list(/datum/rmb_intent/feint,\
	/datum/rmb_intent/aimed,\
	/datum/rmb_intent/strong,\
	/datum/rmb_intent/swift,\
	/datum/rmb_intent/riposte,\
	/datum/rmb_intent/weak)
	H.swap_rmb_intent(num=1) //dont want to mess with base NPCs too much out of fear of breaking them so I assigned the intents in the outfit

	if(prob(50))
		r_hand = /obj/item/weapon/sword
	else
		r_hand = /obj/item/weapon/polearm/halberd/bardiche/woodcutter

///////////////////////////////////////////////////////////// EVENTMIN SKELETONGS

/mob/living/carbon/human/species/skeleton/npc/peasant/after_creation()
	..()
	ADD_TRAIT(src, TRAIT_NOMOOD, TRAIT_GENERIC)
	ADD_TRAIT(src, TRAIT_NOHUNGER, TRAIT_GENERIC)
	ADD_TRAIT(src, TRAIT_EASYDISMEMBER, TRAIT_GENERIC)
	ADD_TRAIT(src, TRAIT_CRITICAL_WEAKNESS, TRAIT_GENERIC)
	equipOutfit(new /datum/outfit/species/skeleton/npc/peasant)
	dodgetime = 15
	canparry = TRUE
	flee_in_pain = FALSE
	wander = TRUE

/datum/outfit/species/skeleton/npc/peasant/pre_equip(mob/living/carbon/human/H)
	..()
	H.base_strength = 6
	H.base_speed = 8
	H.base_constitution = 8
	H.base_endurance = 8
	H.recalculate_stats(FALSE)
	var/loadout = rand(1,7)
	head = /obj/item/clothing/head/roguehood/colored/random
	pants = /obj/item/clothing/pants/tights/colored/vagrant
	shirt = /obj/item/clothing/shirt/undershirt/colored/vagrant
	switch(loadout)
		if(1) //Axe Warrior
			r_hand = /obj/item/weapon/axe/iron
			wrists = /obj/item/clothing/wrists/bracers/leather
			head = /obj/item/clothing/head/knitcap
		if(2) //Long Stick Fighter
			r_hand = /obj/item/weapon/polearm/woodstaff
		if(3) //Club Caveman
			r_hand = /obj/item/weapon/mace/woodclub
		if(4) //Stabbity Stabbity your Knight is now horizontality
			r_hand =/obj/item/weapon/pitchfork
			head = /obj/item/clothing/head/strawhat
		if(5) //Bonk Build
			r_hand = /obj/item/weapon/thresher
			wrists = /obj/item/clothing/wrists/bracers/leather
		if(6) //Bonk Build
			r_hand = /obj/item/weapon/hoe
			head = /obj/item/clothing/head/fisherhat
		if(7) //Ex Wife
			r_hand = /obj/item/cooking/pan
			head = /obj/item/clothing/head/armingcap
			shirt = /obj/item/clothing/shirt/dress/gen/colored/brown


///////////////////////////////////////////////////////////// EVENTMIN SKELETONGS
/mob/living/carbon/human/species/skeleton/npc/ambush/after_creation()
	..()
	ADD_TRAIT(src, TRAIT_NOMOOD, TRAIT_GENERIC)
	ADD_TRAIT(src, TRAIT_NOHUNGER, TRAIT_GENERIC)
	ADD_TRAIT(src, TRAIT_HEAVYARMOR, TRAIT_GENERIC)
	ADD_TRAIT(src, TRAIT_EASYDISMEMBER, TRAIT_GENERIC)
	ADD_TRAIT(src, TRAIT_CRITICAL_WEAKNESS, TRAIT_GENERIC)
	equipOutfit(new /datum/outfit/species/skeleton/npc/random)
	dodgetime = 15
	canparry = TRUE
	flee_in_pain = FALSE
	wander = TRUE

/datum/outfit/species/skeleton/npc/random/pre_equip(mob/living/carbon/human/H)
	..()
	if(prob(50))
		wrists = /obj/item/clothing/wrists/bracers/leather
	if(prob(50))
		armor = /obj/item/clothing/armor/chainmail/iron
	if(prob(30))
		shirt = /obj/item/clothing/shirt/undershirt/colored/vagrant
	if(prob(50))
		pants = /obj/item/clothing/pants/tights/colored/vagrant
	if(prob(50))
		head = /obj/item/clothing/head/helmet/leather
	if(prob(50))
		head = /obj/item/clothing/head/roguehood/colored/random
	if(prob(50))
		r_hand = /obj/item/weapon/sword/iron
	else
		r_hand = /obj/item/weapon/mace/woodclub

///////////////////////////////////////////////////////////// EVENTMIN SKELETONGS

/mob/living/carbon/human/species/skeleton/npc/warrior/after_creation()
	..()
	ADD_TRAIT(src, TRAIT_NOMOOD, TRAIT_GENERIC)
	ADD_TRAIT(src, TRAIT_NOHUNGER, TRAIT_GENERIC)
	ADD_TRAIT(src, TRAIT_HEAVYARMOR, TRAIT_GENERIC)
	ADD_TRAIT(src, TRAIT_EASYDISMEMBER, TRAIT_GENERIC)
	ADD_TRAIT(src, TRAIT_CRITICAL_WEAKNESS, TRAIT_GENERIC)
	equipOutfit(new /datum/outfit/species/skeleton/npc/warrior)
	dodgetime = 15
	canparry = TRUE
	flee_in_pain = FALSE
	wander = TRUE

/datum/outfit/species/skeleton/npc/warrior/pre_equip(mob/living/carbon/human/H)
	..()
	H.base_strength = 10
	H.base_speed = 7
	H.base_constitution = 10
	H.base_endurance = 10
	H.recalculate_stats(FALSE)
	shirt = /obj/item/clothing/shirt/undershirt/colored/vagrant
	pants = /obj/item/clothing/pants/tights/colored/vagrant
	neck = /obj/item/clothing/neck/chaincoif
	armor = /obj/item/clothing/armor/chainmail/iron
	wrists = /obj/item/clothing/wrists/bracers/leather
	var/loadout = rand(1,6)
	switch(loadout)
		if(1) //Skeleton Warrior
			r_hand = /obj/item/weapon/sword/iron
			l_hand = /obj/item/weapon/shield/wood
			belt = /obj/item/storage/belt/leather
			head = /obj/item/clothing/head/helmet/kettle
		if(2)//Skeleton Warrior
			r_hand = /obj/item/weapon/mace
			l_hand = /obj/item/weapon/shield/wood
			belt = /obj/item/storage/belt/leather
			head = /obj/item/clothing/head/helmet/kettle
		if(3) //Skeleton Warrior
			r_hand = /obj/item/weapon/flail
			l_hand = /obj/item/weapon/shield/wood
			belt = /obj/item/storage/belt/leather
			head = /obj/item/clothing/head/helmet/skullcap
		if(4) //Skeleton Warrior
			r_hand =/obj/item/weapon/polearm/spear
			head = /obj/item/clothing/head/helmet/kettle
		if(5) //Skeleton Warrior
			r_hand = /obj/item/weapon/sword/sabre
			l_hand = /obj/item/weapon/knife/dagger
			head = /obj/item/clothing/head/helmet/kettle
		if(6) //Skeleton Warrior
			r_hand = /obj/item/weapon/sword/scimitar/messer
			l_hand = /obj/item/weapon/knife/dagger
			head = /obj/item/clothing/head/helmet/skullcap


/mob/living/carbon/human/species/skeleton/npc/warrior/skilled/after_creation()
	..()
	ADD_TRAIT(src, TRAIT_NOMOOD, TRAIT_GENERIC)
	ADD_TRAIT(src, TRAIT_NOHUNGER, TRAIT_GENERIC)
	ADD_TRAIT(src, TRAIT_HEAVYARMOR, TRAIT_GENERIC)
	equipOutfit(new /datum/outfit/species/skeleton/npc/warrior)
	d_intent = INTENT_PARRY //these ones will parry instead of dodge, making them much more dangerous
	canparry = TRUE
	flee_in_pain = FALSE
	wander = TRUE
	configure_mind()

/mob/living/carbon/human/species/skeleton/npc/warrior/skilled/proc/configure_mind()
	if(!mind)
		mind = new /datum/mind(src)

	adjust_skillrank(/datum/skill/combat/polearms, 3, TRUE)
	adjust_skillrank(/datum/skill/combat/swords, 3, TRUE)
	adjust_skillrank(/datum/skill/combat/wrestling, 3, TRUE)
	adjust_skillrank(/datum/skill/combat/unarmed, 3, TRUE)
	adjust_skillrank(/datum/skill/combat/knives, 3, TRUE)
	adjust_skillrank(/datum/skill/combat/axesmaces, 3, TRUE)
	adjust_skillrank(/datum/skill/combat/shields, 3, TRUE)

/mob/living/carbon/human/species/skeleton/death_arena
	should_have_aggro = FALSE

/mob/living/carbon/human/species/skeleton/death_arena/after_creation()
	..()
	equipOutfit(new /datum/outfit/arena_skeleton)
	ADD_TRAIT(src, TRAIT_CRITICAL_WEAKNESS, TRAIT_GENERIC)
	ADD_TRAIT(src, TRAIT_NOLIMBDISABLE, TRAIT_GENERIC)

	base_strength = 20
	base_speed = 10
	base_constitution = 8
	base_endurance = 8
	base_intelligence = 1

/mob/living/carbon/human/species/skeleton/death_arena/roll_mob_stats()
	return
