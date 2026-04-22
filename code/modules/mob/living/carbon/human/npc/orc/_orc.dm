/mob/living/carbon/human/species/orc
	name = "orc"
	icon = 'icons/roguetown/mob/monster/orc.dmi'
	icon_state = "orc"
	race = /datum/species/orc
	gender = MALE
	bodyparts = list(/obj/item/bodypart/chest/orc, /obj/item/bodypart/head/orc, /obj/item/bodypart/l_arm/orc,
					/obj/item/bodypart/r_arm/orc, /obj/item/bodypart/r_leg/orc, /obj/item/bodypart/l_leg/orc, /obj/item/bodypart/mouth)
	rot_type = /datum/component/rot/corpse/orc
	ambushable = FALSE
	base_intents = list(INTENT_HELP, INTENT_DISARM, INTENT_GRAB, /datum/intent/unarmed/claw, /datum/intent/simple/bite, /datum/intent/kick)
	bloodpool = 1500

/mob/living/carbon/human/species/orc/slaved
	ai_controller = /datum/ai_controller/human_npc
	dodgetime = 15
	canparry = TRUE
	wander = FALSE

/mob/living/carbon/human/species/orc/slaved/Initialize()
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

/mob/living/carbon/human/species/orc/npc
	ai_controller = /datum/ai_controller/human_npc
	dodgetime = 15
	canparry = TRUE
	flee_in_pain = FALSE
	var/orc_outfit
	wander = FALSE

/mob/living/carbon/human/species/orc/npc/Initialize()
	. = ..()
	AddComponent(/datum/component/ai_aggro_system)
	AddComponent(/datum/component/combat_noise, list("aggro" = 2))

/mob/living/carbon/human/species/orc/npc/after_creation()
	..()
	if(orc_outfit)
		equipOutfit(new orc_outfit)

/mob/living/carbon/human/species/orc/ambush
	ai_controller = /datum/ai_controller/human_npc

/mob/living/carbon/human/species/orc/ambush/Initialize()
	. = ..()
	AddComponent(/datum/component/ai_aggro_system)

/mob/living/carbon/human/species/orc/ambush/after_creation()
	..()
	job = "Ambush Orc"
	ADD_TRAIT(src, TRAIT_NOMOOD, TRAIT_GENERIC)
	ADD_TRAIT(src, TRAIT_NOHUNGER, TRAIT_GENERIC)
	equipOutfit(new /datum/outfit/npc/orc/ambush)
	dodgetime = 15
	canparry = TRUE
	flee_in_pain = FALSE
	wander = TRUE

/obj/item/bodypart/chest/orc
	dismemberable = 1
/obj/item/bodypart/l_arm/orc
	dismemberable = 1
/obj/item/bodypart/r_arm/orc
	dismemberable = 1
/obj/item/bodypart/r_leg/orc
	dismemberable = 1
/obj/item/bodypart/l_leg/orc
	dismemberable = 1
/obj/item/bodypart/head/orc
	sellprice = 10

/obj/item/bodypart/head/orc/update_icon_dropped()
	return

/obj/item/bodypart/head/orc/get_limb_icon(dropped, hideaux = FALSE)
	return

/obj/item/bodypart/head/orc/skeletonize()
	. = ..()
	icon_state = "orc_skel_head"

/mob/living/carbon/human/species/orc/update_body()
	remove_overlay(BODY_LAYER)
	if(!dna || !dna.species)
		return
	var/datum/species/orc/G = dna.species
	if(!istype(G))
		return
	icon_state = ""
	var/list/standing = list()
	var/mutable_appearance/body_overlay
	var/obj/item/bodypart/chesty = get_bodypart("chest")
	var/obj/item/bodypart/headdy = get_bodypart("head")
	if(!headdy)
		if(chesty && chesty.skeletonized)
			body_overlay = mutable_appearance(icon, "orc_skel_decap", -BODY_LAYER)
		else
			body_overlay = mutable_appearance(icon, "[G.raceicon]_decap", -BODY_LAYER)
	else
		if(chesty && chesty.skeletonized)
			body_overlay = mutable_appearance(icon, "orc_skel", -BODY_LAYER)
		else
			body_overlay = mutable_appearance(icon, "[G.raceicon]", -BODY_LAYER)

	if(body_overlay)
		standing += body_overlay
	if(standing.len)
		overlays_standing[BODY_LAYER] = standing

	apply_overlay(BODY_LAYER)
	dna.species.update_damage_overlays()

