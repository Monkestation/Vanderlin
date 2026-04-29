
#define FACTION_NONE		"None"
#define FACTION_NEUTRAL		"Neutral"
#define FACTION_HOSTILE		"Hostile"
#define FACTION_TOWN		"Town"
#define FACTION_FOREIGNERS  "Foreigners"
#define FACTION_MIGRANTS  	"Migrants"
#define FACTION_UNDEAD		"Undead"
#define FACTION_PLANTS		"Plants"
#define FACTION_VINES		"Vines" //Seemingly unused
#define FACTION_CABAL		"Cabal"
#define FACTION_RATS		"Rats"
#define FACTION_ORCS		"Orcs"
#define FACTION_BUMS		"Bums"
#define FACTION_MATTHIOS	"Matthios"
#define FACTION_VIKINGS     "Vikings"

#define ALL_FACTIONS list( \
	FACTION_NONE, \
	FACTION_NEUTRAL, \
	FACTION_HOSTILE, \
	FACTION_TOWN, \
	FACTION_FOREIGNERS, \
	FACTION_MIGRANTS, \
	FACTION_UNDEAD, \
	FACTION_PLANTS, \
	FACTION_VINES, \
	FACTION_CABAL, \
	FACTION_RATS, \
	FACTION_ORCS, \
	FACTION_BUMS, \
	FACTION_VIKINGS, \
	FACTION_MATTHIOS \
)

/**
 * SET_FACTION_AND_ALLIES_FROM(destination, source)
 * Sets the atom's faction and allies to match that of the provided type's.
 *
 * This is equivalent to:
 *   destination.set_faction(source.get_faction())
 *    destination.set_allies(source.allies)
 *
 * This is a macro (not a proc) to avoid proc call overhead in hot paths.
 */
#define SET_FACTION_AND_ALLIES_FROM(destination, source) \
	do { \
		(destination).set_faction((source).get_faction()); \
		(destination).set_allies(LAZYLISTDUPLICATE((source).allies)); \
	} while(FALSE)

/**
 * APPLY_FACTION_AND_ALLIES_FROM(destination, source)
 * Adds the provided type's factions and allies to the atom's current factions and allies.
 *
 * This is equivalent to:
 *   destination.add_faction(source.get_faction())
 *    destination.add_ally(source.allies)
 *
 * This is a macro (not a proc) to avoid proc call overhead in hot paths.
 */
#define APPLY_FACTION_AND_ALLIES_FROM(destination, source) \
	do { \
		(destination).add_faction((source).get_faction()); \
		(destination).add_ally(LAZYLISTDUPLICATE((source).allies)); \
	} while(FALSE)

/**
 * Compare two lists of factions, returning true if any match.
 * If exact match is passed through we only return true if both faction lists match equally.
 *
 * Macro-ified version to avoid extra proc overhead.
 */
#define FAST_FACTION_CHECK(faction_A, faction_B, allies_A, allies_B, exact_match) \
( \
	!(exact_match) ? \
		(LAZYLEN((faction_A) & (faction_B)) || LAZYLEN((allies_A) & (allies_B))) \
	: \
		((LAZYLEN((faction_A) & (faction_B)) == LAZYLEN(faction_A)) && LAZYLEN((allies_A) & (allies_B))) \
)
