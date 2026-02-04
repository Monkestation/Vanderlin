// WHEN THESE MACROS HAVE ARGUMENTS NAMED TURF, THEY MEAN IT!!!
// DO NOT TRY PASSING A MOVABLE TO THIS, IT WILL BREAK AND RUNTIME IF THE MOVABLE ISN'T ON A TURF!
// YOU HAVE BEEN WARNED!!!!!!!

/// Attempt to get the turf below the provided one according to Z traits
#define GET_TURF_BELOW(turf) (\
	(!(turf) || !length(SSmapping.multiz_levels) || !SSmapping.multiz_levels[(turf).z][Z_LEVEL_DOWN]) ? null : get_step((turf), DOWN))
/// Attempt to get the turf below and to the side according to Z traits. Should include DOWN still. Saves one extra get_step call.
#define GET_TURF_BELOW_DIAGONAL(turf, direction) (\
	(!(turf) || !length(SSmapping.multiz_levels) || !SSmapping.multiz_levels[(turf).z][Z_LEVEL_DOWN]) ? null : get_step((turf), direction))
/// Attempt to get the turf above the provided one according to Z traits
#define GET_TURF_ABOVE(turf) (\
	(!(turf) || !length(SSmapping.multiz_levels) || !SSmapping.multiz_levels[(turf).z][Z_LEVEL_UP]) ? null : get_step((turf), UP))
/// Attempt to get the turf above and to the side according to Z traits. Should include UP still.
#define GET_TURF_ABOVE_DIAGONAL(turf, direction) (\
	(!(turf) || !length(SSmapping.multiz_levels) || !SSmapping.multiz_levels[(turf).z][Z_LEVEL_UP]) ? null : get_step((turf), direction))

/// Similar to GET_TURF_ABOVE, but without unnecessary safety checks, mostly for use in weather/sunlight code.
/// Assumptions: turf is non-null, SSmapping.multiz_levels has been initialized.
#define _GET_TURF_ABOVE_UNSAFE(turf) (SSmapping.multiz_levels[(turf).z][Z_LEVEL_UP]) && get_step((turf), UP)
