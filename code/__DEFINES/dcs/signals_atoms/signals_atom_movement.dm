///called on /living when someone starts pulling (atom/movable/pulled, state, force)
#define COMSIG_LIVING_START_PULL "living_start_pull"
///signal sent out by an atom when it checks if it can be pulled, for additional checks
#define COMSIG_ATOM_CAN_BE_PULLED "movable_can_be_pulled"
	#define COMSIG_ATOM_CANT_PULL (1 << 0)
///signal sent out by an atom when it is no longer being pulled by something else : (atom/puller)
#define COMSIG_ATOM_NO_LONGER_PULLED "movable_no_longer_pulled"
///signal sent out by an atom when it is no longer pulling something : (atom/pulling)
#define COMSIG_ATOM_NO_LONGER_PULLING "movable_no_longer_pulling"
