GLOBAL_LIST_EMPTY(rousman_ambush_objects)

/mob/living/carbon/human/species/rousman
	name = "rousman"
	icon = 'icons/roguetown/mob/monster/rousman.dmi'
	icon_state = "rousman"
	race = /datum/species/rousman
	gender = MALE
	bodyparts = list(/obj/item/bodypart/chest/rousman, /obj/item/bodypart/head/rousman, /obj/item/bodypart/l_arm/rousman,
					/obj/item/bodypart/r_arm/rousman, /obj/item/bodypart/r_leg/rousman, /obj/item/bodypart/l_leg/rousman)
	rot_type = /datum/component/rot/corpse/rousman
	ambushable = FALSE
	base_intents = list(INTENT_STEAL, INTENT_HELP, INTENT_DISARM, /datum/intent/unarmed/claw, /datum/intent/simple/bite, /datum/intent/jump)
	possible_rmb_intents = list()
	bloodpool = 200

/mob/living/carbon/human/species/rousman/Initialize()
	. = ..()
	update_appearance(UPDATE_OVERLAYS)

/mob/living/carbon/human/species/rousman/death(gibbed)
	. = ..()
	update_appearance(UPDATE_OVERLAYS)

/mob/living/carbon/human/species/rousman/update_overlays()
	. = ..()
	if(stat == DEAD)
		return
	. += emissive_appearance('icons/roguetown/mob/monster/rousman.dmi', "rousman_eyes", alpha = src.alpha)

/mob/living/carbon/human/species/rousman/npc
	ai_controller = /datum/ai_controller/human_npc
	dodgetime = 13
	canparry = TRUE
	flee_in_pain = TRUE
	wander = FALSE

/mob/living/carbon/human/species/rousman/npc/Initialize()
	. = ..()
	AddComponent(/datum/component/ai_aggro_system)
	AddComponent(/datum/component/combat_noise, list("scream" = 5, "laugh" = 1))

/mob/living/carbon/human/species/rousman/ambush
	ai_controller = /datum/ai_controller/human_npc

/mob/living/carbon/human/species/rousman/ambush/after_creation()
	. = ..()
	AddComponent(/datum/component/ai_aggro_system)
	job = "Ambusher Rousman"
	ADD_TRAIT(src, TRAIT_NOMOOD, TRAIT_GENERIC)
	ADD_TRAIT(src, TRAIT_NOHUNGER, TRAIT_GENERIC)
	equipOutfit(new /datum/outfit/npc/rousman/ambush)
	dodgetime = 13
	canparry = TRUE
	flee_in_pain = TRUE
	wander = TRUE

/////////////////////////////////////////////////////////////////////////////
/obj/item/bodypart/chest/rousman
	dismemberable = 1
	icon = 'icons/roguetown/mob/monster/rousman.dmi'
	icon_state = "rousman_chest"
/obj/item/bodypart/chest/rousman/update_icon_dropped()
	return
/obj/item/bodypart/chest/rousman/get_limb_icon(dropped, hideaux = FALSE)
	return

/obj/item/bodypart/l_arm/rousman
	dismemberable = 1
	icon = 'icons/roguetown/mob/monster/rousman.dmi'
	icon_state = "rousman_l_arm"
/obj/item/bodypart/l_arm/rousman/update_icon_dropped()
	return
/obj/item/bodypart/l_arm/rousman/get_limb_icon(dropped, hideaux = FALSE)
	return

/obj/item/bodypart/r_arm/rousman
	dismemberable = 1
	icon = 'icons/roguetown/mob/monster/rousman.dmi'
	icon_state = "rousman_r_arm"
/obj/item/bodypart/r_arm/rousman/update_icon_dropped()
	return
/obj/item/bodypart/r_arm/rousman/get_limb_icon(dropped, hideaux = FALSE)
	return

/obj/item/bodypart/r_leg/rousman
	dismemberable = 1
	icon = 'icons/roguetown/mob/monster/rousman.dmi'
	icon_state = "rousman_r_leg"
