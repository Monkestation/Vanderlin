/datum/attribute_holder/sheet/job/abyssal
	raw_attribute_list = list(
		/datum/attribute/skill/misc/swimming = 30,
		/datum/attribute/skill/misc/climbing = 20,
		/datum/attribute/skill/misc/athletics = 20,
		/datum/attribute/skill/misc/sneaking = 10,
		/datum/attribute/skill/combat/wrestling = 20,
		/datum/attribute/skill/combat/unarmed = 20,
		/datum/attribute/skill/combat/knives = 20,
		/datum/attribute/skill/combat/polearms = 30,
		/datum/attribute/skill/combat/swords = 20,
	)

/datum/attribute_holder/sheet/job/abyssal/girl
	raw_attribute_list = list(
		STAT_STRENGTH = 1,
		STAT_CONSTITUTION = 1,
		STAT_PERCEPTION = 2,
		STAT_INTELLIGENCE = -1,
		/datum/attribute/skill/misc/athletics = 10,
		/datum/attribute/skill/combat/unarmed = 10,
	)

/datum/attribute_holder/sheet/job/abyssal/boy
	raw_attribute_list = list(
		STAT_PERCEPTION = 2,
		STAT_INTELLIGENCE = 2,
		/datum/attribute/skill/misc/sneaking = 20,
		/datum/attribute/skill/misc/medicine = 20,
		/datum/attribute/skill/craft/cooking = 10,
		/datum/attribute/skill/craft/crafting = 10,
		/datum/attribute/skill/magic/arcane = 10,
	)

/datum/job/advclass/mercenary/abyssal
	title = "Abyssal Guard"
	tutorial = "Amphibious warriors from the depths, the Abyss Guard is a legion of triton mercenaries forged in the seas, the males are trained in the arcyne whilst the females take the vanguard with their imposing physique."
	allowed_races = list(SPEC_ID_TRITON)
	outfit = /datum/outfit/mercenary/abyssal
	category_tags = list(CTAG_MERCENARY)
	total_positions = 2
	cmode_music = 'sound/music/cmode/adventurer/CombatOutlander3.ogg'

	attribute_sheet = /datum/attribute_holder/sheet/job/abyssal

	traits = list(
		TRAIT_MEDIUMARMOR
	)

/datum/job/advclass/mercenary/abyssal/after_spawn(mob/living/carbon/human/spawned, client/player_client)
	. = ..()

	if(spawned.gender == FEMALE)
		// Female: vanguard spear + shield
		var/obj/item/weapon/polearm/spear/hoplite/abyssal/aby_spear = new(get_turf(src))
		var/obj/item/weapon/shield/tower/buckleriron/shield = new(get_turf(src))
		spawned.equip_to_appropriate_slot(aby_spear)
		spawned.equip_to_appropriate_slot(shield)
		spawned.attributes?.add_sheet(/datum/attribute_holder/sheet/job/abyssal/girl)
	if(spawned.gender == MALE)
		// Male: arcyne trident wielder
		spawned.add_spell(/datum/action/cooldown/spell/undirected/conjure_item/summon_trident)
		spawned.add_spell(/datum/action/cooldown/spell/pressure)
		spawned.mana_pool?.set_intrinsic_recharge(MANA_ALL_LEYLINES)
		spawned.attributes?.add_sheet(/datum/attribute_holder/sheet/job/abyssal/boy)

		if(!istype(spawned.patron, /datum/patron/inhumen/zizo))
			spawned.set_patron(/datum/patron/divine/noc)
	spawned.merctype = 10

/datum/outfit/mercenary/abyssal
	name = "Abyssal Guard (Mercenary)"
	shoes = /obj/item/clothing/shoes/sandals
	belt = /obj/item/storage/belt/leather/mercenary
	backl = /obj/item/storage/backpack/satchel
	armor = /obj/item/clothing/armor/medium/scale
	head = /obj/item/clothing/head/helmet/winged
	neck = /obj/item/clothing/neck/chaincoif/iron
	beltl = /obj/item/weapon/sword/sabre/cutlass
	wrists = /obj/item/clothing/wrists/bracers/leather
	scabbards = list(/obj/item/weapon/scabbard/sword)
	backpack_contents = list(
		/obj/item/key/mercenary,
		/obj/item/storage/belt/pouch/coins/poor,
	)
