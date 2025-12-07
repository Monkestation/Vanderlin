/datum/job/advclass/bandit/knave //sneaky bastards - ranged classes of two flavors archers and rogues
	title = "Knave"
	tutorial = "Not all followers of Matthios take by force. Thieves, poachers, and ne'er-do-wells of all forms steal from others from the shadows, long gone before their marks realize their misfortune."
	outfit = /datum/outfit/bandit/knave
	category_tags = list(CTAG_BANDIT)
	cmode_music = 'sound/music/cmode/antag/CombatBandit1.ogg'
	exp_types_granted  = list(EXP_TYPE_COMBAT, EXP_TYPE_THIEF)

/datum/outfit/bandit/knave/pre_equip(mob/living/carbon/human/H)
	..()
	H.adjust_skillrank(/datum/skill/combat/polearms, 3, TRUE)
	H.adjust_skillrank(/datum/skill/combat/axesmaces, 3, TRUE)
	H.adjust_skillrank(/datum/skill/combat/wrestling, 3, TRUE)
	H.adjust_skillrank(/datum/skill/combat/unarmed, 3, TRUE)
	H.adjust_skillrank(/datum/skill/combat/swords, 3, TRUE)
	H.adjust_skillrank(/datum/skill/combat/whipsflails, 3, TRUE)
	H.adjust_skillrank(/datum/skill/combat/knives, 3, TRUE)
	H.adjust_skillrank(/datum/skill/combat/bows, 3, TRUE)
	H.adjust_skillrank(/datum/skill/combat/crossbows, 3, TRUE)
	H.adjust_skillrank(/datum/skill/craft/crafting, 2, TRUE)
	H.adjust_skillrank(/datum/skill/craft/carpentry, 1, TRUE)
	H.adjust_skillrank(/datum/skill/misc/reading, 1, TRUE)
	H.adjust_skillrank(/datum/skill/misc/climbing, 5, TRUE)
	H.adjust_skillrank(/datum/skill/misc/sewing, 1, TRUE)
	H.adjust_skillrank(/datum/skill/misc/athletics, 2, TRUE)
	H.adjust_skillrank(/datum/skill/misc/medicine, 1, TRUE)
	H.adjust_skillrank(/datum/skill/misc/sneaking, 4, TRUE)
	H.adjust_skillrank(/datum/skill/misc/stealing, 4, TRUE)
	H.adjust_skillrank(/datum/skill/misc/lockpicking, 4, TRUE)
	H.adjust_skillrank(/datum/skill/craft/traps, 3, TRUE)
	//H.adjust_skillrank(/datum/skill/misc/tracking, 3, TRUE)
	belt = /obj/item/storage/belt/leather
	pants = /obj/item/clothing/pants/trou/leather
	shirt = /obj/item/clothing/shirt/shortshirt/colored/random
	shoes = /obj/item/clothing/shoes/boots
	mask = /obj/item/clothing/face/facemask/steel
	neck = /obj/item/clothing/neck/coif
	armor = /obj/item/clothing/armor/leather
	H.change_stat(STATKEY_END, 1)
	H.change_stat(STATKEY_PER, 2)
	H.change_stat(STATKEY_SPD, 3) //It's all about speed and perception
	ADD_TRAIT(H, TRAIT_DODGEEXPERT, TRAIT_GENERIC) //gets dodge expert but no medium armor training - gotta stay light
	H.adjust_blindness(-3)
	var/weapons = list("Crossbow & Dagger", "Bow & Sword")
	var/weapon_choice = input("Choose your weapon.", "TAKE UP ARMS") as anything in weapons
	H.set_blindness(0)
	switch(weapon_choice)
		if("Crossbow & Dagger") //Rogue
			backl= /obj/item/gun/ballistic/revolver/grenadelauncher/crossbow //we really need to make this not a grenade launcher subtype
			beltr = /obj/item/ammo_holder/quiver/bolts
			cloak = /obj/item/clothing/cloak/raincloak/colored/mortus //cool cloak
			beltl = /obj/item/weapon/knife/dagger/steel
			backr = /obj/item/storage/backpack/satchel
			backpack_contents = list(/obj/item/needle/thorn = 1, /obj/item/natural/cloth = 1, /obj/item/lockpickring/mundane = 1) //rogue gets lockpicks
			H.adjust_skillrank(/datum/skill/combat/crossbows, 1, TRUE)
			H.adjust_skillrank(/datum/skill/combat/knives, 1, TRUE)
		if("Bow & Sword") //Poacher
			backl= /obj/item/gun/ballistic/revolver/grenadelauncher/bow
			beltr = /obj/item/weapon/sword/short/iron //steel sword like literally every adventurer gets
			beltl = /obj/item/ammo_holder/quiver/arrows
			head = /obj/item/clothing/head/helmet/leather/volfhelm //cool hat
			backr = /obj/item/storage/backpack/satchel
			backpack_contents = list(/obj/item/needle/thorn = 1, /obj/item/natural/cloth = 1, /obj/item/restraints/legcuffs/beartrap = 2) //poacher gets mantraps
			H.adjust_skillrank(/datum/skill/combat/bows, 1, TRUE)
			H.adjust_skillrank(/datum/skill/combat/swords, 1, TRUE)
			ADD_TRAIT(H, TRAIT_FORAGER, TRAIT_GENERIC)
			ADD_TRAIT(H, TRAIT_BRUSHWALK, TRAIT_GENERIC)
