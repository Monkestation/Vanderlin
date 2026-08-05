/datum/quirk/boon/backstory
	name = "Additional Training"
	desc = "During your youth, you dabbled in other skills, and still carry some of that ability today. (OOC NOTE; COMBAT SKILLS ARE CLAMPED AT AVERAGE FROM THIS, THIS IS YOUR PAST.)"
	point_value = -3
	customization_label = "Choose Background"
	customization_options = list()
	var/static/list/backstories

/datum/quirk/boon/backstory/New()
	// Populate options from all backstory types
	for(var/datum/backstory/backstory_type as anything in subtypesof(/datum/backstory))
		if(IS_ABSTRACT(backstory_type))
			continue
		customization_options += backstory_type

	if(!length(backstories))
		for(var/datum/backstory/backstory_type as anything in subtypesof(/datum/backstory))
			if(IS_ABSTRACT(backstory_type))
				continue
			LAZYADD(backstories, new backstory_type())

	return ..()

/datum/quirk/boon/backstory/get_desc(datum/preferences/prefs)
	var/base_desc = desc

	// If a backstory is selected, add its stats to the description
	var/datum/backstory/B = customization_value
	if(!B || !ispath(B))
		B = prefs.quirk_customizations[type]
	if(!B)
		return base_desc
	var/datum/attribute/skill/granted_skill = initial(B.granted_skill)
	var/skill_amount = initial(B.amount)
	var/skill_clamp = initial(B.clamp)

	base_desc += "<br><br><b>Selected: [initial(B.name)]</b>"
	base_desc += "<br>[initial(B.desc)]"

	// Add skill grant information
	if(granted_skill)
		base_desc += "<br><b>Grants:</b> +[skill_amount] [initial(granted_skill.name)] (MAX: [skill_clamp])"

	return base_desc

/datum/quirk/boon/backstory/return_customization(datum/preferences/prefs)
	var/list/custom = list()

	for(var/datum/backstory/story in backstories)
		if(story.is_available(prefs))
			custom |= story.type
	return custom

/datum/quirk/boon/backstory/after_job_spawn()
	if(!ishuman(owner))
		return

	if(!customization_value || !ispath(customization_value, /datum/backstory))
		customization_value = /datum/backstory/combat/soldier

	var/datum/backstory/B = customization_value
	var/mob/living/carbon/human/H = owner

	if(initial(B.granted_skill))
		H.clamped_adjust_skill_level(initial(B.granted_skill), B.amount, initial(B.clamp), TRUE)


	to_chat(H, span_notice("Your experience as [LOWER_TEXT(initial(B.name))] has shaped who you are today."))

/datum/quirk/boon/backstory/on_remove()
	if(!ishuman(owner))
		return

	if(!customization_value || !ispath(customization_value, /datum/backstory))
		return

	var/datum/backstory/B = customization_value
	var/mob/living/carbon/human/H = owner

	return ..()

/datum/backstory
	/// The name of the backstory shown to players
	var/name = "Backstory"
	/// Description of the backstory
	var/desc = "A background."
	/// The skill this backstory grants
	var/datum/attribute/skill/granted_skill
	///ammount we give
	var/amount = 10
	///what we clamp to
	var/clamp = 60

	/// List of allowed ages (empty = all allowed)
	var/list/allowed_ages = list()
	/// List of blocked ages
	var/list/blocked_ages = list()
	/// List of allowed species (empty = all allowed)
	var/list/allowed_species = list()
	/// List of blocked species
	var/list/blocked_species = list()


/datum/backstory/proc/is_available(datum/preferences/prefs)
	if(!prefs)
		return TRUE

	// Check age restrictions
	if(length(allowed_ages) && !(prefs.read_preference(/datum/preference/choiced/age) in allowed_ages))
		return FALSE
	if(prefs.read_preference(/datum/preference/choiced/age) in blocked_ages)
		return FALSE

	// Check species restrictions
	if(length(allowed_species) && !(prefs.pref_species in allowed_species))
		return FALSE
	if(prefs.pref_species in blocked_species)
		return FALSE

	return TRUE

/datum/backstory/combat
	abstract_type = /datum/backstory/combat
	desc = "A combat-focused background."
	amount = 20
	clamp = 20

/datum/backstory/combat/soldier
	name = "Novice Swordsman"
	desc = "You dabbled in swordplay while you were younger."
	granted_skill = /datum/attribute/skill/combat/swords

