/datum/job/courtagent
	title = JOB_COURT_AGENT
	tutorial = "Whether acquired by merit, shrewd negotiation or fulfilled bounties, \
	you have found yourself under the underhanded employ of the Hand. \
	Fulfill desires and whims of the court that they would rather not be publicly known. \
	Your position is anything but secure, and any mistake can leave you disowned and charged like the petty criminal you are. \
	Garrison and Court members know who you are."
	department_flag = NOBLEMEN
	job_flags = (JOB_EQUIP_RANK | JOB_SHOW_IN_CREDITS | JOB_NEW_PLAYER_JOINABLE)
	faction = FACTION_TOWN
	total_positions = 3
	spawn_positions = 3
	bypass_lastclass = TRUE

	allowed_ages = list(AGE_ADULT, AGE_MIDDLEAGED, AGE_IMMORTAL)
	allowed_races = RACES_PLAYER_ALL

	outfit = /datum/outfit/courtagent
	advclass_cat_rolls = list(CTAG_COURTAGENT = 20)
	cmode_music = 'sound/music/cmode/nobility/CombatSpymaster.ogg'
	job_bitflag = BITFLAG_GARRISON // counts for antag shit

	exp_type = list(EXP_TYPE_LIVING)
	exp_types_granted = list(EXP_TYPE_NOBLE, EXP_TYPE_COMBAT) //noble EXP as new Court Agents may want to transition to playing Hand with enough hours played
	exp_requirements = list(
		EXP_TYPE_LIVING = 300,
	)

	mind_traits = list(
		TRAIT_KNOW_COURTAGENT_DOORS,
		TRAIT_KNOWCOURTAGENTS
	)
	traits = list(
		TRAIT_COURTAGENT,
		TRAIT_STEELHEARTED,
		TRAIT_KEENEARS
	)
	verbs = list(
		/mob/living/carbon/human/proc/torture_victim
	)

	languages = list(/datum/language/thievescant)

/datum/job/courtagent/after_spawn(mob/living/carbon/human/spawned, client/player_client)
	if(ishuman(spawned))
		GLOB.court_agents += spawned.real_name
	return ..()

/datum/outfit/courtagent
	abstract_type = /datum/outfit/courtagent
	name = "Court Agent Base"
	belt = /obj/item/storage/belt/leather/black/courtagent
	pants = /obj/item/clothing/pants/trou/leather
	shoes = /obj/item/clothing/shoes/boots
	ring = /obj/item/clothing/ring/courtagent_ring

/datum/job/advclass/courtagent
	exp_types_granted = list(EXP_TYPE_NOBLE, EXP_TYPE_COMBAT)

/datum/attribute_holder/sheet/job/courtagent/bruiser
	raw_attribute_list = list(
		STAT_STRENGTH = 2,
		STAT_ENDURANCE = 1,
		STAT_SPEED = 3,
		STAT_INTELLIGENCE = -2,
		/datum/attribute/skill/combat/unarmed = 30,
		/datum/attribute/skill/combat/wrestling = 30,
		/datum/attribute/skill/combat/knives = 20,
		/datum/attribute/skill/misc/athletics = 30,
		/datum/attribute/skill/misc/swimming = 20,
		/datum/attribute/skill/misc/sneaking = 40,
		/datum/attribute/skill/misc/climbing = 40,
		/datum/attribute/skill/misc/lockpicking = 40,
		/datum/attribute/skill/misc/stealing = 40,
		/datum/attribute/skill/craft/crafting = 10,
		/datum/attribute/skill/misc/reading = 10
	)

/datum/attribute_holder/sheet/job/courtagent/bruiser/barehanded
	raw_attribute_list = list()
	clamped_adjustment = list(
		/datum/attribute/skill/combat/unarmed = list(35, 35),
		/datum/attribute/skill/combat/wrestling = list (35, 35)
	)

/datum/job/advclass/courtagent/bruiser
	title = "Bruiser"
	tutorial = "You are one of the Hand's loyal Agents. \
	From a very early age growing up on the streets, you learned the best ways to cause harm to people using nothing but your fists and your wits. \
	Eventually, you became employed by the Hand as personal muscle. When the Hand gives the order, you go and break some legs."
	outfit = /datum/outfit/courtagent/bruiser
	category_tags = list(CTAG_COURTAGENT)

	attribute_sheet = /datum/attribute_holder/sheet/job/courtagent/bruiser

	traits = list(
		TRAIT_DODGEEXPERT
	)

