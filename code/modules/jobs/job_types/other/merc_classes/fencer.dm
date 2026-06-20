/datum/attribute_holder/sheet/job/fencer
	raw_attribute_list = list(
		STAT_PERCEPTION = 3,
		STAT_INTELLIGENCE = 3,
		/datum/attribute/skill/combat/swords = 40, // SKILL BLOAT!!!11!! this is because the fencer lacks major combat skills and has no armor training nor dodge expert.
		/datum/attribute/skill/combat/unarmed = 30,
		/datum/attribute/skill/combat/wrestling = 20,
		/datum/attribute/skill/misc/swimming = 30,
		/datum/attribute/skill/misc/climbing = 30,
		/datum/attribute/skill/misc/sneaking = 30,
		/datum/attribute/skill/misc/athletics = 35,
		/datum/attribute/skill/misc/reading = 10,
		/datum/attribute/skill/misc/medicine = 25,
		/datum/attribute/skill/craft/crafting = 10,
	)

/datum/job/advclass/mercenary/fencer
	title = "Fencer"
	tutorial = "A expert fencer from a prestigious fencing school in Western Grenzelhoft, trained to use their wits in duels rather then brute strength or speed. These fencers are often hired by nobles to duel on their behalf."
	allowed_races = list(SPEC_ID_HUMEN, SPEC_ID_AASIMAR, SPEC_ID_HALF_ELF, SPEC_ID_DWARF)
	outfit = /datum/outfit/mercenary/fencer
	cmode_music = 'sound/music/cmode/nobility/combat_noble.ogg'
	total_positions = 2

	attribute_sheet = /datum/attribute_holder/sheet/job/fencer

/datum/job/advclass/mercenary/fencer/after_spawn(mob/living/carbon/human/spawned, client/player_client)
	. = ..()
	spawned.merctype = 2

/datum/outfit/mercenary/fencer
	name = "Fencer (Mercenary)"
	shirt = /obj/item/clothing/armor/gambeson/arming/fencer
	gloves = /obj/item/clothing/gloves/leather/fencer
	pants = /obj/item/clothing/pants/fencer
	shoes = /obj/item/clothing/shoes/boots // placeholder until i can fix the boots
	belt = /obj/item/storage/belt/leather/cloth_belt
	beltl = /obj/item/weapon/scabbard/sword
	backl = /obj/item/storage/backpack/satchel
	beltr = /obj/item/storage/belt/pouch/coins/mid
	backpack_contents = list(
		/obj/item/natural/bundle/cloth/bandage/full = 1,
		/obj/item/storage/keyring/mercenary = 1,
		/obj/item/weapon/knife/dagger/navaja = 1 // fancy folding dagger. it looks cool and makes a funny noise
	)

/datum/job/advclass/mercenary/fencer/on_roundstart(mob/living/carbon/human/spawned, client/player_client)
	. = ..()

	var/static/list/weapons = list(
		"Longsword" = /obj/item/weapon/sword/long,
		"Sabre" = /obj/item/weapon/sword/sabre/dec,
	)

	spawned.select_equippable(player_client, weapons, message = "Choose your WEAPON.", title = "MAY YOUR AIM BE TRUE.")

	var/static/list/armors = list(
		"Fencing Cuirass" = /obj/item/clothing/armor/cuirass/fencer,
		"Fencing Jacket" = /obj/item/clothing/armor/leather/fencer,
	)
	spawned.select_equippable(player_client, armors, message = "Choose your ARMOR.", title = "MAY YOUR GUARD BE UNBREAKABLE.")
