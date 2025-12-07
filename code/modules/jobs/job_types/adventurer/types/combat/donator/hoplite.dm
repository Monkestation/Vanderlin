/datum/job/advclass/combat/hoplite
	title = "Immortal Bulwark"
	tutorial = "You have marched and fought in formations since the ancient war that nearly destroyed Psydonia. There are few in the world who can match your expertise in a shield wall, but all you have ever known is battle and obedience..."
	allowed_races = list(SPEC_ID_AASIMAR)
	outfit = /datum/outfit/adventurer/hoplite
	total_positions = 1
	roll_chance = 15 // Same as the other very rare classes
	category_tags = list(CTAG_ADVENTURER)
	cmode_music = 'sound/music/cmode/adventurer/CombatIntense.ogg'

/datum/outfit/adventurer/hoplite/pre_equip(mob/living/carbon/human/H)
	..()
	H.adjust_skillrank(/datum/skill/combat/wrestling, 4, TRUE)
	H.adjust_skillrank(/datum/skill/combat/unarmed, 3, TRUE)
	H.adjust_skillrank(/datum/skill/combat/shields, 4, TRUE)
	H.adjust_skillrank(/datum/skill/misc/swimming, 3, TRUE)
	H.adjust_skillrank(/datum/skill/misc/climbing, 3, TRUE)
	H.adjust_skillrank(/datum/skill/misc/athletics, 4, TRUE)
	H.change_stat(STATKEY_STR, 2)
	H.change_stat(STATKEY_END, 2)
	H.change_stat(STATKEY_CON, 2)
	H.change_stat(STATKEY_SPD, -1)

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
	var/weapontype = pickweight(list("Khopesh" = 5, "Spear" = 3, "WingedSpear" = 2)) // Rolls for various weapon options based on weighted list
	switch(weapontype) // We either get a spear (winged or regular), or a khopesh sword. The weapon we get is what we get our training in
		if("Khopesh")
			beltl = /obj/item/weapon/sword/khopesh
			H.adjust_skillrank(/datum/skill/combat/swords, 4, TRUE)
		if("Spear")
			backr = /obj/item/weapon/polearm/spear/hoplite
			H.adjust_skillrank(/datum/skill/combat/polearms, 4, TRUE)
		if("WingedSpear")
			backr = /obj/item/weapon/polearm/spear/hoplite/winged
			H.adjust_skillrank(/datum/skill/combat/polearms, 4, TRUE)

	ADD_TRAIT(H, TRAIT_HEAVYARMOR, TRAIT_GENERIC)
	ADD_TRAIT(H, TRAIT_STEELHEARTED, TRAIT_GENERIC)
