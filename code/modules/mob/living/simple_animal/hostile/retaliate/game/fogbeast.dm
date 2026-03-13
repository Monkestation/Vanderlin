GLOBAL_LIST_INIT(valid_honse_colors, list("White" = COLOR_WHITE, "Gray" = COLOR_GRAY, "Black" = COLOR_ALMOST_BLACK, "Brown" = COLOR_DARK_BROWN, "Chestnut" = COLOR_DARK_ORANGE))

/mob/living/simple_animal/hostile/retaliate/honse
	name = "honse mare"
	desc = "A distant cousin to the saiga, hailing from the mysterious islands of Kaizoku - rarer, but more strongly valued. Extensively used in the Steppes of Aavnr as pack animals and combat mounts."
	icon = 'icons/mob/monster/fogbeast.dmi'
	icon_state = "fogbeast"
	icon_living = "fogbeast"
	icon_dead = "fogbeast_dead"
	icon_gib = "saiga_gib"
	mob_biotypes = MOB_ORGANIC|MOB_BEAST
	emote_see = list("looks around.", "chews some leaves.", "neighs")
	speak_chance = 1
	see_in_dark = 6
	move_to_delay = 8
	butcher_results = list(
		/obj/item/reagent_containers/food/snacks/meat/steak = 4,
		/obj/item/reagent_containers/food/snacks/fat = 2,
		/obj/item/natural/hide = 4,
		/obj/item/natural/bundle/bone/full = 1
	)
	base_intents = list(/datum/intent/simple/honse)
	animal_species = /mob/living/simple_animal/hostile/retaliate/honse/male
	health = 380
	maxHealth = 380
	food_type = list(
		/obj/item/reagent_containers/food/snacks/produce/grain/wheat,
		/obj/item/reagent_containers/food/snacks/produce/grain/oat,
		/obj/item/reagent_containers/food/snacks/produce/fruit/apple
		)
	tame_chance = 15
	bonus_tame_chance = 15
	footstep_type = FOOTSTEP_MOB_SHOE
	pooptype = /obj/item/natural/poo/horse
	faction = list("horse")
	attack_verb_continuous = "tramples"
	attack_verb_simple = "kicks"
	melee_damage_lower = 50
	melee_damage_upper = 70
	retreat_distance = 0
	minimum_distance = 10
	base_speed = 15
	base_constitution = 8
	base_strength = 12
	base_endurance = 15
	pixel_x = -8
	attack_sound = list('sound/vo/mobs/saiga/attack (1).ogg','sound/vo/mobs/saiga/attack (2).ogg')
	can_buckle = TRUE
	buckle_lying = 0
	can_saddle = TRUE
	aggressive = TRUE
	remains_type = /obj/effect/decal/remains/saiga
	ai_controller = /datum/ai_controller/saiga
	generate_genetics = TRUE
	genetics = /datum/animal_genetics/honse
	var/honse_color
	var/can_breed = TRUE

/mob/living/simple_animal/hostile/retaliate/honse/Initialize(mapload)
	. = ..()

	if(can_breed)
		AddComponent(\
			/datum/component/breed,\
			list(/mob/living/simple_animal/hostile/retaliate/honse),\
			3 MINUTES,\
			list(/mob/living/simple_animal/hostile/retaliate/honse/kid = 70, /mob/living/simple_animal/hostile/retaliate/honse/kid/male = 30),\
			CALLBACK(src, PROC_REF(after_birth)),\
		)

/mob/living/simple_animal/hostile/retaliate/honse/tame
	tame = TRUE

/mob/living/simple_animal/hostile/retaliate/honse/tame/saddled/Initialize()
	. = ..()
	var/obj/item/natural/saddle/S = new(src)
	ssaddle = S
	update_icon()

// BEHAVIORS
/mob/living/simple_animal/hostile/retaliate/honse/update_icon()
	cut_overlays()
	..()
	if(stat != DEAD)
		if(ssaddle)
			var/mutable_appearance/saddlet = mutable_appearance(icon, "saddle-above", 4.3)
			saddlet.appearance_flags = RESET_ALPHA|RESET_COLOR
			add_overlay(saddlet)
			saddlet = mutable_appearance(icon, "saddle")
			saddlet.appearance_flags = RESET_ALPHA|RESET_COLOR
			add_overlay(saddlet)
		if(has_buckled_mobs())
			var/mutable_appearance/mounted = mutable_appearance(icon, "[icon_state]_mounted", 4.3)
			add_overlay(mounted)


/mob/living/simple_animal/hostile/retaliate/honse/get_sound(input)
	switch(input)
		if("aggro")
			return pick('sound/vo/mobs/saiga/attack (1).ogg','sound/vo/mobs/saiga/attack (2).ogg')
		if("pain")
			return pick('sound/vo/mobs/saiga/pain (1).ogg','sound/vo/mobs/saiga/pain (2).ogg','sound/vo/mobs/saiga/pain (3).ogg')
		if("death")
			return pick('sound/vo/mobs/saiga/death (1).ogg','sound/vo/mobs/saiga/death (2).ogg')
		if("idle")
			return pick('sound/vo/mobs/saiga/idle (1).ogg','sound/vo/mobs/saiga/idle (2).ogg','sound/vo/mobs/saiga/idle (3).ogg','sound/vo/mobs/saiga/idle (4).ogg','sound/vo/mobs/saiga/idle (5).ogg','sound/vo/mobs/saiga/idle (6).ogg','sound/vo/mobs/saiga/idle (7).ogg')


