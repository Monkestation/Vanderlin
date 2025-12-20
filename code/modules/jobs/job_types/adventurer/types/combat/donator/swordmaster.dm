/datum/job/advclass/combat/swordmaster
	title = "Hedge Knight"
	tutorial = "You spent years serving the eastern Grenzelhoftian lords, and now you spend your days as a travelling hedge knight. Upon this island, you like to increase the fame of your sword skills, as well as your honor."
	allowed_sexes = list(MALE)
	allowed_races = list(SPEC_ID_HUMEN, SPEC_ID_AASIMAR) // not RACES_PLAYER_GRENZ because dwarves don't have a sprite for this armor
	outfit = /datum/outfit/adventurer/swordmaster
	total_positions = 1
	roll_chance = 15
	category_tags = list(CTAG_ADVENTURER)
	cmode_music = 'sound/music/cmode/combat_grenzelhoft.ogg'
	is_recognized = TRUE

/datum/outfit/adventurer/swordmaster/pre_equip(mob/living/carbon/human/H)
	..()
	if(H.mind)
		H.adjust_skillrank(/datum/skill/combat/wrestling, 3, TRUE)
		H.adjust_skillrank(/datum/skill/combat/unarmed, 3, TRUE)
		H.adjust_skillrank(/datum/skill/combat/swords, 4, TRUE)
		H.adjust_skillrank(/datum/skill/misc/climbing, 1, TRUE)
		H.adjust_skillrank(/datum/skill/misc/athletics, 3, TRUE)
		H.adjust_skillrank(/datum/skill/misc/reading, 2, TRUE)
		H.change_stat(STATKEY_STR, 2)
		H.change_stat(STATKEY_END, 2)
		H.change_stat(STATKEY_CON, 2)
		H.change_stat(STATKEY_SPD, -1)
		var/prev_real_name = H.real_name
		var/prev_name = H.name
		var/honorary = "Ritter"
		if(H.pronouns == SHE_HER)
			honorary = "Ritterin"
		H.real_name = "[honorary] [prev_real_name]"
		H.name = "[honorary] [prev_name]"

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
	if(!H.has_language(/datum/language/oldpsydonic))
		H.grant_language(/datum/language/oldpsydonic)
		to_chat(H, "<span class='info'>I can speak Old Psydonic with ,m before my speech.</span>")

	ADD_TRAIT(H, TRAIT_HEAVYARMOR, TRAIT_GENERIC)

	if(H.dna?.species.id == SPEC_ID_HUMEN)
		H.dna.species.native_language = "Old Psydonic"
		H.dna.species.accent_language = H.dna.species.get_accent(H.dna.species.native_language)
		H.dna.species.soundpack_m = new /datum/voicepack/male/knight()
