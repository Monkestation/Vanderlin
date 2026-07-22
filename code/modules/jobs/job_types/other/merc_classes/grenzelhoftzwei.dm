/datum/attribute_holder/sheet/job/grenzelhoftzwei
	raw_attribute_list = list(
		STAT_CONSTITUTION = 2,
        STAT_STRENGTH = 2,
		/datum/attribute/skill/misc/swimming = 20,
		/datum/attribute/skill/misc/climbing = 30,
		/datum/attribute/skill/misc/sneaking = 30,
		/datum/attribute/skill/combat/wrestling = 20,
		/datum/attribute/skill/misc/athletics = 35, // slight bonus, they use big sword
		/datum/attribute/skill/combat/unarmed = 20,
		/datum/attribute/skill/combat/swords = 36,
		/datum/attribute/skill/combat/axesmaces = 25, // cudgel
		/datum/attribute/skill/misc/reading = 10,
		/datum/attribute/skill/misc/medicine = 10,
    )
/datum/job/advclass/mercenary/grenzelhoftzwei
	title = "Grenzelhoft Doppelsöldner"
	tutorial = "A Grenzelhoft Doppelsöldner, specializing in using Zweihanders to break through enemy pike formations. This expertise generally demands high pay, which has given them the name of 'double-pay men'."
	allowed_races = RACES_PLAYER_GRENZ_MERC
	outfit = /datum/outfit/mercenary/grenzelhoftzwei

	attribute_sheet = /datum/attribute_holder/sheet/job/grenzelhoftzwei

	traits = list(TRAIT_MEDIUMARMOR, TRAIT_STEELHEARTED) // these guys are in the frontline. they see bloody shit and are used to it.
	languages = list(/datum/language/newpsydonic)
	category_tags = list(CTAG_MERCENARY)

	cmode_music = 'sound/music/cmode/combat_grenzelhoft.ogg'

/datum/outfit/mercenary/grenzelhoftzwei
	name = "Grenzelhoft Doppelsoldner (Mercenary)"
	neck = /obj/item/clothing/neck/gorget //no double padding for your helmet, its a weak spot!
	pants = /obj/item/clothing/pants/grenzelpants
	shoes = /obj/item/clothing/shoes/rare/grenzelhoft
	gloves = /obj/item/clothing/gloves/angle/grenzel
	belt = /obj/item/storage/belt/leather/mercenary
	shirt = /obj/item/clothing/shirt/grenzelhoft
	wrists = /obj/item/clothing/wrists/bracers/iron //bonus arm protection so you dont get your arms chopped off!
	backl = /obj/item/storage/backpack/satchel
	backr = /obj/item/weapon/sword/long/greatsword/zwei
	head = /obj/item/clothing/head/helmet/skullcap/grenzelhoft
	armor = /obj/item/clothing/armor/cuirass/grenzelhoft
	backpack_contents = list(
		/obj/item/storage/belt/pouch/coins/poor = 1,
		/obj/item/weapon/knife/villager = 1, //utility knife!
		/obj/item/weapon/mace/cudgel //all of this spawns in their bag because of stuff that spawns things on your hip
	)
/datum/outfit/mercenary/grenzelhoftzwei/pre_equip(mob/living/carbon/human/H)
	. = ..()
	if(H.gender == FEMALE)
		H.underwear = "Femleotard"
		H.underwear_color = CLOTHING_SOOT_BLACK
		H.update_body()

/datum/job/advclass/mercenary/grenzelhoftzwei/after_spawn(mob/living/carbon/human/H)
	. = ..()
	H.merctype = 2
	if(H.dna?.species.id == SPEC_ID_HUMEN)
		H.dna.species.native_language = "Old Psydonic"
		H.dna.species.accent_language = H.dna.species.get_accent(H.dna.species.native_language)
