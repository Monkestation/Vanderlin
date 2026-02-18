/datum/job/advclass/mercenary/anthrax
	title = "Anthrax"
	tutorial = "With the brutal dismantlement of drow society, the talents of the redeemed Anthraxi were no longer needed. Yet where one door closes, another opens - the decadent mortals of the overworld clamber over each other to bid for your blade. Show them your craft."
	allowed_races = list(SPEC_ID_DROW)
	outfit = /datum/outfit/mercenary/anthrax
	category_tags = list(CTAG_MERCENARY)
	total_positions = 5
	cmode_music = 'sound/music/cmode/adventurer/CombatOutlander3.ogg'

	skills = list(
		/datum/skill/misc/swimming = 2,
		/datum/skill/misc/climbing = 2,
		/datum/skill/misc/athletics = 2,
		/datum/skill/misc/sneaking = 1,
		/datum/skill/combat/wrestling = 2,
		/datum/skill/combat/unarmed = 1,
		/datum/skill/combat/knives = 2,
		/datum/skill/misc/reading = 1,
		/datum/skill/misc/riding = 1,
	)

	traits = list(
		TRAIT_STEELHEARTED
	)


/datum/job/advclass/mercenary/anthrax/after_spawn(mob/living/carbon/human/spawned, client/player_client)
	. = ..()
	add_verb(spawned, /mob/living/carbon/human/proc/torture_victim)

	if(spawned.gender == FEMALE)
		// Female: melee defense-oriented brute
		spawned.adjust_skillrank(/datum/skill/combat/axesmaces, 2, TRUE)
		spawned.adjust_skillrank(/datum/skill/combat/whipsflails, 3, TRUE)
		spawned.adjust_skillrank(/datum/skill/combat/shields, 3, TRUE)

		spawned.adjust_stat_modifier(STATMOD_JOB, STATKEY_STR, 2)
		spawned.adjust_stat_modifier(STATMOD_JOB, STATKEY_CON, 1)
		spawned.adjust_stat_modifier(STATMOD_JOB, STATKEY_END, 1)
		spawned.adjust_stat_modifier(STATMOD_JOB, STATKEY_INT, -1)
		spawned.adjust_stat_modifier(STATMOD_JOB, STATKEY_SPD, -1)

		ADD_TRAIT(spawned, TRAIT_MEDIUMARMOR, TRAIT_GENERIC)

	if(spawned.gender == MALE)
		// Male: squishy hit-and-runner
		spawned.adjust_skillrank(/datum/skill/misc/climbing, 1, TRUE)
		spawned.adjust_skillrank(/datum/skill/misc/sneaking, 2, TRUE)
		spawned.adjust_skillrank(/datum/skill/misc/lockpicking, 3, TRUE)
		spawned.adjust_skillrank(/datum/skill/combat/bows, 3, TRUE)
		spawned.adjust_skillrank(/datum/skill/combat/crossbows, 2, TRUE)
		spawned.adjust_skillrank(/datum/skill/combat/swords, 3, TRUE)
		spawned.adjust_skillrank(/datum/skill/misc/sewing, 1, TRUE)
		spawned.adjust_skillrank(/datum/skill/misc/medicine, 2, TRUE)
		spawned.adjust_skillrank(/datum/skill/craft/crafting, 1, TRUE)
		spawned.adjust_skillrank(/datum/skill/craft/cooking, 1, TRUE)
		spawned.adjust_skillrank(/datum/skill/craft/traps, 3, TRUE)

		spawned.adjust_stat_modifier(STATMOD_JOB, STATKEY_END, 1)
		spawned.adjust_stat_modifier(STATMOD_JOB, STATKEY_PER, 2)
		spawned.adjust_stat_modifier(STATMOD_JOB, STATKEY_SPD, 2)

		ADD_TRAIT(spawned, TRAIT_DODGEEXPERT, TRAIT_GENERIC)

	spawned.merctype = 7


/datum/outfit/mercenary/anthrax
	name = "Anthrax (Mercenary)"
	shoes = /obj/item/clothing/shoes/boots
	belt = /obj/item/storage/belt/leather/black
	pants = /obj/item/clothing/pants/trou/shadowpants
	backl = /obj/item/storage/backpack/satchel
	backpack_contents = list(
		/obj/item/key/mercenary,
		/obj/item/storage/belt/pouch/coins/poor,
		/obj/item/weapon/knife/dagger/steel/dirk
	)

/datum/outfit/mercenary/anthrax/pre_equip(mob/living/carbon/human/equipped_human, visuals_only)
	. = ..()
	if(equipped_human.gender == FEMALE)
		armor = /obj/item/clothing/armor/cuirass/iron/shadowplate
		gloves = /obj/item/clothing/gloves/chain/iron/shadowgauntlets
		wrists = /obj/item/clothing/wrists/bracers/leather
		mask = /obj/item/clothing/face/facemask/shadowfacemask
		neck = /obj/item/clothing/neck/gorget
		backr = /obj/item/weapon/shield/tower/spidershield
		beltr = /obj/item/weapon/whip/spiderwhip

	if(equipped_human.gender == MALE)
		shirt = /obj/item/clothing/shirt/shadowshirt
		armor = /obj/item/clothing/armor/gambeson/shadowrobe
		cloak = /obj/item/clothing/cloak/half/shadowcloak
		gloves = /obj/item/clothing/gloves/fingerless/shadowgloves
		mask = /obj/item/clothing/face/shepherd/shadowmask
		neck = /obj/item/clothing/neck/chaincoif/iron
		backr = /obj/item/gun/ballistic/revolver/grenadelauncher/bow/short
		beltr = /obj/item/ammo_holder/quiver/arrows
		beltl = /obj/item/weapon/sword/sabre/stalker
		scabbards = list(/obj/item/weapon/scabbard/sword)
