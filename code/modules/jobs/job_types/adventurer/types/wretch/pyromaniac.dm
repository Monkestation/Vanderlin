/datum/attribute_holder/sheet/job/pyromaniac
	raw_attribute_list = list(
		STAT_ENDURANCE = 2,
		STAT_STRENGTH = 1,
		STAT_CONSTITUTION = 3,
		STAT_INTELLIGENCE = 3,
		/datum/attribute/skill/combat/crossbows = 30,
		/datum/attribute/skill/combat/bows = 30,
		/datum/attribute/skill/combat/polearms = 30,
		/datum/attribute/skill/combat/knives = 20,
		/datum/attribute/skill/misc/swimming = 20,
		/datum/attribute/skill/misc/athletics = 40,
		/datum/attribute/skill/combat/wrestling = 30,
		/datum/attribute/skill/combat/unarmed = 30,
		/datum/attribute/skill/misc/climbing = 40,
		/datum/attribute/skill/misc/reading = 20,
		/datum/attribute/skill/craft/traps = 40,
		/datum/attribute/skill/craft/alchemy = 40,
		/datum/attribute/skill/craft/crafting = 20,
		/datum/attribute/skill/craft/engineering = 30,
		/datum/attribute/skill/labor/farming = 10,
		/datum/attribute/skill/craft/bombs = 40,
	)

/datum/job/advclass/wretch/pyromaniac
	title = "Pyromaniac"
	tutorial = "They said you reveled in punishment far too much, that you dared to lie and claim that you sought to harm, not cleanse! \
	They cast you out, they told you to find Astrata elsewhere... That the miracles you preform are child's play... FOOLS! YOUR control of \
	fire is better than them! Only YOU can suffer the smoke of a smouldering heretic! This world is naught meant for 'good and evil', only WRATH! \
	SHOW them what it means to be cleansed of sin! SHOW them the might of a TRUE sun-fearing stud! You are NOT a Zealot, Zealots provide no compromise! \
	They would never ramble on-and-on about their cause! For YOURS is the TRUTH! YOU are her HOLY FURY, and you would NEVER stoop so low as to blindly bend \
	the words of THE ULTIMATE JUDGE for your SICK FANTASIES. This is NOT a game! This is the truth! \
	SHOW THEM THAT THERE IS POWER IN PAIN! SHOW THEM WHAT A TRUE ZEALOT CAN DO!" // The 'Mania' in Pyromania really means something here.
	allowed_sexes = list(MALE, FEMALE)
	allowed_races = RACES_PLAYER_ALL
	outfit = /datum/outfit/wretch/pyromaniac
	total_positions = 2
	cmode_music = 'sound/music/cmode/antag/CombatPyromaniac.ogg'

	attribute_sheet = /datum/attribute_holder/sheet/job/pyromaniac

	traits = list(
		TRAIT_MEDIUMARMOR,
		TRAIT_FORAGER,
		TRAIT_BEAUTIFUL,
		TRAIT_STUD,
		TRAIT_NOPAINSTUN
	)

	spells = list(
		/datum/action/cooldown/spell/enchantment/singingblade,
		/datum/action/cooldown/spell/undirected/joy,
		/datum/action/cooldown/spell/undirected/conjure_item/fire_vial
	)

	honoraries = list(
 		"the Arsonist" = HONORARY_SUFFIX,
 		"the Firebug" = HONORARY_SUFFIX,
 		"the Insane" = HONORARY_SUFFIX,
 		"Firestarter" = HONORARY_PREFIX,
 		"Pious" = HONORARY_PREFIX,
 		"of Astrata" = HONORARY_SUFFIX,
 		"the Cook" = HONORARY_SUFFIX,
 		"the Trailblazer" = HONORARY_SUFFIX,
 		"the Wildfire" = HONORARY_SUFFIX,
 		"the Judge" = HONORARY_SUFFIX,
 		"Judge" = HONORARY_PREFIX,
 		"of Sound Mind" = HONORARY_SUFFIX,
 		"Sin-Eater" = HONORARY_PREFIX,
 		"the Cleaner" = HONORARY_SUFFIX,
		"the Zealot" = HONORARY_SUFFIX,
		"the Kreecher ov Deception" = HONORARY_SUFFIX,
		"Ztogie Chomping" = HONORARY_PREFIX,
		"the Kind" = HONORARY_SUFFIX,
		"the Burning One" = HONORARY_SUFFIX,
		"the Hammer of Astrata" = HONORARY_SUFFIX,
		", Astrata's Reject" = HONORARY_SUFFIX,
		", Borne of Fire" = HONORARY_SUFFIX,
		"Immolated" = HONORARY_PREFIX,
		"the Immolator" = HONORARY_SUFFIX,
		"Well-Done" = HONORARY_PREFIX,
		"Venator" = HONORARY_PREFIX,
		"the Consecrator" = HONORARY_SUFFIX,
		", Ira Domini" = HONORARY_SUFFIX,
		"borne of Wrath" = HONORARY_SUFFIX,
	)