/mob/living/simple_animal/hostile/retaliate/honse/tamed()
	..()
	deaggroprob = 20
	if(can_buckle)
		AddComponent(/datum/component/riding/saiga)

/mob/living/simple_animal/hostile/retaliate/honse/death()
	unbuckle_all_mobs()
	return ..()

/mob/living/simple_animal/hostile/retaliate/honse/simple_limb_hit(zone)
	if(!zone)
		return ""
	switch(zone)
		if(BODY_ZONE_PRECISE_R_EYE)
			return "head"
		if(BODY_ZONE_PRECISE_L_EYE)
			return "head"
		if(BODY_ZONE_PRECISE_NOSE)
			return "snout"
		if(BODY_ZONE_PRECISE_MOUTH)
			return "snout"
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

/// If we're a mount and are hit while sprinting, throw our rider off
/// Also called if the rider is hit
/mob/living/simple_animal/hostile/retaliate/honse/proc/check_sprint_dismount()
	SIGNAL_HANDLER
	for(var/mob/living/carbon/human/rider in buckled_mobs)
		if(rider.m_intent == MOVE_INTENT_RUN)
			var/rider_skill = rider.get_skill_level(/datum/skill/misc/riding)
			if(rider_skill < SKILL_LEVEL_MASTER)
				violent_dismount(rider)

/mob/living/simple_animal/hostile/retaliate/honse/post_buckle_mob(mob/living/M)
	. = ..()
	RegisterSignal(M, COMSIG_MOB_APPLY_DAMGE, PROC_REF(check_sprint_dismount))
	if(!has_buckled_mobs())
		RegisterSignal(src, COMSIG_MOB_APPLY_DAMGE, PROC_REF(check_sprint_dismount))

/mob/living/simple_animal/hostile/retaliate/honse/post_unbuckle_mob(mob/living/M)
	. = ..()
	UnregisterSignal(M, COMSIG_MOB_APPLY_DAMGE, PROC_REF(check_sprint_dismount))
	if(!has_buckled_mobs())
		UnregisterSignal(src, COMSIG_MOB_APPLY_DAMGE, PROC_REF(check_sprint_dismount))

/obj/effect/decal/remains/honse
	name = "remains"
	desc = "The remains of a once-proud honse. Perhaps it was killed for food, or slain in battle with a valiant knight atop?"
	gender = PLURAL
	icon_state = "skele"
	icon = 'icons/mob/monster/fogbeast.dmi'

/mob/living/simple_animal/hostile/retaliate/honse/male
	name = "honse stallion"
	gender = MALE

/mob/living/simple_animal/hostile/retaliate/honse/male/tame
	tame = TRUE

/mob/living/simple_animal/hostile/retaliate/honse/male/tame/saddled/Initialize()
	. = ..()
	var/obj/item/natural/saddle/S = new(src)
	ssaddle = S
	update_icon()

// FOAL
/mob/living/simple_animal/hostile/retaliate/honse/kid
	name = "honse filly"
	desc = "A young honse, likely to be running around with its mother. Honses are a distant cousin to the saiga, hailing from the mysterious islands of Kaizoku - rarer, but more strongly valued. Extensively used in the Steppes of Aavnr as pack animals and combat mounts."
	icon = 'icons/mob/monster/fogbeast.dmi'
	icon_state = "foggie"
	icon_living = "foggie"
	icon_dead = "foggie_dead"
	icon_gib = "foggie_dead"
	animal_species = null
	emote_see = list("looks around.", "chews some leaves.", "neighs", "hops about playfully")
	animal_species = null
	butcher_results = list(/obj/item/reagent_containers/food/snacks/meat/steak = 1, /obj/item/alch/bone = 3)
	health = 20
	maxHealth = 20
	pass_flags = PASSTABLE | PASSMOB
	mob_size = MOB_SIZE_SMALL
	melee_damage_lower = 1
	melee_damage_upper = 6
	base_constitution = 5
	base_strength = 5
	base_speed = 5
	adult_growth = /mob/living/simple_animal/hostile/retaliate/honse
	tame = TRUE
	can_buckle = FALSE
	can_saddle = FALSE
	aggressive = TRUE
	ai_controller = /datum/ai_controller/saiga_kid
	can_breed = FALSE
	generate_genetics = FALSE

/mob/living/simple_animal/hostile/retaliate/honse/kid/male
	name = "honse colt"
	adult_growth = /mob/living/simple_animal/hostile/retaliate/honse/male

// INTENT
/datum/intent/simple/honse
	name = "horse"
	icon_state = "instrike"
	attack_verb = list("tramples", "rams", "kicks")
	animname = "blank22"
	blade_class = BCLASS_BLUNT
	hitsound = "punch_hard"
	chargetime = 0
	penfactor = 10
	swingdelay = 0
	candodge = TRUE
	canparry = TRUE
	item_damage_type = "blunt"
	clickcd = CLICK_CD_MELEE * 1.1
