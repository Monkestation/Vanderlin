/datum/job/squire
	title = "Squire"
	tutorial = "You've always had greater aspirations than the simple life of a peasant. \n\
	You and your friends practiced the basics, swordfighting with sticks and loosing arrows into hay bale targets. \n\
	The Captain took notice of your potential, and recruited you as a personal ward. \
	\n\n\
	Learn from the garrison and train hard... maybe one dae you will be honored with knighthood."
	flag = SQUIRE
	department_flag = APPRENTICES
	job_flags = (JOB_ANNOUNCE_ARRIVAL | JOB_SHOW_IN_CREDITS | JOB_EQUIP_RANK | JOB_NEW_PLAYER_JOINABLE)
	faction = FACTION_STATION
	total_positions = 2
	spawn_positions = 2

	allowed_races = RACES_PLAYER_NONDISCRIMINATED
	allowed_sexes = list(MALE, FEMALE)
	allowed_ages = list(AGE_CHILD)

	outfit = /datum/outfit/job/squire
	display_order = JDO_SQUIRE
	give_bank_account = TRUE
	min_pq = 0
	bypass_lastclass = TRUE
	selection_color = "#304529"
	advclass_cat_rolls = list(CTAG_SQUIRE = 20)
	can_have_apprentices = FALSE


/datum/outfit/job/squire
	shirt = /obj/item/clothing/shirt/undershirt/guard
	pants = /obj/item/clothing/pants/chainlegs/iron
	shoes = /obj/item/clothing/shoes/boots
	belt = /obj/item/storage/belt/leather
	beltl = /obj/item/storage/keyring/manorguard

/datum/job/squire/after_spawn(mob/living/carbon/spawned, client/player_client)
	. = ..()

/datum/advclass/squire/lancer
	name = "Pikeman Squire"
	tutorial = "History with riding, and a bit of practice with a spear have landed you in a promising mounted position."
	outfit = /datum/outfit/job/squire/lancer

	category_tags = list(CTAG_SQUIRE)

/datum/outfit/job/squire/lancer/pre_equip(mob/living/carbon/human/H)
	r_hand = /obj/item/weapon/polearm/spear
	armor = /obj/item/clothing/armor/chainmail
	gloves = /obj/item/clothing/gloves/leather
	wrists = /obj/item/clothing/wrists/bracers/leather
	backr = /obj/item/storage/backpack/satchel
	cloak = /obj/item/clothing/cloak/stabard/guard
	backpack_contents = list(/obj/item/storage/belt/pouch/coins/poor = 1, /obj/item/clothing/neck/chaincoif = 1, /obj/item/weapon/hammer/iron = 1,)
	H.adjust_skillrank(/datum/skill/combat/axesmaces, 1, TRUE)
	H.adjust_skillrank(/datum/skill/combat/crossbows, 1, TRUE)
	H.adjust_skillrank(/datum/skill/combat/wrestling, 2, TRUE)
	H.adjust_skillrank(/datum/skill/combat/unarmed, 2, TRUE)
	H.adjust_skillrank(/datum/skill/combat/polearms, 2, TRUE)
	H.adjust_skillrank(/datum/skill/combat/knives, 1, TRUE)
	H.adjust_skillrank(/datum/skill/misc/swimming, 2, TRUE)
	H.adjust_skillrank(/datum/skill/misc/climbing, 2, TRUE)
	H.adjust_skillrank(/datum/skill/misc/athletics, 2, TRUE)
	H.adjust_skillrank(/datum/skill/misc/reading, 1, TRUE)
	H.adjust_skillrank(/datum/skill/misc/riding, 2, TRUE)
	H.adjust_skillrank(/datum/skill/craft/weaponsmithing, 1, TRUE)  // For repairing your good Royal Guards equipment
	H.adjust_skillrank(/datum/skill/craft/armorsmithing, 1, TRUE)
	H.change_stat(STATKEY_SPD, -1)
	if(H.gender == MALE && H.dna?.species)
		H.dna.species.soundpack_m = new /datum/voicepack/male/squire()
	ADD_TRAIT(H, TRAIT_MEDIUMARMOR, TRAIT_GENERIC)

/datum/advclass/squire/footman
	name = "Footman Squire"
	tutorial = "Years of hitting dummies with a sword and chasing your friends around have finally paid off."
	outfit = /datum/outfit/job/squire/footman

	category_tags = list(CTAG_SQUIRE)

