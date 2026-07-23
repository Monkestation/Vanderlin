/// Check if a Z level is the lowest in the Z stack or has no multiZ connections
#define LOWEST_Z_IN_STACK(z) (SSmapping.multiz_levels?[z] ? !SSmapping.multiz_levels[z][Z_LEVEL_DOWN] : TRUE)
