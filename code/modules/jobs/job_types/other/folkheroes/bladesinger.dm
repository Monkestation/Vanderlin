/datum/attribute_holder/sheet/job/bladesinger
	raw_attribute_list = list(
		STAT_STRENGTH = 2,
		STAT_CONSTITUTION = 1,
		STAT_ENDURANCE = 1,
		STAT_SPEED = 1,
		/datum/attribute/skill/combat/knives = 20,
		/datum/attribute/skill/combat/swords = 40,
		/datum/attribute/skill/combat/bows = 20,
		/datum/attribute/skill/combat/wrestling = 20,
		/datum/attribute/skill/combat/unarmed = 20,
		/datum/attribute/skill/misc/swimming = 20,
		/datum/attribute/skill/misc/climbing = 20,
		/datum/attribute/skill/misc/athletics = 30,
		/datum/attribute/skill/misc/reading = 20,
	)

/datum/job/advclass/combat/bladesinger
	title = "Bladesinger"
	tutorial = "Your vigil over the elven cities has long since ended. Though dutiful, the inevitable happened and now you hope these lands have use for your talents."
	allowed_races = list(SPEC_ID_ELF)
	total_positions = 1
	outfit = /datum/outfit/folkhero/bladesinger
	category_tags = list(CTAG_FOLKHEROES)
	cmode_music = 'sound/music/cmode/adventurer/CombatWarrior.ogg'

	attribute_sheet = /datum/attribute_holder/sheet/job/bladesinger

	traits = list(
		TRAIT_HEAVYARMOR,
		TRAIT_DUALWIELDER,
	)

/datum/job/advclass/combat/bladesinger/after_spawn(mob/living/carbon/human/spawned, client/player_client)
	. = ..()
	if(spawned.gender == FEMALE)
		spawned.underwear = "Femleotard"
		spawned.underwear_color = CLOTHING_SOOT_BLACK
		spawned.update_body()

/datum/outfit/folkhero/bladesinger
	name = "Bladesinger (Folkhero)"
	pants = /obj/item/clothing/pants/tights/colored/black
	backr = /obj/item/weapon/sword/long/greatsword/elfgsword
	beltl = /obj/item/storage/belt/pouch/coins/mid
	shoes = /obj/item/clothing/shoes/boots/rare/elfplate/welfplate
	gloves = /obj/item/clothing/gloves/rare/elfplate/welfplate
	belt = /obj/item/storage/belt/leather
	shirt = /obj/item/clothing/shirt/undershirt/colored/black
	armor = /obj/item/clothing/armor/rare/elfplate/welfplate
	backl = /obj/item/storage/backpack/satchel
	head = /obj/item/clothing/head/rare/elfplate/welfplate
	neck = /obj/item/clothing/neck/chaincoif
