/*
	These defines are specific to the atom/flags_1 bitmask
*/
#define ALL (~0) //For convenience.
#define NONE 0

//for convenience
#define ENABLE_BITFIELD(variable, flag) (variable |= (flag))
#define DISABLE_BITFIELD(variable, flag) (variable &= ~(flag))
#define CHECK_BITFIELD(variable, flag) (variable & (flag))
#define TOGGLE_BITFIELD(variable, flag) (variable ^= (flag))


//check if all bitflags specified are present
#define CHECK_MULTIPLE_BITFIELDS(flagvar, flags) (((flagvar) & (flags)) == (flags))

GLOBAL_LIST_INIT(bitflags, list(1, 2, 4, 8, 16, 32, 64, 128, 256, 512, 1024, 2048, 4096, 8192, 16384, 32768))

// for /datum/var/datum_flags
#define DF_USE_TAG				(1<<0)
#define DF_VAR_EDITED			(1<<1)
#define PROCESSING_DEFAULT		(1<<2)
#define PROCESSING_FAST			(1<<3)
#define PROCESSING_WEATHER		(1<<4)
#define PROCESSING_PROJECTILE	(1<<5)
#define PROCESSING_TODCHANGE	(1<<6)
#define PROCESSING_INCONE		(1<<7)
#define PROCESSING_WATERLEVEL	(1<<8)
#define PROCESSING_LIGHTING		(1<<9)
#define PROCESSING_LOBBY	(1<<10)
#define PROCESSING_DAMOVERLAYS	(1<<11)

//FLAGS BITMASK

/// This flag is what recursive_hear_check() uses to determine wether to add an item to the hearer list or not.
#define HEAR_1						(1<<3)
/// Projectiels will check ricochet on things impacted that have this.
#define CHECK_RICOCHET_1			(1<<4)
/// conducts electricity (metal etc.)
#define CONDUCT_1					(1<<5)
/// For machines and structures that should not break into parts, eg, holodeck stuff
#define NODECONSTRUCT_1				(1<<7)
/// item has priority to check when entering or leaving
#define ON_BORDER_1					(1<<8)
/// Prevent clicking things below it on the same turf eg. doors/ fulltile windows
#define PREVENT_CLICK_UNDER_1		(1<<9)
#define HOLOGRAM_1					(1<<10)
/// TESLA_IGNORE grants immunity from being targeted by tesla-style electricity
#define TESLA_IGNORE_1				(1<<11)
///Whether /atom/Initialize() has already run for the object
#define INITIALIZED_1				(1<<12)
/// was this spawned by an admin? used for stat tracking stuff.
#define ADMIN_SPAWNED_1			    (1<<13)
/// should not get harmed if this gets caught by an explosion?
#define PREVENT_CONTENTS_EXPLOSION_1 (1<<14)
/// Is the thing currently spinning?
#define IS_SPINNING_1 (1<<15)
/// Is this atom on top of another atom, and as such has click priority?
#define IS_ONTOP_1 (1<<16)
/// Are we in the overlay queue
#define OVERLAY_QUEUED_1 (1<<17)

/// If a turf can be made dirty at roundstart. This is also used in areas.
#define CAN_BE_DIRTY_1				(1<<2)
/// If blood cultists can draw runes or build structures on this turf
#define CULT_PERMITTED_1			(1<<3)
/// Blocks lava rivers being generated on the turf
#define NO_LAVA_GEN_1				(1<<6)
/// Blocks ruins spawning on the turf
#define NO_RUINS_1					(1<<10)
/// If a turf can be damaged when attacked by items
#define CAN_BE_ATTACKED_1			(1<<11)

