/datum/job/squire
	title = "Squire"
	tutorial = "You've always had greater aspirations than the simple life of a peasant. \n\
	You and your friends practiced the basics, swordfighting with sticks and loosing arrows into hay bale targets. \n\
	The Captain took notice of your potential, and recruited you as a personal ward. \
	\n\n\
	Learn from the garrison and train hard... maybe one dae you will be honored with knighthood."
	department_flag = APPRENTICES
	job_flags = (JOB_ANNOUNCE_ARRIVAL | JOB_SHOW_IN_CREDITS | JOB_EQUIP_RANK | JOB_NEW_PLAYER_JOINABLE)
	faction = FACTION_TOWN
	total_positions = 2
	spawn_positions = 2
	display_order = JDO_SQUIRE
	give_bank_account = TRUE
	bypass_lastclass = TRUE
	selection_color = "#304529"
	advclass_cat_rolls = list(CTAG_SQUIRE = 20)
	can_have_apprentices = FALSE
	cmode_music = 'sound/music/cmode/garrison/CombatManAtArms.ogg'
	exp_types_granted = list(EXP_TYPE_GARRISON)

	allowed_races = RACES_PLAYER_NONDISCRIMINATED
	allowed_ages = list(AGE_CHILD, AGE_ADULT)

	outfit = /datum/outfit/squire

	exp_types_granted = list(EXP_TYPE_GARRISON)

/datum/outfit/squire
	name = "Squire"
	shirt = /obj/item/clothing/shirt/undershirt/colored/guard
	pants = /obj/item/clothing/pants/chainlegs/iron
	shoes = /obj/item/clothing/shoes/boots
	belt = /obj/item/storage/belt/leather
	beltl = /obj/item/storage/keyring/manorguard

/datum/job/advclass/squire
	allowed_ages = list(AGE_CHILD, AGE_ADULT)
	allowed_races = RACES_PLAYER_NONDISCRIMINATED
	exp_type = list(EXP_TYPE_GARRISON)
	exp_types_granted = list(EXP_TYPE_GARRISON)

/datum/job/advclass/squire/lancer
	title = "Pikeman Squire"
	tutorial = "History with riding, and a bit of practice with a spear have landed you in a promising mounted position."
	outfit = /datum/outfit/squire/lancer
	category_tags = list(CTAG_SQUIRE)

	jobstats = list(
		STATKEY_SPD = -1
	)

	skills = list(
		/datum/skill/combat/axesmaces = 1,
		/datum/skill/combat/crossbows = 1,
		/datum/skill/combat/wrestling = 2,
		/datum/skill/combat/unarmed = 2,
		/datum/skill/combat/polearms = 2,
		/datum/skill/combat/knives = 1,
		/datum/skill/misc/swimming = 2,
		/datum/skill/misc/climbing = 2,
		/datum/skill/misc/athletics = 2,
		/datum/skill/misc/reading = 1,
		/datum/skill/misc/riding = 2,
		/datum/skill/craft/weaponsmithing = 1,
		/datum/skill/craft/armorsmithing = 1
	)

	traits = list(
		TRAIT_MEDIUMARMOR
	)

/datum/job/advclass/squire/lancer/after_spawn(mob/living/carbon/human/spawned, client/player_client)
	. = ..()
	if(spawned.age == AGE_ADULT)
		spawned.adjust_stat_modifier(STATMOD_JOB, STATKEY_STR, -1)
		spawned.adjust_stat_modifier(STATMOD_JOB, STATKEY_CON, -1)

	if(spawned.gender == MALE && spawned.dna?.species)
		spawned.dna.species.soundpack_m = new /datum/voicepack/male/squire()

/datum/outfit/squire/lancer
	name = "Pikeman Squire"
	r_hand = /obj/item/weapon/polearm/spear
	armor = /obj/item/clothing/armor/chainmail
	gloves = /obj/item/clothing/gloves/leather
	wrists = /obj/item/clothing/wrists/bracers/leather
	backr = /obj/item/storage/backpack/satchel
	cloak = /obj/item/clothing/cloak/stabard/guard
	backpack_contents = list(
		/obj/item/storage/belt/pouch/coins/poor = 1,
		/obj/item/clothing/neck/chaincoif = 1,
		/obj/item/weapon/hammer/iron = 1
	)

