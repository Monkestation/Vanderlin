// This flag disables certain checks that presume antagonist datums mean 'baddie'.
#define FLAG_FAKE_ANTAG					(1 << 0)
//The storyteller will ignore this antag datum as counting against the antag cap.
#define FLAG_ANTAG_CAP_IGNORE			(1 << 1)
//  The storyteller will count everyone on this antag's team as a singular antag instead.
#define FLAG_ANTAG_CAP_TEAM				(1 << 2)

#define IS_DEADITE(mob) (mob?.mind?.has_antag_datum(/datum/antagonist/zombie))
