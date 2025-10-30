/datum/job/advclass/wretch/reject
	title = "Rejected Royal"
	tutorial = "You were once a member of the royal family, but due to your actions, or the circumstances of your birth, you have been cast out to roam the wilds. \
	Now, you return, seeking redemption or perhaps... revenge."
	allowed_races = list(\
		SPEC_ID_HUMEN,\
		SPEC_ID_HALF_ELF,\
		SPEC_ID_HALF_DROW,\
		SPEC_ID_DWARF,\
		SPEC_ID_ELF,\
		SPEC_ID_DROW,\
		SPEC_ID_HALF_ORC,\
		SPEC_ID_TIEFLING,\
	)
	allowed_ages = list(AGE_ADULT, AGE_CHILD)
	total_positions = 1
	cmode_music = 'sound/music/cmode/nobility/combat_noble.ogg'
	outfit = /datum/outfit/wretch/reject

/datum/outfit/wretch/reject
	head = /obj/item/clothing/head/crown/circlet
	cloak = /obj/item/clothing/cloak/raincloak
	mask = /obj/item/clothing/face/shepherd/rag
	armor = /obj/item/clothing/armor/leather/advanced
	shoes = /obj/item/clothing/shoes/nobleboot
	belt = /obj/item/storage/belt/leather
	ring = /obj/item/key/manor
	beltr = /obj/item/weapon/sword
	beltl = /obj/item/ammo_holder/quiver/bolts
	neck = /obj/item/storage/belt/pouch/coins/rich
	backr = /obj/item/storage/backpack/satchel
	backl = /obj/item/gun/ballistic/revolver/grenadelauncher/crossbow
	pants = /obj/item/clothing/pants/trou/leather/advanced
	backpack_contents = list(
		/obj/item/reagent_containers/glass/cup/golden = 3,
		/obj/item/reagent_containers/glass/bottle/killersice = 1,
		/obj/item/weapon/knife/dagger/steel/special = 1,
		/obj/item/lockpickring/mundane = 1,
	)

/datum/outfit/wretch/reject/pre_equip(mob/living/carbon/human/H)
	. = ..()
	addtimer(CALLBACK(SSfamilytree, TYPE_PROC_REF(/datum/controller/subsystem/familytree, AddRoyal), H, FAMILY_PROGENY), 10 SECONDS)
	if(GLOB.keep_doors.len > 0)
		addtimer(CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(know_keep_door_password), H), 5 SECONDS)
	ADD_TRAIT(H, TRAIT_KNOWKEEPPLANS, TRAIT_GENERIC)

	if(H.gender == MALE)
		shirt = /obj/item/clothing/shirt/dress/royal/prince
		H.job = "Disowned Prince"
	if(H.gender == FEMALE)
		shirt = /obj/item/clothing/shirt/dress/royal/princess
		H.job = "Disowned Princess"

	H.adjust_skillrank(/datum/skill/combat/axesmaces, 1, TRUE)
	H.adjust_skillrank(/datum/skill/combat/bows, 2, TRUE)
	H.adjust_skillrank(/datum/skill/combat/crossbows, 3, TRUE)
	H.adjust_skillrank(/datum/skill/combat/swords, 3, TRUE)
	H.adjust_skillrank(/datum/skill/combat/wrestling, 2, TRUE)
	H.adjust_skillrank(/datum/skill/combat/unarmed, 2, TRUE)
	H.adjust_skillrank(/datum/skill/combat/knives, 4, TRUE)
	H.adjust_skillrank(/datum/skill/misc/swimming, 2, TRUE)
	H.adjust_skillrank(/datum/skill/misc/climbing, 5, TRUE)
	H.adjust_skillrank(/datum/skill/misc/athletics, 4, TRUE)
	H.adjust_skillrank(/datum/skill/misc/sneaking, 4, TRUE)
	H.adjust_skillrank(/datum/skill/misc/stealing, 4, TRUE)
	H.adjust_skillrank(/datum/skill/misc/lockpicking, 4, TRUE)
	H.adjust_skillrank(/datum/skill/misc/riding, 2, TRUE)
	H.adjust_skillrank(/datum/skill/misc/reading, 1, TRUE)
	H.adjust_skillrank(/datum/skill/craft/cooking, 1, TRUE)
	H.adjust_skillrank(/datum/skill/misc/sewing, 1, TRUE)
	H.adjust_skillrank(/datum/skill/craft/crafting, 1, TRUE)
	H.adjust_skillrank(/datum/skill/labor/mathematics, 3, TRUE)
	H.change_stat(STATKEY_STR, 1)
	H.change_stat(STATKEY_PER, 1)
	H.change_stat(STATKEY_CON, 1)
	H.change_stat(STATKEY_SPD, 2)
	H.change_stat(STATKEY_LCK, 1)
	ADD_TRAIT(H, TRAIT_BEAUTIFUL, TRAIT_GENERIC)
	ADD_TRAIT(H, TRAIT_DODGEEXPERT, TRAIT_GENERIC)
	ADD_TRAIT(H, TRAIT_LIGHT_STEP, TRAIT_GENERIC)
	if(H.dna.species.id != SPEC_ID_TIEFLING)
		ADD_TRAIT(H, TRAIT_NOBLE, TRAIT_GENERIC)

/datum/outfit/wretch/reject/post_equip(mob/living/carbon/human/H, visualsOnly)
	. = ..()
	if(alert("Do you wish to be recognized as a non-foreigner?", "", "Yes", "No") == "Yes")
		REMOVE_TRAIT(H, TRAIT_FOREIGNER, TRAIT_GENERIC)
	wretch_select_bounty(H)
