/datum/job/advclass/combat/hoplite
	title = "Immortal Bulwark"
	tutorial = "You have marched and fought in formations since the ancient war that nearly destroyed Psydonia. There are few in the world who can match your expertise in a shield wall, but all you have ever known is battle and obedience..."
	allowed_races = list(SPEC_ID_AASIMAR)
	outfit = /datum/outfit/adventurer/hoplite
	total_positions = 1
	roll_chance = 15 // Same as the other very rare classes
	category_tags = list(CTAG_ADVENTURER)
	cmode_music = 'sound/music/cmode/adventurer/CombatIntense.ogg'

	skills = list(
		/datum/skill/combat/wrestling = 4,
		/datum/skill/combat/unarmed = 3,
		/datum/skill/combat/shields = 4,
		/datum/skill/misc/swimming = 3,
		/datum/skill/misc/climbing = 3,
		/datum/skill/misc/athletics = 4,
	)

	jobstats = list(
		STATKEY_STR = 2,
		STATKEY_END = 2,
		STATKEY_CON = 2,
		STATKEY_SPD = -1,
	)

	traits = list(
		TRAIT_HEAVYARMOR,
		TRAIT_STEELHEARTED,
	)

/datum/job/advclass/combat/hoplite/after_spawn(mob/living/carbon/human/spawned, client/player_client)
	. = ..()
	if(istype(spawned.backr, /obj/item/weapon/polearm/spear))
		spawned.adjust_skillrank(/datum/skill/combat/polearms, 4, TRUE)
	else
		spawned.adjust_skillrank(/datum/skill/combat/swords, 4, TRUE)

/datum/outfit/adventurer/hoplite
	name = "Immortal Bulwark (Adventurer)"
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
/datum/outfit/adventurer/hoplite/pre_equip(mob/living/carbon/human/H, visuals_only)
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