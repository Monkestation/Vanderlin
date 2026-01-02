/datum/storyteller/astrata
	name = ASTRATA
	desc = "Astrata will provide a balanced and varied experience. Consider this the default experience."
	weight = 6
	always_votable = TRUE
	follower_modifier = LOWER_FOLLOWER_MODIFIER
	color_theme = "#FFD700"

	tag_multipliers = list(
		TAG_ASTRATA = 3,
	)

	influence_sets = list(
		"Set 1" = list(
			STATS_LAWS_AND_DECREES_MADE = list("name" = "Laws and decrees:", "points" = 2.6, "capacity" = 40),
		),
		"Set 2" = list(
			STATS_ALIVE_NOBLES = list("name" = "Number of nobles:", "points" = 2.25, "capacity" = 60),
		),
		"Set 3" = list(
			STATS_NOBLE_DEATHS = list("name" = "Noble deaths:", "points" = -3.5, "capacity" = -60),
			STATS_PEOPLE_SMITTEN = list("name" = "People smitten:", "points" = 6, "capacity" = 40),
		),
		"Set 4" = list(
			STATS_ASTRATA_REVIVALS = list("name" = "Holy revivals:", "points" = 6.25, "capacity" = 75),
			STATS_PRAYERS_MADE = list("name" = "Prayers made:", "points" = 1.375, "capacity" = 65),
		),
		"Set 5" = list(
			STATS_TAXES_COLLECTED = list("name" = "Taxes collected:", "points" = 0.215, "capacity" = 80),
			STATS_SLURS_SPOKEN = list("name" = "Slurs spoken:", "points" = 1.425, "capacity" = 70),
		)
	)

/datum/storyteller/noc
	name = NOC
	desc = "Noc will try to send more magical events."
	welcome_text = "The veil between realms shimmers in your presence."
	weight = 4
	always_votable = TRUE
	follower_modifier = LOWER_FOLLOWER_MODIFIER
	color_theme = "#F0F0F0"

	tag_multipliers = list(
		TAG_NOC = 3,
		TAG_MAGICAL = 1.75,
		TAG_HAUNTED = 1.5,
	)
	cost_variance = 25

	influence_sets = list(
		"Set 1" = list(
			STATS_BOOKS_PRINTED = list("name" = "Books printed:", "points" = 4, "capacity" = 40),
		),
		"Set 2" = list(
			STATS_LITERACY_TAUGHT = list("name" = "Literacy taught:", "points" = 12.5, "capacity" = 65),
		),
		"Set 3" = list(
			STATS_ILLITERATES = list("name" = "Number of illiterates:", "points" = -2.5, "capacity" = -40),
		),
		"Set 4" = list(
			STATS_SKILLS_DREAMED = list("name" = "Skills dreamed:", "points" = 0.265, "capacity" = 80),
		),
		"Set 5" = list(
			STATS_MANA_SPENT = list("name" = "Mana spent:", "points" = 0.010, "capacity" = 90),
		)
	)

/datum/storyteller/ravox
	name = RAVOX
	desc = "Ravox will cause raids to happen naturally instead of only when people are dying a lot."
	welcome_text = "The drums of war grow louder."
	weight = 4
	always_votable = TRUE
	color_theme = "#228822"

	tag_multipliers = list(
		TAG_RAVOX = 3,
		TAG_COMBAT = 1.75,
		TAG_RAID = 1.5,
	)

	point_gains_multipliers = list(
		EVENT_TRACK_MUNDANE = 0.75,
		EVENT_TRACK_PERSONAL = 1,
		EVENT_TRACK_MODERATE = 1,
		EVENT_TRACK_INTERVENTION = 1,
		EVENT_TRACK_CHARACTER_INJECTION = 1.25,
		EVENT_TRACK_OMENS = 1,
		EVENT_TRACK_RAIDS = 1.75,
	)

	influence_sets = list(
		"Set 1" = list(
			STATS_COMBAT_SKILLS = list("name" = "Combat skills learned:", "points" = 0.7, "capacity" = 80),
		),
		"Set 2" = list(
			STATS_PARRIES = list("name" = "Parries made:", "points" = 0.0535, "capacity" = 100),
		),
		"Set 3" = list(
			STATS_WARCRIES = list("name" = "Warcries made:", "points" = 0.325, "capacity" = 50),
		),
		"Set 4" = list(
			STATS_YIELDS = list("name" = "Yields made:", "points" = -4, "capacity" = -40),
		),
		"Set 5" = list(
			STATS_UNDERWORLD_DUELS = list("name" = "Underworld duels:", "points" = 6, "capacity" = 60),
		)
	)