/datum/backstory/combat/guard
	name = "Peasent Spearman"
	desc = "You spent much of your youth warding off volves and goblins with a spear."
	granted_skill = /datum/attribute/skill/combat/polearms

/datum/backstory/combat/mercenary
	name = "Ex-Mercenary"
	desc = "You fought for coin, wielding axe and mace with brutal efficiency."
	granted_skill = /datum/attribute/skill/combat/axesmaces

/datum/backstory/combat/brawler
	name = "Pit Fighter"
	desc = "When money was tight you took part in brawling duels to earn your keep."
	granted_skill = /datum/attribute/skill/combat/unarmed

/datum/backstory/combat/archer
	name = "Dabbling Hunter"
	desc = "You aren't the best with a bow, but it is enough to feed you."
	granted_skill = /datum/attribute/skill/combat/bows

/datum/backstory/combat/assassin
	name = "Reformed Assassin"
	desc = "You killed for hire, a blade in the dark."
	granted_skill = /datum/attribute/skill/combat/knives

/datum/backstory/combat/crossbowman
	name = "Former Crossbowman"
	desc = "You served as a crossbowman, learning patience and precision."
	granted_skill = /datum/attribute/skill/combat/crossbows

/datum/backstory/combat/wrestler
	name = "Pit Fighter"
	desc = "You wrestled for sport and survival in fighting pits."
	granted_skill = /datum/attribute/skill/combat/wrestling

/datum/backstory/combat/whipmaster
	name = "Former Slaver"
	desc = "You wielded whip and flail in a dark past you've left behind."
	granted_skill = /datum/attribute/skill/combat/whipsflails

/datum/backstory/combat/shieldbearer
	name = "Shield Bearer"
	desc = "You defended others with shield and determination."
	granted_skill = /datum/attribute/skill/combat/shields

/datum/backstory/combat/gunner
	name = "Former Gunner"
	desc = "You served with firearms, a dangerous and loud profession."
	granted_skill = /datum/attribute/skill/combat/firearms

/datum/backstory/combat/athlete // under "combat" so they get clamped as well
	name = "Former Athlete"
	desc = "You competed in games, testing strength and endurance."
	granted_skill = /datum/attribute/skill/misc/athletics

/datum/backstory/combat/acrobat
	name = "Retired Acrobat"
	desc = "You performed daring feats, climbing and leaping."
	granted_skill = /datum/attribute/skill/misc/climbing

/datum/backstory/craft
	abstract_type = /datum/backstory/craft
	desc = "A crafting-focused background."

/datum/backstory/craft/blacksmith
	name = "Apprentice Blacksmith"
	desc = "You worked the forge, shaping metal with hammer and anvil."
	granted_skill = /datum/attribute/skill/craft/blacksmithing

/datum/backstory/craft/weaponsmith
	name = "Journeyman Weaponsmith"
	desc = "You crafted weapons, from simple daggers to mighty blades."
	granted_skill = /datum/attribute/skill/craft/weaponsmithing

/datum/backstory/craft/armorer
	name = "Former Armorer"
	desc = "You made armor, protecting warriors with your craft."
	granted_skill = /datum/attribute/skill/craft/armorsmithing

/datum/backstory/craft/carpenter
	name = "Retired Carpenter"
	desc = "You worked with wood, building homes and furniture."
	granted_skill = /datum/attribute/skill/craft/carpentry

/datum/backstory/craft/mason
	name = "Ex-Mason"
	desc = "You shaped stone, building walls and monuments."
	granted_skill = /datum/attribute/skill/craft/masonry

/datum/backstory/craft/cook
	name = "Former Cook"
	desc = "You prepared meals, from simple stews to elaborate feasts."
	granted_skill = /datum/attribute/skill/craft/cooking

/datum/backstory/craft/alchemist
	name = "Apprentice Alchemist"
	desc = "You mixed potions and studied strange reagents."
	granted_skill = /datum/attribute/skill/craft/alchemy

/datum/backstory/craft/engineer
	name = "Failed Engineer"
	desc = "You built machines and contraptions, though not all worked."
	granted_skill = /datum/attribute/skill/craft/engineering

/datum/backstory/craft/tailor
	name = "Former Tailor"
	desc = "You sewed garments for nobles and commoners alike."
	granted_skill = /datum/attribute/skill/misc/sewing