/mob/living/carbon/human/species/orc/update_inv_head(hide_nonstandard = FALSE)
	update_wearable()
/mob/living/carbon/human/species/orc/update_inv_armor()
	update_wearable()

/mob/living/carbon/human/species/orc/Initialize()
	. = ..()
	addtimer(CALLBACK(src, PROC_REF(after_creation)), 1 SECONDS)

/datum/attribute_holder/sheet/job/orc_npc/configure_mind
	raw_attribute_list = list(
		/datum/attribute/skill/combat/polearms = 20,
		/datum/attribute/skill/combat/swords = 20,
		/datum/attribute/skill/combat/wrestling = 20,
		/datum/attribute/skill/combat/unarmed = 20,
		/datum/attribute/skill/combat/knives = 20,
		/datum/attribute/skill/combat/axesmaces = 20,
	)

/mob/living/carbon/human/species/orc/proc/configure_mind()
	if(!mind)
		mind = new /datum/mind(src)
	mind.current = src
	attributes.add_sheet(/datum/attribute_holder/sheet/job/orc_npc/configure_mind)

/mob/living/carbon/human/species/orc/after_creation()
	..()
	gender = MALE
	if(src.dna && src.dna.species)
		src.dna.species.soundpack_m = new /datum/voicepack/orc()
		var/obj/item/bodypart/head/headdy = get_bodypart("head")
		if(headdy)
			headdy.icon = 'icons/roguetown/mob/monster/orc.dmi'
			headdy.icon_state = "[src.dna.species.id]_head"
	src.grant_language(/datum/language/common)

	var/list/eye_list = getorganslotlist(ORGAN_SLOT_EYES)
	for(var/obj/item/organ/eyes/eyes as anything in eye_list)
		eyes.Remove(src,1)
		QDEL_NULL(eyes)

	var/obj/item/organ/eyes/LE = new /obj/item/organ/eyes/night_vision/nightmare
	var/obj/item/organ/eyes/RE = new /obj/item/organ/eyes/night_vision/nightmare
	LE.switch_side(LEFT_SIDE)

	LE.Insert(src)
	RE.Insert(src)

	src.underwear = "Nude"
	if(length(quirks))
		clear_quirks()
	update_eyes()
	faction = list(FACTION_ORCS)
	var/turf/turf = get_turf(src)
	if(SSterrain_generation.get_island_at_location(turf))
		faction |= "islander"
	name = "orc"
	real_name = "orc"
	ADD_TRAIT(src, TRAIT_HEAVYARMOR, TRAIT_GENERIC)
	ADD_TRAIT(src, TRAIT_NOMOOD, TRAIT_GENERIC)
	ADD_TRAIT(src, TRAIT_NOHUNGER, TRAIT_GENERIC)
	ADD_TRAIT(src, TRAIT_CRITICAL_WEAKNESS, TRAIT_GENERIC)

/datum/species/orc
	name = "orc"
	id = SPEC_ID_ORC
	species_traits = list(NO_UNDERWEAR)
	inherent_traits = list(TRAIT_RESISTCOLD,TRAIT_RESISTHIGHPRESSURE,TRAIT_RESISTLOWPRESSURE,TRAIT_RADIMMUNE,TRAIT_CRITICAL_WEAKNESS, TRAIT_NASTY_EATER, TRAIT_LEECHIMMUNE, TRAIT_INHUMENCAMP)
	nojumpsuit = 1
	sexes = 1
	damage_overlay_type = ""
	changesource_flags = WABBAJACK
	var/raceicon = "orc"
	exotic_bloodtype = /datum/blood_type/human/corrupted/orc
	meat = list(/obj/item/reagent_containers/food/snacks/meat/strange/inhumen = 1)

