/datum/job/advclass/pilgrim/nomad
	title = "Nomadic Herder"
	tutorial = "A nomad from the far steppes, you and your saigas have journeyed far to reach these lands."
	allowed_races = RACES_PLAYER_ALL
	outfit = /datum/outfit/adventurer/nomad
	category_tags = list(CTAG_PILGRIM)
	cmode_music = 'sound/music/cmode/adventurer/CombatOutlander2.ogg'

	jobstats = list(
		STATKEY_PER = 2,
		STATKEY_END = 2,
	)

	skills = list(
		/datum/skill/craft/crafting = 2,
		/datum/skill/craft/tanning = 3,
		/datum/skill/combat/bows = 3,
		/datum/skill/combat/knives = 2,
		/datum/skill/craft/cooking = 1,
		/datum/skill/labor/butchering = 2,
		/datum/skill/labor/taming = 4,
		/datum/skill/misc/medicine = 1,
		/datum/skill/misc/sewing = 2,
		/datum/skill/misc/sneaking = 2,
		/datum/skill/craft/traps = 3,
		/datum/skill/misc/athletics = 3,
		/datum/skill/misc/climbing = 2,
		/datum/skill/misc/swimming = 1,
		/datum/skill/misc/riding = 4,
	)

	traits = list(TRAIT_FORAGER)

/datum/job/advclass/pilgrim/nomad/after_spawn(mob/living/carbon/human/spawned, client/player_client)
	. = ..()
	new /mob/living/simple_animal/hostile/retaliate/saiga/tame/saddled(get_turf(spawned))
	new /mob/living/simple_animal/hostile/retaliate/saigabuck/tame/saddled(get_turf(spawned))

/datum/outfit/adventurer/nomad
	name = "Nomad"
	pants = /obj/item/clothing/pants/tights/colored/random
	shirt =  /obj/item/clothing/armor/gambeson/light/steppe
	armor = /obj/item/clothing/armor/leather/hide/steppe
	shoes = /obj/item/clothing/shoes/boots/leather
	neck = /obj/item/storage/belt/pouch/coins/poor
	head = /obj/item/clothing/head/papakha
	cloak = /obj/item/clothing/cloak/volfmantle
	backr = /obj/item/storage/backpack/satchel
	backl = /obj/item/gun/ballistic/revolver/grenadelauncher/bow/short
	belt = /obj/item/storage/belt/leather
	beltr = /obj/item/ammo_holder/quiver/arrows
	beltl = /obj/item/storage/meatbag
	backpack_contents = list(/obj/item/bait = 1, /obj/item/weapon/knife/hunting = 1, /obj/item/tent_kit = 1)
