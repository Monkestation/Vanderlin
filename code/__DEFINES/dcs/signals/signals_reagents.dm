
///from base of [/datum/reagent/proc/expose_atom]: (/mob/living, reac_volume, methods, show_message, touch_protection, /mob/eye/blob) // ovemind arg is only used by blob reagents.
#define COMSIG_REAGENT_EXPOSE_MOB "reagent_expose_mob"
	/// Prevents the atom from being exposed to reagents if returned on [COMSIG_ATOM_EXPOSE_REAGENTS]
	#define COMPONENT_NO_EXPOSE_REAGENTS (1<<0)
///from base of [/datum/reagents/proc/add_reagent]: (/datum/reagent, amount, reagtemp, data, no_react)
#define COMSIG_REAGENTS_NEW_REAGENT "reagents_new_reagent"
///from base of [/datum/reagents/proc/add_reagent]: (/datum/reagent, amount, reagtemp, data, no_react)
#define COMSIG_REAGENTS_ADD_REAGENT "reagents_add_reagent"
///from base of [/datum/reagents/proc/del_reagent]: (/datum/reagent)
#define COMSIG_REAGENTS_DEL_REAGENT "reagents_del_reagent"
///from base of [/datum/reagents/proc/remove_reagent]: (/datum/reagent, amount)
#define COMSIG_REAGENTS_REM_REAGENT "reagents_rem_reagent"
///from base of [/datum/reagents/proc/clear_reagents]: ()
#define COMSIG_REAGENTS_CLEAR_REAGENTS "reagents_clear_reagents"
///from base of [/datum/reagents/proc/handle_reactions]: (num_reactions)
#define COMSIG_REAGENTS_REACTED			"reagents_reacted"

///from base of [/datum/reagents/proc/update_total()]
#define COMSIG_REAGENTS_HOLDER_UPDATED "reagents_update_total"
///from base of [/datum/reagents/proc/set_temperature]: (new_temp, old_temp)
#define COMSIG_REAGENTS_TEMP_CHANGE "reagents_temp_change"
