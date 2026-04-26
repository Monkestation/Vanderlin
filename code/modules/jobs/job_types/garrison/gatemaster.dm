/datum/job/gatemaster
	title = JOB_GATEMASTER
	tutorial = "Tales speak of the Gatemaster's legendary ability to stand still at a gate and ask people questions. \
	Some may mock you as lazy sitting on your comfy chair all day, \
	but the lord themself entrusted you with who is and isn't allowed behind those gates. \
	You could almost say you're the lord's most trusted person. At least you yourself like to say that."
	department_flag = GARRISON
	job_flags = (JOB_ANNOUNCE_ARRIVAL | JOB_SHOW_IN_CREDITS | JOB_EQUIP_RANK | JOB_NEW_PLAYER_JOINABLE)
	display_order = JDO_GATEMASTER
	faction = FACTION_TOWN
	total_positions = 1
	spawn_positions = 1
	bypass_lastclass = TRUE

	allowed_races = RACES_PLAYER_ALL

	outfit = /datum/outfit/gatemaster
	advclass_cat_rolls = list(CTAG_GATEMASTER = 20)
	give_bank_account = 30
	cmode_music = 'sound/music/cmode/garrison/CombatGatekeeper.ogg'

	job_bitflag = BITFLAG_GARRISON

	exp_type = list(EXP_TYPE_GARRISON, EXP_TYPE_LIVING)
	exp_types_granted = list(EXP_TYPE_GARRISON, EXP_TYPE_COMBAT)
	exp_requirements = list(
		EXP_TYPE_LIVING = 300,
		EXP_TYPE_GARRISON = 300
	)
	honorary = JOB_GATEMASTER

	traits = list(
		TRAIT_STEELHEARTED,
	)
	mind_traits = list(TRAIT_KNOWBANDITS)
	verbs = list(
		/mob/proc/haltyell
	)

/datum/outfit/gatemaster
	name = "Gatemaster Base"
	head = /obj/item/clothing/head/helmet/townwatch/gatemaster
	shirt = /obj/item/clothing/armor/chainmail
	belt = /obj/item/storage/belt/leather/black
	pants = /obj/item/clothing/pants/trou/leather
	shoes = /obj/item/clothing/shoes/boots

/datum/outfit/gatemaster/post_equip(mob/living/carbon/human/H, visuals_only = FALSE)
	. = ..()
	if(H.wear_armor && !findtext(H.wear_armor.name, "([H.real_name])"))
		H.wear_armor.name = "[H.wear_armor.name] ([H.real_name])"

/datum/job/advclass/gatemaster
	inherit_parent_title = TRUE
	exp_type = list(EXP_TYPE_GARRISON, EXP_TYPE_COMBAT)
	exp_types_granted = list(EXP_TYPE_GARRISON, EXP_TYPE_COMBAT)

/datum/attribute_holder/sheet/job/gatemaster/whip
	raw_attribute_list = list(
		STAT_STRENGTH = 1,
		STAT_CONSTITUTION = 2,
		STAT_ENDURANCE = 2,
		STAT_PERCEPTION = -1,
		/datum/attribute/skill/combat/axesmaces = 20,
		/datum/attribute/skill/combat/whipsflails = 30,
		/datum/attribute/skill/combat/shields = 30,
		/datum/attribute/skill/combat/wrestling = 20,
		/datum/attribute/skill/combat/unarmed = 30,
		/datum/attribute/skill/combat/knives = 20,
		/datum/attribute/skill/misc/swimming = 20,
		/datum/attribute/skill/misc/climbing = 20,
		/datum/attribute/skill/misc/athletics = 30,
		/datum/attribute/skill/misc/reading = 20,
		/datum/attribute/skill/misc/sneaking = 10
	)

/datum/job/advclass/gatemaster/gatemaster_whip
	title = "Chainguard Gatemaster"
	tutorial = "Metal chimes in your hands, their skin rough from those heavy chains you pull. \
	Day by day, chains pass through your palms. \
	Day by day, the chains' coldness feels more familar. \
	Day by day, trespassers hear your chain whip rattling."
	outfit = /datum/outfit/gatemaster/whip
	category_tags = list(CTAG_GATEMASTER)

	attribute_sheet = /datum/attribute_holder/sheet/job/gatemaster/whip

	traits = list(
		TRAIT_MEDIUMARMOR,
		TRAIT_DODGEEXPERT
	)

/datum/outfit/gatemaster/whip
	name = "Chainguard Gatemaster"
	gloves = /obj/item/clothing/gloves/chain
	neck = /obj/item/clothing/neck/gorget
	armor = /obj/item/clothing/armor/leather/jacket/gatemaster_jacket/armored
	beltr = /obj/item/weapon/mace/cudgel
	beltl = /obj/item/weapon/whip/chain
	backr = /obj/item/weapon/shield/heater
	backl = /obj/item/storage/backpack/satchel/black
	backpack_contents = list(
		/obj/item/storage/keyring/manorguard = 1,
		/obj/item/weapon/knife/dagger/steel/special = 1,
		/obj/item/rope/chain = 1
	)

