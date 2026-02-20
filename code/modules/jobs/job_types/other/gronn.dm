//the mooks
/datum/job/advclass/mercenary/gronn
	title = "Gronnic Privateer"
	tutorial = "You are one of many upstarts from Gronn, who sailed from the coastal capital of Danheim to the southern beaches of Azuria in search of a more... honest means of profit than the Sea Raiders of infamy."
	allowed_sexes = list(MALE, FEMALE)
	allowed_races = RACES_PLAYER_ALL
	allowed_patrons = ALL_GRONNIC_PATRONS //Subvariant of the 'ALL_INHUMEN_PATRONS' tag, with Abyssor and Dendor as situational additions. Do not add any more to this, no matter what.
	outfit = /datum/outfit/job/mercenary/gronn
	cmode_music = 'sound/music/combat_vagarian.ogg'
	languages = list(/datum/language/gronnic)
	pack_message = "This subclass has 2 loadouts with various stats, skills & equipment."
	skills = list(
	//Universal skills
		/datum/skill/misc/reading = SKILL_LEVEL_NOVICE,
		/datum/skill/misc/climbing = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/craft/crafting = SKILL_LEVEL_NOVICE,
		/datum/skill/craft/tanning = SKILL_LEVEL_APPRENTICE,
		/datum/skill/labor/fishing = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/swimming = SKILL_LEVEL_EXPERT, //All of you can suck my dick they're SEAMEN
		/datum/skill/misc/sewing = SKILL_LEVEL_NOVICE,
		/datum/skill/craft/cooking = SKILL_LEVEL_NOVICE,
	)

/datum/outfit/job/mercenary/gronn/pre_equip(mob/living/carbon/human/H)
	..()

	//Universal gear
	backl = /obj/item/storage/backpack/satchel/black
	belt = /obj/item/storage/belt/leather
	beltl = /obj/item/storage/belt/pouch/coins/poor
	backpack_contents = list(
		/obj/item/flashlight/flare/torch/metal = 1,
		/obj/item/key/mercenary = 1,
		/obj/item/weapon/knife/hunting = 1,
		/obj/item/weapon/scabbard/knife = 1
		)

	// CLASS ARCHETYPES
	if(H.mind)
		var/classes = list("Leðurháls - Byrine Grunt", "Skemmdarvargur - Ravager")
		var/classchoice = input(H, "Choose your archetypes", "Available archetypes") as anything in classes

		switch(classchoice)
			if("Leðurháls - Byrine Grunt")	//Medium armor, pick between swords or axes. Boots-on-the-ground for hire.
				to_chat(H, span_warning("Clad in their unique leatherbound chainmaille and shortsword, The Danheim Leðurháls - roughly translated in Imperial to 'Leatherneck' due to their choice of leather gorgets over forged metal - are known for their harsh dogmatisms and steady personalities."))
				shoes = /obj/item/clothing/shoes/boots/leather/atgervi
				head = /obj/item/clothing/head/helmet/bascinet/atgervi/gronn/ownel
				gloves = /obj/item/clothing/gloves/chain/gronn
				armor = /obj/item/clothing/armor/brigandine/gronn
				pants = /obj/item/clothing/pants/trou/leather/splint/iron/gronn
				wrists = /obj/item/clothing/wrists/bracers/iron
				backr = /obj/item/weapon/shield/tower/buckleriron
				beltr = /obj/item/weapon/scabbard/sword
				l_hand = /obj/item/weapon/sword/short/gronn //New heavy shortsword.
				neck = /obj/item/clothing/neck/coif
				H.clamped_adjust_skillrank(/datum/skill/combat/swords, 4, TRUE)
				H.clamped_adjust_skillrank(/datum/skill/combat/shields, 4, TRUE)
				H.clamped_adjust_skillrank(/datum/skill/combat/axesmaces, 2, TRUE)
				H.clamped_adjust_skillrank(/datum/skill/combat/knives, 3, TRUE)
				H.clamped_adjust_skillrank(/datum/skill/misc/athletics, 4, TRUE)
				H.clamped_adjust_skillrank(/datum/skill/combat/wrestling, 3, TRUE)
				H.clamped_adjust_skillrank(/datum/skill/combat/unarmed, 2, TRUE)
				H.change_stat(STATKEY_STR, 2)
				H.change_stat(STATKEY_PER, 2) //You technically wield a shortsword
				H.change_stat(STATKEY_CON, 2)
				H.change_stat(STATKEY_INT, -1) //Unga swordsman.
				ADD_TRAIT(H, TRAIT_MEDIUMARMOR, TRAIT_GENERIC)
				H.dna.species.soundpack_m = new /datum/voicepack/male/warrior()



			if("Skemmdarvargur - Ravager")	//Light armor, beast claws or dual handaxes.
				to_chat(H, span_warning("The Skemmdarvargur are famously known to hail from the northern city of Skugge, the first line of defense for the Northern Empty. Although highly superstitious with their various carved armaments, they lack the mystical miracles of the Iskarn Shamans."))
				shoes = /obj/item/clothing/shoes/boots/leather/atgervi
				head = /obj/item/clothing/head/helmet/bascinet/atgervi/gronn
				gloves = /obj/item/clothing/gloves/angle/gronnfur
				armor = /obj/item/clothing/armor/leather/heavy/gronn
				wrists = /obj/item/clothing/wrists/bracers/leather/masterwork
				pants = /obj/item/clothing/pants/trou/leather/gronn
				neck = /obj/item/clothing/neck/coif
				H.clamped_adjust_skillrank(/datum/skill/combat/axesmaces, 2, 2, TRUE)
				H.clamped_adjust_skillrank(/datum/skill/combat/whipsflails, 3, 3, TRUE)
				H.clamped_adjust_skillrank(/datum/skill/combat/shields, 3, 3, TRUE)
				H.clamped_adjust_skillrank(/datum/skill/combat/knives, 2, 2, TRUE)
				H.clamped_adjust_skillrank(/datum/skill/misc/athletics, 4, 4, TRUE)
				H.clamped_adjust_skillrank(/datum/skill/combat/wrestling, 3, 3, TRUE)
				H.clamped_adjust_skillrank(/datum/skill/combat/unarmed, 2, 2, TRUE)
				H.clamped_adjust_skillrank(/datum/skill/craft/traps, 3, 3, TRUE)//Ditto
				H.change_stat(STATKEY_CON, 2)
				H.change_stat(STATKEY_SPD, 2)
				ADD_TRAIT(H, TRAIT_DODGEEXPERT, TRAIT_GENERIC)
				H.dna.species.soundpack_m = new /datum/voicepack/male/evil() //Dodge builds are evil
				var/weapons = list("Handclaws","Dual Handaxes")
				var/weapon_choice = input(H, "Choose your weapon.", "TAKE UP ARMS") as anything in weapons
				if(H.mind)
					switch(weapon_choice)
						if("Handclaws")
							H.clamped_adjust_skillrank(/datum/skill/combat/unarmed, SKILL_LEVEL_EXPERT, SKILL_LEVEL_EXPERT, TRUE)
							l_hand = /obj/item/weapon/handclaw/gronn //You dont get the insane fucking steel or the special Iskarn ones
						if("Dual Handaxes")
							H.clamped_adjust_skillrank(/datum/skill/combat/axesmaces, SKILL_LEVEL_EXPERT, SKILL_LEVEL_EXPERT, TRUE)
							r_hand = /obj/item/weapon/axe/stone
							l_hand = /obj/item/weapon/axe/stone
							ADD_TRAIT(H, TRAIT_DUALWIELDER, TRAIT_GENERIC)

	H.merctype = 1

