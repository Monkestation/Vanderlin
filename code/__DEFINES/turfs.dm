#define CHANGETURF_DEFER_CHANGE (1 << 0)
/// This flag prevents changeturf from gathering air from nearby turfs to fill the new turf with an approximation of local air
#define CHANGETURF_IGNORE_AIR (1 << 1)
#define CHANGETURF_FORCEOP (1 << 2)
/// A flag for PlaceOnTop to just instance the new turf instead of calling ChangeTurf. Used for uninitialized turfs NOTHING ELSE
#define CHANGETURF_SKIP (1 << 3)
/// Inherit air from previous turf. Implies CHANGETURF_IGNORE_AIR
#define CHANGETURF_INHERIT_AIR (1 << 4)
/// Immediately recalc adjacent atmos turfs instead of queuing.
#define CHANGETURF_RECALC_ADJACENT (1 << 5)

#define IS_OPAQUE_TURF(turf) (turf.directional_opacity == ALL_CARDINALS)

//supposedly the fastest way to do this according to https://gist.github.com/Giacom/be635398926bb463b42a
///Returns a list of turf in a square
#define RANGE_TURFS(RADIUS, CENTER) \
block( \
	locate(max(CENTER.x-(RADIUS),1),          max(CENTER.y-(RADIUS),1),          CENTER.z), \
	locate(min(CENTER.x+(RADIUS),world.maxx), min(CENTER.y+(RADIUS),world.maxy), CENTER.z) \
)

#define Z_TURFS(ZLEVEL) block(locate(1,1,ZLEVEL), locate(world.maxx, world.maxy, ZLEVEL))

///Returns all currently loaded turfs
#define ALL_TURFS(...) block(locate(1, 1, 1), locate(world.maxx, world.maxy, world.maxz))

/// If a turf is an unused reservation turf awaiting assignment
#define UNUSED_RESERVATION_TURF (1 << 0)
/// If a turf is a reserved turf
#define RESERVATION_TURF (1 << 1)
/// Can't be jaunted through
#define NO_JAUNT (1 << 2)
/// Fluid effects can't spawn in this turf
#define TURF_NO_LIQUID_SPREAD (1<<3)
/// Turf is currently in the weathered_turfs list and should not be readded to avoid duplicates
#define TURF_BEING_WEATHERED (1<<4)
/// Turf is currently queued in GLOB.SUNLIGHT_QUEUE_CORNER and should not be re-queued to avoid duplicates
#define TURF_SUNLIGHT_QUEUED (1<<5)

//water_height defines
#define WATER_HEIGHT_ANKLE 1
#define WATER_HEIGHT_SHALLOW 2
#define WATER_HEIGHT_DEEP 3
#define WATER_HEIGHT_FULL 4

#define WATER_VOLUME_DRY 0
#define WATER_VOLUME_NORMAL 1
#define WATER_VOLUME_INFINITE 2

#define MINIMUM_WATER_VOLUME 10

/// Makes the set turf transparent
#define ADD_TURF_TRANSPARENCY(modturf, source) \
	if(!HAS_TRAIT(modturf, TURF_Z_TRANSPARENT_TRAIT)) { modturf.AddElement(/datum/element/turf_z_transparency) }; \
	ADD_TRAIT(modturf, TURF_Z_TRANSPARENT_TRAIT, (source))

/// Removes the transparency from the set turf
#define REMOVE_TURF_TRANSPARENCY(modturf, source) \
	REMOVE_TRAIT(modturf, TURF_Z_TRANSPARENT_TRAIT, (source)); \
	if(!HAS_TRAIT(modturf, TURF_Z_TRANSPARENT_TRAIT)) { modturf.RemoveElement(/datum/element/turf_z_transparency) }
