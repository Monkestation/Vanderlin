/// Divine pantheon storytellers
#define DIVINE_STORYTELLERS list( \
	/datum/storyteller/astrata, \
	/datum/storyteller/noc, \
	/datum/storyteller/ravox, \
	/datum/storyteller/abyssor, \
	/datum/storyteller/xylix, \
	/datum/storyteller/necra, \
	/datum/storyteller/pestra, \
	/datum/storyteller/malum, \
	/datum/storyteller/eora, \
	/datum/storyteller/dendor, \
)

/// Inhumen pantheon storytellers
#define INHUMEN_STORYTELLERS list( \
	/datum/storyteller/zizo, \
	/datum/storyteller/baotha, \
	/datum/storyteller/graggar, \
	/datum/storyteller/matthios, \
)

/// All storytellers
#define STORYTELLERS_ALL (DIVINE_STORYTELLERS + INHUMEN_STORYTELLERS)

/datum/storyteller/astrata
	name = "Astrata"
	desc = "Astrata will provide a balanced and varied experience. Consider this the default experience."
	weight = 6
	always_votable = TRUE
	follower_modifier = ASTRATA_FOLLOWER_MODIFIER
	color_theme = "#FFD700"

	influence_factors = list(
		STATS_LAWS_AND_DECREES_MADE = list("points" = 2.75, "capacity" = 45),
		STATS_ALIVE_NOBLES = list("points" = 3.5, "capacity" = 75),
		STATS_NOBLE_DEATHS = list("points" = -5, "capacity" = -70),
		STATS_ASTRATA_REVIVALS = list("points" = 6, "capacity" = 75),
		STATS_SLURS_SPOKEN = list("points" = 0.2, "capacity" = 90),
	)

/datum/storyteller/noc
	name = "Noc"
	desc = "Noc will try to send more magical events."
	welcome_text = "The veil between realms shimmers in your presence."
	weight = 4
	always_votable = TRUE
	color_theme = "#F0F0F0"

	tag_multipliers = list(
		TAG_MAGICAL = 1.2,
		TAG_HAUNTED = 1.1,
	)
	cost_variance = 25

	influence_factors = list(
		STATS_BOOKS_PRINTED = list("points" = 5, "capacity" = 40),
		STATS_LITERACY_TAUGHT = list("points" = 15, "capacity" = 70),
		STATS_ILLITERATES = list("points" = -2, "capacity" = -40),
		STATS_SKILLS_DREAMED = list("points" = 0.325, "capacity" = 100),
		STATS_MANA_SPENT = list("points" = 0.0175, "capacity" = 100),
	)

/datum/storyteller/ravox
	name = "Ravox"
	desc = "Ravox will cause raids to happen naturally instead of only when people are dying a lot."
	welcome_text = "The drums of war grow louder."
	weight = 4
	always_votable = TRUE
	color_theme = "#228822"

	tag_multipliers = list(
		TAG_RAID = 1.3,
	)

	point_gains_multipliers = list(
		EVENT_TRACK_MUNDANE = 0.75,
		EVENT_TRACK_PERSONAL = 0.9,
		EVENT_TRACK_MODERATE = 1,
		EVENT_TRACK_INTERVENTION = 1,
		EVENT_TRACK_CHARACTER_INJECTION = 1,
		EVENT_TRACK_OMENS = 1,
		EVENT_TRACK_RAIDS = 2,
	)

	influence_factors = list(
		STATS_COMBAT_SKILLS = list("points" = 1.2, "capacity" = 100),
		STATS_PARRIES = list("points" = 0.05, "capacity" = 100),
		STATS_WARCRIES = list("points" = 0.375, "capacity" = 50),
		STATS_YIELDS = list("points" = -5, "capacity" = -40),
		STATS_UNDERWORLD_DUELS = list("points" = 6, "capacity" = 70),
	)

/datum/storyteller/abyssor
	name = "Abyssor"
	desc = "Abyssor likes to send water and trade-related events."
	welcome_text = "The tides of fate shift in your favor."
	weight = 4
	always_votable = TRUE
	color_theme = "#3366CC"

	tag_multipliers = list(
		TAG_WATER = 1.3,
		TAG_TRADE = 1.2,
	)

	influence_factors = list(
		STATS_WATER_CONSUMED = list("points" = 0.0125, "capacity" = 90),
		STATS_FISH_CAUGHT = list("points" = 1.8, "capacity" = 90),
		STATS_ABYSSOR_REMEMBERED = list("points" = 0.75, "capacity" = 40),
		STATS_LEECHES_EMBEDDED = list("points" = 0.175, "capacity" = 70),
		STATS_PEOPLE_DROWNED = list("points" = 9, "capacity" = 75),
	)