//the scary mook
/datum/job/advclass/mercenary/gronnheavy
	title = "Fjall Járnklæddur"
	tutorial = "Even within Fjall, few bear witness to the Horned Visages of the Járnklæddur; Ironclad warriors who stand against the undead armies that rise out of the 'Red Blizzard'. Those who do not have the blessing of the Iskarn Shamans within the Northern Empty oft-seek the protection of the Járnklæddur, despite their steep costs."
	allowed_sexes = list(MALE, FEMALE)
	allowed_races = RACES_PLAYER_ALL
	total_positions = 1 //Hopefully this works.
	outfit = /datum/outfit/job/mercenary/gronnheavy
	traits = list(TRAIT_HEAVYARMOR)
	cmode_music = 'sound/music/combat_vagarian.ogg'
	languages = list(/datum/language/gronnic)
	allowed_patrons = ALL_GRONNIC_PATRONS //Subvariant of the 'ALL_INHUMEN_PATRONS' tag, with Abyssor and Dendor as situational additions. Do not add any more to this, no matter what.
	jobstats = list(
		STATKEY_WIL = 3, //People see big numbers and start shitting their pants, but their weighted stats are 7 and it's limited to one, singular slot. This is fine.
		STATKEY_STR = 3, //TO WIELD THE MAUL. THEY CAN'T USE ANY OTHER WEAPON TYPE BUT MACES ANYWAY.
		STATKEY_INT = 2,
		STATKEY_CON = 3,
		STATKEY_PER = -1, //CAN'T SEE SHIT OUTTA THIS THING!!
		STATKEY_SPD = -3 //SLOW AND UNWIELDY
	)
	skills = list(
		/datum/skill/misc/reading = SKILL_LEVEL_NOVICE,
		/datum/skill/misc/climbing = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/craft/crafting = SKILL_LEVEL_NOVICE,
		/datum/skill/craft/tanning = SKILL_LEVEL_APPRENTICE,
		/datum/skill/labor/fishing = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/swimming = SKILL_LEVEL_EXPERT, //All of you can suck my dick they're SEAMEN
		/datum/skill/misc/sewing = SKILL_LEVEL_NOVICE,
		/datum/skill/craft/cooking = SKILL_LEVEL_NOVICE,
		/datum/skill/combat/axesmaces = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/knives = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/wrestling = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/unarmed = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/athletics = SKILL_LEVEL_EXPERT,
	)

