
// Brutal Zealot, a class balanced to town guard, with noticeably more strength but less intelligence and perception. Axe/Mace and shield focus.
/datum/job/advclass/adept/bzealot
	title = "Brutal Zealot"

	tutorial = "You are a former thug who has been given a chance to redeem yourself by the Inquisitor. You serve him and Psydon with your physical strength and zeal."
	outfit = /datum/outfit/adept/bzealot
	category_tags = list(CTAG_ADEPT)
	cmode_music = 'sound/music/cmode/church/CombatInquisitor.ogg'

	jobstats = list(
		STATKEY_STR = 3,
		STATKEY_INT = -2,
		STATKEY_PER = -2,
		STATKEY_END = 1,
		STATKEY_CON = 1,
	)

	traits = list(
		TRAIT_MEDIUMARMOR,
		TRAIT_STEELHEARTED,
		TRAIT_KNOWBANDITS,
		TRAIT_INQUISITION,
		TRAIT_PSYDONIAN_GRIT,
		TRAIT_PSYDONITE,
	)

	skills = list(
		/datum/skill/combat/wrestling = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/unarmed = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/knives = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/axesmaces = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/shields = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/swimming = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/climbing = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/athletics = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/reading = SKILL_LEVEL_NOVICE,
		/datum/skill/combat/firearms = SKILL_LEVEL_NOVICE,
		/datum/skill/misc/medicine = SKILL_LEVEL_NOVICE
	)

/datum/outfit/adept/bzealot/pre_equip(mob/living/carbon/human/H)
	..()
	//Armor for class
	belt = /obj/item/storage/belt/leather
	head = /obj/item/clothing/head/adeptcowl
	neck = /obj/item/clothing/neck/gorget/explosive
	armor = /obj/item/clothing/armor/chainmail
	cloak = /obj/item/clothing/cloak/tabard/adept
	beltl = /obj/item/weapon/mace/spiked
	backr = /obj/item/weapon/shield/wood/adept
	gloves = /obj/item/clothing/gloves/leather
	backpack_contents = list(/obj/item/storage/keyring/adept = 1, /obj/item/weapon/knife/dagger/silver/psydon = 1)

	if(H.dna?.species)
		H.dna.species.soundpack_m = new /datum/voicepack/male/warrior() // Lunkhead.

/datum/outfit/adept/bzealot/post_equip(mob/living/carbon/human/H, visuals_only)
	. = ..()
	GLOB.inquisition.add_member_to_school(H, "Benetarus", -10, "Zealot")