/datum/storyteller/xylix
	name = "Xylix"
	desc = "Xylix is a wildcard, spinning the wheels of fate."
	welcome_text = "The dice have been cast, let chaos reign."
	weight = 4
	always_votable = TRUE
	color_theme = "#AA8888"
	event_repetition_multiplier = 0
	forced = TRUE

	point_gains_multipliers = list(
		EVENT_TRACK_MUNDANE = 1,
		EVENT_TRACK_PERSONAL = 1,
		EVENT_TRACK_MODERATE = 0,
		EVENT_TRACK_INTERVENTION = 0,
		EVENT_TRACK_CHARACTER_INJECTION = 0,
		EVENT_TRACK_OMENS = 0,
		EVENT_TRACK_RAIDS = 0,
	)

	influence_factors = list(
		STATS_LAUGHS_MADE = list("points" = 0.25, "capacity" = 85),
		STATS_GAMES_RIGGED = list("points" = 3.5, "capacity" = 35),
		STATS_PEOPLE_MOCKED = list("points" = 5, "capacity" = 60),
		STATS_CRITS_MADE = list("points" = 0.275, "capacity" = 90),
		STATS_SONGS_PLAYED = list("points" = 0.75, "capacity" = 70),
	)

/datum/storyteller/necra
	name = "Necra"
	desc = "Necra takes things very slow, rarely bringing in newcomers."
	welcome_text = "The grave whispers, patience is virtue."
	weight = 4
	always_votable = TRUE
	color_theme = "#888888"

	tag_multipliers = list(
		TAG_HAUNTED = 1.3,
	)

	point_gains_multipliers = list(
		EVENT_TRACK_MUNDANE = 1.25,
		EVENT_TRACK_PERSONAL = 0.7,
		EVENT_TRACK_MODERATE = 1.25,
		EVENT_TRACK_INTERVENTION = 1.25,
		EVENT_TRACK_CHARACTER_INJECTION = 0.5,
		EVENT_TRACK_OMENS = 1.25,
		EVENT_TRACK_RAIDS = 0.5,
	)

	influence_factors = list(
		STATS_DEATHS = list("points" = 1.35, "capacity" = 110),
		STATS_GRAVES_CONSECRATED = list("points" = 6.5, "capacity" = 100),
		STATS_GRAVES_ROBBED = list("points" = -4, "capacity" = -40),
		STATS_DEADITES_KILLED = list("points" = 6, "capacity" = 90),
		STATS_VAMPIRES_KILLED = list("points" = 12, "capacity" = 70),
	)

/datum/storyteller/pestra
	name = "Pestra"
	desc = "Pestra keeps things simple, with a slight bias towards alchemy."
	welcome_text = "The balance of life and craft tilts in your favor."
	color_theme = "#AADDAA"

	tag_multipliers = list(
		TAG_ALCHEMY = 1.2,
		TAG_MEDICAL = 1.2,
		TAG_NATURE = 1.1,
	)

	influence_factors = list(
		STATS_POTIONS_BREWED = list("points" = 4.25, "capacity" = 80),
		STATS_WOUNDS_SEWED = list("points" = 0.475, "capacity" = 100),
		STATS_SOULS_REINCARNATED = list("points" = 2.25, "capacity" = 65),
		STATS_ANIMALS_BRED = list("points" = 5, "capacity" = 65),
		STATS_FOOD_ROTTED = list("points" = 0.175, "capacity" = 80),
	)

/datum/storyteller/malum
	name = "Malum"
	desc = "Malum believes in hard work, intervening more often than others."
	welcome_text = "Toil and perseverance shall shape your destiny."
	color_theme = "#D4A56C"

	tag_multipliers = list(
		TAG_WORK = 1.5,
	)

	point_gains_multipliers = list(
		EVENT_TRACK_MUNDANE = 1,
		EVENT_TRACK_PERSONAL = 1.2,
		EVENT_TRACK_MODERATE = 1,
		EVENT_TRACK_INTERVENTION = 2,
		EVENT_TRACK_CHARACTER_INJECTION = 1,
		EVENT_TRACK_OMENS = 1,
		EVENT_TRACK_RAIDS = 1,
	)

	influence_factors = list(
		STATS_MASTERWORKS_FORGED = list("points" = 2.4, "capacity" = 85),
		STATS_ROCKS_MINED = list("points" = 0.25, "capacity" = 100),
		STATS_CRAFT_SKILLS = list("points" = 0.6, "capacity" = 90),
		STATS_BEARDS_SHAVED = list("points" = -4, "capacity" = -40),
		STATS_BLACKSTEEL_SMELTED = list("points" = 5, "capacity" = 65),
	)