/datum/outfit/job/mercenary/gronnheavy/pre_equip(mob/living/carbon/human/H)
	..()
	H.dna.species.soundpack_m = new /datum/voicepack/male/evil() //It's fucking cool okay
	shoes = /obj/item/clothing/shoes/boots/armor/iron/gronn
	head = /obj/item/clothing/head/helmet/heavy/bucket/gronn
	gloves = /obj/item/clothing/gloves/plate/iron/gronn
	armor = /obj/item/clothing/armor/plate/iron/gronn
	cloak = /obj/item/clothing/cloak/volfmantle	//Aura farming.
	wrists = /obj/item/clothing/wrists/bracers/iron //Weakspot.
	pants = /obj/item/clothing/pants/platelegs/iron/gronn
	r_hand = /obj/item/weapon/mace/maul
	neck = /obj/item/clothing/neck/bevor/iron
	backl = /obj/item/storage/backpack/satchel/black
	belt = /obj/item/storage/belt/leather
	beltl = /obj/item/storage/belt/pouch/coins/poor

	backpack_contents = list(
		/obj/item/flashlight/flare/torch/metal = 1,
		/obj/item/key/mercenary = 1,
		/obj/item/weapon/knife/hunting = 1,
		/obj/item/weapon/scabbard/knife = 1
		)
	H.merctype = 1

//the special mooks
/datum/job/advclass/mercenary/shamanaaa
	title = "Atgervi Shaman"
	tutorial = "You are a Shaman of the Fjall, The Northern Empty. Shamans are savage combatants who commune with the Ecclesical Beast Gods through ritualistic violence, rather than idle prayer."
	outfit = /datum/outfit/job/roguetown/mercenary/atgervishaman
	allowed_sexes = list(MALE, FEMALE)
	allowed_races = RACES_PLAYER_ALL
	allowed_patrons = ALL_GRONNIC_PATRONS
	languages = list(/datum/language/gronnic)
	cmode_music = 'sound/music/combat_shaman2.ogg'
	traits = list(TRAIT_STRONGBITE, TRAIT_IGNOREDAMAGESLOWDOWN, TRAIT_NOPAINSTUN)
	jobstats = list(
		STATKEY_STR = 3,
		STATKEY_CON = 2,
		STATKEY_SPD = 1,
		STATKEY_INT = -1,
		STATKEY_PER = -1
	)
	skills = list(
		/datum/skill/misc/swimming = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/climbing = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/sneaking = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/wrestling = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/unarmed = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/reading = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/athletics = SKILL_LEVEL_EXPERT,
		/datum/skill/craft/tanning = SKILL_LEVEL_APPRENTICE,
		/datum/skill/magic/holy = SKILL_LEVEL_JOURNEYMAN,
	)

/datum/outfit/job/roguetown/mercenary/atgervishaman/pre_equip(mob/living/carbon/human/H)
	..()
	H.mind?.current.faction += "[H.name]_faction"
	H.dna.species.soundpack_m = new /datum/voicepack/male/warrior()

	head = /obj/item/clothing/head/helmet/leather/shaman_hood
	gloves = /obj/item/clothing/gloves/angle/gronnfur
	armor = /obj/item/clothing/armor/leather/heavy/atgervi
	shirt = /obj/item/clothing/shirt/undershirt
	pants = /obj/item/clothing/pants/trou/leather/atgervi
	wrists = /obj/item/clothing/wrists/bracers
	shoes = /obj/item/clothing/shoes/boots/leather/atgervi
	backr = /obj/item/storage/backpack/satchel/black
	belt = /obj/item/storage/belt/leather
	neck = /obj/item/storage/belt/pouch/coins/poor
	beltl = /obj/item/flashlight/flare/torch
	H.put_in_hands(new /obj/item/weapon/handclaw/gronn)

	switch(H.patron?.type)
		if(/datum/patron/inhumen/zizo)
			neck = /obj/item/clothing/neck/psycross/inhumen/gronn
		if(/datum/patron/inhumen/graggar)
			neck = /obj/item/clothing/neck/psycross/inhumen/graggar/gronn
		if(/datum/patron/inhumen/matthios)
			neck = /obj/item/clothing/neck/psycross/inhumen/matthios/gronn
		if(/datum/patron/inhumen/baotha)
			neck = /obj/item/clothing/neck/psycross/inhumen/baothagronn
		if(/datum/patron/divine/abyssor)
			neck = /obj/item/clothing/neck/psycross/abyssor/gronn
		if(/datum/patron/divine/dendor)
			neck = /obj/item/clothing/neck/psycross/dendor/gronn
		else
			neck = /obj/item/clothing/neck/psycross/inhumen/gronn/special //Failsafe. Gives a specially-fluffed version of Zizo's talisman, which can be reinterpreted as needed.

	var/datum/devotion/cleric = new /datum/devotion(H, H.patron)
	cleric.grant_to(H)
	cleric.make_shaman()//Capped to T2 miracles.

	backpack_contents = list(
		/obj/item/key/mercenary = 1,
		/obj/item/weapon/knife/hunting = 1,
		/obj/item/weapon/scabbard/knife = 1,
		/obj/item/storage/belt/pouch/coins/poor = 1,
		)

	H.merctype = 1
