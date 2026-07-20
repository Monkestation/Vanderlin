//Vehicle control flags

#define VEHICLE_CONTROL_PERMISSION 1
#define VEHICLE_CONTROL_DRIVE 2
#define VEHICLE_CONTROL_KIDNAPPED 4 //Can't leave vehicle voluntarily, has to resist.

//Car trait flags
#define CAN_KIDNAP 1

//Ridden vehicle flags

/// Does our vehicle require arms to operate? Also used for piggybacking on humans to reserve arms on the rider
#define RIDER_NEEDS_ARMS   (1<<0)
// As above but only used for riding cyborgs, and only reserves 1 arm instead of 2
#define RIDER_NEEDS_ARM (1<<1)
/// Do we need legs to ride this (checks against TRAIT_FLOORED)
#define RIDER_NEEDS_LEGS   (1<<2)
/// If the rider is disabled or loses their needed limbs, do they fall off?
#define UNBUCKLE_DISABLED_RIDER (1<<3)
// For fireman carries, the carrying human needs an arm
#define CARRIER_NEEDS_ARM (1<<4)
// This rider must be our friend
#define JUST_FRIEND_RIDERS (1<<5)

///Flags relating to our AI controller when ridden
//do we halt planning while ridden?
#define RIDING_PAUSE_AI_PLANNING (1<<0)
//do we halt movement while ridden?
#define RIDING_PAUSE_AI_MOVEMENT (1<<1)
