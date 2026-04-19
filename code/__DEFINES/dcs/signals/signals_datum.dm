// Datum signals. Format:
// When the signal is called: (signal arguments)
// All signals send the source datum of the signal as the first argument

// /datum signals
/// from datum ui_act (usr, action)
#define COMSIG_UI_ACT "COMSIG_UI_ACT"

/// fires on the target datum when an element is attached to it (/datum/element)
#define COMSIG_ELEMENT_ATTACH "element_attach"
/// fires on the target datum when an element is detached from it (/datum/element)
#define COMSIG_ELEMENT_DETACH "element_detach"
