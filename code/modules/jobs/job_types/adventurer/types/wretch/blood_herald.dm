/datum/attribute_holder/sheet/job/blood_herald
	raw_attribute_list = list(
		STAT_STRENGTH = 3,
		STAT_CONSTITUTION = 2,
		STAT_ENDURANCE = 2,
		STAT_INTELLIGENCE = 2,
		STAT_PERCEPTION = 1,
		/datum/attribute/skill/combat/polearms = 30,
		/datum/attribute/skill/combat/axesmaces = 30,
		/datum/attribute/skill/combat/wrestling = 30,
		/datum/attribute/skill/combat/unarmed = 30,
		/datum/attribute/skill/combat/swords = 40,
		/datum/attribute/skill/combat/whipsflails = 30,
		/datum/attribute/skill/misc/riding = 30,
		/datum/attribute/skill/misc/athletics = 30,
		/datum/attribute/skill/magic/blood = 40,
	)

/datum/job/advclass/wretch/blood_herald
	title = "Blood Herald"
	tutorial = "The Herald of The Forgotten, wielder of the darkest arts... you will bring ruin and remembrance to all."
	allowed_sexes = list(MALE, FEMALE)
	allowed_races = RACES_PLAYER_ALL
	outfit = /datum/outfit/wretch/blood_herald
	cmode_music = 'sound/music/cmode/antag/combat_deadlyshadows.ogg'
	total_positions = 0
	exp_types_granted = list(EXP_TYPE_COMBAT, EXP_TYPE_MAGICK)
	factions = list(FACTION_NEUTRAL, FACTION_BLOOD_MAGIC)
	allowed_patrons = list(/datum/patron/archdevil/mephistopheles, /datum/patron/archdevil/abraxas, /datum/patron/archdevil/abaddon, /datum/patron/archdevil/leviathan)

	attribute_sheet = /datum/attribute_holder/sheet/job/blood_herald

	traits = list(
		TRAIT_MEDIUMARMOR,
		TRAIT_HEAVYARMOR,
		TRAIT_BLOOD_SORCERER,
		TRAIT_VITAE_USER,
		TRAIT_BLOOD_SENSE,
		TRAIT_DEADNOSE,
		TRAIT_STEELHEARTED,
		TRAIT_BATTLE_READY,
		TRAIT_NOPAINSTUN,
	)

	languages = list(
		/datum/language/sanguine
	)

	spells = list(
		/datum/action/cooldown/spell/status/blood_sight/herald,
		/datum/action/cooldown/spell/blood_healing/herald,
		/datum/action/cooldown/spell/status/blood_mark/herald,
		/datum/action/cooldown/spell/status/blood_choke/herald,
		/datum/action/cooldown/spell/aoe/blood_harvest,
	)
	book_type = /obj/item/recipe_book/arcyne

/datum/job/advclass/wretch/blood_herald/on_roundstart(mob/living/carbon/human/spawned, client/player_client)
	. = ..()

	spawned.hud_used?.set_bloody_bloodpool()
	spawned.maxbloodpool += 1000
	spawned.set_bloodpool(2500)

	for(var/datum/mind/found_mind in get_minds(JOB_ADMIN_BLOOD_SORCERER))
		spawned.mind?.share_identities(found_mind)
	for(var/datum/mind/found_mind in get_minds("Blood Mage"))
		spawned.mind?.share_identities(found_mind)

/datum/outfit/wretch/blood_herald
	name = "Blood Herald (Wretch)"
	head = /obj/item/clothing/head/helmet/visored/blkknight/bloodsteel
	armor = /obj/item/clothing/armor/plate/blkknight/bloodsteel
	wrists = /obj/item/clothing/wrists/bracers/leather
	gloves = /obj/item/clothing/gloves/plate/blk/bloodsteel
	pants = /obj/item/clothing/pants/platelegs/blk/bloodsteel
	shoes = /obj/item/clothing/shoes/boots/armor/blkknight/bloodsteel
	ring = /obj/item/clothing/ring/rubybs
	belt = /obj/item/storage/belt/leather/black
	backl = /obj/item/storage/backpack/satchel/black
	backr = /obj/item/weapon/sword/long/greatsword/claymore/bloodsteel
	beltr = /obj/item/reagent_containers/glass/bottle/strongbloodpot/labelled
	beltl = /obj/item/weapon/knife/dagger/bloodsteel
	backpack_contents = list(
		/obj/item/reagent_containers/glass/bottle/stronghealthpot/labelled = 1,
		/obj/item/storage/belt/pouch/coins/mid = 1,
		/obj/item/needle = 1,
	)


/obj/item/clothing/head/helmet/visored/blkknight/bloodsteel
	name = "bloodsteel helmet"
	desc = "A helmet born of blood and despair."
	color = "#ff6066"
	melting_material = /datum/material/bloodsteel
	melt_amount = 200
	sellprice = 0
	examine_highlight_type = /datum/examine_highlight/heresy_alarming/bloodmagic

/obj/item/clothing/head/helmet/visored/blkknight/bloodsteel/Initialize(mapload)
	. = ..()
	enchant(/datum/enchantment/bloodcurse)

/obj/item/clothing/armor/plate/blkknight/bloodsteel
	name = "bloodsteel plate"
	desc = "A chestplate born of blood and despair."
	color = "#ff6066"
	melting_material = /datum/material/bloodsteel
	melt_amount = 300
	sellprice = 0
	examine_highlight_type = /datum/examine_highlight/heresy_alarming/bloodmagic

/obj/item/clothing/armor/plate/blkknight/bloodsteel/Initialize(mapload)
	. = ..()
	enchant(/datum/enchantment/bloodcurse)

/obj/item/clothing/shoes/boots/armor/blkknight/bloodsteel
	name = "bloodsteel boots"
	desc = "Plate boots born of blood and despair."
	color = "#ff6066"
	melting_material = /datum/material/bloodsteel
	melt_amount = 100
	sellprice = 0
	examine_highlight_type = /datum/examine_highlight/heresy_alarming/bloodmagic

/obj/item/clothing/shoes/boots/armor/blkknight/bloodsteel/Initialize(mapload)
	. = ..()
	enchant(/datum/enchantment/bloodcurse)

/obj/item/clothing/gloves/plate/blk/bloodsteel
	name = "bloodsteel gauntlets"
	desc = "Gauntlets born of blood and despair."
	color = "#ff6066"
	melting_material = /datum/material/bloodsteel
	melt_amount = 100
	sellprice = 0
	examine_highlight_type = /datum/examine_highlight/heresy_alarming/bloodmagic

/obj/item/clothing/gloves/plate/blk/bloodsteel/Initialize(mapload)
	. = ..()
	enchant(/datum/enchantment/bloodcurse)

/obj/item/clothing/pants/platelegs/blk/bloodsteel
	name = "bloodsteel greaves"
	desc = "Greaves born of blood and despair."
	color = "#ff6066"
	melting_material = /datum/material/bloodsteel
	melt_amount = 200
	sellprice = 0
	examine_highlight_type = /datum/examine_highlight/heresy_alarming/bloodmagic

/obj/item/clothing/pants/platelegs/blk/bloodsteel/Initialize(mapload)
	. = ..()
	enchant(/datum/enchantment/bloodcurse)