/datum/storyteller/abyssor
	name = ABYSSOR
	desc = "Abyssor likes to send water and trade-related events."
	welcome_text = "The tides of fate shift in your favor."
	weight = 4
	always_votable = TRUE
	color_theme = "#3366CC"

	tag_multipliers = list(
		TAG_ABYSSOR = 3,
		TAG_WATER = 1.75,
		TAG_TRADE = 1.5,
	)

	influence_sets = list(
		"Set 1" = list(
			STATS_FISH_CAUGHT = list("name" = "Fish caught:", "points" = 1.5, "capacity" = 80),
		),
		"Set 2" = list(
			STATS_WATER_CONSUMED = list("name" = "Water consumed:", "points" = 0.014, "capacity" = 90),
		),
		"Set 3" = list(
			STATS_ABYSSOR_REMEMBERED = list("name" = "Abyssor remembered:", "points" = 1.1, "capacity" = 50),
			STATS_ALIVE_TRITONS = list("name" = "Number of tritons:", "points" = 8, "capacity" = 70),
		),
		"Set 4" = list(
			STATS_LEECHES_EMBEDDED = list("name" = "Leeches embedded:", "points" = 0.7, "capacity" = 70),
		),
		"Set 5" = list(
			STATS_PEOPLE_DROWNED = list("name" = "People drowned:", "points" = 12, "capacity" = 75),
			STATS_BATHS_TAKEN = list("name" = "Baths taken:", "points" = 4, "capacity" = 60),
		)
	)

/datum/storyteller/xylix
	name = XYLIX
	desc = "Xylix is a wildcard, spinning the wheels of fate."
	welcome_text = "The dice have been cast, let chaos reign."
	weight = 4
	always_votable = TRUE
	color_theme = "#AA8888"
	event_repetition_multiplier = 0
	forced = TRUE

	tag_multipliers = list(
		TAG_XYLIX = 3,
		TAG_GAMBLE = 1.75,
		TAG_TRICKERY = 1.5,
		TAG_UNEXPECTED = 1.25,
	)

	point_gains_multipliers = list(
		EVENT_TRACK_MUNDANE = 1,
		EVENT_TRACK_PERSONAL = 1.5,
		EVENT_TRACK_MODERATE = 1,
		EVENT_TRACK_INTERVENTION = 1.75,
		EVENT_TRACK_CHARACTER_INJECTION = 0,
		EVENT_TRACK_OMENS = 1,
		EVENT_TRACK_RAIDS = 1,
	)

	influence_sets = list(
		"Set 1" = list(
			STATS_LAUGHS_MADE = list("name" = "Laughs had:", "points" = 0.285, "capacity" = 85),
		),
		"Set 2" = list(
			STATS_GAMES_RIGGED = list("name" = "Games rigged:", "points" = 4, "capacity" = 40),
		),
		"Set 3" = list(
			STATS_PEOPLE_MOCKED = list("name" = "People mocked:", "points" = 5.5, "capacity" = 60),
		),
		"Set 4" = list(
			STATS_CRITS_MADE = list("name" = "Crits made:", "points" = 0.285, "capacity" = 90),
		),
		"Set 5" = list(
			STATS_SONGS_PLAYED = list("name" = "Songs played:", "points" = 0.775, "capacity" = 70),
			STATS_MOAT_FALLERS = list("name" = "Moat fallers:", "points" = 5, "capacity" = 50),
		)
	)

