/datum/quirk/boon/backstory
	name = "Additional Skill"
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
		customization_value = /datum/backstory/combat/sword

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
	var/list/allowed_ages
	/// List of blocked ages
	var/list/blocked_ages
	/// List of allowed species (empty = all allowed)
	var/list/allowed_species
	/// List of blocked species
	var/list/blocked_species


/datum/backstory/proc/is_available(datum/preferences/prefs)
	if(!prefs)
		return TRUE

	// Check age restrictions
	if(length(allowed_ages) && !(prefs.read_preference(/datum/preference/choiced/age) in allowed_ages))
		return FALSE
	if(length(blocked_ages) && (prefs.read_preference(/datum/preference/choiced/age) in blocked_ages))
		return FALSE

	// Check species restrictions
	if(length(allowed_species) && !(prefs.pref_species in allowed_species))
		return FALSE
	if(length(blocked_species) && (prefs.pref_species in blocked_species))
		return FALSE

	return TRUE

/datum/backstory/combat
	abstract_type = /datum/backstory/combat
	desc = "A combat-focused background."
	amount = 20
	clamp = 20

/datum/backstory/combat/sword
	name = "Novice Swordsman"
	desc = "You dabbled in swordplay while you were younger."
	granted_skill = /datum/attribute/skill/combat/swords

/datum/backstory/combat/spear
	name = "Peasant Spearman"
	desc = "You spent much of your youth warding off wolves and goblins with a spear."
	granted_skill = /datum/attribute/skill/combat/polearms

/datum/backstory/combat/clubber
	name = "Chicken Clubber"
	desc = "You were often made to butcher the chickens for dinner, with axe or club to slay the animal."
	granted_skill = /datum/attribute/skill/combat/axesmaces

/datum/backstory/combat/brawler
	name = "Basic Brawler"
	desc = "When money was tight you took part in fistfights to earn your keep."
	granted_skill = /datum/attribute/skill/combat/unarmed

/datum/backstory/combat/hunter
	name = "Dabbling Hunter"
	desc = "You aren't the best with a bow, but it is enough to feed you."
	granted_skill = /datum/attribute/skill/combat/bows

/datum/backstory/combat/knifetricks
	name = "Knifetrick Enthusiast"
	desc = "You loved doing all sorts of tricks with knives, hands and arms nicked and scarred."
	granted_skill = /datum/attribute/skill/combat/knives

/datum/backstory/combat/guardian
	name = "Livestock Guardian"
	desc = "When volves, vernard, and other predators threatened your animals, they often met a bolt."
	granted_skill = /datum/attribute/skill/combat/crossbows

/datum/backstory/combat/wrestler
	name = "Moo-Beast Wrestler"
	desc = "Often when you grew up, you enjoyed wrestling with the bulls, now you can apply it to people too."
	granted_skill = /datum/attribute/skill/combat/wrestling

/datum/backstory/combat/thresher
	name = "Grain Thresher"
	desc = "Threshing grain translates well to cracking whips and swinging flails."
	granted_skill = /datum/attribute/skill/combat/whipsflails

/datum/backstory/combat/shieldbearer
	name = "Shield Bearer"
	desc = "You defended others with shield and determination."
	granted_skill = /datum/attribute/skill/combat/shields

/datum/backstory/combat/gunner
	name = "Gun Enthusiast"
	desc = "A mercenary travelled by, and showed you a puffer, and you have been obsessed with them ever since."
	granted_skill = /datum/attribute/skill/combat/firearms

/datum/backstory/combat/courier // under "combat" so they get clamped as well
	name = "Woodland Courier"
	desc = "You ran messages through the forests, zipping past goblins and more. "
	granted_skill = /datum/attribute/skill/misc/athletics

/datum/backstory/combat/acrobat
	name = "Wild Acrobat"
	desc = "You spent as much time in the trees as on the ground, climbing and swinging through the branches."
	granted_skill = /datum/attribute/skill/misc/climbing

/datum/backstory/craft
	abstract_type = /datum/backstory/craft
	desc = "A crafting-focused background."

/datum/backstory/craft/blacksmith
	name = "Apprentice Blacksmith"
	desc = "You worked the forge, learning to shape metal with hammer and anvil."
	granted_skill = /datum/attribute/skill/craft/blacksmithing

/datum/backstory/craft/weaponsmith
	name = "Journeyman Weaponsmith"
	desc = "You crafted weapons, from simple daggers to mighty blades."
	granted_skill = /datum/attribute/skill/craft/weaponsmithing

/datum/backstory/craft/armorer
	name = "Former Armorer"
	desc = "You made armor, protecting warriors with your craft."
	granted_skill = /datum/attribute/skill/craft/armorsmithing

