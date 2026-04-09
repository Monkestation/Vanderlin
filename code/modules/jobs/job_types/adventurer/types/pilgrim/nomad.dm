/datum/attribute_holder/sheet/job/pilgrim/nomad
	raw_attribute_list = list(
		STAT_PERCEPTION = 2,
		STAT_ENDURANCE = 2,
		/datum/attribute/skill/craft/crafting = 20,
		/datum/attribute/skill/craft/tanning = 30,
		/datum/attribute/skill/combat/bows = 30,
		/datum/attribute/skill/combat/knives = 20,
		/datum/attribute/skill/craft/cooking = 10,
		/datum/attribute/skill/labor/butchering = 20,
		/datum/attribute/skill/labor/taming = 40,
		/datum/attribute/skill/misc/medicine = 10,
		/datum/attribute/skill/misc/sewing = 20,
		/datum/attribute/skill/misc/sneaking = 20,
		/datum/attribute/skill/craft/traps = 30,
		/datum/attribute/skill/misc/athletics = 30,
		/datum/attribute/skill/misc/climbing = 20,
		/datum/attribute/skill/misc/swimming = 10,
		/datum/attribute/skill/misc/riding = 40,
	)

/datum/job/advclass/pilgrim/nomad
	title = "Nomadic Herder"
	tutorial = "A nomad from the far steppes, you and your saigas have journeyed far to reach these lands."
	allowed_races = RACES_PLAYER_ALL
	outfit = /datum/outfit/pilgrim/nomad
	category_tags = list(CTAG_PILGRIM)
	cmode_music = 'sound/music/cmode/adventurer/CombatOutlander2.ogg'

	attribute_sheet = /datum/attribute_holder/sheet/job/pilgrim/nomad

	traits = list(TRAIT_FORAGER)

/datum/job/advclass/pilgrim/nomad/after_spawn(mob/living/carbon/human/spawned, client/player_client)
	. = ..()
	new /mob/living/simple_animal/hostile/retaliate/saiga/tame/saddled(get_turf(spawned))
	new /mob/living/simple_animal/hostile/retaliate/saigabuck/tame/saddled(get_turf(spawned))

/datum/outfit/pilgrim/nomad
	name = "Nomad (Pilgrim)"
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