/datum/storyteller/necra
	name = NECRA
	desc = "Necra takes things very slow, rarely bringing in newcomers."
	welcome_text = "The grave whispers, patience is virtue."
	weight = 4
	always_votable = TRUE
	color_theme = "#888888"

	tag_multipliers = list(
		TAG_NECRA = 3,
		TAG_HAUNTED = 1.75,
	)

	point_gains_multipliers = list(
		EVENT_TRACK_MUNDANE = 1.25,
		EVENT_TRACK_PERSONAL = 0.75,
		EVENT_TRACK_MODERATE = 1.25,
		EVENT_TRACK_INTERVENTION = 1.25,
		EVENT_TRACK_CHARACTER_INJECTION = 0.75,
		EVENT_TRACK_OMENS = 1.25,
		EVENT_TRACK_RAIDS = 0.75,
	)

	influence_sets = list(
		"Set 1" = list(
			STATS_DEATHS = list("name" = "Total deaths:", "points" = 1.25, "capacity" = 90),
		),
		"Set 2" = list(
			STATS_GRAVES_CONSECRATED = list("name" = "Graves consecrated:", "points" = 6, "capacity" = 80),
		),
		"Set 3" = list(
			STATS_GRAVES_ROBBED = list("name" = "Graves robbed:", "points" = -3.5, "capacity" = -40),
			STATS_ALIVE_SNOW_ELVES = list("name" = "Number of elves:", "points" = 4.25, "capacity" = 60),
		),
		"Set 4" = list(
			STATS_DEADITES_KILLED = list("name" = "Deadites killed:", "points" = 5.5, "capacity" = 90),
		),
		"Set 5" = list(
			STATS_VAMPIRES_KILLED = list("name" = "Vampires killed:", "points" = 12, "capacity" = 70),
			STATS_SOULS_REINCARNATED = list("name" = "Souls reincarnated:", "points" = 2.25, "capacity" = 70),
		)
	)

/datum/storyteller/pestra
	name = PESTRA
	desc = "Pestra keeps things simple, with a slight bias towards alchemy."
	welcome_text = "The balance of life and craft tilts in your favor."
	color_theme = "#AADDAA"

	tag_multipliers = list(
		TAG_PESTRA = 3,
		TAG_ALCHEMY = 1.75,
		TAG_MEDICAL = 1.75,
		TAG_NATURE = 1.25,
	)

	influence_sets = list(
		"Set 1" = list(
			STATS_POTIONS_BREWED = list("name" = "Potions brewed:", "points" = 2.75, "capacity" = 70),
			STATS_ANIMALS_BRED = list("name" = "Animals bred:", "points" = 1.5, "capacity" = 60),
		),
		"Set 2" = list(
			STATS_WOUNDS_SEWED = list("name" = "Wounds sewed up:", "points" = 0.75, "capacity" = 90),
		),
		"Set 3" = list(
			STATS_LUX_HARVESTED = list("name" = "Lux extracted:", "points" = 8, "capacity" = 70),
			STATS_LUX_REVIVALS = list("name" = "Lux revivals:", "points" = 16, "capacity" = 70),
		),
		"Set 4" = list(
			STATS_ALIVE_MEDICATORS = list("name" = "Number of medicators:", "points" = 8, "capacity" = 70),
		),
		"Set 5" = list(
			STATS_FOOD_ROTTED = list("name" = "Food rotted:", "points" = 0.175, "capacity" = 80),
		)
	)

/datum/storyteller/malum
	name = MALUM
	desc = "Malum believes in hard work, intervening more often than others."
	welcome_text = "Toil and perseverance shall shape your destiny."
	color_theme = "#D4A56C"

	tag_multipliers = list(
		TAG_MALUM = 3,
		TAG_WORK = 1.75,
	)

	point_gains_multipliers = list(
		EVENT_TRACK_MUNDANE = 1,
		EVENT_TRACK_PERSONAL = 1.25,
		EVENT_TRACK_MODERATE = 1,
		EVENT_TRACK_INTERVENTION = 2,
		EVENT_TRACK_CHARACTER_INJECTION = 1,
		EVENT_TRACK_OMENS = 1,
		EVENT_TRACK_RAIDS = 1,
	)

	influence_sets = list(
		"Set 1" = list(
			STATS_MASTERWORKS_FORGED = list("name" = "Masterworks forged:", "points" = 4.75, "capacity" = 70),
		),
		"Set 2" = list(
			STATS_ROCKS_MINED = list("name" = "Rocks mined:", "points" = 0.25, "capacity" = 90),
		),
		"Set 3" = list(
			STATS_CRAFT_SKILLS = list("name" = "Craft skills learned:", "points" = 0.7, "capacity" = 80),
		),
		"Set 4" = list(
			STATS_ALIVE_DWARVES = list("name" = "Number of dwarfs:", "points" = 4.25, "capacity" = 50),
		),
		"Set 5" = list(
			STATS_BLACKSTEEL_SMELTED = list("name" = "Blacksteel smelted:", "points" = 4.5, "capacity" = 60),
			STATS_BEARDS_SHAVED = list("name" = "Beards shaved:", "points" = -4, "capacity" = -40),
		)
	)