/datum/attribute_holder/sheet/job/gatemaster/mace
	raw_attribute_list = list(
		STAT_STRENGTH = 2,
		STAT_ENDURANCE = 1,
		STAT_CONSTITUTION = 2,
		STAT_SPEED = -1,
		/datum/attribute/skill/combat/knives = 20,
		/datum/attribute/skill/combat/axesmaces = 30,
		/datum/attribute/skill/combat/shields = 30,
		/datum/attribute/skill/combat/wrestling = 20,
		/datum/attribute/skill/combat/unarmed = 30,
		/datum/attribute/skill/misc/swimming = 20,
		/datum/attribute/skill/misc/climbing = 10,
		/datum/attribute/skill/misc/athletics = 30,
		/datum/attribute/skill/misc/reading = 20,
		/datum/attribute/skill/craft/crafting = 10
	)

/datum/job/advclass/gatemaster/gatemaster_mace
	title = "Bruiser Gatemaster"
	tutorial = "Years of work let your body grow acustome to the job. Growing large, fitting to your chair. \
	Even if you may be slower, but you dont need to be fast. \
	They are the ones that need to get past you after all. \
	Let them try to break through your armor, and let them learn how easy skulls break under cold hard steel."
	outfit = /datum/outfit/gatemaster/mace
	category_tags = list(CTAG_GATEMASTER)

	attribute_sheet = /datum/attribute_holder/sheet/job/gatemaster/mace

	traits = list(
		TRAIT_MEDIUMARMOR
	)

/datum/outfit/gatemaster/mace
	name = "Bruiser Gatemaster"
	neck = /obj/item/clothing/neck/gorget
	gloves = /obj/item/clothing/gloves/chain
	armor = /obj/item/clothing/armor/leather/jacket/gatemaster_jacket/armored
	beltr = /obj/item/weapon/mace/steel
	backr = /obj/item/weapon/shield/heater
	backl = /obj/item/storage/backpack/satchel/black
	backpack_contents = list(
		/obj/item/storage/keyring/manorguard = 1,
		/obj/item/weapon/knife/dagger/steel/special = 1,
		/obj/item/rope/chain = 1
	)

/datum/attribute_holder/sheet/job/gatemaster/bow
	raw_attribute_list = list(
		STAT_STRENGTH = 1,
		STAT_PERCEPTION = 2,
		STAT_ENDURANCE = 1,
		/datum/attribute/skill/combat/axesmaces = 20,
		/datum/attribute/skill/combat/knives = 20,
		/datum/attribute/skill/combat/bows = 30,
		/datum/attribute/skill/combat/crossbows = 30,
		/datum/attribute/skill/combat/wrestling = 20,
		/datum/attribute/skill/combat/unarmed = 30,
		/datum/attribute/skill/misc/swimming = 20,
		/datum/attribute/skill/misc/climbing = 30,
		/datum/attribute/skill/misc/athletics = 20,
		/datum/attribute/skill/misc/reading = 20,
		/datum/attribute/skill/craft/crafting = 10
	)

/datum/job/advclass/gatemaster/gatemaster_bow
	title = "Archer Gatemaster"
	tutorial = "Many may try to sneak past your post, thinking you wont see them. \
	But the years made your senses grow sharp, and your arrows sharper. \
	There is yet to be an arrow fired from you, that did not put the fear of the ten into their eyes."
	outfit = /datum/outfit/gatemaster/bow
	category_tags = list(CTAG_GATEMASTER)

	attribute_sheet = /datum/attribute_holder/sheet/job/gatemaster/bow

	traits = list(
		TRAIT_DODGEEXPERT
	)

/datum/outfit/gatemaster/bow
	name = "Archer Gatemaster"
	neck = /obj/item/clothing/neck/coif
	armor = /obj/item/clothing/armor/leather/jacket/gatemaster_jacket
	gloves = /obj/item/clothing/gloves/leather
	beltr = /obj/item/weapon/mace/cudgel
	backl = /obj/item/storage/backpack/satchel/black
	backpack_contents = list(
		/obj/item/storage/keyring/manorguard = 1,
		/obj/item/weapon/knife/dagger/steel/special = 1,
		/obj/item/rope/chain = 1
	)

/datum/outfit/gatemaster/bow/pre_equip(mob/living/carbon/human/equipped_human, visuals_only)
	. = ..()
	var/weapontypec = pickweight(list("Bow" = 4, "Crossbow" = 6))
	switch(weapontypec)
		if("Bow")
			backr = /obj/item/gun/ballistic/bow/long
			beltl = /obj/item/ammo_holder/quiver/arrows
		if("Crossbow")
			backr = /obj/item/gun/ballistic/bow/cross
			beltl = /obj/item/ammo_holder/quiver/bolts