/datum/storyteller/eora
	name = "Eora"
	desc = "Eora hates death and promotes love. Raids will never naturally progress, only death will bring them."
	welcome_text = "Life shall flourish under my watchful gaze."
	color_theme = "#9966CC"

	tag_multipliers = list(
		TAG_WIDESPREAD = 1.5,
		TAG_BOON = 1.2,
	)

	point_gains_multipliers = list(
		EVENT_TRACK_MUNDANE = 1,
		EVENT_TRACK_PERSONAL = 1.4,
		EVENT_TRACK_MODERATE = 1,
		EVENT_TRACK_INTERVENTION = 2,
		EVENT_TRACK_CHARACTER_INJECTION = 1,
		EVENT_TRACK_OMENS = 1,
		EVENT_TRACK_RAIDS = 0,
	)

	influence_factors = list(
		STATS_PARENTS = list("points" = 8, "capacity" = 90),
		STATS_MARRIAGES = list("points" = 25, "capacity" = 75),
		STATS_HUGS_MADE = list("points" = 1.75, "capacity" = 60),
		STATS_HANDS_HELD = list("points" = 2.5, "capacity" = 60),
		STATS_PACIFISTS = list("points" = 10, "capacity" = 70),
	)

/datum/storyteller/dendor
	name = "Dendor"
	desc = "Dendor likes to send nature-themed events."
	welcome_text = "The wilds whisper your name."
	weight = 4
	always_votable = TRUE
	color_theme = "#664422"

	tag_multipliers = list(
		TAG_NATURE = 1.5,
	)

	point_gains_multipliers = list(
		EVENT_TRACK_MUNDANE = 1,
		EVENT_TRACK_PERSONAL = 0.8,
		EVENT_TRACK_MODERATE = 1,
		EVENT_TRACK_INTERVENTION = 2,
		EVENT_TRACK_CHARACTER_INJECTION = 1,
		EVENT_TRACK_OMENS = 1,
		EVENT_TRACK_RAIDS = 1,
	)

	influence_factors = list(
		STATS_TREES_CUT = list("points" = -0.375, "capacity" = -60),
		STATS_PLANTS_HARVESTED = list("points" = 0.75, "capacity" = 130),
		STATS_WEREVOLVES = list("points" = 15, "capacity" = 80),
		STATS_DENDOR_SACRIFICES = list("points" = 15, "capacity" = 80),
		STATS_FOREST_DEATHS = list("points" = 6.5, "capacity" = 90),
	)

// INHUMEN

/datum/storyteller/zizo
	name = "Zizo"
	desc = "Zizo thrives on risk and reward, favoring the daring and unpredictable."
	welcome_text = "You will kneel."
	weight = 4
	always_votable = TRUE
	color_theme = "#CC4444"

	tag_multipliers = list(
		TAG_MAGICAL = 1.2,
		TAG_GAMBLE = 1.5,
		TAG_TRICKERY = 1.3,
		TAG_UNEXPECTED = 1.2,
	)

	point_gains_multipliers = list(
		EVENT_TRACK_MUNDANE = 1,
		EVENT_TRACK_PERSONAL = 1.2,
		EVENT_TRACK_MODERATE = 1.1,
		EVENT_TRACK_INTERVENTION = 1.5,
		EVENT_TRACK_CHARACTER_INJECTION = 1,
		EVENT_TRACK_OMENS = 1.3,
		EVENT_TRACK_RAIDS = 0.8,
	)

	influence_factors = list(
		STATS_ZIZO_PRAISED = list("points" = 0.3, "capacity" = 40),
		STATS_NOBLE_DEATHS = list("points" = 5, "capacity" = 80),
		STATS_DEADITES_WOKEN_UP = list("points" = 3, "capacity" = 90),
		STATS_CLERGY_DEATHS = list("points" = 9, "capacity" = 80),
		STATS_TORTURES = list("points" = 4, "capacity" = 70),
	)

	cost_variance = 50  // Events will be highly variable in cost