/datum/outfit/courtagent/bruiser
	name = "Bruiser"
	cloak = /obj/item/clothing/cloak/raincloak
	shirt = /obj/item/clothing/shirt/undershirt/colored/black
	armor = /obj/item/clothing/armor/leather/splint
	backr = /obj/item/storage/backpack/satchel/black
	backpack_contents = list(
		/obj/item/storage/belt/pouch/coins/poor = 1
	)

/datum/job/advclass/courtagent/bruiser/on_roundstart(mob/living/carbon/human/spawned, client/player_client)
	. = ..()

	var/static/list/weapons = list(
		"Steel Knuckles" = /obj/item/weapon/knuckles,
		"Steel Katar" = /obj/item/weapon/katar,
		"Bare Handed" = /obj/item/clothing/gloves/bandages/pugilist,
	)
	var/weapon_choice = spawned.select_equippable(player_client, weapons, message = "Choose Your Specialisation", title = "COURT AGENT")
	if(!weapon_choice)
		return
	switch(weapon_choice)
		if("Bare Handed")
			spawned.attributes?.add_sheet(/datum/attribute_holder/sheet/job/courtagent/bruiser/barehanded)

/datum/attribute_holder/sheet/job/courtagent/hitman
	raw_attribute_list = list(
		STAT_STRENGTH = -1,
		STAT_ENDURANCE = 1,
		STAT_PERCEPTION = 2,
		STAT_SPEED = 3,
		/datum/attribute/skill/combat/unarmed = 20,
		/datum/attribute/skill/combat/wrestling = 30,
		/datum/attribute/skill/combat/knives = 30,
		/datum/attribute/skill/misc/athletics = 30,
		/datum/attribute/skill/misc/swimming = 20,
		/datum/attribute/skill/misc/sneaking = 50,
		/datum/attribute/skill/misc/climbing = 50,
		/datum/attribute/skill/misc/stealing = 50,
		/datum/attribute/skill/misc/lockpicking = 50,
		/datum/attribute/skill/craft/crafting = 10,
		/datum/attribute/skill/misc/reading = 10
	)

/datum/attribute_holder/sheet/job/courtagent/hitman/shortbow
	raw_attribute_list = list()
	clamped_adjustment = list(
		/datum/attribute/skill/combat/bows = list(30, 30)
	)

/datum/attribute_holder/sheet/job/courtagent/hitman/crossbow
	raw_attribute_list = list()
	clamped_adjustment = list(
		/datum/attribute/skill/combat/crossbows = list(30, 30)
	)

/datum/job/advclass/courtagent/hitman
	title = "Hitman"
	tutorial = "You are one of the Hand's loyal Agents. \
	Before finding yourself employed at the Court, you were an Assassin for hire. You took gold and killed without question. \
	Now for steady pay, you aid the Hand and the Court in matters that the public had best not know about. \
	Your targets are picked out, and you execute without question, as you always have done."
	outfit = /datum/outfit/courtagent/hitman
	category_tags = list(CTAG_COURTAGENT)

	attribute_sheet = /datum/attribute_holder/sheet/job/courtagent/hitman

	traits = list(
		TRAIT_DODGEEXPERT
	)

/datum/outfit/courtagent/hitman
	name = "Hitman"
	cloak = /obj/item/clothing/cloak/raincloak
	shirt = /obj/item/clothing/shirt/undershirt/colored/black
	armor = /obj/item/clothing/armor/leather/splint
	gloves = /obj/item/clothing/gloves/fingerless
	wrists = /obj/item/clothing/wrists/bracers/leather
	backr = /obj/item/storage/backpack/satchel/black
	backpack_contents = list(
		/obj/item/storage/belt/pouch/coins/poor = 1
	)

/datum/job/advclass/courtagent/hitman/on_roundstart(mob/living/carbon/human/spawned, client/player_client)
	. = ..()

	var/static/list/weapons = list(
		"Shortbow" = /obj/item/gun/ballistic/bow/short,
		"Crossbow" = /obj/item/gun/ballistic/bow/cross,
	)
	var/weapon_choice = spawned.select_equippable(player_client, weapons, message = "Choose Your Specialisation", title = "COURT AGENT")
	if(!weapon_choice)
		return
	switch(weapon_choice)
		if("Shortbow")
			spawned.equip_to_slot_or_del(new /obj/item/ammo_holder/quiver/arrows, ITEM_SLOT_BELT_L, TRUE)
			spawned.attributes?.add_sheet(/datum/attribute_holder/sheet/job/courtagent/hitman/shortbow)
		if("Crossbow")
			spawned.equip_to_slot_or_del(new /obj/item/ammo_holder/quiver/bolts, ITEM_SLOT_BELT_L, TRUE)
			spawned.attributes?.add_sheet(/datum/attribute_holder/sheet/job/courtagent/hitman/crossbow)

