/datum/attribute_holder/sheet/job/anthrax
	raw_attribute_list = list(
		/datum/attribute/skill/misc/swimming = 20,
		/datum/attribute/skill/misc/climbing = 20,
		/datum/attribute/skill/misc/athletics = 20,
		/datum/attribute/skill/misc/sneaking = 10,
		/datum/attribute/skill/combat/wrestling = 20,
		/datum/attribute/skill/combat/unarmed = 10,
		/datum/attribute/skill/combat/knives = 20,
		/datum/attribute/skill/misc/reading = 10,
		/datum/attribute/skill/misc/riding = 10,
	)

/datum/attribute_holder/sheet/job/anthrax/female
	raw_attribute_list = list(
		STAT_STRENGTH = 2,
		STAT_CONSTITUTION = 1,
		STAT_ENDURANCE = 1,
		STAT_INTELLIGENCE = -1,
		STAT_SPEED = -1,
		/datum/attribute/skill/combat/axesmaces = 20,
		/datum/attribute/skill/combat/whipsflails = 30,
		/datum/attribute/skill/combat/shields = 30,
	)

/datum/attribute_holder/sheet/job/anthrax/male
	raw_attribute_list = list(
		STAT_ENDURANCE = 1,
		STAT_PERCEPTION = 2,
		STAT_SPEED = 2,
		/datum/attribute/skill/misc/climbing = 10,
		/datum/attribute/skill/misc/sneaking = 20,
		/datum/attribute/skill/misc/lockpicking = 30,
		/datum/attribute/skill/combat/bows = 30,
		/datum/attribute/skill/combat/crossbows = 20,
		/datum/attribute/skill/combat/swords = 30,
		/datum/attribute/skill/misc/sewing = 10,
		/datum/attribute/skill/misc/medicine = 20,
		/datum/attribute/skill/craft/crafting = 10,
		/datum/attribute/skill/craft/cooking = 10,
		/datum/attribute/skill/craft/traps = 30,
	)

/datum/job/advclass/mercenary/anthrax
	title = "Anthrax"
	tutorial = "With the brutal dismantlement of drow society, the talents of the redeemed Anthraxi were no longer needed. Yet where one door closes, another opens - the decadent mortals of the overworld clamber over each other to bid for your blade. Show them your craft."
	allowed_races = list(SPEC_ID_DROW)
	outfit = /datum/outfit/mercenary/anthrax
	category_tags = list(CTAG_MERCENARY)
	total_positions = 5
	cmode_music = 'sound/music/cmode/adventurer/CombatOutlander3.ogg'

	attribute_sheet = /datum/attribute_holder/sheet/job/anthrax

	traits = list(
		TRAIT_STEELHEARTED
	)


/datum/job/advclass/mercenary/anthrax/after_spawn(mob/living/carbon/human/spawned, client/player_client)
	. = ..()
	add_verb(spawned, /mob/living/carbon/human/proc/torture_victim)

	if(spawned.gender == FEMALE)
		// Female: melee defense-oriented brute
		spawned.attributes?.add_sheet(/datum/attribute_holder/sheet/job/anthrax/female)

		ADD_TRAIT(spawned, TRAIT_MEDIUMARMOR, TRAIT_GENERIC)

	if(spawned.gender == MALE)
		// Male: squishy hit-and-runner
		spawned.attributes?.add_sheet(/datum/attribute_holder/sheet/job/anthrax/male)
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