/datum/storyteller/baotha
	name = "Baotha"
	desc = "Baotha revels in chaos, making events and reality unpredictable."
	welcome_text = "The world bends to my whims."
	weight = 4
	always_votable = TRUE
	color_theme = "#9933FF"

	tag_multipliers = list(
		TAG_INSANITY = 1.4,
		TAG_MAGIC = 1.2,
		TAG_DISASTER = 1.1,
	)

	point_gains_multipliers = list(
		EVENT_TRACK_MUNDANE = 1.1,
		EVENT_TRACK_PERSONAL = 1.2,
		EVENT_TRACK_MODERATE = 1.3,
		EVENT_TRACK_INTERVENTION = 2,
		EVENT_TRACK_CHARACTER_INJECTION = 0.7,
		EVENT_TRACK_OMENS = 1.5,
		EVENT_TRACK_RAIDS = 1.2,
	)

	influence_factors = list(
		STATS_DRUGS_SNORTED = list("points" = 4.5, "capacity" = 85),
		STATS_ALCOHOL_CONSUMED = list("points" = 0.045, "capacity" = 90),
		STATS_ALCOHOLICS = list("points" = 3.5, "capacity" = 60),
		STATS_JUNKIES = list("points" = 8, "capacity" = 70),
		STATS_LUXURIOUS_FOOD_EATEN = list("points" = 0.85, "capacity" = 85),
	)

	cost_variance = 30  // Makes events more erratic in timing

/datum/storyteller/graggar
	name = "Graggar"
	desc = "Graggar encourages war and conquest, making combat the solution to all."
	welcome_text = "Victory or death!"
	weight = 4
	always_votable = TRUE
	color_theme = "#8B3A3A"

	tag_multipliers = list(
		TAG_BATTLE = 1.6,
		TAG_BLOOD = 1.3,
		TAG_WAR = 1.2,
	)

	point_gains_multipliers = list(
		EVENT_TRACK_MUNDANE = 0.8,
		EVENT_TRACK_PERSONAL = 0.7,
		EVENT_TRACK_MODERATE = 1.2,
		EVENT_TRACK_INTERVENTION = 1.5,
		EVENT_TRACK_CHARACTER_INJECTION = 1,
		EVENT_TRACK_OMENS = 0.9,
		EVENT_TRACK_RAIDS = 2.5,
	)

	influence_factors = list(
		STATS_BLOOD_SPILT = list("points" = 0.000275, "capacity" = 90),
		STATS_ORGANS_EATEN = list("points" = 3.25, "capacity" = 75),
		STATS_LIMBS_BITTEN = list("points" = 0.6, "capacity" = 75),
		STATS_PEOPLE_GIBBED = list("points" = 3, "capacity" = 50),
		STATS_ASSASSINATIONS = list("points" = 15, "capacity" = 80),
	)

	cost_variance = 10  // Less randomness, more direct

/datum/storyteller/matthios
	name = "Matthios"
	desc = "Matthios manipulates wealth and corruption, rewarding those who make deals."
	welcome_text = "Fortune favors the cunning."
	weight = 4
	always_votable = TRUE
	color_theme = "#8B4513"

	tag_multipliers = list(
		TAG_TRADE = 1.4,
		TAG_CORRUPTION = 1.3,
		TAG_LOOT = 1.2,
	)

	point_gains_multipliers = list(
		EVENT_TRACK_MUNDANE = 1,
		EVENT_TRACK_PERSONAL = 1.1,
		EVENT_TRACK_MODERATE = 1.2,
		EVENT_TRACK_INTERVENTION = 1.3,
		EVENT_TRACK_CHARACTER_INJECTION = 1.5,
		EVENT_TRACK_OMENS = 1.1,
		EVENT_TRACK_RAIDS = 0.6,
	)

	influence_factors = list(
		STATS_ITEMS_PICKPOCKETED = list("points" = 5, "capacity" = 85),
		STATS_SHRINE_VALUE = list("points" = 0.1, "capacity" = 70),
		STATS_GREEDY_PEOPLE = list("points" = 8, "capacity" = 70),
		STATS_DODGES = list("points" = 0.0865, "capacity" = 100),
		STATS_LOCKS_PICKED = list("points" = 4, "capacity" = 85),
	)

	cost_variance = 15  // Keeps a balance between predictability and randomness
