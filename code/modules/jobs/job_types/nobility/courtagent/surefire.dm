/datum/attribute_holder/sheet/job/courtagent/surefire
	raw_attribute_list = list(
		STAT_PERCEPTION = 2, //use gun from a range!
		STAT_SPEED = -2, // fuck you no running!
		/datum/attribute/skill/misc/swimming = 20,
		/datum/attribute/skill/misc/climbing = 30,
		/datum/attribute/skill/misc/sneaking = 30,
		/datum/attribute/skill/combat/wrestling = 20,
		/datum/attribute/skill/misc/athletics = 30,
		/datum/attribute/skill/combat/unarmed = 20,
		/datum/attribute/skill/combat/firearms = 33,
		/datum/attribute/skill/combat/axesmaces = 20,
		/datum/attribute/skill/misc/reading = 10,
		/datum/attribute/skill/craft/bombs = 10,
	)

/datum/job/advclass/courtagent/grenzsurefire
	title = "Grenzelhoft Surefire"
	tutorial = "You are one of the Hand's loyal Agents. \
	You have a gun. \
	<i>BACKSTORY TO BE FINISHED LATER</i>."
	allowed_races = RACES_PLAYER_GRENZ_MERC
	outfit = /datum/outfit/courtagent/surefire

	attribute_sheet = /datum/attribute_holder/sheet/job/courtagent/surefire

	traits = list(TRAIT_MEDIUMARMOR)
	languages = list(/datum/language/newpsydonic)
	category_tags = list(CTAG_COURTAGENT)
	total_positions = 1 //strong gun so limited

	cmode_music = 'sound/music/cmode/combat_grenzelhoft.ogg'

/datum/outfit/courtagent/surefire
	name = "Grenzelhoft Surefire (Court Agent)"
	neck = /obj/item/clothing/neck/chaincoif
	pants = /obj/item/clothing/pants/grenzelpants
	shoes = /obj/item/clothing/shoes/rare/grenzelhoft
	gloves = /obj/item/clothing/gloves/angle/grenzel
	shirt = /obj/item/clothing/shirt/grenzelhoft
	backl = /obj/item/storage/backpack/satchel/black
	backr = /obj/item/weapon/axe/steel
	belt = /obj/item/storage/belt/leather/black/courtagent
	beltl = /obj/item/gun/ballistic/powder/wheellock/puffer
	beltr = /obj/item/ammo_holder/bullet/bullets
	head = /obj/item/clothing/head/helmet/skullcap/grenzelhoft
	armor = /obj/item/clothing/armor/cuirass/grenzelhoft
	backpack_contents = list(
		/obj/item/storage/belt/pouch/coins/poor = 1,
		/obj/item/reagent_containers/glass/bottle/aflask,
	)

/datum/outfit/courtagent/surefire/pre_equip(mob/living/carbon/human/H)
	. = ..()
	if(H.gender == FEMALE)
		H.underwear = "Femleotard"
		H.underwear_color = CLOTHING_SOOT_BLACK
		H.update_body()

/datum/job/advclass/courtagent/grenzsurefire/after_spawn(mob/living/carbon/human/H)
	. = ..()
	H.merctype = 2
	if(H.dna?.species.id == SPEC_ID_HUMEN)
		H.dna.species.native_language = "Old Psydonic"
		H.dna.species.accent_language = H.dna.species.get_accent(H.dna.species.native_language)
