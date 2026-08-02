// ~fov component
///from base of datum/component/field_of_vision/proc/hide_fov()
#define COMSIG_FOV_HIDE "fov_hide"
///from base of datum/component/field_of_vision/proc/show_fovv()
#define COMSIG_FOV_SHOW "fov_show"
///from base of mob/visible_atoms(): (list/visible_atoms)
#define COMSIG_MOB_FOV_VIEW "mob_visible_atoms"
	#define COMPONENT_NO_EXAMINATE (1<<0) //cancels examinate completely
	#define COMPONENT_EXAMINATE_BLIND (1<<1) //outputs the "something is there but you can't see it" message.
///from base of get_actual_viewers(): (atom/center, depth, viewers_list)
#define COMSIG_MOB_FOV_VIEWER "mob_is_viewer"
///from base of atom/visible_message(): (atom/A, msg, range, ignored_mobs)
#define COMSIG_MOB_VISIBLE_MESSAGE "mob_get_visible_message"
	#define COMPONENT_NO_VISIBLE_MESSAGE (1<<0) //cancels visible message completely
	#define COMPONENT_VISIBLE_MESSAGE_BLIND (1<<1) //outputs blind message instead

///from base of client/change_view(): (client, old_view, view)
#define COMSIG_MOB_CLIENT_CHANGE_VIEW "mob_client_change_view"
///from base of mob/reset_perspective(): (atom/target)
#define COMSIG_MOB_RESET_PERSPECTIVE "mob_reset_perspective"