/datum/outfit/job/squire/footman/pre_equip(mob/living/carbon/human/H)
	armor = /obj/item/clothing/armor/chainmail
	gloves = /obj/item/clothing/gloves/leather
	wrists = /obj/item/clothing/wrists/bracers/leather
	backr = /obj/item/storage/backpack/satchel
	beltr = /obj/item/weapon/sword/iron
	cloak = /obj/item/clothing/cloak/tabard/knight/guard
	backpack_contents = list(/obj/item/storage/belt/pouch/coins/poor = 1, /obj/item/clothing/neck/chaincoif = 1, /obj/item/weapon/hammer/iron = 1,)
	if(H.mind)
		H.adjust_skillrank(/datum/skill/combat/axesmaces, 2, TRUE)
		H.adjust_skillrank(/datum/skill/combat/crossbows, 2, TRUE)
		H.adjust_skillrank(/datum/skill/combat/wrestling, 2, TRUE)
		H.adjust_skillrank(/datum/skill/combat/unarmed, 2, TRUE)
		H.adjust_skillrank(/datum/skill/combat/swords, 2, TRUE)
		H.adjust_skillrank(/datum/skill/combat/knives, 1, TRUE)
		H.adjust_skillrank(/datum/skill/misc/swimming, 2, TRUE)
		H.adjust_skillrank(/datum/skill/misc/climbing, 2, TRUE)
		H.adjust_skillrank(/datum/skill/misc/athletics, 2, TRUE)
		H.adjust_skillrank(/datum/skill/misc/reading, 1, TRUE)
		H.adjust_skillrank(/datum/skill/craft/weaponsmithing, 1, TRUE)  // For repairing your good Royal Guards equipment
		H.adjust_skillrank(/datum/skill/craft/armorsmithing, 1, TRUE)
		H.change_stat(STATKEY_SPD, -1)
	if(H.gender == MALE && H.dna?.species)
		H.dna.species.soundpack_m = new /datum/voicepack/male/squire()
	ADD_TRAIT(H, TRAIT_MEDIUMARMOR, TRAIT_GENERIC)

/datum/advclass/squire/skirmisher
	name = "Bowman Squire"
	tutorial = "Coming from a background of hunters, your practice with a bow has proven useful for the keep."
	outfit = /datum/outfit/job/squire/skirmisher

	category_tags = list(CTAG_SQUIRE)

/datum/outfit/job/squire/skirmisher/pre_equip(mob/living/carbon/human/H)
	beltr = /obj/item/ammo_holder/quiver/arrows
	armor = /obj/item/clothing/armor/chainmail
	backl = /obj/item/gun/ballistic/revolver/grenadelauncher/bow/recurve
	gloves = /obj/item/clothing/gloves/leather
	wrists = /obj/item/clothing/wrists/bracers/leather
	backr = /obj/item/storage/backpack/satchel
	cloak = /obj/item/clothing/cloak/stabard/surcoat/guard
	backpack_contents = list(/obj/item/weapon/knife/dagger/steel = 1, /obj/item/storage/belt/pouch/coins/poor = 1, /obj/item/clothing/neck/chaincoif = 1, /obj/item/weapon/hammer/iron = 1,)
	if(H.mind)
		H.adjust_skillrank(/datum/skill/combat/bows, 2, TRUE)
		H.adjust_skillrank(/datum/skill/combat/crossbows, 1, TRUE)
		H.adjust_skillrank(/datum/skill/combat/wrestling, 1, TRUE)
		H.adjust_skillrank(/datum/skill/combat/unarmed, 1, TRUE)
		H.adjust_skillrank(/datum/skill/combat/swords, 2, TRUE)
		H.adjust_skillrank(/datum/skill/combat/knives, 2, TRUE)
		H.adjust_skillrank(/datum/skill/misc/swimming, 2, TRUE)
		H.adjust_skillrank(/datum/skill/misc/climbing, 3, TRUE)
		H.adjust_skillrank(/datum/skill/misc/athletics, 2, TRUE)
		H.adjust_skillrank(/datum/skill/misc/reading, 1, TRUE)
		H.adjust_skillrank(/datum/skill/misc/riding, 1, TRUE)
		H.adjust_skillrank(/datum/skill/craft/weaponsmithing, 1, TRUE)  // For repairing your good Royal Guards equipment
		H.adjust_skillrank(/datum/skill/craft/armorsmithing, 1, TRUE)
		H.change_stat(STATKEY_STR, -1)
		H.change_stat(STATKEY_CON, -1)
	if(H.gender == MALE && H.dna?.species)
		H.dna.species.soundpack_m = new /datum/voicepack/male/squire()
	ADD_TRAIT(H, TRAIT_DODGEEXPERT, TRAIT_GENERIC)
