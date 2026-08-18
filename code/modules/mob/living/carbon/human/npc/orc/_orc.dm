/mob/living/carbon/human/species/orc
	name = "orc"
	icon = 'icons/roguetown/mob/monster/orc.dmi'
	icon_state = "orc"
	faction = list(FACTION_HOSTILE)
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
	equipOutfit(new /datum/outfit/npc/orc/ambush)
	dodgetime = 15
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
	add_faction(FACTION_ORCS)
	name = "orc"
	real_name = "orc"
	add_traits(list(TRAIT_HEAVYARMOR, TRAIT_NOMOOD, TRAIT_NOHUNGER, TRAIT_CRITICAL_WEAKNESS), SPECIES_TRAIT)

/datum/outfit/npc/orc/ambush/pre_equip(mob/living/carbon/human/H)
	..()
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
	equipOutfit(new /datum/outfit/npc/orc/tribal)
	dodgetime = 15
	flee_in_pain = FALSE
	wander = TRUE

/datum/attribute_holder/sheet/job/orc_npc/tribal
	raw_attribute_list = list(
		STAT_SPEED = 1,
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
	equipOutfit(new /datum/outfit/npc/orc/warrior)
	dodgetime = 15
	flee_in_pain = FALSE
	wander = TRUE

/datum/attribute_holder/sheet/job/orc_npc/warrior
	raw_attribute_list = list(
		STAT_CONSTITUTION = 1,
		STAT_ENDURANCE = 1,
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
	equipOutfit(new /datum/outfit/npc/orc/marauder)
	dodgetime = 15
	flee_in_pain = FALSE
	wander = TRUE

/datum/attribute_holder/sheet/job/orc_npc/marauder_mob
	raw_attribute_list = list(
		STAT_STRENGTH = 1,
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
	equipOutfit(new /datum/outfit/npc/orc/warlord)
	dodgetime = 15
	flee_in_pain = FALSE
	wander = TRUE

/datum/attribute_holder/sheet/job/orc_npc/warlord_mob
	raw_attribute_list = list(
		STAT_STRENGTH = 1,
		STAT_SPEED = 2,
		STAT_CONSTITUTION = 1,
		STAT_ENDURANCE = 1,
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
	equipOutfit(new /datum/outfit/npc/orc/warlord)
	dodgetime = 15
	flee_in_pain = FALSE
	wander = TRUE
	configure_mind()