/*
	These defines are used specifically with the atom/pass_flags bitmask
	the atom/checkpass() proc uses them (tables will call movable atom checkpass(PASSTABLE) for example)
*/
//flags for pass_flags
/// Allows you to pass over tables.
#define PASSTABLE (1<<0)
/// Allows you to pass over glass(this generally includes anything see-through that's glass-adjacent, ie. windows, windoors, airlocks with glass, etc.)
#define PASSGLASS (1<<1)
/// Allows you to pass over grilles.
#define PASSGRILLE (1<<2)
/// Allows you to pass over blob tiles.
#define PASSBLOB (1<<3)
/// Allows you to pass over mobs.
#define PASSMOB (1<<4)
/// Allows you to pass over closed turfs, ie. walls.
#define PASSCLOSEDTURF (1<<5)
/// Let thrown things past us. **ONLY MEANINGFUL ON pass_flags_self!**
#define LETPASSTHROW (1<<6)
/// Allows you to pass over structures, ie. racks, tables(if you don't already have PASSTABLE), etc.
#define PASSSTRUCTURE (1<<7)
/// Allows you to pass over doors.
#define PASSDOORS (1<<8)
/// Allows you to pass over dense items.
#define PASSITEM (1<<9)
/// Do not intercept click attempts during Adjacent() checks. See [turf/proc/ClickCross]. **ONLY MEANINGFUL ON pass_flags_self!**
#define LETPASSCLICKS (1<<10)
/// Allows you to pass over windows and window-adjacent stuff, like windows and windoors. Does not include doors with glass in them.
#define PASSWINDOW (1<<11)

//Movement Types
/// Regular ground based movment
#define GROUND (1<<0)
/// Flying, typically with wings
#define FLYING (1<<1)
/// Not used but if we had vents it would use this
#define VENTCRAWLING (1<<2)
/// Like flying but for zero G where you lack control
#define FLOATING (1<<3)
/// When moving, will Cross()/Uncross() everything, but won't stop or Bump() anything.
#define PHASING (1<<4)

//Fire and Acid stuff, for resistance_flags
#define LAVA_PROOF		(1<<0)
/// 100% immune to fire damage (but not necessarily to lava or heat)
#define FIRE_PROOF		(1<<1)
#define FLAMMABLE		(1<<2)
#define ON_FIRE			(1<<3)
/// acid can't even appear on it, let alone melt it.
#define UNACIDABLE		(1<<4)
/// acid stuck on it doesn't melt it.
#define ACID_PROOF		(1<<5)
/// doesn't take damage
#define INDESTRUCTIBLE	(1<<6)
/// can't be frozen
#define FREEZE_PROOF	(1<<7)
/// can't be moved by explosions, this one is excluded from everything proof
#define EXPLOSION_MOVE_PROOF (1<<8)

#define EVERYTHING_PROOF (LAVA_PROOF | FIRE_PROOF | UNACIDABLE | ACID_PROOF | INDESTRUCTIBLE | FREEZE_PROOF)

//EMP protection
#define EMP_PROTECT_SELF (1<<0)
#define EMP_PROTECT_CONTENTS (1<<1)
#define EMP_PROTECT_WIRES (1<<2)

//Mob mobility var flags
/// can move
#define MOBILITY_MOVE			(1<<0)
/// can stand
#define MOBILITY_STAND			(1<<1)
/// can pickup items
#define MOBILITY_PICKUP			(1<<2)
/// can hold and use items
#define MOBILITY_USE			(1<<3)
/// can use interfaces like machinery
#define MOBILITY_UI				(1<<4)
/// can use storage item
#define MOBILITY_STORAGE		(1<<5)
/// can pull things
#define MOBILITY_PULL			(1<<6)

#define MOBILITY_FLAGS_DEFAULT (MOBILITY_MOVE | MOBILITY_STAND | MOBILITY_PICKUP | MOBILITY_USE | MOBILITY_UI | MOBILITY_STORAGE | MOBILITY_PULL)

//alternate appearance flags
#define AA_TARGET_SEE_APPEARANCE (1<<0)
#define AA_MATCH_TARGET_OVERLAYS (1<<1)

/// Checks the visibility between two other objects.
#define CAN_THEY_SEE(target, source) ((source in viewers(7, target)) || in_range(target, source))