/datum/storyteller/eora
	name = EORA
	desc = "Eora hates death and promotes love. Raids will never naturally progress, only death will bring them."
	welcome_text = "Life shall flourish under my watchful gaze."
	color_theme = "#9966CC"

	tag_multipliers = list(
		TAG_EORA = 3,
		TAG_BOON = 1.75,
		TAG_WIDESPREAD = 1.5,
	)

	point_gains_multipliers = list(
		EVENT_TRACK_MUNDANE = 1,
		EVENT_TRACK_PERSONAL = 1.5,
		EVENT_TRACK_MODERATE = 1,
		EVENT_TRACK_INTERVENTION = 2,
		EVENT_TRACK_CHARACTER_INJECTION = 1,
		EVENT_TRACK_OMENS = 1,
		EVENT_TRACK_RAIDS = 0,
	)

	influence_sets = list(
		"Set 1" = list(
			STATS_PARENTS = list("name" = "Number of parents:", "points" = 7.5, "capacity" = 80),
			STATS_CHILD_POPULATION = list("name" = "Number of children:", "points" = 6.25, "capacity" = 70),
		),
		"Set 2" = list(
			STATS_MARRIAGES = list("name" = "Marriages made:", "points" = 20, "capacity" = 80),
			STATS_PACIFISTS = list("name" = "Number of pacifists:", "points" = 12.5, "capacity" = 75),
		),
		"Set 3" = list(
			STATS_HUGS_MADE = list("name" = "Hugs made:", "points" = 2.15, "capacity" = 70),
		),
		"Set 4" = list(
			STATS_HANDS_HELD = list("name" = "Hands held:", "points" = 2.15, "capacity" = 70),
		),
		"Set 5" = list(
			STATS_CLINGY_PEOPLE = list("name" = "Clingy people:", "points" = 4.5, "capacity" = 70),
			STATS_ALIVE_HARPIES = list("name" = "Number of harpies:", "points" = 8, "capacity" = 70),
		)
	)

/datum/storyteller/dendor
	name = DENDOR
	desc = "Dendor likes to send nature-themed events."
	welcome_text = "The wilds whisper your name."
	weight = 4
	always_votable = TRUE
	color_theme = "#664422"

	tag_multipliers = list(
		TAG_DENDOR = 3,
		TAG_NATURE = 1.75,
	)

	point_gains_multipliers = list(
		EVENT_TRACK_MUNDANE = 1,
		EVENT_TRACK_PERSONAL = 0.75,
		EVENT_TRACK_MODERATE = 1.25,
		EVENT_TRACK_INTERVENTION = 2,
		EVENT_TRACK_CHARACTER_INJECTION = 1,
		EVENT_TRACK_OMENS = 1,
		EVENT_TRACK_RAIDS = 1,
	)

	influence_sets = list(
		"Set 1" = list(
			STATS_TREES_CUT = list("name" = "Trees felled:", "points" = -0.35, "capacity" = -45),
			STATS_WEREVOLVES = list("name" = "Number of werevolves:", "points" = 12.5, "capacity" = 65),
		),
		"Set 2" = list(
			STATS_PLANTS_HARVESTED = list("name" = "Plants harvested:", "points" = 0.675, "capacity" = 80),
		),
		"Set 3" = list(
			STATS_FOREST_DEATHS = list("name" = "Forest deaths:", "points" = 6, "capacity" = 80),
		),
		"Set 4" = list(
			STATS_DENDOR_SACRIFICES = list("name" = "Sacrifices to Dendor:", "points" = 12.5, "capacity" = 75),
		),
		"Set 5" = list(
			STATS_ANIMALS_TAMED = list("name" = "Animals tamed:", "points" = 4.5, "capacity" = 60),
		)
	)

