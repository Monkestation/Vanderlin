/datum/job/advclass/disciple
	title = "Disciple"
	tutorial = "Some train their steel, others train their wits. You have honed your body itself into a weapon, anointing it with faithful markings to fortify your soul. You serve and train under the Ordo Benetarus, and one day you will be among Psydon’s most dauntless warriors."
	allowed_sexes = list(MALE, FEMALE)
	allowed_races = RACES_PLAYER_ALL
	outfit = /datum/outfit/job/disciple
	category_tags = list(CTAG_INQUISITION)
	jobstats = list(
		STATKEY_STR = 3,
		STATKEY_END = 3,
		STATKEY_CON = 3,
		STATKEY_INT = -2,
		STATKEY_SPD = -1
	)
	skills = list(
		/datum/skill/misc/athletics = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/unarmed = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/wrestling = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/climbing = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/swimming = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/medicine = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/reading = SKILL_LEVEL_APPRENTICE,
		/datum/skill/craft/cooking = SKILL_LEVEL_NOVICE,
	)

	traits = list(
		TRAIT_INQUISITION,
		TRAIT_SILVER_BLESSED,
		TRAIT_STEELHEARTED,
	)

/obj/item/storage/belt/leather/rope/dark
	color = "#505050"

/datum/outfit/job/disciple/pre_equip(mob/living/carbon/human/H)
	..()
	if(H.mind)
		var/weapons = list("Discipline - Unarmed", "Katar", "Knuckledusters", "Quarterstaff")
		var/weapon_choice = input(H,"Choose your WEAPON.", "TAKE UP PSYDON'S ARMS.") as anything in weapons
		switch(weapon_choice)
			if("Discipline - Unarmed")
				H.clamped_adjust_skillrank(/datum/skill/combat/unarmed, 5, 5, TRUE)
				H.clamped_adjust_skillrank(/datum/skill/misc/athletics, 5, 5, TRUE)
				gloves = /obj/item/clothing/gloves/bandages/pugilist
				ADD_TRAIT(H, TRAIT_CRITICAL_RESISTANCE, TRAIT_GENERIC)
				ADD_TRAIT(H, TRAIT_IGNOREDAMAGESLOWDOWN, TRAIT_GENERIC) //Removes pain-inflicted slowdowns. Does not immunize against pain, nor other means of slowdown - frostspells, unpaved terrain, etc.
			if("Katar")
				r_hand = /obj/item/weapon/katar/psydon
				gloves = /obj/item/clothing/gloves/bandages/weighted
				ADD_TRAIT(H, TRAIT_CRITICAL_RESISTANCE, TRAIT_GENERIC)
			if("Knuckledusters")
				r_hand = /obj/item/weapon/knuckles/psydon
				gloves = /obj/item/clothing/gloves/bandages/weighted
				ADD_TRAIT(H, TRAIT_CRITICAL_RESISTANCE, TRAIT_GENERIC)
			if("Quarterstaff")
				H.clamped_adjust_skillrank(/datum/skill/combat/polearms, 3, 3, TRUE)
				r_hand = /obj/item/weapon/polearm/woodstaff/quarterstaff
				gloves = /obj/item/clothing/gloves/bandages/weighted
				H.change_stat(STATKEY_PER, 1)
				H.change_stat(STATKEY_INT, 1) //Changes statblock from 3/3/3/-2/-1/0 to 3/3/3/-1/-1/1. Note that this comes at the cost of losing the 'critical resistance' trait, and retaining the unarmorable status.
		var/armors = list("Heavyweight, Blacksteel Thorns", "Lightweight, Dodge-Expert")
		var/armor_choice = input(H, "Choose your ARCHETYPE.", "TAKE UP PSYDON'S DUTY.") as anything in armors
		switch(armor_choice)
			if("Heavyweight, Blacksteel Thorns")
				head = /obj/item/clothing/head/roguehood/psydon
				mask = /obj/item/clothing/head/helmet/blacksteel/psythorns
				wrists = /obj/item/clothing/wrists/bracers/psythorns
				neck = /obj/item/clothing/neck/psycross/silver
				ring = /obj/item/clothing/ring/signet/silver
			if("Lightweight, Dodge-Expert")
				head = /obj/item/clothing/head/headband/naledi
				mask = /obj/item/clothing/face/lordmask/naledi/sojourner
				wrists = /obj/item/clothing/wrists/bracers/naledi
				neck = /obj/item/clothing/neck/psycross/g //Naledians covet gold far more than the Orthodoxists cover silver. Emphasizes their nature as 'visitors', more-so than anything else.
				ring = /obj/item/clothing/ring/signet
				ADD_TRAIT(H, TRAIT_DODGEEXPERT, TRAIT_GENERIC)
				REMOVE_TRAIT(H, TRAIT_CRITICAL_RESISTANCE, TRAIT_GENERIC)

				H.change_stat(STATKEY_CON, -3)
				H.change_stat(STATKEY_INT, 3)
				H.change_stat(STATKEY_SPD, 2) //Turns the Sojourner's unmodified statblock to 3/0/0/1/1, compared to the Disciple's 3/3/3/-2/-1.

	shoes = /obj/item/clothing/shoes/psydonboots
	armor = /obj/item/clothing/armor/regenerating/skin/disciple
	backl = /obj/item/storage/backpack/satchel/otavan
	backpack_contents = list(/obj/item/key/inquisition = 1,
	/obj/item/paper/inqslip/arrival/ortho = 1) //Kept here for now, until we figure out how to make it better fit in overfilled hands.
	belt = /obj/item/storage/belt/leather/rope/dark
	pants = /obj/item/clothing/pants/tights/colored/black
	beltl = /obj/item/storage/belt/pouch/coins/mid
	cloak = /obj/item/clothing/cloak/psydontabard/alt

/datum/outfit/job/disciple/post_equip(mob/living/carbon/human/H, visuals_only)
	. = ..()
	GLOB.inquisition.add_member_to_school(H, "Benetarus", 0, "Disciple")
