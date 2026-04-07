/datum/attribute_holder/sheet/job/hoplite
	raw_attribute_list = list(
		STAT_STRENGTH = 2,
		STAT_ENDURANCE = 2,
		STAT_CONSTITUTION = 2,
		STAT_SPEED = -1,
		/datum/attribute/skill/combat/wrestling = 20,
		/datum/attribute/skill/combat/unarmed = 30,
		/datum/attribute/skill/combat/shields = 40,
		/datum/attribute/skill/misc/swimming = 30,
		/datum/attribute/skill/misc/climbing = 30,
		/datum/attribute/skill/misc/athletics = 40,
	)

/datum/attribute_holder/sheet/job/hoplite/spear
	raw_attribute_list = list(
		/datum/attribute/skill/combat/polearms = 40,
	)

/datum/attribute_holder/sheet/job/hoplite/sword
	raw_attribute_list = list(
		/datum/attribute/skill/combat/swords = 40,
	)

/datum/job/advclass/combat/hoplite
	title = "Immortal Bulwark"
	tutorial = "You have marched and fought in formations since the ancient war that nearly destroyed Psydonia. There are few in the world who can match your expertise in a shield wall, but all you have ever known is battle and obedience..."
	allowed_races = list(SPEC_ID_AASIMAR)
	outfit = /datum/outfit/folkhero/hoplite
	total_positions = 1
	category_tags = list(CTAG_FOLKHEROES)
	cmode_music = 'sound/music/cmode/adventurer/CombatIntense.ogg'

	attribute_sheet = /datum/attribute_holder/sheet/job/hoplite

	traits = list(
		TRAIT_HEAVYARMOR,
		TRAIT_STEELHEARTED,
	)

/datum/job/advclass/combat/hoplite/after_spawn(mob/living/carbon/human/spawned, client/player_client)
	. = ..()
	if(istype(spawned.backr, /obj/item/weapon/polearm/spear))
		spawned.attributes?.add_sheet(/datum/attribute_holder/sheet/job/hoplite/spear)
	else
		spawned.attributes?.add_sheet(/datum/attribute_holder/sheet/job/hoplite/sword)

/datum/outfit/folkhero/hoplite
	name = "Immortal Bulwark (Folkhero)"
	// Despite extensive combat experience, this class is exceptionally destitute. The only luxury besides combat gear that it possesses is a lantern for a source of light
	// Beneath the arms and armor is a simple loincloth, and it doesn't start with any money. This should encourage them to find someone to serve or work alongside with very quickly
	pants = /obj/item/clothing/pants/loincloth/colored/brown
	beltr = /obj/item/flashlight/flare/torch/lantern
	shoes = /obj/item/clothing/shoes/rare/hoplite
	cloak = /obj/item/clothing/cloak/half/colored/red
	belt = /obj/item/storage/belt/leather/rope
	armor = /obj/item/clothing/armor/rare/hoplite
	head = /obj/item/clothing/head/rare/hoplite
	wrists = /obj/item/clothing/wrists/bracers/rare/hoplite
	neck = /obj/item/clothing/neck/gorget/hoplite
	backl = /obj/item/weapon/shield/tower/hoplite
	// Weapon will be set in pre_equip() based on random selection
/datum/outfit/folkhero/hoplite/pre_equip(mob/living/carbon/human/H, visuals_only)
	. = ..()
	if(visuals_only)
		return

	var/weapontype = pickweight(list("Khopesh" = 5, "Spear" = 3, "WingedSpear" = 2))

	switch(weapontype)
		if("Khopesh")
			beltl = /obj/item/weapon/sword/khopesh
		if("Spear")
			backr = /obj/item/weapon/polearm/spear/hoplite
		if("WingedSpear")
			backr = /obj/item/weapon/polearm/spear/hoplite/winged
