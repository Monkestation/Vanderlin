/* smoothing_flags */
/// Smoothing system in where adjacencies are calculated and used to select a pre-baked icon_state, encoded by bitmasking.
#define SMOOTH_BITMASK	(1<<0)
/// Limits SMOOTH_BITMASK to only cardinal directions, for use with cardinal smoothing
#define SMOOTH_BITMASK_CARDINALS (1<<1)
/// Turf only, uses overlays to create edges on smoothed atoms. Incompatible with bitmask smoothing.
#define SMOOTH_EDGE		(1<<2)
/// atom will smooth with the borders of the map
#define SMOOTH_BORDER	(1<<3)
/// smooths with objects, and will thus need to scan turfs for contents.
#define SMOOTH_OBJ		(1<<4)
/// atom is currently queued to smooth.
#define SMOOTH_QUEUED	(1<<5)

#define USES_SMOOTHING (SMOOTH_BITMASK|SMOOTH_BITMASK_CARDINALS|SMOOTH_EDGE)

#define USES_BITMASK_SMOOTHING (SMOOTH_BITMASK|SMOOTH_BITMASK_CARDINALS)

DEFINE_BITFIELD(smooth, list(
	"SMOOTH_BORDER" = SMOOTH_BORDER,
	"SMOOTH_BITMASK" = SMOOTH_BITMASK,
	"SMOOTH_BITMASK_CARDINALS" = SMOOTH_BITMASK_CARDINALS,
	"SMOOTH_EDGE" = SMOOTH_EDGE,
	"SMOOTH_OBJ" = SMOOTH_OBJ,
	"SMOOTH_QUEUED" = SMOOTH_QUEUED,
))

/*smoothing macros*/

#define QUEUE_SMOOTH(thing_to_queue) if(thing_to_queue.smoothing_flags & USES_SMOOTHING) {SSicon_smooth.add_to_queue(thing_to_queue)}

#define QUEUE_SMOOTH_NEIGHBORS(thing_to_queue) for(var/atom/atom_neighbor as anything in orange(1, thing_to_queue)) {QUEUE_SMOOTH(atom_neighbor)}


/**SMOOTHING GROUPS
 * Groups of things to smooth with.
 * * Contained in the `list/smoothing_groups` variable.
 * * Matched with the `list/smoothing_list` variable to check whether smoothing is possible or not.
 */

/* /turf only */

#define S_TURF(num) (#num + ",")

#define SMOOTH_GROUP_OPEN S_TURF(0) //!turf/open
#define SMOOTH_GROUP_OPEN_FLOOR S_TURF(1) //!turf/open/floor

#define SMOOTH_GROUP_FLOOR_LIQUID S_TURF(2) //!turf/open/water, /turf/open/lava
#define SMOOTH_GROUP_FLOOR_OPEN_SPACE S_TURF(3) //!turf/open/openspace

#define SMOOTH_GROUP_FLOOR_CARPET S_TURF(4) //!turf/open/floor/carpet
#define SMOOTH_GROUP_FLOOR_DIRT S_TURF(5)
#define SMOOTH_GROUP_FLOOR_DIRT_ROAD S_TURF(6)
#define SMOOTH_GROUP_FLOOR_GRASS S_TURF(7)
#define SMOOTH_GROUP_FLOOR_SNOW S_TURF(8)
#define SMOOTH_GROUP_FLOOR_STONE S_TURF(9)
#define SMOOTH_GROUP_FLOOR_WOOD S_TURF(10)

#define SMOOTH_GROUP_CLOSED S_TURF(11) //!/turf/closed
#define SMOOTH_GROUP_CLOSED_WALL S_TURF(12) //!/turf/closed/wall

#define SMOOTH_GROUP_MINERAL_WALLS S_TURF(13) //!turf/closed/mineral, /turf/closed/mineral/turf/random, /closed/indestructible

#define SMOOTH_GROUP_WALLS_STONE S_TURF(14) //!turf/closed/wall/mineral/stone (and moss)
#define SMOOTH_GROUP_WALLS_STONE_CRAFT S_TURF(15) //!turf/closed/wall/mineral/craftstone
#define SMOOTH_GROUP_WALLS_STONE_BRICK S_TURF(16) //!turf/closed/wall/mineral/stonebrick
#define SMOOTH_GROUP_WALLS_STONE_DECO S_TURF(17) //!turf/closed/wall/mineral/decorstone (and moss)
#define SMOOTH_GROUP_WALLS_PIPE S_TURF(18) //!turf/closed/wall/mineral/pipe
#define SMOOTH_GROUP_WALLS_EREBUS S_TURF(19) //!turf/closed/wall/mineral/underbrick
#define SMOOTH_GROUP_WALLS_WOOD S_TURF(20) //!turf/closed/wall/mineral/wood

#define SMOOTH_GROUP_FLOOR_FLESH S_TURF(21)
#define SMOOTH_GROUP_MUSHROOM S_TURF(22)

#define MAX_S_TURF 22 //Always match this value with the one above it.

/* /obj included */

#define S_OBJ(num) ("-" + #num + ",")

#define SMOOTH_GROUP_WALLS S_OBJ(1) //!turf/closed/wall, /structure/door/secret

#define SMOOTH_GROUP_WINDOW_FULLTILE S_OBJ(2) //!obj/structure/window

#define SMOOTH_GROUP_DOOR S_OBJ(3) //!obj/structure/door
#define SMOOTH_GROUP_DOOR_SECRET S_OBJ(4) //!obj/structure/door/secret

#define SMOOTH_GROUP_TABLES S_OBJ(5) //!obj/structure/table
#define SMOOTH_GROUP_WOOD_TABLES S_OBJ(6) //!obj/structure/table/wood
#define SMOOTH_GROUP_FANCY_WOOD_TABLES S_OBJ(7) //!obj/structure/table/wood/fancy

/// Performs the work to set smoothing_groups and smoothing_list.
/// An inlined function used in both turf/Initialize and atom/Initialize.
#define SETUP_SMOOTHING(...) \
	if(smoothing_groups) { \
		if(PERFORM_ALL_TESTS(focus_only/sorted_smoothing_groups)) { \
			ASSERT_SORTED_SMOOTHING_GROUPS(smoothing_groups); \
		} \
		SET_SMOOTHING_GROUPS(smoothing_groups); \
	} \
\
	if(smoothing_list) { \
		if(PERFORM_ALL_TESTS(focus_only/sorted_smoothing_groups)) { \
			ASSERT_SORTED_SMOOTHING_GROUPS(smoothing_list); \
		} \
		/* S_OBJ is always negative, and we are guaranteed to be sorted. */ \
		if(smoothing_list[1] == "-") { \
			smoothing_flags |= SMOOTH_OBJ; \
		} \
		SET_SMOOTHING_GROUPS(smoothing_list); \
	}

/// Given a smoothing groups variable, will set out to the actual numbers inside it
#define UNWRAP_SMOOTHING_GROUPS(smoothing_groups, out) \
	json_decode("\[[##smoothing_groups]0\]"); \
	##out.len--;

#define ASSERT_SORTED_SMOOTHING_GROUPS(smoothing_group_variable) \
	var/list/unwrapped = UNWRAP_SMOOTHING_GROUPS(smoothing_group_variable, unwrapped); \
	assert_sorted(unwrapped, "[#smoothing_group_variable] ([type])"); \
