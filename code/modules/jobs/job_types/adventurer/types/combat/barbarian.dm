/datum/attribute_holder/sheet/job/barbarian
	raw_attribute_list = list(
		STAT_STRENGTH = 3,
		STAT_ENDURANCE = 2,
		STAT_CONSTITUTION = 2,
		STAT_INTELLIGENCE = -2,
		/datum/attribute/skill/combat/axesmaces = 10,
		/datum/attribute/skill/combat/wrestling = 20,
		/datum/attribute/skill/combat/unarmed = 30,
		/datum/attribute/skill/combat/swords = 10,
		/datum/attribute/skill/combat/bows = 20,
		/datum/attribute/skill/craft/crafting = 10,
		/datum/attribute/skill/craft/tanning = 10,
		/datum/attribute/skill/misc/swimming = 30,
		/datum/attribute/skill/misc/climbing = 30,
		/datum/attribute/skill/misc/riding = 20,
		/datum/attribute/skill/misc/sewing = 20,
		/datum/attribute/skill/craft/cooking = 10,
		/datum/attribute/skill/misc/athletics = 30,
	)

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

	attribute_sheet = /datum/attribute_holder/sheet/job/barbarian

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
/datum/job/advclass/combat/barbarian/on_roundstart(mob/living/carbon/human/spawned, client/player_client)
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
			spawned.clamped_adjust_skill_level(/datum/attribute/skill/combat/axesmaces, 20, 30, TRUE)
		if("Mace")
			spawned.clamped_adjust_skill_level(/datum/attribute/skill/combat/axesmaces, 20, 30, TRUE)
		if("Sword")
			spawned.clamped_adjust_skill_level(/datum/attribute/skill/combat/swords, 20, 30, TRUE)
		if("Club")
			spawned.clamped_adjust_skill_level(/datum/attribute/skill/combat/axesmaces, 20, 30, TRUE)

/datum/outfit/adventurer/barbarian
	name = "Barbarian (Adventurer)"
	head = /obj/item/clothing/head/helmet/horned
	backl = /obj/item/storage/backpack/satchel
	cloak = /obj/item/clothing/cloak/raincloak/furcloak/colored/brown
	belt = /obj/item/storage/belt/leather
	shoes = /obj/item/clothing/shoes/boots/leather
	wrists = /obj/item/clothing/wrists/bracers/leather