// INHUMEN

/datum/storyteller/zizo
	name = ZIZO
	desc = "Zizo thrives on risk and reward, favoring the daring and unpredictable."
	welcome_text = "You will kneel."
	weight = 4
	always_votable = TRUE
	follower_modifier = LOWER_INHUMEN_FOLLOWER_MODIFIER
	color_theme = "#CC4444"

	tag_multipliers = list(
		TAG_ZIZO = 3,
		TAG_MAGICAL = 1.5,
		TAG_UNEXPECTED = 1.5,
		TAG_TRICKERY = 1.25,
	)

	point_gains_multipliers = list(
		EVENT_TRACK_MUNDANE = 1,
		EVENT_TRACK_PERSONAL = 1.25,
		EVENT_TRACK_MODERATE = 1.25,
		EVENT_TRACK_INTERVENTION = 1.5,
		EVENT_TRACK_CHARACTER_INJECTION = 1,
		EVENT_TRACK_OMENS = 1.25,
		EVENT_TRACK_RAIDS = 1.25,
	)

	influence_sets = list(
		"Set 1" = list(
			STATS_ZIZO_PRAISED = list("name" = "Zizo praised:", "points" = 1.25, "capacity" = 45),
			STATS_ALIVE_DARK_ELVES = list("name" = "Number of dark elves:", "points" = 6.75, "capacity" = 60),
		),
		"Set 2" = list(
			STATS_NOBLE_DEATHS = list("name" = "Nobles killed:", "points" = 5.5, "capacity" = 80),
		),
		"Set 3" = list(
			STATS_DEADITES_WOKEN_UP = list("name" = "Deadites woken up:", "points" = 4.5, "capacity" = 85),
		),
		"Set 4" = list(
			STATS_CLERGY_DEATHS = list("name" = "Clergy killed:", "points" = 12.5, "capacity" = 70),
		),
		"Set 5" = list(
			STATS_TORTURES = list("name" = "Tortures performed:", "points" = 6.25, "capacity" = 70),
		)
	)

	cost_variance = 50  // Events will be highly variable in cost

/datum/storyteller/baotha
	name = BAOTHA
	desc = "Baotha revels in chaos, making events and reality unpredictable."
	welcome_text = "The world bends to my whims."
	weight = 4
	always_votable = TRUE
	follower_modifier = STANDARD_INHUMEN_MODIFIER
	color_theme = "#9933FF"

	tag_multipliers = list(
		TAG_BAOTHA = 3,
		TAG_INSANITY = 1.75,
		TAG_DISASTER = 1.5,
	)

	point_gains_multipliers = list(
		EVENT_TRACK_MUNDANE = 1.25,
		EVENT_TRACK_PERSONAL = 1.25,
		EVENT_TRACK_MODERATE = 1.25,
		EVENT_TRACK_INTERVENTION = 2,
		EVENT_TRACK_CHARACTER_INJECTION = 0.75,
		EVENT_TRACK_OMENS = 1.5,
		EVENT_TRACK_RAIDS = 1,
	)

	influence_sets = list(
		"Set 1" = list(
			STATS_DRUGS_SNORTED = list("name" = "Drugs snorted:", "points" = 4, "capacity" = 85),
		),
		"Set 2" = list(
			STATS_ALCOHOL_CONSUMED = list("name" = "Alcohol consumed:", "points" = 0.04, "capacity" = 90),
		),
		"Set 3" = list(
			STATS_ALCOHOLICS = list("name" = "Number of alcoholics:", "points" = 3, "capacity" = 60),
		),
		"Set 4" = list(
			STATS_JUNKIES = list("name" = "Number of junkies:", "points" = 9, "capacity" = 70),
			STATS_ALIVE_TIEFLINGS = list("name" = "Number of tieflings:", "points" = 6.25, "capacity" = 60),
		),
		"Set 5" = list(
			STATS_LUXURIOUS_FOOD_EATEN = list("name" = "Luxurious food eaten:", "points" = 0.925, "capacity" = 85),
		)
	)

	cost_variance = 30  // Makes events more erratic in timing

