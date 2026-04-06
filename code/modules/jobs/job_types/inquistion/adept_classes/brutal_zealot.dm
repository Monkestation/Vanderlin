/datum/attribute_holder/sheet/job/bzealot
	raw_attribute_list = list(
		STAT_STRENGTH = 3,
		STAT_INTELLIGENCE = -2,
		STAT_PERCEPTION = -2,
		STAT_ENDURANCE = 1,
		STAT_CONSTITUTION = 1,
		/datum/attribute/skill/combat/wrestling = 20,
		/datum/attribute/skill/combat/unarmed = 30,
		/datum/attribute/skill/combat/knives = 20,
		/datum/attribute/skill/combat/axesmaces = 30,
		/datum/attribute/skill/combat/shields = 30,
		/datum/attribute/skill/misc/swimming = 20,
		/datum/attribute/skill/misc/climbing = 20,
		/datum/attribute/skill/misc/athletics = 30,
		/datum/attribute/skill/misc/reading = 10,
		/datum/attribute/skill/combat/firearms = 10,
		/datum/attribute/skill/misc/medicine = 10
	)

// Brutal Zealot, a class balanced to town guard, with noticeably more strength but less intelligence and perception. Axe/Mace and shield focus.
/datum/job/advclass/adept/bzealot
	title = "Brutal Zealot"
	tutorial = "You are a former thug who has been given a chance to redeem yourself by the Inquisitor. You serve him and Psydon with your physical strength and zeal."
	outfit = /datum/outfit/adept/bzealot
	category_tags = list(CTAG_ADEPT)
	cmode_music = 'sound/music/cmode/church/CombatInquisitor.ogg'

	attribute_sheet = /datum/attribute_holder/sheet/job/bzealot

	traits = list(
		TRAIT_MEDIUMARMOR,
		TRAIT_STEELHEARTED,
		TRAIT_INQUISITION,
		TRAIT_PSYDONIAN_GRIT,
		TRAIT_PSYDONITE,
	)
	mind_traits = list(TRAIT_KNOWBANDITS)


/datum/job/advclass/adept/bzealot/after_spawn(mob/living/carbon/human/spawned, client/player_client)
	. = ..()
	GLOB.inquisition.add_member_to_school(spawned, "Benetarus", -10, "Zealot")

	if(spawned.dna?.species)
		spawned.dna.species.soundpack_m = new /datum/voicepack/male/warrior() // Lunkhead.

/datum/outfit/adept/bzealot
	name = "Brutal Zealot (Adept)"
	belt = /obj/item/storage/belt/leather
	head = /obj/item/clothing/head/adeptcowl
	neck = /obj/item/clothing/neck/gorget/explosive
	armor = /obj/item/clothing/armor/chainmail
	cloak = /obj/item/clothing/cloak/tabard/adept
	beltl = /obj/item/weapon/mace/spiked
	backr = /obj/item/weapon/shield/wood/adept
	gloves = /obj/item/clothing/gloves/leather
	backpack_contents = list(
		/obj/item/storage/keyring/adept = 1,
		/obj/item/weapon/knife/dagger/silver/psydon = 1
	)
