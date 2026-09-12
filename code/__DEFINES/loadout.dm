// Bitflags for loadout item restrictions/properties
#define LOADOUT_FLAG_NONE 0
#define LOADOUT_FLAG_NO_RENT (1<<0) // Cannot be rented for single rounds, must be owned permanently
#define LOADOUT_FLAG_NO_EQUIP (1<<1) // Cannot be manually equipped (granted automatically on spawn, cosmetic/species grants)
#define LOADOUT_FLAG_PATREON_LOCKED (1<<2) // Requires active patreon/donator status to use
#define LOADOUT_FLAG_ACHIEVEMENT_LOCKED (1<<3) // requires required_award to be satisfied (replaces checking required_award != null implicitly)
#define LOADOUT_FLAG_NO_DONATOR_FREE (1<<4)
#define LOADOUT_FLAG_GIVEAWAY_ONLY (1<<5)

#define TICKET_TYPE_LOADOUT "loadout"
#define TICKET_TYPE_SPECIAL "special"
#define TICKET_TYPE_JOB_BOOST "job_boost"
#define TICKET_TYPE_UNKNOWN "unknown"
#define TICKET_TYPE_TRIUMPH "triumph"

// Seconds the *sender* must wait before a cancel is processed
// (prevents accepting+cancelling race that would dupe tickets)
#define TICKET_TRADE_CANCEL_LOCK 5
#define TRIUMPH_TICKET_MIN_CONVERT 10
