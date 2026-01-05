/datum/job/advclass/combat/swordmaster
	title = "Hedge Knight"
	tutorial = "You spent years serving the eastern Grenzelhoftian lords, and now you spend your days as a travelling hedge knight. Upon this island, you like to increase the fame of your sword skills, as well as your honor."
	allowed_sexes = list(MALE)
	allowed_races = list(SPEC_ID_HUMEN, SPEC_ID_AASIMAR) // not RACES_PLAYER_GRENZ because dwarves don't have a sprite for this armor
	outfit = /datum/outfit/folkhero/swordmaster
	total_positions = 1
	category_tags = list(CTAG_FOLKHEROES)
	cmode_music = 'sound/music/cmode/combat_grenzelhoft.ogg'

	skills = list(
		/datum/skill/combat/wrestling = 2,
		/datum/skill/combat/unarmed = 3,
		/datum/skill/combat/swords = 4,
		/datum/skill/misc/climbing = 1,
		/datum/skill/misc/athletics = 3,
		/datum/skill/misc/reading = 2,
	)

	jobstats = list(
		STATKEY_STR = 2,
		STATKEY_END = 2,
		STATKEY_CON = 2,
		STATKEY_SPD = -1,
	)

	traits = list(
		TRAIT_HEAVYARMOR,
	)

	languages = list(/datum/language/oldpsydonic)

/datum/job/advclass/combat/swordmaster/after_spawn(mob/living/carbon/human/spawned, client/player_client)
	. = ..()
	var/prev_real_name = spawned.real_name
	var/prev_name = spawned.name
	var/honorary = "Ritter"
	if(spawned.pronouns == SHE_HER)
		honorary = "Ritterin"
	spawned.real_name = "[honorary] [prev_real_name]"
	spawned.name = "[honorary] [prev_name]"

	var/datum/species/species = spawned.dna?.species
	if(species && species.id == SPEC_ID_HUMEN)
		species.native_language = "Old Psydonic"
		species.accent_language = species.get_accent(species.native_language)
		species.soundpack_m = new /datum/voicepack/male/knight()

/datum/outfit/folkhero/swordmaster
	name = "Hedge Knight (Folkhero)"
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
