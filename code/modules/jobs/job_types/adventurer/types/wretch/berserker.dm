/datum/job/advclass/wretch/berserker
	title = "Reaver"
	tutorial = "You are a warrior feared for your brutality, dedicated to using your might for your own gain. Might equals right, and you are the reminder of such a saying."
	allowed_sexes = list(MALE, FEMALE)
	allowed_races = RACES_PLAYER_ALL
	outfit = /datum/outfit/wretch/berserker
	total_positions = 2

/datum/outfit/wretch/berserker/pre_equip(mob/living/carbon/human/H)
	head = /obj/item/clothing/head/helmet/nasal
	mask = /obj/item/clothing/face/skullmask
	cloak = /obj/item/clothing/cloak/raincloak/furcloak/colored/brown
	wrists = /obj/item/clothing/wrists/bracers/leather
	pants = /obj/item/clothing/pants/trou/leather/advanced
	shoes = /obj/item/clothing/shoes/boots/leather/advanced
	gloves = /obj/item/clothing/gloves/leather/advanced
	backr = /obj/item/storage/backpack/satchel
	belt = /obj/item/storage/belt/leather
	neck =	/obj/item/clothing/neck/chaincoif/iron
	armor = /obj/item/clothing/armor/leather/advanced
	backpack_contents = list(
		/obj/item/weapon/knife/hunting = 1,
		/obj/item/flashlight/flare/torch/lantern = 1,
		/obj/item/storage/belt/pouch/coins/poor = 1,
		/obj/item/rope/chain = 1,
		/obj/item/weapon/scabbard/knife = 1,
		/obj/item/reagent_containers/glass/bottle/stronghealthpot = 1,	//Small health vial
	)
	H.add_spell(/datum/action/cooldown/spell/undirected/barbrage)
	H.adjust_skillrank(/datum/skill/combat/axesmaces, 3, TRUE)
	H.adjust_skillrank(/datum/skill/combat/wrestling, 4, TRUE)
	H.adjust_skillrank(/datum/skill/combat/unarmed, 3, TRUE)
	H.adjust_skillrank(/datum/skill/combat/swords, 3, TRUE)
	H.adjust_skillrank(/datum/skill/craft/tanning, 1, TRUE)
	H.adjust_skillrank(/datum/skill/misc/swimming, 4, TRUE)
	H.adjust_skillrank(/datum/skill/misc/climbing, 4, TRUE)
	H.adjust_skillrank(/datum/skill/misc/athletics, 4, TRUE)
	H.adjust_skillrank(/datum/skill/craft/cooking, 1, TRUE)
	H.adjust_skillrank(/datum/skill/labor/butchering, 1, TRUE)
	H.adjust_skillrank(/datum/skill/misc/medicine, 1, TRUE)
	H.adjust_skillrank(/datum/skill/craft/tanning, 2, TRUE)
	H.adjust_skillrank(/datum/skill/misc/sneaking, 3, TRUE)
	H.change_stat(STATKEY_STR, 3)
	H.change_stat(STATKEY_PER, -1)
	H.change_stat(STATKEY_END, 1)
	H.change_stat(STATKEY_CON, 2)
	H.change_stat(STATKEY_INT, -1)
	H.change_stat(STATKEY_SPD, 1)

	ADD_TRAIT(H, TRAIT_STEELHEARTED, TRAIT_GENERIC)
	ADD_TRAIT(H, TRAIT_STRONGBITE, TRAIT_GENERIC)
	ADD_TRAIT(H, TRAIT_CRITICAL_RESISTANCE, TRAIT_GENERIC)
	ADD_TRAIT(H, TRAIT_NOPAINSTUN, TRAIT_GENERIC)
	ADD_TRAIT(H, TRAIT_INHUMENCAMP, TRAIT_GENERIC)

/datum/outfit/wretch/berserker/post_equip(mob/living/carbon/human/H)
	var/static/list/selectableweapon = list( \
		"MY BARE HANDS!!!" = /obj/item/weapon/knife/dagger/steel, \
		"Great Axe" = /obj/item/weapon/greataxe/steel, \
		"Mace" = /obj/item/weapon/mace/goden/steel, \
		"Sword" = /obj/item/weapon/sword/arming \
		)
	var/choice = H.select_equippable(H, selectableweapon, message = "Choose Your Specialisation", title = "BERSERKER")
	if(!choice)
		return
	switch(choice)
		if("MY BARE HANDS!!!")
			H.adjust_skillrank(/datum/skill/combat/unarmed, 2, TRUE)
			H.adjust_skillrank(/datum/skill/combat/knives, 4, TRUE)
		if("Great Axe")
			H.clamped_adjust_skillrank(/datum/skill/combat/axesmaces, 4, 4, TRUE)
		if("Mace")
			H.clamped_adjust_skillrank(/datum/skill/combat/axesmaces, 4, 4, TRUE)
		if("Sword")
			H.clamped_adjust_skillrank(/datum/skill/combat/swords, 4, 4, TRUE)
	wretch_select_bounty(H)
