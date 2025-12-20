/datum/job/advclass/combat/barbarian
	title = "Barbarian"
	tutorial = "Wildmen and warriors all, Barbarians forego the intricacies of modern warfare in favour of raw strength and brutal cunning. Few of them can truly adjust to the civilized, docile lands of lords and ladies."
	allowed_races = list(\
		SPEC_ID_HUMEN,\
		SPEC_ID_HALF_ELF,\
		SPEC_ID_DWARF,\
		SPEC_ID_HALF_ORC,\
		SPEC_ID_TIEFLING,\
	)
	outfit = /datum/outfit/adventurer/barbarian
	category_tags = list(CTAG_ADVENTURER)
	cmode_music = 'sound/music/cmode/adventurer/CombatOutlander2.ogg'

	allowed_patrons = list(/datum/patron/divine/ravox, /datum/patron/divine/abyssor, /datum/patron/divine/necra, /datum/patron/divine/dendor, /datum/patron/godless, /datum/patron/inhumen/graggar)

/datum/outfit/adventurer/barbarian/pre_equip(mob/living/carbon/human/H)
	..()
	H.adjust_skillrank(/datum/skill/combat/axesmaces, 1, TRUE)
	H.adjust_skillrank(/datum/skill/combat/wrestling, 3, TRUE)
	H.adjust_skillrank(/datum/skill/combat/unarmed, 3, TRUE)
	H.adjust_skillrank(/datum/skill/combat/swords, 1, TRUE)
	H.adjust_skillrank(/datum/skill/combat/bows, 2, TRUE)  //funger reference
	H.adjust_skillrank(/datum/skill/craft/crafting, 1, TRUE)
	H.adjust_skillrank(/datum/skill/craft/tanning, 1, TRUE)
	H.adjust_skillrank(/datum/skill/misc/swimming, 3, TRUE)
	H.adjust_skillrank(/datum/skill/misc/climbing, 3, TRUE)
	H.adjust_skillrank(/datum/skill/misc/riding, 2, TRUE)
	H.adjust_skillrank(/datum/skill/misc/sewing, 2, TRUE)
	H.adjust_skillrank(/datum/skill/craft/cooking, 1, TRUE)
	H.adjust_skillrank(/datum/skill/misc/athletics, 4, TRUE)
	H.add_spell(/datum/action/cooldown/spell/undirected/barbrage)
	belt = /obj/item/storage/belt/leather
	shoes = /obj/item/clothing/shoes/boots/leather
	wrists = /obj/item/clothing/wrists/bracers/leather
	if(prob(50))
		backr = /obj/item/storage/backpack/satchel
	H.change_stat(STATKEY_STR, 3)
	H.change_stat(STATKEY_END, 2)
	H.change_stat(STATKEY_CON, 2)
	H.change_stat(STATKEY_INT, -2)
	var/armortype = pickweight(list("Cloak" = 5, "Hide" = 3, "Helmet" = 2))
	var/weapontype = pickweight(list("Sword" = 4, "Club" = 3, "Axe" = 2)) //clubs and axes share a weapon type
	switch(armortype)
		if("Cloak")
			cloak = /obj/item/clothing/cloak/raincloak/furcloak/colored/brown
		if("Hide")
			armor = /obj/item/clothing/armor/leather/hide
		if("Helmet")
			head = /obj/item/clothing/head/helmet/horned
	switch(weapontype)
		if("Sword")
			beltr = /obj/item/weapon/sword/iron
			H.adjust_skillrank(/datum/skill/combat/swords, 2, TRUE)
		if("Club")
			beltr = /obj/item/weapon/mace/woodclub
			H.adjust_skillrank(/datum/skill/combat/axesmaces, 2, TRUE)
		if("Axe")
			beltr = /obj/item/weapon/axe/iron
			H.adjust_skillrank(/datum/skill/combat/axesmaces, 2, TRUE)
	ADD_TRAIT(H, TRAIT_STEELHEARTED, TRAIT_GENERIC)
	ADD_TRAIT(H, TRAIT_DEADNOSE, TRAIT_GENERIC)
	ADD_TRAIT(H, TRAIT_CRITICAL_RESISTANCE, TRAIT_GENERIC)
	ADD_TRAIT(H, TRAIT_NOPAINSTUN, TRAIT_GENERIC)
	ADD_TRAIT(H, TRAIT_DUALWIELDER, TRAIT_GENERIC)
	if(H.dna?.species)
		H.dna.species.soundpack_m = new /datum/voicepack/male/warrior()

