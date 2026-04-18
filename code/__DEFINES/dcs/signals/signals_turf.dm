#define COMSIG_MOVABLE_TURF_ENTERED "movable_turf_entered"
#define COMSIG_MOVABLE_TURF_EXITED "movable_turf_exited"

#define COMSIG_TURF_ENTER "turf_enter"
	#define COMPONENT_TURF_ALLOW_MOVEMENT (1<<0)
	#define COMPONENT_TURF_DENY_MOVEMENT  (1<<1)
#define COMSIG_TURF_ENTERED "turf_entered"

///from /datum/element/footstep/prepare_step(): (list/steps)
#define COMSIG_TURF_PREPARE_STEP_SOUND "turf_prepare_step_sound"
	//stops element/footstep/proc/prepare_step() from returning null if the turf itself has no sound
	#define FOOTSTEP_OVERRIDEN (1<<0)

///Called when turf no longer blocks light from passing through
#define COMSIG_TURF_NO_LONGER_BLOCK_LIGHT "turf_no_longer_block_light"