/obj/item/bodypart/r_leg/rousman/update_icon_dropped()
	return
/obj/item/bodypart/r_leg/rousman/get_limb_icon(dropped, hideaux = FALSE)
	return

/obj/item/bodypart/l_leg/rousman
	dismemberable = 1
	icon = 'icons/roguetown/mob/monster/rousman.dmi'
	icon_state = "rousman_l_leg"
/obj/item/bodypart/l_leg/rousman/update_icon_dropped()
	return
/obj/item/bodypart/l_leg/rousman/get_limb_icon(dropped, hideaux = FALSE)
	return
/////////////////////////////////////////////////////////////////////////////

/obj/item/bodypart/head/rousman/update_icon_dropped()
	return

/obj/item/bodypart/head/rousman/get_limb_icon(dropped, hideaux = FALSE)
	return

/obj/item/bodypart/head/rousman/getonmobprop(tag)
	if(tag)
		switch(tag)
			if("gen")
				return list("shrink" = 1,"sx" = -7,"sy" = -4,"nx" = 7,"ny" = -4,"wx" = -4,"wy" = -4,"ex" = 2,"ey" = -4,"nturn" = 0,"sturn" = 0,"wturn" = 0,"eturn" = 0,"nflip" = 0,"sflip" = 0,"wflip" = 0,"eflip" = 0,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0)
			if("wielded")
				return null
			if("altgrip")
				return null
			if("onbelt")
				return list("shrink" = 1,"sx" = -2,"sy" = -5,"nx" = 4,"ny" = -5,"wx" = 0,"wy" = -5,"ex" = 2,"ey" = -5,"nturn" = 0,"sturn" = 0,"wturn" = 0,"eturn" = 0,"nflip" = 0,"sflip" = 0,"wflip" = 0,"eflip" = 0,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0)
			if("onback")
				return list("shrink" = 1,"sx" = 1,"sy" = -1,"nx" = 1,"ny" = -1,"wx" = 4,"wy" = -1,"ex" = -1,"ey" = -1,"nturn" = 0,"sturn" = 0,"wturn" = 0,"eturn" = 0,"nflip" = 8,"sflip" = 0,"wflip" = 0,"eflip" = 0,"northabove" = 1,"southabove" = 0,"eastabove" = 0,"westabove" = 0)

/obj/item/bodypart/head/rousman/skeletonize()
	. = ..()
	icon_state = "rousman_skel_head"
	headprice = 2
	sellprice = 2


/datum/species/rousman
	name = "rousman"
	id = SPEC_ID_ROUSMAN
	species_traits = list(NO_UNDERWEAR)
	inherent_traits = list(TRAIT_RESISTCOLD,TRAIT_RESISTHIGHPRESSURE,TRAIT_RESISTLOWPRESSURE,TRAIT_RADIMMUNE, TRAIT_EASYDISMEMBER, TRAIT_CRITICAL_WEAKNESS, TRAIT_NASTY_EATER, TRAIT_LEECHIMMUNE, TRAIT_INHUMENCAMP)

	no_equip = list(ITEM_SLOT_SHIRT, ITEM_SLOT_MASK, ITEM_SLOT_GLOVES, ITEM_SLOT_SHOES, ITEM_SLOT_PANTS)
	offset_features_m = list(OFFSET_HANDS = list(0,-4))
	offset_features_f = list(OFFSET_HANDS = list(0,-4))
	dam_icon_f = null
	dam_icon_m = null
	damage_overlay_type = ""
	changesource_flags = WABBAJACK
	var/raceicon = "rousman"
	exotic_bloodtype = /datum/blood_type/human/corrupted/rousman

/datum/species/rousman/update_damage_overlays(mob/living/carbon/human/H)
	return

