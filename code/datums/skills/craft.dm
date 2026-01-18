/datum/skill/craft
	abstract_type = /datum/skill/craft
	name = "Craft"
	desc = ""  //Most descriptions are placeholders. They might not reflect reality or what it does in the code

/datum/skill/craft/crafting
	name = "Crafting"
	desc = "Crafting is a general skill that represents your character's ability to craft items. The higher your skill in Crafting, the more complex items you can craft."
	dreams = list(
		"...you feel grass under you feet as you peer onto a meadow, you prepare a campfire and a tent and drift off into deeper slumber.."
	)

/datum/skill/craft/weaponsmithing
	name = "Weaponsmithing"
	desc = "Weaponsmithing is a skill that represents your character's ability to craft metal weapons. The higher your skill in Weaponsmithing, the more complex weapons you can create, and the better resulting quality, up to Masterwork."
	dreams = list(
		"...you gently grasp the tang of the blade. without water nor oil, you turn over to the basin, slicing your hand, and letting the blood fill the void... you quench the blade."
	)

/datum/skill/craft/armorsmithing
	name = "Armorsmithing"
	desc = "Armorsmithing is a skill that represents your character's ability to craft metal armor. The higher your skill in Armorsmithing, the more complex armor you can create, and the better resulting quality, up to Masterwork."
	dreams = list(
		"...you are assailed by a faceless adversary. he pummels you - crack, crack, crack... it hurts, you scream... he tires, you do not..."
	)

/datum/skill/craft/blacksmithing
	name = "Blacksmithing"
	desc = "Blacksmithing is a skill that represents your character's ability to craft metal items. The higher your skill in Blacksmithing, the more complex items you can create, and the better resulting quality, up to Masterwork."
	dreams = list(
		"...CLANG! Clang! Clang... you feel the weight of the hammer reverberate up your arm, past your shoulder, through your spine... the hits march to the drums of your heart. you feel attuned to the metal."
	)

/datum/skill/craft/smelting
	name = "Smelting"
	desc = "Smelting is a skill that represents your character's ability to smelt metal into ingots. The higher your skill in Smelting, the better the ingots you create, which affect the quality of the resulting item."
	dreams = list(
		"...the heat brings warmth to you on this dreary night. your feet ache, and your arms remain sore - but the stress of the day melts away, along with the snow around you - becoming just another distant memory."
	)

/datum/skill/craft/carpentry
	name = "Carpentry"
	desc = "Carpentry is a skill that represents your character's ability to craft wooden items. The higher your skill in Carpentry, the faster you can create wooden items and buildings."
	dreams = list(
		"...in the bitter cold, you stay in your cabin... in the dreary fire, the chair you made burns... the effort wasted, and yet you live..."
	)

/datum/skill/craft/masonry
	name = "Masonry"
	desc =	"Masonry is a skill that represents your character's ability to craft stone items. The higher your skill in Masonry, the faster you can make stone items and buildings."
	dreams = list(
		"...you chisel and chisel at the marble, the hammer slipping and smacking you square in the thumb... blood gently trickles over the stone, as the statue reflects the scars of its artisan..."
	)

/datum/skill/craft/traps
	name = "Trapping"
	desc = "Trapping is a skill that represents your character's ability to lay traps. The higher your skill in Trapping, the more effective your traps will be and the less likely you are to set them off accidentally."
	dreams = list(
		"...you hear a quick snap in the distance... you rush over, and notice a small cabbit with a snare wrapped around its leg... you gently unsheath your knife, and loom over the poor, frightened thing..."
	)

/datum/skill/craft/cooking
	name = "Cooking"
	desc = "Cooking is a skill that represents your character's ability to cook food. The higher your skill in Cooking, the better the food you can cook and the more you can make with your ingredients."
	dreams = list(
		"...you sit by the table in your dreary hovel, staring at the wooden bowl of soup given to you by your mother... you blink and look around the tavern, before your vision returns to the bowl... you feel comforted..."
	)

/datum/skill/craft/alchemy
	name = "Alchemy"
	desc = "Alchemy is a skill that represents your character's ability to craft potions. The higher your skill in Alchemy, the better you can identify potions and ingredients."
	dreams = list(
		"...the smell of sulfur singes your nostrils... you taste iron... the smoke clears as you stare down at the reflection in your cauldron... the Queen stares back at you... she looks like she's crying..."
	)

/datum/skill/craft/alchemy/skill_level_effect(level, datum/mind/mind)
	if(level > SKILL_LEVEL_MASTER)
		ADD_TRAIT(mind?.current, TRAIT_LEGENDARY_ALCHEMIST, type)
	else if(HAS_TRAIT(mind?.current, TRAIT_LEGENDARY_ALCHEMIST))
		REMOVE_TRAIT(mind?.current, TRAIT_LEGENDARY_ALCHEMIST, type)

/datum/skill/craft/bombs
	name = "Bombcrafting"
	desc = "Bombcrafting is a skill that represents your character's ability to craft bombs. The higher your skill in Bombcrafting, the better the bombs you can create and the more you can make with your materials."
	dreams = list(
		"...you pour the powder down the barrel of the cannon, and without a projectile to follow the dust, you cut off a finger, and toss it in there... you turn to light the fuse..."
	)

/datum/skill/craft/engineering
	name = "Engineering"
	desc = "Engineering is a skill that represents your character's ability to craft mechanical items. The higher your skill in Engineering, the more complex items you can create without failure..."
	dreams = list(
		"...visions plague your mind. you toss and turn this nite. you see mechanical beasts gutting their masters with bare hands, fire raging acrost unknown streets... you grab a brick off the road and peer below into an infinite void... you inhale, and feel the steam burn your lungs..."
	)

/datum/skill/craft/tanning
	name = "Skincrafting"
	desc = "Skincrafting is a skill that represents your character's ability to process and use animal hide. The higher your skill in Skinning, the more leather you can create and the more you can make with them."
	dreams = list(
		"...you stare down at the rabbit, its eyes wide and unblinking... you feel the knife in your hand, and the blood on your hands... and the warmth of the pelt..."
	)