/datum/job/advclass/squire/footman
	title = "Footman Squire"
	tutorial = "Years of hitting dummies with a sword and chasing your friends around have finally paid off."
	outfit = /datum/outfit/squire/footman
	category_tags = list(CTAG_SQUIRE)

	jobstats = list(
		STATKEY_SPD = -1
	)

	skills = list(
		/datum/skill/combat/axesmaces = 2,
		/datum/skill/combat/crossbows = 2,
		/datum/skill/combat/wrestling = 2,
		/datum/skill/combat/unarmed = 2,
		/datum/skill/combat/swords = 2,
		/datum/skill/combat/knives = 1,
		/datum/skill/misc/swimming = 2,
		/datum/skill/misc/climbing = 2,
		/datum/skill/misc/athletics = 2,
		/datum/skill/misc/reading = 1,
		/datum/skill/craft/weaponsmithing = 1,
		/datum/skill/craft/armorsmithing = 1
	)

	traits = list(
		TRAIT_MEDIUMARMOR
	)

/datum/job/advclass/squire/footman/after_spawn(mob/living/carbon/human/spawned, client/player_client)
	. = ..()
	if(spawned.age == AGE_ADULT)
		spawned.adjust_stat_modifier(STATMOD_JOB, STATKEY_STR, -1)
		spawned.adjust_stat_modifier(STATMOD_JOB, STATKEY_CON, -1)

	if(spawned.gender == MALE && spawned.dna?.species)
		spawned.dna.species.soundpack_m = new /datum/voicepack/male/squire()

/datum/outfit/squire/footman
	name = "Footman Squire"
	armor = /obj/item/clothing/armor/chainmail
	gloves = /obj/item/clothing/gloves/leather
	wrists = /obj/item/clothing/wrists/bracers/leather
	backr = /obj/item/storage/backpack/satchel
	beltr = /obj/item/weapon/sword
	cloak = /obj/item/clothing/cloak/tabard/knight/guard
	backpack_contents = list(
		/obj/item/storage/belt/pouch/coins/poor = 1,
		/obj/item/clothing/neck/chaincoif = 1,
		/obj/item/weapon/hammer/iron = 1
	)

/datum/job/advclass/squire/skirmisher
	title = "Bowman Squire"
	tutorial = "Coming from a background of hunters, your practice with a bow has proven useful for the keep."
	outfit = /datum/outfit/squire/skirmisher
	category_tags = list(CTAG_SQUIRE)

	jobstats = list(
		STATKEY_STR = -1,
		STATKEY_CON = -1
	)

	skills = list(
		/datum/skill/combat/bows = 2,
		/datum/skill/combat/crossbows = 1,
		/datum/skill/combat/wrestling = 1,
		/datum/skill/combat/unarmed = 1,
		/datum/skill/combat/swords = 2,
		/datum/skill/combat/knives = 2,
		/datum/skill/misc/swimming = 2,
		/datum/skill/misc/climbing = 3,
		/datum/skill/misc/athletics = 2,
		/datum/skill/misc/reading = 1,
		/datum/skill/misc/riding = 1,
		/datum/skill/craft/weaponsmithing = 1,
		/datum/skill/craft/armorsmithing = 1
	)

	traits = list(
		TRAIT_DODGEEXPERT
	)

/datum/job/advclass/squire/skirmisher/after_spawn(mob/living/carbon/human/spawned, client/player_client)
	. = ..()
	if(spawned.age == AGE_ADULT)
		spawned.adjust_stat_modifier(STATMOD_JOB, STATKEY_SPD, -1)

	if(spawned.gender == MALE && spawned.dna?.species)
		spawned.dna.species.soundpack_m = new /datum/voicepack/male/squire()

/datum/outfit/squire/skirmisher
	name = "Bowman Squire"
	beltr = /obj/item/ammo_holder/quiver/arrows
	armor = /obj/item/clothing/armor/chainmail
	backl = /obj/item/gun/ballistic/revolver/grenadelauncher/bow/short
	gloves = /obj/item/clothing/gloves/leather
	wrists = /obj/item/clothing/wrists/bracers/leather
	backr = /obj/item/storage/backpack/satchel
	cloak = /obj/item/clothing/cloak/stabard/jupon/guard
	backpack_contents = list(
		/obj/item/weapon/knife/dagger/steel = 1,
		/obj/item/storage/belt/pouch/coins/poor = 1,
		/obj/item/clothing/neck/chaincoif = 1,
		/obj/item/weapon/hammer/iron = 1
	)