/datum/species/rousman/regenerate_icons(mob/living/carbon/human/H)
	H.icon_state = ""
	if(HAS_TRAIT(H, TRAIT_NO_TRANSFORM))
		return 1
	H.update_inv_hands()
	H.update_inv_handcuffed()
	H.update_inv_legcuffed()
	H.update_fire()
	H.update_body()
	var/mob/living/carbon/human/species/rousman/R = H
	R.update_wearable()
	H.update_transform()
	return TRUE

/mob/living/carbon/human/species/rousman/update_body()
	remove_overlay(BODY_LAYER)
	if(!dna || !dna.species)
		return
	var/datum/species/rousman/R = dna.species
	if(!istype(R))
		return
	icon_state = ""
	var/list/standing = list()
	var/mutable_appearance/body_overlay
	var/obj/item/bodypart/chesty = get_bodypart("chest")
	var/obj/item/bodypart/headdy = get_bodypart("head")
	if(!headdy)
		if(chesty && chesty.skeletonized)
			body_overlay = mutable_appearance(icon, "rousman_skel_decap", -BODY_LAYER)
		else
			body_overlay = mutable_appearance(icon, "[R.raceicon]_decap", -BODY_LAYER)
	else
		if(chesty && chesty.skeletonized)
			body_overlay = mutable_appearance(icon, "rousman_skel", -BODY_LAYER)
		else
			body_overlay = mutable_appearance(icon, "[R.raceicon]", -BODY_LAYER)

	if(body_overlay)
		standing += body_overlay
	if(standing.len)
		overlays_standing[BODY_LAYER] = standing

	apply_overlay(BODY_LAYER)
	dna.species.update_damage_overlays()

/mob/living/carbon/human/species/rousman/update_inv_head(hide_nonstandard = FALSE)
	update_wearable()
/mob/living/carbon/human/species/rousman/update_inv_armor()
	update_wearable()

/mob/living/carbon/human/species/rousman/Initialize()
	. = ..()
	addtimer(CALLBACK(src, PROC_REF(after_creation)), 1 SECONDS)

/mob/living/carbon/human/species/rousman/after_creation()
	..()
	gender = MALE
	if(src.dna && src.dna.species)
		src.dna.species.soundpack_m = new /datum/voicepack/rousman()
		src.dna.species.soundpack_f = new /datum/voicepack/rousman()
		var/obj/item/bodypart/head/headdy = get_bodypart("head")
		if(headdy)
			headdy.icon = 'icons/roguetown/mob/monster/rousman.dmi'
			headdy.icon_state = "[src.dna.species.id]_head"
			headdy.headprice = rand(7,20)
			headdy.sellprice = rand(7,20)
	var/obj/item/organ/eyes/eyes = src.getorganslot(ORGAN_SLOT_EYES)
	if(eyes)
		eyes.Remove(src,1)
		QDEL_NULL(eyes)
	eyes = new /obj/item/organ/eyes/night_vision/nightmare
	eyes.Insert(src)
	src.underwear = "Nude"
	if(src.charflaw)
		QDEL_NULL(src.charflaw)
	update_body()
	faction = list(FACTION_RATS)
	var/turf/turf = get_turf(src)
	if(SSterrain_generation.get_island_at_location(turf))
		faction |= "islander"
	name = "rousman"
	real_name = "rousman"
	ADD_TRAIT(src, TRAIT_NOMOOD, TRAIT_GENERIC)
	ADD_TRAIT(src, TRAIT_NOHUNGER, TRAIT_GENERIC)
	ADD_TRAIT(src, TRAIT_CRITICAL_WEAKNESS, TRAIT_GENERIC)

