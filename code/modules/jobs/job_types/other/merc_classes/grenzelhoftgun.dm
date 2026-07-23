/datum/attribute_holder/sheet/job/grenzelhoftgun
	raw_attribute_list = list(
		STAT_PERCEPTION = 2, //use musket from a range!
        STAT_SPEED = -2, // fuck you no running!
		/datum/attribute/skill/misc/swimming = 20,
		/datum/attribute/skill/misc/climbing = 30,
		/datum/attribute/skill/misc/sneaking = 30,
		/datum/attribute/skill/combat/wrestling = 20,
		/datum/attribute/skill/misc/athletics = 30,
		/datum/attribute/skill/combat/unarmed = 20,
		/datum/attribute/skill/combat/firearms = 33,
		/datum/attribute/skill/combat/swords = 20,
		/datum/attribute/skill/misc/reading = 10,
		/datum/attribute/skill/craft/bombs = 10,
    )
/datum/job/advclass/mercenary/grenzelhoftgun
	title = "Grenzelhoft Arkebusier"
	tutorial = "A Grenzelhoft Arkebusier, they specialize in blackpowder weaponry, usually seen armed with muskets. Although more frail then other mercenaries, they make up for it with the incredible strength of their equipment."
	allowed_races = RACES_PLAYER_GRENZ_MERC
	outfit = /datum/outfit/mercenary/grenzelhoftgun

	attribute_sheet = /datum/attribute_holder/sheet/job/grenzelhoftgun

	traits = list(TRAIT_MEDIUMARMOR)
	languages = list(/datum/language/newpsydonic)
	category_tags = list(CTAG_MERCENARY)
	total_positions = 2 //strong gun so limited

	cmode_music = 'sound/music/cmode/combat_grenzelhoft.ogg'

/datum/outfit/mercenary/grenzelhoftgun
	name = "Grenzelhoft Arkebusier (Mercenary)"
	neck = /obj/item/clothing/neck/chaincoif
	pants = /obj/item/clothing/pants/grenzelpants
	shoes = /obj/item/clothing/shoes/rare/grenzelhoft
	gloves = /obj/item/clothing/gloves/angle/grenzel
	belt = /obj/item/storage/belt/leather/mercenary
	shirt = /obj/item/clothing/shirt/grenzelhoft
	backl = /obj/item/storage/backpack/satchel/musketeer
	beltl = /obj/item/weapon/sword/sabre/dec
	head = /obj/item/clothing/head/helmet/skullcap/grenzelhoft
	armor = /obj/item/clothing/armor/cuirass/grenzelhoft //bad stats so they cna keep the strong armor

/datum/outfit/mercenary/grenzelhoftgun/pre_equip(mob/living/carbon/human/H)
	. = ..()
	if(H.gender == FEMALE)
		H.underwear = "Femleotard"
		H.underwear_color = CLOTHING_SOOT_BLACK
		H.update_body()

/datum/job/advclass/mercenary/grenzelhoftgun/on_roundstart(mob/living/carbon/human/spawned, client/player_client)
	. = ..()
	var/static/list/weapons = list("Musket", "Blunderbuss")
	var/weapon_choice = tgui_input_list(player_client, "CHOOSE YOUR WEAPON.", "GO EARN SOME COIN.", weapons)
	switch(weapon_choice)
		if("Musket")
			spawned.equip_to_slot_or_del(new /obj/item/gun/ballistic/powder/musket, ITEM_SLOT_BACK_R, TRUE)
			spawned.equip_to_slot_or_del(new /obj/item/ammo_holder/bullet/bullets, ITEM_SLOT_BELT_R, TRUE)
		if("Blunderbuss")
			spawned.equip_to_slot_or_del(new /obj/item/gun/ballistic/powder/wheellock/blunderbuss, ITEM_SLOT_BACK_R, TRUE)
			spawned.equip_to_slot_or_del(new /obj/item/storage/belt/pouch/pellets, ITEM_SLOT_BELT_R, TRUE)

/datum/job/advclass/mercenary/grenzelhoftgun/after_spawn(mob/living/carbon/human/H)
	. = ..()
	H.merctype = 2
	if(H.dna?.species.id == SPEC_ID_HUMEN)
		H.dna.species.native_language = "Old Psydonic"
		H.dna.species.accent_language = H.dna.species.get_accent(H.dna.species.native_language)
