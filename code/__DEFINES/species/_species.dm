#define SPEC_ID_HUMAN_SPACE "space_human"
#define SPEC_ID_HUMEN "human"
#define SPEC_ID_DWARF "dwarf"
#define SPEC_ID_DWARF_SUBTERRAN "dwarf_subterran"
#define SPEC_ID_AASIMAR "aasimar"
#define SPEC_ID_ELF "elf"
#define SPEC_ID_HALF_ELF "halfelf"
#define SPEC_ID_DROW "drow"
#define SPEC_ID_HALF_DROW "halfdrow"
#define SPEC_ID_TIEFLING "tiefling"
#define SPEC_ID_HALF_ORC "halforc"
#define SPEC_ID_RAKSHARI "rakshari"
#define SPEC_ID_KOBOLD "kobold"
#define SPEC_ID_KOBOLD_FORMIKRAG "kobold_formikrag"
#define SPEC_ID_HOLLOWKIN "hollowkin"
#define SPEC_ID_HARPY "harpy"
#define SPEC_ID_TRITON "triton"
#define SPEC_ID_MEDICATOR "medicator"
#define SPEC_ID_HALFLING "halfling"
#define SPEC_ID_AUTOMATON "automaton"

#define SPEC_ID_ORC	"orc"
#define SPEC_ID_GOBLIN	"goblin"
#define SPEC_ID_ROUSMAN	"rousman"
#define SPEC_ID_ZIZOMBIE "zizombie"

/// List of all species
#define ALL_RACES_LIST list(\
	SPEC_ID_HUMEN,\
	SPEC_ID_DWARF,\
	SPEC_ID_DWARF_SUBTERRAN,\
	SPEC_ID_AASIMAR,\
	SPEC_ID_ELF,\
	SPEC_ID_HALF_ELF,\
	SPEC_ID_DROW,\
	SPEC_ID_HALF_DROW,\
	SPEC_ID_TIEFLING,\
	SPEC_ID_HARPY,\
	SPEC_ID_RAKSHARI,\
	SPEC_ID_TRITON,\
	SPEC_ID_MEDICATOR,\
	SPEC_ID_KOBOLD,\
	SPEC_ID_KOBOLD_FORMIKRAG,\
	SPEC_ID_HOLLOWKIN,\
	SPEC_ID_HALF_ORC,\
	SPEC_ID_ORC,\
	SPEC_ID_GOBLIN,\
	SPEC_ID_ROUSMAN,\
	SPEC_ID_ZIZOMBIE,\
	SPEC_ID_HUMAN_SPACE,\
	SPEC_ID_HALFLING,\
	SPEC_ID_AUTOMATON, \
)

/// Species where females get underwear, no underwear for kobold, rakshari, medicator and triton, dwarves handled seperately
#define RACES_UNDERWEAR_FEMALE list(\
	SPEC_ID_HUMEN,\
	SPEC_ID_ELF,\
	SPEC_ID_HALF_ELF,\
	SPEC_ID_DROW,\
	SPEC_ID_HALF_DROW,\
	SPEC_ID_HOLLOWKIN,\
	SPEC_ID_HARPY,\
	SPEC_ID_TIEFLING,\
	SPEC_ID_AASIMAR,\
	SPEC_ID_HALF_ORC,\
	SPEC_ID_ORC,\
	SPEC_ID_ZIZOMBIE,\
	SPEC_ID_HUMAN_SPACE,\
)

/// Species where males get underwear, identical to above, elves handled seperately
#define RACES_UNDERWEAR_MALE list(\
	SPEC_ID_HUMEN,\
	SPEC_ID_HOLLOWKIN,\
	SPEC_ID_HARPY,\
	SPEC_ID_TIEFLING,\
	SPEC_ID_AASIMAR,\
	SPEC_ID_HALF_ORC,\
	SPEC_ID_HALF_ELF,\
	SPEC_ID_HALF_DROW,\
	SPEC_ID_ORC,\
	SPEC_ID_ZIZOMBIE,\
	SPEC_ID_HUMAN_SPACE,\
)