/datum/job/advclass/wretch/pyromaniac/on_roundstart(mob/living/carbon/human/spawned, client/player_client)
	. = ..()

	var/static/list/selectableweapon = list(
		"Burning Spear" = /obj/item/weapon/polearm/spear/pyromanicspear,
		"Crossbow" = /obj/item/gun/ballistic/bow/cross,
		"Bow" = /obj/item/gun/ballistic/bow/cross,
	)
	var/weaponschoice = spawned.select_equippable(player_client, selectableweapon, message = "Choose Your Weapon of choice", title = "PYROMANIAC")
	if(!weaponschoice)
		return

	switch(weaponschoice)
		if("Burning Spear")
			to_chat(spawned, span_info("The flame that burns bright lasts half as long."))
		if("Crossbow")
			var/obj/item/ammo_holder/quiver/bolts/pyro/P = new(get_turf(spawned))
			spawned.equip_to_appropriate_slot(P)
			to_chat(spawned, span_info("You are able to make more crossbow ammunition with iron, blast powder and some planks."))
		if("Bow")
			var/obj/item/ammo_holder/quiver/arrows/pyro/P = new(get_turf(spawned))
			spawned.equip_to_appropriate_slot(P)
			to_chat(spawned, span_info("You are able to make more bow ammunition with iron, blast powder and some planks."))

/datum/outfit/wretch/pyromaniac
	name = "Pyromaniac (Wretch)"
	head = /obj/item/clothing/head/roguehood/colored/red/pyromaniac
	mask = /obj/item/clothing/face/pyromaniac
	neck = /obj/item/clothing/neck/chaincoif/iron
	pants = /obj/item/clothing/pants/trou/leather/pyromaniac
	armor = /obj/item/clothing/armor/leather/splint/pyromaniac
	shirt = /obj/item/clothing/armor/gambeson/heavy/pyromaniac
	backl = /obj/item/storage/backpack/satchel
	belt = /obj/item/storage/belt/leather/black
	gloves = /obj/item/clothing/gloves/leather/pyromaniac
	shoes = /obj/item/clothing/shoes/boots/armor
	r_hand = /obj/item/explosive/bottle
	l_hand = /obj/item/explosive/bottle
	cloak = /obj/item/clothing/cloak/raincloak/furcloak/colored
	mouth = /obj/item/clothing/face/cigarette/rollie/nicotine/zigar
	backpack_contents = list(
		/obj/item/explosive/bottle = 2,
		/obj/item/weapon/knife/hunting = 1,
		/obj/item/storage/belt/pouch/coins/poor = 1,
		/obj/item/rope/chain = 1,
		/obj/item/flint = 1,
		/obj/item/storage/fancy/cigarettes/tinzig = 1,
		/obj/item/reagent_containers/glass/bottle/stronghealthpot = 1,
	)

/datum/job/advclass/wretch/pyromaniac/after_spawn(mob/living/carbon/human/spawned, client/player_client)
	. = ..()
	spawned.set_patron(/datum/patron/divine/astrata, TRUE)
//	var/mob/living/carbon/human/stud = spawned
	to_chat(spawned, span_green("I'm a Stud! I'm ballsy! I'm better than everyone else! Especially since I'm the only mortal being who is always objectively correct!"))

///datum/job/advclass/wretch/pyromaniac/proc/on_examine(mob/living/carbon/human/stud, mob/living/carbon/human/user, list/examine_list)
//	if(!istype(stud) || !istype(user))
//		return
//	if(stud == user)
//		return
//	if(HAS_TRAIT(user, TRAIT_APRICITY))
//		examine_list += span_boldred("That's not a Priest.")
//	else if(is_priest_job(user.mind?.assigned_role))
//		examine_list += SPAN_GOD_ASTRATA("A VOLF IN SHEEPS GARBS! A psychopath who bends Astrata's will for pleasure and pain!")
//	else if(user.mind?.has_antag_datum(/datum/antagonist/maniac))
//		examine_list += span_green("What a STUD!")
//	else if(HAS_TRAIT(user, TRAIT_CRACKHEAD))
//		examine_list += span_green("That one REALLY knows how to have a good time!")
//	else if(HAS_TRAIT(user, TRAIT_STUD))
//		examine_list += span_green("Looking Good! Sssmokin'!")

// Can't get all of this stuff to work! Oh well, fix it another time.