/datum/backstory/craft/tanner
	name = "Ex-Tanner"
	desc = "You worked with leather, turning hides into useful goods."
	granted_skill = /datum/attribute/skill/craft/tanning

/datum/backstory/craft/trapper
	name = "Former Trapper"
	desc = "You laid traps for beasts and sometimes men."
	granted_skill = /datum/attribute/skill/craft/traps

/datum/backstory/craft/smelter
	name = "Apprentice Smelter"
	desc = "You worked the furnace, turning ore into metal."
	granted_skill = /datum/attribute/skill/craft/smelting

/datum/backstory/craft/bombmaker
	name = "Powder Maker"
	desc = "You crafted explosives, a dangerous trade."
	granted_skill = /datum/attribute/skill/craft/bombs

/datum/backstory/craft/general
	name = "Jack of All Trades"
	desc = "You dabbled in many crafts, master of none."
	granted_skill = /datum/attribute/skill/craft/crafting

/datum/backstory/labor
	abstract_type = /datum/backstory/labor
	desc = "A labor-focused background."

/datum/backstory/labor/miner
	name = "Ex-Miner"
	desc = "You worked in the mines, digging for ore and gems."
	granted_skill = /datum/attribute/skill/labor/mining

/datum/backstory/labor/farmer
	name = "Former Farmer"
	desc = "You tilled the land and knew the seasons well."
	granted_skill = /datum/attribute/skill/labor/farming

/datum/backstory/labor/fisher
	name = "Retired Fisher"
	desc = "You fished the waters, patient and persistent."
	granted_skill = /datum/attribute/skill/labor/fishing

/datum/backstory/labor/butcher
	name = "Former Butcher"
	desc = "You prepared meat, skilled with knife and cleaver."
	granted_skill = /datum/attribute/skill/labor/butchering

/datum/backstory/labor/lumberjack
	name = "Ex-Lumberjack"
	desc = "You felled trees and split logs with ease."
	granted_skill = /datum/attribute/skill/labor/lumberjacking

/datum/backstory/labor/tamer
	name = "Beast Tamer"
	desc = "You trained animals, from horses to more exotic beasts."
	granted_skill = /datum/attribute/skill/labor/taming

/datum/backstory/misc
	abstract_type = /datum/backstory/misc
	desc = "A miscellaneous background."

/datum/backstory/misc/thief
	name = "Former Thief"
	desc = "You picked pockets and stole to survive."
	granted_skill = /datum/attribute/skill/misc/stealing

/datum/backstory/misc/spy
	name = "Ex-Spy"
	desc = "You moved in shadows, gathering secrets."
	granted_skill = /datum/attribute/skill/misc/sneaking

/datum/backstory/misc/locksmith
	name = "Former Locksmith"
	desc = "You worked with locks, both making and picking them."
	granted_skill = /datum/attribute/skill/misc/lockpicking

/datum/backstory/misc/bard
	name = "Tavern Bard"
	desc = "You played for crowds, earning coin and applause."
	granted_skill = /datum/attribute/skill/misc/music

/datum/backstory/misc/medic
	name = "Field Medic"
	desc = "You treated the wounded on battlefields and in clinics."
	granted_skill = /datum/attribute/skill/misc/medicine

/datum/backstory/misc/rider
	name = "Horse Trainer"
	desc = "You rode and trained mounts for nobles and soldiers."
	granted_skill = /datum/attribute/skill/misc/riding

/datum/backstory/misc/scribe
	name = "Scribe's Apprentice"
	desc = "You studied letters and copied manuscripts."
	granted_skill = /datum/attribute/skill/misc/reading

/datum/backstory/misc/swimmer
	name = "Former Swimmer"
	desc = "You swam the rivers and knew the waters well."
	granted_skill = /datum/attribute/skill/misc/swimming

/datum/backstory/misc/merchant
	name = "Merchant's Assistant"
	desc = "You counted coin and learned the art of numbers."
	granted_skill = /datum/attribute/skill/labor/mathematics

/datum/backstory/magic
	abstract_type = /datum/backstory/magic
	desc = "A magical background."
	clamp = 20

/datum/backstory/magic/acolyte
	name = "Former Acolyte"
	desc = "You studied in a temple, learning divine miracles."
	granted_skill = /datum/attribute/skill/magic/holy
