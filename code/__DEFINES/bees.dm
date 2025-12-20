// Bee behavior constants
#define BEE_POLLINATION_TIME 30 SECONDS
#define BEE_RETURN_THRESHOLD 5
#define BEE_MERGE_THRESHOLD 5
#define BEE_WANDERING_RANGE 7

// Apiary constants
#define APIARY_BASE_MAX_BEES 30
#define APIARY_COMB_COST 100
#define APIARY_BEE_CREATION_COST 10
#define APIARY_QUEEN_CREATION_POLLEN 50
#define APIARY_QUEEN_CREATION_COMBS 2

// Disease constants
#define DISEASE_CHECK_CHANCE 3
#define DISEASE_BASE_INFECTION 2
#define DISEASE_NEARBY_INFECTION 10
#define DISEASE_CRITICAL_SEVERITY 100

// Swarm constants
#define SWARM_COOLDOWN 5 MINUTES
#define SWARM_THRESHOLD 80
#define SWARM_MIN_SIZE 5
#define SWARM_MAX_SIZE 10

// Bee states
#define BEE_STATE_IDLE 0
#define BEE_STATE_POLLINATING 1
#define BEE_STATE_RETURNING 2
#define BEE_STATE_MERGING 3
#define BEE_STATE_AGITATED 4

GLOBAL_LIST_INIT(bee_diseases, init_diseases())

/proc/init_diseases()
	var/list/list = list()
	for(var/datum/bee_disease/disease as anything in subtypesof(/datum/bee_disease))
		list |= disease
		list[disease] = new disease
	return list