/datum/species/orc/update_damage_overlays(mob/living/carbon/human/H)
	return

/datum/species/orc/regenerate_icons(mob/living/carbon/human/H)
	H.icon_state = ""
	if(HAS_TRAIT(H, TRAIT_NO_TRANSFORM))
		return 1
	H.update_inv_hands()
	H.update_inv_handcuffed()
	H.update_inv_legcuffed()
	H.update_fire()
	H.update_body()
	var/mob/living/carbon/human/species/orc/G = H
	G.update_wearable()
	H.update_transform()
	return TRUE

/datum/component/rot/corpse/orc/process()
	var/amt2add = 10
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

/datum/attribute_holder/sheet/job/orc_npc/ambush
	raw_attribute_list = list(
		STAT_STRENGTH = 3,
		STAT_SPEED = 2,
		STAT_CONSTITUTION = 3,
		STAT_ENDURANCE = 3,
		STAT_INTELLIGENCE = -9,
	)

/datum/outfit/npc/orc/ambush/pre_equip(mob/living/carbon/human/H)
	..()
	H.attributes.add_sheet(/datum/attribute_holder/sheet/job/orc_npc/ambush)
	var/loadout = rand(1,5)
	switch(loadout)
		if(1)
			r_hand = /obj/item/weapon/axe/iron
			armor = /obj/item/clothing/armor/leather/hide/orc
		if(2)
			r_hand = /obj/item/weapon/thresher
			armor = /obj/item/clothing/armor/leather/hide/orc
		if(3)
			r_hand = /obj/item/weapon/pitchfork
			armor = /obj/item/clothing/armor/leather/hide/orc
			if(prob(10))
				r_hand = /obj/item/weapon/sickle
				armor = /obj/item/clothing/armor/leather/hide/orc
		if(4)
			if(prob(50))
				head = /obj/item/clothing/head/helmet/orc
				r_hand = /obj/item/weapon/mace/spiked
				armor = /obj/item/clothing/armor/chainmail/iron/orc
				pants = /obj/item/clothing/armor/leather/hide/orc
				head = /obj/item/clothing/head/helmet/leather
			if(prob(30))
				l_hand = /obj/item/weapon/sword/iron
				armor = /obj/item/clothing/armor/chainmail/iron/orc
				head = /obj/item/clothing/head/helmet/leather
			if(prob(23))
				armor = /obj/item/clothing/armor/chainmail/iron/orc
				r_hand = /obj/item/weapon/knife/dagger
				l_hand = /obj/item/weapon/knife/dagger
				pants = /obj/item/clothing/armor/leather/hide/orc
				head = /obj/item/clothing/head/helmet/leather
			if(prob(80))
				armor = /obj/item/clothing/armor/chainmail/iron/orc
				pants = /obj/item/clothing/armor/leather/hide/orc
				head = /obj/item/clothing/head/helmet/leather
		if(5)
			if(prob(20))
				r_hand = /obj/item/weapon/mace
				l_hand = /obj/item/weapon/whip
				armor = /obj/item/clothing/armor/plate/orc
				head = /obj/item/clothing/head/helmet/orc
			else
				r_hand = /obj/item/weapon/sword/short/iron
				l_hand = /obj/item/weapon/sword/short/iron
				armor = /obj/item/clothing/armor/plate/orc
				head = /obj/item/clothing/head/helmet/orc
			if(prob(80))
				head = /obj/item/clothing/head/helmet/orc
				armor = /obj/item/clothing/armor/plate/orc
				pants = /obj/item/clothing/armor/leather/hide/orc
				r_hand = /obj/item/weapon/flail
			else
				head = /obj/item/clothing/head/helmet/orc
				armor = /obj/item/clothing/armor/plate/orc
				r_hand = /obj/item/weapon/axe/battle
			if(prob(50))
				r_hand = /obj/item/weapon/sword/iron
				l_hand = /obj/item/weapon/shield/wood
				armor = /obj/item/clothing/armor/plate/orc
				head = /obj/item/clothing/head/helmet/orc
			else
				r_hand = /obj/item/weapon/mace/spiked
				l_hand = /obj/item/weapon/shield/wood
				armor = /obj/item/clothing/armor/plate/orc
				head = /obj/item/clothing/head/helmet/orc
			if(prob(30))
				r_hand = /obj/item/weapon/sword/scimitar/messer
				armor = /obj/item/clothing/armor/plate/orc
				head = /obj/item/clothing/head/helmet/orc

