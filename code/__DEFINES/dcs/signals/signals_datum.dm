// Datum signals. Format:
// When the signal is called: (signal arguments)
// All signals send the source datum of the signal as the first argument

// /datum signals
/// from datum ui_act (usr, action)
#define COMSIG_UI_ACT "COMSIG_UI_ACT"
/// generic topic handler (usr, href_list)
#define COMSIG_TOPIC "handle_topic"
/// Add to inspect topic descriptions
#define COMSIG_TOPIC_INSPECT "handle_topic_inspect"

#define COMSIG_ADD_TRAIT "atom_add_trait"
#define COMSIG_REMOVE_TRAIT "atom_remove_trait"

/// before a datum's Destroy() is called: (force), returning a nonzero value will cancel the qdel operation
#define COMSIG_PREQDELETED "parent_preqdeleted"
/// just before a datum's Destroy() is called: (force), at this point none of the other components chose to interrupt qdel and Destroy will be called
#define COMSIG_QDELETING "parent_qdeleting"

// /datum/species signals
/// from datum/species/on_species_gain(): (datum/species/new_species, datum/species/old_species)
#define COMSIG_SPECIES_GAIN "species_gain"
/// from datum/species/on_species_loss(): (datum/species/lost_species)
#define COMSIG_SPECIES_LOSS "species_loss"

/// fires on the target datum when an element is attached to it (/datum/element)
#define COMSIG_ELEMENT_ATTACH "element_attach"
/// fires on the target datum when an element is detached from it (/datum/element)
#define COMSIG_ELEMENT_DETACH "element_detach"
