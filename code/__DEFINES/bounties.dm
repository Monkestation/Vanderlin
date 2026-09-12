#define BOUNTY_NO_MATCH       0 // Item wasn't what the bounty wanted
#define BOUNTY_MATCH_CONSUMED 1 // Item matched and should be qdel'd right now
#define BOUNTY_MATCH_PARTIAL  2 // Item matched partially, keep it alive but don't sell it

#define FALSE_BUT_HANDLED    -1 // Tells tram loop: "Do not sell this, but do not delete it either."