/mob/living/carbon/human/species/orc/tribal
	name = "Tribal Orc"
	ai_controller = /datum/ai_controller/human_npc
	var/loadout = /datum/outfit/npc/orc/tribal
	ambushable = FALSE

/mob/living/carbon/human/species/orc/tribal/Initialize()
	. = ..()
	AddComponent(/datum/component/ai_aggro_system)

/mob/living/carbon/human/species/orc/tribal/after_creation()
	..()
	ADD_TRAIT(src, TRAIT_NOMOOD, TRAIT_GENERIC)
	ADD_TRAIT(src, TRAIT_NOHUNGER, TRAIT_GENERIC)
	equipOutfit(new /datum/outfit/npc/orc/tribal)
	dodgetime = 15
	canparry = TRUE
	flee_in_pain = FALSE
	wander = TRUE

/datum/attribute_holder/sheet/job/orc_npc/tribal
	raw_attribute_list = list(
		STAT_STRENGTH = 3,
		STAT_SPEED = 3,
		STAT_CONSTITUTION = 3,
		STAT_ENDURANCE = 3,
		STAT_INTELLIGENCE = -9,
	)

/datum/outfit/npc/orc/tribal/pre_equip(mob/living/carbon/human/H)
	..()
	H.attributes.add_sheet(/datum/attribute_holder/sheet/job/orc_npc/tribal)
	var/loadout = rand(1,5)
	switch(loadout)
		if(1)
			r_hand = /obj/item/weapon/axe/stone
			l_hand = /obj/item/weapon/axe/stone
			armor = /obj/item/clothing/armor/leather/hide/orc
			cloak = /obj/item/clothing/cloak/raincloak/colored/brown
		if(2)
			r_hand = /obj/item/weapon/polearm/woodstaff
			armor = /obj/item/clothing/armor/leather/hide/orc
			cloak = /obj/item/clothing/cloak/raincloak/colored/brown
		if(3)
			r_hand = /obj/item/weapon/mace/woodclub
			armor = /obj/item/clothing/armor/leather/hide/orc
			cloak = /obj/item/clothing/cloak/raincloak/colored/brown
		if(4)
			armor = /obj/item/clothing/armor/leather/hide/orc
			cloak = /obj/item/clothing/cloak/raincloak/colored/brown
			r_hand = /obj/item/weapon/knife/stone
			l_hand = /obj/item/weapon/knife/stone
		if(5)
			r_hand = /obj/item/weapon/polearm/spear/stone
			armor = /obj/item/clothing/armor/leather/hide/orc
			cloak = /obj/item/clothing/cloak/raincloak/colored/brown

/mob/living/carbon/human/species/orc/warrior
	name = "Warrior Orc"
	ai_controller = /datum/ai_controller/human_npc
	var/loadout = /datum/outfit/npc/orc/warrior
	ambushable = FALSE

/mob/living/carbon/human/species/orc/warrior/after_creation()
	..()
	AddComponent(/datum/component/ai_aggro_system)
	ADD_TRAIT(src, TRAIT_NOMOOD, TRAIT_GENERIC)
	ADD_TRAIT(src, TRAIT_NOHUNGER, TRAIT_GENERIC)
	equipOutfit(new /datum/outfit/npc/orc/warrior)
	dodgetime = 15
	canparry = TRUE
	flee_in_pain = FALSE
	wander = TRUE

/datum/attribute_holder/sheet/job/orc_npc/warrior
	raw_attribute_list = list(
		STAT_STRENGTH = 3,
		STAT_SPEED = 3,
		STAT_CONSTITUTION = 4,
		STAT_ENDURANCE = 4,
		STAT_INTELLIGENCE = -9,
	)

