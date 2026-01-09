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

	allowed_patrons = list(/datum/patron/divine/ravox, /datum/patron/divine/abyssor, /datum/patron/divine/necra, /datum/patron/divine/dendor,/datum/patron/inhumen/graggar, /datum/patron/godless, /datum/patron/godless/autotheist, /datum/patron/godless/defiant, /datum/patron/godless/dystheist, /datum/patron/godless/naivety, /datum/patron/godless/rashan, /datum/patron/godless/galadros)

	jobstats = list(
		STATKEY_STR = 3,
		STATKEY_END = 2,
		STATKEY_CON = 2,
		STATKEY_INT = -2,
	)

	skills = list(
		/datum/skill/combat/axesmaces = 1,
		/datum/skill/combat/wrestling = 2,
		/datum/skill/combat/unarmed = 3,
		/datum/skill/combat/swords = 1,
		/datum/skill/combat/bows = 2,
		/datum/skill/craft/crafting = 1,
		/datum/skill/craft/tanning = 1,
		/datum/skill/misc/swimming = 3,
		/datum/skill/misc/climbing = 3,
		/datum/skill/misc/riding = 2,
		/datum/skill/misc/sewing = 2,
		/datum/skill/craft/cooking = 1,
		/datum/skill/misc/athletics = 3,
	)

	traits = list(
		TRAIT_STEELHEARTED,
		TRAIT_DEADNOSE,
		TRAIT_CRITICAL_RESISTANCE,
		TRAIT_NOPAINSTUN,
		TRAIT_DUALWIELDER,
	)

	voicepack_m = /datum/voicepack/male/warrior

	spells = list(
		/datum/action/cooldown/spell/undirected/barbrage
	)

/datum/job/advclass/combat/barbarian/after_spawn(mob/living/carbon/human/spawned, client/player_client)
	. = ..()
	if(istype(spawned.beltr, /obj/item/weapon/sword/iron))
		spawned.adjust_skillrank(/datum/skill/combat/swords, 2, TRUE)
	else if(istype(spawned.beltr, /obj/item/weapon/mace/woodclub) || istype(spawned.beltr, /obj/item/weapon/axe/iron))
		spawned.adjust_skillrank(/datum/skill/combat/axesmaces, 2, TRUE)

/datum/outfit/adventurer/barbarian
	name = "Barbarian (Adventurer)"
	belt = /obj/item/storage/belt/leather
	shoes = /obj/item/clothing/shoes/boots/leather
	wrists = /obj/item/clothing/wrists/bracers/leather
	beltr = /obj/item/weapon/sword/iron  // Default weapon

/datum/outfit/adventurer/barbarian/pre_equip(mob/living/carbon/human/equipped_human, visuals_only)
	. = ..()
	if(prob(50))
		backr = /obj/item/storage/backpack/satchel

	var/armortype = pickweight(list("Cloak" = 5, "Hide" = 3, "Helmet" = 2))
	var/weapontype = pickweight(list("Sword" = 4, "Club" = 3, "Axe" = 2))

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
		if("Club")
			beltr = /obj/item/weapon/mace/woodclub
		if("Axe")
			beltr = /obj/item/weapon/axe/iron
