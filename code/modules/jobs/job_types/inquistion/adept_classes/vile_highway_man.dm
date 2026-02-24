// Vile Highwayman. Your run of the mill swordsman, albeit fancy, smarter than the other two so he has some non combat related skills.
/datum/job/advclass/adept/highwayman
	title = "Vile Renegade"
	tutorial = "You were a former outlaw who has been given a chance to redeem yourself by the Inquisitor. You serve him and Psydon with your survival skills."
	outfit = /datum/outfit/adept/highwayman
	category_tags = list(CTAG_ADEPT)
	cmode_music = 'sound/music/cmode/towner/CombatGaffer.ogg'

	skills = list(
		/datum/skill/combat/swords = 3,
		/datum/skill/combat/whipsflails = 2,
		/datum/skill/combat/knives = 2,
		/datum/skill/combat/wrestling = 2,
		/datum/skill/combat/unarmed = 2,
		/datum/skill/misc/athletics = 3,
		/datum/skill/misc/swimming = 2,
		/datum/skill/misc/climbing = 3,
		/datum/skill/misc/riding = 1,
		/datum/skill/craft/crafting = 2,
		/datum/skill/craft/cooking = 2,
		/datum/skill/craft/sewing = 2,
		/datum/skill/misc/medicine = 2,
		/datum/skill/labor/mathematics = 2,
		/datum/skill/misc/reading = 2,
		/datum/skill/combat/firearms = 1
	)

	traits = list(
		TRAIT_FORAGER,
		TRAIT_STEELHEARTED,
		TRAIT_KNOWBANDITS,
		TRAIT_INQUISITION,
		TRAIT_BLACKBAGGER,
		TRAIT_PSYDONIAN_GRIT,
		TRAIT_PSYDONITE,
	)

	jobstats = list(
		STATKEY_PER = 1,
		STATKEY_INT = 2,
		STATKEY_SPD = 1,
		STATKEY_CON = -1
	)

	voicepack_m = /datum/voicepack/male/knight

/datum/job/advclass/adept/highwayman/after_spawn(mob/living/carbon/human/spawned, client/player_client)
	. = ..()
	GLOB.inquisition.add_member_to_school(spawned, "Order of the Venatari", -10, "Renegade")

/datum/outfit/adept/highwayman
	name = "Vile Renegade (Adept)"
	belt = /obj/item/storage/belt/leather
	armor = /obj/item/clothing/armor/leather/jacket/leathercoat/renegade
	head = /obj/item/clothing/head/helmet/leather/tricorn
	beltl = /obj/item/weapon/sword/short/iron
	l_hand = /obj/item/weapon/whip // Great length, they don't need to be next to a person to help in apprehending them.
	backpack_contents = list(
		/obj/item/storage/keyring/adept = 1,
		/obj/item/weapon/knife/dagger/silver/psydon = 1,
		/obj/item/clothing/head/inqarticles/blackbag = 1,
		/obj/item/inqarticles/garrote = 1,
	)