/datum/component/rot/corpse/rousman/process()
	var/amt2add = 10 //1 second
	var/time_elapsed = last_process ? (world.time - last_process)/10 : 1
	if(last_process)
		amt2add = ((world.time - last_process)/10) * amt2add
	last_process = world.time
	amount += amt2add
	if(has_world_trait(/datum/world_trait/pestra_mercy))
		amount -= (is_ascendant(PESTRA) ? 2.5 : 5) * time_elapsed

	var/mob/living/carbon/C = parent
	if(!C)
		qdel(src)
		return
	if(C.stat != DEAD)
		qdel(src)
		return
	var/should_update = FALSE
	if(amount > 20 MINUTES)
		for(var/obj/item/bodypart/B in C.bodyparts)
			if(!B.skeletonized)
				B.skeletonized = TRUE
				should_update = TRUE
	else if(amount > 12 MINUTES)
		for(var/obj/item/bodypart/B in C.bodyparts)
			if(!B.rotted)
				B.rotted = TRUE
				should_update = TRUE
			if(B.rotted && amount < 16 MINUTES && !(FACTION_MATTHIOS in C.faction))
				var/turf/open/T = C.loc
				if(istype(T))
					T.pollute_turf(/datum/pollutant/rot, 4)
	if(should_update)
		if(amount > 20 MINUTES)
			C.update_body()
			qdel(src)
			return
		else if(amount > 12 MINUTES)
			C.update_body()

/////////////////////
/////////////////////
////// Outfits //////
/////////////////////
/////////////////////

/datum/outfit/npc/rousman/ambush/pre_equip(mob/living/carbon/human/H)
	..()
	H.base_strength = rand(6, 10)
	H.base_perception = rand(6, 10)
	H.base_intelligence = rand(2, 5)
	H.base_constitution = rand(4, 8)
	H.base_endurance = rand(7, 10)
	H.base_speed = rand(10, 15)
	H.recalculate_stats(FALSE)

	var/loadout = rand(1,4)
	switch(loadout)
		if(1) //Grats, you got all the good armor
			armor = /obj/item/clothing/armor/cuirass/iron/rousman
			head = /obj/item/clothing/head/helmet/rousman
			ADD_TRAIT(H, TRAIT_HEAVYARMOR, TRAIT_GENERIC)
		if(2) //Plate armor with chance of getting a helm
			armor = /obj/item/clothing/armor/cuirass/iron/rousman
			ADD_TRAIT(H, TRAIT_HEAVYARMOR, TRAIT_GENERIC)
			if(prob(50))
				head = /obj/item/clothing/head/helmet/rousman
		if(3) //Helm with chance of getting plate armor
			if(prob(50))
				armor = /obj/item/clothing/armor/cuirass/iron/rousman
				ADD_TRAIT(H, TRAIT_HEAVYARMOR, TRAIT_GENERIC)
			else
				armor = /obj/item/clothing/armor/leather/hide/rousman
			head = /obj/item/clothing/head/helmet/rousman
		if(4) //Just a loincloth for you
			armor = /obj/item/clothing/armor/leather/hide/rousman

	var/weapons = rand(1,5)
	switch(weapons)
		if(1) //Sword and Shield
			r_hand = /obj/item/weapon/sword/iron
			l_hand = /obj/item/weapon/shield/wood
		if(2) //Daggers
			r_hand = /obj/item/weapon/knife/copper
			l_hand = /obj/item/weapon/knife/copper
		if(3) //Spear
			r_hand = /obj/item/weapon/polearm/spear
		if(4) //Flail
			r_hand = /obj/item/weapon/flail
		if(5) //Mace
			r_hand = /obj/item/weapon/mace/spiked

////////////////////////////
////////////////////////////
////// AMBUSH OBJECTS //////
////////////////////////////
////////////////////////////

/obj/structure/rousman_hole
	name = "narrow hole"
	desc = "Is that infernal squeaking coming from this?"
	icon = 'icons/roguetown/topadd/rousman/structures.dmi'
	icon_state = "rousman_hole_inactive"
	layer = BELOW_OBJ_LAYER
	density = FALSE
	anchored = TRUE
	max_integrity = 500
	destroy_sound = 'sound/combat/hits/onstone/stonedeath.ogg'
	attacked_sound = list('sound/combat/hits/onstone/wallhit.ogg','sound/combat/hits/onstone/wallhit2.ogg','sound/combat/hits/onstone/wallhit3.ogg')
	var/activate_range = 5 //The view range needed to activate rousman jumping out
	var/skulking_vermin = 3 //Number of potential mobs in the hole
	var/already_ambushed = FALSE
	var/list/all_alarms = list() //The alarms for this obj
	var/activated = FALSE
	var/try_activating_timer = 12 MINUTES  //Timer to recheck if this obj can activate

