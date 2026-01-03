/datum/job/advclass/mercenary/duelist
	title = "Duelist"
	tutorial = "A swordsman from Valoria, wielding a rapier with deadly precision and driven by honor and a thirst for coin, they duel with unmatched precision, seeking glory and wealth."
	allowed_races = list(\
		SPEC_ID_HUMEN,\
		SPEC_ID_ELF,\
		SPEC_ID_TIEFLING,\
		SPEC_ID_HALF_ELF,\
		SPEC_ID_HALF_DROW,\
		SPEC_ID_AASIMAR,\
		SPEC_ID_HALF_ORC,\
	) //Yes, Horcs get to be Duelists, Not Drows though.
	outfit = /datum/outfit/mercenary/duelist
	category_tags = list(CTAG_MERCENARY)
	cmode_music = 'sound/music/cmode/adventurer/CombatOutlander.ogg' //Placeholder music since apparently i can't use one from the internet...
	total_positions = 5

	jobstats = list(
		STATKEY_END = 2,
		STATKEY_SPD = 2,
		STATKEY_PER = 2,
		STATKEY_STR = -1
	)

	skills = list(
		/datum/skill/combat/swords = 4,
		/datum/skill/combat/unarmed = 3,
		/datum/skill/combat/wrestling = 3,
		/datum/skill/misc/swimming = 3,
		/datum/skill/misc/climbing = 3,
		/datum/skill/misc/sneaking = 3,
		/datum/skill/misc/athletics = 4,
		/datum/skill/misc/reading = 1,
		/datum/skill/misc/medicine = 1,
		/datum/skill/craft/crafting = 1,
		/datum/skill/craft/cooking = 3
	)

	traits = list(
		TRAIT_DODGEEXPERT
	)

/datum/job/advclass/mercenary/duelist/after_spawn(mob/living/carbon/human/spawned, client/player_client)
	. = ..()
	spawned.merctype = 8

/datum/outfit/mercenary/duelist
	name = "Duelist (Mercenary)"
	head = /obj/item/clothing/head/leather/duelhat
	cloak = /obj/item/clothing/cloak/half/duelcape
	armor = /obj/item/clothing/armor/leather/jacket/leathercoat/duelcoat
	shirt = /obj/item/clothing/shirt/undershirt
	gloves = /obj/item/clothing/gloves/leather/duelgloves
	pants = /obj/item/clothing/pants/trou/leather/advanced/colored/duelpants
	shoes = /obj/item/clothing/shoes/nobleboot/duelboots
	belt = /obj/item/storage/belt/leather/mercenary
	backl = /obj/item/storage/backpack/satchel
	backpack_contents = list(/obj/item/storage/belt/pouch/coins/mid = 1)
	scabbards = list(/obj/item/weapon/scabbard/sword)

/datum/outfit/mercenary/duelist/pre_equip(mob/living/carbon/human/equipped_human, visuals_only)
	. = ..()
	var/rando = rand(1,6)
	switch(rando)
		if(1 to 2)
			beltl = /obj/item/weapon/sword/rapier
		if(3 to 4)
			beltl = /obj/item/weapon/sword/rapier/silver //Correct, They have a chance to receive a silver rapier, due to them being from Valoria.
		if(5 to 6)
			beltl = /obj/item/weapon/sword/rapier/dec