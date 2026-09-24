/datum/attribute_holder/sheet/job/blood_herald
	raw_attribute_list = list(
		STAT_STRENGTH = 5,
		STAT_CONSTITUTION = 2,
		STAT_ENDURANCE = 2,
		STAT_INTELLIGENCE = 2,
		STAT_PERCEPTION = 1,
		/datum/attribute/skill/combat/wrestling = 30,
		/datum/attribute/skill/combat/unarmed = 30,

		/datum/attribute/skill/combat/swords = 20,
		/datum/attribute/skill/combat/whipsflails = 20,
		/datum/attribute/skill/combat/polearms = 20,
		/datum/attribute/skill/combat/axesmaces = 20,

		/datum/attribute/skill/misc/riding = 30,
		/datum/attribute/skill/misc/athletics = 30,
		/datum/attribute/skill/magic/blood = 40,
		/datum/attribute/skill/craft/armor_repair = 30,
		/datum/attribute/skill/craft/weapon_repair = 30,
	)

/datum/attribute_holder/sheet/job/blood_herald/sword
	raw_attribute_list = list()
	clamped_adjustment = list(
		/datum/attribute/skill/combat/swords = list(40, 40)
	)

/datum/attribute_holder/sheet/job/blood_herald/polearm
	raw_attribute_list = list()
	clamped_adjustment = list(
		/datum/attribute/skill/combat/polearms = list(40, 40)
	)

/datum/attribute_holder/sheet/job/blood_herald/claws
	raw_attribute_list = list()
	clamped_adjustment = list(
		/datum/attribute/skill/combat/unarmed = list(40, 40)
	)

/datum/attribute_holder/sheet/job/blood_herald/whip
	raw_attribute_list = list()
	clamped_adjustment = list(
		/datum/attribute/skill/combat/whipsflails = list(40, 40)
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
		TRAIT_CRITICAL_RESISTANCE,
		TRAIT_THIEFSENSE,
		TRAIT_DEVIL_MARKED_ABRAXAS,
		TRAIT_DEVIL_MARKED_ABADDON,
		TRAIT_DEVIL_MARKED_MEPHISTOPHELES,
		TRAIT_DEVIL_MARKED_LEVIATHAN,
	)

	languages = list(
		/datum/language/sanguine
	)

	spells = list(
		/datum/action/cooldown/spell/status/blood_sight/herald,
		/datum/action/cooldown/spell/blood_bind,
		/datum/action/cooldown/spell/recall_weapon/blood,
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

	spawned.AddComponent(/datum/component/violent_death)

	for(var/datum/mind/found_mind in get_minds(JOB_ADMIN_BLOOD_SORCERER))
		spawned.mind?.share_identities(found_mind)
	for(var/datum/mind/found_mind in get_minds("Blood Mage"))
		spawned.mind?.share_identities(found_mind)
	for(var/datum/mind/found_mind in get_minds("Blood Herald"))
		spawned.mind?.share_identities(found_mind)


	var/static/list/weapons = list(
		"Broadsword" = /obj/item/weapon/sword/long/greatsword/claymore/bloodsteel,
		"Rapier" = /obj/item/weapon/sword/rapier/bloodsteel,
		"Spear" = /obj/item/weapon/polearm/spear/bloodsteel,
		"Halberd" = /obj/item/weapon/polearm/halberd/bloodsteel,
		"Whip" = /obj/item/weapon/whip/bloodsteel,
		"Handclaws" = /obj/item/weapon/handclaw/steel/bloodsteel,
	)
	var/weapon_choice = spawned.select_equippable(player_client, weapons, message = "Choose Your Specialisation", title = "BLOOD HERALD")
	if(!weapon_choice)
		return
	switch(weapon_choice)
		if("Broadsword")
			spawned.attributes?.add_sheet(/datum/attribute_holder/sheet/job/blood_herald/sword)
		if("Rapier")
			spawned.attributes?.add_sheet(/datum/attribute_holder/sheet/job/blood_herald/sword)
		if("Spear")
			spawned.attributes?.add_sheet(/datum/attribute_holder/sheet/job/blood_herald/polearm)
		if("Halberd")
			spawned.attributes?.add_sheet(/datum/attribute_holder/sheet/job/blood_herald/polearm)
		if("Whip")
			spawned.attributes?.add_sheet(/datum/attribute_holder/sheet/job/blood_herald/whip)
		if("Handclaws")
			spawned.attributes?.add_sheet(/datum/attribute_holder/sheet/job/blood_herald/claws)
			spawned.equip_to_slot_or_del(new /obj/item/weapon/handclaw/steel/bloodsteel, ITEM_SLOT_BELT_R, TRUE)


/datum/outfit/wretch/blood_herald
	name = "Blood Herald (Wretch)"
	head = /obj/item/clothing/head/helmet/visored/blkknight/bloodsteel
	neck = /obj/item/clothing/neck/chaincoif/bloodsteel
	armor = /obj/item/clothing/armor/plate/blkknight/bloodsteel
	wrists = /obj/item/clothing/wrists/bracers/leather
	gloves = /obj/item/clothing/gloves/plate/blk/bloodsteel
	pants = /obj/item/clothing/pants/platelegs/blk/bloodsteel
	shoes = /obj/item/clothing/shoes/boots/armor/blkknight/bloodsteel
	ring = /obj/item/clothing/ring/rubybs
	belt = /obj/item/storage/belt/leather/black
	backl = /obj/item/storage/backpack/satchel/black
	beltl = /obj/item/weapon/knife/dagger/bloodsteel
	backpack_contents = list(
		/obj/item/reagent_containers/glass/bottle/stronghealthpot/labelled = 1,
		/obj/item/reagent_containers/glass/bottle/strongbloodpot/labelled = 1,
		/obj/item/weapon/hammer/steel = 1,
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

/obj/item/clothing/neck/chaincoif/bloodsteel
	name = "bloodsteel chain coif"
	desc = "A coif made of interwoven bloodsteel rings, made to protect against arrows and blades. \
			Generally used as padding, but serviceable enough on its own."
	color = "#ff6066"
	armor_type = /datum/armor/neck/maille/bloodsteel
	smeltresult = null
	melt_amount = 100
	melting_material = /datum/material/bloodsteel

/obj/item/clothing/neck/chaincoif/bloodsteel/Initialize(mapload)
	. = ..()
	enchant(/datum/enchantment/bloodcurse)
