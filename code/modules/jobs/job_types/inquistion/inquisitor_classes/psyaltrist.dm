/datum/job/advclass/psyaltrist
	title = "Psyaltrist"
	tutorial = "Every inquisitor has their second. You aim to keep spirits and faith high, while handling the needs of the inquisitor. Not a glamorous role, but a vital one. “Maybe his lordship would prefer the lute, today, over the viola?”"
	outfit = /datum/outfit/job/psyaltrist
	traits = list(TRAIT_DODGEEXPERT, TRAIT_EMPATH)
	category_tags = list(CTAG_INQUISITION)
	jobstats = list(
		STATKEY_STR = 1,
		STATKEY_END = 1,
		STATKEY_SPD = 3,
	)
	skills = list(
		/datum/skill/misc/music = SKILL_LEVEL_MASTER,
		/datum/skill/magic/holy = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/knives = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/wrestling = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/unarmed = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/swimming = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/climbing = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/athletics = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/reading = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/medicine = SKILL_LEVEL_APPRENTICE
	)


/datum/outfit/job/psyaltrist/pre_equip(mob/living/carbon/human/H)
	armor = /obj/item/clothing/armor/leather/studded/psyaltrist
	backl = /obj/item/storage/backpack/satchel/otavan
	cloak = /obj/item/clothing/cloak/psyaltrist
	shirt = /obj/item/clothing/armor/gambeson/heavy/inq
	gloves = /obj/item/clothing/gloves/leather/otavan
	wrists = /obj/item/clothing/neck/psycross/silver
	pants = /obj/item/clothing/pants/tights/colored/black
	shoes = /obj/item/clothing/shoes/psydonboots
	belt = /obj/item/storage/belt/leather/knifebelt/black/psydon
	beltr = /obj/item/weapon/knife/dagger/silver/psydon
	beltl = /obj/item/storage/belt/pouch/coins/mid
	ring = /obj/item/clothing/ring/signet/silver
	var/datum/inspiration/I = new /datum/inspiration(H)
	I.grant_inspiration(H, bard_tier = BARD_T3)
	backpack_contents = list(
		/obj/item/key/inquisition = 1,
		/obj/item/paper/inqslip/arrival/ortho = 1
	)


	H.add_spell(/datum/action/cooldown/spell/vicious_mockery)
	if(H.mind)
		var/weapons = list("Harp","Lute","Accordion","Guitar","Hurdy-Gurdy","Viola","Vocal Talisman", "Psyaltery", "Flute")
		var/weapon_choice = browser_input_list(H, "Choose your instrument.", "TAKE UP ARMS", weapons)
		H.set_blindness(0)
		switch(weapon_choice)
			if("Harp")
				backr = /obj/item/instrument/harp
			if("Lute")
				backr = /obj/item/instrument/lute
			if("Accordion")
				backr = /obj/item/instrument/accord
			if("Guitar")
				backr = /obj/item/instrument/guitar
			if("Hurdy-Gurdy")
				backr = /obj/item/instrument/hurdygurdy
			if("Viola")
				backr = /obj/item/instrument/viola
			if("Vocal Talisman")
				backr = /obj/item/instrument/vocals
			if("Psyaltery")
				backr = /obj/item/instrument/psyaltery
			if("Flute")
				backr = /obj/item/instrument/flute

/datum/outfit/job/psyaltrist/post_equip(mob/living/carbon/human/H, visuals_only)
	. = ..()
	GLOB.inquisition.add_member_to_school(H, "Order of the Venatari", 0, "Psyaltrist")
