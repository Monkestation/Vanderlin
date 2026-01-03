/datum/job/advclass/mercenary/abyssal
	title = "Abyssal Guard"
	tutorial = "Amphibious warriors from the depths, the Abyss Guard is a legion of triton mercenaries forged in the seas, the males are trained in the arcyne whilst the females take the vanguard with their imposing physique."
	allowed_races = list(SPEC_ID_TRITON)
	outfit = /datum/outfit/mercenary/abyssal
	category_tags = list(CTAG_MERCENARY)
	total_positions = 2
	cmode_music = 'sound/music/cmode/adventurer/CombatOutlander3.ogg'

	skills = list(
		/datum/skill/misc/swimming = 3,
		/datum/skill/misc/climbing = 2,
		/datum/skill/misc/athletics = 2,
		/datum/skill/misc/sneaking = 1,
		/datum/skill/combat/wrestling = 2,
		/datum/skill/combat/unarmed = 2,
		/datum/skill/combat/knives = 2,
		/datum/skill/combat/polearms = 2,
		/datum/skill/combat/swords = 2,
	)

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
		spawned.adjust_skillrank(/datum/skill/combat/shields, 3, TRUE)
		spawned.adjust_skillrank(/datum/skill/misc/athletics, 1, TRUE)
		spawned.adjust_skillrank(/datum/skill/combat/unarmed, 2, TRUE)
		spawned.adjust_stat_modifier(STATMOD_JOB, STATKEY_STR, 1)
		spawned.adjust_stat_modifier(STATMOD_JOB, STATKEY_CON, 1)
		spawned.adjust_stat_modifier(STATMOD_JOB, STATKEY_INT, -1)
		spawned.adjust_stat_modifier(STATMOD_JOB, STATKEY_PER, 2)
	if(spawned.gender == MALE)
		// Male: arcyne trident wielder
		spawned.add_spell(/datum/action/cooldown/spell/undirected/conjure_item/summon_trident)
		spawned.add_spell(/datum/action/cooldown/spell/pressure)
		spawned.mana_pool?.set_intrinsic_recharge(MANA_ALL_LEYLINES)
		spawned.adjust_skillrank(/datum/skill/misc/sneaking, 2, TRUE)
		spawned.adjust_skillrank(/datum/skill/misc/medicine, 2, TRUE)
		spawned.adjust_skillrank(/datum/skill/craft/crafting, 1, TRUE)
		spawned.adjust_skillrank(/datum/skill/craft/cooking, 1, TRUE)
		spawned.adjust_skillrank(/datum/skill/magic/arcane, 1, TRUE)
		spawned.adjust_stat_modifier(STATMOD_JOB, STATKEY_INT, 2)
		spawned.adjust_stat_modifier(STATMOD_JOB, STATKEY_PER, 2)
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
	scabbards = list(/obj/item/weapon/scabbard/sword)
	backpack_contents = list(
		/obj/item/key/mercenary,
		/obj/item/storage/belt/pouch/coins/poor,
		/obj/item/reagent_containers/food/snacks/fish/swordfish
	)