/datum/attribute_holder/sheet/job/courtagent/mystic
	raw_attribute_list = list(
		STAT_PERCEPTION = 3,
		STAT_INTELLIGENCE = 3,
		STAT_STRENGTH = -2,
		STAT_CONSTITUTION = -1,
		STAT_ENDURANCE = 1,
		/datum/attribute/skill/combat/unarmed = 20,
		/datum/attribute/skill/combat/wrestling = 20,
		/datum/attribute/skill/combat/knives = 20,
		/datum/attribute/skill/combat/polearms = 20,
		/datum/attribute/skill/magic/arcane = 30,
		/datum/attribute/skill/misc/athletics = 30,
		/datum/attribute/skill/misc/swimming = 20,
		/datum/attribute/skill/misc/sneaking = 30,
		/datum/attribute/skill/misc/climbing = 30,
		/datum/attribute/skill/misc/lockpicking = 30,
		/datum/attribute/skill/misc/stealing = 30,
		/datum/attribute/skill/craft/crafting = 20,
		/datum/attribute/skill/misc/reading = 30
	)

/datum/job/advclass/courtagent/mystic
	title = "Mystic Spy"
	tutorial = "You are one of the Hand's loyal Agents. \
	Before becoming an Agent, you were a Mage of the Mages Guild. However due to some complications with your colleagues, you were cast aside. \
	Now you work for the Hand, using your knowledge of Magic and the Arcane to more effectively spy on people. \
	You have been supplied with gadgets to aid in your work, along with the spells you already knew from your time with the Guild."
	outfit = /datum/outfit/courtagent/mystic
	category_tags = list(CTAG_COURTAGENT)
	allowed_patrons = list(/datum/patron/divine/noc, /datum/patron/inhumen/zizo)

	attribute_sheet = /datum/attribute_holder/sheet/job/courtagent/mystic

	spells = list(
		/datum/action/cooldown/spell/undirected/message,
		/datum/action/cooldown/spell/aoe/knock,
		/datum/action/cooldown/spell/undirected/feather_falling,
		/datum/action/cooldown/spell/undirected/longstrider,
		/datum/action/cooldown/spell/conjure/phantom_ear,
	)

/datum/job/advclass/courtagent/mystic/after_spawn(mob/living/carbon/human/spawned, client/player_client)
	. = ..()
	spawned.adjust_spell_points(10)

/datum/outfit/courtagent/mystic
	name = "Mystic Spy"
	head = /obj/item/clothing/head/roguehood/colored/black
	gloves = /obj/item/clothing/gloves/fingerless
	shirt = /obj/item/clothing/shirt/undershirt/colored/black
	armor = /obj/item/clothing/shirt/robe/colored/black
	wrists = /obj/item/clothing/wrists/bracers/leather
	backr = /obj/item/storage/backpack/satchel/black
	backl = /obj/item/weapon/polearm/woodstaff
	beltl = /obj/item/storage/magebag/poor
	backpack_contents = list(
		/obj/item/storage/belt/pouch/coins/poor = 1,
		/obj/item/reagent_containers/glass/bottle/manapot = 1,
		/obj/item/chalk = 1,
		/obj/item/speaker/agent = 1,
		/obj/item/listeningdevice/agent = 2
	)

/datum/attribute_holder/sheet/job/courtagent/protector
	raw_attribute_list = list(
		STAT_STRENGTH = 2,
		STAT_CONSTITUTION = 2,
		STAT_ENDURANCE = 1,
		STAT_INTELLIGENCE = -2,
		/datum/attribute/skill/combat/unarmed = 20,
		/datum/attribute/skill/combat/wrestling = 20,
		/datum/attribute/skill/combat/knives = 20,
		/datum/attribute/skill/misc/athletics = 30,
		/datum/attribute/skill/misc/swimming = 20,
		/datum/attribute/skill/misc/sneaking = 30,
		/datum/attribute/skill/misc/climbing = 30,
		/datum/attribute/skill/misc/lockpicking = 30,
		/datum/attribute/skill/misc/stealing = 30,
		/datum/attribute/skill/craft/crafting = 10,
		/datum/attribute/skill/misc/reading = 10,
	)

