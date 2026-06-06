/datum/attribute_holder/sheet/job/berserker
	raw_attribute_list = list(
		STAT_STRENGTH = 3,
		STAT_PERCEPTION = -1,
		STAT_ENDURANCE = 1,
		STAT_CONSTITUTION = 2,
		STAT_INTELLIGENCE = -1,
		STAT_SPEED = 1,
		/datum/attribute/skill/combat/axesmaces = 30,
		/datum/attribute/skill/combat/wrestling = 30,
		/datum/attribute/skill/combat/unarmed = 30,
		/datum/attribute/skill/combat/swords = 30,
		/datum/attribute/skill/craft/tanning = 20,
		/datum/attribute/skill/misc/swimming = 40,
		/datum/attribute/skill/misc/climbing = 40,
		/datum/attribute/skill/misc/athletics = 40,
		/datum/attribute/skill/craft/cooking = 10,
		/datum/attribute/skill/labor/butchering = 10,
		/datum/attribute/skill/misc/medicine = 10,
		/datum/attribute/skill/misc/sneaking = 30
	)

/datum/job/advclass/wretch/berserker
	title = "Reaver"
	tutorial = "You are a warrior feared for your brutality, dedicated to using your might for your own gain. Might equals right, and you are the reminder of such a saying."
	allowed_sexes = list(MALE, FEMALE)
	allowed_races = RACES_PLAYER_ALL
	outfit = /datum/outfit/wretch/berserker
	total_positions = 2

	attribute_sheet = /datum/attribute_holder/sheet/job/berserker

	traits = list(
		TRAIT_STEELHEARTED,
		TRAIT_STRONGBITE,
		TRAIT_BLOODDRINKER,
		TRAIT_CRITICAL_RESISTANCE,
		TRAIT_NOPAINSTUN,
	)

	spells = list(
		/datum/action/cooldown/spell/undirected/barbrage
	)

/datum/job/advclass/wretch/berserker/on_roundstart(mob/living/carbon/human/spawned, client/player_client)
	. = ..()
	var/static/list/selectableweapon = list(
		"MY BARE HANDS!!!" = /obj/item/weapon/knife/dagger/steel,
		"Great Axe" = /obj/item/weapon/greataxe/steel,
		"Mace" = /obj/item/weapon/mace/goden/steel,
		"Sword" = /obj/item/weapon/sword/arming
	)

	var/choice = spawned.select_equippable(player_client, selectableweapon, message = "Choose Your Specialisation", title = "BERSERKER")
	if(!choice)
		return

	switch(choice)
		if("MY BARE HANDS!!!")
			spawned.adjust_skill_level(/datum/attribute/skill/combat/unarmed, 20)
			spawned.adjust_skill_level(/datum/attribute/skill/combat/knives, 40)
		if("Great Axe")
			spawned.clamped_adjust_skill_level(/datum/attribute/skill/combat/axesmaces, 40, 40, TRUE)
		if("Mace")
			spawned.clamped_adjust_skill_level(/datum/attribute/skill/combat/axesmaces, 40, 40, TRUE)
		if("Sword")
			spawned.clamped_adjust_skill_level(/datum/attribute/skill/combat/swords, 40, 40, TRUE)

/datum/outfit/wretch/berserker
	name = "Reaver (Wretch)"
	head = /obj/item/clothing/head/helmet/nasal
	mask = /obj/item/clothing/face/skullmask
	cloak = /obj/item/clothing/cloak/raincloak/furcloak/colored/brown
	wrists = /obj/item/clothing/wrists/bracers/leather
	pants = /obj/item/clothing/pants/trou/leather/advanced
	shoes = /obj/item/clothing/shoes/boots/leather/advanced
	gloves = /obj/item/clothing/gloves/leather/advanced
	backr = /obj/item/storage/backpack/satchel
	belt = /obj/item/storage/belt/leather
	neck = /obj/item/clothing/neck/chaincoif/iron
	armor = /obj/item/clothing/armor/leather/advanced
	backpack_contents = list(
		/obj/item/weapon/knife/hunting = 1,
		/obj/item/flashlight/flare/torch/lantern = 1,
		/obj/item/storage/belt/pouch/coins/poor = 1,
		/obj/item/rope/chain = 1,
		/obj/item/weapon/scabbard/knife = 1,
		/obj/item/reagent_containers/glass/bottle/stronghealthpot = 1
	)
