
///from base of area/Entered(): (atom/movable/arrived, area/old_area)
#define COMSIG_AREA_ENTERED "area_entered"
///from base of area/Exited(): (atom/movable/gone, direction)
#define COMSIG_AREA_EXITED "area_exited"
///from base of area/Entered(): (area/new_area). Sent to "area-sensitive" movables, see __DEFINES/traits.dm for info.
#define COMSIG_ENTER_AREA "enter_area"
///from base of area/Exited(): (area). Sent to "area-sensitive" movables, see __DEFINES/traits.dm for info.
#define COMSIG_EXIT_AREA "exit_area"
