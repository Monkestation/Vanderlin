/datum/attribute_holder/sheet/job/pilgrim/grenzelhoft
	raw_attribute_list = list(
		STAT_INTELLIGENCE = 1,
		STAT_ENDURANCE = 2,
		/datum/attribute/skill/misc/swimming = 20,
		/datum/attribute/skill/misc/climbing = 30,
		/datum/attribute/skill/misc/riding = 30,
		/datum/attribute/skill/misc/reading = 40,
		/datum/attribute/skill/misc/music = 10,
		/datum/attribute/skill/craft/cooking = 20,
		/datum/attribute/skill/combat/bows = 10,
		/datum/attribute/skill/combat/crossbows = 20,
		/datum/attribute/skill/combat/wrestling = 20,
		/datum/attribute/skill/combat/unarmed = 20,
		/datum/attribute/skill/combat/swords = 30,
		/datum/attribute/skill/combat/knives = 20,
		/datum/attribute/skill/labor/mathematics = 30,
	)

/datum/job/advclass/pilgrim/rare/grenzelhoft
	title = "Grenzelhoft Count"
	tutorial = "A Count hailing from the Grenzelhoft Imperiate, here on an official visit to Vanderlin."
	allowed_races = RACES_PLAYER_GRENZ
	outfit = /datum/outfit/pilgrim/grenzelhoft
	category_tags = list(CTAG_PILGRIM)
	total_positions = 1
	is_recognized = TRUE
	cmode_music = 'sound/music/cmode/combat_grenzelhoft.ogg'
	honorary = "Count"
	honorary_f = "Countess"

	attribute_sheet = /datum/attribute_holder/sheet/job/pilgrim/grenzelhoft

	traits = list(
		TRAIT_MEDIUMARMOR,
		TRAIT_NOBLE_BLOOD,
		TRAIT_NOBLE_POWER,
		TRAIT_FOREIGNER
	)


	spells = list(
		/datum/action/cooldown/spell/undirected/call_bird/grenzel
	)

	languages = list(/datum/language/newpsydonic)

/datum/job/advclass/pilgrim/rare/grenzelhoft/after_spawn(mob/living/carbon/human/spawned, client/player_client)
	. = ..()

	if(spawned.dna?.species.id == SPEC_ID_HUMEN)
		spawned.dna.species.native_language = "Old Psydonic"
		spawned.dna.species.accent_language = spawned.dna.species.get_accent(spawned.dna.species.native_language)

/datum/outfit/pilgrim/grenzelhoft
	name = "Grenzelhoft Count (Pilgrim)"
	shoes = /obj/item/clothing/shoes/rare/grenzelhoft
	gloves = /obj/item/clothing/gloves/angle/grenzel
	wrists = /obj/item/clothing/neck/psycross/gold
	head = /obj/item/clothing/head/helmet/skullcap/grenzelhoft
	armor = /obj/item/clothing/armor/brigandine
	belt = /obj/item/storage/belt/leather/plaquesilver
	beltl = /obj/item/weapon/sword/sabre/dec
	beltr = /obj/item/flashlight/flare/torch/lantern
	backr = /obj/item/storage/backpack/satchel
	ring = /obj/item/clothing/ring/gold
	shirt = /obj/item/clothing/shirt/grenzelhoft
	pants = /obj/item/clothing/pants/grenzelpants
	neck = /obj/item/clothing/neck/gorget
	backpack_contents = list(/obj/item/storage/belt/pouch/coins/veryrich = 1)

/datum/outfit/pilgrim/grenzelhoft/pre_equip(mob/living/carbon/human/equipped_human, visuals_only)
	. = ..()
	if(equipped_human.gender == FEMALE)
		armor = /obj/item/clothing/armor/gambeson/heavy/dress/alt
		beltl = /obj/item/weapon/sword/rapier/dec