/obj/structure/rousman_hole/Initialize()
	. = ..()
	GLOB.rousman_ambush_objects |= src
	pre_activate_check()

/obj/structure/rousman_hole/Destroy()
	GLOB.rousman_ambush_objects -= src
	for(var/obj/structure/rousman_alarm/alarm as anything in all_alarms)
		QDEL_NULL(alarm)
	all_alarms.Cut()
	return ..()

/obj/structure/rousman_hole/proc/pre_activate_check()
	if(activated == TRUE && already_ambushed == TRUE)
		return
	for(var/obj/structure/rousman_hole/RH in GLOB.rousman_ambush_objects)
		if(RH.activated == TRUE && RH.already_ambushed == FALSE)
			//try again later
			addtimer(CALLBACK(src, PROC_REF(pre_activate_check)), try_activating_timer)
			return
	if(activated == FALSE && already_ambushed == FALSE && prob(50))
		//better luck next time, adds a bit of randomness
		addtimer(CALLBACK(src, PROC_REF(pre_activate_check)), try_activating_timer)
		return
	activated = TRUE
	icon_state = "rousman_hole_active"
	//activates the hole for ambushing
	for(var/turf/T in view(activate_range,src))
		var/obj/structure/rousman_alarm/alarm = new /obj/structure/rousman_alarm(T)
		all_alarms.Add(alarm)
		alarm.hole = src

/obj/structure/rousman_hole/proc/ambush(mob/living/carbon/human/ambushed_mob)
	if(already_ambushed == TRUE)
		return
	var/num_mobs = rand(1, skulking_vermin)
	for(var/i = 1; i <= num_mobs; i++)
		var/mob/living/carbon/human/species/rousman/ambush/A = new /mob/living/carbon/human/species/rousman/ambush(get_turf(src))
		A.del_on_deaggro = 1 MINUTES
		A.ai_controller?.set_blackboard_key(BB_BASIC_MOB_CURRENT_TARGET, ambushed_mob)
	ambushed_mob.playsound_local(ambushed_mob, pick('sound/misc/jumphumans (1).ogg','sound/misc/jumphumans (2).ogg','sound/misc/jumphumans (3).ogg','sound/misc/jumpscare (1).ogg','sound/misc/jumpscare (2).ogg','sound/misc/jumpscare (3).ogg','sound/misc/jumpscare (4).ogg'), 100)
	already_ambushed = TRUE
	icon_state = "rousman_hole_inactive"
	delete_alarms()

/obj/structure/rousman_hole/proc/delete_alarms()
	for(var/obj/structure/rousman_alarm/alarm in all_alarms)
		if(QDELETED(alarm))
			continue
		qdel(alarm)

/obj/structure/rousman_alarm
	name = ""
	desc = ""
	icon = 'icons/roguetown/topadd/rousman/structures.dmi'
	icon_state = ""
	layer = BELOW_OBJ_LAYER
	density = FALSE
	anchored = TRUE
	var/obj/structure/rousman_hole/hole

/obj/structure/rousman_alarm/Destroy()
	hole = null
	return ..()

/obj/structure/rousman_alarm/Crossed(atom/movable/AM)
	. = ..()
	if(istype(AM, /mob/living/carbon/human))
		var/mob/living/carbon/human/H = AM
		if(H.ambushable == TRUE && hole.already_ambushed == FALSE)
			hole.ambush(H)

////////////////////////////////
////////////////////////////////
////// Admin only rousmen //////
////////////////////////////////
////////////////////////////////