// ============ USING NAME
/// All playable species from character selection menu.
#define RACES_PLAYER_ALL list(\
	SPEC_ID_HUMEN,\
	SPEC_ID_DWARF,\
	SPEC_ID_DWARF_SUBTERRAN,\
	SPEC_ID_AASIMAR,\
	SPEC_ID_ELF,\
	SPEC_ID_HALF_ELF,\
	SPEC_ID_HALFLING,\
	SPEC_ID_DROW,\
	SPEC_ID_HALF_DROW,\
	SPEC_ID_TIEFLING,\
	SPEC_ID_HARPY,\
	SPEC_ID_RAKSHARI,\
	SPEC_ID_TRITON,\
	SPEC_ID_MEDICATOR,\
	SPEC_ID_KOBOLD,\
	SPEC_ID_KOBOLD_FORMIKRAG,\
	SPEC_ID_HOLLOWKIN,\
	SPEC_ID_HALF_ORC,\
)

/// Species not considered discriminated against in Vanderlin. Used for nobility, etc.
#define RACES_PLAYER_NONDISCRIMINATED list(\
	SPEC_ID_HUMEN,\
	SPEC_ID_DWARF,\
	SPEC_ID_AASIMAR,\
	SPEC_ID_ELF,\
	SPEC_ID_HALF_ELF,\
	SPEC_ID_HALFLING,\
)

/// Species who are nonheretical to the church. Excluded species typically have an inhumen god associated, like Zizo. Used for church/faith roles.
#define RACES_PLAYER_NONHERETICAL list(\
	SPEC_ID_HUMEN,\
	SPEC_ID_DWARF,\
	SPEC_ID_AASIMAR,\
	SPEC_ID_ELF,\
	SPEC_ID_HALF_ELF,\
	SPEC_ID_HALFLING,\
	SPEC_ID_HARPY,\
	SPEC_ID_TRITON,\
	SPEC_ID_MEDICATOR,\
)

/// Species who are non-exotic to Vanderlin. These are species from foreign lands with no local pull or uncommon species. Used in miscellaneous cases, when they would not be that role.
#define RACES_PLAYER_NONEXOTIC list(\
	SPEC_ID_HUMEN,\
	SPEC_ID_DWARF,\
	SPEC_ID_DWARF_SUBTERRAN,\
	SPEC_ID_AASIMAR,\
	SPEC_ID_ELF,\
	SPEC_ID_HALF_ELF,\
	SPEC_ID_HALFLING,\
	SPEC_ID_DROW,\
	SPEC_ID_HALF_DROW,\
	SPEC_ID_TIEFLING,\
	SPEC_ID_HARPY,\
	SPEC_ID_TRITON,\
	SPEC_ID_MEDICATOR,\
	SPEC_ID_HOLLOWKIN,\
	SPEC_ID_HALF_ORC,\
)

/// Species that lack lux. Any who have no ties to divinity anymore, whether it be their creation story or otherwise taken from them (Hollow-kin)
#define RACES_PLAYER_LUXLESS list(\
	SPEC_ID_KOBOLD,\
	SPEC_ID_KOBOLD_FORMIKRAG,\
	SPEC_ID_HOLLOWKIN,\
	SPEC_ID_RAKSHARI,\
	SPEC_ID_HUMAN_SPACE,\
	SPEC_ID_ROUSMAN,\
	SPEC_ID_GOBLIN,\
	SPEC_ID_ORC,\
)

/// Species who are affiliated with Grenzelhoft or Psydon specifically.
#define RACES_PLAYER_GRENZ list(\
	SPEC_ID_HUMEN,\
	SPEC_ID_DWARF,\
	SPEC_ID_AASIMAR,\
)

/// Species who are affiliated with Zaladin
#define RACES_PLAYER_ZALADIN list(\
	SPEC_ID_HUMEN,\
	SPEC_ID_RAKSHARI,\
	SPEC_ID_ELF,\
	SPEC_ID_HALF_ELF,\
	SPEC_ID_DWARF,\
)

/// Elves and Half-Elves
#define RACES_PLAYER_ELF list(\
	SPEC_ID_ELF,\
	SPEC_ID_HALF_ELF,\
)

/// Dark elves, half-drow
#define RACES_PLAYER_DROW list(\
	SPEC_ID_DROW,\
	SPEC_ID_HALF_DROW,\
)

/// Elves, Half-Elves, Half-Drow, Dark Elves
#define RACES_PLAYER_ELF_ALL list(\
	SPEC_ID_ELF,\
	SPEC_ID_HALF_ELF,\
	SPEC_ID_DROW,\
	SPEC_ID_HALF_DROW,\
)

