/datum/quirk/boon/backstory
	name = "Experienced Background"
	desc = "You had a previous career before becoming an adventurer. You've retained skills from that time, but it left its mark on you. (OOC NOTE; COMBAT SKILLS ARE CLAMPED AT AVERAGE FROM THIS, THIS IS YOUR PAST.)"
	point_value = -2
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
	var/stat_penalty = initial(B.stat_penalty)
	var/stat_reduction = initial(B.stat_reduction)

	base_desc += "<br><br><b>Selected: [initial(B.name)]</b>"
	base_desc += "<br>[initial(B.desc)]"

	// Add skill grant information
	if(granted_skill)
		base_desc += "<br><b>Grants:</b> +1 [initial(granted_skill.name)]"

	// Add stat penalty information
	if(stat_penalty && stat_reduction > 0)
		var/stat_name = ""
		switch(stat_penalty)
			if(STAT_STRENGTH)
				stat_name = "Strength"
			if(STAT_PERCEPTION)
				stat_name = "Perception"
			if(STAT_INTELLIGENCE)
				stat_name = "Intelligence"
			if(STAT_CONSTITUTION)
				stat_name = "Constitution"
			if(STAT_ENDURANCE)
				stat_name = "Endurance"
			if(STAT_SPEED)
				stat_name = "Speed"

		if(stat_name)
			base_desc += "<br><b>Penalty:</b> -[stat_reduction] [stat_name]"

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
		H.clamped_adjust_skill_level(initial(B.granted_skill), 10, initial(B.clamp), TRUE)
		H.adjust_skill_exp_multiplier(initial(B.granted_skill), initial(B.xp_multiplier))

	// Apply stat penalty
	if(initial(B.stat_penalty) && initial(B.stat_reduction) > 0)
		H.adjust_stat_modifier(STATMOD_QUIRK, list(initial(B.stat_penalty) = -initial(B.stat_reduction)))

	to_chat(H, span_notice("Your experience as [lowertext(initial(B.name))] has shaped who you are today."))

/datum/quirk/boon/backstory/on_remove()
	if(!ishuman(owner))
		return

	if(!customization_value || !ispath(customization_value, /datum/backstory))
		return

	var/datum/backstory/B = customization_value
	var/mob/living/carbon/human/H = owner

	if(initial(B.stat_penalty) && initial(B.stat_reduction) > 0)
		H.adjust_stat_modifier(STATMOD_QUIRK, list(initial(B.stat_penalty) = initial(B.stat_reduction)))

	H.adjust_skill_exp_multiplier(initial(B.granted_skill), -initial(B.xp_multiplier))

/datum/backstory
	/// The name of the backstory shown to players
	var/name = "Backstory"
	/// Description of the backstory
	var/desc = "A background."
	/// The skill this backstory grants
	var/datum/attribute/skill/granted_skill
	/// The stat this backstory penalizes
	var/stat_penalty
	/// How much to reduce the stat
	var/stat_reduction = 1
	///what we clamp to
	var/clamp = 60
	///how much of an xp multiplier we add
	var/xp_multiplier = 0.2

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
	if(length(allowed_ages) && !(prefs.age in allowed_ages))
		return FALSE
	if(prefs.age in blocked_ages)
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
	clamp = 20
	xp_multiplier = 0.1

/datum/backstory/combat/soldier
	name = "Former Soldier"
	desc = "You served in the military, learning discipline and swordsmanship."
	granted_skill = /datum/attribute/skill/combat/swords
	stat_penalty = STAT_INTELLIGENCE

/datum/backstory/combat/guard
	name = "Retired Guard"
	desc = "You stood watch for years, mastering the spear and halberd."
	granted_skill = /datum/attribute/skill/combat/polearms
	stat_penalty = STAT_SPEED

/datum/backstory/combat/mercenary
	name = "Ex-Mercenary"
	desc = "You fought for coin, wielding axe and mace with brutal efficiency."
	granted_skill = /datum/attribute/skill/combat/axesmaces
	stat_penalty = STAT_PERCEPTION

/datum/backstory/combat/brawler
	name = "Street Fighter"
	desc = "You brawled to survive in the gutters and alleys."
	granted_skill = /datum/attribute/skill/combat/unarmed
	stat_penalty = STAT_CONSTITUTION

/datum/backstory/combat/archer
	name = "Former Archer"
	desc = "You were a skilled bowman, whether in war or the hunt."
	granted_skill = /datum/attribute/skill/combat/bows
	stat_penalty = STAT_STRENGTH

/datum/backstory/combat/assassin
	name = "Reformed Assassin"
	desc = "You killed for hire, a blade in the dark."
	granted_skill = /datum/attribute/skill/combat/knives
	stat_penalty = STAT_ENDURANCE

