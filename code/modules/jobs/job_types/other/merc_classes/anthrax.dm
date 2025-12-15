/datum/job/advclass/mercenary/anthrax
	title = "Anthrax"
	tutorial = "With the brutal dismantlement of drow society, the talents of the redeemed Anthraxi were no longer needed. Yet where one door closes, another opens - the decadent mortals of the overworld clamber over each other to bid for your blade. Show them your craft."
	allowed_races = list(SPEC_ID_DROW)
	outfit = /datum/outfit/mercenary/anthrax
	category_tags = list(CTAG_MERCENARY)
	total_positions = 5

	cmode_music = 'sound/music/cmode/adventurer/CombatOutlander3.ogg'

/datum/outfit/mercenary/anthrax/pre_equip(mob/living/carbon/human/H)
	..()
	shoes = /obj/item/clothing/shoes/boots
	belt = /obj/item/storage/belt/leather/black
	pants = /obj/item/clothing/pants/trou/shadowpants
	backl = /obj/item/storage/backpack/satchel
	backpack_contents = list(/obj/item/key/mercenary, /obj/item/storage/belt/pouch/coins/poor, /obj/item/weapon/knife/dagger/steel/dirk)
	if(H.mind)
		H.adjust_skillrank(/datum/skill/misc/swimming, 2, TRUE)
		H.adjust_skillrank(/datum/skill/misc/climbing, 3, TRUE)
		H.adjust_skillrank(/datum/skill/misc/athletics, 3, TRUE)
		H.adjust_skillrank(/datum/skill/misc/sneaking, 2, TRUE)
		H.adjust_skillrank(/datum/skill/combat/wrestling, 3, TRUE)
		H.adjust_skillrank(/datum/skill/combat/unarmed, 2, TRUE)
		H.adjust_skillrank(/datum/skill/combat/knives, 3, TRUE)
		H.adjust_skillrank(/datum/skill/misc/reading, 2, TRUE)
		H.adjust_skillrank(/datum/skill/misc/riding, 3, TRUE)

		ADD_TRAIT(H, TRAIT_STEELHEARTED, TRAIT_GENERIC)
		H.verbs |= /mob/living/carbon/human/proc/torture_victim //Secret police training owing to their origins.

		if(H.gender == FEMALE) //Melee defense-oriented brute, heavy lean towards non-lethal takedowns and capture.
			armor = /obj/item/clothing/armor/cuirass/iron/shadowplate
			gloves = /obj/item/clothing/gloves/chain/iron/shadowgauntlets
			wrists = /obj/item/clothing/wrists/bracers/leather
			mask = /obj/item/clothing/face/facemask/shadowfacemask
			neck = /obj/item/clothing/neck/gorget
			backr = /obj/item/weapon/shield/tower/spidershield
			beltr = /obj/item/weapon/whip/spiderwhip

			H.adjust_skillrank(/datum/skill/combat/axesmaces, 2, TRUE)
			H.adjust_skillrank(/datum/skill/combat/whipsflails, 4, TRUE)
			H.adjust_skillrank(/datum/skill/combat/shields, 3, TRUE)

			H.change_stat(STATKEY_STR, 2) //Grenz merc statline but with maluses.
			H.change_stat(STATKEY_CON, 1)
			H.change_stat(STATKEY_END, 1)
			H.change_stat(STATKEY_INT, -1) //Brutebrain, relies on archer for healing, lockpicking and crafting.
			H.change_stat(STATKEY_SPD, -1)

			ADD_TRAIT(H, TRAIT_MEDIUMARMOR, TRAIT_GENERIC)

		if(H.gender == MALE) //Squishy hit-and-runner assassin.
			shirt = /obj/item/clothing/shirt/shadowshirt
			armor = /obj/item/clothing/armor/gambeson/shadowrobe
			cloak = /obj/item/clothing/cloak/half/shadowcloak
			gloves = /obj/item/clothing/gloves/fingerless/shadowgloves
			mask = /obj/item/clothing/face/shepherd/shadowmask
			neck = /obj/item/clothing/neck/chaincoif/iron
			backr = /obj/item/gun/ballistic/revolver/grenadelauncher/bow/short //Coupled with the racial PER malus, abysmal damage, but good for poison arrows.
			beltr = /obj/item/ammo_holder/quiver/arrows
			var/const/obj/item/weapon/sword_type = /obj/item/weapon/sword/sabre/stalker
			beltl = sword_type
			scabbards = list(sword_type::associated_scabbard_type)

			H.adjust_skillrank(/datum/skill/misc/climbing, 1, TRUE)
			H.adjust_skillrank(/datum/skill/misc/sneaking, 2, TRUE)
			H.adjust_skillrank(/datum/skill/misc/lockpicking, 3, TRUE)
			H.adjust_skillrank(/datum/skill/combat/bows, 4, TRUE)
			H.adjust_skillrank(/datum/skill/combat/crossbows, 2, TRUE)
			H.adjust_skillrank(/datum/skill/combat/swords, 3, TRUE)
			H.adjust_skillrank(/datum/skill/misc/sewing, 1, TRUE)
			H.adjust_skillrank(/datum/skill/misc/medicine, 2, TRUE)
			H.adjust_skillrank(/datum/skill/craft/crafting, 1, TRUE)
			H.adjust_skillrank(/datum/skill/craft/cooking, 1, TRUE) //Spread-out support skills, but inferior to Steppesman/Boltslinger.
			H.adjust_skillrank(/datum/skill/craft/traps, 3, TRUE)

			H.change_stat(STATKEY_SPD, 2) //Speedier than a Steppesman, but not as tough or damaging.
			H.change_stat(STATKEY_END, 1)
			H.change_stat(STATKEY_PER, 2)

			ADD_TRAIT(H, TRAIT_DODGEEXPERT, TRAIT_GENERIC)

		H.merctype = 7
