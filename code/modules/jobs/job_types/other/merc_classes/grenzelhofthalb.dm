/datum/attribute_holder/sheet/job/grenzelhofthalb
	raw_attribute_list = list(
		STAT_ENDURANCE = 1, //they want to stay in the fight for longer
        STAT_STRENGTH = 2,
		STAT_PERCEPTION = 1, //direct pokes
		/datum/attribute/skill/misc/swimming = 20,
		/datum/attribute/skill/misc/climbing = 30,
		/datum/attribute/skill/misc/sneaking = 30,
		/datum/attribute/skill/combat/wrestling = 20,
		/datum/attribute/skill/misc/athletics = 30,
		/datum/attribute/skill/combat/unarmed = 20,
		/datum/attribute/skill/combat/polearms = 36,
		/datum/attribute/skill/combat/swords = 25, // their secondary weapon, could afford more training then the gun user
		/datum/attribute/skill/misc/reading = 10,
		/datum/attribute/skill/craft/cooking = 10,
    )
/datum/job/advclass/mercenary/grenzelhofthalb
	title = "Grenzelhoft Hellebardiere"
	tutorial = "A Grenzelhoft Halberdier, specializing in the usage of polearms. They make up the majority of the Grenzelhoft mercenary guild, and are known for their reliability."
	allowed_races = RACES_PLAYER_GRENZ_MERC
	outfit = /datum/outfit/mercenary/grenzelhofthalb

	attribute_sheet = /datum/attribute_holder/sheet/job/grenzelhofthalb

	traits = list(TRAIT_MEDIUMARMOR)
	languages = list(/datum/language/newpsydonic)
	category_tags = list(CTAG_MERCENARY)

	cmode_music = 'sound/music/cmode/combat_grenzelhoft.ogg'

/datum/outfit/mercenary/grenzelhofthalb
	name = "Grenzelhoft Hellebardiere (Mercenary)"
	neck = /obj/item/clothing/neck/chaincoif
	pants = /obj/item/clothing/pants/grenzelpants
	shoes = /obj/item/clothing/shoes/rare/grenzelhoft
	gloves = /obj/item/clothing/gloves/angle/grenzel
	belt = /obj/item/storage/belt/leather/mercenary
	shirt = /obj/item/clothing/shirt/grenzelhoft
	beltr = /obj/item/weapon/sword/short
	backl = /obj/item/storage/backpack/satchel
	backr = /obj/item/weapon/polearm/halberd
	backpack_contents = list(
		/obj/item/storage/belt/pouch/coins/poor = 1,
		/obj/item/weapon/knife/villager = 1, //utility knife!
	)
/datum/outfit/mercenary/grenzelhoft/pre_equip(mob/living/carbon/human/H)
	. = ..()
	if(H.gender == FEMALE)
		H.underwear = "Femleotard"
		H.underwear_color = CLOTHING_SOOT_BLACK
		H.update_body()

/datum/job/advclass/mercenary/grenzelhofthalb/after_spawn(mob/living/carbon/human/H)
	. = ..()
	H.merctype = 2
	if(H.dna?.species.id == SPEC_ID_HUMEN)
		H.dna.species.native_language = "Old Psydonic"
		H.dna.species.accent_language = H.dna.species.get_accent(H.dna.species.native_language)

/datum/job/advclass/mercenary/grenzelhofthalb/on_roundstart(mob/living/carbon/human/spawned, client/player_client)
	. = ..()
	var/static/list/armor = list("Grenzelhoft Cuirass & Grenzelhoft Plume Hat", "Steel Cuirass & Sallet")
	var/armor_choice = tgui_input_list(player_client,"CHOOSE YOUR MAILLE", "GO EARN SOME COIN.", armor)
	switch(armor_choice)
		if("Grenzelhoft Cuirass & Grenzelhoft Plume Hat")
			spawned.equip_to_slot_or_del(new /obj/item/clothing/armor/cuirass/grenzelhoft, ITEM_SLOT_ARMOR, TRUE)
			spawned.equip_to_slot_or_del(new /obj/item/clothing/head/helmet/skullcap/grenzelhoft, ITEM_SLOT_HEAD, TRUE)
		if("Steel Cuirass & Sallet")
			spawned.equip_to_slot_or_del(new /obj/item/clothing/armor/cuirass, ITEM_SLOT_ARMOR, TRUE)
			spawned.equip_to_slot_or_del(new /obj/item/clothing/head/helmet/sallet, ITEM_SLOT_HEAD, TRUE)