/datum/outfit/npc/orc/warrior/pre_equip(mob/living/carbon/human/H)
	..()
	H.attributes.add_sheet(/datum/attribute_holder/sheet/job/orc_npc/warrior)
	var/loadout = rand(1,5)
	switch(loadout)
		if(1)
			r_hand = /obj/item/weapon/sword/iron
			l_hand = /obj/item/weapon/shield/wood
			armor = /obj/item/clothing/armor/chainmail/iron/orc
			cloak = /obj/item/clothing/cloak/raincloak/colored/brown
			head = /obj/item/clothing/head/helmet/leather
		if(2)
			r_hand = /obj/item/weapon/axe/iron
			l_hand = /obj/item/weapon/shield/wood
			armor = /obj/item/clothing/armor/chainmail/iron/orc
			cloak = /obj/item/clothing/cloak/raincloak/colored/brown
			head = /obj/item/clothing/head/helmet/leather
		if(3)
			r_hand = /obj/item/weapon/flail
			l_hand = /obj/item/weapon/sword/scimitar/messer
			armor = /obj/item/clothing/armor/chainmail/iron/orc
			cloak = /obj/item/clothing/cloak/raincloak/colored/brown
			head = /obj/item/clothing/head/helmet/leather
		if(4)
			armor = /obj/item/clothing/armor/chainmail/iron/orc
			cloak = /obj/item/clothing/cloak/raincloak/colored/brown
			r_hand = /obj/item/weapon/sword/iron
			l_hand = /obj/item/weapon/sword/short/iron
			head = /obj/item/clothing/head/helmet/leather
		if(5)
			if(prob(50))
				r_hand = /obj/item/weapon/mace/spiked
				l_hand = /obj/item/weapon/shield/wood
				armor = /obj/item/clothing/armor/plate/orc
				head = /obj/item/clothing/head/helmet/orc
			else
				r_hand = /obj/item/weapon/mace/spiked
				l_hand = /obj/item/weapon/sword/scimitar/messer
				armor = /obj/item/clothing/armor/plate/orc
				head = /obj/item/clothing/head/helmet/orc
				cloak = /obj/item/clothing/cloak/raincloak/colored/brown
			if(prob(30))
				r_hand = /obj/item/weapon/axe/iron
				armor = /obj/item/clothing/armor/plate/orc
				head = /obj/item/clothing/head/helmet/orc
				cloak = /obj/item/clothing/cloak/raincloak/colored/brown

/mob/living/carbon/human/species/orc/marauder
	name = "Marauder Orc"
	ai_controller = /datum/ai_controller/human_npc
	var/loadout = /datum/outfit/npc/orc/marauder
	ambushable = FALSE

/mob/living/carbon/human/species/orc/marauder/after_creation()
	..()
	AddComponent(/datum/component/ai_aggro_system)
	ADD_TRAIT(src, TRAIT_NOMOOD, TRAIT_GENERIC)
	ADD_TRAIT(src, TRAIT_NOHUNGER, TRAIT_GENERIC)
	equipOutfit(new /datum/outfit/npc/orc/marauder)
	dodgetime = 15
	canparry = TRUE
	flee_in_pain = FALSE
	wander = TRUE

/datum/attribute_holder/sheet/job/orc_npc/marauder_mob
	raw_attribute_list = list(
		STAT_STRENGTH = 2,
		STAT_SPEED = 2,
		STAT_CONSTITUTION = 3,
		STAT_ENDURANCE = 3,
		STAT_INTELLIGENCE = -9,
	)

