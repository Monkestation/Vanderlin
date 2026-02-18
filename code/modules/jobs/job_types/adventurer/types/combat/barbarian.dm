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

	allowed_patrons = list(/datum/patron/divine/ravox, /datum/patron/divine/abyssor, /datum/patron/divine/necra, /datum/patron/divine/dendor,/datum/patron/inhumen/graggar, /datum/patron/godless/godless, /datum/patron/godless/autotheist, /datum/patron/godless/defiant, /datum/patron/godless/dystheist, /datum/patron/godless/naivety, /datum/patron/godless/rashan, /datum/patron/godless/galadros)

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
	var/static/list/selectableweapon = list(
		"Axe" = /obj/item/weapon/axe/iron,
		"Mace" = /obj/item/weapon/mace/spiked,
		"Sword" = /obj/item/weapon/sword/iron,
		"Club" = /obj/item/weapon/mace/woodclub
	)

	var/choice = spawned.select_equippable(player_client, selectableweapon, message = "Choose Your Specialisation", title = "BARBARIAN")
	if(!choice)
		return

	switch(choice)
		if("Axe")
			spawned.clamped_adjust_skillrank(/datum/skill/combat/axesmaces, 2, 3, TRUE)
		if("Mace")
			spawned.clamped_adjust_skillrank(/datum/skill/combat/axesmaces, 2, 3, TRUE)
		if("Sword")
			spawned.clamped_adjust_skillrank(/datum/skill/combat/swords, 2, 3, TRUE)
		if("Club")
			spawned.clamped_adjust_skillrank(/datum/skill/combat/axesmaces, 2, 3, TRUE)

/datum/outfit/adventurer/barbarian
	name = "Barbarian (Adventurer)"
	head = /obj/item/clothing/head/helmet/horned
	backl = /obj/item/storage/backpack/satchel
	cloak = /obj/item/clothing/cloak/raincloak/furcloak/colored/brown
	belt = /obj/item/storage/belt/leather
	shoes = /obj/item/clothing/shoes/boots/leather
	wrists = /obj/item/clothing/wrists/bracers/leather