/mob/living/carbon/human/species/rousman/assassin
	ai_controller = /datum/ai_controller/human_npc

/mob/living/carbon/human/species/rousman/assassin/after_creation()
	. = ..()
	AddComponent(/datum/component/ai_aggro_system)
	job = "Assassin Rousman"
	ADD_TRAIT(src, TRAIT_NOMOOD, TRAIT_GENERIC)
	ADD_TRAIT(src, TRAIT_NOHUNGER, TRAIT_GENERIC)
	equipOutfit(new /datum/outfit/npc/rousman/assassin)
	dodgetime = 13
	canparry = TRUE
	flee_in_pain = TRUE
	wander = TRUE

/datum/outfit/npc/rousman/assassin/pre_equip(mob/living/carbon/human/H)
	..()

	H.base_strength = rand(6, 10)
	H.base_perception = rand(6, 10)
	H.base_intelligence = rand(2, 5)
	H.base_constitution = rand(4, 8)
	H.base_endurance = rand(7, 10)
	H.base_speed = rand(15, 20)
	H.recalculate_stats(FALSE)

	armor = /obj/item/clothing/armor/leather/advanced/rousman
	head = /obj/item/clothing/head/roguehood/rousman
	belt = /obj/item/storage/belt/leather/knifebelt/black/rous
	r_hand = /obj/item/weapon/knife/throwingknife/rous

	ADD_TRAIT(H, TRAIT_DODGEEXPERT, TRAIT_GENERIC)
	ADD_TRAIT(H, TRAIT_ZJUMP, TRAIT_GENERIC)

	H.adjust_skillrank(/datum/skill/misc/climbing, 5, TRUE)
	H.adjust_skillrank(/datum/skill/misc/athletics, 5, TRUE)
	H.adjust_skillrank(/datum/skill/misc/sneaking, 5, TRUE)

/mob/living/carbon/human/species/rousman/seer
	ai_controller = /datum/ai_controller/human_npc

/mob/living/carbon/human/species/rousman/seer/after_creation()
	. = ..()
	AddComponent(/datum/component/ai_aggro_system)
	job = "Seer Rousman"
	ADD_TRAIT(src, TRAIT_NOMOOD, TRAIT_GENERIC)
	ADD_TRAIT(src, TRAIT_NOHUNGER, TRAIT_GENERIC)
	equipOutfit(new /datum/outfit/npc/rousman/seer)
	dodgetime = 13
	canparry = TRUE
	flee_in_pain = TRUE
	wander = TRUE

/datum/outfit/npc/rousman/seer/pre_equip(mob/living/carbon/human/H)
	..()
	H.base_strength = rand(4, 8)
	H.base_perception = rand(6, 10)
	H.base_intelligence = rand(10, 16)
	H.base_constitution = rand(4, 8)
	H.base_endurance = rand(7, 10)
	H.base_speed = rand(10, 15)
	H.recalculate_stats(FALSE)

	armor = /obj/item/clothing/shirt/robe/rousseer
	head = /obj/item/clothing/head/roguehood/rousman/rousseer
	r_hand = /obj/item/weapon/polearm/woodstaff/seer

	var/list/spells = list(
		/datum/action/cooldown/spell/projectile/fireball,
		/datum/action/cooldown/spell/projectile/blood_bolt,
		/datum/action/cooldown/spell/projectile/sickness,
		/datum/action/cooldown/spell/projectile/fetch,
		/datum/action/cooldown/spell/undirected/arcyne_eye,
		/datum/action/cooldown/spell/eyebite,
		/datum/action/cooldown/spell/sundering_lightning,
	)

	H.adjust_skillrank(/datum/skill/magic/arcane, 5, TRUE)
	H.adjust_spell_points(17)
	H.generate_random_attunements(rand(4,6))
	H.mana_pool.set_intrinsic_recharge(MANA_ALL_LEYLINES)
	H.mana_pool.adjust_mana(100)
	for(var/spell in spells)
		H.add_spell(spell)