/datum/outfit/npc/orc/marauder/pre_equip(mob/living/carbon/human/H)
	..()
	H.attributes.add_sheet(/datum/attribute_holder/sheet/job/orc_npc/marauder_mob)
	var/loadout = rand(1,5)
	switch(loadout)
		if(1)
			r_hand = /obj/item/weapon/sword/iron
			l_hand = /obj/item/weapon/axe/iron
			armor = /obj/item/clothing/armor/plate/orc
			cloak = /obj/item/clothing/cloak/raincloak/colored/brown
			head = /obj/item/clothing/head/helmet/orc
		if(2)
			r_hand = /obj/item/weapon/axe/battle
			armor = /obj/item/clothing/armor/plate/orc
			cloak = /obj/item/clothing/cloak/raincloak/colored/brown
			head = /obj/item/clothing/head/helmet/orc
		if(3)
			r_hand = /obj/item/weapon/mace/goden/steel/warhammer
			armor = /obj/item/clothing/armor/plate/orc
			cloak = /obj/item/clothing/cloak/raincloak/colored/brown
			head = /obj/item/clothing/head/helmet/orc
		if(4)
			armor = /obj/item/clothing/armor/plate/orc
			cloak = /obj/item/clothing/cloak/raincloak/colored/brown
			r_hand = /obj/item/weapon/mace/steel
			l_hand = /obj/item/weapon/shield/tower
			head = /obj/item/clothing/head/helmet/orc
		if(5)
			r_hand = /obj/item/weapon/polearm/halberd/bardiche
			armor = /obj/item/clothing/armor/plate/orc
			cloak = /obj/item/clothing/cloak/raincloak/colored/brown
			head = /obj/item/clothing/head/helmet/orc

/mob/living/carbon/human/species/orc/warlord
	name = "Warlord Orc"
	ai_controller = /datum/ai_controller/human_npc
	var/loadout = /datum/outfit/npc/orc/warlord
	ambushable = FALSE

/mob/living/carbon/human/species/orc/warlord/after_creation()
	..()
	AddComponent(/datum/component/ai_aggro_system)
	ADD_TRAIT(src, TRAIT_NOMOOD, TRAIT_GENERIC)
	ADD_TRAIT(src, TRAIT_NOHUNGER, TRAIT_GENERIC)
	equipOutfit(new /datum/outfit/npc/orc/warlord)
	dodgetime = 15
	canparry = TRUE
	flee_in_pain = FALSE
	wander = TRUE

/datum/attribute_holder/sheet/job/orc_npc/warlord_mob
	raw_attribute_list = list(
		STAT_STRENGTH = 4,
		STAT_SPEED = 4,
		STAT_CONSTITUTION = 4,
		STAT_ENDURANCE = 4,
		STAT_INTELLIGENCE = -9,
	)

/datum/outfit/npc/orc/warlord/pre_equip(mob/living/carbon/human/H)
	..()
	H.attributes.add_sheet(/datum/attribute_holder/sheet/job/orc_npc/warlord_mob)
	var/loadout = rand(1,5)
	switch(loadout)
		if(1)
			r_hand = /obj/item/weapon/polearm/halberd
			armor = /obj/item/clothing/armor/plate/orc/warlord
			head = /obj/item/clothing/head/helmet/orc/warlord
		if(2)
			r_hand = /obj/item/weapon/sword/long/greatsword
			armor = /obj/item/clothing/armor/plate/orc/warlord
			head = /obj/item/clothing/head/helmet/orc/warlord
		if(3)
			r_hand = /obj/item/weapon/whip/antique
			l_hand = /obj/item/weapon/sword/short/iron
			armor = /obj/item/clothing/armor/plate/orc/warlord
			head = /obj/item/clothing/head/helmet/orc/warlord
		if(4)
			armor = /obj/item/clothing/armor/plate/orc/warlord
			r_hand = /obj/item/weapon/sword/scimitar/falchion
			l_hand = /obj/item/weapon/shield/tower
			head = /obj/item/clothing/head/helmet/orc/warlord
		if(5)
			r_hand = /obj/item/weapon/flail/sflail
			armor = /obj/item/clothing/armor/plate/orc/warlord
			head = /obj/item/clothing/head/helmet/orc/warlord

/mob/living/carbon/human/species/orc/warlord/skilled/after_creation()
	..()
	ADD_TRAIT(src, TRAIT_NOMOOD, TRAIT_GENERIC)
	ADD_TRAIT(src, TRAIT_NOHUNGER, TRAIT_GENERIC)
	equipOutfit(new /datum/outfit/npc/orc/warlord)
	dodgetime = 15
	canparry = TRUE
	flee_in_pain = FALSE
	wander = TRUE
	configure_mind()
