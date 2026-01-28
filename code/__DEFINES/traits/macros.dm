// This file contains all of the "dynamic" traits and trait sources that can be used
// in a number of versatile and everchanging ways.
// If it uses psuedo-variables like the examples below, it's a macro-trait.

/// A trait given by a specific status effect (in case someone makes a status effect id match an existing source somehow)
#define TRAIT_STATUS_EFFECT(effect_id) "status_effect_[effect_id]"
/// Trait applied by element
#define ELEMENT_TRAIT(source) "element_trait_[source]"