/datum/backstory/combat/crossbowman
	name = "Former Crossbowman"
	desc = "You served as a crossbowman, learning patience and precision."
	granted_skill = /datum/attribute/skill/combat/crossbows
	stat_penalty = STAT_SPEED

/datum/backstory/combat/wrestler
	name = "Pit Fighter"
	desc = "You wrestled for sport and survival in fighting pits."
	granted_skill = /datum/attribute/skill/combat/wrestling
	stat_penalty = STAT_INTELLIGENCE

/datum/backstory/combat/whipmaster
	name = "Former Slaver"
	desc = "You wielded whip and flail in a dark past you've left behind."
	granted_skill = /datum/attribute/skill/combat/whipsflails
	stat_penalty = STAT_CONSTITUTION

/datum/backstory/combat/shieldbearer
	name = "Shield Bearer"
	desc = "You defended others with shield and determination."
	granted_skill = /datum/attribute/skill/combat/shields
	stat_penalty = STAT_SPEED

/datum/backstory/combat/gunner
	name = "Former Gunner"
	desc = "You served with firearms, a dangerous and loud profession."
	granted_skill = /datum/attribute/skill/combat/firearms
	stat_penalty = STAT_PERCEPTION

/datum/backstory/combat/athlete // under "combat" so they get clamped as well
	name = "Former Athlete"
	desc = "You competed in games, testing strength and endurance."
	granted_skill = /datum/attribute/skill/misc/athletics
	stat_penalty = STAT_INTELLIGENCE

/datum/backstory/combat/acrobat
	name = "Retired Acrobat"
	desc = "You performed daring feats, climbing and leaping."
	granted_skill = /datum/attribute/skill/misc/climbing
	stat_penalty = STAT_INTELLIGENCE

/datum/backstory/craft
	abstract_type = /datum/backstory/craft
	desc = "A crafting-focused background."

/datum/backstory/craft/blacksmith
	name = "Apprentice Blacksmith"
	desc = "You worked the forge, shaping metal with hammer and anvil."
	granted_skill = /datum/attribute/skill/craft/blacksmithing
	stat_penalty = STAT_INTELLIGENCE

/datum/backstory/craft/weaponsmith
	name = "Journeyman Weaponsmith"
	desc = "You crafted weapons, from simple daggers to mighty blades."
	granted_skill = /datum/attribute/skill/craft/weaponsmithing
	stat_penalty = STAT_SPEED

/datum/backstory/craft/armorer
	name = "Former Armorer"
	desc = "You made armor, protecting warriors with your craft."
	granted_skill = /datum/attribute/skill/craft/armorsmithing
	stat_penalty = STAT_PERCEPTION

/datum/backstory/craft/carpenter
	name = "Retired Carpenter"
	desc = "You worked with wood, building homes and furniture."
	granted_skill = /datum/attribute/skill/craft/carpentry
	stat_penalty = STAT_INTELLIGENCE

/datum/backstory/craft/mason
	name = "Ex-Mason"
	desc = "You shaped stone, building walls and monuments."
	granted_skill = /datum/attribute/skill/craft/masonry
	stat_penalty = STAT_SPEED

/datum/backstory/craft/cook
	name = "Former Cook"
	desc = "You prepared meals, from simple stews to elaborate feasts."
	granted_skill = /datum/attribute/skill/craft/cooking
	stat_penalty = STAT_STRENGTH

/datum/backstory/craft/alchemist
	name = "Apprentice Alchemist"
	desc = "You mixed potions and studied strange reagents."
	granted_skill = /datum/attribute/skill/craft/alchemy
	stat_penalty = STAT_ENDURANCE

/datum/backstory/craft/engineer
	name = "Failed Engineer"
	desc = "You built machines and contraptions, though not all worked."
	granted_skill = /datum/attribute/skill/craft/engineering
	stat_penalty = STAT_CONSTITUTION

/datum/backstory/craft/tailor
	name = "Former Tailor"
	desc = "You sewed garments for nobles and commoners alike."
	granted_skill = /datum/attribute/skill/misc/sewing
	stat_penalty = STAT_STRENGTH

/datum/backstory/craft/tanner
	name = "Ex-Tanner"
	desc = "You worked with leather, turning hides into useful goods."
	granted_skill = /datum/attribute/skill/craft/tanning
	stat_penalty = STAT_INTELLIGENCE

/datum/backstory/craft/trapper
	name = "Former Trapper"
	desc = "You laid traps for beasts and sometimes men."
	granted_skill = /datum/attribute/skill/craft/traps
	stat_penalty = STAT_SPEED

