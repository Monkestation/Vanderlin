/// Called after one or more verbs are added: (list of verbs added)
#define COMSIG_CLIENT_VERB_ADDED "client_verb_added"

/// Called after one or more verbs are added: (list of verbs added)
#define COMSIG_CLIENT_VERB_REMOVED "client_verb_removed"

/// from base of client/MouseDown(): (/client, object, location, control, params)
#define COMSIG_CLIENT_MOUSEDOWN "client_mousedown"
/// from base of client/MouseUp(): (/client, object, location, control, params)
#define COMSIG_CLIENT_MOUSEUP "client_mouseup"
	#define COMPONENT_CLIENT_MOUSEUP_INTERCEPT (1<<0)
/// from base of client/MouseUp(): (/client, object, location, control, params)
#define COMSIG_CLIENT_MOUSEDRAG "client_mousedrag"
