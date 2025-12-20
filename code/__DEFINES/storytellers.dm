/// Could be bitflags, but that would require a good amount of translations, which eh, either way works for me
/// When the event is combat oriented (spawning monsters, inherently hostile antags)

#define TAG_ASTRATA "Astrata"
#define TAG_NOC "Noc"
#define TAG_RAVOX "Ravox"
#define TAG_ABYSSOR "Abyssor"
#define TAG_XYLIX "Xylix"
#define TAG_NECRA "Necra"
#define TAG_PESTRA "Pestra"
#define TAG_MALUM "Malum"
#define TAG_EORA "Eora"
#define TAG_DENDOR "Dendor"
#define TAG_ZIZO "Zizo"
#define TAG_BAOTHA "Baotha"
#define TAG_GRAGGAR "Graggar"
#define TAG_MATTHIOS "Matthios"

/// Base tag for god-related logic and identification
#define TAG_GOD "God"

/// Tag used for blessings granted by Eora
#define TAG_BOON "Boon"

/// Tag reserved for curse mechanics (unused by gods)
#define TAG_CURSE "Curse"

/// Tag associated with hauntings, used by Noc and Necra
#define TAG_HAUNTED "Haunted"

/// Tag reserved for combat logic (unused by gods)
#define TAG_COMBAT "Combat"

/// Tag used for raid events, associated with Ravox
#define TAG_RAID "Raid"

/// Tag representing trade interactions, used by Abyssor and Matthios
#define TAG_TRADE "Trade"

/// Tag denoting widespread effects, utilized by Eora
#define TAG_WIDESPREAD "Widespread"

/// Tag reserved for villain roles or actions (unused by gods)
#define TAG_VILLAIN "Villain"

/// Tag representing medical influences, tied to Pestra
#define TAG_MEDICAL "Medical"

/// Tag for alchemy-related actions or systems, belonging to Pestra
#define TAG_ALCHEMY "Alchemy"

/// Tag for nature-related events, tied to Pestra and Dendor
#define TAG_NATURE "Nature"

/// Tag representing work-related actions or influence, used by Malum
#define TAG_WORK "Work"

/// Tag for water-related actions or effects, used by Abyssor
#define TAG_WATER "Water"

/// Tag representing magical influence or events, used by Noc and Zizo
#define TAG_MAGICAL "Magical"

/// Tag denoting battle-related effects, associated with Graggar
#define TAG_BATTLE "Battle"

/// Tag symbolizing blood-related actions, belonging to Graggar
#define TAG_BLOOD "Blood"

/// Tag representing war-like influence, tied to Graggar
#define TAG_WAR "War"

/// Tag for gambling-related systems or events, used by Xylix
#define TAG_GAMBLE "Gamble"

/// Tag symbolizing trickery, mischief, or deception, belonging to Zizo and Xylix
#define TAG_TRICKERY "Trickery"

/// Tag representing unexpected outcomes or randomness, tied to Zizo and Xylix
#define TAG_UNEXPECTED "Unexpected"

/// Tag representing insanity-related mechanics, used by Baotha
#define TAG_INSANITY "Insanity"

/// Tag for magic-related influence or systems, belonging to Baotha
#define TAG_MAGIC "Magic"

/// Tag denoting disaster-related events or effects, tied to Baotha
#define TAG_DISASTER "Disaster"

/// Tag representing corruption, used by Matthios
#define TAG_CORRUPTION "Corruption"

/// Tag for loot-related events, effects, or systems, used by Matthios
#define TAG_LOOT "Loot"

#define EVENT_TRACK_MUNDANE "Mundane"
#define EVENT_TRACK_PERSONAL "Personal"
#define EVENT_TRACK_MODERATE "Moderate"
#define EVENT_TRACK_INTERVENTION "God Intervention"
#define EVENT_TRACK_CHARACTER_INJECTION "Character Injection"
#define EVENT_TRACK_OMENS "Omen"
#define EVENT_TRACK_RAIDS "Raids"

#define ALL_EVENTS "All"
#define UNCATEGORIZED_EVENTS "Uncategorized"

#define STORYTELLER_WAIT_TIME 5 SECONDS

#define EVENT_POINT_GAINED_PER_SECOND 0.09

