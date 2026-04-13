/datum/attribute_holder/sheet/job/swordmaster
	raw_attribute_list = list(
		STAT_STRENGTH = 2,
		STAT_ENDURANCE = 2,
		STAT_CONSTITUTION = 2,
		STAT_SPEED = -1,
		/datum/attribute/skill/combat/wrestling = 20,
		/datum/attribute/skill/combat/unarmed = 30,
		/datum/attribute/skill/combat/swords = 40,
		/datum/attribute/skill/misc/climbing = 10,
		/datum/attribute/skill/misc/athletics = 30,
		/datum/attribute/skill/misc/reading = 20,
	)

/datum/job/advclass/combat/swordmaster
	title = "Hedge Knight"
	tutorial = "You spent years serving the eastern Grenzelhoftian lords, and now you spend your days as a travelling hedge knight. Upon this island, you like to increase the fame of your sword skills, as well as your honor."
	allowed_sexes = list(MALE)
	allowed_races = list(SPEC_ID_HUMEN, SPEC_ID_AASIMAR) // not RACES_PLAYER_GRENZ because dwarves don't have a sprite for this armor
	outfit = /datum/outfit/swordmaster
	total_positions = 1
	category_tags = list(CTAG_ADVENTURER)
	cmode_music = 'sound/music/cmode/combat_grenzelhoft.ogg'
	honorary = "Ritter"
	honorary_f = "Ritterin"
	roll_chance = 7

	attribute_sheet = /datum/attribute_holder/sheet/job/swordmaster


	traits = list(
		TRAIT_HEAVYARMOR,
	)

	languages = list(/datum/language/newpsydonic)

/datum/job/advclass/combat/swordmaster/after_spawn(mob/living/carbon/human/spawned, client/player_client)
	. = ..()
	var/datum/species/species = spawned.dna?.species
	if(species && species.id == SPEC_ID_HUMEN)
		species.native_language = "Old Psydonic"
		species.accent_language = species.get_accent(species.native_language)
		species.soundpack_m = new /datum/voicepack/male/knight()

/datum/outfit/swordmaster
	name = "Hedge Knight"
	pants = /obj/item/clothing/pants/tights/colored/black
	backr = /obj/item/weapon/sword/long/greatsword/flamberge
	beltl = /obj/item/storage/belt/pouch/coins/mid
	shoes = /obj/item/clothing/shoes/boots/rare/grenzelplate
	gloves = /obj/item/clothing/gloves/rare/grenzelplate
	belt = /obj/item/storage/belt/leather
	shirt = /obj/item/clothing/armor/gambeson
	armor = /obj/item/clothing/armor/rare/grenzelplate
	backl = /obj/item/storage/backpack/satchel
	head = /obj/item/clothing/head/rare/grenzelplate
	wrists = /obj/item/clothing/wrists/bracers
	neck = /obj/item/clothing/neck/chaincoif