/datum/attribute_holder/sheet/job/courtagent/protector/swordshield
	raw_attribute_list = list()
	clamped_adjustment = list(
		/datum/attribute/skill/combat/swords = list(30, 30),
		/datum/attribute/skill/combat/shields = list(30, 30)
	)

/datum/attribute_holder/sheet/job/courtagent/protector/rapier
	raw_attribute_list = list()
	clamped_adjustment = list(
		/datum/attribute/skill/combat/swords = list(30, 30)
	)

/datum/attribute_holder/sheet/job/courtagent/protector/axesmaces
	raw_attribute_list = list()
	clamped_adjustment = list(
		/datum/attribute/skill/combat/axesmaces = list(30, 30)
	)

/datum/attribute_holder/sheet/job/courtagent/protector/spear
	raw_attribute_list = list()
	clamped_adjustment = list(
		/datum/attribute/skill/combat/polearms = list(30, 30)
	)

/datum/attribute_holder/sheet/job/courtagent/protector/whipsflails
	raw_attribute_list = list()
	clamped_adjustment = list(
		/datum/attribute/skill/combat/whipsflails = list(30, 30)
	)


/datum/job/advclass/courtagent/protector
	title = "Protector"
	tutorial = "You are one of the Hand's loyal Agents. \
	While your colleagues specialise in the more subtle arts, you specialise in sheer brute strength. \
	A born fighter from an early age, you are now tasked by the Hand to provide personal protection where the Hand deems it necessary. \
	Little do your charges know who you also report to. No one suspects their protector to hear all their dirty little secrets, surely."
	outfit = /datum/outfit/courtagent/protector
	category_tags = list(CTAG_COURTAGENT)

	attribute_sheet = /datum/attribute_holder/sheet/job/courtagent/protector

	traits = list(
		TRAIT_MEDIUMARMOR
	)

/datum/outfit/courtagent/protector
	head = /obj/item/clothing/head/helmet/leather/headscarf
	gloves = /obj/item/clothing/gloves/leather
	shirt = /obj/item/clothing/armor/gambeson/light/colored/black
	armor = /obj/item/clothing/armor/brigandine/light
	neck = /obj/item/clothing/neck/gorget
	cloak = /obj/item/clothing/cloak/raincloak
	wrists = /obj/item/clothing/wrists/bracers/leather
	backr = /obj/item/storage/backpack/satchel/black
	backpack_contents = list(
		/obj/item/storage/belt/pouch/coins/poor = 1
	)

/datum/job/advclass/courtagent/protector/on_roundstart(mob/living/carbon/human/spawned, client/player_client)
	. = ..()

	var/static/list/weapons = list(
		"Sword & Shield" = /obj/item/weapon/sword/scimitar/messer,
		"Rapier" = /obj/item/weapon/sword/rapier,
		"Axe" = /obj/item/weapon/axe/iron,
		"Mace" = /obj/item/weapon/mace/spiked,
		"Spear" = /obj/item/weapon/polearm/spear,
		"Flail" = /obj/item/weapon/flail,
		"Whip" = /obj/item/weapon/whip,
	)
	var/weapon_choice = spawned.select_equippable(player_client, weapons, message = "Choose Your Specialisation", title = "COURT AGENT")
	if(!weapon_choice)
		return
	switch(weapon_choice)
		if("Sword & Shield")
			spawned.put_in_hands(new /obj/item/weapon/shield/heater(spawned), TRUE)
			spawned.attributes?.add_sheet(/datum/attribute_holder/sheet/job/courtagent/protector/swordshield)
		if("Rapier")
			spawned.attributes?.add_sheet(/datum/attribute_holder/sheet/job/courtagent/protector/rapier)
		if("Axe")
			spawned.attributes?.add_sheet(/datum/attribute_holder/sheet/job/courtagent/protector/axesmaces)
		if("Mace")
			spawned.attributes?.add_sheet(/datum/attribute_holder/sheet/job/courtagent/protector/axesmaces)
		if("Spear")
			spawned.attributes?.add_sheet(/datum/attribute_holder/sheet/job/courtagent/protector/spear)
		if("Flail")
			spawned.attributes?.add_sheet(/datum/attribute_holder/sheet/job/courtagent/protector/whipsflails)
		if("Whip")
			spawned.attributes?.add_sheet(/datum/attribute_holder/sheet/job/courtagent/protector/whipsflails)