#define TRACK_FAIL_POINT_PENALTY_MULTIPLIER 0.8

#define GAMEMODE_PANEL_MAIN "Main"
#define GAMEMODE_PANEL_VARIABLES "Variables"

#define MUNDANE_POINT_THRESHOLD 20
#define MODERATE_POINT_THRESHOLD 35
#define MAJOR_POINT_THRESHOLD 70
#define ROLESET_POINT_THRESHOLD 80
#define OBJECTIVES_POINT_THRESHOLD 80

#define MUNDANE_MIN_POP 5
#define MODERATE_MIN_POP 8
#define MAJOR_MIN_POP 20
#define CHARACTER_INJECTION_MIN_POP 0
#define OBJECTIVES_MIN_POP 20

/// Defines for how much pop do we need to stop applying a pop scalling penalty to event frequency.
#define MUNDANE_POP_SCALE_THRESHOLD 20
#define MODERATE_POP_SCALE_THRESHOLD 30
#define MAJOR_POP_SCALE_THRESHOLD 40
#define ROLESET_POP_SCALE_THRESHOLD 45
#define OBJECTIVES_POP_SCALE_THRESHOLD 45
#define RAID_POP_SCALE_THRESHOLD 55

/// The maximum penalty coming from pop scalling, when we're at the most minimum point, easing into 0 as we reach the SCALE_THRESHOLD. This is treated as a percentage.
#define MUNDANE_POP_SCALE_PENALTY 35
#define MODERATE_POP_SCALE_PENALTY 35
#define MAJOR_POP_SCALE_PENALTY 35
#define ROLESET_POP_SCALE_PENALTY 35
#define OBJECTIVES_POP_SCALE_PENALTY 35
#define RAID_POP_SCALE_PENALTY 55

#define STORYTELLER_VOTE "storyteller"

#define EVENT_TRACKS list(EVENT_TRACK_MUNDANE, EVENT_TRACK_PERSONAL, EVENT_TRACK_MODERATE, EVENT_TRACK_INTERVENTION, EVENT_TRACK_CHARACTER_INJECTION, EVENT_TRACK_OMENS, EVENT_TRACK_RAIDS)
#define EVENT_PANEL_TRACKS list(EVENT_TRACK_MUNDANE, EVENT_TRACK_PERSONAL, EVENT_TRACK_MODERATE, EVENT_TRACK_INTERVENTION, EVENT_TRACK_CHARACTER_INJECTION, EVENT_TRACK_OMENS, EVENT_TRACK_RAIDS, UNCATEGORIZED_EVENTS, ALL_EVENTS)

/// Defines for the antag cap to prevent midround injections.
#define ANTAG_CAP_FLAT 3
#define ANTAG_CAP_DENOMINATOR 30

///Below are defines for roundstart point pool. The GAIN ones are multiplied by ready population
#define ROUNDSTART_MUNDANE_BASE 10
#define ROUNDSTART_MUNDANE_GAIN 0.5

#define ROUNDSTART_PERSONAL_BASE 10
#define ROUNDSTART_PERSONAL_GAIN 0.8

#define ROUNDSTART_MODERATE_BASE 15
#define ROUNDSTART_MODERATE_GAIN 1.2

#define ROUNDSTART_MAJOR_BASE 35
#define ROUNDSTART_MAJOR_GAIN 1.5

#define ROUNDSTART_ROLESET_BASE 40
#define ROUNDSTART_ROLESET_GAIN 2

#define ROUNDSTART_OBJECTIVES_BASE 40
#define ROUNDSTART_OBJECTIVES_GAIN 2

#define SHARED_HIGH_THREAT	"high threat event"
#define SHARED_MINOR_THREAT "minor event"

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

// Divine pantheon
#define ASTRATA "Astrata"
#define NOC "Noc"
#define RAVOX "Ravox"
#define ABYSSOR "Abyssor"
#define XYLIX "Xylix"
#define NECRA "Necra"
#define PESTRA "Pestra"
#define MALUM "Malum"
#define EORA "Eora"
#define DENDOR "Dendor"

// Inhumen pantheon
#define ZIZO "Zizo"
#define BAOTHA "Baotha"
#define GRAGGAR "Graggar"
#define MATTHIOS "Matthios"
