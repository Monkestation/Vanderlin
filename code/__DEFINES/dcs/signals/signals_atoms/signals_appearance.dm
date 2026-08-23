///from base of [/atom/proc/update_appearance]: (updates)
#define COMSIG_ATOM_UPDATE_APPEARANCE "atom_update_appearance"
	/// If returned from [COMSIG_ATOM_UPDATE_APPEARANCE] it prevents the atom from updating its name.
	#define COMSIG_ATOM_NO_UPDATE_NAME UPDATE_NAME
	/// If returned from [COMSIG_ATOM_UPDATE_APPEARANCE] it prevents the atom from updating its desc.
	#define COMSIG_ATOM_NO_UPDATE_DESC UPDATE_DESC
	/// If returned from [COMSIG_ATOM_UPDATE_APPEARANCE] it prevents the atom from updating its icon.
	#define COMSIG_ATOM_NO_UPDATE_ICON UPDATE_ICON
///from base of [/atom/proc/update_name]: (updates)
#define COMSIG_ATOM_UPDATE_NAME "atom_update_name"
///from base of [/atom/proc/update_desc]: (updates)
#define COMSIG_ATOM_UPDATE_DESC "atom_update_desc"
///from base of [/atom/update_icon]: ()
#define COMSIG_ATOM_UPDATE_ICON "atom_update_icon"
	/// If returned from [COMSIG_ATOM_UPDATE_ICON] it prevents the atom from updating its icon state.
	#define COMSIG_ATOM_NO_UPDATE_ICON_STATE UPDATE_ICON_STATE
	/// If returned from [COMSIG_ATOM_UPDATE_ICON] it prevents the atom from updating its overlays.
	#define COMSIG_ATOM_NO_UPDATE_OVERLAYS UPDATE_OVERLAYS
///from base of [atom/update_icon_state]: ()
#define COMSIG_ATOM_UPDATE_ICON_STATE "atom_update_icon_state"
///from base of [/atom/update_overlays]: (list/new_overlays)
#define COMSIG_ATOM_UPDATE_OVERLAYS "atom_update_overlays"
///from base of [/atom/update_icon]: (signalOut, did_anything)
#define COMSIG_ATOM_UPDATED_ICON "atom_updated_icon"
