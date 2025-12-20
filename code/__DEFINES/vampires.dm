#define VITAE_LEVEL_STARVING 100
#define VITAE_LEVEL_HUNGRY 250
#define VITAE_LEVEL_FED 500


#define BLOOD_PREFERENCE_ALL (BLOOD_PREFERENCE_RATS | BLOOD_PREFERENCE_HOLY | BLOOD_PREFERENCE_SLEEPING | BLOOD_PREFERENCE_LIVING | BLOOD_PREFERENCE_FANCY)

#define BLOOD_PREFERENCE_DEAD (1<<0)
#define BLOOD_PREFERENCE_LIVING (1<<1)
#define BLOOD_PREFERENCE_HOLY (1<<2)
#define BLOOD_PREFERENCE_SLEEPING (1<<3)
#define BLOOD_PREFERENCE_KIN (1<<4)
#define BLOOD_PREFERENCE_FANCY (1<<5)
#define BLOOD_PREFERENCE_RATS (1<<6)
#define BLOOD_PREFERENCE_EUPHORIC (1<<7)

#define TATTOO_SILENT	"Silent Casting"

#define	TOME_CLOSED	1
#define	TOME_OPEN	2

#define RUNE_WRITE_CANNOT	0
#define RUNE_WRITE_COMPLETE	1
#define RUNE_WRITE_CONTINUE	2
#define	RUNE_CAN_ATTUNE	0
#define	RUNE_CAN_IMBUE	1
#define	RUNE_CANNOT		2
#define RUNE_STAND	1
#define	MAX_TALISMAN_PER_TOME	5

#define RITUALABORT_ERASED	"erased"
#define RITUALABORT_STAND	"too far"
#define RITUALABORT_GONE	"moved away"
#define RITUALABORT_BLOCKED	"blocked"
#define RITUALABORT_BLOOD	"channel cancel"
#define RITUALABORT_TOOLS	"moved talisman"
#define RITUALABORT_REMOVED	"victim removed"
#define RITUALABORT_CONVERT	"convert success"
#define RITUALABORT_REFUSED	"convert refused"
#define RITUALABORT_NOCHOICE	"convert nochoice"
#define RITUALABORT_SACRIFICE	"convert failure"
#define RITUALABORT_FULL	"no room"
#define RITUALABORT_CONCEAL	"conceal"
#define RITUALABORT_NEAR	"near"
#define RITUALABORT_MISSING	"missing"
#define RITUALABORT_OVERCROWDED "overcrowded"

#define BLOODCOST_TARGET_BLEEDER	"bleeder"
#define BLOODCOST_AMOUNT_BLEEDER	"bleeder_amount"
#define BLOODCOST_TARGET_GRAB	"grabbed"
#define BLOODCOST_AMOUNT_GRAB	"grabbed_amount"
#define BLOODCOST_TARGET_HANDS	"hands"
#define BLOODCOST_AMOUNT_HANDS	"hands_amount"
#define BLOODCOST_TARGET_HELD	"held"
#define BLOODCOST_AMOUNT_HELD	"held_amount"
#define BLOODCOST_LID_HELD		"held_lid"
#define BLOODCOST_TARGET_SPLATTER	"splatter"
#define BLOODCOST_AMOUNT_SPLATTER	"splatter_amount"
#define BLOODCOST_TARGET_BLOODPACK	"bloodpack"
#define BLOODCOST_AMOUNT_BLOODPACK	"bloodpack_amount"
#define BLOODCOST_HOLES_BLOODPACK	"bloodpack_noholes"
#define BLOODCOST_TARGET_CONTAINER	"container"
#define BLOODCOST_AMOUNT_CONTAINER	"container_amount"
#define BLOODCOST_LID_CONTAINER	"container_lid"
#define BLOODCOST_TARGET_USER	"user"
#define BLOODCOST_AMOUNT_USER	"user_amount"
#define BLOODCOST_TOTAL		"total"
#define BLOODCOST_RESULT	"result"
#define BLOODCOST_FAILURE	"failure"
#define BLOODCOST_TRIBUTE	"tribute"
#define BLOODCOST_USER	"user"
