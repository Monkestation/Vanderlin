// Vile Highwayman. Your run of the mill swordsman, albeit fancy, smarter than the other two so he has some non combat related skills.
/datum/job/advclass/adept/highwayman
	title = "Vile Renegade"
	tutorial = "You were a former outlaw who has been given a chance to redeem yourself by the Inquisitor. You serve him and Psydon with your survival skills."
	outfit = /datum/outfit/adept/highwayman

	category_tags = list(CTAG_ADEPT)
	cmode_music = 'sound/music/cmode/towner/CombatGaffer.ogg'

	skills = list(
		/datum/skill/combat/swords = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/whipsflails = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/knives = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/wrestling = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/unarmed = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/athletics = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/swimming = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/climbing = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/riding = SKILL_LEVEL_NOVICE,
		/datum/skill/craft/crafting = SKILL_LEVEL_APPRENTICE,
		/datum/skill/craft/cooking = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/sewing = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/medicine = SKILL_LEVEL_APPRENTICE, // Try to stablize more heretics for questioning.
		/datum/skill/labor/mathematics = SKILL_LEVEL_APPRENTICE, // Smart... For a knave.
		/datum/skill/misc/reading = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/firearms = SKILL_LEVEL_NOVICE
	)

	traits = list(
		TRAIT_FORAGER,
		TRAIT_STEELHEARTED,
		TRAIT_KNOWBANDITS,
		TRAIT_INQUISITION,
		TRAIT_BLACKBAGGER,
	)

	jobstats = list(
		STATKEY_PER = 1,
		STATKEY_INT = 2,
		STATKEY_SPD = 1,
		STATKEY_CON = -1
	)


/datum/outfit/adept/highwayman/pre_equip(mob/living/carbon/human/H)
	..()
	//Armor for class
	belt = /obj/item/storage/belt/leather
	armor = /obj/item/clothing/armor/leather/jacket/leathercoat/renegade
	head = /obj/item/clothing/head/helmet/leather/tricorn
	neck = /obj/item/clothing/neck/highcollier/iron/renegadecollar
	beltl =  /obj/item/weapon/sword/short
	l_hand = /obj/item/weapon/whip // Great length, they don't need to be next to a person to help in apprehending them.
	pants = /obj/item/clothing/pants/trou/leather
	backpack_contents = list(/obj/item/storage/keyring/adept = 1, /obj/item/weapon/knife/dagger/silver/psydon = 1, /obj/item/clothing/head/inqarticles/blackbag = 1, /obj/item/inqarticles/garrote = 1,)

	if(H.dna?.species)
		H.dna.species.soundpack_m = new /datum/voicepack/male/knight() // We're going with gentleman-thief here.

/datum/outfit/adept/highwayman/post_equip(mob/living/carbon/human/H, visuals_only)
	. = ..()
	GLOB.inquisition.add_member_to_school(H, "Order of the Venatari", -10, "Renegade")
