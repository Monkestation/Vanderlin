/datum/attribute_holder/sheet/job/highwayman
	raw_attribute_list = list(
		STAT_PERCEPTION = 1,
		STAT_INTELLIGENCE = 2,
		STAT_SPEED = 1,
		STAT_CONSTITUTION = -1,
		/datum/attribute/skill/combat/swords = 30,
		/datum/attribute/skill/combat/whipsflails = 20,
		/datum/attribute/skill/combat/knives = 20,
		/datum/attribute/skill/combat/wrestling = 20,
		/datum/attribute/skill/combat/unarmed = 20,
		/datum/attribute/skill/misc/athletics = 30,
		/datum/attribute/skill/misc/swimming = 20,
		/datum/attribute/skill/misc/climbing = 30,
		/datum/attribute/skill/misc/riding = 10,
		/datum/attribute/skill/craft/crafting = 20,
		/datum/attribute/skill/craft/cooking = 20,
		/datum/attribute/skill/misc/sewing = 20,
		/datum/attribute/skill/misc/medicine = 20,
		/datum/attribute/skill/labor/mathematics = 20,
		/datum/attribute/skill/misc/reading = 20,
		/datum/attribute/skill/combat/firearms = 10
	)

// Vile Highwayman. Your run of the mill swordsman, albeit fancy, smarter than the other two so he has some non combat related skills.
/datum/job/advclass/adept/highwayman
	title = "Vile Renegade"
	tutorial = "You were a former outlaw who has been given a chance to redeem yourself by the Inquisitor. You serve him and Psydon with your survival skills."
	outfit = /datum/outfit/adept/highwayman
	category_tags = list(CTAG_ADEPT)
	cmode_music = 'sound/music/cmode/towner/CombatGaffer.ogg'

	attribute_sheet = /datum/attribute_holder/sheet/job/highwayman
	traits = list(
		TRAIT_FORAGER,
		TRAIT_STEELHEARTED,
		TRAIT_INQUISITION,
		TRAIT_BLACKBAGGER,
		TRAIT_PSYDONIAN_GRIT,
		TRAIT_PSYDONITE,
	)
	mind_traits = list(TRAIT_KNOWBANDITS)

	voicepack_m = /datum/voicepack/male/knight

/datum/job/advclass/adept/highwayman/after_spawn(mob/living/carbon/human/spawned, client/player_client)
	. = ..()
	GLOB.inquisition.add_member_to_school(spawned, "Order of the Venatari", -10, "Renegade")

/datum/outfit/adept/highwayman
	name = "Vile Renegade (Adept)"
	belt = /obj/item/storage/belt/leather
	armor = /obj/item/clothing/armor/leather/jacket/leathercoat/renegade
	head = /obj/item/clothing/head/helmet/leather/tricorn
	neck = /obj/item/clothing/neck/gorget/explosive
	beltl = /obj/item/weapon/sword/short/iron
	l_hand = /obj/item/weapon/whip // Great length, they don't need to be next to a person to help in apprehending them.
	pants = /obj/item/clothing/pants/trou/leather
	backpack_contents = list(
		/obj/item/storage/keyring/adept = 1,
		/obj/item/weapon/knife/dagger/silver/psydon = 1,
		/obj/item/clothing/head/inqarticles/blackbag = 1,
		/obj/item/inqarticles/garrote = 1,
	)