/datum/backstory/craft/carver
	name = "Hobby Carver"
	desc = "You have always enjoyed shaping wood by hand and blade."
	granted_skill = /datum/attribute/skill/craft/carpentry

/datum/backstory/craft/mason
	name = "Simple Stoneworker"
	desc = "You learned to chisel and shape stone, making all sorts of carvings."
	granted_skill = /datum/attribute/skill/craft/masonry

/datum/backstory/craft/cook
	name = "Common Cook"
	desc = "You always have enjoyed cooking, and still remember the basics."
	granted_skill = /datum/attribute/skill/craft/cooking

/datum/backstory/craft/alchemist
	name = "Apprentice Alchemist"
	desc = "You mixed potions and studied strange reagents."
	granted_skill = /datum/attribute/skill/craft/alchemy

/datum/backstory/craft/engineer
	name = "Studied Engineer"
	desc = "While you couldn't build complex machines, you still know how to fix them, and make gears."
	granted_skill = /datum/attribute/skill/craft/engineering

/datum/backstory/craft/stitcher
	name = "Simple Stitcher"
	desc = "You learned to sew at a young age, and still remember some needlework."
	granted_skill = /datum/attribute/skill/misc/sewing

/datum/backstory/craft/tanner
	name = "Leatherworker"
	desc = "You worked with leather, turning hides into useful goods."
	granted_skill = /datum/attribute/skill/craft/tanning

/datum/backstory/craft/trapper
	name = "Mantrap Maker"
	desc = "You learned to lay traps for game, using wits and bait."
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
	name = "Minor Miner"
	desc = "You helped your family dig and excavate a new cellar, and some of the skills stuck with you."
	granted_skill = /datum/attribute/skill/labor/mining

/datum/backstory/labor/farmer
	name = "Family Farmer"
	desc = "You tilled the land and grew simple foods for your home."
	granted_skill = /datum/attribute/skill/labor/farming

/datum/backstory/labor/fisher
	name = "Leisure Time Fisher"
	desc = "You fished the waters, getting away from the daily grind and enjoying the peace of the water."
	granted_skill = /datum/attribute/skill/labor/fishing

/datum/backstory/labor/butcher
	name = "Basic Butcher"
	desc = "You were  often set to work cleaning the carcasses of the animals, your hands still remember the feeling."
	granted_skill = /datum/attribute/skill/labor/butchering

/datum/backstory/labor/lumberjack
	name = "Learned Lumberjack"
	desc = "You helped split wood and chop trees around winter, for fuel and construction."
	granted_skill = /datum/attribute/skill/labor/lumberjacking

/datum/backstory/labor/tamer
	name = "Rous Whisperer"
	desc = "Your first pet was a rous, which you befriended with cheese. Your family always said you had a way with animals."
	granted_skill = /datum/attribute/skill/labor/taming

/datum/backstory/misc
	abstract_type = /datum/backstory/misc
	desc = "A miscellaneous background."

/datum/backstory/misc/pickpocket
	name = "Pickpocketing"
	desc = "You have always had sticky fingers."
	granted_skill = /datum/attribute/skill/misc/stealing

/datum/backstory/misc/sneaky
	name = "Light-footed Listener"
	desc = "You had a tendency to creep around and enjoy going unseen."
	granted_skill = /datum/attribute/skill/misc/sneaking

/datum/backstory/misc/locksmith
	name = "Latent Locksmith"
	desc = "You've always had a knack for locks and keys, and learned to pick them for fun."
	granted_skill = /datum/attribute/skill/misc/lockpicking

/datum/backstory/misc/bard
	name = "Tavern Bard"
	desc = "You have always had a passion for music, and learned to play a few instruments."
	granted_skill = /datum/attribute/skill/misc/music

/datum/backstory/misc/medic
	name = "Doctor's Assistant"
	desc = "Your home town's feldsher often recruited you to help with basic medical care, and you learned a few things."
	granted_skill = /datum/attribute/skill/misc/medicine

/datum/backstory/misc/rider
	name = "Horse Trainer"
	desc = "You helped raise saiga, and learned to ride too."
	granted_skill = /datum/attribute/skill/misc/riding

/datum/backstory/misc/literacy
	name = "Basic Literacy"
	desc = "You spent time learning to read and write as a child."
	granted_skill = /datum/attribute/skill/misc/reading

/datum/backstory/misc/swimmer
	name = "Summer Swimmer"
	desc = "You enjoyed swimming often to cool off come the hot days of the summer."
	granted_skill = /datum/attribute/skill/misc/swimming

/datum/backstory/misc/merchant
	name = "Marketplace Assistant"
	desc = "You helped handle the coin from your family's ventures, and still have a good handle on math."
	granted_skill = /datum/attribute/skill/labor/mathematics

/datum/backstory/magic
	abstract_type = /datum/backstory/magic
	desc = "A magical background."

