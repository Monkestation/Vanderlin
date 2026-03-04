
// Define set that decides how an atom will be scanned for astar things
/// If set, we make the assumption that CanAStarPass() will NEVER return FALSE unless density is true
#define CANASTARPASS_DENSITY 0
/// If this is set, we bypass density checks and always call the proc
#define CANASTARPASS_ALWAYS_PROC 1

/// Don't remove diagonals
#define DIAGONAL_DO_NOTHING NONE
/// Removal all diagaonals
#define DIAGONAL_REMOVE_ALL 1
/// Remove diagonals on edges
#define DIAGONAL_REMOVE_CLUNKY 2

/**
 * A helper macro to see if it's possible to step from the first turf into the second one, minding things like door access and directional windows.
 * Note that this can only be used inside the [datum/pathfind][pathfind datum] since it uses variables from said datum.
 * If you really want to optimize things, optimize this, cuz this gets called a lot.
 */
#define CAN_STEP(cur_turf, next, pass_info, avoid) (next && (next != avoid) && !cur_turf.LinkBlockedWithAccess(next, pass_info))
/// Check if we are close enough to be considered done
/// Only relevant for a point on the same Z level
#define ASTAR_CLOSE_ENOUGH_TO_END(end, checking_turf) (end == checking_turf || (mintargetdist && (get_dist(checking_turf, end) <= mintargetdist)))