/datum/storyteller/graggar
	name = GRAGGAR
	desc = "Graggar encourages war and conquest, making combat the solution to all."
	welcome_text = "Victory or death!"
	weight = 4
	always_votable = TRUE
	follower_modifier = STANDARD_INHUMEN_MODIFIER
	color_theme = "#8B3A3A"

	tag_multipliers = list(
		TAG_GRAGGAR = 3,
		TAG_BATTLE = 1.75,
		TAG_BLOOD = 1.5,
		TAG_WAR = 1.25,
	)

	point_gains_multipliers = list(
		EVENT_TRACK_MUNDANE = 0.75,
		EVENT_TRACK_PERSONAL = 0.75,
		EVENT_TRACK_MODERATE = 1.25,
		EVENT_TRACK_INTERVENTION = 1.5,
		EVENT_TRACK_CHARACTER_INJECTION = 1,
		EVENT_TRACK_OMENS = 1,
		EVENT_TRACK_RAIDS = 2.25,
	)

	influence_sets = list(
		"Set 1" = list(
			STATS_HUNTED_PEOPLE = list("name" = "Number of available prey:", "points" = 10, "capacity" = 80),
			STATS_ASSASSINATIONS = list("name" = "Successful assasinations:", "points" = 25, "capacity" = 75),
		),
		"Set 2" = list(
			STATS_BLOOD_SPILT = list("name" = "Blood spilt:", "points" = 0.03, "capacity" = 90),
		),
		"Set 3" = list(
			STATS_ORGANS_EATEN = list("name" = "Organs eaten:", "points" = 4.75, "capacity" = 70),
		),
		"Set 4" = list(
			STATS_LIMBS_BITTEN = list("name" = "Limbs bitten:", "points" = 1.25, "capacity" = 70),
			STATS_ALIVE_HALF_ORCS = list("name" = "Number of half-orcs:", "points" = 8.5, "capacity" = 70),
		),
		"Set 5" = list(
			STATS_PEOPLE_GIBBED = list("name" = "People gibbed:", "points" = 4.5, "capacity" = 60),
		)
	)

	cost_variance = 10  // Less randomness, more direct

/datum/storyteller/matthios
	name = MATTHIOS
	desc = "Matthios manipulates wealth and corruption, rewarding those who make deals."
	welcome_text = "Fortune favors the cunning."
	weight = 4
	always_votable = TRUE
	follower_modifier = LOWER_INHUMEN_FOLLOWER_MODIFIER
	color_theme = "#8B4513"

	tag_multipliers = list(
		TAG_MATTHIOS = 3,
		TAG_CORRUPTION = 1.75,
		TAG_LOOT = 1.75,
		TAG_TRADE = 1.25,
	)

	point_gains_multipliers = list(
		EVENT_TRACK_MUNDANE = 1,
		EVENT_TRACK_PERSONAL = 1,
		EVENT_TRACK_MODERATE = 1.25,
		EVENT_TRACK_INTERVENTION = 1.25,
		EVENT_TRACK_CHARACTER_INJECTION = 1.5,
		EVENT_TRACK_OMENS = 1.25,
		EVENT_TRACK_RAIDS = 1,
	)

	influence_sets = list(
		"Set 1" = list(
			STATS_ITEMS_PICKPOCKETED = list("name" = "Items pickpocketed:", "points" = 5.5, "capacity" = 70),
		),
		"Set 2" = list(
			STATS_SHRINE_VALUE = list("name" = "Value offered to his idol:", "points" = 0.0725, "capacity" = 70),
		),
		"Set 3" = list(
			STATS_GREEDY_PEOPLE = list("name" = "Number of greedy people:", "points" = 8, "capacity" = 70),
			STATS_KLEPTOMANIACS = list("name" = "Number of kleptomaniacs:", "points" = 14, "capacity" = 70),
		),
		"Set 4" = list(
			STATS_DODGES = list("name" = "Dodges made:", "points" = 0.0875, "capacity" = 100),
		),
		"Set 5" = list(
			STATS_LOCKS_PICKED = list("name" = "Locks picked:", "points" = 4.5, "capacity" = 70),
			STATS_GRAVES_ROBBED = list("name" = "Graves robbed:", "points" = 6, "capacity" = 60),
		)
	)

	cost_variance = 15  // Keeps a balance between predictability and randomness