/// Guard Species - No Orcs or Dark Elf
#define RACES_PLAYER_GUARD list(\
	SPEC_ID_HUMEN,\
	SPEC_ID_DWARF,\
	SPEC_ID_AASIMAR,\
	SPEC_ID_ELF,\
	SPEC_ID_HALF_ELF,\
	SPEC_ID_HALFLING,\
	SPEC_ID_HALF_DROW,\
	SPEC_ID_TIEFLING,\
	SPEC_ID_HARPY,\
	SPEC_ID_RAKSHARI,\
	SPEC_ID_TRITON,\
	SPEC_ID_MEDICATOR,\
	SPEC_ID_HOLLOWKIN,\
)

/// Vanderlin royalty
#define RACES_PLAYER_ROYALTY list(\
	SPEC_ID_HUMEN,\
	SPEC_ID_HALF_ELF,\
	SPEC_ID_ELF,\
	SPEC_ID_DWARF,\
)

/// The butler

#define RACES_BUTLER list(\
	SPEC_ID_HUMEN,\
	SPEC_ID_ELF,\
	SPEC_ID_HALF_ELF,\
	SPEC_ID_HALFLING,\
	SPEC_ID_DWARF,\
	SPEC_ID_DROW,\
	SPEC_ID_HALF_DROW,\
	SPEC_ID_TIEFLING,\
	SPEC_ID_AASIMAR,\
	SPEC_ID_HARPY,\
	SPEC_ID_MEDICATOR,\
	SPEC_ID_TRITON,\
)

/// The tennite temple's paladins - Hallowed species excluding Harpies due to their inability to wear plate
#define RACES_TEMPLAR list(\
	SPEC_ID_HUMEN,\
	SPEC_ID_ELF,\
	SPEC_ID_HALF_ELF,\
	SPEC_ID_DWARF,\
	SPEC_ID_AASIMAR,\
	SPEC_ID_MEDICATOR,\
	SPEC_ID_TRITON,\
)

/// Foreigner Nobility Species - No Tiefling (you know why) or hollow-kin or medicators (too young to have nobles mayhaps)
#define RACES_PLAYER_FOREIGNNOBLE list(\
	SPEC_ID_HUMEN,\
	SPEC_ID_DWARF,\
	SPEC_ID_AASIMAR,\
	SPEC_ID_ELF,\
	SPEC_ID_HALF_ELF,\
	SPEC_ID_HALFLING,\
	SPEC_ID_DROW,\
	SPEC_ID_HALF_DROW,\
	SPEC_ID_HALF_ORC,\
	SPEC_ID_HARPY,\
	SPEC_ID_RAKSHARI,\
	SPEC_ID_TRITON,\
	SPEC_ID_KOBOLD,\
)

/// Nonnative species - Anything not native to Psydonia.
/// Probably only will ever contain humans pragmatically, as funny as ethereals pretending to be tieflings would be.
#define RACES_PLAYER_ALIEN list(\
	SPEC_ID_HUMAN_SPACE,\
)

/// Species who are heretical to the church.
#define RACES_PLAYER_HERETICAL_RACE list(\
	SPEC_ID_DROW,\
	SPEC_ID_HALF_DROW,\
	SPEC_ID_TIEFLING,\
	SPEC_ID_HALF_ORC,\
	SPEC_ID_KOBOLD,\
	SPEC_ID_RAKSHARI,\
	SPEC_ID_HOLLOWKIN,\
)

/// Species that use the base human body, adjusted or otherwise
/// Should include everything but dwarves and kobolds for now
#define SPECIES_BASE_BODY list(\
	SPEC_ID_HUMEN,\
	SPEC_ID_HUMAN_SPACE,\
	SPEC_ID_AASIMAR,\
	SPEC_ID_ELF,\
	SPEC_ID_HALF_ELF,\
	SPEC_ID_DROW,\
	SPEC_ID_HALF_DROW,\
	SPEC_ID_TIEFLING,\
	SPEC_ID_HARPY,\
	SPEC_ID_RAKSHARI,\
	SPEC_ID_TRITON,\
	SPEC_ID_MEDICATOR,\
	SPEC_ID_HOLLOWKIN,\
	SPEC_ID_HALF_ORC,\
	SPEC_ID_ZIZOMBIE,\
)