/datum/backstory/craft/smelter
	name = "Apprentice Smelter"
	desc = "You worked the furnace, turning ore into metal."
	granted_skill = /datum/attribute/skill/craft/smelting
	stat_penalty = STAT_PERCEPTION

/datum/backstory/craft/bombmaker
	name = "Powder Maker"
	desc = "You crafted explosives, a dangerous trade."
	granted_skill = /datum/attribute/skill/craft/bombs
	stat_penalty = STAT_ENDURANCE

/datum/backstory/craft/general
	name = "Jack of All Trades"
	desc = "You dabbled in many crafts, master of none."
	granted_skill = /datum/attribute/skill/craft/crafting
	stat_penalty = STAT_CONSTITUTION

/datum/backstory/labor
	abstract_type = /datum/backstory/labor
	desc = "A labor-focused background."

/datum/backstory/labor/miner
	name = "Ex-Miner"
	desc = "You worked in the mines, digging for ore and gems."
	granted_skill = /datum/attribute/skill/labor/mining
	stat_penalty = STAT_PERCEPTION

/datum/backstory/labor/farmer
	name = "Former Farmer"
	desc = "You tilled the land and knew the seasons well."
	granted_skill = /datum/attribute/skill/labor/farming
	stat_penalty = STAT_SPEED

/datum/backstory/labor/fisher
	name = "Retired Fisher"
	desc = "You fished the waters, patient and persistent."
	granted_skill = /datum/attribute/skill/labor/fishing
	stat_penalty = STAT_STRENGTH

/datum/backstory/labor/butcher
	name = "Former Butcher"
	desc = "You prepared meat, skilled with knife and cleaver."
	granted_skill = /datum/attribute/skill/labor/butchering
	stat_penalty = STAT_INTELLIGENCE

/datum/backstory/labor/lumberjack
	name = "Ex-Lumberjack"
	desc = "You felled trees and split logs with ease."
	granted_skill = /datum/attribute/skill/labor/lumberjacking
	stat_penalty = STAT_PERCEPTION

/datum/backstory/labor/tamer
	name = "Beast Tamer"
	desc = "You trained animals, from horses to more exotic beasts."
	granted_skill = /datum/attribute/skill/labor/taming
	stat_penalty = STAT_STRENGTH

/datum/backstory/misc
	abstract_type = /datum/backstory/misc
	desc = "A miscellaneous background."

/datum/backstory/misc/thief
	name = "Former Thief"
	desc = "You picked pockets and stole to survive."
	granted_skill = /datum/attribute/skill/misc/stealing
	stat_penalty = STAT_STRENGTH

/datum/backstory/misc/spy
	name = "Ex-Spy"
	desc = "You moved in shadows, gathering secrets."
	granted_skill = /datum/attribute/skill/misc/sneaking
	stat_penalty = STAT_ENDURANCE

/datum/backstory/misc/locksmith
	name = "Former Locksmith"
	desc = "You worked with locks, both making and picking them."
	granted_skill = /datum/attribute/skill/misc/lockpicking
	stat_penalty = STAT_CONSTITUTION

/datum/backstory/misc/bard
	name = "Tavern Bard"
	desc = "You played for crowds, earning coin and applause."
	granted_skill = /datum/attribute/skill/misc/music
	stat_penalty = STAT_STRENGTH

/datum/backstory/misc/medic
	name = "Field Medic"
	desc = "You treated the wounded on battlefields and in clinics."
	granted_skill = /datum/attribute/skill/misc/medicine
	stat_penalty = STAT_SPEED

/datum/backstory/misc/rider
	name = "Horse Trainer"
	desc = "You rode and trained mounts for nobles and soldiers."
	granted_skill = /datum/attribute/skill/misc/riding
	stat_penalty = STAT_INTELLIGENCE

/datum/backstory/misc/scribe
	name = "Scribe's Apprentice"
	desc = "You studied letters and copied manuscripts."
	granted_skill = /datum/attribute/skill/misc/reading
	stat_penalty = STAT_ENDURANCE

/datum/backstory/misc/swimmer
	name = "Former Swimmer"
	desc = "You swam the rivers and knew the waters well."
	granted_skill = /datum/attribute/skill/misc/swimming
	stat_penalty = STAT_STRENGTH

/datum/backstory/misc/merchant
	name = "Merchant's Assistant"
	desc = "You counted coin and learned the art of numbers."
	granted_skill = /datum/attribute/skill/labor/mathematics
	stat_penalty = STAT_CONSTITUTION

/datum/backstory/magic
	abstract_type = /datum/backstory/magic
	desc = "A magical background."
	stat_reduction = 0
	clamp = 20

/datum/backstory/magic/acolyte
	name = "Former Acolyte"
	desc = "You studied in a temple, learning divine miracles."
	granted_skill = /datum/attribute/skill/magic/holy
